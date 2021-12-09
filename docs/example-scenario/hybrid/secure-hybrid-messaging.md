Enterprise messaging infrastructure (EMI) is s key service to organizations. Moving from legacy less secured methods of authentication and authorization for the benefit of modern authentication is a challenge which takes center stage in the modern world of remote work. Ensuring multifactor authentication requirements for messaging service access is one of the most effective ways to address that. 

This article describes an architecture to help you enhance your security in a Web Access scenario by using Azure multifactor authentication.

## Potential use cases

Usage of this architecture is relevant for the following scenarios and industries:
- Enhance EMI security posture
- Adopt [Zero Trust] security strategy in organization
- Apply the same high level of protection for On-premises messaging service during transition/co-existence to/with Exchange Online
- Closed/Highly secured organizations e.g., such as finance sector with strict security/compliance requirements 

## Architecture 

We may split the solution in two areas, related to protection for Exchange Online and Exchange On-premises in Hybrid/non-Hybrid scenario. In this part we will focus on Web Access scenario to protect messaging service (Outlook on the Web/Exchange Control Panel) when mailbox is hosted in Exchange Online or in Exchange On-premises.

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

