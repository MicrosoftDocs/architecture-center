---
title: Secure a backend web API in a multitenant app
description: Learn how to secure a backend web API for multitenant applications by using the Tailspin Surveys app, which has a backend API to manage operations on surveys.
author: EdPrice-MSFT
ms.author: pnp
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
pnp.series.prev: authorize
pnp.series.next: token-cache
products:
  - azure-active-directory
  - azure-app-service-web
---

# Secure a backend web API for multitenant applications

[:::image type="icon" source="../_images/github.png" border="false"::: Sample code][sample application]

The [Tailspin Surveys][surveys] application uses a backend web API to manage CRUD operations on surveys. For example, when a user clicks "My Surveys", the web application sends an HTTP request to the web API:

```http
GET /users/{userId}/surveys
```

The web API returns a JSON object:

```http
{
  "Published":[],
  "Own":[
    {"Id":1,"Title":"Survey 1"},
    {"Id":3,"Title":"Survey 3"},
    ],
  "Contribute": [{"Id":8,"Title":"My survey"}]
}
```

The web API does not allow anonymous requests, so the web app must authenticate itself using OAuth 2 bearer tokens.

> [!NOTE]
> This is a server-to-server scenario. The application does not make any AJAX calls to the API from the browser client.

There are two main approaches you can take:

* Delegated user identity. The web application authenticates with the user's identity.
* Application identity. The web application authenticates with its client ID, using OAuth 2 client credential flow.

The Tailspin application implements delegated user identity. Here are the main differences:

**Delegated user identity:**

* The bearer token sent to the web API contains the user identity.
* The web API makes authorization decisions based on the user identity.
* The web application needs to handle 403 (Forbidden) errors from the web API, if the user is not authorized to perform an action.
* Typically, the web application still makes some authorization decisions that affect UI, such as showing or hiding UI elements).
* The web API can potentially be used by untrusted clients, such as a JavaScript application or a native client application.

**Application identity:**

* The web API does not get information about the user.
* The web API cannot perform any authorization based on the user identity. All authorization decisions are made by the web application.
* The web API cannot be used by an untrusted client (JavaScript or native client application).
* This approach may be somewhat simpler to implement, because there is no authorization logic in the Web API.

In either approach, the web application must get an access token, which is the credential needed to call the web API.

