Overlapping IP address spaces are commonly found when connected networks are from different customers, different companies within a holding company, or companies that don't have a centralized IP address management (IPAM) methodology.
 
Azure provides several ways to connect networks: Azure VPN Gateway and Azure ExpressRoute provide hybrid connectivity between the cloud and on-premises facilities, and you can use virtual network peering to connect two virtual networks. These solutions, however, have a common restriction: the networks on either side of the connection can't use overlapping IP addresses to establish connection. If two networks use the same address space, traffic can't be routed between them.  
 
This article describes how you can use [Azure Private Link](https://azure.microsoft.com/products/private-link) to overcome overlapping IP address space constraints. It provides general guidance on how to expose applications running in one virtual network on Azure to consumers in another virtual network that has an overlapping IP address space.

## What is Azure Private Link?
 
Private Link enables access to Azure-hosted customer-owned, partner, and Azure PaaS services over a private endpoint from your virtual network. Traffic between your virtual network and the service is kept private inside the Azure network backbone. Exposing your service to the public internet is optional after you configure your private endpoint.

You can use Private Link to expose an application that's deployed in one Azure virtual network into another virtual network. The following diagram provides an example. Assume that you want to expose an application on Network B so that it can be consumed from Network A, which shares the same IP address prefix.

:::image type="content" source="images/without-private-link.png" alt-text="Diagram that shows overlapping IP addresses without Private Link." lightbox="images/without-private-link.png" border="false":::

You want virtual machines on Network A to be able to seamlessly access the application that's running on the remote Network B. The same private endpoint should be accessible from on-premises, if required.
 
For more information about Private Link, see [What is Azure Private Link service?](/azure/private-link/private-link-service-overview#details). 

## How to deploy your application with Private Link
 
Your application needs to meet some prerequisites if you want to expose it in Network A via Private Link. You can find the prerequisites in the [Details](/azure/private-link/private-link-service-overview#details) section of **What is Azure Private Link service?**. 

The most important prerequisite is that your application must be deployed in an Azure virtual network. You can't use Private Link when the application with the overlapping address space is deployed on-premises and you need to access it from Azure. 

After the prerequisites are met, you can follow the steps in one of the available quickstart guides to deploy your private link service. You can use the [Azure portal](/azure/private-link/create-private-link-service-portal#create-a-private-link-service), [PowerShell](/azure/private-link/create-private-link-service-powershell#create-a-private-link-service), [Azure CLI](/azure/private-link/create-private-link-service-cli#create-a-private-link-service), or [ARM templates](/azure/private-link/create-private-link-service-template).  
 
After you deploy your private link service, the scenario shown in the preceding diagram evolves into an architecture that uses Private Link: 

private-link-diagram.png 

Figure 2 Accessing an application with overlapping IP addresses using Private Link Service
 
Although both networks continue having overlapping IP address spaces, now the communication is possible between them without any software-based overlay network or customer’s NAT solution. 

## Operational considerations
 
### Networking 

All traffic coming to your application would appear to originate from an IP address on the destination Virtual Network associated with the Private Link Service. Figure 3 shows the IP addresses that both customer and application would see as their respective sources and destination IP addresses. If your application requires actual source IP address of the customer initiating the connection, Private Link supports the Proxy protocol that provides a convenient way to safely transport connection information such as a client's address across multiple layers of NAT or TCP proxies. 

More details about how to use Proxy protocol is available in the article [Getting connection Information using TCP Proxy v2].  

image 

Figure 3 Source NAT of inbound traffic using Azure Private Link Service
 
 
Finally, you should review the [Azure subscription limits and quotas] page to check the limits associated with Private Link and dimension your solution accordingly.
 
### Access Control 

Azure Private Link supports virtual networks in the same subscription, across subscriptions in the same Azure AD tenant, or across subscriptions in different Azure AD tenants. If you need to control who can create a Private Endpoint inside their virtual network to access your application, Private Link service supports a granular access through its "Visibility" setting. You can find more details on how to configure the visibility options of your Private Link Service in the article [Control service access] 

### Name resolution
 
After deploying a Private Endpoint in your virtual network, the application is accessible over the IP address of the Private Endpoint. However, if your application requires using a specific domain name to connect to, you will need to configure the domain name resolution. Azure Private Link doesn't automatically register the application’s domain name in a DNS. You must register its FQDN and IP address of the Private Endpoint in your DNS yourself. 
 
Azure DNS and Azure Private DNS Zones can be used as the DNS server for your application. You can review the following articles to know more about [how to create your public] or [private DNS Zone].

As a reference, you can follow the same approach of Azure Private Link enabled services to provide a transparent DNS resolution for your customers. You can review the article [Azure Private Endpoint DNS configuration] for more details
 
### Cost
 
Private Link service has no charges associated with the subscription where the application is deployed. However, from the consumer point of view, both Private Endpoint hourly rate and inbound/outbound data processed would be charged. If the consumer virtual network is in a different Azure region where the application is deployed, standard data transfer rates apply on top of that. 

More details are available in the pricing page of [Azure Private Link] and [Bandwidth]. 

Contributors

Principal Authors: 
- Ivens Applyrs  | Product Manager 2
- Jose Angel Fernandez Rodrigues | SR Specialist GBB


Other contributors: 
- Mick Alberts 
- Shane Bala | Program Manager 2
- Sumeet Mittal | Principal Product Manager


Next Steps:
Create a Private Link Service –-> Quickstart - Create a Private Link service by using the Azure portal - Azure Private Link | Microsoft Learn

Related resources:
Referred to in the article 
