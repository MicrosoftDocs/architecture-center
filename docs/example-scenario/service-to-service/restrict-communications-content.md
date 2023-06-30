This example scenario restricts communications between two Azure backend services on both the application and network layers. Communications can flow only between services that explicitly allow it, adhering to the [principle of least privilege][leastpriv]. This example uses Azure App Service to host the services, but you can use similar techniques for Azure Functions Apps.

Interservice communications restrictions are only one part of an overall security strategy based on careful planning, [threat-modeling][threatmodeling], and the [Security Development Lifecycle][sdlc]. Overall security planning should incorporate business, compliance, regulatory, and other non-functional requirements.

## Potential use cases

While the current scenario focuses on network restrictions, many organizations now embrace a [zero trust security model][zerotrust] that assumes a breach, so the networking layer is of secondary importance.

## Architecture

:::image type="complex" source="./media/service-to-service-architecture.svg" alt-text="Diagram showing both network layer and application layer communications restrictions between two Azure App Service backend services." border="false":::
In the network layer step 1, Service A uses client credentials to request and receive an OAuth 2.0 token for Service B from Azure Active Directory. In step 2, Service A injects the token into a communications request toward Service B. In step 3, Service B evaluates the access token's aud claim and validates the token. In the application layer, Service A is in an integration subnet in a virtual network. In step 1, Service A uses App Service Regional VNet Integration to communicate only from a private IP address in its integration subnet. In step 2, Service B uses service endpoints to accept communications only from IP addresses in the Service A integration subnet.
:::image-end:::

### Dataflow

The diagram shows restricted communications from Service A to Service B. Token-based authorization restricts access on the application layer, and service endpoints restrict access on the network layer.

- Both services [register with Azure Active Directory (Azure AD)][appreg], and use OAuth 2.0 token-based authorization in the [client credentials flow][clientcredsflow].
- Service A communicates by using [Regional VNet Integration][regionalvnet] from a private IP address in its virtual network integration subnet. Service B [service endpoints][svcep] accept inbound communications only from the Service A integration subnet.

#### Token-based authorization

An OpenID Connect (OIDC)-compatible library like the [Microsoft Authentication Library (MSAL)][msal] supports this token-based client credentials flow. For more information, see [Scenario: Daemon application that calls web APIs][daemoncallswebapi] and the [sample application for the daemon scenario][daemonsample].

1. Both Service A and Service B register in Azure AD. Service A has client credentials in either shared secret or certificate form.
1. Service A can use its own client credentials to request an access token for Service B.
1. Azure AD provides an access token with a Service B audience or [aud][accesstokenclaims] claim.
1. Service A injects the token as a *bearer token* in the HTTP Authorization header of a request to Service B, according to the [OAuth 2.0 Bearer Token Usage specification][bearertokenspec].
1. Service B [validates the token][tokenvalidation] to ensure that the `aud` claim matches the Service B application.

Service B uses one of the following methods to ensure that only specifically allowed clients, Service A in this case, can get access:

- **Validate the token appid claim**. Service B can validate the token [appid][accesstokenclaims] claim, which identifies which Azure AD-registered application requested the token. Service B explicitly checks the claim against a known access control caller list.
- **Check for roles in the token**. Similarly, Service B can check for certain [roles][accesstokenclaims] claimed in the incoming token, to ensure that Service A has explicit access permissions.
- **Require user assignment**. Alternatively, the Service B owner or admin can configure Azure AD to require *user assignment*, so only applications that have explicit permissions to the Service B application can get a token toward Service B. Service B then doesn't need to check for specific roles, unless business logic requires it.

   To set up a user assignment requirement to access Service B:

   1. In Azure AD, [enable user assignment][userassignment] on Service B.
   1. [Expose at least one app role][exposeapprole] on Service B that Service A can ask permission for. The **AllowedMemberTypes** for this role must include `Application`.
   1. [Request app permission][configurepermission] for Service A to the exposed Service B role.
      1. From the **API permissions** section of the Service A app registration, select **Add a permission**, and then select the Service B application from the list.
      1. On the **Request API permissions** screen, select [Application permissions][aadpermissiontypes], because this backend application runs without a signed-in user. Select the exposed Service B role, and then select **Add permissions**.
   1. [Grant admin consent][consent] to the Service A application permissions request. Only a Service B owner or admin can consent to the Service A permissions request.

