Digital forensics is a science that addresses the recovery and investigation of digital data to support criminal investigations or civil proceedings. Computer forensics is a branch of digital forensics that captures and analyzes data from computers, virtual machines (VMs), and digital storage media.

Companies must guarantee that digital evidence they provide in response to legal requests demonstrates a valid *Chain of Custody* (CoC) throughout the evidence acquisition, preservation, and access process. To ensure a valid CoC, digital evidence storage must demonstrate adequate access control, data protection and integrity, monitoring and alerting, and logging and auditing.

## Architecture

:::image type="content" alt-text="Diagram showing the chain of custody architecture." source="media/chain-of-custody.png" lightbox="media/chain-of-custody.png":::

*Download a [Visio file](https://arch-center.azureedge.net/chain-of-custody.vsdx) of this architecture.*

### Workflow

This standard Azure *hub-spoke* architecture deploys VMs on the **Production** spoke, and encrypts them with [Azure Disk Encryption (ADE)](/azure/security/fundamentals/azure-disk-encryption-vms-vmss). The [Azure Key Vault](/azure/key-vault/general/overview) in the Production subscription stores the VMs' *BitLocker encryption keys* (BEKs), and *key encryption keys* (KEKs) if applicable.

The SOC team has exclusive access to a different Azure **SOC** subscription, for resources that must be kept protected, unviolated, and monitored. The [Azure Storage](/azure/storage/common/storage-introduction) account in the SOC subscription hosts copies of disk snapshots in [immutable Blob storage](/azure/storage/blobs/storage-blob-immutable-storage), and keeps the snapshots' SHA-256 hash values and copies of the VMs' BEKs and KEKs in its own SOC key vault.

In response to a request to capture a VM's digital evidence, a SOC team member signs in to the Azure SOC subscription, and uses a [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker) VM in [Azure Automation](/azure/automation/automation-intro) to execute the **Copy-VmDigitalEvidence** runbook. The Hybrid Runbook Worker provides control of all mechanisms involved in the capture.

The Copy-VmDigitalEvidence runbook:

1. Signs in to Azure as a [managed identity](/azure/active-directory/managed-identities-azure-resources/overview) or [service principal](/azure/active-directory/develop/howto-create-service-principal-portal) to access the SOC subscription as well as the target VM
1. Creates disk snapshots for the VM's operating system (OS) and data disks
1. Copies the snapshots to the SOC subscription's immutable Blob storage, and to a temporary file share
1. Calculates SHA-256 hash values for the snapshots on the file share
1. Copies the SHA-256 hash values, as well as the VM's BEK, KEK if applicable, and disk identification tags, to the SOC key vault
1. Deletes all copies of the snapshots except the one in immutable Blob storage

### Components

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker)
- [Azure Automation](https://azure.microsoft.com/services/automation)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)(Azure AD)

### Alternatives

If necessary, you can grant time-limited read-only SOC Storage account access to IP addresses from outside, on-premises networks, for investigators to download the digital evidence.

You can also deploy a Hybrid Runbook Worker on on-premises or other cloud networks, which they can use to run the Copy‑VmDigitalEvidence Azure Automation runbook on their resources.

### Azure Storage account

The Storage account in the SOC subscription hosts the disk snapshots in a container configured as Azure immutable Blob storage. Immutable Blob storage stores business-critical data objects in a *Write Once, Read Many* (WORM) state, which makes the data non-erasable and non-modifiable for a user-specified interval. [Secure transfer](/azure/storage/common/storage-require-secure-transfer) must be enabled on the Storage account.

The Storage account also hosts an [Azure file share](/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal) to use as a temporary repository for calculating the snapshot's SHA-256 hash value.

For better [performance](/azure/storage/files/storage-files-scale-targets#azure-file-share-scale-targets) you can choose a Standard Storage Account, with the ["large file share" feature enabled](/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal#enable-large-files-shares-on-an-existing-account), or a Premium Storage Account.

### Azure Key Vault

The SOC subscription has its own key vault, which hosts a copy of the BEK that ADE uses to protect the target VM, as well as the KEK if applicable. The primary copy of the key stays in the key vault used by the target VM, so that VM can continue normal operation. The SOC key vault also contains the SHA-256 hash values for the disk snapshots.

### Azure Automation

The SOC team uses an [Azure Automation](/azure/automation/automation-intro) account to create and maintain the Copy-VmDigitalEvidence runbook. They also use Azure Automation to create the Hybrid Runbook Workers that run the runbook.

#### Hybrid Runbook Worker

The [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker) VM is part of the Automation account, and is used exclusively by the SOC Team to execute the Copy-VmDigitalEvidence runbook.

The Hybrid Runbook Worker VM must be hosted in the same subnet that grants access to the Storage account. Access to this virtual network is granted only to the Hybrid Runbook Worker, using the [service endpoint](/azure/virtual-network/virtual-network-service-endpoints-overview) mechanism.

The Hybrid Runbook Worker must have a managed identity or a Service Principal in order to access the target VM's subscription and execute the runbook. The identity must have at least the following permissions:

- **Contributor** on the target VM's resource group, which provides snapshot rights on VM disks
- **Storage Account Contributor** on the SOC immutable Storage account
- Access policy to **Get Secret** for the BEK, and **Get Key** for the KEK if present, on the target VM's key vault
- Access policy to **Set Secret** for the BEK, and **Create Key** for the KEK if present, on the SOC key vault

If the VM is behind a Firewall (Network Virtual Appliance (NVA), Azure Firewall, Network Security Group) or a Proxy, ensure to allow the connectivity between the VM and the Storage Account.

### Log Analytics

An Azure [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs-collect-workspace) in Azure Monitor stores activity logs to audit all the events on the SOC subscription.

## Scenario details

### Potential use cases

- A company's *Security Operation Center* (SOC) team can implement this technical solution to support a valid CoC for digital evidence
- Investigators can attach disk copies obtained with this technique on a computer dedicated to forensic analysis, without re-creating, powering on, or accessing the original source VM


## Regulatory Compliance

One of the requirements when validating a CoC solution is compliance with security standards and regulations. All the components included in the above architecture are Azure standard services built upon a foundation of trust, security and [compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance).

Azure has a wide range of compliance certifications, including certifications specific for global regions and countries and for key industries like healthcare, government, finance and education.

Updated audit reports, with information about standards compliance for the services adopted in this solution can be found on [Microsoft Compliance Guide](https://servicetrust.microsoft.com/ViewPage/MSComplianceGuideV3).

As an example, the report [Cohasset Assessment - Microsoft Azure WORM Storage](https://servicetrust.microsoft.com/ViewPage/MSComplianceGuide?command=Download&downloadType=Document&downloadId=19b08fd4-d276-43e8-9461-715981d0ea20&docTab=4ce99610-c9c0-11e7-8c2c-f908a777fa4d_GRC_Assessment_Reports) gives details about Microsoft Azure Storage compliance with following requirements:

- **Securities and Exchange Commission (SEC) in 17 CFR § 240.17a-4(f)**, which regulates exchange members, brokers or dealers
- **Financial Industry Regulatory Authority (FINRA) Rule 4511(c)**, which defers to the format and media requirements of SEC Rule 17a-4(f)
- **Commodity Futures Trading Commission (CFTC) in regulation 17 CFR § 1.31(c)-(d)**, which regulates commodity futures trading

It is Cohasset's opinion that Microsoft Azure Storage, with the Immutable Storage for Azure Blobs feature and Policy Lock option, retains time-based Blobs (records) in a non-erasable and non-rewritable format and meets relevant storage requirements of SEC Rule 17a-4(f), FINRA Rule 4511(c), and the principles-based requirements of CFTC Rule 1.31(c)-(d).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider the following requirements when proving the validity of a CoC:

### Least access/privilege

Only two individuals within the SOC team should have rights to modify the controls governing access to the subscription and its data. Grant other individuals only bare minimum access to data subsets they need to perform their work. Configure and enforce access through [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview). Only the [virtual network](/azure/virtual-network/virtual-networks-overview) in the SOC subscription has access to the Storage account.

### Evidence acquisition

Azure Audit Logs can show evidence acquisition by recording the action of taking a VM disk snapshot, with elements like who took the snapshot, how, and where.

### Evidence integrity

You must guarantee that actions taken to move evidence to its final archive destination haven't altered the evidence. You can mitigate the risk of alteration by using native Azure mechanisms like Functions or Azure Automation.

If you apply *Legal Hold* to the destination Azure storage, the evidence is frozen in time as soon as it's written. Legal Hold effectively shows that the CoC was maintained entirely in Azure, and there was no opportunity to tamper between the time the disk image existed on a live VM and became evidence in the Storage account.

Another useful integrity mechanism is the use of *hash algorithms*. Azure offers an MD5 hash value for each disk, but you can calculate stronger values, like SHA-256 in the current example.

### Evidence production

Investigators need access to evidence in order to perform analyses, and this access must be tracked.

Provide investigators with a [Storage Shared Access Signatures (SAS) URI](/azure/storage/common/storage-sas-overview) key for accessing evidence. Using a SAS URI produces relevant log information when the SAS is generated, and every time it's used to get a copy of the evidence.

You also need to provide investigators with the BEKs and KEKs archived in the SOC key vault before they can use the encrypted disk copies.

For example, if a legal team needs a preserved virtual hard drive (VHD) transferred to them, one of the two data custodians generates a read-only SAS URI key that expires after eight hours, to ensure the window of availability to the data is kept to a minimum, and that the data cannot be altered.

### Monitoring and alerting

Azure provides services to all customers to monitor and alert on anomalies involving their subscription and its resources. These services include:

- [Microsoft Sentinel](https://aka.ms/azure-sentinel)
- [Microsoft Defender for Cloud](https://aka.ms/asc)
- [Azure Storage Advanced Threat Protection (ATP)](/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal)

### Regional store

For compliance, some standards or regulations require evidence and all support infrastructure to be maintained in the same Azure region.

## Deploy this scenario

The following PowerShell code samples of the Copy-VmDigitalEvidence runbook are available in GitHub:

- [Copy‑VmDigitalEvidenceWin](https://github.com/mspnp/solution-architectures/blob/master/forensics/Copy-VmDigitalEvidenceWin.ps1) runbook for [Windows Hybrid RunBook Worker](/azure/automation/automation-windows-hrw-install).

- [Copy‑VmDigitalEvidence](https://github.com/mspnp/solution-architectures/blob/master/forensics/Copy-VmDigitalEvidence.ps1) runbook for [Linux Hybrid RunBook Worker](/azure/automation/automation-linux-hrw-install#installing-a-linux-hybrid-runbook-worker). The Hybrid Runbook Worker must have PowerShell Core installed and the `sha256sum` program available, to calculate the disk snapshots' SHA-256 hash values.

The Hybrid Runbook Worker must map the Azure File share containing the disk, used to calculate its hash values. Further details for the mounting procedure are available for both [Windows](/azure/storage/files/storage-how-to-use-files-windows) and [Linux](/azure/storage/files/storage-files-how-to-mount-nfs-shares) systems and must be integrated in the PowerShell code.

> [!NOTE]
> Scripts are provided as a starting point, are not intended to be downloaded a run directly in a customer environment. Be sure to replace placeholders and adapt them to your customer scenario. Before run the script remember to complete the section *Mounting fileshare* with the code to mount the Azure file share. The code is strictly tied to your implementation. To generate the correct code follow the documentation links contained in the scripts.

### Capture workflow

The SOC team has created the Copy‑VmDigitalEvidence runbook and the dedicated [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker) VM in their Azure Automation account.

When the team receives a request to capture digital evidence, a SOC team member follows this workflow:

1. Sign in to the SOC subscription in the Azure portal, and select their Azure Automation account
1. Edit the Copy-VmDigitalEvidence runbook to supply the following information:
   - The target VM's subscription ID
   - The target VM's resource group
   - The target VM's machine name
1. Access the Hybrid Runbook Worker VM, which has a managed identity or service principal for the Azure tenant, and run the Copy-VmDigitalEvidence runbook
1. The Activity Logs register the runbook execution, and store the related data in Log Analytics for further analysis

The Copy-VmDigitalEvidence runbook performs the following actions:

1. Signs in to the Azure SOC subscription
1. Signs in to the target VM and creates the OS disk snapshot
1. Copies the snapshot to the immutable SOC Blob Storage account and to the temporary SOC Azure file share
1. Calculates the SHA-256 hash value of snapshot on the file share
1. Accesses the target VM's key vault and copies the VM's BEK, and KEK if applicable, to the SOC key vault. A secret named with the thumbprint of the runbook execution contains the encryption key and all the tags to identify the disk and volume
1. Stores the calculated SHA-256 hash value into the SOC key vault
1. Removes the temporary copy of the snapshot from the SOC Azure file share
1. Repeats the disk snapshots, snapshot and key copying, and hash generation and copying for each data disk attached to the VM
1. Removes all the source snapshots generated during the process

### Deployment without a Hybrid Runbook Worker node

You can execute the code within a VM with the following configuration:

- The VM must be hosted in the same subnet that grants access to the Storage account.
- The VM must have a managed identity to which must be given access to target VM's subscription.
- Inside this VM, you can run the code without the associated 'if' statement.

### Evidence retrieval

After the execution of the Copy-VmDigitalEvidence runbook, the evidence is stored on the SOC Blob Storage account as a file with .vhd extension.

Different methods are available to retrieve the evidence from the .vhd image.

In the following examples the .vhd file is used to create an [Azure managed disk](/azure/virtual-machines/managed-disks-overview) that is attached as a data disk to an Azure Virtual Machine used to analyze the evidence.

Below actions must be executed:

- [Create a managed disk from a VHD file in a storage account](/azure/virtual-machines/scripts/virtual-machines-powershell-sample-create-managed-disk-from-vhd)
- Attach the newly created disk to the Azure Virtual Machine:
  - [Windows procedure](/azure/virtual-machines/windows/attach-disk-ps#attach-an-existing-data-disk-to-a-vm)
  - [Linux procedure](/azure/virtual-machines/linux/attach-disk-portal#attach-a-new-disk)

At the end of the procedure, the Virtual Machine has a new encrypted data disk connected to it.

To decrypt the disk, follow the procedures described in below sessions.

#### Windows disks unlock

The Azure Windows data disk is locked by BitLocker. Once the disk is attached on a Windows machine the content is not readable, until it's unlocked.

To unlock an Azure data disk connected, for example, on G:\ execute below actions:

1. Open the SOC key vault, and search the secret containing the BEK of the disk. The secret is named with the thumbprint of the Copy-VmDigitalEvidence runbook execution
1. Copy the BEK string and paste it into the `$bekSecretBase64` variable in the following PowerShell script. Paste the value of the `DiskEncryptionKeyFileName` tag associated to the secret into the `$fileName` variable
1. Run the script

    ```powershell
    $bekSecretbase64=""

    $fileName=""

    $bekFileBytes = [Convert]::FromBase64String($bekSecretbase64)

    $path = "C:\BEK\$fileName"

    [System.IO.File]::WriteAllBytes($path,$bekFileBytes)

    manage-bde -unlock G: -rk $path
    ```

#### Linux disks unlock

The Azure Linux data disk is locked by DM-Crypt. The content of the disk is not accessible until the disk is unlocked.

To unlock an Azure data disk and mount it under the directory `datadisk`:

1. Open the SOC key vault, and search the secret containing the BEK of the disk. The secret is named with the thumbprint of the Copy-VmDigitalEvidence runbook execution
1. Copy the BEK string and paste it into the `bekSecretBase64` variable in the following bash script
1. Run the script

    ```bash
   #!/bin/bash

   bekSecretbase64=""

   mountname="datadisk"

   device=$(blkid -t TYPE=crypto_LUKS -o device)

   passphrase="$(base64 -d <<< $bekSecretbase64)"

   echo "Passphrase: " $passphrase

   if [ ! -d "${mountname:+$mountname/}" ]; then

    mkdir $mountname

   fi

   cryptsetup open $device $mountname
    ```

After the script execution, you will be prompted for the encryption passphrase. Copy it from the script output to unlock and access the content of the Azure data disk.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Simone Savi](https://www.linkedin.com/in/simone-savi-3b50aa7) | Senior Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about Azure data-protection features, see:

- [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption)
- [Azure Disk Encryption for VMs and virtual machine scale sets](/azure/security/fundamentals/azure-disk-encryption-vms-vmss)
- [Immutable Storage - Legal Hold Policy](/azure/storage/blobs/storage-blob-immutable-storage#legal-holds)

For more information about Azure logging and auditing features, see:

- [Azure security logging and auditing](/azure/security/fundamentals/log-audit)
- [Azure Storage analytics logging](/azure/storage/common/storage-analytics-logging)
- [Azure platform logs in a Log Analytics workspace in Azure Monitor](/azure/azure-monitor/platform/resource-logs-collect-workspace)

For more information about Microsoft Azure Compliance, see:

- [Azure Compliance](https://azure.microsoft.com/overview/trusted-cloud/compliance)
- [Microsoft Azure Compliance Offerings](https://azure.microsoft.com/resources/microsoft-azure-compliance-offerings)

## Related resources

- [Security architecture design](../../guide/security/security-start-here.yml)
- [Azure Active Directory IDaaS in security operations](../aadsec/azure-ad-security.yml)
- [Security considerations for highly sensitive IaaS apps in Azure](../../reference-architectures/n-tier/high-security-iaas.yml)
