---
title: Title
titleSuffix: Azure Example Scenarios
description: Description
author: GitHubAlias
ms.date: 03/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Azure Active Directory Reference Architecture for Security Operations
## Identity, meet Security Operations; your neighbor across the hall

Traditionally, when talking about security operations with an organization, network security dominated the conversation. This made sense when users were using services and devices managed by the organization and contained on a managed network.

More users and organizations are now moving towards cloud services and  [zero trust security model](https://www.microsoft.com/security/business/zero-trust). There has been a shift toward treating [user identity as the primary security boundary](https://docs.microsoft.com/azure/security/fundamentals/identity-management-best-practices).

Like two shy neighbors, Identity teams and Security Operations teams not always had a close relationship. Now it's time to change that. This document shows using Azure AD platform, how security operations can take advantage of – protect, detect, and respond capabilities available today.
Through 2022, Gartner [predicts](https://www.gartner.com/en/newsroom/press-releases/2019-04-02-gartner-forecasts-worldwide-public-cloud-revenue-to-g) that the market size and growth of the cloud services industry will grow at a rate nearly three times that of overall IT services.

As mentioned in Verizon's [2019 data breach investigations report](https://enterprise.verizon.com/resources/reports/dbir/?cmp=paid_search:bing:ves_us:gm:awareness&utm_medium=paid_search&utm_source=bing&utm_campaign=ves_us&utm_content=gm&utm_term=awareness&gclid=CLnp-ujPi-kCFQw6fwodhE8CEw&gclsrc=ds), 32% of breaches involved phishing and 29% involved use of stolen credentials. As per [Microsoft security intelligence report 2019](https://www.microsoft.com/security/blog/2019/02/28/microsoft-security-intelligence-report-volume-24-is-now-available/), phishing attacks have increased by a margin of 250% just between January to December of 2018. 

These data breaches can be costly. According to a recent [study of data breach incidents](https://www.all-about-security.de/fileadmin/micropages/Fachartikel_28/2019_Cost_of_a_Data_Breach_Report_final.pdf), the average global cost of a data breach was $3.92M dollars, with the US average cost closer to $8.2M. As more companies embrace cloud computing, securing identities in the cloud must remain a high priority.

One approach proposed by Gartner is the [concept of an adaptive security architecture](https://www.gartner.com/en/documents/3913561/shift-from-managing-risk-and-security-to-enabling-value-). This implements adaptive access protection combining – access, behavioral monitoring, usage management, and discovery with continuous monitoring and analytical capabilities. This architecture helps advance that approach.

## How to use this document
-	Design a new solution 
-	Enhance your existing implementation
-	Train your security operations team

## Architecture
Microsoft has built this [reference architecture](https://gallery.technet.microsoft.com/Cybersecurity-Reference-883fb54c) to show a recommended architecture for cloud and hybrid environments that use the Azure Active Directory Premium workload as their Identity-as-a-Service (IDaaS) component. The terminologies have been kept simple for easy understanding of key security capabilities of Azure AD and other Microsoft security workloads.
![Screenshot shows the architecture discussed in this article](architecure.png)

The following sections explain each component mentioned in the above architecture. 

1. [Credential management](https://docs.microsoft.com/azure/active-directory/authentication/index) – The umbrella of credential management includes any service, policy or practice used to issue, track and update access to resources or services. It includes capabilities like [passwordless authentication](https://www.microsoft.com/security/business/identity/passwordless), [self-service password reset (SSPR)](https://docs.microsoft.com/azure/active-directory/authentication/concept-sspr-howitworks), [banned password lists](https://docs.microsoft.com/azure/active-directory/authentication/concept-password-ban-bad), and [smart lockout](https://docs.microsoft.com/azure/active-directory/authentication/howto-password-smart-lockout). 

   -	[Passwordless authentication](https://www.microsoft.com/security/business/identity/passwordless) – Adding options like multi-factor authentication to your credential management strategy, while useful in enhancing security, can sometimes frustrate end users. Also, end users can struggle with remembering complex or hard to remember passwords. Passwordless authentication experiences take the password out of the authentication workflow and replace it with:
          - Something the user has – like a smartphone or hardware token
          - Something that the user is or knows – like biometric identifiers or a PIN.

          Microsoft provides passwordless authentication options that can work with Azure resources like [Windows hello for business](https://docs.microsoft.com/windows/security/identity-protection/hello-for-business/hello-identity-verification), and the [Microsoft authenticator app](https://www.microsoft.com/account/authenticator) on mobile devices. Microsoft also has preview support available for organizations who want to enable passwordless authentication experiences for their users [using FIDO2 compatible security keys](https://docs.microsoft.com/azure/active-directory/authentication/howto-authentication-passwordless-security-key). FIDO2 compatible keys leverage WebAuthn and the [FIDO alliance’s Client-to-Authenticator (CTAP) protocol](https://fidoalliance.org/specifications/download/) to authenticate users.

   - [Self-service password reset (SSPR)](https://docs.microsoft.com/azure/active-directory/authentication/concept-sspr-howitworks) – Users have multiple accounts and are expected to have complex passwords for each account. Users generally tend to forget their passwords. SSPR is a feature that enables the users to self-serve and reset password on their own. This results in not only reducing the number of helpdesk calls, but provides user flexibility and security. Azure AD also provides [Password writeback](https://docs.microsoft.com/azure/active-directory/authentication/concept-sspr-writeback) feature, which allows password changed in cloud to sync with on-premises directory in real time.

    - [Banned password list](https://docs.microsoft.com/azure/active-directory/authentication/concept-password-ban-bad) – Asking users to choose a unique and complex password is one way to help mitigate risk in your environment. Azure AD password protection analyzes telemetry data exposing commonly used weak or compromised passwords, and then bans their use globally throughout Azure AD. Customize this functionality for your environment. You can also include a list of [custom passwords](https://docs.microsoft.com/azure/active-directory/authentication/concept-password-ban-bad#custom-banned-password-list) that you want to ban within your own organization.

    - [Smart lockout](https://docs.microsoft.com/azure/active-directory/authentication/howto-password-smart-lockout) – This feature compares authentication attempts from legitimate users with the  users attempting to brute-force guess user credentials to gain access. With smart lockout enabled, under the default policy an account will lock out for one minute after 10 failed sign-in attempts. As sign-in attempts continue to fail, the account lockout time increases. Policies can be used to adjust the settings to get the appropriate mix of security and usability for your organization.

2.	Provisioning and assignment to resources –
 Azure AD [entitlement management](https://docs.microsoft.com/azure/active-directory/governance/entitlement-management-overview) is an Azure AD [identity governance](https://docs.microsoft.com/azure/active-directory/governance/identity-governance-overview) feature that enables organizations to manage identity and access lifecycle at scale. It automates access request workflows, access assignments, reviews, and expiration. The [provisioning service](https://docs.microsoft.com/azure/active-directory/manage-apps/user-provisioning) enables you to automatically create user identities and roles in the applications that users need access to. [Azure AD provisioning](https://docs.microsoft.com/azure/active-directory/app-provisioning/how-provisioning-works) can also be configured with the following applications: 
    - Inbound user provisioning from [SuccessFactors](https://docs.microsoft.com/azure/active-directory/saas-apps/sap-successfactors-inbound-provisioning-tutorial)
    - [Workday](https://docs.microsoft.com/azure/active-directory/saas-apps/workday-inbound-tutorial)
    - Many [other third-party software as a service applications](https://docs.microsoft.com/azure/active-directory/saas-apps/tutorial-list). 

    Azure AD allows you to configure [seamless single sign-on](https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sso). It automatically authenticates users to other cloud-based applications once user logs into their corporate device. Azure AD seamless SSO can be used with either [Password hash synchronization](https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-password-hash-synchronization) or [Pass-through authentication](https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-pta).

3. [Access policy](https://docs.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policies) and [Authorization engine](https://docs.microsoft.com/azure/active-directory/conditional-access/troubleshoot-conditional-access-what-if) – A Conditional access policy is an if-then statement of assignments and access controls, bringing signals together to make decisions and enforce organizational policies.

4. Attestation – [Azure AD access reviews](https://docs.microsoft.com/azure/active-directory/governance/access-reviews-overview), identity governance, and entitlement management work together to help organizations mitigate risk and meet monitoring and auditing requirements. By creating access reviews, you can quickly identify things like:
      - The number of users with admin roles
      - Report on access for new employees to make sure they can access needed resources
      - Reviewing user’s access on a regular basis to determine if continued access is necessary.

5. [Risk detections](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-risk-events) – Azure AD uses adaptive machine learning algorithms and heuristics to detect suspicious actions that are related to your user accounts. Each detected suspicious action is stored in a record called a risk detection. User and sign-in risk probability are calculated using this data. Data is further enhanced with Microsoft’s internal and external threat intelligence sources and signals.

   [Azure identity protection](https://docs.microsoft.com/azure/active-directory/identity-protection/) includes several default policies that can help your organization manage  responses to suspicious user actions. User risk is the probability that a user identity is compromised. Sign-in risk is the probability that a sign-in request isn’t coming from the user. 

   Azure AD calculates sign-in risk scores based on the probability of the sign-in request originating from the actual user based on behavioral analytics. 

6. [Controls](https://docs.microsoft.com/azure/active-directory/conditional-access/controls) – With [Azure AD conditional access](https://docs.microsoft.com/azure/active-directory/active-directory-conditional-access-azure-portal), you can control how authorized users access your apps. In a conditional access policy, you define the response ("if this") to the reason for triggering your policy ("then do this").

   All the controls can work in conjunction with your conditional access policies to help enforce organizational policy. Coupling conditional access controls with conditions for access you can create additional security controls only when necessary. As a typical example, you may want to allow users access to resources using single sign-on for users who are on a domain-joined device. For users off network or when  using their own devices, MFA controls may be required.

   The conditional access controls with Azure AD allow you to implement security based on the factors detected at the time of request for access, rather than a one-size fits all approach.

     - Multi-factor authentication (MFA) – Helps protect access to your data and resources by implementing multiple forms of authentication when users attempt to access protected resources. Most users are familiar with having something that they know – like a password when accessing resources. MFA asks users to also demonstrate something that they have – like access to a trusted device or something that they are – like a biometric identifier.
 
          [Azure multi-factor authentication](https://docs.microsoft.com/azure/active-directory/authentication/concept-mfa-howitworks) allows you to configure different authentication types available to users and use those controls in a conditional access policy. Azure MFA allows you to use  different kind of  [authentication methods](https://docs.microsoft.com/azure/active-directory/authentication/concept-authentication-methods) like phone calls, text messages, or [notification through the authenticator app](https://www.microsoft.com/account/authenticator). 


    - [Privileged identity management (PIM)](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/) – Provides you with a way to add additional monitoring and protection to administrative accounts and Azure AD resources and services. 

      [Azure AD PIM](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure) allows you to manage and control access to resources within Azure, Azure AD, and other M365 services. PIM provides just-in-time access to all your M365 services and resources. It provides a history of administrative activities, a change log, and alerts to notify you when users are added or removed from roles you define. You can choose to [require approval](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-resource-roles-configure-role-settings) for activation of your administrative roles and whether you want to force users to provide justification for role requests.

      With PIM, users can instead maintain normal privileges most of the time. When user needs to do an administrative task, they make a request for access to the role that they need to complete their work. Once users have completed their work and logged out – or the time limit on their request has expired, their session will end, and they can reauthenticated with their standard user permissions.  

      Managing who has administrative access to resources and services can be challenging. [Just-in-time (JIT) and Just-enough administration (JEA)](https://docs.microsoft.com/azure/azure-australia/role-privileged) reduces the attack vector for your organization.

      You may already be familiar with how to use [Role-based access control (RBAC)](https://docs.microsoft.com/azure/role-based-access-control/) for Azure resources. Once the appropriate roles have been configured, you can assign those roles to users who need to do administrative tasks. You may also create or maintain separate dedicated admin-only accounts. Access requests can be time limited, scoped to the roles you’ve setup with Azure, and access is granted through approval workflows.

     - Cloud app security broker (CAS-B) – Are security policy enforcement points that allow you to monitor the cloud applications and services in use in your organization.  As users access cloud services, they can also be used to inject enterprise security policies.

          [Microsoft cloud app security (MCAS)](https://www.microsoft.com/microsoft-365/enterprise-mobility-security/cloud-app-security) is a CAS-B that discovers and analyzes cloud apps that are in use based on traffic logs. 
        - [Policies can be created](https://docs.microsoft.com/cloud-app-security/control-cloud-apps-with-policies) to manage interaction with these apps or services
        - Identify applications as [sanctioned or unsanctioned](https://docs.microsoft.com/cloud-app-security/governance-discovery)

        - [Control and limit access to data](https://docs.microsoft.com/cloud-app-security/governance-actions)
    
        - [Apply information protection](https://docs.microsoft.com/cloud-app-security/azip-integration) guard against information loss. 

        MCAS also works with [Azure AD conditional access](https://docs.microsoft.com/azure/active-directory/active-directory-conditional-access-azure-portal) allowing you to create access and session policies for your SaaS applications. [Access policies](https://docs.microsoft.com/cloud-app-security/access-policy-aad) allow you to strengthen control over which users have access to which cloud apps. It can be done by doing things like:
        - [Limiting the IP ranges that user can access services from](https://docs.microsoft.com/azure/active-directory/conditional-access/location-condition), [requiring MFA](https://docs.microsoft.com/azure/active-directory/authentication/concept-mfa-howitworks) for some services
        - [Conducting activities from within an approved application](https://docs.microsoft.com/azure/active-directory/conditional-access/app-based-conditional-access)
        - Allowing you to control what actions users can do while logged in to the protected cloud apps by using [session policies](https://docs.microsoft.com/cloud-app-security/session-policy-aad). 

      - Limiting access to [Exchange online](https://docs.microsoft.com/graph/auth-limit-mailbox-access), SharePoint online and OneDrive for Business content – The SharePoint admin center provides multiple ways that you can control access to your SharePoint and OneDrive content. Using the [access control page in the SharePoint admin center](https://admin.microsoft.com/sharepoint?page=accessControl&modern=true), you can choose to [completely block access from unmanaged devices](https://docs.microsoft.com/sharepoint/control-access-from-unmanaged-devices#block-access-using-the-new-sharepoint-admin-center). Also, you can [choose to allow limited, web-only access for these users](https://docs.microsoft.com/sharepoint/control-access-from-unmanaged-devices#limit-access-using-the-new-sharepoint-admin-center). Similar to managing access from managed and unmanaged devices you can also [control access to content based on network location](https://docs.microsoft.com/sharepoint/control-access-based-on-network-location). 


      - [Terms of Use (TOU)](https://docs.microsoft.com/azure/active-directory/conditional-access/terms-of-use) – Provides a way for you to present information to end users that they must consent to before gaining access to protected resources. TOU documents are uploaded to Azure as PDF files and once added are available as controls in conditional access policies.

          By creating a conditional access policy that requires users to consent to TOU policy at sign-in, you can easily audit users that accepted the TOU policy.

7. [Real-time remediation](https://docs.microsoft.com/azure/active-directory/identity-protection/howto-identity-protection-remediate-unblock) – If you allow users to self-remediate, with Azure MFA and SSPR in your risk policies, when risk is detected users can unblock themselves.

8. [Logs](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor) – Microsoft provides you with multiple options to route Azure AD sign-in logs and audit logs to an endpoint like [Azure Monitor](https://azure.microsoft.com/services/monitor/) for long-term retention and data insights, Azure Blob Storage, Azure Sentinel, and [other third-party options](https://docs.microsoft.com/azure/azure-monitor/platform/stream-monitoring-data-event-hubs). For risk detections, [there are APIs](https://docs.microsoft.com/azure/active-directory/identity-protection/howto-identity-protection-graph-api) that expose information about risky users and sign-ins via the Microsoft Graph API.  Azure AD documentation includes instructions to help you in setting up routing Azure AD logs to SIEM solutions like -  [ArcSight](https://docs.microsoft.com/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-arcsight), [Splunk](https://docs.microsoft.com/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-splunk), and [SumoLogic](https://docs.microsoft.com/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-sumologic) directly, with the following features:

   - Monitoring – [Azure Monitor](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor) allows you to route your Azure AD audit or sign-in logs to different locations.
It could include a storage account within Azure or your own SIEM system. It allows you to use [Azure event hubs](https://azure.microsoft.com/services/event-hubs/) to stream data back to your SIEM. You can use [reporting graph API](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-reporting-api) to retrieve and consume the data within your own scripts.

   - Auditing – Azure AD provides [audit reports](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-audit-logs) on sign-ins to manage applications and other Azure services. It provides traceability of changes made in Azure, and risky sign-in and security logs. All this log data can be filtered and searched based on different kind of parameters including – service, category, activity, and status.

9. [Endpoint management](https://docs.microsoft.com/azure/active-directory/conditional-access/require-managed-devices) – Authorized users can access your cloud apps from a broad range of devices including mobile and personal devices. Restrict access using conditional access policies if your environment has apps that can be only accessed by devices that meet your standards for security and compliance. These devices are also known as managed devices and require [a device identity](https://docs.microsoft.com/azure/active-directory/devices/overview).

10.	[User/entity behavioral analytics (UEBA)](https://docs.microsoft.com/azure-advanced-threat-protection/what-is-atp) – Azure Advanced Threat Protection (AATP) is a cloud-based security solution. It uses your on-premises AD signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions. AATP focuses on learning patterns of user behavior to identify insider threats and flag risk. In this way, even if an identity becomes compromised, AATP can help identify that compromise based on unusual user behavior. 

    AATP is [integrated with MCAS](https://docs.microsoft.com/azure-advanced-threat-protection/atp-mcas-integration) to extend protection to cloud apps. It can be used with Azure AD identity protection to help protect user identities being synchronized to Azure via AADConnect. MCAS can be used to create [session policies](https://docs.microsoft.com/cloud-app-security/session-policy-aad#protect-download)  that protect your files on download. For example, you may automatically set view only permissions on any file downloaded by specific types of users. 

11. SIEM – Route your monitoring data to [Azure Sentinel](https://docs.microsoft.com/azure/sentinel/quickstart-onboard) or to an event hub with [Azure Monitor](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor). You can further integrate with [external SIEM, monitoring, and ITSM tools](https://docs.microsoft.com/azure/azure-monitor/platform/stream-monitoring-data-event-hubs). 

    > Note: Each control or security feature discussed is part of the overall integrated and layered security approach in Azure AD. 
 ## Hybrid Considerations

- Hybrid authentication – While not represented in the above architecture, hybrid authentication methods are a key input to securing your organization’s identities. Microsoft provides [specific guidance](https://docs.microsoft.com/azure/security/fundamentals/choose-ad-authn) on choosing an authentication method with Azure AD.
- Access to on-premise applications – [Application Proxy](https://docs.microsoft.com/azure/active-directory/manage-apps/application-proxy) feature in Azure enables users to access on-premises web applications from a remote client. Using application proxy you can monitor all sign-in activities for your applications in one place. You can provide secure remote access to on-premise apps, and use Azure features like conditional access when users access these applications. 

   For some applications, you may already be using an [application delivery controller or network controller](https://docs.microsoft.com/azure/active-directory/manage-apps/secure-hybrid-access) to provide off-network access. Azure AD has several partners including [Akamai](https://docs.microsoft.com/azure/active-directory/saas-apps/akamai-tutorial), [Citrix](https://docs.microsoft.com/azure/active-directory/saas-apps/citrix-netscaler-tutorial), [F5 Networks](https://aka.ms/f5-hybridaccessguide), and [Zscaler](https://aka.ms/zscaler-hybridaccessguide) to offer solutions and guidance for integration with Azure AD and to enable the above reference architecture.

## Licensing 
Refer [here](https://azure.microsoft.com/pricing/details/active-directory/) for  questions related  to licensing.

## Next Steps 
- Learn more about the [concept of zero trust](https://www.microsoft.com/security/business/zero-trust). Check out this [blog](https://www.microsoft.com/security/blog/2020/04/30/zero-trust-deployment-guide-azure-active-directory/?ocid=usoc_TWITTER_M365_spl100001244212434) to know how Microsoft can help. 
- Get additional [security architecture guidance](https://docs.microsoft.com/azure/architecture/framework/security/overview).  
- Develop your identity and security roadmap using [these tools](https://github.com/MarkSimos/MicrosoftSecurity/blob/master/Azure%20Security%20Compass%201.1/AzureSecurityCompassIndex.md). 
- Try out the Azure AD features in a [demo tenant](http://demos.microsoft.com/) (requires a Microsoft Partner Network account). Alternatively, [sign up](https://www.microsoft.com/microsoft-365/enterprise-mobility-security) for a trial tenant. 
- Ready to deploy? Check out our [deployment plans](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-deployment-plans) for step-by-step guidance on some of the most common scenarios.

## Feedback

