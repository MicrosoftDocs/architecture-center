This reference architecture provides guidance for designing a mission critical workload that has network controls in place to prevent any unauthorized public access between the internet and the workload.

 It builds on the [mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro), which is focused on maximizing reliability and operational effectiveness. This architecture adds features to secure ingress and egress paths using cloud-native capabilities. It's recommended that you become familiar with the baseline before proceeding with this article.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Reliability tier
<!--how does security impact the overall reliablity-->


> [!TIP]
> To define a realistic SLO, it's important to understand the SLA of all Azure components within the architecture. These individual numbers should be aggregated to determine a [composite SLA](/azure/architecture/framework/resiliency/business-metrics#composite-slas) which should align with workload targets.
>
> Refer to [Well-architected mission critical workloads: Design for business requirements](/azure/architecture/framework/mission-critical/mission-critical-design-methodology#1design-for-business-requirements).

## Key design strategies

The [design strategies for mission-critical baseline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#key-design-strategies) still apply in this use case. Here are some additional points:

- **Secure ingress**
Take PaaS services offline. Eliminate any connectivoty from resources used in the solution.
Taking components offline has a cost which is private endpoint. and subnet. However that is only from ingress perspective. What's coming to these services.

Ingress: In our global routing we have a bunhc of private endpojnts. In the stamp vnet, we need a subnet that has a PL service and ILB. 

- **Secure egress** 

    Egress traffic refers to traffic from a virtual network to entities outside that network. For example, Azure services used in the workload might need to access  endpoints for various management and control plane operations. That communication might be over the public internet. Lack of security controls on egress traffic might lead to data exfilteration attacks by malicious third-party services.

    Consider restricting outbound traffic to the internet using Azure Firewall and network security groups (NSGs) on the subnets.


- **Balance tradeoffs with security**

    There are significant trade-offs security features are added to the workload architecture. You might notice some impact on performance, operational agility, and even reliability. However, attack vectors, such as Denial-Of-Service (DDoS), data intrusion, and others, can target the system's overall reliability and eventually cause unavailability.

It's also important to note that there are often significant trade-offs associated with a hardened security posture, particularly with respect to performance, operational agility, and in some cases reliability. For example, the inclusion of inline Network Virtual Appliances (NVA) for Next-Generation Firewall (NGFW) capabilities, such as deep packet inspection, will introduce a significant performance penalty, additional operational complexity, and a reliability risk if scalability and recovery operations are not closely aligned with that of the application. It's therefore essential that additional security components and practices intended to mitigate key threat vectors are also designed to support the reliability target of an application, which will form a key aspect of the recommendations and considerations presented within this section.


  
- **Communication with the workload**

    > Refer to [Well-architected mission critical workloads](/azure/architecture/framework/mission-critical/).

![Mission critical online](./images/mission-critical-architecture-connected.svg)

The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources). 

## Global resources

The global resources are long living and share the lifetime of the system. They have the capability of being globally available within the context of a multi-region deployment model. 

**Azure Front Door** is used as the global load balancer for reliably routing traffic to the regional deployments with some level of guarantee based on the availability of backend services in a region. 

> Refer to [Well-architected mission critical workloads: Global traffic routing](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#global-traffic-routing).

**Azure Cosmos DB with SQL API** is used to store state related to the workload outside the compute cluster. The database account is replicated to each regional stamp and also has zonal redundancy enabled. 

> Refer to [Well-architected mission critical workloads: Globally distributed multi-write datastore](/azure/architecture/framework/mission-critical/mission-critical-data-platform#globally-distributed-multi-write-datastore).

**Azure Container Registry** is used to store all container images. It has geo-replication capabilities that allow the resources to function as a single registry, serving multiple regions with multi-master regional registries.

> Refer to [Well-architected mission critical workloads: Container registry](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#container-registry).

## Regional resources
The regional resources are provisioned as part of a _deployment stamp_ to a single Azure region. These resources share nothing with resources in another region. They can be independently removed or replicated to additional regions. They, however, share [global resources](#global-resources) between each other. 

**Static website in an Azure Storage Account** hosts a single page application (SPA) that send requests to backend services.

**Azure Virtual Networks** provide secure environments for running the workload. <!-- what are the subnets and what do they hold--> 

**Azure Kubernetes Service (AKS)** is the orchestrator for backend compute that runs an application and is stateless. The AKS cluster is deployed as a private cluster. So, the Kubernetes API server isn't exposed to the public internet, and traffic to the API server is limited to a private network. 

> Refer to [Well-architected mission critical workloads: Container Orchestration and Kubernetes](/azure/architecture/framework/mission-critical/mission-critical-application-platform#container-orchestration-and-kubernetes).

**Azure Firewall** is a network security service that protects all the Azure Virtual Network resources. The firewall allows only approved services and fully qualified domain names (FQDNs) as egress traffic.

**Azure Event Hubs** is used to optimize performance and maintain responsiveness during peak load, the design uses asynchronous messaging to handle intensive system flows. An additional Azure Storage account is provisioned for checkpointing. 

> Refer to [Well-architected mission critical workloads: Loosely coupled event-driven architecture](/azure/architecture/framework/mission-critical/mission-critical-application-design#loosely-coupled-event-driven-architecture).

**Azure Key Vault** stores secrets and configuration. There are common secrets such as connection strings to the global database but there is also information unique to a single stamp, such as the Event Hubs connection string. Also, independent resources avoid a single point of failure.

> Refer to [Well-architected mission critical workloads: Data integrity protection](/azure/architecture/framework/mission-critical/mission-critical-security#data-integrity-protection).

## Deployment pipeline

Build and release pipelines for a mission critical application must be fully automated. No action should be performed manually. This design demonstrates fully automated pipelines that deploy a validated stamp consistently every time. Another alternative approach is to only deploy rolling updates to an existing stamp.  

**GitHub** is used for source control, providing a highly available git-based platform for collaboration on application code and infrastructure code.

**Azure Pipelines** is chosen to automate pipelines are required for building, testing, and deploying a mission workload in preproduction _and_ production environments. 

> Refer to [Well-architected mission critical workloads: DevOps processes](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures#devops-processes).

**Self-hosted Azure DevOps build agent pools** are used to have more control over the builds and deployments. This level of autonomy is needed because the compute cluster is private. 

> [!NOTE] 
>  The use of self-hosted agents is demonstrated in the [Mission Critical - Connected](https://aka.ms/mission-critical-connected) reference implementation.

## Observability resources

Operational data from application and infrastructure must be available to allow for effective operations and maximize reliability. Monitoring data for global resources and regional resources should be stored independently. A single, centralized observability store isn't recommended to avoid a single point of failure.

- **Azure Log Analytics** is used as a unified sink to store logs and metrics for all application and infrastructure components. 
- **Azure Application Insights** is used as an Application Performance Management (APM) tool to collect all application monitoring data and store it directly within Log Analytics.

## Management resources

Because the compute cluster is private, additional resources are provisioned to gain secure access to cluster. 

**Azure Virtual Machine Scale Sets** for jump box instances to run tools against the cluster, such as kubectl.

**Azure Bastion** provides secure access to a jump box and removes the need for the jump boxes to have public IPs. Bastion host is in a dedicated subnet of the virtual network in the stamp. 

## Private compute
rk.

ACR Tasks



## Networking
<!--Coming soon-->
On the subnets that have Azure Container Registry agents, NSGs allow only necessary outbound traffic. For instance, traffic is allowed to Azure Key Vault, Azure Active Directory, Azure Monitor, and other services that the container registry needs to talk to.

The subnet with the jump box is intended for management operations. The NSG rule only allows SSH access from Azure Bastion in the hub, and limited outbound connections. Jump boxes do not have universal internet access, and are controlled at both the subnet NSG and Azure Firewall.
Ingress flow: 
Build agents need access to resources
No peering

Egress flow:
Two solutions:

- New snet called azure in all stamps. there's UDR on the subnet if there's coming from AKS or private endpoint. It will be go through Firewall. 
- Firewall rules can be very crisp and hyper local.

(most aligned version but very cost inffective. )

Option 2:

Keep vnet the same, 2 snets (priv end, k8)
regional vnets, has firewall. it's peered to the stamp v-net. 
(violates principles)
peering: when one vnet can talk to another vnet. free flowing. treat two as one. for MC perspective, peering can fail. It's weird to set up. Both sides resources need to be created. Deployment can be trickly. Not very intentional. You need non overlapping IP space. 

closer to the connected story.

## Private compute

<!--Coming soon-->

## Request and processor flows

This image shows the request and background processor flow of the reference implementation.

:::image type="content" source="./images/request-flow.png" alt-text="Diagram of the request flow." lightbox="./images/request-flow.png":::

The description of this flow is in the following sections.

### Website request flow

1. A request for the web user interface is sent to a global load balancer. For this reference architecture, the global load balancer is Azure Front Door.

2. The WAF Rules are evaluated. WAF rules positively affect the reliability of the system by protecting against a variety of attacks such as cross-site scripting (XSS) and SQL injection. Azure Front Door will return an error to the requester if a WAF rule is violated and processing stops. If there are no WAF rules violated, Azure Front Door continues processing.

3. Azure Front Door uses routing rules to determine which backend pool to forward a request to. [How requests are matched to a routing rule](/azure/frontdoor/front-door-route-matching). In this reference implementation, the routing rules allow Azure Front Door to route UI and frontend API requests to different backend resources. In this case, the pattern "/*" matches the UI routing rule. This rule routes the request to a backend pool that contains storage accounts with static websites that host the Single Page Application (SPA). Azure Front Door uses the Priority and Weight assigned to the backends in the pool to select the backend to route the request. [Traffic routing methods to origin](/azure/frontdoor/routing-methods). Azure Front Door uses health probes to ensure that requests aren't routed to backends that aren't healthy. The SPA is served from the selected storage account with static website.

    > [!NOTE]
    > The terms **backend pools** and **backends** in Azure Front Door Classic are called **origin groups** and **origins** in Azure Front Door Standard or Premium Tiers.  

4. The SPA makes an API call to the Azure Front Door frontend host. The pattern of the API request URL is "/api/*".

### Frontend API request flow

5. The WAF Rules are evaluated like in step 2.

6. Azure Front Door matches the request to the API routing rule by the "/api/*" pattern. The API routing rule routes the request to a backend pool that contains the public IP addresses for NGINX Ingress Controllers that know how to route requests to the correct service in Azure Kubernetes Service (AKS). Like before, Azure Front Door uses the Priority and Weight assigned to the backends to select the correct NGINX Ingress Controller backend.

7. For GET requests, the frontend API performs read operations on a database. For this reference implementation, the database is a global Azure Cosmos DB instance. Azure Cosmos DB has several features that makes it a good choice for a mission critical workload including the ability to easily configure multi-write regions, allowing for automatic failover for reads and writes to secondary regions. The API uses the client SDK configured with retry logic to communicate with Cosmos DB. The SDK determines the optimal order of available Cosmos DB regions to communicate with based on the ApplicationRegion parameter.

8. For POST or PUT requests, the Frontend API performs writes to a message broker. In the reference implementation, the message broker is Azure Event Hubs. You can choose Service Bus alternatively. A handler will later read messages from the message broker and perform any required writes to Cosmos DB. The API uses the client SDK to perform writes. The client can be configured for retries.

## Background processor flow

9. The background processors process messages from the message broker. The background processors use the client SDK to perform reads. The client can be configured for retries.

10. The background processors perform the appropriate write operations on the global Azure Cosmos DB instance. The background processors use the client SDK configured with retry to connect to Azure Cosmos DB. The client's preferred region list could be configured with multiple regions. In that case, if a write fails, the retry will be done on the next preferred region.

## Design areas

We suggest that you explore these design areas for recommendations and best practice guidance when defining your own mission critical architecture.

|Design area|Description|
|---|---|
|[Application design](/azure/architecture/framework/mission-critical/mission-critical-application-design)|Design patterns that allow for scaling, and error handling.|
|**[Application platform](mission-critical-app-platform.md)|Infrastructure choices and mitigations for potential failure cases.|
|[Data platform](/azure/architecture/framework/mission-critical/mission-critical-data-platform)|Choices in data store technologies, informed by evaluating required volume, velocity, variety, and veracity characteristics.|
|**[Networking and connectivity](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-networking)|Network considerations for routing incoming traffic to stamps.|
|[Health modeling](/azure/architecture/framework/mission-critical/mission-critical-health-modeling)|Observability considerations through customer impact analysis correlated monitoring to determine overall application health.|
|[Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing)|Strategies for CI/CD pipelines and automation considerations, with incorporated testing scenarios, such as synchronized load testing and failure injection (chaos) testing.|
|[Security](/azure/architecture/framework/mission-critical/mission-critical-security)|Mitigation of attack vectors through Microsoft Zero Trust model.|
|[Operational procedures](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures)|Processes related to deployment, key management, patching and updates.|

** Indicates design area considerations that are specific to this reference architecture.

## Related resources

For product documentation on the Azure services used in this architecture, see these articles. 
- [Azure Front Door](/azure/frontdoor/)
- [Azure Cosmos DB](/azure/cosmos-db/)
- [Azure Container Registry](/azure/container-registry/)
- [Azure Log Analytics](/azure/azure-monitor/)
- [Azure Key Vault](/azure/key-vault/)
- [Azure Service Bus](/azure/service-bus-messaging/)
- [Azure Kubernetes Service](/azure/aks/)
- [Azure Application Insights](/azure/azure-monitor/)
- [Azure Event Hubs](/azure/event-hubs/)
- [Azure Blob Storage](/azure/storage/blobs/)


## Deploy this architecture

Deploy the reference implementation to get a complete understanding of considered resources, including how they are operationalized in a mission-critical context. 

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)

## Next steps

If you want to extend this implementation with added security measures, refer to [Mission-Critical Connected](https://github.com/Azure/Mission-Critical-Connected). It contains a security-focused reference implementation and deployment guide intended to illustrate a solution-oriented approach for mission-critical application development on Azure.

