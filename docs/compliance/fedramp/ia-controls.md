# Automated Foundational Architecture for NIST 800-53-Compliant Environments


> **Note:** These controls are defined by NIST and the U.S. Department of Commerce as part of the NIST Special Publication 800-53 Revision 4. Please refer to NIST 800-53 Rev. 4 for information on testing procedures and guidance for each control.
    
    

# Identification and Authentication (IA)

## NIST 800-53 Control IA-1

#### Identification and Authentication Policy and Procedures

**IA-1** The organization develops, documents, and disseminates to [Assignment: organization-defined personnel or roles] an identification and authentication policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and procedures to facilitate the implementation of the identification and authentication policy and associated identification and authentication controls; and reviews and updates the current Identification and authentication policy [Assignment: organization-defined frequency]; and identification and authentication procedures [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level identification and authentication policy and procedures may be sufficient to address this control. <br /> The customer is responsible for developing, documenting, reviewing, updating, and disseminating identification and authentication policy and procedures for customer-deployed resources. The customer control implementation statement should address the content of the policy (which must include purpose, scope, roles, responsibilities, management commitment, coordination, and compliance), procedures (which must facilitate the implementation of the policies and associated controls), the frequency of review, and the role(s) responsible. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-2

#### Identification and Authentication (Organizational Users)

**IA-2** The information system uniquely identifies and authenticates organizational users (or processes acting on behalf of organizational users).

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Accounts created by this Azure Blueprint have unique identifiers. Built-in accounts with non-unique identifiers are disabled or removed. |


 ### NIST 800-53 Control IA-2 (1)

#### Identification and Authentication (Organizational Users) | Network Access to Privileged Accounts

**IA-2 (1)** The information system implements multifactor authentication for network access to privileged accounts.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for implementing multifactor authentication for network access to privileged accounts. The customer control implementation statement should address privileged account types and how multifactor authentication is enforced. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-2 (2)

#### Identification and Authentication (Organizational Users) | Network Access to Non-Privileged Accounts

**IA-2 (2)** The information system implements multifactor authentication for network access to non-privileged accounts.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for implementing multifactor authentication for network access to non-privileged accounts. The customer control implementation statement should address non-privileged account types and how multifactor authentication is enforced. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-2 (3)

#### Identification and Authentication (Organizational Users) | Local Access to Privileged Accounts

**IA-2 (3)** The information system implements multifactor authentication for local access to privileged accounts.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customer do not have local access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control IA-2 (4)

#### Identification and Authentication (Organizational Users) | Local Access to Non-Privileged Accounts

**IA-2 (4)** The information system implements multifactor authentication for local access to non-privileged accounts.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customer do not have local access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control IA-2 (5)

#### Identification and Authentication (Organizational Users) | Group Authentication

**IA-2 (5)** The organization requires individuals to be authenticated with an individual authenticator when a group authenticator is employed.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | No shared/group accounts are enabled on resources deployed by this Azure Blueprint. |


 ### NIST 800-53 Control IA-2 (8)

#### Identification and Authentication (Organizational Users) | Network Access to Privileged Accounts - Replay Resistant

**IA-2 (8)** The information system implements replay-resistant authentication mechanisms for network access to privileged accounts.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Access to resources deployed by this Azure Blueprint is protected from replay attacks by the built-in Kerberos functionality of Azure Active Directory, Active Directory, and the Windows operating system. In Kerberos authentication, the authenticator sent by the client contains additional data, such as an encrypted IP list, client timestamps, and ticket lifetime. If a packet is replayed, the timestamp is checked. If the timestamp is earlier than, or the same as a previous authenticator, the packet is rejected. |


 ### NIST 800-53 Control IA-2 (9)

#### Identification and Authentication (Organizational Users) | Network Access to Non-Privileged Accounts - Replay Resistant

**IA-2 (9)** The information system implements replay-resistant authentication mechanisms for network access to non-privileged accounts.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Access to resources deployed by this Azure Blueprint is protected from replay attacks by the built-in Kerberos functionality of Azure Active Directory, Active Directory, and the Windows operating system. In Kerberos authentication, the authenticator sent by the client contains additional data, such as an encrypted IP list, client timestamps, and ticket lifetime. If a packet is replayed, the timestamp is checked. If the timestamp is earlier than, or the same as a previous authenticator, the packet is rejected. |


 ### NIST 800-53 Control IA-2 (11)

#### Identification and Authentication (Organizational Users) | Remote Access  - Separate Device

**IA-2 (11)** The information system implements multifactor authentication for remote access to privileged and non-privileged accounts such that one of the factors is provided by a device separate from the system gaining access and the device meets [Assignment: organization-defined strength of mechanism requirements].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for implementing multifactor authentication to access customer-deployed resources remotely. The customer control implementation statement should address how multifactor authentication is implemented for remote access, the requirement that one of the factors is provided by a device separate from the customer-deployed resources gaining access, and the customer-defined strength of mechanism requirements for the separate device. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-2 (12)

#### Identification and Authentication (Organizational Users) | Acceptance of Piv Credentials

**IA-2 (12)** The information system accepts and electronically verifies Personal Identity Verification (PIV) credentials.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for accepting and verifying Personal Identity Verification (PIV) credentials. The customer control implementation statement should address the mechanisms for accepting and verifying PIV credentials. Note: if the customer does not deploy PIV credentials this control is not applicable. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-3

#### Device Identification and Authentication

**IA-3** The information system uniquely identifies and authenticates [Assignment: organization-defined specific and/or types of devices] before establishing a [Selection (one or more): local; remote; network] connection.

**Responsibilities:** `Shared`

|||
|---|---|
| **Customer** | The customer is responsible for implementing device identification and authentication. The customer control implementation statement should address customer-defined specific and/or types of devices and connections, as well as how devices are uniquely identified and authenticated prior to establishing a connection.  |
| **Provider (Microsoft Azure)** | Future Availability |


 ## NIST 800-53 Control IA-4.a

#### Identifier Management

**IA-4.a** The organization manages information system identifiers by receiving authorization from [Assignment: organization-defined personnel or roles] to assign an individual, group, role, or device identifier.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for managing  identifiers (i.e., individuals, groups, roles, and devices) for customer resources. The customer control implementation statement should address the requirement that authorization is provided by customer-defined personnel/roles prior to assigning identifiers.   |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-4.b

#### Identifier Management

**IA-4.b** The organization manages information system identifiers by selecting an identifier that identifies an individual, group, role, or device.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint prompts during deployment for customer-specified identifiers for individual accounts.  |


 ## NIST 800-53 Control IA-4.c

#### Identifier Management

**IA-4.c** The organization manages information system identifiers by assigning the identifier to the intended individual, group, role, or device.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for managing  identifiers (i.e., individuals, groups, roles, and devices) for customer resources. The customer control implementation statement should address the assignment of identifiers.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-4.d

#### Identifier Management

**IA-4.d** The organization manages information system identifiers by preventing reuse of identifiers for [Assignment: organization-defined time period].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Active Directory and local Windows operating system accounts are assigned a unique security identifier (SID). Azure Active Directory accounts are assigned a globally unique Object ID. These unique IDs are not subject to reuse. |


 ## NIST 800-53 Control IA-4.e

#### Identifier Management

**IA-4.e** The organization manages information system identifiers by disabling the identifier after [Assignment: organization-defined time period of inactivity].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements a scheduled task for Active Directory to automatically disable accounts after 35 days of inactivity. |


 ### NIST 800-53 Control IA-4 (4)

#### Identifier Management | Identify User Status

**IA-4 (4)** The organization manages individual identifiers by uniquely identifying each individual as [Assignment: organization-defined characteristic identifying individual status].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Azure Active Directory and Active Directory support denoting contractors, vendors, and other user types using naming conventions applied to their identifiers. |


 ## NIST 800-53 Control IA-5.a

#### Authenticator Management

**IA-5.a** The organization manages information system authenticators by verifying, as part of the initial authenticator distribution, the identity of the individual, group, role, or device receiving the authenticator.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for managing authenticators. The customer control implementation statement should address verifying, as part of the initial authenticator distribution, the identity of the individual, group, role, or device receiving the authenticator (e.g., verifying an individual’s identity with a government-issued identification card). |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-5.b

#### Authenticator Management

**IA-5.b** The organization manages information system authenticators by establishing initial authenticator content for authenticators defined by the organization.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All initial authenticator content for accounts created by this Azure Blueprint meet the requirements stated in IA-5 (1) verified when specified by the customer during deployment.  |


 ## NIST 800-53 Control IA-5.c

#### Authenticator Management

**IA-5.c** The organization manages information system authenticators by ensuring that authenticators have sufficient strength of mechanism for their intended use.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Authenticators used by this Azure Blueprint meet requirements for strength as required by FedRAMP. |


 ## NIST 800-53 Control IA-5.d

#### Authenticator Management

**IA-5.d** The organization manages information system authenticators by establishing and implementing administrative procedures for initial authenticator distribution, for lost/compromised or damaged authenticators, and for revoking authenticators.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for managing authenticators. The customer control implementation statement should address the requirement that the customer implements administrative procedures for initial authenticator distribution, for lost/compromised or damaged authenticators, and for revoking authenticators. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-5.e

#### Authenticator Management

**IA-5.e** The organization manages information system authenticators by changing default content of authenticators prior to information system installation.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All authenticators for components of this Azure Blueprint have been changed from their defaults. Authenticators are customer-specified during deployment of this solution. |


 ## NIST 800-53 Control IA-5.f

#### Authenticator Management

**IA-5.f** The organization manages information system authenticators by establishing minimum and maximum lifetime restrictions and reuse conditions for authenticators.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for managing authenticators. The customer control implementation statement should address the establishment of minimum and maximum lifetime restrictions and reuse conditions for authenticators.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control IA-5.g

#### Authenticator Management

**IA-5.g** The organization manages information system authenticators by changing/refreshing authenticators [Assignment: organization-defined time period by authenticator type].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a domain controller to which all deployed virtual machines are joined. A group policy is established and configured to implement password lifetime restrictions (60 days). |


 ## NIST 800-53 Control IA-5.h

#### Authenticator Management

**IA-5.h** The organization manages information system authenticators by protecting authenticator content from unauthorized disclosure and modification.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements Key Vault to protect authenticator content from unauthorized disclosure and modification. The following authenticators are stored in Key Vault: Azure password for deploy account, virtual machine administrator password, SQL Server service account password. |


 ## NIST 800-53 Control IA-5.i

#### Authenticator Management

**IA-5.i** The organization manages information system authenticators by requiring individuals to take, and having devices implement, specific security safeguards to protect authenticators.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements Key Vault to protect authenticator content from unauthorized disclosure and modification. The following authenticators are stored in Key Vault: Azure password for deploy account, virtual machine administrator password, SQL Server service account password. Key Vault encrypts keys and secrets (such as authentication keys, storage account keys, data encryption keys, and passwords) by using keys that are protected by hardware security modules (HSMs). |


 ## NIST 800-53 Control IA-5.j

#### Authenticator Management

**IA-5.j** The organization manages information system authenticators by Changing authenticators for group/role accounts when membership to those accounts changes.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | No shared/group accounts are enabled on resources deployed by this Azure Blueprint. |


 ### NIST 800-53 Control IA-5 (1).a

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).a** The information system, for password-based authentication enforces minimum password complexity of [Assignment: organization-defined requirements for case sensitivity, number of characters, mix of upper-case letters, lower-case letters, numbers, and special characters, including minimum requirements for each type].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a domain controller to which all deployed virtual machines are joined. A group policy is established and configured to enforce password complexity requirements for virtual machine local accounts and AD accounts.  |


 ### NIST 800-53 Control IA-5 (1).b

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).b** The information system, for password-based authentication enforces at least the following number of changed characters when new passwords are created: [Assignment: organization-defined number].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing password-based authentication within customer-deployed resources. The customer control implementation statement should address the customer-defined number of characters to be changed when new passwords are created.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (1).c

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).c** The information system, for password-based authentication stores and transmits only cryptographically-protected passwords.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Azure Directory is used to ensure that all passwords are cryptographically protected while stored and transmitted. Passwords stored by Active Directory and locally on deployed Windows virtual machines are automatically hashed as part of built-in security functionality. Remote desktop authentication sessions are secured using TLS to ensure authenticators are protected when transmitted. |


 ### NIST 800-53 Control IA-5 (1).d

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).d** The information system, for password-based authentication enforces password minimum and maximum lifetime restrictions of [Assignment: organization-defined numbers for lifetime minimum, lifetime maximum].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a domain controller to which all deployed virtual machines are joined. A group policy is established and configured to enforce restrictions on passwords that enforce minimum (1 day) and maximum (60 days) lifetime restrictions for local accounts and AD accounts. |


 ### NIST 800-53 Control IA-5 (1).e

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).e** The information system, for password-based authentication prohibits password reuse for [Assignment: organization-defined number] generations.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a domain controller to which all deployed virtual machines are joined. A group policy is established and configured to enforce restrictions on reuse conditions (24 passwords) for local accounts and AD accounts. |


 ### NIST 800-53 Control IA-5 (1).f

