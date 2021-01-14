---
title: Secure network connectivity
description: Best practices for network security in Azure, including network segmentation, network management, containment strategy, and internet edge strategy.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Secure network connectivity

It's often the case that the workload and the supporting components of a cloud architecture will need to access external assets. These assets can be on-premises, devices outisde the main virtual network, or other Azure resources. Those connections can be over the internet or networks within the your organization.

. When thinking about network traffic, it’s helpful to distinguish East-West traffic from North-South traffic:
•	East-West traffic is network traffic within the cluster (service-to service, pod-to-pod). This architecture uses Kubernetes network policies to restrict which pods can communicate, starting from a zero-trust policy and then opening specific communication paths as needed. 
•	North-South traffic is network traffic from client applications to the backend. This architecture uses Web Application Firewall on Application Gateway to secure incoming (ingress) traffic, and Azure Firewall to secure outgoing (egress) traffic.

## Key points

- Protect non-public accessible services with network restrictions and IP firewall.
- Use service endpoints and private links where appropriate.
- Restrict access to backend services to a minimal set of public IP addresses, only those who really need it.
- Use Azure controls over third-party solutions for basic security needs. They are easy to configure and scale. 
- Define access policies based on the type of workload and control flow between the different application tiers.

## Internet edge traffic

As you design the workload, start with simple questions. Does the workload or parts of it need to be accessible from public IP addresses. What level of access should be given to prevent unauthorized access.

Internet edge traffic (also called _North-South traffic_) represents network connectivity between resources used by the workload and the internet. An internet edge strategy is intended to mitigate as many attacks from the internet as is reasonable to detect or block threats. There are two primary choices that provide security controls and monitoring:

- Azure solutions such as Azure Firewall and Web Application Firewall (WAF).

Azure provides networking solutions to restrict access to individual services. Use multiple levels of security, such as combination of IP filtering, firewall rules to prevent application services from being accessed by unauthorized actors.

- Network virtual appliances (NVAs). You can use Azure Firewall or third-party solutions available in Azure Marketplace.  

Azure security features are sufficient for common attacks, easy to configure, and scale. Third-party solutions often have advanced features but they can be hard to configure if they don't integrate well with fabric controllers. From a cost perspective, Azure options tend to be cheaper than partner solutions.

**How do you configure public IPs for which traffic is passed in?**
***

Provision VMs with private IP addresses for protection. Utilize Azure IP address to determine which traffic is passed in, and how and where it's translated on to the virtual network.

You can deploy Azure Firewall in your VNet for filtering traffic flowing between cloud resources, the internet, and on-premise. You create rules or policies (using Azure Firewall or Azure Firewall Manager) specifying allow or deny traffic using layer 3 to layer 7 controls. You can also filter traffic going to the internet using both Azure Firewall and third parties by directing some or all traffic through third-party security providers for advanced filtering & user protection.

## Communication with backend services

Most workloads are composed of mutiple tiers where several services can serve each tier. Common examples of tiers are web front ends, business processes, reporting and analysis, backend infrastructure, and so on. 

**How do you configure traffic flow between multiple application tiers?**
***
Use Azure Virtual Network Subnet to allocate separate address spaces for different elements or tiers within the workload. Then, define different access policies to control traffic flows between those tiers and restrict access. You can implement those restrictions through IP filtering or firewall rules.

**Do you need to restrict access to the backend infrastructure?**
***

Web applications typically have one public entrypoint and don't expose subsequent APIs and database servers over the internet. Expose only a minimal set of public IP addresses based on need _and_ only those who really need it. For example, when using gateway services, such as Azure Front Door, it's possible to restrict access only to a set of Front Door IP addresses and lock down the infrastructure completely.


## Connection with Azure PaaS services

The workload will often need to communicate with other Azure services. For example it might need to get secrets from Azure Key Vault. Avoid making connections over the public internet. Common approaches are service endpoints or private links.

With Azure Virtual Network (VNet), you have the capability adding service endpoints. The endpoint opens a private IP address on a subnet of the VNet to communicate with endpoint of the destination Azure service. The communication path is secure because you can reach the endpoint of an Azure service without needing a public IP address on the VNet. Most services support communication through service endpoints. For a list of generally available services, see [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview).

Another mechanism is through Azure Private Link. Private Endpoint uses a private IP address from your VNet, effectively bringing the service into your VNet. For details, see [What is Azure Private Link?](/azure/private-link/private-link-overview).



## On-premises to cloud connectivity

In a hybrid archittecture, the workload run partly on-premises and partly in Azure. Have security controls that check traffic entering Azure virtual network from on-premises data center. 

**How do you establish cross premises connectivity?**
***

Use Azure ExpressRoute to set up cross premises connectivity to on-premises networks. private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure. This reduces the risk of potential of access to company’s information assets on-premises.

Another option is to force tunnel all outbound internet traffic from on-premises through site-to-site VPN or is _forced tunneling_, which is achieved through a cross-premise WAN link. The goal is to provide the network security teams with greater security and visibility to internet traffic. Even when your resources in the cloud try to respond to incoming requests from the internet, the responses are force tunneled. This option fits a datacenter expansion scenario and can work well for a quick proof of concept, but scales poorly because of the increased traffic load, latency, and cost. For those reasons, we recommend that you avoid [forced tunneling](/azure/vpn-gateway/vpn-gateway-about-forced-tunneling).


How do you disable RDP/SSH access to virtual machines?

Risk: Potential for attackers to use brute force techniques to gain access and launch other attacks.

Disable RDP/SSH access to Azure Virtual Machines and use VPN/ExpressRoute to access these virtual machines for remote management.

Do workload virtual machines running on premises or in the cloud have direct internet connectivity for users that may perform interactive logins, or by applications running on virtual machines?

Attackers constantly scan public cloud IP ranges for open management ports and attempt “easy” attacks like common passwords and known unpatched vulnerabilities.

Develop process and procedures to prevent direct Internet access of virtual machines with logging and monitoring to enforce policies.


## Decide on an internet ingress/egress policy
Decide whether to route traffic for the internet through on-premises security devices (also called forced tunneling) or allow internet connectivity through cloud-based network security devices.

