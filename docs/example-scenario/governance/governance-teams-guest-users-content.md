This example scenario helps users collaborate with other organizations, by providing identity and governance controls for external users when using Azure Active Directory (Azure AD) B2B collaboration.

## Architecture

:::image type="content" source="media/governance-teams-guest-users.svg" alt-text="Architecture for governance of Teams guest users." lightbox="media/governance-teams-guest-users.svg" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/US-1897068-governance-teams-guest-users.vsdx) of this architecture.*

### Workflow

1. **Resource directory** - This is the Azure AD directory that contains resources, which are Microsoft 365 groups and teams. For this example, the resource is a project team that is added to the access package, so that users external to the organization can request access to it.
1. **External directory (Connected organization)** -This is the external Azure AD directory that contains external users from the connected organization. These users can be allowed by a policy to request access to the project team.
1. **Catalog 1** - A catalog is a container for related resources and access packages. Catalog 1 contains the project team and its access package.

   Catalogs allow for delegation, so that non-administrators can create access packages. Catalog owners can add resources that they own to a catalog.
   
1. **Resources** - These are the resources that appear in the access packages. They can include security groups, applications, and SharePoint Online sites. In this example, it's the project team.
1. **Access 1** - An access package is a collection of resources with access types for each. Access packages are used to govern access for internal and external users. In this example, the project team is the resource with a single policy that allows external users to request access. Internal users in this example don't need to use Azure AD entitlement management. They're added to the project team by using Microsoft Teams.
1. **Group 1 resource role** - Resource roles are permissions that are associated with, and defined by, a resource. A group has two roles—member and owner. SharePoint sites typically have three roles, but can have additional custom roles. Applications can have custom roles.
1. **External access policy** - This is the policy that defines the rules for assignment to an access package. A policy is used in this example to ensure that users from connected organizations can request access to the project team. After a request is made, approval is required from approvers as defined in the policy. The policy also specifies time limits and renewal settings.
1. **Approver** - An approver approves the access request. This can be an internal or external user.
1. **Requester** - This is the external user that requests access via the My Access portal. The portal only shows the access packages that the requester is allowed to request.

#### Requesting access to a resource for users external to the organization flow

Here is a high-level workflow that shows how access to the Microsoft 365 group or team is granted to external users. It includes the removal of a guest account when access is no longer required or a time limit is reached.

:::image type="content" source="media/governance-teams-guest-users-access.svg" alt-text="Flow diagram with steps that shows how access works for external users." lightbox="media/governance-teams-guest-users-access.svg" border="false" :::

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) offers cloud-based identity and access management services that provide a way for users to sign in and access resources. It has the following features and capabilities:
  - **Azure AD entitlement management** is an identity governance feature that enables organizations to manage identity and access lifecycles at scale, by automating access request workflows, access assignments, reviews, and expiration.
  - **Azure AD business-to-business (B2B) collaboration** is used by Azure AD entitlement management to share access, so that internal users can collaborate with external users.
  - **Azure AD access reviews** enable organizations to efficiently manage group memberships, access to enterprise applications, and role assignments. User access can be reviewed on a regular basis to make sure only the right people have continued access.
  - **Microsoft Teams guest access** allows external users to access teams, channels, resources, chats, and applications, while you maintain control over your corporate resources.
  - **Azure AD Conditional Access** brings signals together to make decisions, and enforce organizational policies. Conditional Access in this solution was used to enforce Terms of Use agreements and multifactor authentication, and to set session timeouts for guest accounts.

### Alternatives

An alternative solution to Azure AD entitlement management is to allow internal users to invite external users to a team. An invited user could then create a guest account in the resource directory.

This alternative doesn't provide the identity and governance controls that the customer required. The deficiencies compared to AD entitlement management are:

- External users can't request access—there must be an invitation. The external user has to know how to request an invitation, a process that can vary by team, and change over time.
- There are no business justifications, email notifications, review processes, or approval processes, which is an auditing issue.
- Access to specific resources can't be managed, removed, or updated easily. Because project resources are likely to change, this is an efficiency issue.
- If an external user is invited but the user's organization isn't allowed, the user is denied access, causing confusion.
- Guest accounts aren't automatically removed and there's no expiration set. A manual process to handle expiration is error-prone and less efficient than an automatic process that requires limits to be set at account creation. This is a security issue and an efficiency issue.

