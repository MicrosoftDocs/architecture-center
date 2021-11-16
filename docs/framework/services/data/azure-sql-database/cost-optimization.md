---
title: Azure SQL Database and cost optimization
description: Focuses on the Azure SQL Database service used in the Data solution to provide best-practice and configuration recommendations related to Cost Optimization.
author: v-stacywray
ms.date: 11/15/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-sql-database
categories:
  - data
  - management-and-governance
---

# Azure SQL Database and cost optimization

[Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions without user involvement. Management functions include:

- Upgrades
- Patches
- Backups
- Monitoring

This service allows you to create a highly available and high-performance data storage layer for your Azure applications and workloads. SQL Database includes built-in intelligence that helps you dramatically reduce the costs of running and managing databases through automatic performance monitoring and tuning.

For more information about how Azure SQL Database provides cost-saving features, reference [Plan and manage costs for Azure SQL Database](/azure/azure-sql/database/cost-management).

The following sections include a configuration checklist and recommended configuration options specific to Azure SQL Database and cost optimization.

## Checklist

**Have you configured Azure SQL Database with cost optimization in mind?**

> [!div class="checklist"]
> - Evaluate DTU usage.
> - Evaluate Azure SQL Database Serverless.
> - Optimize queries.
> - Consider reserved capacity for Azure SQL Database.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure SQL Database configuration for cost savings:

|Recommendation|Description|
|--------------|-----------|
|Evaluate DTU usage.|Evaluate the DTU usage for all Databases and determine if they've been sized and provisioned correctly. For non-prod Databases, consider using Basic Tier or S0 and configure the DTUs, as applicable. The DTUs can be scaled on demand, for example, when running a load test and more.|
|Evaluate Azure SQL Database Serverless.|Consider using Azure SQL Database Serverless over Provisioned Computing Tier. Serverless is a compute tier for single databases that automatically scales compute based on workload demand and bills for the amount of compute used per second. The serverless compute tier also automatically pauses databases during inactive periods when only storage is billed. It automatically resumes databases when activity returns. Azure SQL Database serverless isn't suited for all scenarios. If you have a database that isn't always heavily used and if you have periods of complete inactivity, serverless is a solution that guarantees performance and saves costs.|
|Optimize queries.|Optimize the queries, tables, and databases using Query Performance Insights and Performance Recommendations to help reduce resource consumption, and arrive at appropriate configuration.|
|Consider reserved capacity for Azure SQL Database.|You can reduce compute costs associated with Azure SQL Database by using [Reservation Discount](/azure/cost-management-billing/reservations/understand-reservation-charges). Once you've determined the total compute capacity and performance tier for Azure SQL databases in a region, you can use this information to reserve the capacity. The reservation can span one or three years. For more information, reference [Save costs for resources with reserved capacity](/azure/azure-sql/database/reserved-capacity-overview).|

## Next step

> [!div class="nextstepaction"]
> [Azure SQL Database and operational excellence](./operational-excellence.md)