#### Authenticator Management | Password-Based Authentication

**IA-5 (1).f** The information system, for password-based authentication allows the use of a temporary password for system logons with an immediate change to a permanent password.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Azure Active Directory is used to manage control access to the information system. Whenever an account is initially created, or a temporary password is generated, Azure Active Directory is employed to require that the user change the password at the next login. |


 ### NIST 800-53 Control IA-5 (2).a

#### Authenticator Management | Pki-Based Authentication

**IA-5 (2).a** The information system, for PKI-based authentication validates certifications by constructing and verifying a certification path to an accepted trust anchor including checking certificate status information.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing PKI-based authentication within customer-deployed resources. The customer control implementation statement should address the requirement to validate certifications by constructing and verifying a certification path to an accepted trust anchor, including checking certificate status information. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (2).b

#### Authenticator Management | Pki-Based Authentication

**IA-5 (2).b** The information system, for PKI-based authentication enforces authorized access to the corresponding private key.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing PKI-based authentication within customer-deployed resources. The customer control implementation statement should address the enforcement of authorized access to private keys.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (2).c

#### Authenticator Management | Pki-Based Authentication

**IA-5 (2).c** The information system, for PKI-based authentication maps the authenticated identity to the account of the individual or group.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing PKI-based authentication within customer-deployed resources. The customer control implementation statement should address the mapping of each authenticated identity to the account of the corresponding individual or group. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (2).d

