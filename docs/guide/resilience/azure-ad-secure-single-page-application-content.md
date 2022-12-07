When developing cloud-native distributed systems, securing such systems can introduce a new layer of complexity.

On-premise systems rely on the security boundaries that the internal network provides, and they use the directory services for user security. They can run for many years within this secure environment without problems. Moving to the cloud can present new security risks. This article describes tools that you can use to mitigate these risks.

One such tool is access control. Access control identifies users and regulates what they can do when interacting with an application.

There are two parts to access control:

- **Authentication** identifies the user.
- **Authorization** determines what the user can do in the application.

OAuth, an open framework, helps address these challenges and provides a protocol for developers to use when building their systems. OAuth 2.0 is the current standard.

OAuth 2.0 provides secure delegated access. By issuing access tokens, you can authorize third-party access to your protected resources without providing credentials.

Azure Active Directory (Azure AD) is Microsoft's built-in solution for managing identities in the cloud. It integrates with on-premise systems so that users have a seamless experience when accessing protect services in the cloud.

This guide shows you how to use Azure AD and OAuth 2.0 to secure a single-page application.

## OAuth flows

OAuth flows cover many use cases, all backed by Azure AD Services. Developers use these flows to build a secure application, so that:

- Users can securely access client systems.
- Guest users can participate through business-to-business transactions.
- Users can reach out to end consumers through Azure Business to Consumers (Azure B2C).

:::image type="content" source="media/azure-ad-secure-single-page-application/azure-ad-oauth-2-flow-inline.png" alt-text="Diagram that shows the secure OAuth 2 flow between a native app and a web API." lightbox="media/azure-ad-secure-single-page-application/azure-ad-oauth-2-flow-expanded.png" :::

There are two OAuth flows, implicit grant and authorization code. Implicit grant is the most common, but we recommend using the [authorization code flow](/azure/active-directory/develop/v2-oauth2-auth-code-flow).

## Register your application in Azure

Register a service principal for the UI and API using Azure AD Directory in the Azure portal.

