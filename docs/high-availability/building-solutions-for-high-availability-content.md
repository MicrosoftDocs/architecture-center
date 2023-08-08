Microsoft Azure's global infrastructure is designed and constructed at every layer to deliver the highest levels of redundancy and resiliency. Azure infrastructure is composed of geographies, regions, and availability zones. Each of these components helps you to limit the blast radius of a failure, and therefore limit potential impact to your applications and data. Azure availability zones provide help to protect against datacenter failures and to provide increased high availability (HA).

Availability zones are unique physical locations within an Azure region. Each zone is made up of one or more datacenters with independent power, cooling, and networking. The physical separation of availability zones within a region limits the impact to applications and data from zone failures, such as power and cooling failures, large-scale flooding, major storms and superstorms, and other events that could disrupt site access, safe passage, extended utilities uptime, and the availability of resources. Availability zones and their associated datacenters are designed such that if one zone is compromised, the services, capacity, and availability are supported by the other availability zones in the region.

![Diagram showing Azure availability zones 1-3.](./images/high-availability-001.png)

Availability zones can be used to spread a solution across multiple zones within a region, allowing for an application to continue functioning when one zone fails. When you use availability zones, Azure offers an industry-best 99.99% [Virtual Machine (VM) uptime service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/). Zone-redundant services replicate your services and data across availability zones to protect from single points of failure. If you are designing highly available solutions on Azure that are mission-critical in nature, you can extend the reliability provided by availability zones by [globally distributing your solution across multiple Azure regions](/azure/architecture/framework/mission-critical/mission-critical-application-design#global-distribution).

For additional information about availability zones, see [What are availability zones in Azure?](/azure/availability-zones/az-overview) For information about which regions support availability zones, see [
Azure regions with availability zone support](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).

## Availability zones reference architectures

The following architectures feature high-availability scenarios:

- [Mission-critical workload built for maximum reliability](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)
- [High availability enterprise deployment using App Services Environment](../web-apps/app-service-environment/architectures/ase-high-availability-deployment.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)
- [Multi-region load balancing with Traffic Manager and Application Gateway](./reference-architecture-traffic-manager-application-gateway.yml)
- [Multi-region web app with private connectivity to database](../example-scenario/sql-failover/app-service-private-sql-multi-region.yml)
- [Multi-tier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)
- [Baseline highly available zone-redundant web application](../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Azure Spring Apps baseline architecture](../web-apps/spring-apps/architectures/spring-apps-multi-zone.yml)

## Delivering reliability in Azure

The key to improving the reliability of a solution is to design it to continue to function in spite of failure. In cloud-based solutions, building to survive failure is a shared responsibility. These responsibilities can be viewed at three levels: a resilient foundation, resilient services, and resilient applications. The foundation is Microsoft's investment in the platform, including availability zones. On top of this foundation are the Azure services that you use and configure to support high availability. For example, when you use Azure Storage, you can use zone-redundant storage (ZRS), which automatically replicates data across zones. You then build your applications on top of the foundation and your chosen services. You need to design your applications to support resiliency.

<div align="center"> 
<hr />

   ### Your applications

   Your **app** or **workload** architecture

   ### Resilient services

   Azure capabilities you **enable as needed**

   ### Resilient foundation

   Azure capabilities **built into the platform**

<hr />
</div>

When designing a resilent architecture, consider all three layers - foundation, services, and applications - so that you can achieve highest level of reliability. Because a solution can be made up of many components, each component should be designed for reliability.

## Zonal and zone-redundant architectures

Azure services supporting availability zones fall into two categories: *zonal* and *zone-redundant*. You can select an approach to meet your performance and durability requirements. Some Azure services support one approach, and other services support both approaches. For a list of Azure services that support availability zones, and the type of support they offer, see the [availability zones documentation](/azure/availability-zones/az-region).

By designing your solution to use multiple availability zones, you can protect your applications and data from a zone becoming unavailable. For example, if one zone is compromised by a power failure, replicated apps and data are instantly available in another zone.

> [!TIP]
> TODO

### Zonal architecture

When you deploy a *zonal* component, it's deployed to a specific availability zone that you select. In general, zonal configuration is supported by infrastructure as a service (IaaS) resources, like a virtual machine or managed disk. You can pin resources like virtual machines, managed disks, and standard IP addresses to a specific availability zone, like in the following illustration:

![Diagram showing zonal architecture.](./images/high-availability-002.png)

In the illustration above, each VM and load balancer (LB) are deployed to a specific availability zone.

This approach helps you to achieve strict latency or performance requirements, because traffic within the zone doesn't have to travel far.

By itself, a zonal approach doesn't give you resiliency. In the case of an availability zone failure, the zonal services in the failed zone become unavailable until the zone has recovered. You need to replicate your applications and data to one or more zones within the region so that you're resilient to a zone outage.

When you configure a zonal solution, you can typically decide how you want to replicate your data:

- **Synchronous replication** ensures that your data is always up-to-date across each availability zone, which minimizes the risk of any data loss during an outage. However, for some workloads, synchronous replication might increase the latency of your application because changes to your data have to be confirmed in multiple places before the write operation can be completed.
- **Asynchronous replication** updates secondary copies of your data after the write has already completed, so this approach doesn't introduce latency into your transactions. However, if an outage happens of one availability zone, you might lose any data that hasn't been replicated yet.

> [!TIP]
> For most scenarios, it's a good idea to use synchronous replication across availability zones. Most applications aren't sensitive enough to be affected by the small amount of latency required for synchronous replication.

### Zone-redundant architecture

With a *zone-redundant* architecture, Azure automatically replicates a resource and its configuration and data across multiple availability zones. Microsoft manages the delivery of high availability, including distributing traffic between the availability zones, synchronously replicating data, and failing over if an availability zone has an outage.

For example, when you configure an Azure Storage account to use zone-redundant storage (ZRS), Azure replicates the data in your storage account across multiple zones. ZRS means that a zone failure doesn't impact the availability of the data.

In general, zone-redundant configuration is supported by platform as a service (PaaS) services, including Azure Storage, Azure Service Bus, Azure Application Gateway, virtual private network (VPN) gateways, Azure ExpressRoute gateways, Azure Event Hubs, Azure Cosmos DB. Standard load balancers also support zone redundancy, as illustrated in the following figure:

![Diagram showing a zone-redundant load balancer.](./images/high-availability-003.png)

Some resources, like load balancers, support both zonal and zone-redundant deployments. You can select an approach that makes sense for the rest of your solution.  For information on how availability zones apply to load balancers in both zonal and zone-redundant configurations, see [Standard Load Balancer and availability zones](/azure/load-balancer/load-balancer-standard-availability-zones).

## SLA offered by availability zones

With availability zones, Azure offers an industry-best 99.99% VM uptime SLA. For more information, see the [Azure SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/).

The following diagram illustrates the different levels of HA offered by a single VM, availability sets, and availability zones:

![Diagram showing levels of HA that are offered by a single VM, availability sets, and availability zones.](./images/high-availability-004.png)

For example, consider a VM-based workload. You have multiple ways that you can configure the VM:
- If you deploy it as a single VM, it has an SLA of 99.9%. This means the VM will be available 99.9% of the time.
- If you deploy it into an availability set, Azure provides a higher SLA. Azure guarantees that a VM within the availability set will be available 99.95% of the time, and it ensures they're no all on the same hardware to meet this guarantee.
- Within a region, VM workloads can be distributed across multiple availability zones to increase the SLA to 99.99%. When you use availability zones, Azure guarantees that at least one VM instance will be available 99.99% of the time.

For more information, see [Availability options for VMs in Azure](/azure/virtual-machines/availability).

Other services provide different guarantees based on their own use of availability zones. For example, Azure Cosmos DB provides a higher SLA when you configure it to use zone redundancy compared to when you don't use zone redundancy.

Every organization has unique requirements, and you should design your applications to best meet your own business needs. Defining a target SLA makes it possible to evaluate whether the architecture meets your business requirements. Some things to consider include:

- What are the availability requirements?

- How much downtime is acceptable?

- How much will potential downtime cost your business?

- How much should you invest in making the application highly available?

- In the event of a disaster, how much data loss is acceptable?

- What are the data backup requirements?

- What are the data replication requirements?

- What are the monitoring requirements?

- Does your application have specific latency requirements?

For additional guidance, see [Principles of the reliability pillar](/azure/architecture/framework/resiliency/principles).

Depending on the availability needs of an application, the cost and design complexity varies. When you build a VM workload, there's a cost associated with each VM. For example, two VMs per zone across three active zones means you need to pay for a total of six VMs. For pricing of VM workloads, see the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=virtual-machines).

## Next steps

- [Azure Services that support availability zones](/azure/availability-zones/az-region)
- [Regions and availability zones in Azure](/azure/availability-zones/az-overview)
- [Create a virtual machine in an availability zone using Azure CLI](/azure/virtual-machines/linux/create-cli-availability-zone)
- [Create a virtual machine in an availability zone using Azure PowerShell](/azure/virtual-machines/windows/create-powershell-availability-zone)
- [Create a virtual machine in an availability zone using the Azure portal](/azure/virtual-machines/windows/create-portal-availability-zone)
- [About Azure Edge Zone](/azure/networking/edge-zones-overview)
