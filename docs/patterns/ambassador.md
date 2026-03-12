---
title: Ambassador Pattern
description: Learn about the ambassador pattern, which creates helper services that send network requests on behalf of a consumer service or application.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/25/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Ambassador pattern

Create helper services that send network requests on behalf of a consumer service or application. Think of an ambassador service as an out-of-process proxy that is colocated with the client.

Use the ambassador pattern to offload common client connectivity tasks like monitoring, logging, routing, security like Transport Layer Security (TLS), and [resiliency patterns](/azure/well-architected/reliability/design-patterns) in a language-agnostic way. Extend the networking capabilities of legacy applications, or other applications that are difficult to modify, using the Ambassador pattern. Specialized teams also use the Ambassador pattern to implement those features.

## Context and problem

Resilient cloud-based applications require features like [circuit breaking](./circuit-breaker.md), routing, metering and monitoring, and to make network-related configuration updates. If the code is no longer maintained, or can't be easily modified by the development team, it might be difficult or even impossible to update legacy applications or existing code libraries to add these features.

Network calls might also require substantial configuration for connection, authentication, and authorization. Configure network calls for each instance if these calls are used across multiple applications and built using multiple languages and frameworks. A central team within your organization might need to manage network and security functionality. With a large code base, it can be risky for that team to update application code they aren't familiar with.

## Solution

Put client frameworks and libraries into an external process that acts as a proxy between your application and external services. To allow control over routing, resiliency, security features, and to avoid any host-related access restrictions, deploy the proxy on the same host environment as your application. Use the ambassador pattern to standardize and extend instrumentation. The proxy can monitor performance metrics like latency or resource usage, and this monitoring happens in the same host environment as the application.

:::image type="complex" source="./_images/ambassador.png" alt-text="Diagram of the ambassador pattern." border="false":::
  Diagram that shows a client application and an ambassador proxy colocated on the same host. The client application sends requests to the ambassador instead of calling external services directly. The ambassador forwards those requests to the remote services. Responses from the remote services return through the ambassador and back to the client application.
:::image-end:::

Features that are offloaded to the ambassador can be managed independently of the application. Update and modify the ambassador without disturbing the application's legacy functionality. The ambassador pattern allows for separate, specialized teams to implement and maintain security, networking, or authentication features that have been moved to the ambassador.

Ambassador services can be deployed as a [sidecar](./sidecar.md) to accompany the lifecycle of a consuming application or service. Alternatively, if multiple separate processes on a common host share an ambassador, it can be deployed as a daemon or Windows service. If the consuming service is containerized, create the ambassador as a separate container on the same host, with the appropriate links configured for communication.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- The proxy adds some latency overhead. Consider whether a client library, invoked directly by the application, is a better approach.

- Consider the possible impact of including generalized features in the proxy. For example, the ambassador could handle retries, but that might not be safe unless all operations are idempotent.

- Consider a mechanism to allow the client to pass some context to the proxy, and back to the client. For example, include HTTP request headers to opt out of retry or specify the maximum number of times to retry.

- Consider how to package and deploy the proxy.

- Consider whether to use a single shared instance for all clients or an instance for each client.

## When to use this pattern

Use this pattern when you:

- Need to build a common set of client connectivity features for multiple languages or frameworks.

- Need to offload cross-cutting client connectivity concerns to infrastructure developers or other more specialized teams.

- Need to support cloud or cluster connectivity requirements in a legacy application or an application that's difficult to modify.

- Must support protocols or connectivity patterns that **aren't easily handled** by API gateways, service meshes, or standard ingress/egress controls.

This pattern might not be suitable when:

- Network request latency is critical. A proxy introduces some overhead, although minimal, and this overhead might affect the application.

- Client connectivity features are consumed by a single language. In that case, a better option might be a client library that is distributed to the development teams as a package.

- Connectivity features can't be generalized and these features require deeper integration with the client application.

- Your application platform supports prebuilt solutions, like a service mesh, to handle mutual TLS, traffic management, and policy capabilities. Use these solutions instead of creating a custom ambassador solution.

## Workload design

An architect should evaluate how the Ambassador pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | The network communications mediation point facilitated by this pattern provides an opportunity to add reliability patterns to network communication, like retry or buffering.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | This pattern provides an opportunity to augment security on network communications that the client couldn't handle directly.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:07 Encryption](/azure/well-architected/security/encryption) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

The following diagram shows an application making a request to a remote service via an ambassador proxy. The ambassador provides routing, circuit breaking, and logging. It calls the remote service and then returns the response to the client application:

:::image type="complex" source="./_images/ambassador-example.png" alt-text="Example of the Ambassador pattern." border="false":::
  Diagram that shows a client application sending a request to an ambassador proxy. The ambassador proxy contains three components: routing, circuit breaker, and logging. The request flows through each of these components in sequence. The ambassador then forwards the request to the remote service. The remote service returns a response that flows back through the ambassador proxy to the client application.
:::image-end:::

In a containerized environment, this ambassador would run as a sidecar container next to the application container. In noncontainerized environments, it would be implemented as a local process or Windows service on the same host.

## Next step

- [Sidecar pattern](./sidecar.md)