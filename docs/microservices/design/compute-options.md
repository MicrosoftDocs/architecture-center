---
title: Choose a Compute Option for Microservices
description: Learn how to choose an Azure compute platform for a microservices architecture. Compare orchestrators, serverless options, and PaaS platforms based on inter-service communication, independent scaling, and deployability.
author: francisnazareth
ms.author: fnazaret
ms.date: 11/05/2024
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Choose an Azure compute option for microservices

This article helps you choose an Azure compute platform for a workload that is built on a microservices architecture. A microservices architecture is a composition of small, independently deployable services that communicate over the network. Your compute platform needs to support that model: independent scaling, independent deployment, and reliable inter-service communication across many services.

For decision factors that apply to any workload, such as team skills, networking, and portability, see [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md). This article focuses on what matters specifically for microservices.

## Azure compute platforms for microservices

The following Azure platforms support microservices workloads. They differ in how much orchestration, inter-service communication, and scaling behavior they provide out of the box.

### Azure Kubernetes Service (AKS)

[AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that provides direct access to Kubernetes APIs and the control plane. AKS handles upgrades, patching, and node management, but you configure the cluster, networking, and scaling policies.

For microservices, AKS supports service meshes like [Istio](/azure/aks/istio-about) for traffic management and mTLS, per-deployment scaling through Horizontal Pod Autoscaler and [KEDA](/azure/aks/keda-about), and Kubernetes-native deployment strategies like rolling updates and canary releases.

[AKS Automatic](/azure/aks/intro-aks-automatic) is a mode of AKS that preconfigures node management, scaling, security, and observability based on AKS well-architected recommendations, so that teams get a production-ready cluster without configuring each capability individually.

### Azure Container Apps

[Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a managed service built on Kubernetes that abstracts cluster management.

Container Apps provides built-in features for microservices, including [service discovery](/azure/container-apps/connect-apps), [Dapr integration](/azure/container-apps/dapr-overview) for service-to-service invocation with mTLS, publish/subscribe messaging, and state management. [KEDA-based autoscaling](/azure/container-apps/scale-app) enables event-driven scaling, including scale to zero. Container Apps also supports [traffic splitting](/azure/container-apps/revisions) across revisions for canary deployments and [jobs](/azure/container-apps/jobs) for on-demand, scheduled, or event-driven tasks.

Container Apps doesn't expose Kubernetes APIs. If your deployment tooling or service mesh configuration depends on Kubernetes primitives, use AKS instead.

### Azure Functions

[Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless, event-driven compute service suited for microservices that respond to triggers like HTTP requests, queue messages, or timers. Functions scales each function independently and can scale to zero. Functions doesn't provide platform-level service discovery or inter-service communication. You'll implement those features in application code or through external services like [Azure API Management](/azure/api-management/api-management-key-concepts).

Functions supports [multiple programming languages](/azure/azure-functions/supported-languages#language-support-details). You can also run the Azure Functions programming model [on Container Apps](/azure/container-apps/functions-overview), which combines Functions triggers and bindings with Container Apps networking and scaling features.

### Azure App Service

[Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is suited for HTTP-based microservices such as web APIs. App Service supports deploying as code or as a single container. It provides built-in autoscaling, [deployment slots](/azure/app-service/deploy-staging-slots) for blue-green deployments, and integration with CI/CD pipelines. App Service doesn't provide service discovery or traffic splitting, so it's a better fit for simpler microservices that don't require inter-service communication features from the platform.

### Azure Red Hat OpenShift

[Azure Red Hat OpenShift](/azure/openshift) provides fully managed OpenShift clusters. It extends Kubernetes with an opinionated developer experience and is jointly engineered, operated, and supported by Red Hat and Microsoft. Use Azure Red Hat OpenShift if your organization has standardized on OpenShift.

## Compare platforms for microservices

The following table compares how each platform supports the capabilities that matter for a microservices architecture. For a broader comparison that includes general-purpose compute factors, see [Choose an Azure container service](../../guide/choose-azure-container-service.md).

| Capability | AKS | Container Apps | Functions | App Service |
| :--------- | :-- | :------------- | :-------- | :---------- |
| **Service discovery** | Kubernetes DNS, service mesh | [Built-in](/azure/container-apps/connect-apps), [Dapr](/azure/container-apps/dapr-overview) | None (app-level) | None (app-level) |
| **Inter-service communication** | Service mesh ([Istio](/azure/aks/istio-about)) | [Dapr](/azure/container-apps/dapr-overview), [environment-level](/azure/container-apps/networking) | None (app-level) | None (app-level) |
| **Pub/sub messaging** | App-level (e.g., Service Bus, Event Hubs) | [Dapr pub/sub](/azure/container-apps/dapr-overview) | [Bindings](/azure/azure-functions/functions-triggers-bindings) | App-level |
| **Independent scaling** | Per-deployment (HPA, [KEDA](/azure/aks/keda-about)) | Per-app ([KEDA](/azure/container-apps/scale-app)) | Per-function | Per-App Service plan |
| **Scale to zero** | No (nodes stay provisioned) | Yes | Yes (Consumption/Flex plans) | No |
| **Traffic splitting / canary** | Kubernetes-native, service mesh | [Revision-based](/azure/container-apps/revisions) | Deployment slots | [Deployment slots](/azure/app-service/deploy-staging-slots) |
| **Distributed tracing** | [Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview), open-source tooling | [Built-in](/azure/container-apps/observability), Dapr tracing | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) |
| **Stateful services** | Persistent volumes, StatefulSets | [Volume mounts](/azure/container-apps/storage-mounts), [Dapr state](/azure/container-apps/dapr-overview) | [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) | Not supported |
| **Per-service identity** | [Workload identity](/azure/aks/workload-identity-overview) | [Managed identity](/azure/container-apps/managed-identity) | [Managed identity](/azure/azure-functions/security-concepts#managed-identities) | [Managed identity](/azure/app-service/overview-managed-identity) |
| **Kubernetes API access** | Yes | No | No | No |
| **Independent deployability** | Yes (per pod/deployment) | Yes (per container app) | Yes (per function app) | Yes (per app or [deployment slot](/azure/app-service/deploy-staging-slots)) |
| **Runs containers** | Yes | Yes | Yes | Yes |
| **Runs code without containers** | No | No | Yes | Yes |

> [!NOTE]
> Azure Red Hat OpenShift is not included in this table. It provides the full Kubernetes API, so its microservices capabilities are comparable to AKS. Choose Azure Red Hat OpenShift when your organization requires a jointly supported Red Hat and Microsoft platform or has existing investments in the OpenShift ecosystem.

## Choose your platform

- **Start with Container Apps** when you want built-in microservices primitives, such as service discovery, Dapr, and per-app scaling with scale to zero, without managing a Kubernetes cluster.
- **Choose AKS** when you need direct Kubernetes API access, custom service mesh configuration, or fine-grained control over cluster infrastructure such as node pools, networking policies, or scheduling constraints.
- **Use Functions** for event-driven microservices with sporadic or bursty traffic patterns that benefit from scale-to-zero billing and trigger-based execution.
- **Use App Service** for straightforward HTTP-based services that don't need platform-level service discovery or inter-service communication features.

Your microservices workload doesn't need to run on a single platform. For example, you can run core services on AKS or Container Apps while handling event-driven workloads with Functions. Evaluate each service in your composition against its own traffic pattern, scaling requirements, and communication needs, and choose the platform that fits that service instead of trying to make the service fit the platform.

## Key decision factors

The table above shows what each platform supports. This section helps you weigh those capabilities based on which microservices concerns matter most to your workload.

- **Inter-service communication.** Microservices depend on reliable service-to-service communication with capabilities like service discovery, retries, and mutual TLS (mTLS).

  If your architecture relies heavily on synchronous service-to-service calls across many services, prioritize a platform with built-in communication primitives. Container Apps provides these through Dapr without extra infrastructure. AKS provides them through service meshes like Istio, which offer more control but require configuration and operational investment.

  If your services communicate primarily through asynchronous messaging (queues, event streams), the platform's built-in communication features matter less as you'll need to interact with those services through an SDK or an abstraction.

- **Independent scaling.** Each microservice in a composition has different load characteristics.

  If your services have highly variable or bursty traffic, Container Apps and Functions scale per service and can scale idle services to zero, which avoids paying for unused capacity. AKS provides per-deployment scaling, but you manage shared node pools that stay provisioned.

  If your services have steady, predictable load, AKS or App Service can be more cost-effective because you're not paying for the overhead of per-invocation billing.

- **Independent deployability.** You need to deploy, update, and roll back individual microservices without affecting the rest of the system. All four platforms support this, but they differ in how you validate changes. If you use canary deployments that gradually shift traffic to new versions, Container Apps and AKS provide traffic splitting natively. App Service and Functions use deployment slots, which support swap-based blue-green deployments but not percentage-based traffic shifting.

- **Distributed observability.** A single user request can traverse many services. If you need correlated traces across the full call chain, verify that your platform's observability tooling integrates with your tracing strategy. Container Apps offers built-in observability with Dapr tracing. AKS integrates with Prometheus and open-source tracing tools, giving you more flexibility but requiring setup. Functions and App Service integrate with Application Insights, which provides end-to-end transaction tracing with minimal configuration.

- **State management.** Microservices typically externalize state to databases or caches, but some services benefit from state that's colocated with the compute instance, such as actor-based patterns or in-cluster data stores. If you need stateful services, AKS provides the most flexibility through persistent volumes and StatefulSets. Container Apps supports volume mounts and Dapr state management. Functions supports stateful orchestrations through Durable Functions. App Service doesn't support persistent local state.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

In a microservices architecture, individual services should be designed to fail independently. Your compute platform needs to detect unhealthy service instances, restart them, and route traffic away from them without bringing down the entire system.

- AKS provides liveness and readiness probes per container, automatic pod restarts, and replica sets that maintain a minimum instance count.
- Container Apps provides similar [health probes](/azure/container-apps/health-probes) and automatically replaces failed replicas.
- Functions automatically retries failed executions based on the trigger type. Deploy across [availability zones](/azure/reliability/availability-zones-overview) on whichever platform you choose to protect against datacenter-level failures.

For platform-specific reliability guidance, see the reliability sections of the WAF service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#reliability), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#reliability), and [Azure Functions](/azure/well-architected/service-guides/azure-functions#reliability).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Microservices increase the attack surface because every service-to-service call crosses a network boundary. Treat inter-service traffic as untrusted. Use mutual TLS (mTLS) to authenticate and encrypt communication between services. AKS supports mTLS through service meshes like [Istio](/azure/aks/istio-about), and Container Apps provides mTLS through [Dapr](/azure/container-apps/dapr-overview) or [environment-level configuration](/azure/container-apps/networking).

Assign each microservice its own identity by using [workload identity](/azure/aks/workload-identity-overview) on AKS or [managed identity](/azure/container-apps/managed-identity) on Container Apps, so that each service authenticates to only the resources it requires.

For platform-specific security guidance, see the security sections of the WAF service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#security), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#security), and [Azure Functions](/azure/well-architected/service-guides/azure-functions#security).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

A microservices architecture can include dozens of services, each with different traffic volumes. Services that handle high throughput continuously might be less expensive on dedicated compute. Services that handle sporadic or event-driven traffic might cost less on a consumption model that scales to zero.

- Container Apps and Functions support consumption billing and can scale to zero.
- AKS requires dedicated node pools that you pay for whether the pods are busy or idle, though you can mix node pool sizes and use cluster autoscaler to reduce waste.

In a composition with many services, the billing model you choose for each service can have a larger cost impact than the per-unit price of any single platform. For platform-specific cost guidance, see the cost optimization sections of the WAF service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#cost-optimization), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#cost-optimization), and [Azure Functions](/azure/well-architected/service-guides/azure-functions#cost-optimization).

## Next step

> [!div class="nextstepaction"]
> [Design interservice communication for microservices](./interservice-communication.yml)

## Related resources

- [Design a microservices architecture](index.md)
- [Design APIs for microservices](../design/api-design.md)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md)
- [Choose an Azure container service](../../guide/choose-azure-container-service.md)
- [Architectural considerations for choosing an Azure container service](../../guide/container-service-general-considerations.md)
