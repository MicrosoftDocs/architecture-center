This article addresses the scenario of how to expose a PaaS resource over a private endpoint to specific workload in a single region, hub-spoke network architecture provided by Microsoft Azure Virtual WAN.

> [!IMPORTANT]
> This article is part of a series on Azure Private Link and Azure DNS in Virtual WAN and builds on the network topology defined in the scenario guide. Read the [overview page first](./private-link-vwan-dns-guide.yml) to understand the base network architecture and key challenges.

## Scenario

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region.svg" lightbox="./images/dns-private-endpoints-vwan-scenario-single-region.svg" alt-text="Diagram showing the single-region architecture.":::
Diagram showing the single-region architecture.
:::image-end:::
*Figure 1: Single-region scenario for Virtual WAN with Private Link and Azure DNS - the challenge*

This section defines the scenario and redefines the challenge for this scenario (the challenge is the same as the [nonworking example in the overview page](./private-link-vwan-dns-guide.yml#nonworking-scenario)). The initial scenario architecture builds on the [common network topology defined in the overview guide](./private-link-vwan-dns-guide.yml#common-network-topology). The following are the additions and changes:

- There's only one region with one virtual hub.
- There's an Azure Storage account in the region with public network access disabled. This storage account is only intended to be accessed by the single workload in this scenario.
- There's initially a single Azure Virtual Network connected to the virtual hub.
- The virtual network has a workload subnet that contains a virtual machine (VM) client.
- The virtual network contains a private endpoint subnet that contains a private endpoint for the storage account.

### Successful outcome

The Azure Virtual Machine client can connect to the Azure Storage account via the storage account's private endpoint that is in the same virtual network, and all other access to the storage account is blocked.

### Impediment

You need a DNS record in the DNS flow that is able to resolve the fully qualified domain name (FQDN) of the storage account back to the private IP address of the private endpoint. As identified in the [overview](private-link-vwan-dns-guide.yml#key-challenges), the challenge with this is twofold:

1. It isn't possible to link a private DNS zone that maintains the storage accounts necessary DNS records to a virtual hub.
1. You can link a private DNS zone to the workload network, so you might think that would work. Unfortunately, the [baseline architecture](./private-link-vwan-dns-guide.yml#common-network-topology) stipulates that each connected virtual network has DNS servers configured to point to use the Azure Firewall DNS proxy.

Because you can't link a private DNS zone to a virtual hub, and the virtual network is configured to use the Azure Firewall DNS proxy, Azure DNS servers don't have any mechanism to resolve the (FQDN) of the storage account to the private IP address of the private endpoint. The result is that the client receives an erroneous DNS response.

#### DNS and HTTP flows

Let's visualize the impediment described earlier in the context of this workload by reviewing the DNS and resulting HTTP request flows.

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region-challenge.svg" lightbox="./images/dns-private-endpoints-vwan-scenario-single-region-challenge.svg" alt-text="Diagram showing the single-region challenge.":::
Diagram showing the single-region challenge where the secured virtual hub cannot successful resolve the DNS values that the spoke needs in order to communicate to a local private endpoint.
:::image-end:::
*Figure 2: Single-region scenario for Virtual WAN with Private Link and Azure DNS - the challenge*

**DNS flow**

1. The DNS query for `stgworkload00.blob.core.windows.net` from the client is sent to the configured DNS server, which is Azure Firewall in the peered regional hub.
2. Azure Firewall proxies the request to Azure DNS. Because it isn't possible to link a private DNS zone to a virtual hub, Azure DNS doesn't know how to resolve the FQDN to the private endpoint private IP address. It does know how to resolve the FQDN to the public IP address of the storage account, so it returns the storage account's public IP address.

**HTTP flow**

1. With the DNS result in hand, the public IP address of the storage account, the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
2. The request is sent to the public IP address of the storage account. This request fails for many reasons:
   - The NSG on the workload subnet may not allow this Internet-bound traffic.
   - The Azure Firewall that is filtering Internet-bound egress traffic likely doesn't have an application rule to support this flow.
   - Even if both the NSG and Azure Firewall did have allowances for this request flow, the Storage account is configured to block all public network access.
   - This ultimately violates our goal of only allowing access to the storage account via the private endpoint.

## Solution - Establish a virtual hub extension for DNS

A solution to the challenge is for the enterprise network team to implement a [virtual hub extension](./private-link-vwan-dns-virtual-hub-extension-pattern.yml) for DNS. The single responsibility for the DNS virtual hub extension is to enable workload teams that need to use private DNS zones in their architecture within this [common Virtual WAN hub topology](./private-link-vwan-dns-guide.yml#common-network-topology).

The DNS extension is implemented as a virtual network spoke that is peered to its regional virtual hub. It's possible to link private DNS zones to this virtual network. The virtual network also contains an Azure DNS Private Resolver that enables services outside of this virtual network, like Azure Firewall, to query and receive values from all linked private DNS zones. The following are the components of a typical virtual hub extension for DNS, along with some required configuration changes:

- A new spoke virtual network that is peered with region's virtual hub. This spoke is configured like any other spoke, meaning default DNS server and routing rules force the use of Azure Firewall in the regional hub.
- A DNS Private Resolver resource is deployed with an [inbound endpoint](/azure/dns/private-resolver-endpoints-rulesets#inbound-endpoints) in the spoke virtual network.
- A private DNS zone resource named `privatelink.blob.core.windows.net` is created.
  - This zone contains an `A` record that maps from the storage account FQDN name to the private IP address of the private endpoint for the storage account.
  - The private DNS zone is linked to the spoke virtual network.
  - The maintenance of these DNS records can either be performed by [autoregistration](/azure/dns/private-dns-autoregistration) or service-managed entries, if RBAC affordances are made, or manually as needed.
- In the regional hub, the Azure Firewall's DNS server is changed to point at the DNS Private Resolver's inbound endpoint.

The following diagram illustrates the architecture, along with both the DNS and HTTP flows.

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region-works.svg" lightbox="./images/dns-private-endpoints-vwan-scenario-single-region-works.svg" alt-text="Diagram showing the working solution with a Virtual hub extension for DNS.":::
The diagram shows a virtual hub secured by Azure Firewall connected to two virtual networks in a single region. One virtual network contains a DNS Private Resolver. The other virtual network contains a subnet with a VM client and a subnet with a Private Link endpoint. Both virtual networks have the Azure Firewall configured as their DNS server. A private DNS zone is linked to the virtual network containing the resolver and contains an A record with a value of the private IP address of the storage account private endpoint. The diagram shows a DNS flow and an HTTP flow. The DNS flow shows the following steps: 1. A DNS query for the storage account FQDN is sent to Azure Firewall, 2. Azure Firewall forwards the query to its configured DNS server that is the DNS Private Resolver, 3. The DNS Private Resolver proxies to Azure DNS and 4. Azure DNS is aware of the private DNS zone. The HTTP flow shows the client issuing an HTTP request to the Private Link endpoint and connecting to the storage account successfully.
:::image-end:::
*Figure 3: Working solution for single region scenario for Virtual WAN with Private Link and DNS*

**DNS flow**

1. The DNS query for `stgworkload00.blob.core.windows.net` from the client is sent to the configured DNS server, which is Azure Firewall in the peered regional hub - 10.100.0.132 in this case.

    :::image type="content" source="./images/workload-vnet-configured-dns-server.png" lightbox="./images/workload-vnet-configured-dns-server.png" alt-text="Screenshot of the workload VNet showing that DNS servers are set to Custom and the private IP address of the Azure Firewall securing the hub added.":::
    *Figure 4: DNS servers configuration for workload virtual network*

1. Azure Firewall proxies the request to the regional Azure DNS Private Resolver in the hub extension - 10.200.1.4 in this case, which is the private IP address of the DNS Private Resolver's inbound endpoint.

    :::image type="complex" source="./images/firewall-policy-dns-settings.png" lightbox="./images/firewall-policy-dns-settings.png" alt-text="Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set":::
    Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set to Custom. The entry points to the private IP address of the DNS Private Resolver input endpoint.
    :::image-end:::
    *Figure 5: DNS configuration in Azure Firewall policy*

1. DNS Private Resolver proxies the request to Azure DNS. Because a private DNS zone is linked to the virtual network containing the inbound endpoint, Azure DNS can use records in those linked private DNS zones.

    :::image type="content" source="./images/private-dns-zone-linked-to-vnet.png" lightbox="./images/private-dns-zone-linked-to-vnet.png" alt-text="Screenshot of the private DNS zone virtual network links showing a link to the DNS extension virtual network.":::
    *Figure 6: Private DNS zone virtual network links*

1. Azure DNS consults the linked private DNS zone resolves the FQDN of `stgworkload00.blob.core.windows.net` to 10.1.2.4, which is the IP address of the private endpoint for the storage account. This response is provided to Azure Firewall DNS, which then returns the storage account's private IP address to the client.

    :::image type="content" source="./images/private-dns-zone-config.png" lightbox="./images/private-dns-zone-config.png" alt-text="Screenshot of the private DNS zone with the A record with name stgworkload00 and value 10.1.2.4":::
    *Figure 7: Private DNS zone with the A record for storage account private endpoint*

**HTTP flow**

1. With the DNS result in hand, the private IP address of the storage account, the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
1. The request is sent to the private IP address (10.1.2.4) of the storage account. This request routes successfully, assuming no conflicting restrictions on the local Network Security Groups on the client subnet or the private endpoint subnet. It's important to understand that, even though Azure Firewall is securing private traffic, the request doesn't get routed through Azure Firewall because the private endpoint is in the same virtual network as the client.  Meaning no Azure Firewall allowances need to be made for this scenario.
1. A private connection to the storage account is established through the Private Link service. The storage account only allows private network access, and as such accepts the HTTP request.

### Virtual hub extension for DNS considerations

When implementing the extension for your enterprise, consider the following guidance.

- Deploying the DNS extension isn't a task for the workload team. This task is an enterprise networking function and should be an implementation decision made with those individuals.
- The DNS extension and private DNS zones must exist prior to adding any PaaS service you want to configure private endpoint DNS records for.
- The virtual hub extension is a regional resource, avoid cross-region traffic and establish a hub extension per regional hub where private endpoint DNS resolution is expected.

#### Spoke virtual network

- Following the single responsibility principal, the virtual network for the DNS extension should only contain the resources required for DNS resolution and shouldn't be shared with other resources.
- The virtual network for the DNS extension should follow the same configuration guidelines under [Adding spoke networks](./private-link-vwan-dns-guide.yml#adding-spoke-networks).

#### Azure DNS Private Resolver

- There should be one virtual hub DNS extension with one DNS Private Resolver per region.
- The DNS Private Resolver only requires an inbound endpoint and no outbound endpoints for this scenario. The private IP for the inbound endpoint is what is set for the custom DNS service in the Azure Firewall policy (see figure 5).
- For higher resiliency and increased load handling, multiple DNS Private Resolvers instances can be deployed per region, with Azure DNS proxy configured with multiple IP addresses for proxied resolution.

    :::image type="content" source="./images/dns-private-resolver-inbound-endpoints.png" lightbox="./images/dns-private-resolver-inbound-endpoints.png" alt-text="Screenshot of the inbound endpoints for the DNS Private Resolver showing one endpoint.":::
    *Figure 8: Inbound endpoints for the DNS Private Resolver*

- Follow the [virtual network restrictions](/azure/dns/dns-private-resolver-overview#virtual-network-restrictions) for the DNS Private Resolver.
- The Network Security Group in the subnet for the DNS Private Resolver's inbound endpoint should only allow UDP traffic from its regional hub to port 53. You should block all other inbound and outbound traffic.

#### Private DNS zone

Because the Azure DNS Private Resolver is resolving DNS via Azure DNS, Azure DNS is able to pick up any private DNS zones linked to its inbound subnet's virtual network.

- Link the private DNS zone to the virtual hub extension for DNS virtual network.
- Follow the guidance on [managing private DNS zones for private endpoints](/azure/private-link/private-endpoint-dns).
- If you expect PaaS resource owners to manage their own entries, configure RBAC accordingly or implement a solution such as the one from [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

## Scenario considerations

With a well-managed virtual hub DNS extension in place, let's turn back to the workload and address some additional points to help achieve the [successful outcome](#successful-outcome) objectives within this scenario.

### Storage account

- Set **Disable public access and use private access** under **Network connectivity** to ensure the storage account can only be accessed via private endpoints.
- Add a private endpoint to a dedicated private endpoint subnet in the workload's virtual network.
- Azure Diagnostics should be sent to the workload's Log Analytics Workspace. The access logs generated can be helpful in troubleshooting initial configuration issues.

### Private endpoint security

A requirement of this solution is to limit the exposure of this storage account. Once you remove public internet access to your PaaS resource, you should address private networking security.

When Azure Firewall is securing private traffic in a Virtual WAN hub-spoke topology, spoke-to-spoke connectivity is denied by default in Azure Firewall. This prevents workloads in other spoke networks from accessing private endpoints (and other resources) in the workload virtual network. Traffic fully within a virtual network isn't routed through Azure Firewall. To control access within the virtual network, and add more granular protection, consider the following network security group (NSG) recommendations.

- Create application security groups (ASGs) to group resources that have similar inbound or outbound access needs. In this scenario, use an ASG for the client VMs that need to access storage and one for Storage Accounts that need to be accessed. See, [Configure an application security group (ASG) with a private endpoint](/azure/private-link/configure-asg-private-endpoint).
- Make sure the subnet containing the workload VM has an NSG.
- Make sure the subnet containing the private endpoints has an NSG.

#### NSG rules for subnet containing workload VM

Besides any other network rules that your workload requires, configure the following rules.

- Outbound rules:
  - Allow compute ASG to access storage account ASG.
  - Allow compute ASG to the regional hub Azure Firewall's private IP for UDP on port 53.

:::image type="content" source="./images/workload-nsg-rules.png" lightbox="./images/workload-nsg-rules.png" alt-text="Picture showing NSG rules for workload subnet.":::
*Figure 9: NSG rules for workload subnet

#### NSG rules for subnet containing private endpoints

It's considered best practice to expose private endpoints on a small, dedicated subnet within the consuming virtual network. One reason is that you can apply user-defined routes and Network Security Group [network policies for private endpoints](/azure/private-link/disable-private-endpoint-network-policy) for added traffic control and security.

This scenario allows for a highly restrictive network security group to apply.

- Inbound rules:
  - Allow compute ASG to access storage account ASG
  - Deny all other traffic
- Outbound rules:
  - Deny all traffic

:::image type="content" source="./images/private-endpoint-nsg-rules.png" lightbox="./images/private-endpoint-nsg-rules.png" alt-text="Picture showing NSG rules for private endpoint subnet.":::
*Figure 10: NSG rules for private endpoint subnet

#### Private endpoint security in action

The following image illustrates defense in depth security by following the considerations outlined. The diagram shows an additional spoke virtual network with a second VM. That workload isn't able to access the private endpoint.

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region-doesnt-work.svg" lightbox="./images/dns-private-endpoints-vwan-scenario-single-region-doesnt-work.svg" alt-text="Diagram showing workload in second spoke virtual network not able to access private endpoint.":::
The diagram shows a virtual hub secured by Azure Firewall connected to three virtual networks in a single region. One virtual network contains a DNS Private Resolver. The second virtual network contains a subnet with a VM client and a subnet with a Private Link endpoint. The third virtual network contains another workload. All three virtual networks have the Azure Firewall configured as their DNS server. A private DNS zone is linked to the virtual network containing the resolver and contains an A record with a value of the private IP address of the storage account private endpoint. The diagram shows a DNS flow and an HTTP flow. The DNS flow shows the following steps: 1. A DNS query for the storage account FQDN is sent to Azure Firewall, 2. Azure Firewall forwards the query to its configured DNS server that is the DNS Private Resolver, 3. The DNS Private Resolver proxies to Azure DNS and 4. Azure DNS is aware of the private DNS zone. The HTTP flow shows the client in the second spoke virtual network issuing an HTTP request, which flows through Azure Firewall. The diagram illustrates that Azure Firewall isn't allowing spoke-to-spoke communication. The diagram further shows that the NSG can further be used to block the request.
:::image-end:::
*Figure 11: Working solution for single region scenario for Virtual WAN with Private Link and DNS*

**DNS flow**

The DNS flow is exactly the same as in [the solution flow](#solution---establish-a-virtual-hub-extension-for-dns).

What is important to highlight, is that the FQDN resolves to the private IP address, and not the public IP address. This resolution means that all spokes always receive the private IP address of this service.  Another scenario covers how this approach can be used to share a PaaS service across multiple consuming workloads. For this single-workload scenario, this isn't a concern.

**HTTP flow**

1. With the DNS result in hand, the private IP address of the storage account, the client issues an HTTP request to `stgworkload00.blob.core.windows.net`.
1. The request is sent to the private IP address of the storage account. This request appropriately fails for many reasons:
    - The request flows through Azure Firewall because it's configured to secure private traffic.  Unless Azure Firewall has a network or application rule in place to allow the flow, Azure Firewall blocks the request.
    - If you choose not to secure private traffic by Azure Firewall in the hub, such as if your [network supports private, cross-region traffic](./private-link-vwan-dns-guide.yml#multi-region-routing), the NSG on the private endpoint subnet is still configured to block all traffic other than the compute ASG sources within the workload's virtual network.

## Summary

This article introduces a scenario where an Azure Virtual Machine client can connect to the Azure Storage account via the storage account's private endpoint that is in the same virtual network. All other access to the storage account is blocked. This scenario requires a DNS record in the DNS flow that is able to resolve the fully qualified domain name (FQDN) of the storage account back to the private IP address of the private endpoint.

The [common network topology](./private-link-vwan-dns-guide.yml#common-network-topology) for this scenario introduces two challenges:

- It isn't possible to link a private DNS zone with the required DNS records for the storage account to the virtual hub.
- Linking a private DNS zone to the workload subnet won't work. The common network topology requires that default DNS server and routing rules force the use of Azure Firewall in the regional hub.

The proposed solution is for the enterprise network team to implement a virtual hub extension for DNS. This extension allows the enterprise network team to expose shared DNS services to workload spokes that require them.

## Related resources

- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale)
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/guide/networking/private-link-hub-spoke-network)
- [DNS for on-premises and Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources)
- [Single-region data landing zone connectivity](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/eslz-network-considerations-single-region)
- [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)
- [Azure DNS Private Resolver](/azure/architecture/example-scenario/networking/azure-dns-private-resolver)
- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/example-scenario/security/access-multitenant-web-app-from-on-premises)
- [Network-hardened web application with private connectivity to PaaS datastores](/azure/architecture/example-scenario/security/hardened-web-app)
- [Tutorial: Create a private endpoint DNS infrastructure with Azure Private Resolver for an on-premises workload](/azure/private-link/tutorial-dns-on-premises-private-resolver)
