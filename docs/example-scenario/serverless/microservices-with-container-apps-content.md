This scenario shows an existing workload originally designed for Kubernetes that is replatformed to run in Azure Container Apps. Azure Container Apps is well suited for brownfield workloads where teams want to simplify infrastructure and container orchestration.

The example workload is a containerized microservices application. It reuses the same workload defined in [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml). This architecture rehosts it in Azure Container Apps as its application platform.

> [!IMPORTANT]
> This architecture focuses on minimizing application code changes and approaching the transition from AKS to Azure Container Apps as a platform migration. The goal is a like-for-like implementation, deferring code or infrastructure optimizations that might put the migration at risk.
>
> For a greenfield workload, see [Deploy Microservices with Azure Container Apps and Dapr](./microservices-with-container-apps-dapr.yml).

> [!TIP]
> ![GitHub logo](../../_images/github.png) The architecture is backed by an [example implementation](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) that illustrates some of the design choices described in this article.

## Architecture

:::image type="complex" border="false" source="./media/microservices-with-container-apps-runtime-diagram.png" alt-text="Diagram showing the runtime architecture for the solution." lightbox="./media/microservices-with-container-apps-runtime-diagram.png":::
   The diagram shows an Azure Container Apps environment as a large rectangle containing five container apps. At the far left an HTTP traffic source arrow points right into the Ingestion service at the upper left of the environment. An upward arrow from Ingestion goes to Azure Service Bus above the environment, and a downward arrow from Azure Service Bus returns to the Workflow service centered in the top row. From Workflow, three black connectors descend and bend toward each lower service: left to Package service, straight down to Drone Scheduler service, and right to Delivery service. Each lower service has a vertical arrow to its own external state store placed below the environment: Package service to Azure Cosmos DB for MongoDB API, Drone Scheduler service to Azure Cosmos DB, and Delivery service to Azure Managed Redis. Two rightward arrows exit the middle of the environment: the upper goes to Azure Application Insights and the lower to Azure Log Analytics workspace. Below the workspace is Azure Key Vault and below that Azure Container Registry, shown without connecting arrows. Microsoft Azure branding appears at the lower left outside the environment.
:::image-end:::

This diagram illustrates the runtime architecture for the solution.

