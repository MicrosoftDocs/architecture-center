Your business can simplify the deployment and management of microservice containers by using Azure Container Apps. Container Apps provides a fully managed serverless environment for building and deploying modern applications.

To illustrate, we use the [Fabrikam Drone Delivery](https://github.com/mspnp/aks-fabrikam-dronedelivery) application that ran in Azure Kubernetes Service (AKS) and deployed it using Container Apps. You can find this scenario on [GitHub](https://github.com/mspnp/container-apps-fabrikam-dronedelivery).

## Potential use cases

The Container Apps service is a solution for microservice applications that benefit from:

* Deploying many microservices in a single container environment.
* The flexibility of serverless environments.
* Autoscaling based on HTTP traffic or Kubernetes Event-Driven Autoscaling (KEDA) triggers.
* Kubernetes features without the need to access the Kubernetes API.

## Architecture

![Microservices Deployed with Container Apps](./media/microservices-with-container-apps-diagram.png)

### Workflow

1. Ingestion service: Receives client requests, buffers them and send them via Azure Service Bus to the WorkFlow service.
1. Workflow service:  Dispatches client requests and manages the delivery workflow.
1. Package service: Manages packages.
1. Drone scheduler service: Schedules drones and monitors drones in flight.
1. Delivery service: Manages deliveries that are scheduled or in-transit.

Each containerized microservice is stored in a container app.  These container apps deployed to single Azure Container Apps environment.  The Container Apps environment is configured with a [Log Analytics workspace](https://docs.microsoft.com/azure/azure-monitor/logs/design-logs-deployment), which is used by the Azure Monitor service. Container Apps in the same environment share the same virtual network and write logs to the same Log Analytics workspace.

### Components

This solution uses the following Azure components:

**[Azure Container Apps](https://azure.microsoft.com/services/container-apps)** is an Azure offering that provides serverless, managed platform.

**External storage and other components:**

**[Azure Key Vault](https://azure.microsoft.com/services/key-vault)** service for securely storing and accessing secrets, such as API keys, passwords, and certificates.

**[Azure Container Registry](https://azure.microsoft.com/services/container-registry)** stores private container images. You can also use other container registries like Docker Hub.

**[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)** stores data using the open-source [Azure Cosmos DB API for MongoDB](/azure/cosmos-db/mongodb-introduction). Microservices are typically stateless and write their state to external data stores. Azure Cosmos DB is a NoSQL database with open-source APIs for MongoDB and Cassandra.

**[Azure Service Bus](https://azure.microsoft.com/services/service-bus)** offers reliable cloud messaging as a service and simple hybrid integration. Service Bus supports asynchronous messaging patterns that are common with microservices applications.

**[Azure Cache for Redis](https://azure.microsoft.com/services/cache)** adds a caching layer to the application architecture to improve speed and performance for heavy traffic loads.

**[Azure Monitor](/azure/azure-monitor)** collects and stores metrics and logs. Use this data to monitor the application, set up alerts and dashboards, and do root cause analysis of failures.  This scenario uses a Log Analytics workspace for comprehensive monitoring of the application.

### Alternatives

An alternative scenario of this example is the Fabrikam Drone Delivery application using Kubernetes can be found [here](https://github.com/mspnp/aks-fabrikam-dronedelivery).

Instead of using Azure Service Bus, messaging between the microservices can be implemented with [Dapr](https://dapr.io/) (Distributed Application Runtime).  

## Considerations

### Availability

Although not implemented in this scenario, high availability can be achieved with Container Apps autoscaling.  Autoscaling dynamically scales container app instances based on HTTP traffic or any KEDA-based triggers.

### Operations

For easy management and maintenance of the application:

* Revisions are dynamically deployed when a container app is updated.
* The Azure Monitor service enables monitoring and analysis of the application.
* Traffic-splitting across revisions can be enabled for blue/green deployments and A/B testing.

### Performance

Factors affecting performance are:

* The cpu and memory resource configuration.
* The autoscaling criteria.

### Scalability

When needed, the Container Apps service supports scaling based on HTTP traffic and any KEDA-based triggers.  Scaling can be easily added to the container app configuration.

### Security

This scenario users Azure Key Vault to securely store and access secrets.  

### Resiliency

The Container Apps service provides resiliency by automatically restarting any container app that crashes.

### DevOps

This example uses Bicep templates for deployment. Both deployments and redeployments are run manually. 
CD/CI pipelines can be enabled by adding GitHub Actions to the container apps.  

## Deploy this scenario

Follow the steps in the README.md in the [sample repository](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) to deploy this scenario.

## Pricing

* The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your specific scenario.
* Azure Container Apps has no costs associated with deployment, management, and operations of the Container Apps environments. You only pay for the compute and storage resources the applications consume. Autoscaling can significantly reduce costs by removing empty or unused nodes.
* In this scenario, the Azure Cosmos DB and Azure Cache for Redis services will consume most of the costs.  
* To avoid accruing charges, don't leave this example running.

## Next steps

* [Azure Container Apps Documentation](/azure/container-apps/?branch=release-ignite-container-apps)
* [Build microservices on Azure](/azure/architecture/microservices/)

## Related resources

* [Build microservices on Azure](/azure/architecture/microservices/)
* [Design a microservices architecture](/azure/architecture/microservices/design/)
* [Microservices with AKS](/azure/architecture/solution-ideas/articles/microservices-with-aks)
* [Advanced Azure Kubernetes Service (AKS) microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
* [Microservices architecture on Azure Kubernetes Service](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
* [Microservices architecture on Azure Service Fabric](/azure/architecture/reference-architectures/microservices/service-fabric)
