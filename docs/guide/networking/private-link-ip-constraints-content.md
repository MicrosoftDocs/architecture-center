Overlapping IP address spaces commonly occur when connected networks are from different customers, different companies within a holding company, or companies that don't have a centralized IP address management (IPAM) methodology.
 
Azure provides several ways to connect networks: Azure VPN Gateway and Azure ExpressRoute provide hybrid connectivity between the cloud and customer on-premises facilities, and you can use virtual network peering to connect two virtual networks. These solutions, however, have a common restriction: the networks being connected can't use overlapping IP addresses to establish connection. If two networks use the same address space, traffic can't be routed between them.  
 
This article describes how you can use [Azure Private Link](https://azure.microsoft.com/products/private-link) to overcome overlapping IP address space constraints. It provides general guidance on how to expose applications that run in one virtual network on Azure to consumers in another virtual network that has an overlapping IP address space.

## What is Azure Private Link?
 
Private Link enables access to Azure-hosted customer-owned, partner, and Azure PaaS services over a private endpoint from your virtual network. Traffic between your virtual network and the service is kept more private inside the Azure network backbone. Exposing your service to the public internet is optional after you configure your private endpoint.

Private Link service is the reference to your own service that's powered by Private Link. You can use Private Link service to expose an application that's deployed in one Azure virtual network into another virtual network. The following diagram provides an example. Assume that you want to expose an application on Network B so that it can be consumed from Network A, which shares the same IP address prefix.

:::image type="content" source="images/without-private-link.png" alt-text="Diagram that shows overlapping IP addresses without Private Link service." lightbox="images/without-private-link.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-ip-constraints.pptx) of the architecture diagrams in this article.* 

You want virtual machines on Network A to be able to seamlessly access the application that runs on the remote Network B. The same private endpoint should be accessible from on-premises, if required.
 
For more information about Private Link, see [What is Azure Private Link service?](/azure/private-link/private-link-service-overview#details). 

## How to deploy your application with Private Link
 
Your application needs to meet some prerequisites if you want to expose it in Network A by using Private Link service. You can find the prerequisites in the [Details](/azure/private-link/private-link-service-overview#details) section of **What is Azure Private Link service?**. 

The most important prerequisite is that your application must be deployed in an Azure virtual network. You can't use Private Link service when the application with the overlapping address space is deployed on-premises and you need to access it from Azure. 

After the prerequisites are met, you can follow the steps in one of the available quickstart guides to deploy your private link service. These quickstart guides describe how to use the [Azure portal](/azure/private-link/create-private-link-service-portal#create-a-private-link-service), [PowerShell](/azure/private-link/create-private-link-service-powershell#create-a-private-link-service), [Azure CLI](/azure/private-link/create-private-link-service-cli#create-a-private-link-service), or [ARM templates](/azure/private-link/create-private-link-service-template).  
 
After you deploy your Private Link service, the scenario shown in the preceding diagram evolves into an architecture that uses Private Link: 

:::image type="content" source="images/private-link-diagram.png" alt-text="Diagram that shows how to access an application that has overlapping IP addresses via Private Link service." lightbox="images/private-link-diagram.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-ip-constraints.pptx) of the architecture diagrams in this article.*  

Although the networks have overlapping IP address spaces, communication is now possible between them. No software-based overlay network or customer NAT solution is required. 

## Operational considerations
 
### Networking

All traffic coming to your application will appear to originate from an IP address on the destination virtual network that's associated with the Private Link service. The following diagram shows the IP addresses that both the customer and application will see as their source and destination IP addresses. If your application requires the actual source IP address of the customer that's initiating the connection, Private Link supports the Proxy protocol. This protocol provides a convenient way to transport, with enhanced security, connection information like a client's address across multiple layers of NAT or TCP proxies.

For more information, see [Getting connection Information using TCP Proxy v2](/azure/private-link/private-link-service-overview#getting-connection-information-using-tcp-proxy-v2).  

:::image type="content" source="images/inbound-traffic-source.png" alt-text="Diagram that shows the source NAT of inbound traffic." lightbox="images/inbound-traffic-source.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-ip-constraints.pptx) of the architecture diagrams in this article.* 
 
Finally, you should review [Azure subscription limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits#private-link-limits) to check the limits associated with Private Link, and size your solution accordingly.
 
### Access control 

Private Link supports virtual networks in a single subscription, across subscriptions in a single Azure Active Directory (Azure AD) tenant, and across subscriptions in different Azure AD tenants. If you need to control who can create private endpoints inside their virtual networks to access your application, Private Link service supports granular access through its **Visibility** property. For information on how to configure the visibility options of your Private Link service, see [Control service access](/azure/private-link/private-link-service-overview#control-service-access).

### Name resolution
 
After you deploy a private endpoint in your virtual network, the application can be accessed over the IP address of the private endpoint. However, if your application requires the use of a specific domain name, you need to configure domain name resolution. Private Link doesn't automatically register the application's domain name in a DNS. You need to register its FQDN and the IP address of the private endpoint in your DNS. 
 
You can use Azure DNS and private Azure DNS zones as the DNS server for your application. For more information, see [Create public DNS zone](/azure/dns/dns-getstarted-portal) or [Create a private DNS zone](/azure/dns/private-dns-getstarted-portal).

For information about providing transparent DNS resolution for your customers, see [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration).
 
### Cost
 
The subscription where the application is deployed won't incur any charges for Private Link service. However, from the consumer point of view, private endpoint hourly rates and inbound/outbound data processing rates apply. If the consumer virtual network isn't in the same Azure region as the application, standard data transfer rates also apply. 

For more information, see [Azure Private Link pricing](https://azure.microsoft.com/pricing/details/private-link) and [Bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth). 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Ivens Applyrs](https://www.linkedin.com/in/ivens-applyrs) | Product Manager 2
- [Jose Angel Fernandez Rodrigues](https://www.linkedin.com/in/jangelfdez) | Senior Specialist GBB


Other contributors: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
- [Shane Bala](https://www.linkedin.com/in/sudarshan-bala) | Program Manager 2
- [Sumeet Mittal](https://www.linkedin.com/in/mittalsumeet) | Principal Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Private Link service?](/azure/private-link/private-link-service-overview)
- [Create a Private Link service by using the Azure portal](/azure/private-link/create-private-link-service-portal)
- [Create a public DNS zone](/azure/dns/dns-getstarted-portal) 
- [Create a private DNS zone](/azure/dns/private-dns-getstarted-portal)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)

## Related resources

- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale)
- [Azure Private Link in a hub-and-spoke network](../../guide/networking/private-link-hub-spoke-network.yml)
- [Azure DNS Private Resolver](../../example-scenario/networking/azure-dns-private-resolver.yml)