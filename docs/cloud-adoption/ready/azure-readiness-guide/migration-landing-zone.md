---
title: Deploy a migration landing zone in Azure
description: Learn how to deploy a migration landing zone in Azure.
author: BrianBlanchard
ms.author: brblanch
ms.date: 5/19/2019
ms.topic: conceptual
ms.service: azure-portal
ms.subservice: enterprise-cloud-adoption
ms.custom: "fasttrack-edit"
---

# Deploy a migration landing zone

Migration landing zone is a term used to describe an environment that has been provisioned and prepared to host workloads being migrated from an on-premises environment into Azure. A migration landing zone is the final deliverable of the Azure readiness guide. This article ties together all of the readiness topics discussed in this guide and applies the decisions made to the deployment of your first migration landing zone.

The following outlines a landing zone commonly used to establish an environment suitable for use during a migration. The environment or landing zone described in this article has also been captured in an Azure blueprint. The CAF Migrate landing zone blueprint will allow you to deploy the defined environment with a single click.

## Purpose of the blueprint

The CAF migrate landing zone blueprint will create a landing zone. However, that landing zone is intentionally limited. It is designed to create a consistent starting point that provides room to learn infrastructure as code. For some migration efforts, this landing zone may be sufficient to meet your needs. However, it is safe to assume that you will need to change something in the blueprint to meet your unique constraints.

## Blueprint alignment

The image below shows the CAF migrate landing zone blueprint in relation to architectural complexity and compliance requirements.

![Blueprint alignment](../../_images/ready/blueprint-overview.png)

- The letter A sits inside of a curved line marking the scope of this blueprint. That scope is meant to convey that this blueprint covers limited architectural complexity but is built on relatively mid-line compliance requirements.
- Customers who have a high degree of complexity and stringent compliance requirements may be better served by leveraging a partner's extended blueprint or one of the [standards-based blueprint samples](/azure/governance/blueprints/samples/).
- Most customers will fall in the spectrum between these two extremes. The letter B represents the process outlined in the [landing zone considerations](../considerations/index.md) articles. For customers in this space, you can use the decision guides found in those articles to identify nodes to be added to the CAF migrate landing zone blueprint. This approach will allow you to customize the blueprint to fit your needs.

## Using this blueprint

Before using the CAF migration landing zone blueprint, you should review the following assumptions, decisions, and implementation guidance.

## Assumptions

The following assumptions or constraints were used when defining this initial landing zone. If these assumptions align with your constraints, then the blueprint could be used to create your first landing zone. The blueprint can be extended to create a landing zone blueprint that meets your unique constraints.

- **Subscription Limits:** This adoption effort is not expected to exceed [subscription limits](https://docs.microsoft.com/azure/azure-subscription-service-limits). Two common indicators would be an excess of 25,000 VMs or 10,000 vCPUs.
- **Compliance:** No 3rd-party compliance requirements are needed in this landing zone
- **Architectural complexity:** Architectural complexity doesn't warrant additional production subscriptions
- **Shared services:** There are no existing shared services in Azure to warrant treating this subscription like a spoke in a hub/spoke architecture

If these assumptions seem reasonably aligned with your current environment, then this blueprint might be a good place to start building your landing zone.

## Decisions

The following decisions are represented in the landing zone blueprint:

|Component  |Decisions  |Alternative approaches  |
|---------|---------|---------|
|Migration tools|Azure Site Recovery will be deployed and an Azure Migrate project will be created.|[Migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md)|
|Logging & monitoring|Operational Insights workspace and diagnostic storage account will be provisioned|         |
|Network|A VNet will be created with subnets for gateway, firewall, jumpbox, and landing zone.|[Networking decisions](../considerations/network-decisions.md)|
|Identity     |It is assumed that the subscription is already associated with an Azure AD instance|[Identity management best practices](https://docs.microsoft.com/azure/security/azure-security-identity-management-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json)         |
|Policy|This blueprint currently assumes that no Azure policies are to be applied.|         |
|Subscription design|N/A - Designed for a single production subscription|[Scaling Subscriptions](../considerations/scaling-subscriptions.md)|
|Management groups|N/A - Designed for a single production subscription|[Scaling Subscriptions](../considerations/scaling-subscriptions.md)         |
|Resource groups|N/A - Designed for a single production subscription|[Scaling Subscriptions](../considerations/scaling-subscriptions.md)         |
|Data|N/A|[Choose the correct SQL Server option in Azure](https://docs.microsoft.com/azure/sql-database/sql-database-paas-vs-sql-server-iaas?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json)         |
|Storage|N/A|[Azure Storage guidance](../considerations/storage-guidance.md)         |
|Naming and tagging standards|N/A|[Naming and tagging best practices](../considerations/name-and-tag.md)         |
|Cost management|N/A|[Tracking costs](../azure-best-practices/track-costs.md)|
|Compute|N/A|[Compute options](../considerations/compute-decisions.md)|

## Customize or deploy a landing zone from this blueprint

A reference sample of the Cloud Adoption Framework migrate landing zone blueprint can be downloaded for deployment or customization from [GitHub](https://aka.ms/CAF/ready/landingzonesample).

For guidance on customization that should be made to this blueprint or the resulting landing zone, see the [landing zone considerations](../considerations/index.md) articles.

## Next steps

Once a migration landing zone has been deployed, your are now ready to begin migrating workloads to Azure.
The [Azure migration guide](../../migrate/azure-migration-guide/index.md) can help guide you through the tools and processes required to migrate your first workload.

> [!div class="nextstepaction"]
> [Migrate your first workload with the Azure migration guide](../../migrate/azure-migration-guide/index.md)
