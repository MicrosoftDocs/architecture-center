Azure Private Link allows you to access Azure PaaS services directly from your private virtual networks without traversing public networks. You configure a private endpoint in your network that uses a private IP address from your network. Clients can then connect privately to Private Link services through that private endpoint.

Clients don't need to change to be aware of the private IP address of the private endpoint. They continue to connect to the service through its normal Fully Qualified Domain Name (FQDN). The requirement to make this approach possible is that you must configure DNS in your network to resolve the FQDN to the private IP address of the private endpoint instead of the service's public IP. Your network design and, in particular, your DNS configuration plays a key factor in supporting private endpoint connectivity to services.

This article series takes a common hub-and-spoke network topology using Azure Virtual WAN and provides guidance on implementing several Private Link scenarios.

## Common network topology

The starting network topology used in this series was chosen to illustrate a common network architecture while incorporating Private Link and DNS. Your network design likely has differences, but the solutions you use when designing your workloads remain similar.

:::image type="complex" source="./images/dns-private-endpoints-vwan-baseline-architecture.svg" lightbox="./images/dns-private-endpoints-vwan-baseline-architecture.svg" alt-text="Diagram showing the baseline Virtual WAN architecture used for this series.":::
The diagram shows a network with Azure Virtual WAN. The network has two regions, each with a secured virtual hub. Each secured virtual hub is secured with Azure Firewall. Azure Firewall is configured with DNS Proxy enabled. There are two Virtual Networks connected to each virtual hub. The Virtual Networks have a dotted line to the Firewall on their hub, noting that the Firewall instance is their configured DNS.
:::image-end:::
*Figure 1: Default network architecture for all private endpoint and DNS scenarios*

This topology has the following characteristics:

- A hub-spoke networking model implemented with Azure Virtual WAN Standard.
- Two regions, each with a regional, Azure Firewall secured virtual hub.
- Each secured regional virtual hub has the following security configuration for Azure Virtual Network connections:
  - Internet traffic: Secured by Azure Firewall - All traffic out to the Internet flows through the regional hub's firewall.
  - Private traffic: Secured by Azure Firewall - Traffic transiting from spoke to spoke flows through the regional hub's firewall.
- Each regional virtual hub is secured with Azure Firewall. Each firewall has the following configurations:
  - DNS Servers: Default (Azure provided) - Azure Firewall explicitly uses Azure DNS for FQDN resolution in rule collections.
  - DNS Proxy: Enabled - Azure Firewall responds to DNS queries on port 53, proxying to Azure DNS for uncached values.
  - Logging to a Log Analytics workspace in the same region for both firewall rule evaluation and DNS proxy requests. Both are a common network security logging requirement.
- Each connected virtual network spoke has their default DNS servers setting configured to use the regional Azure Firewall's DNS proxy, otherwise [the FQDN rule evaluation can be out of sync](/azure/firewall/dns-details#clients-not-configured-to-use-the-firewall-dns-proxy).

### Multi-region routing

