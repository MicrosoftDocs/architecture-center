


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]


This reference architecture shows how to deploy an e-commerce web site on Azure using Azure CosmosDB as data store. Azure CosmosDB is used to store products and session state. 

This archietcture also supports in-depth queries over diverse product catalogs, traffic spikes, and rapidly changing inventory.

![Architecture Diagram](../media/retail-and-e-commerce-using-cosmos-db.png)
*Download an [SVG](../media/retail-and-e-commerce-using-cosmos-db.svg) of this architecture.*

## Architecture

The architecture has following components

**Azure Kubernetes Service** (AKS). AKS is an Azure service that deploys a managed Kubernetes cluster.


### Microservices

### Data storage



## Next steps

- To learn about monitoring this architecture, see [Monitoring a microservices architecture in Azure Kubernetes Service (AKS)](../../../microservices/logging-monitoring.md).
- To learn how we measured the performance of this application, see [Performance tuning scenario: Distributed business transactions](../../../performance/distributed-transaction.md).
