This article describes common options to deploy a set of network virtual appliances (NVAs) for high availability in Azure. An NVA typically controls the flow of traffic between network segments that have different security levels, for example between a perimeter network virtual network and the public internet, or to connect external locations to Azure, such as VPN or software-defined WAN (SD-WAN) appliances.

This article assumes a basic understanding of Azure networking, [Azure load balancers][alb], [virtual network traffic routing][udr], and user-defined routes (UDRs).

Many design patterns use NVAs to inspect traffic between different security zones. They might use NVAs for the following purposes:

- To inspect egress traffic from virtual machines to the internet and prevent data exfiltration.

- To inspect ingress traffic from the internet to virtual machines and prevent attacks.
- To filter traffic between virtual machines in Azure to prevent lateral moves of compromised systems.
- To filter traffic between on-premises systems and Azure virtual machines, especially if they belong to different security levels. For example, Azure hosts the perimeter network, and on-premises hosts the internal applications.
- To terminate VPN or SD-WAN tunnels from external locations, such as on-premises networks or other public clouds.

Consider the following examples of NVAs:

- Network firewalls
- Layer-4 reverse proxies
- IPsec VPN endpoints
- SD-WAN appliances
- Web-based reverse proxies that have web application firewall functionality
- Internet proxies to restrict which internet pages can be accessed from Azure
- Layer-7 load balancers

You can add all of these NVAs to an Azure design by using the patterns in this article. Azure-native NVAs such as [Azure Firewall][azfw] and [Azure Application Gateway][appgw] use the designs explained later in this article. You should understand these options from a design perspective and for network troubleshooting purposes.

NVAs often require high availability because they control the communication between network segments. If your NVAs become unavailable, network traffic can't flow and applications stop working. Scheduled and unscheduled outages occasionally shut down NVA instances, similar to any other virtual machine in Azure or other clouds. The NVA instances might shut down even if you configure them with Azure Premium SSDs, which provide a single-instance service-level agreement in Azure. Highly available applications require at least two NVAs to help ensure connectivity.

When you choose the best option to deploy an NVA into an Azure virtual network, the most important aspect to consider is whether the NVA vendor vetted and validated that specific design. The vendor must also provide the required NVA configuration to integrate the NVA in Azure. If the NVA vendor provides different alternatives as supported design options for an NVA, these factors can influence the decision:

- **Convergence time:** The time it takes in each design to steer the traffic away from a failed NVA instance

- **Topology support:** The NVA configurations that each design option supports, auch as active/active, active/standby, or scale-out NVA clusters with n+1 redundancy
- **Traffic symmetry:** Whether a particular design forces the NVA to perform Source Network Address Translation (SNAT) on the packets to avoid asymmetric routing, or if traffic symmetry is enforced by other means

The following sections describe common architectures that you can use to integrate NVAs into a hub-and-spoke network.

>[!NOTE]
> This article focuses on [hub-and-spoke designs][caf_hns]. [Azure Virtual WAN][vwan] isn't covered because it has more prescriptive guidelines for deplying NVAs, depending on whether the Virtual Wan hub supports a specific NVA. For more information, see [NVAs in the Virtual WAN hub][vwan_nva].

## High availability architectures overview

The following architectures describe the resources and configuration necessary for highly available NVAs.

