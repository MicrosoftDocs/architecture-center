---
title: Target and non-functional requirements
description: Meet reliability targets for availability, recovery, and non-functional requirements, which involve application and data platforms, networking, and connectivity.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Target and non-functional requirements

Target and non-functional requirements such as *availability targets* and *recovery targets* allow you to measure the uptime and downtime of your workloads. Having clearly defined targets is crucial in order to have a goal to work and measure against. In addition to these targets, there are many other requirements you should consider to improve reliability requirements and meet business expectations.

Building resiliency (recovering from failures) and availability (running in a healthy state without significant downtime) into your apps begins with gathering requirements. For example, how much downtime is acceptable? How much does potential downtime cost your business? What are your customer's availability requirements? How much do you invest in making your application highly available? What is the risk versus the cost?

## Key points

- Determine the acceptable level of uptime for your workloads.
- Determine how long workloads can be unavailable and how much data is acceptable to lose during a disaster.
- Consider application and data platform requirements to improve resiliency and availability.
- Ensure connection availability and improve reliability with Azure services.
- Assess overall application health of workloads.

## Availability targets

A Service Level Agreement (SLA), is an availability target that represents a commitment around performance and availability of the application. Understanding the SLA of individual components within the system is essential in order to define reliability targets. Knowing the SLA of dependencies will also provide a justification for additional spend when making the dependencies highly available and with proper support contracts. Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets should also be considered.

Understanding your availability expectations is vital to reviewing overall operations for the application. For example, if you are striving to achieve an application Service Level Objective (SLO) of 99.999%, the level of inherent operational action required by the application is going to be far greater than if an SLO of 99.9% was the goal.

Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets. Make sure you measure and monitor key targets such as:

- Mean Time Between Failures (MTBF) &mdash; The average time between failures of a particular component.
- Mean Time To Recover (MTTR) &mdash; The average time it takes to restore a component after a failure.

### Considerations for availability targets

**Are SLAs/SLOs/SLIs for all leveraged dependencies understood?**
***

Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets. Make sure SLAs/SLOs/SLIs for all leveraged dependencies are understood.

**Has a composite SLA been calculated for the application and/or key scenarios using Azure SLAs?**
***

