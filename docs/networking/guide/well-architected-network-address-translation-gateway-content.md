This article describes best practices for an Azure NAT gateway. The guidance is based on the five pillars of architectural excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.

As a prerequisite to this guidance, you should have a working knowledge of Azure NAT Gateway and understand its respective features. For more information, see [Azure NAT Gateway documentation](/azure/virtual-network/nat-gateway).

## Cost optimization

Configure access to platform as a service (PaaS) solutions through Azure Private Link or service endpoints, including storage, so that you don't have to use a NAT gateway. Private Link and service endpoints don't require traversal of the NAT gateway to access PaaS services. This approach reduces the cost per gigabyte (GB) of processed data, compared to the cost of using a NAT gateway. Private Link and service endpoints also provide security benefits.

## Performance efficiency

Each NAT gateway resource provides up to 50 gigabits per second (Gbps) of throughput. You can split your deployments into multiple subnets, and then assign a NAT gateway to each subnet or group of subnets to scale out.

Each NAT gateway public IP address provides 64,512 Source Network Address Translation (SNAT) ports. You can assign up to 16 IP addresses to a NAT gateway, including individual standard public IP addresses, the public IP prefix, or both. For each assigned outbound IP address that goes to the same destination endpoint, NAT gateway can support up to 50,000 concurrent flows for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) respectively.

### SNAT exhaustion

Consider the following guidance to help prevent SNAT exhaustion:

- NAT gateway resources have a default TCP idle timeout of four minutes. You can configure the timeout for up to 120 minutes. If you change this setting to a higher value than the default, NAT gateway holds on to flows longer, which can create unnecessary pressure on the SNAT port inventory.

- Atomic requests (one request per connection) limit scale, reduce performance, and reduce reliability. Instead of atomic requests, you can reuse HTTP or HTTPS connections to reduce the number of connections and associated SNAT ports. When you reuse connections, the application can scale better. Application performance improves due to reduced handshakes, overhead, and cryptographic operation costs when you use Transport Layer Security (TLS).
- If you don't cache DNS resolver's results, Domain Name System (DNS) lookups can introduce many individual flows at volume. Use DNS caching to reduce the volume of flows and reduce the number of SNAT ports. DNS is the naming system that maps domain names to IP addresses for resources that are connected to the internet or to a private network.
- UDP flows, such as DNS lookups, use SNAT ports during the idle timeout. The UDP idle timeout timer is fixed at four minutes.
- Use connection pools to shape your connection volume.
- To clean up flows, don't silently abandon TCP flows or rely on TCP timers. If you don't let TCP explicitly close a connection, the TCP connection remains open. Intermediate systems and endpoints keep this connection in use, which makes the SNAT port unavailable for other connections. This antipattern can trigger application failures and SNAT exhaustion.
- Don't change OS-level TCP-close related timer values unless you know the implications. If the endpoints of a connection have mismatched expectations, the TCP stack can recover, but it might negatively affect your application performance. You typically have an underlying design problem if you need to change timer values. And if the underlying application has other antipatterns and you alter timer values, you might also accelerate SNAT exhaustion.

Review the following guidance to improve the scale and reliability of your service:

- Consider the effects of reducing the TCP idle timeout to a lower value. A default idle timeout of four minutes can preemptively free up SNAT port inventory.
- Consider asynchronous polling patterns for long-running operations to free up your connection resources for other operations.

- Consider using TCP keepalives or application-layer keepalives for long-lived TCP flows, such as reused TCP connections, to prevent intermediate systems from timing out. You should only increase the idle timeout as a last resort, and it might not resolve the root cause. A long timeout can cause low rate failures when the timeout expires. It can also introduce a delay and unnecessary failures. You can enable TCP keepalives from one side of a connection to keep a connection alive from both sides.
- Consider using UDP keepalives for long-lived UDP flows to prevent intermediate systems from timing out. When you enable UDP keepalives on one side of the connection, only one side of the connection remains active. You must enable UDP keepalives on both sides of a connection to keep a connection alive.
- Consider graceful retry patterns to avoid aggressive retries and bursts during transient failure or failure recovery. For the antipattern *atomic connections*, you create a new TCP connection for every HTTP operation. Atomic connections waste resources and prevent your application from scaling well.

  To increase transaction speed and decrease resource costs for your application, always pipeline multiple operations into the same connection. When your application uses transport layer encryption, for example TLS, new connection processing increases cost. For more best practice patterns, see [Azure cloud design patterns](/azure/architecture/patterns).

## Operational excellence

