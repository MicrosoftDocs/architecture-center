# Implement Strong Access Control Measures

## PCI DSS Requirement 8: Identify and authenticate access to system components  

Assigning a unique identification (ID) to each person with access ensures that each individual is uniquely accountable for their actions. When such accountability is in place, actions taken on critical data and systems are performed by, and can be traced to, known and authorized users and processes.
The effectiveness of a password is largely determined by the design and implementation of the authentication system—particularly, how frequently password attempts can be made by an attacker, and the security methods to protect user passwords at the point of entry, during transmission, and while in storage.
Note: These requirements are applicable for all accounts, including point-of-sale accounts, with administrative capabilities and all accounts used to view or access cardholder data or to access systems with cardholder data. This includes accounts used by vendors and other third parties (for example, for support or maintenance). These requirements do not apply to accounts used by consumers (e.g., cardholders). 
However, Requirements 8.1.1, 8.2, 8.5, 8.2.3 through 8.2.5, and 8.1.6 through 8.1.8 are not intended to apply to user accounts within a point-of-sale payment application that only have access to one card number at a time in order to facilitate a single transaction (such as cashier accounts).

> **Note:** These requirements are defined by the [Payment Card Industry (PCI) Security Standards Council](https://www.pcisecuritystandards.org/pci_security/) as part of the [PCI Data Security Standard (DSS) Version 3.2](https://www.pcisecuritystandards.org/document_library?category=pcidss&document=pci_dss). Please refer to the PCI DSS for information on testing procedures and guidance for each requirement.

### PCI DSS Requirement 8.1

**8.1** Define and implement policies and procedures to ensure proper user identification management for non-consumer users and administrators on all system components as follows:

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore provides documentation and details the correct usage of administrators for the sample deployment.|



#### PCI DSS Requirement 8.1.1

**8.1.1** Assign all users a unique ID before allowing them to access system components or cardholder data.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore implements Azure Active Directory, and Azure Active Directory Role-Based Access Control (RBAC) to ensure all users have a unique ID.<br /><br />[Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.1.2

**8.1.2** Control addition, deletion, and modification of user IDs, credentials, and other identifier objects.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore implements Azure Active Directory, and Azure Active Directory Role-Based Access Control (RBAC) to ensure all users have a unique ID.<br /><br />[Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.1.3

**8.1.3** Immediately revoke access for any terminated users.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore utilizes Azure Active Directory for user management. Revocation of users can be done in Active directory.|



#### PCI DSS Requirement 8.1.4

**8.1.4** Remove/disable inactive user accounts within 90 days.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore utilizes Azure Active Directory for user management. Revocation of users can be done in Active directory.|



#### PCI DSS Requirement 8.1.5

**8.1.5** Manage IDs used by vendors to access, support, or maintain system components via remote access as follows:
- Enabled only during the time period needed and disabled when not in use.
- Monitored when in use.

**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Microsoft Azure has adopted applicable corporate and organizational security policies, including an Information Security Policy. The policies have been approved, published, and communicated to Microsoft Azure. The Information Security Policy requires that access to Microsoft Azure assets to be granted based on business justification, with the asset owner's authorization and limited based on "need-to-know" and "least-privilege" principles. In addition, the policy also addresses requirements for access management lifecycle including access provisioning, authentication, access authorization, removal of access rights, and periodic access reviews.  |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore demo has implemented Azure Active Directory, and Azure Active Directory Role-Based Access control to manage user access to the installation.<br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.1.6

**8.1.6** Limit repeated access attempts by locking out the user ID after not more than six attempts.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Contoso Webstore has implemented clear seperation of duties (SOD) for all users of the demo. For more information, see ""Azure Active Directory Identity Protection" at [PCI Guidance - Identity Management](reference.md#identity-management).|



#### PCI DSS Requirement 8.1.7

**8.1.7** Set the lockout duration to a minimum of 30 minutes or until an administrator enables the user ID.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Customers are responsible for creating, enforcing, and monitoring a password policy compliant with PCI DSS requirements.|



#### PCI DSS Requirement 8.1.8

**8.1.8** If a session has been idle for more than 15 minutes, require the user to re-authenticate to re-activate the terminal or session.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Customers are responsible for creating, enforcing, and monitoring a password policy compliant with PCI DSS requirements.|



### PCI DSS Requirement 8.2

**8.2** In addition to assigning a unique ID, ensure proper user-authentication management for non-consumer users and administrators on all system components by employing at least one of the following methods to authenticate all users:
- Something you know, such as a password or passphrase
- Something you have, such as a token device or smart card
- Something you are, such as a biometric.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore implementation for multi-factor authentication has been disabled to provide ease of use for the demo. Multi-factor authentication can be implemented using [Azure Multi-Factor Authentication](https://azure.microsoft.com/en-us/services/multi-factor-authentication/).|



#### PCI DSS Requirement 8.2.1

**8.2.1** Using strong cryptography, render all authentication credentials (such as passwords/phrases) unreadable during transmission and storage on all system components.

**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Microsoft Azure has established key management procedures to manage cryptographic keys throughout their lifecycle (e.g., generation, distribution, revocation). Microsoft Azure uses Microsoft's corporate PKI infrastructure. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.2.2

**8.2.2** Verify user identity before modifying any authentication credential—for example, performing password resets, provisioning new tokens, or generating new keys.


**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Microsoft Azure has established key management procedures to manage cryptographic keys throughout their lifecycle (e.g., generation, distribution, revocation). Microsoft Azure uses Microsoft's corporate PKI infrastructure. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.2.3

**8.2.3** Passwords/passphrases must meet the following:
- Require a minimum length of at least seven characters.
- Contain both numeric and alphabetic characters.
Alternatively, the passwords/passphrases must have complexity and strength at least equivalent to the parameters specified above.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.2.4

**8.2.4** Change user passwords/passphrases at least once every 90 days.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.2.5

**8.2.5** Do not allow an individual to submit a new password/passphrase that is the same as any of the last four passwords/passphrases he or she has used.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



#### PCI DSS Requirement 8.2.6

**8.2.6** Set passwords/passphrases for first-time use and upon reset to a unique value for each user, and change immediately after the first use.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all users in Contoso Webstore enforce a strong password requirement, details of the password requirements are documented in the deployment guide. Durring installation strong passwords are enforced. <br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



### PCI DSS Requirement 8.3

**8.3** Secure all individual non-console administrative access and all remote access to the CDE using multi-factor authentication.
> **Note:** Multi-factor authentication requires that a minimum of two of the three authentication methods (see Requirement 8.2 for descriptions of authentication methods) be used for authentication. Using one factor twice (for example, using two separate
passwords) is not considered multi-factor
authentication.


**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Azure administrators are required to use multi-factor authentication to access when performing maintenance and administration to Azure systems and servers. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Cotoso Webstore assigns only two users during the deployment. The users provided are admin, and sqladmin, users are edna, and chris. TFA is not implemented for the demo.|



#### PCI DSS Requirement 8.3.1

**8.3.1** Incorporate multi-factor authentication for all non-console access into the CDE for personnel with administrative access.
> **Note:** This requirement is a best practice until January 31, 2018, after which it becomes a requirement.

**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Azure administrators are required to use multi-factor authentication to access when performing maintenance and administration to Azure systems and servers. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | |



#### PCI DSS Requirement 8.3.2

**8.3.2** Incorporate multi-factor authentication for all remote network access (both user and administrator, and including third-party access for support or maintenance) originating from outside the entity’s network.


**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Azure administrators are required to use multi-factor authentication to access when performing maintenance and administration to Azure systems and servers. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | |



### PCI DSS Requirement 8.4

**8.4** Document and communicate authentication procedures and policies to all users including:
- Guidance on selecting strong authentication credentials
- Guidance for how users should protect their authentication credentials
- Instructions not to reuse previously used passwords
- Instructions to change passwords if there is any suspicion the password could be compromised.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Customers are responsible for following guidance and documenting and communicating authentication procedures and policies to all users.|



### PCI DSS Requirement 8.5

**8.5** Do not use group, shared, or generic IDs, passwords, or other authentication methods as follows:
- Generic user IDs are disabled or removed.
- Shared user IDs do not exist for system administration and other critical functions.
- Shared and generic user IDs are not used to administer any system components.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Cotoso Webstore assigns only two users during the deployment. The users provided are admin, and sqladmin, users are edna, and chris. TFA is not implemented for the demo.|



#### PCI DSS Requirement 8.5.1

**8.5.1** **Additional requirement for service providers only:** Service providers with remote access to customer premises (for example, for support of POS systems or servers) must use a unique authentication credential (such as a password/phrase) for each customer. 
Note: This requirement is not intended to apply to shared hosting providers accessing their own hosting environment, where multiple customer environments are hosted. 

**Responsibilities: `UNKNOWN`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable for Microsoft Azure customers. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | |



### PCI DSS Requirement 8.6

**8.6** Where other authentication mechanisms are used (for example, physical or logical security tokens, smart cards, certificates, etc.), use of these mechanisms must be assigned as follows:
- Authentication mechanisms must be assigned to an individual account and not shared among multiple accounts.
- Physical and/or logical controls must be in place to ensure only the intended account can use that mechanism to gain access.

**Responsibilities: `Shared`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | The Contoso Webstore assigns only two users during the deployment. The users provided are admin, and sqladmin, users are edna, and chris. All access is managed via [Azure Key Vault] (https://azure.microsoft.com/en-us/services/key-vault/), which helps safeguard cryptographic keys and secrets used by cloud applications and services. |



### PCI DSS Requirement 8.7

**8.7** All access to any database containing cardholder data (including access by applications, administrators, and all other users) is restricted as follows:
- All user access to, user queries of, and user actions on databases are through programmatic methods.
- Only database administrators have the ability to directly access or query databases.
- Application IDs for database applications can only be used by the applications (and not by individual users or other non-application processes).

**Responsibilities: `Deployment of all CHD data for Contoso Webstoreis protected with Azure Key Vault, and encryption of records outlined in the deployment documentation.`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Deployment of all CHD data for Contoso Webstoreis protected with Azure Key Vault, and encryption of records outlined in the deployment documentation.<br /><br /><br /><br />Azure Key Vault https://azure.microsoft.com/en-us/services/key-vault/  helps safeguard cryptographic keys and secrets used by cloud applications and services. Stores<br /><br />Keys- SQL DB Column Encryption keys  customer managed keys <br /><br />Secrets - Bitlocker keys for Azure Disk Encryption<br /><br /><br /><br />The Contoso Webstore includes identity management capabilities. For more information, see [PCI Guidance - Identity Management](reference.md#identity-management).<br /><br />|



### PCI DSS Requirement 8.8

**8.8** Ensure that security policies and operational procedures for identification and authentication are documented, in use, and known to all affected parties.

**Responsibilities: `Customer Only`**

|||
|---|---|
| **Microsoft&nbsp;Azure** | Not applicable. |
| **Customer&nbsp;PCI<br />Blueprint&nbsp;(PaaS)** | Customers are responsible for ensuring that security policies and operational procedures for identification and authentication are documented, in use, and known to all affected parties.|




