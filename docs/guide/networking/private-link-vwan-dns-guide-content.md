Azure Private Link allows you to access Azure PaaS services from your network over a private network connection. You configure a Private Endpoint in your network that uses a private IP address from your network. Clients can then connect privately and securely to Private Link services through that Private Endpoint.

Clients aren't aware of the private IP address of the Private Endpoint. They connect to the service through its Fully Qualified Domain Name (FQDN). The challenge is that you must configure DNS in your network to resolve the FQDN to the private IP address of the Private Endpoint.

Your network design and, in particular, your DNS configuration plays a key factor in supporting private endpoint connectivity to services. This article series takes a common hub-and-spoke network topology using Azure Virtual WAN (VWAN) and provides guidance on implementing several Private Link scenarios where a client accesses one or more PaaS resources. The scenarios start simple and increase in complexity.

| PaaS Resources | # Regions | # Spokes |
| --- | --- | --- |
| 1 dedicated PaaS resource | 1 | 1 |
| 1 dedicated PaaS resource | 1 | 2 |
| 1 dedicated PaaS resource | 2 | 2 |
| 2 workload-isolated PaaS resources | 1 | 1 |
| 2 workload-isolated PaaS resources | 2 | 2 |

The base network topology used in this series isn't intended to be a target network architecture and your design likely has differences. The goal is to outline common networking constraints you might encounter when designing your workloads.

## Default network architecture

:::image type="complex" source="./images/dns-private-endpoints-vwan-baseline-architecture.svg" alt-text="Diagram showing the baseline VWAN architecture used for this series.":::
The diagram shows a network with Azure Virtual WAN. The network has two regions, each with a secured virtual hub. Each secured virtual hub is secured with Azure Firewall. Azure Firewall is configured with DNS Proxy enabled. There are 2 VNets connected to each Virtual Hub. The VNets have a dotted line to the Firewall on their hub, noting that the Firewall instance is their configured DNS.
:::image-end:::
*Figure 1: Default network architecture for all private endpoint and DNS scenarios*

The architecture has the following attributes that have to be taken into consideration when implementing each of the scenarios:

- Hub-and-spoke networking model implemented with Azure Virtual WAN
- Two regions, each with a regional secured virtual hub
- Hub-to-hub connectivity is enabled. This is base functionality and not a setting.
- Branch-to-branch: Disabled - Branch-to-branch communication flows through the hubs
- Each secured regional virtual hub has the following configurations:
  - Internet traffic: Azure Firewall - All traffic out to the internet flows through the Firewall on a regional hub
  - Private traffic: Azure Firewall - Traffic within the network flows through the Firewall
