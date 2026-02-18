---
title: Sidecar Pattern
description: Learn how to deploy features of an application into a separate process or container to provide modular abstraction and isolation of cross-cutting concerns.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/17/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Sidecar pattern

Deploy application components into a process or container separate from the main application to provide isolation and encapsulation. This pattern lets you build applications from diverse components and technologies.

Like a motorcycle sidecar, these components attach to a parent application and share its life cycle, so you create and retire them together. This pattern is also known as the *Sidekick pattern* and supports application decomposition.

## Context and problem

Applications and services often require related functionality, like monitoring, logging, configuration, and networking services. You can implement these peripheral tasks as separate components or services.

Tightly integrated components run in the same process and efficiently use shared resources, but they lack isolation. An outage in one component can affect the entire application. They also require implementation in the parent application's language, which creates interdependence.

If you decompose the application into services, you can build each service by using different languages and technologies. This approach provides more flexibility. But each component has its own dependencies and requires language-specific libraries to access the platform and shared resources. When you deploy these features as separate services, you add latency. Language-specific code and dependencies also increase complexity for hosting and deployment.

## Solution

Deploy a cohesive set of tasks alongside the primary application in a separate process or container. This approach provides a consistent interface for platform services across languages.

:::image type="complex" border="false" source="./_images/sidecar.png" alt-text="Diagram that shows the Sidecar pattern." lightbox="./_images/sidecar.png":::
The diagram shows the primary application and sidecar linked together. The application handles core functionality, and the sidecar handles peripheral tasks, like platform abstraction, proxy to remote services, logging, and configuration. Both the application and sidecar reside in a host.
:::image-end:::

A sidecar service connects to the application without being part of it and deploys alongside it. Each application instance gets its own sidecar instance that shares its life cycle.

The Sidecar pattern provides the following advantages:

- **Language independence:** The sidecar runs independently from the primary application's runtime environment and programming language. You can use one sidecar implementation across applications written in different languages.

- **Shared resource access:** The sidecar can access the same resources as the primary application. For example, the sidecar can monitor system resources that both components use.

- **Low latency:** The sidecar's proximity to the primary application minimizes communication latency.

- **Enhanced extensibility:** You can extend applications that lack native extensibility mechanisms by attaching a sidecar as a separate process on the same host or subcontainer.

The most common implementation of this pattern uses containers, which are also called *sidecar containers* or *sidekick containers*.

## Problems and considerations

Consider the following points when you implement this pattern:

- Consider the deployment and packaging format to deploy services, processes, or containers. Containers work well for the Sidecar pattern.

- When you design a sidecar service, carefully choose the interprocess communication mechanism. Use language-agnostic or framework-agnostic technologies unless performance requirements make that approach impractical.

- Before you add functionality to a sidecar, evaluate whether it works better as a separate service or a traditional daemon.

- Consider whether to implement the functionality as a library or through a traditional extension mechanism. Language-specific libraries provide deeper integration and less network overhead.

## When to use this pattern

Use this pattern when:

- Your primary application uses diverse languages and frameworks. Sidecars provide a consistent interface that different applications can use regardless of their language or framework.

- A separate team or external partner owns a component.

- You must deploy a component or feature on the same host as the application.

- You need a service that shares the overall life cycle of your main application but that you can update independently.

- You need fine-grained control over resource limits for a specific resource or component. For example, you can deploy a component as a sidecar to restrict and manage its memory usage independently of the main application.

This pattern might not be suitable when:

- You need to optimize interprocess communication. Sidecars add overhead, especially latency, which makes them unsuitable for applications with frequent communication between components.

- Your application is small. The resource cost of deploying a sidecar for each instance might outweigh the isolation benefits.

- You need to scale the component independently. If you must scale the component differently from the main application, deploy it as a separate service instead.

- Your platform provides equivalent functionality. If your application platform already provides the needed capabilities natively, sidecars add unnecessary complexity.

## Workload design

Evaluate how to use the Sidecar pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | When you encapsulate these tasks and deploy them in separate processes, you reduce the attack surface to only the necessary code. You can also use sidecars to add cross-cutting security controls to application components that lack native support for these features. <br><br> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) <br> - [SE:07 Encryption](/azure/well-architected/security/encryption) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern lets you flexibly integrate observability tools without adding dependencies to your application code. You can update and maintain the sidecar independently of the application. <br><br> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes) <br> - [OE:07 Monitoring system](/azure/well-architected/operational-excellence/observability) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern lets you centralize cross-cutting tasks in sidecars that scale across multiple application instances. You don't need to deploy duplicate functionality for each application instance. <br><br> - [PE:07 Code and infrastructure](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

You can apply the Sidecar pattern to many scenarios. Consider the following examples:

- **Dependency abstraction:** Deploy a custom service alongside each application to provide access to shared dependency capabilities through a consistent API. This approach replaces language-specific client libraries with a sidecar that handles concerns like logging, configuration, service discovery, state management, and health checks.

  The [Distributed Application Runtime (Dapr) sidecar](https://docs.dapr.io/concepts/dapr-services/sidecar/) exemplifies this use case.

- **Service mesh data plane:** Deploy a sidecar proxy alongside each service instance to handle cross-cutting networking concerns like traffic routing, retries, mutual Transport Layer Security (mTLS), policy enforcement, and telemetry.

  Service meshes like [Istio](https://istio.io/latest/about/service-mesh/) use sidecar proxies to implement these capabilities without requiring changes to application code.

- **Ambassador sidecar:** Deploy an [ambassador](./ambassador.yml) service as a sidecar. The application routes calls through the ambassador, which handles request logging, routing, circuit breaking, and other connectivity features.

- **Protocol adapters:** Deploy a sidecar to translate between incompatible protocols or data formats, or to [bridge messaging systems](messaging-bridge.yml). This approach lets the application use simpler or legacy interfaces.

- **Telemetry enrichment:** Deploy a sidecar to preprocess or enrich telemetry data, like metrics, logs, and traces, before it forwards the data to external monitoring systems. Components like the [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/deploy/agent/) can run as sidecars to normalize, enrich, or route telemetry separately from the application.

## Next steps

- [Microservice APIs that use Dapr](/azure/container-apps/dapr-overview): Learn how Azure Container Apps uses Dapr sidecars to help you build simple, portable, resilient, and secure microservices.

- [Native sidecar mode for Istio-based service mesh feature in Azure Kubernetes Service (AKS)](/azure/aks/istio-native-sidecar): Learn how the Istio service mesh feature for AKS uses the Sidecar pattern to address distributed architecture challenges.

## Related resource

- [Ambassador pattern](./ambassador.yml)