For production enterprise, allow cloud resources to start and respond to internet request directly through cloud network security devices defined by your [internet edge strategy](#define-an-internet-edge-strategy). This approach fits the Nth datacenter paradigm, that is Azure datacenters are a part of your enterprise. It scales better for an enterprise deployment because it removes hops that add load, latency, and cost.

Forced tunneling is achieved through a cross-premise WAN link. The goal is to provide the network security teams with greater security and visibility to internet traffic. Even when your resources in the cloud try to respond to incoming requests from the internet, the responses are force tunneled. Alternately, forced tunneling fits a datacenter expansion paradigm and can work well for a quick proof of concept, but scales poorly because of the increased traffic load, latency, and cost. For those reasons, we recommend that you avoid [forced tunneling](/azure/vpn-gateway/vpn-gateway-about-forced-tunneling).

## Evolve security beyond network controls

In modern architectures, mobile and other devices outside the network access various services for applications over the internet or on cloud provider networks. Traditional network controls that are based on a trusted intranet approach can’t effectively provide security assurances for those applications. 

Combine network controls with application, identity, and other technical control types. This approach is  effective in preventing, detecting, and responding to threats outside the networks you control.

- Ensure that resource grouping and administrative privileges align to the segmentation model.

- Design security controls that identify and allow expected traffic, access requests, and application communication between segments. Monitor the communication between segment. Use data to identify anomalies, set alerts, or block traffic to mitigate the risk of attackers crossing segmentation boundaries. 

For information, see [Jericho Forum](https://en.wikipedia.org/wiki/Jericho_Forum) and ‘Zero Trust’ approaches.









## IP configuration



Are the services of this workload, which should not be accessible from public ip addresses, protected with network restrictions / IP firewall rules?

Azure provides networking solutions to restrict access to individual application services. Multiple levels (such as IP filtering or firewall rules) should be explored to prevent application services from being accessed by unauthorized actors.

Protect non-public accessible services with network restrictions / IP firewall.

Does the workload use Service Endpoints or Private Link for accessing Azure PaaS services?

Service Endpoints and Private Link can be leveraged to restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios). Don’t forget that Private Link is a paid service and has meters for inbound and outbound data processed. Private Endpoints are charged as well.

Use service endpoints and private links where appropriate.

Does the organization use Azure Firewall or any 3rd party next generation Firewall for this workload to control outgoing traffic of Azure PaaS services (data exfiltration protection) where Private Link is not available?

NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported (Azure Firewall).

Use Azure Firewall or a 3rd party next generation firewall to protect against data exfiltration concerns.

Does the workload use network security groups (NSG) to isolate and protect traffic within the workloads VNet?

If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked.

Use NSG or Azure Firewall to protect and control traffic within the VNet

Does the organization have configured NSG flow logs to get insights about ingoing and outgoing traffic of this workload?

NSG flow logs should be captured and analyzed to monitor performance and security. The NSG flow logs enables Traffic Analytics to gain insights into internal and external traffic flows of the application.

Configure and collect network traffic logs.

Does the organization restrict access to the workload backend infrastructure (APIs, databases, etc.) by only a minimal set of public IP addresses based on need, only those who really need it?

Web applications typically have one public entrypoint and don't expose subsequent APIs and database servers over the internet. When using gateway services like Azure Front Door it's possible to restrict access only to a set of Front Door IP addresses and lock down the infrastructure completely.

Restrict access to backend services to a minimal set of public IP addresses, only those who really need it.

Does the organization identify and isolate groups of resources from other parts of the organization to aid in detecting and containing adversary movement within the enterprise?

A unified enterprise segmentation strategy will guide all technical teams to consistently segment access using networking, applications, identity, and any other access controls.

Establish a unified enterprise segmentation strategy.

Does the organization align the cloud network segmentation strategy with the enterprise segmentation model?

Aligning cloud network segmentation strategy with the enterprise segmentation model reduces confusion and resulting challenges with different technical teams (networking, identity, applications, etc.) each developing their own segmentation and delegation models that don’t align with each other.

Align cloud network segmentation strategy with the enterprise segmentation model.




***
It’s challenging to write concise firewall rules for networks where different cloud resources dynamically spin up and down, cloud customers may share common infrastructure, and employees and users expect to access data and services from anywhere. To enable all those capabilities, you must manage access based on identity authentication and authorization controls to protect data and resources and to decide which requests are permitted. 



Start by gathering requirements about the workload. 

|Question|Security assurance|
|---|---|
|**How do you isolate network traffic in Azure?**|Communication between VMs should remain private within a network boundary. If there are various rules, associate a network interface to one of more application security groups. Apply a security rule to restrict traffic that applies to the interfaces of each security group. |
|**How do you isolate and protect traffic within the workload VNet?**||

## Virtual network

When designing a workload, you'll typically start by provisioning an Azure Virtual Network (VNet)  in a private address space where the workload will reside. No traffic is allowed by default between any two virtual networks. If there's a need, define the communication paths explicitly.

A key aspect is protecting the VMs in the VNet. The network interfaces on the VMs allow them to communicate with other VMs, the internet, and on-premises networks. To control traffic on VMs within a VNet (and subnet), use application security groups (ASGs). They are referenced with an application context. It allows you to group a set of VMs under an application tag and define traffic rules that are then applied to each of the underlying VMs.

## Subnets

Most workloads are composed of mutiple tiers and each several services can serve each tier. Common examples are web front ends, business processes, reporting and analysis, data stores, and so on. To isolate those service, a VNet is divided into one or more subnets.

Provide proper network security controls that allow or deny inbound network traffic to, or outbound network traffic from, within larger network space.

**How do you isolate and protect traffic within the workload VNet?**
***

A common way to secure communication within a VNet is with a set of rules. You can set rules that inspect traffic and allow or deny traffic to, or from specific sources and route them to the specified destinations. 
>![Task](../../_images/i-best-practices.svg) Review the rule set and confirm that the required services are not unintentionally blocked.

For traffic between subnets, the recommended way is through network security groups (NSGs). Define rules on each NSG that allows or denies traffic to and from single IP address, multiple IP addresses, or entire subnets.

Another way is to use network virtual appliances (NVAs) that check inbound (ingress) and outbound (egress) traffic and filters based on rules. 

For example, you need to inspect all ingress traffic from a public load balancer. One way is to host an NVA in a subnet that allows traffic only if certain criteria is met. That traffic is sent to the subnet that hosts an internal load balancer that routes that traffic to the backend services.  

You can also use NVAs for egress traffic. For instance all workload traffic is routed by using UDR to another subnet. That subnet has an internal load balancer that distributes requests to the NVA.  between a set of NVAs. These NVAs direct traffic to the internet using their individual public IP addresses.

>![Task](../../_images/i-best-practices.svg) An NVA can be a single point of failure if it becomes unavailable. Makes sure the NVA is highly available. Deploy more than one NVA into an availability set.

> [!TIP]
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Automated failover for network virtual appliances]https://github.com/Azure/ha-nva-fo).
>
> The design considerations are described in [Deploy highly available NVAs](/azure/architecture/reference-architectures/dmz/nva-ha).

Azure Firewall can serve as an NVA. Azure supports third-party network device providers. They are available in Azure Marketplace.


**How do you route network traffic through NVAs for security boundary policy enforcement, auditing, and inspection?**
***

Use Azure Virtual Network User Defined Routes (UDR) to control next hop for traffic between Azure, on-premises, and Internet resources through virtual appliance, virtual network gateway, virtual network, or internet.


**How do you get insights about ingoing and outgoing traffic of this workload?**
***
As a general rule, configure and collect network traffic logs. If you use NSGs, capture and analyze NSG flow logs to monitor performance and security. The NSG flow logs enable Traffic Analytics to gain insights into internal and external traffic flows of the application.