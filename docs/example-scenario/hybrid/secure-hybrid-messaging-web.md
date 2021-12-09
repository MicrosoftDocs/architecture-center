Enterprise messaging infrastructure (EMI) is a key service to organizations. Moving from older, less secure methods of authentication and authorization to modern authentication is a critical challenge in a world where remote work is common. Implementing multifactor authentication requirements for messaging service access is one of the most effective ways to meet that challenge. 

This article describes an architecture to help you enhance your security in a web access scenario by using Azure AD Multi-Factor Authentication.

## Potential use cases

This architecture is relevant for the following scenarios and industries:
- Enhance EMI security 
- Adopt a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) security strategy 
- Apply your standard high level of protection for your on-premises messaging service during transition to or co-existence with Exchange Online
- Enforce strict security or compliance requirements in closed or highly secured organizations, like those in the finance sector

## Architecture 

In this discussion, we divide the solution into two areas, describing security for:
- Exchange Online. 
- Exchange on-premises in a hybrid or non-hybrid scenario. 

This article describes a web access scenario to help you protect your messaging service (Outlook on the web / Exchange Control Panel) when mailboxes are hosted in Exchange Online or Exchange on-premises.

For information about other scenarios, see these articles:
- []
- []

We do not touch any other protocols (like IMAP/POP and other), as we do not recommend them to be used for user access.

