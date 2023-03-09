This article addresses the scenario of how to securely connect to a PaaS resource over a private endpoint in a single-region hub-and-spoke network architecture that uses Azure Virtual WAN.

> [!IMPORTANT]
> This article is part of a series on Private Link and DNS in Azure Virtual WAN and builds on a baseline architecture. Read the [overview page first](./private-link-vwan-dns-guide.yml) to understand the baseline architecture.

## Initial scenario architecture

This section defines the scenario and redefines the challenge for this scenario (the challenge is the same as the [non-working example in the overview page](./private-link-vwan-dns-guide.yml#non--working-example)). The initial scenario architecture builds on the [default network architecture defined in the overview guide](./private-link-vwan-dns-guide.yml#default-network-architecture). The following are the additions and changes:

- There's only one region with one virtual hub.
- There's an Azure Storage Account in the region with public network access disabled.
- There's initially a single virtual network (VNet) connected to the virtual hub.
- The VNet has a workload subnet that contains a virtual machine (VM) client.
- The VNet contains a private endpoint subnet that contains a private endpoint for the Storage Account.

**Scenario** - The scenario we want to solve for is to enable the VM client to connect to the Storage Account via the Storage Account's private endpoint that is in the same VNet.<br />
**Challenge** - It isn't possible to link a Private DNS Zone to a virtual hub. Because of that, Azure DNS Servers don't know how to resolve the fully qualified domain name (FQDN) of the Storage Account to the private IP address of the private endpoint.

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region-challenge.svg" alt-text="Diagram showing the single region challenge."::: 
Diagram showing the single region challenge.
:::image-end:::
*Figure 1: Single region scenario for Virtual WAN with Private Link and DNS - the challenge*

**DNS flow for the diagram**

1. The DNS query for mystorageacct.blob.core.windows.net is sent to the configured DNS server that is the Azure Firewall.
2. Azure Firewall proxies the request to Azure DNS. Because it isn't possible to link a Private DNS Zone to a virtual hub, Azure DNS doesn't know how to resolve the FQDN to the private endpoint private IP address. It does know how to resolve the FQDN to the public IP address of the Storage Account, so it returns the public IP address.

**HTTP flow for the diagram**

1. The client issues a request to mystorageacct.blob.core.windows.net.
2. The request is sent to the public IP address of the Storage Account. Because public network access is disabled on the Storage Account, the request fails with a 404 response code.

## Solution - Virtual WAN hub DNS extension

The solution to the challenge is to implement a [Virtual WAN extension](./private-link-vwan-extension.yml) for DNS. The single responsibility for the DNS extension is to enable to the use of Private DNS Zones in an architecture with a Virtual WAN hub.

The DNS extension is implemented as a VNet that is peered to VWAN hub. It's possible to link a private DNS Zone to this VNet. The extension VNet contains a DNS private resolver that enables services outside of this VNet like Azure Firewall to query the private zone. The following is a high-level list of the components of a Virtual WAN extension for DNS, along with some required configuration changes:

- A VNet that is peered with the virtual hub. The configured DNS server for the VNet is the Azure Firewall securing the virtual hub.
- A DNS private resolver in the new VNet. The DNS Private resolver has an inbound endpoint added.
- A Private DNS Zone named privatelink.blob.core.windows.net.
  - The Private DNS Zone contains an A record that maps from the Storage Account name to the private IP address of the private endpoint for the Storage Account.
  - The Private DNS Zone is linked to the new VNet.
- The Azure Firewall DNS Server is configured to point at the DNS private resolver's inbound endpoint.

The following diagram illustrates the architecture, along with both the DNS and HTTP flows.

:::image type="complex" source="./images/dns-private-endpoints-vwan-scenario-single-region-works.svg" alt-text="Diagram showing the working solution with a Virtual WAN DNS extension.":::
The diagram shows a virtual hub secured by Azure Firewall connected to two virtual networks in a single region. One VNet contains a DNS private resolver. The other VNet contains a subnet with a virtual machine client and a subnet with a Private Link endpoint. Both VNets have the Azure Firewall configured as their DNS Server. A Private DNS Zone is linked to the VNet containing the resolver and contains an A record with a value of the private IP address of the storage account private endpoint. The diagram shows a DNS flow and an HTTP flow. The DNS flow shows the following steps: 1. A DNS query for the storage account FQDN is sent to Azure Firewall, 2. Azure Firewall forwards the query to its configured DNS Server that is the DNS private resolver, 3. The DNS private resolver proxies to Azure DNS and 4. Azure DNS is aware of the Private DNS Zone. The HTTP flow shows the client issuing an HTTP request to the private link endpoint and connecting to the storage account successfully.
:::image-end:::
*Figure 2: Working solution for single region scenario for Virtual WAN with Private Link and DNS*

**DNS flow for the diagram**

1. A DNS query is issues to the configured DNS server for the VNet where the query originated. The DNS servers are set to custom with the IP address of 10.100.0.132 added. That address is the private IP address of the Azure Firewall securing the virtual hub so the request is forwarded to the Firewall.

    :::image type="content" source="./images/workload-vnet-configured-dns-server.png" alt-text="Screenshot of the workload VNet showing that DNS Servers are set to Custom and the private IP address of the Azure Firewall securing the hub added.":::
    *Figure 3: DNS servers configuration for workload VNet*

1. Because DNS Proxy is enabled on the Azure Firewall, it's listening for DNS requests on port 53. It forwards the query to the configured custom DNS server of 10.200.1.4, which is the private IP address of the DNS private resolver input endpoint.

    :::image type="content" source="./images/firewall-policy-dns-settings.png" alt-text="Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set":::
    Screenshot of the Azure Firewall policy where DNS Proxy is enabled and the DNS servers are set to Custom. The entry points to the private IP address of the DNS private resolver input endpoint.
    :::image-end:::
    *Figure 4: DNS configuration in Azure Firewall policy*

1. The DNS private resolver queries Azure DNS and receives information about an Azure Private DNS virtual network link.

    :::image type="content" source="./images/private-dns-zone-linked-to-vnet.png" alt-text="Screenshot of the Private DNS Zone virtual network links showing a link to the DNS extension VNet.":::
    *Figure 5: Private DNS Zone virtual network links*

1. The Azure Private DNS Zone resolves the FQDN of stgworkload00.blob.core.windows.net to 10.1.2.4, which is the IP address of the private endpoint.

    :::image type="content" source="./images/private-dns-zone-config.png" alt-text="Screenshot of the Private DNS Zone with the A record with name stgworkload00 and value 10.1.2.4":::
    *Figure 6: Private DNS Zone with the A record for Storage Account private endpoint*

**HTTP flow for the diagram**

1. The client issues request to stgworkload00.blob.core.windows.net.
1. Because DNS resolved stgworkload00.blob.core.windows.net to 10.1.2.4, the request is issued to the private endpoint. It's important to understand that even though private traffic is configured to be secured by Azure Firewall (see Figure 8), because the private endpoint is in the same VNet as the client, the request doesn't get routed through Azure Firewall.
1. A private connection to the storage account is established through the private link service.

## Recommendations

### Adding spoke networks

When adding spoke networks, configure them as follows to ensure they propagate to the Default route table in its regional hub, and both internet and private traffic are secured by Azure Firewall.

- When adding a spoke virtual network connections to the virtual hub, configure default routing by applying the following settings:

  - Associate Route Table: Default
  - Propagate to none: Yes

    :::image type="content" source="./images/virtual-hub-add-spoke-virtual-network.png" alt-text="Screenshot of the Virtual WAN virtual network connections add connection box with Propagate to none.":::
    *Figure 7: Add connection dialog for Virtual WAN virtual network connections*

- When setting the security configuration for the connection, apply the following settings to ensure internet and private traffic are secured by Azure Firewall:
  - Internet traffic: Secured by Azure Firewall
  - Private traffic: Secured by Azure Firewall

    :::image type="content" source="./images/virtual-hub-vnet-connection-security-configuration.png" alt-text="Screenshot of the security configuration for the virtual hub VNet connections showing internet and private traffic secured by Azure Firewall.":::
    *Figure 8: Virtual hub VNet connections security configuration*

### Virtual WAN DNS extension

- Make sure you install the virtual WAN DNS extension with nothing configured in the Private DNS Zone prior to adding any PaaS service you want to configure private endpoint DNS records for

#### Virtual network

- The VNet for the DNS extension should only contain the resources required for DNS resolution and nothing else.
- The VNet for the DNS extension should follow the same configuration guidelines under [Adding spoke networks](adding-spoke-networks).

#### DNS private resolver

Consider the following guidance regarding the DNS private resolver in the Virtual WAN DNS extension.

- When naming a DNS private resolver, use **dnspr** as the prefix. For example, the west resolver is named dnspr-westus3.
- There should be one DNS extension with one DNS private resolver per region.
- The DNS private resolver only requires an inbound endpoint and no outbound endpoints for this scenario. This allows you to forward traffic to the resolver. The private IP for the endpoint is what we configure for the custom dns service in the Azure Firewall policy (see figure 4).

    :::image type="content" source="./images/dns-private-resolver-inbound-endpoints.png" alt-text="Screenshot of the inbound endpoints for the DNS private resolver showing one endpoint.":::
    *Figure 9: Inbound endpoints for the DNS private resolver*

- The subnet for DNS private resolver has to be a /24.
- The Network Security Group in the subnet for the DNS private resolver should only allow UDP traffic from its region to port 53. You should block all other inbound and outbound traffic.

#### Private DNS Zone

Because the Azure DNS private resolver is resolving DNS via Azure DNS, Azure DNS is able to pick up any private DNS zones linked to its inbound subnet's virtual network.

- Link the Private DNS Zone to the Virtual WAN DNS extension virtual network.
- Follow the guidance on [managing Private DNS Zones]()
- If you expect PaaS service owners to manage their own entries, configure RBAC accordingly. See [article on ...] for more considerations.

### Storage Account

 