---
title:  Azure Well-Architected Framework review of Azure Firewall
titleSuffix: Azure Architecture Center
description: This guidance provides best practices for Azure Firewall, based on the Well-Architected Framework's five pillars of architecture excellence.
author: rohilla-shweta
ms.author: rosanto
ms.date: 08/25/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-firewall
categories:
  - networking
ms.custom:
  - fcp
---

# Azure Well-Architected Framework review of Azure Firewall

This article provides architectural best practices for Azure Firewall. The guidance is based on the five pillars of architecture excellence: cost optimization, operational excellence, performance efficiency, reliability, and security.

## Cost optimization

Review underutilized Azure Firewall instances, and identify and delete Azure Firewall deployments not in use. To identify Azure Firewall deployments not in use, start analyzing the Monitoring Metrics and User Defined Routes (UDRs) that are associated with subnets pointing to the Firewall’s private IP. Then, combine that with additional validations, such as if the Azure Firewall has any Rules (Classic) for NAT, or Network and Application, or even if the DNS Proxy setting is configured to **Disabled**, as well as with internal documentation about your environment and deployments. See the details about monitoring logs and metrics at [Monitor Azure Firewall logs and metrics](/azure/firewall/firewall-diagnostics) and [SNAT port utilization](/azure/firewall/logs-and-metrics#metrics).

Share the same Azure Firewall across multiple workloads and Azure Virtual Networks. Deploy a central Azure Firewall in the hub virtual network, and share the same Firewall across many spoke virtual networks that are connected to the same hub from the same region. Ensure that there is no unexpected cross-region traffic as part of the hub-spoke topology.

Stop Azure Firewall deployments that do not need to run for 24 hours. This could be the case for development environments that are used only during business hours. See more details at [Deallocate and allocate Azure Firewall](/powershell/module/az.network/set-azfirewall?#4--deallocate-and-allocate-the-firewall).

Properly size the number of Public IPs that your firewall needs. Validate whether all the associated Public IPs are in use. If they are not in use, disassociate and delete them. Use IP Groups to reduce your management overhead. Evaluate SNAT ports utilization before you remove any IP Addresses. See the details about monitoring logs and metrics at [Monitor Azure Firewall logs and metrics](/azure/firewall/firewall-diagnostics) and [SNAT port utilization](/azure/firewall/logs-and-metrics#metrics).

Use Azure Firewall Manager and its policies to reduce your operational costs, by increasing the efficiency and reducing your management overhead. Review your Firewall Manager policies, associations, and inheritance carefully. Policies are billed based on firewall associations. A policy with zero or one firewall association is free of charge. A policy with multiple firewall associations is billed at a fixed rate. See more details at [Pricing - Firewall Manager](https://azure.microsoft.com/pricing/details/firewall-manager).

Review the differences between the two Azure Firewall SKUs. The Standard option is usually enough for east-west traffic, where Premium comes with the necessary additional features for north-south traffic, as well as the forced tunneling feature and many other features. See more information at [Azure Firewall Premium Preview features](/azure/firewall/premium-features). Deploy mixed scenarios using the Standard and Premium options, according to your needs.

## Operational excellence

### General administration and governance

- Use Azure Firewall to govern:
  - Internet outbound traffic (VMs and services that access the internet)
  - Non-HTTP/S inbound traffic
  - East-west traffic filtering
- Use Azure Firewall Premium, if any of the following capabilities are required:
  - TLS inspection - Decrypts outbound traffic, processes the data, encrypts the data, and then sends it to the destination.
  - IDPS - A network intrusion detection and prevention system (IDPS) allows you to monitor network activities for malicious activity, log information about this activity, report it, and optionally attempt to block it.
  - URL filtering - Extends Azure Firewall’s FQDN filtering capability to consider an entire URL. For example, the filtered URL might be www.contoso.com/a/c instead of www.contoso.com.
  - Web categories - Administrators can allow or deny user access to website categories, such as gambling websites, social media websites, and others.
  - See more details at [Azure Firewall Premium Preview features](/azure/firewall/premium-features).
- Use Firewall Manager to deploy and manage multiple Azure Firewalls across Azure Virtual WAN hubs and hub-spoke based deployments.
- Create a global Azure Firewall policy to govern the security posture across the global network environment, and then assign it to all Azure Firewall instances. This allows for granular policies to meet the requirements of specific regions, by delegating incremental Azure Firewall policies to local security teams, via RBAC.
- Configure supported 3rd-party SaaS security providers within Firewall Manager, if you want to use such solutions to protect outbound connections.
- For existing deployments, migrate Azure Firewall rules to Azure Firewall Manager policies, and use Azure Firewall Manager to centrally manage your firewalls and policies.

### Infrastructure provisioning and changes

- We recommend the Azure Firewall to be deployed in the hub VNet. Very specific scenarios might require additional Azure Firewall deployments in spoke virtual networks, but that is not common.
- Prefer using IP prefixes.
- Become familiar with the limits and limitations, especially SNAT ports. Do not exceed limits, and be aware of the limitations. See the Azure Firewall limits at [Azure subscription limits and quotas -  Azure Resource  Manager](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits). Also, learn more about any existing usability limitations at [Azure Firewall FAQ](/azure/firewall/firewall-faq).
- For concurrent deployments, make sure to use IP Groups, policies, and firewalls that do not have concurrent Put operations on them. Ensure all updates to the IP Groups and policies have an implicit firewall update that is run afterwards.
- Ensure a developer and test environment to validate firewall changes.
- A well-architected solution also involves considering the placement of your resources, to align with all functional and non-functional requirements. Azure Firewall, Application Gateway, and Load Balancers can be combined in multiple ways to achieve different goals. You can find scenarios with detailed recommendations, at [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway).

### Networking

An Azure Firewall is a dedicated deployment in your virtual network. Within your virtual network, a [dedicated subnet](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet) is required for the Azure Firewall. Azure Firewall will provision more capacity as it scales. A /26 address space for its subnets ensures that the firewall has enough IP addresses available to accommodate the scaling. Azure Firewall does not need a subnets bigger than /26, and the Azure Firewall subnet name must be **AzureFirewallSubnet**.
- If you are considering using Forced Tunneling feature, you will need an additional /26 address space for the Azure Firewall Management Subnet, and it must to be named **AzureFirewallManagementSubnet**, this is also a requirement.
- Azure Firewall always starts with 2 instances, it can scale up to 20 instances, and you cannot see those individual instances. You can only deploy a single Azure Firewall in each Vnet.
- Azure Firewall must have direct Internet connectivity. If your **AzureFirewallSubnet** learns a default route to your on-premises network via BGP, you must configure Azure Firewall in Forced Tunneling mode. If this is an existing Azure Firewall, which cannot be reconfigured in Forced Tunneling mode, it is recommended to create an UDR with a 0.0.0.0/0 route with the **NextHopType** value set as **Internet** and associate it with the **AzureFirewallSubnet** to maintain internet connectivity.
- When deploying a new Azure Firewall, if you enable the Forced Tunneling mode, you can set the Public IP Address to **None** deploying a fully private Data Plane. However, the Management Plane still requires a Public IP for management purposes only, the internal traffic from Virtual Networks, and/or on-premises will not use that Public IP. See more about Force tunneling at: [Azure Firewall forced tunneling](/azure/firewall/forced-tunneling).
- When having multi-region Azure environments, remember that Azure Firewall is a regional service, therefor you'll likely have one instance per regional hub.

### Monitoring

#### Monitoring capacity metrics

The following metrics can be used by the customer as indicators of utilization of provisioned Azure Firewall capacity. Alerts can be set as needed by the customers to get notifications once a threshold has been reached for any metric.

| **Metric name** | **Explanation** |
| :--: | :-- |
| Application rules hit count | The number of times an application rule has been hit. <br> Unit: count |
| Data Processed | Sum of data traversing the firewall in a given time window. <br> Unit: bytes |
| Firewall Health State | Indicates the health of the firewall based on SNAT port availability. <br> Unit: percent <br> This metric has two dimensions: <br> - Status: Possible values are Healthy, Degraded, Unhealthy. <br> - Reason: Indicates the reason for the corresponding status of the firewall.  <br>   <br> If SNAT ports are used > 95%, they are considered exhausted and the health is 50% with status=Degraded and reason=SNAT port. The firewall keeps processing traffic and existing connections are not affected. However, new connections may not be established intermittently.  <br><br> If SNAT ports are used < 95%, then firewall is considered healthy and health is shown as 100%. <br><br> If no SNAT ports usage is reported, health is shown as 0%. |
| Network rules hit count | The number of times a network rule has been hit. <br> Unit: count |
| SNAT port utilization | The percentage of SNAT ports that have been utilized by the firewall. <br> Unit: percent <br> <br> When you add more public IP addresses to your firewall, more SNAT ports are available, reducing the SNAT ports utilization. Additionally, when the firewall scales out for different reasons (for example, CPU or throughput) additional SNAT ports also become available. So effectively, a given percentage of SNAT ports utilization may go down without you adding any public IP addresses, just because the service scaled out. You can directly control the number of public IP addresses available to increase the ports available on your firewall. But, you can't directly control firewall scaling. <br><br> If your firewall is running into SNAT port exhaustion, you should add at least five public IP address. This increases the number of SNAT ports available. Another option is associating a NAT Gateway with the Azure Firewall Subnet, which can help to increase the ports up to +1M ports. |
| Throughput | Rate of data traversing the firewall per second. <br> Unit: bits per second |

#### Monitoring logs using Azure Firewall Workbook

Azure Firewall exposes a few other logs and metrics for troubleshooting that can be used as indicators of issues. We recommend evaluating alerts as per the table below. Reference: [Monitor Azure Firewall logs and metrics](/azure/firewall/firewall-diagnostics)

| **Metric name**  | **Explanation** |
| :--: | :-- |
| Application rule log | Each new connection that matches one of your configured application rules results in a log for the accepted/denied connection. |
| Network rule log | Each new connection that matches one of your configured network rules results in a log for the accepted/denied connection. |
| DNS Proxy log| This log tracks DNS messages to a DNS server configured using DNS proxy. |

#### Diagnostics logs and policy analytics

- Diagnostic logs allow you to view Azure Firewall logs, Performance logs, and Access logs. You can use these logs in Azure to manage and troubleshoot your Azure Firewall.

- Policy Analytics for Azure Firewall Manager allows you to start seeing rules and flows that match the rules and hit count for those rules. By watching that you can see what rule is in use and traffic being matched, it provides full visibility of the traffic.

## Performance efficiency

### SNAT Ports Exhaustion

- If more than 512K ports will be necessary, use NAT Gateway with Azure Firewall to scale up that limit, you can have up to +1M ports when associating a NAT Gateway to the Azure Firewall Subnet. Refer to the following link: [Scale SNAT ports with Azure NAT Gateway](/azure/firewall/integrate-with-nat-gateway)

### Auto scale and performance

- Azure Firewall uses auto scale, it can go up to 20 instances providing up to 20 Gbps.
- Azure Firewall always starts with 2 instances, and it scales up and down based on CPU and Network Throughput. After Auto scale, Azure Firewall ends up with either n-1 or n+1 instances.
- Scaling up happens if the threshold for CPU or throughput are greater than 60% for more than 5 min.
- Scaling down happens if the threshold for CPU or throughput are under 60% for more than 30 min. The scale down process happens gracefully (deleting instances). The Active Connections on the deprovisioned instances are disconnected and switched over to other instances, for majority of applications this process does not cause any downtime, but applications should have some type of auto-reconnect capability, majority already have.
- If performing load tests, make sure to create initial traffic that is not part of your load tests 20 minutes prior to the test to allow the Azure Firewall to scale up its instances to the maximum. Use Diagnostics settings to capture scale up and down events.
- Do not exceed 10k Network Rules, and make sure use IP Groups. When creating Network Rules, remember that for each rule, Azure actually multiples **Ports x IP Addresses**, so if you 1 Rule with 4 IP Address Ranges and 5 Ports, you will be actually consuming 20 Network Rules, always try to summarize IP ranges.
- There are no restrictions for Application Rules.
- Add the Allow rules first, then add the Deny rules to the lowest priority levels.

## Reliability

- Azure Firewall provides 99.95% SLA when deployed in a single Availability Zone, and 99.99% SLA when deployed in multi-zones.
- For workloads designed to be resistant to failures and fault-tolerant, remember to take into consideration that Azure Firewalls and Virtual Networks are regional resources. 

- Closely monitor metrics, especially SNAT port utilization, firewall health state, and throughput.

- Avoid adding multiple individual IP addresses or IP Addresses ranges to Network Rules, use Super Nets instead or IP Groups when possible. Azure Firewall multiples **IPs x rules**, and that can make you to achieve the 10k recommended rules limit.

## Security

- Understand rule processing logic
  - Azure Firewall has NAT rules, network rules, and applications rules. The rules are processed according to the rule type. See more at: [Azure Firewall rule processing logic](/azure/firewall/rule-processing) and [Azure Firewall Manager rule processing logic](/azure/firewall-manager/rule-processing)
- Use FQDN filtering in network rules
  - You can use FQDNs in network rules based on DNS resolution in Azure Firewall and Firewall policy. This capability allows you to filter outbound traffic with any TCP/UDP protocol (including NTP, SSH, RDP, and more). You must enable DNS Proxy to use FQDNs in your network rules. See how it works: [Azure Firewall FQDN filtering in network rules](/azure/firewall/fqdn-filtering-network-rules#how-it-works)
- If filtering inbound Internet traffic with Azure Firewall policy DNAT, for security reasons, the recommended approach is to add a specific Internet source to allow DNAT access to the network and avoid using wildcards.
- Use Azure Firewall to secure Private Endpoints (Virtual WAN scenario). See more at: [Secure traffic destined to private endpoints in Azure Virtual WAN](/azure/firewall-manager/private-link-inspection-secure-virtual-hub)
- Configure threat intelligence:
  - Threat intelligence-based filtering can be configured for your Azure Firewall policy to alert and deny traffic from and to known malicious IP addresses and domains. See more at: [Azure Firewall threat intelligence configuration](/azure/firewall-manager/threat-intelligence-settings)
- Use Azure Firewall Manager
  - Azure Firewall Manager is a security management service that provides central security policy and route management for cloud-based security perimeters.
    - Central Azure Firewall deployment and configuration
    - Hierarchical policies (global and local)
    - Integrated with third-party security-as-a-service for advanced security
    - Centralized route management
  - Understand how Policies are applied: [Azure Firewall Manager policy overview](/azure/firewall-manager/policy-overview#hierarchical-policies)
  - Use Azure Firewall policy to define a rule hierarchy: [Use Azure Firewall policy to define a rule hierarchy](/azure/firewall-manager/rule-hierarchy)
- Use Azure Firewall Premium
  - Azure Firewall Premium is a next generation firewall with capabilities that are required for highly sensitive and regulated environments. It includes the following features:
    - TLS inspection - decrypts outbound traffic, processes the data, then encrypts the data and sends it to the destination.
    - IDPS - A network intrusion detection and prevention system (IDPS) allows you to monitor network activities for malicious activity, log information about this activity, report it, and optionally attempt to block it.
    - URL filtering - extends Azure Firewall’s FQDN filtering capability to consider an entire URL. For example, www.contoso.com/a/c instead of www.contoso.com.
    - Web categories - administrators can allow or deny user access to website categories such as gambling websites, social media websites, and others.
  - See more at [Azure Firewall Premium Preview features](/azure/firewall/premium-features).
- Deploy a security partner provider
  - Security partner providers in Azure Firewall Manager allow you to use your familiar, best-in-breed, third-party security as a service (SECaaS) offering to protect Internet access for your users.
  - With a quick configuration, you can secure a hub with a supported security partner, and route and filter Internet traffic from your Virtual Networks (Virtual Networks) or branch locations within a region. You can do this with automated route management, without setting up and managing User Defined Routes (UDRs).
  - The current supported security partners are Zscaler, Check Point, and iboss.
  - See more at: [Deploy an Azure Firewall Manager security partner provider](/azure/firewall-manager/deploy-trusted-security-partner)
  
 ## Next steps

 - See the [Microsoft Azure Well-Architected Framework](../../framework/index.md).
 - [What is Azure Firewall?](/azure/firewall/overview)

 ## Related resources
 
 - [Azure Firewall architecture overview](/azure/architecture/example-scenario/firewalls)
 - [Azure Well-Architected Framework review of Azure Application Gateway](/azure/architecture/networking/guide/waf-application-gateway)
 - [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway)
 - [Choose between virtual network peering and VPN gateways](/azure/architecture/reference-architectures/hybrid-networking/vnet-peering)
 - [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
 - [Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)
