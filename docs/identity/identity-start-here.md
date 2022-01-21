# Identity architecture design

Identity solutions are part of identity and access management (IAM), a framework for protecting data and resources. In on-premises systems, internal networks provide security boundaries. Public cloud systems rely on IAM for boundary security.

IAM provides a way to identify accounts and regulate what they can do when interacting with resources. Identities exist for user accounts and for accounts that devices, applications, and service principles use. IAM includes components that support the authentication and authorization of these identities. The process of authentication identifies users. Authorization determines what users can do in applications.

Azure offers a comprehensive set of services, tools, and reference architectures for developing secure, operationally efficient identity solutions.

## Introduction to identity on Azure

If you're new to IAM, the best place to start is with Microsoft Learn. Microsoft Learn is a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services. The following resources can help you build foundational knowledge of IAM and take you through core concepts.

### Learning paths

- [Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions][Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions]
- [Implement Microsoft identity – Associate][Implement Microsoft identity – Associate]
- [SC-300: Implement an identity management solution][SC-300: Implement an identity management solution]
- [MS-500 part 1 - Implement and manage identity and access][MS-500 part 1 - Implement and manage identity and access]

### Modules

- [Describe identity concepts][Describe identity concepts]
- [Explore the Microsoft identity platform][Explore the Microsoft identity platform]

## Path to production

After you understand the importance of identity management, the next step is to design your solution. This process involves comparing products and services while determining which components to use. To explore options for identity solutions, consult these resources:

- For a comparison of three services that provide applications, services, or devices with access to a central identity, see [Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services][Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services].

- To learn how to make IAM resilient, see [Resilient identity and access management with Azure AD][Resilient identity and access management with Azure AD].

- To compare options for reducing latency when integrating your on-premises Active Directory (AD) environment with an Azure network, see [Integrate on-premises AD with Azure][Integrate on-premises AD with Azure].

- Add description. See [Azure billing offers and Active Directory tenants][Azure billing offers and Active Directory tenants].

- Evaluates options for an identity and access foundation. Examines IAM design considerations and recommendations in a cloud environment, see [Azure identity and access management design area][Azure identity and access management design area].

- To explore ways to organize resources that you deploy to the cloud, see [Resource organization][Resource organization].

- Descriptions of different methods and a comparison (password hash, pass-through auth, federation) of options that support access to cloud apps, see [Choose the right authentication method for your Azure Active Directory hybrid identity solution][Choose the right authentication method for your Azure Active Directory hybrid identity solution].

- For add description, see [How Azure AD Delivers Cloud Governed Management for On-Premises Workloads][How Azure AD Delivers Cloud Governed Management for On-Premises Workloads].

- To learn how Description of Azure AD Connect: It integrates on-premises directories with Azure AD, see [What is Azure AD Connect?][What is Azure AD Connect?].

When you've decided on an approach, implementation comes next. To learn how to deploy identity solutions, use these resources:

- For a series of articles that explain how to manage user identities when you're building a multitenant application and include code, see [Identity management in multitenant applications][Identity management in multitenant applications].

- For information on deploying Azure Active Directory (Azure AD), see these resources:

  - [Azure Active Directory feature deployment guide][Azure Active Directory feature deployment guide]
  - [Azure Active Directory deployment plans][Azure Active Directory deployment plans]
  - [Azure Active Directory B2C deployment plans][Azure Active Directory B2C deployment plans]

- To learn how to use Azure AD and OAuth 2.0 to secure a single-page application, see [Secure development with single-page applications (SPAs)][Secure development with single-page applications (SPAs)].

## Best practices

- Azure AD can boost productivity through automation, delegation, self-service, and single sign-on capabilities. For general information on benefitting from this functionality, see [Four steps to a strong identity foundation with Azure Active Directory][Four steps to a strong identity foundation with Azure Active Directory].

- To check whether your Azure AD implementation aligns with the Azure Security Benchmark version 2.0, see [Azure security baseline for Azure Active Directory][Azure security baseline for Azure Active Directory].

