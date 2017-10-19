# Automated Foundational Architecture for NIST 800-53-Compliant Environments


> **Note:** These controls are defined by NIST and the U.S. Department of Commerce as part of the NIST Special Publication 800-53 Revision 4. Please refer to NIST 800-53 Rev. 4 for information on testing procedures and guidance for each control.
    
    

# Maintenance (MA)

## NIST 800-53 Control MA-1

#### System Maintenance Policy and Procedures

**MA-1** The organization develops, documents, and disseminates to [Assignment: organization-defined personnel or roles] a system maintenance policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and procedures to facilitate the implementation of the system maintenance policy and associated system maintenance controls; and reviews and updates the current system maintenance policy [Assignment: organization-defined frequency]; and system maintenance procedures [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance policy and procedures may be sufficient to address this control. <br /> The customer is responsible for developing, documenting, reviewing, updating, and disseminating system maintenance policy and procedures for the customer-deployed resources. The customer control implementation statement should address the content of the policy (which must include purpose, scope, roles, responsibilities, management commitment, coordination, and compliance), procedures (which must facilitate the implementation of the policies and associated controls), the frequency of review, and the role(s) responsible. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-2.a

#### Controlled Maintenance

**MA-2.a** The organization schedules, performs, documents, and reviews records of maintenance and repairs on information system components in accordance with manufacturer or vendor specifications and/or organizational requirements.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for controlled maintenance. The customer control implementation statement should address the scheduling, performing, documenting and reviewing of remote maintenance and repair records for all customer-deployed operating systems in accordance with organizational requirements. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-2.b

#### Controlled Maintenance

**MA-2.b** The organization approves and monitors all maintenance activities, whether performed on site or remotely and whether the equipment is serviced on site or removed to another location.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for controlled maintenance. The customer control implementation statement should address the approval and monitoring of all remote maintenance activities performed on customer-deployed operating systems. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-2.c

#### Controlled Maintenance

**MA-2.c** The organization requires that [Assignment: organization-defined personnel or roles] explicitly approve the removal of the information system or system components from organizational facilities for off-site maintenance or repairs.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ## NIST 800-53 Control MA-2.d

#### Controlled Maintenance

**MA-2.d** The organization sanitizes equipment to remove all information from associated media prior to removal from organizational facilities for off-site maintenance or repairs.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ## NIST 800-53 Control MA-2.e

#### Controlled Maintenance

**MA-2.e** The organization checks all potentially impacted security controls to verify that the controls are still functioning properly following maintenance or repair actions.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for controlled maintenance. The customer control implementation statement should address the  process for identifying potentially impacted security controls and the process used for verifying those controls are still functioning properly following maintenance/repair activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-2.f

#### Controlled Maintenance

**MA-2.f** The organization includes [Assignment: organization-defined maintenance-related information] in organizational maintenance records.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for controlled maintenance. The customer control implementation statement should address the inclusion of customer-defined maintenance-related information in organizational maintenance records. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-2 (2).a

#### Controlled Maintenance | Automated Maintenance Activities

**MA-2 (2).a** The organization employs automated mechanisms to schedule, conduct, and document maintenance and repairs.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for automating maintenance activities. The customer control implementation statement should address how automated mechanisms are used to schedule, conduct, and document maintenance and repairs of customer-deployed operating systems. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-2 (2).b

#### Controlled Maintenance | Automated Maintenance Activities

**MA-2 (2).b** The organization produces up-to date, accurate, and complete records of all maintenance and repair actions requested, scheduled, in process, and completed.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for automating maintenance activities. The customer control implementation statement should address the production of up-to date, accurate, and complete records of all maintenance and repair actions requested, scheduled, in process, and completed for customer-deployed operating systems. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-3

#### Maintenance Tools

**MA-3** The organization approves, controls, and monitors information system maintenance tools.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control MA-3 (1)

#### Maintenance Tools | Inspect Tools

**MA-3 (1)** The organization inspects the maintenance tools carried into a facility by maintenance personnel for improper or unauthorized modifications.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control MA-3 (2)

#### Maintenance Tools | Inspect Media

**MA-3 (2)** The organization checks media containing diagnostic and test programs for malicious code before the media are used in the information system.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control MA-3 (3)

#### Maintenance Tools | Prevent Unauthorized Removal

**MA-3 (3)** The organization prevents the unauthorized removal of maintenance equipment containing organizational information by verifying that there is no organizational information contained on the equipment; sanitizing or destroying the equipment; retaining the equipment within the facility; or obtaining an exemption from [Assignment: organization-defined personnel or roles] explicitly authorizing removal of the equipment from the facility.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ## NIST 800-53 Control MA-4.a

#### Nonlocal Maintenance

**MA-4.a** The organization approves and monitors nonlocal maintenance and diagnostic activities.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing non-local maintenance on customer-deployed operating systems. The customer control implementation statement should address the approval and monitoring of non-local maintenance and diagnostic activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-4.b

#### Nonlocal Maintenance

**MA-4.b** The organization allows the use of nonlocal maintenance and diagnostic tools only as consistent with organizational policy and documented in the security plan for the information system.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing non-local maintenance on customer-deployed operating systems. The customer control implementation statement should address the requirement that non-local maintenance and diagnostic tools are consistent with organizational policy and documented in the security plan. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-4.c

#### Nonlocal Maintenance

**MA-4.c** The organization employs strong authenticators in the establishment of nonlocal maintenance and diagnostic sessions.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing non-local maintenance on customer-deployed operating systems. The customer control implementation statement should address the use of strong authenticators when establishing non-local maintenance and diagnostic sessions. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-4.d

#### Nonlocal Maintenance

**MA-4.d** The organization maintains records for nonlocal maintenance and diagnostic activities.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing non-local maintenance on customer-deployed operating systems. The customer control implementation statement should address the requirement to maintain records for non-local maintenance and diagnostic activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-4.e

#### Nonlocal Maintenance

**MA-4.e** The organization terminates session and network connections when nonlocal maintenance is completed.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing non-local maintenance on customer-deployed operating systems. The customer control implementation statement should address the termination of session and network connections when non-local maintenance is completed. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-4 (2)

#### Nonlocal Maintenance | Document Nonlocal Maintenance

**MA-4 (2)** The organization documents in the security plan for the information system, the policies and procedures for the establishment and use of nonlocal maintenance and diagnostic connections.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for documenting non-local maintenance in the security plan for customer-deployed operating systems. The customer control implementation statement should address the documentation of policies and procedures for the establishment and use of non-local maintenance and diagnostic connections. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-4 (3)

#### Nonlocal Maintenance | Comparable Security / Sanitization

**MA-4 (3)** The organization requires that nonlocal maintenance and diagnostic services be performed from an information system that implements a security capability comparable to the capability implemented on the system being serviced; or removes the component to be serviced from the information system prior to nonlocal maintenance or diagnostic services, sanitizes the component (with regard to organizational information) before removal from organizational facilities, and after the service is performed, inspects and sanitizes the component (with regard to potentially malicious software) before reconnecting the component to the information system.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for performing all non-local maintenance of customer-deployed operating systems from an information system that has comparable security. The customer control implementation statement should address the security capabilities of information systems used to perform non-local maintenance and diagnostic services. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-4 (6)

#### Nonlocal Maintenance | Cryptographic Protection

**MA-4 (6)** The information system implements cryptographic mechanisms to protect the integrity and confidentiality of nonlocal maintenance and diagnostic communications.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for implementing cryptographic mechanisms when performing non-local maintenance and diagnostics of customer-deployed operating systems. The customer control implementation statement should address the cryptographic mechanisms used to protect the integrity and confidentiality of non-local maintenance and diagnostic communications. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-5.a

#### Maintenance Personnel

**MA-5.a** The organization establishes a process for maintenance personnel authorization and maintains a list of authorized maintenance organizations or personnel.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance personnel authorization and escort processes may be sufficient to address this control. <br /> The customer is responsible for managing maintenance personnel. The customer control implementation statement should address the process for authorizing maintenance personnel and maintaining a list of authorized maintenance organizations/personnel. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-5.b

#### Maintenance Personnel

**MA-5.b** The organization ensures that non-escorted personnel performing maintenance on the information system have required access authorizations.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance personnel authorization and escort processes may be sufficient to address this control. <br /> The customer is responsible for managing maintenance personnel. The customer control implementation statement should address the requirement that non-escorted personnel performing maintenance on customer-deployed operating systems have the required access authorizations. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-5.c

#### Maintenance Personnel

**MA-5.c** The organization designates organizational personnel with required access authorizations and technical competence to supervise the maintenance activities of personnel who do not possess the required access authorizations.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance personnel authorization and escort processes may be sufficient to address this control. <br /> The customer is responsible for managing maintenance personnel. The customer control implementation statement should address the designation of organizational personnel with required access authorizations and technical competence to supervise the maintenance activities of personnel who do not possess the required access authorizations. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-5 (1).a

#### Maintenance Personnel | Individuals Without Appropriate Access

**MA-5 (1).a** The organization implements procedures for the use of maintenance personnel that lack appropriate security clearances or are not U.S. citizens, that include the following requirements maintenance personnel who do not have needed access authorizations, clearances, or formal access approvals are escorted and supervised during the performance of maintenance and diagnostic activities on the information system by approved organizational personnel who are fully cleared, have appropriate access authorizations, and are technically qualified; prior to initiating maintenance or diagnostic activities by personnel who do not have needed access authorizations, clearances or formal access approvals, all volatile information storage components within the information system are sanitized and all nonvolatile storage media are removed or physically disconnected from the system and secured.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance personnel authorization and escort processes may be sufficient to address this control. <br /> The customer is responsible for managing the use of maintenance personnel that lack appropriate security clearances or are not U.S. citizens. The customer control implementation statement should address the following requirements regarding maintenance personnel who do not have needed access authorizations, clearances, or formal access approvals: such personnel are escorted and supervised during maintenance and diagnostic activities on customer-deployed operating systems by approved organizational personnel who are fully cleared, have appropriate access authorizations, and are technically qualified; and all volatile information storage media within customer-deployed operating systems are sanitized and all non-volatile storage media are removed or disconnected from customer-deployed resources and secured prior to such personnel performing maintenance and diagnostic activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control MA-5 (1).b

#### Maintenance Personnel | Individuals Without Appropriate Access

**MA-5 (1).b** The organization develops and implements alternate security safeguards in the event an information system component cannot be sanitized, removed, or disconnected from the system.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level system maintenance personnel authorization and escort processes may be sufficient to address this control. <br /> The customer is responsible for implementing alternate security safeguards for the use of maintenance personnel that lack appropriate security clearances or are not U.S. citizens. The customer control implementation statement should address the safeguards implemented in the event that resources identified MA-05(01).a cannot be sanitized, removed, or disconnected from customer-deployed operating systems. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control MA-6

#### Timely Maintenance

**MA-6** The organization obtains maintenance support and/or spare parts for [Assignment: organization-defined information system components] within [Assignment: organization-defined time period] of failure.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |



