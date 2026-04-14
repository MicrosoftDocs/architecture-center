---
title: Get started with security architecture design
description: Get an overview of Azure security technologies and cloud desktop design, including architecture guidance, solution ideas, and reference architectures.
ms.author: anaharris
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 04/14/2026
ai-usage: ai-assisted
---

# Get started with security architecture design

Security is one of the most important aspects of any architecture. Good security provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems.

Azure provides a wide range of security tools and capabilities. The following list describes some of the key security services available on Azure:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction). Provides cloud security posture management (CSPM) and cloud workload protection (CWPP). It assesses your resources for security compliance, provides a secure score to track your posture, and offers threat protection across Azure, on-premises, and multicloud workloads.
- [Microsoft Entra ID](/entra/fundamentals/whatis). The Microsoft cloud-based identity and access management service. It provides single sign-on, multifactor authentication, and conditional access to guard against identity-based attacks.
- [Azure Front Door](/azure/frontdoor/front-door-overview). A global entry point for web applications that includes a built-in web application firewall (WAF) to protect against common exploits and vulnerabilities, DDoS protection, and TLS termination at the edge.
- [Azure Firewall](/azure/firewall/overview). A cloud-native network firewall that supports threat intelligence-based filtering, intrusion detection and prevention (IDPS) in the Premium tier, TLS inspection, and FQDN-based rules.
- [Azure Key Vault](/azure/key-vault/general/overview). Provides centralized secrets management, key management, and certificate management. The Premium tier offers HSM-protected keys validated to FIPS 140-3 Level 3.
- [Azure Private Link](/azure/private-link/private-link-overview). Enables you to access Azure PaaS services over a private endpoint in your virtual network, keeping traffic on the Microsoft backbone network and eliminating exposure to the public internet.
- [Azure Application Gateway](/azure/application-gateway/overview). A regional web traffic load balancer with an integrated web application firewall (WAF v2) that protects against OWASP top-10 vulnerabilities, bot mitigation, and custom rules.
- [Azure Policy](/azure/governance/policy/overview). Enables you to enforce organizational standards, assess compliance at scale, and apply guardrails that prevent noncompliant resource configurations.

For more information about Azure security tools and capabilities, see [End-to-end security in Azure](/azure/security/fundamentals/end-to-end).

## Architecture

:::image type="content" source="images/security-get-started-diagram.png" alt-text="Diagram that shows a baseline security implementation on Azure." border="false":::

*Download a [Visio file]() of this architecture.*

The previous diagram demonstrates a typical baseline security implementation. The architecture shows how Azure security services work together to protect workloads across identity, networking, data, and application layers. For real-world solutions that you can build in Azure, see [Security architectures](#example-solutions).

## Explore security architectures and guides

## Learn about security on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training for Azure security technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for security implementations on Azure:

**Security fundamentals:** These learning paths cover core security concepts and Azure security features:

- [Introduction to security, compliance, and identity concepts](/training/paths/describe-concepts-of-security-compliance-identity)
- [Introduction to Microsoft Entra](/training/paths/describe-capabilities-of-microsoft-identity-access)
- [Introduction to Microsoft security solutions](/training/paths/describe-capabilities-of-microsoft-security-solutions)

**Network security:** This learning path covers virtual network security, network segmentation, and secure connectivity:

- [Configure secure access to your workloads using Azure virtual networking](/training/paths/configure-secure-workloads-using-azure-virtual-networking)

**Data protection:** This learning path covers encryption, key management, and application security:

- [Secure your cloud applications in Azure](/training/paths/secure-your-cloud-apps)

**Threat protection:** This learning path covers threat detection, investigation, and response:

- [Mitigate threats using Microsoft Defender for Cloud](/training/paths/sc-200-mitigate-threats-using-azure-defender)

### Learning paths by role

Microsoft Learn offers role-based certification paths for security professionals:

- [Microsoft Certified: Azure Security Engineer Associate (AZ-500)](/credentials/certifications/azure-security-engineer/)

  > [!NOTE]
  > The AZ-500 certification is retiring on August 31, 2026. Check the [certification page](/credentials/certifications/azure-security-engineer/) for the latest information.

- [Microsoft Certified: Security Operations Analyst Associate (SC-200)](/credentials/certifications/security-operations-analyst/)
- [Microsoft Certified: Cybersecurity Architect Expert (SC-100)](/credentials/certifications/cybersecurity-architect-expert/)

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. The Cloud Adoption Framework [Secure methodology](/azure/cloud-adoption-framework/secure/overview) provides a structured approach for securing your Azure cloud estate, covering security across strategy, planning, readiness, adoption, governance, and operations.

Azure governance establishes the tooling needed to support cloud governance, compliance auditing, and automated guardrails. For information about governing your Azure environment, see [Azure governance design area guidance](/azure/cloud-adoption-framework/ready/landing-zone/design-area/governance).

To help ensure the quality of your security solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions. For security-specific guidance, see the Well-Architected Framework [Security pillar](/azure/well-architected/security/).

For security-specific guidance, see the following Well-Architected Framework service guides:

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall)
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)
- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door)

