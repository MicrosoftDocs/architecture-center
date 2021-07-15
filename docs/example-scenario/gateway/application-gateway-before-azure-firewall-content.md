Application security should be tackled in a multi-layered approach. One of those layers is networking security, where network appliances can inspect network packets to make sure that only legitimate traffic reaches your application.

Different network appliances typically specialize in different aspects of the network packet: while Web Application Firewalls are looking for patterns that would indicate an attack at the web application layer, next-generation firewalls usually focus on more generic threats, not restricted to web applications. In some situations you may want to combine multiple types of network security appliances for maximum protection. When combining two or more network appliances there are different patterns that can be used. Some of these patterns are explored in [Firewall and Application Gateway for virtual networks][appgw_azfw]. This document will double down on one of the most common approaches for maximum security, the one where Azure Application Gateway is deployed before Azure Firewall:

![Overall diagram](./images/application-gateway-before-azure-firewall-architecture.png)

This architecture uses SSL to encrypt traffic at every step.

1. A client sends packets to Azure Application Gateway, which has (the) Web Firewall (feature) turned on.

1. Application Gateway decrypts the packets and searches for threats to web applications. If Application Gateway doesn't find any threats, it encrypts the packets and sends them to Azure Firewall.

1. Azure Firewall runs security checks:

   - [TLS inspection][azfw_tls] decrypts and examines the traffic.
   - [Intrusion detection and protection][azfw_idps] features check the packets for malicious intent.

   If the packets pass the tests, Azure Firewall takes these steps:

   - Encrypts the packets
   - If needed, uses a DNS server to determine the application VM
   - Forwards the packets to the application VM

Multiple inspection engines in this architecture ensure traffic integrity:

- Web Application Firewall uses rules to prevent attacks at the web layer. Examples of attacks include SQL code injection and cross-site scripting. For more information on rules and the Open Web Application Security Project (OWASP) Core Rule Set, see [Web Application Firewall CRS rule groups and rules][appgw_crs].
- Azure Firewall uses generic intrusion detection and prevention rules. Among other threats, these rules help identify malicious files that target web applications.

## Azure Firewall Premium and name resolution

When checking for malicious traffic, Azure Firewall Premium verifies that the HTTP Host header matches the packet IP address and TCP port. For example, suppose Application Gateway sends web packets to the IP address 172.16.1.4 and TCP port 443. The value of the HTTP Host header should resolve to that IP address.

HTTP Host headers don't typically contain IP addresses. Instead, the headers contain names that match the server's digital certificate. As a result, Azure Firewall Premium uses Domain Name Service (DNS) to resolve the Host header name to an IP address:

- In a traditional hub and spoke architecture, DNS private zones provide an easy way to use DNS:

  - Configure a DNS private zone.
  - Link the zone to the virtual network that contains Azure Firewall Premium.
  - Make sure that an A record exists for the value that Azure Application Gateway uses for traffic and for health checks.

- In a virtual WAN secured hub, you can't associate a DNS private zone with the secure hub that contains the Azure Firewall. Instead, take these steps:

  - Configure the [Azure Firewall DNS Settings][azfw_dns] to use custom DNS servers.
  - Deploy the DNS servers in a shared services virtual network that you connect to the virtual WAN.

  You can link a DNS private zone to the shared services virtual network. Then the DNS servers can resolve the name that Application Gateway uses in the HTTP host header.

> [!NOTE]
> Azure Application Gateway doesn't support port numbers in HTTP Host headers. As a result, Azure Firewall assumes a default HTTPS TCP Port of 443. The connection between Azure Application Gateway and the web server then only supports TCP port 443, not non-standard ports.

## Digital Certificates

This architecture contains three distinct SSL connections. Digital certificates validate each one:

