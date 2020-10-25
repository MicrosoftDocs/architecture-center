---
title: Optimize administration of SQL Server instances in on-premises and multi-cloud scenarios by leveraging Azure Arc 
description: Optimize management, maintenance, and monitoring of SQL Server with Azure Arc enabled SQL Server and Azure Arc enabled data services in on-premises and multi-cloud scenarios.
author: githubusername
ms.date: 00/00/0000
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - category
ms.custom: fcp
---

# Optimize administration of SQL Server instances in on-premises and multi-cloud scenarios by leveraging Azure Arc 

This reference architecture illustrates how to leverage Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multi-cloud scenarios.

![Diagram illustrating different scenarios that leverage Azure Arc to optimize administration of SQL Server instances residing on-premises or hosted by third-party cloud providers. The first group of scenarios consists of SQL Server instances running on physical servers or virtual machines. The second group of scenarios comprises on-premises or third-party cloud hosted Kubernetes clusters or Azure Kubernetes Service clusters running on Azure Stack HCI, with Azure Arc data controller serving as an intermediary management layer. All of these scenarios offer integration with a range of Azure services, such as Azure Monitor and Log Analytics, Azure Policy, Azure Security Center and Azure Sentinel.

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Assessing Azure Arc enabled SQL Server configuration, availability, performance, and compliance by using Azure Monitor
- Detecting and remediating security threats targeting Azure Arc enabled SQL Server by using Azure Security Center and Azure Sentinel
- Automating deployment and management of Azure Arc enabled SQL Managed Instance on Azure Arc enabled Kubernetes in on-premises and multi-cloud scenarios
- Automating deployment and management of Azure Arc enabled SQL Managed Instance on Azure Kubernetes Service on Azure Stack HCI 

## Architecture

The architecture consists of the following components and capabilities:

- **[SQL Server][sql-server]**. A data platform that gives you a wide range of choices of development languages, data types, on-premises or cloud environments, and operating systems.
- **[Azure Arc][azure-arc]**. A cloud-based service that extend the Azure Resource Manager-based management model to non-Azure resources including virtual machines (VMs), Kubernetes clusters, and containerized databases. 
- **[Azure Arc enabled servers][azure-arc-enabled-servers]**. A hybrid service that allows you to manage your Windows and Linux machines hosted outside of Azure, on your corporate network or other cloud provider, similar to how you manage native Azure virtual machines. 
- **[Azure Arc enabled SQL Server][azure-arc-enabled-sql-server]**. A part of the Azure Arc enabled servers that extends Azure services to SQL Server instances hosted outside of Azure in the customer’s datacenter, on the edge or in a multi-cloud environment.
- **[Kubernetes][kubernetes-open-source]**. A portable, extensible open-source platform for managing and orchestrating containerized workloads.
- **[Azure Kubernetes Service][azure-kubernetes-service]**. A service that makes it simple to deploy a managed Kubernetes cluster in Azure. 
- **[Azure Stack HCI][azs-hci]**. A hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux operating system (OS) workloads and their storage in a hybrid on-premises environment. A cluster can consist of between 2 and 16 physical nodes.
- **[Azure Kubernetes Service on Azure Stack HCI][azure-kubernetes-service-on-azs-hci]**. An implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale on Azure Stack HCI.
- **[Azure Arc enabled Kubernetes][azure-arc-enabled-kubernetes]**. A hybrid service that allows you to streamline deployment and management of Kubernetes clusters inside or outside of Azure. 
- **[Azure Arc enabled data services][azure-arc-enabled-data-services]**. A hybrid service that makes possible to run Azure data services on-premises, at the edge, and in public clouds using Kubernetes and the infrastructure of your choice.
- **[Azure SQL Managed Instance][sql-managed-instance]**. An intelligent, scalable cloud database service that combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service.
- **[Azure Arc enabled SQL Managed Instance][azure-arc-enabled-sql-managed-instance]**. An Azure SQL data service that can created on the infrastructure of your choice that hosts Azure Arc enabled data services.
- **[Azure Resource Manager][azure-resource-manager]**. Azure Resource Manager is the deployment and management service for Azure. It provides a management layer that enables you to create, update, and delete resources in your Azure account. You use management features, like access control, locks, and tags, to secure and organize your resources after deployment.
- **[Azure Monitor][azure-monitor]**. A cloud-based service that maximizes the availability and performance of applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from Azure and non-Azure locations.
- **[Log Analytics][azure-log-analytics]**. The primary tool in the Azure portal for writing log queries and interactively analyzing their results. 
- **[Azure Sentinel][azure-sentinel]**. A scalable, cloud-native, security information event management (SIEM) and security orchestration automated response (SOAR) solution.
- **[Azure Security Center][azure-security-center]**. A unified infrastructure security management system that strengthens the security posture of your data centers, and provides advanced threat protection across your hybrid workloads.
- **[Azure Backup][azure-backup]**. The Azure Backup service provides simple, secure, and cost-effective solutions to back up your data and recover it from the Microsoft Azure cloud.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Assess, monitor, and optimize performance, availability, compliance, and security of Azure Arc enabled SQL Server instances by leveraging Azure services.

In absence of a consistent, unified operational and management model, administration of individual instances of SQL Server might introduce a significant overhead. In addition, without a proper set of tools, identifying and maintaining the optimally performant, resilient, and secure SQL Server configuration requires advanced skills and continuous efforts. The need to solve these challenges is particularly important as business technology landscape evolves and becomes increasingly complex, with multiple SQL Server instances running on different hardware across on-premises datacenters, multiple public and private clouds, and the edge. 

To address this need, you can use Azure Arc enabled SQL Server instances hosted on physical and virtual machines residing outside of Azure, running Windows or Linux operating system with locally installed Connected Machine agent. The installation of the agent takes place automatically when you register the SQL Server instance with Azure. Azure Arc leverages the agent to establish a logical connection between the non-Azure resource and Azure. By virtue of establishing this connection, a non-Azure resource automatically becomes a hybrid Azure resource, with its own identity represented by an Azure Resource Manager resource ID. Azure Resource Manager serves as the management interface that allows you to create, modify, and delete Azure resources. Once you Arc-enable a non-Azure resource, you can leverage Azure Resource Manager to facilitate implementation of other Azure services that enhance manageability of SQL Server instances. 

> [!NOTE]
> Installation of the Connected Agent is also part of implementation of Azure Arc enabled servers. Effectively, there is no need for its installation when implementing Azure Arc enabled SQL Server on Azure Arc enabled servers.

In particular, with Azure Arc enabled SQL Server, once you satisfy all of the [prerequisites][azure-arc-sql-assess-prereqs], including installation of the Log Analytics agent, you will automatically have the option to use the following Azure functionality:

- On-demand SQL Assessment of Azure Arc enabled SQL Server. The assessment relies on the Log Analytics agent to collect relevant data and upload it to the Log Analytics workspace you designate. With logs uploaded to the workspace, the SQL Server Assessment Log Analytics solution handles data analysis and allows you to review its [results directly in the Azure portal][azure-arc-sql-assess]. Whenever applicable, the solution also provides recommendations regarding potential improvements. The results of the analysis are organized into four categories: assessment quality, security and compliance, availability and continuity, and performance and scalability. The Log Analytics agent scans for updates in regular intervals and automatically uploads them to the Log Analytics workspace to ensure that the results you are reviewing are up-to-date.

> [!NOTE]
> Log Analytics agent is commonly referred to as Microsoft Monitoring Agent (MMA).

- Advanced data security for Azure Arc enabled SQL Server. This functionality helps you detect and remediate security anomalies and threats to Azure Arc enabled SQL Server instances. Just as with the on-demand SQL Assessment, to enable it you need to install the Log Analytics agent on the server hosting the SQL Server instance. You also must enable the Azure Defender feature of Azure Security Center to automatically define the scope of data collection and to analyze it. You can [review results of this analysis in the Azure Security Center][azure-security-center-explore] and, once you [on-board Azure Sentinel][azure-sentinel-onboarding], use it to further investigate security alerts directly in the Azure portal. 

### Automate deployment and management of Azure Arc enabled SQL Managed Instance in on-premises and multi-cloud scenarios.

Azure Arc enabled SQL Managed Instance takes the form of a containerized deployment running on top of Azure Arc enabled data services. To host your deployment, you can use the following options:

- Azure Arc enabled data services on an Azure Arc enabled Kubernetes cluster. Azure Arc enabled Kubernetes supports a wide range of Kubernetes distributions hosted in cloud or on-premises environments on virtual or physical servers. 
- Azure Arc enabled data services on an AKS cluster hosted on an on-premises, physical Azure Stack HCI cluster. 

Both of these options support the equivalent SQL Server-related capabilities, since these capabilities rely on the Azure Arc enabled data services layer. However, when using Azure Stack HCI, you should implement AKS, since this considerably simplifies implementation and management of the Kubernetes infrastructure and its workloads. 

Azure Arc enabled SQL Managed Instance offers [near 100% compatibility][azure-arc-enabled-sql-mi-compatibility] with the latest SQL Server database engine. This facilitates lift and shift migrations of to Azure Arc data services with minimal application and database changes. 

Azure Arc enabled SQL Managed Instance relies on Arc Data Controller to establish and maintain a logical connection to the Azure Resource Manager control plane. The data controller takes the form of a group of pods running within the local Kubernetes or AKS cluster. The pods are responsible for orchestrating SQL Managed Instance management and operational tasks, such as provisioning and deprovisioning, automatic failover, updates, scaling, backups and restores, and monitoring. 

When planning for Azure Arc enabled data services, you need to decide whether the data controller will operate in the [Directly Connected and Indirectly Connected connectivity mode][azure-arc-data-services-connectivity-modes]. Your decision has important implications in regard to the management capabilities and the amount of data being sent to Azure. If the Azure Arc enabled data services are directly connected to Azure, then it becomes possible to manage them by using the standard Azure Resource Manager-based interfaces and tools, including the Azure portal, Azure Command Line Interface (CLI), or Azure Resource Manager templates. If the Azure Arc enabled data services are indirectly connected to Azure, then Azure Resource Manager provides their read-only inventory. Similarly, the Directly Connected mode is necessary if you want to provide Azure Arc enabled data services with support for Azure Active Directory (Azure AD), Azure Role-Based Access Control (RBAC), or integrate them with such Azure services as the Azure Defender, Azure Monitor, or Azure Backup. 

> [!CAUTION]
> The Indirectly Connected connectivity mode requires a minimal amount of data to be delivered to Azure for inventory and billing purposes at least once per month.

While the indirectly connected mode offers somewhat reduced functionality, it allows you to accommodate a range of scenarios that preclude the use of the directly connected mode. This applies, for example, to on-premises data centers that block direct external connectivity due to business or regulatory requirements or out of concerns of external attacks or data exfiltration. It also provides support for edge site locations with no or limited direct connectivity to the Internet.

The common set of capabilities of the Azure Arc enabled SQL Managed Instance include:

- Support for automated updates. Microsoft provides updates to Azure Arc enabled data services via Microsoft Container Registry on a frequent basis, including servicing patches and new features, delivering the experience similar to the one applicable to Azure managed data services. However, you control deployment schedule and cadence. 
- Elastic scale. Container-based architecture inherently supports elastic scale, with limits dependent on the available capacity of your infrastructure. This capability accommodates burst scenarios that have volatile needs, including ingesting and querying data in real time, at any scale, with sub-second response time.
- Self-service provisioning. With Kubernetes-based orchestration, you can provision a database in seconds using either graphical interface or CLI tools.
- Flexible monitoring and management. With Azure Arc enabled SQL Managed Instance, you can collect and analyze logs and telemetry from Kubernetes APIs and implement [local monitoring using Kibana and Grafana dashboards][kubernetes-kibana-grafana]. You also have the ability to provision and manage Azure Arc enabled SQL Managed Instance by using a number of standard SQL Server management tools, including Azure Data Studio, Azure Data CLI, as well as Kubernetes management tools such as helm and kubectl. 

In addition, since Azure Arc enabled SQL Managed Instance runs on Azure Arc enabled Kubernetes or AKS on Azure Stack HCI, you also can leverage their management, security, and compliance capabilities, including:

- Support for [enforcement of run-time policies by using Azure Policy for Kubernetes][arc-enabled-kubrnetes-policy-enforcement] and centralized reporting of the corresponding policy compliance. This allows you, for example to enforce HTTPS ingress in Kubernetes cluster or ensure that containers listen only on allowed ports. 
- Support for [deploying Kubernetes and AKS configurations by using GitOps][arc-enabled-kubernetes-gitops]. GitOps is the practice of automated deployment of code residing in a Git repository. In this scenario, that code describes the desired state of Kubernetes or AKS configuration. You have the option to [enforce specific GitOps-based configurations by using Azure Policy][arc-enabled-kubernetes-gitops-enforce], which also provide centralized reporting of the corresponding policy compliance.

> [!CAUTION]
> Verify that the Azure Arc features you intend to use in your production environment are generally available.

## Architectural excellence

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Cost optimization

- Azure Arc helps minimize or even eliminate the need for an on-premises management and monitoring systems, reducing operational complexity and cost, especially in large, diverse, and distributed environments. This helps offset additional cost associated with some of the Azure Arc-related services. For example, advanced data security for Azure Arc enabled SQL Server instance requires [Azure Defender] functionality of Azure Security Center, which has [pricing implications][azure-defender-pricing]. 

- Containerizing your SQL Server environment by using Azure Arc enabled SQL Managed Instance helps increase workload density and mobility. This facilitates more efficient hardware utilization, which tends to maximize return on investment (ROI) and minimize operational costs, helping accellerate data center consolidation initiatives. 

### Operational excellence

- To perform registration of individual Azure Arc enabled SQL Server instances, you can run interactively [a script available directly from the Azure portal][connect-sql-server-to-azure-arc]. For large-scale deployments, you can [run the same script in the unattended manner][connect-sql-server-to-azure-arc-at-scale], by leveraging an Azure Active Directory service principal.

- To perform on-demand assessment of configuration and health of Azure Arc enabled SQL Server by using Azure Monitor, you have to deploy the Log Analytics agent to the server hosting that SQL Server instance. You can automate this deployment at scale by leveraging the ability to [enable Azure Monitor for VMs for Azure Arc enabled servers][azure-monitor-for-vms].

- On-demand SQL Assessment and Advanced data security are available for SQL Server instances which are not Azure Arc enabled, however Azure Arc simplifies their provisioning and configuration. You can, for example, use the VM extension capability to [automate deployment of the Log Analytics agent][azure-vm-extension-log-analytics-deploy] to servers hosting SQL Server instances.

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [manageability features][azure-arc-sql-mi-manageability]

### Performance efficiency

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [high scalability and performance features][azure-arc-sql-mi-performance]

- When planning for deployment of Azure Arc enabled SQL Managed Instance, you should identify the correct amount of compute, memory, and storage that will be required to run the [Azure Arc data controller][azure-arc-data-controller-sizing] and the intended [SQL managed instance][azure-arc-sql-mi-sizing] server groups. Note, however, that you have the flexibility of extending capacity of the underlying Kubernetes or AKS cluster over time by adding additional compute nodes or storage.

- Kubernetes or AKS offers an abstraction layer over the underlying virtualization stack and hardware. Storage Classes implement such abstraction for storage. At the time of provisioning a pod, you need to decide which storage class should be used for its volumes. Your decision is important from the performance standpoint, since an incorrect choice could result in suboptimal performance. When planning for deployment of Azure Arc enabled SQL Managed Instance, you should take into account a range of factors affecting storage configuration [kubernetes-storage-class-factors] for both [data controller][kubernetes-storage-data-controller] and [database instances][kubernetes-storage-database-instance]. 

### Reliability

- With Azure Arc enabled SQL Managed Instance, planning for storage is also critical from the data resiliency standpoint, since an incorrect choice might introduce the risk of total data loss in the event of a hardware failure. To avoid such risk, you should take into account a range of factors affecting storage configuration [kubernetes-storage-class-factors] for both [data controller][kubernetes-storage-data-controller] and [database instances][kubernetes-storage-database-instance]. 

- With Azure Arc enabled SQL Managed Instance, you can deploy individual databases in either a single pod pattern or a multiple pod pattern. For example, the developer or general purpose pricing tier implements a single pod pattern, while a highly available business critical pricing tier implements a multiple pod pattern.  A highly available Azure SQL managed instance uses Always On Availability Groups to replicate the data from one instance to another either synchronously or asynchronously. 

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for a majority of its [high availability features][azure-arc-sql-mi-ha].

- Azure Arc enabled SQL Managed Instance provides automatic local backups, regardless of the connectivity mode. In the Directly Connected Mode, you additionally have the option of leveraging Azure Backup for off-site long-term backup retention. 

### Security

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [security features][azure-arc-sql-mi-security].

- With Azure Arc enabled SQL Managed Instance, in the Directly Connected Mode, you should provide the data controller with direct access to the Microsoft Container Registry (MCR) to facilitate automatic upgrades and patching. Alternatively, you have the option to import container images from MCR and make them available in a local, private container registry accessible by the data controller.

- The Connected Machine agent communicates outbound to Azure Arc over TCP port 443 using the Transport Layer Security (TLS) protocol. 

- With Azure Arc enabled SQL Managed Instance in the Directly Connected mode, there is no need to open any inbound ports at the perimeter of on-premises data centers. Data controller initiated outbound connectivity in the secure manner over TCP port 443 using the Transport Layer Security (TLS) protocol.

> [!CAUTION]
> To enhance the security of data in transit to Azure, you should [configure servers hosting the SQL Server instances to use Transport Layer Security (TLS) 1.2][server-configure-tls-12].


[architectural-diagram]: images/azure_arc_sql_srvr.png
[architectural-diagram-visio-source]: diagrams/azure_arc_sql_srvr.vsdx
[azure-well-architected-framerwork]: https://docs.microsoft.com/azure/architecture/framework/
[sql-server]: https://docs.microsoft.com/sql/sql-server/
[azure-arc]: https://docs.microsoft.com/azure/azure-arc/
[azure-arc-enabled-servers]: https://docs.microsoft.com/azure/azure-arc/servers/overview
[azure-arc-enabled-sql-server]: https://docs.microsoft.com/sql/sql-server/azure-arc/overview?view=sql-server-ver15
[kubernetes-open-source]: https://docs.microsoft.com/learn/modules/intro-to-kubernetes/2-what-is-kubernetes
[azure-kubernetes-service]: https://docs.microsoft.com/azure/aks/intro-kubernetes
[azs-hci]: https://docs.microsoft.com/azure-stack/hci/overview
[azure-kubernetes-service-on-azs-hci]: https://docs.microsoft.com/azure-stack/aks-hci/overview
[azure-arc-enabled-kubernetes]: https://docs.microsoft.com/azure/azure-arc/kubernetes/overview
[azure-arc-enabled-data-services]: https://docs.microsoft.com/azure/azure-arc/data/overview
[sql-managed-instance]: https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[azure-arc-enabled-sql-managed-instance]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-overview
[azure-resource-manager]: https://docs.microsoft.com/azure/azure-resource-manager/management/overview
[azure-monitor]: https://docs.microsoft.com/azure/azure-monitor/overview
[azure-log-analytics]: https://docs.microsoft.com/azure/azure-monitor/log-query/log-query-overview#what-is-log-analytics
[azure-sentinel]: https://docs.microsoft.com/azure/sentinel/overview
[azure-security-center]: https://docs.microsoft.com/azure/security-center/security-center-introduction
[azure-backup]: https://docs.microsoft.com/azure/backup/backup-overview
[azure-premier-support]: https://azure.microsoft.com/support/plans/premier/
[azure-monitor-for-vms]: https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-enable-policy
[connect-sql-server-to-azure-arc]: https://docs.microsoft.com/sql/sql-server/azure-arc/connect?view=sql-server-ver15
[connect-sql-server-to-azure-arc-at-scale]: https://docs.microsoft.com/sql/sql-server/azure-arc/connect-at-scale?view=sql-server-ver15
[azure-arc-sql-assess-prereqs]: https://docs.microsoft.com/sql/sql-server/azure-arc/assess?view=sql-server-ver15#prerequisites
[azure-arc-sql-assess]: https://docs.microsoft.com/sql/sql-server/azure-arc/assess?view=sql-server-ver15
[azure-security-center-explore]: https://docs.microsoft.com/sql/sql-server/azure-arc/configure-advanced-data-security?view=sql-server-ver15#explore
[azure-sentinel-onboarding]: https://docs.microsoft.com/azure/sentinel/connect-data-sources
[azure-vm-extension-log-analytics-deploy]: https://docs.microsoft.com/sql/sql-server/azure-arc/configure-advanced-data-security?view=sql-server-ver15#install-microsoft-monitoring-agent-mma
[azure-arc-enabled-sql-mi-compatibility]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-overview
[azure-arc-data-services-connectivity-modes]: https://docs.microsoft.com/azure/azure-arc/data/connectivity
[kubernetes-kibana-grafana]: https://docs.microsoft.com/azure/azure-arc/data/monitor-grafana-kibana
[arc-enabled-kubernetes-gitops]: https://docs.microsoft.com/azure/azure-arc/kubernetes/use-gitops-connected-cluster
[arc-enabled-kubernetes-gitops-enforce]: https://docs.microsoft.com/azure/azure-arc/kubernetes/use-azure-policy
[arc-enabled-kubrnetes-policy-enforcement]: https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes?toc=/azure/azure-arc/kubernetes/toc.yml
[azure-defender-pricing]: https://azure.microsoft.com/pricing/details/security-center/
[azure-arc-data-controller-sizing]: https://docs.microsoft.com/azure/azure-arc/data/sizing-guidance#data-controller-sizing-details
[azure-arc-sql-mi-sizing]: https://docs.microsoft.com/azure/azure-arc/data/sizing-guidance#sql-managed-instance-sizing-details
[kubernetes-storage-class-factors]: https://docs.microsoft.com/azure/azure-arc/data/storage-configuration#factors-to-consider-when-choosing-your-storage-configuration
[kubernetes-storage-data-controller]: https://docs.microsoft.com/azure/azure-arc/data/storage-configuration#data-controller-storage-configuration
[kubernetes-storage-database-instance]: https://docs.microsoft.com/azure/azure-arc/data/storage-configuration#database-instance-storage-configuration
[azure-arc-sql-mi-manageability]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-features#RDBMSM
[azure-arc-sql-mi-performance]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-features#RDBMSSP
[azure-arc-sql-mi-ha]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-features#RDBMSHA
[azure-arc-sql-mi-security]: https://docs.microsoft.com/azure/azure-arc/data/managed-instance-features#RDBMSS
[server-configure-tls-12]: https://docs.microsoft.com/azure/azure-arc/servers/agent-overview#transport-layer-security-12-protocol