## Best practices

Follow these best practices to improve the security, reliability, performance, and operational quality of your security workloads on Azure.

- [Security design principles](/azure/well-architected/security/principles): Guiding principles for designing secure workloads on Azure, based on the Zero Trust model and the CIA triad of confidentiality, integrity, and availability.

- [Security quick links](/azure/well-architected/security/): A hub page for the Well-Architected Framework Security pillar, providing links to security guidance, design patterns, and best practices.

- [Design review checklist for Security](/azure/well-architected/security/checklist): A checklist of recommendations for security design review, covering identity, networking, data protection, and governance.

- [Azure Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway): Guidance for protecting Azure application workloads by using authentication, encryption, and network security layers with Azure Firewall and Application Gateway.

- [Implement a Zero Trust network for web applications by using Azure Firewall and Azure Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall): A proactive, integrated approach to security across all layers using Zero Trust principles with end-to-end TLS encryption and inspection.

- [Microsoft cloud security benchmark](/security/benchmark/azure/introduction): Prescriptive best practices and recommendations to help improve the security of workloads, data, and services on Azure and multicloud environments.

## Stay current with security

Azure security services evolve to address modern security challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/?category=security).

To stay current with key security services, see the following articles:

- [What's new in Microsoft Defender for Cloud](/azure/defender-for-cloud/release-notes)
- [Microsoft Entra releases and announcements](/entra/fundamentals/whats-new)
- [What's new for Azure Key Vault](/azure/key-vault/general/whats-new)
- [What's new in Microsoft Sentinel](/azure/sentinel/whats-new)
- [What's new in Azure Firewall](https://azure.microsoft.com/updates?filters=%5B%22Azure+Firewall%22%5D)
- [What's new in Azure Application Gateway](/azure/application-gateway/whats-new)

### Other resources

Security is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Example solutions

These architecture solutions demonstrate security patterns and implementations on Azure:

- [Improved-security access to App Service web apps from an on-premises network](/azure/architecture/web-apps/guides/networking/access-multitenant-web-app-from-on-premises)
- [Securely managed web applications](/azure/architecture/example-scenario/apps/fully-managed-secure-apps)
- [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)
- [Browse all security architectures](/azure/architecture/browse/?azure_categories=security)

### Product documentation

- [End-to-end security in Azure](/azure/security/fundamentals/end-to-end): An introduction to the security services in Azure, organized by protection, detection, and response capabilities.

- [Microsoft Cybersecurity Reference Architectures](/security/adoption/mcra): Diagrams that describe how Microsoft security capabilities integrate with Microsoft platforms and third-party platforms, using Zero Trust principles.

## Hybrid and multicloud

Most organizations need a hybrid approach to security because their workloads, identities, and data span on-premises datacenters, Azure, and other cloud platforms. Security policies, threat detection, and compliance controls must extend across all of these environments to avoid gaps that attackers can exploit. Organizations typically [extend on-premises security solutions to the cloud](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) and use [Azure Arc](/azure/azure-arc/overview) to project non-Azure resources into the Azure control plane for centralized governance. To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/).

Review the following key hybrid and multicloud security scenarios:

- [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz). A reference architecture that extends an on-premises network to Azure using a perimeter network (DMZ) with Azure Firewall to control all inbound and outbound traffic between on-premises and Azure environments.

- [Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking/). A comparison of hybrid network connectivity options, including VPN Gateway, Azure ExpressRoute, and ExpressRoute with VPN failover, that establish the secure network foundation for hybrid deployments.

- [Hybrid architecture design](/azure/architecture/hybrid/hybrid-start-here). A hub page for hybrid architectures on Azure that covers hybrid network connectivity, best practices, and reference architectures for running workloads across on-premises and Azure environments.

- [Design a hybrid DNS solution with Azure](/azure/architecture/hybrid/hybrid-dns-infra). A reference architecture for implementing a hybrid Domain Name System (DNS) solution that resolves names for workloads hosted on-premises and in Azure, using Azure DNS Private Resolver and Azure Firewall.

- [Implement hybrid and multicloud adoption with Azure Arc and Azure landing zones](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone). Guidance for onboarding on-premises servers, Kubernetes clusters, and multicloud services into the Azure control plane using Azure Arc, enabling centralized policy enforcement, monitoring, and threat protection with Microsoft Defender for Cloud.

- [Integrate Azure and Microsoft Defender XDR security services](/azure/architecture/solution-ideas/articles/microsoft-365-defender-security-integrate-azure). A solution idea that demonstrates how to integrate Microsoft Sentinel, Microsoft Defender for Cloud, and Microsoft Defender XDR for unified security monitoring and threat response across on-premises and cloud environments.

### Identity and access management

Identity is the primary security perimeter in cloud environments. In Azure, identity and access management (IAM) centers on Microsoft Entra ID as the cloud-based identity provider, with Conditional Access serving as the Zero Trust policy engine. The following architectures and guides address IAM design patterns for Azure and multicloud environments.

- [Integrate on-premises Active Directory domains with Microsoft Entra ID](/azure/architecture/reference-architectures/identity/azure-ad). A reference architecture for integrating on-premises Active Directory with Microsoft Entra ID to provide cloud-based identity authentication, including Microsoft Entra Connect Sync, application proxy, and Conditional Access.
- [Identity architecture design](/azure/architecture/identity/identity-start-here). A hub page for identity architecture in Azure that covers learning paths, design options, implementation guidance, and baseline identity implementations.
- [Create an AD DS resource forest in Azure](/azure/architecture/reference-architectures/identity/adds-forest). A reference architecture for creating a separate Active Directory domain in Azure that is trusted by domains in an on-premises Active Directory forest.
- [Deploy AD DS in an Azure virtual network](/azure/architecture/example-scenario/identity/adds-extend-domain). A reference architecture for extending an on-premises Active Directory domain to Azure to provide distributed authentication services.
- [Extend on-premises AD FS to Azure](/azure/architecture/reference-architectures/identity/adfs). A reference architecture for implementing Active Directory Federation Services (AD FS) authorization in Azure as part of a secure hybrid network.

### Threat protection

Threat protection encompasses the tools, patterns, and practices that detect, prevent, and respond to security threats across Azure workloads. Azure provides layered threat protection through services such as Microsoft Defender for Cloud, Microsoft Sentinel, and Microsoft Entra ID Protection. These services use behavioral analytics, machine learning, and threat intelligence to detect threats across compute, storage, networking, identity, and application layers.

The following architectures and guides address threat protection patterns on Azure:

- [Multilayered protection for Azure virtual machine access](/azure/architecture/solution-ideas/articles/multilayered-protection-azure-vm). A defense-in-depth solution that combines Microsoft Entra Privileged Identity Management (PIM), just-in-time (JIT) VM access in Microsoft Defender for Cloud, Azure Bastion, and Azure RBAC custom roles to minimize the attack surface for virtual machine management.

- [Build the first layer of defense with Azure Security services](/azure/architecture/solution-ideas/articles/azure-security-build-first-layer-defense). A solution idea that maps Azure security services to resources and threat types using the MITRE ATT&CK framework, organized by network, infrastructure, application, data, and identity layers.
- [Map threats to your IT environment](/azure/architecture/solution-ideas/articles/map-threats-it-environment). Guidance for diagramming your IT environment and creating a threat map using the MITRE ATT&CK framework, covering on-premises, Azure, and Microsoft 365 environments.
- [Integrate Azure and Microsoft Defender XDR security services](/azure/architecture/solution-ideas/articles/microsoft-365-defender-security-integrate-azure). A solution idea that demonstrates how to integrate Microsoft Sentinel, Microsoft Defender for Cloud, and Microsoft Defender XDR for unified security monitoring and threat response across on-premises and cloud environments.
- [Microsoft Sentinel automated responses](/azure/architecture/solution-ideas/articles/microsoft-sentinel-automated-response). A solution idea that uses Microsoft Sentinel playbooks and Azure Logic Apps to automate threat response, including blocking compromised users and isolating endpoints.
- [Apply Zero Trust principles to virtual machines in Azure](/security/zero-trust/azure-infrastructure-virtual-machines). Step-by-step guidance for applying Zero Trust principles to Azure virtual machines, including logical isolation, RBAC, secure boot, encryption, secure access with Azure Bastion, and advanced threat detection with Microsoft Defender for Servers.

- [Azure threat protection](/azure/security/fundamentals/threat-detection). A comprehensive overview of Azure threat protection services, including Microsoft Defender for Cloud, Microsoft Sentinel, Microsoft Entra ID Protection, Microsoft Defender for Cloud Apps, and Azure Firewall.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure security options to those of other cloud services:

### Service comparison

- [Compare AWS and Azure identity management solutions](/azure/architecture/aws-professional/security-identity). A detailed comparison of AWS and Azure identity services, including core identity, authentication, access control, privileged access management, and application identity patterns.

- [AWS to Azure services comparison — Security, identity, and access](/azure/architecture/aws-professional/#security). A comparison of AWS and Azure security services, including identity and access management, encryption, firewalls, threat detection, SIEM, and DDoS protection.

- [Google Cloud to Azure services comparison — Security and identity](/azure/architecture/gcp-professional/services#security-and-identity). A comparison of Google Cloud and Azure security services, covering authentication, encryption, key management, threat detection, SIEM, container security, and DLP.

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security). Guidance for deploying Microsoft Entra identity and access solutions for AWS, including single sign-on (SSO), multifactor authentication (MFA), Conditional Access, and Privileged Identity Management (PIM) for AWS accounts.

### Migration guidance

If you're migrating from another cloud platform, see the following articles:

- [Migrate security services from AWS](/azure/migration/migrate-security-from-aws). Guidance for migrating AWS security services to Azure, including SIEM migration to Microsoft Sentinel and customer identity migration to Microsoft Entra External ID.

- [Migrate workloads to Azure from other cloud platforms](/azure/migration/migrate-to-azure). An overview of the end-to-end workload migration process from AWS and Google Cloud to Azure, including planning, preparation, and execution phases.