This example scenario applies to any industry that needs to deploy reliable multitier applications built for high availability and disaster recovery (DR). In this scenario, the application consists of three layers.

- **The web tier** is the top layer that includes the UI. This layer parses user interactions and passes actions to the next layer for processing.

- **The business tier** processes the user interactions and makes logical decisions about the next steps. This layer connects the web tier and the data tier.

- **The data tier** stores the application data by using a database, object storage, or file storage.

Common application scenarios include any mission-critical application that runs on Windows or Linux, for example a prebuilt application such as SAP or a custom line-of-business (LOB) application.

## Architecture

:::image type="complex" source="./media/architecture-disaster-recovery-multi-tier-app.svg" border="false" lightbox="./media/architecture-disaster-recovery-multi-tier-app.svg" alt-text="Diagram that shows the architecture overview of a highly resilient multitier web application.":::
Architecture diagram that shows a DR setup for a multitier application across two Azure regions. In the primary region, user traffic enters through Azure Traffic Manager and routes to a public IP address. The traffic flows through a public load balancer to the web tier virtual machines (VMs) in a subnet. An internal load balancer distributes requests from the web tier to the business tier VMs in a separate subnet. Another internal load balancer routes traffic from the business tier to the SQL Server cluster in the data tier subnet. The VMs in each tier are distributed across either two availability zones or within an availability set, depending on region support. For DR, the architecture shows asynchronous replication from the primary region to a secondary target region by using either SQL Always On native replication or Azure Site Recovery. The secondary region mirrors the primary architecture with its own public IP address, load balancers, and three-tier VM deployment. Traffic Manager monitors both regions and automatically redirects traffic to the secondary region during a primary region outage.
:::image-end:::

*Download a [Visio file][visio-download] of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Users access the front-end ASP.NET web tier via the Azure Traffic Manager endpoint. Traffic Manager redirects traffic to the primary public IP address in the primary source region. The public IP address redirects the call to one of the web tier virtual machine (VM) instances through a public load balancer.

1. All web tier VM instances reside in one subnet. An internal load balancer routes each call from the web tier to a business tier VM instance for processing.

   All business tier VMs reside in a separate subnet. The business tier processes the operation, and the ASP.NET application connects to a SQL Server cluster in the back-end tier through an internal load balancer. These back-end SQL Server instances reside in a separate subnet.

1. Distribute the VMs in each tier across two availability zones in regions that support zones.

1. In other regions, deploy the VMs in each tier within one availability set.

1. You can set up the database tier to use Always On availability groups. This SQL Server configuration uses one primary read/write replica within an availability group and up to eight secondary read-only replicas. If the primary replica fails, the availability group promotes a secondary replica to primary. The secondary replica performs the read/write activity and keeps the application available. For more information, see [Overview of Always On availability groups for SQL Server][docs-sql-always-on].

1. For DR scenarios, you can set up SQL Always On asynchronous native replication to the target region that you use for DR. You can also set up Azure Site Recovery replication to the target region if the data change rate is within supported limits of Site Recovery.

   The Traffic Manager secondary endpoint is set to the public IP address in the target region that you use for DR. When a disruption occurs in the primary region, you invoke Site Recovery failover and the application becomes active in the target region. The Traffic Manager endpoint automatically redirects the client traffic to the public IP address in the target region.

### Components

- [Availability sets][docs-availability-sets] are a fault-tolerance feature that you can use to distribute VMs across multiple isolated hardware nodes in a cluster. In this architecture, availability sets protect against hardware and software failures by ensuring that outages affect only a subset of VMs. This approach maintains application availability and operational continuity across the multitier application.

- [Availability zones][docs-availability-zones] are separate physical locations within an Azure region that protect applications and data from datacenter failures. In this architecture, availability zones provide higher resilience by distributing VMs across multiple datacenters that have independent power, cooling, and networking infrastructure.

- [Azure Load Balancer][docs-load-balancer] is a layer-4 load balancer that distributes inbound traffic according to defined rules and health probes for high throughput and low latency. In this architecture, a public load balancer distributes incoming client traffic across web tier VMs. Internal load balancers route traffic from the web tier to the business tier and from the business tier to the back-end SQL Server cluster.

- [Traffic Manager][docs-traffic-manager] is a Domain Name System (DNS)-based traffic load balancer that distributes traffic across global Azure regions. In this architecture, Traffic Manager provides global load balancing. It routes user traffic to the primary region during normal operations and automatically redirects traffic to the DR region during outages.

- [Site Recovery][docs-azure-site-recovery] is a DR service that replicates VMs to another Azure region for business continuity and disaster recovery (BC/DR). In this architecture, Site Recovery replicates VMs to a target region. This replication recovers applications during source region outages and supports compliance requirements through periodic DR drills.

### Alternatives

- You can use other operating systems instead of Windows. The infrastructure doesn't depend on a specific operating system.

- You can replace the back-end data store with [SQL Server for Linux][docs-sql-server-linux].

