---
title: Implement a Zero Trust Network for Web Applications by Using Azure Firewall and Azure Application Gateway
description: Protect web apps by implementing Zero Trust security in virtual networks. Use Azure Firewall and Azure Application Gateway in networks to maximize protection.
author: erjosito
ms.author: jomore
ms.date: 06/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.category:
   - networking
ms.custom: arb-web
---

# Implement a Zero Trust network for web applications by using Azure Firewall and Azure Application Gateway

This article describes how to implement Zero Trust security for web apps to enable inspection and end-to-end encryption. The Zero Trust model includes many other concepts, such as continuous identity verification and minimizing the size of the implicit trust areas. 

This article focuses on the encryption and inspection component of a Zero Trust architecture for inbound traffic from the public internet. For more information about other aspects of deploying your application securely, such as authentication and authorization, see the [Zero Trust documentation][Zero Trust documentation]. The example in this article uses a multilayered approach. In a multilayered approach, network security makes up one of the layers of the Zero Trust model. In this layer, network appliances inspect packets to ensure that only legitimate traffic reaches applications.

Typically, different types of network appliances inspect different aspects of network packets:

- Web application firewalls look for patterns that indicate an attack at the web application layer.

- Next-generation firewalls can also look for generic threats.

This architecture focuses on a common pattern for maximizing security, in which Azure Application Gateway inspects and processes traffic before it reaches Azure Firewall Premium. In some scenarios, you can combine different types of network security appliances to increase protection. For more information, see [Azure Firewall and Application Gateway for virtual networks][Firewall and Application Gateway for virtual networks].

## Architecture

:::image type="complex" border="false" source="./images/application-gateway-before-azure-firewall-architecture.svg" alt-text="Architecture diagram that shows the packet flow in a web app network that uses Application Gateway in front of Azure Firewall Premium." lightbox="./images/application-gateway-before-azure-firewall-architecture.svg":::
   In this diagram, an arrow labeled HTTPS points from an icon that represents clients to icons that represent Application Gateway and Azure Web Application Firewall. Another arrow labeled HTTPS points from these icons to an Azure Firewall Premium icon. Two arrows point from the Azure Firewall Premium icon. One arrow is labeled Domain Name System (DNS) and points to a DNS server or private zone. The other arrow is labeled HTTPS and points to an icon that represents Azure Virtual Machines.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/application-gateway-before-azure-firewall.vsdx) of this architecture.*

This architecture uses the Transport Layer Security (TLS) protocol to encrypt traffic at every step.

1. A client sends packets to Application Gateway, a load balancer. It runs with the optional addition of [Azure Web Application Firewall][What is Azure Web Application Firewall on Application Gateway?].

1. Application Gateway decrypts the packets and searches for threats to web applications. If it doesn't find any threats, it uses Zero Trust principles to encrypt the packets. Then it releases them.

1. Azure Firewall Premium runs the following security checks:

   - [TLS inspection][TLS inspection] decrypts and examines the packets.
   - [Intrusion detection and prevention system (IDPS)][IDPS] features check the packets for malicious intent.

1. If the packets pass the tests, Azure Firewall Premium takes these steps:

   - It encrypts the packets.
   - It uses a Domain Name System (DNS) service to determine the application virtual machine (VM).
   - It forwards the packets to the application VM.

Various inspection engines in this architecture ensure traffic integrity:

- Azure Web Application Firewall uses rules to prevent attacks at the web layer. Examples of attacks include SQL code injection and cross-site scripting. For more information about rules and the Open Worldwide Application Security Project (OWASP) Core Rule Set (CRS), see [Web application firewall CRS rule groups and rules][Web application firewall CRS rule groups and rules].

- Azure Firewall Premium uses generic intrusion detection and prevention rules. These rules help identify malicious files and other threats that target web applications.

This architecture supports the following types of network design, which this article discusses:

- Traditional hub and spoke networks
- Networks that use Azure Virtual WAN as a platform
- Networks that use Azure Route Server to simplify dynamic routing

## Azure Firewall Premium and name resolution

When Azure Firewall Premium checks for malicious traffic, it verifies that the HTTP Host header matches the packet IP address and Transmission Control Protocol (TCP) port. For example, suppose Application Gateway sends web packets to the IP address 172.16.1.4 and TCP port 443. The value of the HTTP Host header should resolve to that IP address.