- Some solutions use private endpoints in tenants to connect to Azure services. To see guidelines for specific security issues that come up with private endpoints, see [Limit cross-tenant private endpoint connections in Azure][Limit cross-tenant private endpoint connections in Azure].

- For recommendations for the following scenarios, see [Integrate on-premises AD domains with Azure AD][Integrate on-premises AD domains with Azure AD]:

  - Deploying web apps in Azure that provide access to remote users who belong to your organization.
  - Implementing self-service capabilities for end users.
  - Using an on-premises network and a virtual network that aren't connected by a VPN tunnel or ExpressRoute circuit.

- For general information and guidelines on migrating applications to Azure AD, see these resources:

  - [Move application authentication to Azure Active Directory][Move application authentication to Azure Active Directory]
  - [Migrate application authentication to Azure Active Directory][Migrate application authentication to Azure Active Directory]
  - [Review the application activity report][Review the application activity report]
  - [Resources for migrating applications to Azure Active Directory][Resources for migrating applications to Azure Active Directory]









[Azure Active Directory B2C deployment plans]: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/azure-active-directory-b2c-deployment-plans
[Azure Active Directory deployment plans]: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-deployment-plans
[Azure Active Directory feature deployment guide]: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-deployment-checklist-p2
[Azure billing offers and Active Directory tenants]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-ad-tenant
[Azure identity and access management design area]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access
[Azure security baseline for Azure Active Directory]: https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/aad-security-baseline
[Choose the right authentication method for your Azure Active Directory hybrid identity solution]: https://docs.microsoft.com/en-us/azure/active-directory/hybrid/choose-ad-authn
[Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services]: https://docs.microsoft.com/en-us/azure/active-directory-domain-services/compare-identity-solutions
[Describe identity concepts]: https://docs.microsoft.com/en-us/learn/modules/describe-identity-principles-concepts/
[Explore the Microsoft identity platform]: https://docs.microsoft.com/en-us/learn/modules/explore-microsoft-identity-platform/
[Four steps to a strong identity foundation with Azure Active Directory]: https://docs.microsoft.com/en-us/azure/active-directory/hybrid/four-steps
[How Azure AD Delivers Cloud Governed Management for On-Premises Workloads]: https://docs.microsoft.com/en-us/azure/active-directory/hybrid/cloud-governed-management-for-on-premises
[Identity management in multitenant applications]: https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/
[Implement Microsoft identity – Associate]: https://docs.microsoft.com/en-us/learn/paths/m365-identity-associate/
[Integrate on-premises AD with Azure]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/identity/
[Integrate on-premises AD domains with Azure AD]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/identity/azure-ad
[Limit cross-tenant private endpoint connections in Azure]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/limit-cross-tenant-private-endpoint-connections
[Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions]: https://docs.microsoft.com/en-us/learn/paths/describe-capabilities-of-microsoft-identity-access/
[Migrate application authentication to Azure Active Directory]: https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/migrate-application-authentication-to-azure-active-directory
[Move application authentication to Azure Active Directory]: https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/migrate-adfs-apps-to-azure
[MS-500 part 1 - Implement and manage identity and access]: https://docs.microsoft.com/en-us/learn/paths/implement-manage-identity-access/
[Resilient identity and access management with Azure AD]: https://docs.microsoft.com/en-us/azure/architecture/guide/resilience/resilience-overview
[Resource organization]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[Resources for migrating applications to Azure Active Directory]: https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/migration-resources
[Review the application activity report]: https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/migrate-adfs-application-activity
[SC-300: Implement an identity management solution]: https://docs.microsoft.com/en-us/learn/paths/implement-identity-management-solution/
[Secure development with single-page applications (SPAs)]: https://docs.microsoft.com/en-us/azure/architecture/guide/resilience/azure-ad-secure-single-page-application
[What is Azure AD Connect?]: https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect
