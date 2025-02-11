This article describes an infrastructure and workflow process to help teams provide digital evidence that demonstrates a valid chain of custody (CoC) in response to legal requests. This discussion guides a valid CoC throughout the evidence acquisition, preservation, and access processes.

> [!NOTE]
> This article is based on the theoretical and practical knowledge of the authors. Before you use it for legal purposes, validate its applicability with your legal department.

## Architecture

The architecture design follows the [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone) principles that are described in the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/).

This scenario uses a hub-and-spoke network topology as shown in the following diagram:

:::image type="content" alt-text="Diagram showing the chain of custody architecture." source="media/chain-of-custody.svg" lightbox="media/chain-of-custody.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/chain-of-custody.vsdx) of this architecture.*

### Workflow

In the architecture, the production virtual machines (VMs) are part of a spoke [Azure virtual network](/azure/virtual-network/virtual-networks-overview). Their disks are encrypted with **Azure Disk Encryption**. For more information, see [Overview of managed disk encryption options](/azure/virtual-machines/disk-encryption-overview). In the production subscription, [Azure Key Vault](/azure/key-vault/general/overview) stores the VMs' BitLocker encryption keys (BEKs).

> [!NOTE]
> The scenario also works for production VMs with unencrypted disks.

The Security Operation Center (SOC) team uses a discrete Azure **SOC** subscription. The team has exclusive access to that subscription, which contains the resources that must be kept protected, inviolable, and monitored. The [Azure Storage](/azure/storage/common/storage-introduction) account in the SOC subscription hosts copies of disk snapshots in [immutable blob storage](/azure/storage/blobs/storage-blob-immutable-storage), and a dedicated [key vault](/azure/key-vault/general/overview) keeps the snapshots' hash values and copies of the VMs' BEKs.

In response to a request for capturing a VM's digital evidence, a member of the SOC team logs into the Azure SOC subscription and uses an [Azure hybrid runbook worker](/azure/automation/extension-based-hybrid-runbook-worker-install) VM of [Automation](/azure/automation/automation-intro) to execute the Copy-VmDigitalEvidence runbook. The [Automation hybrid runbook worker](/azure/automation/automation-hybrid-runbook-worker) provides control of all mechanisms involved in the capture.

The Copy-VmDigitalEvidence runbook implements these macro steps:

1. Use the [System-assigned managed identity for an Automation account](/azure/automation/enable-managed-identity-for-automation) to sign in to Azure and access the target VM's resources, along with the other Azure services needed for the solution.
1. Generate disk snapshots of the VM's operating system (OS) and data disks.
1. Transfer the snapshots to the SOC subscription's immutable blob storage and in a temporary file share.
1. Compute the hash values of the snapshots using the copy stored on the file share.
1. Store the obtained hash values and the VM's BEK in the SOC key vault.
1. Remove all the copies of the snapshots except the one in immutable blob storage.

> [!NOTE]
> The production VMs' encrypted disks can also use key encryption keys (KEKs). The Copy-VmDigitalEvidence runbook provided in the [deploy scenario](#deploy-this-scenario) doesn't cover this scenario.

### Components

- [Azure Automation](/azure/automation/overview) automates frequent, time-consuming, and error-prone cloud management tasks.
- [Storage](/azure/storage/common/storage-introduction) is a cloud storage solution that includes object, file, disk, queue, and table storage.
- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) provides optimized cloud object storage that manages massive amounts of unstructured data.
- [Azure Files](/azure/well-architected/service-guides/azure-files) shares. You can concurrently mount shares through cloud or on-premises deployments of Windows, Linux, and macOS. Additionally, you can cache Azure Files shares on Windows Servers using Azure File Sync for quick access near the data usage location.
- [Azure Monitor](/azure/azure-monitor/overview) supports your operations at scale by helping you to maximize the performance and availability of your resources, while proactively identifying potential issues.
- [Key Vault](/azure/key-vault/general/overview) helps you safeguard cryptographic keys and other secrets used by cloud apps and services.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity service that helps you control access to Azure and other cloud apps.