- From clients to Azure Application Gateway: In Azure Application Gateway, deploy the digital certificate that clients see. A well-known certificate authority (CA) such as DigiCert or Let's Encrypt typically issues such a certificate.
- From Azure Application Gateway to Azure Firewall: In order to decrypt and inspect TLS traffic, Azure Firewall Premium dynamically generates certificates and presents itself to Application Gateway as the web server. A private CA signs the certificates that Azure Firewall Premium generates, as [Azure Firewall Premium certificates][azfw_certs] describes. Azure Application Gateway needs to validate those certificates. So configure the root CA that Azure Firewall uses in the application's HTTP settings.
- From Azure Firewall to web server: Azure Firewall will finally establish the last SSL session to the destination web server. As part of the verifications performed by Azure Firewall premium, it will verify that the Web Server SSL packets are signed by a well-known Certificate Authority.

The following diagram shows the different SSL sessions and certificates at play:

![SSL sessions](./images/application-gateway-before-azure-firewall-certificates.png)

The main reason why Azure Application Gateway and Azure Firewall behave differently regarding certificates is because they have slightly different functionalities:

- Azure Application Gateway is a **reverse web proxy**. That means that it provides protection to web servers from malicious clients, by intercepting HTTP(S) requests from any client to the protected servers. The protected servers are declared in the backend pool of the Application Gateway with their IP address or fully qualified domain name. Since any legitimate client should be able to access the application, the Application Gateway should be configured with a digital certificate signed by a public certificate authority, that any SSL client will accept.
- Azure Firewall is a **forward web proxy**, sometimes called simply a web proxy. Its purpose is protecting clients from malicious web servers, by intercepting SSL calls from the protected clients to any web server. When the protected clients make an HTTP request, the forward proxy will impersonate the target web server, generating digital certificates on the fly and presenting those to the client. The dynamically generated certificates will be signed by a private certificate authority installed in the Azure Firewall Premium, that the protected client needs to be configured to trust. In the scenario described in this article, Azure Firewall Premium is configured to protect requests from the Application Gateway to the Web Server, hence the Application Gateway needs to trust the Certificate Authority installed in the Azure Firewall.

## Example design with Hub and Spoke network

In hub and spoke design, shared network components are typically deployed in the hub VNet, while application-specific components are located in the spokes. While it is pretty common considering the Azure Firewall as a shared resource, it is not so obvious whether Web Application Firewalls are similarly shared network devices, or on the contrary application-specific components. The overall recommendation is treating Azure Application Gateway as an application device, and hence deploy it in a spoke VNet, out of these reasons:

- Troubleshooting Web Application Firewall alerts typically requires in-depth knowledge of the application in order to decide whether the messages triggering those alarms are legitimate or not.
- Treating the Azure Application Gateway as a shared resource could lead to exhausting some of the [Azure Application Gateway Limits][appgw_limits]
- Having applications managed by different teams leveraging the same Azure Application Gateway might create some Role-Based Access Control challenges, since each of those developer teams would have access to the whole configuration of the Azure Application Gateway

The following diagram describes the connection flow for a connection coming from the public Internet, with the Azure Application Gateway deployed into a spoke Virtual Network:

![Hub And Spoke internal traffic](./images/appgwB4azfw_hns_external.png)

1. A client connects to the public IP address of Azure Application Gateway, which has (the) Web Firewall (feature) turned on.

1. Application Gateway decrypts the client packets and searches for web-application threats. If Application Gateway doesn't find any threats, it takes these steps:

   - Connects with one of the back end servers
   - Encrypts the packets
   - Forwards the client request to Azure Firewall

1. Azure Firewall runs security checks:

   - [TLS inspection][azfw_tls] decrypts and examines the traffic.
   - [Intrusion detection and protection][azfw_idps] features check the packets for malicious intent.

   If the packets pass the tests, Azure Firewall encrypts the packets and forwards them to the application VM.

1. The VM answers the request by sending a packet to Application Gateway. The Application Gateway subnet redirects the packet to Azure Firewall.

1. Azure Firewall forwards the traffic to Application Gateway.

1. Application Gateway answers the client.

If traffic is not coming from the public Internet but from an on-premises network (via Site-to-Site VPN or ExpressRoute), it will arrive at a Virtual Network Gateway in the hub first. The rest of the network flow is the same as in the previous case:

![Hub And Spoke internal traffic](./images/appgwB4azfw_hns_internal.png)

## Example design with Virtual WAN

