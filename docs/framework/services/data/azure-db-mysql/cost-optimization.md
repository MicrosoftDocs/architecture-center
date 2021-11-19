---
title: Azure Database for MySQL and cost optimization
description: Focuses on the Azure Database for MySQL service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Cost Optimization.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-database-mysql
categories:
  - data
  - management-and-governance
---

# Azure Database for MySQL and cost optimization

[Azure Database for MySQL](/azure/mysql/overview) is a relational database service in the Microsoft cloud based on the [MySQL Community Edition](https://www.mysql.com/products/community/). You can use either [Single Server](/azure/mysql/single-server-overview) or [Flexible Server](/azure/mysql/flexible-server/overview) to host a MySQL database in Azure. It's a fully managed database as a service offering that can handle mission-critical workloads with predictable performance and dynamic scalability.

For more information about how Azure Database for MySQL supports cost optimization for your workload, reference [Server concepts](/azure/mysql/concepts-servers), specifically, [Stop/Start an Azure Database for MySQL](/azure/mysql/concepts-servers#stopstart-an-azure-database-for-mysql).

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Database for MySQL.

## Design considerations

Azure Database for MySQL includes the following design considerations:

- Take advantage of the scaling capabilities of Azure Database for MySQL to lower consumption cost whenever possible. To scale your database up and down, as needed, reference the following Microsoft Support article, which covers the automation process using runbooks: [How to autoscale an Azure Database for MySQL/PostgreSQL instance with Azure run books and Python](https://techcommunity.microsoft.com/t5/azure-database-support-blog/how-to-auto-scale-an-azure-database-for-mysql-postgresql/ba-p/369177).
- Plan your Recovery Point Objective (RPO) according to your operation level requirement. There's no extra charge for backup storage for up to `100%` of your total provisioned server storage. Extra consumption of backup storage will be charged in `GB/month`.
- The cloud native design of the Single-Server service allows it to support `99.99%` of availability, eliminating the cost of passive *hot* standby.
- Consider using Flexible Server SKU for non-production workloads. Flexible servers provide better cost optimization controls with ability to stop and start your server. They provide a burstable compute tier that is ideal for workloads that don't need continuous full compute capacity.

## Checklist

**Have you configured Azure Database for MySQL with cost optimization in mind?**
***

> [!div class="checklist"]
> - Choose the appropriate server size for your workload.
> - Consider Reserved Capacity for Azure Database for MySQL Single Server.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Database for MySQL configuration for cost optimization:

|Recommendation|Description|
|--------------|-----------|
|Choose the appropriate server size for your workload.|Configuration options: [Single Server](/azure/mysql/concepts-pricing-tiers) and [Flexible Server](/azure/mysql/flexible-server/concepts-compute-storage).|
|Consider Reserved Capacity for Azure Database for MySQL Single Server.|Compute costs associated with Azure Database For MySQL [Single Server Reservation Discount](/azure/mysql/concept-reserved-pricing). Once you've determined the total compute capacity and performance tier for Azure Database for MySQL in a region, this information can be used to reserve the capacity. The reservation can span one or three years. You can realize significant cost optimization with this commitment.|

> [!div class="nextstepaction"]
> [Azure Database for PostgreSQL and cost optimization](../azure-db-postgresql/cost-optimization.md)
