Enterprise messaging infrastructure (EMI) is a key service for organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multifactor authentication requirements for messaging service access is one of the most effective ways to meet that challenge.

This article describes four architectures to help you enhance your security in a Outlook Access scenario by using Azure AD Multi-Factor Authentication. 

The following four scenarios are described in this article:
- Outlook Access for user's mailbox in Exchange Online
- Outlook Access option 2 (AD FS) for user's mailbox in Exchange Online
- Outlook Access for user's mailbox in Exchange on-premises
- Outlook Access option 2 (AD FS) for user's mailbox in Exchange on-premises

All four architectures cover both Outlook for Windows and Outlook for MAC.

## Potential use cases
This architecture is relevant for the following scenarios and industries:
- Enhance EMI security.
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy.
- Apply your standard high level of protection for your on-premises messaging service during transition to or coexistence with Exchange Online.
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector.



## Architecture

In this part we will focus on Outlook Access scenario to protect messaging service (Outlook for Windows/Outlook for MAC) when mailbox is hosted in Exchange Online or in Exchange On-premises. 

links to the other 2 articles 

We do not touch any other protocols (like IMAP/POP and other), as we do not expect that these will be used often.

### General notes

- We will describe the options for federated Azure AD Identity model. In case of Password Hash Sync (PHS) or Pass-through Authentication (PTA) models, the logic and the flow will be the same, the only difference will be related to the fact that Azure AD will not redirect the authentication request to On-premises Active Directory Federation Services (ADFS).

- On all further schemas, we will show with dashed arrows basic interactions between local Active Directory, Azure AD Connect, Azure Active Directory, ADFS and Web Application Proxy (WAP) components as it is described in Hybrid Identity Required Ports and Protocols document.

- By “Exchange On-premises” we mean Exchange 2019 version with the latest updates, Mailbox role. 

- In a real environment, obviously, we will have not one server, but load-balanced array of Exchange servers for high availability, all described scenarios are suitable for such configuration as well.

### Outlook Access for user's mailbox in Exchange Online

:::image type="content" border="false" source="./media/desktop-online-option-1.png" alt-text="Screenshot that shows an architecture for enhanced security in an Outlook Access scenario." lightbox="./media/desktop-online-option-1.png":::
:::image-end:::


(Outlook for Windows/Outlook for MAC)

In this scenario, the user needs to use the version of Outlook client which supports Modern Authentication as described in this [article].

1.	User’s Outlook is trying to access Exchange Online. 
2.	Exchange Online will provide an url of Azure AD endpoint to retrieve the access token to get access to mailbox.
3.	Outlook will connect to Azure AD using url provided on Step 2.
4.	As soon as the domain is federated, Azure AD will redirect the request to on-premises ADFS.
5.	User will enter credentials on ADFS sign-in page.
6.	ADFS will redirect session back to Azure AD. 
7.	To enforce MFA requirement Azure AD will apply Azure Conditional Access Policy (CAP) with MFA requirement for “Mobile Apps and desktop clients”. Example of such policy configuration:
    1. Put “Mobile apps and desktop clients” in Clients Apps section:
    
         :::image type="content" source="./media/client-apps-desktop.png" alt-text="Screenshot that shows the Client apps window.":::

    1. Apply MFA requirement in “Grant” control:
       
       :::image type="content" source="./media/grant-control-desktop.png"
       alt-text="Screenshot that shows the Grant window.":::

1.	CAP will call for Azure MFA service to complete authentication. User will get MFA request and go through that.
1.	User will successfully complete MFA request.
1.	Azure AD will issue and return Access and Refresh tokens to the client.
1.	Using Access token client will connect to Exchange Online and retrieve the content.

To block attempts to access Exchange Online via legacy authentication (red dash-dot arrow on the diagram), we need to create an [Authentication Policy] which will disable legacy authentication for protocols used by Outlook service, in particular Autodiscover, Mapi, OAB, EWS, what corresponds to the following parameters for Authentication Policy configuration:

AllowBasicAuthAutodiscover         : False<br>
AllowBasicAuthMapi                 : False<br>
AllowBasicAuthOfflineAddressBook   : False<br>
AllowBasicAuthWebServices          : False<br>
AllowBasicAuthRpc                  : False

(Rpc protocol is [deprecated and not supported] for Office 365, so the last parameter should not affect clients in any way).

Example of command to create such Authentication Policy: 

New-AuthenticationPolicy -Name BlockLegacyOutlookAuth -AllowBasicAuthRpc:$false<br> -AllowBasicAuthMapi:$false<br> 
-AllowBasicAuthAutodiscover:$false<br>
-AllowBasicAuthWebServices:$false -AllowBasicAuthOfflineAddressBook:$false

Please, pay attention, that after policy creation, by default, legacy authentication for all other protocols (like IMAP, POP, ActiveSync) will be disabled too. If this is not the case, enable it with command:

Set-AuthenticationPolicy -Identity BlockOutlook -AllowBasicAuthImap:$true

After authentication policy creation, we may first assign it to the pilot group of users with Set-User user01 -AuthenticationPolicy <<name_of_the_policy>> command and after successful testing expand it for all users to apply policy on organization level with Set-OrganizationConfig -DefaultAuthenticationPolicy <<name_of_the_policy>> command. Configuration needs to be done through Exchange Online PowerShell.

### Outlook Access for user's mailbox in Exchange Online, option 2

:::image type="content" border="false" source="./media/desktop-online-option-2.png" alt-text="Screenshot that shows an alternative architecture for enhanced security in an Outlook Access scenario." lightbox="./media/desktop-online-option-2.png":::
:::image-end:::

