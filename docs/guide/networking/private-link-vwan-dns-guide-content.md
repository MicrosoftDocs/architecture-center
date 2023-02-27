Azure Private Link allows you to access Azure PaaS services from your network over a private network connection. You configure a Private Endpoint in your network that uses a private IP address from your network. Clients can then connect privately and securely to Private Link services through that Private Endpoint.

Clients aren't aware of the private IP address of the Private Endpoint. They connect to the service through its Fully Qualified Domain Name (FQDN). The challenge is that you must configure DNS in your network to resolve the FQDN to the private IP address of the Private Endpoint.

Your network design and, in particular, your DNS configuration plays a key factor in supporting private endpoint connectivity to services. This article series takes a common hub-and-spoke network topology using Azure Virtual WAN (VWAN) and provides guidance on implementing several Private Link scenarios where a client accesses one or more PaaS resources. The scenarios start simple and increase in complexity.

| PaaS Resources | # Regions | # Spokes |
| --- | --- | --- |
| 1 dedicated PaaS resource | 1 | 1 |
| 1 dedicated PaaS resource | 2 | 1 |
| 1 dedicated PaaS resource | 2 | 2 |
| 2 workload-isolated PaaS resources | 1 | 2 |
| 2 workload-isolated PaaS resources | 2 | 2 |

The base network topology used in this series isn't intended to be a target network architecture and your design likely has differences. The goal is to outline common networking constraints you might encounter when designing your workloads.

## Default network architecture

:::image type="complex" source="./images/dns-private-endpoints-vwan-baseline-architecture.svg" alt-text="Diagram showing the baseline VWAN architecture used for this series.":::
The diagram shows a network with Azure Virtual WAN. The network has two regions, each with a Virtual Hub. Each Virtual Hub has an Azure Firewall configured with DNS Proxy enabled. There are 2 VNets connected to each Virtual Hub. The VNets have a dotted line to the Firewall on their hub, noting that the Firewall instance is their configured DNS.
:::image-end:::
*Figure 1: Default network architecture for all private endpoint and DNS scenarios*

The architecture has the following attributes that have to be taken into consideration when implementing each of the scenarios:

- Hub-and-spoke networking model implemented with Azure Virtual WAN
- Two regions, each with a VWAN Hub
- Hub-to-hub connectivity is enabled
- Branch-to-branch: Disabled - Branch-to-branch communication to flow through the hubs
- Each VWAN contains an Azure Firewall. The Firewall has the following configurations:
  - DNS Proxy: Enabled - Azure Firewall acts as DNS for any connected spoke networks
  - Internet traffic: Azure Firewall - All traffic out to the internet flows through the Firewall on a regional hub
  - Private traffic: Bypass Azure Firewall - Traffic within the network doesn't flow through the Firewall

### Challenge with DNS Proxy: Enabled

DNS proxy has to be enabled if you want Azure Firewall network rules to support Fully Qualified Domain Names (FQDN). Instead of managing the complexity of ensuring the correct IP addresses are in place in network rules, the rules need only specify the FQDN. Azure Firewall resolves the FQDN to the correct IP address.

Enabling DNS proxy on the Firewall means that clients in the VNet use Azure Firewall for DNS. They don't use Azure DNS. This adds complexity regarding private endpoints and DNS. To illustrate the challenge, the following diagram shows a basic private endpoint configuration. A Private DNS Zone is linked to the VNet containing a client that wants to communicate to a service through its private endpoint. The Private DNS zone has an A record that resolves the FQDN to the private IP address of the private endpoint. The following diagram illustrates the flow.

:::image type="complex" source="./images/dns-private-endpoints-basic-config-works.svg" alt-text="Diagram showing a basic private endpoint and DNS configuration.":::
The diagram shows a Virtual Network, Azure DNS, a Private DNS Zone and a storage account. The VNet has a client in a workload subnet and a private endpoint in a private endpoint subnet. The private endpoint has a private IP address of 10.0.1.4 and it points to the storage account. The diagram illustrates that the client makes a request to the resources FQDN. Azure DNS forwards the query to the Private DNS Zone, which has an A record for that FQDN, so it returns the private IP address for the private endpoint. The client is able to make the request.
:::image-end:::
*Figure 2: A basic DNS configuration for private endpoints*

1. Client issues request to mystorageacct.privatelink.blob.core.windows.net
2. Azure DNS, the configured DNS Server for the VNet is queried for the IP address for mystorageacct.privatelink.blob.core.windows.net.
3. Azure DNS is aware that the Private DNS Zone privatelink.blob.core.windows.net is linked to spokevnet, so it forwards the query.
4. Because the A record exists for mystorageaccount.privatelink.blob.core.windows.net is found, the private IP address 10.0.1.4 is returned.
5. The request is issued to the Private Link Endpoint with the 10.0.1.4 IP address
6. A private connection to the storage account is established through the private link service

The above works because Azure DNS is the configured DNS server for the VNet. Azure DNS is aware of the linked Private DNS zone and forwards the DNS query to it. When DNS Proxy is enabled in the Firewall on the Virtual Hub, the client uses the Firewall for DNS. Because VWAN Virtual Hubs don't support linking Private DNS Zones, the basic DNS setup doesn't work.

:::image type="complex" source="./images/dns-private-endpoints-dnsproxy-basic-config-doesnt-work.svg" alt-text="Diagram showing DNS configuration in a Private DNS zone not working because Azure Firewall has DNS proxy enabled.":::
The diagram shows a Virtual Hub with and Azure Firewall with DNS Proxy enabled. It illustrates that you can't connect a Private DNS Zone to a Virtual Hub. It further illustrates that a client isn't able to make use of the A record in the Private DNS zone to resolve the FQDN to the private IP address of the storage account.
:::image-end:::
*Figure 3: Private DNS Zones don't work with Virtual Hubs*

1. Client issues request to mystorageacct.privatelink.blob.core.windows.net
2. Azure Firewall DNS Proxy is enabled in the Virtual Hub, so the DNS Proxy is queried for the IP address for mystorageacct.privatelink.blob.core.windows.net.
3. Because you can't link a Private DNS Zone to the Azure VWAN virtual hub, the Azure Firewall DNS Proxy can't resolve mystorageacct.privatelink.blob.core.windows.net so it responds ‘no such domain’
4. The client doesn't have the private IP address for the Private Link Endpoint and can't establish a private connection to the Storage Account.

## Scenarios

The scenarios illustrate a client accessing one or more services over a private endpoint under different network topologies. The scenarios start with a client accessing a single service in a network with a single region and a single subnet. The scenarios get incrementally more complex, adding subnets and regions, and adding another resource that the client must access.  

The client is implemented as a Virtual Machine and one of the services the client accesses is implemented as a Storage Account. Virtual Machines are a good stand-in for any Azure resource that has a NIC exposed on a virtual network, such as Virtual Machine Scale Sets, Azure Kubernetes Service, or other services that routes in a similar way. Be aware that Azure Storage Account’s Private Link implementation may differ from other services in subtle ways, but it does align well for many.

Each scenario starts with the desired end state and details the configuration required to get from the beginning state to the desired state. The following are the scenarios.