HTTP Host headers usually don't contain IP addresses. Instead, the headers contain names that match the server's digital certificate. In this case, Azure Firewall Premium uses DNS to resolve the Host header name to an IP address. The network design determines which DNS solution works best.

> [!NOTE]
> Application Gateway doesn't support port numbers in HTTP Host headers. As a result:
>
> - Azure Firewall Premium assumes a default HTTPS TCP port of 443.
> - The connection between Application Gateway and the web server only supports TCP port 443, not nonstandard ports.

## Digital certificates

The following diagram shows the common names (CNs) and certificate authorities (CAs) that this architecture's TLS sessions and certificates use.

:::image type="complex" border="false" source="./images/application-gateway-before-azure-firewall-certificates.svg" alt-text="Diagram that shows the CNs and CAs that a web app network uses when a load balancer is in front of a firewall." lightbox="./images/application-gateway-before-azure-firewall-certificates.svg":::
   In this diagram, an arrow labeled HTTPS points from an icon that represents clients to icons that represent Application Gateway and Azure Web Application Firewall. On the left side of these icons are the CN, myapp.contoso.com, and the CA, DigiCert. On the right side of these icons is the Azure Firewall root CA in HTTP settings. Another arrow labeled HTTPS points from these icons to an Azure Firewall Premium icon. On the left side of this icon is the CN, myapp.contoso.com, and the CA, Azure Firewall CA. Another arrow labeled HTTPS points to an icon that represents Azure Virtual Machines. On the left side of this icon is the CN, myapp.contoso.com, and the CA, DigiCert. 
:::image-end:::

Azure Firewall dynamically generates its own certificates. This capability is one of the main reasons why it's placed behind Application Gateway. Otherwise, the application client is confronted with self-generated certificates that are flagged as a security risk.

### TLS connections

This architecture contains three distinct TLS connections. Digital certificates validate each one.

#### From clients to Application Gateway

In Application Gateway, you deploy the digital certificate that clients see. A well-known CA such as DigiCert or Let's Encrypt typically issues such a certificate. This mechanism is fundamentally different from how Azure Firewall dynamically generates digital certificates from a self-signed or internal public key infrastructure CA.

#### From Application Gateway to Azure Firewall Premium

To decrypt and inspect TLS traffic, Azure Firewall Premium dynamically generates certificates. Azure Firewall Premium also presents itself to Application Gateway as the web server. A private CA signs the certificates that Azure Firewall Premium generates. For more information, see [Azure Firewall Premium certificates][Azure Firewall Premium certificates]. Application Gateway needs to validate those certificates. In the application's HTTP settings, you configure the root CA that Azure Firewall Premium uses.

#### From Azure Firewall Premium to the web server

Azure Firewall Premium establishes a TLS session with the destination web server. Azure Firewall Premium verifies that a well-known CA signs the web server TLS packets.

### Component roles

Application Gateway and Azure Firewall Premium handle certificates differently from one another because their roles differ:

- Application Gateway is a *reverse web proxy*. It protects web servers from malicious clients by intercepting HTTP and HTTPS requests. You declare each protected server that's in the back-end pool of Application Gateway with its IP address or fully qualified domain name. Legitimate clients should be able to access each application. So you configure Application Gateway with a digital certificate that a public CA signs. Use a CA that any TLS client accepts.

- Azure Firewall Premium is a *forward web proxy.* That is, it acts as a web proxy, protecting clients from malicious web servers by intercepting TLS calls from the protected clients. When a protected client makes an HTTP request, the forward web proxy impersonates the target web server by generating digital certificates and presenting them to the client. Azure Firewall Premium uses a private CA, which signs the dynamically generated certificates. You configure the protected clients to trust that private CA. In this architecture, Azure Firewall Premium protects requests from Application Gateway to the web server. Application Gateway trusts the private CA that Azure Firewall Premium uses.

## Routing and traffic forwarding

Routing is slightly different depending on the topology of your network design. The following sections describe examples of hub and spoke, Virtual WAN, and Route Server topologies. All topologies have the following aspects in common:

- Application Gateway always serves as a proxy. Azure Firewall Premium also serves as a proxy when it's configured for TLS inspection. Application Gateway terminates the TLS sessions from clients, and new TLS sessions are built toward Azure Firewall. Azure Firewall receives and terminates the TLS sessions sourced from Application Gateway and builds new TLS sessions toward the workloads. This process affects the IDPS configuration of Azure Firewall Premium. For more information, see [IDPS and private IP addresses][IDPS and private IP addresses].

