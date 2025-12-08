This scenario shows an existing workload originally designed for Kubernetes, which is replatformed to run in Azure Container Apps. Container Apps supports brownfield workloads where teams want to simplify infrastructure and container orchestration.

The example workload is a containerized microservices application. It reuses the same workload defined in [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml). This architecture rehosts the workload in Container Apps as its application platform.

> [!IMPORTANT]
> This architecture focuses on minimizing application code changes and approaching the transition from AKS to Container Apps as a platform migration. The goal is to replicate the existing implementation and defer code or infrastructure optimizations that can compromise the migration.
>
> For a greenfield workload, see [Deploy microservices by using Container Apps and Dapr](./microservices-with-container-apps-dapr.yml).

> [!TIP]
> :::image type="icon" source="../../_images/github.png"::: An [example implementation](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) supports this architecture and illustrates some of the design choices described in this article.

## Architecture

:::image type="complex" border="false" source="./media/microservices-with-container-apps.svg" alt-text="Diagram that shows the runtime architecture for the solution." lightbox="./media/microservices-with-container-apps.svg":::
   The diagram shows a Container Apps environment as a large rectangle that contains five container apps. An HTTP traffic source arrow points into the Ingestion service. An upward arrow from Ingestion goes to Azure Service Bus. A downward arrow goes from Service Bus and returns to the Workflow service. From Workflow, three black connectors descend and bend toward each lower service: the Package, the Drone Scheduler, and the Delivery services. Each lower service has a vertical arrow to its own external state store: Package service goes to Azure DocumentDB. Drone Scheduler service goes to Azure Cosmos DB for NoSQL. Delivery service goes to Azure Managed Redis. Two arrows exit the middle of the environment: the upper arrow goes to Azure Application Insights. The lower arrow goes to Azure Log Analytics workspace. Under the workspace is Azure Key Vault and below that Azure Container Registry, shown without connecting arrows.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/microservices-with-container-apps.vsdx) of this architecture.*

Services that share the same environment benefit in the following ways:

- Internal ingress and service discovery
- A single Log Analytics workspace for runtime logging
- A secure management method for secrets and certificates

### Data flow

1. **Ingestion service:** Receives client requests, buffers them, then publishes them to Azure Service Bus. It's the only ingress point into the workload.

1. **Workflow service:** Consumes messages from Service Bus and dispatches them to underlying microservices.
1. **Package service:** Manages packages. The service maintains its own state in Azure Cosmos DB.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight. The service maintains its own state in Azure Cosmos DB.
1. **Delivery service:** Manages scheduled or in-transit deliveries. The service maintains its own state in Azure Managed Redis.
1. **Secrets retrieval:** Because it's an existing workload, only some components access Azure Key Vault to get runtime secrets. The other services receive those secrets from the Container Apps environment.
1. **Logs and metrics:** The environment and all container apps emit logs and metrics that Azure Monitor features and then collect and visualize.
1. **Container images:** Container images are pulled from the existing Azure Container Registry that was previously used for AKS and deployed into the Container Apps environment.

### Components

The workload uses the following Azure services in coordination with each other:

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that simplifies container orchestration and management. In this architecture, Container Apps serves as the primary hosting platform for all microservices.

  The following features replace many of the capabilities of the previous AKS architecture:

  - Built-in service discovery
  - Managed HTTP and HTTP/2 endpoints
  - Integrated load balancing
  - Logging and monitoring
  - Autoscaling based on HTTP traffic or events powered by Kubernetes-based Event Driven Autoscaling (KEDA)
  - Application upgrades and versioning

- [Container Registry](/azure/container-registry/container-registry-intro) is a managed registry service for storing and managing private container images. In this architecture, it's the source of all container images that are deployed to the Container Apps environment. The registry is the same one used in the AKS implementation.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database service.  In this architecture, the drone scheduler service uses Azure Cosmos DB as its data store.

