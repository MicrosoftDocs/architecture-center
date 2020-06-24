---
title: Azure Application Gateway and Azure Firewall
titleSuffix: Azure Example Scenarios
description: Learn options and best practices for using Azure Firewall and Azure Application Gateway in virtual networks.
author: erjosito
ms.date: 06/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Application security for virtual networks

Application and data security is extremely important when deploying Azure application workloads. You can implement protective measures like authentication or encryption in the application itself, and add more security in the network that contains the application. This article describes network security controls that you can implement in [Azure Virtual Networks] where you deploy applications, such as Azure Virtual Machines (VMs), Virtual Machine Scale Sets, or Azure Kubernetes Service (AKS).

First, decide whether to implement generic security like Azure Firewall, application-specific mechanisms like Azure Web Application Firewall in Azure Application Gateway, or both. These Azure services are complementary, so it can be difficult to know which is best for your workloads, or how to integrate both for optimal protection at both the network and the application layer. 

- [Azure Firewall][azfw-overview] is a managed next-generation firewall that offers *Network Address Translation (NAT)*, and packet filtering based on Layer 4 attributes like IP addresses and TCP/UDP ports, or application-based attributes for HTTP(S) or SQL. Azure Firewall leverages Microsoft threat intelligence to more effectively identify malicious IP addresses. For more information, see the [Azure Firewall documentation][azfw-docs].
- [Azure Application Gateway][appgw-overview] is a managed HTTP(S) full reverse proxy that can do SSL encryption and decryption, or inspect web payloads to detect attacks at the HTTP layer with its Web Application Firewall capabilities. For more information, see the [Application Gateway documentation][appgw-docs].
- Web Application Firewall running on top of the Application Gateway is a security-hardened device designed to operate facing the public internet, with a very limited attack surface. For more information, see the [Web Application Firewall documentation][waf-docs].

This article explains when to use each service, and when to use different design options that combine both services. In general, you use:

- [Azure Firewall only] when there are no web applications in the virtual network
- [Application Gateway only] when there are only web applications in the virtual network, and *Network Security Groups (NSGs)* are sufficient for egress filtering
- [Azure Firewall and Application Gateway in parallel], the most common design, when you want Azure Application Gateway to protect HTTP(S) applications from web attacks, and Azure Firewall to protect all other workloads and filter outbound traffic
- [Application Gateway before Azure Firewall], when you want Azure Firewall to inspect both inbound and outbound traffic for web and non-web applications, but also have the Application Gateway protect web workloads
- [Azure Firewall before Application Gateway], when you want to inspect traffic before it arrives at the Application Gateway

Variations of the previous basic designs include [on-premises application clients], [hub and spoke networks], and [Azure Kubernetes Service][aks-overview] implementations. You can add services like an [API Management][apim-overview] gateway, and you can replace the Azure resources with third-party [Network Virtual Appliances (NVAs)].

## Azure Firewall only

If there are no web-based workloads in the virtual network that can benefit from the extra protection of the Azure Web Application Firewall, use Azure Firewall only. The design in this case is relatively simple, but going over the different packets will help understand more complex designs.

The following *packet walk* example shows how a user accesses an application hosted on VMs from the public internet. The diagram includes only one VM for simplicity. For higher availability and scalability, you'd have multiple application instances behind a load balancer.

![Firewall only](./images/design1_500.png)

1. The client initiates the connection to the public IP address of the Azure Firewall:
   - Source IP address: ClientPIP
   - Destination IP address: AzFwPIP
2. The Azure Firewall [Destination NAT (DNAT) rule][azfw-dnat] translates the destination IP address to the application IP address inside the virtual network. The Azure Firewall also *Source NATs (SNAT)* the packet under certain circumstances. Azure Firewall always SNATs if it performs DNAT. For more information, see [Azure Firewall known issues][azfw-issues]. The VM sees the following IP addresses in the incoming packet:
   - Source IP address: 192.168.100.7 
   - Destination IP address: 192.168.1.4
