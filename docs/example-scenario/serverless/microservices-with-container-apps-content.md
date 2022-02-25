
Your business can simplify the deployment and management of microservice containers by using Azure Container Apps Preview. Container Apps provides a fully managed serverless environment for building and deploying modern applications.

This example scenario demonstrates how to deploy microservice containers without needing to manage complex infrastructure and container orchestration.  

Fabrikam, Inc. (a fictional company) has implemented a drone delivery service where users can request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated delivery time. While the delivery is in progress, the customer can track the location of the drone, with a continuously updated ETA.  The application is implemented as containerized microservices and originally deployed to using Azure Kubernetes Service (AKS).

Fabrikam is achieving simplification in the following areas:

* Development
* Maintenance
* Operations
* Deployment

The Fabrikam team was able to smoothly port the Fabrikam Drone Delivery legacy app from AKS to Container Apps.  Container Apps provided a layer of abstraction at the DevOps level that reduced:

1. the complexity of the managed service by offering built-in features
1. the deployment, development and maintenance effort: deploying with Bicep templates rather than AKS Helm charts
1. the operations effort for monitoring and managing in/out cluster infrastructure with these features:
    1. External HTTPS ingress for the **Ingestion service** is managed.  
    1. Service discovery and internal ingress are managed for the rest of the background services.
    1. Run containers from any registry, the Fabrikam Drone Delivery uses ACR to publish its Docker images.
1. application operator effort for application lifecycle management: The revision feature supports running multiple or a single revision of the microservices side by side in the same compute environment.

With Azure Container Apps, Fabrikam can run their containerized applications on a flexible, serverless platform purpose-built to support microservices. Azure Container Apps runs on Azure Kubernetes Service, and includes several open-source projects: Kubernetes Event Driven Autoscaling (KEDA), Distributed Application Runtime (Dapr), and Envoy. This open-source foundation enables teams to build and run portable applications powered by Kubernetes and open standards. By applying built-in platform capabilities and teams can avoid the management complexity of working with the platform directly. 

You can find a code sample in the [Container Apps Example Scenario](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) repository.

## Potential use cases

In this example solution, the use cases are:

* Move the Fabrikam Drone Delivery legacy app from a full fleshed cluster (AKS) to Container Apps with almost no friction.
* Run background processing application such as *workflow* (consumer messaging app) using the built-in single revision feature.

Other common uses of Container Apps include:

* Deploying multiple containerized microservice containers
* Running applications in a flexible serverless platform
* Autoscaling applications based on HTTP/HTTPS traffic and KEDA triggers
* Minimizing maintenance overhead for containerized applications
* Deploying API endpoints
* Hosting background processing applications
* Handling event-driven processing

## Architecture

![Microservices Deployed with Container Apps](./media/microservices-with-container-apps-deployment.png)

In this scenario, the design decision was made to deploy the **Ingestion service** to its own Container App environment and the rest of the services to a single Container App environment.  Since the **Ingestion service** communicates with the **Workflow service** via Azure Service Bus, it doesn't need to discover the other services.  Deploying it in its own environment minimizes security risks by isolating the external ingress from the rest of the services.

The services sharing the same environment benefit from:

* a single internal VNET
* internal ingress and service discovery
* a single Log Analytics workspace for runtime logging
* secure management of secrets and certificates

Each container app is pulled from Azure Container Registry and deployed to a Container Apps environment.  

![Microservices Deployed with Container Apps](./media/microservices-with-container-apps-runtime-diagram.png)

This diagram illustrates the runtime architecture for the solution.  

### Workflow

1. **Ingestion service:** Receives client requests, buffers them and sends them via Azure Service Bus to the workflow service.
1. **Workflow service:**  Consumes messages from Azure Service Bus and dispatches them to underlying services.
1. **Package service:** Manages packages.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight.
1. **Delivery service:** Manages deliveries that are scheduled or in-transit.

### Components

The drone delivery service uses a series of Azure services in concert with one another.