Azure Virtual WAN Secured Virtual Hubs have *limited support* for inter-hub connectivity when two or more Secured Virtual Hubs are present. This impacts both multi-hub, intra-region and cross-region scenarios. As such, the network topology above does not directly facilitate [filtering private, cross-region traffic through Azure Firewall](/azure/firewall-manager/overview#known-issues). Support for this capability will be delivered through [Virtual WAN Hub routing intent and routing policies](/azure/virtual-wan/how-to-routing-policies#key-considerations), which is currently in preview.

For this series, the assumption is that internal secured traffic does not traverse multiple hubs. Traffic that must traverse hubs must be on a parallel topology that does not filter private traffic through a secured virtual hub, but instead lets it pass through.

### Adding spoke networks

 When adding spoke networks, they will follow the constraints defined in the common network topology above. Specifically they will be be associated with the Default route table in its regional hub and Azure Firewall is configured to securing both internet and private traffic.

    - **Internet traffic**: **Secured by Azure Firewall**
    - **Private traffic**: **Secured by Azure Firewall**

    :::image type="content" source="./images/virtual-hub-vnet-connection-security-configuration.png" lightbox="./images/virtual-hub-vnet-connection-security-configuration.png" alt-text="Screenshot of the security configuration for the virtual network connections showing internet and private traffic secured by Azure Firewall.":::
    *Figure 2: Virtual hub virtual network connections security configuration*

### Key challenges

This common network configuration creates a few challenges regarding configuring DNS for private endpoints.

While the use of Azure Virtual WAN gives you a managed hub experience, the tradeoff is a limited ability to influence the configuration of the virtual hub or the ability to add more components into it. A traditional hub-spoke topology allows you to isolate workloads in spokes, while sharing common network services, such as DNS records, in the self-managed hub.

In a traditional hub-spoke implementation, you would typically link private DNS zone to the hub network, which would allow Azure DNS to resolve private endpoint IP addresses requested by a resource in the hub. It isn't possible to link private DNS zones to VWAN virtual hubs, so any DNS resolution that happens within the hub isn't aware of private zones. This specifically is a problem for Azure Firewall, the configured DNS provider for workload spokes, which is using DNS for FQDN resolution.

When using VWAN virtual hubs, it seems intuitive that you'd instead link private DNS zones to the spoke virtual networks where workloads expect DNS resolution. However, as noted in the architecture, DNS proxy is enabled on the regional firewalls and it's expected that all spokes use their regional firewall as their DNS source.  This is done by the spoke network configuration of setting the Custom DNS server to point to the Azure Firewall's private IP instead of the normal Azure DNS value.  This means that Azure DNS would be called from Azure Firewall instead of from the workload's network, so any private DNS zone links on the workload network isn't used in the resolution.

Given the complexity with the prescriptive use of DNS proxy on Azure Firewall in this topology, let's review why this feature is commonly enabled.

- Azure Firewall network rules support FQDN-based limits to more precisely control egress traffic that can't be handled by application rules. DNS proxy must be enabled to support this feature. A common example of this is limiting Network Time Protocol (NTP) traffic to known endpoints, such as `time.windows.com`.
- Security teams can benefit from DNS request logging. Azure Firewall has built-in support for DNS request logging, so requiring that all spoke resources use Azure Firewall as their DNS provider ensures broad logging coverage.

To illustrate the challenges, the following are two simplified configurations, the most basic example that works and a more complex example that doesn't. We provide details about why they do and don't work.

#### Working scenario

The following example is a basic private endpoint configuration. A private DNS zone is linked to the virtual network containing a client that wants to communicate to a PaaS service through its private endpoint. The private DNS zone has an A record that resolves the FQDN to the private IP address of the private endpoint. The following diagram illustrates the flow.

:::image type="complex" source="./images/dns-private-endpoints-basic-config-works.svg" lightbox="./images/dns-private-endpoints-basic-config-works.svg" alt-text="Diagram showing a basic private endpoint and DNS configuration.":::
The diagram shows an Azure Virtual Network, Azure DNS, a private DNS zone and an Azure storage account. The virtual network has a client in a workload subnet and a private endpoint in a private endpoint subnet. The private endpoint has a private IP address of 10.1.2.4 and it points to the storage account. The diagram illustrates that the client makes a request to the resources FQDN. Azure DNS forwards the query to the private DNS zone, which has an A record for that FQDN, so it returns the private IP address for the private endpoint. The client is able to make the request.
:::image-end:::
*Figure 3: A basic DNS configuration for private endpoints*

1. Client issues a request to stgworkload00.blob.core.windows.net.
2. Azure DNS, the configured DNS server for the virtual network is queried for the IP address for stgworkload00.blob.core.windows.net.

   Running the following command from the virtual machine (VM) illustrates that the VM is configured to use Azure DNS (168.63.129.16) as the DNS provider.

    ```bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 168.63.129.16
             DNS Servers: 168.63.129.16    
    ```

3. Azure DNS is aware that the private DNS zone privatelink.blob.core.windows.net is linked to spokevnet, so incorporates records from it in its response.
4. Because the A record exists for stgworkload00.privatelink.blob.core.windows.net is found, the private IP address 10.1.2.4 is returned.

    Running the following command from the VM resolves the storage account's DNS to the private IP address of the private endpoint.

    ```bash
    resolvectl query stgworkload00.blob.core.windows.net

    stgworkload00.blob.core.windows.net: 10.1.2.4   -- link: eth0
                                        (stgworkload00.privatelink.blob.core.windows.net)
    ```

5. The request is issued to the Private Link Endpoint with the 10.1.2.4 IP address.
6. A private connection to the storage account is established through the Azure Private Link service.

The above works because Azure DNS is the configured DNS server for the Virtual Network, is aware of the linked private DNS zone, and resolves DNS query using the values of the zone.

#### Nonworking scenario

The following example represents a naive attempt to use private endpoints with our common network topology. It isn't possible to link a private DNS zone to a virtual hub in Virtual WAN. Therefore, when clients are configured to use the Azure Firewall as their DNS server, the DNS requests are proxied to Azure DNS from within the virtual hub, which doesn't have a linked private DNS zone. Azure DNS doesn't know how to resolve the query other than providing the default, public FQDN response for the PaaS service.

:::image type="complex" source="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" lightbox="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" alt-text="Diagram showing DNS configuration in a private DNS zone not working because Azure Firewall has DNS proxy enabled.":::
    The diagram shows a virtual hub with and Azure Firewall with DNS Proxy enabled. It illustrates that you can't connect a private DNS zone to a virtual hub. It further illustrates that a client isn't able to make use of the A record in the private DNS zone to resolve the FQDN to the private IP address of the storage account.
:::image-end:::
*Figure 4: Private DNS zones can't be linked to virtual hubs*

1. Client issues a request to stgworkload00.blob.core.windows.net.

    Running the following command from the VM illustrates that the VM is configured to use Azure Firewall as the DNS provider.

    ```bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 10.100.0.132
             DNS Servers: 10.100.0.132    
    ```

2. Azure Firewall DNS Proxy is enabled in the virtual hub, so the DNS query of stgworkload00.blob.core.windows.net is proxied to Azure DNS.
3. Azure DNS can't resolve stgworkload00.blob.core.windows.net to the private IP address of the private endpoint because: 1. you can't link a private DNS zone to the virtual hub and 2. Azure DNS won't be aware of a private DNS zone linked to the workload virtual network because the configured DNS server for the workload virtual network is Azure Firewall. Azure DNS responds with the public IP address of the storage account.

    Running the following command from the VM resolves the storage account's DNS to the public IP of the storage account.

    ```bash
    resolvectl query stgworkload00.blob.core.windows.net
    
    stgworkload00.blob.core.windows.net: 52.239.174.228 -- link: eth0
                                        (blob.bn9prdstr08a.store.core.windows.net)
    ```

    Because Azure Firewall is proxying DNS queries, we're able to log them. The following are sample Azure Firewall DNS Proxy logs.

    ```bash
    DNS Request: 10.1.0.4:60137 - 46023 A IN stgworkload00.blob.core.windows.net. udp 63 false 512 NOERROR qr,rd,ra 313 0.009424664s
    DNS Request: 10.1.0.4:53145 - 34586 AAAA IN blob.bn9prdstr08a.store.core.windows.net. udp 69 false 512 NOERROR qr,aa,rd,ra 169 0.000113s    
    ```

4. The client doesn't receive the private IP address for the Private Link Endpoint and can't establish a private connection to the storage account.

The above behavior is expected and is the problem that the scenarios are going to address.

## Scenarios

While the solution to this problem is generally the same approach, walking through common workload scenarios helps showcase how the solution maps to the requirements of these common situations. Most scenarios consist of a client accessing one or more PaaS services over a private endpoint under different workload requirements, but they all adhere to the common network topology presented above. The scenarios start simply, with a client accessing a single regional PaaS service. The scenarios get incrementally more complex, adding more network visibility, regions, and PaaS services.

In most scenarios, the client is implemented as a VM and the PaaS service the client accesses is a storage account. VMs should be considered a stand-in for any Azure resource that has a NIC exposed on a virtual network, such as Virtual Machine Scale Sets, Azure Kubernetes Service nodes, or any other service that routes in a similar way.

> [!IMPORTANT]
> Azure Storage account's Private Link implementation might differ from other PaaS services in subtle ways, but it does align well for many. For example, some services remove FQDN records while exposed through private link, which might result in different behaviors, but are generally not a factor in solution to these scenarios.

Each scenario starts with the desired end state and details the configuration required to get from the common network topology to the desired end state. The solution to every scenario takes advantage of the [virtual hub extensions pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml). This pattern addresses how to expose shared services in an isolated and secure manner, as a conceptual extension to a regional hub. The following table contains links to the virtual hub extension pattern and the scenarios.

| Guide | Description |
| --- | --- |
| [Virtual hub extensions pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml) | This pattern addresses how to expose shared services in a virtual hub in an isolated and secure manner. |
| [Single region, dedicated PaaS](./private-link-vwan-dns-single-region-workload.yml) | A Workload in a single region accessing one dedicated PaaS resource. |

## Next steps

> [!div class="nextstepaction"]
> [Read the single region, dedicated PaaS resource scenario](./private-link-vwan-dns-single-region-workload.yml)

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
