---
title: Conditional Access framework and policies
description: Conditional Access framework, structure and policy details
author: clajes
ms.author: clajes
ms.date: 12/12/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-active-directory
  - m365-threat-protection 
  - mdatp
  - m365-ems
  - m365-ems-cloud-app-security
  - mem
categories:
  - Security
  - Identity
ms.custom: fcp
---

# Conditional Access framework and policies

This section describes a suggested Conditional Access framework in details that includes a structured persona based approach on how to form and name the Conditional Access policies.

What typically happens if you don't form such a framework including a naming standard is that policies are created over time by different people and in an ad-hoc manner.

Typically this results in many policies that overlap and if/when people who have created them are not available it is very difficult for others to know why the are there and what the intention was with a given policy.

Following a structured framework makes it simpler to understand the policies and also makes it easier to cover all scenarios and not have conflicting policies that are difficult to troubleshoot.

## Naming Conventions

Having a properly defined naming convention helps understand the purpose of a policy and thus enables easier policy management and troubleshooting. Your naming convention should fit to the framework you choose to structure your policies.

The recommended naming policy is based on personas, policy types and apps and looks as follows:

**\<CAnumber>-\<Persona>-\<Policy Type>-\<App>-\<Platform>-\<GrantControl>-\<OptionalDescription>**


![CA Framework Naming](media/caframeworknaming.png)

The naming sections of the policies are explained in the table below

|CA Section|Description and example|
|----------|-----------------------|
|CA Number|CA001-CA099|
|Persona Groups|Global, Admins, Internals, Externals, GuestUsers, Microsoft365ServiceAccounts, AzureServiceAccounts, CorpServiceAccounts|
|Policy Type|BaseProtection, AppProtection, DataProtection, IdentityProtection, AttackSurfaceProtection, Compliance|
|App|AllApps, O365 for all O365 services, EXO for Exchange Online|
|Platform| AnyPlatform, Unknown, Windows, MacOS, iOS, Android|
|GrantControl|Block, ADHJ, Compliant, Unmanaged, where unmanaged is specified in device state condition|
|Description|Optional extra words to describe purpose of the policy|

## Numbering scheme

For ease of administration, the below numbering scheme is suggested.

|Persona Group|Number Allocation|
|-------------|-----------------|
|CA-Persona-Global|CA001-CA099|
|CA-Persona-Internals|CA100-CA199|
|CA-Persona-Admins|CA200-CA299|
|CA-Persona-Externals|CA300-CA399|
|CA-Persona-GuestUsers|CA400-CA499|
|CA-Persona-GuestAdmins|CA500-CA599|
|CA-Persona-M365ServiceAccounts|CA600-CA699|
|CA-Persona-AzureServiceAccounts|CA700-CA799|
|CA-Persona-CorpServiceAccounts|CA800-CA899|
|CA-Persona-WorkloadIdentities|CA900-CA999|
|CA-Persona-Developers|CA1000-CA1099|

## Policy Types

The suggested policy types are explained below

|Policy Type|Description/Examples|
|-----------|--------------------|
|BaseProtection|For each persona, we want to have a base protection that is covered by this policy type. For users on managed devices, this could typically be known user and known device, whereas for external guests, it could be known user and MFA. The base protection is the default policy for all app for users of the given persona. If a given app should have other policy than the default policy, the idea is to exclude that app from the base protection policy and add an explicit policy targeting only that app. An example would be if the base protection for Internals is to require known user and known device for all cloud apps, but you want to allow for Outlook on the Web (OWA) from any device, then you would exclude Exchange Online from the Base Protection policy and add a separate policy for Exchange Online where you require known device OR MFA|
|IdentityProtection|On top of the base protection for each persona, we can have CA policies that relate to identity. Examples are: Block Legacy Authentication, Require extra MFA for high user or sign-in risk, Require known device for MFA registration|
|DataProtection|Type policy type indicates delta policies that protect data as an extra layer on top of the base protection. Examples includes App Protection Policies for iOS and Android where we can protect and encrypt the data on a phone. (App Protection policies also include app protection, so it can be considered both). Other examples include session policies where data is protected using Azure Information protection on the flow if the data being downloaded is considered sensitive data|
|AppProtection|This policy type is another addition to the base protection. An example is if/when you want to allow for web access to Exchange Online from any device. In this case you exclude Exchange from the base policy and create a new explicit policy for access to Exchange, where you for example only allow read-only to Exchange Online. Another example of AppProtection policy would be if we require MFA for Endpoint Manager enrollment. We would then exclude "Intune/EM enrollment" from the base policy and add an app protection policy that requires MFA for Endpoint Manager enrollment|
|AttackSurfaceReduction|This type of policy is to mitigate against various attacks, like if a user is coming from an unknown platform, then experiences shows that this could be an attempt to try to bypass CA policies where we require a given platform, hence we may want to block requests coming from unknown platforms to mitigate against this. Another example would be to block access to Office 365 services for Azure Administrators or block access to an app for all users if the app is a known to be bad|
|Compliance|A compliance policy could be used to require a user to see a "Terms of Use" for guests accessing customer services. In this case you would have an audit record that proves that the guest user|

## App Type

The App Type section of a policy is explained below

|APP Name|Description/Examples|
|--------|--------------------|
|All Apps|Indicates that "All Cloud Apps" is being targeted in the CA policy which means that all endpoints are protected for users’ access, both those endpoints that support CA as well as those that don't. Using “AllApps” does have implications of some scenarios that don't work well with this policy. Using “AllApps” in the base policy is recommended seen from a security point of view as you then have all endpoints protected by the base policy and new apps showing up in Azure AD will also adhere to this policy automatically|
|AppName|AppName is just an example of an app that the policy addresses, it could be "EXO" for Exchange Online (to not make the policy name too long), or SPO for SharePoint Online|

## Platform Type

Platform section as part of a Conditional Access policy name is explained below.

|Platform Type|Description/Examples|
|-------------|--------------------|
|AnyPlatform|This indicates that the policy should target any platform. This is typically done by selecting "Any Device" (in CA policy both the word platform as well as device are being used)|
|iOS|Means that the policy targets the Apple iOS platforms|
|Android|Means that the policy targets the Google Android platforms|
|WindowsPhone|Means that the policy targets the Windows Phone platforms|
|macOS|Means that the policy targets the MacOS platforms|
|iOSAndroid|Means that the policy targets both the iOS and the Android platforms|
|Unknown|Means that the policy targets both the iOS and the Android platforms Means that the policy targets platforms not any of the above. This is typically used by including "Any Device" and excluding all the individual platforms|

## Grant Control Types

The various grant control types are explained below

|Grant Type|Description/Examples|
|----------|--------------------|
|MFA|Indicate that the policy requires MFA|
|Compliant|Indicates that the policy requires a compliant device as determined by Endpoint Manager, so the device needs to be managed by Endpoint Manager|
|CompliantorAADHJ|Indicates that the policy requires a compliant device or Azure AD Hybrid Joined device. A standard company PC that is domain joined is also Azure AD Hybrid Joined. Mobile phones and Windows 10 PCs that are comanaged or Azure AD Joined can be compliant|
|CompliantandAADHJ|This indicates that the policy requires a compliant AND Azure AD Hybrid Joined Device|
|MFAorCompliant|Indicates that the policy requires a compliant device OR MFA if it is not|
|MFAandCompliant|Indicates that the policy requires a compliant device AND MFA to satisfy this policy|
|MFAorAADHJ|Indicates that the policy requires an Azure AD Hybrid Joined PC or MFA if it is not|
|MFAandAADHJ|Indicates that the policy requires an Azure AD Hybrid Joined PC and MFA|
|Unmanaged|This indicates that the policy is targeting devices that are not known by Azure AD. An example of where this could be used would be to allow for access to Exchange Online from any device|

