# Automated Foundational Architecture for NIST 800-53-Compliant Environments


> **Note:** These controls are defined by NIST and the U.S. Department of Commerce as part of the NIST Special Publication 800-53 Revision 4. Please refer to NIST 800-53 Rev. 4 for information on testing procedures and guidance for each control.
    
    

# Contingency Planning (CP)

## NIST 800-53 Control CP-1

#### Contingency Planning Policy and Procedures

**CP-1** The organization develops, documents, and disseminates to [Assignment: organization-defined personnel or roles] a contingency planning policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and procedures to facilitate the implementation of the contingency planning policy and associated contingency planning controls; and reviews and updates the current contingency planning policy [Assignment: organization-defined frequency]; and contingency planning procedures [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level contingency planning policy and procedures may be sufficient to address this control. <br /> The customer is responsible for developing, documenting, reviewing, updating, and disseminating contingency planning policy and procedures for customer-deployed resources. The customer control implementation statement should address the content of the policy (which must include purpose, scope, roles, responsibilities, management commitment, coordination, and compliance), procedures (which must facilitate the implementation of the policies and associated controls), the frequency of review, and the role(s) responsible. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.a

#### Contingency Plan

**CP-2.a** The organization develops a contingency plan for the information system that identifies essential missions and business functions and associated contingency requirements; provides recovery objectives, restoration priorities, and metrics; addresses contingency roles, responsibilities, assigned individuals with contact information; addresses maintaining essential missions and business functions despite an information system disruption, compromise, or failure; addresses eventual, full information system restoration without deterioration of the security safeguards originally planned and implemented; and is reviewed and approved by [Assignment: organization-defined personnel or roles].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for developing a contingency plan for customer-deployed resources. The customer control implementation statement should address the essential mission and business functions and associated contingency requirements; recovery objectives, restoration priorities and metrics; contact information for assigned roles/responsibilities/individuals; maintaining essential mission and business functions despite system disruption, compromise or failure;  eventual, full system restoration without deterioration of originally implemented security safeguards; and review/approval of the plan by customer-defined personnel/roles. Note: the customer should also include any reliance on Microsoft Azure functionality to perform these tasks. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.b

#### Contingency Plan

**CP-2.b** The organization distributes copies of the contingency plan to [Assignment: organization-defined key contingency personnel (identified by name and/or by role) and organizational elements].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for distributing the contingency plan. The customer control implementation statement should address the key personnel (identified by name and/or role) and customer elements who should receive a copy of the contingency plan defined in CP-02.a. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.c

#### Contingency Plan

**CP-2.c** The organization coordinates contingency planning activities with incident handling activities.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for coordinating contingency planning with incident handling. The customer control implementation statement should address the process in which planned contingency activities are coordinated with incident handling activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.d

#### Contingency Plan

**CP-2.d** The organization reviews the contingency plan for the information system [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for reviewing the contingency plan. The customer control implementation statement should address the frequency with which the contingency plan is reviewed. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.e

#### Contingency Plan

**CP-2.e** The organization updates the contingency plan to address changes to the organization, information system, or environment of operation and problems encountered during contingency plan implementation, execution, or testing.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for updating the contingency plan. The customer control implementation statement should address how updates reflect changes to the organization, resources, or environment of operation; and the problems encountered during implementation, execution, or testing of contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.f

#### Contingency Plan

**CP-2.f** The organization communicates contingency plan changes to [Assignment: organization-defined key contingency personnel (identified by name and/or by role) and organizational elements].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for communicating changes made to the contingency plan. The customer control implementation statement should address the means by which the customer communicates changes to the key personnel defined in CP-02.b. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-2.g

#### Contingency Plan

**CP-2.g** The organization protects the contingency plan from unauthorized disclosure and modification.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for protecting the contingency plan. The customer control implementation statement should address the process for preventing unauthorized disclosure or modification of the plan. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (1)

#### Contingency Plan | Coordinate With Related Plans

**CP-2 (1)** The organization coordinates contingency plan development with organizational elements responsible for related plans.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level contingency plan coordination. <br /> The customer is responsible for coordinating contingency plan development with organizational elements responsible for related plans (e.g., business continuity, disaster recovery). The customer control implementation statement should address the coordination of initial plan development, as well as how updates to the contingency plan affect related plans and vice versa. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (2)

#### Contingency Plan | Capacity Planning

**CP-2 (2)** The organization conducts capacity planning so that necessary capacity for information processing, telecommunications, and environmental support exists during contingency operations.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level capacity planning. <br /> The customer is responsible for conducting capacity planning to ensure customer-deployed resources continue operating during contingency activities. The customer control implementation statement should address how the necessary capacity is available for processing, telecommunications, and environmental support  during contingency operations. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support continued system operation during contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (3)

#### Contingency Plan | Resume Essential Missions / Business Functions

**CP-2 (3)** The organization plans for the resumption of essential missions and business functions within [Assignment: organization-defined time period] of contingency plan activation.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level organization-wide contingency planning for essential missions and business functions. <br /> The customer is responsible for resuming essential mission and business functions once contingency activities have commenced. The customer control implementation statement should address the time period within which essential mission and business functions must resume after contingency plan activation. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support continued system operation during contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (4)

#### Contingency Plan | Resume All Missions / Business Functions

**CP-2 (4)** The organization plans for the resumption of all missions and business functions within [Assignment: organization-defined time period] of contingency plan activation.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level organization-wide contingency planning. <br /> The customer is responsible for resuming all mission and business functions once contingency activities have commenced. The customer control implementation statement should address the time period within which all mission and business functions must resume after contingency plan activation. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support continued system operation during contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (5)

#### Contingency Plan | Continue  Essential Missions / Business Functions

**CP-2 (5)** The organization plans for the continuance of essential missions and business functions with little or no loss of operational continuity and sustains that continuity until full information system restoration at primary processing and/or storage sites.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level organization-wide contingency planning for essential missions and business functions. <br /> The customer is responsible for continuing essential mission and business functions until customer-deployed resources have been restored at primary sites. The customer control implementation statement should address how the customer continues essential mission and business functions with little or no loss of operational continuity and sustains that continuity until full resource restoration has occurred at primary processing and/or storage sites. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support continued system operation during contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-2 (8)

#### Contingency Plan | Identify Critical Assets

**CP-2 (8)** The organization identifies critical information system assets supporting essential missions and business functions.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level organization-wide contingency planning to identify critical assets. <br /> The customer is responsible for identifying critical customer-deployed resources. The customer control implementation statement should address any resources that support essential mission and business functions during contingency operations. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-3.a

#### Contingency Training

**CP-3.a** The organization provides contingency training to information system users consistent with assigned roles and responsibilities within [Assignment: organization-defined time period] of assuming a contingency role or responsibility.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level training program may provide contingency training. <br /> The customer is responsible for providing contingency training to users of customer-deployed resources in accordance with assigned roles and responsibilities. The customer control implementation statement should address the time period within which personnel assuming a contingency role/responsibility must be trained. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-3.b

#### Contingency Training

**CP-3.b** The organization provides contingency training to information system users consistent with assigned roles and responsibilities when required by information system changes.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level training program may provide need-based contingency training. <br /> The customer is responsible for providing contingency retraining to users of customer-deployed resources, when changes occur, in accordance with assigned roles and responsibilities. The customer control implementation statement should address the types of changes to customer-deployed resources that necessitate retraining. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-3.c

#### Contingency Training

**CP-3.c** The organization provides contingency training to information system users consistent with assigned roles and responsibilities [Assignment: organization-defined frequency] thereafter.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level training program may provide ongoing contingency training. <br /> The customer is responsible for providing contingency retraining to users of customer-deployed resources, as required, in accordance with assigned roles and responsibilities. The customer control implementation statement should address the customer-defined frequency with which retraining is required. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-3 (1)

#### Contingency Training | Simulated Events

**CP-3 (1)** The organization incorporates simulated events into contingency training to facilitate effective response by personnel in crisis situations.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level contingency training may include simulated events. <br /> The customer is responsible for facilitating effective response by personnel in crisis situations. The customer control implementation statement should address the incorporation of simulated events into contingency training. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-4.a

#### Contingency Plan Testing

**CP-4.a** The organization tests the contingency plan for the information system [Assignment: organization-defined frequency] using [Assignment: organization-defined tests] to determine the effectiveness of the plan and the organizational readiness to execute the plan.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for testing the contingency plan for customer-deployed resources. The customer control implementation statement should address the frequency and tests performed to determine the effectiveness of the contingency plan and the organizational readiness to execute the plan. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-4.b

#### Contingency Plan Testing

**CP-4.b** The organization reviews the contingency plan test results.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for reviewing the results of contingency plan testing (see CP-04.a). The customer control implementation statement should address the process of reviewing contingency plan test results. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-4.c

#### Contingency Plan Testing

**CP-4.c** The organization initiates corrective actions, if needed.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for initiating corrective action regarding contingency plan testing. The customer control implementation statement should address any corrective actions taken upon review of contingency plan test results (see CP-04.b).  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-4 (1)

#### Contingency Plan Testing | Coordinate With Related Plans

**CP-4 (1)** The organization coordinates contingency plan testing with organizational elements responsible for related plans.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on enterprise-level contingency plan testing coordination. <br /> The customer is responsible for coordinating contingency plan testing with the testing of related plans. The customer control implementation statement should address the coordination of contingency plan testing with organizational elements responsible for related plans (e.g., business continuity, disaster recovery). |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-4 (2).a

#### Contingency Plan Testing | Alternate Processing Site

**CP-4 (2).a** The organization tests the contingency plan at the alternate processing site to familiarize contingency personnel with the facility and available resources.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for testing the contingency plan at an alternate processing location. The customer control implementation statement should address how testing familiarizes contingency personnel with the facility and resources available at the alternate site. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support contingency testing and provide continued system operation during contingency activities.
 |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-4 (2).b

#### Contingency Plan Testing | Alternate Processing Site

**CP-4 (2).b** The organization tests the contingency plan at the alternate processing site to evaluate the capabilities of the alternate processing site to support contingency operations.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for testing the contingency plan at an alternate processing location. The customer control implementation statement should address the evaluation of the alternate processing site and its capability to support contingency operations. Note: if the customer configures Microsoft Azure appropriately for reserving processing capacity in an alternate region, Azure can support contingency testing and provide continued system operation during contingency activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-6.a

#### Alternate Storage Site

**CP-6.a** The organization establishes an alternate storage site including necessary agreements to permit the storage and retrieval of information system backup information.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All storage accounts deployed by this Azure Blueprint are replicated to ensure high availability using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region; six copies of all data are maintained on separate nodes across two datacenters. |


 ## NIST 800-53 Control CP-6.b

#### Alternate Storage Site

**CP-6.b** The organization ensures that the alternate storage site provides information security safeguards equivalent to that of the primary site.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All storage accounts deployed by this Azure Blueprint are replicated to ensure high availability using geo-redundant storage (GRS). Physical security controls are implemented uniformly across Azure datacenters. |


 ### NIST 800-53 Control CP-6 (1)

#### Alternate Storage Site | Separation From Primary Site

**CP-6 (1)** The organization identifies an alternate storage site that is separated from the primary storage site to reduce susceptibility to the same threats.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All storage accounts deployed by this Azure Blueprint are replicated to ensure high availability using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region. Primary and secondary regions are paired to ensure necessary distance between datacenters to ensure availability in the event of an area-wide outage or disaster. |


 ### NIST 800-53 Control CP-6 (2)

#### Alternate Storage Site | Recovery Time / Point Objectives

**CP-6 (2)** The organization configures the alternate storage site to facilitate recovery operations in accordance with recovery time and recovery point objectives.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All storage accounts deployed by this Azure Blueprint are replicated to ensure high availability using geo-redundant storage (GRS). GRS ensures that data is replicated to a secondary region. Customers must ensure the Azure data replication model is compatible with contingency objectives. |


 ### NIST 800-53 Control CP-6 (3)

#### Alternate Storage Site | Accessibility

**CP-6 (3)** The organization identifies potential accessibility problems to the alternate storage site in the event of an area-wide disruption or disaster and outlines explicit mitigation actions.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have access to Azure datacenters. |


 ## NIST 800-53 Control CP-7.a

#### Alternate Processing Site

**CP-7.a** The organization establishes an alternate processing site including necessary agreements to permit the transfer and resumption of [Assignment: organization-defined information system operations] for essential missions/business functions within [Assignment: organization-defined time period consistent with recovery time and recovery point objectives] when the primary processing capabilities are unavailable.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. |


 ## NIST 800-53 Control CP-7.b

#### Alternate Processing Site

**CP-7.b** The organization ensures that equipment and supplies required to transfer and resume operations are available at the alternate processing site or contracts are in place to support delivery to the site within the organization-defined time period for transfer/resumption.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. When deploying to an alternate Azure region, equipment provisioning is managed transparently by Azure. |


 ## NIST 800-53 Control CP-7.c

#### Alternate Processing Site

**CP-7.c** The organization ensures that the alternate processing site provides information security safeguards equivalent to those of the primary site.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. Security safeguards are uniformly implemented at Azure datacenters. |


 ### NIST 800-53 Control CP-7 (1)

#### Alternate Processing Site | Separation From Primary Site

**CP-7 (1)** The organization identifies an alternate processing site that is separated from the primary processing site to reduce susceptibility to the same threats.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. Azure datacenters are geographically separated. |


 ### NIST 800-53 Control CP-7 (2)

#### Alternate Processing Site | Accessibility

**CP-7 (2)** The organization identifies potential accessibility problems to the alternate processing site in the event of an area-wide disruption or disaster and outlines explicit mitigation actions.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have access to Azure datacenters. |


 ### NIST 800-53 Control CP-7 (3)

#### Alternate Processing Site | Priority of Service

**CP-7 (3)** The organization develops alternate processing site agreements that contain priority-of-service provisions in accordance with organizational availability requirements (including recovery time objectives).

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. When deploying to an alternate Azure region, resource availability is managed transparently by Azure. |


 ### NIST 800-53 Control CP-7 (4)

#### Alternate Processing Site | Preparation for Use

**CP-7 (4)** The organization prepares the alternate processing site so that the site is ready to be used as the operational site supporting essential missions and business functions.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint contains guidance on how this solution can be deployed simultaneously in multiple regions and configured to provide full redundancy at an alternate processing site. When deploying to an alternate Azure region, physical resource preparation is managed transparently by Azure. |


 ## NIST 800-53 Control CP-8

#### Telecommunications Services

**CP-8** The organization establishes alternate telecommunications services including necessary agreements to permit the resumption of [Assignment: organization-defined information system operations] for essential missions and business functions within [Assignment: organization-defined time period] when the primary telecommunications capabilities are unavailable at either the primary or alternate processing or storage sites.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (1).a

#### Telecommunications Services | Priority of Service Provisions

**CP-8 (1).a** The organization develops primary and alternate telecommunications service agreements that contain priority-of-service provisions in accordance with organizational availability requirements (including recovery time objectives).

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (1).b

#### Telecommunications Services | Priority of Service Provisions

**CP-8 (1).b** The organization requests Telecommunications Service Priority for all telecommunications services used for national security emergency preparedness in the event that the primary and/or alternate telecommunications services are provided by a common carrier.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (2)

#### Telecommunications Services | Single Points of Failure

**CP-8 (2)** The organization obtains alternate telecommunications services to reduce the likelihood of sharing a single point of failure with primary telecommunications services.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (3)

#### Telecommunications Services | Separation of Primary / Alternate Providers

**CP-8 (3)** The organization obtains alternate telecommunications services from providers that are separated from primary service providers to reduce susceptibility to the same threats.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (4).a

#### Telecommunications Services | Provider Contingency Plan

**CP-8 (4).a** The organization requires primary and alternate telecommunications service providers to have contingency plans.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (4).b

#### Telecommunications Services | Provider Contingency Plan

**CP-8 (4).b** The organization reviews provider contingency plans to ensure that the plans meet organizational contingency requirements.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ### NIST 800-53 Control CP-8 (4).c

#### Telecommunications Services | Provider Contingency Plan

**CP-8 (4).c** The organization obtains evidence of contingency testing/training by providers [Assignment: organization-defined frequency].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not control the telecommunications services that provide connectivity for systems in Azure. |


 ## NIST 800-53 Control CP-9.a

#### Information System Backup

**CP-9.a** The organization conducts backups of user-level information contained in the information system [Assignment: organization-defined frequency consistent with recovery time and recovery point objectives].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a Recovery Services Vault. User-level information in the deployed SQL database is implemented using the SQL VM IaaS extension. |


 ## NIST 800-53 Control CP-9.b

#### Information System Backup

**CP-9.b** The organization conducts backups of system-level information contained in the information system [Assignment: organization-defined frequency consistent with recovery time and recovery point objectives].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys a Recovery Services Vault. An Azure Backup policy is established for all virtual machines implementing a daily, weekly, monthly, and yearly backup image retention.  |


 ## NIST 800-53 Control CP-9.c

#### Information System Backup

**CP-9.c** The organization conducts backups of information system documentation including security-related documentation [Assignment: organization-defined frequency consistent with recovery time and recovery point objectives].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for conducting backups of customer-deployed resources (to include applications, operating systems, databases, and software). The customer control implementation statement should address the frequency (to be consistent with customer-defined RTO's and RPO's) with which system documentation information is backed up. Note: if the customer configures Microsoft Azure backup services appropriately, Azure can support data loss prevention. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control CP-9.d

#### Information System Backup

**CP-9.d** The organization protects the confidentiality, integrity, and availability of backup information at storage locations.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Confidentiality and integrity of all storage blobs deployed by this Azure Blueprint are protected through use of Azure SSE, which uses 256-bit AES encryption for all data-at-rest. |


 ### NIST 800-53 Control CP-9 (1)

#### Information System Backup | Testing for Reliability / Integrity

**CP-9 (1)** The organization tests backup information [Assignment: organization-defined frequency] to verify media reliability and information integrity.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Azure Recovery Services Vaults uses online storage; there is no customer backup media within the scope of systems deployed on Azure. |


 ### NIST 800-53 Control CP-9 (2)

#### Information System Backup | Test Restoration Using Sampling

**CP-9 (2)** The organization uses a sample of backup information in the restoration of selected information system functions as part of contingency plan testing.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for testing backup information. The customer control implementation statement should address the use of backup information as part of contingency plan testing. Note: if the customer configures Microsoft Azure backup services appropriately, Azure can support the testing of backup information. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-9 (3)

#### Information System Backup | Separate Storage for Critical Information

**CP-9 (3)** The organization stores backup copies of [Assignment: organization-defined critical information system software and other security-related information] in a separate facility or in a fire-rated container that is not collocated with the operational system.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for separately storing backup information. The customer control implementation statement should address the customer-defined critical information to be stored, and the separation of this data from primary customer-deployed resources (e.g., separate facility or fire-rated container that is not collocated). Note: if the customer configures Microsoft Azure backup services appropriately, Azure can support the protection of backup data. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-9 (5)

#### Information System Backup | Transfer to Alternate Storage Site

**CP-9 (5)** The organization transfers information system backup information to the alternate storage site [Assignment: organization-defined time period and transfer rate consistent with the recovery time and recovery point objectives].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All deployed storage accounts within this Azure Blueprint, including those used for backup, implement geo-redundant storage, ensuring six copies of all data are maintained on separate nodes across two data centers. |


 ## NIST 800-53 Control CP-10

#### Information System Recovery and Reconstitution

**CP-10** The organization provides for the recovery and reconstitution of the information system to a known state after a disruption, compromise, or failure.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for the recovery and reconstitution of customer-deployed resources (to include applications, operating systems, databases, and software). The customer control implementation statement should address the customer's ability to restore the system after a disruption, compromise, or failure. Note: if the customer configures Microsoft Azure backup and/or alternate site processing services appropriately, Azure can support the continued operation of customer-deployed resources. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control CP-10 (2)

#### Information System Recovery and Reconstitution | Transaction Recovery

**CP-10 (2)** The information system implements transaction recovery for systems that are transaction-based.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys SQL Server in an Always On Availability Group. SQL Server maintains a transaction log that supports transaction recovery in the event of a system failure. |


 ### NIST 800-53 Control CP-10 (4)

#### Information System Recovery and Reconstitution | Restore Within Time Period

**CP-10 (4)** The organization provides the capability to restore information system components within [Assignment: organization-defined restoration time-periods] from configuration-controlled and integrity-protected information representing a known, operational state for the components.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for restoring customer-deployed resources to a known operational state. The customer control implementation statement should address the customer-defined time period within which restoration must occur from configuration-controlled and integrity-protected information representing a known, operational state. Note: if the customer configures Microsoft Azure backup and/or alternate site processing services appropriately, Azure can support the continued operation of customer-deployed resources. |
| **Provider (Microsoft Azure)** | Not Applicable |



