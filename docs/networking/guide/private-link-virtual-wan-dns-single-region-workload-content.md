This article shows how to expose a PaaS resource to a workload over a private endpoint in a single-region Azure Virtual WAN hub-and-spoke topology.

> [!IMPORTANT]
> This article is part of a series on Azure Private Link and Azure DNS in Virtual WAN and builds on the network topology defined in the scenario guide. Read the [overview page first](./private-link-virtual-wan-dns-guide.yml) to understand the base network architecture and key challenges.

## Scenario

:::image type="complex" source="images/dns-private-endpoints-virtual-wan-scenario-single-region.svg" lightbox="images/dns-private-endpoints-virtual-wan-scenario-single-region.svg" alt-text="Diagram showing the single-region architecture.":::
Diagram showing the single-region architecture.
:::image-end:::
*Figure 1: Single-region scenario for Virtual WAN with Private Link and Azure DNS - the challenge*

*Download a [Visio file](https://arch-center.azureedge.net/dns-private-endpoints-virtual-wan.vsdx) of this architecture.*
This section outlines the scenario and restates the challenge from the [nonworking example in the overview](private-link-virtual-wan-dns-guide.yml#nonworking-scenario). The architecture builds on the [starting network topology](private-link-virtual-wan-dns-guide.yml#starting-network-topology) with the following additions:

- There's only one region with one virtual hub.
- There's an Azure Storage account in the region that has public network access disabled. The assumption in this scenario is that only one workload accesses the storage account.
- There's initially a single virtual network connected to the virtual hub.
- The virtual network has a workload subnet that contains a virtual machine (VM) client.
- The virtual network contains a private endpoint subnet that contains a private endpoint for the storage account.

### Successful outcome

The VM client can connect to the storage account via the private endpoint in the same virtual network, and all other access to the storage account is blocked.

### Impediment

You need a DNS record in the DNS flow that resolves the fully qualified domain name (FQDN) of the storage account to the private IP address of the private endpoint. As identified in the [overview](private-link-virtual-wan-dns-guide.yml#key-challenges), the challenge in this scenario is twofold:

1. It isn't possible to link a private DNS zone that maintains the storage account's required DNS records to a virtual hub.
1. You can link a private DNS zone to the workload network, so it might seem viable, but the [baseline architecture](private-link-virtual-wan-dns-guide.yml#starting-network-topology) stipulates that each connected virtual network has DNS servers configured to use the Azure Firewall DNS proxy.

Because you can't link a private DNS zone to a virtual hub, and the virtual network is configured to use the Azure Firewall DNS proxy, Azure DNS cannot resolve the FQDN of the storage account to the private IP address. The result is that the client receives the public IP address instead.

#### DNS and HTTP flows

Let's review the DNS and resulting HTTP request flows to visualize the impediment.

:::image type="complex" source="images/dns-private-endpoints-virtual-wan-scenario-single-region-challenge.svg" lightbox="images/dns-private-endpoints-virtual-wan-scenario-single-region-challenge.svg" alt-text="Diagram that shows the single-region challenge.":::
Diagram that shows the single-region challenge. The secured virtual hub can't resolve the DNS values that the spoke needs for communicating to a local private endpoint.
:::image-end:::
*Figure 2: Single-region scenario for Virtual WAN with Private Link and Azure DNS - the challenge*

*Download a [Visio file](https://arch-center.azureedge.net/dns-private-endpoints-virtual-wan.vsdx) of this architecture.*

**DNS flow**

1. The DNS query for `stgworkload00.blob.core.windows.net` from the client is sent to the configured DNS server, which is Azure Firewall in the peered regional hub.
1. Azure Firewall proxies the request to Azure DNS. Because it isn't possible to link a private DNS zone to a virtual hub, Azure DNS doesn't know how to resolve the FQDN to the private endpoint's IP address. Azure DNS resolves the FQDN to the public IP address of the storage account and returns that value.

**HTTP flow**

1. With the DNS result (the public IP address of the storage account), the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
1. The request is sent to the public IP address of the storage account. This request fails for many reasons:
   - The NSG on the workload subnet might not allow this Internet-bound traffic.
   - The Azure Firewall that is filtering Internet-bound egress traffic likely doesn't have an application rule to support this flow.
   - Even if both the NSG and Azure Firewall had allowances for this request flow, the storage account is configured to block all public network access.

   This attempt violates the goal of allowing access only via the private endpoint.

## Solution - Establish a virtual hub extension for DNS

The recommended solution for DNS in Virtual WAN environments is to implement a [virtual hub extension](./private-link-virtual-wan-dns-virtual-hub-extension-pattern.yml) for DNS. This pattern is detailed in the associated architecture article and provides the foundation for the working single‑region scenario shown here. The DNS virtual hub extension enables workload teams to use private DNS zones within the [starting Virtual WAN hub topology](./private-link-virtual-wan-dns-guide.yml#starting-network-topology).

The DNS extension is implemented as a virtual network spoke that is peered to its regional virtual hub. Private DNS zones can link to this virtual network. The virtual network also contains an Azure DNS Private Resolver that enables services outside of this virtual network, like Azure Firewall, to query and receive values from all linked private DNS zones. The following are the components of a typical virtual hub extension for DNS, along with some required configuration changes:

- A new spoke virtual network that is peered with the region's virtual hub. This spoke is configured like any other spoke, meaning default DNS server and routing rules force the use of Azure Firewall in the regional hub.
- A DNS Private Resolver resource is deployed with an [inbound endpoint](/azure/dns/private-resolver-endpoints-rulesets#inbound-endpoints) in the spoke virtual network.
- A private DNS zone resource named `privatelink.blob.core.windows.net` is created.
  - This zone contains an `A` record that maps the storage account FQDN to the private IP address of the private endpoint for the storage account.
  - The private DNS zone is linked to the spoke virtual network.
  - If Azure role-based access control (Azure RBAC) allows, you can use [auto registration](/azure/dns/private-dns-autoregistration) or service-managed entries to maintain these DNS records. If not, you must maintain them manually.
- In the regional hub, the Azure Firewall's DNS server is changed to point at the DNS Private Resolver's inbound endpoint.

The following diagram illustrates the architecture, along with both the DNS and HTTP flows.

:::image type="complex" source="images/dns-private-endpoints-virtual-wan-scenario-single-region-works.svg" lightbox="images/dns-private-endpoints-virtual-wan-scenario-single-region-works.svg" alt-text="Diagram showing the working solution with a Virtual hub extension for DNS.":::
The diagram shows a virtual hub that Azure Firewall secures. It's connected to two virtual networks in a single region. One virtual network contains a DNS Private Resolver. The other virtual network contains a subnet with a VM client and a subnet with a Private Link endpoint. Both virtual networks have the Azure Firewall configured as their DNS server. A private DNS zone is linked to the virtual network containing the resolver and contains an A record with a value of the private IP address of the storage account private endpoint. The diagram shows a DNS flow and an HTTP flow. The DNS flow shows the following steps: 1. A DNS query for the storage account FQDN is sent to Azure Firewall, 2. Azure Firewall forwards the query to its configured DNS server that is the DNS Private Resolver, 3. The DNS Private Resolver proxies to Azure DNS and 4. Azure DNS is aware of the private DNS zone. The HTTP flow shows the client issuing an HTTP request to the Private Link endpoint and connecting to the storage account successfully.
:::image-end:::
*Figure 3: Working solution for single region scenario for Virtual WAN with Private Link and DNS*

*Download a [Visio file](https://arch-center.azureedge.net/dns-private-endpoints-virtual-wan.vsdx) of this architecture.*

### DNS flow for the virtual hub extension

1. The DNS query for `stgworkload00.blob.core.windows.net` from the client is sent to the configured DNS server, which is Azure Firewall in the peered regional hub - 10.100.0.132 in this case.

    :::image type="content" source="images/workload-virtual-network-configured-dns-server.png" lightbox="images/workload-virtual-network-configured-dns-server.png" alt-text="Screenshot of the workload virtual network showing that DNS servers are set to Custom and the private IP address of the Azure Firewall securing the hub added.":::
    *Figure 4: DNS servers configuration for workload virtual network*

1. Azure Firewall proxies the request to the regional Azure DNS Private Resolver in the hub extension - 10.200.1.4 in this case, which is the private IP address of the DNS Private Resolver's inbound endpoint.

    :::image type="complex" source="images/firewall-policy-dns-settings.png" lightbox="images/firewall-policy-dns-settings.png" alt-text="Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set.":::
    Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set to Custom. The entry points to the private IP address of the DNS Private Resolver input endpoint.
    :::image-end:::
    *Figure 5: DNS configuration in Azure Firewall policy*

1. DNS Private Resolver proxies the request to Azure DNS. Because a private DNS zone is linked to the virtual network containing the inbound endpoint, Azure DNS can use records in those linked private DNS zones.

    :::image type="content" source="images/private-dns-zone-linked-to-virtual-network.png" lightbox="images/private-dns-zone-linked-to-virtual-network.png" alt-text="Screenshot of the private DNS zone virtual network links showing a link to the DNS extension virtual network.":::
    *Figure 6: Private DNS zone virtual network links*

1. Azure DNS consults the linked private DNS zone and resolves the FQDN of `stgworkload00.blob.core.windows.net` to 10.1.2.4, which is the IP address of the private endpoint for the storage account. This response is provided to Azure Firewall DNS, which then returns the storage account's private IP address to the client.

    :::image type="content" source="images/private-dns-zone-config.png" lightbox="images/private-dns-zone-config.png" alt-text="Screenshot of the private DNS zone with the A record with name stgworkload00 and value 10.1.2.4.":::
    *Figure 7: Private DNS zone with the A record for storage account private endpoint*

**HTTP flow**

1. With the DNS result (the private IP address of the storage account), the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
1. The request is sent to the private IP address (10.1.2.4) of the storage account. This request routes successfully, assuming no conflicting restrictions on the local Network Security Groups on the client subnet or the private endpoint subnet. It's important to understand that, even though Azure Firewall is securing private traffic, the request doesn't get routed through Azure Firewall because the private endpoint is in the same virtual network as the client. This default behavior can change if user‑defined routes (UDRs) or Network Virtual Appliances (NVAs) are introduced, but this scenario assumes the standard VNet routing model. No Azure Firewall allowances are needed for this scenario.
1. A private connection to the storage account is established through the Private Link service. The storage account allows only private network access, and accepts the HTTP request.

### Virtual hub extension for DNS considerations

When implementing the extension for your enterprise, consider the following guidance.

- Deploying the DNS extension isn't a task for the workload team. This task is an enterprise networking function and should be an implementation decision made with those individuals.
- The DNS extension and private DNS zones must exist before you add any PaaS service for which you plan to configure private endpoint DNS records.
- The virtual hub extension is a regional resource, avoid cross-region traffic and establish a hub extension per regional hub where private endpoint DNS resolution is expected.

#### Spoke virtual network

- Following the single responsibility principle, the virtual network for the DNS extension should only contain the resources required for DNS resolution and shouldn't be shared with other resources.
- The virtual network for the DNS extension should follow the same configuration guidelines under [Adding spoke networks](./private-link-virtual-wan-dns-guide.yml#adding-spoke-networks).

#### Azure DNS Private Resolver
Azure DNS Private Resolver is a zone‑redundant service, providing high availability for production workloads without requiring customer‑managed clustering. In this single‑region scenario, only an inbound endpoint is needed; however, other architectures—such as hybrid name resolution, conditional forwarding, or cross‑environment resolution—may require outbound endpoints. Monitoring is available through Azure Monitor metrics and logs, which is recommended for operational readiness and troubleshooting. The same resolver capabilities can also be used in development scenarios, such as enabling private DNS resolution from a developer workstation when connected to the virtual network.

- Each region should have one virtual hub DNS extension with one DNS Private Resolver.
- The DNS Private Resolver only requires an inbound endpoint and no outbound endpoints for this scenario. Set the private IP of the inbound endpoint as the custom DNS service in the Azure Firewall policy (see figure 5).
- For higher resiliency and increased load handling, deploy two DNS Private Resolver instances (or at least two inbound IPs) per region, and configure both IPs on Azure Firewall DNS settings for redundant resolution.

    :::image type="content" source="images/dns-private-resolver-inbound-endpoints.png" lightbox="images/dns-private-resolver-inbound-endpoints.png" alt-text="Screenshot of the inbound endpoints for the DNS Private Resolver showing one endpoint.":::
    *Figure 8: Inbound endpoints for the DNS Private Resolver*

- Follow the [virtual network restrictions](/azure/dns/dns-private-resolver-overview#virtual-network-restrictions) for the DNS Private Resolver.
- Use a dedicated inbound endpoint subnet sized /28 or larger per resolver requirements; don't share it with other resources.
- The Network Security Group in the subnet for the DNS Private Resolver's inbound endpoint should only allow UDP traffic from its regional hub to port 53. Block all other inbound and outbound traffic.

#### Private DNS zone

Because Azure DNS Private Resolver forwards to Azure DNS, it can use any private DNS zones linked to the virtual network of its inbound subnet.

- Link the private DNS zone to the virtual hub extension virtual network.
- Follow the guidance on [managing private DNS zones for private endpoints](/azure/private-link/private-endpoint-dns).
- If you expect PaaS resource owners to manage their own entries, configure Azure RBAC accordingly or implement a solution such as the one from [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

## Scenario considerations

With a well-managed virtual hub DNS extension in place, let's turn back to the workload and address some additional points to help achieve the [successful outcome](#successful-outcome) objectives within this scenario.

### Storage account

- Set **Public network access**: **Disabled** under **Network connectivity** to ensure that the storage account can only be accessed via private endpoints.
- Add a private endpoint to a dedicated private endpoint subnet in the workload's virtual network.
- Send Azure Diagnostics to the workload Log Analytics Workspace. You can use the access logs to help troubleshoot configuration issues.

### Private endpoint security

A requirement of this solution is to limit the exposure of this storage account. Once you remove public internet access to your PaaS resource, you should address private networking security.

When Azure Firewall is securing private traffic in a Virtual WAN hub-spoke topology, Azure Firewall defaults to denying spoke-to-spoke connectivity. This default setting prevents workloads in other spoke networks from accessing private endpoints (and other resources) in the workload virtual network. Traffic fully within a virtual network isn't routed through Azure Firewall. To control access within the virtual network and add more granular protection, consider the following network security group (NSG) recommendations.

- Create an application security group (ASG) to group resources that have similar inbound or outbound access needs. In this scenario, use an ASG for the client VMs that need to access storage and one for storage accounts that are accessed. See, [Configure an application security group (ASG) with a private endpoint](/azure/private-link/configure-asg-private-endpoint).
- Make sure the subnet containing the workload VM has an NSG.
- Make sure the subnet containing the private endpoints has an NSG.

#### NSG rules for subnet containing workload VM

Besides any other network rules that your workload requires, configure the following rules.

- Outbound rules:
  - Allow compute ASG to access storage account ASG.
  - Allow compute ASG to the regional hub Azure Firewall's private IP for UDP on port 53.

:::image type="content" source="images/workload-nsg-rules.png" lightbox="images/workload-nsg-rules.png" alt-text="Screenshot showing NSG rules for workload subnet.":::
*Figure 9: NSG rules for workload subnet*

#### NSG rules for subnet containing private endpoints

It's considered best practice to expose private endpoints on a small, dedicated subnet within the consuming virtual network. One reason is that you can apply user-defined routes and Network Security Group [network policies for private endpoints](/azure/private-link/disable-private-endpoint-network-policy) for added traffic control and security.

This scenario allows you to apply a highly restrictive network security group.

- Inbound rules:
  - Allow compute ASG to access storage account ASG
  - Deny all other traffic
- Outbound rules:
  - Deny all traffic

:::image type="content" source="images/private-endpoint-nsg-rules.png" lightbox="images/private-endpoint-nsg-rules.png" alt-text="Screenshot showing NSG rules for private endpoint subnet.":::
*Figure 10: NSG rules for private endpoint subnet

#### Private endpoint security in action

The following image illustrates how following the considerations that were outlined can provide defense-in-depth security. The diagram shows a second spoke virtual network with a second VM. That workload isn't able to access the private endpoint.

:::image type="complex" source="images/dns-private-endpoints-virtual-wan-scenario-single-region-doesnt-work.svg" lightbox="images/dns-private-endpoints-virtual-wan-scenario-single-region-doesnt-work.svg" alt-text="Diagram showing workload in second spoke virtual network not able to access private endpoint.":::
The diagram shows a virtual hub that Azure Firewall secures. It's connected to three virtual networks in a single region. One virtual network contains a DNS Private Resolver. The second virtual network contains a subnet with a VM client and a subnet with a Private Link endpoint. The third virtual network contains another workload. All three virtual networks have the Azure Firewall configured as their DNS server. A private DNS zone is linked to the virtual network containing the resolver and contains an A record with a value of the private IP address of the storage account private endpoint. The diagram shows a DNS flow and an HTTP flow. The DNS flow shows the following steps: 1. A DNS query for the storage account FQDN is sent to Azure Firewall, 2. Azure Firewall forwards the query to its configured DNS server that is the DNS Private Resolver, 3. The DNS Private Resolver proxies to Azure DNS and 4. Azure DNS is aware of the private DNS zone. The HTTP flow shows the client in the second spoke virtual network issuing an HTTP request, which flows through Azure Firewall. The diagram illustrates that Azure Firewall isn't allowing spoke-to-spoke communication. The diagram further shows that the NSG can be used to block the request.
:::image-end:::
*Figure 11: Working solution for single region scenario for Virtual WAN with Private Link and DNS*

*Download a [Visio file](https://arch-center.azureedge.net/dns-private-endpoints-virtual-wan.vsdx) of this architecture.*

**DNS flow**

The DNS flow is exactly the same as in [the solution flow](#solution---establish-a-virtual-hub-extension-for-dns).

The key point is that the FQDN resolves to the private IP address, not the public IP address. This resolution means that all spokes always receive the private IP address of this service. In this scenario, all spokes will resolve the PaaS service’s private endpoint to its private IP address. While this enables the possibility of sharing the service across multiple workloads, this article does not provide a multi‑workload design pattern. For now, the focus remains on the single‑workload scenario illustrated here.

**HTTP flow**

1. With the DNS result in hand (the private IP address of the storage account), the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
1. The request is sent to the private IP address of the storage account. This request appropriately fails for many reasons:
    - Azure Firewall is configured to secure private traffic, so it handles the request. Unless Azure Firewall has a network or application rule in place to allow the flow, Azure Firewall blocks the request.
    - You don't have to use Azure Firewall in the hub to secure private traffic. For example, if your [network supports private, cross-region traffic](private-link-virtual-wan-dns-guide.yml#multi-region-routing), the NSG on the private endpoint subnet is still configured to block all traffic other than the compute ASG sources within the virtual network that hosts the workload.

## Summary

This article introduces a scenario in which a VM client connects to the Azure Storage account via the storage account's private endpoint. The endpoint is in the same virtual network as the client. All other access to the storage account is blocked. This scenario requires a DNS record in the DNS flow that resolves the fully qualified domain name (FQDN) of the storage account back to the private IP address of the private endpoint.

The [starting network topology](private-link-virtual-wan-dns-guide.yml#starting-network-topology) for this scenario introduces two challenges:

- It isn't possible to link a private DNS zone with the required DNS records for the storage account to the virtual hub.
- Linking a private DNS zone to the workload subnet doesn't work. The starting network topology requires that default DNS server and routing rules force the use of Azure Firewall in the regional hub.

The proposed solution is for the enterprise network team to implement a virtual hub extension for DNS. This extension enables shared DNS services to the workload spokes that require them.

## Related resources

- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale)
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/networking/guide/private-link-hub-spoke-network)
- [DNS for on-premises and Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources)
- [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)
- [Azure DNS Private Resolver](/azure/architecture/networking/architecture/azure-dns-private-resolver)
- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/web-apps/guides/networking/access-multitenant-web-app-from-on-premises)
- [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)
- [Tutorial: Create a private endpoint DNS infrastructure with Azure Private Resolver for an on-premises workload](/azure/private-link/tutorial-dns-on-premises-private-resolver)
