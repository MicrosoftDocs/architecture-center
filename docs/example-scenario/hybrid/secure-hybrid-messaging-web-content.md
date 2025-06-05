
The solution in this article provides a way for you to help protect your messaging service (Outlook on the web or Exchange Control Panel) when mailboxes are hosted in Exchange Online or Exchange on-premises.

## Architecture

In this architecture, we divide the solution into two areas, describing security for:

- Exchange Online, on the right side of the diagram.
- Exchange on-premises in a hybrid or non-hybrid scenario, on the left side of the diagram.

:::image type="complex" border="false" source="./media/hybrid-messaging-web.svg" alt-text="Screenshot that shows an architecture for enhanced security in a web access scenario." lightbox="./media/hybrid-messaging-web.svg":::
   Diagram that shows two flows of web access. On the right side, a user with a mailbox hosted in Exchange Online. On the left side, a user with a mailbox hosted in Exchange on-premises.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-hybrid-messaging-web.vsdx) of this architecture.*

### General notes

- This architecture uses the [federated](/entra/identity/hybrid/connect/whatis-fed) Microsoft Entra identity model. For the password hash synchronization and pass-through authentication models, the logic and the flow are the same. The only difference is related to the fact that Microsoft Entra ID won't redirect the authentication request to on-premises Active Directory Federation Services (AD FS).
- The diagram shows access to the Outlook on the web service that corresponds to an …/owa path. Exchange admin center (or Exchange Control Panel) user access that corresponds to an …/ecp path follows the same flow.
- In the diagram, dashed lines show basic interactions between local Active Directory, Microsoft Entra Connect, Microsoft Entra ID, AD FS, and Web Application Proxy components. You can learn more about these interactions in [Hybrid identity required ports and protocols](/entra/identity/hybrid/connect/reference-connect-ports).
- By *Exchange on-premises*, we mean Exchange 2019 with the latest updates, Mailbox role. By *Exchange Edge on-premises*, we mean Exchange 2019 with the latest updates, Edge Transport role. We include Edge server in the diagram to highlight that you can use it in these scenarios. It's not involved in the work with client protocols that's discussed here.
- In a real environment, you won't have just one server. You'll have a load-balanced array of Exchange servers for high availability. The scenarios described here are suited for that configuration.

### Exchange Online user's flow

