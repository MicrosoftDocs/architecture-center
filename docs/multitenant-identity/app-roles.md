---
title: Application roles
description: Learn how to perform authorization by using Azure AD application roles, which are used to assign permissions to users.
author: EdPrice-MSFT
ms.date: 10/06/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - identity
  - web
ms.custom:
  - guide
pnp.series.title: Manage Identity in Multitenant Applications
pnp.series.prev: signup
pnp.series.next: authorize
products:
  - azure-active-directory
---

# Application roles

[:::image type="icon" source="../_images/github.png" border="false"::: Sample code][sample application]

Application roles are used to assign permissions to users. For example, the [Tailspin Surveys][tailspin] application defines the following roles:

* Administrator. Can perform all CRUD operations on any survey that belongs to that tenant.
* Creator. Can create new surveys.
* Reader. Can read any surveys that belong to that tenant.

You can see that roles ultimately get translated into permissions, during [authorization][authorization]. But the first question is how to assign and manage roles. We identified three main options:

* [Azure AD App Roles](#roles-using-azure-ad-app-roles)
* [Azure AD security groups](#roles-using-azure-ad-security-groups)
* [Application role manager](#roles-using-an-application-role-manager).

## Roles using Azure AD App Roles

This is the approach that we used in the Tailspin Surveys app.

In this approach, The SaaS provider defines the application roles by adding them to the application manifest. After a customer signs up, an admin for the customer's AD directory assigns users to the roles. When a user signs in, the user's assigned roles are sent as claims.

> [!NOTE]
> If the customer has Azure AD Premium, the admin can assign a security group to a role, and user members of the group will inherit the app role. This is a convenient way to manage roles, because the group owner doesn't need to be an admin or app owner.

Advantages of this approach:

* Simple programming model.
* Roles are specific to the application. The role claims for one application are not sent to another application.
* If the customer removes the application from their Azure AD tenant, the roles go away.
* The application doesn't need any extra Azure AD permissions, other than reading the user's profile.

Drawbacks:

* Customers without Azure AD Premium cannot assign app roles to security groups. For these customers, all app role assignments to users must be done individually, by an administrator or an owner of the app.
* If you have a backend web API which is separate from the web app, the app role assignments for the web app don't apply to the web API. For more discussion of this point, see [Securing a backend web API].

### Implementation

**Define the roles.** The SaaS provider declares the app roles in the [application manifest][application manifest]. For example, here is the manifest entry for the Surveys app:

```json
"appRoles": [
  {
    "allowedMemberTypes": [
      "User"
    ],
    "description": "Creators can create Surveys",
    "displayName": "SurveyCreator",
    "id": "1b4f816e-5eaf-48b9-8613-7923830595ad",
    "isEnabled": true,
    "value": "SurveyCreator"
  },
  {
    "allowedMemberTypes": [
      "User"
    ],
    "description": "Administrators can manage the Surveys in their tenant",
    "displayName": "SurveyAdmin",
    "id": "c20e145e-5459-4a6c-a074-b942bbd4cfe1",
    "isEnabled": true,
    "value": "SurveyAdmin"
  }
],
```

The `value`  property appears in the role claim. The `id` property is the unique identifier for the defined role. Always generate a new GUID value for `id`.

**Assign users**. When a new customer signs up, the application is registered in the customer's Azure AD tenant. At this point, an Azure AD admin for that tenant or an app owner (under Enterprise apps) can assign app roles to users.

> [!NOTE]
> As noted earlier, customers with Azure AD Premium can also assign app roles to security groups.

The following screenshot from the Azure portal shows users and groups for the Survey application. Admin and Creator are groups, assigned the SurveyAdmin and SurveyCreator app roles, respectively. Alice is a user who was assigned the SurveyAdmin app role directly. Bob and Charles are users that have not been directly assigned an app role.

![Users and Groups](./images/running-the-app/users-and-groups.png)

As shown in the following screenshot, Charles is part of the Admin group, so he inherits the SurveyAdmin role. In the case of Bob, he has not been assigned an app role yet.

![Admin group members](./images/running-the-app/admin-members.png)

> [!NOTE]
> An alternative approach is for the application to assign app roles programmatically, using the Azure AD Graph API. However, this requires the application to obtain write permissions for the customer's Azure AD directory, which is a high privilege that is usually unnecessary.

**Get role claims**. When a user signs in, the application receives the user's assigned role(s) in a claim with type `http://schemas.microsoft.com/ws/2008/06/identity/claims/role` (the `roles` claim in a JWT token).

A user can be assigned multiple roles, or no role. In your authorization code, don't assume the user has exactly one role claim. Instead, write code that checks whether a particular claim value is present:

```csharp
if (context.User.HasClaim(ClaimTypes.Role, "Admin")) { ... }
```

## Roles using Azure AD security groups

In this approach, roles are represented as Azure AD security groups. The application assigns permissions to users based on their security group memberships.

Advantages:

* For customers who do not have Azure AD Premium, this approach enables the customer to use security groups to manage role assignments.

Disadvantages:

* Complexity. Because every tenant sends different group claims, the app must keep track of which security groups correspond to which application roles, for each tenant.
* As users belong to more groups, access tokens grow to include more claims. After a certain limit, Azure AD includes an "overage" claim to limit the token size; see [Microsoft identity platform access tokens](/azure/active-directory/develop/access-tokens). Application roles avoid this issue because they are scoped to the specific application.

<!-- markdownlint-disable MD024 -->

### Implementation

<!-- markdownlint-enable MD024 -->

In the application manifest, set the `groupMembershipClaims` property to "SecurityGroup". This is needed to get group membership claims from Azure AD.

```json
{
   // ...
   "groupMembershipClaims": "SecurityGroup",
}
```

When a new customer signs up, the application instructs the customer to create security groups for the roles needed by the application. The customer then needs to enter the group object IDs into the application. The application stores these in a table that maps group IDs to application roles, per tenant.

> [!NOTE]
> Alternatively, the application could create the groups programmatically, using the Microsoft Graph API. This could be less error prone, but requires the application to obtain privileged read/write permissions for the customer's directory. Many customers might be unwilling to grant this level of access.

When a user signs in:

1. The application receives the user's groups as claims. The value of each claim is the object ID of a group.
2. Azure AD limits the number of groups sent in the token. If the number of groups exceeds this limit, Azure AD sends a special "overage" claim. If that claim is present, the application must query the Azure AD Graph API to get all of the groups to which that user belongs. For details, see [Groups overage claim](/azure/active-directory/develop/id-tokens#groups-overage-claim).
3. The application looks up the object IDs in its own database, to find the corresponding application roles to assign to the user.
4. The application adds a custom claim value to the user principal that expresses the application role. For example: `survey_role` = "SurveyAdmin".

Authorization policies should use the custom role claim, not the group claim.

## Roles using an application role manager

With this approach, application roles are not stored in Azure AD at all. Instead, the application stores the role assignments for each user in its own DB &mdash; for example, using the **RoleManager** class in ASP.NET Identity.

Advantages:

* The app has full control over the roles and user assignments.

Drawbacks:

* More complex, harder to maintain.
* Cannot use Azure AD security groups to manage role assignments.
* Stores user information in the application database, where it can get out of sync with the tenant's Azure AD directory, as users are added or removed.

[**Next**][authorization]

<!-- links -->

[tailspin]: ./tailspin.yml
[authorization]: ./authorize.md
[Securing a backend web API]: ./web-api.yml
[application manifest]: /azure/active-directory/active-directory-application-manifest
[sample application]: https://github.com/mspnp/multitenant-saas-guidance
