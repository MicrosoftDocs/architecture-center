Azure Private Link allows you to access Azure PaaS services from your network over a private network connection. You configure a private endpoint in your network that uses a private IP address from your network. Clients can then connect privately and securely to Private Link services through that private endpoint.

Clients aren't aware of the private IP address of the private endpoint. They connect to the service through its Fully Qualified Domain Name (FQDN). The challenge is that you must configure DNS in your network to resolve the FQDN to the private IP address of the private endpoint. Your network design and, in particular, your DNS configuration plays a key factor in supporting private endpoint connectivity to services.

This article series takes a common hub-and-spoke network topology using Azure Virtual WAN and provides guidance on implementing several Private Link scenarios.

## Default network architecture

The base network topology used in this series isn't intended to be a target network architecture. The configuration was chosen to illustrate a complex topology regarding Private Link and DNS. While your design likely has differences, the goal is to outline common networking constraints you might encounter when designing your workloads.

:::image type="complex" source="./images/dns-private-endpoints-vwan-baseline-architecture.svg" lightbox="./images/dns-private-endpoints-vwan-baseline-architecture.svg" alt-text="Diagram showing the baseline Virtual WAN architecture used for this series.":::
The diagram shows a network with Azure Virtual WAN. The network has two regions, each with a secured virtual hub. Each secured virtual hub is secured with Azure Firewall. Azure Firewall is configured with DNS Proxy enabled. There are two Virtual Networks connected to each virtual hub. The Virtual Networks have a dotted line to the Firewall on their hub, noting that the Firewall instance is their configured DNS.
:::image-end:::
*Figure 1: Default network architecture for all private endpoint and DNS scenarios*

The architecture has the following attributes that have to be taken into consideration when implementing each of the scenarios:

- A Hub-and-spoke networking model implemented with Azure Virtual WAN.
- Two regions, each with a regional secured virtual hub
- Hub-to-hub connectivity is enabled. This is base functionality and not a setting.
- Branch-to-branch: Disabled - Branch-to-branch communication flows through the hubs.
- Each secured regional virtual hub has the following security configuration for Azure Virtual Network connections:
  - Internet traffic: Secured by Azure Firewall - All traffic out to the internet flows through the Firewall on a regional hub.
  - Private traffic: Secured by Azure Firewall - Traffic within the network flows through the Firewall.
- Each regional virtual hub is secured with Azure Firewall. Each firewall has the following configurations:
  - DNS Servers: Default (Azure provided) - Azure Firewall will proxy DNS requests to Azure DNS.
  - DNS Proxy: Enabled - Azure Firewall listens for DNS queries on port 53.
