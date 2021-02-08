---
title: Cost optimization in a hybrid workload
description: Includes guidance and recommendations that apply to the Cost pillar in a hybrid and multi-cloud environment.
author: v-aangie
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Cost optimization in a hybrid workload

## Workload definitions

Define the following for your workloads:

- **Monitor cloud spend with hybrid workloads**. Track cost trends and forecast future spend in dashboards in Azure of your on-prem data estates with Azure Arc.<!--CAF Overlap-->
- **Keep within cost constraints**.<!--CAF Overlap-->
   - Create, apply, and enforce standardized and custom tags and policies.<!--CAF Overlap-->
   - Enforce run-time conformance and audit resources with Azure Policy.<!--CAF Overlap-->
- **Choose a flexible billing model**. With Azure Arc enabled data services, you can use existing hardware with the addition of an operating expense (OPEX) model.

## Functionality

For budget concerns, you get a considerable amount of functionality at no cost that you can use across all of your servers and cluster<!--CAF Overlap "across all of your servers and cluster"--> with Azure Arc enabled servers. You can turn on additional Azure services to each workload as you need them, or not at all.

- **Free Core Azure Arc capabilities**
   - Update, management<!--CAF Overlap-->
   - Search index<!--CAF Overlap-->
   - Group, tags<!--CAF Overlap-->
   - Portal
   - Templates, extensions
   - RBAC, subscriptions

- **Paid-for Azure Arc enabled attached services**
   - Azure policy
   - Azure monitor
   - Security center – Standard
   - Azure Sentinel
   - Backup
   - Config and change management

### Tips

- **Start slow**. Light up new capabilities as needed. Most of Azure Arc's resources are free to start.
- **Save time with unified management<!--CAF Overlap "unified management"-->** for your on-premises and cloud workloads by projecting them all into Azure.
- **Automate and delegate** remediation of incidents and problems to service teams without IT intervention.<!--CAF Overlap-->
 
## Design resources on Azure Architecture Center (AAC)

Click the following links for architecture details and diagrams.

- [Manage configurations for Azure Arc enabled servers](/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)
- [Disaster Recovery for Azure Stack Hub virtual machines](/azure/architecture/hybrid/azure-stack-vm-dr)
- [Build high availability into your BCDR strategy](/azure/architecture/solution-ideas/articles/build-high-availability-into-your-bcdr-strategy)
- [Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office](/azure/architecture/hybrid/azure-stack-robo)
- [Archive on-premises data to cloud](/azure/architecture/solution-ideas/articles/backup-archive-on-premises)
 
## Workload considerations

- Virtual machines
- Managed PaaS services
- Container-based applications
   - Kubernetes could be both self-managed in on-premises, and managed Kubernetes deployments in the cloud.

## Infrastructure Decisions

- Use Azure Stack HCI to modernize on-prem workloads with hyperconverged infra. Azure Stack HCI billing is based on a monthly subscription fee per physical processor core, not a perpetual license. When customers connect to Azure, the number of cores used is automatically uploaded and assessed for billing purposes. Cost doesn’t vary with consumption beyond the physical processor cores. This means that more VMs don’t cost more, and customers who are able to run denser virtual environments are rewarded.

You can use AVS if you're locked in with VMware, or use Azure Arc on any infrastructure of your choice. Slowly begin migrating out of your datacenter and use Azure Arc while you're migrating to project everything into Azure.<!--CAF Overlap-->

### Capacity planning

- Define SLAs
- Determine regulatory needs

## Provision

Click the following links for guidance in provisioning:

- [Azure Arc pricing](https://azure.microsoft.com/pricing/details/azure-arc/)
- [Azure Arc Jumpstart for templates](https://github.com/microsoft/azure_arc) (in GitHub)
- [Azure Stack HCI pricing](https://azure.microsoft.com/en-us/pricing/details/azure-stack/hci/)
   - Azure Stack HCI can reduce costs by saving in server, storage, and network infrastructure.
- [Azure VMware Solution pricing - Run your VMware workloads natively on Azure](https://azure.microsoft.com/pricing/details/azure-vmware/)
   - Run your VMware workloads natively on Azure.
- [Azure Stack Hub pricing](https://azure.microsoft.com/pricing/details/azure-stack/hub/)

## Monitor

- [Managing the Azure Arc enabled servers agent](https://docs.microsoft.com/azure/azure-arc/servers/manage-agent/)
   - Bring all your resources into a single system so you can organize and inventory through a variety of Azure scopes, such as Management groups, Subscriptions, and Resource Groups.<!--CAF Overlap-->
   - Create, apply, and enforce standardized and custom tags to keep track of resources.<!--CAF Overlap-->
   - Build powerful queries and search your global portfolio with Azure Resource Graph.<!--CAF Overlap-->
- With [Azure Stack HCI](https://azure.microsoft.com/en-us/pricing/details/azure-stack/hci/)
   - Costs for datacenter real estate, electricity, personnel, and servers can be reduced or eliminated.<!--CAF Overlap-->
   - Costs are now part of OPEX, which can be scaled as needed.<!--CAF Overlap-->

## Next steps

>[!div class="nextstepaction"]
>[Operational excellence](/azure/architecture/framework/hybrid/hybrid-opex)