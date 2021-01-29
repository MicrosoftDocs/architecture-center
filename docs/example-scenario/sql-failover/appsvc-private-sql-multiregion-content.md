This example scenario discusses a highly available solution for a web app with private connectivity to a SQL database. A single-region architecture already exists for a web app with private connectivity to a SQL Database. This solution extends that base architecture by making it highly available.

See [Web app private connectivity to Azure SQL database](https://docs.microsoft.com/azure/architecture/example-scenario/private-web-app/private-web-app) for more information on the base architecture.

To offer high availability, this solution:

- Deploys a secondary instance of the solution in another Azure region.
- [Uses auto-failover groups for geo-replication and high availability of the database](https://docs.microsoft.com/azure/azure-sql/database/auto-failover-group-overview).

## Potential use cases

As with the single-region version (*change wording to avoid repitition*), this approach isn't limited to Azure SQL Database. You can also use this scenario with any service that supports an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview#private-link-resource) for inbound connectivity. Examples include:

- Azure Storage
- Azure Cosmos DB
- Azure Cognitive Search
- Azure Event Grid
- Function Apps
- Other web apps

## Partial region failover

One way to achieve high availability is with a [complete region failover][Complete region failover]. However, this solution uses a partial region failover. With this approach, only the components that experience an issue fail over:

- If the primary database fails over, the web app in the primary region connects to the newly activated secondary database while maintaining private connectivity.
- If the app goes down in the primary region, the instance in the secondary region takes over but connects to the primary database, which is still active.

## Two private endpoints for each database

Note that per the documentation on making [App Service work with Azure DNS private zones](https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones), the web app needs the `WEBSITE_VNET_ROUTE_ALL` configuration setting to be `1` for the DNS resolution to work correctly within the region. (*Elaborate. What does that setting specify? Earlier in that article it's explained: To route all traffic from your app into your VNet, set WEBSITE_VNET_ROUTE_ALL to 1.*)

For cross-region private connectivity, however, this is not enough. [Global peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview) between the Virtual Networks is not an option, because with App Service regional VNet integration, [you can't reach resources across global peering connections](https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration). This means that when the database would fail over to the secondary region, the web app in the primary region cannot reach the private endpoint of the database in the secondary region.

This architecture overcomes that limitation. Instead of one private endpoint, each database has *two* private endpoints, with one in each region. The solution then contains a total of four private endpoints. This approach works well because:

- [You can create multiple private endpoints for the same resource](https://docs.microsoft.com/azure/private-link/private-link-faq#can-i-connect-my-service-to-multiple-private-endpoints), meaning that it's allowed to expose two private endpoints for the same database.
- [A private endpoint in one region can connect to an Azure PaaS resource in another region](https://docs.microsoft.com/azure/private-link/private-link-faq#can-private-endpoint-connect-to-azure-paas-resources-across-azure-regions); in this case a private endpoint for the primary database can be created in the secondary region and vice versa.
- [You can create multiple private endpoints in the same Virtual Network](https://docs.microsoft.com/azure/private-link/private-link-faq#can-i-create-multiple-private-endpoints-in-same-vnet-can-they-connect-to-different-services), meaning that the private endpoints for both database instances can exist in the same network, [even in the same subnet](https://docs.microsoft.com/azure/private-link/private-link-faq#do-i-require-a-dedicated-subnet-for-private-endpoints).


## Architecture

![Architecture diagram](./media/appsvc-private-sql-multiregion-solution-architecture.png "Solution Architecture")

### General case

Local connectivity happens exactly like in the [single-region version](https://docs.microsoft.com/azure/architecture/example-scenario/private-web-app/private-web-app):

1. Traffic Manager routes requests from the internet to a web app.
1. By using Azure App Service [regional VNet Integration](https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration), the web app connects to Azure through an **AppSvcSubnet** delegated subnet in an Azure Virtual Network. [Azure Private Link](https://docs.microsoft.com/azure/azure-sql/database/private-endpoint-overview#how-to-set-up-private-link-for-azure-sql-database) sets up a [private endpoint](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) for the Azure SQL database in the **PrivateLinkSubnet** of the Virtual Network.
1. The web app connects to the Azure SQL Database private endpoint presented inside the **PrivateLinkSubnet** of the Virtual Network.
1. The database firewall allows only traffic coming from the private endpoint on the **PrivateLinkSubnet** to connect.
1. The database is inaccessible from the public internet (but accessible from anything inside or connected to the Virtual Network).

### Specific cases

The following sections describe the cases that result when specific databases and web apps are active.

In all scenarios, the web app connects to the currently active database over a fully private connection without requiring a configuration change. In both regions, the web app uses a connection string that includes a `Server` host name. That host name refers to the DNS name of the SQL failover group. An example is:

`Server=tcp:sql-failovergroup.database.windows.net,1433;Initial Catalog=...`

Since both regions use the same connection string, there's no need to change that string when a database fails over.

#### Primary database is active

This architecture uses a SQL failover group. When the primary database is active:

- The DNS name `sql-failovergroup.database.windows.net` resolves to the host name of the currently active database, `sql-primary.database.windows.net`.
- Since the database has private endpoints enabled, the DNS name `sql-primary.database.windows.net` resolves to `sql-primary.privatelink.database.windows.net`.

##### Primary web app is active

In this case:
- Internet requests arrive at the primary web app (**1**).
- The web app connects to the primary AppSvcSubnet subnet (**2**).
- The web app accesses the database:
  - As configured, the Private DNS Zone resolves `sql-primary.privatelink.database.windows.net` to `10.1.1.4`.
  - The app connects to the private endpoint of the primary database (**3**).
- The app and the database run in the same region (**4**).

Summary of DNS resolution:

`sql-failovergroup.database.windows.net => sql-primary.database.windows.net => sql-primary.privatelink.database.windows.net => 10.1.1.4`

##### Secondary web app is active

The secondary web app is active in either of these cases:

- The primary web app fails over the secondary region.
- Traffic Manager routes traffic to both regions simultaneously in an active-active configuration.

When the secondary web app is active:

- Internet requests arrive at the secondary web app (**1'**).
- The web app connects to the secondary AppSvcSubnet subnet (**2'**).
- The web app accesses the database:
  - As configured, the Private DNS Zone in the secondary region resolves `sql-primary.privatelink.database.windows.net` to `10.2.1.5`.
  - The app connects to the private endpoint of the primary database (**3'**), which is exposed via the local Virtual Network inside the secondary region (thereby not requiring any global peering support as the connectivity is local from the web app's point of view).
- The cross-region traffic increases latency (**4'**).

Summary of DNS resolution:

`sql-failovergroup.database.windows.net => sql-primary.database.windows.net => sql-primary.privatelink.database.windows.net => 10.2.1.5`

#### Secondary database is active

When the primary database fails over:

- The SQL failover group's DNS record changes. The DNS name `sql-failovergroup.database.windows.net` resolves to the newly active database in the secondary region, `sql-secondary.database.windows.net.`
- Since the secondary database has private endpoints enabled, the DNS name `sql-secondary.database.windows.net` resolves to `sql-secondary.privatelink.database.windows.net`.

##### Primary web app is active

In this case:

- Internet requests arrive at the primary web app (**1**).
- The web app connects to the primary AppSvcSubnet subnet (**2**).
- The web app accesses the database:
  - As configured, the Private DNS Zone in the primary region resolves `sql-secondary.privatelink.database.windows.net` to `10.1.1.5`.
  - The app connects to the local private endpoint of the secondary database (**3''**).
- The cross-region traffic increases latency (**4''**).

Summary of DNS resolution:

`sql-failovergroup.database.windows.net => sql-secondary.database.windows.net => sql-secondary.privatelink.database.windows.net => 10.1.1.5`

##### Secondary web app is active

In this case:

- Internet requests arrive at the secondary web app (**1'**).
- The web app connects to the primary AppSvcSubnet subnet (**2'**).
- The web app accesses the database:
  - As configured, the Private DNS Zone in the secondary region resolves `sql-secondary.privatelink.database.windows.net` to `10.2.1.4`.
  - The app connects to the private endpoint of the secondary database (**3'''**).
- The app and the database run in the same region (**4'''**).

Summary of DNS resolution:

`sql-failovergroup.database.windows.net` => `sql-secondary.database.windows.net` => `sql-secondary.privatelink.database.windows.net` => `10.2.1.4`








### Components

- [App Service][App Service overview] provides a framework for building, deploying, and scaling web apps. This platform offers built-in infrastructure maintenance, security patching, and scaling.

- [Azure SQL Database][What is Azure SQL Database?] is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.

- [Azure Virtual Network][What is Azure Virtual Network?] is the fundamental building block for private networks in Azure. Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks through Virtual Networks.

- [Azure Private Link][What is Azure Private Link?] provides a private endpoint in a Virtual Network for connectivity to Azure PaaS services like Azure Storage and SQL Database, or to customer or partner services.

- [Traffic Manager][What is Traffic Manager?] is a DNS-based traffic load balancer. This service distributes traffic to public-facing applications across global Azure regions. Traffic Manager also provides public endpoints with high availability and quick responsiveness.

### Alternatives

- In general, the [alternatives that are appropriate for the single-region version][Alternatives] also apply to this solution.

- Instead of using a partial region failover, you can use a complete region failover. As [Highly available multi-region web application](https://docs.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/multi-region) explains, when a single component fails with this approach, the architecture fails over the entire region. For example, an issue in the primary region web app can trigger a database failover. At the same time, [Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview) or [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview) can shift all traffic to the app in the secondary region.

  This approach requires no cross-region connectivity. Instead, you treat your entire solution as an isolated [deployment stamp](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp) that moves from one region to another as one unit. However, a complete region failover has disadvantages. Triggering a [database failover can cause data loss](https://docs.microsoft.com/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview#fail-over-to-a-geo-replicated-secondary-database) due to the asynchronous nature of database replication.


## Considerations

In general, the [considerations that apply to the single-region version](https://docs.microsoft.com/azure/architecture/example-scenario/private-web-app/private-web-app#considerations) also apply to this solution. Keep the following points in mind, too.

### Availability considerations

This solution deploys additional private endpoints in the remote regions. As a result, this solution overcomes the [global peering limitation][Global peering limitation] that applies to the single-region version. This approach also achieves a higher availability than with a single-region deployment.

### Performance considerations

A partial region failover involves cross-region connectivity, which increases latency. Instead of staying withing a single region, every app request to the database crosses the Azure network backbone into a remote Azure region.

Some implementations can temporarily tolerate this behavior. After the failed app or database is restored, connectivity returns to normal inside the same region. However, implementations with strict latency requirements may face issues.

### Security considerations

As with the single-region scenario, the web apps in this solution use fully private connections to securely connect to both backend databases. The public internet can't access either of the database servers. Using this setup eliminates a common attack vector.

## Deploy this scenario

Follow these steps to deploy this scenario:

1. Deploy the two regions separately by following the steps in the [single-region version](https://docs.microsoft.com/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario). But note the following points:

   - You need at least two resource groups for this complete scenario for these reasons:

     - The Azure resource that represents a private DNS zone uses the actual DNS zone name (for example, `privatelink.database.windows.net`).
     - You can't have different private DNS zones with the same name within a single resource group.
  
     It's best to deploy all resources that you host in the same Azure region into the same resource group.

   - To avoid confusion, choose non-overlapping IP address ranges for the virtual networks in both regions. This approach isn't required but is best if you plan on peering the networks for other reasons later on.

   - Only create the logical SQL Server in the secondary region. Don't create the SQL Database itself. The process of setting up the SQL failover group automatically creates and replicates the secondary database.

1. [Create the SQL failover group](https://docs.microsoft.com/azure/azure-sql/database/failover-group-add-single-database-tutorial#2---create-the-failover-group). This step replicates the database across the two regions. Ensure the application uses the failover group DNS name in its connection string.

1. Deploy and configure the additional cross-regional private endpoints for both databases:

   1. [Create an additional private endpoint for each database](https://docs.microsoft.com/azure/private-link/create-private-endpoint-portal#create-a-private-endpoint), but select the subnet in the virtual network in the *other* region.
   1. Look up the IP address for the newly created private endpoint in the local virtual network. For example:

      - In the primary region, the address for the secondary database might be `10.1.1.5`.
      - In the secondary region, the address for the primary database might be `10.2.1.5`.

   1. Add that IP address as an A record to the `privatelink.database.windows.net` private DNS zone that's linked to the local virtual network. For example:
   
      - In the primary region, set `sql-secondary` to `10.1.1.5`.
      - In the seconday region, set `sql-primary` to `10.2.1.5`.

   ![Screenshot showing adding the A record for the secondary database in the primary region](media/appsvc-private-sql-multiregion-privatezone.png)

At this point:

- The apps in both regions should be able to connect to both databases over their private endpoints.
- Both apps should transparently continue to function even if the database fails over to the other region.

## Pricing

This scenario effectively doubles the cost of the single-region version, unless you use a scaled-down version of the App Service Plan in the secondary (standby) region and scale it up only when it becomes the active region. The database in the secondary region *must* be configured with the same service tier as called out in the [documentation for Azure SQL Database geo-replication](https://docs.microsoft.com/azure/azure-sql/database/active-geo-replication-overview#configuring-secondary-database), otherwise the secondary may not be able to keep up with the replication changes. An additional factor is the [egress bandwidth cost](https://azure.microsoft.com/pricing/details/bandwidth/) in case there is cross-region traffic, as network traffic between Azure regions is charged.

## Next steps

## Related resources

For more information on database replication and high availability, see the [Overview of business continuity with Azure SQL Database](https://docs.microsoft.com/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview).

For more information on inbound and outbound scenarios for App Service, and which features to use in which cases, see the [App Service networking features overview](/azure/app-service/networking-features).

[Alternatives]: /azure/architecture/example-scenario/private-web-app/private-web-app#alternatives
[App Service overview]: /azure/app-service/overview
[Complete region failover]: #alternatives
[Global peering limitation]: /azure/architecture/example-scenario/private-web-app/private-web-app#global-peering
[What is Azure Private Link?]: /azure/private-link/private-link-overview
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[What is Traffic Manager?]: /azure/traffic-manager/traffic-manager-overview