- The workload sees connections that come from the Azure Firewall subnet IP address. The original client IP address is preserved in the `X-Forwarded-For` HTTP header that Application Gateway inserts. Azure Firewall also supports injecting the source client IP address in the `X-Forwarded-For` header. In this scenario, the source client IP address is the application gateway's IP address.

- Traffic from Application Gateway to the workload is typically sent to Azure Firewall by using Azure routing mechanisms. These mechanisms include user-defined routes (UDRs) configured in the Application Gateway subnet or routes that Virtual WAN or Route Server inject. Explicitly defining the Azure Firewall private IP address in the Application Gateway back-end pool is possible, but we don't recommend doing so because it removes some of the native functionality of Application Gateway, such as load balancing and session stickiness.

The following sections describe some of the most common topologies that you can use with Azure Firewall and Application Gateway.

### Hub and spoke topology

A hub and spoke design typically deploys shared network components in the hub virtual network and application-specific components in the spokes. In most systems, Azure Firewall Premium is a shared resource. Azure Web Application Firewall can be a shared network device or an application-specific component. It's a best practice to treat Application Gateway as an application component and deploy it in a spoke virtual network for the following reasons:

- It can be difficult to troubleshoot Azure Web Application Firewall alerts. You generally need in-depth knowledge of the application to decide whether the messages that trigger those alarms are legitimate.

- If you treat Application Gateway as a shared resource, you might exceed [Application Gateway limits][Application Gateway limits].

- You might face role-based access control problems if you deploy Application Gateway in the hub. This situation can occur when teams manage different applications but use the same instance of Application Gateway. Each team then has access to the entire Application Gateway configuration.

In traditional hub and spoke architectures, DNS private zones provide an easy way to use DNS:

1. Configure a DNS private zone.
1. Link the zone to the virtual network that contains Azure Firewall Premium.
1. Make sure that an address record exists for the value that Application Gateway uses for traffic and for health checks.

The following diagram shows the packet flow when Application Gateway is in a spoke virtual network. In this case, a client connects from the public internet.

:::image type="complex" border="false" source="./images/application-gateway-before-azure-hub-spoke-external.svg" alt-text="Diagram that shows the packet flow in a hub and spoke network that includes a load balancer and a firewall. Clients connect from the public internet." lightbox="./images/application-gateway-before-azure-hub-spoke-external.svg":::
   The diagram consists of two main sections, the hub virtual network and the spoke virtual network. A blue arrow represents a client request's journey from the internet to the application subnet in the spoke virtual network. The blue arrow starts at an icon that represents the internet and points to the Application Gateway subnet in the spoke virtual network. The blue arrow continues from the Application Gateway subnet to the Azure Firewall subnet in the hub virtual network. It then points from the Azure Firewall subnet to the application subnet in the spoke virtual network. A double-sided arrow labeled virtual network peering connects the hub virtual network and the spoke virtual network sections. A green arrow represents the client request's journey from the application subnet back to the client. The green arrow starts at the application subnet and points to the Azure Firewall subnet. The green arrow continues from the Azure Firewall subnet to the Application Gateway subnet and back to the client.
:::image-end:::

1. A client submits a request to a web server.

1. Application Gateway intercepts the client packets and examines them. If the packets pass inspection, Application Gateway sends the packets to the back-end VM. When the packets reach Azure, a UDR in the Application Gateway subnet forwards them to Azure Firewall Premium.

1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.

1. The VM responds and sets the destination IP address to the application gateway. A UDR in the VM subnet redirects the packets to Azure Firewall Premium.

1. Azure Firewall Premium forwards the packets to Application Gateway.

1. Application Gateway answers the client.

Traffic can also arrive from an on-premises network instead of the public internet. The traffic flows either through a site-to-site virtual private network (VPN) or through Azure ExpressRoute. In this scenario, the traffic first reaches a virtual network gateway in the hub. The rest of the network flow is the same as the previous diagram.

