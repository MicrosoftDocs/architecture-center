This guide outlines a strategy for implementing [zero-trust][Zero trust definition] security for web apps for inspection and encryption. The zero-trust paradigm includes many other concepts, such as constant verification of the identity of the actors or reducing the size of the implicit trust areas to a minimum. This article refers to the encryption and inspection component of a zero-trust architecture for traffic inbound from the public Internet. Please read other [zero-trust documents][Zero trust definition] for more aspects of deploying your application securely, such as authentication. For the purpose of this article, a multilayered approach works best, where network security makes up one of the layers of the zero-trust model. In this layer, network appliances inspect packets to ensure that only legitimate traffic reaches applications.

Typically, different types of network appliances inspect different aspects of network packets:

- Web application firewalls look for patterns that indicate an attack at the web application layer.
- Next-generation firewalls can also look for generic threats.

In some situations, you can combine different types of network security appliances to increase protection. A separate guide, [Firewall and Application Gateway for virtual networks][Firewall and Application Gateway for virtual networks], describes design patterns that you can use to arrange the various appliances. This document focuses on a common pattern for maximizing security, in which Azure Application Gateway acts before Azure Firewall Premium. The following diagram illustrates this pattern:

:::image type="content" source="./images/application-gateway-before-azure-firewall-architecture.png" alt-text="Architecture diagram showing the packet flow in a web app network that uses Application Gateway in front of Azure Firewall Premium." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/application-gateway-before-azure-firewall.vsdx) of this architecture.*

This architecture uses the Transport Layer Security (TLS) protocol to encrypt traffic at every step.

- A client sends packets to Application Gateway, a load balancer. It runs with the optional addition [Azure Web Application Firewall][What is Azure Web Application Firewall on Azure Application Gateway?].

- Application Gateway decrypts the packets and searches for threats to web applications. If it doesn't find any threats, it uses zero-trust principles to encrypt the packets. Then it releases them.

- Azure Firewall Premium runs security checks:

  - [Transport layer security (TLS) inspection][TLS inspection] decrypts and examines the packets.
  - [Intrusion detection and protection][IDPS] features check the packets for malicious intent.

- If the packets pass the tests, Azure Firewall Premium takes these steps:

  - Encrypts the packets
  - Uses a Domain Name System (DNS) service to determine the application virtual machine (VM)
  - Forwards the packets to the application VM

Various inspection engines in this architecture ensure traffic integrity:

- Web Application Firewall uses rules to prevent attacks at the web layer. Examples of attacks include SQL code injection and cross-site scripting. For more information on rules and the Open Web Application Security Project (OWASP) Core Rule Set, see [Web Application Firewall CRS rule groups and rules][Web Application Firewall CRS rule groups and rules].
- Azure Firewall Premium uses generic intrusion detection and prevention rules. These rules help identify malicious files and other threats that target web applications.

This architecture supports different types of network design, which this article discusses:

- Traditional hub and spoke networks
- Networks that use Azure Virtual WAN as a platform
- Networks that use Azure Route Server to simplify dynamic routing

## Azure Firewall Premium and name resolution

When checking for malicious traffic, Azure Firewall Premium verifies that the HTTP Host header matches the packet IP address and TCP port. For example, suppose Application Gateway sends web packets to the IP address 172.16.1.4 and TCP port 443. The value of the HTTP Host header should resolve to that IP address.

HTTP Host headers usually don't contain IP addresses. Instead, the headers contain names that match the server's digital certificate. In this case, Azure Firewall Premium uses DNS to resolve the Host header name to an IP address. The network design determines which DNS solution works best, as later sections describe.

> [!NOTE]
> Application Gateway doesn't support port numbers in HTTP Host headers. As a result:
>
> - Azure Firewall Premium assumes a default HTTPS TCP port of 443.
> - The connection between Application Gateway and the web server only supports TCP port 443, not non-standard ports.

## Digital certificates

The following diagram shows the common names (CNs) and certificate authorities (CAs) that the architecture's TLS sessions and certificates use:

:::image type="content" source="./images/application-gateway-before-azure-firewall-certificates.png" alt-text="Architecture diagram showing the common names and certificate authorities that a web app network uses when a load balancer is in front of a firewall." border="false":::

### TLS connections

This architecture contains three distinct TLS connections. Digital certificates validate each one:

#### From clients to Application Gateway

In Application Gateway, you deploy the digital certificate that clients see. A well-known CA such as DigiCert or Let's Encrypt typically issues such a certificate.

