[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This pattern is an example of how you can use Azure API Management to implement a no token in the browser pattern for a JavaScript single-page application.

This pattern uses [Azure API Management](https://azure.microsoft.com/en-us/products/api-management) in a [Backend for Frontend](https://learn.microsoft.com/en-us/azure/architecture/patterns/backends-for-frontends) pattern to handle the OAuth2 access token acquisition from Azure Active Directory; [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) encryption and decryption of the access token into an `HttpOnly` cookie; and to proxy all API calls requiring authorization.

As the backend handles the token acquisition, no other code or library, such as [MSAL.js](https://github.com/AzureAD/microsoft-authentication-library-for-js), is required in the single-page application itself. This also means that no tokens are stored in the browser session or local storage. By encrypting and storing the access token in an `HttpOnly` cookie protects it from [XSS](https://owasp.org/www-community/attacks/xss/) attacks, and scoping it to the API domain and setting `SameSite=strict` ensures that the cookie is automatically sent with all proxied API first-party requests.

## Architecture

![Diagram of the No Token in the Browser architecture.](../media/no-token-in-the-browser.png)

*Download a [Visio file](https://arch-center.azureedge.net/no-token-in-the-browser.vsdx) of this architecture.*

### Workflow

1. User selects sign-in in single-page application.
2. Single-page application invokes Authorization Code flow with a redirect to Azure Active Directory authorize endpoint.
3. User authenticates themselves.
4. Authorization Code flow response redirects to Azure API Management callback endpoint with authorization code.
5. Azure API Management policy exchanges authorization code for access token by calling Azure Active Directory token endpoint.
6. Azure API Management policy redirects back to single-page application and sets encrypted access token in an HttpOnly cookie.
7. User invokes external API call from single-page application through Azure API Management proxied endpoint.
8. Azure API Management policy receives API request, decrypts cookie, and makes downstream API call with access token added as Authorization header.

## Scenario details

Single-page applications are written in JavaScript and run within the context of a client-side browser. This pattern means that any code running in the browser can be accessed by the user. It also means that any data such as an access token stored in the browser session or local storage can be accessed by malicious code running in the browser, or via a XSS vulnerability. This means that any sensitive data, such as access tokens, can be accessed and used to impersonate the user.

This pattern increases the security of the application by moving the token acquisition and storage to the backend, and by using an encrypted `HttpOnly` cookie to store the access token. This means that the access token isn't stored in the browser session or local storage, and isn't accessible to malicious code running in the browser.

The acquisition of the access token and encryption and decryption of the cookie is handled by the use of Azure API Management Policies. Examples of these policies can be found in this [GitHub repository](https://github.com/irarainey/no-token-in-the-browser-pattern).

By using an `HttpOnly` cookie to store the access token, the token is protected from XSS attacks and is not accessible by JavaScript. Scoping the cookie to the API domain and setting `SameSite=strict` ensures that the cookie is automatically sent with all proxied API first-party requests. This pattern allows the access token to be automatically added to the Authorization header of all API calls made from the single-page application by the backend.

### Potential use cases

This pattern can be used to protect any API that requires authorization when being called from a single-page application running in a browser. It can be used to protect a single API or multiple APIs as all API calls are proxied through the API Management instance.

### Components

- [Azure API Management](https://azure.microsoft.com/services/api-management/) is a hybrid, multicloud management platform for APIs across all environments. API Management creates consistent, modern API gateways for existing backend services.
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Identity services, single sign-on, and multifactor authentication across Azure workloads.
- [Azure Static Web Apps](/azure/static-web-apps), for automatically building and deploying web applications to Azure, triggered by changes made to application source code in GitHub or in Azure DevOps repositories.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Ira Rainey](https://www.linkedin.com/in/ira-rainey) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Example Implementation of this Architecture Pattern (GitHub)](https://github.com/irarainey/no-token-in-the-browser-pattern)
* [Policies in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)
* [How to set or edit Azure API Management policies](https://learn.microsoft.com/en-us/azure/api-management/set-edit-policies)
* [Use named values in Azure API Management policies](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-properties)
* [OAuth 2.0 authentication with Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/auth-oauth2)
* [What is Azure Static Web Apps?](https://learn.microsoft.com/en-us/azure/static-web-apps/overview)

## Related resources

* [Protect APIs with Application Gateway and API Management](../../reference-architectures/apis/protect-apis.yml)
* [Protect backend APIs by using Azure API Management and Azure AD B2C](./protect-backend-apis-azure-management.yml)