---
title: Conditional Access overview
description: Conditional Access overview and introduction.
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

# Overview

This section introduces the Conditonal Access guidance based on Zero Trust principles

## Introduction

This document describes a high-level design and framework for Azure AD Conditional Access which is the central policy engine for access to cloud services based on a Zero Trust approach. The guidance is based on years of experiences from engagements where Microsoft has helped customers secure access to their resources based on Zero Trust Principles.  

The Conditional Access policy framework presented as part of this guidance represents a structured approach for customers to follow to ensure that they can get a good balance between security and usability while ensuring that any interactive/user access is secured

## Document Purpose

The purpose of this document is to help companies understand how they can secure access to resources based on Zero Trust principles.

Not only does the guidance suggest a structured approach on how to secure the access based on personas. it also includes breakdown of suggested personas and shows what the related Conditional Access policies would be for each persona.

## Intended Audience

This guidance is intended for employees and individuals in companies who are responsible for designing and arhitecting security and identity solutions for access control to Azure protected resources well as for people maintaining the solution after it’s delivered.

It assumes a basic working knowledge of Azure AD, and a general understanding of MFA, conditional access, identity, and security concepts.

Knowledge about the following areas is suggested to follow the topics discussed and recommendations and design decisions.

- Azure Active Directory
- Microsoft Endpoint Manager
- Azure AD Identity Management
- Azure AD Conditional Access and MFA for Guest users (B2B)
- Azure AD Security Policies and resource protection
- B2B Invitation process

## Requirements

Companies have different individual requirements and security policies that must be taken into account when forming an architecture and following a suggested framework for Conditional Access. This guidance does not include specific requirements as they will vary from one company to another. Rather the guidance includes principles related to Zero Trust and take this as input to forming the architecture.

Readers are encouraged to include specific company requirements and policies to and adjust accordingly.

Example of requirements for company CONTOSO:

CONTOSO to provide more input in this section

- All access must be protected by at least two factors
- No data on unmanaged devices
- No guest access allowed (if so)
- Access to cloud services must be based on password-less authentication


## Next steps

The Conditional Access guidance is broken down into the following sub-sections

- Conditional access design principles and dependencies 
- Conditional access architecture and personas 
- Conditional access framework and policies 

The design principles sub-section lists recommended principles to follow that together with the companies requirements will server as input to the suggested architecture based on personas.

The Personas section introduce the persona based approach as the basis on how to structure Conditional Access policies as well as shows some suggested personas that can be used as a starting point.

The Conditional Access framework and policy section goes into specific details on how to structure and name Conditional Access policies based on the personas chosen.

## Related resources