3. The VM answers the application request, reverting source and destination IP addresses. This inbound flow doesn't require a *User-Defined Route (UDR)* because the source IP is Azure Firewall's IP address. Be sure to establish a UDR for outbound connections, making sure packets to the public internet don't bypass the Azure Firewall.
   - Source IP address: 192.168.1.4
   - Destination IP address: 192.168.100.7
4. Finally, Azure Firewall undoes the SNAT and DNAT operations, and delivers the response to the client:
   - Source IP address: AzFwPIP
   - Destination IP address: ClientPIP

- In this design, Azure Firewall inspects both the incoming connections from the public internet, and the outbound connections from the application subnet VM, using the UDR.

- The IP address `192.168.100.7` is one of the instances the Azure Firewall service deploys under the covers, here with the front-end IP address `192.168.1.4`. These individual instances are normally invisible to the Azure administrator, but noticing the difference is useful in some cases, such as when troubleshooting network issues.

- If traffic comes from a *virtual private network (VPN)* or [Azure ExpressRoute] gateway, the client initiates the connection to the VM's IP address, not to the firewall's IP address.

## Application Gateway only

When only web applications exist in the virtual network, and inspecting outbound traffic with NSGs is enough protection, there's no need for Azure Firewall. The main difference from Azure Firewall is that the Application Gateway doesn't act as a routing device with NAT, but behaves as a full reverse application proxy. Application Gateway terminates the web session from the client, and establishes a separate session with one of its backend servers.

The following *packet walk* example shows how a user accesses a web application hosted on VMs from the public internet. The situation is similar if the client comes from an on-premises network over a VPN or ExpressRoute gateway, except the client accesses the private IP address of the Application Gateway instead of the public one.

![Application Gateway only](./images/design2_500.png)

1. The client initiates the connection to the public IP address of the Azure Application Gateway:
   - Source IP address: ClientPIP
   - Destination IP address: AppGwPIP
2. The Application Gateway instance that receives the request terminates the connection from the client, and establishes a new connection with one of the back ends. The back end sees the Application Gateway instance as the source IP address. The Application Gateway inserts the *X-Forwarded-For HTTP* header with the original client IP address.
   - Source IP address: 192.168.200.7 (the private IP address of the Application Gateway instance)
   - Destination IP address: 192.168.1.4
   - X-Forwarded-For header: ClientPIP
3. The VM answers the application request, reverting source and destination IP addresses. The VM already knows how to reach the Application Gateway, so doesn't need a UDR.
   - Source IP address: 192.168.1.4
   - Destination IP address: 192.168.200.7
4. Finally, the Application Gateway instance answers the client:
   - Source IP address: AppGwPIP
   - Destination IP address: ClientPIP

- Azure Application Gateway adds metadata to the packet HTTP headers, such as the X-Forwarded-For header containing the original client's IP address. Some application servers need that information to serve geolocation-specific content, or for logging. For more information, see [How an application gateway works][appgw-networking].

- The IP address `192.168.200.7` is one of the instances the Azure Application Gateway service deploys under the covers, here with the front-end IP address `192.168.1.4`. These individual instances are normally invisible to the Azure administrator, but noticing the difference is useful in some cases, such as when troubleshooting network issues.

## Application Gateway and Azure Firewall in parallel

Due to its simplicity and flexibility, running Application Gateway and Azure Firewall in parallel is recommended for most scenarios.

In some situations, filtering outbound connections from the VMs with NSGs might be very complex or impossible. For example, if you want to allow connectivity to a specific Azure Storage Account but not others, you need *fully qualified domain name (FQDN)*-based filters. Hence this design is often used where FQDN-based filtering for egress traffic is required, for example when [limiting egress traffic from an Azure Kubernetes Services cluster][aks-egress].

Another reason for implementing this design is because there is a mix of web and non-web workloads in the virtual network. The Web Application Firewall protects inbound traffic to the web workloads, and the Azure Firewall inspects inbound traffic for the other applications.

