This example scenario discusses a [highly available][High availability] solution for a web app with private connectivity to an SQL database. A single-region architecture already exists for a web app with private database connectivity. This solution extends that base architecture by making it highly available.

See [Web app private connectivity to Azure SQL Database][Web app private connectivity to Azure SQL database] for information on the base architecture.

## Architecture

:::image type="complex" source="./media/app-service-private-sql-multi-region-solution-architecture.svg" alt-text="Architecture diagram showing how traffic flows from a web app to a database on a private connection. Routes for multiple failover scenarios are visible." border="false" lightbox="./media/app-service-private-sql-multi-region-solution-architecture.svg":::
   The diagram contains two vertically aligned boxes, one for a primary region and one for a secondary region. Each box contains a web app icon, a box for a virtual network, and a database icon. Outside the boxes on the left, a cloud represents the internet. Arrows point from that cloud through a Front Door and then into the web app in each box. The arrow leading into the secondary region box is dashed. Inside each box, arrows connect the web app, the virtual network, and the database. More arrows cross from the virtual network in each region into the database in the other region. All arrows that end in the secondary database are dashed. Outside each box on the right, a cloud represents the internet. A red arrow that is marked with a letter x points from each cloud to the database in its region. An arrow with points on both ends that is labeled Database Geo-replication connects the two databases. An arrow with points on both ends that is labeled Virtual Network Peering connects the two networks. An icon for a private DNS zone is located at the top of the diagram.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/US-1808238-app-service-private-sql-multi-region-solution-architecture.vsdx) of this architecture.*

### General case

In the general case, the traffic flow and basic configuration look like the [single-region version][Web app private connectivity to Azure SQL database].

#### Dataflow

1. Azure Web Application Firewall rules are evaluated.
1. Azure Front Door routes requests from the internet to a web app.
1. By using Azure App Service regional VNet Integration, the web app connects to a delegated subnet named **AppSvcSubnet** in Azure Virtual Network.
1. Azure Private Link sets up a [private endpoint for the Azure SQL Database][How to set up Private Link for Azure SQL Database] in a virtual network subnet named **PrivateLinkSubnet**. The web app connects to this private endpoint.
1. The database firewall only lets in traffic coming from the **PrivateLinkSubnet** private endpoint.
1. The database is inaccessible from the public internet. Only components inside or connected to the virtual network can reach the database.

#### Configuration

For the web app to work with [Azure DNS private zones][Azure DNS private zones], this architecture uses App Service VNet Integration. When the web app and database run in the same region, the configuration is straightforward. For cross-region private connectivity, the web app can reach the database in the other region by setting up [global peering][Virtual network peering] between the virtual networks. When the primary database fails over to the secondary region, the web app in the primary region can still reach the private endpoint of the secondary database in the peered network.

### Specific cases

The following cases result when specific databases and web apps are active.

In all scenarios, the web app connects to the currently active database over a fully private connection without requiring a configuration change. In both regions, the web app uses a connection string that includes a `Server` host name. That host name refers to the DNS name of the SQL failover group. An example is:

`Server=tcp:sql-failovergroup.database.windows.net,1433;Initial Catalog=...`

Since both regions use the same connection string, you don't need to change that string when a database fails over.

#### Primary database is active

Since this architecture uses a SQL failover group, when the primary database is active:

- The DNS name `sql-failovergroup.database.windows.net` resolves to the host name of the currently active database, `sql-primary.database.windows.net`.
- The database has private endpoints turned on, so the DNS name `sql-primary.database.windows.net` resolves to `sql-primary.privatelink.database.windows.net`.
- The `privatelink.database.windows.net` private DNS zone is linked to the virtual networks, so that DNS lookups resolve to the private IP address of the primary database, which is `10.1.1.4`.

Summary of DNS resolution:

`sql-failovergroup.database.windows.net` => `sql-primary.database.windows.net` => `sql-primary.privatelink.database.windows.net` => `10.1.1.4`

##### Primary web app is active

In this case:

- Internet requests arrive at the primary web app (**1**).
- The web app connects to the primary **AppSvcSubnet** subnet (**2**).
- The web app connects to the private endpoint of the primary database (**3**).
- The app and database run in the same region (**4**).

##### Secondary web app is active

The secondary web app is active in either of these cases:

- The primary web app fails over the secondary region.
- Front Door routes traffic to both regions simultaneously in an active-active configuration.

When the secondary web app is active:

- Internet requests arrive at the secondary web app (**1\***).
- The web app connects to the secondary **AppSvcSubnet** subnet (**2\***).
- The web app connects to the private endpoint of the primary database (**3\***). The global peering of the virtual networks makes that endpoint available from the secondary region. The cross-region traffic results in increased latency.
- The app connects to the database in a different region (**4**).

#### Secondary database is active

When the primary database fails over:

- The SQL failover group's DNS record changes. The DNS name `sql-failovergroup.database.windows.net` resolves to the newly active database in the secondary region, `sql-secondary.database.windows.net.`
- Since the secondary database has private endpoints turned on, the DNS name `sql-secondary.database.windows.net` resolves to `sql-secondary.privatelink.database.windows.net`.
- The `privatelink.database.windows.net` private DNS zone is linked to the virtual networks, so that DNS lookups resolve to the private IP address of the secondary database, which is `10.2.1.4`.

Summary of DNS resolution:

`sql-failovergroup.database.windows.net` => `sql-secondary.database.windows.net` => `sql-secondary.privatelink.database.windows.net` => `10.2.1.4`

##### Primary web app is active

In this case:

- Internet requests arrive at the primary web app (**1**).
- The web app connects to the primary **AppSvcSubnet** subnet (**2**).
- The web app connects to the private endpoint of the secondary database (**3\*\***). The global peering of the virtual networks makes that endpoint available from the primary region. The cross-region traffic results in increased latency.
- The app connects to the database in a different region (**4\***).

##### Secondary web app is active

In this case:

- Internet requests arrive at the secondary web app (**1\***).
- The web app connects to the secondary **AppSvcSubnet** subnet (**2\***).
- The web app connects to the private endpoint of the secondary database (**3\*\*\***).
- The app and database run in the same region (**4\***).

### Components

- [App Service][Azure App Service] and its [Web Apps][Azure Web Apps] feature provide a framework for building, deploying, and scaling web apps. The App Service platform offers built-in infrastructure maintenance, security patching, and scaling.

- [App Service VNet Integration][Integrate your app with an Azure virtual network] connects apps to Azure resources. If you use Virtual Network to set up a non-internet-routable network, the VNet Integration feature gives apps access to resources in that network. The [regional variation of VNet Integration][Regional VNet Integration] works with virtual networks in the same region as the app.

- An [Azure DNS private zone][What is a private Azure DNS zone] contains records that you can't resolve from the internet. DNS resolution only works from virtual networks that are linked to the private zone.

- [Azure Private Endpoint][What is Azure Private Endpoint?] is a network interface that connects privately and securely to a service that Private Link powers.

- [Private Link][What is Azure Private Link?] provides a private endpoint in a virtual network. You can use the private endpoint to connect to Azure PaaS services like Azure Storage and SQL Database or to customer or partner services.

- [SQL Database][What is Azure SQL Database?] is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.

- [Azure Front Door][What is Azure Front Door?] is a global, scalable entry-point that uses the Microsoft global edge network to create fast, secure, and widely scalable web applications. With Front Door, you can transform your global consumer and enterprise applications into robust, high-performing personalized modern applications with contents that reach a global audience through Azure.

- [Web Application Firewall (WAF) on Azure Front Door](/azure/frontdoor/web-application-firewall) defends against common exploits and vulnerabilities such as SQL injection. Azure Front Door Premium tier integrates with Web Application Firewall premium tier which supports [Managed Rules](/azure/web-application-firewall/afds/waf-front-door-drs).

- [Virtual Network][What is Azure Virtual Network?] is the fundamental building block for private networks in Azure. Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks through Virtual Network.

### Alternatives