| Solution | Benefits | Considerations |
| --- | --- | --- |
| [Azure Load Balancer](#load-balancer-design) | Supports active/active, active/standby, and scale-out NVAs with good convergence time | The NVA needs to provide a port for the health probes, especially for active/standby deployments. For stateful appliances such as firewalls that require traffic symmetry, flows to/from internet require SNAT |
| [Azure Route Server](#azure-route-server) | The NVA needs to support BGP. Supports active/active, active/standby, and scale-out NVAs. | Traffic symmetry also requires SNAT. |
| [Gateway Load Balancer](#gateway-load-balancer) | Traffic symmetry guaranteed without SNAT. NVAs can be shared across tenants. Good convergence time. Supports active/active, active/standby, and scale-out NVAs. | Supports flows to and from the internet, no East-West flows |
| [Changing PIP/UDR](#changing-pip-udr) | No special feature required by the NVA. Guarantees symmetric traffic | Only for active/passive designs. High convergence time of 1-2 minutes |

## Load Balancer design

This design uses two Azure load balancers to expose a cluster of NVAs to the rest of the network. The approach suits both stateful and stateless NVAs:

- An internal load balancer redirects internal traffic from Azure and on-premises to the NVAs. This internal load balancer is configured with [high availability ports rules][alb_haports], so that every TCP/UDP port is redirected to the NVA instances.

- A public load balancer exposes the NVAs to the internet. [High availability ports][alb_haports] are for inbound traffic, so every individual TCP/UDP port needs to be opened in a dedicated load-balancing rule.

The following diagram shows the sequence of hops that packets take from the internet to an application server in a spoke virtual network. These packets traverse a firewall NVA to control traffic to and from the public internet, also called *North-South traffic*.

![ALB Internet][alb_internet]

*Download a [Visio file][visio-download] of this architecture.*

The mechanism to send traffic from spokes to the public internet through the NVAs is a UDR for `0.0.0.0/0` with next-hop the internal Load Balancer's IP address.

For traffic between Azure and the public internet, each direction of the traffic flow crosses a different Azure Load Balancer. This occurs even if the firewall NVA has a single NIC for both the public and internal networks, as the ingress packet goes through the public ALB and the egress packet goes through the internal ALB. Because both directions of the flow going through different load balancers, if traffic symmetry is required, as is usually the case in most firewalls, SNAT needs to be performed by the NVA instances to attract the return traffic and avoid traffic asymmetry.

The same design with load balancers can be used as well to inspect traffic between Azure and on-premises networks (East-West), where only an internal load balancer is involved:

![ALB Onpremises][alb_onprem]

The mechanism to send traffic between spokes through the NVAs is exactly the same, so no other diagram is provided. In the example diagrams above, since spoke1 doesn't know about spoke2's range, the `0.0.0.0/0` UDR sends traffic addressed to spoke2 to the NVA's internal Azure Load Balancer. 

For traffic between on-premises networks and Azure or between Azure virtual machines, traffic symmetry is guaranteed in single-NIC NVAs by the internal Azure Load Balancer: when both directions of a traffic flow traverse the same Azure Load Balancer, the same NVA instance will be chosen by the load balancer. In the case of dual-NIC NVAs where there is an internal load balancer for each sense of the communication, the traffic symmetry has to be provided via SNAT as in the North/South example above.

Another challenge that dual-NIC NVAs face in this design is where to send back the replies to the load balancer's health checks. Azure Load Balancer always uses the same IP address as source for the health checks (168.63.129.16). The NVA needs to be able to send the answer to the health check's sourced from this IP address on the same interface that they were received. This typically requires multiple routing tables in an operating system, since destination-based routing would send the reply to the health checks always through the same NIC.

The Azure Load Balancer has a good convergence time in individual NVA outages. Since the [health probes][alb_probes] can be sent every 5 seconds and it takes 3 failed probes to declare a backend instance out of service, it usually takes 10-15 seconds for the Azure Load Balancer to converge traffic to a different NVA instance.

This setup supports both active/active and active/standby configurations. For active/standby configurations, the NVA instances need to offer a TCP/UDP port or HTTP endpoint that only responds to the Load Balancer health probes for the instance that  is in the active role.

### Layer-7 load balancers

A particular case of this design for security appliances replaces the Azure public load balancer with a Layer-7 load balancer such as the [Azure Application Gateway][appgw], which can be considered an NVA itself. In this scenario, the NVAs only require an internal load balancer for traffic from the workload systems. Dual-NIC devices sometimes use this approach to avoid routing problems with the Azure load balancer's health checks, as described in the previous section. This design supports only the Layer-7 protocols that the Layer-7 load balancer supports, which is typically HTTP and HTTPS.

The NVA should handle inbound traffic for protocols that your Layer-7 load balancer doesn't support. The NVA might also handle all egress traffic. For more information, see [Firewall and Application Gateway for virtual networks][azfw_appgw].

## Route Server

[Route Server][ars] is a service that enables an NVA to interact with Azure software-defined networking via Border Gateway Protocol (BGP). NVAs learn which IP address prefixes exist in Azure virtual networks. They can also inject routes in the effective route tables of virtual machines in Azure. 

![ARS Internet][ars_internet]

In the diagram above each NVA instance is peered over BGP with the Route Server. No route table is required in the spoke subnets, since Route Server programs the routes advertised by the NVAs. If two or more routes are programmed in the Azure virtual machines, they use Equal Cost MultiPathing (ECMP) to choose one of the NVA instances for every traffic flow. As a consequence, SNAT is a must in this design if traffic symmetry is a requirement.

This insertion method supports both active/active (all NVAs advertise the same routes to the Route Server), and active/standby (one NVA advertises routes with a shorter AS path than the other). The Route Server supports a maximum of 8 BGP adjacencies. Hence, if using a scale-out cluster of active NVAs, this design supports a maximum of 8 NVA instances.

Convergence time is fast in this setup, and is influenced by the keepalive and holdtime timers of the BGP adjacency. While the Route Server has default keepalive and holdtime timers (60 seconds and 180 seconds respectively), the NVAs can negotiate lower timers during the BGP adjacency establishment. Setting these timers too low could lead to BGP instabilities.

This design suits NVAs that need to interact with Azure routing, for example SD-WAN or IPsec NVAs that typically have good BGP support and need to learn the prefixes configured in Azure virtual networks or advertise certain routes over ExpressRoute private peerings. This type of appliances is usually stateless so that traffic symmetry isn't a problem and SNAT isn't required.

## Gateway Load Balancer

[Azure Gateway Load Balancer][gwlb] is a new way of inserting NVAs in the data path without the need to steer traffic with UDRs. For virtual machines that expose their workloads via an Azure load balancer or a public IP address, you can redirect inbound and outbound traffic transparently to a cluster of NVAs located in a different virtual network. The following diagram shows the path that packets follow for inbound traffic from the public internet if the workloads expose the application via an Azure load balancer.

![GWLB Internet][gwlb_internet]

One of the main advantages of this NVA injection method is that SNAT isn't required to guarantee traffic symmetry. Another benefit of this design option is that the same NVAs can be used to inspect traffic to/from different virtual networks, thus achieving multitenancy from the NVA perspective. No virtual network peering is required between the NVA virtual network and the workload virtual networks, and no UDRs are required in the workload virtual network, which dramatically simplifies the configuration.

Service injection with the Gateway Load Balancer can be used for inbound flows hitting an Azure public Load Balancer (and their return traffic), and for outbound flows originating in Azure. East-West traffic between Azure virtual machines can't leverage the Gateway Load Balancer for NVA injection.

In the NVA cluster, Azure Load Balancer health check probes are used to detect individual NVA instance failures, achieving a quick convergence time (10-15 seconds).

## Changing PIP-UDR

The idea behind this design is having the setup that would be required without NVA redundancy, and have it modified in case the NVA suffers from downtime. The diagram below shows how an Azure Public IP address is associated to the active NVA (NVA1), and the UDRs in the spokes have the active NVA's IP address as next hop (`10.0.0.37`).

![PIP/UDR Internet][pipudr_internet]

If the active NVA became unavailable, the standby NVA would call the Azure API to remap the public IP address and the spoke UDRs to itself (or move the private IP address too). These API calls can take some minutes to be effective, which is why this design offers the worst convergence time of all the options in this document.

Another limitation of this design is that only active/standby configurations are supported, which can lead to scalability problems: if you need to increase the bandwidth supported by your NVAs, the only option with this design is scaling up both instances.

One benefit of this design is that no SNAT is required to guarantee traffic symmetry, since there's only one NVA active at any given point in time.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

 - [Keith Mayer](https://www.linkedin.com/in/keithm) | Principal Cloud Solution Architect
 - [Telmo Sampaio](https://www.linkedin.com/in/telmo-sampaio-172200) | Principal Service Engineering Manager
 - [Jose Moreno](https://www.linkedin.com/in/erjosito) | Principal Engineer
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Perimeter networks][caf_perimeter]
- [Cloud perimeter networks][caf_dmz]

## Related resources

- [Implement a secure hybrid network by using Azure Firewall][secure_hybrid]

<!-- links -->

[udr]: /azure/virtual-network/virtual-networks-udr-overview
[azfw]: /azure/firewall/overview
[appgw]: /azure/application-gateway/overview
[ars]: /azure/route-server/overview
[gwlb]: /azure/load-balancer/gateway-overview
[alb]: /azure/load-balancer/load-balancer-overview
[vwan]: /azure/virtual-wan/virtual-wan-about
[vwan_nva]: /azure/virtual-wan/about-nva-hub
[alb_probes]: /azure/load-balancer/load-balancer-custom-probe-overview
[alb_haports]: /azure/load-balancer/load-balancer-ha-ports-overview
[caf_dmz]: /azure/cloud-adoption-framework/decision-guides/software-defined-network/cloud-dmz
[caf_perimeter]: /azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks
[caf_hns]: /azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[secure_hybrid]: /azure/architecture/reference-architectures/dmz/secure-vnet-dmz
[azfw_appgw]: /azure/architecture/example-scenario/gateway/firewall-application-gateway
[visio-download]: https://arch-center.azureedge.net/deploy-highly-available-nva-diagrams.vsdx

<!-- images -->

[alb_internet]: ./images/nvaha-load-balancer-internet.png "Internet traffic with Azure Load Balancer integration"
[alb_onprem]: ./images/nvaha-load-balancer-on-premises.png "On-premises traffic with Azure Load Balancer integration"
[ars_internet]: ./images/nvaha-route-server-internet.png "Internet traffic with Route Server integration"
[gwlb_internet]: ./images/nvaha-gateway-load-balancer-internet.png "Internet traffic with Gateway Load Balancer integration"
[pipudr_internet]: ./images/nvaha-pipudr-internet.png "Internet traffic with moving PIP/UDR"
