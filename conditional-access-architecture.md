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