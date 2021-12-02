This article describes how to set up an [Azure web app](https://azure.microsoft.com/services/app-service/web) in a network environment that enforces strict policies for inbound and outbound network flows. In such cases, the web app can't be directly exposed to the internet. Instead, all traffic needs to go through an [Azure firewall](/azure/firewall) or a third-party network virtual appliance.

The example shows a scenario in which a web app is protected with [Azure Front Door](/azure/frontdoor) and an Azure firewall. It connects with improved security to an [Azure SQL database](/azure/azure-sql).

## Potential use cases

These use cases have similar design patterns:

- Connect from a web app or an [Azure function](/azure/azure-functions) to any platform as a service (PaaS) offering that supports [Azure Private Link private endpoints](/azure/private-link/private-endpoint-overview) for inbound network flows. Examples include Azure Storage, Azure Cosmos DB, and other web apps.
- Connect from a web app or an Azure function to a [virtual machine](/azure/virtual-machines) in the cloud or on-premises by using virtual private networks or [Azure ExpressRoute](/azure/expressroute).

## Architecture

:::image type="content" source="./media/hardened-web-app.png" alt-text="Diagram that shows an architecture for setting up a web app in a high-security environment." lightbox="./media/hardened-web-app.png":::

*Download a [Visio file](https://arch-center.azureedge.net/hardened-webapp-architecture.vsdx) of this architecture.*

1. An Azure Front Door instance provides [Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) features and terminates SSL connections from clients.
2. A custom fully qualified domain name (FQDN) is chosen to represent the back-end web app and is mapped through CNAME or A DNS records to the public IP address of an Azure firewall or third-party network virtual appliance.
3. A private endpoint for the web app is created in a virtual network subnet (*subnet-privatelink* in the example).
3. The Azure firewall or third-party network virtual appliance is deployed in a virtual network (*Hub Virtual Network* in the example) and configured to perform destination NAT (DNAT) of incoming requests to the private IP address of the private endpoint associated with the web app.
4. The wep app is assigned the custom FQDN through the [domain verification ID property of the web app](/Azure/app-service/manage-custom-dns-migrate-domain#bind-the-domain-name-preemptively). This allows the custom FQDN already mapped to the public IP of the Azure firewall or third-party network virtual appliance to be reused with the web app without altering Domain Name System (DNS) name resolution and network flows.
5. The web app connects to a virtual network subnet (*subnet-webapp* in the example) through regional VNet integration. The **Route All** flag is enabled, which forces all outbound traffic from the web app into the virtual network and allows the web app to inherit the virtual network's DNS resolution configuration, including custom DNS servers and integration with [private DNS zones](/azure/dns) used for private endpoint name resolution.
7. A custom [route table](/azure/virtual-network/virtual-networks-udr-overview#custom-routes) that's attached to the web app subnet (*subnet-webapp* in the example) forces all outbound traffic that comes from the web app to go to the Azure firewall or third-party network virtual appliance.
8. One or more private DNS zones link to the virtual network that contains the web app (*Spoke Virtual Network* in the example) to allow DNS resolution of PaaS resources deployed with private endpoints.
9. A private endpoint for Azure SQL is created in a virtual network subnet (*subnet-privatelink* in the example). A corresponding DNS record is created on the matching private DNS zone.
10. The web app can now be accessed only through Azure Front Door and Azure Firewall. It can also establish a connection to the Azure SQL instance through private endpoint, securing the communication over private IP only.



### Components

- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) provides Azure Web Application Firewall features and terminates SSL connections from clients.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) provides security to the web app. 
- [Azure App Service](https://azure.microsoft.com/services/app-service) allows you to create web apps and deploy them in a cloud infrastructure. 
- [Azure Private Link private endpoints](/azure/private-link/private-endpoint-overview) allow you to connect privately and with improved security to Azure services.
- [Azure SQL](https://azure.microsoft.com/products/azure-sql) connects to the web app via a private endpoint. 


### Alternatives

- You can deploy the wep app to an internal [App Service Environment](/azure/app-service/environment/overview) to provide isolation from the public internet. This example uses a web app within App Service to reduce operating costs.
- You can replace Azure Front Door with an [Azure application gateway](/azure/application-gateway) if you also need to deploy the Web Application Firewall component of the solution behind a firewall or within a virtual network.

## Considerations

The solution deploys an Azure Front Door instance, which terminates SSL connections from clients and provides a rich set of Web Application Firewall configurations. We recommend that you further lock down your applications to accept traffic coming only from your Azure Front Door instance. You can do this in several ways, depending on the network virtual appliance you're using and your application configuration. Some options include:

- Configuring your Azure firewall or network virtual appliance to accept traffic only from the **AzureFrontDoor.Backend** [Azure IP ranges](https://www.microsoft.com/download/details.aspx?id=56519).
- Configuring your network virtual appliance to integrate with [Azure service tags](/azure/virtual-network/service-tags-overview).
- Configuring your application to accept traffic only from your Azure Front Door instance by validating request headers.

For more information, see [How do I lock down the access to my backend to only Azure Front Door?](/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door-?). 

The solution also uses an Azure SQL server that accepts traffic only through a private endpoint, locking down traffic that comes from external sources. The web app used in the solution is configured to ensure proper DNS resolution of private endpoints and allow secure communication with the SQL Server instance. 

When you deploy resources that use private endpoints in your environments, it's important to configure your DNS infrastructure properly. For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

### Availability

Azure Front Door is a global service with built-in availability and redundancy and a high [SLA](https://azure.microsoft.com/support/legal/sla/frontdoor/v1_0).

Azure Firewall features [built-in availability and a high SLA](/azure/firewall/features#built-in-high-availability). You can deploy it to span multiple [availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones/#overview) to [increase the SLA](/azure/firewall/features#availability-zones). If you use a third-party or custom network virtual appliance, you can achieve the same SLA targets by configuring your deployment to use availability sets or availability zones.

Azure web apps support built-in availability. You can deploy them across [multiple availability zones](/azure/app-service/how-to-zone-redundancy).

You can further increase the availability of the solution by spreading it across multiple [Azure regions](https://azure.microsoft.com/global-infrastructure/geographies/#overview). You can accomplish this by deploying new instances of all components (except Azure Front Door) to other Azure regions and then configuring the original Azure Front Door instance with [multiple back-end targets](/azure/frontdoor/front-door-backend-pool). If you use Azure SQL as your data store, you can then [join multiple servers to an auto-failover group to enable transparent and coordinated failover of multiple databases](/azure/azure-sql/database/auto-failover-group-overview).

See these reference architectures to learn about deploying highly available web applications in Azure and setting up multi-region SQL Server instances to work with private endpoints:

- [Highly available multi-region web application](/azure/architecture/reference-architectures/app-service-web-app/multi-region)  
- [Multi-region web app with private connectivity to a database](/azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region)

You can use [Azure Monitor](/azure/azure-monitor) to monitor all components of this solution.
You can use [Monitor Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) to monitor logs related to the web application firewall and network inspection rules of Azure Front Door and Azure Firewall. You can use [Monitor Application Insights](/azure/azure-monitor/azure-monitor-app-hub) to monitor performance and availability and gain insights into your use of web applications.

### Scalability

All components of the solution either provide transparent built-in scalability or expose a rich set of features, like [Azure web app autoscale](/azure/azure-monitor/autoscale/autoscale-best-practices#manual-scaling-is-reset-by-autoscale-min-and-max), for scaling the number of available instances.

## Deploy this scenario

### Prerequisites

- An Azure account. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free) before you start.
- A publicly routable domain. Additionally, you must have permissions to create two DNS records in your public DNS zone.
- A valid SSL certificate to use for your web app.

### Walkthrough

The solution is made up of several [Bicep](/azure/azure-resource-manager/bicep) files that deploy the required infrastructure. You can download the files from [GitHub](https://github.com/Azure/hardened-webapp/tree/main/deploy). 

The `main.bicep` file deploys the base infrastructure by using Bicep modules from these files:
- `network.bicep`
- `webapp.bicep`
- `firewall.bicep`
- `sql.bicep`
- `frontdoor.bicep`
- `routetable.bicep`

1. [Install Bicep](/azure/azure-resource-manager/bicep/install) and deploy `main.bicep` by using either [Azure PowerShell](/azure/azure-resource-manager/bicep/install#azure-powershell) or [Azure CLI](/azure/azure-resource-manager/bicep/install#azure-cli). The Bicep file has preconfigured parameters for deploying all resources.

   For example, if you're using Azure PowerShell:

   ```powershell
   New-AzResourceGroupDeployment -ResourceGroupName [resourceGroupName] -Name [frontDoorDeployment] -TemplateFile .\frontdoor.bicep
   ```

   You'll be asked to provide the `customBackendFqdn` and `sqladministratorLoginPassword` parameters upon deployment.

2. Copy and save the public IP address that's assigned to the Azure firewall after deployment. You'll need it in a later step. The IP is also provided as output of the deployment of `main.bicep`.
   
   :::image type="content" source="./media/public-ip.png" alt-text="Screenshot that shows the public IP address." lightbox="./media/public-ip.png":::

3. Copy and save the custom domain verification ID of the web app that you just created. The custom domain verification ID is also provided as output of the deployment of `main.bicep`.

    :::image type="content" source="./media/domain-id.png" alt-text="Screenshot that shows the custom domain verification ID." lightbox="./media/domain-id.png":::

4. Copy and save the name of the Azure SQL Server instance you just created. The FQDN of the server name is also provided as output of the deployment of `main.bicep`.

    :::image type="content" source="./media/sql.png" alt-text="Screenshot that shows the name of the Azure SQL Server instance." lightbox="./media/sql.png":::

5. Sign in to the website of your domain provider.

   > [!NOTE]
   > Every domain provider has its own DNS records interface, so consult the provider's documentation. Look for areas of the site labeled *Domain Name*, *DNS*, or *Name Server Management*.
   >
   > You can often find the DNS records page by viewing your account information and then looking for a link such as *My domains*. Go to that page and look for a link that's named something like *Zone file*, *DNS records*, or *Advanced configuration*.


6. Create an A record with the public IP that you just obtained.

   Here's an example of a DNS records page after the A record is created:
   
   :::image type="content" source="./media/dns-records-1.png" alt-text="Screenshot that shows a DNS records page." lightbox="./media/dns-records-1.png":::

   > [!NOTE]
   > If you want, you can use Azure DNS to manage DNS records for your domain and configure a custom DNS name for App Service. For more information, see [Tutorial: Host your domain in Azure DNS](/azure/dns/dns-delegate-domain-azure-dns).

7. Create a TXT record with the custom domain verification ID of the web app you just deployed. Doing so allows you to reuse the custom FQDN record for which you just created an A record and add it to the web app in the following steps.

   Create the TXT record in the format `asuid.<subdomain>`. For example, if your custom FQDN is `backend.contoso.com`, you'd create this record:

   `asuid.backend.contoso.com TXT [DOMAIN VERIFICATION ID]`

   For more information, see [Tutorial: Map an existing custom DNS name to Azure App Service - Create the DNS records](/Azure/app-service/app-service-web-tutorial-custom-domain?tabs=cname#4-create-the-dns-records).

   Here's an example of a DNS records page after the TXT record is created:
   
   :::image type="content" source="./media/dns-records-2.png" alt-text="Screenshot that shows the DNS records page after the TXT record is created." lightbox="./media/dns-records-2.png":::

8. Map the custom domain to the web app that you just created. For more information, see [Tutorial: Map an existing custom DNS name to Azure App Service - Get a domain verification ID](/Azure/app-service/app-service-web-tutorial-custom-domain?tabs=cname#3-get-a-domain-verification-id).

9. Upload an SSL certificate that matches your custom FQDN to your web app. For more information, see [Tutorial: Secure a custom DNS name with a TLS/SSL binding in Azure App Service](/Azure/app-service/configure-ssl-bindings).

   You should now be able to access your web app by using the public FQDN of the Azure Front Door instance.

**Optional steps**

If you want, you can also [bind a custom FQDN domain to Azure Front Door](/azure/frontdoor/front-door-custom-domain) and [configure HTTPS for the custom domain](/azure/frontdoor/front-door-custom-domain-https).

1. You can verify that connectivity from the web app to the Azure SQL Server instance is happening over a private channel by creating a [virtual machine](/azure/virtual-machines) in the same virtual network that you used earlier in this procedure. 
    1. Sign in to the virtual machine and go to `https://<web-app-name>.scm.azurewebsites.net`. You access the [Kudu diagnostic console](/azure/app-service/resources-kudu) from here. 
    1. Sign in. In the menu bar, select **Debug console --> CMD**.
    1. Enter the command `nameresolver <sql-name>.database.windows.net`. Use the Azure SQL Server name you obtained in step 4 of this walkthrough.

    You should see that the Azure SQL Server instance name is resolved with a private IP.

    Here's what DNS resolution of an Azure SQL Server instance looks like in the Kudu console:

    :::image type="content" source="./media/kudu.png" alt-text="Screenshot that shows DNS resolution in the Kudu console." lightbox="./media/kudu.png":::

13. You can also verify that outbound traffic from the web app goes through the Azure firewall. Enter this command in the Kudu console:
    - `curl -s ifconfig.co`

    The output should match the public IP address of the Azure firewall that you obtained in step 2.

    Here's what it looks like in the Kudu console:

    :::image type="content" source="./media/outbound.png" alt-text="Screenshot that shows the IP address in the Kudu console." lightbox="./media/outbound.png":::

## Pricing

The example scenario features a deployment within a hardened network environment. So an Azure firewall or third-party network virtual appliance most likely already exists in the target infrastructure.

The main consideration for the remaining infrastructure is the SKU of the App Service plan that hosts the web app. Private endpoints for web apps are [available only in the Premium SKUs](/azure/app-service/networking/private-endpoint).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your costs. Here are two possible pricing estimates:

- [Infrastructure, including Azure Firewall](https://azure.com/e/e836a805a5b04fd3a750f04c4bfef120)  
- [Infrastructure, excluding Azure Firewall](https://azure.com/e/200979762ace4d8096851edb92c13756)

## Next steps
- [Azure Web Apps deployment best practices](/azure/app-service/deploy-best-practices)
- [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview)

## Related resources
- [Azure Architecture Center](../../browse/index.yml) 
- [Microsoft Azure Well-Architected Framework](../../framework/index.md) 
- [Azure Firewall architecture overview](/azure/architecture/example-scenario/firewalls)
