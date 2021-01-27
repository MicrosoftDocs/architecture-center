---
title: Operational excellence in a hybrid workload
description: Includes guidance and recommendations that apply to the Operational Excellence pillar in a hybrid and multi-cloud workload.
author: v-aangie
ms.date: 01/27/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Operational excellence in a hybrid workload

Operational excellence consists of the operations processes that keep a system running in production.

Be sure to utilize hybrid reference architectures from this section. They can also be found in the Azure Architecture Center, [Hybrid and Multicloud](/azure/architecture/browse/?azure_categories=hybrid) category.

## Monitor your hybrid workloads across clouds

- **Azure Arc enabled data services**
   - Better data estate planning and control: Single view of all data assets for easy tracking and IT control over sprawl.<!--CAF Overlap-->
   - Improve IT productivity: No end of support for traditional on-premises database SW, full automation to enable management at scale.<!--CAF Overlap-->
   - Increase IT agility: Policy-driven management to give business users access and freedom to operate within defined enterprise-level policies by IT.<!--CAF Overlap-->

### Manage all of your workload infrastructure with Azure Arc

- **IT Estate visibility and control**<!--CAF Overlap-->
   - Customer's need: "I need to be able to see all my resources in a single location and be able to query through them to gain insights."<!--CAF Overlap-->
- **Cloud-based management**<!--CAF Overlap-->
   - Customer's need: "I need to be able to modernize my operations by being able to use the same cloud management services on my resources outside of Azure."<!--CAF Overlap-->
- **Governance**<!--CAF Overlap-->
   - Customer's need: "I need to be able to ensure consistent configurations in all my resources from a central location."<!--CAF Overlap-->
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

- **Upgrade your infrastructure for remote work using VDI**.<!--CAF Overlap-->
   - Bring desktops on-premises for low latency and data sovereignty enabling remote work using a brokerage service like Microsoft Remote Desktop Services. With Azure Stack HCI you can scale your resources in a simple predictable way. Provide a secure way to deliver desktop services to a wide range of devices without allowing users to store data locally or upload data from those local devices.<!--CAF Overlap-->
- **Modernize your remote and branch office, with easier to deploy and manageable technology**.<!--CAF Overlap-->
   - Use Azure Stack HCI to meet the evolving IT demands of branch offices, retail stores, and field locations. Bring efficient IT to remote locations at the right price by leveraging switchless deployment and 2 node clusters.<!--CAF Overlap-->
   - Deploy your container-built edge workloads and essential business applications in highly available virtual machines (VMs).<!--CAF Overlap-->
   - Get a global view of your system’s health Azure Monitor.<!--CAF Overlap-->
   - Control your enterprise virtual desktop infrastructure configuration in the cloud with an Azure update management solution.<!--CAF Overlap-->
- **Modernize your high-performance workloads and container enterprise infrastructure Customer**
   - Use Azure Stack HCI to enable automated deployment, scaling and management of containerized applications by running a Kubernetes cluster on your hyperconverged infrastructure.
 
## Application design

Utilize Arc Jumpstart, Arc Reference Architectures, and HCI Reference Architectures.

- [microsoft/azure_arc: Azure Arc environments bootstrapping for everyone](https://github.com/microsoft/azure_arc) (in github.com)
- [Hybrid and Multicloud Architectures - Azure Architecture Center | Microsoft Docs](/azure/architecture/browse/?azure_categories=hybrid#management) - Management
- [Hybrid and Multicloud Architectures - Azure Architecture Center | Microsoft Docs](/azure/architecture/browse/?azure_categories=hybrid#data) - Data
- Show design patterns for:
   - Arc enabled servers
   - Arc enabled K8s
   - Arc enabled SQL server
   - Arc enabled data services
 
## Monitoring

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

- **Deploy Azure VM extensions with ARM templates**: [Enable VM extension using Azure Resource Manager template](/azure/azure-arc/servers/manage-vm-extensions-template) (in Azure Arc | Microsoft Docs)<!--CAF Overlap-->
   - Linux
   - Windows
- **Deploy Custom Scripts**<!--CAF Overlap-->
   - Linux
   - Windows
- **Deploy PowerShell DSC Extension**<!--CAF Overlap-->
   - Linux
   - Windows
- **Deploy Azure Monitor Dependency Extension agent**<!--CAF Overlap-->
   - Linux
   - Windows
- **Deploy Azure Key Vault Extensions**<!--CAF Overlap-->
   - Linux
   - Windows

## Manage data anywhere <!--CAF Overlap-->

![Management capabilities comparison by deployment model](../_images/hybrid-deployment.png)
  
## Next steps

>[!div class="nextstepaction"]
>[Performance Efficiency](/azure/architecture/framework/hybrid/hybrid-performance-efficiency)