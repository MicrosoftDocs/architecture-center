This architecture provides guidance for designing a carrier-grade solution for a telecommunication use case. The design choices focus on high reliability by minimizing points of failure and ultimately the overall downtime using native Azure capabilities. 

> [!TIP] 
> This architecture is based on the design principles of a carrier-grade workload. We highly recommend that you read [Well-Architected](/azure/architecture/framework/carrier-grade/carrier-grade-get-started) documentation to undersand the design choices made in this architecture. 

## Use case

This reference architecture is for a voicemail solution. It offers common functionalities such as, play greeting and record voicemail, retrieve voicemail through phone or app, configure features, and much more.  

Multiple clients can connect to the workload using various protocols. They can be HTTP or non-web protocols, such as Session Initiation Protocol. A connection will lead to persisted state, which can be client configuration, messages, and related metadata. 

## Workload requirements
- The workload is expected to have a Service Level Object target of 99.999%, which equates to outage duration of less than 5 minutes per year.
- Application requests for all the supported protocols must be load-balanced across all the active service instances (SIs).
- Replication of write operations on subscriber data must be instantaneous across regions. Any service instance reading data always gets served the latest and most up to date version of the subscriber data.
- If a failure occurs in the middle of an active subscriber voice mail session, the caller will need to reconnect. The application isn't required to maintain active session state for in-flight messages.

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

Allows access to the application through a gateway outside the cloud. Before the gateway sends traffic, it determines the health of the backend endpoints from a DNS server.

> [!IMPORTANT] 
> Global routing is handled through DNS. If any global service or a foundational service, such as DNS, identity platform isn't available, the entire system will be impacted. 

### Regional resources

This set of services that are deployed each region and their lifetime is tied to the region.  

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

## Key design strategies

- **Active-active muti-region deployment**. 12 service instances are deployed across four regions to minimize regional outage as a single point of failure. In active-active model, there's no failover also making  request processing fast and reliable.
- **Replicated storage**. The application itself is stateless. Any data that's shared between regions is replicated. For example, data stored in Cosmos DB is  replicated between regions. Another component used is Blob Storage, which is replicated into just two regions for cost efficiency.
- **Eventual data consistency enforced by Consistency, Availability, and Partition tolerance (CAP)**. Application logic uses conflict-free replicated data types (CRDTs) to handle eventual inconsistency.
- **Shared fate within each stamp**. TODO
- **Avoid correlated failure modes**. Take independent elements, which aren't highly available, and combine them so that they remain independent entities. (e.g., 99.9% \/ 99.9% = 99.9999% if indep, 99.9% if not). TODO

## Workload design

The workload has two main layers; each layer is composed of immutable service instances (SIs). They differ in their functions and lifetimes.

- Application service delivers the actual application function and is intended to be short-lived. 
- Management service only delivers the management and monitoring aspects for the application. 

All SIs are interchangeable in that any SI can service any request. Any application SI can serve a client request. More than one management SI can service a single application SI.

> TODO: Incorporate these RI features

- making use of subscriptions as a scale unit, and more generally re-evaluating the current selection of scale units;
- more use of event-driven processing, though in many cases synchronous processing is forced by the external protocols MVM must support;
- explicit tabulation of concerns such as disaster recovery strategy, SLA, etc across the different MVM components and features (currently known but not tabulated).


### Resiliency considerations

The services are implemented as microservices, containerized in a regional AKS cluster. The microservice pattern allows for separation of processing elements and state so that failure in one component doesn't affect others. The SIs are stateless and long-living state is stored in an external database. 

_**To increase reliability, the cluster uses AKS Uptime SLA that SLA guarantees 99.95% SLA availability of the AKS control plane.**_ SIs are deployed in multiple Availability Zones and regions in an active-active model. An application SI and its associated management and monitoring SIs are colocated in the cluster, so a local failure terminates both the application SI and all related SIs. 

> TODO: Why?--> Although the diagram shows multiple AZs, the pattern does not rely on AZs. It would be perfectly acceptable to deploy multiple application SIs into a single zone. Equally, use of single-AZ regions is fully supported, subject to the overall capacity requirements of the workload.

