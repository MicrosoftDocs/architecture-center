---
title: "Evaluate Workload Readiness"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 4/4/2019
---

# Evaluate Workload Readiness

This activity focuses on evaluating readiness of a workload to migrate to the cloud. During this activity, the Cloud Adoption Team validates that all assets and associated dependencies are compatible with the chosen deployment model and cloud provider. During the process the team will document any efforts required to [remediate](../migrate/remediate.md) compatibility issues.

## Evaluation Assumptions

Most of the content labeled as "theory" in the cloud adoption framework strives to be cloud agnostic. Unfortunately, readiness evaluation is a cloud centric process. The following guidance assumes an intention to migration to Azure. The following guidance also assumes an intention to leverage Azure Migrate (also known as Azure Site Recovery) for [replication activities](replicate.md). For alternative tools, see [Replication Options](./replicate-options.md).

This article is not intended to capture all possible evaluation activities. It is assumed that each environment and business outcome will dictate specific requirements. To help accelerate the creation of those requirements, the remainder of this article shares a few common evaluation activities related to [Infrastructure](#common-infrastructure-evaluation-activities), [Database](#common-database-evaluation-activities), and [Network](#common-network-evaluation-activities) evaluation.

## Common infrastructure evaluation activities

* VMWare Requirements: [Review the Azure Site Recovery requirements for VMWare](/azure/site-recovery/vmware-physical-azure-support-matrix)
* Hyper-V Requirements: [Review the Azure Site Recovery requirements for Hyper-V](/azure/site-recovery/hyper-v-azure-support-matrix)

Be sure to document any discrepancies in host configuration, replicated VM configuration, storage requirements or network configuration.

## Common database evaluation activities

* Document Recovery Point Objectives and Recovery Time Objectives of the current database deployment. This will be used in [Architecture activities](./architect.md) to aid in decision making
* Document any requirements for high availability configuration. For assistance understanding SQL Server requirements see the [SQL Server High Availability Solutions Guide](/sql/sql-server/failover-clusters/high-availability-solutions-sql-server)
* Evaluate PaaS compatibility: [Azure Data Migration Guide](https://datamigration.microsoft.com/) maps a number of on-premise data bases to compatible Azure PaaS solutions like [Cosmos DB](/azure/cosmos-db) or [Azure DB](/azure/sql-database/) for [MySQL](/azure/mysql/), [Postgres](/azure/postgresql/), or [MariaDB](/azure/mariadb/)
* When PaaS compatibility is an option without need for any remediation, consult the team responsible for [Architecture Activities](./architect.md). PaaS migrations can produce significant time savings and reductions in the Total Cost of Ownership (TCO) of most cloud solutions.
* When PaaS compatibility is an option, but remediation is required, consult the teams responsible for [Architecture Activities](./architect.md) and [Remediation Activities](../migrate/remediate.md). In many scenarios, the advantages of PaaS migrations for database solutions can outweigh the increase in remediation time.
* Document size and rate of change for each database to be migrated.
* When possible, document any applications or other assets that make calls to each database

> [!TIP]
> Synchronization of any asset consumes bandwidth during the replication processes. A very common pitfall, is overlooking the bandwidth consumption required to keep assets synchronized between the point of replication and release. Databases are common consumers of bandwidth during release cycles, databases with large storage footprints or a high rate of change are especially concerning. Consider an approach of replicating the data structure, with controlled updates before UAT & release. In such scenarios, alternatives to Azure Site Recovery may be more appropriate. See guidance from [Azure Data Migration Guide](https://datamigration.microsoft.com/) for more detail.

## Common network evaluation activities

* Calculate the total storage for of all VMs to be replicated during the iterations leading up to a release.
* Calculate the drift or change rate of storage for all VMs to be replicated during the iterations leading up to a release.
* Calculate the bandwidth requirements needed for each iteration by summing total storage and drift
* Calculate unused bandwidth available on the current network to validate per iteration alignment
* Document bandwidth needed to reach anticipated migration velocity. If any remediation is required to provide necessary bandwidth, notify the team responsible for [Remediation Activities](../migrate/remediate.md).

> [!NOTE]
> Total storage will directly impact bandwidth requirements during initial replication. However, storage drift will continue from the point of replication until release. This means that drift has an accumulative affect on available bandwidth.

## Next steps

Once the evaluation of a system is complete, the outputs will feed the development of a the new [cloud architecture](./architect.md).

> [!div class="nextstepaction"]
> [Architect the future state solution](./architect.md)