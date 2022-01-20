This article describes a Conditional Access architecture that adheres to Zero Trust principles. The architecture uses a persona-based approach to form a structured Conditional Access framework.

## Conditional Access Zero Trust architecture

You first need to choose an architcture. We recommend that you consider either a Targeted or a Zero Trust Conditional Access architecture. This diagram shows the corresponding settings:

![Diagram that shows the settings for Targeted and Zero Trust architectures.](images/conditional-access-architecture.png)

The Zero Trust Conditional Access architecture is the one that best fits the principles of Zero Trust. If you select the **All cloud apps** option in a Conditional Access policy, all endpoints are protected by the given grant controls, like known user and known or compliant device. But the policy doesn't just apply to the endpoints and apps that support Conditional Access. It applies to any endpoint that the user interacts with.

An example is a device-login flow endpoint that's used in various new PowerShell and Microsoft Graph tools. Device-login flow provides a way to allow sign-in from a device on which it's not possible to show a sign-in screen, like on an IoT device.

A device-based sign-in command is run on the given device, and a code is shown to the user. This code is used on another device. The user goes to https://aka.ms/devicelogin and specifies their user name and password. After sign-in from the other device, the sign-in succeeds on the IoT device in that user context.

The challenge with this sign-in is that it doesn't support device-based Conditional Access. This means that nobody can use the tools and commands if you apply a baseline policy for all cloud apps that requires known user and known device. There are other applications that have the same problem with device-based Conditional Access.

The other architecture, the Targeted one, is built on the principle that you target only individual apps that you want to protect in Conditional Access policies. In this case, endpoints like device-login endpoints aren't protected by the Conditional Access policies, so they continue to work.

The challenge with this architecture is that you might forget to protect all your cloud apps. The number of Office 365 and Azure Active Directory (Azure AD) apps increases over time as Microsoft and partners release new features and as your IT admins integrate various applications with Azure AD.

Access to all such applications is protected only if you have a mechanism that detects any new app that supports Condition Access and automatically applies a policy to them. Creating and maintaining such a script could be challenging.

Also, the maximum supported number of apps for any one Conditional Access policy is approximately 250. You might be able to add as many as 600 apps before you get a technical error about payload being exceeded, but that number isn't supported.

## Conditional Access personas

There are many ways to structure Condtional Access policies. One approach is to structure policies based on the sensitivity of the resource being accessed. In practice, this approach can be challenging to implement and while still protecting access to resources for various users. 

For example, you could define a Conditional Access policy that requires a known user and a known device for access to a sensitive resource that must be accessed by both guests and employees. When guests come from a managed device, the access request won't work. You'd need to adjust the Condtional Access policy to meet both requirements, which typically would result in a policy that meets the less secure requrement.

Another approach would be to try to define access policies based on where you are in the organization. This approach could result in many Conditional Acceess policies and might be unmanageable.

A better approach is to structure policies related to common access needs and contain a set of access needs in a persona that represents these needs for various users who have the same needs. Personas are identity types that share common enterprise attributes, responsibilities, experiences, objectives, and access.

Understanding how enterprise assets and resources are accessed by various personas is integral to developing a comprehensive Zero Trust strategy.

Some suggested Conditional Access personas from Microsoft are shown here:

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