The components within each SI use a fate-sharing model, which simplifies logic flows and connection paths by removing the need for special case code to handle partial failure conditions. 

### Monitoring

This implementation has a health model in place to make sure client requests aren't sent to unhealthy instances. The management SIs probe the application SIs at regular intervals and maintain a health status. If the health state of a particular SI is degraded, the management SI stops responding to the polling request and traffic isn't routed to that instance.  

> TODO incoporate these RI features
- building an explicit health model that can be used to monitor the application and drive automated remediation;
- enhancing synthetic health probes to exercise more of the system, and adding health data from live traffic;
- correlating and combining health data across MVM and Azure services (currently these are siloed in separate systems).


## Traffic management

![Diagram showing the logical architecture of a carrier-grade solution](./images/carrier-grade-traffic.svg)

The application is fronted by a traffic management layer which provides load balancing. Incoming traffic can be categorized based on the type of protocol:

- **Protocol A** accesses the application through an intermediate gateway component outside the cloud. The design uses [gateway routing pattern](/azure/architecture/patterns/gateway-routing) in which the gateway serves as the single endpoint and routes traffic to multiple backend SIs. 

- **Protocol B** routes internet traffic to the application in multiple regions. Azure Traffic Manager is used as global load balancer and routes traffic based on DNS. 

The internal load balancer distributes incoming requests to the SI pods. The services are reachable through their DNS names assigned by native Kubernetes objects.

### Health monitoring

The health model makes sure client requests aren't routed to unhealthy instances. The traffic management layer polls the backend management SIs before routing traffic. 

For Protocol A, the gateway is responsible for endpoint monitoring. It receives a prioritized list of SI access points from a DNS server and uses active polling to determine SI liveness. 

For Protocol B, Azure Traffic Manager has its own active polling that minimizes the chance of sending traffic to an unresponsive SI. Unhealthy endpoints are excluded in the DNS response to clients. This approach helps reliability because a client’s first attempt to reach a server will most likely be successful. 

### Reliability considerations 

In the Protocol A routing pattern, the gateway can be a single point of failure. Azure Global DNS is chosen to reduce complexity and higher Service Level Agreement (SLA). 

> TODO Is the gateway single point of failure then? What fault tolerance capabilities are in place to avoid this situation.

Traffic Manager is on the critical path for clients making their initial connection and for clients whose existing cached DNS records have expired. If Traffic Manager is unavailable, the system will appear as offline to the clients. So, when calculating the composite SLA target for the system, Traffic Manager SLA must be considered. 

### Security considerations

> TODO In choosing TM, we don't get WAF. So security can bring down the reliability. Should we address that?

> TODO: Incorporate these RI features

- further threat modeling, regular penetration testing and other security reviews, regular automated security monitoring;
- use of PIM for just-in-time access to systems;
- use of Azure Policy to drive governance;
- use of DDoS Protection;
- and a review of other security items and considerations.


## Data consistency

For carrier-grade workloads, it's recommended that crucial data related to the workload is stored externally.  Writing to the database is a critical process for this use case. In case of a failure, time taken to bring up an instance in  another region should be minimized.

- Data should be regionally replicated in an active-active configuration such as that it's instantly synchronized across regions. Also, all instances should be able to handle read and write requests. 
- In case of a failure, write requests to the database should still be functional.

Azure Cosmos DB was chosen as the global database because it meets those requirements. The architecture uses the multi-write region model. If there's a global outage, consistent data is available in multiple regions almost instantly. Also, zonal redundancy is guaranteed through availability zone redundancy support (AZRS).

> Refer to [Well-Architected carrier-grade workloads](/azure/architecture/framework/carrier-grade/carrier-grade-design-area-data-model).

This architecture also uses Azure Blob Storage to store supplementary data, such as long-term metrics data,  application core dumps and diagnostics packages. The resource is configured to use zone-redundant storage (ZRS), in conjunction with [object replication](/azure/storage/blobs/object-replication-overview) between regions. This combination was chosen because it allows control of the secondary region and storage tier, that is, premium primary copy and hot/cool secondary copy. For this use case, it's also a cost-effective way of replicating data. 