The following diagram illustrates the traffic flow for inbound connections by a user outside of the virtual network.

![Application Gateway and Azure Firewall in parallel, ingress flow](./images/design3_ingress_500.png)

The following diagram illustrates the traffic flow for outbound connections to the public internet initiated for the VMs, for example to connect to backend systems or get operating system updates:

![Application Gateway and Azure Firewall in parallel, egress flow](./images/design3_egress_500.png)

The packet flow steps are the same as for the previous two design options.

## Application Gateway in front of Azure Firewall

Some organizations require all traffic to go through both Azure Firewall and WAF. The WAF provides protection at the application layer, and Azure Firewall acts as a central logging and control point. In this case, the Application Gateway and the Azure Firewall aren't sitting in parallel, but one after the other.

One limitation of this design is that Azure Firewall doesn't add much value for inbound web traffic, since the firewall only inspects legitimate traffic from the Application Gateway to the web application. This design also places additional pressure on Azure Firewall, due to the need to inspect web traffic.

In this design, the Web Application Firewall faces the public internet. Being the first line of defense, the WAF sets the source client IP address in the X-Forwarded-For header, making the original client IP address visible to the web server.

![Application Gateway before Azure Firewall](./images/design4_500.png)

Network traffic from the public internet follows this packet walk:

1. The client initiates the connection to the public IP address of the Azure Application Gateway:
   - Source IP address: ClientPIP
   - Destination IP address: AppGwPIP
2. The Application Gateway instance terminates the connection from the client, and establishes a new connection with one of the back ends. The UDR to `192.168.1.0/24` in the subnet of the Application Gateway forwards the packet to the Azure Firewall, yet preserving the destination IP towards the web application:
   - Source IP address: 192.168.200.7 (private IP address of the Application Gateway instance)
   - Destination IP address: 192.168.1.4
   - X-Forwarded-For header: ClientPIP
3. Azure Firewall doesn't SNAT the traffic, since it's going to a private IP address, and forwards the traffic to the application VM if rules allow it. For more information, see [Azure Firewall SNAT][azfw-snat]).
   - Source IP address: 192.168.200.7 (the private IP address of the Application Gateway instance that happens to handle this specific request)
   - Destination IP address: 192.168.1.4
   - X-Forwarded-For header: ClientPIP
4. The VM answers the request, reverting source and destination IP addresses. The UDR to `192.168.200.0/24` captures the packet sent back to the Application Gateway and redirects it to Azure Firewall, yet preserves the destination IP towards the Application Gateway.
   - Source IP address: 192.168.1.4
   - Destination IP address: 192.168.200.7
5. Here again the Azure Firewall doesn't SNAT the traffic, since it's going to a private IP address, and forwards the traffic to the Application Gateway.
   - Source IP address: 192.168.1.4
   - Destination IP address: 192.168.200.7
6. Finally, the Application Gateway instance answers the client:
   - Source IP address: AppGwPIP
   - Destination IP address: ClientPIP

Outbound flows from the VMs to the public internet go through Azure Firewall, as defined by the UDR to `0.0.0.0/0`.

## Application Gateway behind Azure Firewall

This design is motivated by the desire to have Azure Firewall filter and discard malicious packets before they reach the Application Gateway. Another benefit of this design is that the application gets the same public IP address for both inbound and outbound traffic. A downside of this design is that the application doesn't see the original source IP address of the web traffic, because Azure Firewall SNATs the packets as they come in to the virtual network.

![Application Gateway after Azure Firewall](./images/design5_500.png)

Network traffic from the public internet follows this packet walk:

1. The client initiates the connection to the public IP address of the Azure Firewall:
   - Source IP address: ClientPIP
   - Destination IP address: AzFWPIP
2. The Azure Firewall DNATs the web port, usually TCP 443, to the private IP address of the Application Gateway. Azure Firewall also SNATs when doing DNAT. For more information, see [Azure Firewall known issues][azfw-issues]:
   - Source IP address: 192.168.100.7 (the private IP address of the Azure Firewall instance)
   - Destination IP address: 192.168.200.4
