---
title: Highly available (HA) and disaster recovery (DR) configured multi-tier web application
description: Build a highly available and disaster recovery configured multi-tier web application on Azure using Azure virtual machines, Availability sets, Availability zones, Azure Site Recovery and Azure Traffic Manager
author: sujayt
ms.date: 11/16/2018
---

# Build a highly available and disaster recovery configured multi-tier web application

This example scenario is applicable to any industry that have a need to deploy resilient multi-tier applications with high availability and disaster recovery configured. In this scenario, the application consists of 3 layers.

- Web tier - This is the top most layer with user interface. This translates inputs and outputs into something user understands.
- Business tier - This layer processed the user interactions and makes logical decisions about the next steps. It acts as a connection between the web tier and the data tier
- Data tier - This is the layer where the data is stored. Typically, a database or a file storage is used.

Example application scenarios include any mission critical application running Windows or Linux operating systems. This can be a standard application such as SAP and SharePoint or a custom Line of Business (LOB) application.

## Relevant use cases

Other relevant use cases include:

* Deploy highly resilient standard applications such as SAP and SharePoint
* Dsign business continuty and disaster recovery plan for Line of Business (LOB) applications
* Configure disaster recovery (DR) and perform DR drills for compliance needs

## Architecture

This scenario covers a multi-tier application that uses ASP.NET and Microsoft SQL Server. In Azure regions supporting Azure availabilit zones, you can deploy your VMs in source region across availability zones and replicate the VMs to diaster recovry (DR) target region. In Azure regions not supporting availability zones, you can deploy your VMs within an availability set and replicate the VMs to disaster recovery (DR) target region.


![Architecture overview of highly resilient multi tier web application][architecture]

- Distribute the VMs in each tier across 2 availability zones in regions supporting zones. In other region, deploy the VMs in each tier within 1 availability set.
- The database tier can be configured to use Always On availability groups. With this SQL Server configuration, one primary database within a cluster is configured with up to eight secondary databases. If an issue occurs with the primary database, the cluster fails over to one of the secondary databases, which allows the application to continue to be available. For more information, see [Overview of Always On availability groups for SQL Server][sqlalwayson-docs].
- For disaster recovery scenarios, you can configure SQL AlwaysON asynchrnous native replication to the DR target region. You can also configure Azure Site Recovery (ASR) replication to the DR target region as long as the data change rate is within supported limits of ASR.
- Users access the front-end ASP.NET web tier by hitting the traffic manager endpoint.
- The traffic manager redirects the traffic to primary public IP endpoint in primary source region.
- The public IP redirects the call to one of the web-tier VM instances through Azure internet load-balancer. All web-tier VMs are in one subnet.
- From the web-tier VM, the call is routed to one of the VM instances in bustiness tier through an Azure internal load balancer for processing. All business-tier VMs are in a separate subnet.
- The operation is processed in business tier and the ASP.NET application connects to Microsoft SQL Server cluster in a back-end tier via an Azure internal load balancer. These back-end SQL Server instances are in a separate subnet.
- The traffic manager's secondary endpoint is configured to be the public IP in the DR target region.
- In the even of a primary region disruption, you invoke Azure Site Recovery (ASR) failover and the application becomes active in the DR target region.
- The traffic manager endpoint automatically redirects the client traffic to the public IP in DR target region.

### Components

1. [**Azure Traffic Manager**][traffic-manager-docs] is a DNS-based traffic load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness.
2. [**Azure load balancer**][loadbalancer-docs] distributes inbound traffic according to rules and health probes. A load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications. An internet load balancer is used in this scenario to distribute incoming client traffic to the web tier. An internal load balancer is used in this scenario to distribute traffic from the business tier to the back-end SQL Server cluster.
3. [**Availability sets**][availability-set-docs]  ensure that the VMs you deploy on Azure are distributed across multiple isolated hardware nodes in a cluster. Doing this ensures that if a hardware or software failure within Azure happens, only a subset of your VMs are impacted and that your overall solution remains available and operational.
4. [**Availability Zones**](availability-zones-docs) is a high-availability offering that protects your applications and data from datacenter failures. Availability Zones are unique physical locations within an Azure region. Each zone is made up of one or more datacenters equipped with independent power, cooling, and networking. 
5. [**Disaster recovery using Azure Site Recovery**][azure-site-recovery-docs] allows you to replicate virtual machines to another Azure region for business continuity and disaster recovery needs. You can conduct periodic DR drills to ensure you meet the compliance needs. The VM will be replicated with the specified settings to the selected region so that you can recover your applications in the event of outages in source region.


### Alternatives

* Windows can easily be replaced by a variety of other operating systems as nothing in the infrastructure depends on the operating system.

* [SQL Server for Linux][sql-linux] can replace the back-end data store.

* The database can be replcaed by any standard database application available.

## Other considerations

### Scalability

You can add or remove VMs in each tier depending on your scaling requirements. As the scenario is using Load balancers, you can add more VMs in the tier without impacting the application uptime.

For other scalability topics, see the [scalability checklist][scalability] in the Azure Architecture Center.

### Security

All the virtual network traffic into the front-end application tier is protected by network security groups. Rules limit the flow of traffic so that only the front-end application tier VM instances can access the back-end database tier. No outbound Internet traffic is allowed from the businees tier or database tier. To reduce the attack footprint, no direct remote management ports are open. For more information, see [Azure network security groups][nsg-docs].

For general guidance on designing secure scenarios, see the [Azure Security Documentation][security].


## Related resources

<!-- links -->
[appgateway-docs]: /azure/application-gateway/overview
[architecture]: ./media/arhitecture-disaster-recovery-multi-tier-app.png
[autoscaling]: /azure/architecture/best-practices/auto-scaling
[availability]: ../../checklist/availability.md
[azureaz-docs]: /azure/availability-zones/az-overview
[cloudwitness-docs]: /windows-server/failover-clustering/deploy-cloud-witness
[loadbalancer-docs]: /azure/load-balancer/load-balancer-overview
[nsg-docs]: /azure/virtual-network/security-overview
[ntiersql-ra]: /azure/architecture/reference-architectures/n-tier/n-tier-sql-server
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[scaleset-docs]: /azure/virtual-machine-scale-sets/overview
[sqlalwayson-docs]: /sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server
[vmssautoscale-docs]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[vnet-docs]: /azure/virtual-network/virtual-networks-overview
[vnetendpoint-docs]: /azure/virtual-network/virtual-network-service-endpoints-overview
[pci-dss]: /azure/security/blueprints/pcidss-iaaswa-overview
[dmz]: /azure/virtual-network/virtual-networks-dmz-nsg
[sql-linux]: /sql/linux/sql-server-linux-overview?view=sql-server-linux-2017

[small-pricing]: https://azure.com/e/711bbfcbbc884ef8aa91cdf0f2caff72
[medium-pricing]: https://azure.com/e/b622d82d79b34b8398c4bce35477856f
[large-pricing]: https://azure.com/e/1d99d8b92f90496787abecffa1473a93
