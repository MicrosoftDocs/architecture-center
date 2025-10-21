This article outlines an infrastructure and workflow process designed to help teams provide digital evidence that demonstrates a valid chain of custody in response to legal requests. This article describes how to maintain a valid chain of custody throughout the stages of evidence acquisition, preservation, and access.

> [!NOTE]
> This article is based on the theoretical and practical knowledge of the authors. Before you use it for legal purposes, validate its applicability with your legal department.

## Architecture

The architecture design follows the [Azure landing zone principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) in the Cloud Adoption Framework for Azure.

This scenario uses a hub-and-spoke network topology, which is shown in the following diagram:

:::image type="complex" border="false" source="media/chain-of-custody.svg" alt-text="Diagram that shows the chain of custody architecture." lightbox="media/chain-of-custody.svg":::
  This diagram shows the chain of custody architecture where production virtual machines reside in a spoke Azure virtual network. These machines have their disks encrypted by using Azure Disk Encryption, with BitLocker encryption keys stored in a production Azure Key Vault. A separate, secure Azure SOC subscription that's accessible only by the security operations center (SOC) team contains an Azure Storage account that holds disk snapshots in immutable blob storage. It also includes a dedicated Azure Key Vault that stores the hash values of the snapshots and copies of the VMs' encryption keys. When a request is made to capture digital evidence, a SOC team member logs in to the SOC subscription and uses an Azure Automation hybrid runbook worker VM to run the Copy-VmDigitalEvidence runbook. The runbook uses a system-assigned managed identity to access the target VM's resources and generates snapshots of its operating system and data disks. It transfers these snapshots to both the immutable blob storage and a temporary file share, computes their hash values, and stores the hash values and the VM's encryption key in the SOC key vault. Finally, it removes all temporary copies except for the immutable snapshot.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/chain-of-custody.vsdx) of this architecture.*

### Workflow

In the architecture, the production virtual machines (VMs) are part of a spoke [Azure virtual network](/azure/virtual-network/virtual-networks-overview). The VM disks are encrypted with Azure Disk Encryption. For more information, see [Overview of managed disk encryption options](/azure/virtual-machines/disk-encryption-overview). In the production subscription, [Azure Key Vault](/azure/key-vault/general/overview) stores the BitLocker encryption keys (BEKs) of the VMs.

> [!NOTE]
> The scenario also supports production VMs that have unencrypted disks.

The security operations center (SOC) team uses a discrete Azure **SOC** subscription. The team has exclusive access to that subscription, which contains the resources that must be kept protected, inviolable, and monitored. The [Azure Storage](/azure/storage/common/storage-introduction) account in the SOC subscription hosts copies of disk snapshots in [immutable blob storage](/azure/storage/blobs/storage-blob-immutable-storage). A dedicated [key vault](/azure/key-vault/general/overview) stores copies of the hash values of the snapshots and the BEKs from the VMs.

In response to a request to capture the digital evidence of a VM, a member of the SOC team signs in to the Azure SOC subscription and uses an [Azure hybrid runbook worker](/azure/automation/extension-based-hybrid-runbook-worker-install) VM from [Azure Automation](/azure/automation/automation-intro) to run the `Copy-VmDigitalEvidence` runbook. The [Automation hybrid runbook worker](/azure/automation/automation-hybrid-runbook-worker) provides control of all mechanisms included in the capture.

The `Copy-VmDigitalEvidence` runbook implements the following macro steps:

1. Use the [system-assigned managed identity for an Automation account](/azure/automation/enable-managed-identity-for-automation) to sign in to Azure. This identity grants access to the target VM's resources and the other Azure services needed for the solution.

1. Generate disk snapshots of the VM's operating system (OS) and data disks.

1. Transfer the snapshots to both the SOC subscription's immutable blob storage and a temporary file share.

1. Compute the hash values of the snapshots by using the copy that's stored in the file share.

1. Store the obtained hash values and the VM's BEK in the SOC key vault.

1. Remove all the copies of the snapshots, except for the copy in immutable blob storage.

