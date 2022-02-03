# place holder

This example scenario demonstrates how to deploy microservice containers without the needing to manage complex infrastructure and container orchestration.  

Fabrikam, Inc. has implemented a drone delivery service where users can request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated delivery time. While the delivery is in progress, the customer can track the location of the drone, with a continuously updated ETA.  The application is implemented as containerized microservices and originally deployed to using Azure Kubernetes Service (AKS).

Fabrikam needed to simplify their implementation and move their platform where their application could scale to meet future demands.

With Azure Container Apps, Fabrikam can run their applications on a flexible serverless platform built for microservice applications.  Container Apps provides the powerful features of kubernetes without needing to create and maintain complicated configurations.  

In this scenario, the existing Fabrikam Drone Delivery application [Azure Kubernetes Service (AKS) implementation](https://github.com/mspnp/aks-fabrikam-dronedelivery) is instead, deployed using Container Apps.  By deploying the application in Container Apps, this architecture is streamlined by eliminating the need for many external Azure services that were required in the previous AKS implementation.

You can find this example workload on [Container Apps Example Scenario](https://github.com/mspnp/container-apps-fabrikam-dronedelivery).

## Potential use cases

The Container Apps service is a solution for microservice and containerized applications.   Common uses of Azure Container Apps include:

* Deploying applications to a serverless platform
* Deploying API endpoints
* Hosting background processing applications
* Handling event-driven processing
* Deploying applications that dynamically scale

## Architecture

![Microservices Deployed with Container Apps](./media/microservices-with-container-apps-deployment.png)

In this scenario, the design decision was made to deploy all of the microservice containers to a single Container Apps environment.  With this option, the services share the same secure environment with:

* a single internal VNET
* internal ingress and service discovery
* a single Log Analytics workspace for runtime logging
* external HTTP endpoints enabled without the need for other Azure services
* secured management of secrets and certificates

Each containers app is pulled from Azure Container Registry and added to a Container Apps environment.  

![Microservices Deployed with Container Apps](./media/microservices-with-container-apps-runtime-diagram.png)

This diagram illustrates the runtime architecture for the solution.  

### Workflow

1. **Ingest service:** Receives client requests, buffers them and sends them via Azure Service Bus to the WorkFlow service.
1. **Workflow service:**  Dispatches client requests and manages the delivery workflow.
1. **Package service:** Manages packages.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight.
1. **Delivery service:** Manages deliveries that are scheduled or in-transit.

### Components

This solution uses the following Azure components:

**[Azure Container Apps](https://azure.microsoft.com/services/container-apps)** is fully managed serverless container service to building and deploying modern apps at scale.

Many of the complexities of the previous AKS architecture are replaced by these features:

* Built-in service discovery
* Fully managed HTTP and HTTP/2 endpoints
* Integrated load balancing
* Logging and monitoring
* Autoscaling based on HTTP traffic or events powered by KEDA
* Application upgrades and versioning


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

As an alternative to a deploying all of the microservices to a single Container Apps environment, the containers could be deployed to multiple environments. Multiple environments ensure that the services don't share the same compute resources.

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

When implemented, Container Apps provides independent scaling of microservices.  Your service can scale up or down based on HTTP traffic or any KEDA-based event triggers. Scaling rules can be easily configures for each container. 

### Security

Container Apps allows your application to securely store sensitive configuration values.  Once defined at the application level, secured values are available to the containers across revisions, and when implemented, inside scale rules.  In this scenario uses GitHub secrets and environmental variable values.

### Resiliency

The Container Apps service provides resiliency by automatically restarting any container app that crashes.

### DevOps

This example uses Bicep templates for deployment. Both deployments and redeployments are run manually. 
CD/CI pipelines can be enabled by adding GitHub Actions to the container app.  

## Deploy this scenario

Follow the steps in the README.md in the [sample repository](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) to deploy this scenario.

## Pricing

* The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your specific scenario.
* Azure Container Apps has no costs associated with deployment, management, and operations of the Container Apps environments. You only pay for the compute and storage resources the applications consume. Autoscaling can significantly reduce costs by removing empty or unused nodes.
* In this scenario, the Azure Cosmos DB and Azure Cache for Redis services will consume most of the costs.  
* To avoid accruing charges, don't leave this example running.

## Next steps

* [Azure Container Apps Documentation](https://docs.microsoft.com/azure/container-apps/?branch=release-ignite-container-apps)
* [Build microservices on Azure](/azure/architecture/microservices/)

## Related resources

* [Build microservices on Azure](/azure/architecture/microservices/)
* [Design a microservices architecture](/azure/architecture/microservices/design/)
* [Microservices with AKS](/azure/architecture/solution-ideas/articles/microservices-with-aks)
* [Advanced Azure Kubernetes Service (AKS) microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
* [Microservices architecture on Azure Kubernetes Service](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
* [Microservices architecture on Azure Service Fabric](/azure/architecture/reference-architectures/microservices/service-fabric)
