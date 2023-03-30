
The article shows how to implement multi-factor authentication for Outlook mobile clients that access Microsoft Exchange. There are two architectures that correspond to two different possibilities for the Microsoft Exchange that has the user mailbox:

- [Exchange Online](#architecture-exchange-online)
- [Exchange on-premises](#architecture-exchange-on-premises)

## Architecture (Exchange Online)

:::image type="content" border="false" source="./media/mobile-online.png" alt-text="Diagram that shows an architecture for enhanced security in an Outlook mobile access scenario. The user's mailbox is in Exchange Online." lightbox="./media/mobile-online.png":::

In this scenario, users need to use a mobile client that supports modern authentication. We recommend Outlook mobile (Outlook for iOS / Outlook for Android), which is supported by Microsoft. The following workflow uses Outlook mobile.

### Workflow (Exchange Online)

1. The user starts Outlook profile configuration by entering an email address. Outlook mobile connects to the AutoDetect service.
1. The AutoDetect service makes an anonymous AutoDiscover V2 request to Exchange Online to get the mailbox. Exchange Online replies with a 302 redirect response that contains the ActiveSync URL address for the mailbox, pointing to Exchange Online. You can see an [example of this type of request here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow).
1. Now that the AutoDetect service has information about the endpoint of the mailbox content, it can call ActiveSync without authentication.
1. As described in the [connection flow here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow), Exchange responds with a 401 challenge response. It includes an authorization URL that identifies the Azure AD endpoint that the client needs to use to get an access token.
1. The AutoDetect service returns the Azure AD authorization endpoint to the client.
1. The client connects to Azure AD to complete authentication and enter sign-in information (email).
1. If the domain is federated, the request is redirected to Web Application Proxy.
1. Web Application Proxy proxies the authentication request to AD FS. The user sees a sign-in page.
1. The user enters credentials to complete authentication.
1. The user is redirected back to Azure AD.
1. Azure AD applies an Azure Conditional Access policy.
1. The policy can enforce restrictions based on the user's device state if the device is enrolled in Microsoft Endpoint Manager, enforce application protection policies, and/or enforce multi-factor authentication. You can find a detailed example of this type of [policy in the implementation steps described here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#implementation-steps).
1. The user implements any policy requirements and completes the multi-factor authentication request.
1. Azure AD returns access and refresh tokens to the client.
1. The client uses the access token to connect to Exchange Online and retrieve the mailbox content.

### Configuration (Exchange Online)

To block attempts to access Exchange Online ActiveSync via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook mobile service uses. Specifically, you need to disable AutoDiscover, ActiveSync, and Outlook Service. Here's the corresponding authentication policy configuration:

> AllowBasicAuthAutodiscover         : False
>
> AllowBasicAuthActiveSync           : False
>
> AllowBasicAuthOutlookService       : False

After you create the authentication policy, you can assign it to a pilot group of users. Then, after testing, you can expand the policy for all users. To apply the policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange Online PowerShell for this configuration.

For federated domains, you can configure AD FS to trigger multi-factor authentication instead of using a Conditional Access policy. However, we recommend that you control the connection and apply restrictions at the Conditional Access policy level.

## Architecture (Exchange on-premises)

:::image type="content" border="false" source="./media/mobile-on-premises.png" alt-text="Diagram that shows an architecture for enhanced security in an Outlook mobile access scenario. The user's mailbox is in Exchange on-premises." lightbox="./media/mobile-on-premises.png":::

In this scenario, users need to use a mobile client that supports modern authentication, as described in [Using hybrid modern authentication](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019). We recommend Outlook mobile (Outlook for iOS / Outlook for Android), which is supported by Microsoft. The following workflow uses Outlook mobile.

### Workflow (Exchange on-premises)

1. The user starts Outlook profile configuration by entering an email address. Outlook mobile connects to the AutoDetect service.
1. The AutoDetect service makes an anonymous AutoDiscover V2 request to Exchange Online to get the mailbox.
1. After the mailbox is located on-premises, Exchange Online replies with a 302 redirect response that contains an on-premises AutoDiscover URL that AutoDetect can use to retrieve the ActiveSync URL address for the mailbox.
1. AutoDetect uses the on-premises URL that it received in the previous step to make an anonymous AutoDiscover v2 request to Exchange on-premises to get the mailbox. Exchange on-premises returns an ActiveSync URL address for the mailbox, pointing to Exchange on-premises. You can see an [example of this type of request here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow).
1. Now that the AutoDetect service has information about the endpoint of the mailbox content, it can call the on-premises ActiveSync endpoint without authentication. As described in the [connection flow here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow), Exchange responds with a 401 challenge response. It includes an authorization URL that identifies the Azure AD endpoint that the client needs to use to get an access token.
1. The AutoDetect service returns the Azure AD authorization endpoint to the client.
1. The client connects to Azure AD to complete authentication and enter sign-in information (email).
1. If the domain is federated, the request is redirected to Web Application Proxy.
1. Web Application Proxy proxies the authentication request to AD FS. The user sees a sign-in page.
1. The user enters credentials to complete authentication.
1. The user is redirected back to Azure AD.
1. Azure AD applies an Azure Conditional Access policy.
1. The policy can enforce restrictions based on the user's device state if the device is enrolled in Microsoft Endpoint Manager, enforce application protection policies, and/or enforce multi-factor authentication. You can find a detailed example of this type of policy in the [implementation steps described here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#implementation-steps).
1. The user implements any policy requirements and completes the multi-factor authentication request.
1. Azure AD returns access and refresh tokens to the client.
1. The client uses the access token to connect to Exchange Online and retrieve the on-premises mailbox content. The content should be provided from the [cache, as described here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#microsoft-cloud-architecture-for-hybrid-exchange-server-customers). To achieve that, the client issues a provisioning request that includes the user's access token and the on-premises ActiveSync endpoint.
1. The provisioning API in Exchange Online takes the provided token as an input. The API obtains a second access-and-refresh token pair to access the on-premises mailbox via an on-behalf-of call to Active Directory. This second access token is scoped with the client as Exchange Online and an audience of the on-premises ActiveSync namespace endpoint.
1. If the mailbox isn't provisioned, the provisioning API creates a mailbox.
1. The provisioning API establishes a secure connection to the on-premises ActiveSync endpoint. The API synchronizes the user's messaging data by using the second access token as the authentication mechanism. The refresh token is used periodically to generate a new access token so that data can synchronize in the background without user intervention.
1. Data is returned to the client.

### Configuration (Exchange on-premises)

To block attempts to access Exchange on-premises ActiveSync via legacy authentication (the red dashed lines in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook mobile service uses. Specifically, you need to disable AutoDiscover and ActiveSync. Here's the corresponding authentication policy configuration:

> BlockLegacyAuthAutodiscover: True
>
> BlockLegacyAuthActiveSync: True

Here's an example of a command for creating this authentication policy:

```powershell
New-AuthenticationPolicy -Name BlockLegacyActiveSyncAuth -BlockLegacyAuthActiveSync -BlockLegacyAuthAutodiscover
```

After you create the authentication policy, you can first assign it to a pilot group of users by using the `Set-User user01 -AuthenticationPolicy <name_of_policy>` command. After testing, you can expand the policy to include all users. To apply the policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange on-premises PowerShell for this configuration.

You also need to take steps to achieve consistency and allow access only from the Outlook client. To allow Outlook mobile as the only approved client in the organization, you need to block connection attempts from clients that aren't Outlook mobile clients that support modern authentication. You need to block these attempts on the Exchange on-premises level by completing these steps:

- Block other mobile device clients:

  ```powershell
  Set-ActiveSyncOrganizationSettings -DefaultAccessLevel Block
  ```  

- Allow Exchange Online to connect to on-premises:

  ```powershell
  If ((Get-ActiveSyncOrganizationSettings).DefaultAccessLevel -ne "Allow") {New-ActiveSyncDeviceAccessRule -Characteristic DeviceType -QueryString "OutlookService" -AccessLevel Allow}
  ```

- Block basic authentication for Outlook for iOS and Android:

  ```powershell
  New-ActiveSyncDeviceAccessRule -Characteristic DeviceModel -QueryString "Outlook for iOS and Android" -AccessLevel Block
  ```

For more information about these steps, see [Using hybrid Modern Authentication with Outlook for iOS and Android](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#implementation-steps).

For federated domains, you can configure AD FS to trigger multi-factor authentication instead of using a Conditional Access policy. However, we recommend that you control the connection and apply restrictions at the Conditional Access policy level.

## Components

- [Azure AD](https://azure.microsoft.com/products/active-directory). Azure AD is a Microsoft cloud-based identity and access management service. It provides modern authentication that's essentially based on EvoSTS (a Security Token Service used by Azure AD). It's used as an authentication server for Exchange Server on-premises.
- [Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/howto-mfa-getstarted). Multi-factor authentication is a process in which users are prompted during the sign-in process for another form of identification, like a code on their cellphone or a fingerprint scan.
- [Azure AD Conditional Access](/azure/active-directory/conditional-access/concept-conditional-access-conditions). Conditional Access is the feature that Azure AD uses to enforce organizational policies like multi-factor authentication.
- [AD FS](/windows-server/identity/active-directory-federation-services). AD FS enables federated identity and access management by sharing digital identity and entitlements rights across security and enterprise boundaries with improved security. In these architectures, it's used to facilitate sign-in for users with federated identity.
- [Web Application Proxy](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server). Web Application Proxy pre-authenticates access to web applications by using AD FS. It also functions as an AD FS proxy.
- [Microsoft Intune](https://www.microsoft.com/security/business/endpoint-management/microsoft-intune). Intune is our cloud-based unified endpoint management, managing endpoints across Windows, Android, Mac, iOS, and Linux operating systems.
- [Exchange Server](https://www.microsoft.com/microsoft-365/exchange/email). Exchange Server hosts user mailboxes on-premises. In these architectures, it uses tokens issued to the user by Azure AD to authorize access to mailboxes.
- [Active Directory services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview). Active Directory services stores information about members of a domain, including devices and users. In these architectures, user accounts belong to Active Directory services and are synchronized to Azure AD.

## Alternatives

You can use third-party mobile clients that support modern authentication as an alternative to Outlook mobile. If you choose this alternative, the third-party vendor is responsible for the clients' support.

## Scenario details

Enterprise messaging infrastructure (EMI) is a key service for organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multi-factor authentication requirements for messaging service access is one of the most effective ways to meet that challenge.

This article describes two architectures to help you enhance your security in an Outlook mobile access scenario by using Azure AD Multi-Factor Authentication.

These scenarios are described in this article:

- Outlook mobile access when the user's mailbox is in Exchange Online
- Outlook mobile access when the user's mailbox is in Exchange on-premises

Both architectures cover both Outlook for iOS and Outlook for Android.

For information about applying multi-factor authentication in other hybrid messaging scenarios, see these articles:

- [Enhanced-security hybrid messaging infrastructure in a web access scenario](secure-hybrid-messaging-web.yml)
- [Enhanced-security hybrid messaging infrastructure in a desktop-client access scenario](secure-hybrid-messaging-client.yml)

This article doesn't discuss other protocols, like IMAP or POP. Typically, these scenarios don't use these protocols.

### General notes

- These architectures use the [federated](/azure/active-directory/hybrid/whatis-fed) Azure Active Directory (Azure AD) identity model. For the password hash synchronization and Pass-through Authentication models, the logic and flow are the same. The only difference is related to the fact that Azure AD won't redirect the authentication request to on-premises Active Directory Federation Services (AD FS).
- In the diagrams, black dashed lines show basic interactions between local Active Directory, Azure AD Connect, Azure AD, AD FS, and Web Application Proxy components. You can learn about these interactions in [Hybrid identity required ports and protocols](/azure/active-directory/hybrid/reference-connect-ports).
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

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

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

For general guidance about security on mobile devices, see [Protect data and devices with Microsoft Intune](/mem/intune/protect/device-protect).

For information about security and hybrid modern authentication, see [Deep Dive: How Hybrid Authentication Really Works](https://techcommunity.microsoft.com/t5/exchange-team-blog/deep-dive-how-hybrid-authentication-really-works/ba-p/606780).

For closed organizations that have traditional strong perimeter protection, there are security concerns related to Exchange Hybrid Classic configurations. The Exchange Hybrid Modern configuration doesn't support hybrid modern authentication.

For information about Azure AD, see [Azure AD security operations guide](/azure/active-directory/fundamentals/security-operations-introduction).

For information about scenarios that use AD FS security, see these articles:

- [Best practices for securing AD FS and Web Application Proxy](/windows-server/identity/ad-fs/deployment/best-practices-securing-ad-fs)
- [Configure AD FS Extranet Smart Lockout](/windows-server/identity/ad-fs/operations/configure-ad-fs-extranet-smart-lockout-protection)

### Cost optimization

The cost of your implementation depends on your Azure AD and Microsoft 365 license costs. The total cost also includes costs for software and hardware for on-premises components, IT operations, training and education, and project implementation.

These solutions require at least Azure AD Premium P1. For pricing details, see [Azure AD pricing](https://www.microsoft.com/security/business/identity-access-management/azure-ad-pricing).

For information about AD FS and Web Application Proxy, see [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing).

For more pricing information, see these resources:

- [Microsoft Intune pricing](/mem/intune/fundamentals/licenses)
- [Exchange Online plans](https://www.microsoft.com/microsoft-365/exchange/compare-microsoft-exchange-online-plans)
- [Exchange server pricing](https://www.microsoft.com/microsoft-365/exchange/microsoft-exchange-licensing-faq-email-for-business)

### Performance efficiency

Performance depends on the performance of the components that are involved and your company's network performance. For more information, see [Office 365 performance tuning using baselines and performance history](/microsoft-365/enterprise/performance-tuning-using-baselines-and-history?view=o365-worldwide).

For information about on-premises factors that influence performance for scenarios that include AD FS services, see these resources:

- [Configure performance monitoring](/windows-server/identity/ad-fs/deployment/configure-performance-monitoring)
- [Fine tuning SQL and addressing latency issues with AD FS](/windows-server/identity/ad-fs/operations/adfs-sql-latency)

#### Scalability

For information about AD FS scalability, see [Planning for AD FS server capacity](/windows-server/identity/ad-fs/design/planning-for-ad-fs-server-capacity).

For information about Exchange Server on-premises scalability, see [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019).

## Deploy this scenario

To implement this infrastructure, you need to complete the steps outlined in the guidance included in the following articles.
Here are the high-level steps:

1. Secure Outlook mobile access as described in [these implementation steps for modern authentication](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#implementation-steps).
1. [Block all other legacy authentication attempts at the Azure AD level.](/azure/active-directory/conditional-access/block-legacy-authentication)
1. [Block legacy authentication attempts at the messaging services level by using authentication policy.](/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

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
- [Enhanced-security hybrid messaging infrastructure in a desktop-client access scenario](secure-hybrid-messaging-client.yml)
