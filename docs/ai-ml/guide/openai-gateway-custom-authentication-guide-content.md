This article shows how to implement alternative authentication mechanisms for client applications communicating with Azure OpenAI Service through a gateway. In this scenario, the focus is on the use of identity providers and managed identity taking advantage of role-based access control using pre-built roles.  

> [!IMPORTANT]
> This article is part of a series of solutions involving providing access to Azure OpenAI through a gateway. Ensure you’ve read Providing access to Azure OpenAI through a gateway before reading this guide, as this guide builds upon that pattern.

## Scenario

:::image type="content" source="_images/openai-gateway-custom-authentication-key.png" lightbox="_images/openai-gateway-custom-authentication-key.png" alt-text="Diagram that shows a conceptual architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
*Figure 1: Starting point for application authentication with Azure OpenAI service using key-based authentication. 

This section builds on the starting architecture defined in the overview guide, exploring the challenge of implementing authentication mechanisms to authorize user access to Azure OpenAI service.  

## Impediment 

By default, Azure OpenAI provides an API key authentication mechanism that requires you to manually store and manage the lifecycle of your API keys for your applications. As identified in the overview, the challenges with the scenario include: 

1. API key-based authentication does not allow for fine-grained access control to the OpenAI endpoints and models, which can pose security and governance challenges for organizations building solutions on Azure. 

1. Users must be authorized to access the application and its associated Azure platform services, validated in Microsoft Entra ID with the least privilege access available.

## Successful outcome 

Authenticated application users via Microsoft Entra ID can successfully access the capabilities of Azure OpenAI Service using access tokens, without the need to manage API keys. 

## Solution – Establish user authentication and authorization via Azure API Management  

A solution to the challenge is for teams to implement Azure API Management as an API gateway. The responsibility for the API gateways is to validate the authenticity of a user from user tokens served by an identity provider, ensure that they have granted permission to access the Azure OpenAI API, and distribute requests to one or more Azure OpenAI Service instances without the requirement for key-based authentication. 

The following are the required configuration changes: 

An AI-powered application must authenticate the user with an identity provider, e.g. Microsoft Entra ID. This identity provider issues a user access token with the relevant scopes with access to specific APIs, e.g. ones that interface with the Azure OpenAI service. 

A managed identity is deployed for the Azure API Management service that has the built-in Cognitive Services OpenAI User role assigned to the deployed Azure OpenAI service instances. 

An inbound policy is deployed for the Azure OpenAI API within Azure API Management that validates the user’s access token and ensures an access token is retrieved for the managed identity of Azure API Management to access the Azure OpenAI service. 

The following diagram illustrates the architecture, including the additional Azure resources based on the starting architecture. 
:::image type="complex" source="_images/openai-gateway-conceptual-architecture.svg" lightbox="_images/openai-gateway-conceptual-architecture.svg" alt-text="Diagram that shows a conceptual architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing into a dashed line box labeled gateway. The arrow goes through a line that is labeled 'Federated Authentication', pointing to a 'rate limiter' icon. The 'rate limiter' has an arrow that points to a 'router' icon. The 'router' has four arrows pointing to different icons. The first arrow points to a 'load balancer', which points to 'OpenAI deployment' or 'LLM' icons in two regions and on-premises. The second arrow points to a 'monitoring' icon that later points to a 'cost' and a 'usage' icon. The third arrow points to a 'compute' icon. The fourth points to a 'message queue' icon, which then points to the 'Load balancer'.
:::image-end:::
*Figure 2: Working solution for custom authentication with Azure OpenAI Service 

### User Authentication and Authorization via Microsoft Entra ID 

Microsoft Entra ID is an identity and access management system that registers applications to establish a trust relationship between the application and the identity provider. The registration process is essential whether the application is a client application like a web or mobile app, or a web API (e.g. Azure OpenAI) backing a client app. 

Scopes can be added to provide granular permission to consumers. These scopes allow client applications to request permission to perform operations defined by the web API.

