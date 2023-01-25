Like most Azure platform as a service (PaaS) services, Azure web apps and Azure Functions are publicly available on the internet by default. If you want to restrict the inbound traffic to a web app or function app, Azure provides two built-in options: access restrictions and private endpoints.

Access restrictions provide a way for you to configure the internal firewall of the resource by defining lists of allow and deny rules. You can base the restrictions on IP addresses (IPv4 and IPv6) or service tags, or you can use service endpoints to restrict access. When you use service endpoints, only traffic from selected subnets and virtual networks can access your app. There's no cost to use access restrictions. And they're available in all Azure App Service and Azure Functions plans. But access restrictions have some drawbacks. Maintaining allow and deny rules can be challenging. Also, to allow a third party to consume your service, you need to list its IP address in an allow rule. Some third party services have dynamic IPs, and some organizations view IP addresses as sensitive.

The second built-in option, a private endpoint, gives clients in your private network secure access to your app over Azure Private Link. A private endpoint uses an IP address from your Azure virtual network address space. The network traffic between a client in your private network and the app traverses the virtual network and Private Link on the Microsoft backbone network. This solution eliminates exposure to the public internet. You can also use private endpoints to form ad hoc connections among Azure tenants. Specifically, you can create a secure site-to-point VPN tunnel from a consumer virtual network in one tenant to an Azure web app or function app in another tenant. This approach eliminates the need to set up and maintain site-to-site VPNs or virtual network peerings, which limit the services that a client can access.

This guide discusses the use of a private endpoint to securely expose an Azure web app in one tenant to a client that consumes the app in another Azure tenant. You can also use this approach for Azure Functions if you have a Premium or App Service plan.

## Architecture

:::image type="content" source="./images/cross-tenant-secure-access-private-endpoints-architecture.png" alt-text="Architecture diagram that shows how a private endpoint provides a virtual machine in one tenant with access to a web app in another tenant." lightbox="./images/cross-tenant-secure-access-private-endpoints-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-2025459-cross-tenant-secure-access-private-endpoints.vsdx) of this architecture.*

### Dataflow

1. A user or service on a virtual machine (VM) submits a DNS request for an Azure web app at `webapp.azurewebsites.net`. The client and the web app are in separate tenants.
1. The public Azure DNS service handles the query for `webapp.azurewebsites.net`. The response is a CNAME-record, `webapp.privatelink.azurewebsites.net`.
1. A private Azure DNS zone handles the DNS query for `webapp.privatelink.azurewebsites.net`.
1. The response is an A-record with the IP address of a private endpoint.
1. The VM issues an HTTPS request to the Azure web app via the IP address of the private endpoint.
1. The web app handles the request and responds to the VM.

If the user or service doesn't have access to the private DNS zone, the public Azure DNS service resolves the DNS query to `webapp.privatelink.azurewebsites.net` by returning a public IP address. HTTPS requests to that public IP address receive a *403 Forbidden* response.

### Components