#### Automation

The SOC team uses an [Automation](/azure/automation/overview) account to create and maintain the Copy-VmDigitalEvidence runbook. The team also uses [Automation](/azure/automation/automation-intro) to create the hybrid runbook workers that execute the runbook.

#### Hybrid runbook worker

The [hybrid runbook worker](/azure/automation/extension-based-hybrid-runbook-worker-install) VM is integrated into the Automation account. The SOC team uses this VM exclusively to execute the Copy-VmDigitalEvidence runbook.

You must place the hybrid runbook worker VM in a subnet that can access the Storage account. Configure access to the Storage account by adding the hybrid runbook worker VM subnet to the Storage account's firewall allowlist rules.

You must grant access to this VM only to the SOC team members for maintenance activities.

To isolate the virtual network used by the VM, avoid connecting that virtual network to the hub.

The hybrid runbook worker uses the [Automation system-assigned managed identity](/azure/automation/enable-managed-identity-for-automation) to access the target VM's resources and the other Azure services required by the solution.

The minimal role-based access control (RBAC) permissions that must be assigned to system-assigned managed identity are classified in two categories:

- Access permissions to the SOC Azure architecture containing the solution core components
- Access permissions to the target architecture containing the target VM resources

Access to the SOC Azure architecture includes the following roles:

- **Storage Account Contributor** on the SOC immutable Storage account
- **Key Vault Secrets Officer** on the SOC key vault for the BEK management

Access to the target architecture includes the following roles:

- **Contributor** on the target VM's resource group, which provides snapshot rights on VM disks
- **Key Vault Secrets Officer** on the target VM's key vault used to store the BEK, only if RBAC is used to control the Key Vault access
- Access policy to **Get Secret** on the target VM's key vault used to store the BEK, only if the access policy is used to control the Key Vault access

> [!NOTE]
> To read the BEK, the target VM's key vault must be accessible from the hybrid runbook worker VM. If the key vault's firewall is enabled, make sure that the public IP address of the hybrid runbook worker VM is permitted through the firewall.

#### Azure Storage account

The [Azure Storage account](/azure/well-architected/service-guides/storage-accounts/reliability) in the SOC subscription hosts the disk snapshots in a container configured with a *legal hold* policy as Azure immutable blob storage. Immutable blob storage stores business-critical data objects in a *write once, read many (WORM)* state, which makes the data nonerasable and uneditable for a user-specified interval.

