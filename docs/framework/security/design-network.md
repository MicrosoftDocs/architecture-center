---
title: Network security strategies
description: Best practices for network security in Azure, including network segmentation, network management, containment strategy, and internet edge strategy.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Network security

Protect assets by placing controls on network traffic originating in Azure, between on-premises and Azure hosted resources, and traffic to and from Azure. If security measures aren't in place attackers can gain access, for instance, by scanning across public IP ranges. Proper network security controls can provide defense-in-depth elements that help detect, contain, and stop attackers who gain entry into your cloud deployments. 

Here are some recommendations for network security and containment:

- Align network segmentation with overall strategy
- Centralize network management and security
- Build a network containment strategy
- Define an internet edge strategy

## Centralize network management and security

Centralize the management and security of core networking functions such as cross-premises links, virtual networking, subnetting, and IP address schemes. This also applies to security elements such as virtual network appliances, encryption of cloud virtual network activity and cross-premises traffic, network-based access controls, and other traditional network security components.

Centralizing can reduce the potential for inconsistent strategies that a potential attacker can misuse. Also, the entire organization benefits from the centralized network team’s expertise in network management, security knowledge, and tooling.

[Azure Security Center](/azure/security-center/security-center-network-recommendations) can be used to help centralize the management of network security.

## Build a network segmentation strategy

At an organizational level, align your network segmentation strategy with the enterprise segmentation strategy to have a unified strategy. This approach helps reduce human errors, and increases reliability through automation.

Here's an example of network architecture for a hybrid cloud infrastructure.
![Diagram shows a reference enterprise design for Azure network security in a hybrid cloud infrastructure.](images/ref-entp-design-az-network-security.png)

## Evolve security beyond network controls

In modern architectures, mobile and other devices outside the network access various services for applications over the internet or on cloud provider networks. Traditional network controls that are based on a trusted intranet approach can’t effectively provide security assurances for those applications. 

Combine network controls with application, identity, and other technical control types. This approach is  effective in preventing, detecting, and responding to threats outside the networks you control.

- Ensure that resource grouping and administrative privileges align to the segmentation model.

- Design security controls that identify and allow expected traffic, access requests, and application communication between segments. Monitor the communication between segment. Use data to identify anomalies, set alerts, or block traffic to mitigate the risk of attackers crossing segmentation boundaries. 