- You can replace the data store with any standard database application.

## Scenario details

This scenario demonstrates a multitier application that uses ASP.NET and SQL Server. In [Azure regions that support availability zones](/azure/reliability/regions-list), you can deploy your VMs in a source region across availability zones and replicate the VMs to the target region that you use for DR. In Azure regions that don't support availability zones, you can deploy your VMs within an [availability set](/azure/virtual-machines/availability-set-overview) and replicate the VMs to the target region.

To route traffic between regions, you need a global load balancer. Azure offerings include:

- Azure Front Door
- Traffic Manager

When you choose a load balancer, consider your requirements and the feature set of the two offerings. Consider failover speed, Transport Layer Security (TLS) management overhead, and organizational cost constraints.

Azure Front Door has layer-7 capabilities, including Secure Sockets Layer (SSL) offload, path-based routing, fast failover, and caching. These capabilities improve your application's performance and high availability. Azure Front Door costs more than Traffic Manager. Use the full feature set in Azure Front Door, beyond only failover, to justify the higher cost. Azure Front Door routes traffic through Azure network infrastructure earlier in the path, which reduces packet travel time.

Azure Front Door adds a network hop, which requires extra security operations. Regulatory requirements might restrict the extra traffic TLS termination point. Verify that the Azure Front Door TLS cipher suites meet your organization's security requirements. Also verify that your back-end services use certificates from the [Microsoft Trusted Certificate Authority (CA) list](/azure/frontdoor/end-to-end-tls#supported-certificates).

Traffic Manager is a DNS-based load-balancing service that balances and fails over only at the DNS level. Traffic Manager fails over more slowly than Azure Front Door because DNS caching and systems that don't honor DNS time-to-live (TTL) values delay propagation.

You can combine both load balancers. For example, use Traffic Manager for DNS-based failover and add Azure Front Door point-of-presence (POP) locations for faster edge routing.

This architecture uses Traffic Manager for its simplicity and lower cost. The failover speed meets the requirements for this example.

### Potential use cases

You can use this architecture to:

- Deploy highly resilient applications such as SAP and other mission-critical LOB applications.
- Design a BC/DR plan for LOB applications.
- Set up DR and perform related drills for compliance purposes.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Network security groups (NSGs) protect all virtual network traffic to the front-end application tier. Rules limit traffic flow so that only the front-end application tier VM instances can access the back-end database tier. The business tier and database tier block all outbound internet traffic. To reduce the attack footprint, no direct remote management ports are open. For more information, see [Azure NSGs][docs-nsg].

For more information about how to design secure scenarios, see [Azure security documentation][security].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Using Site Recovery for DR in Azure VMs incurs the following ongoing charges:

- Site Recovery licensing per VM.

- Network egress to replicate data changes from source VM disks to another Azure region. Site Recovery uses built-in compression to reduce data transfer by approximately 50%.

- Storage on the recovery site. Recovery site storage typically matches source region storage plus extra storage for recovery point snapshots.

Use this [sample cost calculator][calculator] to estimate DR costs for a three-tier application that uses six VMs. The calculator includes preconfigured services. Change the variables to see pricing for your use case.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

You can add or remove VMs in each tier based on your scaling requirements. This scenario uses load balancers, so you can add more VMs to a tier without affecting application uptime.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Sujay Talasila](https://in.linkedin.com/in/sujay-talasila-7b20247) | Principal Product Lead

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy Traffic Manager in Azure][Deploy-Traffic-Manager-in-Azure]
- [Set up DR for Azure VMs][Set-up-disaster-recovery-for-Azure-VMs]

## Related resource

- [Multiregion load balancing architecture][Multiregion-load-balancing]

<!-- links -->

[security]: /azure/security
[docs-availability-zones]: /azure/well-architected/service-guides/azure-load-balancer/reliability
[docs-load-balancer]: /azure/well-architected/service-guides/azure-load-balancer
[docs-nsg]: /azure/virtual-network/security-overview
[docs-sql-always-on]: /sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server
[docs-sql-server-linux]: /sql/linux/sql-server-linux-overview?view=sql-server-linux-2017
[docs-traffic-manager]: /azure/well-architected/service-guides/azure-traffic-manager
[docs-azure-site-recovery]: /azure/site-recovery/site-recovery-overview
[docs-availability-sets]: /azure/virtual-machines/availability-set-overview
[calculator]: https://azure.com/e/6835332265044d6d931d68c917979e6d
[Multiregion-load-balancing]: /azure/architecture/high-availability/traffic-manager-application-gateway
[Set-up-disaster-recovery-for-Azure-VMs]: /azure/site-recovery/azure-to-azure-tutorial-enable-replication
[Deploy-Traffic-Manager-in-Azure]: /azure/traffic-manager/quickstart-create-traffic-manager-profile
[visio-download]: https://arch-center.azureedge.net/architecture-disaster-recovery-multi-tier-app.vsdx
