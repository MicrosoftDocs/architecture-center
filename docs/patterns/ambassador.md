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

Create helper services that send network requests on behalf of a consumer service or application. Think of an ambassador service as an out-of-process proxy that's colocated with the client.

Use the Ambassador pattern to offload common client connectivity tasks like monitoring, logging, routing, security like Transport Layer Security (TLS), and [resiliency patterns](/azure/well-architected/reliability/design-patterns) in a language-agnostic way. Extend the networking capabilities of legacy applications, or other applications that are difficult to modify, by using the Ambassador pattern. Specialized teams can also use the Ambassador pattern to implement those features.

## Context and problem

Resilient cloud-based applications require features like [circuit breaking](./circuit-breaker.md), routing, metering and monitoring, and network-related configuration updates. If the development team doesn't maintain the code or can't easily modify it, it might be difficult or even impossible to update legacy applications or existing code libraries to add these features.

Network calls might also require substantial configuration for connection, authentication, and authorization. When multiple applications use these calls across different languages and frameworks, you must configure the calls separately for each instance. A central team within your organization might need to manage network and security functionality. With a large code base, it can be risky for that team to update unfamiliar application code.

## Solution

Put client frameworks and libraries into an external process that acts as a proxy between your application and external services. To provide control over routing, resiliency, and security features and to avoid host-related access restrictions, deploy the proxy on the same host environment as your application. Use the ambassador pattern to standardize and extend instrumentation. The proxy can monitor performance metrics, like latency or resource usage, in the same host environment as the application.

:::image type="complex" source="./_images/ambassador.png" alt-text="Diagram of the ambassador pattern." border="false":::
  Diagram that shows a client application and an ambassador proxy colocated on the same host. The client application sends requests to the ambassador instead of calling external services directly. The ambassador forwards those requests to the remote service. Responses from the remote service return through the ambassador and back to the client application.
:::image-end:::

You can manage features that are offloaded to the ambassador independently of the application. You can update and modify the ambassador without disturbing the application's legacy functionality. Separate, specialized teams can also implement and maintain security, networking, or authentication features that have been moved to the ambassador.

You can deploy ambassador services as a [sidecar](./sidecar.md) to accompany the life cycle of a consuming application or service. Alternatively, if multiple separate processes on a common host share an ambassador, you can deploy it as a daemon or Windows service. If the consuming service is containerized, create the ambassador as a separate container on the same host and set up the appropriate links for communication.

## Problems and considerations

Consider the following points when you decide how to implement this pattern:

- The proxy adds some latency overhead. Consider whether a client library that the application directly invokes is a better approach.

- Consider the possible impact of including generalized features in the proxy. For example, the ambassador could handle retries, but that approach might not be safe unless all operations are idempotent.

- Consider a mechanism that the client can use to pass some context to the proxy and back to the client. For example, include HTTP request headers to opt out of retry or specify the maximum number of times to retry.

- Consider how to package and deploy the proxy.

- Consider whether to use a single shared instance for all clients or an instance for each client.

## When to use this pattern

Use this pattern when:

- You must build a common set of client connectivity features for multiple languages or frameworks.

- You must offload cross-cutting client connectivity concerns to infrastructure developers or other more specialized teams.

- You must support cloud or cluster connectivity requirements in a legacy application or an application that's difficult to modify.

- You must support protocols or connectivity patterns that API gateways, service meshes, or standard ingress and egress controls don't handle easily.

This pattern might not be suitable when:

- Network request latency is critical. A proxy introduces minimal overhead, and this overhead might affect the application.

- Client connectivity features are consumed by a single language. In that case, a better option might be a client library that's distributed to the development teams as a package.

- Connectivity features can't be generalized and these features require deeper integration with the client application.

- Your application platform supports prebuilt solutions, like a service mesh, to handle mutual TLS (mTLS), traffic management, and policy capabilities. Use these solutions instead of creating a custom ambassador solution.

## Workload design

Evaluate how to use the Ambassador pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern introduces a network communications mediation point, so you can add reliability patterns to network communication, like retry or buffering. <br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | With this pattern, you can implement security on network communications that the client can't handle directly. <br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:07 Encryption](/azure/well-architected/security/encryption) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following diagram shows an application making a request to a remote service via an ambassador proxy. The ambassador provides routing, circuit breaking, and logging. It calls the remote service and then returns the response to the client application.

:::image type="complex" source="./_images/ambassador-example.png" alt-text="Example of the Ambassador pattern." border="false":::
  Diagram that shows a client application sending a request to an ambassador proxy. The application sends a request to the remote service via an ambassador proxy. The ambassador determines the location of the remote services and routes the request appropriately. The ambassador checks the circuit breaker state and enriches request headers with tracing information. The ambassador starts measuring the request latency. The ambassador encrypts and sends the request using mutual certificate-based authentication. The remote service receives the request and sends the response. The ambassador logs the request latency. The ambassador returns the response to the client. The application receives the response.
:::image-end:::

In containerized environments, this ambassador would run as a sidecar container next to the application container. In noncontainerized environments, you would implement it as a local process or Windows service on the same host.

## Next step

- [Sidecar pattern](./sidecar.md)
