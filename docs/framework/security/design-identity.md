---
title: Azure identity and access management considerations
description: Use Azure Active Directory (Azure AD) to grant access based on identity authentication and authorization.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
ms.custom:
  - article
---

# Azure identity and access management considerations

Most architectures have shared services that are hosted and accessed across networks. Those services share common infrastructure and users need to access resources and data from anywhere. For such architectures, a common way to secure resources is to use network controls. However, that isn't enough.

Provide security assurance through _identity management_: the process of authenticating and authorizing security principals. Use identity management services to authenticate and grant permission to users, partners, customers, applications, services, and other entities.

## Checklist

**How are you managing the identity for your workload?**
***
> [!div class="checklist"]
>
> - Define clear lines of responsibility and separation of duties for each function. Restrict access based on a need-to-know basis and least privilege security principles.
> - Assign permissions to users, groups, and applications at a certain scope through Azure RBAC. Use built-in roles when possible.
> - Prevent deletion or modification of a resource, resource group, or subscription through management locks.
> - Use Managed Identities to access resources in Azure.
> - Support a single enterprise directory. Keep the cloud and on-premises directories synchronized, except for critical-impact accounts.
> - Set up Azure AD Conditional Access. Enforce and measure key security attributes when authenticating all users, especially for critical-impact accounts.
> - Have a separate identity source for non-employees.
> - Preferably use passwordless methods or opt for modern password methods.
> - Block legacy protocols and authentication methods.

## In this section

Follow these questions to assess the workload at a deeper level. The recommendations in this section are based on using Azure AD.

|Assessment|Description|
|---|---|
|[**Does the application team have a clear view on responsibilities and individual/group access levels?**](design-identity-role-definitions.md)|Designate groups (or individual roles) that will be responsible for central functions, such as network, policy management and so on.|
|[**Is the workload infrastructure protected with Azure role-based access control (Azure RBAC)?**](design-identity-control-plane.md)|Azure Resource Manager handles all control plane requests and applies restrictions that you specify through Azure role-based access control (Azure RBAC), Azure Policy, locks.|
|[**Has role-based and/or resource-based authorization been configured within Azure AD?**](design-identity-authorization.md)|Use a mix of role-based and resource-based authorization. Start with the principle of least privilege and add more actions based your needs.|
|[**How is the workload authenticated when communicating with Azure platform services?**](design-identity-authentication.md)|Authenticate using Managed Identities, use passwordless protections, and keep all (except critical accounts) identities at a central location.|

## Azure security benchmark

The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to the [Azure Security Benchmarks Identity and Access Control](/azure/security/benchmarks/security-controls-v2-identity-management).

## Azure services for identity

The considerations and best practices in this section are based on these Azure services:

- [Azure AD](/azure/active-directory/)
- [Azure AD B2B](/azure/active-directory/b2b/)
- [Azure AD B2C](/azure/active-directory-b2c/)

## Reference architecture

Here are some reference architectures related to identity and access management:

[Integrate on-premises AD domains with Azure AD](../../reference-architectures/identity/azure-ad.yml)

[Integrate on-premises AD with Azure](../../reference-architectures/identity/index.yml)

## Next steps

We recommend applying as many as of the best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program.

> [!div class="nextstepaction"]
> [Monitor identity, network, data risks](./monitor-identity-network.md)

## Related links

[Five steps to securing your identity infrastructure](/azure/security/fundamentals/steps-secure-identity)

> Go back to the main article: [Security](overview.md)
