---
title: Geode Pattern
description: Deploy backend services into a set of geographical nodes, each of which can service any client request in any region.
ms.author: pnp
author: claytonsiemens77
ms.date: 11/06/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Geode pattern

Deploy a collection of backend services into a set of **ge**ographical n**ode**s, each of which can serve any request from any client in any region. This *active-active* approach distributes request processing around the globe to improve latency and increase availability.

:::image type="complex" source="./_images/geode.jpg" alt-text="World map showing geodes distributed across a global network of datacenters and edge locations." lightbox="./_images/geode.jpg":::
   Eight geodes are distributed across a world map: two in North America, two in Asia, and one each in South America, Europe, southern Africa, and Australia. The legend distinguishes geodes from datacenters, shown as blue dots, and edge locations, shown as orange dots. Dotted network lines connect locations across continents and oceans, forming a global network around the geodes.
:::image-end:::

## Context and problem

Many large-scale services face challenges with geographic availability and scale. Classic designs often *bring the data to the compute* by storing data in a remote SQL server that also processes the data. They rely on scaling up to handle growth.

The classic approach might cause the following problems:

- Users in distant regions can experience network latency when they connect to the hosting endpoint.
- Demand bursts can overwhelm services in a single region.
- Deploying copies of application infrastructure to multiple regions for a round-the-clock service can add complexity and cost.

Cloud infrastructure supports global routing and geographic data replication. To reduce latency for a geographically distributed user base, colocate compute with the regional data replicas it processes. The geode pattern *brings the compute to the data*.

## Solution

Deploy the service to multiple geographic locations. Each deployment is called a *geode*. Use a global routing service to distribute requests according to routing policies and health checks. Each geode accesses a geo-replicated data store.

Configure the data tier so that each geode can serve the same application operations within the workload's eventual consistency requirements. Geodes can observe different versions of an item while replication is in progress. The application must account for replication lag and concurrent writes, especially when requests move between geodes.

For example, an [Azure Cosmos DB for NoSQL](/azure/cosmos-db/overview) account configured with [multiple write regions](/azure/cosmos-db/multi-region-writes) can serve reads and writes in each geode's region. Azure Cosmos DB multi-region writes replicate data asynchronously.

In a [deployment stamp](./deployment-stamp.md) architecture, each stamp serves an assigned subset of users or tenants. In a geode architecture, each geode can serve the same application operations for any user and can access the data needed for those operations. Both patterns use multiple deployments; choose between them based on request eligibility and data placement.

:::image type="complex" source="./_images/geode-dist.png" alt-text="Diagram showing global request routing to four geodes with local processing and a shared data replication backplane." lightbox="./_images/geode-dist.png":::
   The diagram shows a global routing network above four geodes: Geode A in Asia Pacific, Geode B in the United States, Geode C in Europe, and Geode D in South America. Users labeled Brazil, United Kingdom, South Africa, and Sydney point to nearby network entry points. Dashed blue lines connect the entry points to all four geodes. Solid black paths show Brazil routed to Geode D, the United Kingdom and South Africa to Geode C, and Sydney to Geode A.

   Each geode contains an entry component that points to a stack of processing components. Arrows connect the processing stack to three supporting components and a database. The connections between processing and the database are bidirectional in Geodes B, C, and D and point toward the database in Geode A. A thick gray replication backplane runs along the bottom, with arrows up to each database and a return arrow from Geode A. Chain symbols mark Geodes A and B as paired and Geodes C and D as paired.
:::image-end:::

Geodes have the following characteristics:

- Each geode consists of a collection of resource types, often defined in a deployment template.
- Each geode contains the regional resources needed to serve requests without depending on another geode's application tier. Shared routing and data services can still exist in the architecture.
- Geodes are loosely coupled through global routing and a replication backplane. The routing tier directs requests to available geodes, and the data tier replicates updates between them. The application still needs an appropriate consistency model and conflict-handling strategy.

The geode pattern occurs in big data architectures that use commodity hardware to process data colocated on the same machine and MapReduce to consolidate results across machines. Another use is near-edge computing, which brings compute closer to the network edge to reduce response time.

Choose the number and placement of geodes according to the regional failures your workload must tolerate. Availability depends on healthy shared dependencies and sufficient compute and database capacity in the surviving geodes to handle redirected traffic.

## Issues and considerations

Use the following techniques and technologies to implement this pattern:

- Use DevOps practices and tools to create and deploy identical geodes across regions or instances.
- Use autoscaling to scale out compute and database throughput within each geode, subject to shared backplane constraints.
- For an HTTP API implementation, Azure Front Door provides [traffic acceleration](/azure/frontdoor/front-door-traffic-acceleration) through its edge network and [split TCP connections](/azure/frontdoor/front-door-traffic-acceleration#connect-to-the-front-door-edge-location-split-tcp).
- Use a geo-replicated data store to control data consistency. For the Cosmos DB multi-region-write example, [configure the SDK's regional routing](/azure/cosmos-db/how-to-multi-master) so that each geode reads and writes to its local database region and can use configured fallback regions.
- Consider consumption-based compute to reduce idle capacity costs when load shifts between geodes. This strategy could allow for many geodes to be deployed with minimal additional investment. Savings depend on the workload and hosting plan.
- Azure API Management is optional. Place it in front of each geode's function app when you need API-management capabilities such as rate limiting.

Consider the following points when deciding how to implement this pattern:

- Choose a [consistency level](/azure/cosmos-db/consistency-levels) that meets your read requirements when requests move between geodes.

  With Azure Cosmos DB session consistency, [return the session token to the client](/azure/cosmos-db/how-to-manage-consistency#utilize-session-tokens) and have the client include it with subsequent read requests so that read-your-writes guarantees survive routing to a different geode. In multi-region-write accounts, [use these shared tokens only for read requests](/azure/cosmos-db/multi-region-writes#best-practices-for-multi-region-writes).

  Select a [conflict resolution policy](/azure/cosmos-db/conflict-resolution-policies) for concurrent writes.

- Define the [failure modes](/azure/well-architected/reliability/failure-mode-analysis) that the workload must tolerate, including regional outages and shared dependency failures. Size surviving geodes for the redirected peak load.

- [Test regional failover and recovery](/azure/well-architected/reliability/reliability-test#validate-your-fault-tolerance-and-recovery-mechanisms) under representative load in a controlled environment. Include shared dependency failures and failback.

- Choose whether to process data locally in each region or compute aggregations in one geode and replicate the results globally. The [Azure Cosmos DB change feed processor](/azure/cosmos-db/change-feed-processor) offers this granular control using its *lease container* concept, and `LeaseContainerPrefix` in the corresponding [Azure Functions binding](/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger). Each approach has distinct advantages and drawbacks.

- Geodes can work together by using the Azure Cosmos DB change feed and a real-time communication platform like SignalR. They can communicate with remote users through other geodes in a mesh pattern without knowing or caring about those users' locations.

- Track components of the same request as they execute asynchronously on different instances or geodes. Monitor shared dependencies as well as regional resources so that you can identify correlated failures. Both Azure Front Door and Azure Cosmos DB can integrate with Log Analytics, and Azure Functions can use Application Insights for application monitoring.

- Secure ingress points at each layer of the distributed deployment.

  - Restrict Azure Cosmos DB access to the function apps.
  - For public function app origins behind Azure Front Door, [configure access restrictions](/azure/app-service/app-service-ip-restrictions#restrict-access-to-a-specific-azure-front-door-instance) that combine the `AzureFrontDoor.Backend` service tag and an `X-Azure-FDID` header filter matching your Front Door profile ID in the same allow rule. Deny unmatched requests.

  Keep API-caller authentication separate from these origin-access controls.

- Ensure each geode can access the secrets it requires from Key Vault, and coordinate provisioning and rotation for shared secrets.

- Performance depends on the number of geodes and the compute hosting model used for each geode's API. You need to evaluate the cost difference between adding geodes and increasing the capacity of each geode.

- Use zone-redundant resources where supported to reduce the effect of availability-zone failures within each geode's region. [Choose regions](/azure/cloud-adoption-framework/ready/azure-setup-guide/regions) based on latency, data residency, service availability, and recovery requirements.

- Use the [load-balancing decision tree](/azure/architecture/guide/technology-choices/load-balancing-overview#choose-a-load-balancing-solution-for-your-scenario) to select a front end for your API.

- For Front Door, [configure origin selection](/azure/frontdoor/routing-methods) to match the active-active design. Give concurrently active geodes the same priority, then configure latency sensitivity and weights.

## When to use this pattern

Use this pattern in the following scenarios:

- You need a high-scale platform for users distributed across a wide geographic area.
- Your workload must continue serving critical requests during the regional outages included in its failure model.

This pattern might not be suitable in the following scenarios:

- Your architecture restricts data or users to particular deployments, for example to meet regional data-residency requirements. Consider [deployment stamps](./deployment-stamp.md) with [data-aware routing](./deployment-stamp.md#traffic-routing) when only some deployments can serve a given user.
- Your workload can meet its requirements in a single region. Consider zone-redundant deployments where supported, and evaluate regional disaster recovery separately.
- Your application's session state or data dependencies bind requests to one region. Existing applications might need changes to state management, data replication, and deployment automation before their regional deployments can serve the same operations.
- Your availability and latency requirements don't justify geo-distribution, for example when most users and data are in one region.

## Workload design

An architect should evaluate how the Geode pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Regional deployments and data replication can help your workload tolerate one or more regional outages.<br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy)<br/> - [Regions and availability zones](/azure/well-architected/design-guides/regions-availability-zones) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Local processing and data access can reduce request latency for a distributed user base. Doing so reduces latency by eliminating long-distance traffic and because you share infrastructure only among users that are currently using the same geode.<br/><br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Examples

- Active Directory Domain Services (AD DS) in Windows Server illustrates a partial variant of this pattern. Writable domain controllers use multi-master replication for the directory partitions they host. Certain operations require a designated Flexible Single Master Operations (FSMO) role holder, so domain controllers aren't interchangeable for every operation.

- The following Azure services illustrate geographic request interchangeability:

  - **Azure Cosmos DB for NoSQL**: With multi-region writes enabled, each [configured region contains all data partitions of a container and can serve reads and writes](/azure/cosmos-db/global-distribution). These regional data-serving deployments illustrate the geodes for that account.
  - **Azure Managed Redis**: With [active geo-replication](/azure/redis/how-to-active-geo-replication), each linked regional instance can accept reads and writes against the same logical cache.
  - **Azure Front Door**: [Every Front Door point of presence can serve any request](/azure/frontdoor/front-door-traffic-acceleration). These edge locations illustrate geographically interchangeable HTTP request handlers.

## Next step

Review the [AKS baseline for multiregion clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml) for related guidance on active-active regional compute and global routing.
