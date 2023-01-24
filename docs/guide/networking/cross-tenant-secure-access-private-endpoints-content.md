Like most Azure platform as a service (PaaS) services, Azure web apps and Azure Functions are publicly available on the internet by default. If you want to restrict the inbound traffic to a web app or function app, Azure provides two built-in options: access restrictions and private endpoints.

Access restrictions provide a way for you to configure the internal firewall of the resource by defining lists of allow and deny rules. You can base the restrictions on IP addresses (IPv4 and IPv6) or service tags, or you can use service endpoints to restrict access. When you use service endpoints, only traffic from selected subnets and virtual networks can access your app. There's no cost to use access restrictions. And they're available in all Azure App Service and Azure Function plans. But access restrictions have some drawbacks. Maintaining allow and deny rules can be challenging. Also, to allow a third party to consume your service, you need to list its IP address in an allow rule. Some third party services have dynamic IPs, and some services view IP addresses as sensitive.

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