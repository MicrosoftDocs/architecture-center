---
title: Operational excellence in a hybrid workload
description: Includes guidance and recommendations that apply to the Operational Excellence pillar in a hybrid and multi-cloud workload.
author: v-aangie
ms.date: 02/08/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Operational excellence in a hybrid workload

<!-- comment new content - More devops focus, in-line with the WAF Op Ex content -->

Operational excellence consists of the operations processes that keep a system running in production. Applications must be designed with DevOps principles in mind, and deployments must be reliable and predictable. Use monitoring tools to verify that your application is running correctly and to gather custom business telemetry that will tell you whether your application is being used as intended.

Use _Azure Arc enabled infrastructure_ to add support for cloud [Overview of the operational excellence pillar](../devops/overview.md) practices and tools to any environment. Be sure to utilize reference architectures and other resources from this section that illustrate applying these principles in hybrid and multicloud scenarios. The architectures referenced here can also be found in the Azure Architecture Center, [Hybrid and Multicloud](../../browse/index.yml?azure_categories=hybrid) category.

<!-- end new content -->

## Monitor your hybrid workloads across clouds

- **Azure Arc enabled data services**
   - Better data estate planning and control: Single view of all data assets for easy tracking and IT control over sprawl.
   - Improve IT productivity: No end of support for traditional on-premises database SW, full automation to enable management at scale.
   - Increase IT agility: Policy-driven management to give business users access and freedom to operate within defined enterprise-level policies by IT.

### Manage all of your workload infrastructure with Azure Arc

- **IT Estate visibility and control**
   - Customer's need: "I need to be able to see all my resources in a single location and be able to query through them to gain insights."
- **Cloud-based management**
   - Customer's need: "I need to be able to modernize my operations by being able to use the same cloud management services on my resources outside of Azure."
- **Governance**
   - Customer's need: "I need to be able to ensure consistent configurations in all my resources from a central location."
- **DevOps and cloud native app deployment flexibility**
   - Customer's need: "I need to be able to deploy apps’ infra through templates and apps’ configurations through GitOps."
- **Increased flexibility when adopting PaaS**
   - Customer's need: "I need to be able to run PaaS services on infrastructure of my choice."
 
### Modernize applications anywhere with Azure Stack HCI

- **Azure Stack Hub**
   - Improve performance: Leverage kernel imbedded architecture to boost your critical workload performance and simplify management.
   - Maintain full flexibility to deploy on-premises to help meet regulatory or policy requirements.
   - Help meet requirements for tasks like global auditing, financial reporting, foreign exchange trading, and online gaming.
   - Address latency and connectivity requirements by processing data locally.

### Azure Stack HCI use cases

- **Modernize your high-performance workloads and containerized applications**

    - Use Azure Stack HCI to enable automated deployment, scaling and management of containerized applications by running a Kubernetes cluster on your hyperconverged infrastructure.

- **Deploy and manage workloads in remote and branch sites**

    - Use Azure Stack HCI to deploy your container-built edge workloads essential and business applications in highly available virtual machines (VMs).
	 -	Bring efficient application development and deployment to remote locations at the right price by leveraging switchless deployment and 2 node clusters.
	 -	Get a global view of your system’s health using Azure Monitor.
	
- **Upgrade your infrastructure for remote work using VDI**

    - Bring desktops on-premises for low latency and data sovereignty enabling remote work using a brokerage service like Microsoft Remote Desktop Services. With Azure Stack HCI you can scale your resources in a simple predictable way. Provide a secure way to deliver desktop services to a wide range of devices without allowing users to store data locally or upload data from those local devices.

## Application design

<!-- new content - More devops focus, in-line with the WAF Op Ex content -->

The introduction of cloud computing had a significant impact on how software is developed, delivered, and run. With _Azure Arc enabled infrastructure_ and Azure Arc components like [Azure Arc enabled Kubernetes](/azure-arc/kubernetes/overview) and [Azure Arc enabled data services](/azure-arc/data/overview) it becomes possible to design cloud native applications with a consistent set of principles and tooling across public cloud, private cloud, and the edge.