- In general, the [alternatives that are appropriate for the single-region version][Alternatives to the single-region version] also apply to this solution.

- Instead of using a partial region failover, you can use a complete region failover. As [Highly available multi-region web application][Highly available multi-region web application] explains, when a single component fails with this approach, the architecture fails over the entire region. For example, an issue in the primary region web app can trigger a database failover. Azure Front Door or [Traffic Manager][What is Traffic Manager?] then shifts all traffic to the app in the secondary region.

  A complete region failover requires no cross-region connectivity. Instead, you treat your entire solution as an isolated [deployment stamp][Deployment stamps] that moves from one region to another as one unit. But this approach has disadvantages. Triggering a [database failover can cause data loss][Fail over to a geo-replicated secondary database] because of the asynchronous nature of database replication. This loss can occur even when the database has no issues.

- As with the single-region version, this approach isn't limited to SQL Database. You can also use this scenario with [any service that supports a Private Endpoint][Private link resource] for inbound connectivity. Examples include:

  - Azure Storage
  - Azure Cosmos DB
  - Azure Cognitive Search
  - Azure Event Grid
  - Function Apps
  - Other web apps

## Scenario details

To offer high availability, this solution:

- Deploys a secondary instance of the solution in another Azure region.
- [Uses auto-failover groups for geo-replication and high availability of the database][Use auto-failover groups to enable transparent and coordinated failover of multiple databases].

You can achieve high availability with a [complete region failover][Complete region failover]. However, this solution uses a partial region failover. With this approach, only components with issues fail over:

- If the primary database fails over, the web app in the primary region connects to the newly activated secondary database while maintaining private connectivity.
- If the app goes down in the primary region, the instance in the secondary region takes over. That instance connects to the primary database, which is still active.

### Potential use cases

With private connectivity to an SQL database and high availability, this solution has applications in many areas. Examples include the financial, healthcare, and defense industries.

## Considerations

In general, the [considerations that apply to the single-region version][Considerations that apply to the single-region version] also apply to this solution. Keep the following points in mind, too.

### Availability

This approach achieves a higher availability than a single-region deployment does.

From the point of view of the web app, you can use this architecture in either an active-passive configuration or an active-active configuration. With an active-active approach, Front Door routes traffic to both regions simultaneously.

### Performance

A partial region failover involves cross-region connectivity, which increases latency. Instead of staying within a single region, app requests to the database cross the Azure network backbone into a remote Azure region.

Some implementations can temporarily tolerate this behavior. After the failed app or database is restored, connectivity returns to normal inside a single region. However, in environments with strict latency requirements, even short-lived cross-region connectivity may pose a problem.

> [!NOTE]
> The use of private endpoints itself also increases latency when accessing Azure SQL Database, as mentioned in the [performance efficiency section of the single-region version][Web app private connectivity to Azure SQL database].

### Security

As with the single-region scenario, the web apps in this solution use fully private connections to securely connect to both backend databases. The public internet can't access either of the database servers. This type of setup eliminates a common attack vector. Secure connections, combined with WAF integration ensures all requests are inspected for common exploits at the edge.

## Cost optimization

- This solution effectively doubles the [cost of the single-region version][Cost of the single-region version]. But certain circumstances can affect this estimate:

  - You use a scaled-down version of the App Service plan in the standby region and scale it up only when it becomes the active region.
  - You have significant cross-region traffic. [Network traffic between Azure regions incurs charges][Bandwidth Pricing Details].

- Make sure that [the primary and secondary databases use the same service tier][Configuring secondary database]. Otherwise, the secondary database may not keep up with replication changes.

## Deploy this scenario

Follow these steps to deploy this scenario:

1. Deploy the two regions separately by following the steps in the [single-region version][Deploy this scenario single-region version]. But note the following points:

   - Ensure to choose non-overlapping IP address ranges for the virtual networks in both regions, otherwise you cannot enable peering.

   - Only create the logical SQL Server in the secondary region. Don't create the SQL Database itself. The process of setting up the SQL failover group automatically creates and replicates the secondary database.