#### Authenticator Management | Pki-Based Authentication

**IA-5 (2).d** The information system, for PKI-based authentication implements a local cache of revocation data to support path discovery and validation in case of inability to access revocation information via the network.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing PKI-based authentication within customer-deployed resources. The customer control implementation statement should address the implementation of a local cache of private key data to support path discovery and validation when unable to access this information via the network. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (3)

#### Authenticator Management | in-Person or Trusted Third-Party Registration

**IA-5 (3)** The organization requires that the registration process to receive [Assignment: organization-defined types of and/or specific authenticators] be conducted [Selection: in person; by a trusted third party] before [Assignment: organization-defined registration authority] with authorization by [Assignment: organization-defined personnel or roles].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for registering authenticators. The customer control implementation statement should address the types of and/or specific authenticators requiring in-person registration, customer-defined registration authority, and personnel/roles assigned to authorize registration.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (4)

#### Authenticator Management | Automated Support  for Password Strength Determination

**IA-5 (4)** The organization employs automated tools to determine if password authenticators are sufficiently strong to satisfy [Assignment: organization-defined requirements].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | User accounts deployed with this Azure Blueprint include AD and local user accounts. Both of these provide mechanisms that force compliance with established password requirements in order to create an initial password and during password changes. Azure Active Directory is the automated tool employed to determine if password authenticators are sufficiently strong to satisfy the password length, complexity, rotation, and lifetime restrictions established in IA-5 (1). Azure Active Directory ensures that password authenticator strength at creation meets these standards. Customer-specified passwords used to deploy this solution are checked to meet password strength requirements. |


 ### NIST 800-53 Control IA-5 (6)