#### From Application Gateway to Azure Firewall Premium

To decrypt and inspect TLS traffic, Azure Firewall Premium dynamically generates certificates. Azure Firewall Premium also presents itself to Application Gateway as the web server. A private CA signs the certificates that Azure Firewall Premium generates. For more information, see [Azure Firewall Premium certificates][Azure Firewall Premium certificates]. Application Gateway needs to validate those certificates. In the application's HTTP settings, you configure the root CA that Azure Firewall Premium uses.

#### From Azure Firewall Premium to the web server

Azure Firewall Premium establishes a TLS session with the destination web server. Azure Firewall Premium verifies that a well-known CA signs the web server TLS packets.

### Component roles

Application Gateway and Azure Firewall Premium handle certificates differently from one another because their roles differ:

- Application Gateway is a *reverse web proxy*. It protects web servers from malicious clients by intercepting HTTP and HTTPS requests. You declare each protected server that's in the back-end pool of Application Gateway with its IP address or fully qualified domain name. Legitimate clients should be able to access each application. So you configure Application Gateway with a digital certificate that a public CA has signed. Use a CA that any TLS client will accept.
- Azure Firewall Premium is a *forward web proxy* or, simply, a web proxy. It protects clients from malicious web servers by intercepting TLS calls from the protected clients. When a protected client makes an HTTP request, the forward proxy impersonates the target web server by generating digital certificates and presenting them to the client. Azure Firewall Premium uses a private CA, which signs the dynamically generated certificates. You configure the protected clients to trust that private CA. In this architecture, Azure Firewall Premium protects requests from Application Gateway to the web server. Application Gateway trusts the private CA that Azure Firewall Premium uses.

## Hub and spoke example

Typically, a hub and spoke design deploys shared network components in the hub virtual network and application-specific components in the spokes. In most systems, Azure Firewall Premium is a shared resource. But Web Application Firewall can be a shared network device or an application-specific component. For the following reasons, it's usually best to treat Application Gateway as an application component and deploy it in a spoke virtual network:

- It can be difficult to troubleshoot Web Application Firewall alerts. You generally need in-depth knowledge of the application to decide whether the messages that trigger those alarms are legitimate.
- If you treat Application Gateway as a shared resource, you might exceed [Azure Application Gateway limits][Application Gateway limits].
- You might face role-based access control problems if you deploy Application Gateway in the hub. This situation can come up when teams manage different applications but use the same instance of Application Gateway. Each team then has access to the entire Application Gateway configuration.

With traditional hub and spoke architectures, DNS private zones provide an easy way to use DNS:

- Configure a DNS private zone.
- Link the zone to the virtual network that contains Azure Firewall Premium.
- Make sure that an A record exists for the value that Application Gateway uses for traffic and for health checks.

The following diagram shows the packet flow when Application Gateway is in a spoke virtual network. In this case, a client connects from the public internet.

:::image type="content" source="./images/application-gateway-before-azure-hub-spoke-external.png" alt-text="Architecture diagram showing the packet flow in a hub and spoke network with a load balancer and a firewall. Clients connect from the public internet." border="false" lightbox="./images/application-gateway-before-azure-hub-spoke-external.png":::

1. A client submits a request to a web server.
1. Application Gateway intercepts the client packets and examines them. If the packets pass inspection, the Application Gateway would send the packet to the backend VM. When the packet hits Azure, a user-defined route (UDR) in the Application Gateway subnet forwards the packets to Azure Firewall Premium.
1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.
1. The VM responds and sets the destination IP address to the Application Gateway. A UDR in the VM subnet redirects the packets to Azure Firewall Premium.
1. Azure Firewall Premium forwards the packets to Application Gateway.
1. Application Gateway answers the client.

Traffic can also arrive from an on-premises network instead of the public internet. The traffic flows either through a site-to-site virtual private network (VPN) or through ExpressRoute. In this scenario, the traffic first reaches a virtual network gateway in the hub. The rest of the network flow is the same as the previous case.

:::image type="content" source="./images/application-gateway-before-azure-hub-spoke-internal.png" alt-text="Architecture diagram showing the packet flow in a hub and spoke network with a load balancer and a firewall. Clients connect from an on-premises network." border="false" lightbox="./images/application-gateway-before-azure-hub-spoke-internal.png":::

