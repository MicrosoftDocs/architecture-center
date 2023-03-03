This reference architecture illustrates how to use Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multicloud environments.

## Architecture

[ ![Diagram illustrating different scenarios that leverage Azure Arc to optimize administration of SQL Server instances residing on-premises or hosted by third-party cloud providers. The first group of scenarios consists of SQL Server instances running on physical servers or virtual machines. The second group of scenarios comprises on-premises, third-party cloud hosted Kubernetes clusters, or Azure Kubernetes Service clusters running on Azure Stack HCI, with Azure Arc data controller serving as an intermediary management layer. All of these scenarios offer integration with a range of Azure services, such as Azure Monitor and Log Analytics, Azure Policy, Microsoft Defender for Cloud, and Microsoft Sentinel.](images/administer-sql-server-azure-arc.svg)](images/administer-sql-server-azure-arc.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Components

The architecture consists of the following components and capabilities:

- [SQL Server][sql-server-service-page]. This data platform gives you a wide range of choices of development languages, data types, on-premises or cloud environments, and operating systems.
- [Azure Arc][azure-arc-service-page]. This cloud-based service extends the Azure Resource Manager-based management model to non-Azure resources including virtual machines (VMs), Kubernetes clusters, and containerized databases.
- [Azure Arc enabled servers][azure-arc-enabled-servers-service-page]. This hybrid service allows you to manage your Windows and Linux machines, hosted outside of Azure, on your corporate network or other cloud provider. This is similar to how you manage native Azure VMs.
- [Azure Arc enabled SQL Server][azure-arc-enabled-sql-server-service-page]. This part of the Azure Arc enabled servers extends Azure services to SQL Server instances, hosted outside of Azure in the customer's datacenter, on the edge or in a multicloud environment.
- [Kubernetes][kubernetes-open-source]. This is a portable, extensible open-source platform for managing and orchestrating containerized workloads.
- [Azure Kubernetes Service][azure-kubernetes-service-service-page]. This is a service that makes it simple to deploy a managed Kubernetes cluster in Azure.
- [Azure Stack HCI (20H2)][azs-hci-service-page]. This is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux operating system (OS) workloads and their storage in a hybrid on-premises environment. A cluster consists of two to 16 physical nodes.
- [Azure Kubernetes Service on Azure Stack HCI][azure-kubernetes-service-on-azs-hci-service-page]. This is an implementation of AKS, which automates running containerized applications at scale on Azure Stack HCI.
- [Azure Arc-enabled Kubernetes][azure-arc-enabled-kubernetes-service-page]. This hybrid service allows you to streamline deployment and management of Kubernetes clusters inside or outside of Azure.
- [Azure Arc enabled data services][azure-arc-enabled-data-services-service-page]. This hybrid service makes it possible to run Azure data services on-premises, at the edge, and in public clouds using Kubernetes and the infrastructure of your choice.
- [Azure SQL Managed Instance][sql-managed-instance-service-page]. This intelligent, scalable cloud database service combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service.
- [Azure Arc enabled SQL Managed Instance][azure-arc-enabled-sql-managed-instance-service-page]. This Azure SQL data service can be created on your choice of infrastructure that hosts Azure Arc enabled data services.
- [Azure Resource Manager][azure-resource-manager-service-page]. Azure Resource Manager is the deployment and management service for Azure. It provides a management layer that enables you to create, update, and delete resources in your Azure account. You use management features, like access control, locks, and tags to secure and organize your resources after deployment.
- [Azure Monitor][azure-monitor-service-page]. This cloud-based service maximizes the availability and performance of applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from Azure and non-Azure locations.
- [Log Analytics][azure-log-analytics-service-page]. This is the primary tool in the Azure portal for writing log queries and interactively analyzing their results.
- [Microsoft Sentinel][azure-sentinel-service-page]. This is a scalable, cloud-native, security information event management (SIEM) and security orchestration automated response (SOAR) solution.
- [Microsoft Defender for Cloud][azure-security-center-service-page]. This unified infrastructure security management system strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads.
- [Azure Backup][azure-backup-service-page]. The Azure Backup service provides simple, secure, and cost-effective solutions to back up your data and recover it from the Microsoft Azure cloud.

## Scenario details

Typical uses for this architecture include:

- Assessing Azure Arc enabled SQL Server configuration, availability, performance, and compliance by using Azure Monitor.
- Detecting and remediating security threats targeting Azure Arc enabled SQL Server by using Microsoft Defender for Cloud and Microsoft Sentinel.
- Automating deployment and management of Azure Arc enabled SQL Managed Instance on Azure Arc-enabled Kubernetes in on-premises and multicloud environments.
- Automating deployment and management of Azure Arc enabled SQL Managed Instance on Azure Kubernetes Service (AKS) on Azure Stack HCI.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Assess, monitor, and optimize performance, availability, compliance, and security of Azure Arc enabled SQL Server instances by using Azure services

Without a consistent, unified operational and management model, administering individual instances of SQL Server might lead to significant overhead costs. Without a proper set of tools, you need advanced skills and continuous efforts to identify and maintain the high-performing, resilient, and secure SQL Server configuration. It's particularly important to solve these challenges as the business technology landscape evolves and becomes increasingly complex, with multiple SQL Server instances running on different hardware across on-premises datacenters, multiple public and private clouds, and the edge.
<!--LM: If the Connected Machine agent is referring to Azure, then use Azure Connected Machine Agent as the full term.-->
You can use Azure Arc enabled SQL Server instances, hosted on physical and virtual machines residing outside of Azure, which are running a Windows or Linux operating system with a locally installed Connected Machine agent. The agent installs automatically when you register the SQL Server instance with Azure. Azure Arc uses the agent to establish a logical connection between the non-Azure resource and Azure. After establishing this connection, a non-Azure resource automatically becomes a hybrid Azure resource, with its own identity and an Azure Resource Manager resource ID. Azure Resource Manager serves as the management interface that allows you to create, modify, and delete Azure resources. After you Arc-enable a non-Azure resource, you can use Azure Resource Manager to facilitate the implementation of other Azure services that enhance the manageability of SQL Server instances.

> [!NOTE]
> Installation of the Azure Connected Machine Agent is also part of implementation of Azure Arc enabled servers. Effectively, there is no need for its installation when implementing Azure Arc enabled SQL Server on Azure Arc enabled servers.
<!--LM: Is Connected Agent the same as Azure Connected Machine Agent described later in the document? If not, please revert the edit.-->
 After you satisfy all of the [prerequisites][azure-arc-sql-assess-prereqs] for Azure Arc enabled SQL Server, including the installation of the Log Analytics agent, you'll automatically have the option to use the following Azure functionality:

- On-demand SQL Assessment of Azure Arc enabled SQL Server. The assessment relies on the Log Analytics agent to collect relevant data and upload it to the Log Analytics workspace you designate. With logs uploaded to the workspace, the SQL Server Assessment Log Analytics solution manages data analysis and allows you to review its [results directly in the Azure portal][azure-arc-sql-assess]. Whenever applicable, the solution also provides recommendations regarding potential improvements. The results of the analysis are organized into four categories: assessment quality, security and compliance, availability and continuity, and performance and scalability. The Log Analytics agent scans for updates in regular intervals and automatically uploads them to the Log Analytics workspace to ensure that the results you're reviewing are up to date.

> [!NOTE]
> Log Analytics agent is commonly referred to as Microsoft Monitoring Agent (MMA).

- Advanced data security for Azure Arc enabled SQL Server. This functionality helps you detect and remediate security anomalies and threats to Azure Arc enabled SQL Server instances. Like the on-demand SQL Assessment, to enable Azure Arc enabled SQL Server, you need to install the Log Analytics agent on the server hosting the SQL Server instance. You must also enable the Microsoft Defender for Cloud feature of Microsoft Defender for Cloud to automatically define the scope of data collection and to analyze it. You can [review results of this analysis in the Microsoft Defender for Cloud][azure-security-center-explore] and, after you [onboard Microsoft Sentinel][azure-sentinel-onboarding], use it to further investigate security alerts directly in the Azure portal.

### Automate deployment and management of Azure Arc enabled SQL Managed Instance in on-premises and multicloud environments

Azure Arc enabled SQL Managed Instance becomes a containerized deployment running on top of Azure Arc enabled data services. To host your deployment, you can use the following options: <!--LM: Please check that "becomes" still retains the meaning of the sentence.-->

- Azure Arc enabled data services on an Azure Arc-enabled Kubernetes cluster. Azure Arc-enabled Kubernetes supports a wide range of Kubernetes distributions hosted in cloud or on-premises environments on virtual or physical servers.
- Azure Arc enabled data services on an AKS cluster hosted on an on-premises, physical Azure Stack HCI cluster.

Both options support equivalent SQL Server-related capabilities because these capabilities rely on the Azure Arc enabled data services layer. However, when using Azure Stack HCI, you should implement AKS because this simplifies the implementation and management of the Kubernetes infrastructure and its workloads.

Azure Arc enabled SQL Managed Instance offers [near 100% compatibility][azure-arc-enabled-sql-mi-compatibility] with the latest SQL Server database engine. This facilitates lift and shift migrations to Azure Arc enabled data services with minimal application and database changes.
<!--LM: Please check that "becomes" retains the meaning in the following paragraph.-->
Azure Arc enabled SQL Managed Instance relies on Azure Arc data controller to establish and maintain a logical connection to the Azure Resource Manager control plane. The data controller becomes a group of pods running within the local Kubernetes or AKS cluster. The pods orchestrate SQL Managed Instance management and operational tasks, such as provisioning and deprovisioning, automatic failover, updates, scaling, backup and restoration, and monitoring.

When planning for Azure Arc enabled data services, you need to decide whether the data controller will operate in the [Directly Connected or Indirectly Connected connectivity mode][azure-arc-data-services-connectivity-modes]. Your decision has important implications for the management capabilities and the amount of data being sent to Azure. If the Azure Arc enabled data services are directly connected to Azure, then you can manage them by using the standard Azure Resource Manager-based interfaces and tools, including the Azure portal, Azure Command-Line Interface (Azure CLI), or Azure Resource Manager templates. If the Azure Arc enabled data services are indirectly connected to Azure, then Azure Resource Manager provides their read-only inventory. Similarly, the Directly Connected mode is necessary if you want to provide Azure Arc enabled data services with support for Azure Active Directory (Azure AD), Azure role-based access control (Azure RBAC), or integrate them with such Azure services as Microsoft Defender for Cloud, Azure Monitor, or Azure Backup.

> [!CAUTION]
> The Indirectly Connected connectivity mode requires a minimal amount of data to be delivered to Azure for inventory and billing purposes at least once per month.

While the Indirectly Connected mode offers reduced functionality, it allows you to accommodate a range of scenarios that prevent the use of the Directly Connected mode. This applies, for example, to on-premises datacenters that block direct external connectivity because of business or regulatory requirements or because of concerns about external attacks or data exfiltration. It also provides support for edge site locations with limited or no direct connectivity to the internet.

The common set of capabilities of the Azure Arc enabled SQL Managed Instance include:

- Support for automated updates. Microsoft frequently provides updates to Azure Arc enabled data services through Microsoft Container Registry (MCR). This includes servicing patches and new features and delivering a similar experience as Azure managed data services. However, you control deployment schedule and cadence. <!--LM: Confirm that Microsoft Container Registry (MCR) is the correct term. Azure Container Registry (ACR) is approved in Term Studio, but I did find Microsoft documentation that uses MCR.-->
- Elastic scale. Container-based architecture inherently supports elastic scale, with limits that depend on the capacity of your infrastructure. This capability accommodates burst scenarios that have volatile needs, including ingesting and querying data in real time, at any scale, with sub-second response time.
- Self-service provisioning. With Kubernetes-based orchestration, you can provision a database in seconds using either graphical interface or Azure CLI tools.
- Flexible monitoring and management. With Azure Arc enabled SQL Managed Instance, you can collect and analyze logs and telemetry from Kubernetes APIs and implement [local monitoring using Kibana and Grafana dashboards][kubernetes-kibana-grafana]. You also have the ability to provision and manage Azure Arc enabled SQL Managed Instance by using a number of standard SQL Server management tools, including Azure Data Studio and Azure CLI, and Kubernetes management tools such as Helm and kubectl.
<!--LM: Do you mean Azure CLI instead of Azure Data CLI? If not, please reject the edit.-->
In addition, because Azure Arc enabled SQL Managed Instance runs on Azure Arc-enabled Kubernetes or AKS on Azure Stack HCI, you also can use their management, security, and compliance capabilities, including:

- Support for [enforcement of run-time policies by using Azure Policy for Kubernetes][arc-enabled-kubrnetes-policy-enforcement] and centralized reporting of the corresponding policy compliance. This allows you, for example, to enforce HTTPS ingress in Kubernetes cluster or ensure that containers listen only on allowed ports. <!--LM: I'm flagging "listen" for inclusivity to confirm that it's allowed in this instance.-->
- Support for [deploying Kubernetes and AKS configurations by using GitOps][arc-enabled-kubernetes-gitops]. GitOps is the practice of automated deployment of code residing in a Git repository. In this scenario, the code describes the desired state of Kubernetes or AKS configuration. You have the option to [enforce specific GitOps-based configurations by using Azure Policy][arc-enabled-kubernetes-gitops-enforce], which also provides centralized reporting of the corresponding policy compliance.

> [!CAUTION]
> Verify that the Azure Arc features you intend to use in your production environment are available.

## Considerations

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Azure Arc helps minimize or even eliminate the need for on-premises management and monitoring systems, which reduces operational complexity and cost, especially in large, diverse, and distributed environments. This helps offset additional costs associated with Azure Arc-related services. For example, advanced data security for Azure Arc enabled SQL Server instance requires [Microsoft Defender for Cloud] functionality of Microsoft Defender for Cloud, which has [pricing implications][azure-defender-pricing].
<!--LM: Azure Defender is in brackets. Did you mean to insert a link here?-->
- Containerizing your SQL Server environment by using Azure Arc enabled SQL Managed Instance helps increase workload density and mobility. This facilitates more efficient hardware utilization, which tends to maximize return on investment (ROI) and minimize operational costs, helping accelerate datacenter consolidation initiatives.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- To perform registration of individual Azure Arc enabled SQL Server instances, you can interactively run [a script available directly from the Azure portal][connect-sql-server-to-azure-arc]. For large-scale deployments, you can [run the same script in the unattended manner][connect-sql-server-to-azure-arc-at-scale], by leveraging an Azure AD service principal.

- To perform on-demand assessment of configuration and health of Azure Arc enabled SQL Server instances by using Azure Monitor, you must deploy the Log Analytics agent to the server hosting that SQL Server instance. You can automate this deployment at scale by using Azure Policy to [enable Azure Monitor for VMs for Azure Arc enabled servers][azure-monitor-for-vms].

- On-demand SQL Assessment and advanced data security are available for SQL Server instances that aren't Azure Arc enabled. However, Azure Arc simplifies their provisioning and configuration. You can, for example, use the VM extension capability to [automate deployment of the Log Analytics agent][azure-vm-extension-log-analytics-deploy] to servers hosting SQL Server instances.

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [manageability features][azure-arc-sql-mi-manageability].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [high scalability and performance features][azure-arc-sql-mi-performance].

- When planning for deployment of Azure Arc enabled SQL Managed Instance, you should identify the correct amount of compute, memory, and storage that will be required to run the [Azure Arc data controller][azure-arc-data-controller-sizing] and the intended [SQL managed instance][azure-arc-sql-mi-sizing] server groups. Note, however, that you have the flexibility to extend the capacity of the underlying Kubernetes or AKS cluster over time by adding additional compute nodes or storage.

- Kubernetes or AKS offers an abstraction layer over the underlying virtualization stack and hardware. Storage classes implement such abstraction for storage. When provisioning a pod, you need to decide which storage class to use for its volumes. Your decision is important from a performance standpoint because an incorrect choice could result in suboptimal performance. When planning for deployment of Azure Arc enabled SQL Managed Instance, you should consider a range of factors affecting storage configuration [kubernetes-storage-class-factors] for both [data controller][kubernetes-storage-data-controller] and [database instances][kubernetes-storage-database-instance].

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- With Azure Arc enabled SQL Managed Instance, planning for storage is also critical from the data resiliency standpoint. If there's a hardware failure, an incorrect choice might introduce the risk of total data loss. To avoid such risk, you should consider a range of factors affecting storage configuration [kubernetes-storage-class-factors] for both [data controller][kubernetes-storage-data-controller] and [database instances][kubernetes-storage-database-instance].

- With Azure Arc enabled SQL Managed Instance, you can deploy individual databases in either a single or multiple-pod pattern. For example, the developer or general-purpose pricing tier implements a single pod pattern, while a highly available business critical pricing tier implements a multiple-pod pattern. A highly available Azure SQL managed instance uses Always On Availability Groups to replicate the data from one instance to another either synchronously or asynchronously.

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for a majority of its [high availability features][azure-arc-sql-mi-ha].

- Azure Arc enabled SQL Managed Instance provides automatic local backups, regardless of the connectivity mode. In the Directly Connected mode, you also have the option of applying Azure Backup for off-site, long-term backup retention.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Azure Arc enabled SQL Managed Instance shares the code base with the latest stable version of SQL Server, providing support for the same set of [security features][azure-arc-sql-mi-security].

- With Azure Arc enabled SQL Managed Instance, in the Directly Connected mode, you should provide the data controller with direct access to the MCR to facilitate automatic upgrades and patching. Alternatively, you have the option to import container images from MCR and make them available in a local, private container registry accessible by the data controller.

- The Azure Connected Machine Agent communicates outbound to Azure Arc over TCP port **443** using the Transport Layer Security (TLS) protocol.
<!--LM: If you're referring to Azure, the correct term is Azure Connected Machine Agent. Use full term.-->
- With Azure Arc enabled SQL Managed Instance in the Directly Connected mode, there's no need to open any inbound ports at the perimeter of on-premises datacenters. Data controller initiated outbound connectivity in the secure manner over TCP port **443** using the Transport Layer Security (TLS) protocol.

> [!CAUTION]
> To enhance the security of data in transit to Azure, you should [configure servers hosting the SQL Server instances to use Transport Layer Security (TLS) 1.2][server-configure-tls-12].

## Next steps

- Product and service documentation:
  - [SQL Server technical documentation][sql-server]
  - [Azure Arc overview][azure-arc]
  - [What is Azure Arc-enabled servers?][azure-arc-enabled-servers]
  - [Azure Arc-enabled SQL Server][azure-arc-enabled-sql-server]
  - [Azure Kubernetes Service][azure-kubernetes-service]
  - [Azure Stack HCI solution overview][azs-hci]
  - [What is on-premises Kubernetes with Azure Kubernetes Service on Azure Stack HCI and Windows Server?][azure-kubernetes-service-on-azs-hci]
  - [What is Azure Arc-enabled Kubernetes?][azure-arc-enabled-kubernetes]
  - [What are Azure Arc-enabled data services?][azure-arc-enabled-data-services]
  - [What is Azure SQL Managed Instance?][sql-managed-instance]
  - [Azure Arc-enabled SQL Managed Instance Overview][azure-arc-enabled-sql-managed-instance]
  - [What is Azure Resource Manager?][azure-resource-manager]
  - [Azure Monitor overview][azure-monitor]
  - [Overview of Log Analytics in Azure Monitor][azure-log-analytics]
  - [What is Microsoft Sentinel?][azure-sentinel]
  - [What is Microsoft Defender for Cloud?][azure-security-center]
  - [What is the Azure Backup service?][azure-backup]

- Training resources
  - [Introduction to Azure Arc][Introduction to Azure Arc - training content]
  - [Introduction to Azure Arc enabled servers][Introduction to Azure Arc enabled servers - training content]
  - [Introduction to Azure Arc-enabled data services][Introduction to Azure Arc-enabled data services - training content]
  - [Introduction to Azure Arc-enabled Kubernetes][Introduction to Azure Arc-enabled Kubernetes - training content]

## Related resources

- [Use Azure Stack HCI switchless interconnect and lightweight quorum for remote office or branch office][Use Azure Stack HCI switchless interconnect and lightweight quorum for remote office or branch office]
- [Manage configurations for Azure Arc-enabled servers][Manage configurations for Azure Arc-enabled servers]
- [Azure Arc hybrid management and deployment for Kubernetes clusters][Azure Arc hybrid management and deployment for Kubernetes clusters]
- [Azure hybrid options][Azure hybrid options]
- [Multicloud blockchain DLT][Multicloud blockchain DLT]

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure_arc_sql_srvr.vsdx
[azure-well-architected-framerwork]: /azure/architecture/framework/
[sql-server]: /sql/sql-server/
[azure-arc]: /azure/azure-arc/overview
[azure-arc-enabled-servers]: /azure/azure-arc/servers/overview
[azure-arc-enabled-sql-server]: /sql/sql-server/azure-arc/overview?view=sql-server-ver15
[kubernetes-open-source]: /training/modules/intro-to-kubernetes/2-what-is-kubernetes
[azure-kubernetes-service]: /azure/aks/intro-kubernetes
[azs-hci]: /azure-stack/hci/overview
[azure-kubernetes-service-on-azs-hci]: /azure-stack/aks-hci/overview
[azure-arc-enabled-kubernetes]: /azure/azure-arc/kubernetes/overview
[azure-arc-enabled-data-services]: /azure/azure-arc/data/overview
[sql-managed-instance]: /azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[azure-arc-enabled-sql-managed-instance]: /azure/azure-arc/data/managed-instance-overview
[azure-resource-manager]: /azure/azure-resource-manager/management/overview
[azure-monitor]: /azure/azure-monitor/overview
[azure-log-analytics]: /azure/azure-monitor/log-query/log-analytics-overview
[azure-sentinel]: /azure/sentinel/overview
[azure-security-center]: /azure/security-center/security-center-introduction
[azure-backup]: /azure/backup/backup-overview
[azure-premier-support]: https://azure.microsoft.com/support/plans/premier/
[azure-monitor-for-vms]: /azure/azure-monitor/insights/vminsights-enable-policy
[connect-sql-server-to-azure-arc]: /sql/sql-server/azure-arc/connect?view=sql-server-ver15#generate-a-registration-script-for-sql-server
[connect-sql-server-to-azure-arc-at-scale]: /sql/sql-server/azure-arc/connect-at-scale?view=sql-server-ver15
[azure-arc-sql-assess-prereqs]: /sql/sql-server/azure-arc/assess?view=sql-server-ver15#prerequisites
[azure-arc-sql-assess]: /sql/sql-server/azure-arc/assess?view=sql-server-ver15
[azure-security-center-explore]: /sql/sql-server/azure-arc/configure-advanced-data-security?view=sql-server-ver15#explore
[azure-sentinel-onboarding]: /azure/sentinel/connect-data-sources
[azure-vm-extension-log-analytics-deploy]: /sql/sql-server/azure-arc/configure-advanced-data-security?view=sql-server-ver15#install-microsoft-monitoring-agent-mma
[azure-arc-enabled-sql-mi-compatibility]: /azure/azure-arc/data/managed-instance-overview
[azure-arc-data-services-connectivity-modes]: /azure/azure-arc/data/connectivity
[kubernetes-kibana-grafana]: /azure/azure-arc/data/monitor-grafana-kibana
[arc-enabled-kubernetes-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[arc-enabled-kubernetes-gitops-enforce]: /azure/azure-arc/kubernetes/use-azure-policy
[arc-enabled-kubrnetes-policy-enforcement]: /azure/governance/policy/concepts/policy-for-kubernetes?toc=/azure/azure-arc/kubernetes/toc.yml
[azure-defender-pricing]: https://azure.microsoft.com/pricing/details/security-center/
[azure-arc-data-controller-sizing]: /azure/azure-arc/data/sizing-guidance#data-controller-sizing-details
[azure-arc-sql-mi-sizing]: /azure/azure-arc/data/sizing-guidance#sql-managed-instance-sizing-details
[kubernetes-storage-class-factors]: /azure/azure-arc/data/storage-configuration#factors-to-consider-when-choosing-your-storage-configuration
[kubernetes-storage-data-controller]: /azure/azure-arc/data/storage-configuration#data-controller-storage-configuration
[kubernetes-storage-database-instance]: /azure/azure-arc/data/storage-configuration#database-instance-storage-configuration
[azure-arc-sql-mi-manageability]: /azure/azure-arc/data/managed-instance-features#RDBMSM
[azure-arc-sql-mi-performance]: /azure/azure-arc/data/managed-instance-features#RDBMSSP
[azure-arc-sql-mi-ha]: /azure/azure-arc/data/managed-instance-features#RDBMSHA
[azure-arc-sql-mi-security]: /azure/azure-arc/data/managed-instance-features#RDBMSS
[server-configure-tls-12]: /azure/azure-arc/servers/agent-overview#transport-layer-security-12-protocol
[sql-server-service-page]: https://www.microsoft.com/sql-server/sql-server-2019
[azure-arc-service-page]: https://azure.microsoft.com/products/azure-arc
[azure-arc-enabled-servers-service-page]: https://azure.microsoft.com/products/azure-arc/hybrid-data-services
[azure-arc-enabled-sql-server-service-page]: https://azure.microsoft.com/products/azure-arc/hybrid-data-services
[azure-kubernetes-service-service-page]: https://azure.microsoft.com/products/kubernetes-service
[azs-hci-service-page]: https://azure.microsoft.com/products/azure-stack/hci
[azure-kubernetes-service-on-azs-hci-service-page]: https://azure.microsoft.com/products/azure-stack/hci/#aks-on-hci
[azure-arc-enabled-kubernetes-service-page]: https://azure.microsoft.com/products/azure-arc
[azure-arc-enabled-data-services-service-page]: https://azure.microsoft.com/products/azure-arc/hybrid-data-services
[sql-managed-instance-service-page]: https://azure.microsoft.com/products/azure-sql/managed-instance
[azure-arc-enabled-sql-managed-instance-service-page]: https://azure.microsoft.com/products/azure-arc/hybrid-data-services
[azure-resource-manager-service-page]: https://azure.microsoft.com/get-started/azure-portal/resource-manager
[azure-monitor-service-page]: https://azure.microsoft.com/products/monitor
[azure-log-analytics-service-page]: https://azure.microsoft.com/products/monitor
[azure-sentinel-service-page]: https://azure.microsoft.com/products/microsoft-sentinel
[azure-security-center-service-page]: https://azure.microsoft.com/products/defender-for-cloud
[azure-backup-service-page]: https://azure.microsoft.com/products/backup
[Introduction to Azure Arc enabled servers - training content]: /training/modules/intro-to-arc-for-servers
[Introduction to Azure Arc-enabled data services - training content]: /training/modules/intro-to-arc-enabled-data-services
[Introduction to Azure Arc-enabled Kubernetes - training content]: /training/modules/intro-to-arc-enabled-kubernetes
[Introduction to Azure Arc - training content]: /training/modules/intro-to-azure-arc
[Use Azure Stack HCI switchless interconnect and lightweight quorum for remote office or branch office]: ./azure-stack-robo.yml
[Manage configurations for Azure Arc-enabled servers]: ./azure-arc-hybrid-config.yml
[Azure Arc hybrid management and deployment for Kubernetes clusters]: ./arc-hybrid-kubernetes.yml
[Azure hybrid options]: ../guide/technology-choices/hybrid-considerations.yml
[Multicloud blockchain DLT]: ../example-scenario/blockchain/multi-cloud-blockchain.yml
