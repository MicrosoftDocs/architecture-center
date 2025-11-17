This scenario shows an existing workload originally designed for Kubernetes that's replatformed to run in Azure Container Apps. Container Apps is well suited for brownfield workloads where teams want to simplify infrastructure and container orchestration.

The example workload is a containerized microservices application. It reuses the same workload defined in [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml). The architecture rehosts it in Container Apps as its application platform.

> [!IMPORTANT]
> This architecture focuses on minimizing application code changes and approaching the transition from AKS to Container Apps as a platform migration. The goal is a like-for-like implementation, deferring code or infrastructure optimizations that might put the migration at risk.
>
> For a greenfield workload, see [Deploy Microservices with Container Apps and Dapr](./microservices-with-container-apps-dapr.yml).

> [!TIP]
> ![GitHub logo](../../_images/github.png) An [example implementation](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) backs the architecture and illustrates some of the design choices described in this article.

## Architecture

:::image type="complex" border="false" source="./media/microservices-with-container-apps-runtime-diagram.png" alt-text="Diagram that shows the runtime architecture for the solution." lightbox="./media/microservices-with-container-apps-runtime-diagram.png":::
   The diagram shows an Container Apps environment as a large rectangle containing five container apps. An HTTP traffic source arrow points into the Ingestion service. An upward arrow from Ingestion goes to Azure Service Bus. A downward arrow goes from Service Bus and returns to the Workflow service. From Workflow, three black connectors descend and bend toward each lower service: the Package, the Drone Scheduler, and the Delivery services. Each lower service has a vertical arrow to its own external state store: Package service goes to Azure Cosmos DB for MongoDB API. Drone Scheduler service goes to Cosmos DB. Delivery service goes to Azure Managed Redis. Two arrows exit the middle of the environment: the upper arrow goes to Azure Application Insights. The lower arrow goes to Azure Log Analytics workspace. Under the workspace is Azure Key Vault and below that Azure Container Registry, shown without connecting arrows.
:::image-end:::

The following diagram illustrates the runtime architecture for the solution.