- Each regional virtual hub is secured with Azure Firewall. Each firewall has the following configurations:
  - DNS Servers: Default (Azure provided) - Azure Firewall will proxy DNS requests to Azure DNS
  - DNS Proxy: Enabled - Azure Firewall listens for DNS queries on port 53. Clients in subnet spokes should be configured to use the Azure Firewall DNS proxy, otherwise [the results can be unpredictable](/azure/firewall/dns-details#clients-not-configured-to-use-the-firewall-dns-proxy).
- Each Azure Firewall is logging to Log Analytics - Azure Firewall enables logging DNS requests, which is a requirement for this topology.

### Challenge with DNS Proxy: Enabled

DNS proxy has to be enabled if you want Azure Firewall network rules to support Fully Qualified Domain Names (FQDN). Instead of managing the complexity of ensuring the correct IP addresses are in place in network rules, the rules need only specify the FQDN. Azure Firewall resolves the FQDN to the correct IP address.

When enabling DNS proxy on the Firewall, you should configure spoke network DNS server settings and set the Azure Firewall’s private IP address as the Custom DNS server. This adds complexity regarding private endpoints and DNS because you aren't able to link a Private DNS Zone to a virtual hub. Because of that, Azure DNS Servers don't know how to resolve the private IP address of a private endpoint.

To illustrate the challenge, the following are two configurations, one that works and one that doesn't. We provide details about why they do and don't work, respectively.

#### Working example

The following example is a basic private endpoint configuration. A Private DNS Zone is linked to the VNet containing a client that wants to communicate to a service through its private endpoint. The Private DNS zone has an A record that resolves the FQDN to the private IP address of the private endpoint. The following diagram illustrates the flow.

:::image type="complex" source="./images/dns-private-endpoints-basic-config-works.svg" alt-text="Diagram showing a basic private endpoint and DNS configuration.":::
The diagram shows a Virtual Network, Azure DNS, a Private DNS Zone and a storage account. The VNet has a client in a workload subnet and a private endpoint in a private endpoint subnet. The private endpoint has a private IP address of 10.0.1.4 and it points to the storage account. The diagram illustrates that the client makes a request to the resources FQDN. Azure DNS forwards the query to the Private DNS Zone, which has an A record for that FQDN, so it returns the private IP address for the private endpoint. The client is able to make the request.
:::image-end:::
*Figure 2: A basic DNS configuration for private endpoints*

1. Client issues request to mystorageacct.privatelink.blob.core.windows.net
2. Azure DNS, the configured DNS Server for the VNet is queried for the IP address for mystorageacct.privatelink.blob.core.windows.net.

    Running the following command from the virtual machine illustrates that the virtual machine is configured to use Azure DNS (168.63.129.16) as the DNS provider.

    ```Bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 168.63.129.16
             DNS Servers: 168.63.129.16    
    ```

3. Azure DNS is aware that the Private DNS Zone privatelink.blob.core.windows.net is linked to spokevnet, so it forwards the query.
4. Because the A record exists for mystorageaccount.privatelink.blob.core.windows.net is found, the private IP address 10.0.1.4 is returned.

    Running the following command from the virtual machine resolves the storage account's DNS to the private IP address of the private endpoint.

    ```Bash
    resolvectl query mystorageaccount.blob.core.windows.net

    mystorageaccount.blob.core.windows.net: 10.0.1.4   -- link: eth0
                                        (mystorageaccount.privatelink.blob.core.windows.net)
    ```

5. The request is issued to the Private Link Endpoint with the 10.0.1.4 IP address
6. A private connection to the storage account is established through the private link service

The above works because Azure DNS is the configured DNS server for the VNet, is aware of the linked Private DNS zone, and forwards the DNS query to it.

#### Non-working example

The non-working example represents an attempt to use private endpoints with our default network architecture. It isn't possible to link a Private DNS Zone to a virtual hub in Azure Virtual WAN. Therefore, when clients are configured to use the Azure Firewall as their DNS servers, the requests are proxied to Azure DNS, which doesn't have a linked Private DNS Zone. Azure DNS doesn't know how to resolve the query.

:::image type="complex" source="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" alt-text="Diagram showing DNS configuration in a Private DNS zone not working because Azure Firewall has DNS proxy enabled.":::
The diagram shows a Virtual Hub with and Azure Firewall with DNS Proxy enabled. It illustrates that you can't connect a Private DNS Zone to a Virtual Hub. It further illustrates that a client isn't able to make use of the A record in the Private DNS zone to resolve the FQDN to the private IP address of the storage account.
:::image-end:::
*Figure 3: Private DNS Zones can't be linked to Virtual Hubs*

1. Client issues request to mystorageacct.privatelink.blob.core.windows.net

    Running the following command from the virtual machine illustrates that the virtual machine is configured to use Azure Firewall as the DNS provider.

    ```Bash
    resolvectl status eth0

    Link 2 (eth0)
          Current Scopes: DNS
      Current DNS Server: 10.0.1.132
             DNS Servers: 10.0.1.132    
    ```

2. Azure Firewall DNS Proxy is enabled in the Virtual Hub, so the DNS query of mystorageacct.privatelink.blob.core.windows.net is proxied to Azure DNS.
3. Because you can't link a Private DNS Zone to the Azure VWAN virtual hub, Azure DNS can't resolve mystorageacct.blob.core.windows.net to the private IP address of the private endpoint. Azure DNS responds with the public IP address of the storage account.

    Running the following command from the virtual machine resolves the storage account's DNS to the public IP of the storage account.

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

4. The client doesn't have the private IP address for the Private Link Endpoint and can't establish a private connection to the Storage Account.

The above behavior is expected and is the problem that the scenarios are going to address.



## Scenarios

The scenarios illustrate a client accessing one or more services over a private endpoint under different network topologies. The scenarios start with a client accessing a single service in a network with a single region and a single subnet. The scenarios get incrementally more complex, adding subnets and regions, and adding another resource that the client must access.  

The client is implemented as a Virtual Machine and one of the services the client accesses is implemented as a Storage Account. Virtual Machines are a good stand-in for any Azure resource that has a NIC exposed on a virtual network, such as Virtual Machine Scale Sets, Azure Kubernetes Service, or other services that routes in a similar way.

> [!IMPORTANT]
> Azure Storage Account’s Private Link implementation might differ from other services in subtle ways, but it does align well for many.

Each scenario starts with the desired end state and details the configuration required to get from the beginning state to the desired state. The following are the scenarios.
