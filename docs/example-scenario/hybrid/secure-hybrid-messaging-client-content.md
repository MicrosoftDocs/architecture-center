The article shows how to implement multi-factor authentication for Outlook desktop clients that access Microsoft Exchange. There are four architectures that correspond to four different possibilities for the Microsoft Exchange that has the user mailbox:

- [Exchange Online](#architecture-exchange-online)
- [Exchange Online, AD FS](#architecture-exchange-online-ad-fs)
- [Exchange on-premises](#architecture-exchange-on-premises)
- [Exchange on-premises, AD FS](#architecture-exchange-on-premises-ad-fs)

> [!NOTE]
> In the diagrams, black dashed lines show basic interactions between local Active Directory, Azure AD Connect, Azure AD, AD FS, and Web Application Proxy components. You can learn about these interactions in [Hybrid identity required ports and protocols](/azure/active-directory/hybrid/reference-connect-ports).

## Architecture (Exchange Online)

:::image type="content" border="false" source="./media/desktop-online-option-1.svg" alt-text="Diagram that shows an architecture for enhanced security in an Outlook client access scenario. The user's mailbox is in Exchange Online." lightbox="./media/desktop-online-option-1.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-hybrid-messaging-client.vsdx) of all diagrams in this article.*

In this scenario, users need to use the version of Outlook client that supports modern authentication. For more information, see [How modern authentication works for Office 2013, Office 2016, and Office 2019 client apps](/microsoft-365/enterprise/modern-auth-for-office-2013-and-2016?view=o365-worldwide). This architecture covers both Outlook for Windows and Outlook for Mac.

### Workflow (Exchange Online)

1. The user tries to access Exchange Online via Outlook.
1. Exchange Online provides the URL of an Azure AD endpoint for retrieving the access token to get access to the mailbox.
1. Outlook connects to Azure AD by using that URL.
1. As soon as the domain is federated, Azure AD redirects the request to on-premises AD FS.
1. The user enters credentials on an AD FS sign-in page.
1. AD FS redirects the session back to Azure AD.
1. Azure AD applies an Azure Conditional Access policy with a multi-factor authentication requirement for mobile apps and desktop clients. See the [deployment section](#set-up-a-conditional-access-policy) of this article for information about setting up that policy.
1. The Conditional Access policy calls Azure AD Multi-Factor Authentication. The user gets a request to complete multi-factor authentication.
1. The user completes multi-factor authentication.
1. Azure AD issues access and refresh tokens and returns them to the client.
1. By using the access token, the client connects to Exchange Online and retrieves the content.

### Configuration (Exchange Online)

To block attempts to access Exchange Online via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, and EWS. Here's the corresponding configuration:

> AllowBasicAuthAutodiscover         : False
>
> AllowBasicAuthMapi                 : False
>
> AllowBasicAuthOfflineAddressBook   : False
>
> AllowBasicAuthWebServices          : False
>
> AllowBasicAuthRpc                  : False

Remote procedure call (RPC) protocol is [no longer supported](/exchange/troubleshoot/administration/rpc-over-http-end-of-support) for Office 365, so the last parameter doesn't affect clients.

Here's an example of a command for creating this authentication policy:

```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -AllowBasicAuthRpc:$false -AllowBasicAuthMapi:$false -AllowBasicAuthAutodiscover:$false
-AllowBasicAuthWebServices:$false -AllowBasicAuthOfflineAddressBook:$false
```

> [!NOTE]
> By default, after you create the policy, legacy authentication for all other protocols (like IMAP, POP, and ActiveSync) is also disabled. To change this behavior, you can enable protocols by using a PowerShell command like this one:
>
> `Set-AuthenticationPolicy -Identity BlockOutlook -AllowBasicAuthImap:$true`

After you create the authentication policy, you can first assign it to a pilot group of users by using the `Set-User user01 -AuthenticationPolicy <name_of_policy>` command. After testing, you can expand the policy to include to all users. To apply policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange Online PowerShell for this configuration.

## Architecture (Exchange Online, AD FS)

:::image type="content" border="false" source="./media/desktop-online-option-2.svg" alt-text="Diagram that shows an alternative architecture for enhanced security in an Outlook client access scenario." lightbox="./media/desktop-online-option-2.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-hybrid-messaging-client.vsdx) of all diagrams in this article.*

This scenario is the same as the previous one, except that it uses a different trigger for multi-factor authentication. In the previous scenario, we used local AD FS for authentication. We then redirected information about successful authentication to Azure AD, where a Conditional Access policy enforced multi-factor authentication. In this scenario, instead of using Conditional Access to enforce multi-factor authentication, we create an access control policy on the AD FS level and enforce multi-factor authentication there. The rest of the architecture is the same as the previous one.

> [!NOTE]
>
> We recommend this scenario only if you're unable to use the previous one.

In this scenario, users need to use the version of Outlook client that supports modern authentication. For more information, see [How modern authentication works for Office 2013, Office 2016, and Office 2019 client apps](/microsoft-365/enterprise/modern-auth-for-office-2013-and-2016?view=o365-worldwide). This architecture covers both Outlook for Windows and Outlook for Mac.

### Workflow (Exchange Online, AD FS)

1. The user tries to access Exchange Online via Outlook.
1. Exchange Online provides the URL of an Azure AD endpoint for retrieving the access token to get access to the mailbox.
1. Outlook connects to Azure AD by using that URL.
1. If the domain is federated, Azure AD redirects the request to on-premises AD FS.
1. The user enters credentials on an AD FS sign-in page.
1. Responding to an AF DS access control policy, AD FS calls Azure AD Multi-Factor Authentication to complete authentication. Here's an example of that type of AD FS access control policy:

   :::image type="content" source="./media/access-control-policy.png" alt-text="Screenshot that shows an example of an AD FS access control policy.":::

   The user gets a request to complete multi-factor authentication.
1. The user completes multi-factor authentication.
1. AD FS redirects the session back to Azure AD.
1. Azure AD issues access and refresh tokens and returns them to the client.
1. By using the access token, the client connects to Exchange Online and retrieves the content.

### Configuration (Exchange Online, AD FS)

> [!NOTE]
>
> The access control policy that's implemented in step 6 is applied on the relying-party-trust level, so it affects all authentication requests for all Office 365 services that go through AD FS. You can [use AD FS authentication rules to apply additional filtering](/windows-server/identity/ad-fs/operations/configure-authentication-policies#to-configure-mfa-per-relying-party-trust-that-is-based-on-a-users-group-membership-data). However, we recommend that you use a Conditional Access policy (described in the previous architecture) rather than using an AD FS access control policy for Microsoft 365 services. The previous scenario is more common, and by using it you can achieve better flexibility.

To block attempts to access Exchange Online via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, and EWS. Here's the corresponding configuration:

> AllowBasicAuthAutodiscover         : False
>
> AllowBasicAuthMapi                 : False
>
> AllowBasicAuthOfflineAddressBook   : False
>
> AllowBasicAuthWebServices          : False
>
> AllowBasicAuthRpc                  : False

RPC protocol is [no longer supported](/exchange/troubleshoot/administration/rpc-over-http-end-of-support) for Office 365, so the last parameter doesn't affect clients.

Here's an example of a command for creating this authentication policy:

```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -AllowBasicAuthRpc:$false -AllowBasicAuthMapi:$false -AllowBasicAuthAutodiscover:$false
-AllowBasicAuthWebServices:$false -AllowBasicAuthOfflineAddressBook:$false
```

## Architecture (Exchange on-premises)

:::image type="content" border="false" source="./media/desktop-on-premises-option-1.svg" alt-text="Diagram that shows an enhanced security architecture in an on-premises Outlook client access scenario." lightbox="./media/desktop-on-premises-option-1.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-hybrid-messaging-client.vsdx) of all diagrams in this article.*

This architecture covers both Outlook for Windows and Outlook for Mac.

### Workflow (Exchange on-premises)

1. A user with a mailbox on Exchange Server starts the Outlook client. The Outlook client connects to Exchange Server and specifies that it has modern authentication capabilities.
1. Exchange Server sends a response to the client requesting that it get a token from Azure AD.
1. The Outlook client connects to an Azure AD URL that's provided by Exchange Server.
1. Azure identifies that the user's domain is federated, so it sends requests to AD FS (via Web Application Proxy).
1. The user enters credentials on an AD FS sign-in page.
1. AD FS redirects the session back to Azure AD.
1. Azure AD applies an Azure Conditional Access policy with a multi-factor authentication requirement for mobile apps and desktop clients. See the [deployment section](#set-up-a-conditional-access-policy) of this article for information about setting up that policy.
1. The Conditional Access policy calls Azure AD Multi-Factor Authentication. The user gets a request to complete multi-factor authentication.
1. The user completes multi-factor authentication.
1. Azure AD issues access and refresh tokens and returns them to the client.
1. The user presents the access token to Exchange Server, and Exchange authorizes access to the mailbox.

### Configuration (Exchange on-premises)

To block attempts to access Exchange on-premises via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, EWS, and RPC. Here's the corresponding configuration:

> BlockLegacyAuthAutodiscover       : True
>
> BlockLegacyAuthMapi               : True
>
> BlockLegacyAuthOfflineAddressBook : True
>
> BlockLegacyAuthRpc                : True
>
> BlockLegacyAuthWebServices        : True

RPC protocol doesn't support modern authentication, so it doesn't support Azure AD Multi-Factor Authentication. Microsoft recommends [MAPI](/exchange/clients/mapi-over-http/mapi-over-http?view=exchserver-2019) protocol for Outlook for Windows clients.

Here's an example of a command for creating this authentication policy:

```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -BlockLegacyAuthAutodiscover -BlockLegacyAuthMapi -BlockLegacyAuthOfflineAddressBook -BlockLegacyAuthRpc
```

After you create the authentication policy, you can first assign it to a pilot group of users by using the `Set-User user01 -AuthenticationPolicy <name_of_policy>` command. After testing, you can expand the policy to include all users. To apply policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange on-premises PowerShell for this configuration.

## Architecture (Exchange on-premises, AD FS)

:::image type="content" border="false" source="./media/desktop-on-premises-option-2.svg" alt-text="Diagram that shows an alternative enhanced security architecture in an on-premises Outlook client access scenario." lightbox="./media/desktop-on-premises-option-2.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-hybrid-messaging-client.vsdx) of all diagrams in this article.*

This scenario is similar to the previous one. However, in this scenario, multi-factor authentication is triggered by AD FS. This architecture covers both Outlook for Windows and Outlook for Mac.

> [!NOTE]
>
> We recommend this scenario only if you are unable to use the previous one.

### Workflow (Exchange on-premises, AD FS)

1. The user starts the Outlook client. The client connects to Exchange Server and specifies that it has modern authentication capabilities.
1. Exchange Server sends a response to the client requesting that it get a token from Azure AD. Exchange Server provides the client with a URL to Azure AD.
1. The client uses the URL to access Azure AD.
1. In this scenario, the domain is federated. Azure AD redirects the client to AD FS via Web Application Proxy.
1. The user enters credentials on an AD FS sign-in page.
1. AD FS triggers multi-factor authentication. Here's an example of that type of AD FS access control policy:

   :::image type="content" source="./media/access-control-policy.png" alt-text="Screenshot that shows an AD FS access control policy.":::

   The user gets a request to complete multi-factor authentication.
1. The user completes multi-factor authentication.
1. AD FS redirects the session back to Azure AD.
1. Azure AD issues access and refresh tokens to the user.
1. The client presents the access token to the Exchange on-premises server. Exchange authorizes access to the user's mailbox.

### Configuration (Exchange on-premises, AD FS)

> [!NOTE]
>
> The access control policy implemented in step 6 is applied on the relying-party-trust level, so it affects all authentication requests for all Office 365 services that go through AD FS. You can [use AD FS authentication rules to apply additional filtering](/windows-server/identity/ad-fs/operations/configure-authentication-policies#to-configure-mfa-per-relying-party-trust-that-is-based-on-a-users-group-membership-data). However, we recommend that you use a Conditional Access policy (described in the previous architecture) rather than using an AD FS access control policy for Microsoft 365 services. The previous scenario is more common, and by using it you can achieve better flexibility.

To block attempts to access Exchange on-premises via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, EWS, and RPC. Here's the corresponding configuration:

> BlockLegacyAuthAutodiscover       : True
>
> BlockLegacyAuthMapi               : True
>
> BlockLegacyAuthOfflineAddressBook : True
>
> BlockLegacyAuthRpc                : True
>
> BlockLegacyAuthWebServices        : True

RPC protocol doesn't support modern authentication, so it doesn't support Azure AD Multi-Factor Authentication. Microsoft recommends [MAPI](/exchange/clients/mapi-over-http/mapi-over-http?view=exchserver-2019) protocol for Outlook for Windows clients.

Here's an example of a command for creating this authentication policy:

```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -BlockLegacyAuthAutodiscover -BlockLegacyAuthMapi -BlockLegacyAuthOfflineAddressBook -BlockLegacyAuthRpc
```

After you create the authentication policy, you can first assign it to a pilot group of users by using the `Set-User user01 -AuthenticationPolicy <name_of_policy>` command. After testing, you can expand the policy to include all users. To apply policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange on-premises PowerShell for this configuration.

## Components

- [Azure AD](https://azure.microsoft.com/products/active-directory). Azure AD is a Microsoft cloud-based identity and access management service. It provides modern authentication that's essentially based on EvoSTS (a Security Token Service used by Azure AD). It's used as an authentication server for Exchange Server on-premises.
- [Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/howto-mfa-getstarted). Multi-factor authentication is a process in which users are prompted during the sign-in process for another form of identification, like a code on their cellphone or a fingerprint scan.
- [Azure AD Conditional Access](/azure/active-directory/conditional-access/concept-conditional-access-conditions). Conditional Access is the feature that Azure AD uses to enforce organizational policies like multi-factor authentication.
- [AD FS](/windows-server/identity/active-directory-federation-services). AD FS enables federated identity and access management by sharing digital identity and entitlements rights across security and enterprise boundaries with improved security. In these architectures, it's used to facilitate sign-in for users with federated identity.
- [Web Application Proxy](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server). Web Application Proxy pre-authenticates access to web applications by using AD FS. It also functions as an AD FS proxy.
- [Microsoft Intune](https://www.microsoft.com/security/business/endpoint-management/microsoft-intune). Intune is our cloud-based unified endpoint management, managing endpoints across Windows, Android, Mac, iOS, and Linux operating systems.
- [Exchange Server](https://www.microsoft.com/microsoft-365/exchange/email). Exchange Server hosts user mailboxes on-premises. In these architectures, it uses tokens issued to the user by Azure AD to authorize access to mailboxes.
- [Active Directory services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview). Active Directory services stores information about members of a domain, including devices and users. In these architectures, user accounts belong to Active Directory services and are synchronized to Azure AD.
- [Outlook for business](https://www.microsoft.com/microsoft-365/outlook/outlook-for-business). Outlook is a client application that supports modern authentication.

## Scenario details

Enterprise messaging infrastructure (EMI) is a key service for organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multi-factor authentication requirements for messaging service access is one of the most effective ways to meet that challenge.

This article describes four architectures to enhance your security in an Outlook desktop-client access scenario by using Azure AD Multi-Factor Authentication.

These are four architectures according to four different possibilities for  Microsoft Exchange:

- [Exchange Online](#architecture-exchange-online)
- [Exchange Online, AD FS](#architecture-exchange-online-ad-fs)
- [Exchange on-premises](#architecture-exchange-on-premises)
- [Exchange on-premises, AD FS](#architecture-exchange-on-premises-ad-fs)

All four architectures cover both Outlook for Windows and Outlook for Mac.

For information about applying multi-factor authentication in other hybrid messaging scenarios, see these articles:

- [Enhanced-security hybrid messaging infrastructure in a web access scenario](secure-hybrid-messaging-web.yml)
- [Enhanced-security hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)

This article doesn't discuss other protocols, like IMAP or POP. Typically, these scenarios don't use these protocols.

### General notes

- These architectures use the [federated](/azure/active-directory/hybrid/whatis-fed) Azure Active Directory (Azure AD) identity model. For the password hash synchronization and Pass-through Authentication models, the logic and flow are the same. The only difference is related to the fact that Azure AD doesn't redirect the authentication request to on-premises Active Directory Federation Services (AD FS).
- By *Exchange on-premises*, we mean Exchange 2019 with the latest updates and a Mailbox role.
- In a real environment, you won't have just one server. You'll have a load-balanced array of Exchange servers for high availability. The scenarios described here are suited for that configuration.

### Potential use cases

This architecture is relevant for the following scenarios:

- Enhance EMI security.
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy.
- Apply your standard high level of protection for your on-premises messaging service during transition to or coexistence with Exchange Online.
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Availability

Overall availability depends on the availability of the components that are involved. For information about availability, see these resources:

- [Advancing Azure Active Directory availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- [Cloud services you can trust: Office 365 availability](https://www.microsoft.com/microsoft-365/blog/2013/08/08/cloud-services-you-can-trust-office-365-availability)
- [What is the Azure Active Directory architecture?](/azure/active-directory/fundamentals/active-directory-architecture)

Availability of on-premises solution components depends on the implemented design, hardware availability, and your internal operations and maintenance routines. For availability information about some of these components, see the following resources:

- [Setting up an AD FS deployment with Always On availability groups](/windows-server/identity/ad-fs/operations/ad-fs-always-on)
- [Deploying high availability and site resilience in Exchange Server](/exchange/high-availability/deploy-ha?view=exchserver-2019)
- [Web Application Proxy in Windows Server](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server)

To use hybrid modern authentication, you need to ensure that all clients on your network can access Azure AD. You also need to consistently maintain Office 365 firewall ports and IP-range openings.

For protocol and port requirements for Exchange Server, see "Exchange client and protocol requirements" in [Hybrid modern authentication overview for use with on-premises Skype for Business and Exchange servers](/microsoft-365/enterprise/hybrid-modern-auth-overview?view=o365-worldwide#do-you-meet-modern-authentication-prerequisites).

For Office 365 IP ranges and ports, see [Office 365 URLs and IP address ranges](/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide).

For information about hybrid modern authentication and mobile devices, read about AutoDetect endpoint in [Other endpoints not included in the Office 365 IP Address and URL Web service](/microsoft-365/enterprise/additional-office365-ip-addresses-and-urls?view=o365-worldwide).

#### Resiliency

For information about the resiliency of the components in this architecture, see the following resources.

- For Azure AD: [Advancing Azure AD availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- For scenarios that use AD FS: [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager](/windows-server/identity/ad-fs/deployment/active-directory-adfs-in-azure-with-azure-traffic-manager)
- For the Exchange on-premises solution: [Exchange high availability](/exchange/high-availability/deploy-ha?view=exchserver-2019)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For information about security and hybrid modern authentication, see [Deep Dive: How Hybrid Authentication Really Works](https://techcommunity.microsoft.com/t5/exchange-team-blog/deep-dive-how-hybrid-authentication-really-works/ba-p/606780).

For closed organizations that have traditional strong perimeter protection, there are security concerns related to Exchange Hybrid Classic configurations. The Exchange Hybrid Modern configuration doesn't support hybrid modern authentication.

For information about Azure AD, see [Azure AD security operations guide](/azure/active-directory/fundamentals/security-operations-introduction).

For information about scenarios that use AD FS security, see these articles:

- [Best practices for securing AD FS and Web Application Proxy](/windows-server/identity/ad-fs/deployment/best-practices-securing-ad-fs)
- [Configure AD FS Extranet Smart Lockout](/windows-server/identity/ad-fs/operations/configure-ad-fs-extranet-smart-lockout-protection)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of your implementation depends on your Azure AD and Microsoft 365 license costs. Total cost also includes costs for software and hardware for on-premises components, IT operations, training and education, and project implementation.

These solutions require at least Azure AD Premium P1. For pricing details, see [Azure AD pricing](https://www.microsoft.com/security/business/identity-access-management/azure-ad-pricing).

For information about AD FS and Web Application Proxy, see [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing).

For more pricing information, see these resources:

- [Microsoft Intune pricing](/mem/intune/fundamentals/licenses)
- [Exchange Online plans](https://www.microsoft.com/microsoft-365/exchange/compare-microsoft-exchange-online-plans)
- [Exchange server pricing](https://www.microsoft.com/microsoft-365/exchange/microsoft-exchange-licensing-faq-email-for-business)

### Performance efficiency

Performance efficiency is the ability of your workload to scale in an efficient manner to meet the demands that your users place on it. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Workload performance depends on the performance of the components that are involved and on network performance. For more information, see [Office 365 performance tuning using baselines and performance history](/microsoft-365/enterprise/performance-tuning-using-baselines-and-history?view=o365-worldwide).

For information about on-premises factors that influence performance for scenarios that include AD FS services, see these resources:

- [Configure performance monitoring](/windows-server/identity/ad-fs/deployment/configure-performance-monitoring)
- [Fine tuning SQL and addressing latency issues with AD FS](/windows-server/identity/ad-fs/operations/adfs-sql-latency)

For information about AD FS scalability, see [Planning for AD FS server capacity](/windows-server/identity/ad-fs/design/planning-for-ad-fs-server-capacity).

For information about Exchange Server on-premises scalability, see [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019).

## Deploy this scenario

Here are the high-level steps:

1. Protect Outlook desktop access by [configuring Exchange Hybrid configuration and enabling hybrid modern authentication](/microsoft-365/enterprise/hybrid-modern-auth-overview?view=o365-worldwide).
1. Block all legacy authentication attempts at the [Azure AD level](/azure/active-directory/conditional-access/block-legacy-authentication). Block legacy authentication attempts on a messaging-services level by using [authentication policy](/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online).

### Set up a Conditional Access policy

To set up an Azure AD Conditional Access policy that enforces multi-factor authentication, as described in some of the architectures in this article:

1. In the **Clients apps** window, select **Mobile apps and desktop clients**:

   :::image type="content" source="./media/client-apps-desktop.png" alt-text="Screenshot that shows the Client apps window.":::

1. Apply the multi-factor authentication requirement in the **Grant** window:

   :::image type="content" source="./media/grant-control-desktop.png" alt-text="Screenshot that shows the Grant window.":::

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Pavel Kondrashov](https://www.linkedin.com/in/kondrashov-pv) | Cloud Solution Architect
- [Ella Parkum](https://www.linkedin.com/in/ella-parkum-15036923) | Principal Customer Solution Architect-Engineering

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Announcing Hybrid Modern Authentication for Exchange On-Premises](https://techcommunity.microsoft.com/t5/exchange-team-blog/announcing-hybrid-modern-authentication-for-exchange-on-premises/ba-p/607476)
- [Hybrid modern authentication overview and prerequisites for use with on-premises Exchange servers](/microsoft-365/enterprise/hybrid-modern-auth-overview?view=o365-worldwide)
- [Use AD FS claims-based authentication with Outlook on the web](/exchange/clients/outlook-on-the-web/ad-fs-claims-based-auth?view=exchserver-2019)
- [How to configure Exchange Server on-premises to use Hybrid Modern Authentication](/microsoft-365/enterprise/configure-exchange-server-for-hybrid-modern-authentication?view=o365-worldwide)
- [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019)
- [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager](/windows-server/identity/ad-fs/deployment/active-directory-adfs-in-azure-with-azure-traffic-manager)
- [Using hybrid Modern Authentication with Outlook for iOS and Android](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019)
- [Account setup with modern authentication in Exchange Online](/exchange/clients-and-mobile-in-exchange-online/outlook-for-ios-and-android/setup-with-modern-authentication)

## Related resources

- [Enhanced-security hybrid messaging infrastructure in a web access scenario](secure-hybrid-messaging-web.yml)
- [Enhanced-security hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)
