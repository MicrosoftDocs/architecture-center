---
title: Cache access tokens in a multitenant app
description: Learn how to implement a custom token cache that derives from the Azure AD Authentication Library TokenCache class suitable for web apps.
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
pnp.series.prev: web-api
pnp.series.next: adfs
products:
  - azure-active-directory
  - azure-app-service-web
---

# Cache access tokens

[:::image type="icon" source="../_images/github.png" border="false"::: Sample code][sample application]

It's relatively expensive to get an OAuth access token, because it requires an HTTP request to the token endpoint. Therefore, it's good to cache tokens whenever possible. The [Microsoft Authentication Library for .NET (MSAL.NET)][MSAL] (MSAL) caches tokens obtained from Azure AD, including refresh tokens.

Some implementations include MSAL are in-memory cache and distributed cache. This option is set in the ConfigureServices method of the Startup class of the web application. To acquire a token for the downstream API, you'll need to `.EnableTokenAcquisitionToCallDownstreamApi()`.

The Surveys app uses distributed token cache that stores data in the backing store. The app uses a Redis cache as the backing store. Every server instance in a server farm reads/writes to the same cache, and this approach scales to many users.

For a single-instance web server, you could use the ASP.NET Core [in-memory cache][in-memory-cache]. (This is also a good option for running the app locally during development.)

```csharp
services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApp(
    options =>
    {
        Configuration.Bind("AzureAd", options);
        options.Events = new SurveyAuthenticationEvents(loggerFactory);
        options.SignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.Events.OnTokenValidated += options.Events.TokenValidated;
    })
    .EnableTokenAcquisitionToCallDownstreamApi()
    .AddDownstreamWebApi(configOptions.SurveyApi.Name, Configuration.GetSection("SurveyApi"))
    .AddDistributedTokenCaches();

    services.AddStackExchangeRedisCache(options =>
    {
        options.Configuration = configOptions.Redis.Configuration;
        options.InstanceName = "TokenCache";
    });
}
```

The configuration for SurveyApi is specified in appsettings.json.

```json
  "SurveyApi": {
    "BaseUrl": "https://localhost:44301",
    "Scopes": "https://test.onmicrosoft.com/surveys.webapi/surveys.access",
    "Name": "SurveyApi"
  },
```

## Encrypting cached tokens

Tokens are sensitive data, because they grant access to a user's resources. (Moreover, unlike a user's password, you can't just store a hash of the token.) Therefore, it's critical to protect tokens from being compromised.

The Redis-backed cache is protected by a password, but if someone obtains the password, they could get all of the cached access tokens. The MSAL token cache is encrypted.

## Acquire the token

The Survey application calls the downstream web API from the page constructor.

```csharp
public class SurveyService : ISurveyService
{
    private string _serviceName;
    private readonly IDownstreamWebApi _downstreamWebApi;

    public SurveyService(HttpClientService factory, IDownstreamWebApi downstreamWebApi, IOptions<ConfigurationOptions> configOptions)
    {
        _serviceName = configOptions.Value.SurveyApi.Name;
        _downstreamWebApi = downstreamWebApi;
    }

    public async Task<SurveyDTO> GetSurveyAsync(int id)
    {
        return await _downstreamWebApi.CallWebApiForUserAsync<SurveyDTO>(_serviceName,
            options =>
            {
                options.HttpMethod = HttpMethod.Get;
                options.RelativePath = $"surveys/{id}";
            });
    }
}
```
Another way is to inject an `ITokenAcquisition` service in the controller. For more information, see [Acquire and cache tokens using the Microsoft Authentication Library (MSAL)](/azure/active-directory/develop/scenario-web-app-call-api-acquire-token?tabs=aspnetcore)

[**Next**][client-certificate]

## Next steps

- [Token cache serialization in MSAL.NET](/azure/active-directory/develop/msal-net-token-cache-serialization)
- [Acquire and cache tokens using the Microsoft Authentication Library (MSAL)](/azure/active-directory/develop/msal-acquire-cache-tokens)

## Related resources

- [Identity management in multitenant applications](/azure/architecture/multitenant-identity)
- [Secure a backend web API for multitenant applications](/azure/architecture/multitenant-identity/web-api)

<!-- links -->

[MSAL]: /azure/active-directory/develop/msal-overview
[client-certificate]: ./client-certificate.md
[data-protection]: /aspnet/core/security/data-protection
[distributed-cache]: /aspnet/core/performance/caching/distributed
[key-management]: /aspnet/core/security/data-protection/configuration/default-settings
[in-memory-cache]: /aspnet/core/performance/caching/memory
[tokencache-class]: /dotnet/api/microsoft.identitymodel.clients.activedirectory.tokencache?view=azure-dotnet
[x509-cert-encryption]: /aspnet/core/security/data-protection/implementation/key-encryption-at-rest#x509-certificate
[sample application]: https://github.com/mspnp/multitenant-saas-guidance