You can use a NAT gateway with Azure Kubernetes Service (AKS), but NAT gateway management isn't included in AKS. If you assign a NAT gateway to the Container Networking Interface (CNI) subnet, you enable AKS pods to egress through the NAT gateway.

When you use multiple NAT gateways across zones or regions, keep the outbound IP estate manageable by using Azure public IP prefixes or bring-your-own IP (BYOIP) prefixes. You can't assign an IP prefix size that's larger than 16 IP addresses (/28 prefix size) to a NAT gateway. 

Use Azure Monitor alerts to monitor and alert on SNAT port usage, processed or dropped packets, and the amount of transmitted data. Use network security group (NSG) flow logs to monitor outbound traffic flow from virtual machine (VM) instances in a NAT gateway-configured subnet.

When you configure a subnet with a NAT gateway, the NAT gateway replaces all other outbound connectivity to the public internet for all VMs on that subnet. The NAT gateway takes precedence over a load balancer, regardless of the outbound rules. The gateway also takes precedence over public IP addresses that are assigned directly to VMs. Azure tracks the direction of a flow and prevents asymmetric routing. Inbound-originated traffic, such as a load balancer front-end IP, is translated correctly, and it's translated separately from outbound-originated traffic through a NAT gateway. This separation allows inbound and outbound services to coexist seamlessly.

We recommend a NAT gateway as the default to enable outbound connectivity for virtual networks. A NAT gateway provides efficiency and operational simplicity compared to other outbound connectivity techniques in Azure. NAT gateways allocate SNAT ports on demand and use a more efficient algorithm to prevent SNAT port reuse conflicts. Don't rely on the *default outbound connectivity* antipattern for your estate. Instead, explicitly define your configuration with NAT gateway resources.

## Reliability

NAT gateway resources are highly available in one availability zone and span multiple fault domains. You can deploy a NAT gateway to a *no zone* in which Azure automatically selects a zone to place the NAT gateway or isolates the NAT gateway to a specific availability zone.

To provide availability zone isolation, each subnet must have resources only within a specific zone. To implement this approach, you can:

- Deploy a subnet for each of the availability zones where VMs are deployed.
- Align the zonal VMs with matching zonal NAT gateways.
- Build separate zonal stacks.

In the following diagram, a VM in availability zone 1 is on a subnet with other resources that are also only in availability zone 1. A NAT gateway is configured in availability zone 1 to serve that subnet.

:::image type="content" source="./images/az-directions.png" alt-text="Diagram that demonstrates the directional flow of a zonal stack." border="false" lightbox="./images/az-directions.png":::

Virtual networks and subnets [span all availability zones in a region](/azure/virtual-network/virtual-networks-overview#virtual-networks-and-availability-zones). You don't need to divide them by availability zones to accommodate zonal resources.

## Security

With a NAT gateway, individual VMs or other compute resources don't need public IP addresses and can remain fully private. Resources without a public IP address can still reach external sources outside the virtual network. You can associate a public IP prefix to ensure that you use a contiguous set of IPs for outbound connectivity. You can configure destination firewall rules based on this predictable IP list.

A common approach is to design an outbound-only network virtual appliance (NVA) scenario with non-Microsoft firewalls or with proxy servers. When you deploy a NAT gateway to a subnet with a virtual machine scale set of NVAs, those NVAs use one or more NAT gateway addresses for outbound connectivity instead of a load balancer IP or the individual IPs. To employ this scenario with Azure Firewall, see [Integrate Azure Firewall with Azure standard load balancer](/azure/firewall/integrate-lb).

:::image type="content" source="./images/natgw-fw-vmss.svg" alt-text="Diagram that shows firewalls with a load balancer sandwich and NAT gateway." border="false" lightbox="./images/natgw-fw-vmss.svg":::

You can use the [Microsoft Defender for Cloud](/azure/security-center) alert feature to monitor for any suspicious outbound connectivity in a NAT gateway.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Ethan Haslett](https://www.linkedin.com/in/ethan-haslett-1502841/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Well-Architected Framework](/azure/well-architected/)
- [Tutorial: Create a NAT gateway using the Azure portal](/azure/virtual-network/nat-gateway/quickstart-create-nat-gateway-portal)
- [Recommendations for using availability zones and regions](/azure/well-architected/reliability/regions-availability-zones)

## Related resources

- [Azure network virtual appliances firewall architecture overview](../../networking/guide/network-virtual-appliances-architecture.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml)
- [Multi-region load balancing with Traffic Manager, Azure Firewall, and Application Gateway](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml)

