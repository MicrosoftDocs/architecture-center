Intelligent applications that use Azure OpenAI Service through Azure-native services provide user authentication and authorization. However, some scenarios are complex and require different architecture designs. These scenarios include topologies that have client applications that aren't hosted on Azure, use external identity providers, and deploy multiple clients that access the same Azure OpenAI instances. In these scenarios, introducing a gateway in front of Azure OpenAI can significantly improve security by adding a layer that ensures consistent authentication to deployed instances.

This article describes key scenarios that provide authentication to Azure OpenAI:

- [Authenticate client applications via an external identity provider](#authenticate-client-applications-via-an-external-identity-provider)

- [Authenticate client applications via certificates](#authenticate-client-applications-via-certificates)

- [Authenticate multiple client applications via keys to access a shared Azure OpenAI instance](#authenticate-multiple-client-applications-via-keys-to-access-a-shared-azure-openai-instance)

- [Authenticate client applications that access multiple Azure OpenAI instances](#authenticate-client-applications-that-access-multiple-azure-openai-instances)

Each scenario describes the challenges that they introduce and the benefits of incorporating a gateway.

> [!IMPORTANT]
> You can use the following guidance for any gateway implementation, including Azure API Management. To illustrate this flexibility, the architecture diagrams use generic representations of components in most scenarios.

## Authenticate client applications via an external identity provider

:::image type="content" source="_images/azure-openai-gateway-identity-scenario-external-identity-provider.svg" lightbox="_images/azure-openai-gateway-identity-scenario-external-identity-provider.svg" alt-text="Diagram that shows client apps authenticating users with an external identity provider and Azure OpenAI by using API keys." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

### Scenario constraints

This scenario has the following constraints:

- Client applications use an external OpenID Connect (OIDC)-enabled identity provider such as Okta, Auth0, or social identity providers.

- Client applications authenticate against a Microsoft Entra tenant that's different than the Azure OpenAI data plane's tenant.

These constraints can apply to the following examples:

- Existing client applications that already authenticate against an external OIDC provider or Microsoft Entra ID and that integrate with Azure OpenAI instances.

- Client applications that must consistently authenticate users from multiple identity providers.

### Connect directly to Azure OpenAI

If the client applications in these scenarios directly connect to Azure OpenAI without using a gateway, they must use key-based authentication to authenticate to Azure OpenAI. Key-based authentication introduces extra security concerns. You must securely store and rotate keys, and you can't give different clients Azure role-based access control (Azure RBAC) configurations for individual model deployments.

### Introduce a gateway

:::image type="content" source="_images/azure-openai-gateway-identity-solution-external-identity-provider.svg" lightbox="_images/azure-openai-gateway-identity-solution-external-identity-provider.svg" alt-text="Diagram that shows a gateway between client apps and Azure OpenAI, which enables authentication with an external identity provider."border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

A gateway resolves this scenario's challenges in the following ways:

- The gateway uses Open Authorization (OAuth) to authenticate users via their existing external identity providers. The gateway validates the authenticated user access tokens, such as a JSON Web Token (JWT), that the identity provider generates. Then the gateway grants authorization to the backing Azure OpenAI instance.

- You don't need to manage client keys. This approach eliminates the security risks of key-based authentication.

- The gateway connects to Azure OpenAI by using a managed identity, which improves security via least-privileged Azure RBAC.

### Recommendations for this scenario

- Add more OAuth scopes to your application registration in your identity provider to enable granular permission to consumers. These scopes enable client applications to request permission to do specific operations in your gateway, including [access to Azure OpenAI](/azure/api-management/api-management-authenticate-authorize-azure-openai#oauth-20-authorization-using-identity-provider).

- Configure this scenario for API Management by using inbound policies. Use the [`validate-jwt` policy](/azure/api-management/validate-jwt-policy) to enforce the existence, validity, and attribute values of a supported JWT.

### Reasons to avoid a gateway for this scenario

If a single intelligent application accesses Azure OpenAI, it's easier to configure user authentication and authorization within the app rather than through the gateway. Use this approach to assign the necessary Azure RBAC to securely authenticate the intelligent application with Azure OpenAI.

## Authenticate client applications via certificates

:::image type="content" source="_images/azure-openai-gateway-identity-scenario-client-certificates.svg" lightbox="_images/azure-openai-gateway-identity-scenario-client-certificates.svg" border="false" alt-text="Diagram that shows an architecture to authenticate users via certificates.":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

### Scenario constraints

This scenario has the following constraints:

- You want to use certificates to authenticate client applications.

- Client applications can't use, or you don't want to use, Microsoft Entra ID or other OIDC providers for authentication.

- Clients can't use, or you don't want to use, federated identity for authentication.

These constraints can apply to the following examples:

- A client that authenticates to Azure OpenAI is a machine or device and no user interaction occurs.

- Your organization requires that you use certificates for authentication because of security standards and compliance regulations.

- You want to provide multiple client applications with options to authenticate based on their environment, including using client certificates.

### Connect directly to Azure OpenAI

Azure OpenAI doesn't natively support client certification authentication. To support this scenario without a gateway, the intelligent application needs to use certificate authentication for the user and either an API key or managed identity to authenticate requests to the Azure OpenAI instance. You must implement the certificate authentication logic in every client. In this scenario, key-based authentication introduces risks and management overhead if you connect directly to Azure OpenAI from clients.

### Introduce a gateway

:::image type="content" source="_images/azure-openai-gateway-identity-solution-client-certificates.svg" lightbox="_images/azure-openai-gateway-identity-solution-client-certificates.svg" alt-text="Diagram that shows a gateway between clients and Azure OpenAI that uses a managed identity with Azure RBAC." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

You can introduce a gateway into this architecture that offloads client certification validation from the clients. The gateway [validates the client digital certificate](/azure/api-management/api-management-howto-mutual-certificates-for-clients#policy-to-validate-client-certificates) that the intelligent application presents and checks the issuer, expiration date, thumbprint, and revocation lists. The gateway should use a managed identity to authenticate itself with Azure OpenAI. The gateway should also use Azure Key Vault to store the root certificate authority (CA). Use this approach to centralize client certificate validation, which reduces maintenance overhead.

A gateway provides several advantages in this scenario:

- You use the managed identity of the gateway instead of access keys, which eliminates the risk stolen keys and reduces the maintenance burden of key rotation.

- You can centralize certificate validation, which ensures that you use consistent security policies to evaluate client digital certificates for all intelligent applications.

- You can offload certificate validation to the gateway, which simplifies client code.

### Recommendations for this scenario

- Verify the entire certificate chain, including the root CA and intermediate certificates, when you validate certificates. Full verification ensures the authenticity of the certificate and prevents unauthorized access.

- Rotate and renew client certificates regularly to minimize the risk of certificate compromise. Use Key Vault to automate this process and keep certificates up to date. Set alerts for upcoming certificate expirations to prevent service disruptions at the gateway.

- Implement mutual Transport Layer Security (mTLS) to ensure that both the client and server authenticate each other. This strategy provides an extra layer of security. To configure the gateway to enforce mTLS,  set the appropriate policies and constraints.

- Use the [`validate-client-certificate` policy](/azure/api-management/api-management-howto-mutual-certificates-for-clients) in API Management to validate client certificates that an Azure Key Vault references. This policy validates the client certificate that the client application presents and checks the issuer, expiration date, thumbprint, and revocation lists.

### Reasons to avoid a gateway for this scenario

In simple environments that have few clients, the cost of handling security and certificate management in the client can outweigh the added complexity of introducing a gateway. Also, gateways can become single points of failure, increase latency because of added layers, and lead to vendor lock-in if you choose commercial solutions rather than custom implementations.

You must carefully assess your specific needs, resource availability, and the criticality of your applications before you implement a gateway for client certificate authentication.

## Authenticate multiple client applications via keys to access a shared Azure OpenAI instance

:::image type="content" source="_images/azure-openai-gateway-identity-scenario-multiple-clients.svg" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-clients.svg" alt-text="Diagram of multiple client apps authenticating with Azure OpenAI via a shared API key." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

### Scenario constraints

This scenario has the following constraints:

- Multiple client applications access a shared Azure OpenAI instance.
- Clients can't use, or you don't want to use, Microsoft Entra ID for authentication.
- Clients can't use, or you don't want to use, federated identity for authentication.
- You want to use key-based authentication for client applications.

These constraints can apply to the following examples:

- You deploy client applications across multiple environments, including Azure, on-premises, or other cloud providers.

- An organization needs to provide Azure OpenAI to different teams and set unique access and usage limits for each team.

### Connect directly to Azure OpenAI

Azure OpenAI supports key-based authentication via shared keys. Azure OpenAI exposes a primary key and a secondary key. The purpose of the secondary key is to support key rotation. It doesn't provide client identity isolation. When you authenticate multiple clients directly to Azure OpenAI in this scenario, each client shares the same key. This implementation has the following challenges:

- You can't revoke permissions for specific clients because every client shares the same key.

- You can't give different clients different access rights to different models in the same Azure OpenAI instance deployment.

- You can't differentiate one client from another from a logging perspective.

### Introduce a gateway

:::image type="content" source="_images/azure-openai-gateway-identity-solution-multiple-clients.svg" lightbox="_images/azure-openai-gateway-identity-solution-multiple-clients.svg" alt-text="Diagram that shows a gateway between multiple clients and Azure OpenAI that uses subscription keys per client and managed identity authentication." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

You can introduce a gateway into this architecture that issues a dedicated key to each client application. API Management uses the concept of [subscriptions](/azure/api-management/api-management-subscriptions) to provide dedicated client keys. The gateway should use a managed identity to authenticate itself with Azure OpenAI.

A gateway provides several advantages in this scenario:

- You can revoke access to a single client application without affecting other clients.

- You don't need to update all the client's key configurations before you rotate keys, so key rotation is logistically easier. You can rotate the dedicated keys for each client after you update the client configuration.

- You can uniquely identify each client from a logging perspective.

- The gateway enforces rate limits and quotas for each client independently.

### Recommendations for this scenario

- Enhance monitoring on metrics that are related to API requests. When you use a managed identity from a gateway, the traceability of the user and client application in Azure OpenAI logs doesn't improve. The gateway should provide logging associated with the request, such as the requesting client and user IDs.

- Ensure that the gateway makes routing decisions to appropriate model deployments based on the client identity when you route multiple client application requests through a gateway to a shared Azure OpenAI instance. For more information, see [Use a gateway in front of multiple Azure OpenAI deployments](./azure-openai-gateway-multi-backend.yml).

## Authenticate client applications that access multiple Azure OpenAI instances

:::image type="content" source="_images/azure-openai-gateway-identity-scenario-multiple-services.svg" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-services.svg" alt-text="Diagram that shows client applications that authenticate with multiple Azure OpenAI instances via shared API keys per instance." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

### Scenario constraints

This scenario has the following constraints:

- Client applications connect to multiple Azure OpenAI instances in one or more regions.
- Clients can't use, or you don't want to use, Microsoft Entra ID or other OIDC providers for authentication.
- You want to use key-based authentication for client applications.

These constraints can apply to the following examples:

- Client applications must distribute their workloads geographically to reduce latency and improve performance.

- Client applications attempt to optimize their tokens per minute quotas by deploying instances across multiple regions.

- An organization requires minimal downtime failover and disaster recovery capabilities to ensure continuous operation. So they manage a dual-deployment strategy, such as a strategy that consists of a provisioned throughput deployment and a pay-as-you-go deployment.

- Client applications must use specific model capabilities that are only available in certain Azure regions.

### Connect directly to multiple Azure OpenAI instances

When client applications connect directly to multiple Azure OpenAI instances, each client must store the key for each instance. Along with the security considerations of using keys, there's an increased management burden regarding rotating keys.

### Introduce a gateway

:::image type="content" source="_images/azure-openai-gateway-identity-solution-multiple-services.svg" lightbox="_images/azure-openai-gateway-identity-solution-multiple-services.svg" alt-text="Diagram of a gateway with a single key to a client application and managed identity authentication to Azure OpenAI with Azure RBAC." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

When you use a gateway to handle client applications that access multiple Azure OpenAI deployments, you get the same benefits as a gateway that handles [multiple client applications via keys to access a shared Azure OpenAI instance](#authenticate-multiple-client-applications-via-keys-to-access-a-shared-azure-openai-instance). You also streamline the authentication process because you use a single user-defined managed identity to authenticate requests from the gateway to multiple Azure OpenAI instances. Implement this approach to reduce overall operational overhead and minimize the risks of client misconfiguration when you work with multiple instances.

An example of how a gateway is being used in Azure to offload identity to an intermediary is the Azure AI Services resource. In that implementation, you authenticate to the gateway, and the gateway handles authenticating to the differing Azure AI services such as Custom Vision or Speech. While that implementation is similar, it does not address this scenario.

### Recommendations for this scenario

- Implement load balancing techniques to distribute the API requests across multiple instances of Azure OpenAI to handle high traffic and ensure high availability. For more information, see [Use a gateway in front of multiple Azure OpenAI deployments or instances](./azure-openai-gateway-multi-backend.yml).

- Correlate token usage for each tenant at the gateway when you implement multitenant scenarios with multiple Azure OpenAI instances. This approach ensures that you track total token usage, regardless of the back-end Azure OpenAI instance that the request is forwarded to.

## General recommendations

When you integrate Azure OpenAI through a gateway, there are several cross-cutting recommendations to consider that apply in all scenarios.

Use Azure API Management instead of creating your own solution for API orchestration, integration with other Azure services, and cost savings by reducing development and maintenance efforts. API Management ensures secure API management by directly supporting authentication and authorization. It integrates with identity providers, such as Microsoft Entra ID, which enables OAuth 2.0 and provides policy-based authorization. Additionally, API Management uses managed identities for secure and low-maintenance access to Azure OpenAI.

### Combine scenarios for a comprehensive gateway solution

In real-world applications, your use cases can span multiple scenarios from this article. For example, you might have client applications that authenticate through an external identity provider and require access to multiple Azure OpenAI instances.

:::image type="content" source="_images/azure-openai-gateway-identity-solution-combined.svg" lightbox="_images/azure-openai-gateway-identity-solution-combined.svg" alt-text="Diagram that shows client applications authenticating with an external identity provider through a gateway, which has access to multiple Azure OpenAI instances." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-authentication.vsdx) of this architecture.*

To build a gateway that supports your specific requirements, combine the recommendations from these scenarios for a comprehensive approach.

### Enforce gateway policies

Before a gateway sends requests to Azure OpenAI instances, make sure you enforce inbound authentication and authorization policies. To ensure that the gateway only forwards authenticated and authorized requests, use user access tokens from an identity provider or certificate validation to implement this approach.

To enable granular control, implement more authorization scoping with roles and permissions for client applications in your gateway. Use these scopes to permit specific operations based on the client application's needs. This approach enhances security and manageability.

For access token validation, be sure to validate all key registered claims such as `iss`, `aud`, `exp`, and `nbf` and any relevant workload-specific claims such as group memberships or application roles.

### Use Azure managed identities

To simplify authentication across all client application scenarios, use Azure managed identities to centralize authentication management. This approach reduces the complexity and risks that are associated with managing multiple API keys or credentials in client applications.

Managed identities inherently support Azure RBAC, so they ensure that the gateway only has the lowest level of permissions necessary to access Azure OpenAI instances. To reduce the risk of unauthorized access and simplify compliance with security policies, combine managed identities with other methods that disable alternative authentication.

### Implement comprehensive observability

When you implement a gateway with a managed identity, it reduces traceability because the managed identity represents the gateway itself, not the user or the application that makes the request. Therefore, it's essential to improve observability on metrics that are related to API requests. To maintain visibility over access patterns and usage, gateways should provide more tracing metadata, such as the requesting client and user IDs.

Centralized logging of all requests that pass through the gateway helps you maintain an audit trail. A centralized audit trail is especially important for troubleshooting, compliance, and detecting unauthorized access attempts.

### Address caching safely

If your API gateway is responsible for caching completions or other inferencing results, make sure the identity of the requestor is considered in the cache logic. Do not return cached results for identities that are not authorized to receive that data.

## Gateway implementations

Azure doesn't provide a complete turnkey solution or reference architecture to build the gateway in this article, so you must build and operate the gateway. Azure API management can be used to build a PaaS based solution through built-in and custom policies. Azure also provides examples of community-supported implementations that cover the use cases in this article. Reference these samples when you build your own gateway solution. For more information, see the video [Learn Live: Azure OpenAI application identity and security](https://www.youtube.com/live/pDjXsNWYmvo).

## Contributors

*The following contributors originally wrote this article.*

Principal authors:

- [Lizet Pena De Sola](https://www.linkedin.com/in/lizetp/) | Senior Customer Engineer, FastTrack for Azure
- [Bappaditya Banerjee](https://www.linkedin.com/in/bappaditya-banerjee-8860ba7/) | Senior Customer Engineer, FastTrack for Azure
- [James Croft](https://www.linkedin.com/in/jmcroft/) | Customer Engineer, ISV & Digital Native Center of Excellence

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure RBAC for Azure OpenAI](/azure/ai-services/openai/how-to/role-based-access-control)
- [Use managed identities in API Management](/azure/api-management/api-management-howto-use-managed-service-identity)
- [Policies in API Management](/azure/api-management/api-management-howto-policies)
- [Authentication and authorization to APIs in API Management](/azure/api-management/authentication-authorization-overview)
- [Protect an API in API Management by using OAuth 2.0 and Microsoft Entra ID](/azure/api-management/api-management-howto-protect-backend-with-aad)
- [Secure back-end services by using client certificate authentication in API Management](/azure/api-management/api-management-howto-mutual-certificates)

## Related resources

- [Access Azure OpenAI and other language models through a gateway](./azure-openai-gateway-guide.yml#key-challenges)
- [Design a well-architected AI workload](/azure/well-architected/ai/get-started)