#### Authenticator Management | Protection of Authenticators

**IA-5 (6)** The organization protects authenticators commensurate with the security category of the information to which use of the authenticator permits access.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for protecting authenticators. The customer control implementation statement should address the mechanisms used to protect authenticators commensurate with the security category of the information to be accessed. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (7)

#### Authenticator Management | No Embedded Unencrypted Static Authenticators

**IA-5 (7)** The organization ensures that unencrypted static authenticators are not embedded in applications or access scripts or stored on function keys.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | There is no use of unencrypted static authenticators embedded in applications, access scripts, or function keys deployed by this Azure Blueprint. Any script or application that uses an authenticator makes a call to an Azure Key Vault container prior to each use. Access to Azure Key Vault containers is audited, which allows detection of violations of this prohibition if a service account is used to access a system without a corresponding call to the Azure Key Vault container. |


 ### NIST 800-53 Control IA-5 (8)

#### Authenticator Management | Multiple Information System Accounts

**IA-5 (8)** The organization implements [Assignment: organization-defined security safeguards] to manage the risk of compromise due to individuals having accounts on multiple information systems.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level security safeguards to manage risk associated with individuals having accounts on multiple systems. <br /> The customer is responsible for managing the risk imposed by users with multiple accounts on customer-deployed resources. The customer control implementation statement should address the security safeguards used to manage the risk of compromise due to individuals having accounts on multiple information systems (e.g., having different authenticators on all systems, employing some form of single sign-on mechanism, or including some form of one-time passwords on all systems). |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (11)

