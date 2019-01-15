---
title: "Fusion: Security management sample policy statements"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Security management sample policy statements

The following policy statements provide examples of how to mitigate specific business risks through design guidance, as well as the implementation of specific tools you can use for cost governance monitoring and enforcement.

### Asset classification

**Business risk**: Assets that are not correctly identified as mission critical or involving sensitive data may not receive sufficient protections, leading to potential data leaks or business disruptions.

**Policy statement**: All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance Team and the application owner prior to deployment to the cloud.

**Design guidance**: Establish [resource tagging standards](../../infrastructure/resource-tagging/overview.md) and apply them to any deployed resources using [Azure resource tags](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)  

### Data Encryption

**Business risk**: There is a risk of protected data being exposed during storage.

**Policy statement**: All protected data must be encrypted when at rest.

**Design guidance**: See the [Azure encryption overview](https://docs.microsoft.com/en-us/azure/security/security-azure-encryption-overview) article for a discussion od how data at rest encryption is performed on the Azure platform.  

### Network isolation

**Business risk**: Connectivity between networks and subnets within networks introduces potential vulnerabilities that can result in data leaks or disruption of mission critical services.

**Policy statement**: Network subnets containing protected data must be isolated from any other subnets. Network traffic between protected data subnets is to be audited regularly.

**Design guidance**: In Azure, network and subnet isolation is managed through [Azure Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview). 

### Secure external access

**Business risk**: Allowing access to workloads from the public internet introduces a risk of external intrusion resulting in unauthorized data exposure.

**Policy statement**: No subnet containing protected data can be directly accessed over public internet or across data centers. Access to those subnets must be routed through intermediate subnet works. All access into those subnets must come through a firewall solution capable of performing packet scanning and blocking functions.

**Design guidance**: In Azure, secure public endpoints by deploying a [DMZ between the public internet and your cloud-based network](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-dmz).

### DDoS Protection

**Business risk**:  Distributed denial of service (DDoS) attacks can result in a business interruption.

**Policy statement**: Deploy automated DDoS mitigation mechanisms to all publicly accessible network endpoints.

**Design guidance**: In Azure, use [Azure DDoS Protection](https://docs.microsoft.com/en-us/azure/virtual-network/ddos-protection-overview).

### Secure on-premises connectivity

**Business risk**:  Unencrypted traffic between your cloud network and on-premises over the public internet is vulnerable to interception, introducing the risk of protected data exposure.

**Policy statement**: All connections between the on-premises and cloud networks must take place either through a secure encrypted VPN connection or a dedicated private WAN link. 

**Design guidance**: In Azure, use ExpressRoute or Azure VPN to establish private connections between you on-premises and cloud networks.

### Network monitoring and enforcement

**Business risk**: Changes to network configuration can lead to new vulnerabilities and data exposure risks.

**Policy statement**: Governance tooling must audit and enforce network configuration requirements defined by the security management team.

**Design guidance**: In Azure, network activity can be monitored using [Network Monitor](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview), and [Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-network-recommendations) can help identify security vulnerabilities. Azure Policy allows you to restrict network resources and resource configuration policy according to limits defined by the security team.

### Security review

**Business risk**: Over time new security threats and attack types emerge, increasing the risk of exposure or disruption of your cloud resources.

**Policy statement**: Trends and potential exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to security management tooling used in the cloud.

**Design guidance**: Establish a regular security review meeting that includes relevant IT and governance team members. Review existing security data and metrics to establish gaps in current policy and security management tooling, and update policy to mitigate any new risks.

## Next steps

Use the samples mentioned in this article as a starting point to develop policies that address specific business risks that align with your cloud adoption plans.

To begin developing your own custom policy statements related to cost management, download the [Cost Management template](template.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns with your environment. Then modify the design to incorporate your specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)