Building a custom solution to handle these issues is unlikely to be cost-competitive or feature-competitive with AD entitlement management.

## Scenario details

This example scenario was built during the COVID-19 pandemic, when a customer had an immediate requirement to collaborate with other organizations. This meant providing identity and governance controls for external users.

Microsoft Teams was the customer's primary tool for company communications. Users collaborated by using Teams chat, meetings, and calling. Teams channels provided them access to files and conversations.

Teams meetings provided an effective way to meet with external users. However, external users couldn't access the teams and channels, so collaborating with them was clumsy, and productivity was impeded. The customer needed something better.

Teams provides two options to communicate and collaborate with external users:

- **External access** - A type of federation that allows internal users to find, call, and chat with external users. External access users can't be added to teams unless they are invited as guests by using guest access.
- **Guest access** - Allows internal users to invite external users to join a team. The invited users get a guest account in Azure Active Directory (Azure AD). Guest access allows external users to be invited to teams and provides access to documents in channels, and to resources, chats, and applications. The customer maintains control over corporate data as required.

Guest access met the customer's collaboration requirements, but gave rise to security and governance concerns:

- Guests must only have access to specific teams as required, and only for as long as necessary. When a project completes, the guest account must be removed.
- There must be an approval process for creating guest accounts that satisfies auditing requirements. Internal users must review requests and approve them as appropriate.
- It must be possible to build and automate the solution quickly. No guest accounts can be created until appropriate security and governance controls are in place.

Azure AD entitlement management was the primary tool to satisfy the security and governance requirements:

- It helps efficiently manage access to Microsoft 365 groups, including teams, applications, and SharePoint online sites, for both internal and external users.
- It provides the ability to automate access request workflows, access assignments, reviews, and expiration.

Guest access and Azure AD entitlement together met the customer's collaboration requirements. External users can join selected teams and the access is managed. Moreover, Azure AD entitlement management offers functionality for possible future use, such as managing access to resources other than teams.

### Potential use cases

This solution applies to any situation that requires managing access—for those internal and external users that need it, to groups, applications, and SharePoint Online sites. Azure AD entitlement management has these features and advantages:

- There's simplified onboarding and management for employee access to resources such as:
  - Azure AD security groups.
  - Microsoft 365 groups.
  - Microsoft 365 teams.
  - Applications, including SaaS applications.
  - Custom applications that implement appropriate security measures.
  - SharePoint Online sites.
- There are simplified procedures for external users to gain access to the resources that they need.
- You can designate which connected organizations are allowed to provide external users that can request access.
- A user who requests access, and is approved, is automatically invited into the team directory, and assigned access to resources.
- A time limit can be set on a user's access to resources, with automatic removal when the limit is reached.
- When access expires for an external user that has no other access package assignments, the user's account can be automatically removed.
- You can ensure that users have no more access than they require.
- There's an approval process for access requests that includes approval by designated individuals, such as managers.
- You can manage access to other resources that rely upon Azure AD security groups or Microsoft 365 groups. An example is granting licenses to users by using group-based licensing.
- You can delegate to non-administrators the ability to create access packages that contain resources that users can request.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

An important implementation step is configuring tenant settings to allow for external users.

:::image type="content" source="media/governance-teams-guest-users-settings.svg" alt-text="A list of seven settings that require verification." lightbox="media/governance-teams-guest-users-settings.svg" border="false" :::

1. **Enable catalog for external users** - Make sure the catalog has **Enabled for external users** set to **Yes**. By default, when you create a new catalog in Azure AD entitlement management, it's enabled to allow external users to request access to packages in the catalog.
1. **Azure AD B2B external collaboration settings** - The Azure B2B external collaboration settings can affect whether you can use Azure AD entitlement management to invite external users to resources. Verify these settings:
   - Check whether guests are allowed to invite other guests to your directory. We recommend setting **Guests can invite** to **No** to only allow governed invitations.
   - Make sure that you're allowing or blocking invitations appropriately. For more information, see [Allow or block invitations to B2B users from specific organizations](/azure/active-directory/external-identities/allow-deny-list).
