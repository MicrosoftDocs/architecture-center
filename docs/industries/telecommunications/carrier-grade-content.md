This architecture provides guidance for designing a carrier-grade solution for a telecommunication use case. The design choices focus on high reliability by minimizing points of failure and ultimately the overall downtime using native Azure capabilities. It applies [Well-Architected](/azure/architecture/framework/carrier-grade/carrier-grade-get-started) design principles to a carrier-grade workload. 

## Architecture

This reference architecture is for a voicemail solution, where multiple clients connect to the workload in a shared model. They can connect using different protocols potentially for different operations. Certain operations might need to persist state in a database. Other operations can query for that data. These operations are simple request/response and don't need long-lived sessions. In case of a failure, the client will just retry the operation. 

In this use case, the business requirements necessitate that the requests be served at the edge to reduce latency. As such, the application isn't required to maintain active session state for in-flight messages if failure occurs. Application logic can accept an eventual consistency data replication model with distributed processing pools, instead of the application requiring global synchronization of its data with a single point of control. Also, there aren't any regulatory requirements.

![Diagram showing the physical architecture of a carrier-grade solution](./images/physical-architecture-carrier-grade.png)

The workload has two main layers; each layer is composed of immutable service instances (SIs). They differ in their functions and lifetimes.

- Application SIs deliver the actual application function and are intended to be short-lived. 
- Management SIs only deliver the management and monitoring aspects for the application. 

The workload is hosted in Azure infrastructure and several Azure services participate in processing requests and the operations related to the workload. The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

These resources provide functionality that's shared by resources deployed in regions. For instance, the global load balancer that distributes traffic to multiple regions. F foundational services that other services depend on, such as the identity platform. Global resources also include services that maintain functional consistency across regions, such as shared state stores and databases. 

#### Azure Traffic Manager

The global load balancer that uses DNS-based routing to send traffic to the application SI that have public endpoints. Health endpoint monitoring is enabled to make sure that traffic is sent to healthy backend instances. 

An alternate technology choice is Azure Front Door. This option only applies to HTTP(S) traffic and can add to the cost. 

#### Azure DNS 

Handles traffic that flows through the intermediate gateway. The gateway is responsible for monitoring the health of the backend endpoints.

#### Azure Cosmos DB

Stores application payload metadata and end-user provisioning data. Also used by dependent services listed above. Multi-master write is enabled so that data is replicated to each region. Also, zone redundancy is enabled through availability zone redundancy support (AZRS). 

> [!IMPORTANT] 
> If any global service is unavailable, the entire system will be impacted. If Azure DNS is unavailable, Traffic Manager won't be able to route traffic. If Azure AD fails, existing compute nodes will continue to work, however, new nodes won't be created. 

### Regional resources

This set of services that are deployed to a given region and their lifetime is tied to the region. They are independent in that unavailability of a resource in one region shouldn't impact resources in another region. There might be simultaneous outages in multiple regions but the impact must be restricted to the individual region.

#### Workload compute

Both virtual machines and containers are used to host the workload. The technology choices are the standard Azure Virtual Machine and Azure Kubernetes Service (AKS), respectively. AKS was chosen as the container orcherstrator because it's widely adopted and supports advanced scalability and deployment topologies. 

The cluster is configured to use all three availability zones in a given region. This makes it possible for the cluster to use AKS Uptime SLA that guarantees 99.95% SLA availability of the AKS control plane.

#### Azure Container Registry

Store all  Open Container Initiative (OCI) artifacts. Zone redundancy is enabled. 

#### Azure Key Vault

Stores global secrets such as connection strings to the global database and regional secrets.

#### Azure Blob Storage (ABS) 

Premium SKU is used for large payload data, long-term metrics data, virtual machine images, application core dumps and diagnostics packages. Storage is configured for  zone-redundant storage (ZRS), object replication (OR) between regions, and application-level handling. 

All SIs are interchangeable in that any SI can service any request. Any application SI can serve a client request. More than one managment SI can service a single appliction SI. SIs are deployed in active-active mode in multiple Availability Zones and multiple regions.  

## Request flow

![Diagram showing the logical architecture of a carrier-grade solution](./images/logical-architecture-carrier-grade.png)


Although any SI can service any incoming request, the application is fronted by a traffic management layer which provides load balancing.   

Incoming traffic uses two types of network protocols/clients: 

The first accesses the application via a gateway element outside the cloud.  This gateway element receives the prioritized list of SI access points from a DNS server, and uses active polling to determine SI liveness.  This is an example of the gateway routing pattern. 

The second relies solely on DNS steering using a traffic manager element.  The traffic manager has its own active polling and maintains health lists to minimise the chance of including an unresponsive SI in a DNS response. 


## Networking considerations

Unhealthy endpoints are excluded in the DNS response to clients. This helps boost reliability because a client’s first attempt to reach a server will most likely be successful. 

Traffic Manager is on the critical path for clients making their initial connection and for clients whose existing cached DNS records have expired. If this service is unavailable, the system will appear as offline to the clients. So, there's a reliability dependency on this service to achieve the overall reliability targets. 


within the architecture where the additional features of ATM are not required, since it is simpler and (currently) has a higher SLO.  Within the reference architecture, this means Global DNS is primarily used to handle the protocol traffic which flows through the intermediate gateway.  This is marked Protocol A traffic in the earlier diagram.  Here, the intermediate gateway takes on the responsibility for endpoint monitoring. 


Azure Networking 

Depending on the specific application, and the details of the deployment, the exact networking requirements can vary significantly, and so they are not dwelt on here.  Any given instance of the architecture is likely to use some or all of vNets, vNet peering, ExpressRoute, Private Endpoints and Private DNS Zones.  From an availability perspective, what is important is that the failure mode analysis is extended to include all network segments between elements of the application, and between the application and the clients, since outages here will still impact availability of the application as perceived by the users. 

## Data consistency considerations

The documented guidance10 for Cosmos DB is to use the single-write region option with service-managed failover for high availability in case of region outage.  However, the reference architecture instead uses the multi-write region model (with availability zone redundancy support – AZRS).  This is because the Cosmos DB process for handling failure of the write region is to bring up a new write instance in another region.  Even with service-managed instances, this will take at least minutes, and can be much longer.  Since writing to the database is a critical process for the reference application, such a global outage duration cannot be tolerated, and so the multi-write region option is the only acceptable choice.  This in turn requires the use of conflict-free replicated data types (CRDTs) within the application, as discussed in the Considered Data Model section of the Appendix. 

An application which had less demanding outage requirements on the ability to write data might be able to use the single-write region option. 

Cosmos DB is selected over other replicated database options since it is the only NoSQL database which is an Azure 1st Party managed service. 



ABS: This combination provides the best compromise for a cost-effective GR storage solution for the volumes of data needed for the reference application.  ZRS plus OR is chosen over GZRS because it allows control of the secondary region and storage tier (premium primary copy and hot/cool secondary copy). 



## Scaling

Scale is achieved through the combination of individual SI capacity and the total number of SIs.   

The overall solution is sized such that any single region can fail and the remaining regions will still be able to service the expected traffic load. 


## Related resources
For product documentation on the Azure services used in this architecture, see these articles.

Azure Front Door
Azure Cosmos DB
Azure Container Registry
Azure Log Analytics
Azure Key Vault
Azure Service Bus
Azure Kubernetes Service
Azure Application Insights
Azure Event Hubs
Azure Blob Storage