---
title: Get Started with Security Architecture Design
description: Get an overview of Azure security technologies and security architecture design, including solution ideas and reference architectures.
ms.author: anaharris
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ms.date: 04/25/2026
ai-usage: ai-assisted
---

# Get started with security architecture design

Security is one of the most important aspects of any architecture. Effective security measures protect the confidentiality, integrity, and availability of your data and systems from deliberate attacks and abuse.

Azure provides many security tools and capabilities, including the following key services:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) provides cloud security posture management (CSPM) and cloud workload protection (CWP). It assesses your resources for security compliance, provides a secure score to track your posture, and offers threat protection across Azure, on-premises, and multicloud workloads.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is the Microsoft cloud-based identity and access management service. It provides single sign-on (SSO), multifactor authentication, and conditional access to guard against identity-based attacks.

- [Azure Front Door](/azure/frontdoor/front-door-overview) is a global entry point for web applications. It provides a built-in web application firewall (WAF) to protect against common exploits and vulnerabilities, DDoS protection, and Transport Layer Security (TLS) termination at the edge.

- [Azure Firewall](/azure/firewall/overview) is a cloud-native network firewall that supports threat intelligence-based filtering, intrusion detection and prevention (IDPS) in the Premium tier, TLS inspection, and fully qualified domain name (FQDN)-based rules.

- [Azure Key Vault](/azure/key-vault/general/overview) provides centralized secrets management, key management, and certificate management. The Premium tier offers hardware security module (HSM)-protected keys validated to Federal Information Processing Standards (FIPS) 140-3 level 3.

- [Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) solutions over a private endpoint in your virtual network. This approach keeps traffic on the Microsoft backbone network and eliminates exposure to the public internet.

- [Azure Application Gateway](/azure/application-gateway/overview) is a regional web traffic load balancer that includes a WAF that protects against the Open Worldwide Application Security Project (OWASP) Top 10 vulnerabilities, bot mitigation, and custom rules.

- [Azure Policy](/azure/governance/policy/overview) enables you to enforce organizational standards, assess compliance at scale, and apply guardrails that prevent noncompliant resource configurations.

For more information about Azure security tools and capabilities, see [End-to-end security in Azure](/azure/security/fundamentals/end-to-end).

## Architecture