For information, see [Jericho Forum](https://en.wikipedia.org/wiki/Jericho_Forum) and ‘Zero Trust’ approaches.


## Build a risk containment strategy

Containment of attack vectors within an environment is critical. Here are some considerations for creating a containment strategy.

- Use native capabilities provided by a cloud service provider, dynamic just-in-time (JIT) methods, and integrated identity and password controls, such as those recommended by zero trust and continuous validation approaches. 
- Make sure that there are network access controls between network constructs. These constructs can represent virtual networks, or subnets within those virtual networks. This works to protect and contain East-West traffic within your cloud network infrastructure. 
- Determine whether to use host-based firewalls. If host-based firewalls have been effective in helping you protect and discover threats in the past, consider using them for your cloud-based resources. Otherwise, explore native solutions on your cloud service provider’s platform.
- Adopt a zero-trust strategy based on user, device, and application identities. Network access controls are based on elements such as source and destination IP address, protocols, and port numbers. Adding zero trust enforces and validates access control during “access time”. This strategy avoids the need for complex combinations of open ports, network routes, available or serviced protocols for several types of changes. Only the destination resource needs to provide the necessary access controls. 

These technology options can be used to set up network control:

-   Azure Network Security Groups. Use for basic layer 3 & 4 access controls between Azure Virtual Networks, their subnets, and the Internet.

-   Azure Web Application Firewall and the Azure Firewall. Use for more advanced network access controls that require application layer support.

-   [Local Admin Password Solution (LAPS)](https://www.microsoft.com/download/details.aspx?id=46899) or a third-party Privileged Access Management. Set strong local admin passwords and just in time access to them.


Third parties offer microsegmentation approaches that may enhance network controls by applying zero-trust principles to networks you control with legacy assets on them.

## Define an internet edge Strategy

Decide whether to use native cloud service provider controls or virtual network appliances for internet edge security.

Internet edge traffic (also known as North-South traffic) represents network connectivity between cloud resources and the internet. Legacy workloads require protection from internet endpoints because they were built with the assumption of an internet firewall. An internet edge strategy is intended to mitigate attacks from the internet and detect or block threats.

There are two primary choices that can provide internet edge security controls and monitoring:

-   Cloud service provider native controls ([Azure Firewall](https://azure.microsoft.com/services/azure-firewall/) and
    [Web Application Firewall (WAF)](/azure/application-gateway/waf-overview)).

-   Partner virtual network appliances (Firewall and WAF Vendors available in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/). Partner solutions consistently cost more than native controls.

Native controls offer basic security and are insufficient for common attacks, such as the OWASP Top 10. Partner capabilities can provide advanced features to protect against sophisticated (but typically uncommon) attacks. Configuration of partner solutions can be complex and more fragile because they don't integrate with cloud’s fabric controllers. From a cost perspective, native control is cheaper than partner solutions.

The decision to use native as opposed to partner controls should be based on your organization’s experience and requirements. If the features of the advanced firewall solutions don’t provide sufficient return on investment, consider using the native capabilities that are easy to configure and scale.


## Evaluate the use of legacy network security technology

Carefully plan your use of signature-based Network Intrusion Detection/Network Intrusion Prevention (NIDS/NIPS) Systems and Network Data Leakage/Loss Prevention (DLP) as you adopt cloud applications services. 

IDS/IPS can generate a high number of false positive alerts. A well-tuned IDS/IPS system can be effective for classic application architectures but don't work well for SaaS and PaaS architectures. 

Network-based DLP is ineffective at identifying both inadvertent and deliberate data loss because most modern protocols and attackers use network-level encryption for inbound and outbound communications. SSL-bridging can provide an authorized man-in-the-middle entity that terminates and then reestablishes encrypted network connections. However, this can also introduce privacy, security, and reliability challenges. 

Keep reviewing and updating your network security strategy on these considerations as you migrate existing workloads to Azure:
- Cloud service providers filter malformed packets and common network layer attacks.
- Many traditional NIDS/NIPS solutions use signature-based approaches per packet. This can be easily evaded by attackers and typically produce a high rate of false positives. 
- Ensure your IDS/IPS system(s) are providing positive value from alerts. 
  - Measure alert quality by the percentage of real attacks detections versus false alarms in the alerts raised by the system. 
  - Provide high-quality alerts to security analysts. Ideally, alerts should have a 90% true positive rate for creating incidents in the primary queue to which triage investigation teams must respond. Lower quality alerts would go to proactive hunting exercises to reduce analyst fatigue and burnout. 
- Adopt modern zero-trust identity approaches for protecting modern SaaS and PaaS applications. See [Zero-Trust](https://aka.ms/zero-trust) for more information
- For IaaS workloads, focus on network security solutions that provide per network context rather than per packet/session context. Software-defined networks in the cloud are naturally instrumented and can achieve this much more easily than on-premises equipment.
- Favor solutions use machine learning techniques across these large volumes of traffic. ML technology is far superior to static/manual human analysis at rapidly identifying anomalies that could be attacker activity out of normal traffic patterns.

## Design virtual network subnet security

Design virtual networks and subnets for growth.

Typically, you'll add more network resources as the design matures. This will require refactoring of IP addressing and subnetting schemes to accommodate the extra resources. There is limited security value in creating many small subnets and then trying to map network access controls (such as security groups) to each of them.

Plan your subnets based on roles and functions that use same protocols. That way, you can add resources to the subnet without making changes to security groups that enforce network level access controls.

Do not use _all open_ rules that allow inbound and outbound traffic to and from 0.0.0.0-255.255.255.255. Use _a least privilege_ approach and only allow relevant protocols. It will decrease your overall network attack surface on the subnet. All open rules provide a false sense of security because such a rule enforces no security. 

The exception is when you want to use security groups only for network logging purposes. We don't recommend this option. But it's an option if you have another network access control solution in place.

[Azure Virtual Network subnets](https://almbok.com/office365/microsoft_cloud_it_architecture_resources) can be designed in this way.

## Mitigate DDoS attacks

Enable Distributed Denial of Service (DDoS) mitigations for all business-critical web application and services.
DDoS attacks are common and are easily conducted by unsophisticated attackers. DDoS attacks can be debilitating. An attack can completely block access to your services and even take down the services. 
Responsible cloud service providers offer DDoS protection of services with varying effectiveness and capacity. Mostly they provide two options:
- DDoS protection at the cloud network fabric level – all customers of the cloud service provider benefit from these protections. The protection usually focuses on the network (layer 3) level.
- DDoS protection at higher levels that profile your services – this option provides a baseline for your deployments and then uses machine learning techniques to detect anomalous traffic and proactively protects based on protection level set prior to service degradation.
Adopt the advance protection for any services where downtime will negatively impact the business.

For an example of advanced DDoS protection, see [Azure DDoS Protection Service](/azure/virtual-network/ddos-protection-overview).

## Decide on an internet ingress/egress policy
Decide whether to route traffic for the internet through on-premises security devices (also called forced tunneling) or allow internet connectivity through cloud-based network security devices.

For production enterprise, allow cloud resources to start and respond to internet request directly through cloud network security devices defined by your [internet edge strategy](#define-an-internet-edge-strategy). This approach fits the Nth datacenter paradigm, that is Azure datacenters are a part of your enterprise. It scales better for an enterprise deployment because it removes hops that add load, latency, and cost.

Forced tunneling is achieved through a cross-premise WAN link. The goal is to provide the network security teams with greater security and visibility to internet traffic. Even when your resources in the cloud try to respond to incoming requests from the internet, the responses are force tunneled. Alternately, forced tunneling fits a datacenter expansion paradigm and can work well for a quick proof of concept, but scales poorly because of the increased traffic load, latency, and cost. For those reasons, we recommend that you avoid [forced tunneling](/azure/vpn-gateway/vpn-gateway-about-forced-tunneling).