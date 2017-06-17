# Gateway Offload Pattern

Offload shared or specialized service functionality to a gateway proxy. This pattern can simplify application development by moving shared service functionality, such as the use of SSL certificates, to a gateway proxy, simplifying application management.

## Context and Problem

Some features are commonly used across multiple services, and these features require configuration, management and maintenance. A shared or specialized service that is distributed with every application deployment increases administrative overhead and increases the likelihood of deployment error. Any update to a shared or specialized service or feature will require deploying that update to all instances of the service. 

Properly handling security issues (token validation, encryption, SSL certificate management, etc...) and other complex tasks can require team members to have highly specialized skills.
For instance, a certificate needed by an application must be configured and deployed on all application instances. With each new deployment of the application, the certificate must be managed to ensure that it does not expire. Any common certificate that is due to expire must be updated, tested and verified on every application deployment.

Other common services such as authentication, authorization, logging, monitoring or throttling can be difficult to implement and manage across a large number of deployments, requiring each of these features to be provisioned on each application deployment separately. It may be better to consolidate this type of functionality to reduce overhead and reduce the likelihood of errors.

## Solution

Offload features of the application into an API gateway. The application may no longer need to be concerned with cross-cutting concerns such as managing certificates, authentication implementation, or some logging and security concerns once the API gateway is in place.

Gateway offload is often used to offload SSL, authentication, monitoring, protocol translation, throttling and other functionality. The following diagram shows an API gateway which terminates inbound SSL connections and requests data on behalf of the original requestor from any HTTP server upstream of the API gateway.

 ![](./_images/gateway-offload.png)
 
The service also has a broader perspective. Implementing the gateway offload pattern commonly simplifies the development of services by removing the requirement to distribute and maintain supporting resources such as web server certificates and configuration for secure websites. Simpler configuration results in easier management and scalability and makes service upgrades much simpler.

Offloading features that take specialized skillset to implement properly, such as security, can let you hand maintenance of those features over to specialized teams that can focus on those issues. This allows your core team to focus on functionality within your application rather than common security features better handled by experts.

This pattern can also ensure some consistency or at least a minimum bar for request or response logging and monitoring. Even if a service is not correctly instrumented, the gateway could be configured to ensure a minimum level of monitoring and logging.

## Issues and Considerations

When using the Gateway Offload pattern, consider the following points:

- Ensure your API gateway is highly available and resilient to failure. Avoid single points of failure in your application by running multiple instances of your API gateway. 
- When implementing the gateway offload pattern, ensure the gateway is architected for the capacity and scaling requirements of your application and endpoints. Make certain that the gateway does not become a bottleneck for the application and is sufficiently scalable.
- Business logic should never be offloaded to the API gateway. Offloaded functionality should only include features used by the entire application, such as security or data transfer.
- If you need to track transactions, consider generating correlation IDs for logging purposes.

## When to Use this Pattern

Use this pattern when:

- An application deployment has a shared concern such as SSL certificates or encryption.
- A feature that is common across application deployments that may have different resource requirements, such as memory resources, storage capacity or network connections.
- You wish to move the responsibility for issues such as network security, throttling, or other network boundary concerns to a more specialized team.

This pattern may not be suitable:

- When the introduction of the gateway offload pattern introduces coupling across services.

## Example

Using Nginx as the SSL offload appliance, the following configuration terminates an inbound SSL connection and distributes the connection to one of three upstream HTTP servers.

```
upstream iis {
    	server  10.3.0.10    max_fails=3 	fail_timeout=15s;
    	server  10.3.0.20    max_fails=3 	fail_timeout=15s;
    	server  10.3.0.30    max_fails=3 	fail_timeout=15s;
}

server {
    	listen 443;
    	ssl on;
    	ssl_certificate /etc/nginx/ssl/domain.cer;
    	ssl_certificate_key /etc/nginx/ssl/domain.key;

    	location / {
            	set $targ iis;
            	proxy_pass http://$targ;
            	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            	proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Real-IP $remote_addr;
            	proxy_set_header Host $host;
    	}
}
```

## Related guidance

- Backend for Frontend
- Gateway Routing
- Gateway Aggregation
- Throttling

