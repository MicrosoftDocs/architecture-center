---
title: Title
titleSuffix: Azure Example Scenarios
description: Description
author: GitHubAlias
ms.date: 01/31/2020
ms.topic: example-scenarios
ms.service: architecture-center
ms.custom:
    - fasttrack
    - fcp
---
# Secure access to IoT apps with Azure AD

This document provides an overview of how a developer can use Azure
Active Directory to secure access to a [SaaS app](https://azure.microsoft.com/en-us/overview/what-is-saas/) in that manages
cloud-connected IoT devices. We'll cover the basics of setting up the
app as well as two common customer scenarios IoT developers may
encounter.

As a developer using a Microsoft identity solution, you will commonly
hear two terms: Azure Active Directory (Azure AD) and the identity
platform. [Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis) is Microsoft's cloud-based identity and access
management service. [The identity platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-overview) is a platform that enables
developers to utilize this service in their applications.

For a gentle introduction into the basics of authentication, consult the
document on [Authentication basics](https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-scenarios).

# Example scenario

In the example scenario for this document, an IoT developer at a company
that sells cloud-connected chillers and pumps has created a SaaS app
that will be used by client companies to manage their purchased devices,
which are connected to the cloud via [Azure IoT](https://azure.microsoft.com/en-us/overview/iot/).

The developer would like to integrate with an identity provider like
Azure AD rather than writing their own identity solution. This document
will explain how and why the developer integrated their app with Azure
AD for identity and access management.

# Benefits of integrating with Azure AD

Our developer intends to save time and increase their app security by
using an existing identity solution rather than creating one themselves.

There are several other benefits that make using Azure AD and the
identity platform a good choice for this developer:

-   End users will be able to reuse preexisting credentials from work or
    social accounts to log in

-   Azure provides the necessary infrastructure to authenticate and
    manage data from users from multiple client companies (more on this
    below)

-   IT administrators at the client companies will be able to enforce
    organizational policies

For more on the benefits of using Azure AD, check out the [Azure AD
landing page](https://azure.microsoft.com/en-us/services/active-directory/).

# Sign in users with their existing credentials using Azure AD multi-tenancy

Our developer will sell the app they are creating to many other
companies, and they want the end users to be able to sign in using their
existing work or social account. So our developer will register their
app in the Azure portal as a [multi-tenant app](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant).

\[!Note\] This is a common scenario for IoT developers. If your
customers have their own Azure AD tenants, the multi-tenant app by
itself is sufficient. If you have customers that do not have Azure AD
tenants you can leverage Azure AD's B2B guest model outlined in scenario
two below.

With a multi-tenant app, users can authenticate using any Azure AD
directory or personal accounts. In addition, the admin in charge of each
tenant can set their own authentication and access policies for the use
of the app in their own tenant. Finally, the identity platform
identifies the tenant that each user belongs to. The developer can use
this information to restrict access to data based on tenant membership,
maintaining separation of proprietary information.

> **Runtime:**

1.  User logs in to app

2.  Azure AD determines the user's tenant and issues token with tenant
    ID

3.  App accepts the token and user gets access to tenant-specific
    resources (note that the app developer must enforce the separation
    of resources by tenant ID)

In the sections below, we'll cover the basics of registering a
multi-tenant app with Azure AD.

## Prerequisites

The developer of the app must belong to an Azure AD tenant. If they do
not have an existing tenant, they can create a [new Azure AD
tenant](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant).

In addition, the developer needs to have permission to register an app
in their Azure AD tenant. You can [check if you have sufficient
permissions](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#check-azure-ad-permissions)
in the Azure portal.

[!NOTE] The app's home tenant is often times [created
specifically for development](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-create-new-tenant#create-a-new-azure-ad-tenant) and is separate from the ISV's own
corporate tenant.

## Register the app

The first step is for the developer to [register the
app](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
inside their own Azure AD tenant. This establishes an identity for the
application itself, and allows the developer to choose whether it will
be single or multi-tenant.

When the app is registered, two objects are created in the tenant:

-   [Application object](https://docs.microsoft.com/en-us/graph/api/resources/application?view=graph-rest-1.0) - resides in the tenant where the app was
    registered (the \"home\" tenant) and serves as the template for
    common and default properties.

-   [Service principal object](https://docs.microsoft.com/en-us/graph/api/resources/serviceprincipal?view=graph-rest-beta) - defines the access policy and
    permissions for the application. A service principal will be created
    in each tenant that uses this application.

## Set up process for obtaining user consent

The next step is for the developer to ensure the app [obtains consent](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#understand-user-and-admin-consent) to
access protected resources on the user's behalf. When a user from a new
tenant signs in to the application for the first time, Azure AD asks
them to consent to the permissions requested by the application. If they
consent, then a service principal is created in the user's tenant, and
sign-in can continue.

 **Runtime:**

1.  App sends sign in request to /common on behalf of user

2.  User responds to sign in prompt and provides any required consent to
    App

3.  Azure AD creates service principal (SP) in customer's tenant

A developer can decide if permission is needed from just the user (to
access data related to them) or an admin (to allow access to the
organization's data). Another factor affecting the consent process is
the policies set on the user\'s tenant, such as if consent to add a new
app is required by an admin of the tenant. This is explained in more
detail in the [this document](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#understand-user-and-admin-consent).

## Properly direct sign-in requests

For multi-tenant apps, sign-in requests for AAD accounts should be sent
to a [common
endpoint](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common)
for all Azure AD tenants: *https://login.microsoftonline.com/common.*
When the Microsoft identity platform receives a request on the /common
endpoint, it signs the user in and in that process discovers which
tenant the user belongs to.

Guest users' sign in attempts should be directed to a tenant-specific endpoint
(i.e. the developer's tenant) https://login.microsoftonline.com/{TenantId\_or\_Name}. We provide an
example of this in the Woodgrove scenario below.

### Creating roles and permissions for users of your app

#### Azure AD App Roles

In addition to authentication, the developer will want to provide the
proper authorization within the app. Using Azure AD, this can be done
with [Role-Based Access Control](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview) (RBAC) and [Role Claims](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-enterprise-app-role-management).
When using RBAC, an administrator grants permissions to **roles**, and
not to individual users or groups.

The developer will [add roles](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps) to an app and declare them in the [app's
manifest](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-application-manifest/). When a user signs into the app, Azure AD emits a claim for
each role that the user has been granted, individually and from their
group membership. The app can use these role claims with the tenant ID
claim to perform an access check to determine whether a user is allowed
to perform an action on a specific resource associated with an Azure AD
tenant.

An app does not need any extra Active Directory permissions, other than
reading the user\'s profile, to enable app roles. Role assignment
managers can then assign these pre-defined app roles to users and manage
who has access to which resource in accordance with their organization's
needs.

#### Conditional Access

In addition to the role based access control, IT admins at companies
using the developer's app will be able to control access to the app and
the related IoT resources according to organizational policy around
specific conditions.

With [Azure AD Conditional Access](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/overview), the developer can implement automated
access control decisions for any service principal (i.e. app) in the
directory. Common signals that Conditional Access can take into account
include

-   User or group membership

-   IP location information

-   Devices marked as compliant

-   Specific applications

# Example app usage scenarios

So far we've explained the basic configurations necessary for a
developer to set up a multi-tenant app. Now, let's explore a couple
customer scenarios to explain how the authentication process will work
for the IoT app. The following two customers, Fabrikam and Woodgrove,
will sign in to our IoT developer's app in different ways. We'll go
through each scenario and discuss how Azure AD helped the developer meet
the customers' needs.

## Scenario 1: Customer with an existing Azure AD tenant

Fabrikam is a large enterprise customer of our developer and has its own
Azure AD tenant. Fabrikam would like its employees to sign into the IoT
app using their existing Azure AD work accounts. In addition, the
company's IT departments will manage access and apply organizational
polices for access to the app, the IoT devices, and data the IoT app
manages. Fabrikam's global admin will review the permissions required by
any app prior to allowing it in the tenant.

Our developer's app supports these requirements as follows:

### Signing in Fabrikam's users with their existing work accounts

Since the app has been registered as a multi-tenant app, Fabrikam users
can sign into the app with their Azure AD work credentials. The app must
send the sign in request with these credentials to the common endpoint,
*https://login.microsoftonline.com/common*. The identity platform will
discover which tenant the user is from and send a sign-in response token
which contains information on which tenant the user belongs to. The
developer can use this information to determine which resources the user
can access. For more information about using the common endpoint, see
[Update your code to send requests to /common](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant#update-your-code-to-send-requests-to-common).

### Admin consent for the app

Fabrikam's tenant administrators can set the [enterprise app settings](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-how-applications-are-added#who-has-permission-to-add-applications-to-my-azure-ad-instance) so
that administrator approval is required before a user in the tenant can
register or provide consent to a new app. This allows the administrators
to control which apps are being run in their tenant. If a user is
blocked from registering or signing in, they will see a generic error
message that says they\'re unauthorized to access the app and they
should ask their admin for help.

In addition, the admins can set up the tenant to require admin consent
for certain permissions (e.g. the ability to write data to your Azure AD
tenant) regardless of whether regular users can register or consent to
new apps.

> [!NOTE]
> The [new admin consent workflow (in Public Preview)](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-admin-consent-workflow) gives tenant admins a secure way to grant access to applications that require admin approval while allowing them to disable their end-user’s ability to consent. \
Benefits of the admin consent workflow include the following: \
• Helps admins manage access to organizational data and regulate the enterprise apps within their organization.\
• Gives administrators increased visibility into what app users need access to. \
The new workflow gives all end-users the ability to request access to apps that they were previously unable to access because of a lack of permissions. When a user tries to access an app but is unable to provide consent, they can send a request for admin approval. The request is sent via email to admins who have been designated as reviewers. A reviewer acts on the request, and the user is notified of the action.


## Scenario 2: Customer without Azure AD tenant

Woodgrove is another company using our developer's app. Woodgrove does
not have an Azure AD tenant and would like its employees to log in with
social IDs such Facebook or Google. To enable this the developer and his
IT Admins can leverage [Azure AD B2B (business-to-business)
collaboration](https://docs.microsoft.com/en-us/azure/active-directory/b2b/what-is-b2b)
by adding Woodgrove's users as **guests in the app's home tenant**.

>[!NOTE] It is possible you may not know which external users need
access to your app, in which case you can develop a self-service sign-up
app that does not require an invitation to your app tenant.

Isolation of Woodgrove's users and resources from other customers and
the developer's tenant must be maintained. In addition, the developer's
company would like to ensure all access to the app can be audited and
reported on. Leveraging Azure AD B2B will fulfill the business
requirements as follows.

### Isolation

Our developer can [create a security
group](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context)
in their home tenant that will act as the isolation boundary for
Woodgrove's users and their IoT devices. Woodgrove can designate one of
its users as the owner of the security group so that that user can
control security group membership. Guests will be subject to the
tenant-level policies set in the developer's home tenant, as well as
security group-level policies put in place by the group owner. The
developer's app will factor in guest users' group memberships when
making access control decisions.

**Runtime:**

1.  User logs in to app targeting the tenanted endpoint

2.  Azure AD issues a token with tenant ID and group membership claims

3.  App accepts the token and user gets access to security group-specific resources

### Adding guest users to a tenant

The developer can enable guests to log in with existing social account
using an [invitation and redemption process](https://docs.microsoft.com/en-us/azure/active-directory/b2b/redemption-experience) that involves sends either a
direct link or an email to the guest. The process can be customized
using [Azure AD business-to-business
APIs](https://docs.microsoft.com/en-us/azure/active-directory/b2b/customize-invitation-api).

There are several options for authenticating guests who wish to use non- Azure AD accounts with your app:

-   [Direct federation](https://docs.microsoft.com/en-us/azure/active-directory/b2b/direct-federation). Direct federation works with identity systems that support the SAML or WS-Fed standards.

-   [Google federation](https://docs.microsoft.com/en-us/azure/active-directory/b2b/google-federation). Gmail users are authenticated using Google federation.

-   [One Time Passcode (OTP) authentication](https://docs.microsoft.com/en-us/azure/active-directory/b2b/one-time-passcode). Provides a temporary code to authenticate users who cannot be authenticated through other means.

To enable guest sign ins, the developer must ensure that guest users'
sign in attempts are directed to the tenant-specific endpoint (i.e. the
developer's tenant, see the [FAQ](https://docs.microsoft.com/en-us/azure/active-directory/b2b/faq#what-applications-and-services-support-azure-b2b-guest-users))
https://login.microsoftonline.com/{TenantId\_or\_Name}. This may require you implement a separate sign-in page specifically for guests. 

# Next Steps 

Our developer may want to provide an e-commerce site for customers to
purchase licenses for their app. This e-commerce site is separate from
the IoT app itself. A sample workload describing how to build an
[e-commerce front-end](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/ecommerce-scenario) is available on the Azure Reference Architecture
Center.

To increase the discoverability and adoption of your IoT app, the
developer can publish the app to the [Azure AD App
gallery](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-app-gallery-listing).
The Azure AD application gallery is in the Azure Marketplace app store,
where all application connectors are published for single sign-on and
user provisioning. IT administrators can add connectors from the app
gallery, and then configure and use the connectors for single sign-on
and provisioning for additional convenience for the end user of the app.

# Conclusion

Using the information in this article you learned to secure your IoT
app, providing users with and without access to existing Azure AD tenant
accounts with the level of access they need. For more guidance, [Azure
IoT reference architecture articles](https://microsoft-my.sharepoint-df.com/personal/nichola_microsoft_com/Documents/Documents/docs.microsoft.com/en-us/azure/architecture/reference-architectures/iot/) are available in the Azure
Architecture Center.

Additional reading and resources:

-   [Microsoft identity platform best practices and recommendations](https://docs.microsoft.com/en-us/azure/active-directory/develop/identity-platform-integration-checklist)

-   [Azure AD developer guidance](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)

-   [Permissions and consent](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent)

-   [Signing up and signing in with Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-add-branding-in-azure-ad-apps#signing-up-and-signing-in-with-azure-ad)

-   [Self-service group management](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-manage-groups?context=azure/active-directory/users-groups-roles/context/ugr-context)​

-   [Restrict your app to a set of users](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users)

-   [Microsoft identity platform (v2.0) Authentication flows and app scenarios](https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-flows-app-scenarios)