- [Azure DocumentDB](/azure/documentdb/overview) is a fully managed MongoDB-compatible database service for building modern applications. In this architecture, the package service uses Azure DocumentDB as its data store.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a cloud messaging service that provides asynchronous communication capabilities and hybrid integration. In this architecture, it handles asynchronous messaging between the ingestion service and the task-based, workflow microservice. The rest of the services in the existing application are designed so other services can invoke them with HTTP requests.

- [Azure Managed Redis](/azure/redis/overview) is an in-memory caching service. In this architecture, it reduces latency and improves throughput for frequently accessed drone delivery data.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and accessing secrets such as API keys, passwords, and certificates. In this architecture, the drone scheduler and delivery services use user-assigned managed identities to authenticate with Key Vault and retrieve secrets needed for their runtime requirements.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a comprehensive monitoring solution that collects and analyzes telemetry data. In this architecture, it collects and stores metrics and logs from all application components through a Log Analytics workspace. You use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures.

  - [Application Insights](/azure/well-architected/service-guides/application-insights) is an application performance management service that provides extensible monitoring capabilities. In this architecture, each service is instrumented with the Application Insights SDK to monitor application performance.

### Alternatives

The [advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml) describes an alternative scenario of this example that uses Kubernetes.

## Scenario details

You can simplify deployment and management of microservice containers by using Container Apps, a serverless environment for hosting containerized applications.

Fabrikam, Inc., a fictional company, implements a drone delivery workload where users request a drone to pick up goods for delivery. When a customer schedules a pickup, a back-end system assigns a drone and notifies the user with an estimated pickup time.

The microservices application was deployed to an AKS cluster. But the Fabrikam team wasn't taking advantage of the advanced or platform-specific AKS features. They migrated the application to Container Apps, which enabled them to do the following actions:

- Employ minimal code changes when moving the application from AKS to Container Apps. The code changes were related to observability libraries that augmented logs and metrics with Kubernetes node information, which aren't relevant in the new environment.

- Deploy both infrastructure and the workload with Bicep templates: No Kubernetes YAML manifests were needed to deploy their application containers.
- Expose the application through managed ingress. Built-in support for external, HTTPS-based ingress to expose the ingestion service removed the need to configure their own ingress.
- Pull container images from Container Registry. Container Apps is compatible with any Linux base image stored in any available repository.
- Use the revision feature to support application life cycle needs. They could run multiple revisions of a particular container app and traffic-split across them for A/B testing or blue/green deployment scenarios.
- Use a managed identity to authenticate with Key Vault and Container Registry.

### Potential use cases

Deploy a brownfield microservice-based application into a platform as a service (PaaS) to simplify management and avoid the complexity of running a container orchestrator. The brownfield workload saved money by using this architecture over its Kubernetes deployment for the following reasons:

- The choice of workload profiles
- Less time spent on day-2 operational tasks for the operations team
- The ability to avoid over provisioning

> [!NOTE]
> Not all workloads yield such cost savings.

Consider other common uses of Container Apps:

- Run containerized workloads on a serverless, consumption-based platform.
- Autoscale applications based on HTTP or HTTPS traffic and event-driven triggers supported by KEDA.
- Minimize maintenance overhead for containerized applications.
- Deploy API endpoints.
- Host background processing applications.
- Handle event-driven processing.

## Optimizations

The goal of the workload team is to migrate the existing workload to Container Apps with minimal code changes. But you should make several optimizations to improve the architecture and workload implementation after migration.

### Improve secret management

The workload uses a hybrid approach to managing secrets. Managed identities apply only to services where switching to managed identities doesn't require code modifications. The drone scheduler and delivery services employ user-assigned managed identities with Key Vault to access stored secrets. The remaining services require code changes to adopt managed identities, so those services use secrets that the Container Apps environment provides.

A better approach is to update all code to support managed identities by using the app or job identity instead of environment-provided secrets. For more information about workload identities, see [Managed identities in Container Apps](/azure/container-apps/managed-identity).

### Avoid designs that require single revision mode

The workflow service container app runs in single revision mode. In single revision mode, the app has one revision backed by zero or more replicas. A replica is composed of the application container and any required sidecars. This example doesn't use sidecars, so each replica is a single container. The workflow service isn't designed for forward compatibility with message schemas. Two different versions of the service should never run concurrently.

