This reference architecture provides guidance for designing a mission critical workload on Azure. The architecture design focuses on maximum reliability and operational effectiveness. 

The architecture guidance references an [example implementation](https://github.com/Azure/Mission-Critical-Online) only for illustrative purposes. It shows a simplified architecture that is still reliable and can be considered as your first step toward production. The architecture provides a foundation for building a cloud-native application, where the workload is accessed over a public endpoint and doesn't require private network connectivity to other resources of an organization. The example workload contains a microservices application that can be accessed over a public endpoint. It's hosted in an Azure Kubernetes Service (AKS) cluster and uses other Azure-native platform capabilities.

> ![GitHub logo](../../../_images/github.svg) [Mission-Critical open source project](http://github.com/azure/mission-critical)

As the next step, refer to the [Mission-Critical Connected](https://github.com/Azure/Mission-Critical-Connected) reference implementation that extends the implementation with added security measures. This implementation isn't referenced in this architecture. For solution guidance, see [Reference Implementation - Solution Guide](https://github.com/Azure/Mission-Critical-Connected/blob/main/docs/reference-implementation/README.md).

## Reliability tier

Ultimately all design decisions depend on the business requirements and the Service Level Agreement (SLA) and Service Level Objective (SLO). Both are percentage figures represents the amount of time in a month when the application is available. This architecture targets availability of 99.95%, which corresponds to a permitted annual downtime of 52 minutes and 35 seconds. All design decisions are intended to reflect this target SLO.

> [!TIP]
> To define a realistic SLO, it's important to understand the SLA numbers of the individual Azure components. Combine those numbers and then, factor in deployment and application outages to define a composite SLO percentage.

> Refer to [Well-architected mission critical workloads: Design for business requirements](/azure/architecture/framework/mission-critical/mission-critical-design-methodology#1design-for-business-requirements).

## Key design strategies

Several factors can affect an application's reliability. The application's ability to recover from performance bottlenecks, regional availability, deployment efficacy, and security are common areas that should be analyzed holistically. This reference architecture focuses on these strategies.

- **Redundancy**: This strategy is applied in these levels:
    - Deploys to multiple regions in an active-active model. The application is distributed across two or more Azure regions that handle active user traffic. 
    - Utilizes Availability Zones (AZs) for all considered services to maximize availability within a single Azure region, distributing components across physically separate data centres inside a region.
    - Chooses resources that support global distribution.

- **Deployment stamp scale-units**: Regional stamps that can be deployed as a _scale unit_ where a logical set of resources can be independently deployed to keep up with the changes in demand. Each stamp also applies multiple nested scale units, such as the Frontend APIs and Background processors which can scale in and out independently.

    > Refer to [Well-architected mission critical workloads: Scale unit architecture](/azure/architecture/framework/mission-critical-application-design#scale-unit-architecture).

- **Containerized microservices**: The workload is composed of microservices that are containerized to consistently and reliably build application components, using container images as the primary model for application deployment packages. 

- **Event-driven asynchronous processing**: To achieve high responsiveness for intensive operations, this architecture uses a message broke to coordinate a business transaction between loosely coupled event-driven microservices.

- **Ephemeral compute**: Regional deployment stamps are ephemeral with a lifecycle tied to a single application release in order to remove patching and maintenance burdens as well as driving operational validity.

- **Zero downtime blue/green deployment pipelines**: Build and release pipelines must be consistent and transparent to end-users. The pipelines must be fully automated to deploy stamps as a single operational unit, using blue/green deployments with continuous validation applied.

- **Infrastructure as code (IaC)**: Uses Terraform to apply the principle of IaC, providing version control and a standardised operational approach for infrastructure components.

- **Environment consistency**: Consistency is applied across all considered environments, with the same deployment pipeline code used across production and pre-production environments. This eliminates risks associated with deployment and process variations across environments.

- **Continuous validation**: Automated testing as part of DevOps, including synchronized load and chaos testing, to fully validate the health of both the application code and underlying infrastructure.

- **Federated workspaces for observability data**: Monitoring data for global resources and regional resources are stored independently. A centralized observability store isn't recommended to avoid a single point of failure. Cross-workspace querying is used to achieve a unified data sink and single pane of glass for operations. 

- **Layered health model**: Constructs a layered representation of application health mapped to a traffic light model for contextualizing. Health scores are calculated for each individual component and then aggregated at a user flow level and combined with key non-functional requirements, such as performance, as coefficients to quantify application health.

## Architecture

![Mission critical online](./images/mission-critical-architecture-online.png)

The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources). 

### Global resources

The global resources are long living and share the lifetime of the system. They have the capability of being globally available within the context of a multi-region deployment model. 


#### Global load balancer

A global load balancer is critical to reliably route traffic to the regional deployments with some level of guarantee based on the availability of backend services in a region. Also, this component should have the capability of inspecting ingress traffic, for example through web application firewall. 

**Azure Front Door** is used as the global entry point for all incoming client HTTP(S) traffic, with **Web Application Firewall (WAF)** capabilities applied to secure Layer 7 ingress traffic. It uses TCP Anycast to optimize routing using the Microsoft backbone network and allows for transparent failover in the event of degraded regional health. Routing is dependant on custom health probes that check the composite heath of key regional resources. Azure Front Door also provides a built-in content delivery network (CDN) to cache static assets for the website component. 

Another option is Traffic Manager. It uses DNS to route traffic at Layer 4. However in this architecture, the capability to route HTTP(S) traffic is required.

> Refer to [Well-architected mission critical workloads: Global traffic routing](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#global-traffic-routing).


#### Database

All state related to the workload is stored in an external database, **Azure Cosmos DB with SQL API**. The SQL API was chosen because it has the feature set needed for performance and reliability tunning, both the client-side and server-side. It's highly recommended that the account has multi-master write enabled.

> [!NOTE]
> While a multi-region-write configuration represents the gold stadard for reliability, there is a significant tradeoff on cost.

The account is replicated to each regional stamp and also has zonal redundancy enabled. Also, autoscaling is enabled at the container-level so that containers automatically scale the provisioned throughput as needed.

> Refer to [Well-architected mission critical workloads: Globally distributed multi-write datastore](/azure/architecture/framework/mission-critical/mission-critical-data-platform#globally-distributed-multi-write-datastore).


#### Container registry

**Azure Container Registry** is used to store all container images. It has geo-replication capabilities that allow the resources to function as a single registry, serving multiple regions with multi-master regional registries.

As a security measure, only allow access to required entities and authenticate that access. For example, in the implementation, admin access is disabled. The compute cluster can pull images only with Azure Active Directory role assignments.  

> Refer to [Well-architected mission critical workloads: Container registry](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#container-registry).


### Regional resources
The regional resources are provisioned as part of a _deployment stamp_ to a single Azure region. These resources share nothing with resources in another region. They can be independently removed or replicated to additional regions. They, however share [global resources](#global-resources) between each other. 

In this architecture, a unified deployment pipeline deploys a stamp with these resources. 

![Regional resources](./images/mission-critical-stamp.png)

#### Frontend

This architecture uses a single page app (SPA) that send requests to backend services. An advantage is that the compute needed for the website experience is offloaded to the client instead of your servers managing site activity. If there's a transient error, SPA can reduce the impact by using service to buffer requests. This reduces a failure point on the backend servers. The SPA is hosted as a **static website in an Azure Storage Account**. 

Another choice is Azure Static Web Apps. As with any PaaS offering, there's reduced complexity but restrictions in flexibility. There are additional considerations, such as how the certificates are exposed, connectivity to global load balancer, and other factors.

Static content is typically cached in a store closer to the client, using a content delivery network (CDN), so that the data can be served quickly without reaching the backend servers. It's a cost-effective way to increase reliability and reduce network latency. In this architecture, **built-in CDN capabilities of Azure Front Door** are used to cache static website content at the Microsoft edge network.

#### Compute cluster

The backend compute runs an application composed of three microservices and is stateless. So, containerization is an appropriate strategy to host the application. **Azure Kubernetes Service (AKS)** was chosen because it meets most business requirements and Kubernetes is widely adopted across many industries. AKS supports advanced scalability and deployment topologies. The AKS Uptime SLA tier is highly recommended for hosting mission critical applications because it provides availability guarantees for the Kubernetes control plane. 

Azure offers other compute services such as Azure Functions, Azure App Services. However, those options are suitable for workloads where offloading compute management to Azure is preferred. 

> [!NOTE] 
>  Avoid storing state on the compute cluster, keeping in mind the ephemeral nature of the stamps. As much as possible, persist state in an external database to keep scaling and recovery operations lightweight. For example in AKS, pods change frequently. Attaching state to pods will add the burden of data consistency.

> Refer to [Well-architected mission critical workloads: Container Orchestration and Kubernetes](/azure/architecture/framework/mission-critical/mission-critical-application-platform#container-orchestration-and-kubernetes).

#### Regional message broker

A message broker brings high responsiveness even during peak load, the design uses asynchronous messaging for intensive system flows. As a request is quickly acknowledged back to the frontend APIs, the request is also queued in a message broker. The messages are consumed by a backend service that, for instance, handles write to a database. 

The entire stamp is stateless except for certain points, such as the message broker. Data is queued in the broker for a short period. The queue is drained after the message is processed and stored in a global database.

In this design, **Azure Event Hubs** is used because it guarantees at least once delivery. This means even if Event Hubs becomes unavailable, messages will be in the queue after the service is restored. However, it's the consumers responsibility to determine whether the message still needs processing. An additional Azure Storage account is provisioned for for checkpointing. 

    
For use cases that require additional message guarantees, Azure Service Bus is recommended. It allows for two phase commits with a client side cursor, and features such as a built-in dead letter queue and dedupe capabilities.

> Refer to [Well-architected mission critical workloads: Loosely coupled event-driven architecture](/azure/architecture/framework/mission-critical/mission-critical-application-design#loosely-coupled-event-driven-architecture).

#### Regional secret store

Each stamp has its own **Azure Key Vault** that stores secrets and configuration. There are common secrets such as connection strings to the global database but there's also information unique to a stamp, such as the Event Hubs connection string. Also, independent resources avoid a single point of failure.

> Refer to [Well-architected mission critical workloads: Data integrity protection](/azure/architecture/framework/mission-critical/mission-critical-security#data-integrity-protection).

### Deployment pipeline

Build and release pipelines for a mission critical application must be fully automated. No action should be done manually. This design demonstrates fully automated pipelines that deploy a clean stamp, every time. Another approach is to only deploy updates to an existing stamp. There might be added complexities that should be tested in a preproduction environment.  

#### Source code repository

**GitHub** is used for source control, providing a highly available git based platform for collaborating on application code and infrastructure code.

#### Continuous Integration/Continuous Delivery (CI/CD) pipelines

Automated pipelines are required for building, testing, and deploying a mission workload in preproduction _and_ production environments. **Azure Pipelines** is chosen given its rich tool set that can target Azure and other cloud platforms. 

Another choice is GitHub Actions as the CI pipeline. The added benefit is that source code and pipeline can be colocated. However, Azure Pipelines was chosen because of the richer CD capabilities. 

> Refer to [Well-architected mission critical workloads: DevOps processes](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures#devops-processes).

#### Build Agents

**Microsoft-hosted build agents** are used by this implementation to reduce complexity and management overhead. Self-hosted agents can be used for scenarios requiring a hardened security posture.  

### Observability resources

Operational data from application and infrastructure must be available to allow for effective operations and maximize reliability. This reference provides a baseline for achieving holistic observability of an application.

#### Unified data sink 

- **Azure Log Analytics** is used as a unified sink to store logs and metrics for all application and infrastructure components. 
- **Azure Application Insights** is used as an Application Performance Management (APM) to collect all application monitoring data and store it directly within Log Analytics.

![Monitoring resources](./images/mission-critical-monitoring-resources.svg)

Monitoring data for global resources and regional resources should be stored independently. A single, centralized observability store isn't recommended to avoid a single point of failure. Cross-workspace querying is used to still achieve a single pane of glass.

In this architecture, data from shared services such as, Azure Front Door, Cosmos DB, Container Registry are stored in dedicated instance of Log Analytics Workspace.

Similarly, monitoring resources per stamp must be independent. If you tear down a stamp, you still want to preserve observability. Each regional stamp has its own dedicated Application Insights and Log Analytics Workspace. The resources are provisioned per region but they outlive the stamps. 

#### Data archiving and analytics
Operational data that is not required for active operations is exported from Log Analytics to Azure Storage Accounts for both data retention purposes and to provide an anytical source for AIOps, which can be appied to optimise the application health model and operational procedures.

> Refer to [Well-architected mission critical workloads: Predictive action and AI operations](/azure/architecture/reference-architectures/containers/aks-mission-critical/azure/architecture/framework/mission-critical/mission-critical-health-modeling#predictive-action-and-ai-operations-aiops).

## Request and processor flows

This image shows the request and background processor flow of the reference implementation.

:::image type="content" source="./images/request-flow.png" alt-text="Diagram of the request flow." lightbox="./images/request-flow.png":::

The description of this flow is in the following sections.

### Website request flow

1. A request for the web user interface is sent to a global load balancer. For this reference architecture, the global load balancer is Azure Front Door. Front Door was chosen because of its rich feature set listed in the components section above.
2. The WAF Rules are evaluated. WAF rules positively affect the reliability of the system by protecting against a variety of attacks such as cross-site scripting (XSS) and SQL injection. Azure Front Door will return an error to the requester if a WAF rule is violated and processing stops. If there are no WAF rules violated, Azure Front Door continues processing.
3. Azure Front Door uses routing rules to determine which backend pool to forward a request to. [How requests are matched to a routing rule](/azure/frontdoor/front-door-route-matching). In this reference implementation, the routing rules allow Azure Front Door to route UI and frontend API requests to different backend resources. In this case, the pattern "/*" matches the UI routing rule. This rule routes the request to a backend pool that contains storage accounts with static websites that host the Single Page Application (SPA). Azure Front Door uses the Priority and Weight assigned to the backends in the pool to select the backend to route the request. [Traffic routing methods to origin](/azure/frontdoor/routing-methods). Azure Front Door uses health probes to ensure that requests aren't routed to backends that aren't healthy. The SPA is served from the selected storage account with static website.

> [!NOTE]
> The terms **backend pools** and **backends** in Azure Front Door Classic are called **origin groups** and **origins** in Azure Front Door Standard or Premium Tiers.  

4. The SPA Makes an API call to the Azure Front Door frontend host. The pattern of the API request URL is "/api/*".

### Frontend API request flow

5. The WAF Rules are evaluated like in step 2.
6. Azure Front Door matches the request to the API routing rule by the "/api/*" pattern. The API routing rule routes the request to a backend pool that contains the public IP addresses for NGINX Ingress Controllers that know how to route requests to the correct service in Azure Kubernetes Service (AKS). Like before, Azure Front Door uses the Priority and Weight assigned to the backends to select the correct NGINX Ingress Controller backend.
7. For GET requests, the frontend API performs read operations on a database. For this reference implementation, the database is a global Azure Cosmos DB instance. Azure Cosmos DB has several features that makes it a good choice for a mission critical workload including the ability to easily configure multi-write regions, allowing for automatic failover for reads and writes to secondary regions. The API uses the client SDK configured with retry logic to communicate with Cosmos DB. The SDK determines the optimal order of available Cosmos DB regions to communicate with based on the ApplicationRegion parameter.
8. For POST or PUT requests, the Frontend API performs writes to a message broker. For this reference architecture, the message broker is Microsoft Azure Service Bus. Service Bus is a good choice for mission critical workloads where every message must be processed because of features like ensuring every message is processed at least once and dead lettering. A handler will later read messages from Service Bus and perform any required writes to Cosmos DB. The API uses the client SDK to perform writes. The client can be configured for retries.

## Background processor flow

9. The background processors subscribe to a topic in Service Bus and receives messages to process. The background processors use the client SDK to perform reads. The client can be configured for retries.
10. The background processors perform the appropriate write operations on the global Azure Cosmos DB instance. The background processors use the client SDK configured with retry to connect to Azure Cosmos DB. The client's preferred region list could be configured with multiple regions. In that case, if a write fails, the retry will be done on the next preferred region.

## Design areas

We suggest that you explore these areas for recommendations on design choices for the architecture components.

|Design area|Description|
|---|---|
|[Application design](/azure/architecture/framework/mission-critical/mission-critical-application-design)|Design patterns that allow for scaling, and error handling.|
|[Application platform](/azure/architecture/framework/mission-critical/mission-critical-application-platform)|Infrastructure choices and mitigations for potential failure cases.|
|[Data platform](/azure/architecture/framework/mission-critical/mission-critical-data-platform)|Choices in data store technologies, informed by evaluating required volume, velocity, variety, and veracity characteristics.|
|[Networking and connectivity](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity)|Network considerations for routing incoming traffic to stamps.|
|[Health modeling](/azure/architecture/framework/mission-critical/mission-critical-health-modeling)|Observability considerations through customer impact analysis correlated monitoring to determine overall application health.|
|[Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing)|Strategies for CI/CD pipelines and automation considerations, with incorporated testing scenarios, such as synchronized load testing and failure injection (chaos) testing.|
|[Security](/azure/architecture/framework/mission-critical/mission-critical-security)|Mitigation of attack vectors through Microsoft Zero Trust model.|
|[Operational procedures](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures)|Processes related to deployment, key management, patching and updates.|

## Related resources

For product documentation on the Azure services used in this architecture, see these articles. 
- [Azure Front Door](/azure/frontdoor/)
- [Azure Cosmos DB](/azure/cosmos-db/)
- [Azure Container Registry](/azure/container-registry/)
- [Azure Log Analytics](/azure/azure-monitor/)
- [Azure Key Vault](/azure/key-vault/)
- [Azure Kubernetes Service](/azure/aks/)
- [Azure Application Insights](/azure/azure-monitor/)
- [Azure Event Hubs](/azure/event-hubs/)
- [Azure Blob Storage](/azure/storage/blobs/)


## Deploy this architecture

Deploy the reference implementation to get a full understanding of reources and their configuration. 

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)