1. **Review your Conditional Access policies** - Verify Conditional Access to make sure guest users are excluded from any Conditional Access policies that they can't satisfy. Otherwise they can't sign in to your directory and won't have access to the resource.
1. **Review your SharePoint Online external sharing settings** - If you include SharePoint Online sites in an access package for external users, make sure that you configure the organization-level external sharing setting. Set as **Anyone** if sign-in isn't required, or **Existing guests** for invited users. For more information, see [Change the organization-level external sharing setting](/sharepoint/turn-external-sharing-on-or-off#change-the-organization-level-external-sharing-setting).
1. **Review your Microsoft 365 group sharing settings** - If you include Microsoft 365 groups or teams in an access package for external users, make sure that **Let users add new guests to the organization** is set to **On** to allow guest access.
1. **Review your Teams sharing setting** - If you include teams in an access package for external users, make sure that **Allow guest access in Microsoft Teams** is set to **On** to allow guest access. Also, check that the Teams **Guest Access settings** are configured.
1. **Manage the lifecycle of external users** - You can select what happens when an external user no longer has any access package assignments. This happens when all assignments are either relinquished by the user, or expired. By default, the user is blocked from signing in to your directory. After 30 days, the guest user account is removed from your directory.

Additional considerations:

- **Access assignment** - Access packages don't replace other mechanisms for access assignment. They're most appropriate in situations such as:
  - Employees need time-limited access for a particular task.
  - Access requires the approval of a manager or other designated individual.
  - Departments want to manage their resources without IT involvement.
  - Two or more organizations are collaborating on a project, so multiple users from one organization need to be invited to access another organization's resources.
- **Updating resources** - With Azure AD entitlement management, you can change the resources in an access package at any time. The users of the package have their resource access automatically adjusted to match the changed package.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The use of Azure AD entitlement management requires an Azure AD Premium P2 license.
- Guest access can be used with all Microsoft 365 Business Standard, Microsoft 365 Business Premium, and Microsoft 365 Education subscriptions. No additional Microsoft 365 license is necessary.
- The billing model for Azure AD External Identities applies to guests in Microsoft 365. Only external users can be invited as guests.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Martin Boam](https://uk.linkedin.com/in/martinboam) | Associate Architect

## Next steps

- [Overview of teams and channels in Microsoft Teams](/microsoftteams/teams-channels-overview)
- [Understand teams and channels in Microsoft Teams](/microsoftteams/teams-adoption-understand-teams-and-channels)
- [Use guest access and external access to collaborate with people outside your organization](/microsoftteams/communicate-with-users-from-other-organizations)
- [Create a new access package in Azure AD entitlement management](/azure/active-directory/governance/entitlement-management-access-package-create)
- [Tutorial: Manage access to resources in Azure AD entitlement management](/azure/active-directory/governance/entitlement-management-access-package-first)
- [What is Azure AD entitlement management?](/azure/active-directory/governance/entitlement-management-overview)
- [What is Azure AD Identity Governance?](/azure/active-directory/governance/identity-governance-overview)
- [What are Azure AD access reviews?](/azure/active-directory/governance/access-reviews-overview)
- [Common scenarios in Azure AD entitlement management](/azure/active-directory/governance/entitlement-management-scenarios)
- [Govern access for external users in Azure AD entitlement management](/azure/active-directory/governance/entitlement-management-external-users)
- [Govern access for users external your organization](/azure/active-directory/governance/entitlement-management-scenarios#govern-access-for-users-external-your-organization)
- [Collaborate with guests in a team](/microsoft-365/solutions/collaborate-as-team?view=o365-worldwide)
- [Use guest access and external access to collaborate with people external your organization](/microsoftteams/communicate-with-users-from-other-organizations)
- [Collaborating with people outside your organization](/microsoft-365/solutions/collaborate-with-people-outside-your-organization?view=o365-worldwide)
- [What is Conditional Access?](/azure/active-directory/conditional-access/overview)

## Related resources

- [Create an AD DS resource forest in Azure](/azure/architecture/reference-architectures/identity/adds-forest)
- [Deploy AD DS in an Azure virtual network](/azure/architecture/reference-architectures/identity/adds-extend-domain)
- [Hybrid identity](/azure/architecture/solution-ideas/articles/hybrid-identity)
- [Integrate on-premises AD domains with Azure AD](/azure/architecture/reference-architectures/identity/azure-ad)
- [Azure Active Directory identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)
