---
title: Use Azure AD to secure access to IoT apps
titleSuffix: Azure Example Scenarios
description: Explore scenarios that use Azure Active Directory to manage access to a cloud-connected IoT app. 
author: v-thepet
ms.date: 03/25/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.custom:
    - fasttrack
    - fcp
---

# Azure Active Directory for IoT apps

This example uses Azure Active Directory (Azure AD) to manage multi-tenant identity and access to a [Software as a Service (SaaS)](https://azure.microsoft.com/overview/what-is-saas/) app that controls cloud-connected Internet of Things (IoT) devices. The article explains the basics of setting up access to the IoT app, and how to use Azure AD to address common customer scenarios.

[Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis) is Microsoft's cloud-based identity and access management service.  The [identity platform](/azure/active-directory/develop/v2-overview) lets developers use Azure AD in their applications.

In this example, a chiller and pump sales company creates a SaaS app that clients can use to manage the devices, which are connected to the cloud via [Azure IoT](https://azure.microsoft.com/overview/iot/). The company wants to save time and maximize security by using an existing access and identity solution. This article explains why and how the company uses Azure AD for app identity and access management.

Several benefits make Azure AD and the identity platform a good choice for this company:

- End users can sign in with preexisting credentials from work or social accounts.
- IT administrators at client companies will be able to enforce their organizational policies.
- Azure provides the necessary infrastructure to authenticate and manage user data from several different client companies.

For more about Azure AD, see [Azure Active Directory](https://azure.microsoft.com/services/active-directory/).

The company registers its IoT app as a [multi-tenant app](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant) in the Azure portal. Client companies that have their own Azure AD tenants can now use the multi-tenant app directly. Companies that don't have Azure AD tenants can leverage Azure AD's [business-to-business (B2B) guest model](/azure/active-directory/b2b/what-is-b2b) for app access. Client companies' end users can sign in to the app with their existing work or social accounts. 

With a multi-tenant app:
- Users can authenticate using Azure AD or personal accounts. 
- The admin in charge of each tenant can set authentication and access policies for the app in that tenant. 
- The identity platform identifies the tenant that each user belongs to, and can use this information to restrict access to data based on tenant membership, maintaining separation of proprietary information.

## Relevant use cases

- Large enterprises that have their own Azure AD tenants, and want to use their own policies to manage access to an app
- Companies that don't have an Azure AD tenant, and want their users to be able to sign in to the app with social IDs like Facebook or Google
- App developers who want to support both of the preceding scenarios in a single app

## Architecture

![Azure AD multi-tenant app access](./media/multi-tenant-iot.png)

In this example of multi-tenant app access:
1.  A user signs in to the app, targeting the Azure AD endpoint.
2.  Azure AD determines the user's tenant, and issues a token with the tenant ID.
3.  The app accepts the token, and the user gets access to any specific app resources for their tenant.

### Prerequisites

To register an app with Azure AD:
- You must belong to an Azure AD tenant. If you don't have one, you can [create a new Azure AD tenant](/active-directory/fundamentals/active-directory-access-create-new-tenant). 
- You must have permission to register an app in the tenant. You can [check if you have sufficient permissions](/azure/active-directory/develop/howto-create-service-principal-portal#check-azure-ad-permissions) in the Azure portal.

### App registration

[App registration](/azure/active-directory/develop/quickstart-register-app) in your Azure AD tenant lets you establish an identity for the app, and choose to create it as multi-tenant.

App registration creates two objects in the tenant:
- The [application object](/graph/api/resources/application?view=graph-rest-1.0) resides in the tenant where the app was registered or *home* tenant, and serves as the template for common and default properties.
- The [service principal object](/graph/api/resources/serviceprincipal?view=graph-rest-beta) defines the access policy and permissions for the app. A service principal will be created in each tenant that uses the app.

### Direct sign-in requests

For multi-tenant apps, all Azure AD tenants' sign-in requests are sent to a [common endpoint](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common), *https:\//login.microsoftonline.com/common.* When the Microsoft identity platform receives a request on the */common* endpoint, it signs the user in, and in that process discovers which tenant the user belongs to.

Guest users' sign-in attempts are directed to the app's tenant endpoint, *https:\//login.microsoftonline.com/{TenantId_or_Name}*. 

### Obtain user consent

Make sure the app [obtains consent](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#understand-user-and-admin-consent) to access protected resources on the user's behalf. When a user from a new tenant signs in to the app for the first time, Azure AD asks them to consent to the permissions requested by the app. If they consent, Azure AD creates a service principal in the user's tenant, and the user can continue to sign in.

![Azure AD common-tenanted endpoint](./media/request.png)

1. The app sends the sign-in request to */common* on behalf of the user.
2. The user responds to the sign-in prompt and consents to the app.
3. Azure AD creates a service principal and delegation link in the user's tenant.

### Azure AD App roles and permissions

In addition to authentication, Azure AD can provide the proper authorization within the app, using [Role-Based Access Control (RBAC)](/azure/role-based-access-control/overview) and [Role Claims](/azure/active-directory/develop/active-directory-enterprise-app-role-management). 

For RBAC, an administrator grants permissions to *roles*, not to individual users or groups. A developer [adds roles](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps) to an app, and declares them in the app's [manifest](/azure/active-directory/active-directory-application-manifest/). When a user signs into the app, Azure AD emits a claim for each role that the user is granted. The app uses these role claims with the tenant ID claim to perform an access check. The check determines whether the user is allowed to perform an action on a specific resource associated with the Azure AD tenant.

An app doesn't need any extra permissions to enable app roles, other than reading the user's profile. Role assignment managers can assign the pre-defined app roles to users, and manage who has access to which resource in accordance with their organization's needs.

### Conditional Access
In addition to RBAC, IT admins at client companies can control access to the app and related IoT resources according to specific conditions set by organizational policy. [Azure AD Conditional Access](/azure/active-directory/conditional-access/overview) can implement automated access control decisions for any service principal app in the directory. Conditional Access can take into account common signals like:
- User or group membership
- IP location information
- Devices marked as compliant
- Specific applications

## Deploy the scenario

A couple of different customer scenarios explain how the Azure AD authentication process works for the IoT app. Two client companies will sign in to the app in different ways.

### Customer with an existing Azure AD tenant

Fabrikam is a large enterprise customer that has its own Azure AD tenant, and would like its employees to sign into the IoT app using their existing Azure AD work accounts. The company's IT department will also manage access and apply organizational polices for access to the app, the IoT devices, and data the IoT app manages. Fabrikam's global admin will review the permissions required by any app before allowing it in the tenant. 

The multi-tenant app supports these requirements as follows:

- **Sign in users with their existing work accounts**
  
  Since the app has been registered as a multi-tenant app, Fabrikam users can sign into the app with their Azure AD work credentials. The app sends the sign-in request with these credentials to the common endpoint, *https:\//login.microsoftonline.com/common*. The identity platform discovers which tenant the user is from, and send a sign-in response token that contains information on which tenant the user belongs to. The app uses this information to determine which resources the user can access. For more information about using the common endpoint, see [Update your code to send requests to /common](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common).
  
- **Obtain admin consent for the app**
  
  Fabrikam's tenant administrators can set the [enterprise app settings](/azure/active-directory/develop/active-directory-how-applications-are-added#who-has-permission-to-add-applications-to-my-azure-ad-instance) to require admin approval before a user in the tenant can register or provide consent to a new app. This allows the admins to control which apps are being run in their tenant. If a user is blocked from registering or signing in, they will see a generic error message that says they're not authorized to access the app and should ask their admin for help.
  
  The admins can also set up the tenant to require admin consent for other permissions, such as the ability to write data to the tenant, regardless of whether users can register or consent to new apps.

### Customer with no Azure AD tenant

Woodgrove, another company using the IoT app, doesn't have an Azure AD tenant. Woodgrove wants its employees to be able to sign in to the app with social IDs like Facebook or Google. [Azure AD B2B collaboration](/azure/active-directory/b2b/what-is-b2b) can support this scenario by adding Woodgrove's users as *guests* in the app's home tenant.

To enable guest sign ins, make sure that guest users' sign-in attempts are directed to the app's tenant-specific endpoint, *https:\//login.microsoftonline.com/{TenantId_or\Name}*. This may require a separate sign-in page specifically for guests. For more information, see the [FAQ](/azure/active-directory/b2b/faq#what-applications-and-services-support-azure-b2b-guest-users). 

The app must maintain isolation of Woodgrove's users and resources from those of other customers and your tenant. All access to the app must also be able to be audited and reported on. 

Azure AD B2B can fulfill these business requirements as follows:

- **Isolation**
  
  You can [create a security group](/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context) in your home tenant to act as the isolation boundary for Woodgrove's users and their IoT devices. Woodgrove can designate one of its users as the owner of the security group, so they can control membership. Guests are subject to the tenant-level policies set in your home tenant, as well as security group-level policies put in place by the group owner. The app will factor in guest users' group memberships when making access control decisions.
  
  ![Guest isolation in the app tenant](./media/single-tenant-iot.png)

  With guest isolation in the app tenant:
  1.  The user signs in to the app, targeting the tenanted endpoint.
  2.  Azure AD issues a token with tenant ID and group membership claims.
  3.  The app accepts the token, and the user gets access to security group-specific resources.
  
- **Add guest users to the tenant**
  
  To let guests sign in with existing social accounts, an [invitation and redemption process](/azure/active-directory/b2b/redemption-experience) sends either a direct link or an email to the guests. You can customize the process using [Azure AD business-to-business APIs](/azure/active-directory/b2b/customize-invitation-api). If you don't know which external users need access to your app, you can develop a self-service sign-up app that doesn't require an invitation. 
  
  There are several options for authenticating guests who use non-Azure AD accounts with your app:
  - [Direct federation](/azure/active-directory/b2b/direct-federation). Direct federation works with identity systems that support the SAML or WS-Fed standards.
  - [Google federation](/active-directory/b2b/google-federation). Gmail users are authenticated using Google federation.
  - [One Time Passcode (OTP) authentication](/azure/active-directory/b2b/one-time-passcode) provides a temporary code to authenticate users who can't be authenticated through other means.

## Considerations

- The app's home tenant may be [created specifically for development](/azure/active-directory/develop/quickstart-create-new-tenant#create-a-new-azure-ad-tenant) and be separate from the company's corporate tenant.

- When setting up user consent, consider whether permission is needed from just the user, to access data related to them, or an admin, to allow access to the organization's data. Also consider policies set on the user's tenant, such as whether an admin of the tenant must give consent to add a new app. For more information, see [Understand user and admin consent](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#understand-user-and-admin-consent).

- The [new admin consent workflow (in Public Preview)](/azure/active-directory/manage-apps/configure-admin-consent-workflow) gives tenant admins a secure way to grant access to apps that require admin approval, and allows them to disable their end users' ability to consent. The admin consent workflow helps admins manage access to organizational data and regulate the enterprise apps in their organization, while giving them visibility into the apps users need access to. 
  
  The new workflow gives all end-users the ability to request access to apps that they were previously unable to access because of a lack of permissions. When a user tries to access an app but is unable to provide consent, they can send a request for admin approval via email to admins who have been designated as reviewers. A reviewer acts on the request, and notifies the user of the action.

## Next steps 
- Provide an e-commerce site, separate from the IoT app itself, for customers to purchase licenses for their app. See the sample workload describing how to build an [e-commerce front-end](/azure/architecture/example-scenario/apps/ecommerce-scenario) in the Azure Reference Architecture Center.
- To increase the discoverability and adoption of your IoT app, publish the app to the [Azure AD app gallery](/azure/active-directory/develop/howto-app-gallery-listing) in the Azure Marketplace app store, where all single sign-on and user provisioning application connectors are also published. For additional end-user convenience, IT administrators can add connectors from the app gallery, and then configure and use the connectors for single sign-on and provisioning.

## Related resources
- [Azure IoT reference architecture articles]() in the Azure Architecture Center
- [Authentication basics](/azure/active-directory/develop/authentication-scenarios)
- [Microsoft identity platform best practices and recommendations](/azure/active-directory/develop/identity-platform-integration-checklist)
- [Azure AD developer guidance](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)
- [Permissions and consent](/azure/active-directory/develop/v2-permissions-and-consent)
- [Signing up and signing in with Azure AD](/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps#signing-up-and-signing-in-with-azure-ad)
- [Self-service group management](/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context)​
- [Restrict your app to a set of users](/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users)
- [Microsoft identity platform (v2.0) authentication flows and app scenarios](/azure/active-directory/develop/authentication-flows-app-scenarios)
