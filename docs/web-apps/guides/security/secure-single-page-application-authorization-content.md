This guide shows how to use Azure API Management to implement a stateless architecture, for a JavaScript single-page application, that doesn't store tokens in the browser session. Doing so helps to protect access tokens from cross-site scripting (XSS) attacks and keep malicious code from running in the browser.

This architecture uses [API Management](https://azure.microsoft.com/products/api-management) to:

- Implement a [Backends for Frontends](/azure/architecture/patterns/backends-for-frontends) pattern that gets an OAuth2 access token from Azure Active Directory (Azure AD).
- Use Advanced Encryption Standard [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) to encrypt and decrypt the access token.
- Store the token in an `HttpOnly` cookie.
- Proxy all API calls that require authorization.

Because the backend handles token acquisition, no other code or library, like [MSAL.js](https://github.com/AzureAD/microsoft-authentication-library-for-js), is required in the single-page application. When you use this design, no tokens are stored in the browser session or local storage. Encrypting and storing the access token in an `HttpOnly` cookie helps to protect it from [XSS](https://owasp.org/www-community/attacks/xss/) attacks. Scoping it to the API domain and setting `SameSite` to `Strict` ensures that the cookie is automatically sent with all proxied API first-party requests.

## Architecture

![Diagram that shows an architecture that doesn't store tokens in the browser.](../_images/no-token.png)

*Download a [Visio file](https://arch-center.azureedge.net/no-token-in-the-browser.vsdx) of this architecture.*

### Workflow

1. A user selects **Sign in** in the single-page application.
2. The single-page application invokes Authorization Code flow via a redirect to the Azure AD authorization endpoint.
3. Users authenticate themselves.
4. An Authorization Code flow response with an authorization code is redirected to the API Management callback endpoint.
5. The API Management policy exchanges the authorization code for an access token by calling the Azure AD token endpoint.
6. The Azure API Management policy redirects to the application and places the encrypted access token in an `HttpOnly` cookie.
7. The user invokes an external API call from the application via an API Management proxied endpoint.
8. The API Management policy receives the API request, decrypts the cookie, and makes a downstream API call, adding the access token as an `Authorization` header.

## Components

- [Azure AD](https://azure.microsoft.com/services/active-directory) provides identity services, single sign-on, and multifactor authentication across Azure workloads.
- [API Management](https://azure.microsoft.com/services/api-management/) is a hybrid multicloud management platform for APIs across all environments. API Management creates consistent, modern API gateways for existing backend services.
- [Azure Static Web Apps](https://azure.microsoft.com/products/app-service/static) is a service that automatically builds and deploys full-stack web apps to Azure from a code repository. Deployments are triggered by changes made to application source code in GitHub or in Azure DevOps repositories.

## Scenario details

Single-page applications are written in JavaScript and run in the context of a client-side browser. In this implementation, users can access any code running in the browser. Malicious code running in the browser or an XSS attack can also access data. Data that's stored in the browser session or local storage can be accessed, so sensitive data, like access tokens, can be used to impersonate the user.

The architecture described here increases the security of applications by moving the token acquisition and storage to the backend, and by using an encrypted `HttpOnly` cookie to store the access token. Access tokens don't need to be stored in the browser session or local storage, and they can't be accessed by malicious code that's running in the browser.

In this architecture, API Management policies handle the acquisition of the access token and the encryption and decryption of the cookie. *Policies* are collections of statements that are run sequentially on the request or response of an API and that are made up of XML elements and C# scripts.

Storing the cooking in an `HttpOnly` cookie helps to protect the token from XSS attacks and to ensure that it can't be accessed by JavaScript. Scoping the cookie to the API domain and setting `SameSite` to `Strict` ensures that the cookie is automatically sent with all proxied API first-party requests. This design enables the access token to be automatically added to the `Authorization` header of all API calls made from the single-page application by the backend.

Because this architecture uses a `SameSite=Strict` cookie, the domain of the API Management gateway must be the same as the domain of the single-page application. That's because a cookie is sent to the API Management gateway only when the API request comes from a site in the same domain. If the domains are different, the cookie isn't added to the API request, and the proxied API request remains unauthenticated.

You can configure this architecture without using custom domains for the API Management instance and static web app, but then you'd need to use `SameSite=None` for the cookie setting. This implementation results in a less secure implementation because the cookie is added to all requests to any instance of the API Management gateway. For more information, see [SameSite cookies](https://developer.mozilla.org/docs/Web/HTTP/Headers/Set-Cookie/SameSite).

To learn more about using custom domains for Azure resources, see [Custom domains with Azure Static Web Apps](/azure/static-web-apps/custom-domain) and [Configure a custom domain name for your Azure API Management instance](/azure/api-management/configure-custom-domain). For more information about configuring DNS records for custom domains, see [How to manage DNS Zones in the Azure portal](/azure/dns/dns-operations-dnszones-portal).

## Authentication flow

This process uses the [OAuth2 Authorization Code flow](/azure/active-directory/fundamentals/auth-oauth2). To obtain an access token that allows the single-page application to access the API, users must first authenticate themselves. You invoke the authentication flow by redirecting users to the Azure AD authorization endpoint. You need to configure a redirect URI in Azure AD. This redirect URI must be the API Management callback endpoint. Users are prompted to authenticate themselves by using Azure AD and are redirected back to the API Management callback endpoint with an authorization code. The API Management policy then exchanges the authorization code for an access token by calling the Azure AD token endpoint. The following diagram shows the sequence of events for this flow.

![Diagram that shows the authentication flow.](../_images/no-token-in-browser-set-token-sequence.png)

The flow contains these steps:

1. To obtain an access token to allow the single-page application to access the API, users must first authenticate themselves. Users invoke the flow by selecting a button that redirects them to the Microsoft identity platform authorization endpoint. The `redirect_uri` is set to the `/auth/callback` API endpoint of the API Management gateway.

2. Users are prompted to authenticate themselves. If authentication succeeds, the Microsoft identity platform responds with a redirect.

3. The browser is redirected to the `redirect_uri`, which is the API Management callback endpoint. The authorization code is passed to the callback endpoint.

4. The inbound policy of the callback endpoint is invoked. The policy exchanges the authorization code for an access token by making a call to the Azure AD token endpoint. It passes the required information, like the client ID, client secret, and authorization code:

   ```XML
   <send-request ignore-error="false" timeout="20" response-variable-name="response" mode="new">
    <set-url>https://login.microsoftonline.com/{{tenant-id}}/oauth2/v2.0/token</set-url>
    <set-method>POST</set-method>
    <set-header name="Content-Type" exists-action="override">
        <value>application/x-www-form-urlencoded</value>
    </set-header>
    <set-body>@($"grant_type=authorization_code&code={context.Request.OriginalUrl.Query.GetValueOrDefault("code")}&client_id={{client-id}}&client_secret={{client-secret}}&redirect_uri=https://{context.Request.OriginalUrl.Host}/auth/callback")</set-body>
   </send-request>
   ```
5. The access token is returned and stored in a variable named `token`:

      ```XML
      <set-variable name="token" value="@((context.Variables.GetValueOrDefault<IResponse>("response")).Body.As<JObject>())" />
      ```
6. The access token is encrypted with AES encryption and stored in a variable named `cookie`:

   ```XML
   <set-variable name="cookie" value="@{
       var rng = new RNGCryptoServiceProvider();
       var iv = new byte[16];
       rng.GetBytes(iv);
       byte[] tokenBytes = Encoding.UTF8.GetBytes((string)(context.Variables.GetValueOrDefault<JObject>("token"))["access_token"]);
       byte[] encryptedToken = tokenBytes.Encrypt("Aes", Convert.FromBase64String("{{enc-key}}"), iv);
       byte[] combinedContent = new byte[iv.Length + encryptedToken.Length];
       Array.Copy(iv, 0, combinedContent, 0, iv.Length);
       Array.Copy(encryptedToken, 0, combinedContent, iv.Length, encryptedToken.Length);
       return System.Net.WebUtility.UrlEncode(Convert.ToBase64String(combinedContent));
    }" />
      ```

6. The outbound policy of the callback endpoint is invoked to redirect to the single-page application. It sets the encrypted access token in an `HttpOnly` cookie that has `SameSite` set to `Strict` and is scoped to the domain of the API Management gateway. Because no explicit expiration date is set, the cookie is created as a session cookie and expires when the browser is closed.

   ```XML
   <return-response>
       <set-status code="302" reason="Temporary Redirect" />
       <set-header name="Set-Cookie" exists-action="override">
           <value>@($"{{cookie-name}}={context.Variables.GetValueOrDefault<string>("cookie")}; Secure; SameSite=Strict; Path=/; Domain={{cookie-domain}}; HttpOnly")</value>
       </set-header>
       <set-header name="Location" exists-action="override">
           <value>{{return-uri}}</value>
       </set-header>
   </return-response>
   ```

## API call flow

When the single-page application has the access token, it can use the token to call the downstream API. Because the cookie is scoped to the domain of the single-page application and is configured with the `SameSite=Strict` attribute, it's automatically added to the request. The access token can then be decrypted so it can be used to call the downstream API. The following diagram shows the sequence of events for this flow.

![Diagram that shows the API call sequence.](../_images/no-token-in-browser-call-api-sequence.png)

The flow contains these steps:

1. A user selects a button in the single-page application to call the downstream API. This action invokes a JavaScript function that calls the `/graph/me` API endpoint of the API Management gateway.

2. Because the cookie is scoped to the domain of the single-page application and has `SameSite` set to `Strict`, the browser automatically adds the cookie when it sends the request to the API.

3. When the API Management gateway receives the request, the inbound policy of the `/graph/me` endpoint is invoked. The policy decrypts the access token from the cookie and stores it in a variable named `access_token`:

   ```XML
   <set-variable name="access_token" value="@{
       try {
           string cookie = context.Request.Headers
               .GetValueOrDefault("Cookie")?
               .Split(';')
               .ToList()?
               .Where(p => p.Contains("{{cookie-name}}"))
               .FirstOrDefault()
               .Replace("{{cookie-name}}=", "");
           byte[] encryptedBytes = Convert.FromBase64String(System.Net.WebUtility.UrlDecode(cookie));
           byte[] iv = new byte[16];
           byte[] tokenBytes = new byte[encryptedBytes.Length - 16];
           Array.Copy(encryptedBytes, 0, iv, 0, 16);
           Array.Copy(encryptedBytes, 16, tokenBytes, 0, encryptedBytes.Length - 16);
           byte[] decryptedBytes = tokenBytes.Decrypt("Aes", Convert.FromBase64String("{{enc-key}}"), iv);
           char[] convertedBytesToChar = Encoding.UTF8.GetString(decryptedBytes).ToCharArray();
           return Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(convertedBytesToChar));
       } catch (Exception ex) {
           return null;
       }
   }" />
   ```
4. The access token is added to the request to the downstream API as an `Authorization` header:

   ```XML
   <choose>
       <when condition="@(!string.IsNullOrEmpty(context.Variables.GetValueOrDefault<string>("access_token")))">
           <set-header name="Authorization" exists-action="override">
               <value>@($"Bearer {context.Variables.GetValueOrDefault<string>("access_token")}")</value>
           </set-header>
       </when>
   </choose>
   ```

5. The request is proxied to the downstream API with the access token added to the `Authorization` header.

6. The response from the downstream API is returned directly to the single-page application.

## Deploy this scenario

For complete examples of the policies described here, together with OpenAPI specifications and a full deployment guide, see this [GitHub repository](https://github.com/Azure/no-token-in-the-browser-pattern).

## Enhancements

This solution isn't production-ready. It's meant to demonstrate what you can do by using the services described here. Consider the following factors before using the solution in production.

- This example doesn't implement access token expiration or the use of refresh or ID tokens.
- The contents of the cookie in the sample are encrypted via AES encryption. The key is stored as a secret on the **Named values** pane of the API Management instance. To better protect this named value, you can use a reference to a secret that's stored in [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). You should periodically rotate encryption keys as part of your [key management](https://en.wikipedia.org/wiki/Key_management) policy.
- This example only proxies calls to a single downstream API, so it requires only one access token. This scenario allows a stateless approach. However, because of the size limitation of HTTP cookies, if you need to proxy calls to multiple downstream APIs, you need a stateful approach. Rather than using a single access token, this approach involves storing access tokens in a cache and retrieving them based on the API that's being called and a key that's provided in the cookie. You can implement this approach by using the API Management [cache](/azure/api-management/api-management-howto-cache) or an external [Redis cache](/azure/api-management/api-management-howto-cache-external).
- Because this example demonstrates the retrieval of data only via a GET request, it doesn't provide protection against [CSRF](https://owasp.org/www-community/attacks/csrf) attacks. If you use other HTTP methods, like POST, PUT, PATCH, or DELETE, this protection is required.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ira Rainey](https://www.linkedin.com/in/ira-rainey) | Senior Software Engineer

Other contributor:
 
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Example implementation and deployment guide](https://github.com/Azure/no-token-in-the-browser-pattern)
- [Policies in Azure API Management](/azure/api-management/api-management-howto-policies)
- [How to set or edit Azure API Management policies](/azure/api-management/set-edit-policies)
- [Use named values in Azure API Management policies](/azure/api-management/api-management-howto-properties)
- [OAuth 2.0 authentication with Azure Active Directory](/azure/active-directory/fundamentals/auth-oauth2)
- [What is Azure Static Web Apps?](/azure/static-web-apps/overview)

## Related resources

- [Protect APIs with Application Gateway and API Management](../../../web-apps/api-management/architectures/protect-apis.yml)
- [Protect backend APIs by using Azure API Management and Azure AD B2C](../../../solution-ideas/articles/protect-backend-apis-azure-management.yml)