If the Service Bus message schema must change, you must drain the bus before deploying the new workflow service version. A better approach is to update the service code for forward compatibility and use multi-revision mode to reduce downtime associated with draining queues.

### Consider job-based work

The workflow service is implemented as a long-running container app. But it can also run as a [job in Container Apps](/azure/container-apps/jobs). A *job* is a containerized application that starts on demand, runs to completion based on available work, then shuts down and frees resources. Jobs can be more economical than continuously running replicas. Migrating the service to run as a Container Apps job based on work available in the queue might be a practical option. It depends on typical queue volume and how finite, parallelizable, and resource optimized the workflow service is written. Experiment and verify to determine the best approach.

### Implement ingress control

The workload uses the built-in external ingress feature of Container Apps to expose the ingestion service. The ingress control approach doesn't provide the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in Azure DDoS Protection plans. You need to front all web-facing workloads with a WAF. To achieve this configuration in the Container Apps environment, you should disable the built-in public ingress and add [Application Gateway](/azure/container-apps/waf-app-gateway) or [Azure Front Door](/azure/container-apps/how-to-integrate-with-azure-front-door).

> [!NOTE]
> Gateways require meaningful health probes, which keep the ingress service alive and prevent it from scaling to zero.

### Modernize with Dapr

You can further modernize the workload by integrating with [Distributed Application Runtime (Dapr)](https://dapr.io/). It adds abstraction between workload code and state stores, messaging systems, and service discovery mechanisms. For more information, see [Deploy microservices with Container Apps and Dapr](./microservices-with-container-apps-dapr.yml). If your workload in Kubernetes already uses Dapr or common KEDA scalers, migrating to Container Apps is often straight forward and can retain that capability.

### Migrate to user authentication and authorization

The workload doesn't delegate authorization to a gateway. The ingestion service handles authorization of its clients. A better approach is to offload this responsibility to the [built-in authentication and authorization feature](/azure/container-apps/authentication), often referred to as *Easy Auth.* This change takes advantage of platform capabilities and reduces custom code in the ingestion microservice.

## Considerations

The following considerations implement the pillars of the Microsoft Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Container Apps helps you deploy, manage, maintain, and monitor the applications in the workload. You can improve reliability by following core recommendations. Some recommendations are implemented during migration from Kubernetes.

- Revisions help you deploy application updates with zero downtime. You can use revisions to manage the deployment of application updates and split traffic between the revisions to support blue/green deployments and A/B testing.

- With the Container Apps observability features, you have insight into components that run within the environment. Container Apps integrates with Application Insights and Log Analytics. You use this data to track operations and set alerts based on metrics and events as part of your observability system.

  Performance monitoring helps you evaluate the application under load. Metrics and logs provide data to recognize trends, investigate failures, and perform root-cause analysis.

- Use [health and readiness probes](/azure/container-apps/health-probes) to handle slow-starting containers and avoid sending traffic before they're ready. The Kubernetes implementation includes these endpoints. Continue to use them if they provide effective signals.

- When a service unexpectedly terminates, Container Apps automatically restarts it. Service discovery is enabled so that the workflow service can discover its downstream microservices. Use [resiliency policies](/azure/container-apps/service-discovery-resiliency) to handle timeouts and introduce circuit breaker logic without needing to further adjust the code.

- Enable autoscaling rules to meet demand as traffic and workloads increase.

- Use the dynamic load balancing and scaling features of Container Apps to improve availability. Over-provision your environment's subnet so that it always has enough [available IP addresses for future replicas or jobs](/azure/container-apps/custom-virtual-networks#subnet).

- Avoid storing state directly within the Container Apps environment, because all state is lost when the replica shuts down. Externalize state to a dedicated state store for each microservice. This architecture distributes state across three distinct stores: Azure Managed Redis, Azure Cosmos DB for NoSQL, and Azure DocumentDB.

- Deploy all resources, including Container Apps, by using a multi-zone topology. For more information, see [Availability zone support in Container Apps](/azure/reliability/reliability-azure-container-apps#availability-zone-support).

  Set the minimum replica count for nontransient applications to at least one replica for each availability zone. During typical operating conditions, replicas are reliably distributed and balanced across availability zones in the region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Secrets

- Your container app can store and retrieve sensitive values as secrets. After you define a secret for the container app, it's available for use by the application and any associated scale rules. If you're running in multi-revision mode, all revisions share the same secrets. Because secrets are considered application-scope changes, if you change the value of a secret, a new revision isn't created. But for any running revisions to load the new secret value, you need to restart them. In this scenario, application and environment variable values are used.

- Rewrite service code to use the app's own managed identity to authenticate to dependencies instead of preshared secrets. All dependencies have SDKs that support managed identity authentication.

- You can securely store sensitive values in environment variables at the application level. When environment variables change, the container app creates a new revision.

#### Network security

- To limit external access, only the ingestion service is configured for external ingress. The back-end services can be accessed only through the internal virtual network in the Container Apps environment and are configured as internal mode. Only expose services to the internet where required.

  Because this architecture uses the built-in external ingress feature, this solution doesn't provide the ability to completely position your ingress point behind a WAF or to include it in DDoS Protection plans. Front all web-facing workloads with a web application firewall. For more information about ingress improvements, see [Implement ingress control](#implement-ingress-control).

- When you create an environment, you can provide a custom virtual network. Otherwise, Microsoft automatically generates and manages a virtual network. You can't manipulate this Microsoft-managed virtual network, such as by adding network security groups (NSGs) or force tunneling traffic to an egress firewall. The example uses an automatically generated virtual network, but a custom virtual network improves security control. A custom network lets you apply [NSGs](/azure/container-apps/firewall-integration) and user-defined route (UDR)-based routing through Azure Firewall.

For more information about network topology options, including private endpoint support for ingress, see [Networking architecture in Container Apps](/azure/container-apps/networking).

#### Workload identities

- Container Apps supports Microsoft Entra managed identities that enable your app to authenticate itself to other resources protected by Microsoft Entra ID, such as Key Vault, without managing credentials in your container app. A container app can use system-assigned identities, user-assigned identities, or both. For services that don't support Microsoft Entra ID authentication, store secrets in Key Vault and use a managed identity to access the secrets.

- Use one dedicated, user-assigned managed identity for Container Registry access. Container Apps supports using a different managed identity for workload operation than for container registry access. This approach provides granular access control. If your workload has multiple Container Apps environments, don't share the identity across instances.

- Use system-assigned managed identities for workload identities to tie the identity life cycle to the workload component life cycle.

#### More security recommendations

- The Kubernetes implementation of this workload provides protection by using [Microsoft Defender for Containers capabilities](/azure/defender-for-cloud/defender-for-containers-introduction). In this architecture, Defender for Containers only [assesses vulnerability](/azure/defender-for-cloud/agentless-vulnerability-assessment-azure#how-vulnerability-assessment-for-images-and-containers-works) of the containers in your Container Registry. Defender for Containers doesn't provide runtime protection for Container Apps. Evaluate supplementing with non-Microsoft security solutions if runtime protection is a requirement.

- Don't run the workload in a shared Container Apps environment. Segment it from other workloads or components that don't need access to these microservices. Create separate Container Apps environments. Apps and jobs that run in a Container Apps environment can discover and reach any service that runs in the environment with internal ingress enabled.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Review an example price estimate for the workload. Use the [Azure pricing calculator](https://azure.com/e/4f044f65e46f40c7a9d7a4837a17e6d7). Configurations vary, so adjust it to match your scenario.

- In this scenario, Azure Cosmos DB, Azure Managed Redis, and Service Bus Premium are the main cost drivers.

- For containers that typically consume low CPU and memory amount, evaluate the consumption workload profile first. Estimate the cost of the consumption profile based on your usage to help gather baseline cost data and evaluate other profiles. For example, you can use a dedicated workload profile for components that have highly predictable and stable usage and can share dedicated nodes. For cost optimization, maintain a multiple of three nodes for each dedicated profile to ensure sufficient compute hosts and replica distribution across availability zones.

- Eliminate compute costs during periods of inactivity by ensuring components can scale to zero so you only pay when needed. This approach reduces expenses for apps that have variable or infrequent usage. Health checks typically prevent complete scale to zero. In the architecture, you can reimplement the workflow service as a job to take advantage of scale-to-zero during idle periods. This approach couples well with workloads that can use a [consumption plan](/azure/container-apps/plans#consumption).

- To avoid cross-region network charges, deploy all components, such as state stores and the container registry, in the same region.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use GitHub Actions or Azure Pipelines integration to set up automated continuous integration and continuous deployment (CI/CD) pipelines.

- Use multi-revision mode with traffic splitting to test changes to your workload code and scale rules.

- Integrate with Application Insights and Log Analytics to provide insight into your workload. Use the same Log Analytics workspace as the rest of your workload's components to keep all workload insights together.

- Use infrastructure as code (IaC), such as Bicep or Terraform, to manage all infrastructure deployments. Deployments include the Container Apps environment, container registry, and microservice state stores. Separate the microservice deployment pipelines from the infrastructure pipelines because they often don't share a similar life cycle. Your declarative pipeline for Azure infrastructure should deploy all resources except the container app resources.

- Use an imperative approach to creating, updating, and removing container apps from the environment. It's especially important if you're dynamically adjusting traffic-shifting logic between revisions. Use a [GitHub action](https://github.com/marketplace/actions/azure-container-apps-build-and-deploy) or [Azure Pipelines task](https://github.com/microsoft/azure-pipelines-tasks/tree/master/Tasks/AzureContainerAppsV1) in your deployment workflows. This imperative approach can be based on [YAML](/azure/container-apps/azure-resource-manager-api-spec?tabs=yaml#container-app-examples) app definitions. To minimize health check failures, always make sure your pipeline populates your container registry with the new container image before deploying the container app.

  An important change from the Kubernetes implementation is the shift from managing Kubernetes manifest files, such as defining `Deployment` Kubernetes objects. Kubernetes provides an atomic *succeeds together* or *fails together* approach to microservice deployment, through this manifest object. In Container Apps, each microservice is deployed independently. Your deployment pipelines become responsible for orchestrating any sequencing and rollback strategy necessary to have a safe deployment.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The workload is distributed among multiple microservice applications.

- Each microservice is independent and shares no state with other microservices, which enables independent scaling.

- Use Container Apps jobs for finite process runs to implement transient runtimes and reduce resource consumption for idle services. Evaluate the performance implications of spinning jobs up and down versus keeping components warm and ready.

- Autoscaling is enabled. Prefer event-based scaling over metric-based scaling where possible. For example, the workflow service, if designed to support it, could scale based on Service Bus queue depth. The default autoscaler is based on HTTP requests. During a replatforming, it's important to start with the same scaling approach, and then evaluate scaling optimizations later.

- Requests are dynamically load balanced to available replicas of a revision. 

- Metrics, including utilization of CPU, memory, bandwidth information, and storage, are available through Azure Monitor.

## Deploy this scenario

Follow the [steps in the README.md in the Container Apps example scenario repository](https://github.com/mspnp/container-apps-fabrikam-dronedelivery).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Contributors:

- [Julien Strebler](https://www.linkedin.com/in/julien-strebler-57647490/) | Cloud Solution Architect
- [Steve Caravajal](https://www.linkedin.com/in/stevecaravajal/) | Cloud Solution Architect
- [Simon Kurtz](https://www.linkedin.com/in/simonkurtz/) | Cloud Solution Architect

## Next steps

- [Container Apps documentation](/azure/container-apps/)

## Related resources

- [Microservices architecture style](/azure/architecture/guide/architecture-styles/microservices)
- [Design a microservices architecture](/azure/architecture/microservices/design/)
- [Build a CI/CD pipeline for AKS apps by using Azure Pipelines](/azure/architecture/guide/aks/aks-cicd-azure-pipelines)
- [Advanced AKS microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
