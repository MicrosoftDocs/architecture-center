
A key design area of any mission critical architecture is the application platform. Platform refers to the infrastructure components and Azure services that must be provisioned to support the workload. Here are some overarching recommendations as you build the platform.

-	Design in layers: the right set of services, their configuration, and the application-specific dependencies. This layered approach helps in creating segmentation that's useful in defining roles and functions and assigning appropriate privileges. Also, deployment is more manageable.   
-	A mission-critical application must be highly reliable and resistant to datacenter and regional failures. Building _zonal and regional redundancy_ in an active-active configuration is the main strategy. As you choose Azure services, consider its Availability Zones support and using multiple Azure regions. 
-	Use _scale units_ to handle increased load. Scale units allow you to logically group services and a unit can be scaled independent of other units or services in the architecture. Use your capacity model and expected performance to define a unit.

In this architecture, the application platform consists of global and regional resources. The regional resources are provisioned as part of a deployment stamp. Each stamp equates to a scale unit. The resources in each set have distinct characteristics:

|Characteristics|Considerations|
|---|---|
|Lifetime|What is the expected lifetime of resource? Should the resource share the lifetime with the entire system, region, or should they be temporary?|
|State|Should the resource persist state? |
|Reach|Is the resource required to be globally distributed? Can the resource communicate with other resources, globally or in regions?|
|Dependencies| What's the dependency on other resources, , globally or in other regions?|
|Scale limits|What is the expected throughput?|
|Availability/disaster recovery|Is the resource configured for high availability?|


## Global resources

Certain resources in this architecture are shared by resources deployed in regions. In this architecture, they are used to distribute traffic across multiple regions, store permanent state, and cache static data. 

|Characteristics|Considerations|
|---|---|
|Lifetime|The resources are expected to be long living. Their lifetime spans the life of the system.|
|State| Only the global resources in the entire system should store permanent state over the lifetime of the system.|
|Reach|The resources should be globally distributed. It’s recommended that these resources communicate with regional or other resources with low latency and the desired consistency.|
|Dependencies| The resources should avoid dependency on regional resources because unavailability of the regional resource can be a cause of failure. For example, certificates or secrets shouldn’t be kept in a key store that’s deployed regionally. |
|Scale limits|The resources should be scaled such that they can handle throughput of the system as a whole.|
|Availability/disaster recovery|Because regional and stamp resources can consume global resources, it’s critical that global resources are configured with high availability and disaster recovery. Otherwise, if these resources become unavailable, the entire system is at risk.|

In this architecture, global resources are Azure Front Door, Azure Cosmos DB, Azure Container Registry, and Azure Log Analytics for storing logs and metrics from global resources. 

![Global resources](./images/global-resources.png)

### Global load balancer

Azure Front Door is used as the only entry point for user traffic. If Front Door becomes unavailable, the entire system is at risk. Azure guarantees that Azure Front Door will deliver the requested content without error 99.99% of the time. 

The Front Door instance sends traffic to the configured backend services, such as the compute cluster and frontend. Such misconfigurations can lead to outages. To avoid such situations, catch errors during testing. Another common error is missing SSL certificate that can prevent users from using the front end. As mitigation, roll back to the previous configuration, re-issue the certificate, if possible. However, expect unavailability while changes take effect.

### Container Registry

Azure Container Registry is used to store Open Container Initiative (OCI) artifacts. It doesn't participate in the request flow and is only accessed periodically. So, a single instance can be considered. 

Container registry is required to exist before stamp resources are deployed and shouldn't have dependency on regional resources. Enable zone redundancy and geo-replication of registries so that runtime access to images is fast and resilient to failures. If Container registry is unavailable, the instance fails over to replica regions and requests are automatically re-routed to another region. Expect transient errors in pulling images until failover is complete. Failures can also occur if images are deleted unadvertantly, new compute nodes will not be able to pull images, but existing nodes can still use cached images. The primary strategy for disaster recovery is redeployment. The artifacts in a container registry can be regenerated from the pipelines.  