#### Service endpoints

The lower half of the architectural diagram shows how to restrict interservice communications on the network layer:

1. The Service A web app uses [Regional VNet Integration][regionalvnet] to route all outbound communications through a private IP address within the IP range of the integration subnet.
1. Service B has [service endpoints][svcep] that allow inbound communications only from web apps on the integration subnet of Service B.

For more information, see [Set up Azure App Service access restrictions][accessrestrictions].

### Components

This scenario uses the following Azure services:

- [Azure App Service][appsvc] hosts both Service A and Service B, allowing autoscale and high availability without having to manage infrastructure.
- [Azure AD][aad] is the cloud-based identity and access management service that authenticates services and enables OAuth 2.0 token-based authorization.
- [Azure Virtual Network][vnet] is the fundamental building block for private networks in Azure. Azure Virtual Network lets resources like Azure Virtual Machines (VMs) securely communicate with each other, the internet, and on-premises networks.
- [Azure Service Endpoints][svcep] provide secure and direct connectivity to Azure services over an optimized route on the Azure backbone network, and allow access only from the range of private source IPs in the integration subnet.
- [Microsoft Authentication Library (MSAL)][msal] is an OIDC-compatible library that allows a service to fetch access tokens from Azure AD using a client credentials flow.

### Alternatives

There are several alternatives to the example scenario.

#### Managed identity

Instead of registering as an application with Azure AD, Service A could use a [managed identity][mi] to fetch an access token. Managed identity frees operators from having to manage credentials for an app registration.

While a managed identity lets Service A fetch a token, it doesn't provide an Azure AD app registration. For other services to request an access token for Service A itself, Service A still needs an Azure AD app registration.

You can't assign a managed identity to an app role through the Azure portal, only through the Azure PowerShell command line. For more information, see [Assign a managed identity access to an application role using PowerShell][addmitorole].

#### Azure Functions

You can host the services in [Azure Functions][functions] instead of App Service. To restrict access on the network layer by using Regional VNet Integration, you need to host the Functions apps in an App Service plan or a Premium Plan. For more information, see [Azure Functions networking options][functionsnetworking].

#### App Service built-in authentication and authorization

By design, this scenario colocates the authorization code with the rest of the business logic by performing token validation as part of application code. [App Service built-in authentication and authorization][easyauth], or Easy Auth, can also perform basic token validation before sending a request to a service. The service then relies on the hosting infrastructure to reject unauthorized requests.

To configure App Service authentication and authorization, set the authorization behavior to **Log in with Azure Active Directory**. This setting validates tokens and restricts access to valid tokens only.

The downside of using Easy Auth is that the service loses the authentication and authorization protection if it moves elsewhere. While App Service authentication and authorization works for simple scenarios, complex authorization requirements should use logic from within the application code.

#### Service endpoints vs. private endpoints

This scenario uses service endpoints rather than [private endpoints][privateend], because only service endpoints allow restricting access to a web app from a given subnet. Filtering inbound traffic on private endpoints isn't supported through Network Security Groups (NSGs) or by using App Service access restrictions. Every service with network line-of-sight can communicate with the private endpoint of a web application. This limits private endpoint usefulness for locking down traffic on the network layer.

## Considerations

- App Service Regional VNet Integration provides a single integration subnet for each App Service Plan. All web apps on the same plan integrate with the same subnet, and share the same set of private outbound IP addresses. Receiving services can't distinguish which web app the traffic originates from. If you need to identify the originating web app, you must deploy the web apps on separate App Service Plans, each with its own integration subnet.

- Every worker instance in an App Service Plan occupies a separate private IP address within the integration subnet. To plan for scale, ensure that the integration subnet is large enough to accommodate the scale you expect.

### Cost optimization

