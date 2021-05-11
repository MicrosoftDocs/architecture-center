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

When choosing a storage technology, explore the retention features. For example, Azure Blob storage provides [Time-based retention policies](/azure/storage/blobs/storage-blob-immutable-storage#time-based-retention-policies). Another choice is to implement a custom solution that deletes data according to retention policies. An example is Data Lifecycle Management (DLM) that manages data life-cycle activities. The solution has been designed with services such as like Azure Data Factory, Azure Active Directory (Azure AD), and Azure Key Vault. 

For more information, see [Managing the data life cycle using Azure Data Factory](https://www.microsoft.com/itshowcase/managing-the-data-life-cycle-using-azure-data-factory).


### Requirement 3.2

Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process. 

#### Your responsibilities
(APPLIES TO: Requirement 3.2.1, Requirement 3.2.2, Requirement 3.2.3)

As per the standard sensitive authentication data consists of full track data, card validation code or value, and PIN data. As part of CHD processing, make sure that authentication data is not exposed in sources such as,
- Logs that are emitted from the pods should not include the data.
- Exception handling routines.
- Filenames. 
- Cache.

If you do need to store this information, document the business justification. 


### Requirement 3.3

Mask PAN when displayed (the first six and last four digits are the maximum number of digits to be displayed), such that only personnel with a legitimate business need can see the full PAN. 

#### Your responsibilities
Primary account number (PAN) is considered to be sensitive data and exposure to this data must be prevented. One way is to reduce the displayed digits through masking. 

Do not implement data masking in the workload. Instead, use database-level constructs. Azure SQL line of services including Azure Synapse Analytics support dynamic data masking, which reduces exposure at the application layer. It's a policy-based security feature that defines who can view the unmasked data and how much data is exposed through masking.  The built-in **Credit card** masking method exposes the last four digits of the designated fields and adds a constant string as a prefix in the form of a credit card.

For more information, see [Dynamic data masking](/azure/azure-sql/database/dynamic-data-masking-overview).

If you do need to bring in unmasked data into your cluster, mask as soon as possible.


### Requirement 3.4
Render PAN unreadable anywhere it is stored (including on portable digital media, backup media, and in logs) by using any of the following approaches:
- One-way hashes based on strong cryptography, (hash must be of the entire PAN)
- Truncation (hashing cannot be used to replace the truncated segment of PAN)
- Index tokens and pads (pads must be securely stored)
- Strong cryptography with associated key-management processes and procedures. 

#### Your responsibilities
For this requirement, you might need to use direct cryptography in the workload. PCI DSS guidance recommends using industry-tested algorithms so that they stand up to real-world attacks. Avoid using custom encryption algorithms.

Appropriate data masking techniques also fulfill this requirement. You're responsible for masking all primary account number (PAN) data. Azure SQL line of services including Azure Synapse Analytics support dynamic data masking. See [Requirement 3.3](#requirement-33).

Make sure PAN is not exposed as part of your workflow processes. Here are some considerations: 

- Keep PAN out of logs, both workflow logs and (expected or unexpected) exception handling logs. Also, diagnostics data flows, such as HTTP headers, must not expose this data.

- Do not use PAN as a cache lookup key or as part of any filename generated by this process.

- If your workload requires sending emails, consider building an email quarantine gate. This validation will give you the ability to scan all outbound message for compliance and check that sensitive data isn't included. Ideally, this approach should also be considered for customer support messages.

- Your customers may provide PAN in free-form text fields unprompted. Ensure content validation and detection processes are in place for any free-form text fields, scrubbing all content that resembles PAN data.

#### 3.4.1 

 If disk encryption is used (rather than file- or column-level database encryption), logical access must be managed separately and independently of native operating system authentication and access control mechanisms (for example, by not using local user account databases or general network login credentials). Decryption keys must not be associated with user accounts.


##### Your responsibilities
As a general rule, do not store state in the AKS cluster. Use an external data storage that supports storage-engine level encryption.

### Requirement 3.5
Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse: 

#### Your responsibilities

These points are described in the subsections: 
- Maintain the practice of least-privilege access for the cryptographic keys. 
- Azure Key Vault and Azure Active Directory are designed to support the authorization and audit logging requirements. For details, see [Request authentication for Azure Key Vault](/azure/key-vault/general/authentication-requests-and-responses#authentication).
- Protect all data encryption keys with a key encryption key that's stored in a cryptographic device. 
- If you use self-managed keys (instead of Microsoft-managed keys), have a process and documentation for maintaining tasks related key management. may be used to protect another key.


#### Requirement 3.5.1
Additional requirement for service providers only: Maintain a documented description of the cryptographic architecture that includes:
- Details of all algorithms, protocols, and keys used for the protection of cardholder data, including key strength and expiry date
- Description of the key usage for each key
- Inventory of any HSMs and other SCDs used for key management

##### Your responsibilities

By default, Azure uses Microsoft-managed keys for all encrypted data, per customer. However, some services also support self-managed keys for encryption. If your design uses self-managed keys for encryption at rest, ensure you account for a process and strategy that handles the tasks related to management of those keys, for example key rotation.

As part of your documentation, include information related to key management such as expiry, location, and maintenance plan details.


#### Requirement 3.5.2
Restrict access to cryptographic keys to the fewest number of custodians necessary.

##### Your responsibilities

Minimize the number of people who have access to the keys. If using any group-based role assignments, set up a recurring audit process to review roles that have access. When project team members change, accounts that are no longer relavant must be removed from permissions. Only the right people should have access. Consider removing standing permissions in favor of just-in-time (JIT) role assignments, time-based, and approval-based role activation. 

#### Requirement 3.5.3
Store secret and private keys used to encrypt/decrypt cardholder data in one (or more) of the following forms at all times:
- Encrypted with a key-encrypting key that is at least as strong as the data-encrypting key, and that is stored  separately from the data-encrypting key
- Within a secure cryptographic device (such as a hardware (host) security module (HSM) or PTS-approved point-of-interaction device)
- As at least two full-length key components or key shares, in accordance with an industry- accepted method

##### Your responsibilities

A PCI-DSS workload will need to use more than one encryption key as part of the data-at-rest protection strategy. While data encryption key (DEK) is used to encrypt and decrypt CHD, you're responsible for an additional key encryption key (KEK) to protect that DEK. You're also responsible for ensuring that KEK is stored in a cryptographic device. 

Azure Key Vault can be used to store the DEK, while Azure Dedicated HSM may be used to store the KEK. For information about HSM key management, see [What is Azure Dedicated HSM?](/azure/dedicated-hsm/overview).


### Requirement 3.6
Fully document and implement all key-management processes and procedures for cryptographic keys used for encryption of cardholder data, including the following: 

#### Your responsibilities

(APPLIES TO: Requirement 3.6.1, Requirement 3.6.2, Requirement 3.6.3, Requirement 3.2.4)

Follow [NIST](https://csrc.nist.gov/) guidance about key management. For details, see:
- [Cryptographic Key Management](https://csrc.nist.gov/projects/key-management/faqs).
- [SP 800-133 Rev. 2, Recommendation for Cryptographic Key Generation](https://csrc.nist.gov/publications/detail/sp/800-133/rev-2/final)
- [SP 800-57 Part 1 Rev. 5, Recommendation for Key Management](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)

#### Requirement 3.6.7
Prevention of unauthorized substitution of cryptographic keys.

##### Your responsibilities

- **Enable diagnostics** on all key stores. Use Azure Monitor for Key Vault. It collects logs and metrics and sends them to Azure Monitor. For more information, see [Monitoring your key vault service with Azure Monitor for Key Vault](/azure/azure-monitor/insights/key-vault-insights-overview).
- **Give read-only permissions** to all consumers. 
- **Do not have standing permissions** for all management service principals. Instead, use just-in-time (JIT) role assignments, time-based, and approval-based role activation. 
- **Create a centralized view** by integrating logs and alerts into Security Information and Event Management (SIEM) solutions, such as Azure Sentinel.  
- **Take action on alerts** and notifications, especially on unexpected changes.

#### Requirement 3.6.8
Requirement for cryptographic key custodians to formally acknowledge that they understand and accept their key-custodian responsibilities.

##### Your responsibilities

Maintain legal documentation that describes the accountabilities of the parties  responsible in the operations of key management. 

### Requirement 3.7
Ensure that security policies and operational procedures for protecting stored cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities
Documentation -- this should be created as a general statement plus a series of up-to-date role guide for all personas.  New hire training and ongoing training should be performed.

It's critical that you maintain thorough documentation about the process and policies. Several teams participate in making sure data is protected at rest and in transit. In your documentation, provide role guidance for all personas. The roles should include SRE, customer support, sales, network operations, security operations, software engineers, database administrators, and others. Personnel should be trained in NIST guidance and data-at-rest strategies to keep the skillset up to date. 

### Requirement 4.1

Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, and so on.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:


#### Your responsibilities
      
Data that transits over the public internet must be encrypted. Data must be encrypted with TLS 1.2 (or later), with reduced cipher support for all transmissions. Do not support non-TLS to TLS redirects on any data transmission services. Have many TLS termination points in your design starting at the first point of interception and all the way to your cluster. Maintain TLS between network hops that may include firewalls and the cluster. At each hop, inspect the packet, block, or route it to the next destination. Have the final TLS termination point at the cluster's ingress resource. Consider taking it further and provide TLS connections between the pods within the cluster resources.

:::image type="content" source="./images/flow.svg" alt-text="Data encryption" lightbox="./images/flow.png":::

Use Azure Policy to govern creation of resources:
- Deny the creation of any non-HTTPS ingress resource. 
- Deny the creation of any public IP or any public load balancers in your cluster, to ensure web traffic is being tunneled through your gateway.

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