To help secure Azure application workloads, use protective measures such as authentication and encryption in the applications themselves. You can add security layers to the virtual networks that host the applications. These security layers help protect the application's inbound flows from unintended use. They also limit outbound flows to the internet to only those endpoints that your application requires. This article describes [Azure Virtual Network][azure-virtual-network] security services like Azure DDoS Protection, Azure Firewall, and Azure Application Gateway. It also describes when to use each service and network design options that combine them.

- [DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application design best practices, provides enhanced DDoS mitigation features that improve defense against DDoS attacks. You should enable DDoS Protection on every perimeter virtual network.

- [Azure Firewall][azfw-overview] is a managed, next-generation firewall that provides [network address translation (NAT)][nat] capabilities. Azure Firewall filters packets based on IP addresses and Transmission Control Protocol (TCP) or User Datagram Protocol (UDP) ports. It can filter traffic by using application-based attributes, such as HTTP(S) and SQL. Azure Firewall also applies Microsoft threat intelligence to help identify malicious IP addresses. For more information, see [Azure Firewall documentation][azfw-docs].

- [Azure Firewall Premium][azfw-premium-features] includes all the functionality of Azure Firewall Standard, in addition to features like transport layer security (TLS) inspection and intrusion detection and prevention system (IDPS).

- [Application Gateway][appgw-overview] is a managed web traffic load balancer and HTTP(S) full reverse proxy that can perform Secure Socket Layer (SSL) encryption and decryption. Application Gateway preserves the original client IP address in an `X-Forwarded-For` HTTP header. Application Gateway also uses Azure Web Application Firewall to inspect web traffic and detect attacks at the HTTP layer. For more information, see [Application Gateway documentation][appgw-docs].

- [Web Application Firewall][web-application-firewall] is an optional addition to Application Gateway. It inspects HTTP requests and prevents web layer attacks, such as SQL injection and cross-site scripting. For more information, see [Web Application Firewall documentation][waf-docs].

These Azure services complement each other. Depending on your needs, using one service might suit your workloads better. However, you can use these services together to help provide optimal protection at both the network and application layers. Use the following decision tree and the examples in this article to choose the best security option for your application's virtual network.

Azure Firewall and Application Gateway use different technologies to help secure different types of data flows.

|Application flow| Can be filtered by Azure Firewall | Can be filtered by Web Application Firewall on Application Gateway |
| --- | :---: |:---: |
| HTTP(S) traffic from on-premises or internet to Azure (inbound) | Yes | Yes |
| HTTP(S) traffic from Azure to on-premises or internet (outbound) | Yes | No |
| Non-HTTP(S) traffic (inbound or outbound) | Yes | No |

The design can vary for each application based on the network flows that it requires. The following diagram provides a simplified decision tree that helps you choose the recommended approach for your application. This choice depends on whether the application is published via HTTP(S) or some other protocol.

![Diagram that shows the virtual network security decision tree.](./images/decision-tree-simple.png)

This article describes the widely recommended designs shown in the flow chart and designs suited for less common scenarios:

- **[Azure Firewall only](#azure-firewall-only-design):** Use this design when there are no web applications in the virtual network. It controls both inbound traffic to the applications and outbound traffic.

- **[Application Gateway only](#application-gateway-only-design):** Use this design when only web applications are in the virtual network and [network security groups (NSGs)][nsgs] provide sufficient output filtering. Azure Firewall provides functionality that can help prevent several attack scenarios, such as data exfiltration and IDPS. As a result, the Application Gateway-only design isn't usually recommended, so it isn't included in the previous flow chart.

- **[Azure Firewall and Application Gateway in parallel](#azure-firewall-and-application-gateway-in-parallel-design):** Use this design when you want Application Gateway to protect HTTP(S) applications from web attacks and Azure Firewall to protect all other workloads and filter outbound traffic. Azure Firewall and Application Gateway in parallel is a common design.

- **[Application Gateway in front of Azure Firewall](#application-gateway-in-front-of-azure-firewall-design):** Use this design when you want Azure Firewall to inspect all traffic, Web Application Firewall to protect web traffic, and the application to identify the client's source IP address. With Azure Firewall Premium and TLS inspection, this design also supports the end-to-end SSL scenario.

- **[Azure Firewall in front of Application Gateway](#azure-firewall-in-front-of-application-gateway-design):** Use this design when you want Azure Firewall to inspect and filter traffic before it reaches the Application Gateway. Because Azure Firewall doesn't decrypt HTTPS traffic, its added functionality to the Application Gateway is limited. This scenario isn't documented in the previous flow chart.

Variations of these fundamental designs are described later in this article and include:

- [On-premises application clients](#on-premises-clients).
- [Hub-and-spoke networks](#hub-and-spoke-topology).
- [Azure Kubernetes Service (AKS)](#aks) implementations.

You can add other reverse proxy services, like an [Azure API Management][api-management-overview] gateway or [Azure Front Door][frontdoor]. Or you can replace the Azure resources with non-Microsoft [network virtual appliances (NVAs)](#other-nvas).

 > [!NOTE]
 > In the following scenarios, an Azure virtual machine (VM) is used as an example of a web application workload. These scenarios are also valid for other workload types, such as containers or Azure Web Apps. For setups that include private endpoints, consider the recommendations in [Azure Firewall scenarios to inspect traffic destined to a private endpoint][azfw-endpoint].

## Azure Firewall-only design

If there are no web-based workloads in the virtual network that can benefit from Web Application Firewall, you can use the Azure Firewall-only design. The design in this example is simple, but you can review the packet flow to better understand more complex designs. In this design, all inbound traffic is sent to Azure Firewall via user-defined routes (UDRs) for connections from on-premises or other Azure virtual networks. It's addressed to the Azure Firewall public IP address for connections from the public internet, as shown in the following diagram. UDRs direct outbound traffic from Azure virtual networks to Azure Firewall, as shown in the following dialog.

The following table summarizes the traffic flows for this scenario.

| Flow | Goes through Application Gateway/Web Application Firewall | Goes through Azure Firewall |
| ---- | :--: | :--: |
| HTTP(S) traffic from the internet or on-premises to Azure     | N/A | Yes |
| HTTP(S) traffic from Azure to the internet or on-premises     | N/A | Yes |
| Non-HTTP(S) traffic from the internet or on-premises to Azure | N/A | Yes |
| Non-HTTP(S) traffic from Azure to the internet or on-premises | N/A | Yes |

Azure Firewall doesn't inspect inbound HTTP(S) traffic. But it can apply layer 3 and layer 4 rules and fully qualified domain name (FQDN)-based application rules. Azure Firewall inspects outbound HTTP(S) traffic, depending on the Azure Firewall tier and whether you configure TLS inspection:

- Azure Firewall Standard inspects only layer 3 and layer 4 attributes of packets in network rules and the Host HTTP header in application rules.

- Azure Firewall Premium adds capabilities, such as inspecting other HTTP headers (like the user-agent) and enabling TLS inspection for deeper packet analysis. However, Azure Firewall isn't the same as Web Application Firewall. If you have web workloads in your virtual network, we recommend that you use Web Application Firewall.

The following packet walk example shows how a client accesses a VM-hosted application from the public internet. The diagram includes only one VM for simplicity. For higher availability and scalability, there are multiple application instances behind a load balancer. In this design, Azure Firewall inspects incoming connections from the public internet and outbound connections from the application subnet VM by using the UDR.

- In this example, Azure Firewall automatically deploys several instances with the front-end IP address `192.168.100.4` and internal addresses within the range `192.168.100.0/26`. Normally, these instances aren't visible to the Azure administrator. However, being aware of them can be helpful for troubleshooting network problems.

- If traffic comes from an on-premises virtual private network (VPN) or [Azure ExpressRoute][expressroute] gateway instead of the internet, the client starts the connection to the VM's IP address. It doesn't start the connection to the firewall's IP address, and the firewall doesn't do source NAT by default.

### Architecture

The following diagram shows the traffic flow and assumes that the instance IP address is `192.168.100.7`.

![Diagram that shows the Azure Firewall-only design.](./images/design1_500.png)

#### Workflow

1. The client starts the connection to the public IP address of Azure Firewall.

   - Source IP address: `ClientPIP`
   - Destination IP address: `AzFwPIP`

2. The request to the Azure Firewall public IP address is distributed to a back-end instance of the firewall, which is `192.168.100.7` in this example. The Azure Firewall [Destination Network Address Translation (DNAT) rule][azfw-dnat] translates the destination IP address to the application IP address inside the virtual network. Azure Firewall also implements *source network address translation (SNAT)* on the packet if it uses DNAT. For more information, see [Azure Firewall known issues][azfw-known-issues]. The VM sees the following IP addresses in the incoming packet:

   - Source IP address: `192.168.100.7`
   - Destination IP address: `192.168.1.4`

3. The VM answers the application request, which reverses both the source and destination IP addresses. The inbound flow doesn't require a UDR because the source IP is the Azure Firewall IP address. The UDR in the diagram for `0.0.0.0/0` is for outbound connections to ensure that packets to the public internet go through Azure Firewall.

   - Source IP address: `192.168.1.4`
   - Destination IP address: `192.168.100.7`

4. Azure Firewall undoes the SNAT and DNAT operations and delivers the response to the client.

   - Source IP address: `AzFwPIP`
   - Destination IP address: `ClientPIP`

## Application Gateway-only design

This design describes the scenario where only web applications exist in the virtual network, and inspecting outbound traffic with NSGs is sufficient to protect outbound flows to the internet.

 > [!NOTE]
 > We don't recommend this design because using Azure Firewall to control outbound flows, instead of relying solely on NSGs, helps prevent attack scenarios such as data exfiltration. With Azure Firewall, you can help ensure that your workloads only send data to an approved list of URLs. Also, NSGs operate only at layer 3 and layer 4 and don't support FQDNs.

The key difference from the previous Azure Firewall-only design is that Application Gateway doesn't serve as a routing device with NAT. Instead, it functions as a full reverse application proxy. This approach means that Application Gateway stops the web session from the client and establishes a separate session with one of its back-end servers. Inbound HTTP(S) connections from the internet are sent to the public IP address of Application Gateway, and connections from Azure or on-premises use the gateway's private IP address. Return traffic from the Azure VMs follows standard virtual network routing back to Application Gateway. For more information, see the packet walk later in this article. Outbound internet flows from Azure VMs go directly to the internet.

The following table summarizes traffic flows.

| Flow | Goes through Application Gateway/Web Application Firewall | Goes through Azure Firewall |
| ---- | :--: | :--: |
| HTTP(S) traffic from the internet or on-premises to Azure     | Yes | N/A |
| HTTP(S) traffic from Azure to the internet or on-premises     | No  | N/A |
| Non-HTTP(S) traffic from the internet or on-premises to Azure | No  | N/A |
| Non-HTTP(S) traffic from Azure to the internet or on-premises | No  | N/A |

### Architecture

The following packet walk example shows how a client accesses the VM-hosted application from the public internet.

![Diagram that shows an Application Gateway-only design.](./images/design2_500.png)

#### Workflow

1. The client starts the connection to the public IP address of Application Gateway.

   - Source IP address: `ClientPIP`
   - Destination IP address: `AppGwPIP`

2. The request to the Application Gateway public IP address is distributed to a back-end instance of the gateway, which is `192.168.200.7` in this example. The Application Gateway instance that receives the request stops the connection from the client and establishes a new connection with one of the back ends. The back end sees the Application Gateway instance as the source IP address. Application Gateway inserts an `X-Forwarded-For` HTTP header with the original client's IP address.

   - Source IP address, which is the private IP address of the Application Gateway instance: `192.168.200.7`
   - Destination IP address: `192.168.1.4`
   - `X-Forwarded-For` header: `ClientPIP`

3. The VM answers the application request and reverses both the source and destination IP addresses. The VM can reach Application Gateway, so it doesn't need a UDR.

   - Source IP address: `192.168.1.4`
   - Destination IP address: `192.168.200.7`

4. The Application Gateway instance answers the client.

   - Source IP address: `AppGwPIP`
   - Destination IP address: `ClientPIP`

Application Gateway adds metadata to the packet HTTP headers, such as the `X-Forwarded-For` header that contains the original client's IP address. Some application servers need the source client IP address to serve geolocation-specific content, or for logging. For more information, see [How an application gateway works][appgw-networking].

- In this example, the IP address `192.168.200.7` is one of the instances deployed by the Application Gateway service automatically. It has the internal, private front-end IP address `192.168.200.4`. These individual instances are normally invisible to the Azure administrator. But noticing the difference can be useful, such as when you troubleshoot network problems.

- The flow is similar if the client comes from an on-premises network over a VPN or ExpressRoute gateway. The difference is the client accesses the private IP address of Application Gateway instead of the public IP address.

> [!NOTE]
> For more information about the `X-Forwarded-For` header and how to preserve the host name on a request, see [Preserve the original HTTP host][preserve-http-host].

## Azure Firewall and Application Gateway in parallel design

Because of its simplicity and flexibility, it's often best to run Application Gateway and Azure Firewall in parallel.

Implement this design if there's both web and non-web workloads in the virtual network. Web Application Firewall in Application Gateway helps protect inbound traffic to the web workloads. Azure Firewall inspects inbound traffic for the other applications. Azure Firewall covers outbound flows from both workload types.

Inbound HTTP(S) connections from the internet should be sent to the public IP address of Application Gateway. HTTP(S) connections from Azure or on-premises should be sent to its private IP address. Standard virtual network routing sends the packets from Application Gateway to the destination VMs, and from the destination VMs back to Application Gateway. For more information, see the packet walk later in this article.

For inbound non-HTTP(S) connections, traffic should target the public IP address of Azure Firewall if it comes from the public internet. Traffic should be sent through Azure Firewall by UDRs if it comes from other Azure virtual networks or on-premises networks. All outbound flows from Azure VMs are forwarded to Azure Firewall by UDRs.

The following table summarizes the traffic flows for this scenario.

| Flow | Goes through Application Gateway/Web Application Firewall | Goes through Azure Firewall |
| ---- | :--: | :--: |
| HTTP(S) traffic from the internet or on-premises to Azure     | Yes | No |
| HTTP(S) traffic from Azure to the internet or on-premises     | No  | Yes |
| Non-HTTP(S) traffic from the internet or on-premises to Azure | No  | Yes |
| Non-HTTP(S) traffic from Azure to the internet or on-premises | No  | Yes |

This design provides much more granular egress filtering than solely using NSGs. For example, if applications need connectivity to a specific Azure Storage account, you can use FQDN-based filters. With FQDN-based filters, applications don't send data to rogue storage accounts. If you only use NSGs, you can't prevent this scenario. This design is often used when outbound traffic requires FQDN-based filtering. One scenario is when you [limit egress traffic from an AKS cluster][aks-egress].

### Architectures

The following diagram illustrates the traffic flow for inbound HTTP(S) connections from an outside client.

![Diagram that shows the ingress flow with Application Gateway and Azure Firewall in parallel.](./images/design3_ingress_500.png)

The following diagram illustrates the traffic flow for outbound connections from the network VMs to the internet. One example is to connect to back-end systems or get operating system updates.

![Diagram that shows the egress flow with Application Gateway and Azure Firewall in parallel.](./images/design3_egress_500.png)

The packet flow steps for each service are the same as in the previous standalone design options.

## Application Gateway in front of Azure Firewall design

This design is explained in more detail in [Zero-trust network for web applications with Azure Firewall and Application Gateway][azfw-appgw-zt]. This article focuses on the comparison with the other design options. In this topology, inbound web traffic goes through both Azure Firewall and Web Application Firewall. Web Application Firewall provides protection at the web application layer. Azure Firewall serves as a central logging and control point, and it inspects traffic between Application Gateway and the back-end servers. In this design, Application Gateway and Azure Firewall don't sit in parallel but sit one in front of the other.

With [Azure Firewall Premium][azfw-premium-features], this design can support end-to-end scenarios, where Azure Firewall applies TLS inspection to perform IDPS on the encrypted traffic between Application Gateway and the web back end.

This design is suited for applications that need to identify incoming client source IP addresses. For example, it can be used to serve geolocation-specific content or for logging. The Application Gateway in front of Azure Firewall design captures the incoming packet's source IP address in the `X-Forwarded-For` header, so the web server can see the original IP address in this header. For more information, see [How an application gateway works][appgw-networking].

Inbound HTTP(S) connections from the internet need to be sent to the public IP address of Application Gateway. HTTP(S) connections from Azure or on-premises should be sent to its private IP address. From Application Gateway, UDRs ensure that the packets are routed through Azure Firewall. For more information, see the packet walk later in this article. 

For inbound non-HTTP(S) connections, traffic should target the public IP address of Azure Firewall if it comes from the public internet. Traffic should be sent through Azure Firewall by UDRs if it comes from other Azure virtual networks or on-premises networks. All outbound flows from Azure VMs are forwarded to Azure Firewall by UDRs.

An important aspect of this design is that Azure Firewall Premium sees traffic with a source IP address from the Application Gateway subnet. If this subnet is configured with a private IP address (in `10.0.0.0/8`, `192.168.0.0/16`, `172.16.0.0/12`, or `100.64.0.0/10`), Azure Firewall Premium treats traffic from Application Gateway as internal and doesn't apply IDPS rules for inbound traffic. As a result, we recommend that you modify the IDPS private prefixes in the Azure Firewall policy. This modification ensures that the Application Gateway subnet isn't considered an internal source, which allows inbound and outbound IDPS signatures to be applied to the traffic. You can find more information about Azure Firewall IDPS rule directions and private IP prefixes for IDPS in [Azure Firewall IDPS rules][azfw-idps-rules]. 

The following table summarizes the traffic flows for this scenario.

| Flow | Goes through Application Gateway/Web Application Firewall | Goes through Azure Firewall |
| ---- | :--: | :--: |
| HTTP(S) traffic from the internet or on-premises to Azure     | Yes | Yes |
| HTTP(S) traffic from Azure to the internet or on-premises     | No  | Yes |
| Non-HTTP(S) traffic from the internet or on-premises to Azure | No  | Yes |
| Non-HTTP(S) traffic from Azure to the internet or on-premises | No  | Yes |

For web traffic from on-premises or from the internet to Azure, Azure Firewall inspects flows that Web Application Firewall allows. Depending on whether Application Gateway encrypts back-end traffic, which is traffic from Application Gateway to the application servers, different scenarios can occur:

- Application Gateway encrypts traffic by following zero-trust principles like [end-to-end TLS encryption](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption), and Azure Firewall receives encrypted traffic. Azure Firewall Standard can still apply inspection rules, such as layer 3 and layer 4 filtering in network rules, or FQDN filtering in application rules, by using the TLS Server Name Indication (SNI) header. [Azure Firewall Premium][azfw-premium-features] provides deeper visibility with TLS inspection, such as URL-based filtering.

- If Application Gateway sends unencrypted traffic to the application servers, Azure Firewall sees inbound traffic in clear text. TLS inspection isn't needed in Azure Firewall.

- If IDPS is enabled in Azure Firewall, it verifies that the HTTP Host header matches the destination IP address. To perform this verification, it needs the name resolution for the FQDN that's specified in the Host header. This name resolution can be performed by using Azure DNS private zones and the default [Azure Firewall DNS settings][azfw-dns]. It can also be achieved with custom DNS servers that need to be configured in the Azure Firewall settings. If you don't have administrative access to the virtual network where Azure Firewall is deployed, the latter method is your only option. One example is with Azure Firewall instances deployed in Azure Virtual WAN-secured hubs.

### Architecture

For the rest of the flows, which include inbound non-HTTP(S) traffic and any outbound traffic, Azure Firewall provides IDPS inspection and TLS inspection where suitable. It also provides [FQDN-based filtering in network rules][azfw-dns] based on DNS.

![Diagram that shows the Application Gateway in front of Azure Firewall design.](./images/design4_500.png)

#### Workflow

Network traffic from the public internet follows this flow:

1. The client starts the connection to the public IP address of Application Gateway.

   - Source IP address: `ClientPIP`
   - Destination IP address: `AppGwPIP`

2. The request to the Application Gateway public IP address is distributed to a back-end instance of the gateway, which is `192.168.200.7` in this example. The Application Gateway instance stops the connection from the client and establishes a new connection with one of the back ends. The UDR to `192.168.1.0/24` in the Application Gateway subnet forwards the packet to Azure Firewall and preserves the destination IP address to the web application.

   - Source IP address, which is the private IP address of the Application Gateway instance: `192.168.200.7`
   - Destination IP address: `192.168.1.4`
   - `X-Forwarded-For` header: `ClientPIP`

3. Azure Firewall doesn't apply SNAT to the traffic because the traffic goes to a private IP address. It forwards the traffic to the application VM if rules allow it. For more information, see [Azure Firewall SNAT private IP address ranges][azfw-snat]. However, if the traffic hits an application rule in the firewall, the workload sees the source IP address of the specific firewall instance that processed the packet because Azure Firewall proxies the connection.

   - Source IP address if the traffic is allowed by an Azure Firewall network rule and is the private IP address of one of the Application Gateway instances: `192.168.200.7`
   - Source IP address if the traffic is allowed by an Azure Firewall application rule and is the private IP address of one of the Azure Firewall instances: `192.168.100.7`
   - Destination IP address: `192.168.1.4`
   - `X-Forwarded-For` header: `ClientPIP`

4. The VM answers the request, which reverses both the source and destination IP addresses. The UDR to `192.168.200.0/24` captures the packet sent back to Application Gateway, redirects it to Azure Firewall, and preserves the destination IP address toward Application Gateway.

   - Source IP address: `192.168.1.4`
   - Destination IP address: `192.168.200.7`

5. Again, Azure Firewall doesn't apply SNAT to the traffic because it goes to a private IP address and forwards the traffic to Application Gateway.

   - Source IP address: `192.168.1.4`
   - Destination IP address: `192.168.200.7`

6. The Application Gateway instance answers the client.

   - Source IP address: `AppGwPIP`
   - Destination IP address: `ClientPIP`

Outbound flows from the VMs to the public internet go through Azure Firewall, which the UDR to `0.0.0.0/0` defines.

As a variation of this design, you can configure private DNAT in Azure Firewall so that the application workload sees the IP addresses of the Azure Firewall instances as the source, and no UDRs are required. The source IP address of the application clients is already preserved in the `X-Forwarded-For` HTTP header by Application Gateway. So if Azure Firewall applies DNAT to the traffic, no information is lost. For more information, see [Filter inbound internet or intranet traffic with Azure Firewall policy DNAT by using the Azure portal][azfw-dnat].

## Azure Firewall in front of Application Gateway design

This design lets Azure Firewall filter and discard malicious traffic before it reaches Application Gateway. For example, it can apply features like threat intelligence-based filtering. Another benefit is that the application gets the same public IP address for both inbound and outbound traffic, regardless of protocol. There are three modes in which you can theoretically configure Azure Firewall:

- **Azure Firewall with DNAT rules:** Azure Firewall only swaps IP addresses at the IP address layer, but it doesn't process the payload. As a result, it doesn't change any of the HTTP headers.

- **Azure Firewall with application rules and TLS inspection disabled:** Azure Firewall can look at the SNI header in TLS, but it doesn't decrypt it. A new TCP connection is created from the firewall to the next hop. In this example, it's Application Gateway.

- **Azure Firewall with application rules and TLS inspection enabled:** Azure Firewall looks into the packet contents and decrypts them. It serves as an HTTP proxy and can set the HTTP headers `X-Forwarded-For` to preserve the IP address. However, it presents a self-generated certificate to the client. For internet-based applications, using a self-generated certificate isn't an option because a security warning is sent to the application clients from their browser.

In the first two options, which are the only valid options for internet-based applications, Azure Firewall applies SNAT to the incoming traffic without setting the `X-Forwarded-For` header. As a result, the application can't see the original IP address of the HTTP requests. For administrative tasks, like troubleshooting, you can obtain the actual client IP address for a specific connection by correlating it with the SNAT logs of Azure Firewall.

The benefits of this scenario are limited because, unless you use TLS inspection and present self-generated certificates to the clients, Azure Firewall only sees encrypted traffic that goes to Application Gateway. This scenario is typically only possible for internal applications. However, there might be scenarios where this design is preferred. One scenario is if another Web Application Firewall exists earlier in the network (for example, with [Azure Front Door][afd-overview]), which can capture the original source IP in the `X-Forwarded-For` HTTP header. You might also prefer this design if many public IP addresses are required because Application Gateway supports a single IP address.

HTTP(S) inbound flows from the public internet should target the public IP address of Azure Firewall. Azure Firewall will DNAT and SNAT the packets to the private IP address of Application Gateway. From other Azure virtual networks or on-premises networks, HTTP(S) traffic should be sent to the Application Gateway private IP address and forwarded through Azure Firewall with UDRs. Standard virtual network routing ensures that return traffic from the Azure VMs goes back to Application Gateway and from Application Gateway to Azure Firewall if DNAT rules were used. For traffic from on-premises or Azure, use UDRs in the Application Gateway subnet. For more information, see the packet walk later in this article. All outbound traffic from the Azure VMs to the internet is sent through Azure Firewall by UDRs.

The following table summarizes the traffic flows for this scenario.

| Flow | Goes through Application Gateway/Web Application Firewall | Goes through Azure Firewall |
| ---- | :--: | :--: |
| HTTP(S) traffic from the internet or on-premises to Azure     | Yes | Yes  |
| HTTP(S) traffic from Azure to the internet or on-premises     | No  | Yes |
| Non-HTTP(S) traffic from the internet or on-premises to Azure | No  | Yes |
| Non-HTTP(S) traffic from Azure to the internet or on-premises | No  | Yes |

For inbound HTTP(S) traffic, Azure Firewall doesn't typically decrypt traffic. It instead applies IDPS policies that don't require TLS inspection, like IP address-based filtering or using HTTP headers.

### Architecture

The application can't see the original source IP address of the web traffic. Azure Firewall applies SNAT to the packets as they come in to the virtual network. To avoid this problem, use [Azure Front Door][afd-overview] in front of the firewall. Azure Front Door injects the client's IP address as an HTTP header before it enters the Azure virtual network.

![Diagram that shows Application Gateway after Azure Firewall.](./images/design5_500.png)

#### Workflow

Network traffic from the public internet follows this flow:

1. The client starts the connection to the public IP address of Azure Firewall.

   - Source IP address: `ClientPIP`
   - Destination IP address: `AzFWPIP`

2. The request to the Azure Firewall public IP address is distributed to a back-end instance of the firewall, which is `192.168.100.7` in this example. Azure Firewall applies DNAT to the web port, usually TCP 443, to the private IP address of the Application Gateway instance. Azure Firewall also applies SNAT when you perform DNAT. For more information, see [Azure Firewall known issues][azfw-known-issues].

   - Source IP address, which is the private IP address of the Azure Firewall instance: `192.168.100.7`
   - Destination IP address: `192.168.200.4`

3. Application Gateway establishes a new session between the instance that handles the connection and one of the back-end servers. The original IP address of the client isn't in the packet.

   - Source IP address, which is the private IP address of the Application Gateway instance: `192.168.200.7`
   - Destination IP address: `192.168.1.4`
   - `X-Forwarded-For` header: `192.168.100.7`

4. The VM answers Application Gateway, which reverses both the source and destination IP addresses:

   - Source IP address: `192.168.1.4`
   - Destination IP address: `192.168.200.7`

5. Application Gateway replies to the SNAT source IP address of the Azure Firewall instance. Azure Firewall sees the internal IP address of Application Gateway, `.4`, as the source IP address, even if the connection comes from a specific Application Gateway instance like `.7`.
   - Source IP address: `192.168.200.4`
   - Destination IP address: `192.168.100.7`

6. Azure Firewall undoes SNAT and DNAT and answers the client.

   - Source IP address: `AzFwPIP`
   - Destination IP address: `ClientPIP`

Application Gateway needs a public IP address so that Microsoft can manage it, even if it has no listeners configured for applications.

> [!NOTE]
> A default route to `0.0.0.0/0` in the Application Gateway subnet that points to Azure Firewall isn't supported because it breaks the control plane traffic that Application Gateway requires to function properly.

## On-premises clients

The preceding designs all show incoming application clients from the public internet. On-premises networks also access applications. Most of the previous information and traffic flows are the same as for internet clients, but there are some notable differences:

- A VPN gateway or ExpressRoute gateway sits in front of Azure Firewall or Application Gateway.

- Web Application Firewall uses the private IP address of Application Gateway.

- Azure Firewall doesn't support DNAT for private IP addresses, so you must use UDRs to send inbound traffic to Azure Firewall from the VPN or ExpressRoute gateways.

- Make sure to verify caveats around *forced tunneling* for [Application Gateway][appgw-defaultroute] and for [Azure Firewall][azfw-defaultroute]. Even if your workload doesn't need outbound connectivity to the public internet, you can't inject a default route like `0.0.0.0/0` for Application Gateway that points to the on-premises network because it breaks control traffic. For Application Gateway, the default route needs to point to the public internet.

### Architecture

The following diagram shows the Application Gateway and Azure Firewall parallel design. Application clients come from an on-premises network that's connected to Azure over VPN or ExpressRoute:

![Diagram that shows a hybrid design with a VPN or an ExpressRoute gateway.](./images/hybrid_500.png)

Even if all clients are located on-premises or in Azure, Application Gateway and Azure Firewall both need to have public IP addresses. These public IP addresses allow Microsoft to manage the services.

## Hub-and-spoke topology

The designs in this article apply to a *hub-and-spoke* topology. Shared resources in a central hub virtual network connect to applications in separate spoke virtual networks through virtual network peerings.

### Architecture

![Diagram that shows a hybrid design with a VPN and Expressroute gateway and a hub-and-spoke topology.](./images/hubnspoke_500.png)

- Azure Firewall is deployed in the central hub virtual network. The previous diagram shows how to deploy Application Gateway in the hub. Application teams often manage components such as Application Gateways or API Management gateways. In this scenario, these components are deployed in the spoke virtual networks.

- Pay special attention to UDRs in the spoke networks. When an application server in a spoke receives traffic from a specific Azure Firewall instance, like the `192.168.100.7` IP address in the previous examples, it should send return traffic back to the same instance. If a UDR in the spoke sets the next hop of traffic addressed to the hub to the Azure Firewall IP address (`192.168.100.4` in the previous diagrams), return packets might end up on a different Azure Firewall instance. This situation causes asymmetric routing. If you have UDRs in the spoke virtual networks, make sure to send traffic to shared services in the hub through Azure Firewall. These UDRs don't include the prefix of the Azure Firewall subnet.

- The previous recommendation applies equally to the Application Gateway subnet and any other NVAs or reverse proxies that might be deployed in the hub virtual network.

- You can't set the next hop for the Application Gateway or Azure Firewall subnets through static routes with a next hop type of `Virtual Network`. This next hop type is only valid in the local virtual network and not across virtual network peerings. For more information about UDRs and next hop types, see [Virtual network traffic routing][udr].

### Asymmetric routing

The following diagram shows how a spoke sends SNAT traffic back to the Azure load balancer of Azure Firewall. This setup causes asymmetric routing.

![Diagram that shows asymmetric routing in a hub-and-spoke topology.](./images/asymmetric_routing.png)

To solve this problem, define UDRs in the spoke without the Azure Firewall subnet and with only the subnets where the shared services are located. In the previous diagram, the correct UDR in the spoke should only contain `192.168.1.0/24`. It shouldn't contain the entire range `192.168.0.0/16`, which is marked in red.

## Integration with other Azure products

You can integrate Azure Firewall and Application Gateway with other Azure products and services.

### API Management Gateway

Integrate reverse proxy services like [API Management][api-management] gateway into the previous designs to provide functionality like API throttling or authentication proxy. API Management gateway integration doesn't significantly affect the designs. The key difference is that instead of the single Application Gateway reverse proxy, there are two reverse proxies chained behind each other.

For more information, see the [design guide to integrate API Management and Application Gateway in a virtual network][appgw-apim] and the application pattern [API gateways for microservices][app-gws].

### AKS

For workloads that run on an AKS cluster, you can deploy Application Gateway independently of the cluster. Or you can integrate it with the AKS cluster by using [Application Gateway for Containers][agc_overview]. When you configure specific objects at the Kubernetes levels, such as services and ingresses, Application Gateway automatically adapts without needing extra manual steps.

Azure Firewall plays an important role in AKS cluster security. It provides the required functionality to filter egress traffic from the AKS cluster based on FQDN, not only the IP address. For more information, see [Limit network traffic with Azure Firewall in AKS][aks-egress].

When you combine Application Gateway and Azure Firewall to protect an AKS cluster, it's best to use the parallel design option. Application Gateway with Web Application Firewall processes inbound connection requests to web applications in the cluster. Azure Firewall permits only explicitly allowed outbound connections. For more information about the parallel design option, see [Baseline architecture for an AKS cluster][aks-secure-baseline].

### Azure Front Door

[Azure Front Door][frontdoor] has functionality that overlaps with Application Gateway in several areas. Both services provide web application firewalling, SSL offloading, and URL-based routing. However, a key difference is that while Application Gateway operates within a virtual network, Azure Front Door is a global, decentralized service.

You can sometimes simplify virtual network design by replacing Application Gateway with a decentralized Azure Front Door. Most designs described in this article still apply, except for the option to place Azure Firewall in front of Azure Front Door.

One scenario is to use Azure Firewall in front of Application Gateway in your virtual network. Application Gateway injects the `X-Forwarded-For` header with the firewall instance's IP address, not the client's IP address. A workaround is to use Azure Front Door in front of the firewall to inject the client's IP address as a `X-Forwarded-For` header before the traffic enters the virtual network and reaches Azure Firewall. You can also [secure your origin with Azure Private Link in Azure Front Door Premium][azure-front-door-private-link].

For more information about the differences between the two services, or when to use each one, see [Frequently asked questions for Azure Front Door][afd-vs-appgw].

## Other NVAs

Microsoft products aren't the only choice to implement web application firewall or next-generation firewall functionality in Azure. A wide range of Microsoft partners provide NVAs. The concepts and designs are essentially the same as in this article, but there are some important considerations:

- Partner NVAs for next-generation firewalling might provide more control and flexibility for NAT configurations that Azure Firewall doesn't support. Examples include DNAT from on-premises or DNAT from the internet without SNAT.

- Azure-managed NVAs like Application Gateway and Azure Firewall reduce complexity, compared to NVAs where users need to handle scalability and resiliency across many appliances.

- When you use NVAs in Azure, use *active-active* and *autoscaling* setups so that these appliances aren't a bottleneck for applications that run in the virtual network.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Jose Moreno](https://de.linkedin.com/in/erjosito) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about the component technologies:

- [What is Application Gateway?](/azure/application-gateway/overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [AKS](/azure/aks/intro-kubernetes)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Web Application Firewall?](/azure/web-application-firewall/overview)
- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)

## Related resources

Explore related architectures:

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Securely managed web applications](../apps/fully-managed-secure-apps.yml)
- [High availability enterprise deployment by using App Service Environment](../../web-apps/app-service-environment/architectures/app-service-environment-high-availability-deployment.yml)
- [Enterprise deployment by using App Service Environment](../../web-apps/app-service-environment/architectures/app-service-environment-standard-deployment.yml)

[afd-overview]: /azure/frontdoor/front-door-overview  
[afd-vs-appgw]: /azure/frontdoor/front-door-faq#what-is-the-difference-between-azure-front-door-and-azure-application-gateway  
[agc_overview]: /azure/application-gateway/for-containers/overview  
[aks-egress]: /azure/aks/limit-egress-traffic  
[aks-secure-baseline]: /azure/architecture/reference-architectures/containers/aks/secure-baseline-aks  
[api-management]: https://azure.microsoft.com/services/api-management/  
[api-management-overview]: /azure/api-management/api-management-key-concepts  
[app-gws]: https://microservices.io/patterns/apigateway.html  
[appgw-apim]: /azure/api-management/api-management-howto-integrate-internal-vnet-appgateway  
[appgw-defaultroute]: /azure/application-gateway/configuration-overview#azure-virtual-network-and-dedicated-subnet  
[appgw-docs]: /azure/application-gateway/  
[appgw-networking]: /azure/application-gateway/how-application-gateway-works  
[appgw-overview]: /azure/application-gateway/overview  
[azfw-appgw-zt]: /azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall  
[azfw-defaultroute]: /azure/firewall/forced-tunneling  
[azfw-dnat]: /azure/firewall/tutorial-firewall-dnat-policy  
[azfw-dns]: /azure/firewall/fqdn-filtering-network-rules  
[azfw-docs]: /azure/firewall/  
[azfw-endpoint]: /azure/private-link/inspect-traffic-with-azure-firewall  
[azfw-idps-rules]: /azure/firewall/premium-features#idps-signature-rules  
[azfw-overview]: /azure/firewall/overview  
[azfw-premium-features]: /azure/firewall/premium-features  
[azfw-known-issues]: /azure/firewall/overview#known-issues  
[azfw-snat]: /azure/firewall/snat-private-range  
[azure-front-door-private-link]: /azure/frontdoor/private-link  
[azure-virtual-network]: https://azure.microsoft.com/services/virtual-network/  
[expressroute]: https://azure.microsoft.com/services/expressroute/  
[frontdoor]: https://azure.microsoft.com/services/frontdoor/  
[nat]: /azure/virtual-network/nat-overview  
[nsgs]: /azure/virtual-network/security-overview  
[preserve-http-host]: /azure/architecture/best-practices/host-name-preservation  
[udr]: /azure/virtual-network/virtual-networks-udr-overview  
[waf-docs]: /azure/web-application-firewall/  
[web-application-firewall]: https://azure.microsoft.com/services/web-application-firewall/  
