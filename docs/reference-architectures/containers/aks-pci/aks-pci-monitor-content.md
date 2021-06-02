This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

<insert blurb>

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates <To do add identity blurb>.

## Regularly Monitor and Test Networks

**Requirement 10**&mdash;Track and monitor all access to network resources and cardholder data

|Requirement|Responsibility|
|---|---|
|[Requirement 10.1](#requirement-101)|Implement audit trails to link all access to system components to each individual user.|
|[Requirement 10.2](#requirement-102)|Implement automated audit trails for all system components to reconstruct the following events:|
|[Requirement 10.3](#requirement-103)|Record at least the following audit trail entries for all system components for each event:|
|[Requirement 10.4](#requirement-104)|Using time-synchronization technology, synchronize all critical system clocks and times and ensure that the following is implemented for acquiring, distributing, and storing time. |
|[Requirement 10.5](#requirement-105)|Secure audit trails so they cannot be altered.|
|[Requirement 10.6](#requirement-106)|Review logs and security events for all system components to identify anomalies or suspicious activity.|
|[Requirement 10.7](#requirement-107)|Retain audit trail history for at least one year, with a minimum of three months immediately available for analysis (for example, online, archived, or restorable from backup).|
|[Requirement 10.8](#requirement-108)|Additional requirement for service providers only: Respond to failures of any critical security controls in a timely manner. Processes for responding to failures in security controls must include|
|[Requirement 10.9](#requirement-109)|Ensure that security policies and operational procedures for monitoring all access to network resources and cardholder data are documented, in use, and known to all affected parties.|

### Requirement 10.1

Implement audit trails to link all access to system components to each individual user.

#### Your responsibilities

We recommend that you use these ways to track operations performed on each component. 

- Activity Log. This log provides information about the type and time of the oepration. Also it logs the identity that started the operation. This information is tracked at the subscription level. The are enabled by default and are collected as soon as the resource is provisioned and start emitting logs. 

- Diagnostic setting. Provides diagnostic and auditing information of Azure resources and the platform. We recommend that you enable this for AKS and other components in the system such as Azure Blob Storage and Key Vault. Based on the resource type, you can choose categories of logs and metric data and send it to a destination.

    - Diagnostic setting for AKS. From the provided AKS categories, enable all Kubernetes audit logs. This includes kube-audit, kube-audit-admin, and guard. Enable the kube-audit-admin category to see log data for events; create, update, delete, patch, and post. If you need get and list events, enable kube-audit instead. Be aware that those events can be prolific and add to the cost. This will log access along with identity name used to make the request. Enable guard logs, to track managed Azure AD and Azure RBAC audits. 

    In addition to the audit logs, consider logs from the Kubernetes control plane, including kube-apiserver, kube-controller-manager, and others.

    For more information, see [View the control plane component logs](/azure/aks/view-control-plane-logs).

    This reference implementation enables cluster-autoscaler, kube-controller-manager, kube-audit-admin, and guard logs. All that information is sent to a Log Analytics workspace for analysis. 

    ![AKS diagnostic setting](images/aks-diagnostic-setting.png)

- Azure Kubernetes Service Diagnostics. Use this feature to detect and troubleshoot issues with the cluster, such as node failures. Also included are networking-specific diagnostic data. This feature is available at no additional cost. For information about this features, see [Azure Kubernetes Service Diagnostics](/azure/aks/concepts-diagnostics).

### Requirement 10.2

Implement automated audit trails for all system components to reconstruct the following events:
- 10.2.1 All individual user accesses to cardholder data
- 10.2.2 All actions taken by any individual with root or administrative privileges
- 10.2.3 Access to all audit trails
- 10.2.4 Invalid logical access attempts
- 10.2 5 Use of and changes to identification and authentication mechanisms—including but not limited to creation of new accounts and elevation of privileges—and all changes, additions, or deletions to accounts with root or administrative privileges
- 10.2.6 Initialization, stopping, or pausing of the audit logs
- 10.2.7 Creation and deletion of system-level objects

#### Your responsibilities

AKS provides audit logs at multiple levels, as described in [Requirement 10.1](#requirement-101). Here are some key points:

- By default, Activity logs provides information about all the operations scoped by an Azure subscription. All resource access operations are recorded along with status, time, and the identity that initiated the operation.
- Enable diagnostic settings to access all records of all API calls made into the AKS cluster. The logs provide details about the requestor, timestamp, the source of request, contents of the request. Store the logs in a storage account, such as a Log Analytics workspace.
- Enable Container Insights to get performance-related data from Kubernetes Metrics API. From a diagnostics perspective, set up alerts to reveal suspicious loads and be configured to protect system and data proactively. For information about this feature, see [Container Insights](/azure/azure-monitor/insights/container-insights-overview).
- If your jump boxes support root access, then add additional logging.

### Requirement 10.3

Record at least the following audit trail entries for all system components for each event:
- 10.3.1 User identification
- 10.3.2 Type of event
- 10.3.3 Date and time
- 10.3.4 Success or failure indication
- 10.3.5 Origination of event
- 10.3.6 Identity or name of affected data, system component, or resource.

#### Your responsibilities

As described in [Requirement 10.2](#requirement-102),  you can get audit logs from the cluster by enabling diagnostic setting for AKS. The logs contain detailed information about get, list, create, update, delete, patch, and postevents. The logs contain information in the listed under Requirements. Store the logs in a storage account so that you can query the information.  

For example, you want to view the preceding set of information for kube-audit-admin events by running this query:

`
AzureDiagnostics
| where Category == 'kube-audit-admin' 
| project TimeGenerated, ResourceId, log_s,  pod_s
| top 200 by TimeGenerated desc
`
The result set shows that information as part of the log_s field.

![Diagnostic example](images/aks-diagnostic-example.png)

|Required information| Schema|
|---|---|
|User identification|SourceIPs|
|Type of event|verb|
|Date and time|requestReceivedTimestamp|
|Success or failure indication|responseStatus|
|Origination of event|user|
|Identity or name of affected data, system component, or resource| objectRef|


For information about the master log, see [View the control plane component logs](/azure/aks/view-control-plane-logs)



### Requirement 10.4

Using time-synchronization technology, synchronize all critical system clocks and times and ensure that the following is implemented for acquiring, distributing, and storing time. 

- 10.4.1 Critical systems have the correct and consistent time.
- 10.4.2 Time data is protected.
- 10.4.3 Time settings are received from industry-accepted time sources.

Note: One example of time synchronization technology is Network Time Protocol (NTP).

#### Your responsibilities

AKS requires the use of ntp.ubuntu.org (and its pool). Configure the cluster nodes to synchronize with that source. Don't block that traffic.

### Requirement 10.5

Limit viewing of audit trails to those with a job-related need.
- 10.5.1 Limit viewing of audit trails to those with a job-related need.
- 10.5.2 Protect audit trail files from unauthorized modifications.
- 10.5.3 Promptly back up audit trail files to a centralized log server or media that is difficult to alter.
- 10.5.4 Write logs for external-facing technologies onto a secure, centralized, internal log server or media device.
- 10.5.5 Use file-integrity monitoring or change-detection software on logs to ensure that existing log data cannot be changed without generating alerts (although new data being added should not cause an alert).

#### Your responsibilities

Collect logs from all system components centrally. The advantage is the ability to review, analyze, and query data efficiently. Azure provides several technology options. You can use Azure Monitor for Containers to write logs into a Log Analytics workspace. Another option to integrate data into Security Information and Event Management (SIEM) solutions, such as Azure Sentinel. Other popular third-party choices are Splunk, QRadar, ArcSight. Azure Security Center and Azure Monitor supports all of those solutions. Those solutions are append-only data sinks making sure the trail cannot be altered.

All logs are kept with at least three copies in one region. As a backup strategy, you can have more copies by enabling cross-region backup or replication. All log entries are available only through secured HTTP/S channels.

Log Analytics supports various (role-based access control) RBAC controls that are granular down to the resource level. Use RBAC to manage the resource access policy. Make sure the roles are mapped to the roles and responsibilities of the organization. 

Make sure your Log Analtytics workspace supports both operations and compliance needs. Consider a dedicated workspace for your in-scope clusters, which forwards to your SIEM solution.

Most logging in AKS will come from stdout/stderr.  If you have additional manually-created logs, consider emiting them in a way that would be picked up by the forwarding stream and not be subject to tampering."


### Requirement 10.6

Review logs and security events for all system components to identify anomalies or suspicious activity. 

- 10.6.1  Review the following at least daily:
    - All security events
    - Logs of all system components that store, process, or transmit CHD and/or SAD
    - Logs of all critical system components
    - Logs of all servers and system components that perform security functions (for example, firewalls, intrusion-detection systems/intrusion-prevention systems (IDS/IPS), authentication servers, e-commerce redirection servers, etc.)."
- 10.6.2 Review logs of all other system components periodically based on the organization’s policies and risk management strategy, as determined by the organization’s annual risk assessment.
- 10.6.3 Follow up exceptions and anomalies identified during the review process.

#### Your responsibilities

Azure monitoring services, Azure Monitor, and Azure Security Center, are capable of generating notifications or alerts when anomalous activity is detected. Those alerts include context information such as severity, status, activity time. 

As alerts are generated, have a remediate strategy and review progress. One way is to track secure score in Azure Security Center and comparing against historical results.

Centralize data in a single view using Security Information and Event Management (SIEM) solutions, such as Azure Sentinel. Integrating data can provide rich  alerts context. 

Alternatively, manually check the full log in your storage. For example in Log Analytics, you can use filtering capability based on type of the activity, content of the activity, or caller of the activity.

Have organizational policies to review alerts and events at a regular cadence and plan initiatives with specific improvement goals. 


### Requirement 10.7

Retain audit trail history for at least one year, with a minimum of three months immediately available for analysis (for example, online, archived, or restorable from backup).

#### Your responsibilities

Ensure Azure Activity logs, Diagnostics settings, are retained in queryable state for three months, and data older than that is archived

Logs are not available indefinitely. Ensure Azure Activity logs, diagnostics settings are retained and can be queried. Specify the three-month retention period when you enable diagnostic setting for your resources. Use Azure Storage Accounts for long-term/archival, which can be used for audits or offline analysis. 


### Requirement 10.8

- 10.8.1 Additional requirement for service providers only: Respond to failures of any critical security controls in a timely manner. Processes for responding to failures in security controls must include:

- Restoring security functions
- Identifying and documenting the duration (date and time start to end) of the security failure
- Identifying and documenting cause(s) of failure, including root cause, and documenting
remediation required to address root cause
- Identifying and addressing any security issues that arose during the failure
- Performing a risk assessment to determine whether further actions are required as a result of the security failure
- Implementing controls to prevent cause of failure from reoccurring
-Resuming monitoring of security controls"

#### Your responsibilities
TBD

### Requirement 10.9

Ensure that security policies and operational procedures for monitoring all access to network resources and cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. Maintain documentation about the enforced policies. As part of your monitoring efforts, <TBD> . This is particularly important for people who are part of the approval process from a policy perspective.

**Requirement 11**&mdash;Regularly test security systems and processes
***

## Next

Maintain a policy that addresses information security for all personnel.

> [!div class="nextstepaction"]
> [Maintain an Information Security Policy](aks-pci-policy.yml)