[Virtual WAN][vwan_overview] can be a very interesting component in the architecture, since amongst other benefits, it will eliminate the need for user-maintained user-defined routes in the spoke Virtual Networks. Instead, the administrator can define static routes in the virtual hub route tables, and these routes will be programmed in every VNet connected to the virtual hub. There are two main differences when leveraging Virtual WAN as networking platform:

- Firstly, DNS private zones cannot be linked to the virtual hub since the virtual hub is a Microsoft-managed Virtual Network and the subscription owner does not have privilege to link private DNS zones. Instead, DNS resolution for the Azure Firewall can be implemented with DNS forwarders deployed in a Shared Services VNet (see [Azure Firewall DNS settings][azfw_dns]).
- Secondly, Virtual WAN is not able to program routes in the spoke for prefix with same or longer length than the VNet prefix. That means that if the Application Gateway and the destination web server are in the same Virtual Network, Virtual WAN will not be able to inject a route that overrides the system route for the VNet, and hence traffic between the Application Gateway and the web server will bypass the Azure Firewall.

The following diagram reflects the packet flow for accessing the Azure Application Gateway from an on-premises network connected to Virtual WAN via Site-to-Site VPN or ExpressRoute, access from the Internet would be similar:

![Virtual WAN internal traffic](./images/appgwB4azfw_vwan_internal.png)

One aspect to consider in this design is that the routing advertised by the hub to the spoke Virtual Networks might have to be modified for certain services. More concretely, the Azure Application Gateway v2 does not support a 0.0.0.0/0 route pointing to anything other than the Internet, since that breaks the connectivity required by Microsoft to manage the Application Gateway. In case you are advertising a 0.0.0.0/0 route from the virtual hub, there are two ways to prevent that route from being inserted in the Application Gateway subnet:

- You can create a route table with a route for 0.0.0.0/0 and next hop Internet, and associate it to the subnet where the Application Gateway is deployed
- If the Application Gateway is deployed in a dedicated spoke, you can disable the propagation of the default route in the settings for the VNet connection

## Example design with Azure Route Server

Finally, the [Azure Route Server][ars_overview] offers another possibility to inject routes automatically in the spoke, to avoid the administrative overhead of maintaining route tables. Its design is a combination of the hub and spoke and Virtual WAN variants:

- The hub Virtual Network is customer-managed, so the subscription admin can do operations such as linking the hub VNet to DNS private zones.
- Azure Route Server has the same limitation as Virtual WAN around injecting prefixes with the same or longer length than the Virtual Network prefix in the spokes. Hence, the Application Gateway and the destination web server needs to be in different Virtual Networks.
- Whether DNS is required or not will depend on the functionality of the Network Virtual Appliance (NVA) in the hub. In the following diagram the DNS step is depicted, but note that this might vary depending on the NVA.

One remark to this design is that the Azure Route Server requires today that the device injecting the routes sends them over Border Gateway Protocol (BGP). Since the Azure Firewall does not support BGP, this design would require a third-party Network Virtual Appliance (NVA):

![Route Server internal traffic](./images/appgwB4azfw_ars_internal.png)

Note that the design with the Route Server might advertise the 0.0.0.0/0 route to the Application Gateway subnet too, which is not supported. In this case, the only solution is configuring a route table for the Application Gateway subnet with a route for 0.0.0.0/0 and next hop Internet.

## Conclusion

By having different appliances such as a Web Application Firewall and a Next-Generation Firewall you can get multi-layer network protection by implementing multiple security checks on your web traffic.

[appgw_azfw]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/gateway/firewall-application-gateway
[azfw_dns]: https://docs.microsoft.com/azure/firewall/dns-settings
[azfw_certs]: https://docs.microsoft.com/azure/firewall/premium-certificates
[appgw_limits]: https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits
[azfw_limits]: https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits
[azfw_tls]: https://docs.microsoft.com/azure/firewall/premium-features#tls-inspection
[azfw_idps]: https://docs.microsoft.com/azure/firewall/premium-features#idps
[appgw_crs]: https://docs.microsoft.com/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules
[vwan_overview]: https://docs.microsoft.com/azure/virtual-wan/virtual-wan-about
[ars_overview]: https://docs.microsoft.com/azure/route-server/overview