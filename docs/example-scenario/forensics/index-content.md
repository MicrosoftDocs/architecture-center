This article describes how teams can ensure a valid *Chain of Custody* (CoC) throughout the evidence acquisition, preservation, and access processes.

> [!NOTE]
> This article is based on the theoretical and practical knowledge of the authors. Before you use it for legal purposes, you should validate its applicability with your legal department.

## Architecture

The architecture design follows the principles of [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone) described in the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework).

This scenario uses a hub-and-spoke network topology as shown in the following diagram:

:::image type="content" alt-text="Diagram showing the chain of custody architecture." source="media/chain-of-custody.svg" lightbox="media/chain-of-custody.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/chain-of-custody.vsdx) of this architecture.*

### Workflow

In the architecture, the production virtual machines are part of a spoke [Azure virtual network](/azure/virtual-network/virtual-networks-overview). Their disks are encrypted with Azure Disk Encryption (ADE). For more information, see [Overview of managed disk encryption options](/azure/security/fundamentals/azure-disk-encryption-vms-vmss). The [Azure Key Vault](/azure/key-vault/general/overview) in the production subscription stores the virtual machines' BitLocker encryption keys (BEKs).

> [!NOTE]
> The scenario works for production virtual machines with unencrypted disks.

### Components

- [Azure Automation](/azure/automation/automation-intro)
- [Hybrid Runbook Worker](/azure/automation/extension-based-hybrid-runbook-worker-install)
- [Azure Automation system-assigned managed identity](/azure/automation/enable-managed-identity-for-automation)
- [Azure Storage account](/azure/storage/common/storage-account-overview)
- [Secure transfer](/azure/storage/common/storage-require-secure-transfer)
- [Azure Storage firewall](/azure/storage/common/storage-network-security)
- [Azure file share](/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal)
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker)
- [Azure Automation](https://azure.microsoft.com/services/automation)
- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory)(Microsoft Entra ID)
- [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs-collect-workspace)

#### Azure Automation

The SOC team uses an [Azure Automation](/azure/automation/automation-intro) account to create and maintain the Copy-VmDigitalEvidence runbook. The team also uses the Azure Automation to create the Hybrid Runbook Workers that run the runbook.

#### Hybrid Runbook Worker

The [Hybrid Runbook Worker](/azure/automation/extension-based-hybrid-runbook-worker-install) virtual machine is part of the Automation account and is used exclusively by the SOC team to implement the Copy-VmDigitalEvidence runbook.

The Hybrid Runbook Worker virtual machine must be placed in a subnet that can access the Storage Account.
Access to the Storage Account is configured by adding the Hybrid Runbook Worker virtual machine subnet to the Storage Account's firewall allowlist rules.

Access to this virtual machine must be granted only to the SOC team members for maintenance activities.

The virtual network used by the virtual machine must not be connected to the hub to keep it isolated.

The Hybrid Runbook Worker uses the [Azure Automation system-assigned managed identity](/azure/automation/enable-managed-identity-for-automation) to access the target virtual machine's resources and the other Azure services required by the solution.

The minimal role-based access control (RBAC) permissions that must be assigned to system-assigned managed identity are classified in two categories:

- Access permissions to the SOC Azure architecture containing the solution core components.
- Access permissions to the target architecture, containing the target Virtual Machine resources.

Access to the SOC Azure architecture includes:

- **Storage Account Contributor** on the SOC immutable Storage account
- **Key Vault Secrets Officer**, on the SOC key vault for the BEK management

Access to the target architecture:

- **Contributor** on the target virtual machine's resource group, which provides snapshot rights on virtual machine disks.
- **Key Vault Secrets Officer** on the target virtual machine's key vault used to store BEK, only if RBAC is used for the Key Vault.
- Access policy to **Get Secret** on the target virtual machine's key vault used to store BEK, only if access policy is used for the Key Vault.

> [!NOTE]
> To read the BEK, the target virtual machine's key vault must be accessible from the Hybrid Runbook Worker virtual machine. If the key vault has the firewall enabled, ensure that the public IP address of the Hybrid RunBook Worker Virtual Machine is allowed through the firewall.

#### Azure Storage account

The [Azure Storage account](/azure/storage/common/storage-account-overview) in the SOC subscription hosts the disk snapshots in a container configured with *Legal Hold* policy as Azure immutable blob storage. Immutable blob storage stores business-critical data objects in a *Write Once, Read Many* (WORM) state, which makes the data nonerasable and uneditable for a user-specified interval.

Ensure that [Secure transfer](/azure/storage/common/storage-require-secure-transfer) and [Storage firewall](/azure/storage/common/storage-network-security?tabs=azure-portal#grant-access-from-a-virtual-network) are both enabled. Firewall grants access only from the SOC Virtual Network.

The storage account also hosts an [Azure file share](/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal) used as a temporary repository for calculating the snapshot's hash value.

#### Azure Key Vault

The SOC subscription has its own [Key Vault](https://azure.microsoft.com/services/key-vault), which hosts a copy of the BEK that Azure Disk Encryption (ADE) uses to protect the target virtual machine. The primary copy is kept in the key vault used by the target virtual machine, so that virtual machine can continue normal operation.

The SOC key vault also contains the hash values of disk snapshots calculated by the Hybrid Worker during the capture operations.

Ensure the [firewall](/azure/key-vault/general/network-security#key-vault-firewall-enabled-virtual-networks---dynamic-ips) is enabled on the key vault. It's configured to grant access only from the SOC Virtual Network.

#### Log analytics

An Azure [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs-collect-workspace) stores activity logs used to audit all relevant events on the SOC subscription.

### Alternatives

If necessary, you can grant time-limited read-only SOC Storage account access to IP addresses from outside, on-premises networks, for investigators to download the digital evidence.

The system and organization controls (SOC) team uses a discrete Azure **SOC** subscription. The team has exclusive access to that subscription, which contains the resources that must be kept protected, inviolable, and monitored. The [Azure Storage](/azure/storage/common/storage-introduction) account in the SOC subscription hosts copies of disk snapshots in [immutable blob storage](/azure/storage/blobs/storage-blob-immutable-storage), and a dedicated [Key Vault](/azure/key-vault/general/overview) keeps the snapshots' hash values and copies of the virtual machines' BEKs.

In response to a request to capture a virtual machine's digital evidence, a SOC team member signs in to the Azure SOC subscription and uses a [Hybrid Runbook Worker](/azure/automation/extension-based-hybrid-runbook-worker-install) virtual machine in [Automation](/azure/automation/automation-intro) to implement the **Copy-VmDigitalEvidence** runbook. The Hybrid Runbook Worker provides control of all mechanisms involved in the capture.

The Copy-VmDigitalEvidence runbook implements these macro steps:

1. Sign in to Azure by using the [System-assigned managed identity for an Automation account](/azure/automation/enable-managed-identity-for-automation) to access the target virtual machine's resources and the other Azure services required by the solution.
1. Create disk snapshots for the virtual machine's operating system (OS) and data disks.
1. Copy the snapshots to the SOC subscription's immutable blob storage, and in a temporary file share.
1. Calculate hash values of the snapshots by using the copy on the file share.
1. Copy the obtained hash values and the virtual machine's BEK in the SOC key vault.
1. Clean up all the copies of the snapshots except the one in immutable blob storage.

> [!NOTE]
> The production virtual machines encrypted disks can use *key encryption keys* (KEK) as well. The Copy-VmDigitalEvidence runbook provided in the [deploy scenario](#deploy-this-scenario) doesn't cover this scenario.

## Scenario details

Digital forensics is a science that addresses the recovery and investigation of digital data to support criminal investigations or civil proceedings. Computer forensics is a branch of digital forensics that captures and analyzes data from computers, virtual machines (VMs), and digital storage media.

Companies must guarantee that the digital evidence they provide in response to legal requests demonstrates a valid CoC throughout the evidence acquisition, preservation, and access process. To ensure a valid CoC, digital evidence storage must demonstrate adequate access control, data protection and integrity, monitoring and alerting, and logging and auditing.

### Potential use cases

- A company's *Security Operation Center* (SOC) team can implement this technical solution to support a valid CoC for digital evidence.
- Investigators can attach disk copies that are obtained with this technique on a computer dedicated to forensic analysis. They can attach the disk copies without powering on or accessing the original source virtual machine.

### Chain of custody regulatory compliance

If it's necessary to submit the proposed solution to a regulatory compliance validation process, consider the following topics to proof the validity of CoC solution.

> [!NOTE]
> You should involve your legal department in the process of validation.

#### Compliance with security standards and regulations

When you validate a CoC solution, one of the requirements to evaluate is the compliance with security standards and regulations.

All the components included in the above architecture are Azure standard services built upon a foundation of trust, security and [compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance).

Azure has a wide range of compliance certifications, including certifications specific for countries or regions, and for the key industries like healthcare, government, finance and education.

Updated audit reports with information about standards compliance for the services adopted in this solution can be found on [Service Trust Portal](https://servicetrust.microsoft.com/ViewPage/HomePageVNext).

Cohasset's [Azure Storage: SEC 17a-4(f) and CFTC 1.31(c)-(d) Compliance Assessment](https://servicetrust.microsoft.com/DocumentPage/19b08fd4-d276-43e8-9461-715981d0ea20) gives details on the following requirements:

- **Securities and Exchange Commission (SEC) in 17 CFR § 240.17a-4(f)**, which regulates exchange members, brokers or dealers.
- **Financial Industry Regulatory Authority (FINRA) Rule 4511(c)**, which defers to the format and media requirements of SEC Rule 17a-4(f).
- **Commodity Futures Trading Commission (CFTC) in regulation 17 CFR § 1.31(c)-(d)**, which regulates commodity futures trading.

It's Cohasset's opinion that Microsoft Azure Storage, with the *Immutable Storage for Azure Blobs* feature and *Policy Lock* option, retains *time-based* Blobs (records) in a non-erasable and non-rewriteable format and meets relevant storage requirements of SEC Rule 17a-4(f), FINRA Rule 4511(c), and the principles-based requirements of CFTC Rule 1.31(c)-(d).

#### Least privilege

When roles of SOC team are assigned, only two individuals within the team should have rights to modify the RBAC configuration of the subscription and its data. Grant other individuals only bare minimum access rights to data subsets they need to perform their work. Configure and enforce access through [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

#### Least access

Only the [virtual network](/azure/virtual-network/virtual-networks-overview) in the SOC subscription has access to the SOC Storage account and key vault used to archive the evidence.

Temporary access to the SOC storage is provided to investigators that require access to evidence. Authorized SOC team members can grant access.

#### Evidence acquisition

Azure Audit Logs can show the evidence acquisition by recording the action of taking a virtual machine disk snapshot, with elements like who has taken the snapshots and when.

#### Evidence integrity

The use of Azure Automation to move evidence to its final archive destination (without human intervention) guarantees that evidence artifacts haven't been altered.

By applying a *Legal Hold* to the destination storage, the evidence is frozen in time as soon as it's written. Legal Hold shows that the CoC has been maintained entirely in Azure. Legal Hold also shows that there wasn't an opportunity to tamper between the time the disk images existed on a live virtual machine and when they were added as evidence in the storage account.

Lastly, as an integrity mechanism, the provided solution can be used to calculate the hash values of the disk images. The supported hash algorithms are: *MD5*, *SHA256*, *SKEIN*, *KECCAK* (or *SHA3*).

#### Evidence production

Investigators need access to evidence to perform analyses, and this access must be tracked and explicitly authorized.

Provide investigators with a storage [shared access signatures (SAS) URI](/azure/storage/common/storage-sas-overview) key for accessing evidence. You can use an SAS URI to produce relevant log information when the SAS is generated. You can also get a copy of the evidence every time the SAS is used.

The IP addresses of investigators requiring access must be explicitly allowlisted in the Storage firewall.

For example, if a legal team needs to transfer a preserved virtual hard drive (VHD), one of the two SOC team custodians generates a read-only SAS URI key that expires after eight hours. The SAS limits the access to the IP addresses of the investigators for a limited timeframe.

Finally, investigators need the BEKs archived in the SOC key vault to access the encrypted disk copies. An SOC team member must extract the BEKs and provide them via secure channels to the investigators.

#### Regional store

For compliance, some standards or regulations require evidence and the support infrastructure to be maintained in the same Azure region.

All the solution components, including the Storage account used to archive evidence, are hosted in the same Azure region as the systems being investigated.

#### Monitoring and alerting

Azure provides services to all customers to monitor and alert on anomalies involving their subscriptions and resources. These services include:

- [Microsoft Sentinel](https://aka.ms/azure-sentinel)
- [Microsoft Defender for Cloud](https://aka.ms/asc)
- [Azure Storage Advanced Threat Protection (ATP)](/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal)

> [!NOTE]
> The configuration of these services isn't described in this article.

## Deploy this scenario

Follow the [CoC LAB Deployment](https://github.com/Azure/forensics/blob/main/README.md) instructions to build and deploy this scenario in a laboratory environment.

The laboratory environment represents a simplified version of the architecture described in the article deploying two resource groups within the same subscription. The first resource group simulates the Production Environment, housing Digital Evidence, while the second resource group holds the SOC Environment.

To deploy only the SOC resource group in a production environment, select: [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fforensics%2Fmain%2F.armtemplate%2Fcoc-soc.json)

> [!NOTE]
> If you deploy the solution in a production environment, please make sure that System Managed Identity of the automation account has following permissions:
>
>- Contributor: on the Production resource group of the virtual machine to be processed (needed to create the snapshots)
>- Key Vault Secrets User: on the Production Key Vault holding the BEK keys (needed to read the BEK keys)
>
>Additionally, if the Key Vault has the firewall enabled, ensure that the public IP address of the Hybrid RunBook Worker VM is allowed through the firewall.

### Extended configuration

A Hybrid Runbook Worker can be deployed on-premises or in different cloud environments.

In this scenario, the Copy‑VmDigitalEvidence runbook can be customized to enable the capture of evidence in different target environments and archive them in storage.

> [!NOTE]
> The Copy-VmDigitalEvidence runbook provided in the [deploy scenario](#deploy-this-scenario) has been developed and tested only in Azure. To extend the solution to other platforms, the runbook must be customized to work with those platforms.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Principal Consultant
- [Simone Savi](https://www.linkedin.com/in/simone-savi-3b50aa7) | Senior Consultant

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

For more information about Microsoft Azure Compliance, see:

- [Azure Compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance)
- [Microsoft Azure Compliance Offerings](https://azure.microsoft.com/en-us/resources/microsoft-azure-compliance-offerings/en-us)

## Related resources

- [Security architecture design](../../guide/security/security-start-here.yml)
- [Microsoft Entra IDaaS in security operations](../aadsec/azure-ad-security.yml)
- [Security considerations for highly sensitive IaaS apps in Azure](../../reference-architectures/n-tier/high-security-iaas.yml)
- [Microsoft Entra ID IDaaS in security operations](../aadsec/azure-ad-security.yml)
- [Security considerations for highly sensitive IaaS apps in Azure](../../reference-architectures/n-tier/high-security-iaas.yml)
