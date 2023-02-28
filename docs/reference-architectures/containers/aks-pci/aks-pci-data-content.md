This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS 3.2.1).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml).

This architecture and the implementation are focused on infrastructure and not the workload. This article provides general considerations and best practices to help you make design decisions. Follow the requirements in the official PCI-DSS 3.2.1 standard and use this article as additional information, where applicable.

> [!IMPORTANT]
>
> The guidance and the accompanying implementation builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks). That architecture based on a hub-and-spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintenance. The spoke virtual network contains the AKS cluster that provides the cardholder data environment (CDE) and hosts the PCI DSS workload. 
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

## Protect Cardholder Data

### **Requirement 3**&mdash;Protect stored cardholder data

#### Your responsibilities

|Requirement|Responsibility|
|---|---|
|[Requirement 3.1](#requirement-31)|Keep cardholder data storage to a minimum by implementing data retention and disposal policies, procedures and processes that include at least the following for all cardholder data (CHD) storage:|
|[Requirement 3.2](#requirement-32)|Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process.|
|[Requirement 3.3](#requirement-33)|Mask PAN when displayed (the first six and last four digits are the maximum number of digits to be displayed), such that only personnel with a legitimate business need can see the full PAN. |
|[Requirement 3.4](#requirement-34)|Render PAN unreadable anywhere it is stored (including on portable digital media, backup media, and in logs) by using any of the following approaches:|
|[Requirement 3.5](#requirement-35)|Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse: |
|[Requirement 3.6](#requirement-36)|Fully document and implement all key-management processes and procedures for cryptographic keys used for encryption of cardholder data, including the following: |
|[Requirement 3.7](#requirement-37)|Ensure that security policies and operational procedures for protecting stored cardholder data are documented, in use, and known to all affected parties.|

### **Requirement 4**&mdash;Encrypt transmission of cardholder data across open, public networks.

#### Your responsibilities

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

Do not store state in the AKS cluster. If you choose to store CHD, explore secure storage options. Options include Azure Storage for file storage, or databases such as Azure SQL Database or Azure Cosmos DB.

Adhere strictly to the standard guidance about what kind of CHD can be stored. Define data retention policies based on your business requirements and the type of storage used. Some key considerations are:
- How and where is the data stored?
- Is the stored data encrypted?
- What's the retention period?
- What actions are permitted during the retention period?
- How are you deleting the stored data after the retention period has expired?

Have governance policies around some of those choices. Built-in Azure policies enforce those choices. For example, you can restrict the volume types on the cluster pods or deny write operations on the root file system.

Review [this list of policy definitions](/azure/aks/policy-reference) and apply them to the cluster, where applicable.

You might need to temporarily cache data. We recommend that you protect the cached data while it's moved to a storage solution. Consider enabling the host-based encryption feature on AKS. This will encrypt the data stored on node VMs. For more information, see [Host-based encryption on Azure Kubernetes Service (AKS)](/azure/aks/enable-host-encryption). Also, enable a built-in Azure policy that requires encryption of temporary disks and cache for node pools.

When you're choosing a storage technology, explore the retention features. For example, Azure Blob Storage provides [time-based retention policies](/azure/storage/blobs/storage-blob-immutable-storage#time-based-retention-policies). Another choice is to implement a custom solution that deletes data according to retention policies. An example is Data Lifecycle Management (DLM), which manages data life-cycle activities. The solution has been designed with services like Azure Data Factory, Azure Active Directory (Azure AD), and Azure Key Vault.

For more information, see [Managing the data life cycle using Azure Data Factory](https://www.microsoft.com/itshowcase/managing-the-data-life-cycle-using-azure-data-factory).

### Requirement 3.2

Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process.

#### Your responsibilities

(APPLIES TO: Requirement 3.2.1, Requirement 3.2.2, Requirement 3.2.3)

Processing and protecting data is beyond the scope of this architecture. Here are some general considerations.

Per the standard, sensitive authentication data consists of full track data, card validation code or value, and PIN data. As part of CHD processing, make sure that authentication data is not exposed in sources such as:
- Logs that are emitted from the pods.
- Exception handling routines.
- File names.
- Cache.

As general guidance, merchants shouldn't store this information. If there's a need document the business justification.

### Requirement 3.3

Mask PAN when displayed (the first six and last four digits are the maximum number of digits to be displayed), such that only personnel with a legitimate business need can see the full PAN.

#### Your responsibilities

Primary account number (PAN) is considered to be sensitive data, and exposure to this data must be prevented. One way is to reduce the displayed digits through masking.

Do not implement data masking in the workload. Instead, use database-level constructs. The Azure SQL line of services, including Azure Synapse Analytics, supports dynamic data masking, which reduces exposure at the application layer. It's a policy-based security feature that defines who can view the unmasked data and how much data is exposed through masking.  The built-in **Credit card** masking method exposes the last four digits of the designated fields and adds a constant string as a prefix in the form of a credit card.

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

Appropriate data-masking techniques also fulfill this requirement. You're responsible for masking all primary account number (PAN) data. The Azure SQL line of services, including Azure Synapse Analytics, supports dynamic data masking. See [Requirement 3.3](#requirement-33).

Make sure PAN is not exposed as part of your workflow processes. Here are some considerations:

- Keep PAN out of logs, both workflow logs and (expected or unexpected) exception-handling logs. Also, diagnostics data flows, such as HTTP headers, must not expose this data.

- Do not use PAN as a cache lookup key or as part of any file name generated by this process.

- Your customers might provide PAN in free-form text fields unprompted. Ensure that content validation and detection processes are in place for any free-form text fields, scrubbing all content that resembles PAN data.

#### Requirement 3.4.1

If disk encryption is used (rather than file- or column-level database encryption), logical access must be managed separately and independently of native operating system authentication and access control mechanisms (for example, by not using local user account databases or general network login credentials). Decryption keys must not be associated with user accounts.

##### Your responsibilities

As a general rule, do not store state in the AKS cluster. Use an external data storage that supports storage-engine level encryption.

All stored data in Azure Storage is encrypted and decrypted by using strong cryptography. Microsoft manages the associated keys. Self-managed encryption keys are preferred. Always encrypt outside the storage layer and only write encrypted data into the storage medium, ensuring that the keys are never adjacent to the storage layer.

With Azure Storage, you can also use self-managed keys. For details, see  [Customer-managed keys for Azure Storage encryption](/azure/storage/common/customer-managed-keys-overview?toc=/azure/storage/blobs/toc.json).

Similar capabilities are available for databases. For Azure SQL options, see [Azure SQL Transparent Data Encryption with customer-managed key](/azure/azure-sql/database/transparent-data-encryption-byok-overview).

Make sure you store your keys in a managed key store (Azure Key Vault, Azure Key Vault Managed Hardware Security Module (HSM), and others).

If you need to store data temporarily, enable the [host-encryption](/azure/aks/enable-host-encryption) feature of AKS to make sure that data stored on VM nodes is encrypted.

### Requirement 3.5

Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse:

#### Your responsibilities

These points are described in the subsections:
- Maintain the practice of least-privilege access for the cryptographic keys.
- Azure Key Vault and Azure Active Directory are designed to support the authorization and audit logging requirements. For details, see [Request authentication for Azure Key Vault](/azure/key-vault/general/authentication-requests-and-responses#authentication).
- Protect all data encryption keys with a key encryption key that's stored in a cryptographic device.
- If you use self-managed keys (instead of Microsoft-managed keys), have a process and documentation for maintaining tasks related to key management.

#### Requirement 3.5.1

Additional requirement for service providers only: Maintain a documented description of the cryptographic architecture that includes:
- Details of all algorithms, protocols, and keys used for the protection of cardholder data, including key strength and expiry date
- Description of the key usage for each key
- Inventory of any HSMs and other SCDs used for key management

##### Your responsibilities

One way to store sensitive information (keys, connection strings, and others) is to use the native Kubernetes `Secret` resource. You must explicitly enable encryption at rest. Alternatively, store them in a managed store such as Azure Key Vault. Of the two approaches, we recommend using a managed store service. One advantage is reduced overhead in tasks related to key management, such as key rotation.

By default, Azure uses Microsoft-managed keys for all encrypted data, per customer. However, some services also support self-managed keys for encryption. If you use self-managed keys for encryption at rest, ensure you account for a process and strategy that handles key management tasks.

As part of your documentation, include information related to key management such as expiration, location, and maintenance plan details.

#### Requirement 3.5.2

Restrict access to cryptographic keys to the fewest number of custodians necessary.

##### Your responsibilities

Minimize the number of people who have access to the keys. If you're using any group-based role assignments, set up a recurring audit process to review roles that have access. When project team members change, accounts that are no longer relevant must be removed from permissions. Only the right people should have access. Consider removing standing permissions in favor of just-in-time (JIT) role assignments, time-based role activation, and approval-based role activation.

#### Requirement 3.5.3

Store secret and private keys used to encrypt/decrypt cardholder data in one (or more) of the following forms at all times:
- Encrypted with a key-encrypting key that is at least as strong as the data-encrypting key, and that is stored  separately from the data-encrypting key
- Within a secure cryptographic device (such as a hardware (host) security module (HSM) or PTS-approved point-of-interaction device)
- As at least two full-length key components or key shares, in accordance with an industry- accepted method

##### Your responsibilities

A PCI-DSS 3.2.1 workload will need to use more than one encryption key as part of the data-at-rest protection strategy. A data encryption key (DEK) is used to encrypt and decrypt the CHD, but you're responsible for an additional key encryption key (KEK) to protect that DEK. You're also responsible for ensuring that the KEK is stored in a cryptographic device.

You can use Azure Key Vault to store the DEK and use Azure Dedicated HSM to store the KEK. For information about HSM key management, see [What is Azure Dedicated HSM?](/azure/dedicated-hsm/overview).

### Requirement 3.6

Fully document and implement all key-management processes and procedures for cryptographic keys used for encryption of cardholder data, including the following:

#### Your responsibilities

(APPLIES TO: Requirement 3.6.1, Requirement 3.6.2, Requirement 3.6.3, Requirement 3.2.4)

If you're using Azure Key Vault to store secrets such as keys, certificates, and connection strings, protect it from unauthorized access. Microsoft Defender for Key Vault detects suspicious access attempts and generates alerts. You can view these alerts in Microsoft Defender for Cloud. For more information, see [Microsoft Defender for Key Vault](/azure/security-center/defender-for-key-vault-introduction).

Follow [NIST](https://csrc.nist.gov/) guidance about key management. For details, see:
- [Cryptographic Key Management](https://csrc.nist.gov/projects/key-management/faqs).
- [SP 800-133 Rev. 2, Recommendation for Cryptographic Key Generation](https://csrc.nist.gov/publications/detail/sp/800-133/rev-2/final)
- [SP 800-57 Part 1 Rev. 5, Recommendation for Key Management](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)

See also [Microsoft Defender for Key Vault](/azure/security-center/defender-for-key-vault-introduction).

#### Requirement 3.6.7

Prevention of unauthorized substitution of cryptographic keys.

##### Your responsibilities

- **Enable diagnostics** on all key stores. Use Azure Monitor for Key Vault. It collects logs and metrics and sends them to Azure Monitor. For more information, see [Monitoring your key vault service with Azure Monitor for Key Vault](/azure/azure-monitor/insights/key-vault-insights-overview).
- **Give read-only permissions** to all consumers.
- **Do not have standing permissions** for all management service principals. Instead, use just-in-time (JIT) role assignments, time-based role activation, and approval-based role activation.
- **Create a centralized view** by integrating logs and alerts into security information and event management (SIEM) solutions, such as Microsoft Sentinel.
- **Take action on alerts** and notifications, especially on unexpected changes.

#### Requirement 3.6.8

Requirement for cryptographic key custodians to formally acknowledge that they understand and accept their key-custodian responsibilities.

##### Your responsibilities

Maintain documentation that describes the accountabilities of the parties responsible in the operations of key management.

### Requirement 3.7

Ensure that security policies and operational procedures for protecting stored cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities

Create documentation as a general statement plus a series of up-to-date role guides for all personas.  Perform new-hire training and ongoing training.

It's critical that you maintain thorough documentation about the processes and policies. Several teams participate in making sure data is protected at rest and in transit. In your documentation, provide role guidance for all personas. The roles should include SRE, customer support, sales, network operations, security operations, software engineers, database administrators, and others. Personnel should be trained in NIST guidance and data-at-rest strategies to keep the skillset up to date. Training requirements are addressed in [Requirement 6.5](./aks-pci-malware.yml#requirement-65) and [Requirement 12.6](./aks-pci-policy.yml).

### Requirement 4.1

Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, and so on.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:

#### Your responsibilities

Card holder data (CHD) that transits over the public internet must be encrypted. Data must be encrypted with TLS 1.2 (or later), with reduced cipher support for all transmissions. Do not support non-TLS to TLS redirects on any data transmission services.

Your design should have a strategic chain of TLS termination points. As data travels through network hops, maintain TLS at hops that require packet inspection. At the very least, have the final TLS termination point at the cluster's ingress resource. Consider taking it further within the cluster resources.

:::image type="content" source="./images/flow.svg" alt-text="Diagram that illustrates data encryption." lightbox="./images/flow.png":::

Use Azure Policy to govern creation of resources:
- Deny the creation of any non-HTTPS ingress resource.
- Deny the creation of any public IP or any public load balancers in your cluster, to ensure web traffic is being tunneled through your gateway.

For more information, see [Azure encryption overview](/azure/security/fundamentals/encryption-overview).

#### Requirement 4.1.1

Ensure wireless networks transmitting cardholder data or connected to the cardholder data environment, use industry best practices (for example, IEEE 802.11i) to implement strong encryption for authentication and transmission.

##### Your responsibilities

This architecture and the implementation aren't designed to do on-premises or corporate network-to-cloud transactions over wireless connections. For considerations, refer to the guidance in the official PCI-DSS 3.2.1 standard.

#### Requirement 4.2

Never send unprotected PANs by end-user messaging technologies (for example, e-mail, instant messaging, SMS, chat, etc.).

##### Your responsibilities

If your workload requires sending emails, consider building an email quarantine gate. This validation will give you the ability to scan all outbound messages for compliance and check that sensitive data isn't included. Ideally, you should also consider this approach for customer support messages.

Validation should be done at the workload level and the change control process. The approval gates should understand the requirement.

For considerations, refer to the guidance in the official PCI-DSS 3.2.1 standard.

#### Requirement 4.3

Ensure that security policies and operational procedures for encrypting transmissions of cardholder data are documented, in use, and known to all affected parties.

##### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. That's especially true when you're managing policies about Transport Layer Security (TLS). Here are some areas:

- Public internet ingress points. An example is Azure Application Gateway support for TLS ciphers.
- Network hops between perimeter network and workload pods.
- Pod-to-pod encryption (if implemented). This can include details about the configuration of a service mesh.
- Pod to storage (if part of the architecture).
- Pod to external services, Azure PaaS services that use TLS, a payment gateway, or a fraud detection system.

People who are operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.

## Next steps

Protect all systems against malware and regularly update antivirus software or programs. Develop and maintain secure systems and applications.

> [!div class="nextstepaction"]
> [Maintain a Vulnerability Management Program](aks-pci-malware.yml)