* For delegated user identity, the token has to come from an identity provider (IDP), such as Azure Active Directory, which can issue a token on behalf of the user.
* For client credentials, an application might get the token from the IDP or host its own token server. (But don't write a token server from scratch; use a well-tested framework like [IdentityServer4].) If you authenticate with Azure AD, it's strongly recommended to get the access token from Azure AD, even with client credential flow.

The rest of this article assumes the application is authenticating with Azure AD.

<img src="./images/access-token.png" alt="Getting the access token" aria-describedby="description-1">
<p id="description-1" class="visually-hidden">A diagram that shows the web application requesting an access token from Azure AD and sending the token to the web API.</p>

## Register the web API in Azure AD

In order for Azure AD to issue a bearer token for the web API, you need to configure some things in Azure AD.

1. Register the web API in Azure AD.

2. Add the client ID of the web app to the web API application manifest, in the `knownClientApplications` property. See the [GitHub readme](https://github.com/mspnp/multitenant-saas-guidance/blob/master/get-started.md#update-the-application-manifests) for more information.

3. Give the web application permission to call the web API. In the Azure portal, you can set two types of permissions: "Application Permissions" for application identity (client credential flow), or "Delegated Permissions" for delegated user identity.

    <img src="./images/delegated-permissions.png" alt="Delegated permissions" aria-describedby="description-2">
    <p id="description-2" class="visually-hidden">A screenshot of the Azure portal that shows the application permissions and delegated permissions.</p>

## Getting an access token

Before calling the web API, the web application gets an access token from Azure AD. In a .NET application, use the [Microsoft Authentication Library for .NET (MSAL.NET)][MSAL]. Add `.EnableTokenAcquisitionToCallDownstreamApi()` in Startup.cs of the application.

After acquiring a token, MSAL caches it. So, you'll also need to choose a token cache implementation, which is included in MSAL. This example uses distributed cache. For details, see See [Token caching][token-cache].

## Using the access token to call the web API

Once you have the token, call a downstream web API. That process is described in [Call a downstream web API with the helper class](/azure/active-directory/develop/scenario-web-app-call-api-call-api?tabs=aspnetcore#option-2-call-a-downstream-web-api-with-the-helper-class).

## Authenticating in the web API

The web API has to authenticate the bearer token. In ASP.NET Core, you can use the [Microsoft.AspNet.Authentication.JwtBearer][JwtBearer] package. This package provides middleware that enables the application to receive OpenID Connect bearer tokens.

Register the middleware in your web API `Startup` class.

```csharp
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApi(jtwOptions =>
        {
            jtwOptions.Events = new SurveysJwtBearerEvents(loggerFactory.CreateLogger<SurveysJwtBearerEvents>()); 
        },
        msIdentityOptions => {
            Configuration.GetSection("AzureAd").Bind(msIdentityOptions);
        });
```

**Events** is a class that derives from **JwtBearerEvents**.

### Issuer validation

Validate the token issuer in the **JwtBearerEvents.TokenValidated** event. The issuer is sent in the "iss" claim.

In the Surveys application, the web API doesn't handle [tenant sign-up]. Therefore, it just checks if the issuer is already in the application database. If not, it throws an exception, which causes authentication to fail.

```csharp
public override async Task TokenValidated(TokenValidatedContext context)
{
    var principal = context.Ticket.Principal;
    var tenantManager = context.HttpContext.RequestServices.GetService<TenantManager>();
    var userManager = context.HttpContext.RequestServices.GetService<UserManager>();
    var issuerValue = principal.GetIssuerValue();
    var tenant = await tenantManager.FindByIssuerValueAsync(issuerValue);

    if (tenant == null)
    {
        // The caller was not from a trusted issuer. Throw to block the authentication flow.
        throw new SecurityTokenValidationException();
    }

    var identity = principal.Identities.First();

    // Add new claim for survey_userid
    var registeredUser = await userManager.FindByObjectIdentifier(principal.GetObjectIdentifierValue());
    identity.AddClaim(new Claim(SurveyClaimTypes.SurveyUserIdClaimType, registeredUser.Id.ToString()));
    identity.AddClaim(new Claim(SurveyClaimTypes.SurveyTenantIdClaimType, registeredUser.TenantId.ToString()));

    // Add new claim for Email
    var email = principal.FindFirst(ClaimTypes.Upn)?.Value;
    if (!string.IsNullOrWhiteSpace(email))
    {
        identity.AddClaim(new Claim(ClaimTypes.Email, email));
    }
}
```

As this example shows, you can also use the **TokenValidated** event to modify the claims. Remember that the claims come directly from Azure AD. If the web application modifies the claims that it gets, those changes won't show up in the bearer token that the web API receives. For more information, see [Claims transformations][claims-transformation].

## Authorization

For a general discussion of authorization, see [Role-based and resource-based authorization][Authorization].

The JwtBearer middleware handles the authorization responses. For example, to restrict a controller action to authenticated users, use the **[Authorize]** attribute and specify **JwtBearerDefaults.AuthenticationScheme** as the authentication scheme:

```csharp
[Authorize(ActiveAuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
```

This returns a 401 status code if the user is not authenticated.

To restrict a controller action by authorization policy, specify the policy name in the **[Authorize]** attribute:

```csharp
[Authorize(Policy = PolicyNames.RequireSurveyCreator)]
```

This returns a 401 status code if the user is not authenticated, and 403 if the user is authenticated but not authorized. Register the policy on startup:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddAuthorization(options =>
    {
        options.AddPolicy(PolicyNames.RequireSurveyCreator,
            policy =>
            {
                policy.AddRequirements(new SurveyCreatorRequirement());
                policy.RequireAuthenticatedUser(); // Adds DenyAnonymousAuthorizationRequirement
                policy.AddAuthenticationSchemes(JwtBearerDefaults.AuthenticationScheme);
            });
        options.AddPolicy(PolicyNames.RequireSurveyAdmin,
            policy =>
            {
                policy.AddRequirements(new SurveyAdminRequirement());
                policy.RequireAuthenticatedUser(); // Adds DenyAnonymousAuthorizationRequirement
                policy.AddAuthenticationSchemes(JwtBearerDefaults.AuthenticationScheme);
            });
    });

    // ...
}
```

## Protecting application secrets

It's common to have application settings that are sensitive and must be protected, such as:

* Database connection strings
* Passwords
* Cryptographic keys

As a security best practice, you should never store these secrets in source control. It's too easy for them to leak &mdash; even if your source code repository is private. And it's not just about keeping secrets from the general public. On larger projects, you might want to restrict which developers and operators can access the production secrets. (Settings for test or development environments are different.)

A more secure option is to store these secrets in [Azure Key Vault][KeyVault]. Key Vault is a cloud-hosted service for managing cryptographic keys and other secrets. This article shows how to use Key Vault to store configuration settings for your app.

In the [Tailspin Surveys][surveys] application, the following settings are secret:

* The database connection string.
* The Redis connection string.
* The client secret for the web application.

The Surveys application loads configuration settings from the following places:

* The appsettings.json file
* The [user secrets store][user-secrets] (development environment only; for testing)
* The hosting environment (app settings in Azure web apps)
* Key Vault (when enabled)

Each of these overrides the previous one, so any settings stored in Key Vault take precedence.

> [!NOTE]
> By default, the Key Vault configuration provider is disabled. It's not needed for running the application locally. You would enable it in a production deployment.

At startup, the application reads settings from every registered configuration provider, and uses them to populate a strongly typed options object. For more information, see [Using Options and configuration objects][options].

[**Next**][token-cache]

<!-- links -->

[Authorization]: ./authorize.md
[MSAL]: /azure/active-directory/develop/msal-overview
[claims-transformation]: ./claims.md#claims-transformations
[IdentityServer4]: https://github.com/IdentityServer/IdentityServer4
[JwtBearer]: https://www.nuget.org/packages/Microsoft.AspNet.Authentication.JwtBearer
[KeyVault]: https://azure.microsoft.com/services/key-vault
[options]: /aspnet/core/fundamentals/configuration/options
[tenant sign-up]: ./signup.md
[Token caching]: ./token-cache.md
[sample application]: https://github.com/mspnp/multitenant-saas-guidance
[surveys]: ./tailspin.md
[token-cache]: ./token-cache.md
[user-secrets]: /aspnet/core/security/app-secrets
