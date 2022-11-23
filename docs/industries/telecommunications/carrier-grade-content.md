This architecture provides guidance for designing a carrier-grade solution for a telecommunication use case. The design choices focus on high reliability by minimizing points of failure and ultimately the overall downtime using native Azure capabilities. 

> [!TIP] 
> This architecture is based on the design principles of a carrier-grade workload. We highly recommend that you read [Well-Architected](/azure/architecture/framework/carrier-grade/carrier-grade-get-started) documentation to undersand the design choices made in this architecture. 

## Use case

This reference architecture is for a voicemail solution. It offers common functionalities such as, play greeting and record voicemail, retrieve voicemail through phone or app, configure features, and much more.  

Multiple clients can connect to the workload using various protocols. They can be HTTP or other protocols, such as Session Initiation Protocol (SIP). A connection will lead to persisted state, which can be client configuration, messages, and related metadata. 

## Workload requirements
- The workload is expected to have a Service Level Object target of 99.999%, which equates to outage duration of less than 5 minutes per year.
- Application requests for all the supported protocols must be load-balanced across all the active service instances (SIs).
- Replication of write operations on subscriber data must be instantaneous across regions. Any service instance reading data always gets served the latest and most up to date version of the subscriber data.
- If a failure occurs in the middle of an active subscriber voice mail session, the caller will need to reconnect. The application isn't required to maintain active session state for in-flight messages.

## Key design strategies

- **Active-active muti-region deployment**. Deploy 12 application instances across four regions to minimize regional outage as a single point of failure. In active-active model, there's no failover also making  request processing fast and reliable.
- **Replicated storage**. Keep the application itself is stateless. Data is persisted either regionally or globally and redundancy is built by replicating across regions. 
- **Eventual data consistency enforced by Consistency, Availability, and Partition tolerance (CAP)**. Implement application logic that uses conflict-free replicated data types (CRDTs) to handle eventual inconsistency.
- **Avoid correlated failure modes**. Take independent elements and [combine them to reach a higher reliability target](/azure/architecture/framework/carrier-grade/carrier-grade-design-area-fault-tolerance#high-availability-through-combination). 
**Shared fate within each stamp**. Aggregate all the components of service instance in a stamp. This removes the overhead of handling partial failures. If an instance is down, a new stamp replaces the unhealthy instance.

## Architecture

![Diagram showing the physical architecture of a carrier-grade solution](./images/carrier-grade-architecture.png)

The workload is hosted in Azure infrastructure and several Azure services participate in processing requests and the operations. The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources).


### Global resources

These resources provide functionality that's shared by resources deployed in regions. For instance, the global load balancer that distributes traffic to multiple regions. Foundational services that other services depend on, such as the identity platform and DNS. Global resources also include services that maintain functional consistency across regions, such as shared state stores and databases. 

**Azure Traffic Manager**

The global load balancer that uses DNS-based routing to send traffic to the application SI that has public endpoints. Health endpoint monitoring is enabled to make sure that traffic is sent to healthy backend instances. 

**Azure Cosmos DB**

Stores application payload metadata and end-user provisioning data. Also used by dependent services listed above. Multi-master write is enabled so that data is replicated to each region, instantaneously. Also, zone redundancy is enabled through availability zone redundancy support (AZRS). 

**Gateway component** 

A custom solution component that that exists outside of the cloud. The gateway serves as the single endpoint for clients using protocols different than Http. It monitors the health of the backend endpoints and routes traffic to the healthy instances. 

> [!IMPORTANT] 
> Global routing is handled through DNS. If any global service or a foundational service, such as DNS, identity platform isn't available, the entire system will be impacted. 

### Regional resources

This set of services that are deployed each region and their lifetime is tied to the region.  

**Management service**

Is a custom service that delivers the management, deployment, and monitoring aspects for the application. More than one management service instance can service a single application instance in any region.

**Azure Container Registry**

Stores all Open Container Initiative (OCI) artifacts. Zone redundancy is enabled. 

**Azure Key Vault**

Stores global secrets such as connection strings to the global database and regional secrets.

**Azure Monitor**
Logs and metrics emitted by the workload that Azure resources are collected and stored in Azure Monitor Logs and Log Analytics Workspace. 

**Virtual machine scale set**

Run as jump box instances to run tools against the cluster, such as kubectl.

**Azure Blob Storage**

Premium SKU is used for large payload data, long-term metrics data, virtual machine images, application core dumps and diagnostics packages. Storage is configured for  zone-redundant storage (ZRS), object replication (OR) between regions, and application-level handling. 

**Azure Functions**

Triggers special functionality of the workload, such as  delivery of messages at the indicated time and delayed notifications.

**Azure Queue Storage**

All regional resources are stateless except for Queue Storage that stores messages temporarily as mitigation of write failures.

> [!IMPORTANT] 
> Regional resources are independent in that unavailability of a resource in one region shouldn't impact resources in another region. There might be simultaneous outages in multiple regions but the impact must be restricted to the individual region. The resources can be further categorized by their functional requirement. Azure Blob Storage, Functions, Queue Storage participate in processing a request. Other components, Key Vault, Monitor, and Container Registry are provisioned for management operations.

### Regional stamp resources

Within each region, a set of resources are deployed as part of a deployment stamp to provide more resiliency, scale. The resources are expected to be ephemeral. They are created and destroyed dynamically while the preceding regional resources outside the stamp continue to persist. 

**Workload compute**

Both virtual machines and containers are used to host the workload. The technology choices are the standard Azure Virtual Machine and Azure Kubernetes Service (AKS), respectively. AKS was chosen as the container orchestrator because it's widely adopted and supports advanced scalability and deployment topologies. 


## Workload design

The application is part of the stamp is immutable. Application service instances (SIs) deliver the actual application function. Any application SI can serve a client request. They are deployed and monitored by the management service.

### Resiliency considerations

The services are implemented as microservices, containerized in a regional AKS cluster. The microservice pattern allows for separation of processing elements and state so that failure in one component doesn't affect others. The SIs are stateless and long-living state is stored in an external database. 

To build redundancy, SIs are deployed in multiple Availability Zones and regions in an active-active model. 

The components within each SI use a fate-sharing model, which simplifies logic flows and connection paths by removing the need for special case code to handle partial failure conditions. 

### Monitoring

This implementation has a health model in place to make sure client requests aren't sent to unhealthy instances. The management service probes the application SIs at regular intervals and maintain a health status. If the health state of a particular SI is degraded, the management service stops responding to the polling request and traffic isn't routed to that instance.  


## Traffic management

![Diagram showing the logical architecture of a carrier-grade solution](./images/carrier-grade-traffic.svg)

The application is fronted by a traffic management layer which provides load balancing. Incoming traffic can be categorized based on the type of protocol:

- **Protocol A** accesses the application through an intermediate gateway component outside the cloud. The design uses [gateway routing pattern](/azure/architecture/patterns/gateway-routing) in which the gateway serves as the single endpoint and routes traffic to multiple backend SIs. 

- **Protocol B** routes HTTP traffic to the application in multiple regions. Azure Traffic Manager is used as global load balancer and routes traffic based on DNS. 

The internal load balancer distributes incoming requests to the SI pods. The services are reachable through their DNS names assigned by native Kubernetes objects.

### Reliability considerations 

Traffic Manager is on the critical path for clients making their initial connection and for clients whose existing cached DNS records have expired. If Traffic Manager is unavailable, the system will appear as offline to the clients. So, when calculating the composite SLA target for the system, Traffic Manager SLA must be considered. 

Like Traffic Manager, the gateway is also a single point of failure. Failure will impact new client connections and existing clients after the cached DNS entry expires.

If a backend service is unavailable, Traffic Manager and gateway won't update the DNS record until DNS time-to-live (TTL) has expired. Clients will continue to reach the last-known address. Use Azure policies to enforce terminating long-running calls or connections that still exist.

Because both routers depend on Azure DNS, as a foundational service, to reduce complexity and higher Service Level Agreement (SLA).  However, if that service is unavailable, expect a full outage. 

### Health monitoring

The health model makes sure client requests aren't routed to unhealthy instances. The traffic management layer polls the backend management service before routing traffic. 

For Protocol A, the gateway is responsible for endpoint monitoring. It receives a prioritized list of SI access points from a DNS server and uses active polling to determine SI liveness. 

For Protocol B, Azure Traffic Manager has its own active polling that minimizes the chance of sending traffic to an unresponsive SI. Unhealthy endpoints are excluded in the DNS response to clients. This approach helps reliability because a client’s first attempt to reach a server will most likely be successful. 

## Data consistency

For carrier-grade workloads, it's recommended that crucial data related to the workload is stored externally.  Writing to the database is a critical process for this use case. In case of a failure, time taken to bring up an instance in  another region should be minimized.

- Data should be regionally replicated in an active-active configuration such as that it's instantly synchronized across regions. Also, all instances should be able to handle read and write requests. 
- In case of a failure, write requests to the database should still be functional.

