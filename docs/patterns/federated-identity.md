---
title: Federated Identity Pattern
description: Use the Federated Identity design pattern to delegate authentication to an external identity provider.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/01/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Federated Identity pattern

Delegate user authentication to an external identity provider (IdP) to simplify development, minimize administrative tasks, and improve application UX.

## Context and problem

Users typically need to work with multiple applications that partner organizations provide and host. They might need to use specific, different sign-in credentials for each application. This requirement can:

- **Cause a disjointed UX.** Employees often forget multiple sign-in credentials.

- **Expose security vulnerabilities.** When an employee leaves the company, the organization must immediately deactivate the account. Large organizations often miss this critical step.

- **Complicate user management.** Admins manage user credentials, issue password reminders, and perform other administrative tasks.

Users typically prefer to use the same sign-in credentials for all applications.

## Solution

Implement a federated identity authentication mechanism. Separate user authentication from the application code and delegate authentication to a trusted IdP. This process simplifies development, minimizes administrative overhead, and provides user authentication via a range of IdPs. Federated identity also separates authentication from authorization.

Trusted IdPs include corporate directories, on-premises federation services, security token services (STSs), and social IdPs like Microsoft, Google, Yahoo!, or Facebook.

The following diagram shows the Federated Identity pattern for a client application that accesses a service that requires authentication. The IdP works with an STS to provide authentication. The IdP issues security tokens that provide information about the authenticated user. This information, called *claims*, includes the user's identity and might also include other claims, like role memberships and more granular access rights.

:::image type="complex" border="false" source="./_images/federated-identity-overview.png" alt-text="Diagram that shows the Federated Identity pattern." lightbox="./_images/federated-identity-overview.png":::
   Diagram that shows the Federated Identity pattern. In step 1, an arrow connects a box labeled service to a box labeled identity provider (IdP) or security token service (STS). The arrow is labeled service trusts IdP or STS. In step 2, an arrow connects a box labeled consumer to the box labeled IdP or STS. The arrow is labeled consumer authenticates and requests token. In step 3, an arrow connects the box labeled IdP or STS back to the box labeled consumer. The arrow is labeled STS returns token. In step 4, an arrow connects the box labeled consumer to the box labeled service. The arrow is labeled consumer presents token to service.
:::image-end:::

This model is also called claims-based access control. Applications and services authorize access to features and functionality based on the claims. The service that requires authentication must trust the IdP. The client application contacts the IdP for authentication. If authentication succeeds, the IdP returns a token that contains user-identifying claims to the STS. The IdP and the STS might be part of the same service. The STS can transform and augment the claims based on predefined rules before it returns the token to the client. The client application then passes this token to the service as proof of its identity.

Federated authentication provides a standards-based method to establish trust in identities across domains, and it supports single sign-on (SSO). Many applications, especially cloud-hosted applications, use federated authentication because it supports SSO without a direct network connection to an IdP. This design increases security, because the user doesn't need to create and enter different sign-in credentials for multiple applications. It also limits credential exposure to only the original IdP. Applications see only the authenticated identity information in the token.

Applications and services that use federated authentication don't need to provide identity management features. Instead, the IdP is responsible for identity and credential management. When the corporate directory trusts the IdP, it doesn't need to manage the user identity. This approach eliminates the administrative overhead of directory-based user identity management.

## Problems and considerations

Consider the following points when you decide how to implement this pattern:

- Authentication can be a single point of failure. To maintain application reliability and availability across multiple regions, consider deploying your identity management mechanism across the same regions as your application.

- To configure role-based access control (RBAC), use authentication tools. RBAC supports granular control over feature and resource access.

- Unlike a corporate directory, claims-based authentication that uses social IdPs usually provides only the authenticated user's email address, and sometimes their name. Some social IdPs, such as Microsoft, provide only a unique identifier. The application usually maintains some information about registered users so it can match this information to the identifier in the claims. This task is typically completed during registration, when the user first accesses the application. Information is then injected into the token as new claims after each authentication.

- If multiple IdPs are configured for the STS, the STS must determine which IdP should authenticate the user. This process is called *home realm discovery*. The STS might determine the IdP automatically based on user-provided information like an email address or a user name, the application subdomain, the user's IP address range, or a cookie stored in the user's browser. For example, if the user enters a Microsoft email address, such as `user@live.com`, the STS redirects the user to the Microsoft account sign-in page. On subsequent visits, the STS can use a cookie that indicates the user previously signed in by using a Microsoft account. If the STS can't automatically determine the home realm, it displays a home realm discovery page that lists the trusted IdPs. The user then selects an IdP.

## When to use this pattern

Use this pattern when you need:

- **SSO in the enterprise.** In this scenario, you need to authenticate employees for corporate applications that are hosted in the cloud outside the corporate security boundary, without a sign-in every time they visit an application. The user experience matches on-premises applications. Users authenticate when they sign in to the corporate network, and then they can access relevant applications without another sign-in.

- **Federated identity with multiple partners.** In this scenario, you need to authenticate corporate employees and business partners who don't have accounts in the corporate directory. This practice is common in business-to-business applications, applications that integrate with partner services, and in companies that use different IT systems, or merged or shared resources.

- **Federated identity in software as a service (SaaS) applications.** In this scenario, independent software vendors provide a ready-to-use service for multiple clients or tenants. Tenants authenticate by using a suitable IdP. For example, business users use their corporate credentials, while tenant consumers and clients use social identity credentials.

- **Federated identity for workload access.** In this scenario, tenant applications, automation workflows, or continuous integration and continuous delivery systems need to call your APIs without a user present. Tenants authenticate via their own IdPs by using workload identities. The application authorizes access by using tenant-scoped claim validation.

This pattern might not be suitable when you have:

- **One IdP.** In this scenario, application users authenticate by using one IdP, and they don't need to authenticate by using another IdP. This situation is typical in applications that use a corporate directory for authentication, either via a VPN or a virtual network connection between the application and an on-premises directory.

- **Incompatible authentication mechanisms.** In this scenario, the application uses a different authentication mechanism, for example by using custom user stores, or it can't handle claims-based technology negotiation standards. It can be complex and expensive to retrofit claims-based authentication and access control into an existing application.

## Workload design

Evaluate how to use the Federated Identity pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern offloads user management and authentication to the IdP, which typically has a high service-level objective. During workload disaster recovery (DR), the workload recovery plan doesn't need to address authentication components.<br><br> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br> -  [RE:09 DR](/azure/well-architected/reliability/disaster-recovery) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | This pattern provides advanced identity-based threat detection and prevention capabilities without requiring you to implement them in your workload. External IdPs also use modern interoperable authentication protocols.<br><br> - [SE:02 Secured development lifecycle](/azure/well-architected/security/secure-development-lifecycle)<br> - [SE:10 Monitoring and threat detection](/azure/well-architected/security/monitor-threats) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern helps you devote application resources to other priorities.<br><br> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

An organization hosts a multicomponent cloud-based application that includes a web front end and a back-end API. The application delegates authentication to a centralized IdP by using Microsoft Entra ID, rather than implementing authentication logic in each component.

:::image type="complex" border="false" source="./_images/federated-identity-microsoft-entra-id.svg" alt-text="Diagram that shows the Federated Identity pattern with Microsoft Entra ID authentication." lightbox="./_images/federated-identity-microsoft-entra-id.svg":::
   Diagram that shows the Federated Identity pattern with Microsoft Entra ID authentication. The diagram heading is Microsoft Entra ID – Authorization Code + PKCE. There are four boxes, labeled user, web app, Microsoft Entra ID, and API. The user connects to the web app with an arrow labeled open app and choose sign-in. The web app connects to Microsoft Entra ID with an arrow labeled redirect for authentication. Microsoft Entra ID connects back to the web app with a dotted arrow labeled redirect to app with authentication code. The web app connects back to Microsoft Entra ID with an arrow labeled POST token (authorization_code + code verifier). Microsoft Entra ID connects back to the web app with a dotted arrow labeled ID token, access token, and refresh token. The web app connects to the API with an arrow that passes through Microsoft Entra ID. The arrow is labeled call API by using Access token. The API validates the token and enforces authorization. The API connects back to the web app with a dotted arrow that passes through Microsoft Entra ID. The arrow is labeled response.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/federated-identity-microsoft-entra-id.vsdx) of this architecture.*

The following workflow corresponds to the previous diagram.

1. The user accesses the web app.

1. The web app redirects the user to Microsoft Entra ID for authentication.

1. After successful authentication, Microsoft Entra ID redirects the user back to the web app with an authorization code.

1. The web app exchanges the authorization code for tokens and sends a POST request to the token endpoint.

1. Microsoft Entra ID issues a token that contains claims about the user.

1. The web app uses this token to call a back-end API.

1. The web app and the back-end API validate the token and enforce their authorization rules based on the claims.

1. The API returns the response to the web app.

Key characteristics:

- **Centralized authentication.** Components rely on Microsoft Entra ID to authenticate users, which removes the need for custom authentication logic in the application.

- **Decentralized authorization.** Application components independently enforce authorization decisions based on claims.

- **Claims-based access control.** Access to functionality is determined by using claims, such as roles or scopes.

- **Standards-based protocols.** Components use OAuth 2.0 and OpenID Connect for authentication.

- **Optional MFA enforcement.** If your risk profile requires stronger sign-in assurance, you can enforce multifactor authentication by using [Conditional Access policies in Microsoft Entra ID](/entra/identity/conditional-access/overview).

- **Optional extensibility through federation.** Microsoft Entra ID can be configured to trust a partner Microsoft Entra tenant by using [cross-tenant access settings](/entra/identity/multi-tenant-organizations/overview#multitenant-capabilities-for-multitenant-organizations). Partner users can then access the application without changes to application components.

## Next steps

- [What is Microsoft Entra?](/entra/fundamentals/what-is-entra)
- [OpenID Connect on the Microsoft identity platform](/entra/identity-platform/v2-protocols-oidc)
- [Convert a single-tenant app to multitenant by using Microsoft Entra ID](/entra/identity-platform/howto-convert-app-to-be-multi-tenant)
- [What is Conditional Access?](/entra/identity/conditional-access/overview)

## Related resources

- [Architectural considerations for identity in a multitenant solution](/azure/architecture/guide/multitenant/considerations/identity)
- [Gatekeeper pattern](./gatekeeper.md)
- [Valet Key pattern](./valet-key.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)