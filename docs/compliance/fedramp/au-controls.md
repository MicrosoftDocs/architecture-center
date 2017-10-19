# Automated Foundational Architecture for NIST 800-53-Compliant Environments


> **Note:** These controls are defined by NIST and the U.S. Department of Commerce as part of the NIST Special Publication 800-53 Revision 4. Please refer to NIST 800-53 Rev. 4 for information on testing procedures and guidance for each control.
    
    

# Audit and Accountability (AU)

## NIST 800-53 Control AU-1

#### Audit and Accountability Policy and Procedures

**AU-1** The organization develops, documents, and disseminates to [Assignment: organization-defined personnel or roles] an audit and accountability policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and procedures to facilitate the implementation of the audit and accountability policy and associated audit and accountability controls; and reviews and updates the current audit and accountability policy [Assignment: organization-defined frequency]; and audit and accountability procedures [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer's enterprise-level audit and accountability policy and procedures may be sufficient to address this control. <br /> The customer is responsible for developing, documenting, reviewing, updating, and disseminating audit and accountability policy and procedures. These documents should address the auditing and accountability of the customer-deployed system. The customer control implementation statement should address the content of the policy (which must include purpose, scope, roles, responsibilities, management commitment, coordination, and compliance), procedures (which must facilitate the implementation of the policies and associated controls), the frequency of review, and the role(s) responsible. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control AU-2.a

#### Audit Events

**AU-2.a** The organization determines that the information system is capable of auditing the following events: [Assignment: organization-defined auditable events].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Audit capability for this Azure Blueprint is provided by Azure Monitor and the Log Analytics service in OMS. Azure Monitor provides detailed audit logs about activity associated with deployed resources. These and OS-level logs are collected by Log Analytics and stored in the OMS repository. Log Analytics correlates audit data across resources deployed by this solution and can be extended to the customer-deployed web application. |


 ## NIST 800-53 Control AU-2.b

#### Audit Events

**AU-2.b** The organization coordinates the security audit function with other organizational entities requiring audit-related information to enhance mutual support and to help guide the selection of auditable events.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on an established enterprise-level process that determines auditable events. <br /> The customer is responsible for coordinating with other entities within its organization to guide the selection of auditable events for customer-deployed resources. The customer control implementation statement should address the customer's organizational entities that provide input to the selection of auditable events and the process by which auditable event selection is coordinated. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control AU-2.c

#### Audit Events

**AU-2.c** The organization provides a rationale for why the auditable events are deemed to be adequate to support after-the-fact investigations of security incidents.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Events audited by this Azure Blueprint include information sufficient to determine when events occur, the source of the event, the outcome of the event, and other detailed information that supports investigation of security incidents. |


 ## NIST 800-53 Control AU-2.d

#### Audit Events

**AU-2.d** The organization determines that the following events are to be audited within the information system: [Assignment: organization-defined audited events (the subset of the auditable events defined in AU-2 a.) along with the frequency of (or situation requiring) auditing for each identified event].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Events audited by this Azure Blueprint include those audited by Azure activity logs for deployed resources, OS-level logs, Active Directory logs, and SQL Server logs. Customers may select additional events to be audited to meet mission needs. |


 ### NIST 800-53 Control AU-2 (3)

#### Audit Events | Reviews and Updates

**AU-2 (3)** The organization reviews and updates the audited events [Assignment: organization-defined frequency].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely an established enterprise-level periodic review and update process for the defined set of audited events. <br /> The customer is responsible for reviewing and updating the events defined in AU-02. The customer control implementation statement should address the process and frequency of reviewing and updating the auditable events defined in AU-02. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control AU-3

#### Content of Audit Records

**AU-3** The information system generates audit records containing information that establishes what type of event occurred, when the event occurred, where the event occurred, the source of the event, the outcome of the event, and the identity of any individuals or subjects associated with the event.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint relies on built-in audit capabilities of Azure, Windows Server, and SQL Server. These audit solutions capture audit records with sufficient detail to satisfy the requirements of this control. |


 ### NIST 800-53 Control AU-3 (1)

#### Content of Audit Records | Additional Audit Information

**AU-3 (1)** The information system generates audit records containing the following additional information: [Assignment: organization-defined additional, more detailed information].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Azure Activity Log events use a detailed schema that contains fields for more than 20 types of audit information. In addition to Activity Log, this Azure Blueprint deploys the Log Analytics solution in OMS which supports a diverse set of data sources including Windows logs, Linux logs, Azure Diagnostics logs, and customer logs.  |


 ### NIST 800-53 Control AU-3 (2)

#### Content of Audit Records | Centralized Management of Planned Audit Record Content

**AU-3 (2)** The information system provides centralized management and configuration of the content to be captured in audit records generated by [Assignment: organization-defined information system components].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All virtual machines deployed by this Azure Blueprint are joined to the deployed Active Directory domain. All domain-joined virtual machines implement a group policy that can be configured to centrally manage the OS-level audit system configuration. |


 ## NIST 800-53 Control AU-4

#### Audit Storage Capacity

**AU-4** The organization allocates audit record storage capacity in accordance with [Assignment: organization-defined audit record storage requirements].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint allocates sufficient storage capacity to retain audit records for a period of one year. All audit records are collected by Log Analytics which is configured for one year retention. |


 ## NIST 800-53 Control AU-5.a

#### Response to Audit Processing Failures

**AU-5.a** The information system alerts [Assignment: organization-defined personnel or roles] in the event of an audit processing failure.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Service status for Azure Monitor and Log Analytics is available on the Azure status website and the service health blade in the Azure portal. Alerts can be configured through Log Analytics to provide notification of other types of audit processing failures. |


 ## NIST 800-53 Control AU-5.b

#### Response to Audit Processing Failures

**AU-5.b** The information system takes the following additional actions: [Assignment: organization-defined actions to be taken (e.g., shut down information system, overwrite oldest audit records, stop generating audit records)].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All audit records generated by resources deployed by this Azure Blueprint are collected by Log Analytics and retained for a period of one year. The storage allocation for this audit record storage is dynamically allocated ensuring sufficient capacity is available. |


 ### NIST 800-53 Control AU-5 (1)

#### Response to Audit Processing Failures | Audit Storage Capacity

**AU-5 (1)** The information system provides a warning to [Assignment: organization-defined personnel, roles, and/or locations] within [Assignment: organization-defined time period] when allocated audit record storage volume reaches [Assignment: organization-defined percentage] of repository maximum audit record storage capacity.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | All audit records generated by resources deployed by this Azure Blueprint are collected by Log Analytics and retained for a period of one year. The storage allocation for this audit record storage is dynamically allocated ensuring sufficient capacity is available. |


 ### NIST 800-53 Control AU-5 (2)

#### Response to Audit Processing Failures | Real-Time Alerts

**AU-5 (2)** The information system provides an alert in [Assignment: organization-defined real-time period] to [Assignment: organization-defined personnel, roles, and/or locations] when the following audit failure events occur: [Assignment: organization-defined audit failure events requiring real-time alerts].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Service status for Azure is available on the service health blade in the Azure portal. Alerts can be configured through Log Analytics to provide notification of other types of audit processing failures. |


 ## NIST 800-53 Control AU-6.a

#### Audit Review, Analysis, and Reporting

**AU-6.a** The organization reviews and analyzes information system audit records [Assignment: organization-defined frequency] for indications of [Assignment: organization-defined inappropriate or unusual activity].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for reviewing and analyzing audit records of customer-deployed resources (to include applications, operating systems, databases, and software). The customer control implementation statement should address the frequency at which the audit records are reviewed and analyzed, and the criteria used to identify inappropriate or unusual activity.  |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control AU-6.b

#### Audit Review, Analysis, and Reporting

**AU-6.b** The organization reports findings to [Assignment: organization-defined personnel or roles].

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for reporting findings of inappropriate or unusual activity (defined in AU-06.a) on customer-deployed resources. The customer control implementation statement should address which personnel/roles will be notified of any findings. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control AU-6 (1)

#### Audit Review, Analysis, and Reporting | Process Integration

**AU-6 (1)** The organization employs automated mechanisms to integrate audit review, analysis, and reporting processes to support organizational processes for investigation and response to suspicious activities.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer may rely on an enterprise-level centralized audit review, analysis, and reporting capability. <br /> The customer is responsible for automating the audit review, analysis, and reporting of suspicious activities within customer-deployed resources (to include applications, operating systems, databases, and software). The customer control implementation statement should address the automated mechanisms employed to support investigation and response to suspicious activities. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ### NIST 800-53 Control AU-6 (3)

#### Audit Review, Analysis, and Reporting | Correlate Audit Repositories

**AU-6 (3)** The organization analyzes and correlates audit records across different repositories to gain organization-wide situational awareness.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics solution in OMS to centralize audit data across deployed resources, supporting organization-wide situational awareness. Customers may chose to further integrate Log Analytics with other systems. |


 ### NIST 800-53 Control AU-6 (4)

#### Audit Review, Analysis, and Reporting | Central Review and Analysis

**AU-6 (4)** The information system provides the capability to centrally review and analyze audit records from multiple components within the system.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics solution in OMS to centralize audit data across deployed resources, supporting centralized  review, analysis, and reporting. |


 ### NIST 800-53 Control AU-6 (5)

#### Audit Review, Analysis, and Reporting | Integration / Scanning and Monitoring Capabilities

**AU-6 (5)** The organization integrates analysis of audit records with analysis of [Selection (one or more): vulnerability scanning information; performance data; information system monitoring information; [Assignment: organization-defined data/information collected from other sources]] to further enhance the ability to identify inappropriate or unusual activity.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint deploys the OMS Security and Audit solution. This solution provides a comprehensive view of security posture. The Security and Audit dashboard provides high-level insight into the security state of deployed resources using data available across deployed OMS solutions, integrating log data and vulnerability data from baseline and patch assessment. |


 ### NIST 800-53 Control AU-6 (6)

#### Audit Review, Analysis, and Reporting | Correlation With Physical Monitoring

**AU-6 (6)** The organization correlates information from audit records with information obtained from monitoring physical access to further enhance the ability to identify suspicious, inappropriate, unusual, or malevolent activity.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Customers do not have physical access to any system resources in Azure datacenters. |


 ### NIST 800-53 Control AU-6 (7)

#### Audit Review, Analysis, and Reporting | Permitted Actions

**AU-6 (7)** The organization specifies the permitted actions for each [Selection (one or more): information system process; role; user] associated with the review, analysis, and reporting of audit information.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Windows virtual machines deployed by this Azure Blueprint implement OS-level permissions that restrict the actions a user can take with respect audit information. Within Azure, users or groups of users can be assigned to roles (e.g., owner, contributor, reader, or a custom role) to restrict the actions available with respect to any resources or deployed solutions, including Log Analytics.  |


 ### NIST 800-53 Control AU-6 (10)

#### Audit Review, Analysis, and Reporting | Audit Level Adjustment

**AU-6 (10)** The organization adjusts the level of audit review, analysis, and reporting within the information system when there is a change in risk based on law enforcement information, intelligence information, or other credible sources of information.

**Responsibilities:** `Customer Only`

|||
|---|---|
| **Customer** | The customer is responsible for adjusting the level of audit review, analysis, and reporting for customer-deployed resources (to include applications, operating systems, databases, and software) when there is a change in risk based on information provided by law enforcement, intelligence, or other credible sources. The customer control implementation statement should address the ability to scale the audit review process. |
| **Provider (Microsoft Azure)** | Not Applicable |


 ## NIST 800-53 Control AU-7.a

#### Audit Reduction and Report Generation

**AU-7.a** The information system provides an audit reduction and report generation capability that supports on-demand audit review, analysis, and reporting requirements and after-the-fact investigations of security incidents.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics solution in OMS. Log Analytics provides monitoring services for OMS by collecting data from managed resources into a central repository. Once collected, the data is available for alerting, analysis, and export. |


 ## NIST 800-53 Control AU-7.b

#### Audit Reduction and Report Generation

**AU-7.b** The information system provides an audit reduction and report generation capability that does not alter the original content or time ordering of audit records.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics solution in OMS. Log Analytics provides monitoring services for OMS by collecting data from managed resources into a central repository. The content and time ordering of audit records are not altered when collected by Log Analytics. |


 ### NIST 800-53 Control AU-7 (1)

#### Audit Reduction and Report Generation | Automatic Processing

**AU-7 (1)** The information system provides the capability to process audit records for events of interest based on [Assignment: organization-defined audit fields within audit records].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics solution in OMS. Log Analytics provides monitoring services for OMS by collecting data from managed resources into a central repository. Once collected, the data is available for alerting, analysis, and export. Log Analytics includes a powerful query language to extract data stored in the repository. |


 ## NIST 800-53 Control AU-8.a

#### Time Stamps

**AU-8.a** The information system uses internal system clocks to generate time stamps for audit records.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Resources deployed by this Azure Blueprint use internal system clocks to generate time stamps for audit records. |


 ## NIST 800-53 Control AU-8.b

#### Time Stamps

**AU-8.b** The information system records time stamps for audit records that can be mapped to Coordinated Universal Time (UTC) or Greenwich Mean Time (GMT) and meets [Assignment: organization-defined granularity of time measurement].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Resources deployed by this Azure Blueprint use internal system clocks to generate time stamps for audit records. Time stamps are recorded in UTC. |


 ### NIST 800-53 Control AU-8 (1).a

#### Time Stamps | Synchronization With Authoritative Time Source

**AU-8 (1).a** The information system compares the internal information system clocks [Assignment: organization-defined frequency] with [Assignment: organization-defined authoritative time source].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Resources deployed by this Azure Blueprint use internal system clocks to generate time stamps for audit records. Internal system clocks are configured to sync with an authoritative time source. |


 ### NIST 800-53 Control AU-8 (1).b

#### Time Stamps | Synchronization With Authoritative Time Source

**AU-8 (1).b** The information system synchronizes the internal system clocks to the authoritative time source when the time difference is greater than [Assignment: organization-defined time period].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Resources deployed by this Azure Blueprint use internal system clocks to generate time stamps for audit records. Internal system clocks are configured to sync with an authoritative time source. |


 ## NIST 800-53 Control AU-9

#### Protection of Audit Information

**AU-9** The information system protects audit information and audit tools from unauthorized access, modification, and deletion.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Logical access controls are used to protect audit information and tools within this Azure Blueprint from unauthorized access, modification, and deletion. Azure Active Directory enforces approved logical access using role-based group memberships. The ability to view audit information and use auditing tools can be limited to users that require those permissions. |


 ### NIST 800-53 Control AU-9 (2)

#### Protection of Audit Information | Audit Backup on Separate Physical Systems / Components

**AU-9 (2)** The information system backs up audit records [Assignment: organization-defined frequency] onto a physically different system or system component than the system or component being audited.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics service in OMS. Deployed VMs and Azure diagnostics storage accounts are connected sources to Log Analytics and retained separately from their origin. Data is collected by OMS in near real-time. |


 ### NIST 800-53 Control AU-9 (3)

#### Protection of Audit Information | Cryptographic Protection

**AU-9 (3)** The information system implements cryptographic mechanisms to protect the integrity of audit information and audit tools.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics service in OMS. Log Analytics ensures that incoming data is from a trusted source by validating certificates and the data integrity with Azure authentication. |


 ### NIST 800-53 Control AU-9 (4)

#### Protection of Audit Information | Access by Subset of Privileged Users

**AU-9 (4)** The organization authorizes access to management of audit functionality to only [Assignment: organization-defined subset of privileged users].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Logical access controls are used to protect audit information and tools within this Azure Blueprint from unauthorized access, modification, and deletion. Azure Active Directory enforces approved logical access using role-based group memberships. The ability to view audit information and use auditing tools can be limited to users that require those permissions.
 |


 ## NIST 800-53 Control AU-10

#### Non-Repudiation

**AU-10** The information system protects against an individual (or process acting on behalf of an individual) falsely denying having performed [Assignment: organization-defined actions to be covered by non-repudiation].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Audit capability for this Azure Blueprint is provided by Azure Monitor and the Log Analytics service in OMS. Azure Monitor provides detailed audit logs about activity associated with deployed resources. These and OS-level logs are collected by Log Analytics and stored in the OMS repository. These logs contained detailed records of information system events and can help protect against non-repudiation. Further, access to log data is restricted using role-based access control to prevent unauthored modification or deletion of log data. |


 ## NIST 800-53 Control AU-11

#### Audit Record Retention

**AU-11** The organization retains audit records for [Assignment: organization-defined time period consistent with records retention policy] to provide support for after-the-fact investigations of security incidents and to meet regulatory and organizational information retention requirements.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics service in OMS. Log Analytics provides monitoring services for OMS by collecting data from managed resources into a central repository. Once collected, the data retained for one year per Log Analytics configuration. |


 ## NIST 800-53 Control AU-12.a

#### Audit Generation

**AU-12.a** The information system provides audit record generation capability for the auditable events defined in AU-2 a. at [Assignment: organization-defined information system components].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Events audited by this Azure Blueprint include those audited by Azure activity logs for deployed resources, OS-level logs, Active Directory logs, and SQL Server logs. Customers may select additional events to be audited to meet mission needs. |


 ## NIST 800-53 Control AU-12.b

#### Audit Generation

**AU-12.b** The information system allows [Assignment: organization-defined personnel or roles] to select which auditable events are to be audited by specific components of the information system.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Access to audit functions is restricted using role-based access control within Azure and at the virtual machine OS-level. The configuration of events selected to be audited by resources deployed by this Azure Blueprint can be configured by users with appropriate role-based authorization. |


 ## NIST 800-53 Control AU-12.c

#### Audit Generation

**AU-12.c** The information system generates audit records for the events defined in AU-2.d. with the content defined in AU-3.

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Events audited by this Azure Blueprint include those audited by Azure activity logs for deployed resources, OS-level logs, Active Directory logs, and SQL Server logs. Customers may select additional events to be audited to meet mission needs. |


 ### NIST 800-53 Control AU-12 (1)

#### Audit Generation | System-Wide / Time-Correlated Audit Trail

**AU-12 (1)** The information system compiles audit records from [Assignment: organization-defined information system components] into a system-wide (logical or physical) audit trail that is time-correlated to within [Assignment: organization-defined level of tolerance for the relationship between time stamps of individual records in the audit trail].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | This Azure Blueprint implements the Log Analytics service in OMS. Log Analytics provides monitoring services for OMS by collecting data from managed resources into a central repository. Audit record time stamps are not altered, therefore the audit trail is time-correlated. |


 ### NIST 800-53 Control AU-12 (3)

#### Audit Generation | Changes by Authorized Individuals

**AU-12 (3)** The information system provides the capability for [Assignment: organization-defined individuals or roles] to change the auditing to be performed on [Assignment: organization-defined information system components] based on [Assignment: organization-defined selectable event criteria] within [Assignment: organization-defined time thresholds].

**Responsibilities:** `Azure Only`

|||
|---|---|
| **Customer** | Not Applicable |
| **Provider (Microsoft Azure)** | Access to audit functions is restricted using role-based access control within Azure and at the virtual machine OS-level. The configuration of events selected to be audited by resources deployed by this Azure Blueprint can be configured by users with appropriate role-based authorization. |



