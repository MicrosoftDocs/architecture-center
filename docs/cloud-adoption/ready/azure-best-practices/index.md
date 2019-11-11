---
title: "Azure readiness best practices"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Introduction to best practices for Azure readiness
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: ready
---

# Best practices for Azure readiness

A large part of cloud readiness is equipping staff with the technical skills needed to begin a cloud adoption effort and prepare your migration target environment for the assets and workloads you'll move to the cloud. The following topics provide best practices and additional guidance to help your team establish and prepare your Azure environment.

## Azure fundamentals

Use the following guidance when organizing and deploying your assets in the Azure environment:

- [Azure fundamental concepts](../considerations/fundamental-concepts.md). Learn fundamental concepts and terms used in Azure. Also learn how these concepts relate to one another.
- [Recommended naming and tagging conventions](../considerations/name-and-tag.md). Review detailed recommendations for naming and tagging your resources. These recommendations support enterprise cloud adoption efforts.
- [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md). Understand strategies for scaling with multiple Azure subscriptions.
- [Organize your resources with Azure management groups](https://docs.microsoft.com/azure/governance/management-groups/?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn how Azure management groups can manage resources, roles, policies, and deployment across multiple subscriptions.
- [Create hybrid cloud consistency](../../infrastructure/misc/hybrid-consistency.md). Create hybrid cloud solutions that provide the benefits of cloud innovation while maintaining many of the conveniences of on-premises management.

## Networking

Use the following guidance to prepare your cloud networking infrastructure to support your workloads:

- [Networking decisions](../considerations/network-decisions.md). Choose the networking services, tools, and architectures that will support your organization's workload, governance, and connectivity requirements.
- [Virtual network planning](https://docs.microsoft.com/azure/virtual-network/virtual-network-vnet-plan-design-arm?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn to plan virtual networks based on your isolation, connectivity, and location requirements.
- [Best practices for network security](https://docs.microsoft.com/azure/security/azure-security-network-security-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn best practices for addressing common network security issues by using built-in Azure capabilities.
- [Perimeter networks](./perimeter-networks.md). Also known as demilitarized zones (DMZs), perimeter networks enable secure connectivity between your cloud networks and your on-premises or physical datacenter networks, along with any connectivity to and from the internet.
- [Hub-and-spoke network topology](./hub-spoke-network-topology.md). Hub and spoke is a networking model for efficient management of common communication or security requirements for complicated workloads. It also addresses potential Azure subscription limitations.

## Identity and access control

Use the following guidance when designing your identity and access control infrastructure to improve the security and management efficiency of your workloads:

- [Azure identity management and access control security best practices](https://docs.microsoft.com/azure/security/azure-security-identity-management-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn best practices for identity management and access control using built-in Azure capabilities.
- [Best practices for role-based access control](./roles.md). Azure role-based access control (RBAC) offers fine-grained group-based access management for resources organized around user roles.
- [Securing privileged access for hybrid and cloud deployments in Azure Active Directory](https://docs.microsoft.com/azure/active-directory/users-groups-roles/directory-admin-roles-secure?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Use Azure Active Directory to help ensure that your organization’s administrative access and admin accounts are secure across your cloud and on-premises environment.

## Storage

- [Azure Storage guidance](../considerations/storage-guidance.md). Select the right Azure Storage solution to support your usage scenarios.
- [Azure Storage security guide](https://docs.microsoft.com/azure/storage/common/storage-security-guide?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn about security features in Azure Storage.

## Databases

- [Choose the correct SQL Server option in Azure](https://docs.microsoft.com/azure/sql-database/sql-database-paas-vs-sql-server-iaas?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Choose the PaaS or IaaS solution that best supports your SQL Server workloads.
- [Database security best practices](https://docs.microsoft.com/azure/security/azure-database-security-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn best practices for database security on the Azure platform.
- [Choose the right data store](https://docs.microsoft.com/azure/architecture/guide/technology-choices/data-store-overview). Selecting the right data store for your requirements is a key design decision. There are literally hundreds of implementations to choose from among SQL and NoSQL databases. Data stores are often categorized by how they structure data and the types of operations they support. This article describes several of the most common storage models. 

## Cost management

- [Tracking costs across business units, environments, and projects](./track-costs.md). Learn best practices for creating proper cost-tracking mechanisms.
- [How to optimize your cloud investment with Azure Cost Management](https://docs.microsoft.com/azure/cost-management/cost-mgt-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Implement a strategy for cost management and learn about the tools available for addressing cost challenges.
- [Create and manage budgets](https://docs.microsoft.com/azure/cost-management/tutorial-acm-create-budgets?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn to create and manage budgets by using Azure Cost Management.
- [Export cost data](https://docs.microsoft.com/azure/cost-management/tutorial-export-acm-data?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn to create and manage exported data in Azure Cost Management.
- [Optimize costs based on recommendations](https://docs.microsoft.com/azure/cost-management/tutorial-acm-opt-recommendations?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn to identify underutilized resources and take action to reduce costs by using Azure Cost Management and Azure Advisor.
- [Use cost alerts to monitor usage and spending](https://docs.microsoft.com/azure/cost-management/cost-mgt-alerts-monitor-usage-spending?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json). Learn to use Cost Management alerts to monitor your Azure usage and spending.
