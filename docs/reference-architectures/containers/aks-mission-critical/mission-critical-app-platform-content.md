
A key design area of any mission critical architecture is the application platform. Platform refers to the infrastructure components and Azure services that must be provisioned to support the application. Here are some overarching recommendations as you build the platform.

-	Design in layers. Choose the right set of services, their configuration, and the application-specific dependencies. This layered approach helps in creating segmentation that's useful in defining roles and functions and assigning appropriate privileges. Also, deployment is more manageable. 

-	A mission-critical application must be highly reliable and resistant to datacenter and regional failures. Building _zonal and regional redundancy_ in an active-active configuration is the main strategy. As you choose Azure services, consider its Availability Zones support and using multiple Azure regions. Check [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-region) to determine support for services.

-	Use _scale units_ to handle increased load. Scale units allow you to logically group services and a unit can be scaled independent of other units or services in the architecture. Use your capacity model and expected performance to define a unit.

In this architecture, the application platform consists of global, deployment stamp, and regional resources. The regional resources are provisioned as part of a deployment stamp. Each stamp equates to a scale unit.


The resources in each set have distinct characteristics:

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

This architecture uses Azure Cosmos DB with SQL API. Multi-master write is enabled with replicas deployed to every region in which a stamp is deployed. Each stamp can write locally and  Cosmos DB handles data replication and synchronization between the stamps.

Zone redundancy is also enabled within each replicated region. 

For details on data considerations, see <!coming soon>.

### Global monitoring

Azure Log Analytics is used to store diagnostic logs from all global resources. It's recommended that you restrict daily quota on storage especially on environments that are used for load testing. Also, set retention policy. These restrictions will prevent any overspend that is incurred by storing data that is not needed beyond a limit. 


### Considerations for foundational services

The system is likely to use other critical platform services that can cause the entire system to be at risk, such as Azure DNS and Azure Active Directory (AD). Unavailability of those services is unlikely. Azure DNS  guarantees 100% availability SLA for valid DNS requests. Azure Active Directory guarantees at least 99.9% uptime. Still, you should be aware of the impact in the event of a failure.

There are hard dependencies on Azure DNS because many Azure services use DNS. For instance, 
- Front Door uses Azure DNS to reach the backend and other global services. 
- Azure Container Registry uses Azure DNS to fail over requests to another region. 

In both cases, both Azure services will be impacted if Azure DNS is unavailable. In the preceding examples, name resolution for user requests from Front Door will fail; Docker images won't be pulled from the registry. Using an external DNS service as backup will not mitigate the risk. Expect full outage.

Similarly, Azure AD is used for control plane operations such as creating new AKS nodes, pulling images from Container Registry, or accessing Key Vault on pod startup. If Azure AD is unavailable, running components should not affected. But, new pods or AKS nodes won't be functional. Consider scaling in during this time and expect decreased user experience. 

Expect disruption in the system caused by foundational services that impact the Azure services chosen in the architecture.

## Deployment stamp resources

In this architecture, the deployment stamp deploys the workload and provisions resources that participate in completing the business transactions. A stamp typically corresponds to a deployment to an Azure region. Although, a region can have more than one stamp. 

|Characteristics|Considerations|
|---|---|
|Lifetime|The resources are expected to have a short life span (ephemeral) with the intent that they can get added and removed dynamically while regional resources outside the stamp continue to persist. The ephemeral nature is needed to provide more resiliency, scale, and proximity to users. |
|State| Because stamps are ephemeral, a stamp should be stateless as much as possible.|
|Reach|Can communicate with regional and global resources. However, communication with other regions or other stamps should be avoided. In this architecture, there isn't a need for these resources to be globally distributed.|
|Dependencies| The stamp resources must be independent. That is, they should not rely on other stamps or components in other regions. They are expected to have regional and global dependencies. </br>The main shared component between stamps which requires synchronization at runtime is the database layer and container registry.|
|Scale limits|Throughput is established through testing. The throughput of the overall stamp is limited to the least performant resource. Stamp throughput needs to take into account both the estimated high-level of demand plus any failover as the result of another stamp in the region becoming unavailable.|
|Availability/disaster recovery|Because of the temporary nature of stamps, disaster recovery is done by redeploying the stamp. If resources are in an unhealthy state, the stamp, as a whole, can be destroyed and redeployed. |

