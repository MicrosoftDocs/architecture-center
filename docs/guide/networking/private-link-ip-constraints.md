# Use Private Link to consume applications on networks with overlapping address spaces

Situations with overlapping IP address space are commonly found when networks to be connected are from different customers, different companies inside a holding, or companies without a centralized IP address management (IPAM) methodology.
 
Azure provides several options to connect different networks: VPN or ExpressRoute provide hybrid connectivity between cloud and customer on-premises facilities, and Vnet Peering is used to connect two Virtual Networks. All these solutions, however, have a common restriction: the networks on both sides of the connection cannot use overlapping IP addresses to be able to establish the connection. If networks have the same address space, traffic cannot be routed successfully between the two networks.  
 
This article is focused on how you can use Azure Private Link to overcome overlapping IP address space constraints. It provides general guidance on how to expose applications running inside one virtual network on Azure to consumers in another virtual network with an overlapping IP address space.

## What Azure Private Link services is and what it provides
 
Azure Private Link is the technology that enables the access to Azure hosted customer-owned/partner services and Azure PaaS Services over a Private Endpoint from your virtual network. Traffic between your virtual network and the service is kept private inside Microsoft Azure network backbone. Exposing your service to the public Internet is optional after configuring your Private Endpoint.

Azure Private Link Service allows you to expose your application deployed in one Azure Virtual Network into another different Virtual Network using the Azure Private Link technology. As depicted on Figure 1, we are interested in exposing an application on Network B to be consumed from Network A that shares the same IP address prefix. 

image

Figure 1 Accessing an application with overlapping IP addresses without Private Link Service

Virtual machines on Network A would be able to access the application that is running on the remote Network B seamlessly. The same Private Endpoint would be accessible from on-premises if required.
 
For more information about Private Link you can check the overview article of  [What is Azure Private Link service?] 

## How to deploy your application with Private Link
 
In order to be able to expose your application inside Network A through Azure Private Link Service, it should meet some prerequisites. You can find all of them in the “Details” section of the  following documentation article [What is Azure Private Link service?]. 

The most important one is that your application must be deployed inside an Azure Virtual Network. It is not possible to use this service when the application with the overlapping address space is deployed on-premises and you need to access it from Azure. 

If prerequisites are met, you can follow the QuickStart guides available to deploy your Private Link Service through [Azure Portal], [PowerShell], [CLI] or [ARM templates].  
 
After you have deployed your Private Link Service, our initial scenario described in Figure 1 evolves now into a Private Link enabled architecture described on Figure 2. 

image 

Figure 2 Accessing an application with overlapping IP addresses using Private Link Service
 
Although both networks continue having overlapping IP address spaces, now the communication is possible between them without any software-based overlay network or customer’s NAT solution. 

## Operational considerations
 
### Networking 

All traffic coming to your application would appear to originate from an IP address on the destination Virtual Network associated with the Private Link Service. Figure 3 shows the IP addresses that both customer and application would see as their respective sources and destination IP addresses. If your application requires actual source IP address of the customer initiating the connection, Private Link supports the Proxy protocol that provides a convenient way to safely transport connection information such as a client's address across multiple layers of NAT or TCP proxies. 

More details about how to use Proxy protocol is available in the article [Getting connection Information using TCP Proxy v2].  

image 

Figure 3 Source NAT of inbound traffic using Azure Private Link Service
 
 
Finally, you should review the Azure subscription limits and quotas page to check the limits associated with Private Link and dimension your solution accordingly.
 
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
Ivens Applyrs  | Product Manager 2
Jose Angel Fernandez Rodrigues | SR Specialist GBB


Other contributors: 
Shane Bala | Program Manager 2
Sumeet Mittal | Principal Product Manager


Next Steps:
Create a Private Link Service –-> Quickstart - Create a Private Link service by using the Azure portal - Azure Private Link | Microsoft Learn

Related resources:
Referred to in the article 