3. The Application Gateway establishes a new session between the instance handling the connection and one of the back-end servers. Note that the original IP address of the client isn't in the packet:
   - Source IP address: 192.168.200.7 (the private IP address of the Application Gateway instance)
   - Destination IP address: 192.168.1.4
   - X-Forwarded-For header: 192.168.100.7
4. The VM answers the Application Gateway, reverting source and destination IP addresses:
   - Source IP address: 192.168.1.4
   - Destination IP address: 192.168.200.7
5. The Application Gateway replies to the SNAT source IP address of the Azure Firewall instance. Even if the connection is coming from a specific Application Gateway instance (.7), Azure Firewall sees the internal IP address of the Application Gateway (.4) as the source IP:
   - Source IP address: 192.168.200.4
   - Destination IP address: 192.168.100.7
6. Finally, the Azure Firewall undoes SNAT and DNAT and answers the client:
   - Source IP address: AzFwPIP
   - Destination IP address: ClientPIP

Even if the Application Gateway has no listeners configured for applications, it still needs a public IP address so Microsoft can manage it.

## On-premises clients

The preceding designs have all shown application clients coming from the public Internet. Many applications are also accessed from on-premises networks. Most of the preceding information and packet walks are the same, but there are some notable differences:

- A VPN gateway or ExpressRoute gateway is in front of Azure Firewall and/or Application Gateway.
- Web Application Firewall uses the private IP address of the Application Gateway.
- Azure Firewall doesn't support DNAT for private IP addresses. Therefore, use UDRs to send inbound traffic to Azure Firewall from the VPN or ExpressRoute gateways.
- Be careful with *forced tunneling*, which is using a default route like `0.0.0.0/0` from the on-premises network. For Azure Application Gateway, the default route needs to point to the public internet.

The following diagram shows the Azure Application Gateway and Azure Firewall parallel design, with application clients coming from an on-premises network connected to Azure over VPN or ExpressRoute:

![Hybrid design with VPN or ExpressRoute gateway](./images/hybrid_500.png)

Even if all clients are located on-premises or in Azure, both the Azure Application Gateway and the Azure Firewall need to keep their public IP addresses, so that Microsoft can manage the services.

## Hub and spoke topology

The designs in this article still apply in a *hub and spoke* topology, where shared resources in a central hub virtual network are connected to applications in separate spoke virtual networks via virtual network peerings.

![Hybrid design with VPN/ER Gateway and Hub and Spoke](./images/hubnspoke_500.png)

Some considerations for this topology include:

- Usually, the Azure Firewall, Application Gateway, and API Management gateway components all go to the hub virtual network.
- Having the Azure Application Gateway in a spoke would be difficult in some designs, because you can't have a default route like `0.0.0.0/0` in the Application Gateway subnet with a next hop to anything other than the internet.
- You can still define backend servers in the Application Gateway, even if they're in a peered virtual network.
- Pay special attention to UDRs in the spoke networks. When the application server receives traffic from a specific Azure Firewall instance, like the `.7` address in the previous examples, it should send return traffic back to the same instance. If a UDR in the spoke sends traffic addressed to the hub to the Azure Firewall IP address, like the `.4` address in the previous examples, return packets might end up on a different Azure Firewall instance, causing asymmetric routing.
- A route table isn't always needed, but you need to verify that the next hop for the Azure Application Gateway subnet and the Azure Firewall subnet is the virtual network.

## Integration with other products

You can integrate Azure Firewall and Azure Application Gateway with other Azure and third-party products and services.

### API Management Gateway

You can integrate reverse proxy services like API Management Gateway into the previous designs, to provide functionality like API throttling or authentication proxy. Integrating an API Management gateway doesn't greatly alter the designs. The main difference is that instead of the single Application Gateway reverse proxy, there are two reverse proxies chained behind each other.

