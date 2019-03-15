---
title: "Staging activities during a migration"
description: Staging activities during a migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Staging activities during a migration

As described in the article on promotion models, staging is the point at which assets have been "migrated" to the cloud. However, they are not yet ready to be promoted to production. This is often the last step in the Migrate process of a migration. Once staged, the workload is managed by an IT Operations or Cloud Operations team to prepare the workload for production usage.

## Deliverables

Staged assets may not be ready to be used in production. However, there are a number of production readiness checks that should be completed before this stage is considered complete. The following area a list of deliverables often associated with completion of asset staging.

- **Automated Testing:** Any automated tests available to validate application performance should be run before concluding the staging process. Once the asset leaves staging, synchronization with the original, source system is terminated. As such, it is harder to re-deploy the replicated assets, once the assets are staged for optimization.
- **Migration Documentation:** Most migration tools can produce an automated report of the assets being migrated. Before concluding the staging activity, it is suggested that all migrated assets be documented for clarity.
- **Configuration Documentation:** Any changes made to an asset (during remediation, replication, or staging) should be documented for operational readiness.
- **Backlog documentation:** The Migration Backlog should be updated to reflect the workload and assets staged.

## Next steps

Once staged assets are tested and documented, the process can proceed to [optimization activities](../optimize/index.md).

> [!div class="nextstepaction"]
> [Optimize](../optimize/index.md)