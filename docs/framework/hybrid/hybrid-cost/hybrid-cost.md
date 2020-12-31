---
title: Cost optimization in a hybrid environment
description: Describes considerations to optimize cost in a hybrid environment.
author: v-aangie
ms.date: 01/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Cost optimization in a hybrid environment

## Principles

### Define

Define the following for your workloads.

- Monitor cloud spend with hybrid workloads.
   - Track cost trends and forecast future spend in dashboards in Azure of your on-prem data estates with Azure Arc. <!--Overlaps with CAF. -->
- Keep within cost constraints.
   - Create, apply, and enforce standardized and custom tags and policies.
   - Enforce run-time conformance and audit resources with Azure Policy.
- Choose a flexible billing model.
   - With Azure Arc enabled data services, you can use existing hardware with the addition of an Opex model.

### Key points

For budget concerns, you get a considerable amount of functionality that you can use across all of your servers and cluster, at no cost with Azure Arc enabled servers. You can turn on additional Azure services to each workload as you need them, or not at all.

- **Free Core Azure Arc capabilities**
   - Update, management
   - Search index
   - Group, tags
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

**Other key points**:

- **Start slow**. Light up new capabilities as needed. Most of Azure Arc's resources are free to start.
- **Save time with unified management** for your on-premises and cloud workloads by projecting them all into Azure.
- **Automate and delegate** remediation of incidents and problems to service teams without IT intervention.
 
## Design

### Azure Architecture Center (AAC) resources

Click the following links for architecture details and diagrams.

- [Manage configurations for Azure Arc enabled servers](/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)
- [Disaster Recovery for Azure Stack Hub virtual machines](/azure/architecture/hybrid/azure-stack-vm-dr)
- [Build high availability into your BCDR strategy](/azure/architecture/solution-ideas/articles/build-high-availability-into-your-bcdr-strategy)
- [Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office](/azure/architecture/hybrid/azure-stack-robo)
- [Archive on-premises data to cloud](/azure/architecture/solution-ideas/articles/backup-archive-on-premises)
 
###	Workload considerations

- Virtual machines
- Managed PaaS services
- Container-based applications
   - Kubernetes could be both self-managed in on-premises, and managed Kubernetes deployments in the cloud.

### Infrastructure Decisions

- Use Azure Stack HCI to modernize on-prem workloads with hyperconverged infra.
   - Azure Stack HCI billing is based on a monthly subscription fee per physical processor core, not a perpetual license. When customers connect to Azure, the number of cores used is automatically uploaded and assessed for billing purposes. Cost doesn’t vary with consumption beyond the physical processor cores. This means that more VMs don’t cost more, and customers who are able to run denser virtual environments are rewarded.
- Use AVS if you're locked in with VMware.
- Use Azure Arc on any infrastructure of your choice.
- Slowly begin migrating out of your datacenter and use Azure Arc while you're migrating to project everything into Azure.

### Capacity planning

- Define SLAs
- Determine regulatory needs

## Provision

Click the following links for guidance in provisioning.

- [Azure Arc pricing](https://azure.microsoft.com/pricing/details/azure-arc/)
- [Azure Arc Jumpstart for templates](https://github.com/microsoft/azure_arc) (in GitHub)
- [Azure Stack HCI pricing](https://azure.microsoft.com/en-us/pricing/details/azure-stack/hci/)
   - Azure Stack HCI can reduce costs by saving in server, storage, and network infrastructure.
- [Azure VMware Solution pricing](https://azure.microsoft.com/pricing/details/azure-vmware/)
   - Run your VMware workloads natively on Azure.
- [Azure Stack Hub pricing](https://azure.microsoft.com/pricing/details/azure-stack/hub/)

## Monitor

- [Managing the Azure Arc enabled servers agent](/azure/azure-arc/servers/manage-agent)
   - Bring all your resources into a single system so you can organize and inventory through a variety of Azure scopes, such as Management groups, Subscriptions, and Resource Groups.
   - Create, apply, and enforce standardized and custom tags to keep track of resources.
   - Build powerful queries and search your global portfolio with Azure Resource Graph.
- With [Azure Stack HCI](https://azure.microsoft.com/en-us/pricing/details/azure-stack/hci/)
   - Costs for datacenter real estate, electricity, personnel, and servers can be reduced or eliminated.
   - Costs are now part of OPEX, which can be scaled as needed.

## Next steps

>[!div class="nextstepaction"]
>[Operational excellence](/azure/architecture/framework/hybrid/hybrid-opex)