:::image type="complex" source="images/security-get-started-diagram.svg" alt-text="Diagram that shows a baseline security implementation on Azure." border="false" lightbox="images/security-get-started-diagram.svg":::
On the left, users (User, Admin, and Developer) connect to Azure. The center shows a security hub virtual network that contains Azure Firewall Premium in its own subnet, a VPN Gateway in a VPN Gateway subnet, Azure Bastion in an Azure Bastion subnet, and Azure DDoS Protection. This hub connects to a workload spoke virtual network on the right, which contains a three-tier application architecture. The application architecture consists of an Application Gateway subnet with AppGw (WAF), a front-end tier subnet with two VMs protected by ASGs and an NSG, an app tier subnet with two VMs protected by ASGs and an NSG, and a data tier subnet with two VMs protected by ASGs and an NSG. Dotted lines in the spoke indicate access to the requested VM through the security layers. Below the hub-and-spoke architecture, the Azure storage services section contains Azure Blob Storage and Azure Files. To the right, common PaaS services section includes Microsoft Entra ID, Microsoft Defender for Cloud, RBAC, Azure Monitor, and Azure Key Vault. At the bottom, an on-premises datacenter section shows a router, admin users, AD DS, Microsoft Entra Connect, and an on-premises app. Arrows throughout the diagram illustrate traffic flows and secure connectivity paths between all components.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/security-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical baseline security implementation. The architecture shows how Azure security services work together to protect workloads across identity, networking, data, and application layers. For real-world solutions that you can build in Azure, see [Example solutions](#example-solutions).

## Learn about security on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training for Azure security technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for security implementations on Azure.

**Security fundamentals:** The following learning paths cover core security concepts and Azure security features:

- [Introduction to security, compliance, and identity concepts](/training/paths/describe-concepts-of-security-compliance-identity)
- [Introduction to Microsoft Entra](/training/paths/describe-capabilities-of-microsoft-identity-access)
- [Introduction to Microsoft security solutions](/training/paths/describe-capabilities-of-microsoft-security-solutions)

**Network security:** The following learning path covers virtual network security, network segmentation, and secure connectivity:

- [Configure secure access to your workloads by using Azure virtual networking](/training/paths/configure-secure-workloads-using-azure-virtual-networking)

**Data protection:** The following learning path covers encryption, key management, and application security:

- [Secure your cloud applications in Azure](/training/paths/secure-your-cloud-apps)

**Threat protection:** The following learning path covers threat detection, investigation, and response:

- [Mitigate threats by using Microsoft Defender for Cloud](/training/paths/sc-200-mitigate-threats-using-azure-defender)

### Learning paths by role

Microsoft Learn offers role-based certification paths for security professionals:

- [Microsoft Certified: Azure Security Engineer Associate (AZ-500)](/credentials/certifications/azure-security-engineer/)

  > [!NOTE]
  > The AZ-500 certification is retiring on August 31, 2026. Check the [certification page](/credentials/certifications/azure-security-engineer/) for the latest information.

- [Microsoft Certified: Security Operations Analyst Associate (SC-200)](/credentials/certifications/security-operations-analyst/)
- [Microsoft Certified: Cybersecurity Architect Expert (SC-100)](/credentials/certifications/cybersecurity-architect-expert/)

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. The Cloud Adoption Framework [Secure methodology](/azure/cloud-adoption-framework/secure/overview) provides a structured approach for securing your Azure cloud estate. It provides security guidance across strategy, planning, readiness, adoption, governance, and operations.

Azure governance establishes the tooling needed to support cloud governance, compliance auditing, and automated guardrails. For more information, see [Azure governance design area guidance](/azure/cloud-adoption-framework/ready/landing-zone/design-area/governance).

To help ensure the quality of your security solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions. For more information, see the [Well-Architected Framework Security pillar](/azure/well-architected/security/).

For security-specific guidance, see the following Well-Architected Framework service guides:

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall)
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)
- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door)

## Best practices

Follow these best practices to improve the security, reliability, performance, and operational quality of your security workloads on Azure:

- [Security design principles](/azure/well-architected/security/principles): Guiding principles to help you design secure workloads on Azure, based on the Zero Trust model and the CIA triad of confidentiality, integrity, and availability.

- [Security quick links](/azure/well-architected/security/): A hub page for the Well-Architected Framework Security pillar that provides links to security guidance, design patterns, and best practices.

- [Design review checklist for Security](/azure/well-architected/security/checklist): A checklist of recommendations for security design review that covers identity, networking, data protection, and governance.

- [Azure Firewall and Azure Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway): Guidance to help you protect Azure application workloads by using authentication, encryption, and network security layers with Azure Firewall and Azure Application Gateway.

- [Implement a Zero Trust network for web applications by using Azure Firewall and Azure Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall): A proactive, integrated approach to security across all layers by using Zero Trust principles and end-to-end TLS encryption and inspection.

- [Microsoft cloud security benchmark](/security/benchmark/azure/introduction): Prescriptive best practices and recommendations to help improve the security of workloads, data, and services on Azure and multicloud environments.

## Stay current with security

Azure security services evolve to address modern security challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/?category=security).

To stay current with key security services, see the following articles:

