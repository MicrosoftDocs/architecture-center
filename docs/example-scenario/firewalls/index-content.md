The cloud is changing the way infrastructure is designed, including the design of firewalls, because the network isn't physical or in virtual LANs anymore. Not all features of a physical network are available in a virtual network (VNet). This includes the use of floating IP addresses or broadcast traffic and that influences the implementation of HA architectures. Load balancers for *Network Virtual Appliances (NVAs)* can/must be implemented in a certain way to achieve a highly available (HA) architecture within a virtual network. This guide presents a structured approach for designing HA firewalls (FWs) in Azure using third-party virtual appliances.

## Options for designing highly available NVAs

When deploying HA architectures, there are a few options to provide failover:

* **Azure API-managed route tables:** This option uses two route tables, one active, one passive to switch the active gateway IP for all services running on a VNet/subnet.
* **Azure API-managed floating IP:** This option uses a secondary IP address on the FWs that can be moved between an active and a stand-by FW.
* **Load Balancer managed:** This option uses an Azure Load Balancer to act as the gateway IP for the subnet, which then forwards the traffic to the active FW. It may even forward the traffic active-active to provide true load balancing.

The problem with the first two options is that failover itself is slow. The FW must instruct the failover, which is essentially a "reconfiguration" of Azure services through a new deployment. Depending on how fast that deployment is completed, the traffic flows will be down for several minutes. Furthermore, it doesn't allow for an active-active configuration where both firewalls are operating at the same time.

That's why the third option is most preferred. The downtime is minimized as the load balancer can fail over almost instantly to the stand-by firewall (in active-passive) or just remove the load from the failed firewall (in active-active). But you can't just use load balancers as "default gateways" as they affect the traffic flow and TCP packets need to be stateful.

## Two-legged firewalls

The following picture starts with two FWs (FW-1 & FW-2), with an external load balancer and a backend server S1.

![Standard Load Balancer in front of two NVAs](./images/standard-lb-inbound.png)

This architecture is a simple setup, used for inbound traffic. A packet hits the load balancer, which chooses the destination FW from its configuration. The chosen firewall then sends the traffic to the backend (web) server. If FW-1 has SNAT enabled, server S1 will see the traffic that comes from the internal IP of FW-1, so it also will send the reply to the packet to FW-1. Failover can happen quickly to FW-2 in this scenario. For outbound traffic, we could add another load balancer on the internal side. When server S1 starts traffic, the same principle will apply. Traffic hits the internal LB (iLB), which chooses a firewall that then translates NAT for external resolution:

![Standard Load Balancer in front and back of two NVAs with trusted/untrusted zones](./images/sandwich-fw.png)

## Three-legged firewalls

Problems arise when we add another interface to the firewall, and you need to disable NAT translation between *internal* zones. In this case, see Subnet-B and Subnet-C:

![Standard Load Balancer in front and back of two NVAs with three zones](./images/three-legged-fw-overview.png)

The L3 routing between the internal zones (Subnet-B and Subnet-C) will both be load balanced without NAT. This setup becomes clearer looking at the traffic flows including the load-balancers in a different view. The diagram below shows the view where the internal Load Balancers [iLB] are linked to a specific NIC on the FWs:

![Detailed traffic flows with 3-legged FWs with Load Balancers](./images/three-legged-fw-details.png)

With L3 traffic (without NAT), S2 will see the S1 IP address as the source address. S2 will then send the return traffic for subnet B (to which S1-IP belongs) to the iLB in Subnet-C. As iLB in Subnet-B and iLB in Subnet-C don't synchronize their session states, depending on the load-balancing algorithm traffic could end-up on FW-2. FW-2 by default doesn't know anything about the initial (green) packet, so it will drop the connection.

Some firewall vendors try to keep a connection state between the firewalls, but they would need almost instant synchronization to be up to date on the connection states. Check with your firewall vendor if they recommend this setup.

The best way to deal with this problem is to eliminate it. In the example above, this solution means eliminating Subnet-C, which bring us to the advantages of Virtualized VNets.

### Isolate hosts in a subnet with Network Security Groups

When there are two VMs in a single subnet, you can apply an NSG that isolates traffic between the two. By default, traffic inside a VNet is entirely allowed. Adding a *Deny all* rule on the NSG, isolates all VMs from each other.

![Block internet subnet traffic with NSGs](./images/inter-subnet-blocked.png)

### VNets use the same backend (virtual) routers

VNet/subnets use a single backend router system from Azure and as such, there's no need to specify a router IP for each subnet. The route destination can be anywhere in the same VNET or even outside.

![NVA with single NICs and how traffic flows](./images/single-nic-fw.png)

With the virtualized networks, you can control the routes in every subnet. These routes can also point to a single IP in another subnet. In the picture above, that would be the iLB in Subnet-D, which load-balances the two firewalls. As S1 starts traffic (green), it will be load balanced to, for example, FW-1. FW-1 will then connect to S2 (still green). S2 will send the response traffic to the IP of S1 (as NAT is disabled). Because of the route tables, S2 uses the same iLB IP as its gateway. The iLB may match the traffic to the initial session, so it will always point this traffic back to FW-1. FW-1 then sends it to S1, establishing a synchronous traffic flow.

For this setup to work, the FW needs to have a route table (internally) pointing Subnet-B and Subnet-C to its default subnet GW. That subnet GW is the first logically available IP in the subnet range in that VNET.

## Impact on reverse proxy services

When you deploy a reverse proxy service, *normally* it would be behind the FW. You may instead put it *in-line* with the FW and actually route the traffic through the FW. The advantage of this setup is that the reverse proxy service would *see* the original IP of the connecting client:

![Diagram showing reverse proxy service in-line with the NVA and routing the traffic through the firewall.](./images/two-legged-revproxy.png)

For this configuration, the route tables on Subnet-E need to point Subnet-B and Subnet-C through the internal load balancer. Some reverse proxy services have built-in firewalls that allow you to remove the FW all together in this network flow. The built-in firewalls point from reverse proxy straight to Subnet-B/C servers.

In this scenario, SNAT will be required on the reverse proxy's as well to avoid return traffic to flow through and denied by the FWs to Subnet-A.

## VPN/ER

Azure provides BGP-enabled/highly-available VPN/ER services through the Azure Virtual Network Gateways. Most architects keep these for backend or non-internet facing connections. This setup means the routing table needs to accommodate the subnets behind these connections, too. While there isn't a large difference to subnet-B/C connectivity, there is in the design of the return traffic, completing the picture:

![Diagram showing reverse proxy service supporting BGP-enabled/highly-available VPN/ER services through Azure Virtual Network Gateway.](./images/two-legged-revproxy-gw.png)

In this architecture, traffic hitting the FW from, for example Subnet-B to Subnet-X would be sent to the iLB, which in turn sends it to either firewall. The internal route inside the FW will send the traffic back to the Subnet-GW (first available IP in Subnet-D). You don't have to send the traffic straight to the Gateway appliance itself, as another route on Subnet-D will have a route for Subnet-X pointing it to the *Virtual Network Gateway*. Azure Networking will take care of the actual routing.

Return traffic coming from Subnet-X will be forwarded to the iLB in Subnet-D. The GatewaySubnet will also have a custom route that points Subnet-B-C to the iLB. Subnet-D isn't via the iLB. This will be treated as *regular* inter-VNET routing.

While not in the drawing, it would make sense for Subnet-B/C/D/Gateway to also include a route for Subnet-A pointing it to the iLB. This arrangement avoids the "regular" VNET routing to bypass the FWs. This as Subnet-A is just another subnet in the VNET according to the Azure networking stack. It won't treat Subnet-A different, although you treat it as DMZ/Internet/etc.

## Summary

In short, the way you treat firewalls in your on-premises (physical/VLAN-based) networks, with as many interfaces (virtual or physical) is not the same as you would in Azure. If necessary you still can (to some degree), but there are better ways to ensure you can minimize fail-over downtime; have active-active implementations and *clean* routing tables.

More information on using load balancers as *gateways* for all traffic can be found on [High availability ports overview](/azure/load-balancer/load-balancer-ha-ports-overview).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Roelf Zomerman](https://ae.linkedin.com/in/rzomerman) | Senior Cloud Solution Architect

## Next steps

Learn more about the component technologies:

- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

## Related resources

Explore related architectures:

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Hybrid connection](../../solution-ideas/articles/hybrid-connectivity.yml)
- [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)
- [Choose between virtual network peering and VPN gateways](../../reference-architectures/hybrid-networking/vnet-peering.yml)
- [Troubleshoot a hybrid VPN connection](../../reference-architectures/hybrid-networking/troubleshoot-vpn.yml)
- [Hub-spoke network topology in Azure](../../reference-architectures/hybrid-networking/hub-spoke.yml)
- [Connect standalone servers by using Azure Network Adapter](../../hybrid/azure-network-adapter.yml)
- [SQL Server 2008 R2 failover cluster in Azure](../sql-failover/sql-failover-2008r2.yml)