Be sure to enable the [secure transfer](/azure/storage/common/storage-require-secure-transfer) and [storage firewall](/azure/storage/common/storage-network-security?tabs=azure-portal#grant-access-from-a-virtual-network) properties. The firewall grants access only from the SOC virtual network.

The storage account also hosts an [Azure file share](/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal) as a temporary repository used to calculate the snapshot's hash value.

#### Azure Key Vault

The SOC subscription has its own instance of [Key Vault](/azure/key-vault/general/overview), which hosts a copy of the BEK that Azure Disk Encryption uses to protect the target VM. The primary copy is stored in the key vault utilized by the target VM, allowing the target VM to continue normal operations.

The SOC key vault also stores the hash values of disk snapshots computed by the hybrid runbook worker during the capture operations.

Ensure the [firewall](/azure/key-vault/general/network-security#key-vault-firewall-enabled-virtual-networks---dynamic-ips) is enabled on the key vault. It must grants access exclusively from the SOC virtual network.

#### Log Analytics

A [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs-collect-workspace) stores activity logs used to audit all relevant events on the SOC subscription. Log Analytics is a feature of [Monitor](/azure/azure-monitor/overview).

## Scenario details

Digital forensics is a science that addresses the recovery and investigation of digital data to support criminal investigations or civil proceedings. Computer forensics is a branch of digital forensics that captures and analyzes data from computers, VMs, and digital storage media.

Companies must guarantee that the digital evidence they provide in response to legal requests demonstrates a valid CoC throughout the evidence acquisition, preservation, and access process.

### Potential use cases

- A company's SOC team can implement this technical solution to support a valid CoC for digital evidence.
- Investigators can attach disk copies that are obtained with this technique on a computer dedicated to forensic analysis. They can attach the disk copies without powering on or accessing the original source VM.

### CoC regulatory compliance

If it's necessary to submit the proposed solution to a regulatory compliance validation process, consider the materials in the [considerations](#considerations) section during the CoC solution validation process.

> [!NOTE]
> You should involve your legal department in the process of validation.

## Considerations

The principles that validate this solution as a CoC are being presented in this section.

To ensure a valid CoC, digital evidence storage must demonstrate adequate access control, data protection and integrity, monitoring and alerting, and logging and auditing.

### Compliance with security standards and regulations

When you validate a CoC solution, one of the requirements to evaluate is the compliance with security standards and regulations.

All the components included in the [architecture](#architecture) are Azure standard services built upon a foundation that supports trust, security, and [compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance).

Azure has a wide range of compliance certifications, including certifications specific for countries or regions, and for the key industries like healthcare, government, finance, and education.

For updated audit reports with information about standards compliance for the services that are adopted in this solution, see [Service Trust Portal](https://servicetrust.microsoft.com/ViewPage/HomePageVNext).

Cohasset's [Azure Storage: SEC 17a-4(f) and CFTC 1.31(c)-(d) Compliance Assessment](https://servicetrust.microsoft.com/DocumentPage/19b08fd4-d276-43e8-9461-715981d0ea20) gives details on the following requirements:

- Securities and Exchange Commission (SEC) in 17 CFR § 240.17a-4(f), which regulates exchange members, brokers, or dealers.
- Financial Industry Regulatory Authority (FINRA) Rule 4511(c), which defers to the format and media requirements of SEC Rule 17a-4(f).
- Commodity Futures Trading Commission (CFTC) in regulation 17 CFR § 1.31(c)-(d), which regulates commodity futures trading.

It's Cohasset's opinion that storage, with the immutable storage feature of Blob Storage and policy lock option, retains *time-based* blobs (records) in a nonerasable and nonrewriteable format and meets relevant storage requirements of SEC Rule 17a-4(f), FINRA Rule 4511(c), and the principles-based requirements of CFTC Rule 1.31(c)-(d).

### Least privilege

When the roles of the SOC team are assigned, only two individuals within the team, referred to as SOC team custodians, should have rights to modify the RBAC configuration of the subscription and its data. Grant other individuals only bare minimum access rights to data subsets that they need to perform their work. Configure and enforce access through [Azure RBAC](/azure/role-based-access-control/overview).

### Least access

Only the [virtual network](/azure/virtual-network/virtual-networks-overview) in the SOC subscription has access to the SOC Storage account and key vault that archives the evidence.

Temporary access to the SOC storage is provided to investigators that require access to evidence. Authorized SOC team members can grant this access.

### Evidence acquisition

Azure audit logs can document the evidence acquisition by recording the action of taking a VM disk snapshot, including details such as who took the snapshots and when.

### Evidence integrity

The use of [Automation](/azure/automation/overview) to move evidence to its final archive destination, without human intervention, guarantees that evidence artifacts weren't altered.

By applying a legal hold policy to the destination storage, the evidence is immediately frozen as soon as it is written. A legal hold demonstrates that the CoC was fully maintained within Azure. It also indicates that there was no opportunity to tamper with the evidence from the time the disk images were on a live VM to when they were stored as evidence in the storage account.

Lastly, you can use the provided solution as an integrity mechanism to compute the hash values of the disk images. The supported hash algorithms are: MD5, SHA256, SKEIN, KECCAK (or SHA3).

### Evidence production

Investigators need access to evidence so they can perform analyses, and this access must be tracked and explicitly authorized.

Provide investigators with a [shared access signatures (SAS) URI](/azure/storage/common/storage-sas-overview) storage key for accessing evidence. A SAS URI can generate relevant log information when it is created, and you can obtain a copy of the evidence each time the SAS is used.

For example, if a legal team needs to transfer a preserved virtual hard drive (VHD), one of the two SOC team custodians generates a read-only SAS URI key that expires after eight hours. The SAS restricts access to the investigators within a specified time frame.

Plus the SOC team must explicitly place the IP addresses of investigators requiring access on an allowlist in the Storage firewall.

Finally, investigators need the BEKs archived in the SOC key vault to access the encrypted disk copies. An SOC team member must extract the BEKs and provide them via secure channels to the investigators.

### Regional store

For compliance, some standards or regulations require evidence and the support infrastructure to be maintained in the same Azure region.

All the solution components, including the Storage account that archives evidence, are hosted in the same Azure region as the systems being investigated.

### Operational excellence

Operational excellence encompasses the processes that deploy an application and ensure its continuous operation in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Monitoring and alerting

Azure offers services to all customers for monitoring and alerting on anomalies related to their subscriptions and resources. These services include:

- [Microsoft Sentinel](https://aka.ms/azure-sentinel).
- [Microsoft Defender for Cloud](https://aka.ms/asc).
- [Microsoft Defender for Storage](/azure/defender-for-cloud/defender-for-storage-introduction?tabs=azure-portal).

> [!NOTE]
> The configuration of these services isn't described in this article.

## Deploy this scenario

Follow the [CoC lab deployment](/samples/azure/forensics/forensics/) instructions to build and deploy this scenario in a laboratory environment.

The laboratory environment represents a simplified version of the architecture described in the article. You deploy two resource groups within the same subscription. The first resource group simulates the production environment, housing digital evidence, while the second resource group holds the SOC environment.

Use the following button to deploy only the SOC resource group in a production environment.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fforensics%2Fmain%2F.armtemplate%2Fcoc-soc.json)

> [!NOTE]
> If you deploy the solution in a production environment, make sure that the system-assigned managed identity of the automation account has the following permissions:
>
>- A Contributor in the production resource group of the VM to be processed. This role creates the snapshots.
>- A Key Vault Secrets User in the production key vault that holds the BEKs. This role reads the BEKs.
>
>Also, if the key vault has the firewall enabled, be sure the public IP address of the hybrid runbook worker VM is allowed through the firewall.

### Extended configuration

You can deploy a hybrid runbook worker on-premises or in different cloud environments.

In this scenario, you must customize the Copy‑VmDigitalEvidence runbook to enable the capture of evidence in different target environments and archive them in storage.

> [!NOTE]
> The Copy-VmDigitalEvidence runbook provided in the [Deploy this scenario section](#deploy-this-scenario) was developed and tested only in Azure. To extend the solution to other platforms, you must customize the runbook to work with those platforms.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Principal Consultant
- [Simone Savi](https://www.linkedin.com/in/sisavi/) | Senior Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about Azure data-protection features, see:

- [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption)
- [Overview of managed disk encryption options](/azure/security/fundamentals/azure-disk-encryption-vms-vmss)
- [Store business-critical blob data with immutable storage](/azure/storage/blobs/storage-blob-immutable-storage)

For more information about Azure logging and auditing features, see:

- [Azure security logging and auditing](/azure/security/fundamentals/log-audit)
- [Azure Storage analytics logging](/azure/storage/common/storage-analytics-logging)
- [Azure resource logs](/azure/azure-monitor/essentials/resource-logs)

For more information about Microsoft Azure compliance, see:

- [Azure compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance)
- [Microsoft compliance offerings](https://learn.microsoft.com/en-us/compliance/regulatory/offering-home)

## Related resource

- [Security architecture design](../../guide/security/security-start-here.yml)
