Enterprise messaging infrastructure (EMI) is a key service for organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multifactor authentication requirements for messaging service access is one of the most effective ways to meet that challenge.

This article describes four architectures to enhance your security in an Outlook desktop-client access scenario by using Azure AD Multi-Factor Authentication.

These four scenarios are described in this article:
- Outlook client access when the user's mailbox is in Exchange Online
- Outlook client access when the user's mailbox is in Exchange Online, AD FS
- Outlook client access when the user's mailbox is in Exchange on-premises
- Outlook client access when the user's mailbox is in Exchange on-premises, AD FS

For information about applying multifactor authentication in other hybrid messaging scenarios, see these articles:
- [Protecting a hybrid messaging infrastructure in a web access scenario](secure-hybrid-messaging-web.yml)
- [Protecting a hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)

All four architectures cover both Outlook for Windows and Outlook for MAC.

This article doesn't discuss other protocols, like IMAP or POP. We don't expect these protocols to be used commonly in these scenarios. 

## Potential use cases
This architecture is relevant for the following scenarios:
- Enhance EMI security.
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy.
- Apply your standard high level of protection for your on-premises messaging service during transition to or coexistence with Exchange Online.
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector.

## Architecture

### General notes

- These architectures use the [federated](/microsoft-365/enterprise/plan-for-directory-synchronization?view=o365-worldwide#federated-authentication) Azure Active Directory (Azure AD) identity model. For the password hash synchronization and Pass-through Authentication models, the logic and flow are the same. The only difference is related to the fact that Azure AD won't redirect the authentication request to on-premises Active Directory Federation Services (AD FS).

- In the diagrams, dashed arrows show basic interactions between local Active Directory, Azure AD Connect, Azure AD, AD FS, and Web Application Proxy components. You can learn about these interactions in [Hybrid identity required ports and protocols](/azure/active-directory/hybrid/reference-connect-ports).

- By *Exchange on-premises*, we mean Exchange 2019 with the latest updates, Mailbox role. 

- In a real environment, you won't have just one server. You'll have a load-balanced array of Exchange servers for high availability. The scenarios described here are suited for that configuration.

### Outlook client access when the user's mailbox is in Exchange Online

:::image type="content" border="false" source="./media/desktop-online-option-1.png" alt-text="Screenshot that shows an architecture for enhanced security in an Outlook client access scenario. The user's mailbox is in Exchange Online." lightbox="./media/desktop-online-option-1.png":::
:::image-end:::

In this scenario, users need to use the version of Outlook client that supports modern authentication. For more information, see [How modern authentication works for Office 2013, Office 2016, and Office 2019 client apps](/microsoft-365/enterprise/modern-auth-for-office-2013-and-2016?view=o365-worldwide).

This architecture covers both Outlook for Windows and Outlook for MAC.

1. The user tries to access Exchange Online via Outlook. 
1. Exchange Online provides the URL of an Azure AD endpoint for retrieving the access token to get access to the mailbox.
1. Outlook connects to Azure AD by using that URL.
1.	As soon as the domain is federated, Azure AD redirects the request to on-premises AD FS.
1.	The user enters credentials on an AD FS sign-in page.
1.	AD FS redirects the session back to Azure AD. 
1.	Azure AD applies an Azure Conditional Access policy with a multifactor authentication requirement for mobile apps and desktop clients. See the [deployment section](#deploy-this-scenario)  of this article for information about setting up that policy.
1.	The Conditional Access policy calls Azure AD Multi-Factor Authentication. The user gets a request to complete multifactor authentication.
1.	The user completes multifactor authentication.
1.	Azure AD issues access and refresh tokens and returns them to the client.
1.	By using the access token, the client connects to Exchange Online and retrieves the content.

To block attempts to access Exchange Online via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, and EWS. Here's the corresponding configuration:
```
AllowBasicAuthAutodiscover         : False
AllowBasicAuthMapi                 : False
AllowBasicAuthOfflineAddressBook   : False
AllowBasicAuthWebServices          : False
AllowBasicAuthRpc                  : False
```
(RPC protocol is [no longer supported](/exchange/troubleshoot/administration/rpc-over-http-end-of-support) for Office 365, so the last parameter shouldn't affect clients in any way.)

Here's an example of a command for creating this authentication policy: 
```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -AllowBasicAuthRpc:$false -AllowBasicAuthMapi:$false -AllowBasicAuthAutodiscover:$false
-AllowBasicAuthWebServices:$false -AllowBasicAuthOfflineAddressBook:$false
```

> [!NOTE]
> By default, after you create the policy, legacy authentication for all other protocols (like IMAP, POP, and ActiveSync) is also disabled. To change this behavior, you can enable protocols by using a PowerShell command like this one:
>
> `Set-AuthenticationPolicy -Identity BlockOutlook -AllowBasicAuthImap:$true`

After you create the authentication policy, you can first assign it to a pilot group of users by using the `Set-User user01 -AuthenticationPolicy <name_of_policy>` command. After testing, you can expand it to all users. To apply policy at the organization level, use the `Set-OrganizationConfig -DefaultAuthenticationPolicy <name_of_the_policy>` command. You need to use Exchange Online PowerShell for this configuration.

### Outlook client access when the user's mailbox is in Exchange Online, AD FS

:::image type="content" border="false" source="./media/desktop-online-option-2.png" alt-text="Screenshot that shows an alternative architecture for enhanced security in an Outlook client access scenario." lightbox="./media/desktop-online-option-2.png":::
:::image-end:::

This scenario is the same as the previous one, except that it uses a different trigger for multifactor authentication. In the previous scenario, we used local AD FS for authentication. We then redirected information about successful authentication to Azure AD, where a Conditional Access policy enforced multifactor authentication. It this scenario, instead of using Conditional Access to enforce multifactor authentication, we create an access control policy on the AD FS level and enforce multifactor authentication there. The rest of the architecture is the same as the previous one. 

> [!NOTE]
> 
> We recommend this scenario only if you are unable to use the previous one. 

This architecture covers both Outlook for Windows and Outlook for MAC.

In this scenario, users need to use the version of Outlook client that supports modern authentication. For more information, see [How modern authentication works for Office 2013, Office 2016, and Office 2019 client apps](/microsoft-365/enterprise/modern-auth-for-office-2013-and-2016?view=o365-worldwide).

1.	The user tries to access Exchange Online via Outlook. 
2.	Exchange Online provides the URL of an Azure AD endpoint for retrieving the access token to get access to the mailbox. 
3.	Outlook connects to Azure AD by using that URL.
4.	If the domain is federated, Azure AD redirects the request to on-premises AD FS.
5.	The user enters credentials on an AD FS sign-in page.
6.	Responding to an AF DS access control policy, AD FS calls Azure AD Multi-Factor Authentication to complete authentication. Here's an example of that type of AD FS access control policy:

    :::image type="content" source="./media/access-control-policy.png" alt-text="Screenshot that shows an example of an AD FS access control policy."::: 
    The user gets a request to complete multifactor authentication.
7.	The user completes multifactor authentication. 
8.	AD FS redirects the session back to Azure AD. 
9.	Azure AD issues access and refresh tokens and returns them to the client.
10.	By using the access token, the client connects to Exchange Online and retrieves the content.

> [!NOTE]
>
> The access control policy implemented in step 6 is applied on the relying-party-trust level, so it affects all authentication requests for all Office 365 services that go through AD FS. You can [use AD FS authentication rules to apply additional filtering](/windows-server/identity/ad-fs/operations/configure-authentication-policies#to-configure-mfa-per-relying-party-trust-that-is-based-on-a-users-group-membership-data). However, to achieve better flexibility and apply the common practice, we recommend that you use a Conditional Access policy (described in the previous architecture) rather than using an AD FS access control policy for Microsoft 365 services.

To block attempts to access Exchange Online via legacy authentication (the red dashed line in the diagram), you need to create an [authentication policy](/powershell/module/exchange/new-authenticationpolicy?view=exchange-ps) that disables legacy authentication for protocols that the Outlook service uses. These are the specific protocols that you need to disable: Autodiscover, MAPI, Offline Address Books, and EWS. Here's the corresponding configuration:

```
AllowBasicAuthAutodiscover         : False
AllowBasicAuthMapi                 : False
AllowBasicAuthOfflineAddressBook   : False
AllowBasicAuthWebServices          : False
AllowBasicAuthRpc                  : False
```
(RPC protocol is [no longer supported](/exchange/troubleshoot/administration/rpc-over-http-end-of-support) for Office 365, so the last parameter shouldn't affect clients in any way.)

Here's an example of a command for creating this authentication policy: 
```powershell
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -AllowBasicAuthRpc:$false -AllowBasicAuthMapi:$false -AllowBasicAuthAutodiscover:$false
-AllowBasicAuthWebServices:$false -AllowBasicAuthOfflineAddressBook:$false
```

### Outlook client access when the user's mailbox is in Exchange on-premises

:::image type="content" border="false" source="./media/desktop-on-premises-option-1.png" alt-text="Screenshot that shows an enhanced security architecture in an on-premises Outlook client access scenario." lightbox="./media/desktop-on-premises-option-1.png":::
:::image-end:::

This architecture covers both Outlook for Windows and Outlook for MAC.

1. User with mailbox on Exchange server starts Outlook client. Outlook client makes connection to Exchange server and advertise modern authentication capability.
2. Exchange server will send response to client “to get token from Azure AD”. 
3. Outlook client connects to Azure Active Directory url provided by Exchange server.
4. Azure identifies that user’s domain is federated and therefore sends requests to ADFS (through WAP).
5. User enters credentials on ADFS sign-in page.
6. ADFS redirects back to Azure AD.
7. To enforce MFA requirement Azure AD will apply Azure Conditional Access Policy (CAP) with MFA requirement for “Mobile Apps and desktop clients”. Example of such policy configuration:

is this the same as above? yes. See the [deployment section] of this article for information about setting up that policy.

8.	CAP will call for Azure MFA service to complete authentication. User will get MFA request and go through that.
9.	User will successfully complete MFA request.
10.	Azure AD will issue and return Access and Refresh tokens to the client.
11.	User will present access token to Exchange server, and it will authorize access to the mailbox.

To block attempts to access Exchange On-premises via legacy authentication (read arrow on the diagram), we need to create an [Authentication Policy] which will disable legacy authentication for protocols used by Outlook service, in particular Autodiscover, Mapi, OAB, EWS and RPC, what corresponds to the following parameters for Authentication Policy configuration:    SAME as above 

this list not the same 
BlockLegacyAuthAutodiscover       : True
BlockLegacyAuthMapi               : True
BlockLegacyAuthOfflineAddressBook : True
BlockLegacyAuthRpc                : True
BlockLegacyAuthWebServices        : True

following not the same as above
Rpc protocol does not support modern authentication (and Azure MFA as a result) and Mapi is [recommended] protocol for Windows client.

not the same as above:
Example of command to create such Authentication Policy: 
not the same as above:
New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -BlockLegacyAuthAutodiscover -BlockLegacyAuthMapi -BlockLegacyAuthOfflineAddressBook -BlockLegacyAuthRpc

not same as above:

After authentication policy creation, we may first assign it to the pilot group of users with Set-User user01 -AuthenticationPolicy <<name_of_the_policy>> command and after successful testing expand it for all users to apply policy on organization level with Set-OrganizationConfig -DefaultAuthenticationPolicy <<name_of_the_policy>> command. Configuration needs to be done through Exchange On-premises PowerShell.

### Outlook Access for user's mailbox in Exchange on-premises, option 2

:::image type="content" border="false" source="./media/desktop-on-premises-option-2.png" alt-text="Screenshot that shows an alternative enhanced security architecture in an on-premises Outlook Access scenario." lightbox="./media/desktop-on-premises-option-2.png":::
:::image-end:::

(Outlook for Windows/Outlook for MAC)

Scenario 5 is similar to Scenario 4. However, MFA in this scenario is triggered by ADFS. Unless scenario 4 with conditional account not available, this scenario is not recommended.

Flow in scenario 5 is following:

1.	User starts Outlook client. Client will connect to Exchange server. Client advertises modern authentication capabilities. 
2.	Exchange server responds to client to get token from Azure Active Directory. Exchange server provides client with url to Azure Active Directory authentication service. 
3.	Client utilizes url and accesses Azure AD. 
4.	In this scenario with ADFS usage, domain is federated. Azure AD redirects client to ADFS through WAP
5.	User enters credentials on ADFS sign page.
6.	ADFS triggers MFA authentication. User will get MFA request and go through that. Example of such ADFS Access Control policy:

same as above? 

7.	MFA request is accomplished by user.
8.	After successful authentication ADFS will redirect back to Azure AD
9.	Azure AD will issue access and refresh tokens to the end user. 
10.	Client will present access token to Exchange on-premises server and it will authorize access to the user’s mailbox.

same as above? 

### Components
[Azure Active Directory.] Azure Active Directory (Azure AD) is Microsoft’s cloud-based identity and access management service. Modern authentication essentially based on EvoSTS (a Security Token Service used by Azure AD) and used as Auth Server for Skype for Business and Exchange server on-premises.

[Azure AD Multifactor authentication.] Multi-factor authentication is a process where a user is prompted during the sign-in process for an additional form of identification, such as to enter a code on their cellphone or to provide a fingerprint scan.

[Azure Active Directory Conditional Access .] Conditional Access is the tool used by Azure Active Directory to bring signals together, to make decisions, and enforce organizational policies such as MFA.

[Active Directory Federation Services | Microsoft Docs.] Active Directory Federation Service (AD FS) enables Federated Identity and Access Management by securely sharing digital identity and entitlements rights across security and enterprise boundaries. In this architecture it is used to facilitate logon for users with federated identity

[Web Application Proxy] Web Application Proxy pre-authenticates access to web applications by using Active Directory Federation Services (AD FS), and functions as an AD FS proxy.

[Microsoft Endpoint Manager | Microsoft 365] Microsoft Intune is part of Microsoft Endpoint Manager and is a 100% cloud-based mobile device management (MDM) and mobile application management. After hybrid Modern Authentication is enabled, all on-premises mobile users can use Outlook for iOS and Android using the Microsoft 365 or Office 365-based architecture. Therefore, it is important to protect corporate data with an Intune app protection policy.

[Microsoft Exchange Server.] Microsoft Exchange server hosts user mailboxes on-premises. In this architecture, it will use tokens issued to the user by Azure Active Directory to authorize access to the mailbox.

[Active Directory services.] Active directory services It stores information about members of the domain, including devices and users. In this architecture user accounts belong to Active Directory Services and synchronized to Azure Active Directory

[Microsoft Outlook for business - Microsoft.] Microsoft Outlook is a client supporting modern authentication. 

## Considerations

### Availability

Overall availability depends on the availability of the components involved. For information about availability, see these resources:
- [Advancing Azure Active Directory availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- [Cloud services you can trust: Office 365 availability](https://www.microsoft.com/microsoft-365/blog/2013/08/08/cloud-services-you-can-trust-office-365-availability)
- [What is the Azure Active Directory architecture?](/azure/active-directory/fundamentals/active-directory-architecture)

Availability of on-premises solution components depends on the implemented design, hardware availability, and your internal operations and maintenance routines. For availability information about some of these components, see the following resources: 
- [Setting up an AD FS deployment with Always On availability groups](/windows-server/identity/ad-fs/operations/ad-fs-always-on)
- [Deploying high availability and site resilience in Exchange Server](/exchange/high-availability/deploy-ha?view=exchserver-2019)
- [Web Application Proxy in Windows Server](/windows-server/remote/remote-access/web-application-proxy/web-application-proxy-in-windows-server) 

Implementation of Hybrid Modern Authentication will require that Azure Active Directory is accessible from all clients on the customer’s network. It is essential for solution that companies consistently maintain O365 firewall ports and ip-ranges openings.

For protocols and port requirement for Exchange servers see section “Exchange client and protocol requirements” in [Hybrid Modern Authentication overview and prerequisites for use with on-premises Skype for Business and Exchange servers]. For O365 IP ranges and opening please check [Office 365 URLs and IP address ranges]. For HMA and mobile devices please check Autodetect endpoint in [Additional endpoints not included in the Office 365 IP Address and URL Web service] documentation.

### Performance
Performance depends on the performance of the components involved and your company's network performance. For more information, see [Office 365 performance tuning using baselines and performance history](/microsoft-365/enterprise/performance-tuning-using-baselines-and-history?view=o365-worldwide).

For information about on-premises factors that influence performance for scenarios that include AD FS services, see these resources:
- [Configure performance monitoring](/windows-server/identity/ad-fs/deployment/configure-performance-monitoring)
- [Fine tuning SQL and addressing latency issues with AD FS](/windows-server/identity/ad-fs/operations/adfs-sql-latency)

### Scalability

For information about AD FS scalability, see [Planning for AD FS server capacity](/windows-server/identity/ad-fs/design/planning-for-ad-fs-server-capacity).

For information about Exchange Server on-premises scalability, see [Exchange 2019 preferred architecture](/exchange/plan-and-deploy/deployment-ref/preferred-architecture-2019).

### Security
Most of security concerns around Hybrid Modern authentication security are answered in [Deep Dive: How Hybrid Authentication Really Works - Microsoft Tech Community]

For closed organizations with traditional perimeter strong protection there are security concerns related to Exchange Hybrid Classic Configuration implementations. Modern Hybrid Configuration does not support Hybrid Modern Authentication. 

Azure Active Directory Security [Azure Active Directory security operations guide | Microsoft Docs]

For scenarios using ADFS security the following topics should be addressed:

[Best Practices for securing AD FS and Web Application Proxy | Microsoft Docs]

[Configure AD FS Extranet Smart Lockout Protection | Microsoft Docs]

### Resiliency

For information about the resiliency of the components in this architecture, see the following resources.
- For Azure AD: [Advancing Azure AD availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability)
- For scenarios that use AD FS: [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager](/windows-server/identity/ad-fs/deployment/active-directory-adfs-in-azure-with-azure-traffic-manager)
- For the Exchange on-premises solution: [Exchange high availability](/exchange/high-availability/deploy-ha?view=exchserver-2019)

## Deploy this scenario
Here are the high-level steps:
1.	Protect Outlook desktop access, configuring Exchange Hybrid configuration and enabling Hybrid Modern Authentication as described [here].
2.	Block all other legacy authentication attempts on Azure AD level as described [here] and on messaging services level using authentication policy as described [here]. 

### Set up a Conditional Access policy 
To set up an Azure AD Conditional Access policy that enforces multifactor authentication, as described in some of the architectures in this article:

 1. Put “Mobile apps and desktop clients” in Clients Apps section:
    
         :::image type="content" source="./media/client-apps-desktop.png" alt-text="Screenshot that shows the Client apps window.":::

    1. Apply MFA requirement in “Grant” control:
       
       :::image type="content" source="./media/grant-control-desktop.png"
       alt-text="Screenshot that shows the Grant window.":::

## Pricing
The cost of your implementation depends on your Azure AD and Microsoft 365 license costs. Total cost also includes costs for software and hardware for on-premises components, IT operations, training and education, and project implementation.

The solution requires at least Azure AD Premium P1. For pricing details, see [Azure AD pricing](https://www.microsoft.com/security/business/identity-access-management/azure-ad-pricing).

[Microsoft Intune pricing]

[Exchange Online plans]

[Exchange server pricing]

For information about AD FS and Web Application Proxy, see [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing).

## Next steps

- Announcing Hybrid Modern Authentication for Exchange On-Premises - Microsoft Tech Community
- Hybrid Modern Authentication overview and prerequisites for use with on-premises Skype for Business and Exchange servers - Microsoft 365 Enterprise | Microsoft Docs
- Use AD FS claims-based authentication with Outlook on the web
- How to configure Exchange Server on-premises to use Hybrid Modern Authentication
- Exchange 2019 preferred architecture | Microsoft Docs
- High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager | Microsoft Docs
- Using hybrid Modern Authentication with Outlook for iOS and Android | Microsoft Docs
- Account setup with modern authentication in Exchange Online | Microsoft Docs

## Related resources
- [web one ]
- [Protecting a hybrid messaging infrastructure in a mobile access scenario](secure-hybrid-messaging-mobile.yml)