It’s recommended that you use the Premium SKU to enable geo replication. The zone redundancy feature ensures resiliency and high availability within a specific region. In case of a regional outage, replicas in other regions are available for data plane operations. With this SKU you can restrict access to the registry through private endpoints. This way, only your application can access that service. This also ensures that all of the potential throughput is available to your application.

### Database
It's recommended that all state is stored global in an external database. Build redundancy by deploying the database across regions. For mission-critical workloads, data consistency should be a primary concern. Also, in case of a failure, write requests to the database should still be functional. 

Data replication in an active-active configuraiton is strongly recommended. The application should be able to instantly connect with another region. Al instances should be able to handle read _and_ write requests.

This architecture uses Azure Cosmos DB with SQL API. Multi-master write is enabled with replicas deployed to every region in which a stamp is deployed. Zone redundancy is also enabled within each replicated region. 

For details on data considerations, see <!coming soon>.

### Global monitoring

Azure Log Analytics is used to store diagnostic logs from all global resources. It's recommended that you restrict daily quota on storage especially on environments that are used for load testing. Also, set retention policy. These restrictions will prevent any overspend that is incurred by storing data that is not needed beyond a limit. 


### Other causes for full outage

The system is likely to use other critical platform services that can cause the entire system to be at risk, such as Azure DNS and Azure Active Directory (AD). Unavailability of those services is unlikely. Azure DNS  guarantees 100% availability SLA for valid DNS requests. Azure Active Directory guarantees at least 99.9% uptime. Still, you should be aware of the impact in the event of a failure.

In this implementation, there are hard dependencies on Azure DNS. Front Door uses Azure DNS to reach the backend and other global services. In the event that Azure Container Registry is unavailable, Azure DNS is used to fail over requests to another region. In both cases, if Azure DNS is unavailable, name resolution for user requests from Front Door will fail; Docker images won't be pulled from the registry. Because both Azure services use Azure DNS, using an external DNS service as backup will not mitigate the risk. Expect full outage.

Similarly, Azure AD is used for control plane operations such as creating new AKS nodes, pulling images from Container Registry, or accessing Key Vault on pod startup. If Azure AD is unavailable, running components should not affected. But, new pods or AKS nodes won't be functional. Consider scaling in during this time and expect decreased user experience. 

## Deployment stamp resources

Each region can have one or more stamps. In this architecture, the stamp deploys the workload and resources that participate in completing a business transaction. 

|Characteristic|Consideration|
|---|---|
|Lifetime|The resources are expected to have a short life span (ephemeral) with the intent that they can get destroyed and created as needed. For example, when a stamp deems itself unhealthy. Regional resources outside the stamp continue to persist.|
|State| Because stamps are ephemeral, a stamp should be stateless as much as possible.|
|Reach|Can communicate with regional and global resources. However, communication with other regions or other stamps should be avoided. In this architecture, there isn't a need for these resources to be globally distributed.|
|Dependencies| The resources are expected to have regional and global dependencies. They shouldn't have dependencies on more than one region or other stamps. |
|Scale limits|Throughput is established through testing. The throughput of the overall stamp is limited to the least performant resource. Stamp throughput needs to take into account both the estimated high-level of demand plus any failover as the result of another stamp in the region becoming unavailable.|
|Availability/disaster recovery|Because of the temporary nature of stamps, disaster recovery is done by redeploying the stamp. If resources are in an unhealthy state, the stamp, as a whole, can be destroyed and redeployed. |

In this architecture, global resources are Azure Kubernetes Service (AKS), Azure Event Hubs, Azure Key Vault, and Azure Storage Accounts. 

![Stamp resources](./images/stamp-resources.png)

### Compute cluster

To containerize the workload, each stamp needs to run a compute cluster. In this architecture, Azure Kubernetes Service (AKS) is chosen because it Kubernetes is the most popular compute platform for modern applications.

