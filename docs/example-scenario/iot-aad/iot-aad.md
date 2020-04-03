---
title: Secure access to IoT apps with Azure AD - Developer guide
titleSuffix: Azure Example Scenarios
description: An overview of how a developer can use Azure Active Directory to implement secure authentication and authorization for a SaaS app that manages cloud-connected IoT devices.
author: knicholasa
ms.date: 03/12/2020
ms.category:
  - iot
  - security
ms.topic: example-scenario
ms.service: architecture-center
ms.custom:
    - fcp
social_image_url: /azure/architecture/example-scenario/iot-aad/media/multi-tenant-iot.png
---
# Secure access to IoT apps with Azure AD - Developer guide

This article provides an overview of how a developer can use Azure Active Directory to implement secure authentication and authorization for a [SaaS app](https://azure.microsoft.com/overview/what-is-saas/) that manages cloud-connected IoT devices. We'll cover the basics of setting up the app and two common customer scenarios IoT developers may encounter.

As a developer using a Microsoft identity solution, you'll commonly hear two terms: Azure Active Directory (Azure AD) and the Microsoft identity platform. [Azure AD](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) is Microsoft's cloud-based identity and access management service. [The Microsoft identity platform](https://docs.microsoft.com/azure/active-directory/develop/v2-overview) is a platform that enables developers to use this service in their applications.

For more information about authentication, see [Authentication basics](https://docs.microsoft.com/azure/active-directory/develop/authentication-scenarios).

## Example scenario

In the example scenario for this document, an IoT developer at a company that sells cloud-connected chillers and pumps has created a SaaS app that will be used by client companies to manage their purchased devices, which are connected to the cloud via [Azure IoT](https://azure.microsoft.com/overview/iot/).

The developer would like to integrate with an identity provider like Azure AD rather than writing their own identity solution. This document will explain how and why the developer integrated their app with Azure AD for identity and access management.

## Benefits of integrating with Azure AD

The developer intends to save time and increase their app security by using an existing identity solution rather than creating one themselves.

There are several other benefits that make using Azure AD and the Microsoft identity platform a good choice for this developer:

- End users can reuse pre-existing credentials from work or email accounts to log in

- Azure AD provides the necessary infrastructure to authenticate and manage data from users from multiple client companies (more on this below)

- IT administrators at the client companies can enforce organizational policies

## Sign-in users with their existing credentials using Azure AD multi-tenancy

The developer will sell the app they're creating to many other companies. They want the end users, who are employees of these client companies, to be able to sign-in using their existing work or social account (e.g. Facebook). So, the developer will register their app in the Azure portal as a [multi-tenant app](https://docs.microsoft.com/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant).

Making an app multi-tenant allows users to authenticate using existing Azure AD directory accounts or social accounts. In addition, the admin in charge of each tenant that uses the app can set their own authentication and access policies for the use of the app. 

With a multi-tenant app, the Microsoft identity platform identifies the tenant that each user belongs to when they log in and passes this information back to the app. The developer can use this information within their app to restrict access to data based on tenant membership, maintaining separation of proprietary information between customers.

> [!NOTE]
> To enable the use of social accounts you will need to leverage Azure AD's B2B guest model outlined in scenario two below.

![Diagram illustrating the runtime steps of a user signing in to a multi-tenant app. There are steps for the sign in process that are labeled and explained below the diagram.](./media/multi-tenant-iot.png)

### Runtime

1. User logs in to app

2. Azure AD determines the user's tenant and issues token with tenant ID

3. App accepts the token and user gets access to tenant-specific resources (note that the app developer must enforce the separation of resources by tenant ID)

In the sections below, we'll cover the basics of registering a multi-tenant app with Azure AD.

## Prerequisites

The developer of the app must belong to an Azure AD tenant. If they don't have an existing tenant, they can create a [new Azure AD tenant](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-access-create-new-tenant).

Additionally, the developer needs to have permission to register an app in their Azure AD tenant. You can [check if you have sufficient permissions](https://docs.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal#check-azure-ad-permissions) in the Azure portal.

>[!NOTE]
> The app's home tenant is often times [created specifically for development](https://docs.microsoft.com/azure/active-directory/develop/quickstart-create-new-tenant#create-a-new-azure-ad-tenant) and is separate from the ISV's own corporate tenant.

## Register the app

The first step is for the developer to [register the app](https://docs.microsoft.com/azure/active-directory/develop/quickstart-register-app) inside their own Azure AD tenant. This establishes an identity for the application itself, and allows the developer to choose whether it will be single or multi-tenant.

When the app is registered, two objects are created in the tenant:

- [Application object](https://docs.microsoft.com/graph/api/resources/application?view=graph-rest-1.0) - lives in the tenant where the app was registered (the "home" tenant) and serves as the template for common and default properties.

- [Service principal object](https://docs.microsoft.com/graph/api/resources/serviceprincipal?view=graph-rest-beta) - defines the access policy and permissions for the application in the current tenant. A service principal will be created in each tenant that uses this application.

## Implement process for obtaining user consent

The next step is for the developer to ensure the app obtains consent to access protected resources on the user's behalf.

When a user (or admin) logs in to a multi-tenant application for the first time, the application will ask for consent to access the data it needs to run. For example, if an application needs to read calendar information about a user from Office 365, that user is required to consent to this access before the app can do so. After consent is given, the client application will be able to call the Microsoft Graph API on behalf of the user, and use the calendar information as needed.

When the user consents, a service principal is created in the user's tenant, and sign-in will continue. An example of the consent process is available on GitHub in the [Azure Active Directory consent framework sample](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/active-directory/develop/consent-framework.md). 

![Diagram illustrating the process of obtaining user consent. There are steps for obtaining user consent that are labeled and explained below the diagram.](./media/request.png)

### Diagram explanation

1. App sends sign-in request to common for the user

2. User responds to sign-in prompt and provides any required consent to app

3. Azure AD creates service principal (SP) in customer's tenant

The developer will decide based on the requirements of the app if it needs consent from the user (to access data related to them) or an admin (to allow access to the organization's data). In addition, policies set in the user's tenant may affect this process, such as if admin consent is required to add any new app to the tenant. This is explained in more detail in the [How to: Sign in any Azure Active Directory user using the multi-tenant application pattern](https://docs.microsoft.com/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#understand-user-and-admin-consent).

## Properly direct sign-in requests

For multi-tenant apps, sign-in requests for AAD accounts should be sent to a [common endpoint](https://docs.microsoft.com/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common) for all Azure AD tenants: `https://login.microsoftonline.com/common`. When the Microsoft identity platform receives a request on the common endpoint, it signs the user in and in that process discovers which tenant the user belongs to.

Guest users' sign-in attempts must be directed to a tenant-specific endpoint (i.e. the developer's tenant) `https://login.microsoftonline.com/{TenantId_or_Name}`. This is required when users are signing in with social accounts, and we provide an example of this in the Woodgrove Bank scenario below.

## Azure AD App Roles

In addition to authentication, the developer will want to provide the proper authorization within the app. Authorization is the process of making sure that once a user has access to an app, they are given proper privileges to access data and resources.

Using Azure AD, proper authorization can be enforced with [Role-Based Access Control](https://docs.microsoft.com/azure/role-based-access-control/overview) (RBAC) and [Role Claims](https://docs.microsoft.com/azure/active-directory/develop/active-directory-enterprise-app-role-management). When using RBAC, an administrator grants permissions to use or view resources based on **roles**, and not to individual users or groups.

The developer will [add app roles](https://docs.microsoft.com/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps) to an app and declare them in the [app's manifest](https://docs.microsoft.com/azure/active-directory/active-directory-application-manifest/). When a user signs into the app, Azure AD emits a claim for each role that the user has been granted, individually and from their group membership. The app can use these role claims with the tenant ID claim to do an access check. This will determine whether a user is allowed to perform an action on a specific resource associated with an Azure AD tenant.

An app does not need any extra Active Directory permissions, other than reading the user's profile, to enable app roles. Role assignment managers within each tenant can then assign these pre-defined app roles to users and manage who has access to which resource following their organization's needs.

## Conditional Access

In addition to the role based access control, IT admins at companies using the developer's app can control access to the app and the related IoT resources according to organizational policy around specific conditions, for example requiring that the user is a member of a certain group in order to access the app.

With [Azure AD Conditional Access](https://docs.microsoft.com/azure/active-directory/conditional-access/overview), the developer can implement automated access control decisions for any service principal (i.e. app) in the directory. Common signals that Conditional Access can take into account include

- User or group membership

- IP location information

- Devices marked as compliant

- Specific applications

## Getting the app to customers

The developer may want to provide an e-commerce site for customers to purchase licenses for the app. This e-commerce site is separate from the IoT app itself. A sample workload describing how to build an [e-commerce front-end](../apps/ecommerce-scenario.md) is available on the Azure Reference Architecture Center.

To increase the discoverability and adoption of your IoT app, the developer should publish the app to the [Azure AD App gallery](https://docs.microsoft.com/azure/active-directory/develop/howto-app-gallery-listing). The Azure AD application gallery is in the Azure Marketplace app store, where all application connectors are published for single sign-on and user provisioning. IT administrators can add connectors from the app gallery, and then configure and use the connectors for single sign-on and provisioning for additional convenience for the end user of the app.

## Example app usage scenarios

So far we've explained the basic configurations necessary for a developer to set up a multi-tenant app. Now, let's explore a couple customer scenarios to explain how the authentication process will work for the IoT app. The following two customers, Fabrikam, Inc. and Woodgrove Bank, will sign in to our IoT developer's app in different ways. We'll go through each scenario and discuss how Azure AD helped the developer meet the customers' needs.

### Scenario 1: Customer with an existing Azure AD tenant

Fabrikam, Inc. is a large enterprise customer of the developer and has its own Azure AD tenant. Fabrikam, Inc. would like its employees to sign into the IoT app using their existing Azure AD work accounts. In addition, the company's IT departments will manage access and apply organizational policies for access to the app, the IoT devices, and data the IoT app manages. Fabrikam, Inc.'s global admin will review the permissions required by any app before allowing it in the tenant.

The developer's app supports these requirements as follows:

#### Signing in Fabrikam, Inc.'s users with their existing work accounts

Since the app has been registered as a multi-tenant app, Fabrikam, Inc. users can sign into the app with their Azure AD work credentials. The app must send the sign-in request with these credentials to the common endpoint, `https://login.microsoftonline.com/common`. The Microsoft identity platform will discover which tenant the user is from and send a sign-in response token that contains information on which tenant the user belongs to. The developer can use this information to determine which resources the user can access. 

>[!TIP]
> For more information about using the common endpoint, see [Update your code to send requests to common](https://docs.microsoft.com/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common).

#### Admin consent for the app

Fabrikam, Inc.'s tenant administrators can set the enterprise app settings so that [administrator approval is required](https://docs.microsoft.com/azure/active-directory/develop/active-directory-how-applications-are-added#who-has-permission-to-add-applications-to-my-azure-ad-instance) before a user in the tenant can register or provide consent to a new app. This allows the administrators to control which apps are being run in their tenant. If a user is blocked from registering or signing in, they'll see a generic error message that says they're unauthorized to access the app and they should ask their admin for help.

In addition, the admins can set up the tenant to require admin consent for certain permissions (e.g. the ability to write data to your Azure AD tenant) regardless of whether regular users can register or consent to new apps.

> [!NOTE]
> The [new admin consent workflow](https://docs.microsoft.com/azure/active-directory/manage-apps/configure-admin-consent-workflow) gives tenant admins a secure way to grant access to applications that require admin approval while allowing them to disable their end-user's ability to consent. When a user tries to access an app but is unable to provide consent, they can send a request for admin approval. Benefits of the admin consent workflow include the following:
>
>- Helps admins manage access to organizational data and regulate the enterprise apps within their organization.
>- Gives administrators increased visibility into what app users need access to.
>
>The new workflow gives all end-users the ability to request access to apps that they were previously unable to access because of a lack of permissions. The request is sent via email to admins who have been designated as reviewers. A reviewer acts on the request, and the user is notified of the action.

### Scenario 2: Customer without Azure AD tenant

Woodgrove Bank is another company using the developer's app. Woodgrove Bank does not have an Azure AD tenant and would like its employees to log in with social IDs such existing Facebook or Google accounts. As with other customers, isolation of Woodgrove Bank's users and resources from other customers must be maintained. In addition, the developer would like to ensure all access to the app can be audited and reported on.

To enable this, the developer and IT Admins can use [Azure AD B2B (business-to-business) collaboration](https://docs.microsoft.com/azure/active-directory/b2b/what-is-b2b), adding Woodgrove Bank's users as **guests in the app's home tenant**. Azure AD B2B will fulfill all the business requirements as follows.

#### Isolation

The developer can [create a security group](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context) in their home tenant that will act as the isolation boundary for Woodgrove Bank's users and their IoT devices. The developer or IT Admin in the developer's tenant can choose to designate a Woodgrove Bank employee as the owner of the security group so that they can control security group membership. The developer's app will factor in guest users' group memberships when making access control decisions.

In order to enforce company policies, the Woodgrove security group owner can set group-level access policies that will control how the group members can access the app.

>[!NOTE]
> Depending on the business logic required by your app, security group ownership and membership can be managed by either an account manager who is an employee of the developer's company or by a Woodgrove guest user who is asigned as owner of the group. To learn more about Azure AD security group functionality, see [Manage app and resource access using Azure Active Directory groups](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-manage-groups).

![Diagram illustrating guest isolation in a tenant with security groups. There are steps for adding a new guest user that are labeled and explained below the diagram.](./media/single-tenant-iot.png)

##### Runtime

1. User logs in to app using the targeted tenant endpoint

2. Azure AD issues a token with tenant ID and group membership claims

3. App accepts the token and user gets access to security group-specific resources

#### Adding guest users to a tenant

The developer can enable guests to log in with existing social account using an [invitation and redemption process](https://docs.microsoft.com/azure/active-directory/b2b/redemption-experience) that involves sending either a direct link or an email to the guest. The process can be customized using [Azure AD business-to-business APIs](https://docs.microsoft.com/azure/active-directory/b2b/customize-invitation-api).

There are several options for authenticating guests who wish to use non- Azure AD accounts with your app:

- [Direct federation](https://docs.microsoft.com/azure/active-directory/b2b/direct-federation). Direct federation works with identity systems that support the SAML or WS-Fed standards.

- [Google federation](https://docs.microsoft.com/azure/active-directory/b2b/google-federation). Gmail users are authenticated using Google federation.

- [One Time Passcode (OTP) authentication](https://docs.microsoft.com/azure/active-directory/b2b/one-time-passcode). Provides a temporary code to authenticate users who cannot be authenticated through other means.

To enable guest sign-ins, the developer must ensure that guest users' sign-in attempts are directed to the tenant-specific endpoint (i.e. the developer's tenant) `https://login.microsoftonline.com/{TenantId_or_Name}`. Note that this differs from the endpoint used for users with existing Azure AD accounts, so may require the developer to implement a separate sign-in page specifically for guests.

## Conclusion

This has been an overview of how to use Azure AD to secure your application, focusing on common IoT app scenarios. The links below provide more information on the topics discussed in this document. 

## Other resources

- [Microsoft identity platform best practices and recommendations](https://docs.microsoft.com/azure/active-directory/develop/identity-platform-integration-checklist)

- [Manage identity in multi-tenant applications](../../multitenant-identity/index.md)

- [Azure AD developer guidance](https://docs.microsoft.com/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)

- [Permissions and consent](https://docs.microsoft.com/azure/active-directory/develop/v2-permissions-and-consent)

- [Signing up and signing in with Azure AD](https://docs.microsoft.com/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps#signing-up-and-signing-in-with-azure-ad)

- [Self-service group management](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context)​

- [Restrict your app to a set of users](https://docs.microsoft.com/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users)

- [Microsoft identity platform (v2.0) Authentication flows and app scenarios](https://docs.microsoft.com/azure/active-directory/develop/authentication-flows-app-scenarios)