:::image type="complex" border="false" source="./images/application-gateway-before-azure-hub-spoke-internal.svg" alt-text="Diagram that shows the packet flow in a hub and spoke network that includes a load balancer and a firewall. Clients connect from an on-premises network." lightbox="./images/application-gateway-before-azure-hub-spoke-internal.svg":::
   The diagram consists of two main sections, the hub virtual network and the spoke virtual network. A blue arrow represents a client request's journey from on-premises to the application VM. The blue arrow begins at the on-premises client and points to the virtual network gateway subnet in the hub virtual network. The blue arrow continues from the virtual network gateway subnet to the Application Gateway subnet in the spoke virtual network. It then points to the Azure Firewall subnet in the hub virtual network and continues to the application subnet in the spoke virtual network. A double-sided arrow labeled virtual network peering connects the hub virtual network and the spoke virtual network sections. A green arrow represents the client request's journey from the application VM back to the on-premises client. The green arrow begins at the application VM and points to the Azure Firewall subnet. It then points to the Application Gateway subnet, to the virtual network gateway, and then to the client.
:::image-end:::

1. An on-premises client connects to the virtual network gateway.

1. The virtual network gateway forwards the client packets to Application Gateway.

1. Application Gateway examines the packets. If they pass inspection, a UDR in the Application Gateway subnet forwards the packets to Azure Firewall Premium.

1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.

1. The VM responds and sets the destination IP address to Application Gateway. A UDR in the VM subnet redirects the packets to Azure Firewall Premium.

1. Azure Firewall Premium forwards the packets to Application Gateway.

1. Application Gateway sends the packets to the virtual network gateway.

1. The virtual network gateway answers the client.

### Virtual WAN topology

You can also use the networking service [Virtual WAN][What is Azure Virtual WAN?] in this architecture. This component provides many benefits. For instance, it eliminates the need for user-maintained UDRs in spoke virtual networks. You can define static routes in virtual hub route tables instead. The programming of every virtual network that you connect to the hub then contains these routes.

When you use Virtual WAN as a networking platform, two main differences result:

- You can't link DNS private zones to a virtual hub because Microsoft manages virtual hubs. As the subscription owner, you don't have permissions to link private DNS zones. As a result, you can't associate a DNS private zone with the secure hub that contains Azure Firewall Premium. 

   To implement DNS resolution for Azure Firewall Premium, use DNS servers instead:

  - Configure the [Azure Firewall DNS settings][Azure Firewall DNS settings] to use custom DNS servers.

  - Deploy the servers in a shared services virtual network that you connect to the virtual WAN.

  - Link a DNS private zone to the shared services virtual network. The DNS servers can then resolve the names that Application Gateway uses in HTTP Host headers. For more information, see [Azure Firewall DNS settings][Azure Firewall DNS settings].

- You can only use Virtual WAN to program routes in a spoke if the prefix is shorter (less specific) than the virtual network prefix. For example, in the preceding diagrams, the spoke virtual network has the prefix `172.16.0.0/16`. In this case, Virtual WAN isn't able to inject a route that matches the virtual network prefix (`172.16.0.0/16`) or any of the subnets (`172.16.0.0/24`, `172.16.1.0/24`). In other words, Virtual WAN can't direct traffic between two subnets that are in the same virtual network.

   This limitation becomes apparent when Application Gateway and the destination web server are in the same virtual network. Virtual WAN can't force the traffic between Application Gateway and the web server to go through Azure Firewall Premium. One work-around is to manually configure UDRs in the Application Gateway and web server subnets.

The following diagram shows the packet flow in an architecture that uses Virtual WAN. In this scenario, access to Application Gateway comes from an on-premises network. A site-to-site VPN or ExpressRoute instance connects that network to Virtual WAN. Internet-based access follows a similar path.

:::image type="complex" border="false" source="./images/application-gateway-before-azure-virtual-wan-internal.svg" alt-text="Diagram that shows the packet flow in a hub and spoke network that includes a load balancer, a firewall, and Virtual WAN." lightbox="./images/application-gateway-before-azure-virtual-wan-internal.svg":::
   The diagram consists of four sections, the hub virtual network, the Application Gateway virtual network, the application virtual network, and the shared services virtual network. A blue arrow represents a client request's journey from on-premises to the application VM. The blue arrow starts at the on-premises client and points to the VPN gateway in the hub virtual network. The blue arrow then points from the VPN gateway to the Application Gateway subnet in the Application Gateway virtual network. It continues from the Application Gateway subnet to an icon that represents Azure Firewall Premium in the hub virtual network. Then it points from the Azure Firewall Premium icon to the DNS subnet in the shared services virtual network. A green arrow represents the client request's journey back to the on-premises client. The green arrow starts at the DNS subnet and points to the Azure Firewall Premium icon in the hub virtual network. A blue arrow represents packets that pass the Azure Firewall Premium security checks. It points to the application VM in the application virtual network. The green arrow points back to Azure Firewall Premium and continues the Application Gateway subnet, then the VPN gateway, and finally back to the client.