In this architecture, stamp resources are Azure Kubernetes Service (AKS), Azure Event Hubs, Azure Key Vault, and Azure Storage Accounts. 

![Stamp resources](./images/stamp-resources.png)

### Scale unit
A stamp can also be considered as a scale-unit. All components and services within a given stamp are configured and tested to serve requests in a given range. Here are some scaling and availability considerations when choosing Azure services in a unit:

- Evaluate capacity relations between all resources in a scale unit. For example, to handle 100 incoming requests, 5 ingress controller pods and 3 catalog service pods and 1000 RUs in Cosmos DB would be needed. So, when autoscaling the ingress pods, expect scaling of the catalog service and cosmos RUs given those ranges.

- Load test the services to determine a range within which requests will be served. Based on the results configure minimum and maximum instances and target metrics. When the target is reached, you can choose to automate scaling of the entire unit.

  **Scalability requirements**

  | Metric | max |
  | --- | --- |
  | Users | 25k |
  | New requests/sec. | 200 |

  This definition is used to evaluate the capabilities of a unit on a regular basis, which later then needs to be translated into a capacity model. This influences the configuration:

  **Configuration**
  
  | Component | min | max |
  | --- | --- | --- |
  | AKS nodes | 3 | 12 |
  | Ingress controller replicas | 3 | 24 |
  | Service replicas | 3 | 24 |
  | Worker replicas | 3 | 12 |
  | Event Hub throughput units | 1 | 10 |
  | Cosmos DB RUs | 4000 | 40000 |

  Each SU is deployed into an Azure region and is therefore primarily handling traffic from that given area (although it can take over traffic from other regions when needed). This geographic spread will likely result in load patterns and business hours that might vary from region to region and as such, every SU is designed to scale-in/-down when idle.

- The Azure subscription scale limits and quotas must support the capacity and cost model set by the business requirements. Also check the limits of individual services in consideration.

- Choose services that support availability zones to build redundancy. This might limit your technology choices.

For other considerations about the size of a unit, and combination of resources, see [Misson critical guidance in Well-architected Framework: ](https://docs.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-application-design#scale-unit-architecture).

### Compute cluster

To containerize the workload, each stamp needs to run a compute cluster. In this architecture, Azure Kubernetes Service (AKS) is chosen because it Kubernetes is the most popular compute platform for modern applications.

The lifetime of the AKS cluster is bound to the ephemeral nature of the stamp. The cluster is stateless and doesn't have persistent volumes. It uses ephemeral OS disks instead of managed disks because they aren't expected to receive application or system-level maintenance.

To increase reliability, the cluster is configured to use all three availability zones in a given region. This makes it possible for the cluster to use AKS Uptime SLA that guarantees 99.95% SLA availability of the AKS API endpoint. 

Scale limits also impact reliability. Even though, the cluster only uses the default node pool to run the simple workload, autoscaling is enabled to let the node pool automatically scale out if needed. For complex workloads, separating system and user node pools is necessary. All node pools should be autoscaled.  

At the pod level, the Horizontal Pod Autoscaler (HPA) scales pods based on configured CPU, memory, or custom metrics. Load test the components of the workload to establish a baseline for the autoscaler values.

The cluster is also configured for automatic node image upgrades and to scale appropriately during those upgrades to allow for zero downtime while upgrades are being performed. Upgrades should occur at different times across the stamps. If one if upgrade fails, another cluster shouldn't be affected. Also, cluster upgrades should be rolled across the nodes so that they aren't unavailable at the same time.

Observability is critical in this architecture because stamps are ephemeral. Diagnostic settings are configured to store all log and metric data in a regional Log Analytics workspace. Also, AKS Container Insights is enabled through an in-cluster OMS Agent. This agent allows the cluster to send monitoring data to the Log Analytics workspace.

<Failure cases- coming soon!>

### Key Vault

Azure Key Vault is used to store global secrets such as connection strings to the database and stamp secrets such as the Event Hubs connection string. 

This architecture uses a Secrets Store CSI driver in the compute cluster to get/set secrets from Key Vault. Secrets are needed when new pods are spwaned. If Key Vault is unavailable, new pods might not get started. As a result there might be disruption; scale out operations can be impacted, updates can fail, new deployments can't be executed. Possible mitigation: HCD cache?

Key Vault has a limit on the number of operations. Due to the automatic update of secrets, the limit can be reached if there are many pods. You can choose to decrease the frequency to avoid this situation. 

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


