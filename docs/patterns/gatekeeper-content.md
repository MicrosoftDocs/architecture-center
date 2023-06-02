Protect applications and services by using a dedicated host instance to broker requests between clients and the application or service. The broker validates and sanitizes the requests, and can provide an additional layer of security and limit the system's attack surface.

## Context and problem

Cloud services expose endpoints that allow client applications to call their APIs. The code used to implement the APIs triggers or performs several tasks, including but not limited to authentication, authorization, parameter validation, and some or all request processing. The API code is likely to access storage and other services on behalf of the client.

If a malicious user compromises the system and gains access to the application's hosting environment, its security mechanisms and access to data and other services are exposed. As a result, the malicious user can gain unrestricted access to credentials, storage keys, sensitive information, and other services.

## Solution

One solution to this problem is to decouple the code that implements public endpoints, from the code that processes requests and accesses storage. You can achieve decoupling by using a façade or a dedicated task that interacts with clients and then hands off the request&mdash;perhaps through a decoupled interface&mdash;to the hosts or tasks that handle the request. The figure provides a high-level overview of this pattern.

![High-level overview of this pattern](./_images/gatekeeper-diagram.png)

The gatekeeper pattern can be used to protect storage, or it can be used as a more comprehensive façade to protect all of the functions of the application. The important factors are:

- **Controlled validation**. The gatekeeper validates all requests, and rejects requests that don't meet validation requirements.
- **Limited risk and exposure**. The gatekeeper doesn't have access to the credentials or keys used by the trusted host to access storage and services. If the gatekeeper is compromised, the attacker doesn't get access to these credentials or keys.
- **Appropriate security**. The gatekeeper runs in a limited privilege mode, while the rest of the application runs in the full trust mode required to access storage and services. If the gatekeeper is compromised, it can't directly access the application services or data.

This pattern acts like a firewall in a typical network topography. It allows the gatekeeper to examine requests and make a decision about whether to pass the request on to the trusted host that performs the required tasks. This decision typically requires the gatekeeper to validate and sanitize the request content before passing it on to the trusted host.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

- Ensure that the trusted hosts expose only internal or protected endpoints, used only by the gatekeeper. The trusted hosts shouldn't expose any external endpoints or interfaces.
- The gatekeeper must run in a limited privilege mode, which typically requires running the gatekeeper and the trusted host in separate hosted services or virtual machines.
- The gatekeeper shouldn't perform any processing related to the application or services or access any data. Its function is purely to validate and sanitize requests. The trusted hosts might need to perform additional request validation, but the gatekeeper should perform the core validation.
- Use a secure communication channel (HTTPS, SSL, or TLS) between the gatekeeper and the trusted hosts or tasks where possible. However, some hosting environments don't support HTTPS on internal endpoints.
- Adding the extra layer to implement the gatekeeper pattern will likely impact performance due to the additional processing and network communication required.
- The gatekeeper instance could be a single point of failure. To minimize the impact of a failure, consider deploying redundant instances and using an autoscaling mechanism to ensure capacity to maintain availability.

## When to use this pattern

This pattern is helpful for applications that:

- handle sensitive information
- expose services that require a high degree of protection from malicious attacks
- perform mission-critical operations that can't be disrupted.
- require request validation be performed separately from the main tasks, or to centralize this validation to simplify maintenance and administration

## Example

In a cloud-hosted scenario, this pattern can be implemented by decoupling the gatekeeper role or virtual machine, from the trusted roles and services in an application. The implementation can use an internal endpoint, a queue, or storage as an intermediate communication mechanism. The figure illustrates using an internal endpoint.

![An example of the pattern using Cloud Services web and worker roles](./_images/gatekeeper-endpoint.png)

## Related resources

The [Valet Key pattern](./valet-key.yml) might also be relevant when implementing the Gatekeeper pattern. When communicating between the Gatekeeper and trusted roles, it's a good practice to enhance security by using keys or tokens that limit permissions for accessing resources. The pattern describes using a token or key that provides clients with restricted, direct access to a specific resource or service.
