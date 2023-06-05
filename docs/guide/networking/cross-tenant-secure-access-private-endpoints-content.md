Like most Azure platform as a service (PaaS) services, Azure web apps and function apps can be accessed from the internet by default. If you want to restrict the inbound traffic to a web app or function app, Azure provides two built-in options: access restrictions and private endpoints.

If you use access restrictions, you can configure the internal firewall of the resource by defining lists of allow and deny rules. You can base the restrictions on IP addresses (IPv4 and IPv6) or service tags, or you can use service endpoints to restrict access. When you use service endpoints, only traffic from selected subnets and virtual networks can access your app. There's no cost to use access restrictions, and they're available in all Azure App Service and Azure Functions plans. But access restrictions have some drawbacks. Maintaining allow and deny rules can be challenging. Also, to allow a third party to consume your service, you need to list its IP address in an allow rule. Some third-party services have dynamic IPs, and some organizations view IP addresses as sensitive.

The second built-in option, a private endpoint, gives clients in your private network secure access to your app over Azure Private Link. A private endpoint uses an IP address from your Azure virtual network address space. The network traffic between a client in your private network and the app traverses the virtual network and Private Link on the Microsoft backbone network. This solution eliminates exposure to the public internet. You can also use private endpoints to form ad hoc connections among Azure tenants. Specifically, you can create a secure site-to-point virtual private network (VPN) tunnel. The tunnel can run from a consumer virtual network in one tenant to an Azure web app or function app in another tenant. This approach eliminates the need to set up and maintain site-to-site VPNs or virtual network peerings.

This guide presents an architecture that uses the private endpoint option. The private endpoint securely exposes an Azure web app in one tenant to a client that consumes the app in another Azure tenant. You can also use this approach for a function app if you have a Premium or App Service plan for Functions.

## Architecture

:::image type="content" source="./images/cross-tenant-secure-access-private-endpoints-architecture.svg" alt-text="Architecture diagram that shows how a private endpoint securely connects a user on a virtual machine in one tenant with a web app in another tenant." lightbox="./images/cross-tenant-secure-access-private-endpoints-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-2025459-cross-tenant-secure-access-private-endpoints.vsdx) of this architecture.*

### Dataflow

1. A user or service on a virtual machine (VM) submits a DNS request for an Azure web app at `webapp.azurewebsites.net`. The web app runs in a provider tenant.
1. The Azure public DNS service handles the query for `webapp.azurewebsites.net`. The response is a CNAME record, `webapp.privatelink.azurewebsites.net`.
1. An Azure DNS private zone handles the DNS query for `webapp.privatelink.azurewebsites.net`.
1. The response is an A record with the IP address of a private endpoint.
1. The VM issues an HTTPS request to the Azure web app via the IP address of the private endpoint.
1. The web app handles the request and responds to the VM.
1. If the user or service doesn't have access to the private DNS zone, the Azure public DNS service resolves the DNS query to `webapp.privatelink.azurewebsites.net` by returning a public IP address. HTTPS requests to that public IP address receive a *403 Forbidden* response.

### Components

