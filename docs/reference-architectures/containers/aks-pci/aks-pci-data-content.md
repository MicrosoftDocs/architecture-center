This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

## Protect Cardholder Data 

**Requirement 3**&mdash;Protect stored cardholder data

|Requirement|Responsibility|
|---|---|
|[Requirement 3.1](#requirement-31)|Keep cardholder data storage to a minimum by implementing data retention and disposal policies, procedures and processes that include at least the following for all cardholder data (CHD) storage:|
|[Requirement 3.2](#requirement-32)|Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process.|
|[Requirement 3.3](#requirement-33)|Mask PAN when displayed (the first six and last four digits are the maximum number of digits to be displayed), such that only personnel with a legitimate business need can see the full PAN. |
|[Requirement 3.4](#requirement-34)|Render PAN unreadable anywhere it is stored (including on portable digital media, backup media, and in logs) by using any of the following approaches:|
|[Requirement 3.5](#requirement-35)|Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse: |
|[Requirement 3.6](#requirement-36)|Fully document and implement all key-management processes and procedures for cryptographic keys used for encryption of cardholder data, including the following: |
|[Requirement 3.7](#requirement-37)|Ensure that security policies and operational procedures for protecting stored cardholder data are documented, in use, and known to all affected parties.|

***
**Requirement 4**&mdash;Encrypt transmission of cardholder data across open, public networks.

|Requirement|Responsibility|
|---|---|
|[Requirement 4.1](#requirement-41)|Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, etc.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:|
|[Requirement 4.2](#requirement-42)|Never send unprotected PANs by end-user messaging technologies (for example, e-mail, instant messaging, SMS, chat, etc.).|
|[Requirement 4.3](#requirement-43)|Ensure that security policies and operational procedures for encrypting transmissions of cardholder data are documented, in use, and known to all affected parties.|

### Requirement 3.1

 Keep cardholder data storage to a minimum by implementing data retention and disposal policies, procedures and processes that include at least the following for all cardholder data (CHD) storage:
- Limiting data storage amount and retention time to that which is required for legal, regulatory, and business requirements
- Processes for secure deletion of data when no longer needed
- Specific retention requirements for cardholder data
- A quarterly process for identifying and securely deleting stored cardholder data that exceeds defined retention.

#### Your responsibilities
Do not store state in the AKS cluster. If you choose to store CHD, explore secure storage options, such as Azure Storage, Azure Data Factory, and others.

Adhere strictly to the standard guidance about what kind of CHD can be stored. Define data retention policies based on your business requirements and the type of storage used. Some key considerations are:
- How and where the data is stored? 
- What's the retention period?
- What actions are permitted during the retention period?
- How are you deleting the stored data after the retention period has expired? 

When choosing a storage technology, explore the retention features. For example, Azure Blob storage provides [Time-based retention policies](/azure/storage/blobs/storage-blob-immutable-storage#time-based-retention-policies). Another choice is to implement a custom solution that deletes data according to retention policies. An example is Data Lifecycle Management (DLM) that manages data life cycle activities. The solution has been designed with services such as like Azure Data Factory, Azure Active Directory (Azure AD), and Azure Key Vault. 

For more information, see [Managing the data life cycle using Azure Data Factory](https://www.microsoft.com/itshowcase/managing-the-data-life-cycle-using-azure-data-factory).


#### Azure responsibilities
Azure makes sure that customer data designated for deletion are securely decommissioned using NIST 800-88 compliant protocols specified in its Secure Disposal policies.


### Requirement 3.2

(Applies to: Requirement 3.2.1, Requirement 3.2.2, Requirement 3.2.3)

Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process. 

It is permissible for issuers and companies that support issuing services to store sensitive authentication data if: 
- There is a business justification and 
- The data is stored securely.

#### Your responsibilities
As per the standard sensitive authentication data consists of full track data, card validation code or value, and PIN data. As part of CHD processing, make sure that authentication data is not stored or included in sources such as,
- Logs that are emitted from the pods should not include the data.
- Exception handling routines.
- Filenames. 
- Cache.

If you do need to store this information, document the business justification. 


### Requirement 3.3

Mask PAN when displayed (the first six and last four digits are the maximum number of digits to be displayed), such that only personnel with a legitimate business need can see the full PAN. 

#### Your responsibilities

### Requirement 3.4

#### Your responsibilities

### Requirement 3.5

#### Your responsibilities

### Requirement 3.6

#### Your responsibilities

### Requirement 3.7

#### Your responsibilities


### Requirement 4.1

Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, etc.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:


#### Your responsibilities
      
Data that transits over the public internet must be encyrpted. Data must be encrypted with TLS 1.2 (or later), with reduced cipher support for all transmissions. Do not support non-TLS to TLS redirects on any data transmission services. Have many TLS terminiation points in your design starting at the first point of interception and all the way to your cluster. This means that TLS should be maintained between network hops that may include firewalls and the cluster. At each hop, inspect the packet, block, or route it to the next destination. Have the final TLS termination point at the cluster's ingress resource. Consider taking it further and provide TLS connections between the pods within the cluster resources.

:::image type="content" source="./images/flow.svg" alt-text="Data encryption" lightbox="./images/flow.png":::

Deny the creation of any non https ingress resource via azure policy. Also deny the creation of any public IP or any public load balacners in your cluster, to ensure web traffic is being tunneled through your gateway.

For more information, see [Azure encryption overview](https://docs.microsoft.com/azure/security/fundamentals/encryption-overview).


<Ask Chad: to give input around can the approval process be automated, who should be responsible and how is that incorporated in the pipeline.>

#### Requirement 4.1.1

Ensure wireless networks transmitting cardholder data or connected to the cardholder data environment, use industry best practices (for example, IEEE 802.11i) to implement strong encryption for authentication and transmission.

##### Your responsibilities
      
<Ask Chad>

#### Requirement 4.2
Never send unprotected PANs by end-user messaging technologies (for example, e-mail, instant messaging, SMS, chat, etc.).

##### Your responsibilities
      
<Ask Chad>


#### Requirement 4.3

Ensure that security policies and operational procedures for encrypting transmissions of cardholder data are documented, in use, and known to all affected parties.

##### Your responsibilities
      
<Ask Chad>



## Next

Protect all systems against malware and regularly update anti-virus software or programs. Develop and maintain secure systems and application

> [!div class="nextstepaction"]
> [Maintain a Vulnerability Management Program](aks-pci-malware.yml)