*Download a [Visio file](https://arch-center.azureedge.net/microservices-with-container-apps.vsdx) of this architecture.*

The services sharing the same environment benefit from:

- Internal ingress and service discovery
- A single Log Analytics workspace for runtime logging
- Secure management of secrets and certificates

### Dataflow

1. **Ingestion service:** Receives client requests, buffers them and sends them via Azure Service Bus to the workflow service. This is the only ingress point into the workload.
1. **Workflow service:** Consumes messages from Azure Service Bus and dispatches them to underlying microservices.
1. **Package service:** Manages packages. The service maintains its own state in Azure Cosmos DB.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight. The service maintains its own state in Azure Cosmos DB.
1. **Delivery service:** Manages deliveries that are scheduled or in-transit. The service maintains its own state in Azure Managed Redis.
1. Because this is an existing workload, only some components access Azure Key Vault to obtain runtime secrets. The other services receive those secrets from the Container Apps environment.
1. The environment and all container apps emit logs and metrics that Azure Monitor collects and visualizes.
1. Container images are pulled from the existing Azure Container Registry previously used for AKS and deployed into the Container Apps environment.

### Components

This workload uses a series of Azure services in concert with one another.

- [Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that simplifies container orchestration and management. In this architecture, Container Apps serves as the primary hosting platform for all microservices.

  The following features replace many of the capabilities of the previous AKS architecture:

  - Built-in service discovery
  - Managed HTTP and HTTP/2 endpoints
  - Integrated load balancing
  - Logging and monitoring
  - Autoscaling based on HTTP traffic or events powered by Kubernetes-based Event Driven Autoscaling (KEDA)
  - Application upgrades and versioning

- **[Azure Container Registry](/azure/container-registry/container-registry-intro)** is a managed registry service for storing and managing private container images. In this architecture, it's the source for all container images that are deployed to the Container Apps environment. This is the same registry that was used in the AKS implementation.

- **[Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db)** is a globally distributed, multiple-model database service. It stores data by using the open-source [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb-introduction) API. Microservices should write their state to a dedicated external data stores. In this architecture, Azure Cosmos DB serves as the primary NoSQL database with open-source APIs for MongoDB and SQL where the microservices write their state and application data.

- **[Azure Service Bus](/azure/well-architected/service-guides/service-bus/reliability)** is a cloud messaging service that provides asynchronous communication capabilities and hybrid integration. In this architecture, it handles asynchronous messaging between the ingestion service and workflow microservice. The rest of the services were designed to be invoked via HTTP requests.

- **[Azure Managed Redis](/azure/redis/overview)** is an in-memory caching service. In this architecture, it reduces latency and improves throughput for frequently accessed drone delivery data.

- **[Azure Key Vault](/azure/key-vault/general/overview)** is a cloud service for securely storing and accessing secrets, such as API keys, passwords, and certificates. In this architecture, the drone scheduler and delivery services use user-assigned managed identities to authenticate with Key Vault and retrieve secrets needed for their runtime requirements.

- **[Azure Monitor](/azure/azure-monitor)** is a comprehensive monitoring solution that collects and analyzes telemetry data. In this architecture, it collects and stores metrics and logs from all application components through a Log Analytics workspace. You use this data to monitor the application, set up alerts and dashboards, and do root cause analysis of failures.

  **[Application Insights](/azure/well-architected/service-guides/application-insights)** is an application performance management service that provides extensible monitoring capabilities. In this architecture, each service is instrumented with the Application Insights SDK to monitor application performance.

### Alternatives

An alternative scenario of this example that uses Kubernetes is described in [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml).

## Scenario details

You can simplify deployment and management of microservice containers by using Azure Container Apps, a serverless environment for building and deploying containerized applications.

Fabrikam, Inc., a fictional company, implements a drone delivery workload where users request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated delivery time.

The microservices application was deployed to an AKS cluster. However, the Fabrikam team wasn't taking advantage of the advanced or platform-specific AKS features. They migrated the application to Azure Container Apps. By porting their solution to Azure Container Apps, Fabrikam was able to take the following actions:

- Migrate the application nearly as-is: Minimal code changes were required when moving the application from AKS to Azure Container Apps.
- Deploy both infrastructure and the workload with Bicep templates: No Kubernetes YAML manifests were needed to deploy their application containers.
- Expose the application through managed ingress: Built-in support for external, https-based ingress to expose the Ingestion Service removed the need for configuring their own ingress.
- Pull container images from ACR (Azure Container Registry): Azure Container Apps doesn't require a specific base image or registry.
- Manage application lifecycle: The revision feature supports running multiple revisions of a particular container app and traffic-splitting across them for A/B testing or Blue/Green deployment scenarios.
- Use managed identity: The Fabrikam team was able to use a managed identity to authenticate with Azure Key Vault and Azure Container Registry.

### Potential use cases

Deploy a brownfield microservice-based application into a platform as a service (PaaS) to simplify management and avoid the complexity of running a container orchestrator. This brownfield workload also experienced cost savings using this architecture over its Kubernetes deployment due to its choice of workload profiles.

Other common uses of Container Apps include:

- Running containerized workloads on a serverless, consumption-based platform.
- Autoscaling applications based on HTTP/HTTPS traffic and event-driven triggers supported by KEDA
- Minimizing maintenance overhead for containerized applications
- Deploying API endpoints
- Hosting background processing applications
- Handling event-driven processing

## Optimizations

The goal of the workload team was to migrate the existing workload to Container Apps with minimal code changes. However, there are several optimizations that should be made to improve the architecture and implementation of the workload after migration.

### Avoid designs that require single revision mode

The workflow service container app runs in single revision mode. In this mode the app has one revision backed by zero or more replicas. A replica is composed of the application container and any required sidecars. This example doesn't use sidecars, so each replica is a single container. The workflow service was not designed for forward compatibility with message schemas. Ensuring two different versions of the service don't run concurrently is important.

If the Service Bus message schema must change, you must drain the bus before deploying the new workflow service version. A better approach is to update the service code for forward compatibility and use multi-revision mode to reduce downtime associated with draining queues.

### Improve secret management

The workload uses a hybrid approach to managing secrets. Managed identities are used in the services where the change required no code modifications. The Drone Scheduler and Delivery services use user-assigned managed identities with Azure Key Vault to access stored secrets. The remaining services required code changes to adopt managed identities, so those services use secrets provided by the Container Apps environment.

A better approach is to update all code to support managed identities, using the app or job identity instead of environment-provided secrets.

### Consider job-based work

The workflow service is implemented as a long-running container app. However, it should run as a [Job in Azure Container Apps](/azure/container-apps/jobs). A job is a containerized application that runs to completion based on work to be done. Migrating this service to run as an Azure Container Apps job, based on work available in the queue, might be a reasonable approach to explore based on typical queue volume and how finite, parallelizable, and resource optimized the workflow service could be written.

### Implement ingress control

The workload uses the built-in external ingress feature of Container Apps to expose the Ingestion service. This approach doesn't offer the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in DDoS Protection plans. All web facing workloads should be fronted with a web application firewall. To achieve this, you should disable the built-in public ingress and add Application Gateway to front the Container Apps environment.

### Modernization with Dapr

The workload could be further modernized by integrating with [Dapr (Distributed Application Runtime)](https://dapr.io/). This would add abstraction between workload code and state stores, messaging systems, and service discovery mechanisms. For more information, see [Deploy Microservices with Azure Container Apps and Dapr](./microservices-with-container-apps-dapr.yml).

### Migrate to user authentication and authorization

The workload does not delegate authorization to a gateway; the ingestion service handles authorization of its clients. A better approach is offload this responsibility to the [built-in authentication and authorization feature](/azure/container-apps/authentication) (often referred to as "Easy Auth"). This change will take advantage of platform capabilities and reduce custom code in the ingestion microservice.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Container Apps allows you to deploy, manage, maintain, and monitor the applications in this workload. You can improve reliability by following core recommendations. Some were implemented during migration from Kubernetes.

- Revisions help you deploy application updates with zero downtime. You can use revisions to manage the deployment of application updates and split traffic between the revisions to support blue/green deployments and A/B testing.

- With Container Apps observability features, you have insight into components running within the environment. Container Apps integrates with Azure Application Insights and Log Analytics, which allows you to track execution and set alerts based on metrics and events.

  Performance monitoring allows you to evaluate the application under load. Metrics and logs provide data to recognize trends, investigate failures, and perform root-cause analysis.

- Use [health and readiness probes](/azure/container-apps/health-probes) to handle slow-starting containers and avoid sending traffic before they are ready. The Kubernetes implementation already had these endpoints; continue using them if they are effective signals.

- When a service unexpectedly terminates, Container Apps automatically restarts it. Service discovery is enabled so that the workflow service can discover its downstream microservices. Use [resiliency policies](/azure/container-apps/service-discovery-resiliency) to handle timeouts and introduce circuit breaker logic without needing to further adjust the code.

- You should enable autoscaling rules to meet demand as traffic and workloads increase.

- Use dynamic load balancing and scaling features of Container Apps improve availability. Your environment's subnet should be over provisioned so that it never falls short of [available IPs for future replicas or jobs](/azure/container-apps/custom-virtual-networks?tabs=workload-profiles-env#subnet).

- Avoid storing state directly within the Azure Container Apps environment; externalize to a dedicated state store per microservice. In this architecture, state is distributed across three distinct stores.

- All resources, including Azure Container Apps, should be deployed using a multi-zone topology.  For more details on availability zone support, see [Availability zone support in Azure Container Apps](/azure/reliability/reliability-azure-container-apps#availability-zone-support).

  Set the minimum replica count for non-transient applications to at least three. Replicas should be distributed across availability zones in the region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Secrets

- Your container app can store and retrieve sensitive values as secrets. After a secret is defined for the container app, it's available for use by the application and any associated scale rules. If you're running in multi-revision mode, all revisions share the same secrets. Because secrets are considered an application-scope change, if you change the value of a secret, a new revision isn't created. However, for any running revisions to load the new secret value, you need to restart them. In this scenario, application and environment variable values are used.

  Service code should be rewritten to use the app's own managed identity to authenticate to dependencies instead of using preshared secrets. All dependencies have SDKs that support managed identity authentication.

- Environment variables: Sensitive values can be securely stored at the application level. When environment variables change, the container app spawns a new revision.

#### Network security

- Ingress: To limit external access, only the Ingestion service is configured for external ingress. The backend services are accessible only through the internal virtual network in the Container Apps environment and are configured as internal mode. Only expose services to the Internet where required. Because this architecture uses the built-in external ingress feature, this solution doesn't offer the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in DDoS Protection plans. All web facing workloads should be fronted with a web application firewall. For ingress improvements, see [Implement ingress control](#implement-ingress-control) in the Optimizations section.
- Virtual network: When you create an environment, you can provide a custom virtual network; otherwise, a virtual network is automatically generated and managed by Microsoft. You can't manipulate this Microsoft-managed virtual network, such as by adding network security groups (NSGs) or force tunneling traffic to an egress firewall. This example uses an automatically generated virtual network, which should be improved by using a custom virtual network, giving you more security control such as [Network Security Groups](/azure/container-apps/firewall-integration) and UDR-based routing through Azure Firewall.

For more network topology options, including private endpoint support for ingress, see [Networking architecture in Azure Container Apps](/azure/container-apps/networking).

#### Workload identities

- Container Apps supports Microsoft Entra managed identities allowing your app to authenticate itself to other resources protected by Microsoft Entra ID, such as Azure Key Vault, without managing credentials in your container app. A container app can use system-assigned, user-assigned, or both types of managed identities. For services that don't support AD authentication, you should store secrets in Azure Key Vault and use a managed identity to access the secrets.
- Use managed identities for Azure Container Registry access. Azure Container Apps allows use of a different managed identity for workload execution than for container registry access. This approach provides granular access control.
- Use system-assigned managed identities for workload identities, tying the identity lifecycle to the workload component lifecycle.

#### Additional security recommendations

- This same workload was previously protected with the Kubernetes capabilities found in [Azure Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction). Defender for Containers in this architecture is limited to only performing [vulnerability assessments](/azure/defender-for-cloud/agentless-vulnerability-assessment-azure#how-vulnerability-assessment-for-images-and-containers-works) of the containers in your Azure Container Registry.

- Don't run the workload in a shared Azure Container Apps environment. Segment it from other workloads or components that don't need access to these microservices.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Review an example price estimate for this workload, use the [Azure pricing calculator](https://azure.com/e/4f044f65e46f40c7a9d7a4837a17e6d7). Configurations vary, so adjust this to match your scenario.

- In this scenario, Azure Cosmos DB and Azure Managed Redis are the main cost drivers.

- Use a dedicated workload profile for components with predictable usage that can share dedicated nodes. For cost optimization, maintain a multiple of three nodes per dedicated profile to ensure sufficient replica distribution across availability zones.

- Eliminate compute costs during periods of inactivity by ensuring components can scale to zero so you only pay when needed. This reduces expenses for apps with variable or infrequent usage. In this architecture the workflow service could be re-implemented as a job to take advantage of scale-to-zero during idle periods. This couples well with workloads that can use a [consumption plan](/azure/container-apps/plans#consumption).

- To avoid cross-region network charges, deploy all components such as state stores and the container registry in the same region.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use GitHub Actions integration for setting up automated CI/CD deployments.

- Use multi-revision mode with traffic splitting for testing changes to your workload code and scale rules.

- Integrate with Application Insights and Log Analytics to provide insight into your workload. Use the same log analytics workspace as the rest of your workload's components to keep all workload insights together.

- Use infrastructure-as-code, such as Bicep or Terraform to manage all infrastructure deployments, including the Azure Container Apps environment, container registry, and microservice state stores. Separate the microservice deployment pipelines from the infrastructure pipelines as they often do not share a similar lifecycle. This means your pipeline for Azure infrastructure should deploy all but the container app resources.

- Use an imperative approach to creating, updating, and removing container apps from the environment, especially if you'll be dynamically adjusting traffic shifting logic between revisions. Use a [GitHub action](https://github.com/marketplace/actions/azure-container-apps-build-and-deploy) or [Azure Pipelines task](https://github.com/microsoft/azure-pipelines-tasks/tree/master/Tasks/AzureContainerAppsV1) in your deployment workflows. This imperative approach can be based on [yaml](/azure/container-apps/azure-resource-manager-api-spec?tabs=yaml#container-app-examples) app definitions. To minimize health check failures, always make sure your pipeline populates your container registry with the new container image prior to deploying the container app.

  An important change from the Kubernetes implementation is the shift from managing Kubernetes manifest files, such as defining `Deployment` Kubernetes objects. Kubernetes provides an atomic *succeeds together* or *fails together* approach to microservice deployment, through this manifest object. In Azure Container Apps, each microservice is deployed independently. Your deployment pipelines become responsible for orchestrating any sequencing and rollback strategy necessary to have a safe deployment.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance considerations in this solution:

- The workload is distributed among multiple microservice applications.
- Each microservice is independent and shares nothing with other microservices, allowing independent scaling.
- Use Container Apps jobs for finite process execution to implement transient runtimes and reduce resource consumption for idle services. Evaluate the performance impact of spinning jobs up and down versus keeping components warm and ready.
- Autoscaling is enabled. Prefer event-based scaling over metric-based scaling where possible. For example, the workflow service, if designed to support it, could scale based on Service Bus queue depth.
- Requests are dynamically load balanced.
- Metrics, including CPU and memory utilization, bandwidth information and storage utilization, are available through Azure Monitor.

## Deploy this scenario

Follow the steps in the README.md in the [Azure Container Apps example scenario](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) repository.

## Contributors

*Microsoft maintains this article. It was originally written by the following contributors.*

Principal author:

- [Catherine Bundy](https://www.linkedin.com/in/catherine-bundy/) | Technical Writer

Other contributors:

- [Julien Strebler](https://www.linkedin.com/in/julien-strebler-57647490/) | Cloud Solution Architect
- [Steve Caravajal](https://www.linkedin.com/in/stevecaravajal/) | Cloud Solution Architect
- [Simon Kurtz](https://www.linkedin.com/in/simonkurtz/) | Cloud Solution Architect

## Next steps

- [Azure Container Apps Documentation](/azure/container-apps/)

## Related resources

- [Microservices architecture style](/azure/architecture/guide/architecture-styles/microservices)
- [Design a microservices architecture](/azure/architecture/microservices/design/)
- [CI/CD for AKS apps with Azure Pipelines](/azure/architecture/guide/aks/aks-cicd-azure-pipelines)
- [Advanced AKS microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
