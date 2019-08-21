---
title: "Evaluate workload readiness"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: A process within cloud migration that focuses on the tasks of migrating workloads to the cloud.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Evaluate workload readiness

This activity focuses on evaluating readiness of a workload to migrate to the cloud. During this activity, the cloud adoption team validates that all assets and associated dependencies are compatible with the chosen deployment model and cloud provider. During the process, the team documents any efforts required to [remediate](../migrate/remediate.md) compatibility issues.

## Evaluation assumptions

Most of the content discussing principles in the Cloud Adoption Framework is intended to be cloud agnostic. However, the readiness evaluation process must be largely specific to each specific cloud platform. The following guidance assumes an intention to migrate to Azure. It also assumes use of Azure Migrate (also known as Azure Site Recovery) for [replication activities](../migrate/replicate.md). For alternative tools, see [replication options](../migrate/replicate-options.md).

This article is not intended to capture all possible evaluation activities. It is assumed that each environment and business outcome will dictate specific requirements. To help accelerate the creation of those requirements, the remainder of this article shares a few common evaluation activities related to [infrastructure](#common-infrastructure-evaluation-activities), [database](#common-database-evaluation-activities), and [network](#common-network-evaluation-activities) evaluation.

## Common infrastructure evaluation activities

- VMware requirements: [Review the Azure Site Recovery requirements for VMware](/azure/site-recovery/vmware-physical-azure-support-matrix).
- Hyper-V requirements: [Review the Azure Site Recovery requirements for Hyper-V](/azure/site-recovery/hyper-v-azure-support-matrix).

Be sure to document any discrepancies in host configuration, replicated VM configuration, storage requirements, or network configuration.

## Common database evaluation activities

- Document the Recovery Point Objectives and Recovery Time Objectives of the current database deployment. These are used in [architecture activities](./architect.md) to aid in decision-making.
- Document any requirements for high-availability configuration. For assistance understanding SQL Server requirements, see the [SQL Server High Availability Solutions Guide](/sql/sql-server/failover-clusters/high-availability-solutions-sql-server).
- Evaluate PaaS compatibility. The [Azure Data Migration Guide](https://datamigration.microsoft.com) maps on-premises databases to compatible Azure PaaS solutions, like [Cosmos DB](/azure/cosmos-db) or [Azure DB](/azure/sql-database) for [MySQL](/azure/mysql), [Postgres](/azure/postgresql), or [MariaDB](/azure/mariadb).
- When PaaS compatibility is an option without the need for any remediation, consult the team responsible for [architecture activities](./architect.md). PaaS migrations can produce significant time savings and reductions in the total cost of ownership (TCO) of most cloud solutions.
- When PaaS compatibility is an option but remediation is required, consult the teams responsible for [architecture activities](./architect.md) and [remediation activities](../migrate/remediate.md). In many scenarios, the advantages of PaaS migrations for database solutions can outweigh the increase in remediation time.
- Document the size and rate of change for each database to be migrated.
- When possible, document any applications or other assets that make calls to each database.

> [!NOTE]
> Synchronization of any asset consumes bandwidth during the replication processes. A very common pitfall is to overlook the bandwidth consumption required to keep assets synchronized between the point of replication and release. Databases are common consumers of bandwidth during release cycles, and databases with large storage footprints or a high rate of change are especially concerning. Consider an approach of replicating the data structure, with controlled updates before user acceptance testing (UAT) and release. In such scenarios, alternatives to Azure Site Recovery may be more appropriate. For more detail, see guidance from the [Azure Data Migration Guide](https://datamigration.microsoft.com).

## Common network evaluation activities

- Calculate the total storage for all VMs to be replicated during the iterations leading up to a release.
- Calculate the drift or change rate of storage for all VMs to be replicated during the iterations leading up to a release.
- Calculate the bandwidth requirements needed for each iteration by summing total storage and drift.
- Calculate unused bandwidth available on the current network to validate per iteration alignment.
- Document bandwidth needed to reach anticipated migration velocity. If any remediation is required to provide necessary bandwidth, notify the team responsible for [remediation activities](../migrate/remediate.md).

> [!NOTE]
> Total storage directly affects bandwidth requirements during initial replication. However, storage drift continues from the point of replication until release. This means that drift has a cumulative effect on available bandwidth.

## Next steps

After the evaluation of a system is complete, the outputs feed the development of a new [cloud architecture](./architect.md).

> [!div class="nextstepaction"]
> [Architect workloads prior to migration](./architect.md)
