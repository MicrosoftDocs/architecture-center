---
title: Highly scalable and secure WordPress website
description: Proven scenario for building a highly scalable and secure WordPress website for media events
author: david-stanford
ms.date: 09/18/2018
---
# Highly scalable and secure WordPress website

This sample scenario is applicable to companies that need a highly scalable and secure installation of WordPress. This scenario is based on a deployment that was used for a large convention and was successfully able to scale to meet the spike traffic that sessions drove to the site.

## Related use cases

Consider this scenario for the following use cases:

* Media events that cause traffic surges.
* ADD A COUPLE MORE

## Architecture

![Architecture overview of the Azure components involved in a scalable & secure WordPress deployment][architecture]

This scenario covers a scalable & secure installation of WordPress that uses Ubuntu web servers and MariaDB. There are two distinct data flows in this scenario the first is the website is consumed:

1. stuff
2. stuff

The second is how authors add new content:

1. stuff
2. stuff

### Components

* [Azure CDN][cdn-docs] is a distributed network of servers that can efficiently deliver web content to users. CDNs store cached content on edge servers in point-of-presence locations that are close to end users, to minimize latency.
* [Azure Virtual Network][vnet-docs] allows resources such as VMs to securely communicate with each other, the Internet, and on-premises networks. Virtual networks provide isolation and segmentation, filter and route traffic, and allow connection between locations. Two virtual networks combined with the appropriate NSGs are used in this scenario to provide a [demilitarized zone][dmz] (DMZ) and isolation of the application components. Virtual network peering connects the two networks together.
* [Azure network security groups][nsg-docs] contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. The virtual networks in this scenario are secured with network security group rules that restrict the flow of traffic between the application components.
* [Azure load balancer][loadbalancer-docs] distributes inbound traffic according to rules and health probes. A load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications. An internal load balancer is used in this scenario to distribute traffic from the frontend application tier to the backend SQL Server cluster.
* [Azure virtual machine scale set][scaleset-docs] let you create and manager a group of identical, load balanced, VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule. Two separate virtual machine scale sets are used in this scenario - one for the frontend ASP.NET application instances, and one for the backend SQL Server cluster VM instances. PowerShell desired state configuration (DSC) or the Azure custom script extension can be used to provision the VM instances with the required software and configuration settings.
* [Azure Files][azure-files-docs] provides a fully managed file share in the cloud that hosts all of the WordPress content in this scenario, so that all of the VMs have access to the data.
* [Azure Key Vault][azure-key-vault-docs] is used to store and tightly control access to passwords, certificates, and keys.
* [Azure Active Directory][aad-docs] is a multi-tenant, cloud-based directory and identity management service.  In this scenario it is used to authenticate into the website and the VPN tunnels.

### Alternatives

* [SQL Server for Linux][sql-linux] can replace the MariaDB data store.

* [Azure database for MySQL][mysql-docs] can replace the MariaDB data store if you prefer a fully managed solution.

## Considerations

### Availability

The VM instances in this scenario are deployed across multiple regions, with the data replicated between the two via RSYNC for the WordPress content and master slave replication for the MariaDB clusters.

Each region is made up of one or more datacenters equipped with independent power, cooling, and networking. A minimum of three zones are available in all enabled regions. This distribution of VM instances across zones provides high availability to the application tiers. For more information, see [what are Availability Zones in Azure?][azureaz-docs]

For other availability topics, see the [availability checklist][availability] in the Azure Architecure Center.

### Scalability

This scenario uses virtual machine scale sets for the frontend. With scale sets, the number of VM instances that run the frontend application tier can automatically scale in response to customer demand, or based on a defined schedule. For more information, see [Overview of autoscale with virtual machine scale sets][vmssautoscale-docs].

The backend is a MariaDB cluster in an availability set.  For more information see the [MariaDB cluster tutorial][mariadb-tutorial].

For other scalability topics, see the [scalability checklist][scalability] in the Azure Architecure Center.

### Security

All the virtual network traffic into the frontend application tier and protected by network security groups. Rules limit the flow of traffic so that only the frontend application tier VM instances can access the backend database tier. No outbound Internet traffic is allowed from the database tier. To reduce the attack footprint, no direct remote management ports are open. For more information, see [Azure network security groups][nsg-docs].

To view guidance on deploying Payment Card Industry Data Security Standards (PCI DSS 3.2) [compliant infrastructure][pci-dss]. For general guidance on designing secure scenarios, see the [Azure Security Documentation][security].

### Resiliency

In combination with the use of Availability Zones and virtual machine scale sets, this scenario uses Azure Application Gateway and load balancer. These two networking components distribute traffic to the connected VM instances, and include health probes that ensure traffic is only distributed to healthy VMs. Two Application Gateway instances are configured in an active-passive configuration, and a zone-redundant load balancer is used. This configuration makes the networking resources and application resilient to issues that would otherwise disrupt traffic and impact end-user access.

For general guidance on designing resilient scenarios, see [Designing resilient applications for Azure][resiliency].

## Pricing

To explore the cost of running this scenario, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on the number of scale set VM instances that run your applications.

* [Small][small-pricing]: this correlates to two frontend and two backend VM instances.
* [Medium][medium-pricing]: this correlates to 20 frontend and 5 backend VM instances.
* [Large][large-pricing]: this correlates to 100 frontend and 10 backend VM instances.

## Related Resources

to be added

<!-- links -->
[architecture]: ./media/secure-scalable-wordpress.png
[cdn-docs]: /azure/cdn/cdn-overview
[vnet-docs]: /azure/virtual-network/virtual-networks-overview
[loadbalancer-docs]: /azure/load-balancer/load-balancer-overview
[nsg-docs]: /azure/virtual-network/security-overview
[azure-files-docs]: /azure/storage/files/storage-files-introduction
[azure-key-vault-docs]: /azure/key-vault/key-vault-overview
[aad-docs]: /azure/active-directory/fundamentals/active-directory-whatis
[mysql-docs]: /azure/mysql/overview
[sql-linux]: /azure/virtual-machines/linux/sql/sql-server-linux-virtual-machines-overview
[mariadb-tutorial]: /azure/virtual-machines/linux/classic/mariadb-mysql-cluster





[availability]: /architecture/checklist/availability
[azureaz-docs]: /azure/availability-zones/az-overview
[azurecosmosdb-docs]: /azure/cosmos-db/introduction=
[ntiersql-ra]: /azure/architecture/reference-architectures/n-tier/n-tier-sql-server
[resiliency]: /azure/architecture/resiliency/ 
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability 
[vmssautoscale-docs]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[vnetendpoint-docs]: /azure/virtual-network/virtual-network-service-endpoints-overview


[small-pricing]: https://azure.com/e/711bbfcbbc884ef8aa91cdf0f2caff72
[medium-pricing]: https://azure.com/e/b622d82d79b34b8398c4bce35477856f
[large-pricing]: https://azure.com/e/1d99d8b92f90496787abecffa1473a93