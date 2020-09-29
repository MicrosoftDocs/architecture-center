---
title: Web app with private connectivity to database
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

This example scenario describes how to set up private connectivity from an Azure Web App to Azure Platform-as-a-Service (PaaS) services, or between PaaS services, that aren't natively deployed in isolated Azure Virtual Networks. This scenario shows a typical combination of hosting a web application in [Azure App Service](/azure/app-service/) and connecting to [Azure SQL Database](/azure/azure-sql/database/). The web app can securely connect to a backend database over a fully private connection. The database can't be reached through a public internet endpoint, eliminating a common malicious attack vector.

[App Service Environment](/azure/app-service/environment/intro) and [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) are natively deployed within isolated Virtual Networks, so can connect privately without additional configuration. For more information, see [Alternatives](#alternatives).

## Potential use cases

These use cases have similar design patterns that are variations on the same underlying principle:

- Connect from a Web App to Azure Storage, Azure Cosmos DB, Azure Cognitive Search, Azure Event Grid, or any other service that supports an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview#private-link-resource) for inbound connectivity.
- Connect from an Azure Function App to any of these services, as long as the Function App is deployed in a [pricing plan that supports Virtual Network integration](/azure/azure-functions/functions-networking-options#virtual-network-integration).
- Connect from a Web App or Function App to another Web App. For example, connect from a website to a REST API hosted in another Azure App Service instance. App Service itself also supports [Private Endpoints](/azure/app-service/networking/private-endpoint) for inbound connectivity.

## Architecture

![Architecture diagram](./media/appsvc-private-sql-solution-architecture.png "Diagram showing an App Service web app connecting to a backend Azure SQL Database through a Virtual Network using Private Link.")

1. Using Azure App Service [regional VNet Integration](/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration), the web app connects to Azure through the **AppSvcSubnet** delegated subnet in an Azure Virtual Network.
2. Only a [private endpoint](/azure/azure-sql/database/private-endpoint-overview#how-to-set-up-private-link-for-azure-sql-database) in the **PrivateLinkSubnet** of the same Azure Virtual Network exposes the Azure SQL database.
3. The database firewall allows only traffic coming from **PrivateLinkSubnet**, making the database inaccessible from the public internet.
4. The web app connects to the database's private endpoint through the Virtual Network.
   
The app code itself can still use the same hostname for the SQL Database in the connection string, for example `contoso.database.windows.net`. However, regional VNet Integration routes traffic from the web app into the Virtual Network only to private addresses, and the SQL Database hostname DNS resolution will still result in its public IP address. The web app would connect to the public IP address and the traffic would not pass through the Virtual Network, although the traffic itself would always remain within the Azure network.

Using the Private Link-specific hostname, like `contoso.privatelink.database.windows.net` at this point won't work, because SQL Database doesn't accept this hostname. Without additional configuration, this still resolves to the same public IP address, due to [how DNS works for private endpoints](/azure/private-link/private-endpoint-dns).

To make the web app resolve the hostname to the SQL Database's private IP address, configure App Service to use the Azure Private DNS Zone set up during the private endpoint configuration. To set this configuration, set the web app's `WEBSITE_Virtual Network_ROUTE_ALL` to `1` and `WEBSITE_DNS_SERVER` to `168.63.129.16`, the IP address of the Azure-provided DNS service. For more information, see [App Service Virtual Network integration with DNS Private Zones](/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones).

These configuration settings mean that `contoso.database.windows.net` no longer resolves to the public IP address, but instead to the private IP address in the **PrivateLinkSubnet**, as defined in the Azure Private DNS Zone. Traffic flows privately over the Virtual Network.

## Components

This scenario uses the following Azure services:

- [Azure App Service](/azure/app-service/app-service-web-overview) hosts web applications, allowing autoscale and high availability without having to manage infrastructure.
- [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.
- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for private networks in Azure. Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks through Virtual Networks.
- [Azure Private Link](/azure/private-link/private-link-overview) provides a private endpoint in a Virtual Network for connectivity to Azure PaaS services like Azure Storage and SQL Database, or customer or partner services.

## Alternatives

- In this example, the Virtual Network is only required for routing the traffic and is otherwise empty, but other subnets and workloads could run in the Virtual Network. The App Service and Private Link subnets could also be in separate peered Virtual Networks, for example as part of a hub-and-spoke network configuration.

- If a Virtual Network already resolves the SQL Database hostname to its private IP address, the delegated **AppSvcSubnet** inherits the DNS settings from that Virtual Network, and the App Service `WEBSITE_DNS_SERVER` configuration setting isn't required. For more information, see [custom DNS server already configured on the Virtual Network](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server).
  
  If you don't have a custom DNS server, you can set the Virtual Network's DNS server IP address to `168.63.129.16`, so that the app inherits this DNS server address. The scope and possible impact of defining DNS for the entire Virtual Network is larger than setting it for the individual App Service, and affects all workloads running within that network. Regardless of whether the DNS configuration is set on the app or on the Virtual Network, the `WEBSITE_Virtual Network_ROUTE_ALL` app setting is required to make this DNS resolution work.

- As an alternative to Private Endpoints, you can use [Service Endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) to secure the database. You still need to use regional VNet Integration to get incoming traffic to route through the Virtual Network. The private endpoint and **PrivateLinkSubnet**, and configuring the `WEBSITE_Virtual Network_ROUTE_ALL` app setting, are unnecessary. A Service Endpoint accesses the database via its public endpoint, so the `WEBSITE_DNS_SERVER` app setting is also unnecessary.
  
  A Private Endpoint provides a fully private, dedicated IP address toward a specific instance, for example a logical SQL Server, rather than the entire service. Private Endpoints could help prevent data exfiltration towards other database servers.
  
  For more information, see [Comparison between Service Endpoints and Private Endpoints](/azure/private-link/private-link-faq#what-is-the-difference-between-a-service-endpoints-and-a-private-endpoints).

- An alternative approach for private connectivity is an [App Service Environment](/azure/app-service/environment/intro) for hosting the web application within an isolated environment, and [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) as the database engine. Because these services are deployed within a Virtual Network, there is no need for Virtual Network integration or private endpoints. These offerings are typically more costly, because they provide single-tenant isolated deployment and other features.
  
  If you have an App Service Environment but aren't using SQL Managed Instance, you can still use a private endpoint for private connectivity to a SQL Database. If you already have SQL Managed Instance but are using multi-tenant App Service, you can still use regional VNet Integration to connect to the SQL Managed Instance private address.

## Considerations

The following considerations apply to this scenario.

### Security

This article discusses securing the outbound connection from an App Service web app to a downstream dependency like a database. You may also want to consider securing the *inbound* path, for example because you are fronting the web app with a service like [Application Gateway](/azure/application-gateway/overview) or [Azure Front Door](/azure/frontdoor/front-door-overview), optionally with [Web Application Firewall](/azure/web-application-firewall/overview) capabilities.

So that end users can't bypass the front-end service and access the web app directly, set [App Service access restrictions](/azure/app-service/app-service-ip-restrictions) like IP address rules or service endpoints. For an example scenario, see [Integrate App Service with Application Gateway through service endpoints](/azure/app-service/networking/app-gateway-with-service-endpoints#integration-with-app-service-multi-tenant).

#### Database firewall options

The most important security consideration in this scenario is how to configure the SQL Database firewall.

Without using the private connectivity outlined in this article, you can add [firewall rules](/azure/azure-sql/database/firewall-create-server-level-portal-quickstart) that allow inbound traffic from Start IP `0.0.0.0` to End IP `255.255.255.255`, which means the database is wide open to the internet, or from any IP address range. A slightly more secure approach is to [allow Azure services and resources to access this server](/azure/azure-sql/database/network-access-controls-overview#allow-azure-services), which locks down the firewall to traffic coming from within Azure, but includes all Azure regions and other customers.

You can add a more restrictive firewall rule for [all outbound IP addresses App Service can use from your web app](/azure/app-service/overview-inbound-outbound-ips#find-outbound-ips). But because App Service is a multi-tenant service, these outbound IP addresses are still shared with and allow traffic from other Azure App Service customers who run their apps on the same [deployment stamp](/azure/architecture/patterns/deployment-stamp), and therefore use the same outbound IP addresses.

With private connectivity configured through the Virtual Network, the following firewall options prevent other customers from having network-level access to the database:

- A [virtual network rule](/azure/azure-sql/database/vnet-service-endpoint-rule-overview) that allows only traffic from the delegated subnet used by App Service regional VNet Integration, **AppSvcSubnet** in this example. The delegated subnet must have a [Service Endpoint](/azure/virtual-network/virtual-network-service-endpoints-overview) configured for `Microsoft.Sql` to see traffic into the database as from that specific subnet.
- Configuring the firewall to [Deny public network access](/azure/azure-sql/database/connectivity-settings#deny-public-network-access), which turns off all other firewall rules and makes the database accessible only through its private endpoint.
  
The option of denying public network access is the most secure configuration, but also means the only database access is by going through the Virtual Network hosting the private endpoint. Anything other than the web app that needs to connect to the database must have direct connectivity to the Virtual Network. For example, database deployments or urgent manual connections from SQL Server Management Studio (SSMS) on local machines won't be able to reach the database except through VPN or ExpressRoute connectivity into the Virtual Network, or other remote access. For exceptional situations, you could also temporarily allow public network access, and reduce risk by using the other configuration options.

### Global peering

any service in any Azure region that has connectivity through the Virtual Network can reach the database's private endpoint, for example through [Virtual Network peering](/azure/virtual-network/virtual-network-peering-overview). However, although App Service regional VNet Integration works across peered Virtual Networks like for hub and spoke topologies, the peered Virtual Networks must be located in the same Azure region.

Absence of *global peering* support means you can't use this solution for cross-region connectivity from App Service to a database or other private endpoint in another Azure region. For example, this solution wouldn't work for a multi-regional deployment to support a partial failover, in which the web app remains active in one region but must connect to a failed-over database in another region, or vice versa.

### Availability

The Azure Private Link service that publishes and maintains the database's private endpoint introduces an additional component and availability consideration into the architecture. The Private Link service has an [availability SLA of 99.99%](https://azure.microsoft.com/support/legal/sla/private-link/), which must be taken into account when calculating the [composite SLA of the entire solution](/azure/architecture/framework/resiliency/business-metrics#composite-slas).

## Deploy this scenario

To establish the private connectivity, follow these instructions:

**Prerequisites**
- An Azure App Service web app
- A deployed Azure SQL Database

### Azure portal

1. In the Azure portal, [create a Virtual Network](/azure/virtual-network/quick-create-portal) using the address range `10.1.0.0/16`, and [create two subnets](/azure/virtual-network/virtual-network-manage-subnet#add-a-subnet) within it:
   - The `PrivateLinkSubnet` (address range `10.1.1.0/24`) used to expose the private endpoint of the database.
   - The `AppSvcSubnet` (address range `10.1.2.0/24`) used for the web app's regional VNet Integration.

   
1. On the database, [create the private endpoint](/azure/private-link/create-private-endpoint-portal#create-a-private-endpoint) in the `PrivateLinkSubnet`.
  - Note that when using the Azure Portal, the easiest way to configure the private endpoint (including the approval step and DNS Private Zones integration) is through the **Private endpoint connections** page on the logical SQL Server resource.
  - The **Resource type** for the connection is `Microsoft.Sql/servers`, the **Resource** is the logical SQL Server you want to expose, and the **Target sub-resource** is `sqlServer`.
    ![Private Endpoint Resource](media/appsvc-private-sql-private-endpoint-create-resource.png)
  - Make sure to **Integrate with private DNS zone**, which will register the database server's private IP address in the `privatelink.database.windows.net` private zone.
    ![Private Endpoint Configuration](media/appsvc-private-sql-private-endpoint-create-configuration.png)
1. On the web app, [enable regional VNet Integration](/azure/app-service/web-sites-integrate-with-vnet#enable-vnet-integration) with the `AppSvcSubnet`.
    ![Regional Virtual Network Integration](media/appsvc-private-sql-regional-vnet-integration.png)
  - Note that if you configure this via the web app's **Networking** page in the Azure Portal, the required delegation of the subnet to `Microsoft.Web` is performed automatically.
  - If not, make sure to [delegate the subnet](/azure/virtual-network/manage-subnet-delegation#delegate-a-subnet-to-an-azure-service) to `Microsoft.Web` manually.
- Still on the web app, [add the configuration settings](/azure/app-service/configure-common#configure-app-settings) required to make the integration work:
  - Set `WEBSITE_Virtual Network_ROUTE_ALL` to `1` and `WEBSITE_DNS_SERVER` to `168.63.129.16`.
    ![Web App Configuration Settings](media/appsvc-private-sql-webapp-settings.png)
- That's it! Your web application should now be able to connect to the database over the private IP address.
  - To validate, set the database firewall to **Deny public network access** which ensures that only traffic is allowed over the private endpoint.
  - If the web app cannot connect, use the [Virtual Network integration troubleshooting guidance](/azure/app-service/web-sites-integrate-with-vnet#troubleshooting) to ensure that the hostname of the SQL Database resolves to its private IP address, using *nameresolver.exe*.
  - Keep using the regular hostname for the SQL Database in the connection string, for example `contoso.database.windows.net`, not the `privatelink`-specific hostname.

### Azure Resource Manager (ARM) template

A slightly more advanced version of this scenario is available as an [Azure Resource Manager QuickStart Template](https://azure.microsoft.com/resources/templates/301-web-app-regional-vnet-private-endpoint-sql-storage/), where a web app accesses both a SQL Database and a Storage Account over private endpoints. These endpoints are in a different Virtual Network from the App Service integrated Virtual Network, to demonstrate how this solution works across peered Virtual Networks.

![Architecture diagram from QuickStart Template](https://github.com/Azure/azure-quickstart-templates/raw/master/301-web-app-regional-vnet-private-endpoint-sql-storage/images/solution-architecture.png "Solution Architecture from QuickStart Template")

## Pricing

There's no additional cost for the App Service regional VNet Integration feature in a supported pricing tier of Standard or above. Standard is a minimum recommendation for production workloads. 

The Azure Private Link service that enables the database's private endpoint has an associated cost based on an hourly fee plus a premium on bandwidth. See the [Private Link pricing page](https://azure.microsoft.com/pricing/details/private-link/) for details.

To explore the cost of running this scenario, all the services mentioned above are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/f25225ef92824212ae34f837c22d519c) with reasonable default values for a small scale application. To see how the pricing would change for your use case, change the appropriate variables to match your expected usage.

## Related resources

For more details on inbound and outbound scenarios for App Service, and which features to use in which cases, see the [App Service networking features overview].
