Information security has always been a complex subject, and it evolves quickly with the creative ideas and implementations of attackers and security researchers.  

Security is one of the most important aspects of any architecture. It provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. Losing these assurances can negatively affect your business operations and revenue, and your organization's reputation.

Here are some broad categories to consider when you design a security system: 

![Image that shows categories to consider when you design a security system.](images/security-overview.png) 

Azure provides a wide range of security tools and capabilities. These are just some of the key security services available in Azure:
- [Microsoft Defender for Cloud](https://azure.microsoft.com/services/defender-for-cloud/). A unified infrastructure security management system that strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads in the cloud and on-premises.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory). The Microsoft cloud-based identity and access management service.  
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor). A global, scalable entry-point that uses the Microsoft global edge network to create fast, highly secure, and widely scalable web applications.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall). A cloud-native, intelligent network firewall security service that provides threat protection for your cloud workloads that run in Azure.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). A high-security secret store for tokens, passwords, certificates, API keys, and other secrets. You can also use Key Vault to create and control the encryption keys used to encrypt your data.
- [Azure Private Link](https://azure.microsoft.com/services/private-link). Enables you to access Azure PaaS services and Azure-hosted services that you own or partner services over a private endpoint in your virtual network. 
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway). An advanced web traffic load balancer that enables you to manage traffic to your web applications. 
- [Azure Policy](https://azure.microsoft.com/services/azure-policy). Helps to enforce organizational standards and to assess compliance at scale. 

For a more comprehensive description of Azure security tools and capabilities, see [End-to-end security in Azure](/azure/security/fundamentals/end-to-end).

## Introduction to security on Azure
If you're new to security on Azure, the best way to learn more is with [Microsoft Learn](https://docs.microsoft.com/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive learning for Microsoft products and more.

Here are two learning paths to get you started:

- [Microsoft Azure Fundamentals: Describe general security and network security features](/learn/paths/az-900-describe-general-security-network-security-features)

- [Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft security solutions](/learn/paths/describe-capabilities-of-microsoft-security-solutions)

## Path to production
- To secure Azure application workloads, you use protective measures like authentication and encryption in the applications themselves. You can also add security layers to the virtual machine (VM) networks that host the applications. See [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway) for an overview.
- Zero Trust is a proactive, integrated approach to security across all layers of the digital estate. It explicitly and continuously verifies every transaction, asserts least privilege, and relies on intelligence, advanced detection, and real-time response to threats.
   - For an implementation strategy for web apps, see [Zero Trust network for web applications with Azure Firewall and Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall). 
   - For an architecture that shows how to incorporate Azure AD identity and access capabilities into an overall Zero Trust security strategy, see [Azure Active Directory IDaaS in security operations](/azure/architecture/example-scenario/aadsec/azure-ad-security).
- Azure governance establishes the tooling needed to support cloud governance, compliance auditing, and automated guardrails. See [Azure governance design area guidance](/azure/cloud-adoption-framework/ready/landing-zone/design-area/governance?toc=https:%2f%2fdocs.microsoft.com%architecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%azure%2farchitecture%2fbread%2ftoc.json) for information about governing your Azure environment. 

## Best practices
The Azure Well-Architected Framework is a set of guiding tenets, based on five pillars, that you can use to improve the quality of your architectures. For information about the security pillar, see [Security design principles in Azure](/azure/architecture/framework/security/security-principles).
 
For information about security for sensitive IaaS workloads, see [Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas).

## Identity management
- [Secure OAuth 2.0 On-Behalf-Of refresh tokens for web services](/azure/architecture/example-scenario/secrets/secure-refresh-tokens)
## Threat protection 
- [Threat indicators for cyber threat intelligence in Microsoft Sentinel](/azure/architecture/example-scenario/data/sentinel-threat-intelligence)
- [Multilayered protection for Azure virtual machine access](/azure/architecture/solution-ideas/articles/multilayered-protection-azure-vm)
- [Real-time fraud detection](/azure/architecture/example-scenario/data/fraud-detection)

## Information protection
- [Confidential computing on a healthcare platform](/azure/architecture/example-scenario/confidential/healthcare-inference)
- [Homomorphic encryption with SEAL](/azure/architecture/solution-ideas/articles/homomorphic-encryption-seal)
- [SQL Managed Instance with customer-managed keys](/azure/architecture/example-scenario/data/sql-managed-instance-cmk)
- [Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)

## Discover and respond
- [Long-term security log retention with Azure Data Explorer](/azure/architecture/example-scenario/security/security-log-retention-azure-data-explorer)

## Stay current with security 
Get the latest updates on [Azure security services and features](https://azure.microsoft.com/updates/?category=security).

## Additional resources

### Example solutions 

- [Hybrid Security Monitoring using Microsoft Defender for Cloud and Microsoft Sentinel](/azure/architecture/hybrid/hybrid-security-monitoring)
- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/example-scenario/security/access-multitenant-web-app-from-on-premises)
- [Restrict interservice communications](/azure/architecture/example-scenario/service-to-service/restrict-communications)
- [Securely managed web applications](/azure/architecture/example-scenario/apps/fully-managed-secure-apps)
- [Secure your Microsoft Teams channel bot and web app behind a firewall](/azure/architecture/example-scenario/teams/securing-bot-teams-channel)
- [Web app private connectivity to Azure SQL database](/azure/architecture/example-scenario/private-web-app/private-web-app)

### AWS or GCP professionals

- **AWS**
   - [Security and identity with Azure and AWS](/azure/architecture/aws-professional/security-identity)
   - [AWS to Azure services comparison - Security](/azure/architecture/aws-professional/services#security-identity-and-access)
- [Google Cloud to Azure services comparison - Security](/azure/architecture/gcp-professional/services#security-and-identity)