> [!Note]
> To register your API and Client applications, follow this guide to expose the scope and grant permission to the API application.

### Azure API Management configuration for establishing authorization to Azure OpenAI Service 

1. To access deployed Azure OpenAI Service instances, backends are required for each deployment. These will be referenced in the API Management policy for the Azure OpenAI API. 

1. To provide a consistent API layer in Azure API Management for Azure OpenAI service deployments, the OpenAPI specification needs to be imported that targets the API version of Azure OpenAI that you are using.

> [!Note]
> The latest Azure OpenAI Service OpenAPI specifications can be found on GitHub here.

1. As well as user access token validation, we recommend using a subscription key in addition. On its own, a subscription key isn’t a strong form of authentication, but it can be useful in scenarios, for example, tracking API usage or granting access to specific APIs.

1. To validate the user’s access token, the inbound policies requires the validate-jwt policy to enforce the existence and validity of a supported JSON Web Token (JWT) extracted from a specified HTTP header, query parameter, or a specific value. 

### Configuring Azure API Management to authenticate with Azure OpenAI Service using Managed Identity 

1. For Azure API Management to call the Azure OpenAI Service APIs without API keys, the system-assigned managed identity must be enabled. This will provide you with an Object ID that you can associate with your Azure OpenAI Service instances.
1. From your Azure OpenAI Service instances, using access control (IAM), create a role assignment for your Azure API Management managed identity with the role Cognitive Services OpenAI User.
1. OpenAI API in Azure API Management, the authentication-managed-identity policy in conjunction with the set-header policy to ensure the request is authenticated.

## Scenario considerations 

With a well-configured Azure OpenAI gateway in place, let’s consider additional points to aid in achieving the successful outcome objectives within this scenario. 

### User-assigned managed identity 

An alternative approach to implementing the managed identity for Azure API Management is to use a user assigned. Unlike the system-assigned managed identity, which is managed for you by Azure, user-assigned managed identity allows you to create and manage it. This gives you more control over the identity implementation and its assigned roles. 

To implement this approach, you need to create the user assigned managed identity within your resource group and assign it the same Cognitive Services OpenAI User role to the Azure OpenAI instances. The user-assigned managed identity has an associated client ID that is needed for configuring the authentication-managed-identity policy in Azure API Management. This must be set as the client-id parameter. 

### External identity providers 

Enabling the use of Microsoft Entra ID to build an identity platform for your application may not be feasible, for example, where you already have an external identity provider configured. Taking advantage of your existing identity platform ensures that your team feel familiar with their tools to focus on building core functionality. 

When working with external OpenID Connect (OIDC) supported identity providers, ensure that a client is configured within that identity provider. This is equivalent to configuring your application within Microsoft Entra ID, discussed in the scenario. With this configured, configuring the validate-jwt policy requires configuration for the external well-known OpenID configuration path.  

Include code snippet for policy 

Additional configuration for required claims can be provided the same as the scenario solution. 

## Contributors 

Principal authors: 

Lizet Pena De Sola | Senior Customer Engineer, FastTrack for Azure 
Bappaditya Banerjee | Senior Customer Engineer, FastTrack for Azure
James Croft | Customer Engineer, ISV & Digital Native Center of Excellence 

## Summary 

This article provides an effective solution for implementing alternative authentication mechanisms for intelligent applications communicating with Azure OpenAI Service instances through a gateway proxy. By leveraging an identity provider for user authentication combined with managed identity for authenticating with Azure OpenAI without the need for managed keys, teams can take advantage of fine-grained access control their Azure OpenAI endpoints and models.  

## Related resources 

- [Role-based access control for Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/role-based-access-control)
- [Use managed identities in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-use-managed-service-identity)
- [Policies in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)
- [Authentication and authorization to APIs in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/authentication-authorization-overview)
- [Protect an API in API Management using OAuth 2.0 and Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad)
