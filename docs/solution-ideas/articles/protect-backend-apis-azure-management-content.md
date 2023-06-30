[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

In this article, we'll look at an architecture that protects backend APIs in Azure and other environments by using API Management and Azure Active Directory (Azure AD) B2C to validate bearer tokens.

## Architecture

:::image type="content" source="../media/protect-backend-apis-azure-management.png" alt-text="Diagram of an architecture that protects backend APIs by using API Management and Azure AD B2C to validate bearer tokens. The APIs can be in Azure or other environments." border="false" lightbox="../media/protect-backend-apis-azure-management.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1932168-protect-backend-apis-azure-management.vsdx) of this architecture.*

### Dataflow

1. To gain access to an application, an API client authenticates by providing credentials such as username and password. The IdP is Azure AD B2C in this solution, but you can use a different one.
1. The authentication request goes via Azure Front Door to Azure AD B2C, which is configured with a custom domain for sign-in. Azure AD B2C authenticates the user and returns a JSON Web Token (JWT) bearer token back to the user.
1. The client triggers an event that accesses a backend API. This event could be a click of a button on a web application or on a mobile device, or a direct call to the endpoint of the backend API.
1. The request goes through Azure Front Door, whose back end is mapped to the public endpoint of API Management. API Management intercepts the request and validates the bearer token against Azure AD B2C by using its [validate-jwt](/azure/api-management/api-management-access-restriction-policies#ValidateJWT) policy. If the token isn't valid, API Management rejects the request by responding with a 401 code.
1. If the token is valid, API Management forwards the request to the appropriate backend API.

   The diagram shows backend APIs running in three environments:

   - App Service Environment
   - Function Apps
   - Azure Kubernetes Services (AKS)

   APIs running in on-premises and hybrid cloud environments can also be integrated with API Management if network connectivity is established between the APIs and API Management.

### Components

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) provides secure communications among Azure resources such as virtual machines (VMs). It also provides access to the internet, and to on-premises networks.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for web content and applications. It offers Layer 7 capabilities such as SSL offload, path-based routing, fast failover, and caching to improve the performance and availability of your applications.
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway) is a Layer 7 load balancer that manages traffic to web applications.
- [API Management](https://azure.microsoft.com/services/api-management) is a turnkey solution for publishing APIs to external and internal clients. It provides features that are useful for managing a public-facing API, including rate limiting, IP restrictions, and authentication that uses Azure AD or another IdP. API Management doesn't perform any load balancing, so you should use it with a load balancer such as Application Gateway or a reverse proxy. For information about using API Management with Application Gateway, see [Integrate API Management in an internal virtual network with Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).
- [Azure AD B2C](https://learn.microsoft.com/azure/active-directory-b2c/overview) is a highly available global identity management service, built on Azure Active Directory, for consumer-facing applications. It scales to hundreds of millions of identities. It's the IdP that this solution uses. It returns the bearer token (JWT) on successful authentication.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps by using .NET, .NET Core, Node.js, Java, Python, or PHP. The apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated as in the mainframe application, and can be stateless to orchestrate a microservices-based system.
- [Azure App Service Environment](/azure/app-service/environment) is a single-tenant deployment of App Service. It enables hosting of applications in a fully isolated and dedicated environment for securely running App Service apps at high scale.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a Microsoft managed Kubernetes environment for running containerized applications.
- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. Azure Functions runs on demand and at scale in the cloud.

## Scenario details

Backend APIs are an entry point to your applications and data, an entry point that should be protected against malicious applications and users. In the architecture described here, Azure API Management acts as a gateway between clients and backend APIs and helps protect the APIs in many ways, including:

- Token validation
- Claims-based authorization
- SSL certificate validation
- IP restrictions
- Throttling
- Rate limiting
- Request and response validation

You can use any OpenID Connect identity provider (IdP), from Microsoft or another supplier, to authenticate clients. This solution uses Azure Active Directory B2C (Azure AD B2C). If you authenticate with something other than OpenID Connect you can, in most cases, use Azure AD B2C to federate. For more information, see [Add an identity provider to your Azure Active Directory B2C tenant](/azure/active-directory-b2c/add-identity-provider).

### Potential use cases

This architecture addresses the needs of organizations seeking to:

- Protect backend APIs from unauthorized users.
- Use API Management features such as throttling, rate limiting, and IP filtering to prevent overloading of APIs.
- Use Azure AD B2C for authentication with OpenID Connect, or federation with other IdPs, including:
  - Third party IdPs such as Ping Identity and Computer Associates (CA) SiteMinder.
  - Facebook, Microsoft account, Google, Twitter.
  - IdPs that support OAuth 1.0, OAuth 2.0, or SAML protocols.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Arshad Azeem](https://www.linkedin.com/in/arshadazeem) | Senior Cloud Solution Architect

Other contributors:

- [Raj Penchala](https://www.linkedin.com/in/rajpenchala) | Principal Cloud Security Architect
- [Ryan Hudson](https://www.linkedin.com/in/ryanhudsonit) | Principal Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Enable custom domains for Azure Active Directory B2C](/azure/active-directory-b2c/custom-domain?pivots=b2c-custom-policy)
- [Azure Active Directory B2C: Custom CIAM User Journeys](https://github.com/azure-ad-b2c/samples#azure-active-directory-b2c-custom-ciam-user-journeys)
- [Resilience through developer best practices](/azure/active-directory/fundamentals/resilience-b2c-developer-best-practices?bc=/azure/active-directory-b2c/bread/toc.json&toc=/azure/active-directory-b2c/TOC.json)

## Related resources

- [Protect APIs with Application Gateway and API Management](../../web-apps/api-management/architectures/protect-apis.yml)
- [Automated API deployments with APIOps](../../example-scenario/devops/automated-api-deployments-apiops.yml)