Azure Cosmos DB was chosen as the global database because it meets those requirements. The architecture uses the multi-write region model. If there's a global outage, consistent data is available in multiple regions almost instantly. Also, zonal redundancy is guaranteed through availability zone redundancy support (AZRS).

> Refer to [Well-Architected carrier-grade workloads](/azure/architecture/framework/carrier-grade/carrier-grade-design-area-data-model).

This architecture also uses Azure Blob Storage to store supplementary data, such as long-term metrics data,  application core dumps and diagnostics packages. The resource is configured to use zone-redundant storage (ZRS), in conjunction with [object replication](/azure/storage/blobs/object-replication-overview) between regions. This combination was chosen because it allows control of the secondary region and storage tier, that is, premium primary copy and hot/cool secondary copy. For this use case, it's also a cost-effective way of replicating data. 

## Scalability considerations

The overall solution is sized such that any single region can fail and the remaining regions will still be able to service the expected traffic load. Scale is achieved through the combination of individual service instance capacity and the total number of instances.  

The capacity of the individual service instance is adjusted based on load testing results that predict load variations. Autoscaling is enabled for the service and cluster by using AKS Cluster Autoscaler and Kubernetes Horizontal Pod Autoscaler. There are components that scale manually. For these components, scale limits are defined in the configuration and scaling is handled as an upgrade operation. This is discussed in 

## Overall observability

Logs and metrics emitted by the workload that Azure resources are collected and stored in Azure Monitor Logs and Blob Storage. They are handled by the management service in each Availability Zone and not replicated outside each zone because the additional cost isn't justified in this case. Application-wide monitoring is achieved through use of federated queries across the management service in each zone. Monitoring data is retained so that diagnosis can be performed after the fact, allowing fault resolution. 

Alerts are set up by the application instances. Metric threshold events are replicated across all zones and regions so they are always available. 

## Operational considerations

The operational aspect of the architecture is key to achieving high availability. This covers automation, deployment, secret management decisions of the architecture.

### Deployment

Application source code and configuration are stored in a Git repository in Azure DevOps Repos. A GitOps approach is used for continuous integration/continuous deployment (CI/CD). 

Flux is the GitOps operator that responds to changes and triggers scripting tool to create Azure resources for the service instances. These include virtual machines, AKS cluster, convergence pods, and updates DNS for service discovery of the new instance. Scaling requirements are also met by GitOps. For manual scaling, scale limits are defined in the service instance configuration. Scaling is achieved through the upgrade process that creates new instances of the required size and then replaces the current one. 

Conversely, Flux also decommissions resources that are not required. For example, if it's determined that a particular instance shouldn't receive traffic, Flux reacts to the configuration change by triggering DNS updates that stops new traffic from reaching the instance. Also, when definition files are removed, GitOps triggers scripting to gracefully delete the cluster, virtual machines, and other Azure resources. Resources are decommissioned as part of scaling in operations. 

### Upgrade, patching, and configuration updates

When a new instance is created, the deployment config files are changed to indicate increase in traffic to the new instance and decrease traffic to the old instance. Flux detects this change and updates the DNS records. In case of errors, traffic is reverted to the old instance. Otherwise, the old instance is decommissioned. 

### Automation

Various automation technologies are used in the operational flow, and automation is fundamental to the overall resiliency given the required reaction times. However, it's also critical that control is not fully closed-loop, so there are explicit manual gates and fire breaks within the end to end process to ensure any contagion cannot infect the complete solution via the automation pathways.  The text below looks at the specific operational steps needed for various lifecycle events.

## Testing and validation

From an availability perspective, what is important is that the failure mode analysis is extended to include all network segments between elements of the application, and between the application and the clients, since outages here will still impact availability of the application as perceived by the users. 

## Alternatives

- Instead of Storage Queue, you can choose another message broker that has reliability guarantees. Azure Service Bus is a good option because it has two-phase commits and features such as a built-in dead letter queue and deduplication capabilities.

- Another option for global routing is Azure Front Door. It has built-in Web Application Firewall (WAF) capabilities applied to secure Layer 7 ingress traffic.

## Related resources

For product documentation on the Azure services used in this architecture, see these articles.

- [Azure Traffic Manager](/azure/traffic-manager/)
- [Azure Cosmos DB](/azure/cosmos-db/)
- [Azure Container Registry](/azure/container-registry/)
- [Azure Key Vault](/azure/key-vault/)
- [Azure Kubernetes Service](/azure/aks/)
- [Azure Application Insights](/azure/azure-monitor/)
- [Azure Blob Storage](/azure/storage/blobs/)