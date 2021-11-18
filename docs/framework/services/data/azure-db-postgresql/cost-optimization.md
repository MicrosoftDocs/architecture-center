---
title: Azure Database for PostgreSQL and cost optimization
description: Focuses on the Azure Database for PostgreSQL service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Cost Optimization.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-database-postgresql
categories:
  - data
  - management-and-governance
---

# Azure Database for PostgreSQL and cost optimization

[Azure Database for PostgreSQL](/azure/postgresql/overview) is a relational database service in the Microsoft cloud based on the [PostgreSQL Community Edition](https://www.postgresql.org/).

You can choose between three deployment modes, such as [Single Server](/azure/postgresql/overview-single-server), [Flexible Server](/azure/postgresql/flexible-server/overview), and [Hyperscale (Citus)](/azure/postgresql/hyperscale-overview):

- *Single Server*: A fully managed database service with minimal requirements for database customizations. This platform is designed to handle most database management functions, such as:

   - Patching
   - Backups
   - High Availability
   - Security with minimal user configuration and control

    This service offers three pricing tiers and allows you to pay only for the resources you need, and only when you need them.

- *Flexible Server*: A fully managed database service designed to provide more granular control and flexibility over database management functions and configuration settings based on user requirements. This service provides better cost optimization controls because you can stop and start the server, and the burstable compute tier.

- *Hyperscale*: This option uses sharding to horizontally scale across multiple machines. Hyperscale is best for applications that require greater scale where workloads approach `100GB` of data.

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Database for PostgreSQL.

## Design considerations

Azure Database for PostgreSQL includes the following design considerations:

- Hyperscale (Citus) provides dynamic scalability without the cost of manual sharding with low application rearchitecture required.

  Distributing table rows across multiple PostgreSQL servers is a key technique for scalable queries in Hyperscale (Citus). Together, multiple nodes can hold more data than a traditional database, and in many cases can use worker CPUs in parallel to execute queries potentially lowering the database costs. Follow this [Shard data on worker nodes tutorial](/azure/postgresql/tutorial-hyperscale-shard) to practice this potential savings architecture pattern.

- Consider using Flexible Server SKU for non-production workloads.

  Flexible servers provide better cost optimization controls with ability to stop and start your server, and burstable compute tier that is ideal for workloads that don't need continuous full compute capacity.

- Plan your Recovery Point Objective (RPO) according to your operation level requirement.

  There's no extra charge for backup storage for up to `100%` of your total provisioned server storage. Extra consumption of backup storage will be charged in GB/month.

- Take advantage of the scaling capabilities of Azure Database for PostgreSQL to lower consumption cost whenever possible.

  This Microsoft Support article about [How to autoscale an Azure Database for MySQL/PostgreSQL instance with Azure runbooks and Python](https://techcommunity.microsoft.com/t5/azure-database-support-blog/how-to-auto-scale-an-azure-database-for-mysql-postgresql/ba-p/369177) covers the automation process using runbooks to scale your database up and down, as needed.

- The cloud native design of the Single- Server service allows it to support `99.99%` of availability eliminating the cost of passive *hot* standby.

## Checklist

**Have you configured Azure Database for PostgreSQL with cost optimization in mind?**
***

> [!div class="checklist"]
> - Choose the appropriate server size for your workload.
> - Consider Reserved Capacity for Azure Database for PostgreSQL Single Server and Hyperscale (Citus).

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Database for PostgreSQL configuration for cost optimization:

|Recommendation|Description|
|--------------|-----------|
|Choose the appropriate server size for your workload.|Configuration options: [Single Server](/azure/postgresql/concepts-pricing-tiers), [Flexible Server](/azure/postgresql/flexible-server/concepts-compute-storage), [Hyperscale (Citus)](/azure/postgresql/concepts-hyperscale-configuration-options).|
|Consider Reserved Capacity for Azure Database for PostgreSQL Single Server and Hyperscale (Citus).|Compute costs associated with Azure Database For PostgreSQL [Single Server Reservation Discount](/azure/postgresql/concept-reserved-pricing) and [Hyperscale (Citus) Reservation Discount](/azure/postgresql/concepts-hyperscale-reserved-pricing). Once the total compute capacity and performance tier for Azure Database for PostgreSQL in a region is determined, this information can be used to reserve the capacity. The reservation can span one or three years. You can realize significant cost optimization with this commitment.|

## Next step

> [!div class="nextstepaction"]
> [Azure SQL Database and reliability](../azure-sql-database/reliability.md)
