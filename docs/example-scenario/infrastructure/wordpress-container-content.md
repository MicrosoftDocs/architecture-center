<!-- cSpell:ignore wordpress -->

Use [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Kubernetes Service](/azure/aks/intro-kubernetes), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) and other Azure services to deploy a highly scalable and secure installation of WordPress.

## Architecture

[![Architecture overview of the WordPress deployment in AKS](media/wordpress-aks-netapp.png)](media/wordpress-aks-netapp.png#lightbox)


> [!NOTE]
> This architecture can be extended and combined with other tips and recommendations that are not specific to any particular WordPress hosting method. [Learn more about tips for WordPress](/azure/architecture/example-scenario/infrastructure/wordpress)


### Dataflow

1. Users access the front-end website through a CDN (Azure Front Door).
2. The CDN uses an [internal Azure load balancer](/azure/load-balancer/load-balancer-overview) (component of AKS) as the origin, and pulls any data that isn't cached from there via private connection via Private Endpoint.
3. The Azure load balancer distributes ingress traffic to pods within AKS.
4. The WordPress application pulls any dynamic information out of the managed [Azure Database for MySQL - Flexible Server](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview), access privately via Private Endpoint. All static content is hosted in [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) via AKS CSI Astra Triden driver.
5. SSL keys or other secrets are stored in [Azure Key Vault](/azure/key-vault/key-vault-overview).

### Components

- [Azure Front Door](https://azure.microsoft.com/products/frontdoor) is a Microsoft’s modern cloud Content Delivery Network (CDN), distributed network of servers that efficiently delivers web content to users. CDNs minimize latency by storing cached content on edge servers in point-of-presence locations near to end users.
- [Virtual networks](https://azure.microsoft.com/products/virtual-network) allow deployed resources to securely communicate with each other, the Internet, and on-premises networks. Virtual networks provide isolation and segmentation, filter and route traffic, and allow connection between locations. The two networks are connected via Vnet peering.
- [Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.
- [Network security groups](/azure/virtual-network/security-overview) contain a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. The virtual networks in this scenario are secured with network security group rules that restrict the flow of traffic between the application components.
- [Load balancers](https://azure.microsoft.com/solutions/load-balancing-with-azure) distribute inbound traffic according to rules and health probes. A load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications. A load balancer is used in this scenario to distribute traffic from the content deliver network to the front-end web servers.
- [Azure Kubernetes Service](https://azure.microsoft.com/products/kubernetes-service) is a fully managed service that makes it easy to deploy, manage, and scale containerized applications using Kubernetes. 
- [Azure NetApp Files](https://azure.microsoft.com/products/storage/netapp) provides a fully managed performance-intensive and latency-sensitive storage solution, that hosts all of the WordPress content in this scenario, so that all of the nodes have access to the data.
- [Azure Key Vault](https://azure.microsoft.com/products/active-directory) is used to store and tightly control access to passwords, certificates, and keys.

## Scenario details

This example scenario is applicable to companies that need a highly scalable and secure installation of WordPress. This scenario is based on a deployment that was used for a large convention and was successfully able to scale to meet the spike traffic that sessions drove to the site.

### Potential use cases

Other relevant use cases include:

- Media events that cause traffic surges.
- Blogs that use WordPress as their content management system.
- Business or e-commerce websites that use WordPress.
- Web sites built using other content management systems.

### Alternatives

- [SQL Server for Linux](/azure/azure-sql/virtual-machines/linux/sql-server-on-linux-vm-what-is-iaas-overview) can replace the MariaDB data store.
- [Azure database for MySQL](/azure/mysql/overview) can replace the MariaDB data store if you prefer a fully managed solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

The VM instances in this scenario are deployed across multiple regions, with the data replicated between the two via RSYNC for the WordPress content and primary/secondary replication for the MariaDB clusters.

### Scalability

This scenario uses Virtual Machine Scale Sets for the two front-end web server clusters in each region. With scale sets, the number of VM instances that run the front-end application tier can automatically scale in response to customer demand, or based on a defined schedule. For more information, see [Overview of autoscale with Virtual Machine Scale Sets][docs-vmss-autoscale].

The back end is a MariaDB cluster in an availability set. For more information, see the [MariaDB cluster tutorial][mariadb-tutorial].

For more resiliency and scalability guidance, see the [resiliency checklist](/azure/architecture/checklist/resiliency-per-service)] in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

All the virtual network traffic into the front-end application tier and protected by network security groups. Rules limit the flow of traffic so that only the front-end application tier VM instances can access the back-end database tier. No outbound Internet traffic is allowed from the database tier. To reduce the attack footprint, no direct remote management ports are open. For more information, see [Azure network security groups][docs-nsg].

For general guidance on designing secure scenarios, see the [Azure Security Documentation][security].

### Resiliency

In combination with the use of multiple regions, data replication and Virtual Machine Scale Sets, this scenario uses Azure load balancers. These networking components distribute traffic to the connected VM instances, and include health probes that ensure traffic is only distributed to healthy VMs. All of these networking components are fronted via a CDN. This makes the networking resources and application resilient to issues that would otherwise disrupt traffic and affect end-user access.

For general guidance on designing resilient scenarios, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We've provided a pre-configured [cost profile][pricing] based on the architecture diagram provided here. To configure the pricing calculator for your use case, there are a couple main things to consider:

- How much traffic are you expecting in terms of GB/month? The amount of traffic will have the biggest effect on your cost, as it will determine the number of VMs that are required to surface the data in the Virtual Machine Scale Set. Additionally, it will directly correlate with the amount of data that is surfaced via the CDN.
- How much new data are you going to be writing to your website? New data written to your website correlates with how much data is mirrored across the regions.
- How much of your content is dynamic? How much is static? The variance around dynamic and static content influences how much data has to be retrieved from the database tier versus how much will be cached in the CDN.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [David Stanford](https://www.linkedin.com/in/das0) | Principal Program Manager

## Next steps

Product documentation:

- [About Azure Key Vault](/azure/key-vault/general/overview)
- [What are Virtual Machine Scale Sets?](/azure/virtual-machine-scale-sets/overview)
- [What is a content delivery network on Azure?](/azure/cdn/cdn-overview)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

Microsoft Learn modules:

- [Build a scalable application with Virtual Machine Scale Sets](/training/modules/build-app-with-scale-sets)
- [Configure Azure Active Directory](/training/modules/configure-azure-active-directory)
- [Configure Azure Load Balancer](/training/modules/configure-azure-load-balancer)
- [Configure Azure files and Azure File Sync](/training/modules/configure-azure-files-file-sync)
- [Create a Content Delivery Network for your Website with Azure CDN and Blob Services](/training/modules/create-cdn-static-resources-blob-storage)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Networks](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)

<!-- links -->

[mariadb-tutorial]: /azure/virtual-machines/linux/classic/mariadb-mysql-cluster
[docs-vmss]: /azure/virtual-machine-scale-sets/overview
[docs-vmss-autoscale]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[docs-nsg]: /azure/virtual-network/security-overview
[security]: /azure/security
[pricing]: https://azure.com/e/a8c4809dab444c1ca4870c489fbb196b