The lifetime of the AKS cluster is bound to the ephemeral nature of the stamp. The cluster is stateless and doesn't have persistent volumes. It uses ephemeral OS disks instead of managed disks. They are not expected to receive application or system-level maintenance.

To increase reliability, the cluster is configured to use all three availability zones in a given region. This makes it possible for the cluster to use AKS Uptime SLA that guarantees 99.95% SLA availability of the AKS API endpoint. 

Scale limits also impact reliability. Even though, the cluster only uses the default node pool to run the simple workload, autoscaling is enabled to let the node pool automatically scale out if needed. For complex workloads, separating system and user node pools is necessary. All node pools should be autoscaled.  

At the pod level, the Horizontal Pod Autoscaler (HPA) scales pods based on configured CPU, memory, or custom metrics. Load test the components of the workload to establish a baseline for the autoscaler values.

The cluster is also configured for automatic node image upgrades and to scale appropriately during those upgrades to allow for zero downtime while upgrades are being performed.

Observability is critical in this architecture because stamps are ephemeral. Diagnostic settings are configured to store all log and metric data in a regional Log Analytics workspace. Also, AKS Container Insights is enabled through an in-cluster OMS Agent. This way cluster monitoring data is integrated with the Log Analytics workspace.

### Key Vault

Azure Key Vault is used to store global secrets such as connection strings to the database and stamp secrets such as the Event Hubs connection string. 

### Event Hubs
The only stateful service in the stamp is the message broker, Azure Event Hubs, which stores requests for a short period. The broker serves the need for buffering and reliable messaging. The processed requests are persisted in the global database.

In this architecture, Standard SKU is used and zone redundancy is enabled for high availability. 

Event Hubs health is verified by the HealthService component running on the compute cluster. It performs periodic checks against various resources. This is useful in detecting unhealthy conditions. Suppose messages cannot be sent to the event hub. This condition will make the stamp unusable for any write operations. HealthService should automatically detect this and take the stamp out of rotation.

For scalability, enabling auto-inflate through a Terraform variable is recommended.

For more information about HealthService and Event Hubs implementation, see Data platform considerations. 

### Storage accounts

In this architecture two storage accounts are provisioned. Both accounts are deployed in zone-redundant mode (ZRS).

One account is used Event Hub checkpointing. If this account is not responsive, the stamp won't be able to process messages from Event Hub and might even impact other services in the stamp. This condition is periodically checked by the HealthService. 

The other is used to host the UI single-page application. If serving of the static web site has any issues, Front Door will detect the issue (through configured health probes?) and won't send traffic to this storage account. During this time, Front Door can use cached content.


## Regional resources

A system can have resources that are deployed in region but outlive the stamp resources. In this architecture, observability data for stamp resources are stored in regional data stores. 

|Characteristic|Consideration|
|---|---|
|Lifetime|The resources share the lifetime of the region and out live the stamp resources.|
|State| State stored in a region cannot live beyond the lifetime of the region. If state needs to be shared across regions, consider using a global data store.|
|Reach|The resources don't need to be globally distributed. Direct communication with other regions should be avoided at all cost. |
|Dependencies| The resources can have dependencies on global resources, but not on stamp resources because stamps are meant to be short lived. |
|Scale limits|Determine the scale limit of regional resources by combining all stamps within the region.|
|Availability/disaster recovery|Coming Soon! |


![Regional resources](./images/regional-resources.png)

### Monitoring data for stamp resources
Deploying monitoring resources is a typical example for regional resources. In this architecture, each region has an individual Log Analytics workspace configured to store all log and metric data emitted from stamp resources. Because regional resource outlive stamp resources, data is available even when the stamp is deleted. 

Azure Log Analytics and Azure Application Insights are used to store logs and metrics from the platform. It's recommended that you restrict daily quota on storage especially on environments that are used for load testing. Also, set retention policy to store all data. These restrictions will prevent any overspend that is incurred by storing data that is not needed beyond a limit. 

Similarly, Application Insights is also deployed as a regional resource to collect all application monitoring data.



## Capacity planning
- Scale unit discussion



--- 
## Dump zone

### Scale units

A _scale unit_ approach is recommended for mission critical workloads where a set of resources can be independently scaled and deployed to keep up with the changes in demand.

![stamp pic]

A scale unit is a logical collection of resources. A stamp is a physical manifest of resources to be deployed. A stamp contains one or more scale units. They are meant to be short lived. After a stamp has served its purpose, it can be removed. 

Consider a use case where you want to deploy updates. It's recommended that a stamp is immutable. That is, deploy a new stamp with updates instead of redeploying the stamp with in- place updates. During the upgrade period, you might have the old and new stamps serving traffic simultaneously. After all the clients have migrated to the new version, you can remove the old stamp.

Here's another example. Suppose a stamp experiences high traffic and reaches its capacity. You deploy additional stamp in another region. When the traffic is back to normal, you can remove that additional stamp.

When a scale unit in a stamp reaches peak capacity, the entire stamp is considered at peak capacity regardless of the utilization of other scale units within that stamp. That's why relationship between related scale-units, and the components inside a single scale-unit, should be defined according to a capacity model, that balances the individual scalability of resources.

The capacity relations between all resources in a scale unit should be known and factored in. E.g.: "To handle 100 incoming requests, we need 5 ingress controller pods and 3 catalog service pods and 1000 RUs in Cosmos".

Thus, when scaling the ingress pods (ideally automatically), you should expect scaling of the catalog service and cosmos RUs within the same relations

Here are some scaling and availability considerations when choosing Azure services in a unit:

- Evaluate autoscaling capabilities of all the services. Load test the services to determine a range within which requests will be served. Based on the results configure minimum and maximum instances and target metrics. When the target is reached, you can choose to automate scaling of the entire unit. 

-  The Azure subscription scale limits and quotas must support the capacity and cost model set by the business requirements. Also check the limits of individual services in consideration. 

- Choose services that support availability zones to build redundancy. This might limit your technology choices.