#### Authenticator Management | Hardware Token-Based Authentication

**IA-5 (11)** The information system, for hardware token-based authentication, employs mechanisms that satisfy [Assignment: organization-defined token quality requirements].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing mechanisms to satisfy hardware token-based authentication quality requirements. The customer control implementation statement should address the customer-defined quality requirements in place. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-5 (13)

#### Authenticator Management | Expiration of Cached Authenticators

**IA-5 (13)** The information system prohibits the use of cached authenticators after [Assignment: organization-defined time period].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | No resources deployed by this Azure Blueprint are configured to allow the use of cached authenticators. Authentication to deployed virtual machines requires that an authenticator is entered at the time of authentication. |


 ## NIST 800-53 Control IA-6

#### Authenticator Feedback

**IA-6** The information system obscures feedback of authentication information during the authentication process to protect the information from possible exploitation/use by unauthorized individuals.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Access to resources deployed by this Azure Blueprint is through Remote Desktop and relies on Windows authentication. The default behavior of Windows authentication sessions masks passwords when input during an authentication session.  |


 ## NIST 800-53 Control IA-7

#### Cryptographic Module Authentication

**IA-7** The information system implements mechanisms for authentication to a cryptographic module that meet the requirements of applicable federal laws, Executive Orders, directives, policies, regulations, standards, and guidance for such authentication.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Windows authentication, remote desktop, and BitLocker are employed by this Azure Blueprint. These components can be configured to rely on FIPS 140 validated cryptographic modules. |


 ## NIST 800-53 Control IA-8

#### Identification and Authentication (Non-Organizational Users)

**IA-8** The information system uniquely identifies and authenticates non-organizational users (or processes acting on behalf of non-organizational users).

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for identifying and authenticating non-organizational users accessing customer-deployed resources. The customer control implementation statement should address how non-organizational users (or processes acting on their behalf) are uniquely identified and authenticated (e.g., database for non-organizational users to log into a web application). |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-8 (1)

#### Identification and Authentication (Non-Organizational Users) | Acceptance of Piv Credentials From Other Agencies

**IA-8 (1)** The information system accepts and electronically verifies Personal Identity Verification (PIV) credentials from other federal agencies.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for accepting and verifying Personal Identity Verification (PIV) credentials issued by other federal agencies. The customer control implementation statement should address the mechanisms for accepting and verifying PIV credentials that have been issued by other government agencies. Note: if the customer does not deploy PIV credentials this control is not applicable. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-8 (2)

#### Identification and Authentication (Non-Organizational Users) | Acceptance of Third-Party Credentials

**IA-8 (2)** The information system accepts only FICAM-approved third-party credentials.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for only accepting third-party credentials that have been approved by the Federal Identity, Credential, and Access Management (FICAM) Trust Framework Solutions initiative. The customer control implementation statement should address the mechanisms for accepting FICAM-approved credentials. Note: if the customer’s deployed resources do not allow third-party credentials this control is not applicable. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-8 (3)

#### Identification and Authentication (Non-Organizational Users) | Use of Ficam-Approved Products

**IA-8 (3)** The organization employs only FICAM-approved information system components in [Assignment: organization-defined information systems] to accept third-party credentials.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for employing only Federal Identity, Credential, and Access Management (FICAM) Trust Framework Solutions initiative approved resources for accepting third-party credentials. The customer control implementation statement should address the resources used in the customer-defined system for accepting FICAM-approved credentials. Note: if the customer’s deployed resources do not allow third-party credentials this control is not applicable. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control IA-8 (4)

#### Identification and Authentication (Non-Organizational Users) | Use of Ficam-Issued Profiles

**IA-8 (4)** The information system conforms to FICAM-issued profiles.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for conforming to the profiles issued by the Federal Identity, Credential, and Access Management (FICAM) Trust Framework Solutions initiative. The customer control implementation statement should address how customer deployed resources conform to FICAM-issued profiles. Note: if the customer’s deployed resources do not allow third-party credentials this control is not applicable. |
| **Provider (Microsoft Azure)** | Not Applicable |