(Outlook for Windows/Outlook for MAC)

This is the same scenario as previous, the only difference would be in the service, which will be a trigger for MFA. In Scenario 2 we used local ADFS for authentication purposes and next redirected information about successful authentication to Azure AD, where MFA enforcement Conditional Access policy came into play. Alternatively, it is possible not to enforce MFA on Azure Conditional Access policy level but create an Access Control Policy on ADFS level and enforce MFA there. All the rest logic will be the same. Unless scenario 2 with conditional account not available, this scenario is not recommended. 

In this scenario, the version of Outlook client which supports Modern Authentication as described in this [article] is required as well.

1.	User’s Outlook is trying to access Exchange Online. 
2.	Exchange Online will provide an url of Azure AD endpoint to retrieve the access token to get the access to mailbox.
3.	Outlook will connect to Azure AD using url provided on Step 2.
4.	In case the domain is federated, Azure AD will redirect the request to on-premises ADFS.
5.	User will enter credentials on ADFS sign-in page.
6.	Based on the AFDS Access Control policy, ADFS will call for Azure MFA service to complete authentication. User will get MFA request and go through that. Example of such ADFS Access Control policy:

    :::image type="content" source="./media/access-control-policy.png" alt-text="Screenshot that shows an example of an AD FS Access Control policy."::: 
7.	User will successfully complete MFA request. 
8.	ADFS will redirect session back to Azure AD. 
9.	Azure AD will issue and return Access and Refresh tokens to the client.
10.	Using Access token client will connect to Exchange Online and access the content.

Please, be aware, that Access Control policy mentioned in Step 6 will be applied on relying party trust level, what means, that it will affect all authentication requests for all Office 365 services going through ADFS. Despite the fact that you may apply additional filtering using ADFS additional authentication rules as described [here], to achieve better flexibility and based on the common practice, the recommendation would be to prefer Azure AD CAP (Scenario 2) vs ADFS Access control policy (Scenario 3) for Microsoft 365 services.

To block attempts to access Exchange Online via legacy authentication (red dash-dot arrow on the diagram), we need to create an [Authentication Policy] which will disable legacy authentication for protocols used by Outlook service, in particular Autodiscover, Mapi, OAB, EWS, what corresponds to the following parameters for Authentication Policy configuration:

same as above? 

### Outlook Access for user's mailbox in Exchange on-premises

:::image type="content" border="false" source="./media/desktop-on-premises-option-1.png" alt-text="Screenshot that shows an enhanced security architecture in an on-premises Outlook Access scenario." lightbox="./media/desktop-on-premises-option-1.png":::
:::image-end:::

(Outlook for Windows/Outlook for MAC) put this in just one place? 

1. User with mailbox on Exchange server starts Outlook client. Outlook client makes connection to Exchange server and advertise modern authentication capability.
2. Exchange server will send response to client “to get token from Azure AD”. 
3. Outlook client connects to Azure Active Directory url provided by Exchange server.
4. Azure identifies that user’s domain is federated and therefore sends requests to ADFS (through WAP).
5. User enters credentials on ADFS sign-in page.
6. ADFS redirects back to Azure AD.
7. To enforce MFA requirement Azure AD will apply Azure Conditional Access Policy (CAP) with MFA requirement for “Mobile Apps and desktop clients”. Example of such policy configuration:

is this the same as above? 

8.	CAP will call for Azure MFA service to complete authentication. User will get MFA request and go through that.
9.	User will successfully complete MFA request.
10.	Azure AD will issue and return Access and Refresh tokens to the client.
11.	User will present access token to Exchange server, and it will authorize access to the mailbox.
is this the same as above? 

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
Azure Active Directory. Azure Active Directory (Azure AD) is Microsoft’s cloud-based identity and access management service. Modern authentication essentially based on EvoSTS (a Security Token Service used by Azure AD) and used as Auth Server for Skype for Business and Exchange server on-premises.

Azure AD Multifactor authentication. Multi-factor authentication is a process where a user is prompted during the sign-in process for an additional form of identification, such as to enter a code on their cellphone or to provide a fingerprint scan.

Azure Active Directory Conditional Access . Conditional Access is the tool used by Azure Active Directory to bring signals together, to make decisions, and enforce organizational policies such as MFA.

Active Directory Federation Services | Microsoft Docs. Active Directory Federation Service (AD FS) enables Federated Identity and Access Management by securely sharing digital identity and entitlements rights across security and enterprise boundaries. In this architecture it is used to facilitate logon for users with federated identity
Web Application Proxy Web Application Proxy pre-authenticates access to web applications by using Active Directory Federation Services (AD FS), and functions as an AD FS proxy.
Microsoft Endpoint Manager | Microsoft 365 Microsoft Intune is part of Microsoft Endpoint Manager and is a 100% cloud-based mobile device management (MDM) and mobile application management. After hybrid Modern Authentication is enabled, all on-premises mobile users can use Outlook for iOS and Android using the Microsoft 365 or Office 365-based architecture. Therefore, it is important to protect corporate data with an Intune app protection policy.
Microsoft Exchange Server. Microsoft Exchange server hosts user mailboxes on-premises. In this architecture, it will use tokens issued to the user by Azure Active Directory to authorize access to the mailbox.
Active Directory services. Active directory services It stores information about members of the domain, including devices and users. In this architecture user accounts belong to Active Directory Services and synchronized to Azure Active Directory
Microsoft Outlook for business - Microsoft. Microsoft Outlook is a client supporting modern authentication. 


### Alternatives

## Considerations

## Pricing

## Next steps

## Related resources