Click the following links for architecture details and diagrams that enable application design and DevOps practices consistent with [Operational excellence principles](../devops/principles.md).

- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
- [Run containers in a hybrid environment](../../hybrid/hybrid-containers)
- [Managing K8 clusters outside of Azure with Azure Arc](https://azure.microsoft.com/resources/videos/kubernetes-app-management-with-azure-arc)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](../../hybrid/azure-arc-sql-server.yml)
- [Azure Data Studio dashboards](/azure-arc/data/azure-data-studio-dashboards)
- [microsoft/azure_arc: Azure Arc environments bootstrapping for everyone](https://github.com/microsoft/azure_arc) (in github.com)
- [All Azure Architecture Center Hybrid and Multicloud Architectures](../../browse/index.yml?azure_categories=hybrid)

<!-- end new content -->

## Monitoring

<!-- new content - More devops focus, in-line with the WAF Op Ex content -->

Click the following links for architecture details and diagrams that illustrate [Monitoring for DevOps](../devops/monitoring.md) in a hybrid and multicloud environment.

- [Hybrid availability and performance monitoring](../../hybrid/hybrid-perf-monitoring.yml)
- [Enable monitoring of Azure Arc enabled Kubernetes cluster](https://docs.microsoft.com/azure/azure-monitorinsights/container-insights-enable-arc-enabled-clusters)
- [Azure Monitor for containers overview](/azure-monitor/insights/container-insights-overview)

<!-- end new content -->

- **Connect Machines agent overview of Azure Arc**
   - Connect machines from Azure portal
   - At scale using service principal
   - Connect to Azure Arc with PowerShell DSC
   - Connect machines from WAC
- **Monitor hybrid machines with Azure Monitor for VMs**
   - [Tutorial - Monitor a hybrid machine with Azure Monitor for VMs](/azure/azure-arc/servers/learn/tutorial-enable-vm-insights) (in Azure Arc | Microsoft Docs)
   - Enable Azure Monitor for VMs --> View data collected
 
## Application performance management

VM extensions can be managed using:

- [Azure portal](/azure/azure-arc/servers/manage-vm-extensions-portal)
- [Azure CLI](/azure/azure-arc/servers/manage-vm-extensions-cli)
- [Azure PowerShell](/azure/azure-arc/servers/manage-vm-extensions-powershell)
- [Azure Resource Manager templates](/azure/azure-arc/servers/manage-vm-extensions-template)

## Code deployment

<!-- new content - More devops focus, in-line with the WAF Op Ex content -->

Click the following links for architecture details and diagrams that illustrate [Deployment considerations for DevOps](../devops/release-engineering-cd.md) in a hybrid and multicloud environment.

- [Deploy configurations using GitOps on Arc enabled Kubernetes cluster](https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/use-gitops-connected-cluster)
- [Use Azure Policy to apply cluster configurations at scale](https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/use-azure-policy)
- [Azure Automation in a hybrid environment](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-automation-hybrid)
- [DevOps in a hybrid environment](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/devops-in-a-hybrid-environment)

<!-- end new content -->

- **Deploy Azure VM extensions with ARM templates**: [Enable VM extension using Azure Resource Manager template](/azure/azure-arc/servers/manage-vm-extensions-template) (in Azure Arc | Microsoft Docs)
   - Linux
   - Windows
- **Deploy Custom Scripts**
   - Linux
   - Windows
- **Deploy PowerShell DSC Extension**
   - Linux
   - Windows
- **Deploy Azure Monitor Dependency Extension agent**
   - Linux
   - Windows
- **Deploy Azure Key Vault Extensions**
   - Linux
   - Windows





## Manage data anywhere

![Management capabilities comparison by deployment model](../_images/hybrid-deployment.png)
  
## Next steps

>[!div class="nextstepaction"]
>[Performance Efficiency](/azure/architecture/framework/hybrid/hybrid-performance-efficiency)