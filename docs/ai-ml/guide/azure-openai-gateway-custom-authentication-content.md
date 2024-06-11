Intelligent applications that use Azure OpenAI services through platform-native Azure deployments offer a seamless user authentication and authorization approach for developers. However, edge case scenarios present unique complexities that require another architecture design. Scenarios include topologies such as non-Azure hosted applications, the use of external identity providers, or deploying multiple clients accessing the same Azure OpenAI instances. In these scenarios, introducing a gateway in front of Azure OpenAI can provide significant improvement with a layer of security that ensures consistency in authentication to deployed instances.

This article explores the following key scenarios when authenticating with Azure OpenAI services.

- [Client applications authenticated with an external identity provider](#client-applications-authenticated-with-an-external-identity-provider)
- [Client applications authenticated with certificates](#client-applications-authenticated-with-certificates)
- [Multiple client applications accessing a shared Azure OpenAI instance](#multiple-client-applications-accessing-a-shared-azure-openai-instance)
- [Client applications accessing multiple Azure OpenAI instances](#client-applications-accessing-multiple-azure-openai-instances)

Each scenario describes the challenges that they introduce, and the benefits introduced by including a gateway.

> [!IMPORTANT]
> The following guidance is suitable for any gateway implementation, including Azure API Management (APIM). The architecture diagrams represent the component generically in most scenarios to illustrate this.

## Client applications authenticated with an external identity provider

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-external-identity-provider.png" lightbox="_images/azure-openai-gateway-identity-scenario-external-identity-provider.png" alt-text="Diagram that shows a conceptual architecture for solutions where client applications authenticate users with an external identity provider, and authenticate with Azure OpenAI with API keys.":::
Diagram that shows a conceptual architecture for solutions where client applications authenticate users with an external identity provider, and authenticate with Azure OpenAI with API keys.
:::image-end:::

### Scenario use cases for external identity providers

In the scenario where a user operates an intelligent application that employs an external Identity Provider (IdP), like Okta or Auth0, the authentication process could differ. If the application isn't hosted within Azure, the use of managed identities for authentication isn't possible. In this case, API keys become essential as they offer a secure and straightforward method for these external applications to interact with Azure OpenAI, facilitating effective tracking and control of API usage.

When you're designing an architecture for accessing Azure OpenAI services, the following use cases could apply:

- A Microsoft Entra ID tenant external to the Azure OpenAI instance manages the user authentication.
- An external OpenID Connect (OIDC) enabled identity provider, such as Okta or Auth0, manages the user authentication.

### Introduce a gateway to improve Azure OpenAI access security and maintainability

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-external-identity-provider.png" lightbox="_images/azure-openai-gateway-identity-solution-external-identity-provider.png" alt-text="Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and Azure OpenAI, enabling authentication validation with an external identity provider before securely authenticating with Azure OpenAI using a managed identity with role-based access control.":::
Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and Azure OpenAI, enabling authentication validation with an external identity provider before securely authenticating with Azure OpenAI using a managed identity with role-based access control.
:::image-end:::

Introducing a gateway in this scenario enables server-side control to authorize access to Azure OpenAI using a managed identity, regardless of the user's authentication method or identity provider. The managed identity eliminates the need to manage API keys for Azure OpenAI instances in client application code, while improving security using Azure role-based access control.

In this scenario, the gateway validates user access tokens, such as a JSON Web Tokens (JWT), created by the identity provider before granting access to the Azure OpenAI instance. When the gateway authenticates with Azure OpenAI, it uses its assigned managed identity with least-privileged role-assignment to make requests for completions.

#### Tips for client applications authenticated with external identity providers  

- More client scopes can be added to your application registration in your identity provider to enable granular permission to consumers. These scopes allow client applications to request permission to perform specific operations in your gateway, including access to Azure OpenAI.
- This scenario is straightforward to configure using inbound policies in Azure API Management with the [validate-jwt policy](https://learn.microsoft.com/en-us/azure/api-management/validate-jwt-policy) to enforce the existence and validity of a supported JWT.

#### Reasons to avoid a gateway for client applications authenticated with external identity providers

When implementing a single Azure deployed client application to access Azure OpenAI, configuration of user authentication and authorization could be easier within the application than at the gateway level. With this approach, your Azure deployed application can also be assigned the necessary built-in roles to securely authenticate with Azure OpenAI directly.

## Client applications authenticated with certificates

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-client-certificates.png" lightbox="_images/azure-openai-gateway-identity-scenario-client-certificates.png" alt-text="Diagram that shows a conceptual architecture for solutions where users are authenticated with client applications using client certificates, and authenticate with Azure OpenAI with API keys.":::
Diagram that shows a conceptual architecture for solutions where users are authenticated with client applications using client certificates, and authenticate with Azure OpenAI with API keys.
:::image-end:::

### Scenario use cases for client certificate authentication

When you're designing an architecture for accessing Azure OpenAI services, the following use cases could apply:

- OIDC providers can't solely meet user authentication requirements.
- Authentication is made from machine-to-machine (M2M), where there's no user interaction.
- Downstream services can validate the client certificate used by client applications to authenticate users.

Azure OpenAI doesn't support client certification authentication natively, requiring the use of an API key to authenticate client application requests to the Azure OpenAI instance. To enable authentication with client digital certificates for intelligent applications or APIs, you can use an API Gateway to request and verify these certificates during the Transport Layer Security (TLS) handshake.

### Introduce a gateway to handle client certificate validation with secure access to Azure OpenAI

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-client-certificates.png" lightbox="_images/azure-openai-gateway-identity-solution-client-certificates.png" alt-text="Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and Azure OpenAI, enabling secure client certificate validation using Azure Key Vault, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.":::
Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and Azure OpenAI, enabling secure client certificate validation using Azure Key Vault, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.
:::image-end:::

Offloading client certification validation to a gateway provides server-side control to authorize access for valid client applications to Azure OpenAI. Additionally, taking advantage of managed identity to authenticate the gateway with Azure OpenAI instances reduces the complexity of managing API keys.

Using a gateway in this scenario, it's the responsibility of the gateway to [validate the client digital certificate presented by the Intelligent Application](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-mutual-certificates-for-clients#policy-to-validate-client-certificates) and check the issuer, expiration, thumbprint, and revocation lists.

Deploying an Azure Key Vault alongside a gateway to store the root certificate authority (CA) ensures that client certificate validation is managed in a centralized location, reducing maintenance overhead.

There are advantages that surpass the disadvantages of using a gateway, including centralized security with consistent security policies to evaluate client digital certificates. The gateway can also reduce complexity offloading the responsibility of certificate verification from the service. You can also enhance performance with cached responses, data compression, and TLS termination. The gateway, rather than the application, handles authentication changes, allowing the architecture to become more flexible.

#### Tips for client applications authenticated with client certificates

- When validating certificates, verify the entire certificate chain, including the root CA and intermediate certificates. Full verification ensures the authenticity of the certificate and prevents unauthorized access.
- Regularly rotate and renew client certificates to minimize the risk of certificate compromise. Automate this process using Azure Key Vault to ensure certificates are always up to date. Setting alerts for upcoming certificate expirations also prevents service disruption at the gateway.
- Using Azure API Management, you can use policies to verify the certificates presented by the clients and easily integrate with Azure Key Vault.
- Self-signed certificates shouldn't be used for authentication purposes.

#### Reasons to avoid a gateway for client applications authenticate with client certificates

In smaller applications or environments where security and certificate management can be handled directly within the application without a gateway, the added complexity could outweigh the benefits. Additionally, gateways can become single points of failure, increase latency due to added layers, and lead to vendor lock-in if you opt for commercial solutions over custom implementations.

You must carefully assess your specific needs, resource availability, and the criticality of your applications before deciding to implement a gateway for client certificate authentication.

## Multiple client applications accessing a shared Azure OpenAI instance

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-multiple-clients.png" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-clients.png" alt-text="Diagram that shows a conceptual architecture for solutions where multiple client applications authenticate with Azure OpenAI using a shared API key.":::
Diagram that shows a conceptual architecture for solutions where multiple client applications authenticate with Azure OpenAI using a shared API key.
:::image-end:::

### Scenario use cases for multiple client applications accessing a shared Azure OpenAI instance

When you're designing an architecture for accessing Azure OpenAI services, the following use cases could apply:

- Multiple client applications are deployed across multiple environments, including Azure, other cloud providers, or on-premises.
- A distributed microservice architecture requires access to a shared Azure OpenAI instance.

Depending on where the applications are deployed, a mix of authentication methods can be used to make a request to the Azure OpenAI instance. When the application isn't deployed in Azure, client applications share an API key that is managed per application.

### Introduce a gateway to handle multiple clients accessing Azure OpenAI with separate subscription keys and unified authentication

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-multiple-clients.png" lightbox="_images/azure-openai-gateway-identity-solution-multiple-clients.png" alt-text="Diagram that shows a conceptual architecture for solutions injecting a gateway between multiple client applications and Azure OpenAI. The gateway provides independent subscription keys for client applications that it validates, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.":::
Diagram that shows a conceptual architecture for solutions injecting a gateway between multiple client applications and Azure OpenAI. The gateway provides independent subscription keys for client applications that it validates, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.
:::image-end:::

Using a shared API key across multiple client applications increases the attack surface for Azure OpenAI deployments, complicating key management for all client applications if one becomes compromised.

By implementing a gateway, you can centralize authentication, reducing the risk associated with key distribution. Managing API keys across numerous client applications can be complex. Regularly rotating keys is a best practice, however, rotating keys across multiple clients can be logistically challenging. The gateway simplifies the process by handling authentication centrally.  

Choosing to configure a gateway with managed identities for Azure OpenAI authentication reduces the administrative burden of API key management while enhancing security.  

#### Tips for multiple client applications access a shared Azure OpenAI instance

- Since using a managed identity might reduce traceability of the end user and client application, enhance monitoring on metrics related to API requests. The gateway should provide any extra tracing metadata associated with the request, such as the requesting client and user IDs.
- Beyond managed identities, consider combining this scenario with an identity provider as covered in [Introduce a gateway to improve Azure OpenAI access security and maintainability](#client-applications-authenticated-with-an-external-identity-provider). Adding an identity provider adds an extra layer of security at the gateway for client requests.
- When routing multiple client application requests through a gateway to a shared Azure OpenAI service, consider implementing retry policies for transient failures. For more best practices in gateway implementations for Azure OpenAI deployments, see [using a gateway in front of multiple Azure OpenAI deployments](./azure-openai-gateway-multi-backend.yml).

## Client applications accessing multiple Azure OpenAI instances

If the intelligent applications aren't hosted within Azure, managed identities can't be utilized for authentication. Instead, API keys are used to authenticate Azure OpenAI for these external applications.

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-multiple-services.png" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-services.png" alt-text="Diagram that shows a conceptual architecture for solutions where client applications authenticate with multiple Azure OpenAI instances using shared API keys per instance.":::
Diagram that shows a conceptual architecture for solutions where client applications authenticate with multiple Azure OpenAI instances using shared API keys per instance.
:::image-end:::

### Scenario use cases for accessing multiple Azure OpenAI instances

When you're designing an architecture for accessing Azure OpenAI services, the following use cases could apply:

- Multitenant client applications ensure resources are as close as possible to their users' region.
- Client applications maximize tokens per minute (TPM) quotas by deploying instances across regions.
- Client applications taking advantage of multiple model capabilities not available in a single region.

These scenarios can require client applications to manage API keys for each Azure OpenAI instance to authenticate requests.

### Introduce a gateway to handle client applications accessing multiple Azure OpenAI deployments with unified authentication

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-multiple-services.png" lightbox="_images/azure-openai-gateway-identity-solution-multiple-services.png" alt-text="Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and multiple Azure OpenAI instances. The gateway provides a single dedicated subscription key to a client application that it validates, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.":::
Diagram that shows a conceptual architecture for solutions injecting a gateway between client applications and multiple Azure OpenAI instances. The gateway provides a single dedicated subscription key to a client application that it validates, before securely authenticating with Azure OpenAI using a managed identity with role-based access control.
:::image-end:::

The approach for introducing a gateway to handle client applications accessing multiple Azure OpenAI deployments follows the same reasons covered by introducing a gateway to handle multiple clients accessing a shared Azure OpenAI deployment.

In addition to those reasons, by using a single user-defined managed identity to authenticate requests from the gateway to multiple Azure OpenAI instances, the process for authentication is streamlined. Implementing this approach reduces the overall operational overhead and minimizes the risks of misconfiguration of the client when working with multiple instances.

#### Tips for client applications accessing multiple Azure OpenAI instances

- Implement load balancing techniques to distribute the API requests across multiple instances of the Azure OpenAI service to handle high traffic and ensure high availability. For more information on this implementation, see [using a gateway in front of multiple Azure OpenAI deployments or instances](./azure-openai-gateway-multi-backend.yml).
- When you're implementing multitenant scenarios using multiple Azure OpenAI instances, tracking token usage for a specific tenant must be correlated at the gateway. Correlating token usage at the gateway ensures that you're tracking total token usage regardless of the backend Azure OpenAI instance that the request is forwarded to.  

### Reasons to avoid a gateway for accessing a shared Azure OpenAI instance or multiple Azure OpenAI instances

Introducing a gateway can be a potential single point of failure for solutions where high availability is a requirement. If the gateway experiences downtime or performance issues, all client applications relying on it for access to the Azure OpenAI instance are affected. Gateway failures can lead to widespread service disruptions, affecting the availability and reliability of critical applications. Instead, provide multiple gateway instances and follow our best practice guidance when [using a gateway in front of multiple Azure OpenAI deployments](./azure-openai-gateway-multi-backend.yml).

Additionally, the gateway can introduce latency, which could be detrimental in performance-sensitive applications. Each request from a client must pass through the gateway, adding extra processing time and potentially slowing down response times. Directly connecting client applications to the Azure OpenAI instance and managing authentication and authorization individually might be more efficient in such cases. This direct approach, albeit more complex to manage, can ensure the lowest possible latency and highest performance for critical applications.

## General recommendations

When you integrate Azure OpenAI services through a gateway, there are several cross-cutting recommendations to consider that apply in all scenarios.

Opting for Azure API Management (APIM) instead of creating your own solution has several benefits. It provides efficient API orchestration, easy integration with other Azure services, and cost savings by lowering development and maintenance efforts. APIM provides secure API management by supporting authentication and authorization directly. It integrates with identity providers, such as Microsoft Entra ID, enabling OAuth 2.0, and offers policy-based authorization. Additionally, it can take advantage of managed identities for secure access to Azure OpenAI.

### Gateway policy enforcement

Before requests to Azure OpenAI instances are sent via a gateway, inbound authentication and authorization policies should be enforced. Whether by user access tokens from an identity provider or certificate validation, implementing this approach ensures that only authenticated and authorized requests are forwarded on.

Implementing more authorization scoping with roles and permissions for client applications in your gateway also enables granular control. These scopes allow specific operations to be permitted based on the client application's needs, enhancing security and manageability.

### Use Azure managed identities

Using Azure managed identities simplifies authentication across all client application scenarios by centralizing authentication management. This approach reduces the complexity and risks associated with managing multiple API keys or credentials in client applications.

As managed identities inherently support Azure role-based access control, they ensure the gateway has only the right level of permission to access Azure OpenAI instances. Managed identities reduce the risk of unauthorized access and simplify compliance with security policies.

### Implement comprehensive observability

When you implement a gateway with managed identity, traceability can be reduced since a managed identity represents the gateway, not the end-user, or the application that made the request. Therefore, it's essential to improve observability on metrics related to API requests. Gateways should provide more tracing metadata, including the requesting client and user IDs, to maintain visibility over access patterns and usage.

Centralized logging of all requests passing through the gateway also helps in maintaining an audit trail. A centralized audit trail is especially important for troubleshooting, compliance, and ensuring that unauthorized access attempts can be detected.

## Gateway implementations

Azure doesn't offer a turn-key solution or reference architecture for building such a gateway. As mentioned in the introduction article, you must build and operate this gateway. The following are examples of community-supported implementations covering the previously mentioned use cases. Consider referencing these samples when you build your own gateway solution.

| Implementation       | Example |
| :------------------- | :------ |
| Azure OpenAI Application Identity and Security – Learn Live Webinar | [Learn Live: Azure OpenAI Application Identity & Security (youtube.com)](https://www.youtube.com/live/pDjXsNWYmvo) |

## Next steps

Implementing a gateway for your workload provides benefits beyond the scenarios for improving authentication and authorization detailed in this article. Learn about the other [key challenges](./azure-openai-gateway-guide.yml#key-challenges) a gateway can solve.

## Contributors

*The following contributors originally wrote this article.*

Principal authors:

- [Lizet Pena De Sola](https://www.linkedin.com/in/lizetp/) | Senior Customer Engineer, FastTrack for Azure
- [Bappaditya Banerjee](https://www.linkedin.com/in/bappaditya-banerjee-8860ba7/) | Senior Customer Engineer, FastTrack for Azure
- [James Croft](https://www.linkedin.com/in/jmcroft/) | Customer Engineer, ISV & Digital Native Center of Excellence

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Role-based access control for Azure OpenAI](/azure/ai-services/openai/how-to/role-based-access-control)
- [Use managed identities in Azure API Management](/azure/api-management/api-management-howto-use-managed-service-identity)
- [Policies in Azure API Management](/azure/api-management/api-management-howto-policies)
- [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview)
- [Protect an API in API Management using OAuth 2.0 and Microsoft Entra ID](/azure/api-management/api-management-howto-protect-backend-with-aad)
- [Secure API Management backend using client certificate authentication](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-mutual-certificates) 
