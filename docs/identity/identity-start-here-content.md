Identity and access management (IAM) architectures provide frameworks for protecting data and resources. Internal networks establish security boundaries in on-premises systems. In cloud environments, perimeter networks and firewalls aren't sufficient for managing access to apps and data. Instead, public cloud systems rely on identity solutions for boundary security.

An identity solution controls access to an organization's apps and data. Users, devices, and applications have identities. IAM components support the authentication and authorization of these and other identities. The process of authentication controls who or what uses an account. Authorization controls what that user can do in applications.

Whether you're just starting to evaluate identity solutions or looking to expand your current implementation, Azure offers many options. One example is Azure Active Directory (Azure AD), a cloud service that provides identity management and access control capabilities. To decide on a solution, start by learning about this service and other Azure components, tools, and reference architectures.

:::image type="content" source="./media/identity-basic-architecture.png" alt-text="Architecture diagram that shows Azure A D in a cloud environment. Connections to apps, devices, and other components are also visible." border="false":::

## Introduction to identity on Azure

If you're new to IAM, the best place to start is with Microsoft Learn. This free online training platform offers videos, tutorials, and hands-on learning for various products and services.

The following resources can help you learn the core concepts of IAM.

### Learning paths

- [Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions][Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions]
- [Implement Microsoft identity – Associate][Implement Microsoft identity – Associate]
- [SC-300: Implement an identity management solution][SC-300: Implement an identity management solution]
- [MS-500 part 1 - Implement and manage identity and access][MS-500 part 1 - Implement and manage identity and access]

### Modules

- [Describe identity concepts][Describe identity concepts]
- [Explore the Microsoft identity platform][Explore the Microsoft identity platform]

## Path to production

After you've covered the fundamentals of identity management, the next step is to develop your solution.

### Design

To explore options for identity solutions, consult these resources:

- For a comparison of three services that provide access to a central identity, see [Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services][Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services].

- To learn how to make IAM resilient, see [Resilient identity and access management with Azure AD][Resilient identity and access management with Azure AD].

- To compare options for reducing latency when integrating with an Azure network, see [Integrate on-premises AD with Azure][Integrate on-premises AD with Azure].

- For information on associating billing offers with an Azure AD tenant, see [Azure billing offers and Active Directory tenants][Azure billing offers and Active Directory tenants].

- To evaluate options for an identity and access foundation, see [Azure identity and access management design area][Azure identity and access management design area].

- To explore ways to organize resources that you deploy to the cloud, see [Resource organization][Resource organization].

- For a comparison of various authentication options, see [Choose the right authentication method for your Azure Active Directory hybrid identity solution][Choose the right authentication method for your Azure Active Directory hybrid identity solution].

- For a comprehensive hybrid identity solution, see [How Azure AD Delivers Cloud Governed Management for On-Premises Workloads][How Azure AD Delivers Cloud Governed Management for On-Premises Workloads].

- To learn how Azure AD Connect integrates on-premises directories with Azure AD, see [What is Azure AD Connect?][What is Azure AD Connect?].

### Implementation

When you've decided on an approach, implementation comes next. For deployment recommendations, see these resources:

- For a series of articles and code samples for a multitenant solution, see [Identity management in multitenant applications][Identity management in multitenant applications].

- For information on deploying Azure AD, see these resources:

  - [Azure Active Directory feature deployment guide][Azure Active Directory feature deployment guide]
  - [Azure Active Directory deployment plans][Azure Active Directory deployment plans]
  - [Azure Active Directory B2C deployment plans][Azure Active Directory B2C deployment plans]

- To learn how to use Azure AD and OAuth 2.0 to secure a single-page application, see [Secure development with single-page applications (SPAs)][Secure development with single-page applications (SPAs)].

## Best practices

- With capabilities like automation, self-service, and single sign-on, Azure AD can boost productivity. For general information on benefitting from this service, see [Four steps to a strong identity foundation with Azure Active Directory][Four steps to a strong identity foundation with Azure Active Directory].

- To check whether your Azure AD implementation aligns with the Azure Security Benchmark version 2.0, see [Azure security baseline for Azure Active Directory][Azure security baseline for Azure Active Directory].

- Some solutions use private endpoints in tenants to connect to Azure services. To see guidelines for security issues regarding private endpoints, see [Limit cross-tenant private endpoint connections in Azure][Limit cross-tenant private endpoint connections in Azure].

- For recommendations for the following scenarios, see [Integrate on-premises AD domains with Azure AD][Integrate on-premises AD domains with Azure AD]:

  - Giving your organization's remote users access to your Azure web apps
  - Implementing self-service capabilities for end users
  - Using an on-premises network and a virtual network that aren't connected by a virtual private network (VPN) tunnel or ExpressRoute circuit

- For general information and guidelines on migrating applications to Azure AD, see these articles:

  - [Move application authentication to Azure Active Directory][Move application authentication to Azure Active Directory]
  - [Migrate application authentication to Azure Active Directory][Migrate application authentication to Azure Active Directory]
  - [Review the application activity report][Review the application activity report]
  - [Resources for migrating applications to Azure Active Directory][Resources for migrating applications to Azure Active Directory]

## Suite of baseline implementations

These reference architectures provide baseline implementations for various scenarios:

- [Create an AD DS resource forest in Azure][Create an AD DS resource forest in Azure]
- [Deploy AD DS in an Azure virtual network][Deploy AD DS in an Azure virtual network]
- [Extend on-premises AD FS to Azure][Extend on-premises AD FS to Azure]

## Stay current with identity

Azure AD receives improvements on an ongoing basis.

