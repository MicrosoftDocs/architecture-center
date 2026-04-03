This reference architecture describes how to design a hybrid Domain Name System (DNS) solution to resolve names for workloads hosted on-premises and in Microsoft Azure.

## Architecture

:::image type="complex" border="false" source="./images/hybrid-dns-infrastructure.svg" alt-text="Diagram that shows a hybrid DNS." lightbox="./images/hybrid-dns-infrastructure.svg":::
   The diagram shows a hybrid DNS architecture. It includes three subscriptions: on-premises, connectivity, and workload. The on-premises section on the left includes DNS servers and on-premises VPN/Azure ExpressRoute termination. A double-sided arrow points from on-premises VPN/ExpressRoute termination to VPN/ExpressRoute gateway in the gateway subnet (10.0.1.0/27). The connectivity subscription in the center includes two main sections: the shared services virtual network (10.1.0.0/16) and the hub virtual network (10.0.0.0/16). A double-sided arrow labeled DNS virtual network link points from Azure private DNS zone to the shared services virtual network. Two double-sided arrows point from the forwarding ruleset and DNS Private Resolver to the outbound endpoint (10.1.0.0/26). Another double-sided arrow points from Azure DNS Private Resolver to the inbound endpoint (10.1.0.64/26). Virtual network peering connects the virtual networks. The hub virtual network includes the gateway subnet and Azure Firewall subnets. The gateway subnet includes the VPN/ExpressRoute gateway. The Azure Firewall subnet (10.0.1.64/26) includes the Azure Firewall DNS server (10.1.0.4). The workload subscription on the right has two parts: the workload subnet (10.2.1.0/24) enclosed in the spoke virtual network (10.2.0.0/16) and custom DNS servers (10.0.1.68).
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/hybrid-dns-infrastructure.vsdx) of this content.*

## Components

- The on-premises network represents a single datacenter that connects to Azure over an [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) or [virtual private network (VPN)](/azure/vpn-gateway/design) connection. In this architecture, the following components make up the on-premises network:

  - DNS servers represent one or more servers that function as the name resolver for on‑premises systems. You must set up these servers by using conditional forwarding rules that send DNS requests for Azure systems or private endpoints to the inbound endpoint for Azure DNS Private Resolver. Azure DNS forwarding rulesets reference the IP addresses of the on-premises DNS servers for domains hosted on-premises.

  - The on-premises gateway represents either a VPN termination device or a router that connects to ExpressRoute and provides private connectivity to the Azure environment.