:::image-end:::

1. An on-premises client connects to the VPN gateway.

1. The VPN gateway forwards the client packets to Application Gateway.

1. Application Gateway examines the packets. If they pass inspection, the Application Gateway subnet forwards the packets to Azure Firewall Premium.

1. Azure Firewall Premium requests DNS resolution from a DNS server in the shared services virtual network.

1. The DNS server answers the resolution request.

1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.

1. The VM responds and sets the destination IP address to Application Gateway. The application subnet redirects the packets to Azure Firewall Premium.

1. Azure Firewall Premium forwards the packets to Application Gateway.

1. Application Gateway sends the packets to the VPN gateway.

1. The VPN gateway answers the client.

If you use this design, you might need to modify the routing that the hub advertises to the spoke virtual networks. Specifically, Application Gateway v2 only supports a `0.0.0.0/0` route that points to the internet. Routes with this address that don't point to the internet break the connectivity that Microsoft requires for managing Application Gateway. If your virtual hub advertises a `0.0.0.0/0` route, prevent that route from propagating to the Application Gateway subnet by taking one of these steps:

- Create a route table with a route for `0.0.0.0/0` and a next hop type of `Internet`. Associate that route with the subnet that you deploy Application Gateway in.

- If you deploy Application Gateway in a dedicated spoke, disable the propagation of the default route in the settings for the virtual network connection.

### Route Server topology

[Route Server][What is Azure Route Server?] provides another way to inject routes automatically in spokes. Use this functionality to avoid the administrative overhead of maintaining route tables. Route Server combines the Virtual WAN and hub and spoke variants:

- You can use Route Server to manage hub virtual networks. As a result, you can link the hub virtual network to a DNS private zone.

- Route Server has the same limitation that Virtual WAN has concerning IP address prefixes. You can only inject routes into a spoke if the prefix is shorter (less specific) than the virtual network prefix. Because of this limitation, Application Gateway and the destination web server need to be in different virtual networks.

The following diagram shows the packet flow when Route Server simplifies dynamic routing. Consider the following points:

- Route Server currently requires the device that injects the routes to send them over Border Gateway Protocol (BGP). Azure Firewall Premium doesn't support BGP, so use a non-Microsoft network virtual appliance (NVA) instead.

- The functionality of the NVA in the hub determines whether your implementation needs DNS.

:::image type="complex" border="false" source="./images/application-gateway-before-azure-firewall-route-server-internal.svg" alt-text="Diagram that shows the packet flow in a hub and spoke network that includes a load balancer, a firewall, and Route Server." lightbox="./images/application-gateway-before-azure-firewall-route-server-internal.svg":::
   The diagram consists of four sections, the hub virtual network, the Application Gateway virtual network, the application virtual network, and the shared services virtual network. The hub virtual network contains three boxes that represent the virtual network gateway subnet, the Route Server subnet, and the NVA subnet. A blue arrow represents a client request's journey from on-premises to the application VM. The blue arrow starts at the on-premises client and points to the virtual network gateway in the hub virtual network section. The blue arrow then points to the Application Gateway subnet in the Application Gateway virtual network. The blue arrow continues to the NVA subnet in the hub virtual network. It then points from the NVA subnet to the DNS subnet in the shared services virtual network. A green arrow represents the client request's journey back to the on-premises client. It starts at the DNS subnet and points to the NVA subnet in the hub virtual network. A blue arrow represents packets that pass the NVA security checks. It points to the application VM in the application virtual network. The green arrow points back to the NVA subnet and continues the Application Gateway subnet, then to the virtual network gateway, and finally back to the client. 
:::image-end:::

1. An on-premises client connects to the virtual network gateway.

1. The virtual network gateway forwards the client packets to Application Gateway.

1. Application Gateway examines the packets. If they pass inspection, the Application Gateway subnet forwards the packets to a back-end machine. Route Server injects a route in the Application Gateway subnet that forwards the traffic to an NVA.

1. The NVA subnet requests DNS resolution from a DNS server in the shared services virtual network.

1. The DNS server answers the resolution request.

1. The NVA runs security checks on the packets. If they pass the tests, the NVA forwards the packets to the application VM.

1. The application VM responds and sets the destination IP address to Application Gateway. Route Server injects a route in the VM subnet that redirects the packets to the NVA.

1. The NVA forwards the packets to Application Gateway.

1. Application Gateway sends the packets to the virtual network gateway.

1. The virtual network gateway answers the client.

Like with Virtual WAN, you might need to modify the routing when you use Route Server. If you advertise the `0.0.0.0/0` route, it might propagate to the Application Gateway subnet. But Application Gateway doesn't support that route. In this case, configure a route table for the Application Gateway subnet. Include a route for `0.0.0.0/0` and a next hop type of `Internet` in that table.

## IDPS and private IP addresses

Azure Firewall Premium decides which IDPS rules to apply based on the source and destination IP addresses of the packets. By default, Azure Firewall treats private IP addresses in the RFC 1918 ranges (`10.0.0.0/8`, `192.168.0.0/16`, and `172.16.0.0/12`) and RFC 6598 range (`100.64.0.0/10`) as internal. So, if you deploy Application Gateway in a subnet in one of these ranges, Azure Firewall Premium considers traffic between Application Gateway and the workload to be internal. Therefore, only IDPS signatures marked to be applied to internal traffic or to any traffic are used. IDPS signatures marked to be applied for inbound or outbound traffic aren't applied to traffic between Application Gateway and the workload. For more information, see [Azure Firewall IDPS rules][IDPS-rules].

The easiest way to force IDPS inbound signature rules to be applied to the traffic between Application Gateway and the workload is by placing Application Gateway in a subnet that uses a prefix outside of the private ranges. You don't necessarily need to use public IP addresses for this subnet. Instead, you can customize the IP addresses that Azure Firewall Premium treats as internal for IDPS. For example, if your organization doesn't use the `100.64.0.0/10` range, you can eliminate this range from the list of internal prefixes for IDPS and deploy Application Gateway in a subnet configured with an IP address in `100.64.0.0/10`. For more information, see [Azure Firewall Premium private IPDS ranges][IDPS-private-ranges].

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

* [Jose Moreno](https://de.linkedin.com/in/erjosito) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Secure networks with Zero Trust][Secure networks with Zero Trust]
- [Virtual network traffic routing][Virtual network traffic routing]
- [How an application gateway works][How an application gateway works]

## Related resources

- [Implement a secure hybrid network][Implement a secure hybrid network]
- [Hub-spoke network topology in Azure][Hub-spoke network topology in Azure]
- [Hub-spoke network topology that uses Virtual WAN][Hub-spoke network topology with Azure Virtual WAN]

[Application Gateway limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-application-gateway-limits
[Azure Firewall DNS settings]: /azure/firewall/dns-settings
[Azure Firewall limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits
[Azure Firewall Premium certificates]: /azure/firewall/premium-certificates
[Firewall and Application Gateway for virtual networks]: ./firewall-application-gateway.yml
[How an application gateway works]: /azure/application-gateway/how-application-gateway-works
[Hub-spoke network topology in Azure]: ../../networking/architecture/hub-spoke.yml
[Hub-spoke network topology with Azure Virtual WAN]: ../../networking/architecture/hub-spoke-virtual-wan-architecture.yml
[IDPS]: /azure/firewall/premium-features#idps
[IDPS and private IP addresses]: #idps-and-private-ip-addresses
[IDPS-rules]: /azure/firewall/premium-features#idps-signature-rules
[IDPS-private-ranges]: /azure/firewall/premium-features#idps-private-ip-ranges
[Implement a secure hybrid network]: ../../reference-architectures/dmz/secure-vnet-dmz.yml
[Secure networks with Zero Trust]: /security/zero-trust/networks
[TLS inspection]: /azure/firewall/premium-features#tls-inspection
[Virtual network traffic routing]: /azure/virtual-network/virtual-networks-udr-overview
[Web application firewall CRS rule groups and rules]: /azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules
[What is Azure Route Server?]: /azure/route-server/overview
[What is Azure Virtual WAN?]: /azure/virtual-wan/virtual-wan-about
[What is Azure Web Application Firewall on Application Gateway?]: /azure/web-application-firewall/ag/ag-overview
[Zero Trust documentation]: https://www.microsoft.com/security/business/zero-trust
