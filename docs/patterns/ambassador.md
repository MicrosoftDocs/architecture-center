## Ambassador Pattern

Use the ambassador pattern to create helper services that make networking requests on behalf of a consumer service or application. An ambassador service can be thought of as an out of process proxy that is co-located with the client.

This pattern can be useful for offloading common client connectivity tasks such as monitoring, logging, routing, security (like TLS), and resiliency patterns in a language agnostic way. This is often used with legacy or other difficult to modify applications to extend networking capabilities, add metering and monitoring capabilities, and offload the creation and maintenance of connectivity features to more specialized team.

## Context and Problem

In many scenarios, it may be difficult for applications or services to make direct network calls to external resources, or to access external functionality reliably in a cloud environment. Updating legacy or rigid applications and libraries to add the types of features may be impossible, due to the code no longer being maintained or otherwise not easily modifiable by your team.

Resilient cloud-based applications require features such as circuit breaking, routing, and the ability to make network related configuration updates in cloud and cluster environments. Metering and monitoring capabilities are also commonly required features in a cloud environment that legacy and rigid applications may not support. 

Network calls may also require substantial connection, authentication, and authorization configuration. If these calls are used across multiple applications, built using multiple languages and frameworks, the calls need to be configured for each of these instances. In addition, network and security functionality may need to be managed by a central team within your organization, leading to the need for them to make changes and updates to app code that they may be unfamiliar with.

## Solution

Use the ambassador pattern to put client frameworks and libraries into an external process and use it as a proxy to communicate between your application and external calls. Deploy this proxy on the same host environment as your application to allow control over routing, resiliency, security features, and to avoid any host-related access restrictions.

An ambassador pattern can also standardize and extend instrumentation. By placing a proxy near your application, monitoring the performance of things like latency or resource usage can be measured in the same way as your application experiences it. 

![](./_images/ambassador.png)

Features offloaded from your application to the ambassador can be managed completely independently. They can be updated and modified without need to disturb the legacy functionality. This independence can allow separate, potentially more specialized, teams to take over the creation and maintenance of key security, networking and authentication features that have been moved to the ambassador.

Ambassador services can be deployed using a sidecar model to accompany the lifecycle of your consuming application or service. If it will be shared by multiple separate processes on a common host, ambassadors can also be deployed as daemons. When being consumed by a containerized service, the ambassador should be created as a separate container on the same host, with the appropriate links configured for easy communication.

## Issues and Considerations

- Consider the potential overhead a proxy might add in terms of latency, and whether or not a client library would be a better approach.
- Consider the impact general features may have on the client. For example, if an operation is not idempotent (does not produce the exact same results each time it's executed), it may not be possible for a client to successfully retry that operation.
- Consider a mechanism that will allow the client to pass some context to the proxy as well as back to the client. This could be in the form of HTTP request and response headers to opt in or out of retry or the number of times the operation is to be retried.
- Consider the packaging and deployment approach for the ambassador proxy to use, and whether or not you will have a single shared instance for all clients or an instance for each client.

## When to use this pattern

Use this pattern when you:

- Need to build a common set of client connectivity features for multiple languages or frameworks
- Need to offload cross-cutting client connectivity concerns to infrastructure developers or other more specialized teams
- Need to support cloud or cluster connectivity requirements in a legacy or rigid application

This pattern may not be suitable:

- When network request latency is critical. A proxy will introduce some overhead, although minimal, and in some cases this may affect the application.
- When client connectivity features are consumed by a single language in the organization. A client library distributed through the languages package management may be a better approach.
- When connectivity features cannot be generalized and require deeper integration with the client application.

## Example

The following diagram shows an application making a request to a remote service via an ambassador proxy. The ambassador provides routing, circuit breaking, and logging functionality, calls the remote service, and then returns the response to the client application:

![](./_images/ambassador-example.png) 

## Related guidance

Sidecar pattern