> TODO why isn't metrics data stored in log analytics workspace

## Scalability considerations

The overall solution is sized such that any single region can fail and the remaining regions will still be able to service the expected traffic load. Scale is achieved through the combination of individual service instance capacity and the total number of instances.  

The capacity of the individual service instance is adjusted based on load testing results that predict load variations. Autoscaling is enabled for the service and cluster by using AKS Cluster Autoscaler and Kubernetes Horizontal Pod Autoscaler. There are components that scale manually. For these components, scale limits are defined in the configuration and scaling is handled as an upgrade operation. This is discussed in 

## Overall observability

Logs and metrics emitted by the workload that Azure resources are collected and stored in Azure Monitor Logs and Blob Storage. They are handled by the management SIs in each Availability Zone and not replicated outside each zone because the additional cost isn't justified in this case. Application-wide monitoring is achieved through use of federated queries across the management SIs in each AZ. 

Alerts are set up by the application SIs or by metric threshold events in the Stats SIs are replicated across all AZs and regions so they are always available. 

In the event of issues with the Application SIs, the Stats SIs data stores are retained for several days before aging out, so that issue diagnosis can be performed after the fact, allowing fault resolution. 

> TODO understand what the Stats SIs are doing here. 

## Operational considerations

The operational aspect of the architecture is key to achieving high availability. This covers automation, deployment, secret management decisions of the architecture.

### Deployment

Application source code and configuration are stored in a GitHub repository. GitOps is used for version control, continuous integration/continuous deployment (CI/CD), and other DevOps practices. 

Flux is the GitOps operator that responds to changes and triggers scripting tool to create Azure resources for the service instances. These include virtual machines, AKS cluster, convergence pods, and updates DNS for service discovery of the new instance. Scaling requirements are also met by GitOps. For manual scaling, scale limits are defined in the service instance configuration. Scaling is achieved through the upgrade process that creates new instances of the required size and then replaces the current one. 

Conversely, Flux also decommissions resources that are not required. For example, if it's determined that a particular instance shouldn't receive traffic, Flux reacts to the configuration change by triggering DNS updates that stops new traffic from reaching the instance. Also, when definition files are removed, GitOps triggers scripting to gracefully delete the cluster, virtual machines, and other Azure resources. Resources are decommissioned as part of scaling in operations. 

> TODO: Understand this: Wait for DNS TTL to expire and in-progress calls to end (or make policy decision to forcibly proceed and terminate long-running calls/connections that still exist). 

> TODO: Talk about the reliability guarantees.

### Upgrade, patching, and configuration updates

When a new instance is created, the deployment config files are changed to indicate increase in traffic to the new instance and decrease traffic to the old instance. Flux detects this change and updates the DNS records. In case of errors, traffic is reverted to the old instance. Otherwise, the old instance is decommissioned. 

### Automation

Various automation technologies are used in the operational flow, and automation is fundamental to the overall resiliency given the required reaction times. However, it's also critical that control is not fully closed-loop, so there are explicit manual gates and fire breaks within the end to end process to ensure any contagion cannot infect the complete solution via the automation pathways.  The text below looks at the specific operational steps needed for various lifecycle events.

### TODO incorporate these RI features
- making use of AIOps;
- regular automated chaos and failure testing as part of CI rather than ad-hoc;
- better usage of AAD and Managed Identities for authentication;
- improved handling of secrets, such as automated key rotation and automated re-retrieval of failing secrets;
- automation of capacity change processes;
- further operational improvem


## Testing and validation

From an availability perspective, what is important is that the failure mode analysis is extended to include all network segments between elements of the application, and between the application and the clients, since outages here will still impact availability of the application as perceived by the users. 





## Related resources
For product documentation on the Azure services used in this architecture, see these articles.

Azure Traffic Manager
Azure Cosmos DB
Azure Container Registry
Azure Key Vault
Azure Kubernetes Service
Azure Application Insights
Azure Event Hubs
Azure Blob Storage