1. An on-premises client connects to the virtual network gateway.
1. The gateway forwards the client packets to Application Gateway.
1. Application Gateway examines the packets. If they pass inspection, a UDR in the Application Gateway subnet forwards the packets to Azure Firewall Premium.
1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.
1. The VM responds and sets the destination IP address to Application Gateway. A UDR in the VM subnet redirects the packets to Azure Firewall Premium.
1. Azure Firewall Premium forwards the packets to Application Gateway.
1. Application Gateway sends the packets to the virtual network gateway.
1. The gateway answers the client.

## Virtual WAN example

You can also use the networking service [Virtual WAN][What is Azure Virtual WAN?] in this architecture. This component offers many benefits. For instance, it eliminates the need for user-maintained UDRs in spoke virtual networks. You can define static routes in virtual hub route tables instead. The programming of every virtual network that you connect to the hub then contains these routes.

When you use Virtual WAN as a networking platform, two main differences result:

- You can't link DNS private zones to a virtual hub because Microsoft manages virtual hubs. As the subscription owner, you don't have permissions for linking private DNS zones. As a result, you can't associate a DNS private zone with the secure hub that contains Azure Firewall Premium. To implement DNS resolution for Azure Firewall Premium, use DNS servers instead:

  - Configure the [Azure Firewall DNS Settings][Azure Firewall DNS settings] to use custom DNS servers.
  - Deploy the servers in a shared services virtual network that you connect to the virtual WAN.
  - Link a DNS private zone to the shared services virtual network. The DNS servers can then resolve the names that Application Gateway uses in HTTP Host headers. For more information, see [Azure Firewall DNS Settings][Azure Firewall DNS settings].

- You can only use Virtual WAN to program routes in a spoke if the prefix is shorter (less specific) than the virtual network prefix. For example, in the diagrams above the spoke VNet has the prefix 172.16.0.0/16: in this case, Virtual WAN would not be able to inject a route that matches the VNet prefix (172.16.0.0/16) or any of the subnets (172.16.0.0/24, 172.16.1.0/24). In other words, Virtual WAN cannot attract traffic between two subnets that are in the same VNet. This limitation becomes apparent when Application Gateway and the destination web server are in the same virtual network: Virtual WAN can't force the traffic between Application Gateway and the web server to go through Azure Firewall Premium (a workaround would be manually configuring User Defined Routes in the subnets of the Application Gateway and web server).

The following diagram shows the packet flow in a case that uses Virtual WAN. In this situation, access to Application Gateway is from an on-premises network. A site-to-site VPN or ExpressRoute connects that network to Virtual WAN. Access from the internet is similar.

:::image type="content" source="./images/application-gateway-before-azure-vwan-internal.png" alt-text="Architecture diagram showing the packet flow in a hub and spoke network that includes a load balancer, a firewall, and Virtual WAN." border="false" lightbox="./images/application-gateway-before-azure-vwan-internal.png":::

1. An on-premises client connects to the VPN.
1. The VPN forwards the client packets to Application Gateway.
1. Application Gateway examines the packets. If they pass inspection, the Application Gateway subnet forwards the packets to Azure Firewall Premium.
1. Azure Firewall Premium requests DNS resolution from a DNS server in the shared services virtual network.
1. The DNS server answers the resolution request.
1. Azure Firewall Premium runs security checks on the packets. If they pass the tests, Azure Firewall Premium forwards the packets to the application VM.
1. The VM responds and sets the destination IP address to Application Gateway. The Application subnet redirects the packets to Azure Firewall Premium.
1. Azure Firewall Premium forwards the packets to Application Gateway.
1. Application Gateway sends the packets to the VPN.
1. The VPN answers the client.

With this design, you might need to modify the routing that the hub advertises to the spoke virtual networks. Specifically, Application Gateway v2 only supports a 0.0.0.0/0 route that points to the internet. Routes with this address that don't point to the internet break the connectivity that Microsoft requires for managing Application Gateway. If your virtual hub advertises a 0.0.0.0/0 route, prevent that route from propagating to the Application Gateway subnet by taking one of these steps:

- Create a route table with a route for 0.0.0.0/0 and a next hop type of `Internet`. Associate that route with the subnet that you deploy Application Gateway in.
- If you deploy Application Gateway in a dedicated spoke, disable the propagation of the default route in the settings for the virtual network connection.

## Route Server example

[Route Server][What is Azure Route Server (Preview)?] offers another way to inject routes automatically in spokes. With this functionality, you avoid the administrative overhead of maintaining route tables. Route Server combines the Virtual WAN and hub and spoke variants:

- With Route Server, customers manage hub virtual networks. As a result, you can link the hub virtual network to a DNS private zone.
- Route Server has the same limitation that Virtual WAN has concerning IP address prefixes. You can only inject routes into a spoke if the prefix is shorter (less specific) than the virtual network prefix. Because of this limitation, Application Gateway and the destination web server need to be in different virtual networks.

The following diagram shows the packet flow when Route Server simplifies dynamic routing. Note these points:

- Route Server currently requires the device that injects the routes to send them over Border Gateway Protocol (BGP). Since Azure Firewall Premium doesn't support BGP, use a third-party Network Virtual Appliance (NVA) instead.
- The functionality of the NVA in the hub determines whether your implementation needs DNS.

:::image type="content" source="./images/application-gateway-before-azure-firewall-route-server-internal.png" alt-text="Architecture diagram showing the packet flow in a hub and spoke network that includes a load balancer, a firewall, and Route Server." border="false" lightbox="./images/application-gateway-before-azure-firewall-route-server-internal.png":::

1. An on-premises client connects to the virtual network gateway.
1. The gateway forwards the client packets to Application Gateway.
1. Application Gateway examines the packets. If they pass inspection, the Application Gateway subnet forwards the packets to a backend machine. A route in the ApplicationGateway subnet injected by the Route Server would forward the traffic to an NVA.
1. The NVA runs security checks on the packets. If they pass the tests, the NVA forwards the packets to the application VM.
1. The VM responds and sets the destination IP address to Application Gateway. A route injected in the VM subnet by the Route Server redirects the packets to the NVA.
1. The NVA forwards the packets to Application Gateway.
1. Application Gateway sends the packets to the virtual network gateway.
1. The gateway answers the client.

As with Virtual WAN, you might need to modify the routing when you use Route Server. If you advertise the 0.0.0.0/0 route, it might propagate to the Application Gateway subnet. But Application Gateway doesn't support that route. In this case, configure a route table for the Application Gateway subnet. Include a route for 0.0.0.0/0 and a next hop type of `Internet` in that table.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Jose Moreno](https://de.linkedin.com/in/erjosito) | Principal Customer Engineer

## Next steps

- [Secure networks with zero trust][Secure networks with Zero Trust]
- [Virtual network traffic routing][Virtual network traffic routing]
- [How an application gateway works][How an application gateway works]

## Related resources

- [Secure and govern workloads with network level segmentation][Secure and govern workloads with network level segmentation]
- [Implement a secure hybrid network][Implement a secure hybrid network]
- [Hub-spoke network topology in Azure][Hub-spoke network topology in Azure]
- [Hub-spoke network topology with Azure Virtual WAN][Hub-spoke network topology with Azure Virtual WAN]

[Application Gateway limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits
[Azure Firewall DNS settings]: /azure/firewall/dns-settings
[Azure Firewall limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits
[Azure Firewall Premium certificates]: /azure/firewall/premium-certificates
[Firewall and Application Gateway for virtual networks]: ./firewall-application-gateway.yml
[How an application gateway works]: /azure/application-gateway/how-application-gateway-works
[Hub-spoke network topology in Azure]: ../../reference-architectures/hybrid-networking/hub-spoke.yml?tabs=cli
[Hub-spoke network topology with Azure Virtual WAN]: ../../networking/hub-spoke-vwan-architecture.yml
[IDPS]: /azure/firewall/premium-features#idps
[Implement a secure hybrid network]: ../../reference-architectures/dmz/secure-vnet-dmz.yml?tabs=portal
[Secure and govern workloads with network level segmentation]: ../../reference-architectures/hybrid-networking/network-level-segmentation.yml
[Secure networks with Zero Trust]: /security/zero-trust/networks
[TLS inspection]: /azure/firewall/premium-features#tls-inspection
[Virtual network traffic routing]: /azure/virtual-network/virtual-networks-udr-overview
[Web Application Firewall CRS rule groups and rules]: /azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules
[What is Azure Route Server (Preview)?]: /azure/route-server/overview
[What is Azure Virtual WAN?]: /azure/virtual-wan/virtual-wan-about
[What is Azure Web Application Firewall on Azure Application Gateway?]: /azure/web-application-firewall/ag/ag-overview
[Zero trust definition]: https://www.microsoft.com/security/business/zero-trust
