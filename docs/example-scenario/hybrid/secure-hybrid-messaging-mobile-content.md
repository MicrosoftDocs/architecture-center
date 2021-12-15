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

## Potential use cases
This architecture is relevant for the following scenarios:

- Enhance EMI security.
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy.
- Apply your standard high level of protection for your on-premises messaging service during transition to or coexistence with Exchange Online.
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector.

## Architecture

### General notes
- These architectures use the [federated](/microsoft-365/enterprise/plan-for-directory-synchronization?view=o365-worldwide#federated-authentication) Azure Active Directory (Azure AD) identity model. For the password hash synchronization and Pass-through Authentication models, the logic and flow are the same. The only difference is related to the fact that Azure AD won't redirect the authentication request to on-premises Active Directory Federation Services (AD FS).
- In the diagrams, black dashed lines show basic interactions between local Active Directory, Azure AD Connect, Azure Active Directory (Azure AD), AD FS, and Web Application Proxy components. You can learn about these interactions in [Hybrid identity required ports and protocols](/azure/active-directory/hybrid/reference-connect-ports).
- By *Exchange on-premises*, we mean Exchange 2019 with the latest updates and a Mailbox role.
- In a real environment, you won't have just one server. You'll have a load-balanced array of Exchange servers for high availability. The scenarios described here are suited for that configuration.

### Outlook mobile access when the user's mailbox is in Exchange Online

:::image type="content" border="false" source="./media/mobile-online.png" alt-text="Diagram that shows an architecture for enhanced security in an Outlook mobile access scenario. The user's mailbox is in Exchange Online." lightbox="./media/mobile-online.png":::

In this scenario, users need to use a mobile client that supports modern authentication. We recommend Outlook mobile (Outlook for iOS / Outlook for Android), which is supported by Microsoft. The following workflow uses Outlook mobile.

1.	The user starts Outlook profile configuration by entering an email address. Outlook mobile connects to the AutoDetect service. 
2.	The AutoDetect service makes an anonymous AutoDiscover V2 request to Exchange Online to get the mailbox. Exchange Online replies with a 302 redirect response that contains the ActiveSync URL address for the mailbox, pointing to Exchange Online. You can see an [example of this type of request here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow).
3.	Now that the AutoDetect service has information about the endpoint of the mailbox content, it can call ActiveSync without authentication.
4.	Based on the [connection flow described here](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#connection-flow), on-premises ActiveSync responds with a 401 challenge response. It includes an authorization URL that identifies the Azure AD endpoint that the client needs to use to get an access token.
5.	The AutoDetect service returns the Azure AD authorization endpoint to the client.
6.	The client connects to Azure AD to complete authentication and enter sign-in information (email).
7.	If the domain is federated, the request is redirected to Web Application Proxy.
8.	Web Application Proxy proxies the authentication request to AD FS. The user gets a sign-in page.
9.	The user enters credentials to complete authentication.
10.	The user is redirected back to Azure AD.
11.	Azure AD applies an Azure Conditional Access policy.
12.	The policy can enforce restrictions based on the user's device state if the device is enrolled in Microsoft Endpoint Manager, enforce application protection policies, and/or enforce multi-factor authentication. You can find a detailed example of this type of [policy in the implementation steps described here](https://docs.microsoft.com/en-us/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019#implementation-steps).
13.	The user implements any policy requirements and completes the multi-factor authentication request.
14.	Azure AD returns access and refresh tokens to the client.
15. The client uses the access token to connect to Exchange Online and retrieve the mailbox content.

To block attempts to access Exchange Online ActiveSync via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols used by Outlook mobile service. Specifically, you need to disable AutoDiscover, ActiveSync, and Outlook Service. Here's the corresponding authentication policy configuration:
```
AllowBasicAuthAutodiscover         : False
AllowBasicAuthActiveSync           : False
AllowBasicAuthOutlookService       : False
```
After you create the authentication policy, you can assign it to a pilot group of users. Then, after testing, you can expand the policy for all users. To apply the policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_policy>` command. You need to use Exchange Online PowerShell for this configuration.

For federated domains, you can configure AD FS to trigger multi-factor authentication instead of using a Conditional Access policy. We recommend that you control the connection and apply restrictions at the Conditional Access policy level.

### Outlook mobile access when the user's mailbox is in Exchange on-premises

:::image type="content" border="false" source="./media/mobile-on-premises.png" alt-text="Diagram that shows an architecture for enhanced security in an Outlook mobile access scenario. The user's mailbox is in Exchange on-premises." lightbox="./media/mobile-on-premises.png":::

In this scenario, users need to use a mobile client that supports modern authentication, as described in [Using hybrid modern authentication](/exchange/clients/outlook-for-ios-and-android/use-hybrid-modern-auth?view=exchserver-2019). We recommend Outlook mobile (Outlook for iOS / Outlook for Android), which is supported by Microsoft. The following workflow uses Outlook mobile.

1.	User is starting Outlook profile configuration entering email address. OM will connect to autodetect service. 
2.	Autodetect service will make an anonymous autodiscover v2 request to Exchange Online for mailbox. 
3.	As soon as mailbox is located on-premises, Exchange Online will reply with 302 redirect response containing on-premises autodiscover url to retrieve the Active-Sync (EAS) url address for mailbox.
4.	Autodetect will use the on-premises url received in Step 2 to make an anonymous autodiscover v2 request to Exchange On-premises for mailbox. Exchange on-premises will return Active-Sync (EAS) url address for mailbox, pointing to Exchange On-premises. Example of such request maybe found in article [here].
5.	Now, having knowledge about the endpoint where we may retrieve the mailbox content, Autodetect service will make a call to On-premises EAS endpoint without authentication. Based on the [flow] described in this article, EXO will respond with a 401-challenge and include and authorization url, pointing to Azure AD, where client need to go to complete authentication to get an Access token.
6.	Autodetect service will return Azure AD authorization endpoint to the client.
7.	Client will connect to Azure AD to complete authentication and enter login (email).
8.	In case the domain is federated, the request will be redirected to WAP.
9.	WAP will proxy authentication request to ADFS, user will see the login page.
10.	User will enter credentials and successfully complete authentication.
11.	As soon as it is done, user will be redirected back to Azure AD.
12.	On Azure AD level, Azure Conditional Access policy will come into play for such scenario.
13.	This policy may enforce restrictions based on user’s device state if it is enrolled in Microsoft Endpoint Management (MEM) solution or not, enforce application protection policies application and/or enforce MFA requirements. Detailed example of such policy may be found in [“Implementation steps”] section of the article mentioned earlier.
14.	User will follow the policy requirements and apply restrictions/complete MFA request.
15.	Azure AD will return to the client Access and Refresh tokens.
16.	Having a valid Access token, client will connect to Exchange Online to retrieve the on-premises mailbox content which should be provided from the cache as it is described [here]. To achieve that client will issue a provisioning request that includes the user's access token and the on-premises ActiveSync endpoint.
17.	The provisioning API within Exchange Online uses provided token as input and obtains a second access-and-refresh token pair to access the on-premises mailbox via an on-behalf-of call to Active Directory. This second access token is scoped with the client being Exchange Online and an audience of the on-premises ActiveSync namespace endpoint.
18.	If the mailbox isn't provisioned, then the provisioning API creates a mailbox.
19.	The provisioning API establishes a secure connection to the on-premises ActiveSync endpoint and synchronizes the user's messaging data using the second access token as the authentication mechanism. Having Refresh token, it will periodically generate a new Access token so that data can be synchronized in the background without user intervention.
20.	Data is returned to the client.
