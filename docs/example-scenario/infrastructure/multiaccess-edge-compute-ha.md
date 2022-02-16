Azure public MEC is a great platform for hosting low latency applications that can leverage the 5G network, but currently does not support Availability Zones, Availability Sets and other availability options compared to Azure regions. It does not have an automatic method to failover if the resources in the Azure public MEC fail. This solution describes how you can deploy workloads in active/standby to achieve availability and disaster recovery. 

## Architecture 

diagram 

visio link 

### Architecture components 

1. Azure Traffic Manager: The Azure Traffic Manager should be setup to use Priority based routing and the Azure public MEC (Primary) region Load Balancer IP should be set as Priority 1 and the one in the region is set to Priority 2. This will ensure that all traffic in the non-failover case will always be sent to the Azure public MEC. 

   1. Note: Azure Traffic Manager for Azure public MEC currently does not support Performance based routing, which could have dynamically made the decision based on lowest latency to the endpoint.  
   1. In the above architecture, failback is automatically achieved once the VMs and/or SLB (Standard Load Balancer) is back online. The Azure Traffic Manager identifies that the workloads are up and will then reroute traffic back to the primary Azure public MEC region 

1. Load Balancers 

   1. Public Load Balancer: This Load balancer will be fronting the Application tier and will be load balancing traffic to the pool of VMs in the VMSS. 

   1. Internal Load Balancer: This load balancer will be used to access the Database layer. Note that, depending on the type of database you choose for your application, you might not need a Load balancer, assuming other PaaS services support their own Load Balancer. 

1. Virtual Machine Scale Sets: Most production deployments use VMSS to dynamically scale their workloads based on the traffic load. Azure public MEC also support Azure Kubernetes Service for cloud native and container-based applications. 

1. Database Tier 

   1. Currently, Azure public MEC does not support Database SQL PaaS offerings (SQL Server, Managed Instance etc.) or NoSQL PaaS offerings (Cosmos DB, Cassandra etc.). 

   1. You can deploy 3rd party ISVs that support SQL or NoSQL offerings and support replication of data across their geo distributed clusters. 

## Considerations
### Deployment 

Azure public MEC are primarily used for low latency and real time computation scenarios, and data would be processed by the compute instances running in the Azure public MEC. The above architecture highlights Active/Standby with a hot standby, i.e., all the workloads in the secondary region will not to be used unless in the case of failover. 

This approach of deploying workloads as a standby would incur Azure deployment costs even though they aren’t being used. 

### Performance 

Since Azure public MEC is designed to host latency critical applications, failover to a secondary region will increase the latency to their workloads and might not provide the same level of performance. Depending on the application and its sensitivity to this increased latency, customers would need to decide which or any of the services should failover to the region. 

### Databases 

Data Replication and backup is extremely important when it comes to Database failovers. Most of the Azure PaaS offerings have built-in support for Geo Replication and creating Read Replicas across regions and geographies.  

*Currently, there is not support for any PaaS offerings in Azure public MEC, but we are working to support Azure SQL Managed Instance, SQL Server, Azure MySQL, and Azure Postgres. 3rd party ISVs (Couchbase, MongoDB, Cassandra, SQL Server etc.) can provide IaaS (infrastructure as a service) offerings that support geo replication.*

 

### Traffic Manager 

#### Failover options 

Traffic Manager supports multiple routing methods: performance, geographic, priority and more. To best support low latency applications, it would be ideal to dynamically make the decision to send the data to the region/Azure public MEC which is closest to the user. Currently, Performance based routing is not supported on Azure public MEC and the best next option is to statically prioritize the location that would be ideal for an application. 

If we have a globally distributed application, with workloads distributed across multiple Azure public MEC and regions, using a nested routing method with geographic routing to split traffic to the corresponding region and then using Priority based routing to further split traffic. 

#### Failback 

After the workloads in the Azure public MEC are back up, ATM probes will detect that it can take requests and will automatically reroute traffic back to the Azure public MEC. 

## Alternatives 

[Azure  Site Recovery] provides another way to support Active/Standby and the workloads are deployed only in case of failure. This approach costs less to run as there would not be resources sitting idle as is the case for Active/Standby but will only be suitable for applications that allow for higher RTOs. 

## Related resources 

You can learn more about Azure Public MEC [here]. see note in source 

Links to other Azure Public MEC Architectures. 