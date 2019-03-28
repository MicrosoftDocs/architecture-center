---
title: "Promotion models - Promote, Stage, or Flight"
description: Understand the impact of promotion on migration activities
author: BrianBlanchard
ms.date: 4/4/2019
---

# Promotion models - Single Step Promotion, Stage, or Flight

Migration of a workload is often discussed as a single activity. In reality, it is a collection of smaller activities that facilitate the movement of a digital asset to the cloud. One of the last activities in a migration is the promotion of an asset to production. Promotion is the point at which the production system changes for end users. Often times it can as simple as changing the network routing, redirecting end users to the new production asset. Promotion is also the point at which IT Operations or Cloud Operations changes the focus of operational management processes from the previous production system to the new production systems.

There are a number of promotion models, this article outlines three of the most common promotion models used in cloud migrations. The choice of a promotion model will change the activities seen within the migrate and optimize processes. As such, it is suggested that promotion model be decided early in an release.

## Impact of promotion model on migrate and optimize activities

In each of the following promotion models, the chosen migration tool will replicate and stage the assets that comprise a workload. Once staged each model treats the asset a bit differently.

**Single Step Promotion:** In a single step promotion model, the staging process doubles as the promotion process. Once all assets are staged, end user traffic is re-routed and staging becomes production. In such a case, promotion is part of the migration process. This is the fastest model of migration. However, this approach makes it more difficult to integrate robust testing or optimization activities. Further, this type of model assumes that the migration team has access to the staging and production environment, which compromises separation of duty requirements in some environments.

> [!NOTE]
> The Table of Contents for this site lists the Promotion activity as part of the Optimize process. In a single step promotion model, promotion actually occurs during the migrate process. When using this model, roles and responsibilities should be updated to reflect as such.

**Stage:** In a staged promotion model, the workload is considered migrated once it is staged, but it is not yet promoted. Prior to promotion, the migrated workload undergoes a series of performance tests, business tests, and optimization changes. It is then promoted at a future date in conjunction with a business test plan. This approach improves the balance between cost and performance, while making it easier to obtain business validation.

**Flight:** The flight promotion model combines single step and staged models. In a flight model, the assets in the workload are treated like production once landing in staging. After a condensed period of automated testing, production traffic is routed to the workload. However, it is a subset of the traffic. That traffic serves as the first flight of production and testing. Assuming the workload performs from a feature and performance perspective, additional traffic is migrated. Once all production traffic has been moved onto the new assets, the workload is considered fully promoted.

The promotion model chosen will impact the sequence of activities to be performed. It will also impact the roles and responsibilities of the Cloud Adoption Team. It may also impact the composition of a sprint or multiple sprints.

## Single Step Promotion

This model leverages migration automation tools to replicate, stage, and promote assets. The assets are replicated into a contained staging environment controlled by the migration tool. Once all assets have been replicated, the tool can execute an automated process to promote the assets into the chosen subscription in a single step. While in staging, the tool continues to replicate the asset, minimizing loss of data between the two environments. Once an asset is promoted, the linkage between the source system and the replicated system is severed. If addition changes occur in the initial source systems, the changes would be lost in this approach.

**Pros:** Positive benefits of this approach.

- This model introduces less change to the target systems
- Continuous replication minimizes data loss
- If a staging process fails it can quickly be deleted and repeated
- Replication plus repeated staging tests enables an incremental scripting and testing process

**Cons:** Negative aspects of this approach.

- Assets staged within the tools isolated sandbox don't allow for complex testing models
- During replication, the migration tool will consume bandwidth in the local data center. Staging a large volume of assets over an extended period of time has an exponential impact on available bandwidth, hurting the migration process and potentially performance of production workloads in the on-premises environment

## Staged Promotion

In this model, the staging sandbox managed by the migration tool is used for limited testing purposes. The replicated assets are then deployed into the cloud environment which serves as an extended staging environment. The migrated assets run in the cloud while additional assets are replicated, staged, and migrated. When full workloads become available, richer testing is initiated. When all assets associated with a subscription have been migrated, the subscription and all hosted workloads are promoted to production. In this scenario, there is no change to the workloads during the promotion process. Instead the changes tend to be at the network and identity layers, routing users to the new environment and revoking access of the cloud adoption team.

**Pros:** Positive benefits of this approach.

- This model provides more accurate business testing opportunities
- The workload can be studied more closely to better optimize performance and cost of the assets
- Larger numbers of assets can be replicated within similar time and bandwidth constraints

**Cons:** Negative aspects of this approach.

- The chosen migration tool can not facilitate on-going replication after migration
- A secondary means of data replication is required to synchronize data platforms during the staged time frame

## Flighted Promotion

This model is similar to the staged promotion model. However, there is one fundamental difference. When the subscription is ready for promotion, end user routing happens in stages or flights. At each flight additional users are re-routed to the production systems.

**Pros:** Positive benefits of this approach.

- This model mitigates the risks associated with a big migration or promotion activity. Errors in the migrated solution can be identified with less impact to business processes.
- This model allows for monitoring of application performance demands in the cloud environment for an extended period of time, increasing accuracy of asset sizing decisions
- Larger numbers of assets can be replicated within similar time and bandwidth constraints

**Cons:** Negative aspects of this approach.

- The chosen migration tool can not facilitate on-going replication after migration
- A secondary means of data replication is required to synchronize data platforms during the staged time frame

## Next steps

Once a promotion model is defined and accepted by the Cloud Adoption Team, [Remediation of assets](./remediate.md) can begin.

> [!div class="nextstepaction"]
> [Remediate assets](./remediate.md)