[What is Conditional Access](https://docs.microsoft.com/azure/active-directory/conditional-access/overview)

[Common Conditional Access Policies](https://docs.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policy-common)

---
title: Conditional Access design principles and dependencies
description: Conditional Access design principles and dependencies based on Zero Trust.
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

# Conditional access design principles and dependencies

There are no further content requirements for Architecture Guides, except to follow all Microsoft and Docs style and pull request criteria.

The Architecture Guide template requires the following two sections at the end of the article:

## Design Principles

In this section we want to form the design principles to design the Conditional Access solution that meets the requirements and follow such principles.

### Conditional Access as Zero Trust policy engine

Microsoft’s approach to Zero Trust includes Conditional Access as the main policy engine as shown in the figure below.

 ![Zero Trust Model](media/zerotrustmodel.png)

 Conditional Access is used as the policy engine for a Zero Trust architecture covering both policy definition point as well as policy enforcement. Based on various signals/conditions, Conditional Access can decide to allow, block or give limited access to resources as shown below.

 ![CA Signals](media/casignals.png)

 In the figure below we zoom even more in on the Conditional Access elements and what it covers.

 ![ZT User Access](media/ztuseraccess.png)

 The figure shows Conditional Access and related elements that can protect access to resources for users (as opposed to non-interactive/non-human access) as shown in the figure below.

 ![CA Identity Types](media/caidentitytypes.svg)

The non-human access to resources also must be protected. Expect this document to be changed to reflect any such potential changes in the CA policy engine as/if they arrive. Meanwhile, non-human identities accessing cloud resources must be protected by other means (like grant controls for OAuth based access).

Note! As per medio November, Microsoft now provides a preview for targeting service principals and protect access to resources for such machine/workload identities based on location. See persona section for more details.

### Enterprise Access Model

In the past, Microsoft has provided guidance and principles for access to on-premises resources based on a tiering model, where Domain Controllers, PKI, ADFS servers and management solutions managing these servers are considered Tier 0, servers hosting applications are considered Tier 1 and client devices are considered Tier 2.

This model is still relevant for on-premises resources, but when we discuss protecting access to resources in the cloud, Microsoft suggests developing an access control strategy that

- Is comprehensive and consistent
- Rigorously applies security principles throughout the technology stack
- Is flexible enough to meet the needs of the organization

Based on these principles, Microsoft has formed the following the Enterprise Access Model shown below.

![Enterprise Access Model](media/enterpriseaccessmodel.png)

The enterprise access model supersedes and replaces the legacy tier model that was focused on containing unauthorized escalation of privilege in an on-premises Windows Server Active Directory environment. Tier 0 expands to become the control plane, Tier 1 consists of the management and data plane and Tier 2 covers user and app access.

Microsoft suggests moving the control and management plane up into being cloud services using Conditional Access as the main control plane and policy engine, thus defining and enforcing access.

The Azure Active Directory CA policy engine can be extended to other policy enforcement points, including:

- Modern applications: Applications that use modern authentication protocols.
- Legacy applications: Via Azure AD Application Proxy.
- VPN and remote access solutions: Such as Microsoft Always-On, Cisco AnyConnect, Palo Alto Networks, F5, Fortinet, Citrix, and Zscaler.
- Documents, email, and other files: Via Microsoft Information Protection.
- SaaS applications:

### Zero Trust Principles

Based on experiences from having worked with various enterprise customers, it seems that the three main Zero Trust principles that Microsoft defines are well understood and makes sense, especially for security departments. However, sometimes, it is overlooked how important the usability is when designing Zero Trust solutions.

Based on experiences from having worked with various enterprise customers, it seems that the three main Zero Trust principles that Microsoft defines are well understood and makes sense, especially for security departments. However, sometimes, it is overlooked how important the usability is when designing Zero Trust solutions.

The figure below emphasize that the usability should always be considered as an implicit principle and shows a few examples of where usability can be improved as you implement solutions based on Zero Trust.

### Conditional Access Principles

Based on all this, we summarize the suggested principles. Microsoft recommends creating an access model based on Conditional Access that is aligned with Microsoft’s three main Zero Trust principles.

**Verify explicitly**

- Move control plane to the cloud (Integrate app with AAD and protect using Conditional Access)
- Consider all clients as external (even so you are connected to Corp net)
Least privileged access
- Evaluate access based on compliance and risk (including user risk, sign-in risk and device risk)
- Use the following access priorities
  - Access the resource directly protected by Conditional Access
  - Publish access to resource using Azure AD Application Proxy, protected by Conditional Access
  - Use CA based VPN to get access to the resource, restrict access to be on a per-app/DNS name
  
**Assume Breach**

- Segment network infrastructure
- Minimize use of Enterprise PKI
- Migrate SSO from ADFS to PHS
- Minimize dependencies on DCs using “Cloud KDC” (Kerberos KDC provided in Azure AD)
- Move management plane to the cloud (Manage devices with MEM)

Further, some additional and more detailed principles and recommended practices for Conditional Access

- Apply Zero Trust principles to Conditional Access
- Use report-only mode before putting a policy into production.
- Test both positive and negative scenarios
- Use change and revision control on CA policies
- Automate the management of CA policies using tools like Azure DevOps/GitHub or Logic Apps
- Limited use of block mode for general access, only if/where needed
- Assure all applications and platform are protected (CA has no implicit "deny all")
- Protect privileged users in all M365 RBAC systems
- Require password change and MFA for high-risk users and sign-ins
- Restrict access from devices with high risk (Intune compliance policy with compliance check in Conditional Access)
- Protect privileged systems (like Azure Mgt. Portal, AWS, GCP)
- Prevent persistent browser sessions for admins and on untrusted devices
- Block legacy authentication
- Restrict access from unknown or unsupported device platforms
- Restrict strong credential registration
- Consider using default session policy that allows sessions to continue working in case of outage given the satisfied the conditions before the outage

## Design dependencies and related areas

The figure below shows dependencies and related areas. Some of the areas are pre-requisites for CA and others are areas that depend on CA being in place. The design described in this document mainly focuses on CA itself and not on any of the related areas.

![CA Dependencies](media/cadependencies.svg)

## Next Steps

In the next sub-section we will look at the conceptual Conditional Access design based on Zero Trust and personas.

## Related resources

---
title: Conditional Access architecture and personas
description: Conditional Access architecture and personas defined using access cards
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

# Conditional Access architecture

In this section we describe a Conditional Access architecture that adheres til Zero Trust principles using on a Persona based approach to form a structured Conditional Access framework.


## Conditional Access Zero Trust Architecture

An important consideration is to choose which architecture the customer wants to pursue. We suggest considering using a Targeted or a Zero Trust CA Architecture. The figure below shows the idea of the two architectures.

![CAZerotrustarchitecture](media/CAzerotrustarchitecture.svg)

The Zero Trust CA architecture is the one that best fits the principles of Zero Trust (hence the wording). Choosing "All cloud apps" in a CA policy implies that all endpoints are protected by the given grant controls, like known user and known or compliant device. However, the policy applies not only the endpoints/apps that support Conditional Access, but any endpoint that the end-user interacts with.

An example is a device login flow endpoint that is being used in various new PowerShell and Graph tools. Device login flow is a way of allowing login from a device where it is not possible to show a login screen, like on an IOT device.

The mechanism is that a device-based login command is executed on the given device and a code is shown to the user. This code is used on another device where the user goes to "https://aka.ms/devicelogin" and specifies the user and password for the user. After login from the other device, the login succeeds on the IOT device in that user context.

The challenge with this login is that it (in nature) does not support device based Conditional Access, which means that no-one can use such tools/commands if we apply a baseline policy for all cloud apps requiring known user and known device. There are other applications that have the same issue with Device Based Conditional Access.

The other architecture, "Targeted architecture", built on the principle that you only target individual apps in CA policies that you want to protect. In this case, endpoints like device-login endpoint are not subjective to the CA policies and hence will continue to work.

The challenge using this architecture is that you may forget to protect all cloud apps. The number of Office 365 and Azure AD apps increase over time as Microsoft or partners release new features or your IT admins integrate various applications with Azure AD.

Access to all such applications will only be protected if you have a mechanism that detects any new app that supports CA and automatically apply a policy to them. Creating and maintaining such a script is a task not to be underestimated.

Also notice that it is only supported to have about 250 apps included in one CA policy. In some cases we have found that you can have up to 600 apps in one policy before you may get a technical error about payload being exceeded, but that is not supported.


## CA Personas

There have been (and still are) many ways of structuring CA policies. One approach is to structure CA policies based on sensitivity of the resource being accessed. In practice this approach has proven to be very challenging to implement and still protect access to resources for various users. 

An example would be to define a CA policy that requires known user and known device for access to a sensitive resource that must be accessed by both guests and employees. As guests come from a managed device, this would not work and you would have to adjust the CA policy to meet both requirements, with typically would result in a policy that only meets lowest denominator (implies less secure).

Another approach would be to look at the organization and try to define access policies based on where you are in the organization. However this approach would result in way too many CA policies and seems unmanageable.

A better approach is to structure policies related to common access needs and contain a set of access needs in a persona, representing these needs for various users who have the same needs. Personas are identity types that share common enterprise attributes, responsibilities, experiences, objectives, and access.

We want to emphasize that understanding how enterprise assets and resources are accessed by various personas is integral to developing a comprehensive Zero Trust strategy.

Some suggested CA personas from Microsoft are shown in the figure below.

![CA Sample Personas](media/casamplepersonas.png)

Microsoft additionally recommends having separate "persona" defined for identities that are not part of any persona group. We call this "persona" for Global. Global is meant to enforce policies for identities not in a persona group as well as policies that should be enforced for all personas.

|Persona|Description|
|--------|----------|
|Global|Global is a persona/placeholder for policies that are general in nature or do not only apply to one persona. So it is used to define policies that apply to all personas or don't apply to one specific persona. The reason for having this persona is to be able to have a model where we can protect all relevant scenarios. It should be used to hold policies that apply to all users or policies that enforce protection on scenarios not covered by policies for other personas. An example of a global policy is if you want to have the same policy to block legacy authentication for all users, then you could choose to place it as a global policy as opposed to having a legacy policy per persona that may be different for various personas. Another example is where you want to block a given account or user to specific applications and the user/account is not part of any of the personas. An example would be that if you create a cloud identity in the AAD tenant, then this identity is not part of any of the other personas (given it has not been assigned any Azure AD Roles), but still we may want to hinder this identity in getting access to Office 365 services. Some customers may want to block all access from identities not covered by any persona group, whereas others may want to just enforce MFA|
|Admins|We define admins in this context as any non-guest identity (cloud or synced) that have any Azure AD or other Microsoft 365 admin Role (like in MDCA, Exchange, Defender for Endpoints or Compliance). As guests who have such roles are covered in a separate persona, guests are excluded from this persona. Many customers still have separate accounts for sensitive admin roles which this persona is based on. Optimally they use these sensitive accounts from a Privileged Access Workstation (PAW), but often we see that admin accounts are being used on standard workstations where the end-user just switches between accounts on same device/PC. Some customers want to differentiate based on sensitivity of cloud admin roles and assign less sensitive Azure roles to standard end-users (Internals) without using separate accounts for this and rather rely on JIT (Just In Time) elevation. In this case notice that an end-user will be targeted by two sets of CA policies, one for each persona. When using PAWs, you may also want to introduce additional policies that uses device-filters in CA to restrict access for admins to only being allowed when using the PAW|
|Developers|The Developers persona covers users who have special needs. They are based on AD accounts synced to Azure AD but need special access to services like Azure DevOps, CI/CD pipelines, Device Code Flow, GitHub i.e. The developers persona can cover users who are considered Internals as well as Externals, but a person will only be part of one of the personas|
|Internals|Internals cover all users who have an AD account synced to Azure AD who are employees of the company and work in a standard end-user role. Internals who have a developers profile are suggested to be covered by the developers persona|
|Externals|This persona holds all external consultants with an AD account synced to Azure AD. Externals who have a developer profile are suggested to be covered by the developer persona|
|Guests|Guests holds all users who have an Azure AD guest account that has been invited into the customer tenant|
|GuestAdmins|GuestAdmins persona holds all users who have an Azure AD guest account that has any of the mentioned admin roles assigned|
|Microsoft365ServiceAccounts|This persona covers cloud based (AAD) user-based service accounts used to access Microsoft 365 services where no other solution can cover the need, like using a managed service |
|AzureServiceAccounts|This persona covers cloud (AAD) user-based service accounts used to access Microsoft Azure (IaaS/PaaS) services, where no other solution can cover the need, like using a managed service identity|
|CorpServiceAccounts|This persona covers user-based service accounts originating from on-premises AD used from on-premises or from an IaaS based virtual machine in another (cloud) datacenter, like Azure, synced to Azure AD that accesses any Azure or Microsoft 365 service (should be avoided)|
|WorkloadIdentities|This persona covers machine identities, like Azure AD service principals and managed identities. CA now supports protecting access to resources from these accounts|

## Persona Access Cards

It is recommended to define charactaristics of each persona. We suggest using an access card template for that. An exampple is shown below.

![CA Persona Access Card example](media/capersonaaccesscardexample.svg)

The access card for each persona serves as requirements as input to forming the specific Conditonal Access policies for each persona.

## Next steps

In the next sub-section we will form a Conditional Access framework which includes a structured approach on how to group the policies based on the personas created.

## Related resources

[Plan Implement and manage identity access](https://docs.microsoft.com/learn/paths/implement-manage-identity-access/)

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
