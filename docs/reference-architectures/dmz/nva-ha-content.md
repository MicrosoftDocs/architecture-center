This article explains the most common options to deploy a set of Network Virtual Appliances (NVAs) for high availability in Azure. An NVA is typically used to control the flow of traffic between network segments classified with different security levels, for example between a De-Militarized Zone (DMZ) Virtual Network and the public Internet.

There are a number of design patterns where NVAs are used to inspect traffic between different security zones, for example:

- To inspect egress traffic from virtual machines to the Internet and prevent data exfiltration.
- To inspect ingress traffic from the Internet to virtual machines and prevent attacks.
- To filter traffic between virtual machines in Azure, to prevent lateral moves of compromised systems.
- To filter traffic between on-premises systems and Azure virtual machines, if they are considered to belong to different security levels. (For example, if Azure hosts the DMZ, and on-premises the internal applications.)

There are many examples of NVAs, such as network firewalls, Layer-4 reverse-proxies, IPsec VPN endpoints, web-based reverse-proxies with web application firewall functionality, Internet proxies to restrict which Internet pages can be accessed from Azure, Layer-7 load balancers, and many others. All of them can be inserted in an Azure design with the patterns described in this article. Even Azure first-party Network Virtual Appliances such as [Azure Firewall][azfw] and [Azure Application Gateway][appgw] use the designs explained later in this article. Understanding these options is critical both from a design perspective as well as when troubleshooting network issues.

The first question to be answered is why High Availability for Network Virtual Appliances is required. The reason is because these devices control the communication between network segments. If they are not available, network traffic can't flow, and applications will stop working. Scheduled and unscheduled outages can and will occasionally bring down NVA instances (as any other virtual machine in Azure or any other cloud). The instances are brought down even if those NVAs are configured with Premium Managed Disks to provide a single-instance SLA in Azure. Hence, highly available applications will require at least a second NVA that can ensure connectivity.

**Prerequisites:** This article assumes a basic understanding of Azure networking, [Azure Load Balancers][alb], and [Virtual Network Traffic Routing][udr] (UDRs).

When choosing the best option to deploy a Network Virtual Appliance into an Azure VNet, the most important aspect to consider is whether the NVA vendor has vetted and validated that specific design. The vendor must also provide the required NVA configuration that is needed to integrate the NVA in Azure. If the NVA vendor offers different alternatives as supported design options for an NVA, these factors can influence the decision:

* Convergence time: how long does it take in each design to steer the traffic away from a failed NVA instance?
* Topology support: what NVA configurations does each design option support? Active/active, active/standby, scale-out NVA clusters with n+1 redundancy?
* Traffic symmetry: does a particular design force the NVA to perform Source Network Address Translation (SNAT) on the packets to avoid asymmetric routing? Or is traffic symmetry enforced by other means?

The following sections in the document will describe the most common architectures used to integrate NVAs into a Hub and Spoke network.
>[!NOTE]
> This article is focused on [Hub & Spoke designs][caf_hns]. [Virtual WAN][vwan] isn't covered, since Virtual WAN is much more prescriptive on how NVAs are deployed, depending on whether a specific NVA is supported in the Virtual WAN hubs. See [Network Virtual Appliances in the Virtual WAN hub][vwan_nva] for more information.

## HA architectures overview

The following architectures describe the resources and configuration necessary for highly available NVAs:

| Solution | Benefits | Considerations |
| --- | --- | --- |
| [Azure Load Balancer](#load-balancer-design) | Supports active/active, active/standby and scale-out NVAs. Very good convergence time | The NVA needs to provide a port for the health probes, especially for active/standby deployments. Flows to/from Internet require SNAT for symmetry |
| [Azure Route Server](#azure-route-server) | The NVA needs to support BGP. Supports active/active, active/standby and scale-out NVAs. | Traffic symmetry requires SNAT |
| [Gateway Load Balancer](#gateway-load-balancer) | Traffic symmetry guaranteed without SNAT. NVAs can be shared across tenants. Very good convergence time. Supports active/active, active/standby and scale-out NVAs. | Supports flows to/from the Internet, no East-West flows |
| [Changing PIP/UDR](#changing-pip-udr) | No special feature required by the NVA. Guarantees symmetric traffic | Only for active/passive designs. High convergence time of 1-2 minutes |

## Load Balancer design

This design uses two Azure Load Balancers to expose a cluster of NVAs to the rest of the network:

- An internal Load Balancer is used to redirect internal traffic from Azure and on-premises to the NVAs. This internal load balancer is configured with [HA Ports rules][alb_haports], so that every TCP/UDP port is redirected to the NVA instances. 
- A public Load Balancer exposes the NVAs to the Internet. Since [HA Ports][alb_haports] are for inbound traffic, every individual TCP/UDP port needs to be opened in a dedicated load-balancing rule.

The following diagram describes the sequence of hops that packets from the Internet to an application server in a spoke VNet would follow:

![ALB Internet][alb_internet]

*Download a [Visio file][visio-download] of this architecture.*

The mechanism to send traffic from spokes to the public Internet through the NVAs is a User-Defined Route for `0.0.0.0/0` with next-hop the internal Load Balancer's IP address.

For traffic between Azure and the public Internet, each direction of the traffic flow will cross a different Azure Load Balancer (the ingress packet through the public ALB, and the egress packet through the internal ALB). As a consequence, if traffic symmetry is required, Source Network Address Translation (SNAT) needs to be performed by the NVA instances to attract the return traffic and avoid traffic asymmetry.

This design can be used as well to inspect traffic between Azure and on-premises networks:

![ALB Onpremises][alb_onprem]

The mechanism to send traffic between spokes through the NVAs is exactly the same, so no additional diagram is provided. In the example diagrams above, since spoke1 doesn't know about spoke2's range, the `0.0.0.0/0` UDR will send traffic addressed to spoke2 to the NVA's internal Azure Load Balancer. 

For traffic between on-premises networks and Azure or between Azure virtual machines, traffic symmetry is guaranteed by the internal Azure Load Balancer: when both directions of a traffic flow traverse the same Azure Load Balancer, the same NVA instance will be chosen.

The Azure Load Balancer has a very good convergence time in case of individual NVA outages. Since the [health probes][alb_probes] can be sent every 5 seconds, and it takes 3 failed probes to declare a backend instance out of service, it usually takes 10-15 seconds for the Azure Load Balancer to converge traffic to a different NVA instance.

This setup supports both active/active and active/standby configurations. However, for active/standby configurations the NVA instances need to offer a TCP/UDP port or HTTP endpoint that doesn't respond to the Load Balancer health probes unless the instance is in the active role.

### Using L7 load balancers

A particular case of this design is replacing the Azure public Load Balancer with a Layer-7 load balancer such as the [Azure Application Gateway][appgw] (which can be considered as an NVA on its own). In this case, the NVAs will only require an internal Load Balancer in front of them, since traffic from the Application Gateway will be sourced from inside the VNet, and traffic asymmetry isn't a concern.

The NVA should be taking inbound traffic for protocols not supported by your Layer-7 load balancer, plus potentially all egress traffic. For further details about this configuration when using Azure Firewall as NVA and Azure Application Gateway as Layer-7 web reverse-proxy, see [Firewall and Application Gateway for virtual networks][azfw_appgw].

## Azure Route Server

[Azure Route Server][ars] is a service which allows an NVA to interact with Azure SDN via Border Gateway Protocol (BGP). Not only the NVAs will learn which IP prefixes exist in the Azure VNets, but they'll be able to inject routes in the effective route tables of the virtual machines in Azure. 

![ARS Internet][ars_internet]

In the diagram above each NVA instance is peered over BGP with the Azure Route Server. No route table is required in the spoke subnets, since Azure Route Server will program the routes advertised by the NVAs. If two or more routes are programmed in the Azure virtual machines, they'll use Equal Cost MultiPathing (ECMP) to choose one of the NVA instances for every traffic flow. As a consequence, SNAT is a must in this design if traffic symmetry is a requirement.

This insertion method supports both active/active (all NVAs advertise the same routes to the Azure Route Server), as well as active/standby (one NVA advertises routes with a shorter AS path than the other). The Azure Route Server supports a maximum of 8 BGP adjacencies. Hence, if using a scale-out cluster of active NVAs, this design will support a maximum of 8 NVA instances.

Convergence time is pretty fast in this setup, and will be influenced by the keepalive and holdtime timers of the BGP adjacency. While the Azure Route Server has default keepalive and holdtime timers (60 seconds and 180 seconds respectively), the NVAs can negotiate lower timers during the BGP adjacency establishment. Setting these timers too low could lead to BGP instabilities.

This design is the most common option for NVAs that need to interact with Azure routing, for example VPN termination NVAs that need to learn the prefixes configured in Azure VNets, or advertise certain routes over ExpressRoute private peerings.

## Gateway Load Balancer

[Azure Gateway Load Balancer][gwlb] is a new way of inserting NVAs in the data path without the need to steer traffic with User-Defined Routes. For Virtual Machines that expose their workloads via an Azure Load Balancer or a public IP address, inbound and outbound traffic can be redirected transparently to a cluster of NVAs located in a different VNet. The following diagram describes the path that packets follow for inbound traffic from the public Internet in case the workloads expose the application via an Azure Load Balancer:

![GWLB Internet][gwlb_internet]

One of the main advantages of this NVA injection method is that Source Network Address Translation (SNAT) isn't required to guarantee traffic symmetry. Another benefit of this design option is that the same NVAs can be used to inspect traffic to/from different VNets, thus achieving multitenancy from the NVA perspective. No VNet peering is required between the NVA VNet and the workload VNet(s), and no User-Defined Routes are required in the workload VNet, which dramatically simplifies the configuration.

Service injection with the Gateway Load Balancer can be used for inbound flows hitting an Azure public Load Balancer (and their return traffic), as well as for outbound flows originating in Azure. East-West traffic between Azure virtual machines can't leverage the Gateway Load Balancer for NVA injection.

In the NVA cluster, Azure Load Balancer health check probes will be used to detect individual NVA instance failures, achieving a very quick convergence time (10-15 seconds).

## Changing PIP-UDR

The idea behind this design is having the setup that would be required without NVA redundancy, and have it modified in case the NVA suffers from downtime. The diagram below shows how an Azure Public IP address is associated to the active NVA (NVA1), and the User-Defined Routes in the spokes have the active NVA's IP address as next hop (`10.0.0.37`).

![PIP/UDR Internet][pipudr_internet]

If the active NVA became unavailable, the standby NVA would call the Azure API to remap the public IP address and the spoke User-Defined Routes to itself (or move the private IP address too). These API calls can take some minutes to be effective, which is why this design offers the worst convergence time of all the options in this document.

Another limitation of this design is that only active/standby configurations are supported, which can lead to scalability problems: if you need to increase the bandwidth supported by your NVAs, the only option with this design is scaling up both instances.

One benefit of this design is that no Source Network Address Translation (SNAT) is required to guarantee traffic symmetry, since there's only one NVA active at any given point in time.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Keith Mayer](https://www.linkedin.com/in/keithm) | Principal Cloud Solution Architect
 - [Telmo Sampaio](https://www.linkedin.com/in/telmo-sampaio-172200) | Principal Service Engineering Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Learn how to [implement a secure hybrid network][secure_hybrid] using Azure Firewall.
- [Perimeter Networks - Cloud Adoption Framework][caf_perimeter]
- [Cloud DMZ - Cloud Adoption Framework][caf_dmz]

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

[alb_internet]: ./images/nva-ha/nvaha-load-balancer-internet.png "Internet traffic with Azure Load Balancer integration"
[alb_onprem]: ./images/nva-ha/nvaha-load-balancer-on-premises.png "On-premises traffic with Azure Load Balancer integration"
[ars_internet]: ./images/nva-ha/nvaha-route-server-internet.png "Internet traffic with Azure Route Server integration"
[gwlb_internet]: ./images/nva-ha/nvaha-gateway-load-balancer-internet.png "Internet traffic with Gateway Load Balancer integration"
[pipudr_internet]: ./images/nva-ha/nvaha-pipudr-internet.png "Internet traffic with moving PIP/UDR"