- [App Service](https://azure.microsoft.com/products/app-service) and its [Web Apps](https://azure.microsoft.com/products/app-service/web) feature provide a framework for building, deploying, and scaling web apps.
- [Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks through Virtual Network.
- [Private Link](https://azure.microsoft.com/products/private-link) provides a private endpoint in a virtual network. You can use the private endpoint to connect to Azure PaaS services or to customer or partner services.
- [Azure DNS](https://azure.microsoft.com/products/dns) is a hosting service for DNS domains. Azure DNS uses Azure infrastructure to provide name resolution. The private Azure DNS service manages and resolves domain names in a virtual network and in connected virtual networks. When you use this service, you don't need to configure a custom DNS solution.
- An [Azure DNS private zone](https://azure.microsoft.com/products/dns) contains records that you can't resolve from the internet. DNS resolution only works from virtual networks that are linked to the private zone.
- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) offers many sizes and types of on-demand, scalable computing resources.

## Provider setup

The first step is to secure the Azure web app within the tenant that owns it. The goal is to ensure that the web app is no longer available on the public internet. You can achieve this goal by creating a private endpoint on the Azure web app.

Web Apps and Functions become immediately inaccessible publicly when they're associated with a private endpoint. If you want to turn on public access again, you can do so via the access restriction settings. Other Azure services are still publicly available after you associate them with a private endpoint. They require additional access controls to become inaccessible.

Before you activate the private endpoint, have a virtual network and subnet ready where you can deploy the NIC of the private endpoint. This step consumes an IP address of the subnet. Also, define your DNS strategy. You need to register an A record of the NIC in the DNS zone.

- If you use the DNS services that Azure provides by default, we recommend that you use the Azure private DNS zone service and allow automatic integration during the creation of the private endpoint. This approach ensures that:
  - The private DNS zone (`privatelink.azurewebsites.net`) is created automatically if needed.
  - The DNS zone is linked to the virtual network of the private endpoint's NIC.
  - The A record is registered and managed automatically in the private DNS zone.

- If you don't use the DNS services that Azure provides by default, you must configure and manage your own DNS servers and zones:
  - Create a `privatelink.azurewebsites.net` DNS zone.
  - Ensure that `privatelink.azurewebsites.net` can be resolved in the virtual networks that need to resolve the NIC of the private endpoint.
  - Register the A-record in the `privatelink.azurewebsites.net` DNS zone.
  - Depending on your setup, possibly configure a DNS forwarder to resolve the Azure service public DNS zone, `azurewebsites.net`.

  For more information, see [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).

In both cases, during the creation of the private endpoint, the Azure service public DNS zone (`azurewebsites.net`) is automatically updated with the CNAME record that points to the private DNS zone. Users can try to reach the web app from sources that can't resolve the private DNS zone to retrieve the actual A record and its internal IP address. Those users get a public resolvable IP address, but the response is *403 Forbidden*.

The provider VM can access the Azure web app because the private DNS zone is linked to the virtual network of the VM. The VM can reach the private endpoint because it resides in the same subnet.

## Consumer setup

The next step is to enable a client in another tenant to reach the Azure web app of the provider. The consumer initiates this setup. It requires a manual approval step by the provider to activate the connection.

### Step 1 (consumer): Create a private endpoint

The first step is to create a private endpoint resource on the consumer side. As with the provider, the consumer needs to have a virtual network and subnet ready where the NIC of the private endpoint can be deployed. This step consumes an IP address of the subnet. There are no constraints on the private IP range of that virtual network. It's okay to have overlapping IP ranges in the provider and consumer tenants.

The consumer doesn't own the target resource, so the full resource ID of the Azure web app in the provider tenant must be used. That resource ID contains the provider's subscription ID, the name of the resource group, and the name of the Azure web app resource. As a result, we recommend that the provider shares this information with the consumer in a secure way. Currently it's not possible to use an alias. Some Azure resources have multiple subresources. For instance, an Azure Storage resource has blob, table, queue, file, web, and Dfs subresources. The provider must also provide information about the subresources. Azure web apps and function apps have only one subresource, sites. For more information about private endpoint subresources and their values, see [Private-link resource](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource). Because the connection of the private endpoint isn't automatically approved, the consumer can provide a free-text message for the provider to read.

It's not possible to automate the DNS zone integration setup. As a result, the consumer needs to manually configure the DNS records as explained in [Step 3](#step-3-consumer-dns-setup).

When the private endpoint resource has been created, the connection status is *Pending*. The connection remains in this unusable state until the provider approves the request.

### Step 2 (provider): Review and approve the connection request

The provider doesn't get a notification that there's a pending private endpoint connection request. As a results, the consumer needs to inform the provider that such a request has been made.

The provider can retrieve, review, and approve or reject pending requests in the Azure portal in either of the following places:

- On the **Private Link Center** page. The approver can enter a description for the approval request on this page.
- On the **Networking** page of the web app, by selecting **Private endpoints**.

Alternatively, the provider can use the Azure CLI or Azure PowerShell to retrieve, review, and approve or reject the pending requests.

The provider can read the free-text message that's provided when the private endpoint was created. The provider can also see the name that the consumer gave the private endpoint. In the Azure CLI and Azure PowerShell, the consumer's tenant ID, resource group name, and private endpoint resource name are also available. The Azure portal hides this information somewhat, because it creates a hyperlink to the private endpoint of the consumer. But because the consumer is in a different tenant, it's typically not accessible by the provider.

It's not possible to automate the process of approving private endpoint connections. In contrast, with Private Link, you can use the auto-approval property to preapprove a set of subscriptions for automated access to the service.

### Step 3 (consumer): DNS setup

You can take the steps in this section immediately after you create the private endpoint resource in step 1. But to avoid having to repeat steps, we recommend that you wait until the provider approves the connection.