- [What's new in Microsoft Defender for Cloud](/azure/defender-for-cloud/release-notes)
- [Microsoft Entra releases and announcements](/entra/fundamentals/whats-new)
- [What's new for Azure Key Vault](/azure/key-vault/general/whats-new)
- [What's new in Microsoft Sentinel](/azure/sentinel/whats-new)
- [What's new in Azure Firewall](https://azure.microsoft.com/updates?filters=%5B%22Azure+Firewall%22%5D)
- [What's new in Azure Application Gateway](/azure/application-gateway/overview#whats-new)

## Other resources

The security category covers a range of solutions. The following resources can help you discover more about Azure.

### Example solutions

The following architecture solutions demonstrate security patterns and implementations on Azure:

- [Improved-security access to Azure App Service web apps from an on-premises network](/azure/architecture/web-apps/guides/networking/access-multitenant-web-app-from-on-premises)
- [Securely managed web applications](/azure/architecture/example-scenario/apps/fully-managed-secure-apps)
- [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)
- [Browse all security architectures](/azure/architecture/browse/?azure_categories=security)

### Product documentation

- [End-to-end security in Azure](/azure/security/fundamentals/end-to-end): An introduction to the security services in Azure, organized by protection, detection, and response capabilities.

- [Microsoft Cybersecurity Reference Architectures](/security/adoption/mcra): Diagrams that describe how Microsoft security capabilities integrate with Microsoft platforms and partner platforms by using Zero Trust principles.

### Hybrid and multicloud

Most organizations need a hybrid approach to security because their workloads, identities, and data span on-premises datacenters, Azure, and other cloud platforms. Security policies, threat detection, and compliance controls must extend across all these environments to avoid gaps that attackers can exploit. Organizations typically [extend on-premises security solutions to the cloud](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) and use [Azure Arc](/azure/azure-arc/overview) to project non-Azure resources into the Azure control plane for centralized governance. To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/).

Review the following key hybrid and multicloud security scenarios:

- [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz): A reference architecture that extends an on-premises network to Azure. It uses a perimeter network (also known as *DMZ, demilitarized zone, and screened subnet*) and Azure Firewall to control inbound and outbound traffic between on-premises and Azure environments.

- [Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking/): A comparison of hybrid network connectivity options, including Azure VPN Gateway, Azure ExpressRoute, and Azure ExpressRoute with VPN failover, that establish the secure network foundation for hybrid deployments.

- [Hybrid architecture design](/azure/architecture/hybrid/hybrid-start-here): A hub page for hybrid architectures on Azure that covers hybrid network connectivity, best practices, and reference architectures to run workloads across on-premises and Azure environments.

- [Design a hybrid DNS solution by using Azure](/azure/architecture/hybrid/hybrid-dns-infra): A reference architecture that implements a hybrid Domain Name System (DNS) solution that resolves names for workloads hosted on-premises and in Azure. This architecture uses Azure DNS Private Resolver and Azure Firewall.

- [Implement hybrid and multicloud adoption by using Azure Arc and Azure landing zones](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone): Guidance to onboard on-premises servers, Kubernetes clusters, and multicloud services into the Azure control plane by using Azure Arc. This architecture uses Microsoft Defender for Cloud to enable centralized policy enforcement, monitoring, and threat protection.

- [Integrate Azure and Microsoft Defender XDR security services](/azure/architecture/solution-ideas/articles/microsoft-365-defender-security-integrate-azure): A solution idea that integrates Microsoft Sentinel, Microsoft Defender for Cloud, and Microsoft Defender XDR to unify security monitoring and threat response across on-premises and cloud environments.

### Identity and access management

Identity is the primary security perimeter in cloud environments. In Azure, identity and access management (IAM) centers on Microsoft Entra ID as the cloud-based identity provider. Microsoft Entra Conditional Access serves as the Zero Trust policy engine. The following architectures and guides address IAM design patterns for Azure and multicloud environments:

- [Integrate on-premises Active Directory domains with Microsoft Entra ID](/azure/architecture/reference-architectures/identity/azure-ad): A reference architecture that integrates on-premises Active Directory with Microsoft Entra ID to provide cloud-based identity authentication, including Microsoft Entra Connect Sync, Microsoft Entra application proxy, and Microsoft Entra Conditional Access.

- [Identity architecture design](/azure/architecture/identity/identity-start-here): A hub page for identity architecture in Azure that covers learning paths, design options, implementation guidance, and baseline identity implementations.

- [Create an Active Directory Domain Services (AD DS) resource forest in Azure](/azure/architecture/reference-architectures/identity/adds-forest): A reference architecture that creates a separate Active Directory domain in Azure that domains in an on-premises Active Directory forest trust.

- [Deploy AD DS in an Azure virtual network](/azure/architecture/example-scenario/identity/adds-extend-domain): A reference architecture that extends an on-premises Active Directory domain to Azure to provide distributed authentication services.

- [Extend on-premises AD FS to Azure](/azure/architecture/reference-architectures/identity/adfs): A reference architecture that implements Active Directory Federation Services (AD FS) authorization in Azure as part of a secure hybrid network.

### Threat protection

Threat protection encompasses the tools, patterns, and practices that detect, prevent, and respond to security threats across Azure workloads. Azure provides layered threat protection through services such as Microsoft Defender for Cloud, Microsoft Sentinel, and Microsoft Entra ID Protection. These services use behavioral analytics, machine learning, and threat intelligence to detect threats across compute, storage, networking, identity, and application layers.

The following architectures and guides address threat protection patterns on Azure:

- [Multilayered protection for Azure virtual machine (VM) access](/azure/architecture/solution-ideas/articles/multilayered-protection-azure-vm): A defense-in-depth solution that combines Microsoft Entra Privileged Identity Management (PIM), just-in-time (JIT) VM access in Microsoft Defender for Cloud, Azure Bastion, and Azure role-based access control (Azure RBAC) custom roles to minimize the attack surface for VM management.

- [Build the first layer of defense by using Azure security services](/azure/architecture/solution-ideas/articles/azure-security-build-first-layer-defense): A solution idea that maps Azure security services to resources and threat types by using the MITRE ATT&CK framework. This article organizes Azure security services by network, infrastructure, application, data, and identity layers.

- [Map threats to your IT environment](/azure/architecture/solution-ideas/articles/map-threats-it-environment): Guidance that helps you diagram your IT environment and create a threat map by using the MITRE ATT&CK framework. It covers on-premises, Azure, and Microsoft 365 environments.

- [Integrate Azure and Microsoft Defender XDR security services](/azure/architecture/solution-ideas/articles/microsoft-365-defender-security-integrate-azure): A solution idea that demonstrates how to integrate Microsoft Sentinel, Microsoft Defender for Cloud, and Microsoft Defender XDR for unified security monitoring and threat response across on-premises and cloud environments.

- [Microsoft Sentinel automated responses](/azure/architecture/solution-ideas/articles/microsoft-sentinel-automated-response): A solution idea that uses Microsoft Sentinel playbooks and Azure Logic Apps to automate threat response, including blocking compromised users and isolating endpoints.

- [Apply Zero Trust principles to VMs in Azure](/security/zero-trust/azure-infrastructure-virtual-machines): Step-by-step guidance to apply Zero Trust principles to Azure VMs, including logical isolation, RBAC, secure boot, encryption, secure access by using Azure Bastion, and advanced threat detection by using Microsoft Defender for Servers.

- [Azure threat protection](/azure/security/fundamentals/threat-detection): An overview of Azure threat protection services, including Microsoft Defender for Cloud, Microsoft Sentinel, Microsoft Entra ID Protection, Microsoft Defender for Cloud Apps, and Azure Firewall.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure security options to other cloud services.

### Service comparison

- [Compare AWS and Azure identity management solutions](/azure/architecture/aws-professional/security-identity): A detailed comparison of AWS and Azure identity services, including core identity, authentication, access control, privileged access management, and application identity patterns.

- [AWS to Azure services comparison - Security, identity, and access](/azure/architecture/aws-professional/#security): A comparison of AWS and Azure security services, including identity and access management, encryption, firewalls, threat detection, security information and event management (SIEM), and DDoS protection.

- [Google Cloud to Azure services comparison - Security and identity](/azure/architecture/gcp-professional/services#security-and-identity): A comparison of Google Cloud and Azure security services. It covers authentication, encryption, key management, threat detection, SIEM, container security, and data loss prevention (DLP).

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security): Guidance to deploy Microsoft Entra identity and access solutions for AWS, including single sign-on (SSO), multifactor authentication (MFA), Microsoft Entra Conditional Access, and Microsoft Entra Privileged Identity Management (PIM) for AWS accounts.

### Migration guidance

If you're migrating from another cloud platform, see the following articles:

- [Migrate security services from AWS](/azure/migration/migrate-security-from-aws): Guidance to migrate AWS security services to Azure, including SIEM migration to Microsoft Sentinel and customer identity migration to Microsoft Entra External ID.

- [Migrate workloads to Azure from other cloud platforms](/azure/migration/migrate-to-azure): An overview of the end-to-end workload migration process from AWS and Google Cloud to Azure, including planning, preparation, and execution phases.