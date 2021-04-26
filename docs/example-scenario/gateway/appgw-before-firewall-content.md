Application security should be tackled in a multi-layered approach. One of those layers is networking security, where network appliances can inspect network packets to make sure that only legitimate traffic reaches your application.

Different network appliances typically specialize in different aspects of the network packet: while Web Application Firewalls are looking for patterns that would indicate an attack at the web application layer, next-generation firewalls usually focus on more generic threats, not restricted to web applications. In some situations you may want to combine multiple types of network security appliances for maximum protection. When combining two or more network appliances there are different patterns that can be used. Some of these patterns are explored in [Firewall and Application Gateway for virtual networks][AppGWAzFW]. This document will double down on one of the most common approaches for maximum security, the one where Azure Application Gateway is deployed before Azure Firewall:

![Overall diagram](./images/appgwB4azfw_flow.png)

In this design, traffic is encrypted with SSL at all times. The packets sent from the client encrypted with SSL will arrive first at the Azure Application Gateway with Web Firewall functionality enabled. It will decrypt the packets and inspect them searching for web application threats. Should the session be allowed, it will be encrypted again and sent over the Azure Firewall. The Azure Firewall will apply its own security checks, and if successful, it will finally forward the packets to their final destination in the Virtual Network (in the diagram represented as a Virtual Machine).

## Azure Firewall Premium and name resolution

The Azure Firewall Premium will use its Intrusion Detection and Prevention inspection capabilities to verify that the traffic is not malicious. One of the verifications it performs is making sure that the value of the HTTP Host header matches the packets IP address and TCP port destination. For example, if the Application Gateway sends web packets addressed to the IP 172.16.1.4 and TCP port 443, the value of the HTTP Host header should resolve to that very same IP.

HTTP Host headers typically do not contain IP addresses but names, since they need to match with the digital certificate installed in the server. As a consequence, Azure Firewall Premium needs to be able to resolve the name of the Host header to an IP address via DNS (Domain Name Service):

- If using a traditional hub and spoke architecture, the easiest way to do this is configuring a DNS private zone linked to the Virtual Network where the Azure Firewall Premium is deployed, and making sure that an A record exists for the value that the Azure Application Gateway uses both for the health checks and for the real traffic.
- If using Virtual WAN secured hubs, you cannot associate a DNS private zone to the secure hub where the Azure Firewall is deployed. As a consequence, you need to configure the Azure Firewall to use custom DNS servers that you would deploy in a Shared Services Virtual Network connected to Virtual WAN. You could then associate a DNS private zone to that Shared Services VNet, so that the DNS servers are able to resolve the name that the Application Gateway uses in the HTTP Host header.

> [!NOTE]
> Since the Azure Application Gateway does not support including a port number in the HTTP Host header, the Azure Firewall will always assume the default HTTPS TCP Port (443). Hence, non-standard TCP ports other than 443 are not supported in the connection between the Azure Application Gateway and the web server.

## Digital Certificates

As the previous diagram shows, there are three distinct SSL connections, each validated by digital certificates:

- From client to Azure Application Gateway: You need to deploy the digital certificate that the client will see in the Azure Application Gateway. This will typically be a certificate issued by a well-known Certificate Authority such as DigiCert or Let's Encrypt.
- From Azure Application Gateway to Azure Firewall: In order to decrypt and inspect TLS traffic, Azure Firewall Premium dynamically generates certificates and presents itself to the Application Gateway as being the web server. In order to do that, it will leverage a private Certificate Authority that it will use to sign the certificates it generates, as described in [Azure Firewall Premium certificates][azfw_certs]. The Azure Application Gateway needs to validate those certificates, so it needs to have Azure Firewall's Root CA configured in the HTTP Settings for the application.
- From Azure Firewall to web server: Azure Firewall will finally establish the last SSL session to the destination web server. As part of the verifications performed by Azure Firewall premium, it will verify that the Web Server SSL packets are signed by a well-known Certificate Authority.

The following diagram shows the different SSL sessions and certificates at play:

![SSL sessions](./images/appgwB4azfw_certs.png)

## Sample design with Hub and Spoke network

In hub and spoke design, shared network components are typically deployed in the hub VNet, while application-specific components are located in the spokes. While it is pretty common considering the Azure Firewall as a shared resource, it is not so obvious whether Web Application Firewalls are similarly shared network devices, or on the contrary application-specific components. The overall recommendation is treating Azure Application Gateway as an application device, and hence deploy it in a spoke VNet, out of these reasons:

- Troubleshooting Web Application Firewall alerts typically requires in-depth knowledge of the application in order to decide whether the messages triggering those alarms are legitimate or not.
- Treating the Azure Application Gateway as a shared resource could lead to exhausting some of its maximum limits

## Sample design with Virtual WAN

The main difference is that DNS private zones cannot be linked to the virtual hub, since the virtual hub is a Microsoft-managed Virtual Network. Instead, DNS resolution for the Azure Firewall can be implemented with DNS forwarders deployed in a Shared Services VNet:


AppGWAzFW: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/gateway/firewall-application-gateway
azfw_dns: https://docs.microsoft.com/azure/firewall/dns-settings
azfw_certs: https://docs.microsoft.com/azure/firewall/premium-certificates
appgw_limits: https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits
azfw_limits: https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits