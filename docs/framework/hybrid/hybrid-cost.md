---
title: Cost optimization in a hybrid workload
description: Includes guidance and recommendations that apply to the Cost pillar in a hybrid and multi-cloud environment.
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-stack-hci
  - azure-arc
categories:
  - hybrid
ms.custom:
  - e2e-hybrid
---

# Cost optimization in a hybrid workload

A key benefit of hybrid cloud environments is the ability to scale dynamically and back up resources in the cloud, avoiding the capital expenditures of a secondary datacenter. However, when workloads sit in both on-premises and cloud environments, it can be challenging to have visibility into the cost. With Azure's hybrid technologies, you can define policies and constraints for both on-premises and cloud workloads with Azure Arc. By utilizing Azure Policy, you're able to enforce organizational standards for your workload and the entire IT estate.

Azure Arc helps minimize or even eliminate the need for on-premises management and monitoring systems, which reduces operational complexity and cost, especially in large, diverse, and distributed environments. This helps offset additional costs associated with Azure Arc-related services. For example, advanced data security for Azure Arc enabled SQL Server instance requires Microsoft Defender for Cloud functionality of Microsoft Defender for Cloud, which has [pricing implications](https://azure.microsoft.com/pricing/details/security-center/).

Other considerations are described in the [Principles of cost optimization](../cost/design-model.md) section in the Microsoft Azure Well-Architected Framework.

## Workload definitions

Define the following for your workloads:

- **Monitor cloud spend with hybrid workloads**. Track cost trends and forecast future spend with dashboards in Azure for your on-prem data estates with Azure Arc.
- **Keep within cost constraints**.
   - Create, apply, and enforce standardized and custom tags and policies.
   - Enforce run-time conformance and audit resources with Azure Policy.
- **Choose a flexible billing model**. With Azure Arc enabled data services, you can use existing hardware with the addition of an operating expense (OPEX) model.

## Functionality

For budget concerns, you get a considerable amount of functionality at no cost that you can use across all of your servers and cluster with Azure Arc enabled servers. You can turn on additional Azure services to each workload as you need them, or not at all.

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
   - Defender for Cloud – Standard
   - Microsoft Sentinel
   - Backup
   - Config and change management

### Tips

- **Start slow**. Light up new capabilities as needed. Most of Azure Arc's resources are free to start.
- **Save time with unified management** for your on-premises and cloud workloads by projecting them all into Azure.
- **Automate and delegate** remediation of incidents and problems to service teams without IT intervention.

## Azure Architecture Center (AAC) resources related to hybrid cost

- [Manage configurations for Azure Arc enabled servers](../../hybrid/azure-arc-hybrid-config.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](../../hybrid/azure-arc-sql-server.yml)
- [Disaster Recovery for Azure Stack Hub virtual machines](../../hybrid/azure-stack-vm-dr.yml)
- [Build high availability into your BCDR strategy](../../solution-ideas/articles/build-high-availability-into-your-bcdr-strategy.yml)
- [Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office](../../hybrid/azure-stack-robo.yml)
- [Archive on-premises data to cloud](../../solution-ideas/articles/backup-archive-on-premises.yml)

## Infrastructure Decisions

Azure Stack HCI can help in cost-savings by using your existing Hyper-V and Windows Server skills to consolidate aging servers and storage. Azure Stack HCI pricing follows the monthly subscription billing model, with a flat rate per physical processor core in an Azure Stack HCI cluster.

Use Azure Stack HCI to modernize on-prem workloads with hyperconverged infra. Azure Stack HCI billing is based on a monthly subscription fee per physical processor core, not a perpetual license. When customers connect to Azure, the number of cores used is automatically uploaded and assessed for billing purposes. Cost doesn't vary with consumption beyond the physical processor cores. This means that more VMs don't cost more, and customers who are able to run denser virtual environments are rewarded.

If you are currently using VMware, you can take advantage of cost savings only available with Azure VMware Solution. Easily move VMware workloads to Azure and increase your productivity with elasticity, scale, and fast provisioning cycles. This will help enhance your workloads with the full range of Azure compute, monitor, backup, database, IoT, and AI services.

Lastly, you can slowly begin migrating out of your datacenter and use Azure Arc while you're migrating to project everything into Azure.

### Capacity planning

Check out our checklist under the [Cost Optimization pillar](../cost/design-checklist.md) in the Well-Framework to learn more about capacity planning, and build a checklist to design cost-effective workloads.

- Define SLAs
- Determine regulatory needs

## Provision

One advantage of cloud computing is the ability to use the PaaS model. And in some cases, PaaS services can be cheaper than managing VMs on your own. Some workloads cannot be moved to the cloud though for regulatory or latency reasons. Therefore, using a service like Azure Arc enabled  services allows you to flexibly use cloud innovation where you need it by deploying Azure services anywhere.

Click the following links for guidance in provisioning:

- [Azure Arc pricing](https://azure.microsoft.com/pricing/details/azure-arc)
- [Azure Arc Jumpstart for templates](https://github.com/microsoft/azure_arc) (in GitHub)
- [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci)
   - Azure Stack HCI can reduce costs by saving in server, storage, and network infrastructure.
- [Azure VMware Solution pricing - Run your VMware workloads natively on Azure](https://azure.microsoft.com/pricing/details/azure-vmware)
   - Run your VMware workloads natively on Azure.
- [Azure Stack Hub pricing](https://azure.microsoft.com/pricing/details/azure-stack/hub)

## Monitor and optimize

Treat cost monitoring and optimization as a process, rather than a point-in-time activity. You can conduct regular cost reviews and forecast the capacity needs so that you can provision resources dynamically and scale with demand.

- [Managing the Azure Arc enabled servers agent](/azure/azure-arc/servers/manage-agent/)
   - Bring all your resources into a single system so you can organize and inventory through a variety of Azure scopes, such as Management groups, Subscriptions, and Resource Groups.
   - Create, apply, and enforce standardized and custom tags to keep track of resources.
   - Build powerful queries and search your global portfolio with Azure Resource Graph.
- With [Azure Stack HCI](https://azure.microsoft.com/pricing/details/azure-stack/hci)
   - Costs for datacenter real estate, electricity, personnel, and servers can be reduced or eliminated.
   - Costs are now part of OPEX, which can be scaled as needed.

## Next steps

> [!div class="nextstepaction"]
> [Operational excellence](./hybrid-opex.md)