*Download a [Visio file](https://arch-center.azureedge.net/microservices-with-container-apps.vsdx) of this architecture.*

The services sharing the same environment benefit from:

- An internal ingress and service discovery
- A single Log Analytics workspace for runtime logging
- A secure management method for secrets and certificates

### Dataflow

1. **Ingestion service:** Receives client requests, buffers them, then publishes them to Azure Service Bus. It's the only ingress point into the workload.
1. **Workflow service:** Consumes messages from Service Bus and dispatches them to underlying microservices.
1. **Package service:** Manages packages. The service maintains its own state in Azure Cosmos DB.
1. **Drone scheduler service:** Schedules drones and monitors drones in flight. The service maintains its own state in Cosmos DB.
1. **Delivery service:** Manages scheduled or in-transit deliveries. The service maintains its own state in Azure Managed Redis.
1. Because it's an existing workload, only some components access Azure Key Vault to get runtime secrets. The other services receive those secrets from the Container Apps environment.
1. The environment and all container apps emit logs and metrics that Azure Monitor features and then collects and visualizes.
1. Container images are pulled from the existing Azure Container Registry that was previously used for AKS and deployed into the Container Apps environment.

### Components

The workload uses a set of Azure services in concert with one another.

- **[Container Apps](/azure/well-architected/service-guides/azure-container-apps)** is an Azure serverless container platform that simplifies container orchestration and management. In this architecture, Container Apps serves as the primary hosting platform for all microservices.

  The following features replace many of the capabilities of the previous AKS architecture:

  - Built-in service discovery
  - Managed HTTP and HTTP/2 endpoints
  - Integrated load balancing
  - Logging and monitoring
  - Autoscaling based on HTTP traffic or events powered by Kubernetes-based Event Driven Autoscaling (KEDA)
  - Application upgrades and versioning

- **[Container Registry](/azure/container-registry/container-registry-intro)** is an Azure managed registry service for storing and managing private container images. In this architecture, it's the source of all container images that are deployed to the Container Apps environment. The registry is the same one used in the AKS implementation.

- **[Cosmos DB](/azure/well-architected/service-guides/cosmos-db)** is an Azure globally distributed, multiple-model database service. It stores data by using the open-source [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb-introduction) API. Microservices should write their state to dedicated external data stores. In this architecture, Cosmos DB serves as the primary NoSQL database with open-source APIs for MongoDB and SQL where the microservices write their state and application data.

- **[Service Bus](/azure/well-architected/service-guides/service-bus/reliability)** is an Azure cloud messaging service that provides asynchronous communication capabilities and hybrid integration. In this architecture, it handles asynchronous messaging between the ingestion service and the task-based, workflow microservice. The rest of the services in the existing application are designed so you can invoke them with HTTP requests.

- **[Managed Redis](/azure/redis/overview)** is an Azure in-memory caching service. In this architecture, it reduces latency and improves throughput for frequently accessed drone delivery data.

- **[Key Vault](/azure/key-vault/general/overview)** is an Azure cloud service for securely storing and accessing secrets such as API keys, passwords, and certificates. In this architecture, the drone scheduler and delivery services use user-assigned managed identities to authenticate with Key Vault and retrieve secrets needed for their runtime requirements.

- **[Monitor](/azure/azure-monitor)** is an Azure comprehensive monitoring solution that collects and analyzes telemetry data. In this architecture, it collects and stores metrics and logs from all application components through a Log Analytics workspace. You use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures.

  **[Azure Application Insights](/azure/well-architected/service-guides/application-insights)** is an application performance management service that provides extensible monitoring capabilities. In this architecture, each service is instrumented with the Application Insights SDK to monitor application performance.

### Alternatives

An alternative scenario of this example that uses Kubernetes is described in [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml).

## Scenario details

You can simplify deployment and management of microservice containers by using Container Apps, a serverless environment for hosting containerized applications.

Fabrikam, Inc., a fictional company, implements a drone delivery workload where users request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated pickup time.

The microservices application was deployed to an AKS cluster. But the Fabrikam team wasn't taking advantage of the advanced or platform-specific AKS features. They migrated the application to Container Apps. When the team ported their solution to Container Apps, they could take the following actions.

- Employ minimal code changes when moving the application from AKS to Container Apps. The code changes were related to observability libraries that augmented logs and metrics with Kubernetes node information, which aren't relevant in the new environment.
- Deploy both infrastructure and the workload with Bicep templates: No Kubernetes YAML manifests were needed to deploy their application containers.
- Expose the application through managed ingress: Built-in support for external, HTTPS-based ingress to expose the Ingestion Service removed the need for configuring their own ingress.
- Pull container images from Container Registry (ARC). Container Apps is compatible with any Linux base image stored in any accessible repository.
- Use the revision feature to support application lifecycle needs. They could run multiple revisions of a particular container app and traffic-split across them for A/B testing or Blue/Green deployment scenarios.
- Use a managed identity to authenticate with Key Vault and Container Registry.

### Potential use cases

Deploy a brownfield microservice-based application into a platform as a service (PaaS) to simplify management and avoid the complexity of running a container orchestrator. The brownfield workload also experienced cost savings by using this architecture over its Kubernetes deployment due to:

- The choice of workload profiles.
- The amount of saved time that the operations team spent on day-2 operational tasks.
- The ability to avoid over provisioning.

> [!NOTE]
> Not all workloads yeild such cost savings.

Other common uses of Container Apps include:

- Run containerized workloads on a serverless, consumption-based platform
- Autoscale applications based on HTTP/HTTPS traffic and event-driven triggers supported by KEDA
- Minimize maintenance overhead for containerized applications
- Deploy API endpoints
- Host background processing applications
- Handle event-driven processing

## Optimizations

The goal of the workload team is to migrate the existing workload to Container Apps with minimal code changes. But there are several optimizations to make that improve the architecture and workload implementation after migration.

### Improve secret management

The workload uses a hybrid approach to managing secrets. Managed identities are used in the services where the change required no code modifications. The Drone Scheduler and Delivery services employ user-assigned managed identities with Key Vault to access stored secrets. The remaining services require code changes to adopt managed identities, so those services use secrets provided by the Container Apps environment.

A better approach is to update all code to support managed identities, by using the app or job identity instead of environment-provided secrets. For more information about workload identities, see [Managed identities in Container Apps](/azure/container-apps/managed-identity).

### Avoid designs that require single revision mode

The workflow service container app runs in single revision mode. In single revision mode, the app has one revision backed by zero or more replicas. A replica is composed of the application container and any required sidecars. This example doesn't use sidecars, so each replica is a single container. The workflow service wasn't designed for forward compatibility with message schemas. It's important to ensure that two different versions of the service don't run concurrently.

If the Service Bus message schema must change, you must drain the bus before deploying the new workflow service version. A better approach is to update the service code for forward compatibility and use multi-revision mode to reduce downtime associated with draining queues.

### Consider job-based work

The workflow service is implemented as a long-running container app. But it can also run as a [job in Container Apps](/azure/container-apps/jobs). A job is a containerized application that spins up on demand, runs to completion based on work to be done, then shuts down and frees resources. Jobs can be more economical than continuously running replicas. So, migrating the service to run as an Container Apps job, based on work available in the queue, might be a reasonable approach to explore. It depends on typical queue volume and how finite, parallelizable, and resource optimized the workflow service is written. Experiment and verify to determine the best approach.

### Implement ingress control

The workload uses the built-in external ingress feature of Container Apps to expose the Ingestion service. The ingress control approach doesn't offer the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in DDoS Protection plans. You need to front all web-facing workloads with a web application firewall. To achieve it with the Container Apps environment, you should disable the built-in public ingress and add [Application Gateway](/azure/container-apps/waf-app-gateway) or [Azure Front Door](/azure/container-apps/how-to-integrate-with-azure-front-door).

> [!NOTE]
> Gateways require meaningful health probes, which means the ingress service is effectively kept alive, preventing the ability to dynamically scale to zero.

### Modernize with Dapr

You can further modernize the workload by integrating with [Distributed Application Runtime (Dapr)](https://dapr.io/). It adds abstraction between workload code and state stores, messaging systems, and service discovery mechanisms. For more information, see [Deploy Microservices with Container Apps and Dapr](./microservices-with-container-apps-dapr.yml). If your workload in Kubernetes already used Dapr or common KEDA scalers, migrating to Container Apps is often straight forward and can retain that capability.

### Migrate to user authentication and authorization

The workload doesn't delegate authorization to a gateway. The ingestion service handles authorization of its clients. A better approach is to offload this responsibility to the [built-in authentication and authorization feature](/azure/container-apps/authentication), often referred to as "Easy Auth." This change takes advantage of platform capabilities and reduces custom code in the ingestion microservice.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Container Apps helps you deploy, manage, maintain, and monitor the applications in the workload. You can improve reliability by following core recommendations. Some are implemented during migration from Kubernetes.

- Revisions help you deploy application updates with zero downtime. You can use revisions to manage the deployment of application updates and split traffic between the revisions to support blue/green deployments and A/B testing.

- With the Container Apps observability features, you have insight into components running within the environment. Container Apps integrates with Application Insights and Log Analytics. You use this data to track operations and set alerts based on metrics and events as part of your observability system.

  Performance monitoring helps you evaluate the application under load. Metrics and logs provide data to recognize trends, investigate failures, and perform root-cause analysis.

- Use [health and readiness probes](/azure/container-apps/health-probes) to handle slow-starting containers and avoid sending traffic before they're ready. The Kubernetes implementation already had these endpoints. Continue to use them if they're effective signals.

- When a service unexpectedly terminates, Container Apps automatically restarts it. Service discovery is enabled so that the workflow service can discover its downstream microservices. Use [resiliency policies](/azure/container-apps/service-discovery-resiliency) to handle timeouts and introduce circuit breaker logic without needing to further adjust the code.

- Enable autoscaling rules to meet demand as traffic and workloads increase.

- Use the dynamic load balancing and scaling features of Container Apps to improve availability. Overprovision your environment's subnet so that it never falls short of [available IPs for future replicas or jobs](/azure/container-apps/custom-virtual-networks?tabs=workload-profiles-env#subnet).

- Avoid storing state directly within the Container Apps environment, because all state is lost when the replica shuts down. Externalize state to a dedicated state store per microservice. In this architecture, state is distributed across three distinct stores: Managed Redis, Azure Cosmos DB for NoSQL, and Cosmos DB for MongoDB.

- Deploy all resources, including Container Apps, by using a multi-zone topology. For more information on availability zone support, see [Availability zone support in Container Apps](/azure/reliability/reliability-azure-container-apps#availability-zone-support).

  Set the minimum replica count for nontransient applications to at least one replica per availability zone. During typical operating conditions, replicas are reliably distributed and balanced across availability zones in the region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Secrets

- Your container app can store and retrieve sensitive values as secrets. After you define a secret for the container app, it's available for use by the application and any associated scale rules. If you're running in multi-revision mode, all revisions share the same secrets. Because secrets are considered application-scope changes, if you change the value of a secret, a new revision isn't created. But for any running revisions to load the new secret value, you need to restart them. In this scenario, application and environment variable values are used.

- Rewrite service code to use the app's own managed identity to authenticate to dependencies instead of preshared secrets. All dependencies have SDKs that support managed identity authentication.

- Environment variables: you can securely store sensitive values at the application level. When environment variables change, the container app spawns a new revision.

#### Network security

- **Ingress:** To limit external access, only the Ingestion service is configured for external ingress. The backend services are accessible only through the internal virtual network in the Container Apps environment and are configured as internal mode. Only expose services to the Internet where required. Because this architecture uses the built-in external ingress feature, this solution doesn't offer the ability to completely position your ingress point behind a web application firewall (WAF) or to include it in DDoS Protection plans. Front all web-facing workloads with a web application firewall. For more information on ingress improvements, see [Implement ingress control](#implement-ingress-control) in the Optimizations section.

- **Virtual network:** When you create an environment, you can provide a custom virtual network. Otherwise, Microsoft automatically generates and manages a virtual network. You can't manipulate this Microsoft-managed virtual network, such as by adding network security groups (NSGs) or force tunneling traffic to an egress firewall. The example uses an automatically generated virtual network, which should be improved by using a custom virtual network. It gives you more security control such as [Network Security Groups](/azure/container-apps/firewall-integration) and UDR-based routing through Azure Firewall.

For more information on network topology options, including private endpoint support for ingress, see [Networking architecture in Container Apps](/azure/container-apps/networking).

#### Workload identities

- Container Apps supports Microsoft Entra managed identities that enable your app to authenticate itself to other resources protected by Microsoft Entra ID, such as Key Vault, without managing credentials in your container app. A container app can use system-assigned, user-assigned, or both types of managed identities. For services that don't support AD authentication, store secrets in Key Vault and use a managed identity to access the secrets.

- Use one, dedicated, user-assigned, managed identity for Container Registry access. Container Apps supports the use of a different managed identity for workload operation than container registry access. This approach provides granular access control. If your workload has multiple Azure Container App environments, don't share the identity across instances.

- Use system-assigned managed identities for workload identities, to tie the identity lifecycle to the workload component lifecycle.

#### More security recommendations

- This same workload was previously protected with the Kubernetes capabilities found in [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction). Defender for Containers in the architecture is limited to only performing [vulnerability assessments](/azure/defender-for-cloud/agentless-vulnerability-assessment-azure#how-vulnerability-assessment-for-images-and-containers-works) of the containers in your Container Registry. Defender for Containers doesn't provide runtime protection for Container Apps. Evaluate supplementing with non-Microsoft security solutions if runtime protection is a requirement.

- Don't run the workload in a shared Container Apps environment. Segment it from other workloads or components that don't need access to these microservices. Create separate Container Apps environments. Apps and jobs running in an Container Apps Environment can discover and reach any service running in the environment with internal ingress enabled.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Review an example price estimate for the workload. Use the [Azure pricing calculator](https://azure.com/e/4f044f65e46f40c7a9d7a4837a17e6d7). Configurations vary, so adjust it to match your scenario.

- In this scenario, Cosmos DB, Managed Redis, and Service Bus (Premium) are the main cost drivers.

- For containers that typically consume low CPU and memory amount, evaluate the consumption workload profile first. Estimate cost of the consumption profile based on your usage to help gather a baseline cost data so you can also evaluate other profiles. For example, you could use a dedicated workload profile for components with highly predictable and stable usage that can share dedicated nodes. For cost optimization, maintain a multiple of three nodes per dedicated profile to ensure sufficient compute hosts and replica distribution across availability zones.

- Eliminate compute costs during periods of inactivity by ensuring components can scale to zero so you only pay when needed. It reduces expenses for apps with variable or infrequent usage. Health checks typically prevent complete scale to zero. In the architecture, the workflow service could be reimplemented as a job to take advantage of scale-to-zero during idle periods. It couples well with workloads that can use a [consumption plan](/azure/container-apps/plans#consumption).

- To avoid cross-region network charges, deploy all components, such as state stores and the container registry, in the same region.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use GitHub Actions or Azure Pipelines integration for setting up automated CI/CD deployments.

- Use multi-revision mode with traffic splitting for testing changes to your workload code and scale rules.

- Integrate with Application Insights and Log Analytics to provide insight into your workload. Use the same Log Analytics workspace as the rest of your workload's components to keep all workload insights together.

- Use infrastructure-as-code, such as Bicep or Terraform to manage all infrastructure deployments. Deployments include the Container Apps environment, container registry, and microservice state stores. Separate the microservice deployment pipelines from the infrastructure pipelines as they often don't share a similar lifecycle. It means your declarative pipeline for Azure infrastructure should deploy all but the container app resources.

- Use an imperative approach to creating, updating, and removing container apps from the environment. It's especially important if you're dynamically adjusting traffic-shifting logic between revisions. Use a [GitHub action](https://github.com/marketplace/actions/azure-container-apps-build-and-deploy) or [Pipelines task](https://github.com/microsoft/azure-pipelines-tasks/tree/master/Tasks/AzureContainerAppsV1) in your deployment workflows. This imperative approach can be based on [yaml](/azure/container-apps/azure-resource-manager-api-spec?tabs=yaml#container-app-examples) app definitions. To minimize health check failures, always make sure your pipeline populates your container registry with the new container image before deploying the container app.

  An important change from the Kubernetes implementation is the shift from managing Kubernetes manifest files, such as defining `Deployment` Kubernetes objects. Kubernetes provides an atomic *succeeds together* or *fails together* approach to microservice deployment, through this manifest object. In Container Apps, each microservice is deployed independently. Your deployment pipelines become responsible for orchestrating any sequencing and rollback strategy necessary to have a safe deployment.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance considerations in this solution:

- The workload is distributed among multiple microservice applications.

- Each microservice is independent and shares no state with other microservices, allowing independent scaling.

- Use Container Apps jobs for finite process execution to implement transient runtimes and reduce resource consumption for idle services. Evaluate the performance impact of spinning jobs up and down versus keeping components warm and ready.

- Autoscaling is enabled. Prefer event-based scaling over metric-based scaling where possible. For example, the workflow service, if designed to support it, could scale based on Service Bus queue depth. The default autoscaler is based on HTTP requests. During a replatforming, it's important to start with the same scaling approach, and then evaluate scaling optimizations later.

- Requests are dynamically load balanced to available replicas of a revision. 

- Metrics, including CPU and memory utilization, bandwidth information and storage utilization, are available through Azure Monitor.

## Deploy this scenario

Follow the steps in the README.md in the [Container Apps example scenario](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) repository.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Catherine Bundy](https://www.linkedin.com/in/catherine-bundy/) | Technical Writer

Other contributors:

- [Julien Strebler](https://www.linkedin.com/in/julien-strebler-57647490/) | Cloud Solution Architect
- [Steve Caravajal](https://www.linkedin.com/in/stevecaravajal/) | Cloud Solution Architect
- [Simon Kurtz](https://www.linkedin.com/in/simonkurtz/) | Cloud Solution Architect

## Next steps

- [Container Apps documentation](/azure/container-apps/)

## Related resources

- [Microservices architecture style](/azure/architecture/guide/architecture-styles/microservices)
- [Design a microservices architecture](/azure/architecture/microservices/design/)
- [CI/CD for AKS apps with Pipelines](/azure/architecture/guide/aks/aks-cicd-azure-pipelines)
- [Advanced AKS microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