- Each connected virtual network has DNS servers configured to point to use the Azure Firewall DNS proxy, otherwise [the DNS query results can be unpredictable](/azure/firewall/dns-details#clients-not-configured-to-use-the-firewall-dns-proxy).
- Each Azure Firewall is logging to Log Analytics - Azure Firewall enables logging DNS requests, which is a requirement for this topology.

### Key challenges

The default network configuration creates two key challenges regarding configuring DNS for private endpoints.

1. The first architectural decision that presents a challenge is the use of Azure Virtual WAN to implement a hub-spoke model. The hub-spoke topology allows you to isolate workloads in spokes, while sharing common services, such as DNS, in the hub. In a traditional hub-spoke implementation, you would link a private DNS zone to the hub network, which would allow Azure DNS to resolve private endpoint IP addresses. It isn't possible to link private DNS zones to virtual hubs.

2. To address the above challenge, you might try to link a private DNS zone to the workload virtual network. This brings about the second architectural decision that presents a challenge: enabling DNS proxy on the Firewall. DNS proxy has to be enabled if you want Azure Firewall network rules to support Fully Qualified Domain Names (FQDN). Instead of managing the complexity of ensuring the correct IP addresses are in place in network rules, the rules need only specify the FQDN. Azure Firewall resolves the FQDN to the correct IP address.

    As noted in the architecture, when enabling DNS proxy on the Firewall, you should configure spoke network Custom DNS server to point at the Azure Firewall to ensure predicable DNS query results. Because the workload spoke network's DNS server is Azure Firewall, Azure DNS isn't aware of a private DNS zone linked to that network.

To illustrate the challenges, the following are two configurations, the most basic example that works and a more complex example that doesn't. We provide details about why they do and don't work, respectively.

#### Working example

The following example is a basic private endpoint configuration. A private DNS zone is linked to the Virtual Network containing a client that wants to communicate to a service through its private endpoint. The private DNS zone has an A record that resolves the FQDN to the private IP address of the private endpoint. The following diagram illustrates the flow.

:::image type="complex" source="./images/dns-private-endpoints-basic-config-works.svg" lightbox="./images/dns-private-endpoints-basic-config-works.svg" alt-text="Diagram showing a basic private endpoint and DNS configuration.":::
The diagram shows an Azure Virtual Network, Azure DNS, a private DNS zone and an Azure storage account. The virtual network has a client in a workload subnet and a private endpoint in a private endpoint subnet. The private endpoint has a private IP address of 10.0.1.4 and it points to the storage account. The diagram illustrates that the client makes a request to the resources FQDN. Azure DNS forwards the query to the private DNS zone, which has an A record for that FQDN, so it returns the private IP address for the private endpoint. The client is able to make the request.
:::image-end:::
*Figure 2: A basic DNS configuration for private endpoints*

1. Client issues a request to mystorageacct.blob.core.windows.net.
2. Azure DNS, the configured DNS server for the Virtual Network is queried for the IP address for mystorageacct.blob.core.windows.net.

    Running the following command from the virtual machine (VM) illustrates that the VM is configured to use Azure DNS (168.63.129.16) as the DNS provider.

    ```Bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 168.63.129.16
             DNS Servers: 168.63.129.16    
    ```

3. Azure DNS is aware that the private DNS zone privatelink.blob.core.windows.net is linked to spokevnet, so it forwards the query.
4. Because the A record exists for mystorageaccount.privatelink.blob.core.windows.net is found, the private IP address 10.0.1.4 is returned.

    Running the following command from the VM resolves the storage account's DNS to the private IP address of the private endpoint.

    ```Bash
    resolvectl query mystorageaccount.blob.core.windows.net

    mystorageaccount.blob.core.windows.net: 10.0.1.4   -- link: eth0
                                        (mystorageaccount.privatelink.blob.core.windows.net)
    ```

5. The request is issued to the Private Link Endpoint with the 10.0.1.4 IP address.
6. A private connection to the storage account is established through the Azure Private Link service.

The above works because Azure DNS is the configured DNS server for the Virtual Network, is aware of the linked private DNS zone, and forwards the DNS query to it.

#### Nonworking example

The nonworking example represents an attempt to use private endpoints with our default network architecture. It isn't possible to link a private DNS zone to a virtual hub in Virtual WAN. Therefore, when clients are configured to use the Azure Firewall as their DNS servers, the requests are proxied to Azure DNS, which doesn't have a linked private DNS zone. Azure DNS doesn't know how to resolve the query.

:::image type="complex" source="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" lightbox="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" alt-text="Diagram showing DNS configuration in a private DNS zone not working because Azure Firewall has DNS proxy enabled.":::
The diagram shows a virtual hub with and Azure Firewall with DNS Proxy enabled. It illustrates that you can't connect a private DNS zone to a virtual hub. It further illustrates that a client isn't able to make use of the A record in the private DNS zone to resolve the FQDN to the private IP address of the storage account.
:::image-end:::
*Figure 3: Private DNS zones can't be linked to virtual hubs*

1. Client issues a request to mystorageacct.blob.core.windows.net.

    Running the following command from the VM illustrates that the VM is configured to use Azure Firewall as the DNS provider.

    ```Bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 10.0.1.132
             DNS Servers: 10.0.1.132    
    ```

2. Azure Firewall DNS Proxy is enabled in the virtual hub, so the DNS query of mystorageacct.blob.core.windows.net is proxied to Azure DNS.
3. Because you can't link a private DNS zone to the virtual hub, Azure DNS can't resolve mystorageacct.blob.core.windows.net to the private IP address of the private endpoint. Azure DNS responds with the public IP address of the storage account.

    Running the following command from the VM resolves the storage account's DNS to the public IP of the storage account.

    ```Bash
    resolvectl query mystorageaccount.blob.core.windows.net
    
    mystorageaccount.blob.core.windows.net: 52.239.174.228 -- link: eth0
                                        (blob.bn9prdstr08a.store.core.windows.net)
    ```

    Because Azure Firewall is proxying DNS queries, we're able to log them. The following are sample Azure Firewall DNS Proxy logs.

    ```bash
    DNS Request: 10.1.0.4:60137 - 46023 A IN mystorageacct.blob.core.windows.net. udp 63 false 512 NOERROR qr,rd,ra 313 0.009424664s
    DNS Request: 10.1.0.4:53145 - 34586 AAAA IN blob.bn9prdstr08a.store.core.windows.net. udp 69 false 512 NOERROR qr,aa,rd,ra 169 0.000113s    
    ```

4. The client doesn't have the private IP address for the Private Link Endpoint and can't establish a private connection to the storage account.

The above behavior is expected and is one problem that the scenarios are going to address.

## Scenarios

The scenarios consist of a client accessing one or more services over a private endpoint under different network topologies that adhere to the default network architecture. The scenarios start with a client accessing a single service in a network with a single region and a single subnet. The scenarios get incrementally more complex, adding subnets and regions, and adding another resource that the client must access.

The client is implemented as a VM and one of the services the client accesses is implemented as a storage account. VMs are a good stand-in for any Azure resource that has a NIC exposed on a Virtual network, such as Virtual Machine Scale Sets, Azure Kubernetes Service, or other services that routes in a similar way.

> [!IMPORTANT]
> Azure Storage account’s Private Link implementation might differ from other services in subtle ways, but it does align well for many.

The solution to every scenario takes advantage of the [virtual hub extensions pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml). This pattern addresses how to expose shared services in a virtual hub in an isolated and secure manner.

> [!IMPORTANT]
> Read the article on [the virtual hub extensions pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml) before reading the scenarios and their solutions. The extensions pattern plays a key role in the solutions.

Each scenario starts with the desired end state and details the configuration required to get from the beginning state to the desired state. The following table contains links to the virtual hub extension pattern and the scenarios.

| Article | Description |
| --- | --- |
| [Virtual hub extensions pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml) | This pattern addresses how to expose shared services in a virtual hub in an isolated and secure manner. |
| [Scenario 1](./private-link-vwan-dns-single-region-workload.yml) | A Workload in a single region accessing one dedicated PaaS resource. |
| Scenario 2 - *coming soon* | Workloads in two regions accessing one dedicated PaaS resource. |
| Scenario 3 - *coming soon* | A workload in a single region accessing two workload-isolated PaaS resources. |
| Scenario 4 - *coming soon* | Workloads in two regions accessing two workload-isolated resources. |

## Next steps

> [!div class="nextstepaction"]
> [Read about the virtual hub extension pattern](./private-link-vwan-dns-virtual-hub-extension-pattern.yml)

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
