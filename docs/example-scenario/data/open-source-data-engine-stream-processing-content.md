## Pricing

To estimate the cost of this solution, use the [Azure pricing calculator][Azure pricing calculator]. Also keep these points in mind:

- [Azure Event Hubs][Event Hubs pricing] is available in Basic, Standard, Premium, and Dedicated tiers. Most likely the Premium or Dedicated tier is best for large-scale streaming workloads. You can scale up throughput, so consider starting small and then scaling up as demand increases.
- [Azure Cosmos DB][Azure Cosmos DB pricing] offers two models:

  - A provisioned throughput model that's ideal for demanding workloads. This model is available in two capacity management options: standard and autoscale.
  - A serverless model that's better suited to run small workloads which are spiky in nature. 

- An [Azure Kubernetes Service][Azure Kubernetes Service (AKS) pricing] cluster consists of a set of nodes, or VMs, that run in Azure. The cost of the compute, storage, and networking components make up a cluster's primary costs.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL pricing] is available in Single Server, Flexible Server, and Hyperscale (Citus) tiers. Different tiers cater to different scenarios, such as predicable, burstable and high-performance workloads. The costs mainly depend on the choice of compute nodes and storage capacity.






[Azure Cosmos DB pricing]: https://azure.microsoft.com/en-us/pricing/details/cosmos-db/
[Azure Database for PostgreSQL pricing]: https://azure.microsoft.com/pricing/details/postgresql/server/
[Azure Kubernetes Service (AKS) pricing]: https://azure.microsoft.com/en-us/pricing/details/kubernetes-service/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Event Hubs pricing]: https://azure.microsoft.com/en-us/pricing/details/event-hubs/