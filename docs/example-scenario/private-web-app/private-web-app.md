---
title: Web app with private connectivity to Azure SQL database
titleSuffix: Azure Example Scenarios
description: Lock down access to an Azure SQL Database through private connectivity from a multi-tenant Azure App Service.
author: jelledruyts
ms.author: jelled
ms.date: 09/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Web app with private connectivity to database

This example scenario describes how to set up private connectivity from an Azure Web App to Azure Platform-as-a-Service (PaaS) services, or between Azure PaaS services that aren't natively deployed in isolated Azure Virtual Networks. The example shows a typical combination of hosting a web application in [Azure App Service](/azure/app-service/) and connecting to [Azure SQL Database](/azure/azure-sql/database/).

The web app can securely connect to a backend database over a fully private connection. The database can't be reached through a public internet endpoint, eliminating a common attack vector.

## Potential use cases

These use cases have similar design patterns that are variations on the same underlying principle:

- Connect from a Web App to Azure Storage, Azure Cosmos DB, Azure Cognitive Search, Azure Event Grid, or any other service that supports an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview#private-link-resource) for inbound connectivity.
- Connect from an [Azure Functions](/azure/azure-functions/functions-overview) App to any of these services, as long as the Function App is deployed in a [pricing plan that supports Virtual Network integration](/azure/azure-functions/functions-networking-options#virtual-network-integration).
- Connect from a Web App or Functions App to another Web App. For example, connect from a website to a REST API hosted in another Azure App Service instance. App Service itself also supports [Private Endpoints](/azure/app-service/networking/private-endpoint) for inbound connectivity.

## Architecture

![Architecture diagram](./media/appsvc-private-sql-solution-architecture.png "Diagram showing an App Service web app connecting to a backend Azure SQL Database through a Virtual Network using Private Link.")

1. Using Azure App Service [regional VNet Integration](/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration), the web app connects to Azure through the **AppSvcSubnet** delegated subnet in an Azure Virtual Network.
2. Only a [private endpoint](/azure/azure-sql/database/private-endpoint-overview#how-to-set-up-private-link-for-azure-sql-database) in the **PrivateLinkSubnet** of the same Azure Virtual Network exposes the Azure SQL database.
3. The database firewall allows only traffic coming from **PrivateLinkSubnet**, making the database inaccessible from the public internet.
4. The web app connects to the database's private endpoint through the Virtual Network.
   
In this example, the Virtual Network is only required for routing the traffic and is otherwise empty, but other subnets and workloads could run in the Virtual Network.

### DNS hostname resolution to the private IP address

The app code can still use the public hostname, for example `contoso.database.windows.net`, for the SQL Database connection string. However, regional VNet Integration routes traffic from the web app only to private addresses in the Virtual Network, and the SQL Database hostname DNS resolution will still result in its public IP address. If the web app connects to the public IP address, the traffic won't pass through the Virtual Network, although the traffic remains within Azure.

Using the Private Link-specific hostname like `contoso.privatelink.database.windows.net` won't work either, because SQL Database doesn't accept this hostname. This hostname still resolves to the public IP address, due to [how DNS works for private endpoints](/azure/private-link/private-endpoint-dns).

To make DNS resolve the hostname to the SQL Database's private IP address, configure App Service to use the Azure Private DNS Zone. To set up this configuration during private endpoint creation, set the web app `WEBSITE_VNET_ROUTE_ALL` to `1` and `WEBSITE_DNS_SERVER` to `168.63.129.16`, the IP address of the Azure-provided DNS service. For more information, see [App Service Virtual Network integration with DNS Private Zones](/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones).

Now `contoso.database.windows.net` no longer resolves to the public IP address, but to the private IP address in the **PrivateLinkSubnet**, as defined in the Azure Private DNS Zone. Traffic flows privately over the Virtual Network.

If you already have a Virtual Network with a custom DNS server that resolves the SQL Database hostname to its private IP address, the delegated **AppSvcSubnet** inherits the DNS settings from that Virtual Network. The App Service `WEBSITE_DNS_SERVER` configuration setting then isn't required. For more information, see [custom DNS server already configured on the Virtual Network](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server).

If you don't have a custom DNS server, you can still define DNS for the entire Virtual Network by setting the Virtual Network's DNS server IP address to `168.63.129.16`, so that the app inherits this DNS server address.

The scope and possible impact of defining DNS for the entire Virtual Network is larger than setting it for the individual App Service, and affects all workloads running within that network. Regardless of whether the DNS configuration is set on the app or on the Virtual Network, the `WEBSITE_VNET_ROUTE_ALL` app setting is required to make this DNS resolution work.

## Components

This scenario uses the following Azure services:

- [Azure App Service](/azure/app-service/app-service-web-overview) hosts web applications, allowing autoscale and high availability without having to manage infrastructure.
- [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.
- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for private networks in Azure. Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks through Virtual Networks.
- [Azure Private Link](/azure/private-link/private-link-overview) provides a private endpoint in a Virtual Network for connectivity to Azure PaaS services like Azure Storage and SQL Database, or to customer or partner services.

## Alternatives

- An alternative approach for private connectivity is an [App Service Environment](/azure/app-service/environment/intro) for hosting the web application within an isolated environment, and [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) as the database engine. Both of these services are natively deployed within a Virtual Network, so there's no need for Virtual Network integration or private endpoints. These offerings are typically more costly, because they provide single-tenant isolated deployment and other features.
  
  If you have an App Service Environment but aren't using SQL Managed Instance, you can still use a private endpoint for private connectivity to a SQL Database. If you already have SQL Managed Instance but are using multi-tenant App Service, you can still use regional VNet Integration to connect to the SQL Managed Instance private address.

- The App Service and Private Link subnets could be in separate peered Virtual Networks, for example as part of a hub-and-spoke network configuration. However, for regional VNet Integration, the peered Virtual Networks must be located in the same Azure region.

- As an alternative to Private Endpoints, you can use [Service Endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) to secure the database. The private endpoint, **PrivateLinkSubnet**, and configuring the `WEBSITE_VNET_ROUTE_ALL` app setting, are then unnecessary. A Service Endpoint accesses the database via its public endpoint, so the `WEBSITE_DNS_SERVER` app setting is also unnecessary. You still need to use regional VNet Integration to get incoming traffic to route through the Virtual Network.
  
  Compared to Service Endpoints, Private Endpoints provide a private, dedicated IP address toward a specific instance, for example a logical SQL Server, rather than an entire service. Private Endpoints can help prevent data exfiltration towards other database servers. For more information, see [Comparison between Service Endpoints and Private Endpoints](/azure/private-link/private-link-faq#what-is-the-difference-between-a-service-endpoints-and-a-private-endpoints).

## Considerations

The following considerations apply to this scenario.

### Security

This scenario secures the outbound connection from an App Service web app to a downstream dependency like a database. You can secure the inbound connection to the web app by fronting the app with a service like [Application Gateway](/azure/application-gateway/overview) or [Azure Front Door](/azure/frontdoor/front-door-overview), optionally with [Web Application Firewall](/azure/web-application-firewall/overview) capabilities.

To prevent users from bypassing the front-end service and accessing the web app directly, set [App Service access restrictions](/azure/app-service/app-service-ip-restrictions) like IP address rules or service endpoints. For an example scenario, see [Application Gateway integration with App Service (multi-tenant)](/azure/app-service/networking/app-gateway-with-service-endpoints#integration-with-app-service-multi-tenant).

#### SQL Database firewall options

The most important security consideration in this scenario is how to configure the SQL Database firewall.

Without using private connectivity, you can add [firewall rules](/azure/azure-sql/database/firewall-create-server-level-portal-quickstart) that allow inbound traffic only from specified IP address ranges. Another approach is to [allow Azure services](/azure/azure-sql/database/network-access-controls-overview#allow-azure-services) to access the server, which locks down the firewall to allow only traffic coming from within Azure, but includes all Azure regions and other customers.

You can also add a more restrictive firewall rule to allow only the [outbound IP addresses](/azure/app-service/overview-inbound-outbound-ips#find-outbound-ips) that your app uses. But because App Service is a multi-tenant service, these IP addresses are shared with and allow traffic from other Azure App Service customers who run their apps on the same [deployment stamp](/azure/architecture/patterns/deployment-stamp) and therefore use the same outbound IP addresses.

Private connectivity through the Virtual Network provides the following firewall options to prevent other customers from accessing the database:

- A [virtual network rule](/azure/azure-sql/database/vnet-service-endpoint-rule-overview) that allows traffic only from the regional VNet Integration delegated subnet, **AppSvcSubnet** in this example. The delegated subnet must have a [Service Endpoint](/azure/virtual-network/virtual-network-service-endpoints-overview) configured for `Microsoft.Sql` so the database can identify traffic from that subnet.
  
- Configuring the firewall to [Deny public network access](/azure/azure-sql/database/connectivity-settings#deny-public-network-access), which turns off all other firewall rules and makes the database accessible only through its private endpoint.
  
The option of denying public network access is the most secure configuration, but means that database access is only possible by going through the Virtual Network that hosts the private endpoint. Anything other than the web app must have direct connectivity to the Virtual Network to connect to the database.

For example, database deployments or urgent manual connections from SQL Server Management Studio (SSMS) on local machines couldn't reach the database except through VPN or ExpressRoute connectivity into the Virtual Network. You could also remote connect to a VM in the Virtual Network and use SSMS from there. For exceptional situations, you could temporarily allow public network access, and reduce risk by using the other configuration options.

### Availability

Azure Private link supporting Azure SQL Database is available in all public and government regions.

Private Link introduces an additional component and availability consideration into the architecture. The Private Link service has an [availability SLA of 99.99%](https://azure.microsoft.com/support/legal/sla/private-link/), which must be taken into account when calculating the [composite SLA of the entire solution](/azure/architecture/framework/resiliency/business-metrics#composite-slas).

#### Global peering

Any service in any Azure region that can connect through the Virtual Network can reach the database's private endpoint, for example through [Virtual Network peering](/azure/virtual-network/virtual-network-peering-overview) in hub and spoke topologies. However, for App Service regional VNet Integration, the peered Virtual Networks must be located in the same Azure region.

Lack of global peering support means you can't use this solution for cross-region connectivity from App Service to a database or other private endpoint in another Azure region. For example, this solution wouldn't work for a multi-regional deployment to support a partial failover, in which the web app remains active in one region but must connect to a failed-over database in another region, or vice versa.

### Cost

There's no additional cost for App Service regional VNet Integration feature in a supported pricing tier of Standard or above. Standard is a minimum recommendation for production workloads.

The Azure Private Link service that enables the database's private endpoint has an associated cost based on an hourly fee plus a premium on bandwidth. See the [Private Link pricing page](https://azure.microsoft.com/pricing/details/private-link/) for details.

To explore the cost of running this scenario, all the mentioned services are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/f25225ef92824212ae34f837c22d519c) with reasonable default values for a small scale application. To see how the pricing would change for your use case, change the appropriate variables to match your expected usage.

### Logging and monitoring

Azure Private Link is integrated with [Azure Monitor](/azure/azure-monitor/overview), which allows you to see if data is flowing and [troubleshoot connectivity problems](/azure/private-link/troubleshoot-private-endpoint-connectivity).

## Deploy this scenario

**Prerequisites**
- An Azure App Service web app
- A deployed Azure SQL Database

### Azure portal

1. In the Azure portal, [create a Virtual Network](/azure/virtual-network/quick-create-portal) using the address range `10.1.0.0/16`, and [create two subnets](/azure/virtual-network/virtual-network-manage-subnet#add-a-subnet) within it:
   - **PrivateLinkSubnet**, address range `10.1.1.0/24`, to expose the private endpoint of the database.
   - **AppSvcSubnet**, address range `10.1.2.0/24`, for the web app's regional VNet Integration.
   
1. On the Azure SQL Database, create the private endpoint in the **PrivateLinkSubnet** by following the instructions at [Create a private endpoint](/azure/private-link/create-private-endpoint-portal#create-a-private-endpoint).
   
   1. For **Resource type**, select **Microsoft.Sql/servers**, for **Resource**, select the logical SQL Server to expose, and for **Target sub-resource**, select **sqlServer**.
      
      ![Screenshot of Private Endpoint Resource creation page.](media/appsvc-private-sql-private-endpoint-create-resource.png)
   1. On the **Configuration** page, select **Integrate with private DNS zone**, which will register the database server's private IP address in the `privatelink.database.windows.net` private zone.
      
      ![Screenshot of the Private Endpoint Configuration page.](media/appsvc-private-sql-private-endpoint-create-configuration.png)
   
1. In the web app, enable regional VNet Integration with the **AppSvcSubnet** by following the instructions at [Enable VNet Integration](/azure/app-service/web-sites-integrate-with-vnet#enable-vnet-integration).
   
   ![Screenshot of enabling regional VNet Integration for the web app.](media/appsvc-private-sql-regional-vnet-integration.png)
   
   If you configure regional VNet Integration on the web app's portal **Networking** page, the required delegation of the subnet to `Microsoft.Web` happens automatically. If you don't use the **Networking** page, make sure to [delegate the subnet](/azure/virtual-network/manage-subnet-delegation#delegate-a-subnet-to-an-azure-service) to `Microsoft.Web` manually by following the instructions at [Delegate a subnet to an Azure service](/azure/virtual-network/manage-subnet-delegation#delegate-a-subnet-to-an-azure-service).
   
1. In the web app's [configuration settings](/azure/app-service/configure-common#configure-app-settings), set **WEBSITE_VNET_ROUTE_ALL** to `1` and **WEBSITE_DNS_SERVER** to `168.63.129.16`.
   
   ![Web App Configuration Settings](media/appsvc-private-sql-webapp-settings.png)
   
   
Your web application should now be able to connect to the database over the private IP address. To validate, set the database firewall to **Deny public network access**, which ensures that traffic is allowed only over the private endpoint.

Keep using the regular hostname for the SQL Database in the connection string, for example `contoso.database.windows.net`, not the `privatelink`-specific hostname.

If the web app can't connect, use **nameresolver.exe** to ensure that the hostname of the SQL Database resolves to its private IP address. For instructions, see [Troubleshooting](/azure/app-service/web-sites-integrate-with-vnet#troubleshooting).

### Azure Resource Manager (ARM) template

A slightly more advanced version of this scenario is available as an [Azure Resource Manager QuickStart Template](https://azure.microsoft.com/resources/templates/301-web-app-regional-vnet-private-endpoint-sql-storage/). In this scenario, a web app accesses both a SQL Database and a Storage Account over private endpoints. These endpoints are in a different Virtual Network from the App Service integrated Virtual Network, to demonstrate how this solution works across peered Virtual Networks.

![Diagram showing the QuickStart Template solution architecture.](https://github.com/Azure/azure-quickstart-templates/raw/master/301-web-app-regional-vnet-private-endpoint-sql-storage/images/solution-architecture.png)

## Related resources

For more information on inbound and outbound scenarios for App Service, and which features to use in which cases, see the [App Service networking features overview](/azure/app-service/networking-features).
