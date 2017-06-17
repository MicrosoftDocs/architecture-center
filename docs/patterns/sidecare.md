# Sidecar Pattern

Deploy components of an application into a separate process or container using the sidecar pattern to provide isolation, encapsulation, and to enable applications composed of heterogeneous components and technologies.

Like a sidecar that is attached to a motorcycle, the sidecar pattern is attached to a parent application that it provides supporting features for. The sidecar also shares the same fate as its companion application, being created and retired alongside the parent. The sidecar pattern is sometimes referred to as the sidekick pattern and is a decomposition pattern.

## Context and Problem

Applications and services often require related functionality, such as monitoring, logging, configuration, and networking services. These peripheral tasks can be implemented as separate components or services, but if they are tightly integrated into an application they usually need to be implemented using the same language, and as a result the component and application have close inter-dependence on the other. While this means that they run in the same process, making efficient use of shared resources, they are not well isolated, and an outage in one of these components can affect other components or the entire application.

On the other hand, when applications are decomposed into multiple services, each service can be built using different languages or technology, providing the best tool for the job. While this allows you to choose the right language for each component of the application, each component has its own dependencies and requires the use of language specific libraries to access the underlying platform and any resources shared with the parent application. In addition, deploying these features as separate services can introduce additional latency to the application.

Managing the code and dependencies for all these language-specific interfaces can also introduce considerable complexity, which introduces separate hosting, deployment, and management concerns.

## Solution

Use the sidecar pattern to co-locate a cohesive set of tasks with the primary application and place them into their own process or container, providing a homogeneous interface for platform services across languages. 

![](./_images/sidecar.png)

A sidecar service is not necessarily part of the application, but connected to it and will go wherever the application it’s attached to goes. Sidecar are supporting/dependent process/services that are deployed with the primary application.

A sidecar is attached to one motorcycle and will share the road with many motorcycles each having their own sidecars. In the same way, a sidecar service shares the fate of its parent application. For each instance of the main application, an instance of the sidecar is deployed and hosted alongside it's companion. 

Sidecar is independent from its primary application in terms of runtime environment and programming language, so there’s no need to develop one sidecar per language. The sidecar is ‘attached’ to its primary application in terms of resource sharing, so it can access the same resources as the primary application. For example, a sidecar can monitor system resources used by both the sidecar and primary application. 

Because of its proximity to primary application, there’s no significant latency incurred when communicating between them.

Even for applications that don’t provide an extensibility mechanism, sidecars can be used to extend functionality by attaching it as own process in the same host or sub-container as the primary application.

The sidecar pattern is often used with containers and referred to as a sidecar container. This is also commonly referred to as a sidekick container. 

## Issues and Considerations

- Consider the deployment and packaging format you use to deploy services, processes or containers. Containers are a useful technology in general and are particularly suited to the sidecar pattern.
- When designing a sidecar service, carefully decide on the mechanism you use for inter-process communication. Try to use language or framework agnostic technologies unless performance requirements require something else.
- Consider if the features you want to deploy as a sidecar would work better as a separate service.
- Consider whether the features you want to deploy as a sidecar aren't better suited to a more traditional daemon.
- Consider whether or not functionality or tasks can be implemented as a library or using a traditional extension mechanism. Language specific libraries may have a deeper level of integration and less network overhead.

## When to Use this Pattern

Use this pattern when:

- A heterogenous set of languages and frameworks are used in your primary application. A sidecar service allows you to create a component that can be consumed by applications written in different languages using different frameworks.
- The component is owned by a remote team or different organization.
- The component or feature must be co-located on the same host as the application
- You need a service with the same overall fate as your main application, but that can still be independently updated.
- You need fine grained control over resource limits for a particular resource or component. For example, you may want to restrict the amount of memory a specific component uses, so you can deploy that component as a sidecar and manage memory usage independent of the main application.

This pattern may not be suitable:

- When inter-process communication needs to be optimized. Communications between a parent application and sidecar services include some overhead, notably latency in the calls. This may not be an acceptable trade-off for extremely chatty interfaces.
- For small applications where the resource cost of deploying a sidecar service for each instance is not worth the advantage of isolation.
- When the service needs to scale differently than or independently from the main applications. In these cases it may make more sense to deploy the feature as a separate service.

## Example

The sidecar pattern is applicable to many scenarios. Some common examples:

- Infrastructure API - The infrastructure development team creates a service that's deployed alongside each application, instead of a language specific client library to provide access to the infrastructure. The service is then loaded as a sidecar and provides primary application a common layer for infrastructure services, including logging, environment data, configuration store, discovery, health checks, and watchdog services. The sidecar also monitors the parent applications host environment and process/container and logs the information to a centralized service.
- Manage NGINX/HAProxy - NGINX is deployed with a sidecar service that monitors environment state, then updates the NGINX configuration file and recycles the process when a change in state is needed.
- Ambassador sidecar -  An ambassador service is deployed as a sidecar with an application. The application makes call through the ambassador which handles request logging, routing, circuit breaking, and other connectivity related features.
- Offload proxy - An NGINX proxy is placed in front of an node.js service instance and handles serving static file contents for the service.


## Related guidance

- Ambassador



