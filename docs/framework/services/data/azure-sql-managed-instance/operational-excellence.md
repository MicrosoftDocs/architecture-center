---
title: Azure SQL Managed Instance and operational excellence
description: Focuses on the Azure SQL Managed Instance service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Operational Excellence.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-sql-managed-instance
categories:
  - data
  - management-and-governance
---

# Azure SQL Managed Instance and operational excellence

[Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) is the intelligent, scalable cloud database service that combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service.

The goal of the high availability architecture in SQL Managed Instance is to guarantee that your database is up and running without worrying about the impact of maintenance operations and outages. This solution is designed to:

- Ensure that committed data is never lost because of failures.
- Ensure that maintenance failures don't affect your workload.
- Ensure that the database won't be a single point of failure in your software architecture.

For more information about how Azure SQL Managed Instance supports operational excellence for your application workloads, reference the following articles:

- [Overview of Azure SQL Managed Instance management operations](/azure/azure-sql/managed-instance/management-operations-overview?branch=master#what-are-management-operations)
- [Monitoring Azure SQL Managed Instance management operations](/azure/azure-sql/managed-instance/management-operations-monitor?branch=master&tabs=azure-portal)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure SQL Managed Instance, and operational excellence.

## Design considerations

Azure SQL Managed Instance includes the following design considerations:

- Define an application performance SLA and monitor it with alerts. Detecting quickly when your application performance inadvertently degrades below an acceptable level is important to maintain high resiliency. Use a monitoring solution to set alerts on key query performance metrics so you can take action when the performance breaks the SLA.
- Use point-in-time restore to recover from human error. Point-in-time restore returns your database to an earlier point in time to recover data from changes done inadvertently. For more information, read the [Point-in-time-restore (PITR)](/azure/azure-sql/database/recovery-using-backups#point-in-time-restore) documentation for managed instance.
- Use geo-restore to recover from a service outage. Geo-restore restores a database from a geo-redundant backup into a managed instance in a different region. For more information, reference [Recover a database using Geo-restore documentation](/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell).
- Consider the time required for certain operations. Make sure you separate time to thoroughly test the amount of time required to scale up and down your existing managed instance, and to create a new managed instance. This timing practice ensures that you understand completely how time consuming operations will affect your RTO and RPO.

## Checklist

**Have you configured Azure SQL Managed Instance with operational excellence in mind?**

> [!div class="checklist"]
> - Use the Business Critical Tier.
> - Configure a secondary instance and an Autofailover group to enable failover to another region.
> - Implement Retry Logic.
> - Monitor your SQL MI instance in near-real time to detect reliability incidents.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure SQL Managed Instance configuration for operational excellence:

|Recommendation|Description|
|--------------|-----------|
|Use the Business Critical Tier.|This tier provides higher resiliency to failures and faster failover times because of the underlying HA architecture, among other benefits. For more information, reference [SQL Managed Instance High availability](/azure/azure-sql/database/high-availability-sla).|
|Configure a secondary instance and an Autofailover group to enable failover to another region.|If an outage impacts one or more of the databases in the managed instance, you can manually or automatically failover all the databases inside the instance to a secondary region. For more information, read the [Autofailover groups documentation for managed instance](/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell).|
|Implement Retry Logic.|Although Azure SQL MI is resilient to transitive infrastructure failures, these failures might affect your connectivity. When a transient error occurs while working with SQL MI, make sure your code can retry the call. For more information, reference how to [implement retry logic](/azure/azure-sql/database/troubleshoot-common-connectivity-issues).|
|Monitor your SQL MI instance in near-real time to detect reliability incidents.|Use one of the available solutions to monitor your SQL MI to detect potential reliability incidents early and make your databases more reliable. Choose a near real-time monitoring solution to quickly react to incidents. For more information, check out the [Azure SQL Managed Instance monitoring options](https://techcommunity.microsoft.com/t5/azure-sql/monitoring-options-available-for-azure-sql-managed-instance/ba-p/1065416).

## Next step

> [!div class="nextstepaction"]
> [Cosmos DB and reliability](../cosmos-db/reliability.md)