**[Azure Container Apps](https://azure.microsoft.com/services/container-apps)** is fully managed serverless container service to building and deploying modern apps at scale.

Many of the complexities of the previous AKS architecture are replaced by these features:

* Built-in service discovery
* Fully managed HTTP and HTTP/2 endpoints
* Integrated load balancing
* Logging and monitoring
* Autoscaling based on HTTP traffic or events powered by KEDA
* Application upgrades and versioning


### External storage and other components

**[Azure Key Vault](https://azure.microsoft.com/services/key-vault)** service for securely storing and accessing secrets, such as API keys, passwords, and certificates.

**[Azure Container Registry](https://azure.microsoft.com/services/container-registry)** stores private container images. You can also use other container registries like Docker Hub.

**[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)** stores data using the open-source [Azure Cosmos DB API for MongoDB](/azure/cosmos-db/mongodb-introduction). Microservices are typically stateless and write their state to external data stores. Azure Cosmos DB is a NoSQL database with open-source APIs for MongoDB and Cassandra.

**[Azure Service Bus](https://azure.microsoft.com/services/service-bus)** offers reliable cloud messaging as a service and simple hybrid integration. Service Bus supports asynchronous messaging patterns that are common with microservices applications.

**[Azure Cache for Redis](https://azure.microsoft.com/services/cache)** adds a caching layer to the application architecture to improve speed and performance for heavy traffic loads.

**[Azure Monitor](/azure/azure-monitor)** collects and stores metrics and logs. Use this data to monitor the application, set up alerts and dashboards, and do root cause analysis of failures.  This scenario uses a Log Analytics workspace for comprehensive monitoring of the application.

**[Azure Resource Manager (ARM) Templates](/azure/azure-resource-manager/templates/overview) to configure and deploy the applications.

### Alternatives

An alternative scenario of this example is the Fabrikam Drone Delivery application using Kubernetes is available on GitHub in the [Azure Kubernetes Service (AKS) Fabrikam Drone Delivery](https://github.com/mspnp/aks-fabrikam-dronedelivery) repository.

## Considerations

### Availability

Deploying containers with Container Apps you can more easily manage, maintain and monitor the applications, thus increasing your application's availability.

Application updates automatically trigger revisions for zero downtime between application updates.  These revisions can be managed and traffic split between the revisions to support blue/green deployments and A/B testing.

Real-time monitoring enables you to track the execution of a container app.  You can set alerts to notify you of any problems.  When an app unexpectedly shuts down due to a coding error or resource issue, the Container Apps service automatically restarts it.  

You can enable autoscaling rules to meet demand as workloads increase. When the application scales, more replicas spawn to ensure availability.  Performance is optimized by the dynamic load balancing features of Container Apps.


### Operational excellence

To achieve operational excellence, the Container Apps service offers these features:

* Automated deployment for reliable, predictable deployments
* Revisions allow you to quickly roll forward and roll back updates
* Traffic-splitting across revisions can be enabled for blue/green deployments and A/B testing
* Azure Monitor service for logging and metrics for each the container
* CI/CD pipeline can be created for this scenario by enabling GitHub Actions

### Performance

Performance considerations in this solution:

* The workload is distributed among multiple microservice applications.
* Each microservice is independent sharing nothing with the other microservices so that they can independently scale.
* Autoscaling can be enabled as the workload increases.
* Requests are dynamically loaded balanced.
* Metrics, including CPU and memory utilization, bandwidth information and storage utilization, are available through Azure Monitor.
* Log analytics provide log aggregation to gather information across each container app.

### Reliability

When a container app shuts down due to a coding error or resource issues, the container automatically restarts.  Container Apps runs on a serverless platform that provides resiliency to hardware and other infrastructure errors.

Performance monitoring through Log Analytics and Azure Monitor allows you to evaluate the application under load.  These metrics give you the data needed to diagnose issues and perform root-cause analysis of failures.

### Security

Container Apps allows your application to securely store sensitive configuration values.  Once you define secured values at the application level, they're available to the containers across revisions, and when implemented, inside scale rules.  In this scenario uses application level secrets and environment variable values.

## Deploy this scenario

Follow the steps in the README.md in the [sample repository](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) to deploy this scenario.

## Pricing

* The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your specific scenario.
* Azure Container Apps has no costs associated with deployment, management, and operations of the Container Apps environments. You only pay for the compute and storage resources the applications consume. Autoscaling can significantly reduce costs by removing empty or unused nodes.
* In this scenario, the Azure Cosmos DB and Azure Cache for Redis services generate most of the costs.  
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