1. [Create the SQL failover group][Create the SQL failover group]. This step replicates the database across the two regions. Ensure the application uses the failover group DNS name in its connection string.

1. [Set up global peering][Virtual network peering] between the two virtual networks. This step enables cross-region connectivity.

At this point:

- The apps in both regions should connect to both databases over their private endpoints.
- Both apps should continue to function even if the database fails over to the other region.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | FastTrack for Azure Engineer

## Next steps

- [Basic web application][Basic web application]
- [Highly available multi-region web application][Highly available multi-region web application]
- [Scalable web application][Scalable web application]

## Related resources

- [Overview of business continuity with Azure SQL Database][Overview of business continuity with Azure SQL Database]: Information on database replication and high availability.

- [App Service networking features overview][App Service networking features]: Information on inbound and outbound App Service scenarios and a discussion of which features to use in which cases.

- [Multi-region N-tier application][Multi-region N-tier application]: An architecture that's similar to this one but doesn't provide private connectivity to the SQL instances.

[Alternatives to the single-region version]: ../private-web-app/private-web-app.yml#alternatives
[App Service networking features]: /azure/app-service/networking-features
[Azure App Service]: /azure/app-service
[Azure DNS Private Zones]: /azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones
[Azure Web Apps]: /azure/app-service/overview
[Bandwidth Pricing Details]: https://azure.microsoft.com/pricing/details/bandwidth/
[Basic web application]: ../../reference-architectures/app-service-web-app/basic-web-app.yml
[Complete region failover]: #alternatives
[Configuring secondary database]: /azure/azure-sql/database/active-geo-replication-overview#configuring-secondary-database
[Considerations that apply to the single-region version]: ../private-web-app/private-web-app.yml#considerations
[Cost of the single-region version]: ../private-web-app/private-web-app.yml#cost-optimization
[Create a Private Endpoint]: /azure/private-link/create-private-endpoint-portal#create-a-private-endpoint
[Create the SQL failover group]: /azure/azure-sql/database/failover-group-add-single-database-tutorial#2---create-the-failover-group
[Deploy this scenario single-region version]: ../private-web-app/private-web-app.yml#deploy-this-scenario
[Deployment stamps]: ../../patterns/deployment-stamp.yml
[Do I require a dedicated subnet for private endpoints?]: /azure/private-link/private-link-faq#do-i-require-a-dedicated-subnet-for-private-endpoints
[Fail over to a geo-replicated secondary database]: /azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview#fail-over-to-a-geo-replicated-secondary-database
[Global peering limitation]: ../private-web-app/private-web-app.yml#global-peering
[High availability]: https://wikipedia.org/wiki/High_availability
[Highly available multi-region web application]: ../../reference-architectures/app-service-web-app/multi-region.yml
[How to set up Private Link for Azure SQL Database]: /azure/azure-sql/database/private-endpoint-overview#how-to-set-up-private-link-for-azure-sql-database
[Integrate your app with an Azure virtual network]: /azure/app-service/web-sites-integrate-with-vnet
[Multi-region N-tier application]: ../../reference-architectures/n-tier/multi-region-sql-server.yml
[Overview of business continuity with Azure SQL Database]: /azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview
[Private link resource]: /azure/private-link/private-endpoint-overview#private-link-resource
[Regional VNet Integration]: /azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration
[Scalable web application]: ../../reference-architectures/app-service-web-app/scalable-web-app.yml
[Use auto-failover groups to enable transparent and coordinated failover of multiple databases]: /azure/azure-sql/database/auto-failover-group-overview
[Virtual network peering]: /azure/virtual-network/virtual-network-peering-overview
[Web app private connectivity to Azure SQL database]: ../private-web-app/private-web-app.yml
[What is a private Azure DNS zone]: /azure/dns/private-dns-privatednszone
[What is Azure Front Door?]: /azure/frontdoor/front-door-overview
[What is Azure Private Endpoint?]: /azure/private-link/private-endpoint-overview
[What is Azure Private Link?]: /azure/private-link/private-link-overview
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[What is Traffic Manager?]: /azure/traffic-manager/traffic-manager-overview
