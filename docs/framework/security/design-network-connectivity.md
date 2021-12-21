---
title: Services for securing network connectivity
description: Learn about best practices for securing access to the internet, Azure platform as a service (PaaS) services, and on-premises networks.
author: PageWriter-MSFT
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
azureCategories:
  - hybrid
  - networking
  - security
products:
  - azure-firewall
  - azure-virtual-network
ms.custom:
  - article
---

# Azure services for securing network connectivity

It's often the case that the workload and the supporting components of a cloud architecture will need to access external assets. These assets can be on-premises, devices outside the main virtual network, or other Azure resources. Those connections can be over the internet or networks within the organization.

## Key points

- Protect non-public accessible services with network restrictions and IP firewall.
- Use Network Security Groups (NSGs) or Azure Firewall to protect and control traffic within the VNet.
- Use Service Endpoints or Private Link for accessing Azure PaaS services.
- Use Azure Firewall to protect against data exfiltration attacks.
- Restrict access to backend services to a minimal set of public IP addresses, only those services that really need it.
- Use Azure controls over third-party solutions for basic security needs. They're easy to configure and scale.
- Define access policies based on the type of workload and control flow between the different application tiers.

## Connectivity between network segments

When designing a workload, you'll typically start by provisioning an Azure Virtual Network (VNet) in a private address space which has the  workload. No traffic is allowed by default between any two virtual networks. If there's a need, define the communication paths explicitly. One way of connecting VNets is through [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

A key aspect is protecting the VMs in the VNet. The network interfaces on the VMs allow them to communicate with other VMs, the internet, and on-premises networks. To control traffic on VMs within a VNet (and subnet), use [Application Security Groups (ASGs)](/azure/virtual-network/application-security-groups). You can group a set of VMs under an application tag and define traffic rules. Those rules are then applied to each of the underlying VMs.

A VNet is segmented into subnets based on business requirements. Provide proper network security controls that allow or deny inbound network traffic to, or outbound network traffic from, within larger network space.

You can also provision VMs with private IP addresses for protection. Take advantage of the Azure IP address to determine incoming traffic, how and where it's translated on to the virtual network.

A good Azure IP addressing schema provides flexibility, room for growth, and integration with on-premises networks. The schema ensures that communication works for deployed resources, minimizes public exposure of systems, and gives the organization flexibility in its network. If not properly designed, systems might not be able to communicate, and additional work will be required to remediate.

**How do you isolate and protect traffic within the workload VNet?**
***
To secure communication within a VNet, set rules that inspect traffic. Then, *allow* or *deny* traffic to, or from specific sources, and route them to the specified destinations.
> ![Task](../../_images/i-best-practices.svg) Review the rule set and confirm that the required services are not unintentionally blocked.

For traffic between subnets, the recommended way is through [Network Security Groups (NSG)](/azure/virtual-network/security-overview). Define rules on each NSG that checks traffic to and from single IP address, multiple IP addresses, or entire subnets.

If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked, or more permissive access than expected is allowed. Azure Firewall (and Firewall Manager) can be used to centralize and manage firewall policies.

Another way is to use network virtual appliances (NVAs) that check inbound (ingress) and outbound (egress) traffic and filters based on rules.

**How do you route network traffic through NVAs for security boundary policy enforcement, auditing, and inspection?**
***

Use User Defined Routes (UDR) to control the next hop for traffic between Azure, on-premises, and internet resources. The routes can be applied to virtual appliance, virtual network gateway, virtual network, or internet.

For example, you need to inspect all ingress traffic from a public load balancer. One way is to host an NVA in a subnet that allows traffic only if certain criteria is met. That traffic is sent to the subnet that hosts an internal load balancer that routes that traffic to the backend services.

You can also use NVAs for egress traffic. For instance, all workload traffic is routed by using UDR to another subnet. That subnet has an internal load balancer that distributes requests to the NVA (or a set of NVAs). These NVAs direct traffic to the internet using their individual public IP addresses.

> [!TIP]
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Automated failover for network virtual appliances](https://github.com/Azure/ha-nva-fo).
>
> The design considerations are described in [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml).

Azure Firewall can serve as an NVA. Azure supports third-party network device providers. They're available in Azure Marketplace.

**How do you get insights about ingoing and outgoing traffic of this workload?**
***
As a general rule, configure and collect network traffic logs. If you use NSGs, capture and analyze NSG flow logs to monitor performance and security. The NSG flow logs enable Traffic Analytics to gain insights into internal and external traffic flows of the application.

For information about defining network perimeters, see [Network segmentation](design-network-segmentation.md).

**Can the VNet and subnet handle growth?**
***

Typically, you'll add more network resources as the design matures. Most organizations end up adding more resources to networks than initially planned. Refactoring to accommodate the extra resources is a labor-intensive process. There is limited security value in creating a very large number of small subnets and then trying to map network access controls (such as security groups) to each of them.

Plan your subnets based on roles and functions that use the same protocols. That way, you can add resources to the subnet without making changes to security groups that enforce network level access controls.

Don't use all open rules that allow inbound and outbound traffic to and from 0.0.0.0-255.255.255.255. Use a least-privilege approach and only allow relevant protocols. It will reduce your overall network attack surface on the subnet. All open rules provide a false sense of security because such a rule enforces no security.

The exception is when you want to use security groups only for network logging purposes.

Design virtual networks and subnets for growth. We recommend planning subnets based on common roles and functions that use common protocols for those roles and functions. This allows you to add resources to the subnet without making changes to security groups that enforce network level access controls.

### Suggested actions

Use NSG or consider using Azure Firewall to protect and control traffic within the VNET.

### Learn more

- [Azure firewall documentation](/azure/firewall/)
- [Design virtual network subnet security](/azure/architecture/framework/security/design-network-segmentation#design-virtual-network-subnet-security)
- [Design an IP addressing schema for your Azure deployment](/learn/modules/design-ip-addressing-for-azure/)
- [Network security groups](/azure/virtual-network/network-security-groups-overview)

## Internet edge traffic

As you design the workload, consider security for internet traffic. Does the workload or parts of it need to be accessible from public IP addresses? What level of access should be given to prevent unauthorized access?

Internet edge traffic (also called _North-South traffic_) represents network connectivity between resources used by the workload and the internet. An internet edge strategy should be designed to mitigate as many attacks from the internet to detect or block threats. There are two primary choices that provide security controls and monitoring:

- Azure solutions such as Azure Firewall and Web Application Firewall (WAF).

Azure provides networking solutions to restrict access to individual services. Use multiple levels of security, such as combination of IP filtering, firewall rules to prevent application services from being accessed by unauthorized actors.

- Network virtual appliances (NVAs). You can use Azure Firewall or third-party solutions available in Azure Marketplace.

Azure security features are sufficient for common attacks, easy to configure, and scale. Third-party solutions often have advanced features but they can be hard to configure if they don't integrate well with fabric controllers. From a cost perspective, Azure options tend to be cheaper than partner solutions.

Information revealing the application platform, such as HTTP banners containing framework information (`X-Powered-By`, `X-ASPNET-VERSION`), are commonly used by malicious actors when mapping attack vectors of the application.

HTTP headers, error messages, and website footers should not contain information about the application platform. Azure CDN can be used to separate the hosting platform from end users. Azure API Management offers transformation policies that allow you to modify HTTP headers and remove sensitive information.

**Suggested action**

Consider using CDN for the workload to limit platform detail exposure to attackers.

**Learn more**

[Azure CDN documentation](/en-us/azure/cdn/)

## Communication with backend services

Most workloads are composed of multiple tiers where several services can serve each tier. Common examples of tiers are web front ends, business processes, reporting and analysis, backend infrastructure, and so on.

Application resources allowing multiple methods to publish app content (such as FTP, Web Deploy) should have the unused endpoints disabled. For Azure Web Apps, SCM is the recommended endpoint and it can be protected separately with network restrictions for sensitive scenarios.

Public access to any workload should be judiciously approved and planned, as public entry points represent a key possible vector of compromise. When allowing access from public IPs to any back-end service, limiting the range of allowed IPs can significantly reduce the attack surface of that service. For example, if using Azure Front Door, you can limit backend tiers to allow Front Door IPs only; or if a partner uses your API, limit access to only their nominated public IP(s).

**How do you configure traffic flow between multiple application tiers?**
***
Use Azure Virtual Network Subnet to allocate separate address spaces for different elements or tiers within the workload. Then, define different access policies to control traffic flows between those tiers and restrict access. You can implement those restrictions through IP filtering or firewall rules.

**Do you need to restrict access to the backend infrastructure?**
***

Restrict access to backend services to a minimal set of public IP addresses with App Services IP restrictions or Azure Front Door.

Web applications typically have one public entry point and don't expose subsequent APIs and database servers over the internet. Expose only a minimal set of public IP addresses based on need _and_ only those who really need it. For example, when using gateway services, such as Azure Front Door, it's possible to restrict access only to a set of Front Door IP addresses and lock down the infrastructure completely.

**Suggested action**

- Restrict and protect application publishing methods.

**Learn more**

- [Set up Azure App Service access restrictions](/azure/app-service/app-service-ip-restrictions)
- [Azure Front Door documentation](/azure/app-service/app-service-ip-restrictions)
- [Deploy your app to Azure App Service using FTP/S](/azure/app-service/deploy-ftp?tabs=portal)

## Connection with Azure PaaS services

The workload will often need to communicate with other Azure services. For example, it might need to get secrets from Azure Key Vault. Avoid making connections over the public internet.

**Does the workload use secure ways to access Azure PaaS services?**
***

Common approaches for accessing PaaS services are Service Endpoints or Private Links. Both approaches  restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability.

With Service Endpoints, the communication path is secure because you can reach the PaaS endpoint without needing a public IP address on the VNet. Most PaaS services support communication through service endpoints. For a list of generally available services, see [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview).

Another mechanism is through Azure Private Link. Private Endpoint uses a private IP address from your VNet, effectively bringing the service into your VNet. For details, see [What is Azure Private Link?](/azure/private-link/private-link-overview).

Service Endpoints provide service level access to a PaaS service, whereas Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks, such as malicious admin access. Private Link is a paid service and has meters for inbound and outbound data processed. Private Endpoints are also charged.

**How do you control outgoing traffic of Azure PaaS services where Private Link isn't available?**
***

Use NVAs and Azure Firewall (for supported protocols) as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link isn't supported. Use Azure Firewall to protect against data exfiltration concerns.

## On-premises to cloud connectivity

In a hybrid architecture, the workload runs partly on-premises and partly in Azure. Have security controls that check traffic entering Azure virtual network from on-premises data center.

**How do you establish cross premises connectivity?**
***

Use Azure ExpressRoute to set up cross premises connectivity to on-premises networks. This service uses a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure. This way, you can reduce the risk of potential of access to company's information assets on-premises.

**How do you access VMs?**
***

Use Azure Bastion to log into your VMs and avoid public internet exposure using SSH and RDP with private IP addresses only. You can also disable RDP/SSH access to VMs and use VPN, ExpressRoute to access these virtual machines for remote management.

**Do the cloud or on-premises VMs have direct internet connectivity for users that may perform interactive logins?**
***

Attackers constantly scan public cloud IP ranges for open management ports and attempt low-cost attacks such as common passwords and known unpatched vulnerabilities. Develop processes and procedures to prevent direct internet access of VMs with logging and monitoring to enforce policies.

**How is internet traffic routed?**
***

Decide how to route internet traffic. You can use on-premises security devices (also called _forced tunneling_) or allow connectivity through cloud-based network security devices.

For production enterprise, allow cloud resources to start and respond to internet request directly through cloud network security devices defined by your [internet edge strategy](#internet-edge-traffic). This approach fits the Nth datacenter paradigm, that is Azure datacenters are a part of your enterprise. It scales better for an enterprise deployment because it removes hops that add load, latency, and cost.

Another option is to force tunnel all outbound internet traffic from on-premises through site-to-site VPN. Or, use a cross-premise WAN link. Network security teams have greater security and visibility to internet traffic. Even when your resources in the cloud try to respond to incoming requests from the internet, the responses are force tunneled. This option fits a datacenter expansion use case and can work well for a quick proof of concept, but scales poorly because of the increased traffic load, latency, and cost. For those reasons, we recommend that you avoid [forced tunneling](/azure/vpn-gateway/vpn-gateway-about-forced-tunneling).

## Next step

> [!div class="nextstepaction"]
> [Secure endpoints](design-network-endpoints.md)

## Related links

For information about controlling next hop for traffic, see [Azure Virtual Network User Defined Routes (UDR)](/azure/virtual-network/virtual-networks-udr-overview).

For information about web application firewalls, see [Application Gateway WAF](/azure/application-gateway/).

For information about Network Appliances from Azure Marketplace, see [Network Appliances](https://azure.microsoft.com/solutions/network-appliances/).

For information about cross premises connectivity, see [Azure site-to-site VPN or ExpressRoute](/azure/security/azure-security-network-security-best-practices).

For information about using VPN/ExpressRoute to access these virtual machines for remote management, see [Disable RDP/SSH access to Azure Virtual Machines](/azure/security/azure-security-network-security-best-practices).

> Go back to the main article: [Network security](design-network.md)