General suggestions:
- We will describe the options for [federated](/microsoft-365/enterprise/plan-for-directory-synchronization?view=o365-worldwide#federated-authentication) Azure AD Identity model. In case of Password Hash Sync (PHS) or Pass-through Authentication (PTA) models, the logic and the flow will be the same, the only difference will be related to the fact that Azure AD will not redirect the authentication request to On-premises Active Directory Federation Services (ADFS).
- basic interactions between local Active Directory, Azure AD Connect, Azure Active Directory, ADFS and Web Application Proxy (WAP) components are as described in [Hybrid Identity Required Ports and Protocols](/azure/active-directory/hybrid/reference-connect-ports) document.
- By "Exchange On-premises" we mean Exchange 2019 version with the latest updates, Mailbox role. By "Exchange Edge On-premises" we mean Exchange 2019 version with the latest updates, Edge Transport role. We show Edge server for illustrative purposes, to highlight that you may use/not use it in these scenarios as it is not involved in work with client protocols we will discuss here.
- In a real environment, you will have not one server, but a load-balanced array of Exchange servers for high availability, all described scenarios are suitable for such configuration as well.

Exchange Online User’s flow:
1.	User is trying to access OotW service via https://outlook.office.com/owa url. 
2.	Exchange Online will redirect user to Azure Active directory for authentication. In case the domain is federated, Azure AD will redirect user to local ADFS for authentication and in case of success user will be redirected back to Azure AD (this is not shown in schema for simplicity).
3.	To enforce MFA requirement Azure AD will apply Azure Conditional Access Policy (CAP) with MFA requirement for “Browser Client”. Example of such policy configuration:
    1.	Put “Office 365 Exchange Online” or “Office 365” as Cloud application:
    
        ![Screenshot that shows how to set Office as a cloud application.](./media/set-as-cloud-app.png)
    1. Use “Browser” as a client application:
       
       ![Screenshot that shows applying policy to the browser.](./media/apply-policy-to-browser.png)
    1. Apply MFA requirement in “Grant” control:
    
       ![Screenshot that shows applying multifactor authentication.](./media/apply-multifactor-authentication.png) 

1. CAP will call for Azure MFA service to complete authentication. User will get MFA request and go through that.
1.	User will successfully complete MFA request.
1.	Azure AD will redirect authenticated web session to Exchange Online and user will access the content.

Exchange On-premises User’s flow:

1.	User is trying to access OotW service via https://mail.contoso.com/owa url pointing to Exchange server internally or WAP server externally. 
1.	Exchange On-premises (in case of internal access) or WAP (in case of external access) will redirect user to ADFS for authentication.
1.	ADFS will use Windows Integrated Authentication (in case of internal access) or provide a web-form to enter credentials (in case of external access).
1.	Based on the AFDS Access Control policy, ADFS will call for Azure MFA service to complete authentication. User will get MFA request and go through that. Example of such ADFS Access Control policy:

    ![Screenshot that shows an example ADFS access control policy.](./media/access-control-policy.png) 

1.	User will successfully complete MFA request and ADFS will redirect authenticated web session to Exchange On-premises.
1.	User will access the content. 

To implement this scenario for On-premises user, additional configuration required on Exchange and ADFS level according to the [Use AD FS claims-based authentication with Outlook on the web] document to configure ADFS usage for pre-authentication of web access requests. Besides that, integration of ADFS and Azure MFA should be enabled according to the guidance here (applicable for ADFS 2016/2019) and user should be synchronized to Azure AD and assigned with a license for Azure MFA usage.

### Components

[Azure Active Directory]. Azure Active Directory (Azure AD) is Microsoft’s cloud-based identity and access management service. Modern authentication essentially based on EvoSTS (a Security Token Service used by Azure AD) and used as Auth Server for Skype for Business and Exchange server on-premises.

[Azure AD Multi-Factor Authentication]. Multi-factor authentication is a process where a user is prompted during the sign-in process for an additional form of identification, such as to enter a code on their cellphone or to provide a fingerprint scan.

[Azure Active Directory Conditional Access Conditional Access] is the tool used by Azure Active Directory to bring signals together, to make decisions, and enforce organizational policies such as MFA.

[Active Directory Federation Services]  Active Directory Federation Service (AD FS) enables Federated Identity and Access Management by securely sharing digital identity and entitlements rights across security and enterprise boundaries. In this architecture it is used to facilitate logon for users with federated identity. 

[Web Application Proxy] Web Application Proxy pre-authenticates access to web applications by using Active Directory Federation Services (AD FS), and also functions as an AD FS proxy.

[Microsoft Exchange Server]. Microsoft Exchange server hosts user mailboxes on premises. In this architecture, it will use tokens issued to the user by Azure Active Directory to authorize access to the mailbox.

[Active Directory services]. Active directory services stores information about members of the domain, including devices and users. In this architecture, user accounts belong to Active Directory Services and synchronized to Azure Active Directory.

### Alternatives

Azure Web Application Proxy [Application Proxy documentation] can be used as an alternative for ADFS and WAP for Exchange On-premises web access services publishing, but there are following disadvantages:
- Lack of documentation for publishing Exchange
- Lack of Exchange specific scalability figures
- Uncomfortable naming (owa-company.msappproxy.net)

## Considerations

### Availability

Availability in each scenario will depend on the availability of the components involved.

For [Azure Active Directory Advancing Azure Active Directory availability | Azure Blog and Updates | Microsoft Azure]

For O365 availability [Cloud services you can trust: Office 365 availability].

For Azure Active Directory services [Architecture overview - Azure Active Directory | Microsoft Docs]

Availability of on-premises solution components will depend on implemented design, hardware availability and operations/maintenance routines performed by IT. 

ADFS availability is described [Setting up an AD FS Deployment with AlwaysOn Availability Groups | Microsoft Docs]

For Exchange server availability [Deploying high availability and site resilience in Exchange Server].

Web Application proxy  [Web Application Proxy in Windows Server | Microsoft Docs] 

### Performance

Performance will depend on the performance of the components involved and the company’s network performance. [Office 365 performance tuning using baselines and performance history - Microsoft 365 Enterprise | Microsoft Docs]

For on-premises factors influencing performance for scenarios including ADFS services

[Configure Performance Monitoring | Microsoft Docs]

[Fine Tuning SQL and Addressing Latency Issues with AD FS | Microsoft Docs]

### Scalability

For scenarios using AFDS addressing sizing and scalability [Planning for AD FS Server Capacity | Microsoft Docs].

Exchange on premises server scalability see [Exchange 2019 preferred architecture | Microsoft Docs]

### Security

Azure Active Directory Security [Azure Active Directory security operations guide | Microsoft Docs]

For scenarios using ADFS security the following topics should be addressed:

[Best Practices for securing AD FS and Web Application Proxy | Microsoft Docs]

[Configure AD FS Extranet Smart Lockout Protection | Microsoft Docs]

### Resiliency

For Azure Active Directory [Advancing Azure Active Directory availability | Azure Blog and Updates | Microsoft Azure]

For scenarios using ADFS [High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager | Microsoft Docs]

For Exchange on-premises solution [Exchange high availability].

## Deploy this scenario

Here are the high-level steps:
1.	Start from web access service and protect it with Azure Conditional Access policy for Exchange Online as described [here].
2.	Protect web access for On-premises EMI using ADFS claim-based authentication as described [here].

## Pricing

The cost of implementation will depend on Azure Active Directory Identity Management and Microsoft M365 license cost. Total implementation cost will also include software/hardware costs for on premises components, IT operations costs for the company, training and user education costs, and implementation project cost.

The solution will require at least Azure Active Directory Premium P1 

[Azure Active Directory Identity Management Pricing]

 [Exchange server pricing] 

For features ADFS and WAP see more on Windows Server pricing 

[Pricing and licensing for Windows Server 2022]

## Next steps

## Related resources

- Announcing Hybrid Modern Authentication for Exchange On-Premises - Microsoft Tech Community
- Hybrid Modern Authentication overview and prerequisites for use with on-premises Skype for Business and Exchange servers - Microsoft 365 Enterprise | Microsoft Docs
- Use AD FS claims-based authentication with Outlook on the web
- Exchange 2019 preferred architecture | Microsoft Docs
- High availability cross-geographic AD FS deployment in Azure with Azure Traffic Manager | Microsoft Docs
