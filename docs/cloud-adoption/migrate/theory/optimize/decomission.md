---
title: "Decomission Retired Assets"
description: Decomission Retired Assets
author: BrianBlanchard
ms.date: 4/4/2019
---

# Decomission Retired Assets

Once a workload is promoted to production, the assets that previously hosted the production workload are no longer required to support business operations. At that point, the older assets are considered retired. Retired assets can then be decomissioned, reducing operational costs. Decomissioning a resource can be a simple as turning off the power to the asset and disposing of the asset responsibly. Unfortunately, decommissioning resources can sometimes have undesired consequences. The following guidance can aid in properly decomissioning retired resources with minimal business interruptions.

## Cost savings realization

When cost savings are the primary motivation for a migration, decomissioning is an important step. Until an asset is decomissioned, it will continue to consume power, environmental support, and other resources that drive costs. Once the asset is decomissioned, the costs savings can start to be realized.

## Continued monitoring

After a migrated workload is promoted, it is advised that the assets to be retired continue to be monitored to validate that no additional production traffic is being routed to the wrong assets.

## Testing windows and dependency validation

Even with the best planning, production workloads may still contain dependencies on assets that are presumed retired. In such cases, turning off a retired asset could cause unexpected system failures. As such it is advised that the termination of any assets be treated with the same level of rigor as a system maintenance activity. Proper testing and outage windows should be established to facilitate the termination of the resource.

## Holding period and data validation

It's not uncommon for migrations to miss data during replication processes. This is especially true for older data that isn't used on a regular basis. After a retired asset has been turned off, it is still wise to maintain the asset for a period of time to serve as a temporary back up of the data. It is advised that companies allow at least 30 days for holding and testing before destroying retired assets.

## Next steps

Once an asset is decomissioned, the migration is completed. The [Secure and Manage](../secure-and-manage/index.md) section of this content can help prepare the reader for the transition from migration to operations.

> [!div class="nextstepaction"]
> [Secure and Manage](../secure-and-manage/index.md)