For more information, see the [Design Guide to integrate API Management and Application Gateway in a virtual network][appgw_apim] and the application pattern [API Gateways for Microservices][app-gws].

### Azure Kubernetes Service

For workloads running on an AKS cluster, you can deploy Azure Application Gateway independently of the AKS cluster, or you can integrate it with the AKS cluster using the [Azure Application Gateway Ingress Controller][agic_overview]. The benefit of this integration is that when configuring certain objects at the Kubernetes levels such as services and ingresses, the Application Gateway automatically adapts without needing additional manual steps.

Azure Firewall plays an important role in AKS cluster security, since it offers the required functionality to filter egress traffic from the AKS cluster based on FQDN and not just IP address, as documented in [Limiting egress traffic from an AKS cluster][aks-egress].

When using Application Gateway and Azure Firewall together to protect an AKS cluster, it's best to use the parallel design option. The Application Gateway with WAF processes inbound connection requests to web applications in the cluster, and the Azure Firewall only permits explicitly allowed outbound connections.

### Azure Front Door

Azure Front Door functionality partly overlaps with Azure Application Gateway. For example, both services offer web application firewalling, SSL offloading, and URL-based routing. One main difference is that while Azure Application Gateway is deployed inside of a virtual network, Azure Front Door is a global, decentralized service. In some situations, you can simplify virtual network design by replacing Application Gateway with a decentralized Azure Front Door. Even in that case, most of the designs described in this document are valid, except for the option of placing Azure Firewall in front of Azure Front Door.

For more information about the differences between the two services, or when to use which one, see [Frequently Asked Questions section for Azure Front Door][afd-vs-appgw].

### Other network virtual appliances

Microsoft products aren't the only choice to implement web application firewall or next-generation firewall functionality in Azure. A wide range of Microsoft partners provide products in this space. The concepts and designs in this article are essentially the same, but there might be some important considerations:

- Partner NVAs for next-generation firewalling may offer more control and flexibility regarding NAT configurations not supported by the Azure Firewall, such as DNAT from on-premises, or DNAT from the internet without SNAT.
- Azure-managed NVAs like Application Gateway and Azure Firewall reduce complexity, compared to NVAs where users need to handle scalability and resiliency across multiple appliances.
- When using NVAs in Azure, use *active-active* and *autoscaling* setups so these appliances aren't a bottleneck for applications running in the virtual network.

[azfw-overview]: https://docs.microsoft.com/azure/firewall/overview
[azfw-docs]: https://docs.microsoft.com/azure/firewall/
[azfw-dnat]: https://docs.microsoft.com/azure/firewall/tutorial-firewall-dnat
[azfw-snat]: https://docs.microsoft.com/azure/firewall/snat-private-range
[azfw-issues]: https://docs.microsoft.com/azure/firewall/overview#known-issues
[appgw-overview]: https://docs.microsoft.com/azure/application-gateway/overview
[appgw-docs]: https://docs.microsoft.com/azure/application-gateway/
[waf-docs]: https://docs.microsoft.com/azure/web-application-firewall/
[appgw_apim]: https://docs.microsoft.com/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway
[api-gws]: https://docs.microsoft.com/azure/architecture/microservices/design/gateway
[agic_overview]: https://docs.microsoft.com/azure/application-gateway/ingress-controller-overview
[apim-overview]: https://docs.microsoft.com/azure/api-management/api-management-key-concepts
[aks-overview]: https://docs.microsoft.com/azure/aks/intro-kubernetes
[aks-egress]: https://docs.microsoft.com/azure/aks/limit-egress-traffic
[afd-overview]: https://docs.microsoft.com/azure/frontdoor/front-door-overview
[afd-vs-appgw]: https://docs.microsoft.com/azure/frontdoor/front-door-faq#what-is-the-difference-between-azure-front-door-and-azure-application-gateway
[appgw-networking]: https://docs.microsoft.com/azure/application-gateway/how-application-gateway-works
