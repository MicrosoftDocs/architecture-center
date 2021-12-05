
This article explains the available options to deploy a set of Network Virtual Appliances (NVAs) for high availability in Azure. An NVA is typically used to control the flow of traffic between network segments classified with different security levels, for example between a De-Militarized Zone (DMZ) Virtual Network and the public Internet. To learn about implementing a DMZ in Azure, see [Microsoft cloud services and network security][cloud-security].

There are a number of design patterns where NVAs are used to inspect traffic between different security zones, for example:

- To inspect egress traffic from virtual machines to the Internet and prevent data exfiltration
- To inspect ingress traffic from the Internet to virtual machines and prevent malicious attacks
- To filter traffic between virtual machines in Azure, to prevent lateral moves of compromised systems
- To filter traffic between on-premises systems and Azure virtual machines, if they are considered to belong to different security levels (for example if Azure hosts the DMZ, and onprem the internal applications).

There are many examples of NVAs, such as network firewalls, Layer-4 reverse-proxies, web-based reverse-proxies with web application firewall funnctionality, Internet proxies to restrict which Internet pages can be accessed from Azure, Layer-7 load balancers, and many others. All of them can be inserted in an Azure design with the patterns described in this article. Even Azure first-party Network Virtual Appliances such as [Azure Firewall][azfw] and [Azure Application Gateway][appgw] use the designs explained below. Understanding these options is critical both from a design perspective as well as when troubleshooting network issues.

The first question to be answered is why High Availability for Network Virtual Appliances is required. The reason is because these devices control the communication between network segments, so if they are not available, network traffic cannot flow and applications will stop working. Scheduled and unscheduled outages can and will occasionally bring down NVA instances (as any other virtual machine in Azure or any other cloud), even if those NVAs are configured with Premium Managed Disks to provide single-instance SLA in Azure. Hence, highly available applications will require at least a second NVA that can ensure connectivity.

**Prerequisites:** This article assumes a basic understanding of Azure networking, [Azure load balancers][lb-overview], and [user-defined routes][udr-overview] (UDRs).

## HA architectures overview

The following architectures describe the resources and configuration necessary for highly available NVAs:

| Solution | Benefits | Considerations |
| --- | --- | --- | --- |
| [Azure Load Balancer][load-balancer-design] | Supports scale out NVAs. Very good convergence time | The NVA needs to provide a port for the health probes, especially for active/standby deployments. Doesn't guarantee symmetric flows for flows to/from Internet |
| [Changing PIP/UDR][changing-pip-udr] | No special feature required by the NVA. Guarantees symmetric traffic | Only for active/passive designs. High convergence time, of 1-2 minutes |
| [Azure Route Server][azure-route-server] | The NVA needs to support BGP. Supports active/active and active/passive | No traffic symmetry guaranteed |
| [Gateway Load Balancer][gateway-load-balancer] | Traffic symmetry guaranteed. NVAs can be shared across tenants. Very good convergence time | Only supports inbound flows from the Internet |

## Load Balancer design

You can use an Azure Standard Load Balancer with HA ports for applications that require load balancing of large numbers of ports. A single load-balancing rule replaces multiple individual load-balancing rules, one for each port.


## Changing PIP-UDR

## Azure Route Server

## Gateway Load Balancer

## Next steps

- Learn how to [implement a DMZ between Azure and your on-premises datacenter][dmz-on-premises] using Azure Firewall.
- [Troubleshoot network virtual appliance issues in Azure](/azure/virtual-network/virtual-network-troubleshoot-nva)

<!-- links -->

[azfw]: /azure/firewall/overview
[appgw]: /azure/application-gateway/overview
[cloud-security]: /azure/best-practices-network-security
[dmz-on-premises]: ./secure-vnet-dmz.yml
[load-balancer-standard-ha-ports]: #load-balancer-standard-and-ha-ports
[egress-with-layer-7]: #egress-with-layer-7-nvas
[ingress-with-layer-7]: #ingress-with-layer-7-nvas
[ingress-egress-with-layer-7]: #ingressegress-with-layer-7-nvas
[lb-overview]: /azure/load-balancer/load-balancer-overview
[nva-scenario]: /azure/virtual-network/virtual-network-scenario-udr-gw-nva
[pip-udr-without-snat]: #pip-udr-switch-with-layer-4-nvas-without-snat
[udr-overview]: /azure/virtual-network/virtual-networks-udr-overview
[ha-nva-fo]: https://aka.ms/ha-nva-fo
[ha-nva-l7-sample]: https://github.com/mspnp/samples/tree/master/solutions/ha-nva

<!-- images -->

[0]: ./images/nva-ha/single-nva.png "Single NVA architecture"
[HAPortsArch]: ./images/nva-ha/nva-ha.png "Diagram of hub-and-spoke virtual network, with NVAs deployed in HA mode"
[1]: ./images/nva-ha/l7-ingress.png "Layer 7 ingress architecture with load balancer"
[2]: ./images/nva-ha/l7-egress.png "Layer 7 egress architecture with load balancer"
[3]: ./images/nva-ha/l7-ingress-egress.png "Layer 7 ingress egress"
[5]: ./images/nva-ha/pip-udr-without-snat.png "PIP-UDR with layer 4 NVAs without SNAT architecture"