Pricing for this scenario depends on your specific infrastructure and requirements. Azure AD has Free up to Premium tiers, depending on needs. Costs for Azure App Service or other hosts vary with your specific scale and security requirements, as described in [Alternatives](#alternatives) and [Considerations](#considerations).

To calculate costs for your scenario, see the [Azure pricing calculator][pricing].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Christof Claessens](https://www.linkedin.com/in/christofclaessens) | FastTrack for Azure Engineer

## Next steps

- [Message encoding considerations for cloud applications](../../best-practices/message-encode.md)
- [Enterprise deployment using App Services Environment](../../web-apps/app-service-environment/architectures/ase-standard-deployment.yml)
- [Web app private connectivity to Azure SQL database](../private-web-app/private-web-app.yml)

## Related resources

- [App Service networking features][appsvcnetworking]
- [Zero to Hero: securing your web app][securingwebapp]
- [Zero to Hero: multi-tier web apps][zerotohero]
- [Azure AD client credentials flow][clientcredsflow]
- [Service endpoints][svcep]
- [App Service Regional VNet Integration][regionalvnet]
- [Sample application demonstrating client credentials flow for daemon apps][daemonsample]
- [Azure Security Baseline for App Service][securitybaseline]

<!-- links -->
[aad]: /azure/active-directory/fundamentals/active-directory-whatis
[aadpermissiontypes]: /azure/active-directory/develop/v2-permissions-and-consent#permission-types
[accessrestrictions]: /azure/app-service/app-service-ip-restrictions#use-service-endpoints
[accesstokenclaims]: /azure/active-directory/develop/access-tokens#payload-claims
[addmitorole]: /azure/active-directory/managed-identities-azure-resources/how-to-assign-app-role-managed-identity-powershell
[appreg]: /azure/active-directory/develop/quickstart-register-app
[appsvc]: /azure/app-service/overview
[appsvcnetworking]: /azure/app-service/networking-features
[bearertokenspec]: https://tools.ietf.org/html/rfc6750
[clientcredsflow]: /azure/active-directory/develop/v2-oauth2-client-creds-grant-flow
[configurepermission]: /azure/active-directory/develop/quickstart-configure-app-access-web-apis#add-permissions-to-access-web-apis
[consent]: /azure/active-directory/manage-apps/grant-admin-consent#grant-admin-consent-in-app-registrations
[daemoncallswebapi]: /azure/active-directory/develop/scenario-daemon-overview
[daemonsample]: https://github.com/Azure-Samples/active-directory-dotnetcore-daemon-v2/tree/master/2-Call-OwnApi
[easyauth]: /azure/app-service/overview-authentication-authorization
[exposeapprole]: /azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps
[functions]: /azure/azure-functions/functions-overview
[functionsnetworking]: /azure/azure-functions/functions-networking-options
[leastpriv]: https://wikipedia.org/wiki/Principle_of_least_privilege
[mi]: /azure/active-directory/managed-identities-azure-resources/overview
[msal]: /azure/active-directory/develop/msal-overview
[pricing]: https://azure.microsoft.com/pricing/calculator/
[privateend]: /azure/private-link/private-endpoint-overview
[privep]: /azure/app-service/networking/private-endpoint
[regionalvnet]: /azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration
[sdlc]: https://www.microsoft.com/securityengineering/sdl
[securingwebapp]: https://azure.github.io/AppService/2020/08/14/zero_to_hero_pt6.html
[securitybaseline]: /azure/app-service/security-baseline
[svcep]: /azure/virtual-network/virtual-network-service-endpoints-overview
[threatmodeling]: https://www.microsoft.com/securityengineering/sdl/threatmodeling
[tokenvalidation]: /azure/active-directory/develop/access-tokens#validating-tokens
[userassignment]: /azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users#update-the-app-to-enable-user-assignment
[vnet]: /azure/virtual-network/virtual-networks-overview
[zerotohero]: https://azure.github.io/AppService/2020/10/05/zero_to_hero_pt7.html
[zerotrust]: https://www.microsoft.com/security/business/zero-trust