- To stay on top of recent developments, see [What's new in Azure Active Directory?][What's new in Azure Active Directory?].
- For a roadmap showing new key features and services, see [Azure updates][Azure updates].

## Additional resources

The following resources provide practical recommendations and information for specific scenarios.

### Azure AD in educational environments

- [Introduction to Azure Active Directory Tenants][Introduction to Azure Active Directory Tenants]
- [Design a multi-tenant architecture for large institutions][Design a multi-tenant architecture for large institutions]
- [Design Tenant Configuration][Design Tenant Configuration]
- [Design authentication and credential strategies][Design authentication and credential strategies]
- [Design an account strategy][Design an account strategy]
- [Design identity governance][Design identity governance]
- [Updated Guidance for Microsoft 365 EDU Deployment during COVID-19][Updated Guidance for M365 EDU Deployment during COVID-19]

### Information for Amazon Web Services (AWS) and Google Cloud professionals

- [Multi-cloud security and identity with Azure and Amazon Web Services (AWS)][Multi-cloud security and identity with Azure and Amazon Web Services (AWS)]
- [Azure Active Directory identity management and access management for AWS][Azure Active Directory identity management and access management for AWS]
- [Google Cloud to Azure services comparison—Security and identity][Google Cloud to Azure services comparison—Security and identity]

[Azure Active Directory B2C deployment plans]: /azure/active-directory/fundamentals/azure-active-directory-b2c-deployment-plans?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure Active Directory deployment plans]: /azure/active-directory/fundamentals/active-directory-deployment-plans?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure Active Directory feature deployment guide]: /azure/active-directory/fundamentals/active-directory-deployment-checklist-p2?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure Active Directory identity management and access management for AWS]: ../reference-architectures/aws/aws-azure-ad-security.yml
[Azure billing offers and Active Directory tenants]: /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-ad-tenant?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure identity and access management design area]: /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure security baseline for Azure Active Directory]: /security/benchmark/azure/baselines/aad-security-baseline?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure updates]: https://azure.microsoft.com/updates/?query=Azure%20AD
[Choose the right authentication method for your Azure Active Directory hybrid identity solution]: /azure/active-directory/hybrid/choose-ad-authn?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services]: /azure/active-directory-domain-services/compare-identity-solutions?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Create an AD DS resource forest in Azure]: ../reference-architectures/identity/adds-forest.yml
[Deploy AD DS in an Azure virtual network]: ../reference-architectures/identity/adds-extend-domain.yml
[Describe identity concepts]: /learn/modules/describe-identity-principles-concepts?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Design an account strategy]: /microsoft-365/education/deploy/design-account-strategy?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Design authentication and credential strategies]: /microsoft-365/education/deploy/design-credential-authentication-strategies?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Design identity governance]: /microsoft-365/education/deploy/design-identity-governance?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Design a multi-tenant architecture for large institutions]: /microsoft-365/education/deploy/design-multi-tenant-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Design Tenant Configuration]: /microsoft-365/education/deploy/design-tenant-configurations?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Explore the Microsoft identity platform]: /learn/modules/explore-microsoft-identity-platform?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Extend on-premises AD FS to Azure]: ../reference-architectures/identity/adfs.yml
[Four steps to a strong identity foundation with Azure Active Directory]: /azure/active-directory/hybrid/four-steps?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Google Cloud to Azure services comparison—Security and identity]: ../gcp-professional/services.md#security-and-identity
[How Azure AD Delivers Cloud Governed Management for On-Premises Workloads]: /azure/active-directory/hybrid/cloud-governed-management-for-on-premises?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Identity management in multitenant applications]: ../multitenant-identity/index.md
[Implement Microsoft identity – Associate]: /learn/paths/m365-identity-associate?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Integrate on-premises AD with Azure]: ../reference-architectures/identity/index.yml
[Integrate on-premises AD domains with Azure AD]: ../reference-architectures/identity/azure-ad.yml
[Introduction to Azure Active Directory Tenants]: /microsoft-365/education/deploy/intro-azure-active-directory?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Limit cross-tenant private endpoint connections in Azure]: /azure/cloud-adoption-framework/ready/azure-best-practices/limit-cross-tenant-private-endpoint-connections?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Microsoft Security, Compliance, and Identity Fundamentals: Describe the capabilities of Microsoft Identity and access management solutions]: /learn/paths/describe-capabilities-of-microsoft-identity-access?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Migrate application authentication to Azure Active Directory]: /azure/active-directory/manage-apps/migrate-application-authentication-to-azure-active-directory?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Move application authentication to Azure Active Directory]: /azure/active-directory/manage-apps/migrate-adfs-apps-to-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[MS-500 part 1 - Implement and manage identity and access]: /learn/paths/implement-manage-identity-access?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Multi-cloud security and identity with Azure and Amazon Web Services (AWS)]: ../aws-professional/security-identity.md
[Resilient identity and access management with Azure AD]: ../guide/resilience/resilience-overview.md
[Resource organization]: /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Resources for migrating applications to Azure Active Directory]: /azure/active-directory/manage-apps/migration-resources?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Review the application activity report]: /azure/active-directory/manage-apps/migrate-adfs-application-activity?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[SC-300: Implement an identity management solution]: /learn/paths/implement-identity-management-solution?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Secure development with single-page applications (SPAs)]: ../guide/resilience/azure-ad-secure-single-page-application.md
[Updated Guidance for M365 EDU Deployment during COVID-19]: /microsoft-365/education/deploy/guidance-for-m365-edu-deployment-during-covid19?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[What is Azure AD Connect?]: /azure/active-directory/hybrid/whatis-azure-ad-connect?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[What's new in Azure Active Directory?]: /azure/active-directory/fundamentals/whats-new?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