1. Log in to the [Azure portal](https://ms.portal.azure.com/), and then search for **App registrations**.

2. Select **New registration**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/app-registration-new-registration.png" alt-text="Screenshot that shows the App registration page with New registration selected.":::

3. To register a new application, you need:

    - The display name for the application.
    - The supported account type.
    - The application type: Web, SPA, or public client/native (mobile and desktop).
    - The redirect URI. When the user is authenticated, Azure AD redirects the result to the client.
        - An example for local development is http://localhost:4200.
        - An example for production is 'https://portal.contoso.com'.

    :::image type="content" source="media/azure-ad-secure-single-page-application/register-an-application-page.png" alt-text="Screenshot that shows the Register an application window.":::

4. Select **Register**.

5. Once the registration is complete, select **Overview**, and then select your application name next to **Managed application in local directory**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/managed-application-in-local-directory.png" alt-text="Screenshot that shows the Overview page with the application name selected.":::

6. Select **Properties**, switch **User assignment required** to **Yes** to set the access permissions for the application, and then select **Save**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/properties-user-assignment-required.png" alt-text="Screenshot that shows the Properties page with User assignment required turned on.":::

7. Select **Users and groups**, and then add existing or new users and security groups.

    :::image type="content" source="media/azure-ad-secure-single-page-application/add-users-and-groups.png" alt-text="Screenshot that shows the Users and groups page with Add user/group selected.":::

8. Your users can access the application through [My Apps](https://myapplications.microsoft.com/).

## Set up configuration details in the client application

After you create and configure the app registration in Azure, you can set up the configuration details in the client application. For a single-page framework like Angular, Microsoft has developed the **@Azure/msal-angular** library to help you integrate Azure AD in your client application.

1. Install an [@Azure/msal-angular](/azure/active-directory/develop/reference-v2-libraries#single-page-application-spa) library.

2. Configure the library.

    - The `protectedResourceMap` contains a list of protected resources and their scopes in an array: [[protected resource], [scopes for resource]].
    - The `clientID` and `authority`, which is the tenant ID, are supplied to the configuration object.
    - For protected HTTP requests, the client inserts a new header property called Authorization. It contains the bearer token for the authenticated user. The bearer token gives the downstream OAuth 2.0 service a secure point of entry. It can include metadata for the service when authorizing the request.

```typescript
export const protectedResourceMap: [string, string[]][]] = [
    ['https://graph.microsoft.com/v1.0/me', ['user.read']],
    ['https://localhost:5001/api/weatherforecast', ['api://ae05da8f-07d0-4ae6-aef1-18a6af68e5dd/access_as_user']]
];

function MSALConfigFactory(): Configuration {
    return {
        auth: {
            clientId: 'eba23c0b-1e86-4f68-b1d2-9c54d96083de',
            authority: 'https://login.microsoftonline.com/1c302616-bc6a-45a6-9c07-838c89d55003',
            redirectUri: 'http://localhost:4200',
            validateAuthority: true,
            postLogoutRedirectUri: 'http://localhost:4200',
            navigateToLoginRequestUrl: true
        },
        cache: {
            cacheLocation: 'sessionStorage',

            storeAuthStateInCookie: false //set to false, not ie 11
        }
    };
}
```

For more information on configuring an Angular library, see [Tutorial: Sign in users and call the Microsoft Graph API from an Angular single-page application (SPA) using auth code flow](/azure/active-directory/develop/tutorial-v2-angular-auth-code).

## Test the application authentication

Test the authentication process by having a user *with* access, and a user *without* access attempt to log in to the client.

The user logs in to the application and is redirected to their Azure AD tenant.

- If the user is valid, they're authenticated and logged in.
- If the user isn't valid, the application returns an error.

## Consume a protected resource or resource server

To consume a protected resource, create another app registration. After the app registration is complete, the API changes the bearer token to allow access.

### Expose the API

1. Create another app registration in Azure.

2. Select **Expose an API**, and then select **Add a scope**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/expose-an-api-add-scope.png" alt-text="Screenshot that shows the Expose an API page with Add a scope selected.":::

3. Enter the **Application ID URI**, and then select **Save and continue**. This permission is used by the API to validate the request.

    :::image type="content" source="media/azure-ad-secure-single-page-application/add-a-scope-application-id-uri.png" alt-text="Screenshot that shows the Add a scope window with an Application ID URI entered and Save and continue selected.":::

4. Configure the scope name and consent information. If you select **Admins only**, only Admins can grant consent for the directory.

    :::image type="content" source="media/azure-ad-secure-single-page-application/add-a-scope-configuration-window.png" alt-text="Screenshot that shows the Add a scope configuration window with example values entered.":::

### Add the API to the App registration

Now that you've defined your permissions and exposed the API, you need to add the API to the app registration for the client.

1. In your app registration, select **API permissions**, and then **Add a permission**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/api-permissions-add-permission.png" alt-text="Screenshot that shows the API permissions page with Add a permission selected.":::

2. Select **My APIs**, and then select the API registration you created.

    :::image type="content" source="media/azure-ad-secure-single-page-application/api-permissions-select-my-apis.png" alt-text="Screenshot that shows the My APIs tab with the API selected.":::

3. Select the scope you created to expose the API permission, and then select **Add permissions**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/select-scope-add-permissions.png" alt-text="Screenshot that shows the selected scope with the Add permissions button selected.":::

Now the API is added to the application. Since you might need to grant consent again for access to the API, consider granting admin consent so that users don't have to reconsent.

:::image type="content" source="media/azure-ad-secure-single-page-application/api-added-to-application.png" alt-text="Screenshot that shows the API added to the application.":::

### Add the API to the protected resource map

Now that the configuration in the Azure portal is complete, the UI client can consume the resource. Add the API to the protected resource map to make sure that the UI attaches the correct bearer token for the API request.

```typescript
export const protectedResourceMap: [string, string[]][] = [
    ['https://graph.microsoft.com/v1.0/me', ['user.read']],
    ['https://localhost:5001/api/weatherforecast', ['api://eba23c0b-1e86-4f68-b1d2-9c54d96083de/access_as_user']]
];
```

When your client application attempts to access the resource, the MSAL Client Library authenticates to Azure AD through a hidden iframe, and then returns a bearer token for the resource. The bearer token is only added for requests that match the endpoint, in this case `https://localhost:5001/api/weatherforecast`.

If the API you configured with the relevant app registrations receives a bearer token with an invalid application ID URI, it rejects the request and returns a 401 unauthorized message.

In the following example, the backend service is written in .NET Core. The example shows the configuration properties for the API. The `ClientId` has the application ID URI in the form of `api://{clientId}`.

```dotnetcli
"AzureAD": {
  "Instance": "https://login.microsoftonline.com/",
  "Domain": "yourName.onmicrosoft.com",
  "TenantId": "1c302616-bc6a-45a6-9c07-838c89d55003",
  "ClientId": "api://ae05da8f-07d0-4ae6-aef1-18a6af68e5dd"
},
```

Within the startup class of the .NET Core API, the Authentication scheme and options are added to the configure services method.

```dotnetcli
services.Addauthentication(AzureADDefaults.BearerAuthenticationScheme).AddAzureADBearer(options => Configuration.Bind("AzureAD",
  options));
```

When the client calls the API, the bearer token gets added to the request.

:::image type="content" source="media/azure-ad-secure-single-page-application/bearer-token-added-to-request.png" alt-text="Screenshot that shows the bearer token added to the request.":::

You can navigate to jwt.ms and paste the bearer token into a human-readable format.

:::image type="content" source="media/azure-ad-secure-single-page-application/bearer-token-human-readable-format.png" alt-text="Screenshot that shows the bearer token in a human-readable format.":::

You can see that the API URI is inside the `aud` property. This property identifies the intended recipient of the token, which is your API. If your API is not the intended recipient, it automatically rejects the request with a 401 HTTP response.

The `scp` property contains the set of scopes exposed by your application. If invalid scopes are added through the client, Azure AD returns an error requesting further authorization for scope.

:::image type="content" source="media/azure-ad-secure-single-page-application/jwtms-properties.png" alt-text="Screenshot that shows the token properties in the jwt.ms file.":::

### Use the application manifest to further define authorization

Further authorization practices are implemented by using the application manifest for the API app registration. Since you have explicitly defined users, you can add further levels of authorization and only allow members of a specific security group to access more sensitive resources.

1. In your app registration, select **Manifest**.

    :::image type="content" source="media/azure-ad-secure-single-page-application/application-manifest-configuration.png" alt-text="Screenshot that shows the manifest page.":::

2. Edit the key value pairs of the JSON object as needed.

In general, it's best to only issue `SecurityGroup`. If you use `All`, security groups, Azure AD roles, and distribution groups are emitted. The token has a set limit of 200, and if that limit is reached, an overage claim is added. The claim points to the Graph endpoint to retrieve the list of groups for the user.

After configuration, the jwt token has a new property, `groups`, that contains the unique object IDs that can be used to enforce authorization.

The API can be configured with a policy that looks for a required claim and value for role-based authorization through the policy handler.

```typescript
public void ConfigureServices(IServiceCollection services)
{

    services.AddAuthentication(AzureADDefaults.BearerAuthenticationScheme).AddAzureADBearer(options => Configuration.Bind("AzureAD",
      options));

    services.AddAuthorization(options =>
    {

        options.AddPolicy("DensuAegisReportsAdmin", policyBuilder =>
        {
            policyBuilder.RequireClaim("groups", "ebde25e7-d254-474e-ae33-cd491aa98ebf"); //This would be an environment variable
        });
});

    JWTSecurityTokenHandler.DefaultMapInboundClaims = false;
    services.AddCors();

    services.AddControllers();
}
```

The controller for the API can have the relevant attributions added. These attributes offer more security and help confirm the authenticated persons are authorized to access the protected resource.

```typescript
[Route("admin")]
[Authorize("DensuAegisReportsAdmin")]
public IActionResult GetForcastsForAdmin()
{
    var user = User.Claims;

    var groups = User.Claims.Where(c => c.Type == "groups").Select(c => c.Value).ToList();
    var userName = UserClaims.Where(c => c.Type == "unique_name").Select(c => c.Value).FirstOrDefault();
    // SecurityGroup = groups
    var rng = new Random();
    var forecasts = Enumerable.Range(1, 5).Select(index => new WeatherForecast
    {
        Date = DateTime.Now.AddDays(index),
        TemperatureC = rng.Next(-20, 55),
        Summary = Summaries[rng.Next(Summaries.Length)],

    })
    .ToArray();

    return Ok(new
    {
        User = userName
        ,
        SecurityGroup = groups
        ,
        Forcasts = forecasts
    });
}
```

More roles can be created with the application manifest that are unique to the app registration. Then, more groups can be created within the context of the application.

:::image type="content" source="media/azure-ad-secure-single-page-application/approle-example.png" alt-text="Screenshot that shows an example of an appRole added to the manifest.":::

For example, you can create a custom role called AppAdmin that is unique to the application registration. Using the enterprise application build, you can assign users or security groups to that role.

When you call the protected resource after the configuration change, the bearer token has the `roles` property inside the bearer token.

:::image type="content" source="media/azure-ad-secure-single-page-application/decoded-token-with-role-property.png" alt-text="Screenshot that shows the role property in the bearer token.":::

The API is configured using the policy builder under **Configure Services**.

```typescript
            // Adding authorization policies that enforce authorization using Azure AD roles.
            services.AddAuthorization(options =>
            {
                options.AddPolicy(AuthorizationPolicies.AssignmentToAppAdminRoleRequired, policy =>
                  policy.RequireRole(AppRole.AppAdmin));
            });
```

The protected route uses the authorization policy to make sure that the authenticated user is in the relevant role before authorizing the request.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Lavan Nallainathan](https://www.linkedin.com/in/lavan-nallainathan-8771b05b/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Integrate on-premises AD domains with Azure AD](../../reference-architectures/identity/azure-ad.yml)
- [Azure Active Directory identity management and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml)
- [Deploy AD DS in an Azure virtual network](../../reference-architectures/identity/adds-extend-domain.yml)

## Related resources

- [OAuth 2.0 and OpenID Connect protocols on the Microsoft identity platform](/azure/active-directory/develop/active-directory-v2-protocols)
- [Microsoft identity platform and implicit grant flow](/azure/active-directory/develop/v2-oauth2-implicit-grant-flow)
- [Microsoft identity platform and OAuth 2.0 authorization code flow](/azure/active-directory/develop/v2-oauth2-auth-code-flow)