1. A user tries to access Outlook on the web service via [https://outlook.office.com/owa](https://outlook.office.com/owa).
1. Exchange Online redirects the user to Microsoft Entra ID for authentication.

    If the domain is federated, Microsoft Entra ID redirects the user to the local AD FS instance for authentication. If authentication succeeds, the user is redirected back to Microsoft Entra ID. (To keep the diagram simple, we left out this federated scenario.)
1. To enforce multifactor authentication, Microsoft Entra ID applies an Azure Conditional Access policy with a multifactor authentication requirement for the browser client application. See the [deployment section](#set-up-a-conditional-access-policy) of this article for information about setting up that policy.
1. The Conditional Access policy calls Microsoft Entra multifactor authentication. The user gets a request to complete multifactor authentication.
1. The user completes multifactor authentication.
1. Microsoft Entra ID redirects the authenticated web session to Exchange Online, and the user can access Outlook.

### Exchange on-premises user's flow

1. A user tries to access the Outlook on the web service via an `https://mail.contoso.com/owa` URL that points to an Exchange server for internal access or to a Web Application Proxy server for external access.
1. Exchange on-premises (for internal access) or Web Application Proxy (for external access) redirects the user to AD FS for authentication.
1. AD FS uses Integrated Windows authentication for internal access or provides a web form in which the user can enter credentials for external access.
1. Responding to an AF DS access control policy, AD FS calls Microsoft Entra multifactor authentication to complete authentication. Here's an example of that type of AD FS access control policy:

    :::image type="content" source="./media/access-control-policy.png" alt-text="Screenshot that shows an example of an AD FS access control policy.":::

    The user gets a request to complete multifactor authentication.

1. The user completes multifactor authentication. AD FS redirects the authenticated web session to Exchange on-premises.
1. The user can access Outlook.

To implement this scenario for an on-premises user, you need to configure Exchange and AD FS to set up AD FS to pre-authenticate web access requests. For more information, see [Use AD FS claims-based authentication with Outlook on the web](/exchange/clients/outlook-on-the-web/ad-fs-claims-based-auth?view=exchserver-2019). 

You also need to enable integration of AD FS and Microsoft Entra multifactor authentication. For more information, see [Configure Azure MFA as authentication provider with AD FS](/windows-server/identity/ad-fs/operations/configure-ad-fs-and-azure-mfa). (This integration requires AD FS 2016 or 2019.) Finally, you need to synchronize users to Microsoft Entra ID and assign them licenses for Microsoft Entra multifactor authentication.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis). Microsoft Entra ID is a Microsoft cloud-based identity and access management service. It provides modern authentication that's based on EvoSTS (a Security Token Service used by Microsoft Entra ID). It's used as an authentication server for Exchange Server on-premises.

- [Microsoft Entra multifactor authentication](/entra/identity/authentication/howto-mfa-getstarted). Multifactor authentication is a process in which users are prompted during the sign-in process for another form of identification, like a code on their cellphone or a fingerprint scan.

- [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview). Conditional Access is the feature that Microsoft Entra ID uses to enforce organizational policies like multifactor authentication.

- [AD FS](/windows-server/identity/active-directory-federation-services). AD FS enables federated identity and access management by sharing digital identity and entitlements rights across security and enterprise boundaries with improved security. In this architecture, it's used to facilitate sign-in for users with federated identity.

- [Web Application Proxy](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server). Web Application Proxy pre-authenticates access to web applications by using AD FS. It also functions as an AD FS proxy.

- [Exchange Server](/exchange/exchange-server). Exchange Server hosts user mailboxes on-premises. In this architecture, it uses tokens issued to the user by Microsoft Entra ID to authorize access to mailboxes.

- [Active Directory services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview). Active Directory services stores information about members of a domain, including devices and users. In this architecture, user accounts belong to Active Directory services and are synchronized to Microsoft Entra ID.

## Scenario details

Enterprise messaging infrastructure (EMI) is a key service for organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multifactor authentication requirements for messaging service access is one of the most effective ways to meet that challenge.

This article describes an architecture to enhance your security in a web access scenario by using Microsoft Entra multifactor authentication.

The architectures here describe scenarios to help you protect your messaging service (Outlook on the web or Exchange Control Panel) when mailboxes are hosted in Exchange Online or Exchange on-premises.

For information about applying multifactor authentication in other hybrid messaging scenarios, see these articles:

- [Enhanced-security hybrid messaging infrastructure in a desktop-client access scenario](secure-hybrid-messaging-client.yml)
- [Enhanced-security hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)

This article doesn't discuss other protocols, like IMAP or POP. We don't recommend that you use them to provide user access.

## Potential use cases

This architecture is relevant for the following scenarios:

- Enhance EMI security.
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy.
- Apply your standard high level of protection for your on-premises messaging service during transition to or coexistence with Exchange Online.
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Availability

Overall availability depends on the availability of the components involved. For information about availability, see these resources:

- [Advancing Microsoft Entra availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- [Cloud services you can trust: Office 365 availability](https://www.microsoft.com/microsoft-365/blog/2013/08/08/cloud-services-you-can-trust-office-365-availability)
- [What is the Microsoft Entra architecture?](/entra/architecture/architecture)

Availability of on-premises solution components depends on the implemented design, hardware availability, and your internal operations and maintenance routines. For availability information about some of these components, see the following resources:

- [Setting up an AD FS deployment with Always On availability groups](/windows-server/identity/ad-fs/operations/ad-fs-always-on)
- [Deploying high availability and site resilience in Exchange Server](/exchange/high-availability/deploy-ha?view=exchserver-2019)
- [Web Application Proxy in Windows Server](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server)

#### Resiliency

For information about the resiliency of the components in this architecture, see the following resources.

- For Microsoft Entra ID: [Advancing Microsoft Entra availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- For scenarios that use AD FS: [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager](/windows-server/identity/ad-fs/deployment/active-directory-adfs-in-azure-with-azure-traffic-manager)
- For the Exchange on-premises solution: [Exchange high availability](/exchange/high-availability/deploy-ha?view=exchserver-2019)

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For information about the security of the components in this architecture, see the following resources:

- [Microsoft Entra security operations guide](/entra/architecture/security-operations-introduction)
- [Best practices for securing AD FS and Web Application Proxy](/windows-server/identity/ad-fs/deployment/best-practices-securing-ad-fs)
- [Configure AD FS Extranet Smart Lockout Protection](/windows-server/identity/ad-fs/operations/configure-ad-fs-extranet-smart-lockout-protection)

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of your implementation depends on your Microsoft Entra ID and Microsoft 365 license costs. Total cost also includes costs for software and hardware for on-premises components, IT operations, training and education, and project implementation.

The solution requires at least Microsoft Entra ID P1. For pricing details, see [Microsoft Entra pricing](https://www.microsoft.com/security/business/identity-access-management/azure-ad-pricing).

For information about Exchange, see [Exchange Server pricing](https://www.microsoft.com/microsoft-365/exchange/microsoft-exchange-licensing-faq-email-for-business).

For information about AD FS and Web Application Proxy, see [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance depends on the performance of the components involved and your company's network performance. For more information, see [Office 365 performance tuning using baselines and performance history](/microsoft-365/enterprise/performance-tuning-using-baselines-and-history?view=o365-worldwide).

For information about on-premises factors that influence performance for scenarios that include AD FS services, see these resources:

- [Configure performance monitoring](/windows-server/identity/ad-fs/deployment/configure-performance-monitoring)
- [Fine tuning SQL and addressing latency issues with AD FS](/windows-server/identity/ad-fs/operations/adfs-sql-latency)

#### Scalability

For information about AD FS scalability, see [Planning for AD FS server capacity](/windows-server/identity/ad-fs/design/planning-for-ad-fs-server-capacity).

For information about Exchange Server on-premises scalability, see [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019).

## Deploy this scenario

To deploy this scenario, complete these high-level steps:

1. Start with the web access service. Improve its security by using an [Azure Conditional Access policy for Exchange Online](/entra/identity/conditional-access/policy-all-users-mfa-strength).
1. Improve the security of web access for on-premises EMI [by using AD FS claim-based authentication](/exchange/clients/outlook-on-the-web/ad-fs-claims-based-auth?view=exchserver-2019).

### Set up a Conditional Access policy

To set up a Microsoft Entra Conditional Access policy that enforces multifactor authentication, as described in step 3 of the online user's flow earlier in this article:

1. Configure **Office 365 Exchange Online** or **Office 365** as a cloud app:

    :::image type="content" source="./media/set-as-cloud-app.png" alt-text="Screenshot that shows how to configure Office as a cloud application.":::

1. Configure the browser as a client app:

    :::image type="content" source="./media/apply-policy-to-browser.png" alt-text="Screenshot that shows applying the policy to the browser.":::

1. Apply the multifactor authentication requirement in the **Grant** window:

    :::image type="content" source="./media/apply-multifactor-authentication.png" alt-text="Screenshot that shows applying the multifactor authentication requirement.":::

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Pavel Kondrashov](https://www.linkedin.com/in/kondrashov-pv) | Cloud Solution Architect
- [Ella Parkum](https://www.linkedin.com/in/ella-parkum-15036923) | Principal Customer Solution Architect-Engineering

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Announcing Hybrid Modern Authentication for Exchange On-Premises](https://techcommunity.microsoft.com/t5/exchange-team-blog/announcing-hybrid-modern-authentication-for-exchange-on-premises/ba-p/607476)
- [Hybrid modern authentication overview and prerequisites for use with on-premises Skype for Business and Exchange servers](/microsoft-365/enterprise/hybrid-modern-auth-overview?view=o365-worldwide)
- [Use AD FS claims-based authentication with Outlook on the web](/exchange/clients/outlook-on-the-web/ad-fs-claims-based-auth?view=exchserver-2019)
- [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019)
- [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager](/windows-server/identity/ad-fs/deployment/active-directory-adfs-in-azure-with-azure-traffic-manager)

## Related resources

- [Enhanced-security hybrid messaging infrastructure in a desktop-client access scenario](secure-hybrid-messaging-client.yml)
- [Enhanced-security hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)