A composite SLA captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets. Make sure the composite SLA of all components and dependencies on the critical paths are understood. To learn more, see [Composite SLAs](./business-metrics.md#understand-service-level-agreements).

> [!NOTE]
> if you have contractual commitments to an SLA for your Azure solution, additional allowances on top of the Azure composite SLA must be made to accommodate outages caused by code-level issues and deployments. This is often overlooked and customers directly put the composite SLA forward to their customers.

**Are availability targets considered while the system is running in disaster recovery mode?**
***

Availability targets might or might not be applied when running in disaster recovery mode. This depends from application to application. If targets must also apply in a failure state then an N+1 model should be used to achieve greater availability and resiliency. In this scenario, N is the capacity needed to deliver required availability. There's also a cost implication, because more resilient infrastructure usually is more expensive. This has to be accepted by business.

**What are the consequences if availability targets are not satisfied?**
***

Are there any penalties, such as financial charges, associated with failing to meet SLA commitments? Additional measures can be used to prevent penalties, but that also brings additional cost to operate the infrastructure. This has to be factored in and evaluated. It should be fully understood what are the consequences if availability targets are not satisfied. This will also inform when to initiate a failover case.

## Recovery targets

Recovery targets identify how long the workload can be unavailable and how much data is acceptable to lose during a disaster. Define target reports for the application and key scenarios. Target reports needed are Recovery Time Objective (RTO) &mdash; the maximum acceptable time an application is unavailable after an incident, and Recovery Point Objective (RPO) &mdash; the maximum duration of data loss that is acceptable during a disaster.

Recovery targets are nonfunctional requirements of a system and should be dictated by business requirements. Recovery targets should be defined in accordance to the required RTO and RPO targets for the workloads.

## Meet application platform requirements

Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU and configuration/deployment. For example, an SLA is dependent on the number of instances deployed or a certain feature enabled. It is recommended that you review the SLA for services used. For example, Service Bus Premium SKU provides predictable latency and throughput to mitigate noisy neighbor scenarios. It also provides the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes.

To learn more, see [Azure Service Bus Premium SKU](/azure/service-bus-messaging/service-bus-premium-messaging).

### Multiple and paired regions

An application platform should be deployed across multiple regions if the requirements dictate. Covering the requirements using zones is cheaper and less complex. Regional isolation should be an extra measure if the SLAs given by the single region cross-zone setup are insufficient or if required by a geographical spread of users.

The ability to respond to disaster scenarios for overall compute platform availability and application resiliency depends on the use of multiple regions or other deployment locations.

Use paired regions that exist within the same geography and provide native replication features for recovery purposes, such as Geo-Redundant Storage (GRS) asynchronous replication. In the event of planned maintenance, updates to a region will be performed sequentially only. To learn more, see [Business continuity with Azure Paired Regions](/azure/best-practices-availability-paired-regions).

### Availability Zones and sets

Platform services that can leverage Availability Zones are deployed in either a zonal manner within a particular zone, or in a zone-redundant configuration across multiple zones. To learn more, see [Building solutions for high availability using Availability Zones](../../high-availability/building-solutions-for-high-availability.md).

An Availability Set (AS) is a logical construct to inform Azure that it should distribute contained virtual machine instances across multiple fault and update domains within an Azure region. Availability Zones (AZ) elevate the fault level for virtual machines to a physical datacenter by allowing replica instances to be deployed across multiple datacenters within an Azure region. While zones provide greater resiliency than sets, there are performance and cost considerations where applications are extremely 'chatty' across zones given the implied physical separation and inter-zone bandwidth charges. Ultimately, Azure Virtual Machines and Azure PaaS services, such as Service Fabric and Azure Kubernetes Service (AKS) which use virtual machines underneath, can leverage either AZs or an AS to provide application resiliency within a region. To learn more, see [Business continuity with data resiliency](https://azurecomcdn.azureedge.net/cvt-27012b3bd03d67c9fa81a9e2f53f7d081c94f3a68c13cdeb7958edf43b7771e8/mediahandler/files/resourcefiles/azure-resiliency-infographic/Azure_resiliency_infographic.pdf).

### Considerations for availability

**Is the application hosted across 2 or more application platform nodes?**
***

To ensure application platform reliability, it is vital that the application be hosted across at least two nodes to ensure there are no single points of failure. Ideally An n+1 model should be applied for compute availability where n is the number of instances required to support application availability and performance requirements.

> [!NOTE]
> Higher SLAs provided for virtual machines and associated related platform services, require at least two replica nodes deployed to either an Availability Set or across two or more Availability Zones. To learn more, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/).

**How is the client traffic routed to the application in the case of region, zone or network outage?**
***

In the event of a major outage, client traffic should be routable to application deployments which remain available across other regions or zones. This is ultimately where cross-premises connectivity and global load balancing should be used, depending on whether the application is internal and/or external facing. Services such as Azure Front Door, Azure Traffic Manager, or third-party CDNs can route traffic across regions based on application health solicited via health probes. To learn more, see [Traffic Manager endpoint monitoring](/azure/traffic-manager/traffic-manager-monitoring).

## Meet data platform requirements

Data and storage services should be running in a highly available configuration/SKU. Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. Examples are Azure SQL Database Business Critical SKUs, or Azure Storage Zone Redundant Storage (ZRS) with three synchronous replicas spread across availability zones.

### Data consistency

Data types should be categorized by data consistency requirements. Data consistency requirements, such as strong or eventual consistency, should be understood for all data types and used to inform data grouping and categorization, as well as what data replication/synchronization strategies can be considered to meet application reliability targets.

CAP theorem proves that it is impossible for a distributed data store to simultaneously provide more than two guarantees across:

- **Consistency:** Every read receives the most recent write or an error.
- **Availability:** Every request receives a non-error response, without the guarantee that it contains the most recent write.
- **Partition tolerance:** A system continues to operate despite an arbitrary number of transactions being dropped or delayed by the network between nodes.

Determining which of these guarantees are most important in the context of application requirements is critical.

### Replication and Redundancy

Replicating data across zones or paired regions supports application availability objectives to limit the impact of failure scenarios. The ability to restore data from a backup is essential when recovering from data corruption situations as well as failure scenarios. To ensure sufficient redundancy and availability for zonal and regional failure scenarios, backups should be stored across zones and/or regions.

Define and test a data restore process to ensure a consistent application state. Regular testing of the data restore process promotes operational excellence and confidence in the ability to recover data in alignment with defined recovery objectives for the application.

Consider how your application traffic is routed to data sources in the case of region, zone, or network outage. Understanding the method used to route application traffic to data sources in the event of a major failure event is critical to identify whether failover processes will meet recovery objectives. Many Azure data platform services offer native reliability capabilities to handle major failures, such as Cosmos DB Automatic Failover or Azure SQL DB Active Geo-Replication.

> [!NOTE]
> Some capabilities such as Azure Storage RA-GRS and Azure SQL DB Active Geo-Replication require application-side failover to alternate endpoints in some failure scenarios, so application logic should be developed to handle these scenarios.

## Networking and connectivity requirements

Consider these guidelines to ensure connection availability and improve reliability with Azure services.

### Connectivity

- **Use a global load balancer used to distribute traffic and/or failover across regions.** Azure Front Door, Azure Traffic Manager, or third-party CDN services can be used to direct inbound requests to external-facing application endpoints deployed across multiple regions. It is important to note that Traffic Manager is a DNS-based load balancer, so failover must wait for DNS propagation to occur. A sufficiently low TTL (Time To Live) value should be used for DNS records, though not all ISPs may honor this. For application scenarios requiring transparent failover, Azure Front Door should be used. To learn more, see [Disaster Recovery using Azure Traffic Manager](/azure/networking/disaster-recovery-dns-traffic-manager) and [Azure Front Door routing architecture](/azure/frontdoor/front-door-routing-architecture).

- **For cross-premises connectivity (ExpressRoute or VPN) ensure there redundant connections from different locations.** At least two redundant connections should be established across two or more Azure regions and peering locations to ensure there are no single points of failure. An active/active load-shared configuration provides path diversity and promotes availability of network connection paths. To learn more, see [Cross-network connectivity](/azure/expressroute/cross-network-connectivity).

- **Simulate a failure path to ensure connectivity is available over alternative paths.** The failure of a connection path onto other connection paths should be tested to validate connectivity and operational effectiveness. Using Site-to-Site VPN connectivity as a backup path for ExpressRoute provides an additional layer of network resiliency for cross-premises connectivity. To learn more, see [Using site-to-site VPN as a backup for ExpressRoute private peering](/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering).

- **Eliminate all single points of failure from the data path (on-premises and Azure.** Single-instance Network Virtual Appliances (NVAs), whether deployed in Azure or within an on-premises datacenter, introduce significant connectivity risk. To learn more, see [Deploy highly available network virtual appliances](../../reference-architectures/dmz/nva-ha.yml).

### Zone-aware services

- **Use ExpressRoute/VPN zone-redundant Virtual Network Gateways.** Zone-redundant virtual network gateways distribute gateway instances across Availability Zones to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region. To learn more, see [Zone-redundant Virtual Network Gateways](/azure/vpn-gateway/about-zone-redundant-vnet-gateways).

- **If used, deploy Azure Application Gateway v2 deployed in a zone-redundant configuration.** Azure Application Gateway v2 can be deployed in a zone-redundant configuration to deploy gateway instances across zones for improved reliability and availability during failure scenarios impacting a datacenter within a region. To learn more, see [Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

- **Use Azure Load Balancer Standard to load-balance traffic across Availability Zones.** Azure Load Balancer Standard is zone-aware to distribute traffic across Availability Zones. It can also be configured in a zone-redundant configuration to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region. To learn more, see [Standard Load Balancer and Availability Zones](/azure/load-balancer/load-balancer-standard-availability-zones).

- **Configure health probes for Azure Load Balancer(s)/Azure Application Gateways.** Health probes allow Azure Load Balancers to assess the health of backend endpoints to prevent traffic from being sent to unhealthy instances. To learn more, see [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview).

- **Assess critical application dependencies with health probes.** Custom health probes should be used to assess overall application health including downstream components and dependent services, such as APIs and datastores, so that traffic is not sent to backend instances that cannot successfully process requests due to dependency failures. To learn more, see [Health Endpoint Monitoring Pattern](../../patterns/health-endpoint-monitoring.md).

## Next step

> [!div class="nextstepaction"]
> [Application design](./app-design.md)

## Related links

- To understand business metrics to design resilient Azure applications, see [Workload availability targets](./business-metrics.md).
- For information on Availability Zones, see [Building solutions for high availability using Availability Zones](../../high-availability/building-solutions-for-high-availability.md).
- For information on health probes, see [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview) and [Health Endpoint Monitoring Pattern](../../patterns/health-endpoint-monitoring.md).
- To learn about connectivity risk, see [Deploy highly available network virtual appliances](../../reference-architectures/dmz/nva-ha.yml).

> Go back to the main article: [Design](design-checklist.md)