- The connectivity subscription represents an Azure subscription that you use for resources that provide connectivity to workloads hosted on Azure.

  - [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. In this architecture, virtual networks connect Azure resources like virtual machines (VMs), support communication with the internet and on-premises networks, and use subnets to organize resources.

    - The hub [virtual network](/azure/virtual-network/virtual-networks-overview) is a central virtual network that hosts connectivity resources. In this architecture, it includes Virtual Network gateways, Azure Firewall, SD-WAN network virtual appliances (NVAs), and firewall NVAs.

      - The [gateway subnet](/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsub) is a dedicated subnet that hosts virtual network gateways. In this architecture, it hosts the Azure VPN or ExpressRoute gateway that provides connectivity back to the on-premises datacenter.

      - The Azure Firewall subnet is a dedicated subnet with a `/26` network mask that hosts Azure Firewall. In this architecture, Azure Firewall filters traffic and provides DNS proxy services. For more information, see [Azure Firewall /26 subnet size requirements](/azure/firewall/firewall-faq#why-does-azure-firewall-need-a--26-subnet-size).

    - The shared services virtual network is a virtual network that hosts resources that provide services to multiple workloads. In this architecture, it hosts DNS servers and other shared resources. If you use a self-managed hub-and-spoke architecture, you can move shared services to the hub virtual network to reduce the number of virtual network peering hops between workloads and shared services. When you set up routing, make sure to not override the system route for the hub address space in the spoke virtual networks. Instead, apply user-defined routes (UDRs) only to the specific subnets that must reach shared services. This approach helps prevent asymmetric routing, especially when firewalls are in the path. For more information, see [Hub virtual network workload](/azure/firewall/firewall-multi-hub-spoke#hub-virtual-network-workloads).

    - [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) is a connection between two virtual networks that lets resources communicate privately. In this architecture, peerings connect spoke virtual networks to the hub and grant them connectivity to the rest of the environment. You must set up virtual network peering to use the virtual network gateway (VPN or ExpressRoute) in the hub so that the gateway propagates the workload and shared services virtual network IP address prefixes to on-premises.

  - [DNS Private Resolver](/azure/dns/dns-private-resolver-overview) is a Microsoft-managed service that provides DNS resolution in Azure, including conditional forwarding of DNS requests to other DNS servers. In this architecture, it handles DNS resolution between Azure and on-premises environments without requiring you to manage the underlying operating system.

    - [DNS forwarding rulesets](/azure/dns/private-resolver-endpoints-rulesets#dns-forwarding-rulesets) are collections of rules that define which name domains forward to which external DNS servers. In this architecture, the rulesets include all on‑premises domains and the IP addresses of the on‑premises DNS servers as forwarding targets. You link forwarding rulesets to virtual networks to provide external DNS resolution. The previous diagram shows the [centralized DNS architecture](/azure/dns/private-resolver-architecture) for external name resolution with DNS Private Resolver. This architecture requires linking the forwarding ruleset to the virtual network where the private resolver is deployed, which is the shared services virtual network in this architecture.

    - **Inbound endpoint subnet:** DNS requests to DNS Private Resolver must go to the IP address of its inbound endpoint. You set up this address in the forwarding rules on your on-premises DNS servers and as the DNS server for Azure Firewall.

    - **Outbound endpoint subnet:** When DNS Private Resolver needs to forward DNS requests to external servers based on forwarding rules, it sources those requests from this subnet. The minimum size for inbound and outbound endpoint subnets is `/28`, but this architecture uses `/26` for added flexibility if limits change. For more information, see [Subnet restrictions](/azure/dns/dns-private-resolver-overview#subnet-restrictions).

  - A [VPN gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet. You can also use Azure VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. In this architecture, a VPN gateway provides the connectivity between the hub virtual network and the on-premises datacenter.

  - An [ExpressRoute gateway](/azure/expressroute/expressroute-about-virtual-network-gateways) is a virtual network gateway that connects a virtual network to an ExpressRoute circuit, which is a dedicated private connection with guaranteed bandwidth between Microsoft and your on-premises environment. In this architecture, it provides private connectivity between the hub virtual network and your on-premises environment.

  - [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native network security service that inspects network traffic and filters it based on configured rules. In this architecture, it serves as a DNS proxy to support fully qualified domain name (FQDN) network rules and DNS logging. For more information, see [Azure Firewall DNS proxy](/azure/firewall/dns-details).

  - [Azure private DNS zones](/azure/dns/private-dns-overview) are containers that host DNS records for private name resolution from linked Azure virtual networks. In this architecture, they provide DNS resolution for Azure workloads, support VM autoregistration, and integrate automatically with private link endpoints through DNS virtual network links.

- The connected workload subscription represents a collection of workloads that require a virtual network and connectivity back to the on-premises network.

  - **Workload virtual network and subnet:** You can inject infrastructure as a service (IaaS) workloads like VMs or virtual machine scale sets, and platform as a service (PaaS) resources like Azure SQL and Azure App Service, into virtual networks.

  - **Workload:** In this example, a [virtual machine scale set](/azure/virtual-machine-scale-sets/overview) or a collection of individual [VMs](/azure/virtual-machines/overview) hosts a workload in Azure that you can access from on-premises, Azure, and the public internet.

## Alternatives

You can modify the topology described in this article and adapt it to your specific requirements. This section describes some of the most common variations:

- Use [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) instead of a self-managed hub-and-spoke solution. In this architecture, a virtual hub replaces the hub virtual network. A virtual hub is a Microsoft-managed virtual network that supports only specific resource types. It supports firewalls (Azure Firewall and non-Microsoft firewalls), virtual network gateways for VPN and ExpressRoute, and SD-WAN NVAs. For more information, see [Non-Microsoft integrations with Virtual WAN hub](/azure/virtual-wan/third-party-integrations).

- Consolidate shared resources and hub virtual networks. You can deploy your DNS Private Resolver, DNS servers, or other shared resources like Azure Bastion or file shares in the hub virtual network. This approach works only if you don't use Virtual WAN. If you have an Azure firewall in your hub virtual network, be careful with routing from the spoke virtual networks to the shared services subnet. In your UDRs, specify only the shared services subnet prefix, not the whole hub virtual network range.

- Use Active Directory domain controllers that run on Azure VMs as DNS servers. In this case, you [run the domain controller VMs in the identity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones), and the domain controllers replace the functionality of DNS Private Resolver. For more information, see [Deploy Active Directory Domain Services (AD DS) in an Azure virtual network](/azure/architecture/example-scenario/identity/adds-extend-domain).

- Deploy custom DNS server software, like [BIND](https://www.isc.org/bind/), that runs on VMs instead of DNS Private Resolver. This option adds management overhead but provides more flexibility. If your organization is familiar with open-source servers like BIND, you can use the same technology in Azure.

- Use DNS Private Resolver for workloads when you have a non-Microsoft firewall that doesn't need to be in the DNS resolution path to support features like FQDN-based rules. Set up the inbound endpoint's IP address as the custom DNS server in the workload virtual network, or link the DNS forwarding ruleset to the workload virtual network. Then set up the DNS Private Resolver inbound endpoint's IP address as the target in your on-premises DNS conditional forwarding rules.

## Workflows

This section explains how hybrid resolution flows work in two main cases:

- An Azure workload tries to resolve a domain name for a system hosted on-premises.

- An on-premises workload tries to resolve a domain name for a system hosted in Azure.

### Azure to on-premises

Azure VMs might need to access on-premises systems like database or monitoring applications. They must be able to resolve domain names for which the authoritative servers are the on-premises DNS servers. This flow has different scenarios, as the following image shows.

:::image type="complex" border="false" source="./images/hybrid-dns-infrastructure-outbound.svg" alt-text="Diagram that shows hybrid resolution from Azure to on-premises." lightbox="./images/hybrid-dns-infrastructure-outbound.svg":::
   Diagram that shows hybrid resolution from Azure to on-premises. It includes three main subscriptions: on-premises, connectivity, and workload. The on-premises section on the left includes DNS servers and on-premises VPN/ExpressRoute termination. The connectivity subscription in the center includes two main sections: the shared services virtual network and the hub virtual network. A double-sided arrow labeled DNS virtual network link points from Azure private DNS zone to the shared services virtual network. Two double-sided arrows point from the forwarding ruleset and DNS Private Resolver to the outbound endpoint (10.1.0.0/26). Another double-sided arrow points from DNS Private Resolver to the inbound endpoint (10.1.0.64/26). Virtual network peering connects the virtual networks. The hub virtual network includes both the gateway and Azure Firewall subnets. The gateway subnet (10.0.1.0/27) includes the VPN or ExpressRoute gateway. The Azure Firewall subnet, which uses the address range 10.0.1.64 to 10.0.1.127, contains the Azure Firewall at 10.0.1.68. The firewall is configured to use a DNS server at 10.1.0.4 in the shared services virtual network, and the firewall's IP address, 10.0.1.68, is set as the custom DNS server for the spoke or workload virtual network. The workload subscription on the right has two parts: the workload subnet (10.2.1.0/24) enclosed in the spoke virtual network (10.2.0.0/16) and custom DNS servers (10.0.1.68). There are four steps in the diagram. In step 1, an arrow points from the workload in the workload subscription section to Azure Firewall in the hub virtual network. In step 2, an arrow points from the Azure Firewall subnet to the inbound endpoint in the shared services virtual network. In step 3, an arrow points from the outbound endpoint to the DNS servers in the on-premises section. The DNS servers are labeled step 4.
:::image-end:::

1. The workload sends the DNS request to Azure Firewall because the IP address of Azure Firewall is configured as the [custom DNS server](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances) in the virtual network.

1. Azure Firewall forwards the DNS request to the inbound endpoint of the DNS Private Resolver.

1. If DNS Private Resolver finds a match in the rulesets associated with its outbound endpoints, it forwards the DNS request to the target specified in the rule, which should be the on-premises DNS servers.

1. One of the on-premises DNS servers resolves the DNS query.

The previous model in this article uses the IP address of the inbound endpoint as the custom DNS server. This model is the *centralized DNS architecture* in the [DNS Private Resolver architecture](/azure/dns/private-resolver-architecture). DNS Private Resolver also provides external DNS resolution by linking DNS forwarding rulesets to virtual networks, which is the [distributed DNS architecture](/azure/dns/private-resolver-architecture#distributed-dns-architecture). If you link the forwarding ruleset to the hub virtual network, set up Azure Firewall to use Azure DNS as its DNS server. The IP address `168.63.129.16` represents Azure DNS in Azure.

### On-premises to Azure

On-premises systems might need name resolution for workloads that you deploy in Azure or for private endpoints of Azure PaaS services. This name resolution follows this workflow.

:::image type="complex" border="false" source="./images/hybrid-dns-infrastructure-inbound.svg" alt-text="Diagram that shows hybrid resolution from on-premises to Azure." lightbox="./images/hybrid-dns-infrastructure-inbound.svg":::
  Diagram that shows hybrid resolution from on-premises to Azure. The architecture includes three main subscription sections: on-premises, connectivity, and workload. The on-premises section on the left includes a workload, DNS servers, and on-premises VPN or ExpressRoute termination. In step 1, an arrow points from the workload to the DNS servers. In step 2, an arrow points from DNS servers to the Azure Firewall subnet in the hub virtual network. The connectivity subscription in the center includes two main sections: the shared services virtual network and the hub virtual network. A double-sided arrow labeled DNS virtual network link points from Azure private DNS zone to the shared services virtual network. Two double-sided arrows point from the forwarding ruleset and DNS Private Resolver to the outbound endpoint (10.1.0.0/26). Another double-sided arrow points from DNS Private Resolver to the inbound endpoint (10.1.0.64/26). The hub virtual network includes the gateway subnet and Azure Firewall subnet. The gateway subnet (10.0.1.0/27) includes the VPN or ExpressRoute gateway. The Azure Firewall subnet (10.0.1.64/26) includes the Azure Firewall DNS server (10.1.0.4). Virtual network peering connects the shared services virtual network and the hub virtual network. In step 3, an arrow points from the Azure Firewall subnet to the inbound endpoint in the shared services virtual network. In step 4, DNS Private Resolver resolves queries for any private DNS zone linked to the virtual network where it's deployed. The workload subscription on the right has two parts: the workload subnet (10.2.1.0/24) enclosed in the spoke virtual network (10.2.0.0/16) and custom DNS servers (10.0.1.68).
:::image-end:::

1. The on-premises workload sends a DNS request to the on-premises DNS server.

1. The on-premises DNS server forwards the query to the DNS Private Resolver inbound endpoint, based on its configured forwarding rules.

1. If you set up Azure Firewall as a DNS proxy, the DNS Private Resolver outbound endpoint forwards the query to Azure Firewall, which then uses Azure DNS for external resolution.

1. DNS Private Resolver resolves queries for any private DNS zone linked to the virtual network where it's deployed.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Extend AD DS to Azure (optional)

If your organization uses Active Directory integrated DNS zones for name resolution, extend your Active Directory domain to Azure. This approach requires an extra set of Active Directory domain controllers that run in an Azure virtual network, preferably in the identity subscription described earlier.

### Set up split-brain DNS

If you have applications that users access internally and externally over the public internet, the access path depends on the users' location. You can set up split-brain DNS so that users don't need to use different host names based on where they are. Split-brain DNS provides different name resolution for the same FQDN to on-premises and internet users. Internet users resolve the application FQDN by using publicly available Azure DNS zones, while you direct DNS requests from internal users to DNS Private Resolver by using the mechanism described in this article.

### Integrate your private endpoints by using private DNS zones

[Azure Private Link](/azure/private-link/private-link-overview) endpoints provide private connectivity to many Azure PaaS resources. Private Link uses a specific type of split-brain DNS implementation. Microsoft provides the public resolution automatically. When a user resolves the FQDN of an Azure PaaS resource that has any private endpoint, Microsoft redirects the name resolution to a new zone name. For example, Microsoft redirects storage accounts that have private endpoints from `blob.core.windows.net` to `privatelink.blob.core.windows.net`. For the zone name for each service, see [Azure private endpoint private DNS zone values](/azure/private-link/private-endpoint-dns).

This mechanism lets you control name resolution when you deploy an Azure private DNS zone for that *privatelink* domain. Users who have access to domain resolution through the private zone receive the Azure PaaS FQDN that resolves to a private IP address. Otherwise, Microsoft provides public resolution for the *privatelink* domains and provides the PaaS service's public IP address to users without access to the private DNS zone. For more information, see [Azure private endpoint DNS integration](/azure/private-link/private-endpoint-dns-integration).

### Turn on autoregistration

When you set up a virtual network link by using a private DNS zone, you can optionally turn on [autoregistration for all VMs](/azure/dns/private-dns-autoregistration). When you use DNS private zone autoregistration, new VMs automatically create DNS records in the private DNS zone so that other systems in Azure and on‑premises can resolve their names.

Azure private DNS zone autoregistration is especially useful for Linux VMs because Linux doesn't provide built-in mechanisms that automatically register their IP addresses in a DNS server. In on-premises environments, Dynamic Host Configuration Protocol (DHCP) servers often provide this automatic registration of all systems in DNS, but Azure virtual networks don't support DHCP.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Scalability and availability

- Confirm that your architecture remains within the [DNS Private Resolver limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#dns-private-resolver1).

- Deploy all Azure resources across availability zones. If you use VMs as DNS servers instead of DNS Private Resolver, distribute at least two DNS servers across availability zones for better resiliency and scalability.

- Deploy at least two VMs when you use them as DNS servers. You can either use [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) to provide a single IP address to your DNS clients, or set up all DNS server IP addresses in your DNS clients. Load Balancer simplifies client configuration and supports easier migrations, but it might add cost.

- Place DNS servers close to the users and systems that need access to them. Consider providing DNS resolution in each Azure region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Consider [protecting private DNS zones and records](/azure/dns/dns-protect-private-zones-recordsets). Restrict administrative access to DNS to reduce misconfigurations, like accidentally deleting private zones, that can disrupt name resolution across many systems.

- Consider using [Domain Name System Security Extensions (DNSSEC)](/azure/dns/dnssec) if you use public DNS.

- Set up [Azure DNS security policies](/azure/dns/dns-security-policy) for extra security in Azure DNS. For more information, see [Azure security baseline for Azure DNS](/security/benchmark/azure/baselines/azure-dns-security-baseline).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Optimize costs by reviewing how your DNS traffic flows. If you set up your DNS Private Resolver or your DNS servers in your hub virtual network, DNS resolutions traverse fewer virtual network peerings, which makes this traffic cheaper. But DNS requests don't consume much bandwidth, so this optimization provides limited cost savings. You can't use this approach if you use Virtual WAN or if your DNS servers must reside in a different subscription.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs. For more information, see [Azure DNS pricing](https://azure.microsoft.com/pricing/details/dns/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use DNS Private Resolver instead of custom DNS server software like BIND when possible to reduce management overhead.

- Use static IP addresses for the inbound and outbound endpoints of DNS Private Resolver so that they remain consistent and predictable across deployments.

- Implement integration between private endpoints and private DNS zones when you use Azure Policy. For more information, see [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

- Set up DNS logging in the Azure Firewall diagnostic settings. For more information about the format of Azure Firewall DNS logs, see [AZFWDnsQuery](/azure/azure-monitor/reference/tables/azfwdnsquery).

- Set up Azure DNS security policies and use diagnostic settings to collect DNS-level logs.

## Related resources

- [Connect an on-premises network to Azure](../reference-architectures/hybrid-networking/index.yml)
- [Deploy AD DS in an Azure virtual network](../example-scenario/identity/adds-extend-domain.yml)
