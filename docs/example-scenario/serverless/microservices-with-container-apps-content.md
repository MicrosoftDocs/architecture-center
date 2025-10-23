This example scenario shows an example of an existing workload that was originally designed to run on Kubernetes can instead run in Azure Container Apps. Azure Container Apps is well-suited for brownfield workloads where teams are looking to simplify complex infrastructure and container orchestration. The example workload runs a containerized microservices application.

The example takes the workload used in [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml) and rehosts it in Azure Container Apps as its application platform.

> [!TIP]
>
> ![GitHub logo](../../_images/github.png) The architecture is backed by an [example implementation](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) that illustrates some of design choices described in this article.

## Architecture

:::image type="content" border="false" source="./media/microservices-with-container-apps-deployment.png" alt-text="Diagram showing microservices deployed with Azure Container Apps." lightbox="./media/microservices-with-container-apps-deployment.png":::

*Download a [Visio file](https://arch-center.azureedge.net/microservices-with-container-apps.vsdx) of this architecture.*

In this scenario, the container images are sourced from Azure Container Registry and deployed to a Container Apps environment.  

The services sharing the same environment benefit from:

- Internal ingress and service discovery
- A single Log Analytics workspace for runtime logging
- Secure management of secrets and certificates

The workflow service container app is running in single revision mode. A container app running in single revision mode has a single revision, backed by zero-many replicas. A replica is composed of the application container and any required sidecar containers. This example isn't making use of sidecar containers, therefore each container app replica represents a single container. Since this example doesn't employ scaling, only one replica runs for each container app.

The workflow uses a hybrid approach to managing secrets. Managed identities are used in the services where such implementation required no code changes. The Drone Scheduler and Delivery services use user-assigned managed identities to authenticate with Azure Key Vault to access the secrets stored there. The remaining services store secrets via Container Apps service at the application level.

:::image type="content" border="false" source="./media/microservices-with-container-apps-runtime-diagram.png" alt-text="Diagram showing the runtime architecture for the solution." lightbox="./media/microservices-with-container-apps-runtime-diagram.png":::

This diagram illustrates the runtime architecture for the solution.

*Download a [Visio file](https://arch-center.azureedge.net/microservices-with-container-apps.vsdx) of this architecture.*

### Dataflow

1. **Ingestion service:** Receives client requests, buffers them and sends them via Azure Service Bus to the workflow service.
1. **Workflow service:** Consumes messages from Azure Service Bus and dispatches them to underlying services.
1. **Package service:** Manages packages.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight.
1. **Delivery service:** Manages deliveries that are scheduled or in-transit.

### Components

The drone delivery service uses a series of Azure services in concert with one another.

#### Azure Container Apps

[Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that simplifies container orchestration and management. In this architecture, Container Apps serves as the primary hosting platform for all microservices.

The following features replace many of the complexities of the previous AKS architecture:

- Built-in service discovery
- Fully managed HTTP and HTTP/2 endpoints
- Integrated load balancing
- Logging and monitoring
- Autoscaling based on HTTP traffic or events powered by Kubernetes-based Event Driven Autoscaling (KEDA)
- Application upgrades and versioning

#### External storage and other components

- **[Azure Key Vault](/azure/key-vault/general/overview)** is a cloud service for securely storing and accessing secrets, such as API keys, passwords, and certificates. In this architecture, the drone scheduler and delivery services use user-assigned managed identities to authenticate with Key Vault and retrieve secrets.

- **[Azure Container Registry](/azure/container-registry/container-registry-intro)** is a managed registry service for storing and managing private container images. In this architecture, it's the source for all container images that are deployed to the Container Apps environment. You can also use other container registries like Docker Hub.

- **[Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db)** is a globally distributed, multiple-model database service. It stores data by using the open-source [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb-introduction) API. Microservices are typically stateless and write their state to external data stores. In this architecture, Azure Cosmos DB serves as the primary NoSQL database with open-source APIs for MongoDB and Cassandra where the stateless microservices write their state and application data.

- **[Azure Service Bus](/azure/well-architected/service-guides/service-bus/reliability)** is a cloud messaging service that provides asynchronous communication capabilities and hybrid integration. In this architecture, it handles asynchronous messaging between the ingestion service and workflow service.

- **[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview)** is an in-memory caching service based on the Redis cache. In this architecture, it improves speed and performance for heavy traffic loads by providing fast data access and reducing latency for frequently accessed data in the drone delivery system.

- **[Azure Monitor](/azure/azure-monitor)** is a comprehensive monitoring solution that collects and analyzes telemetry data. In this architecture, it collects and stores metrics and logs from all application components through a Log Analytics workspace. You can use this data to monitor the application, set up alerts and dashboards, and do root cause analysis of failures.

- **[Application Insights](/azure/well-architected/service-guides/application-insights)** is an application performance management service that provides extensible monitoring capabilities. In this architecture, each service is instrumented with the Application Insights SDK to monitor application performance and direct the data to Azure Monitor for detailed service-level observability.

- **[Bicep templates](/azure/azure-resource-manager/bicep/overview)** are infrastructure-as-code templates for deploying Azure resources. In this architecture, Bicep templates provide declarative deployment for both the Container Apps infrastructure and the drone delivery workload.

### Alternatives

An alternative scenario of this example that uses Kubernetes is described in [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml).

## Scenario details

Your business can simplify the deployment and management of microservice containers by using Azure Container Apps. Container Apps provides a fully managed serverless environment for building and deploying modern applications.

Fabrikam, Inc. (a fictional company) implements a drone delivery application where users request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated delivery time.

The microservices application was deployed to an AKS cluster. However, the Fabrikam team wasn't taking advantage of the advanced or platform-specific AKS features. They eventually migrated the application to Azure Container Apps without much overhead. By porting their solution to Azure Container Apps, Fabrikam was able to take the following actions:

- Migrate the application nearly as-is: Very minimal code changes were required when moving their application from AKS to Azure Container Apps.
- Deploy both infrastructure and the workload with Bicep templates: No Kubernetes YAML manifests were needed to deploy their application containers.
- Expose the application through managed ingress: Built-in support for external, https-based ingress to expose the Ingestion Service removed the need for configuring their own ingress.
- Pull container images from ACR (Azure Container Registry): Azure Container Apps doesn't require a specific base image or registry.
- Manage application lifecycle: The revision feature supports running multiple revisions of a particular container app and traffic-splitting across them for A/B testing or Blue/Green deployment scenarios.
- Use managed identity: The Fabrikam team was able to use a managed identity to authenticate with Azure Key Vault and Azure Container Registry.

### Potential use cases

- Deploy a brownfield microservice-based application into a platform as a service (PaaS) to simplify management and avoid the complexity of running a container orchestrator.
- Optimize operations and management by migrating containerized services to a platform that supports native scale-to-zero.
- Execute a long-running background process, such as the workflow service in single revision mode.

Other common uses of Container Apps include:

- Running containerized workloads on a serverless, consumption-based platform.
- Autoscaling applications based on HTTP/HTTPS traffic and/or Event-driven triggers supported by KEDA
- Minimizing maintenance overhead for containerized applications
- Deploying API endpoints
- Hosting background processing applications
- Handling event-driven processing

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Container Apps allows you to more easily deploy, manage, maintain, and monitor the applications. You can ensure availability through the following key features:

- Revisions help you deploy application updates with zero downtime. You can use revisions to manage the deployment of application updates and split traffic between the revisions to support blue/green deployments and A/B testing (not currently used in this example workload).
- With Container Apps end-to-end observability features, you have a holistic view of your running applications. Container Apps is integrated with Azure Monitor and Log Analytics, which allows you to track container app execution, and set alerts based on metrics and events.
- When an app unexpectedly terminates, the Container Apps service automatically restarts it.
- You can enable autoscaling rules to meet demand as traffic and workloads increase.
- The dynamic load balancing features of Container Apps optimize performance (though they aren't utilized in this example workload).

Container Apps will attempt to restart failing containers and abstracts away hardware from users. Microsoft handles transient failures and ensures high availability of backing compute resources.

Performance monitoring through Log Analytics and Azure Monitor allows you to evaluate the application under load. Metrics and logging information give you the data needed to recognize trends to prevent failures and perform root-cause analysis of failures when they occur.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Secrets

- Your container app can store and retrieve sensitive values as secrets. After a secret is defined for the container app, it's available for use by the application and any associated scale rules. If you're running in multi-revision mode, all revisions share the same secrets. Because secrets are considered an application-scope change, if you change the value of a secret, a new revision isn't created. However, for any running revisions to load the new secret value, you need to restart them. In this scenario, application and environment variable values are used.
- Environment variables: sensitive values can be securely stored at the application level. When environment variables are changed, the container app spawns a new revision.

#### Network security

- Ingress: To limit external access, only the Ingestion service is configured for external ingress. The backend services are accessible only through the internal virtual network in the Container Apps environment. Only expose services to the Internet where required. Because this architecture uses the built-in external ingress feature, this solution doesn't offer the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in DDoS Protection plans. All web facing workloads should be fronted with a web application firewall.
- Virtual network: When you create an environment, you can provide a custom virtual network; otherwise, a virtual network is automatically generated and managed by Microsoft. You can't manipulate this Microsoft-managed virtual network, such as by adding network security groups (NSGs) or force tunneling traffic to an egress firewall. This example uses an automatically generated virtual network.

For more network topology options, see [Networking architecture in Azure Container Apps](/azure/container-apps/networking).

#### Workload identities

- Container Apps supports Microsoft Entra managed identities allowing your app to authenticate itself to other resources protected by Microsoft Entra ID, such as Azure Key Vault, without managing credentials in your container app. A container app can use system-assigned, user-assigned, or both types of managed identities. For services that don't support AD authentication, you should store secrets in Azure Key Vault and use a managed identity to access the secrets.
- Use managed identities for Azure Container Registry access. Azure Container Apps allows you to use a different managed identity for your workload than for container registry access. This approach is recommended for achieving granular access control over your managed identities.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your specific scenario.
- Azure Container Apps has consumption based pricing model.
- Azure Container Apps supports scale to zero. When a container app is scaled to zero, there's no charge.
- In this scenario, Azure Cosmos DB and Azure Cache for Redis are the main cost drivers.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

To achieve operational excellence, the Container Apps service offers these features:

- GitHub Actions integration for setting up automated CI/CD deployments.
- Multi-revision mode with traffic splitting for testing changes to your application code and scale rules.
- Integration with Azure Monitor and Log Analytics to provide insight into your containerized application.
- Log analytics provides log aggregation to gather information across each Container Apps environment.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance considerations in this solution:

- The workload is distributed among multiple microservice applications.
- Each microservice is independent, sharing nothing with the other microservices, so that they can independently scale.
- Autoscaling can be enabled as the workload increases.
- Requests are dynamically load balanced.
- Metrics, including CPU and memory utilization, bandwidth information and storage utilization, are available through Azure Monitor.

## Deploy this scenario

Follow the steps in the README.md in the [Azure Container Apps example scenario](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) repository.

## Contributors

*Microsoft maintains this article. It was originally written by the following contributors.*

Principal author:

- [Catherine Bundy](https://www.linkedin.com/in/catherine-bundy) | Technical Writer

## Next steps

- [Azure Container Apps Documentation](/azure/container-apps/)

## Related resources

- [Microservices architecture style](/azure/architecture/guide/architecture-styles/microservices)
- [Design a microservices architecture](/azure/architecture/microservices/design/)
- [CI/CD for AKS apps with Azure Pipelines](/azure/architecture/guide/aks/aks-cicd-azure-pipelines)
- [Advanced AKS microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
