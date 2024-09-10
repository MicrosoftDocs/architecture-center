Intelligent applications that use Azure OpenAI services through native Azure platforms provide seamless user authentication and authorization. However, some scenarios are complex and require different architecture designs. These scenarios include topologies that have client applications not hosted on Azure, the use of external identity providers, and the deployment of multiple clients that access the same Azure OpenAI instances. In these scenarios, adding a gateway in front of Azure OpenAI can provide significant security improvements by adding a layer that ensures consistency in authentication to deployed instances.

This article describes the key scenarios when you authenticate with Azure OpenAI services:

- [Client applications authenticated via an external identity provider](#client-applications-authenticated-via-an-external-identity-provider)

- [Client applications authenticated via certificates](#client-applications-authenticated-via-certificates)

- [Multiple client applications using keys to access a shared Azure OpenAI instance](#multiple-client-applications-using-keys-to-access-a-shared-azure-openai-instance)

- [Client applications accessing multiple Azure OpenAI instances](#client-applications-accessing-multiple-azure-openai-instances)

Each scenario describes the challenges that they introduce and the benefits of incorporating a gateway.

> [!IMPORTANT]
> You can use the following guidance for any gateway implementation, including Azure API Management. To illustrate this, the architecture diagrams use a generic representation of the component in most scenarios.

## Client applications authenticated via an external identity provider

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-external-identity-provider.png" lightbox="_images/azure-openai-gateway-identity-scenario-external-identity-provider.png" alt-text="Diagram that shows a conceptual architecture for solutions where client applications authenticate users with an external identity provider, and authenticate with Azure OpenAI by using API keys.":::
Diagram that shows a conceptual architecture for solutions where client applications authenticate users with an external identity provider, and authenticate with Azure OpenAI by using API keys.
:::image-end:::

### Scenario constraints

This scenario has the following constraints:

- Client applications use an external OpenID Connect (OIDC)-enabled identity provider such as Okta, Auth0, or social identity providers.

- Client applications authenticate against a Microsoft Entra tenant that's different than the Azure OpenAI data plane's tenant.

You can apply these constraints to scenarios where:

- Existing client applications that already authenticate against an external OIDC provider or Microsoft Entra ID integrate with Azure OpenAI instances.

- Client applications must consistently authenticate users from multiple identity providers.

### Connect directly to Azure OpenAI

If the client applications in these scenarios directly connect to Azure OpenAI without using a gateway, they must use key-based authentication to authenticate to Azure OpenAI. Key-based authentication poses extra security concerns that include securely storing and rotating the keys, and the inability to provide different clients with their own role-based access control (RBAC) configurations for individual model deployments.

### Introduce a gateway

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-external-identity-provider.png" lightbox="_images/azure-openai-gateway-identity-solution-external-identity-provider.png" alt-text="Diagram that shows the insertion of a gateway between client applications and Azure OpenAI, which enables authentication with an external identity provider.":::
Diagram that shows the insertion of a gateway between client applications and Azure OpenAI, which enables authentication with an external identity provider.
:::image-end:::

Introducing a gateway resolves the challenges of this scenario in the following ways:

- The gateway can use Open Authorization (OAuth) to authenticate users by using their existing external identity providers. The gateway validates the authenticated user access tokens, such as a JSON Web Token (JWT), that the identity provider generates. Then it grants authorization to the backing Azure OpenAI instance.

- Client key management is no longer needed, which eliminates the security risks of key-based authentication.

- The gateway can connect to Azure OpenAI by using a managed identity, which improves security via least-privileged Azure role-based access control (Azure RBAC).

### Recommendations for this scenario

- Add more OAuth scopes to your application registration in your identity provider to enable granular permission to consumers. These scopes enable client applications to request permission to perform specific operations in your gateway, including [access to Azure OpenAI](/azure/api-management/api-management-authenticate-authorize-azure-openai#oauth-20-authorization-using-identity-provider).

- Configure this scenario for API Management by using inbound policies. Use the [validate-jwt policy](/azure/api-management/validate-jwt-policy) to enforce the existence, validity, and attribute values of a supported JWT.

### Reasons to avoid a gateway for this scenario

If a single intelligent application accesses Azure OpenAI, it’s easier to configure user authentication and authorization within the app rather than through the gateway. You can use this approach to assign the necessary Azure RBAC to securely authenticate the intelligent application with Azure OpenAI.

## Client applications authenticated via certificates

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-client-certificates.png" lightbox="_images/azure-openai-gateway-identity-scenario-client-certificates.png" alt-text="Diagram that shows users being authenticated with client applications via client certificates, and authenticating with Azure OpenAI using API keys.":::
Diagram that shows users being authenticated with client applications via client certificates, and authenticating with Azure OpenAI using API keys.
:::image-end:::

### Scenario constraints

This scenario has the following constraints:

- You want to use certificates to authenticate client applications.

- Client applications can't use, or you don't want to use, Microsoft Entra ID or any OIDC providers for authentication.

- Clients can't use, or you don't want to use, federated identity for authentication.

These constraints can apply to the following scenarios:

- A client authenticating to Azure OpenAI services is a machine or device without user interaction.

- Your organization requires that you use certificates for authentication because of security standards and compliance regulations.

- You want to provide multiple client applications with options to authenticate based on their environment, including using client certificates.

### Connect directly to Azure OpenAI

Azure OpenAI doesn’t natively support client certification authentication. To support this scenario without a gateway, the intelligent application needs to use certificate authentication for the user and either an API key or managed identity to authenticate requests to the Azure OpenAI instance. Each client must implement the certificate authentication logic. If clients connect directly to Azure OpenAI in this scenario, they face the risks and management overhead of using key-based authentication.

### Introduce a gateway

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-client-certificates.png" lightbox="_images/azure-openai-gateway-identity-solution-client-certificates.png" alt-text="Diagram that shows the insertion of a gateway between client applications and Azure OpenAI using a managed identity with RBAC.":::
Diagram that shows the insertion of a gateway between client applications and Azure OpenAI using a managed identity with RBAC.
:::image-end:::

You can introduce a gateway into this architecture that offloads client certification validation from the clients. The gateway [validates the client digital certificate](/azure/api-management/api-management-howto-mutual-certificates-for-clients#policy-to-validate-client-certificates) presented by the intelligent application, including checks on the issuer, expiration date, thumbprint, and revocation lists. The gateway should use a managed identity to authenticate itself with Azure OpenAI. This approach ensures that client certificate validation is managed in a centralized location, which reduces maintenance overhead.

The advantages of introducing a gateway into this scenario include:

- Using the managed identity of the gateway instead of access keys eliminates the risk of keys being stolen and reduces the maintenance burden of key rotation.

- Centralizing certificate validation ensures that you're using consistent security policies to evaluate client digital certificates for all intelligent applications.

- Offloading certificate validation to the gateway to simplify client code.

### Recommendations for this scenario

- Verify the entire certificate chain, including the root CA and intermediate certificates, when you validate certificates. Full verification ensures the authenticity of the certificate and prevents unauthorized access.

- Rotate and renew client certificates regularly to minimize the risk of certificate compromise. Automate this process using Key Vault to ensure that certificates are always up to date. Set alerts for upcoming certificate expirations to prevent service disruptions at the gateway.

- Implement mutual TLS (mTLS) to ensure that both the client and server authenticate each other. This strategy provides an extra layer of security. Configure the gateway to enforce mTLS by setting appropriate policies and constraints.

- Validate client certificates by using API Management and the [validate-client-certificate policy](/azure/api-management/api-management-howto-mutual-certificates-for-clients) referenced in an Azure key vault. This policy validates the client certificate presented by the client application and checks the issuer, expiration date, thumbprint, and revocation lists.

### Reasons to avoid a gateway for this scenario

In simple environments that have few clients, the cost of handling security and certificate management in the client can outweigh the added complexity of introducing a gateway. Also, gateways can become single points of failure, increase latency because of added layers, and lead to vendor lock-in if you choose commercial solutions rather than custom implementations.

You must carefully assess your specific needs, resource availability, and the criticality of your applications before deciding to implement a gateway for client certificate authentication.

## Multiple client applications using keys to access a shared Azure OpenAI instance

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-multiple-clients.png" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-clients.png" alt-text="Diagram that shows a conceptual architecture for solutions where multiple client applications authenticate with Azure OpenAI via a shared API key.":::
Diagram that shows a conceptual architecture for solutions where multiple client applications authenticate with Azure OpenAI via a shared API key.
:::image-end:::

### Scenario constraints

This scenario has the following constraints:

- Multiple client applications access a shared Azure OpenAI instance.
- Clients can't use, or you don't want to use, Microsoft Entra ID for authentication.
- Clients can't use, or you don't want to use, federated identity for authentication.
- You want to use key-based authentication for client applications.

These constraints can apply to the following scenarios:

- When client applications are deployed across multiple environments, including Azure, on-premises, or other cloud providers.

- When organizations must provide Azure OpenAI services to different teams that have unique access and usage limits.

### Connect directly to Azure OpenAI

Azure OpenAI supports key-based authentication using shared keys. While Azure OpenAI exposes a primary key and a secondary key, the purpose of the secondary key is to support key rotation not for client identity isolation. When you authenticate multiple clients directly to Azure OpenAI in this scenario, each client shares the same key. This implementation has the following challenges:

- You don't have the ability to revoke permissions for specific clients because every client is sharing the same key.

- You can't give different clients different access rights to different models in the same Azure OpenAI instance deployment.

- You can't differentiate one client from another from a logging perspective.

### Introducing a gateway

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-multiple-clients.png" lightbox="_images/azure-openai-gateway-identity-solution-multiple-clients.png" alt-text="Diagram that shows a gateway between multiple clients and Azure OpenAI with subscription keys per client and managed identity authentication.":::
Diagram that shows a gateway between multiple clients and Azure OpenAI with subscription keys per client and managed identity authentication.
:::image-end:::

You can introduce a gateway into this architecture that issues a dedicated key to each client application. API Management uses the concept of [subscriptions](/azure/api-management/api-management-subscriptions) to provide dedicated client keys. The gateway should use managed identity to authenticate itself with Azure OpenAI.

There are several advantages to introducing a gateway to address this scenario, including:

- Access to a single client application can be revoked without affecting other clients.

- Key rotation becomes less logistically challenging because you don't need to update all clients key configuration before rotating them. You can rotate the dedicated keys for each client after the client configuration is updated.

- Each client can be uniquely identified from a logging perspective.

- The gateway becomes responsible for enforcing rate limits and quotas for each client independently.

### Recommendations for this scenario

- Enhance monitoring on metrics related to API requests because using a managed identity from a gateway doesn’t improve traceability of the user and client application in the Azure OpenAI logs. The gateway should provide logging associated with the request, such as the requesting client and user IDs.

- Ensure that the gateway makes routing decisions based on client identity to appropriate model deployments when you route multiple client application requests through a gateway to a shared Azure OpenAI service. For more information, see [Using a gateway in front of multiple Azure OpenAI deployments](./azure-openai-gateway-multi-backend.yml).

## Client applications accessing multiple Azure OpenAI instances

:::image type="complex" source="_images/azure-openai-gateway-identity-scenario-multiple-services.png" lightbox="_images/azure-openai-gateway-identity-scenario-multiple-services.png" alt-text="Diagram that shows client applications authenticating with multiple Azure OpenAI instances using shared API keys per instance.":::
Diagram that shows client applications authenticating with multiple Azure OpenAI instances using shared API keys per instance.
:::image-end:::

### Scenario constraints

This scenario has the following constraints:

- Client applications are connecting to multiple Azure OpenAI instances in one or more regions.
- Clients can't use, or you don't want to use, Microsoft Entra ID or any OIDC providers for authentication.
- You want to use key-based authentication for client applications.

These constraints can apply to scenarios where:

- Client applications must distribute their workloads geographically to reduce latency and improve performance.

- Client applications attempt to optimize their tokens per minute (TPM) quotas by deploying instances across multiple regions.

- Organizations require seamless failover and disaster recovery capabilities to ensure continuous operation by managing a dual deployment strategy, potentially consisting of a provisioned throughput deployment and a pay-as-you-go deployment.

- Client applications must use specific model capabilities that are only available in certain Azure regions.

### Connect directly to multiple Azure OpenAI instances

When client applications connect directly to multiple OpenAI instances, each client must store the key for each instance. Along with the security considerations of using keys, there's an increased management burden regarding rotating keys.

### Introduce a gateway

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-multiple-services.png" lightbox="_images/azure-openai-gateway-identity-solution-multiple-services.png" alt-text="Diagram of a gateway with a single key to a client application and managed identity authentication to Azure OpenAI with RBAC.":::
Diagram of a gateway with a single key to a client application and managed identity authentication to Azure OpenAI with RBAC.
:::image-end:::

Introducing a gateway to handle client applications accessing multiple Azure OpenAI deployments has the same benefits covered by introducing a gateway to handle [multiple client applications using keys to access a shared Azure OpenAI instance](#multiple-client-applications-using-keys-to-access-a-shared-azure-openai-instance). In addition to those reasons, by using a single user-defined managed identity to authenticate requests from the gateway to multiple Azure OpenAI instances, the process for authentication is streamlined. Implementing this approach reduces the overall operational overhead and minimizes the risks of misconfiguration of the client when working with multiple instances.

### Recommendations for this scenario

- Implement load balancing techniques to distribute the API requests across multiple instances of the Azure OpenAI service to handle high traffic and ensure high availability. For more information on this implementation, see [Using a gateway in front of multiple Azure OpenAI deployments or instances](./azure-openai-gateway-multi-backend.yml).

- Correlate token usage for each tenant at the gateway when you implement multitenant scenarios with multiple Azure OpenAI instances. This approach ensures that you’re tracking total token usage, regardless of the backend Azure OpenAI instance that the request is forwarded to.

## General recommendations

When you integrate Azure OpenAI services through a gateway, there are several cross-cutting recommendations to consider that apply in all scenarios.

Use API Management instead of creating your own solution for efficient API orchestration, seamless integration with other Azure services, and cost savings by reducing development and maintenance efforts. API Management ensures secure API management by directly supporting authentication and authorization. It integrates with identity providers, such as Microsoft Entra ID, which enables OAuth 2.0 and provides policy-based authorization. Additionally, API Management can take advantage of managed identities for secure and low-maintenance access to Azure OpenAI.

### Combine scenarios for a comprehensive gateway solution

In real-world applications, your use cases can span multiple scenarios described in this article. For example, you might have client applications that authenticate through an external identity provider and require access to multiple Azure OpenAI instances.

:::image type="complex" source="_images/azure-openai-gateway-identity-solution-combined.png" lightbox="_images/azure-openai-gateway-identity-solution-combined.png" alt-text="Diagram that shows client applications authenticating with an external identity provider via a gateway that has access to multiple Azure OpenAI instances.":::
Diagram that shows client applications authenticating with an external identity provider via a gateway that has access to multiple Azure OpenAI instances.
:::image-end:::

To build a gateway that supports your specific requirements, combine the recommendations from these scenarios for a comprehensive approach.

### Gateway policy enforcement

Before requests to Azure OpenAI instances are sent via a gateway, inbound authentication and authorization policies should be enforced. To ensure that only authenticated and authorized requests are forwarded, implement this approach by using user access tokens from an identity provider or certificate validation.

To enable granular control, implement more authorization scoping with roles and permissions for client applications in your gateway. These scopes enable specific operations based on the client application’s needs, which enhance security and manageability.

For access token validation, be sure to validate all key registered claims such as `iss`, `aud`, `exp`, and `nbf` and any relevant workload-specific claims such as group memberships or application roles.

### Use Azure-managed identities

To simplify authentication across all client application scenarios, use Azure-managed identities to centralize authentication management. This approach reduces the complexity and risks associated with managing multiple API keys or credentials in client applications.

Because managed identities inherently support Azure RBAC, they ensure that the gateway only has the lowest level of permissions necessary to access Azure OpenAI instances. To reduce the risk of unauthorized access and simplify compliance with security policies, combine managed identities with the disabling of alternative authentication methods.

### Implement comprehensive observability

When you implement a gateway with a managed identity, it reduces traceability because the managed identity represents the gateway itself, not the end-user, or the application that made the request. Therefore, it's essential to improve observability on metrics related to API requests. To maintain visibility over access patterns and usage, gateways should include more tracing metadata, such as the requesting client and user IDs.

Centralized logging of all requests that pass through the gateway helps you maintain an audit trail. A centralized audit trail is especially important for troubleshooting, compliance, and ensuring that you can detect unauthorized access attempts.

## Gateway implementations

Azure doesn't provide a turnkey solution or reference architecture for building this type of gateway, so you must build and operate this gateway. The following are examples of community-supported implementations that cover the use cases mentioned previously. Consider referencing these samples when you build your own gateway solution.

| Implementation  | Example |
| :-------- | :--------- |
| Azure OpenAI application identity and security – Learn Live webinar | [Learn Live: Azure OpenAI Application identity and security](https://www.youtube.com/live/pDjXsNWYmvo) |

## Next step

When you implement a gateway for your workload, you gain benefits beyond improving authentication and authorization that are described in this article. For more information, see [Access Azure OpenAI and other language models through a gateway](./azure-openai-gateway-guide.yml#key-challenges).

## Contributors

*The following contributors originally wrote this article.*

Principal authors:

- [Lizet Pena De Sola](https://www.linkedin.com/in/lizetp/) | Senior Customer Engineer, FastTrack for Azure
- [Bappaditya Banerjee](https://www.linkedin.com/in/bappaditya-banerjee-8860ba7/) | Senior Customer Engineer, FastTrack for Azure
- [James Croft](https://www.linkedin.com/in/jmcroft/) | Customer Engineer, ISV & Digital Native Center of Excellence

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [RBAC for Azure OpenAI](/azure/ai-services/openai/how-to/role-based-access-control)
- [Use managed identities in API Management](/azure/api-management/api-management-howto-use-managed-service-identity)
- [Policies in API Management](/azure/api-management/api-management-howto-policies)
- [Authentication and authorization to APIs in API Management](/azure/api-management/authentication-authorization-overview)
- [Protect an API in API Management by using OAuth 2.0 and Microsoft Entra ID](/azure/api-management/api-management-howto-protect-backend-with-aad)
- [Secure API Management backend by using client certificate authentication](/azure/api-management/api-management-howto-mutual-certificates)