- [App Service](https://azure.microsoft.com/products/app-service) and its [Web Apps](https://azure.microsoft.com/products/app-service/web) feature provide a framework for building, deploying, and scaling web apps.
- [Functions](https://azure.microsoft.com/products/functions) is an event-driven serverless compute platform.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks through Virtual Network.
- [Private Link](https://azure.microsoft.com/products/private-link) provides a private endpoint in a virtual network. You can use the private endpoint to connect to Azure PaaS services or to customer or partner services.
- [Azure DNS](https://azure.microsoft.com/products/dns) is a hosting service for DNS domains. Azure DNS uses Azure infrastructure to provide name resolution. The private Azure DNS service manages and resolves domain names in a virtual network and in connected virtual networks. When you use this service, you don't need to configure a custom DNS solution.
- An [Azure DNS private zone](https://azure.microsoft.com/products/dns) contains records that you can't resolve from the internet. DNS resolution only works from virtual networks that are linked to the private zone.
- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) offers many sizes and types of on-demand, scalable computing resources.

## Provider setup

The first step is to secure the Azure web app within the tenant that owns it. The goal is to ensure that the web app is no longer available on the public internet. You can achieve this goal by creating a private endpoint on the Azure web app.

Web apps and function apps become immediately inaccessible publicly when they're associated with a private endpoint. If you want to turn on public access again, you can do so via the access restriction settings. Other Azure services are still publicly available after you associate them with a private endpoint. These services require additional access controls to become inaccessible.

Before you activate the private endpoint, have a virtual network and subnet ready where you can deploy the NIC of the private endpoint. This step consumes an IP address of the subnet. Also, define your DNS strategy. You need to register an A record of the NIC in the DNS zone.

- If you use the DNS services that Azure provides by default, we recommend that you use the Azure DNS private zone service and allow automatic integration during the creation of the private endpoint. This approach ensures that:
  - The private DNS zone (`privatelink.azurewebsites.net`) is created automatically if needed.
  - The DNS zone is linked to the virtual network of the private endpoint's NIC.
  - The A record is registered and managed automatically in the private DNS zone.

- If you don't use the DNS services that Azure provides by default, you must configure and manage your own DNS servers and zones:
  1. Create a `privatelink.azurewebsites.net` DNS zone.
  1. Ensure that `privatelink.azurewebsites.net` can be resolved in the virtual networks that need to resolve the NIC of the private endpoint.
  1. Register the A record in the `privatelink.azurewebsites.net` DNS zone with the IP address of the private endpoint.
  1. Depending on your setup, possibly configure a DNS forwarder to resolve the Azure DNS public zone, `azurewebsites.net`.

  For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

In both cases, during the creation of the private endpoint, the Azure DNS public zone (`azurewebsites.net`) is automatically updated with the CNAME record that points to the private DNS zone. Users can try to reach the web app from sources that can't resolve the private DNS zone to retrieve the actual A record and its internal IP address. Those users get a public resolvable IP address, but the response is *403 Forbidden*.

## Consumer setup

The next step is to enable a client in another tenant to reach the Azure web app of the provider. The consumer initiates this setup. Manual approval by the provider is required to activate the connection.

### Step 1 (consumer): Create a private endpoint

On the consumer side, the setup process starts by creating a private endpoint resource. As with the provider, the consumer needs to have a virtual network and subnet ready where the NIC of the private endpoint can be deployed. This step consumes an IP address of the subnet. There are no constraints on the private IP range of that virtual network. It's okay to have overlapping IP ranges in the provider and consumer tenants.

The consumer doesn't own the target resource, so the full resource ID of the Azure web app in the provider tenant must be used. That resource ID contains the provider's subscription ID, the name of the resource group, and the name of the Azure web app resource. As a result, we recommend that the provider share this information with the consumer in a secure way. Currently it's not possible to use an alias. Some Azure resources have multiple subresources. For instance, an Azure Storage resource has *blob*, *table*, *queue*, *file*, *web*, and *Dfs* subresources. The provider must also provide information about the subresources. Azure web apps and function apps have only one subresource, *sites*. For more information about private endpoint subresources and their values, see [Private-link resource](/azure/private-link/private-endpoint-overview#private-link-resource). Because the connection of the private endpoint isn't automatically approved, the consumer can provide a message for the provider to read.

It's not possible to automate the DNS zone integration setup. As a result, the consumer needs to manually configure the DNS records as explained in [Step 3](#step-3-consumer-dns-setup).

When the private endpoint resource has been created, the connection status is *Pending*. The connection remains in this unusable state until the provider approves the request.

### Step 2 (provider): Review and approve the connection request

The provider doesn't get a notification that there's a pending private endpoint connection request. The consumer needs to inform the provider when a request has been made.

The provider can retrieve, review, and approve or reject pending requests in the Azure portal in either of the following places:

- On the **Private Link Center** page. The approver can enter an approval message on this page.
- On the **Networking** blade of the web app, by selecting **Private endpoints**.

Alternatively, the provider can use the Azure CLI or Azure PowerShell to retrieve, review, and approve or reject the pending requests.

The provider can read the message that's provided when the private endpoint was created. The provider can also see the name that the consumer gave the private endpoint. In the Azure CLI and Azure PowerShell, the consumer's tenant ID, resource group name, and private endpoint resource name are also available. The Azure portal hides this information somewhat—it creates a hyperlink to the private endpoint of the consumer. Because the consumer is in a different tenant, it's typically not accessible by the provider.

It's not possible to automate the process of approving private endpoint connections. In contrast, with Private Link, you can use the auto-approval property to preapprove a set of subscriptions for automated access to the service.

### Step 3 (consumer): DNS setup

You can take the steps in this section immediately after you create the private endpoint resource in step 1. But to avoid having to repeat tasks, we recommend that you wait until the provider approves the connection.

The consumer needs to set up and configure the private DNS zone to make sure its clients can find the NIC of the private endpoint. As with the provider, the DNS strategy in the tenant determines the required steps.

- If the consumer uses the DNS services that Azure provides by default, we recommend that you use the Azure DNS private zone service. If needed, the consumer creates the private DNS zone `privatelink.azurewebsites.net` and links it to a virtual network that contains the NIC of the private endpoint. Automatic registration isn't needed for this DNS zone. The next step is for the consumer to add a new DNS configuration:

  1. In the Azure portal, search for and select the private endpoint.
  1. Open the **DNS configuration** blade.
  1. Select the private DNS zone and provide a connection name to add a new DNS configuration.

  These actions create the A record in the private DNS zone. The FQDN is populated automatically when the connection is approved.

- If the consumer manages their own DNS zones, the consumer needs to configure their environment as described earlier in [Provider setup](#provider-setup).

In this guide's architecture, the consumer VM uses the private endpoint to access the Azure web app. That access is possible as soon as the connection is approved and the DNS has been configured correctly.

## Connection management

Both the provider and the consumer can manage the private endpoint connection after it's created and approved.

- The consumer can remove the connection directly via the private endpoint resource, the **Private Link Center** page, the Azure CLI, or Azure PowerShell. The producer doesn't need to be involved.
- The provider can remove the connections to its service via the **Networking** blade of the Azure web app, the Azure CLI, or Azure PowerShell. As soon as the private endpoint is deleted, the consumer is blocked from accessing the service. The consumer sees that the connection on the private endpoint has the status *Disconnected* and that the DNS record is removed from the private DNS zone. The consumer needs to delete the private endpoint resource manually.

It's not possible to temporarily pause or disable a connection. After the consumer or the provider deletes a connection, you have to create a new private endpoint to restore the connection.

## Cost optimization

In contrast to access restrictions, which are free, private endpoints come with fixed and variable costs for both the provider and consumer.

### Fixed costs

- The [duration of the private endpoint](https://azure.microsoft.com/pricing/details/private-link)
- The [number of DNS zones](https://azure.microsoft.com/pricing/details/dns)

### Variable costs

- The [volume of data that's processed on the private endpoint](https://azure.microsoft.com/pricing/details/private-link)
- The [bandwidth charges if the Azure web app and the private endpoint are deployed in different regions](https://azure.microsoft.com/pricing/details/bandwidth)
- The [number of DNS queries](https://azure.microsoft.com/pricing/details/dns)

VMs aren't included in this pricing overview because they're not an absolute requirement for the architecture.

## Other considerations

- The provider needs to share the subscription ID, the resource group name, and the Azure web app resource name with the consumer. Similarly, the consumer shares the subscription ID, the resource group name, and the private endpoint resource name with the provider.
- There are limits to the number of private endpoints that you can create in a subscription. But because the private endpoints are created in the consumer subscriptions, this limit shouldn't be a problem. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).
- The subscription that contains the Private Link resource must be registered with the Microsoft network resource provider. The subscription that contains the private endpoint must also be registered with the Microsoft network resource provider. For more information, see [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
- If you have connectivity problems, see [Troubleshoot Azure private endpoint connectivity problems](/azure/private-link/troubleshoot-private-endpoint-connectivity). In particular, verify the DNS configuration.

## Deploy this scenario

For a GitHub repo with Bicep templates that you can use to deploy this architecture, see [Project Cross-Tenant Secure Access to Azure Web Apps and Azure Functions with Private Endpoints](https://github.com/Azure/Secure-Cross-Tenant-Azure-App-Access-with-Private-Endpoints).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Robbie De Sutter](https://www.linkedin.com/in/robbiedesutter) | Digital Cloud Solution Architect

Other contributor:

- [Rajkumar (Raj) Balakrishnan](https://www.linkedin.com/in/raj-microsoft) | Digital Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure RBAC permissions for Azure Private Link](/azure/private-link/rbac-permissions)
- [Restrict your storage account to a virtual network (for Functions))](/azure/azure-functions/configure-networking-how-to#restrict-your-storage-account-to-a-virtual-network)
- [Microsoft Azure Well-Architected Framework - Security](/azure/architecture/framework/security)
- [Set up Azure App Service access restrictions](/azure/app-service/app-service-ip-restrictions)
- [Using private endpoints for Azure web app](/azure/app-service/networking/private-endpoint)
- [Azure Functions networking options](/azure/azure-functions/functions-networking-options)
- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Manage Azure private endpoints](/azure/private-link/manage-private-endpoint)
- [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Multitenancy and Azure Private Link](/azure/architecture/guide/multitenant/service/private-link)

## Related resources

- [Improved-security access to multitenant web apps from an on-premises network](../../example-scenario/security/access-multitenant-web-app-from-on-premises.yml)
- [Multi-tier app service with private endpoint](../../example-scenario/web/multi-tier-app-service-private-endpoint.yml)
- [Azure Private Link in a hub-and-spoke network](./private-link-hub-spoke-network.yml)