## Named Locations

When defining locations for use in conditional access policies, we recommend that you define these standard locations:

- Trusted IPs / Internal Networks. These IP subnets represent locations and networks that have physical access restrictions and/or other controls in place, such as computer system management, network level authentication and intrusion detection. These locations are more secure and conditional access enforcement may be relaxed. Consider if Azure or other data centre locations (IPs) should be included in this or have their own named locations.
- Citrix Trusted IPs . If you have Citrix on-premises, it may be useful to configure separate outgoing IPv4 addresses for the Citrix farms, if there is a need to be able to connect to clod services from Citrix sessions. In this case, those locations can potentially be excluded from CA policies where needed.
- ZScaler locations (if applicable). As PCs have a ZPA agent installed and will forward all traffic to the internet to/through ZScaler cloud, it is worthwhile defining ZScaler source IPs in CA and require all requests from non-mobiles to go through ZScaler.
- Countries Allowed Business In/With. It can be useful when designing a policy to divide countries into two location groups. One represented the areas of the world that employees typically work in vs locations that are typically not working from. By having these locations defined, an organization can apply additional controls to requests that originate from outside the areas where the organization normally operates.
- Locations where MFA may be difficult or impossible. The nature of some work conditions may mean that requiring MFA is not practical to the extent that staff may be impeded from carrying out their duties. For example, frontline staff performing border protection duties at immigration screening points may not have the time or opportunity to respond to frequent MFA challenges.  Another example may be locations where RF screening or electrical interference negate the use of mobile devices. Typically, these locations would be afforded other controls and may be trusted.

Location-based access controls rely on the source IP of a request to determine the location of the user at the time of the request. Although it is non-trivial to spoof on the public Internet, protection afforded by network boundaries may be considered less relevant than it once was. We do not recommend relying solely on location as a condition for access but for some scenarios it may be the best/only control that can be used, like securing access from a service account from on-premises that is used in a non-interactive scenario.

## Suggested CA Policies

Link to CA policies to come facilitated in an Excel spreadsheet 

The suggested policies should be considered as your starting set of policies.

You should expect that the policies will be changed over time for each persona to accommodate for various use-cases important to the business. A few examples of scenarios that may result in change of CA policies are shown below.

- Read Only access to Exchange Online for employees from any unmanaged device based on MFA and App Protection and approved client app.
- Information protection, ensuring that sensitive information is not downloaded without being protected using Azure Information Protection.
- Hinder Copy/Paste for guest access
  
## Next Steps

Now that you have a starter set of CA Policies, you want to consider how to deploy them in a controlled and phased approch. We suggest that you use a deployment model.

One approach is depicted in the figure below.

![CA Deployment Model](media/cadeploymentmodel.svg)

The idea is to deploy policies to a small number of users within one persona group. An associated Azure AD group called Persona-Ring 0 can be used for this. After verifying that everything seems to work you change the assignment to a group, Persona-Ring 1 that has more members and so on for multiple Rings.

Then you start by enabling the policies using the same ring based approach and you end up by having all policies deployed.

The members for Ring 0 and Ring 1 would typically be managed manually whereas a Ring 2 or Ring 3 group that covers hundreds or even thousands of users could be based on a dynamic group based on a given percentage of the users in a given Persona group.

The use of rings as part of a deployment model is not only for the initial deployment, but can also be used ongoing when new or changes to existing policies are required.

With a finished deployment you also want to design and implement monitoring controls that we mentioned as part of the Conditional Access principles.

Additionally you may want to automate not only the initial deployment but maybe also the ongoing changes to the policies using CI/CD pipelines. One tool that could be used for this is Microsoft365DSC.

## Related resources

[Conditional Access Policies](https://docs.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policies)

[Plan Implement and administer Conditional Access](https://docs.microsoft.com/learn/modules/plan-implement-administer-conditional-access/)