> [!NOTE]
> The encrypted disks of the production VMs can also use key encryption keys (KEKs). The `Copy-VmDigitalEvidence` runbook provided in the [deploy scenario](#deploy-this-scenario) doesn't cover this scenario.

### Components

- [Azure Automation](/azure/automation/overview) is a cloud-based service that automates operational tasks by using runbooks and scripts. In this architecture, it orchestrates the evidence capture process by running the `Copy-VmDigitalEvidence` runbook to snapshot and transfer VM disks securely. This process helps ensure evidence integrity.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable cloud storage solution for various data types, including object, file, disk, queue, and table storage. In this architecture, it stores VM disk snapshots in immutable blob containers to preserve digital evidence in a tamper-proof format.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud-based solution that provides object storage optimized for unstructured data. In this architecture, it holds the immutable snapshots of VM disks to ensure the integrity and non-repudiation of digital evidence.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed cloud file storage service that provides shared file systems that can be accessed via the industry-standard Server Message Block (SMB) protocol, the Network File System (NFS) protocol, and the Azure Files REST API. You can concurrently mount shares through cloud or on-premises deployments of Windows, Linux, and macOS. You can also cache file shares on Windows Server by using Azure File Sync for quick access near the data usage location. In this architecture, Azure Files temporarily stores disk snapshots to compute hash values before transferring them to immutable storage.

- [Key Vault](/azure/key-vault/general/overview) is a secure cloud service for managing secrets, encryption keys, and certificates. In this architecture, it stores BEKs and hash values of disk snapshots to protect access and verify the integrity of digital evidence.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity service that helps you control access to Azure and other cloud apps. In this architecture, it ensures that only authorized SOC personnel can access and manage sensitive evidence-handling operations.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring service that provides observability through metrics, logs, and alerts. It supports operations at scale by helping you maximize the performance and availability of your resources, while proactively identifying potential problems. In this architecture, it archives activity logs to support auditing, compliance, and monitoring of the evidence chain of custody. 

#### Automation

The SOC team uses an [Automation](/azure/automation/overview) account to create and maintain the `Copy-VmDigitalEvidence` runbook. The team also uses Automation to create the hybrid runbook workers that implement the runbook.

#### Hybrid runbook worker

The [hybrid runbook worker](/azure/automation/extension-based-hybrid-runbook-worker-install) VM is integrated into the Automation account. The SOC team uses this VM exclusively to run the `Copy-VmDigitalEvidence` runbook.

You must place the hybrid runbook worker VM in a subnet that can access the Storage account. Configure access to the Storage account by adding the hybrid runbook worker VM subnet to the Storage account's firewall allowlist rules.

Grant access to this VM only to the SOC team members for maintenance activities.

To isolate the virtual network that the VM uses, avoid connecting the virtual network to the hub.

The hybrid runbook worker uses the [Automation system-assigned managed identity](/azure/automation/enable-managed-identity-for-automation) to access the target VM's resources and the other Azure services that the solution requires.

The minimum Azure role-based access control (Azure RBAC) permissions required for a system-assigned managed identity are divided into two categories:

- Access permissions to the SOC Azure architecture that contains the solution core components
- Access permissions to the target architecture that contains the target VM resources

Access to the SOC Azure architecture includes the following roles:

- **Storage Account Contributor** on the SOC immutable Storage account
- **Key Vault Secrets Officer** on the SOC key vault for BEK management

Access to the target architecture includes the following roles:

- **Contributor** on the target VM's resource group, which provides snapshot rights on VM disks

- **Key Vault Secrets Officer** on the target VM's key vault that's used to store the BEK, only if Azure RBAC is used to control the Key Vault access

- Access policy to **Get Secret** on the target VM's key vault that's used to store the BEK, only if the access policy is used to control the Key Vault access

> [!NOTE]
> To read the BEK, the target VM's key vault must be accessible from the hybrid runbook worker VM. If the key vault's firewall is enabled, make sure that the public IP address of the hybrid runbook worker VM is permitted through the firewall.

#### Storage account

The [Storage account](/azure/well-architected/service-guides/azure-blob-storage) in the SOC subscription hosts the disk snapshots in a container that's configured with a *legal hold* policy as Azure immutable blob storage. Immutable blob storage stores business-critical data objects in a write once, read many (WORM) state. The WORM state makes the data nonerasable and uneditable for a user-specified interval.

Make sure that you enable the [secure transfer](/azure/storage/common/storage-require-secure-transfer) and [storage firewall](/azure/storage/common/storage-network-security#grant-access-from-a-virtual-network) properties. The firewall grants access only from the SOC virtual network.

The storage account also hosts an [Azure file share](/azure/storage/files/storage-how-to-create-file-share) as a temporary repository that's used to calculate the snapshot's hash value.

#### Key Vault

The SOC subscription has its own instance of [Key Vault](/azure/key-vault/general/overview), which hosts a copy of the BEK that Azure Disk Encryption uses to protect the target VM. The primary copy is stored in the key vault that the target VM uses. This setup allows the target VM to continue normal operations without interruption.

The SOC key vault also stores the hash values of disk snapshots that the hybrid runbook worker computes during the capture operations.

Ensure that the [firewall](/azure/key-vault/general/network-security#key-vault-firewall-enabled-virtual-networks---dynamic-ips) is enabled on the key vault. It must grant access exclusively from the SOC virtual network.

#### Log Analytics

A [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs-collect-workspace) stores activity logs used to audit all relevant events on the SOC subscription. Log Analytics is a feature of [Monitor](/azure/azure-monitor/overview).

## Scenario details

Digital forensics is a science that addresses the recovery and investigation of digital data to support criminal investigations or civil proceedings. Computer forensics is a branch of digital forensics that captures and analyzes data from computers, VMs, and digital storage media.

Companies must guarantee that the digital evidence they provide in response to legal requests demonstrates a valid chain of custody throughout the stages of evidence acquisition, preservation, and access.

### Potential use cases

- A company's SOC team can implement this technical solution to support a valid chain of custody for digital evidence.

- Investigators can attach disk copies that are obtained by using this technique on a computer that's dedicated to forensic analysis. They can attach the disk copies without powering on or accessing the original source VM.

### Chain of custody regulatory compliance

If it's necessary to submit the proposed solution to a regulatory compliance validation process, consider the materials in the [considerations](#considerations) section during the chain of custody solution validation process.

> [!NOTE]
> You should include your legal department in the validation process.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The principles that validate this solution as a chain of custody are described in this section. To help ensure a valid chain of custody, digital evidence storage must demonstrate adequate access control, data protection and integrity, monitoring and alerting, and logging and auditing.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Compliance with security standards and regulations

When you validate a chain of custody solution, one of the requirements to evaluate is the compliance with security standards and regulations.

All the components included in the [architecture](#architecture) are Azure standard services built on a foundation that supports trust, security, and [compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance).

Azure has a wide range of compliance certifications, including certifications tailored to countries or regions, and for key industries like healthcare, government, finance, and education.

For more information about updated audit reports that detail standards compliance for the services used in this solution, see [Service Trust Portal](https://servicetrust.microsoft.com/ViewPage/HomePageVNext).

[Cohasset's Azure Storage compliance assessment](https://servicetrust.microsoft.com/DocumentPage/19b08fd4-d276-43e8-9461-715981d0ea20) provides details about the following requirements:

- Securities and Exchange Commission (SEC) in 17 CFR § 240.17a-4(f), which regulates exchange members, brokers, or dealers.

- Financial Industry Regulatory Authority (FINRA) Rule 4511(c), which defers to the format and media requirements of SEC Rule 17a-4(f).

- Commodity Futures Trading Commission (CFTC) in regulation 17 CFR § 1.31(c)-(d), which regulates commodity futures trading.

It's Cohasset's opinion that Azure Storage, with the immutable storage feature of Blob Storage and policy lock option, retains time-based blobs (or *records*) in a nonerasable and nonrewriteable format and meets relevant storage requirements of SEC Rule 17a-4(f), FINRA Rule 4511(c), and the principles-based requirements of CFTC Rule 1.31(c)-(d).

#### Least privilege

When the roles of the SOC team are assigned, only two individuals in the team, known as SOC team custodians, should have rights to modify the [Azure RBAC](/azure/role-based-access-control/overview) configuration of the subscription and its data. Grant other individuals only bare minimum access rights to data subsets that they need to perform their work.

#### Least access

Only the [virtual network](/azure/virtual-network/virtual-networks-overview) in the SOC subscription has access to the SOC Storage account and key vault that archives the evidence. Authorized SOC team members can grant investigators temporary access to evidence in the SOC storage.

#### Evidence acquisition

Azure audit logs can document the evidence acquisition by recording the action of taking a VM disk snapshot. The logs include details such as who takes the snapshots and when they're taken.

#### Evidence integrity

Use [Automation](/azure/automation/overview) to move evidence to its final archive destination, without human intervention. This approach helps guarantee that evidence artifacts remain unaltered.

When you apply a legal hold policy to the destination storage, the evidence is immediately frozen as soon as it's written. A legal hold demonstrates that the chain of custody is fully maintained within Azure. It also indicates that there's no opportunity to tamper with the evidence from the time the disk images are on a live VM to when they are stored as evidence in the storage account.

Lastly, you can use the provided solution as an integrity mechanism to compute the hash values of the disk images. The supported hash algorithms are MD5, SHA256, SKEIN, and KECCAK (or SHA3).

#### Evidence production

Investigators need access to evidence so that they can perform analyses. This access must be tracked and explicitly authorized.

Provide investigators with a [shared access signatures (SAS) uniform resource identifier (URI)](/azure/storage/common/storage-sas-overview) storage key for accessing evidence. A SAS URI can generate relevant log information when it's created. You can obtain a copy of the evidence each time the SAS is used.

For example, if a legal team needs to transfer a preserved virtual hard drive, one of the two SOC team custodians generates a read-only SAS URI key that expires after eight hours. The SAS restricts access to the investigators within a specified time frame.

The SOC team must explicitly place the IP addresses of investigators that require access on an allowlist in the Storage firewall.

Finally, investigators need the BEKs archived in the SOC key vault to access the encrypted disk copies. An SOC team member must extract the BEKs and provide them via secure channels to the investigators.

#### Regional store

For compliance, some standards or regulations require evidence and the supporting infrastructure to be maintained in the same Azure region.

All the solution components, including the Storage account that archives evidence, are hosted in the same Azure region as the systems being investigated.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring and alerting

Azure provides services to all customers for monitoring and alerting about anomalies related to their subscriptions and resources. These services include:

- [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel).
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud).
- [Microsoft Defender for Storage](/azure/defender-for-cloud/defender-for-storage-introduction).

> [!NOTE]
> The configuration of these services isn't described in this article.

## Deploy this scenario

Follow the [chain of custody lab deployment](/samples/azure/forensics/forensics/) instructions to build and deploy this scenario in a laboratory environment.

The laboratory environment represents a simplified version of the architecture described in this article. You deploy two resource groups within the same subscription. The first resource group simulates the production environment, housing digital evidence, while the second resource group holds the SOC environment.

Select **Deploy to Azure** to deploy only the SOC resource group in a production environment.

[![Deploy to Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fforensics%2Fmain%2F.armtemplate%2Fcoc-soc.json)

> [!NOTE]
> If you deploy the solution in a production environment, make sure that the system-assigned managed identity of the Automation account has the following permissions:
>
>- A Contributor in the production resource group of the VM to be processed. This role creates the snapshots.
>- A Key Vault Secrets User in the production key vault that holds the BEKs. This role reads the BEKs.
>
> If the key vault has the firewall enabled, be sure that the public IP address of the hybrid runbook worker VM is allowed through the firewall.

### Extended configuration

You can deploy a hybrid runbook worker on-premises or in different cloud environments.

In this scenario, you must customize the `Copy‑VmDigitalEvidence` runbook to enable the capture of evidence in different target environments and archive them in storage.

> [!NOTE]
> The `Copy-VmDigitalEvidence` runbook provided in the [Deploy this scenario section](#deploy-this-scenario) was developed and tested only in Azure. To extend the solution to other platforms, you must customize the runbook to work with those platforms.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Principal Consultant
- [Simone Savi](https://www.linkedin.com/in/sisavi/) | Senior Consultant

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about Azure data-protection features, see:

- [Storage encryption for data at rest](/azure/storage/common/storage-service-encryption)
- [Overview of managed disk encryption options](/azure/virtual-machines/disk-encryption-overview)
- [Store business-critical blob data with immutable storage in a WORM state](/azure/storage/blobs/immutable-storage-overview)

For more information about Azure logging and auditing features, see:

- [Azure security logging and auditing](/azure/security/fundamentals/log-audit)
- [Storage analytics logging](/azure/storage/common/storage-analytics-logging)
- [Send Azure resource logs to Log Analytics workspaces, Event Hubs, or Storage](/azure/azure-monitor/essentials/resource-logs)

For more information about Microsoft Azure compliance, see:

- [Azure compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance)
- [Microsoft compliance offerings](/compliance/regulatory/offering-home)

## Related resource

- [Security architecture design](../../guide/security/security-start-here.yml)
