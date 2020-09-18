---
title: Network security review
description: Assess your workload in areas such as network boundary security, network security, database security, data storage security, identity management, and operational security
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Network security review
Assess your workload in areas such as network boundary security, network security, database security,
data storage security, identity management, and operational security.

**How do you implement DDoS protection?**
***

**Risk**:  Potential of smaller-scale attack that doesn't trip the platform-level protection.

Azure Virtual Network resources offers **Basic** and **Standard** tiers for DDoS protection. Enable DDoS Protection Standard for all business-critical web application and services. 

The [Windows N-tier application on Azure with SQL Server](../../reference-architectures/n-tier/n-tier-sql-server.md) reference architecture uses DDoS Protection Standard because this option:
- Uses adaptive tuning, based on the application's network traffic patterns, to detect threats. 
- Guarantees 100% SLA. 
- Can be cost effective. For example, during a DDoS attack, the first set of attacks cause  the provisioned resources to scale out. For a resource such as a virtual machine scale set, 10 machines can grow to 100, increasing overall costs. With Standard protection, you don't have to worry about the cost of the scaled resources because Azure will provide the cost credit. 

For information about Standard DDoS Protection, see [Azure DDoS Protection Service](/azure/virtual-network/ddos-protection-overview).


**How do you configure public IPs for which traffic is passed in, and how and where it's translated?**
***

**Risk**: Inability to provision VMs with private IP addresses for protection.

Use Azure Firewall for built-in high availability and unrestricted cloud scalability.

Utilize Azure IP address to determine which traffic is passed in, and how and where it's translated on to the virtual network.

**How do you isolate network traffic in Azure?**
***
**Risk**: Inability to ensure VMs and communication between them remains private within a network boundary.

Use Azure Virtual Network to allow VMs to securely communicate with each other, the internet, and on-premises networks. Otherwise, communication between VMs may not be fully private within a network boundary.

**How do you configure traffic flow between multiple application tiers?**
***

**Risk**: Inability to define different access policies based on the workload types, and to control traffic flows between them.

You may want to define different access policies based on the workload types and control flow between them. Use [Azure Virtual Network Subnet](/azure/virtual-network/virtual-network-manage-subnet) to allocate separate address spaces for different elements or _tiers_ within the workload. Then, define different access policies, and control traffic flows between those tiers.

**How do you route network traffic through security appliances for security boundary policy enforcement, auditing, and inspection?**
***

**Risk**: Inability to define communication paths between different tiers within a network boundary.

Use [Azure Virtual Network User Defined Routes (UDR)](/azure/virtual-network/virtual-networks-udr-overview) to control next hop for traffic between Azure, on-premises, and Internet resources through virtual appliance, virtual network gateway, virtual network, or internet.



**Do you use firewalls, load balancers, and Network Intrusion Detection/Network Intrusion Prevention (NIDS/NIPS)?**
***
**Risk**: Possibility of not being able to select comprehensive solutions for secure network boundaries.

Use [Network Appliances](https://azure.microsoft.com/solutions/network-appliances/) from Azure Marketplace to deploy a variety of preconfigured network virtual appliances. 

Utilize [Application Gateway WAF](/azure/application-gateway/) to detect and protect against common web attacks.

**How do you segment the larger address space into subnets?**
***

**Risk**: Inability to allow or deny inbound network traffic to, or outbound network traffic from, within larger network space.

Use [network security groups (NSGs)](/azure/virtual-network/security-overview) to allow or deny traffic to and from single IP address, to and from multiple IP addresses, or even to and from entire subnets.

**How do you control routing behavior between VM connectivity?**
***

**Risk**: Inability to customize the routing configuration.

Employ [Azure Virtual Network User Defined Routes (UDR)](/azure/virtual-network/virtual-networks-udr-overview) to customize the routing configuration for deployments.


**How do you implement forced tunneling?**
***

**Risk**: Potential of outbound connections from any VM increasing attack surface area leveraged by attackers.
 
Utilize [forced tunneling](/azure/vpn-gateway/vpn-gateway-forced-tunneling-rm) to ensure that connections to the internet go through corporate network security devices.

**How do you implement enhanced levels of security - firewall, IPS/IDS, antivirus, vulnerability management, botnet protection on top of
network-level controls?**
***

**Risk**: Inability to enable security for other OSI model layers other than network and transport layer.
 
Use [Azure Marketplace](/azure/marketplace/) to provision devices for higher levels of network security than with network-level access controls.


**How do you establish cross premises connectivity?**
***
**Risk**: Potential of access to company’s information assets on-premises.
 
Use [Azure site-to-site VPN or ExpressRoute](/azure/security/azure-security-network-security-best-practices) to set up cross premises connectivity to on-premises networks.


**How do you implement global load balancing?**
***

**Risk**: Inability to make services available even when datacenters might become unavailable.

Utilize [Azure Traffic Manager](https://azure.microsoft.com/documentation/services/traffic-manager/) to load balance connections to services based on the location of the user and/or other criteria

**How do you disable RDP/SSH access to virtual machines?** 
***
**Risk**: Potential for attackers to use brute force techniques to gain access and launch other attacks. 

[Disable RDP/SSH access to Azure Virtual Machines](/azure/security/azure-security-network-security-best-practices) and use VPN/ExpressRoute to access these virtual machines for remote management. 

**How do you prevent, detect, and respond to threats?** 
***
**Risk**: Inability to have a single pane of visibility to prevent, detect, and respond to threats. 

Employ [Azure Security Center](/azure/security-center/security-center-intro) for increased visibility into, and control over, the security of Azure resources, integrated security monitoring, and policy management across Azure subscriptions. 

**How do you monitor and diagnose conditions of the network?** 
***
**Risk**: Inability to understand, diagnose, and gain insights to the network in Azure. 

Use [Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) to understand, diagnose, and gain insights to the network in Azure. 

**How do you gain access to real time performance information at the packet level?** 
***
**Risk**: Inability to investigate an issue in detail for better diagnoses. 

Utilize [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) to set alerts and gain access to real time performance information at the packet level. 

**How do you gather data for compliance, auditing, and monitoring the network security profile?** 
***
**Risk**: Inability to build a deeper understanding of the network traffic pattern. 

Use [network security group flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) to gather data for compliance, auditing, and monitoring of your network security profile. 

**How do you diagnose VPN connectivity issues?** 
**Risk**: Inability to identify the issue and use the detailed logs for further investigation. 

Use [Network Watcher troubleshooter](/azure/network-watcher/network-watcher-diagnose-on-premises-connectivity) to diagnose most common VPN gateway and connections issues
