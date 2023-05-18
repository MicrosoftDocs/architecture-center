This reference architecture illustrates how to design a hybrid Domain Name System (DNS) solution to resolve names for workloads that are hosted on-premises and in Microsoft Azure. This architecture works for users and other systems that are connecting from on-premises and the public internet.

## Architecture

:::image type="content" source="./images/hybrid-dns-infra.svg" alt-text="Diagram showing a Hybrid Domain Name System (DNS)." border="false" lightbox="./images/hybrid-dns-infra.svg" :::

*Download a [Visio file][architectual-diagram-visio-source] of this architecture.*

### Workflow

The architecture consists of the following components:

- **On-premises network**. The on-premises network represents a single datacenter that's connected to Azure over an [Azure ExpressRoute][1] or [virtual private network (VPN)][2] connection. In this scenario, the following components make up the on-premises network:
  - **DNS** servers. These servers represent two servers with DNS service installed that are acting as resolver/forwarder. These DNS servers are used for all computers in the on-premises network as DNS servers. Records must be created on these servers for all endpoints in Azure and on-premises.
  - **Gateway**. The [gateway][3] represents either a VPN device or an ExpressRoute connection that's used to connect to Azure.
- **Hub subscription**. The hub subscription represents an Azure subscription that's used to host connectivity, management, and networking resources that are shared across multiple Azure-hosted workloads. These resources can be broken down into multiple subscriptions, as described in the [enterprise-scale architecture.][4]
  > [!NOTE]
  > The hub virtual network can be substituted with a [virtual wide area network (WAN)][5] hub, in which case the DNS servers would have to be hosted in a different [Azure virtual network (VNet)][6]. In the Enterprise-scale architecture, that VNet is maintained in its own subscription entitled the **Identity subscription**.
  - **Azure Bastion subnet**. The Azure Bastion service in the hub virtual network is used for remoting to virtual machines (VMs) in the hub and spoke VNets from the public internet for maintenance purposes.
  - **Private endpoint subnet**. The private endpoint subnet hosts private endpoints for Azure-hosted workloads in VNets that aren't peered to the hub. With this type of disconnected VNet, its IP addresses can clash with other IP addresses that are used in Azure and on-premises.
  - **Gateway subnet**. The gateway subnet hosts the Azure VPN, or ExpressRoute, gateway that's used to provide connectivity back to the on-premises datacenter.
  - **Shared services subnet**. The shared services subnet hosts services that are shared among multiple Azure workloads. In this scenario, this subnet hosts virtual machines running Windows or Linux that are also used as DNS servers. These DNS servers host the same DNS zones as the on-premises servers.
- **Connected subscription**. The connected subscription represents a collection of workloads that require a virtual network and connectivity back to the on-premises network.
  - **VNet peering**. This component is a [peering][7] connection back to the hub VNet. This connection allows connectivity from the on-premises network to the spoke and back through the hub VNet.
  - **Default subnet**. The default subnet contains a sample workload.
    - **web-vmss**. This sample [virtual machine scale set][8] hosts a workload in Azure that can be accessed from on-premises, Azure, and the public internet.
    - **Load balancer**. The [load balancer][9] provides access to a workload that a series of VMs host. The IP address of this load balancer in the **default** subnet must be used to access the workload from Azure and from the on-premises datacenter.
  - **AppGateway subnet**. This subnet is the required subnet for the Azure Application Gateway service.
    - **AppGateway**. [Application Gateway][10] provides access to the sample workload in the **default** subnet to users from the public internet.
    - **wkld1-pip**. This address is the public IP address that's used to access the sample workload from the public internet.
- **Disconnected subscription**. The disconnected subscription represents a collection of workloads that don't require connectivity back to the on-premises datacenter and that use the [private link service][11].
  - **PLSSubnet**. The private link service subnet (PLSSubnet) contains one or more private link service resources that provide connectivity to workloads hosted in the **Connected subscription**.
  - **Default subnet**. The default subnet contains a sample workload.
    - **web-vmss**. This sample virtual machine scale set hosts a workload in Azure that can be accessed from on-premises, Azure, and the public internet.
    - **Load balancer**. The load balancer provides access to a workload that a series of VMs host. This load balancer is connected to the private link service to provide access for users that are coming from Azure and the on-premises datacenter.
  - **AppGateway subnet**. This subnet is the required subnet for the Application Gateway service.
    - **AppGateway**. Application Gateway provides access to the sample workload in the **default** subnet to users from the public internet.
    - **wkld2-pip**. This address is the public IP address that's used to access the sample workload from the public internet.
  - **Azure Bastion subnet**. The Azure Bastion service in the disconnected virtual network is used for remoting to VMs in the hub and spoke VNets from the public internet for maintenance purposes.

## Components

- [Virtual Network](https://azure.microsoft.com/services/virtual-network). Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion). Azure Bastion is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses.

- [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway). VPN Gateway sends encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. You can also use VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. A VPN gateway is a specific type of virtual network gateway.

- [Private Link](https://azure.microsoft.com/services/private-link). Azure Private Link provides private connectivity from a virtual network to Azure platform as a service (PaaS), customer-owned, or Microsoft partner services. It simplifies the network architecture and secures the connection between endpoints in Azure by eliminating data exposure to the public internet.

- [Application Gateway](https://azure.microsoft.com/services/application-gateway). Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to your web applications. Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP) and route traffic based on source IP address and port, to a destination IP address and port.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

> [!NOTE]
> For the following recommendations, we'll refer to **Workload 1** as a connected workload and **Workload 2** as a disconnected workload. We'll also refer to users and systems that access those workloads as **on-premises users**, **internet users**, and **Azure systems**.

### Extend AD DS to Azure (optional)

Use integrated DNS zones in AD DS to host DNS records for your on-premises datacenter and Azure. In this scenario, there are two sets of AD DS DNS servers: one on-premises and one in the hub VNet.

We recommend [extending your AD DS domain to Azure][12]. We also recommend configuring the hub and spoke VNets to use the AD DS DNS servers in the hub VNet for all the VMs in Azure.

> [!NOTE]
> This recommendation is applicable only for organizations that use Active Directory Integrated DNS zone for name resolution. Others can consider implementing DNS servers that act as resolver/forwarder.

### Configure split-brain DNS

Make sure that split-brain DNS is in place to allow Azure systems, on-premises users, and internet users to access workloads based on where they're connecting from.

For both connected and disconnected workloads, we recommend the following components for DNS resolution:

- [Azure DNS zones][13] for internet users.
- DNS servers for on-premises users and Azure systems.
- [Azure private DNS zones][14] for resolution between Azure VNets.

To better understand this split-brain recommendation, consider **Workload 1**, for which we'll use the **wkld1.contoso.com** fully qualified domain name (FQDN).

In this scenario, internet users must resolve that name to the public IP address that Application Gateway exposes through **Wkld1-pip**. This resolution is done by creating an address record (A record) in Azure DNS for the connected subscription.

On-premises users must resolve the same name to the internal IP address for the load balancer in the connected subscription. This resolution is done by creating an A record in the DNS servers in the hub subscription.

Azure systems can resolve the same name to an internal IP address for the load balancer in the connected subscription either by creating an A record in the DNS server in the hub subscription, or by using private DNS zones. When you're using private DNS zones, either manually create an A record in the private DNS zone or enable autoregistration.

### Use private DNS zones for a private link

In our scenario, **Workload 2** is hosted in a disconnected subscription, and access to this workload for on-premises users and connected Azure systems is possible through a private endpoint in the hub VNet. However, there's a third connection possibility for this workload: Azure systems in the same VNet as **Workload 2**.

To better understand the DNS recommendations for **Workload 2**, we'll use the **wkld2.contoso.com** FQDN and discuss the individual recommendations.

In this scenario, internet users must resolve that name to the public IP address that Application Gateway exposes through **Wkld2-pip**. This resolution is done by creating an A record in Azure DNS for the connected subscription.

On-premises users and Azure systems that are connected to the hub VNet and spoke VNets must resolve the same name to the internal IP address for the private endpoint in the Hub VNet. This resolution is done by creating an A record in the DNS servers in the hub subscription.

Azure systems in the same VNet as **Workload 2** must resolve the name to the IP address of the load balancer in the disconnected subscription. This resolution is done by using a private DNS zone in Azure DNS in that subscription.

Azure systems in different VNets can still resolve the IP address of the **Workload 2** if you link those VNets with private DNS zone that is hosting the A record for **Workload 2**.

### Enable autoregistration

When you configure a VNet link with a private DNS zone, you can optionally configure autoregistration [autoregistration for all the virtual machines][15].

> [!NOTE]
> Autoregistration works only for virtual machines. For all other resources that are configured with IP address from the VNet, you have to create DNS records manually in the private DNS zone.

If you're using AD DS DNS server, configure Windows VMs can use dynamic updates for Windows computers to keep your own DNS records up to date in the AD DS DNS servers. We recommend enabling dynamic updates and configuring the DNS servers to only allow secure updates.

Linux VMs do **not** support secure dynamic updates. For on-premises Linux computers, use Dynamic Host Configuration Protocol (DHCP) to register DNS records to the AD DS DNS servers.

For [Linux VMs in Azure][16], use an automated process.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

- Per Azure region or on-premises datacenters, consider using at least two DNS servers each.
- Notice how that's done in the previous scenario, with DNS servers on-premises and in the hub virtual network.

### Availability

- Consider placement of DNS servers. As described in the scalability considerations section, DNS servers should be placed close to the users and systems that need access to them.
  - Per Azure region. Each Azure region has its own hub VNet or vWAN hub. This is where your DNS servers must be deployed.
  - Per on-premises datacenter. You should also have a pair of DNS servers per on-premises datacenter for users and systems in those locations.
  - For isolated (disconnected) workloads, host a private DNS zone and a public DNS zone for each subscription to manage split-brain DNS records.

### Manageability

- Consider the need for DNS records for platform as a service (PaaS) services.
- You also must consider DNS resolution for PaaS services that use a private endpoint. Use a private DNS zone for that and use your DevOps pipeline to create records in the DNS servers.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- If you require the use of DNSSEC, consider that Azure DNS currently does **not** support it.
- For DNSSEC validation, deploy a custom DNS server and enable DNSEC validation.
- [Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### DevOps

- Automate configuration of this architecture by combining Azure Resource Manager templates for configuration of all the resources. Both private and public DNS zones support full management from Azure CLI, PowerShell, .NET, and REST API.
- If you're using a continuous integration and continuous development (CI/CD) pipeline to deploy and maintain workloads in Azure and on-premises, you can also configure autoregistration of DNS records.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Azure DNS zone costs are based on the number of DNS zones hosted in Azure and the number of received DNS queries.
- Use the [Azure pricing calculator][17] to estimate costs. Pricing models for Azure DNS is explained [here](https://azure.microsoft.com/pricing/details/dns/).
- The billing model for [Azure ExpressRoute][18] is based either on metered data, which charges you per gigabyte for outbound data transfer, or unlimited data, which charges a monthly fee including all data transfer.
- If you're using VPN, instead of ExpressRoute, the cost is dependent on the SKU of the [virtual network gateway][19] and is charged per hour.

## Next steps

Learn more about the component technologies:

- [What is Azure DNS?](/azure/dns/dns-overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)

## Related resources

Explore related architectures:

- [Azure enterprise cloud file share](./azure-files-private.yml)
- [Windows N-tier application on Azure](../reference-architectures/n-tier/n-tier-sql-server.yml)
- [N-tier application with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)
- [Multitenant SaaS on Azure](../example-scenario/multi-saas/multitenant-saas.yml)
- [Extend an on-premises network using ExpressRoute](../reference-architectures/hybrid-networking/expressroute.yml)

[architectual-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-dns-infra.vsdx
[1]: /azure/expressroute/expressroute-introduction
[2]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[3]: /azure/vpn-gateway/vpn-gateway-about-vpngateways#whatis
[4]: /azure/cloud-adoption-framework/ready/enterprise-scale/
[5]: /azure/virtual-wan/virtual-wan-about
[6]: /azure/virtual-network/virtual-networks-overview
[7]: /azure/virtual-network/virtual-network-peering-overview
[8]: /azure/virtual-machine-scale-sets/overview
[9]: /azure/load-balancer/load-balancer-overview
[10]: /azure/application-gateway/overview
[11]: /azure/private-link/private-link-service-overview
[12]: ../reference-architectures/identity/index.yml#integrate-your-on-premises-domains-with-azure-ad
[13]: /azure/dns/dns-zones-records
[14]: /azure/dns/private-dns-overview
[15]: /azure/dns/private-dns-autoregistration
[16]: /azure/virtual-machines/linux/azure-dns
[17]: https://azure.microsoft.com/pricing/calculator/
[18]: https://azure.microsoft.com/pricing/details/expressroute/
[19]: https://azure.microsoft.com/pricing/details/vpn-gateway/