For other considerations about the size of a unit, and combination of resources, see [Misson critical guidance in Well-architected Framework: ](https://docs.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-application-design#scale-unit-architecture).


## Table of contents

- [Architecture](#architecture)
  - [Stamp independence](#stamp-independence)
  - [Stateless compute clusters](#stateless-compute-clusters)
  - [Scale Units](#scale-units)
- [Infrastructure](#infrastructure)
  - [Available Azure regions](#available-azure-regions)
  - [Global resources](#global-resources)
  - [Stamp resources](#stamp-resources)
  - [Naming conventions](#naming-conventions)

---

The Azure Mission-Critical reference implementation follows a layered and modular approach. This approach achieves the following goals:

- Cleaner and manageable deployment design
- Ability to switch service(s) with other services providing similar capabilities depending on requirements
- Separation between layers which enables implementation of RBAC easier in case multiple teams are responsible for different aspects of Azure Mission-Critical application deployment and operations

The Azure Mission-Critical reference implementations are composed of three distinct layers:

- Infrastructure
- Configuration
- Application


Infrastructure layer contains all infrastructure components and underlying foundational services required for Azure Mission-Critical reference implementation. It is deployed using [Terraform]().

> Note: Bicep (ARM DSL) was considered during the early stages as part of a proof-of-concept. Please refer to the following [(archived stub)](/docs/reference-implementation/ZZZ-Archived-Bicep.md) for more details.

[Configuration layer]() applies the initial configuration and additional services on top of the infrastructure components deployed as part of infrastructure layer.

[Application layer]() contains all components and dependencies related to the application workload itself.

## Architecture

![Architecture overview](/docs/media/mission-critical-architecture-online.svg)

### Stamp independence

Every [stamp](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp) - which usually corresponds to a deployment to one Azure Region - is considered independent. Stamps are designed to work without relying on components in other regions (i.e. "share nothing").

The main shared component between stamps which requires synchronization at runtime is the database layer. For this, **Azure Cosmos DB** was chosen as it provides the crucial ability of multi-region writes i.e., each stamp can write locally with Cosmos DB handling data replication and synchronization between the stamps.

Aside from the database, a geo-replicated **Azure Container Registry** (ACR) is shared between the stamps. The ACR is replicated to every region which hosts a stamp to ensure fast and resilient access to the images at runtime.

Stamps can be added and removed dynamically as needed to provide more resiliency, scale and proximity to users.

A global load balancer is used to distribute and load balance incoming traffic to the stamps (see [Networking](/docs/reference-implementation/Networking-Design-Decisions.md) for details).

### Stateless compute clusters

As much as possible, no state should be stored on the compute clusters with all states externalized to the database. This allows users to start a user journey in one stamp and continue it in another.

### Scale Units

In addition to [stamp independence](#stamp-independence) and [stateless compute clusters](#stateless-compute-clusters), each "stamp" is considered to be a Scale Unit (SU) following the [Deployment stamps pattern](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp). All components and services within a given stamp are configured and tested to serve requests in a given range. This includes auto-scaling capabilities for each service as well as proper minimum and maximum values and regular evaluation.

An example Scale Unit design in Azure Mission-Critical consists of scalability requirements i.e. minimum values / the expected capacity:

**Scalability requirements**
| Metric | max |
| --- | --- |
| Users | 25k |
| New games/sec. | 200 |
| Get games/sec. | 5000 |

This definition is used to evaluate the capabilities of a SU on a regular basis, which later then needs to be translated into a Capacity Model. This in turn will inform the configuration of a SU which is able to serve the expected demand:

**Configuration**
| Component | min | max |
| --- | --- | --- |
| AKS nodes | 3 | 12 |
| Ingress controller replicas | 3 | 24 |
| Game Service replicas | 3 | 24 |
| Result Worker replicas | 3 | 12 |
| Event Hub throughput units | 1 | 10 |
| Cosmos DB RUs | 4000 | 40000 |

> Note: Cosmos DB RUs are scaled in all regions simultaneously.

Each SU is deployed into an Azure region and is therefore primarily handling traffic from that given area (although it can take over traffic from other regions when needed). This geographic spread will likely result in load patterns and business hours that might vary from region to region and as such, every SU is designed to scale-in/-down when idle.

## Infrastructure

### Available Azure Regions

The reference implementation of Azure Mission-Critical deploys a set of Azure services. These services are not available across all Azure regions. In addition, only regions which offer **[Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-region)** (AZs) are considered for a stamp. AZs are gradually being rolled-out and are not yet available across all regions. Due to these constraints, the reference implementation cannot be deployed to all Azure regions.

As of March 2022, following regions have been successfully tested with the reference implementation of Azure Mission-Critical:

**Europe/Africa**

- northeurope
- westeurope
- germanywestcentral
- francecentral
- uksouth
- norwayeast
- swedencentral
- southafricanorth

**Americas**

- westus2
- eastus
- eastus2
- centralus
- southcentralus
- brazilsouth
- canadacentral

**Asia Pacific**

- australiaeast
- southeastasia
- eastasia
- japaneast
- koreacentral

> Note: Depending on which regions you select, you might need to first request quota with Azure Support for some of the services (mostly for AKS VMs and Cosmos DB).

It's worth calling out that where an Azure service is not available, an equivalent service may be deployed in its place. Availability Zones are the main limiting factor as far as the reference implementation of AZ is concerned.

As regional availability of services used in reference implementation and AZs ramp-up, we foresee this list changing and support for additional Azure regions improving where reference implementation can be deployed.

> Note: If the target availability SLA for your application workload can be achieved without AZs and/or your workload is not bound with compliance related to data sovereignty, an alternate region where all services/AZs are available can be considered.



### Stamp resources

A _stamp_ is a regional deployment and can also be considered as a scale-unit. For now we only always deploy one stamp in an Azure Region but this can be extended to allow multiple stamps per region if required.



