This reference architecture shows how to set up secure private connectivity to a multitenant web app or function app from a on-premises network or from within an Azure virtual network. It also shows how to set up improved-security connectivity with between the app and other Azure PaaS services over Azure Private Link, without using the public internet. 

## Potential use cases

- Access a multitenant web app or function app privately with improved security over its [private endpoint](/azure/private-link/private-endpoint-overview) from the on-premises network or from within an Azure virtual network. 
- Connect from a web app or function app to Azure platform as a service (PaaS) offerings:
   - Another web app
   - Azure SQL Database
   - Azure Storage
   - Azure Key Vault 
   - Any other service that supports Azure private endpoints for inbound connectivity 

## Architecture

![Diagram that shows the reference architecture for secure access to multitenant web apps from an on-premises network.](./images/multitenant-web-apps.png)

*Download a [Visio file](https://arch-center.azureedge.net/multitenant-web-apps.vsdx ) of this architecture.*

This diagram illustrates the following architecture: 
- By using Azure App Service [regional virtual network integration](/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration), the web app connects to Azure services through delegated subnet *VNet Integration Subnet* in an Azure virtual network.
   -	The App Service *VNet Integration Subnet* and *Private Endpoint Subnet* are in separate virtual networks. Both of these networks are peered with *Hub Virtual Network* as part of a hub-and-spoke network configuration. For regional virtual network integration, the peered virtual networks must be located in the same Azure region.
- [Azure Private Link](/azure/private-link/private-link-service-overview) sets up a [private endpoint](/azure/private-link/private-endpoint-overview) for the PaaS services, web apps, Azure SQL database, Azure storage account, and Azure key vault in *Private Endpoint Virtual Network*.
- The on-premises network and Azure virtual networks can be connected via [Site-to-Site (S2S) VPN](/azure/vpn-gateway/tutorial-site-to-site-portal) or [Azure ExpressRoute private peering](azure/expressroute/expressroute-circuit-peerings#privatepeering). Users in the on-premises network access the app privately and with improved security over the private network only.

   In this example, the on-premises network and Azure virtual networks are connected via ExpressRoute private peering.
- For an on-premises network that already has a Domain Name System (DNS) solution in place, the on-premises DNS solution is configured to forward DNS traffic to Azure DNS via a [conditional forwarder](azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server). The conditional forwarder references the DNS forwarder deployed in Azure. This DNS forwarder in Azure resolves all the DNS queries via a server-level forwarder to the Azure-provided DNS service [168.63.129.16](azure/virtual-network/what-is-ip-address-168-63-129-16).

   The resolution is done by a [private DNS zone linked to the virtual network](azure/dns/private-dns-overview). 

   Private DNS zones are also deployed in the same subscription as *Private Endpoint Virtual Network*.

   In this example, A DNS forwarder machine in the on-premises network (192.168.0.254) forwards all DNS resolution requests to the hostname azurewebsites.net to the DNS forwarder VM in Azure (10.0.0.132). This VM forwards all requests to the Azure-provided DNS service IP address 168.63.129.16.

   This app service configuration should be present:

   |Key  |Value   |
   |----------|-----------|
   |WEBSITE_DNS_SERVER     |168.63.129.16       |

- Virtual networks are linked to all the Azure private DNS zones.
  - The virtual network that has private endpoints is automatically linked to the private DNS zones. You need to link the other virtual networks separately.
- The web app communicates with the private endpoints of the PaaS services in *Private Endpoint Virtual Network* via Azure Firewall.
- On Azure Firewall, the [application rules](azure/private-link/inspect-traffic-with-azure-firewall) are configured to allow communication between *VNet Integration Subnet* and the private endpoints of PaaS resources. 
The target FQDNs are:
  - *.azurewebsites.net
  -	*.database.windows.net
  -	*.core.windows.net
  -	*.vaultcore.azure.net
- Firewall and virtual network configuration for Azure SQL, Azure Storage Account, and Azure Key Vault allows traffic only from *VNet Integration Subnet*. The configuration doesn't allow communication with any other virtual network or with the public internet.

### Components
- [Azure App Service](https://azure.microsoft.com/services/app-service) hosts web applications and function apps, allowing autoscale and high availability without having to manage infrastructure.
 - [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.
 - [Azure Storage Account](https://azure.microsoft.com/product-categories/storage) provides a unique namespace for Azure Storage data that's accessible from anywhere in the world over HTTP or HTTPS. It contains all of the Azure Storage data objects: blobs, file shares, queues, tables, and disks.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) is a service for securely storing and accessing API keys, passwords, certificates, cryptographic keys, or any other secrets used by cloud apps and services.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks through Virtual Networks.
- [Azure Private Link](https://azure.microsoft.com/services/private-link) provides a Private Endpoint in a Virtual Network for connectivity to Azure PaaS services like Azure Storage and SQL Database, or to customer or partner services.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) Private Peering extends on-premises networks into the Microsoft cloud over a private connection. Site-to-site VPN could also be established between on-premises and Azure network, instead of Azure ExpressRoute.
-	[Azure Firewall](https://azure.microsoft.com/services/azure-firewall) is a managed, cloud-based network security service that protects Azure Virtual Network resources. 
-	[Private DNS Zone](azure/dns/private-dns-overview) provides a reliable and secure DNS service, to manage and resolve domain names in the virtual network.

### Alternatives

An alternative approach for private connectivity is to use [App Service Environment](azure/app-service/environment/intro) for hosting the Web Application within an isolated environment. For database, [Azure SQL Managed Instance](azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) can be natively deployed within a Virtual Network, so there's no need for VNet Integration or Private Endpoints. These offerings are typically more costly, because they provide single-Tenant isolated deployment and other features.
If you have an App Service Environment but aren't using SQL Managed Instance, you can still use a Private Endpoint for private connectivity to a SQL Database. If you already have SQL Managed Instance but are using multi-tenant App Service, you can still use regional VNet Integration to connect to the SQL Managed Instance private address.

For some of the other Azure services like Key Vault or Storage Account, there is no alternative but to use Private Endpoints for secure and private connections from Web App.

## Considerations

The following considerations apply to this scenario.

### Security
Using Private Endpoint for your Web App enables you to:
- Secure your Web App by configuring the Private Endpoint, eliminating public exposure.
- Securely connect to Web App from on-premises networks that connect to the VNet using a VPN or ExpressRoute private peering. Inbound connections to the Web App are allowed from the on-premises network or from within the Azure virtual network only.
- Avoid any data exfiltration from your VNet.

You can further secure the inbound connection to the web app by fronting the app with a service like [Application Gateway](azure/application-gateway/overview) or [Azure Front Door](azure/frontdoor/front-door-overview), optionally with [Web Application Firewall](azure/web-application-firewall/overview) capabilities. When you enable Private Endpoint to your Web App, the [access restrictions](azure/app-service/app-service-ip-restrictions) configuration of the Web App is not evaluated.

This scenario also secures the outbound connection from an App Service Web App to a downstream dependency like a database, Storage or Key Vault. 

Application routing can be configured to either route all traffic or only private traffic (also known as [RFC1918](https://datatracker.ietf.org/doc/html/rfc1918#section-3) traffic) into your VNet. This behavior is configured through the ‘Route All’ setting. If [Route All](azure/app-service/web-sites-integrate-with-vnet#application-routing) is disabled, web app only routes private traffic into your VNet. To block traffic to public addresses, you must ensure you enable Route All setting to the VNet. A [Network security group](azure/virtual-network/security-overview/) can also be used to block outbound traffic to resources in your VNet or the Internet. When Route All is not enabled, NSGs are only applied to RFC1918 traffic.

In this example, the Web App does not need to communicate with any service that is not present within the virtual network, so ‘Route All’ setting is enabled.

An important security consideration in this scenario is how to configure the Firewall of PaaS resources.

### SQL Database firewall options

Without using private connectivity, you can add [firewall rules](azure/azure-sql/database/firewall-create-server-level-portal-quickstart) that allow inbound traffic from specified IP address ranges only. Another approach is to [allow Azure services](azure-sql/database/network-access-controls-overview#allow-azure-services) to access the server, which locks down the firewall to allow only traffic from within Azure. However, this traffic includes all Azure regions and other customers.

You can also add a more restrictive firewall rule to allow only your app's [outbound IP addresses](azure/app-service/overview-inbound-outbound-ips#find-outbound-ips) to access the database. But because App Service is a multi-tenant service, these IP addresses are shared with and allow traffic from other customers on the same [deployment stamp](azure/architecture/patterns/deployment-stamp), which uses the same outbound IP addresses.

Using private connectivity through the Virtual Network provides the following firewall options to prevent others from accessing the database:
- Create a [virtual network rule](azure/azure-sql/database/vnet-service-endpoint-rule-overview) that allows traffic only from the regional VNet Integration delegated subnet, ‘VNet Integration Subnet’ in this example. The delegated subnet must have a [Service Endpoint](azure/virtual-network/virtual-network-service-endpoints-overview) configured for Microsoft.Sql, so the database can identify traffic from that subnet.
-	Configure the firewall to [Deny public network access](azure/azure-sql/database/connectivity-settings#deny-public-network-access), which turns off all other firewall rules and makes the database accessible only through its Private Endpoint.

The option of denying public network access is the most secure configuration but means that database access is only possible by going through the Virtual Network that hosts the Private Endpoint. To connect to the database, anything other than the web app must have direct connectivity to the Virtual Network.

For example, deployments or urgent manual connections from SQL Server Management Studio (SSMS) on local machines can't reach the database except through VPN or ExpressRoute connectivity into the Virtual Network. You could also remotely connect to a VM in the Virtual Network and use SSMS from there. For exceptional situations, you could temporarily allow public network access, and reduce risk by using other configuration options.

### Storage Account and Key Vault firewall options

Storage accounts and Key Vaults have a public endpoint that is accessible from the internet. You can also create [Private Endpoints for your storage account](azure/storage/common/storage-private-endpoints) and [Key Vault](azure/key-vault/general/private-link-service?tabs=portal) which assigns these services a private IP address from your VNet and secures all traffic between your VNet and the respective service over a private link. 

When Private Endpoint is created, the VNet Integration Subnet can access the service securely and privately over a private link. But the Storage account and Key Vault will still be accessible from other Azure virtual networks. To block access from any other virtual network, create the Service Endpoint too for this delegated subnet.

### Availability

Azure Private Link supporting App Service is available in all public regions. For Azure SQL Database, Azure Storage and Azure Key Vault, the Private Link service is available in all public as well as government regions.

Private Link introduces an additional component and availability consideration into the architecture. The Private Link service has an [availability SLA of 99.99%](https://azure.microsoft.com/support/legal/sla/private-link/), which must be taken into account when calculating the composite SLA of the entire solution.

### Scalability

For information about integrating Azure Private Link for PaaS services with Azure Private DNS zones in hub and spoke network architectures, see [Private Link and DNS integration at scale](azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

### Global peering 

Any service in any Azure region that can connect through the Virtual Network can reach the PaaS services’ private endpoints, for example through [Virtual Network peering](virtual-network/virtual-network-peering-overview) in hub-and-spoke topologies. However, for App Service regional VNet Integration, the peered Virtual Networks must be located in the same Azure region.

Lack of global peering support means you can't use this solution for cross-region connectivity from App Service to a database or other private endpoint in another Azure region. For example, this solution wouldn't work for a multi-regional deployment to support a partial failover, in which the web app remains active in one region but must connect to a failed-over database in another region, or vice versa. But other solutions exist for this situation. See [Multi-region web app with private connectivity to database](azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region) for an architecture that supports partial failovers when either the web app or the database fails over to another region.

To connect Web App to a VNet in another region, Gateway-required VNet Integration can be set-up. The limitation is that gateway-required VNet Integration can’t be used with a VNet connected with Azure ExpressRoute.

## Logging and monitoring

Azure Private Link is integrated with [Azure Monitor](azure/azure-monitor/overview), which allows you to see if data is flowing.

Connection Troubleshoot service from [Network Watcher](azure/private-link/troubleshoot-private-endpoint-connectivity) can also be used to trace the connectivity from a VM in a VNet to the FQDN of the Private Endpoint resource.

## Pricing

There's no additional cost for App Service regional VNet Integration in a supported pricing tier of Standard or above. But Private Endpoints for Web Apps are only supported on Elastic Premium, Premium V2, Premium V3 Plans. 

The Azure Private Link service that enables the Private Endpoints for PaaS services has an associated cost based on an hourly fee plus a premium on bandwidth. See the [Private Link pricing](https://azure.microsoft.com/pricing/details/private-link) page for details. Connections from a client virtual network to the Azure Firewall in the hub virtual network will incur charges. Connections from Azure Firewall in the hub virtual network to Private Endpoints in a peered virtual network are not charged.

Azure Private DNS Zone costs are based on the number of DNS zones hosted in Azure and the number of received DNS queries.

To explore the cost of running this scenario, all the mentioned services are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/004f18af0e4344d7acbabfc212930138) with reasonable default values for a small scale application. To see how the pricing would change for your use case, change the appropriate variables to match your expected usage.

## Next steps

-	Step-by-step guidance on how to [Integrate Azure Functions with an Azure virtual network by using private endpoints](https://docs.microsoft.com/azure/azure-functions/functions-create-vnet)
-	Steps to configure [Azure Firewall Application rules to inspect traffic destined to Private Endpoints in different network topologies](azure/private-link/inspect-traffic-with-azure-firewall)
- For more information on inbound and outbound scenarios for App Service, and which features to use in which case, see the [App Service networking features overview](azure/app-service/networking-features).
- For more information about Private Endpoints for Azure Web Apps, see [Using Private Endpoints for Azure Web App](azure/app-service/networking/private-endpoint)
- For more information about integrating multitenant Web Apps with Azure virtual network, see [Integrate your app with an Azure virtual network](azure/app-service/web-sites-integrate-with-vnet)
-	The FQDN of some of the PaaS services may resolve automatically to a public IP address. For more information about overriding the DNS configuration to connect to the Private Endpoint, see [Azure Private Endpoint DNS configuration](azure/private-link/private-endpoint-dns)

## Related resources

- For information about a similar reference architecture, see [Web app private connectivity to Azure SQL database](azure/architecture/example-scenario/private-web-app/private-web-app)
- Learn how to [Integrate Azure Functions with an Azure virtual network by using private endpoints](azure/azure-functions/functions-create-vnet)
