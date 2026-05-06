---
title: Choose a Compute Option for Microservices
description: Choose an Azure compute platform for a microservices architecture. Compare options based on interservice communication, independent scaling, and deployability.
author: francisnazareth
ms.author: fnazaret
ms.date: 04/17/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Choose an Azure compute option for microservices

This article helps you choose an Azure compute platform for a workload built on a microservices architecture. A microservices architecture consists of small, independently deployable services that communicate over the network. Your compute platform needs to support independent scaling, independent deployment, and reliable interservice communication across many services.

For decision factors that apply to any workload, like team skills, networking, and portability, see [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md). This article focuses on the factors that matter specifically for microservices.

## Azure compute platforms for microservices

The following Azure platforms support microservices workloads. They differ in how much orchestration, interservice communication, and scaling behavior that they provide.

### Azure Kubernetes Service (AKS)

[Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that provides direct access to Kubernetes APIs and the control plane. AKS provides node management, patching, and optional automatic upgrades. You configure the cluster, networking, and scaling policies.

For microservices, AKS supports service meshes like [Istio](/azure/aks/istio-about) for traffic management and mutual Transport Layer Security (mTLS), per-deployment scaling through Horizontal Pod Autoscaler (HPA) and [Kubernetes Event-driven Autoscaling (KEDA)](/azure/aks/keda-about), and Kubernetes-native deployment strategies like rolling updates and canary releases.

[AKS Automatic](/azure/aks/intro-aks-automatic) is a mode of AKS that preconfigures node management, scaling, security, and observability based on AKS well-architected recommendations, so teams get a production-ready cluster without per-capability configuration.

### Azure Container Apps

[Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a managed service built on Kubernetes that abstracts cluster management.

Container Apps provides built-in features for microservices, including [service discovery](/azure/container-apps/connect-apps), [Dapr integration](/azure/container-apps/dapr-overview) for service-to-service invocation with mTLS, publisher-subscriber messaging, and state management. [KEDA-based autoscaling](/azure/container-apps/scale-app) enables event-driven scaling, including scale to zero. Container Apps also supports [traffic splitting](/azure/container-apps/revisions) across revisions for canary deployments and [jobs](/azure/container-apps/jobs) for on-demand, scheduled, or event-driven tasks.

Container Apps doesn't expose Kubernetes APIs. If your deployment tooling or service mesh configuration depends on Kubernetes primitives, use AKS instead.

### Azure Functions

[Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless, event-driven compute service suited for microservices that respond to triggers like HTTP requests, queue messages, or timers. Functions scales each function app independently and can scale to zero. For microservices, deploy each service as its own function app.

Functions doesn't provide platform-level service discovery or interservice communication. Implement those capabilities in application code or through external services like [Azure API Management](/azure/api-management/api-management-key-concepts).

Functions supports [multiple programming languages](/azure/azure-functions/supported-languages#language-support-details). You can also [run the Functions programming model on Container Apps](/azure/container-apps/functions-overview), which combines Functions triggers and bindings with Container Apps networking and scaling features.

### Azure App Service

[Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) suits HTTP-based microservices like web APIs. App Service supports deploying as code or as a single container. It provides built-in autoscaling, [deployment slots](/azure/app-service/deploy-staging-slots) for blue-green deployments and percentage-based traffic routing, and integration with continuous integration and continuous delivery (CI/CD) pipelines. App Service doesn't provide service discovery, so it suits microservices that communicate through external messaging or an API gateway rather than relying on platform-level interservice communication.

### Azure Red Hat OpenShift

[Azure Red Hat OpenShift](/azure/openshift/intro-openshift) provides fully managed OpenShift clusters and extends Kubernetes with an opinionated developer experience. Red Hat and Microsoft jointly engineer, operate, and support the service. Use Azure Red Hat OpenShift when your organization standardizes on OpenShift.

## Compare platforms for microservices

The following table compares how each platform supports the capabilities that matter for a microservices architecture. For a more detailed comparison of Azure container-hosting platforms and their capabilities, see [Choose an Azure container service](../../guide/choose-azure-container-service.md).

| Capability | AKS | Container Apps | Functions | App Service |
| :--------- | :-- | :------------- | :-------- | :---------- |
| Service discovery | Kubernetes Domain Name System (DNS), service mesh | [Built-in](/azure/container-apps/connect-apps), [Dapr](/azure/container-apps/dapr-overview) | None (app-level) | None (app-level) |
| Interservice communication | Service mesh ([Istio](/azure/aks/istio-about)) | [Dapr](/azure/container-apps/dapr-overview), [environment-level](/azure/container-apps/networking) | None (app-level) | None (app-level) |
| Publisher-subscriber messaging | App-level (like Azure Service Bus, Azure Event Hubs) | [Dapr pub/sub](/azure/container-apps/dapr-overview) | [Bindings](/azure/azure-functions/functions-triggers-bindings) | App-level |
| Independent scaling | Per-deployment (HPA, [KEDA](/azure/aks/keda-about)) | Per-app ([KEDA](/azure/container-apps/scale-app)) | Per-function app ([per-function on Flex](/azure/azure-functions/flex-consumption-plan)) | Per-App Service plan |
| Scale to zero | Partial ([user node pools only](/azure/aks/scale-cluster)) | Yes | Yes (Consumption or Flex Consumption plans) | No |
| Cold start mitigation | [Minimum node count](/azure/aks/scale-cluster), minimum pod replicas | [Minimum replica count](/azure/container-apps/scale-app) | [Prewarmed or always-ready instances](/azure/azure-functions/functions-premium-plan#eliminate-cold-starts) (Premium or Flex Consumption) | Not applicable (Always On) |
| Traffic splitting and canary deployments | Kubernetes-native, service mesh | [Revision-based](/azure/container-apps/revisions) | Deployment slots (Premium/Dedicated) | [Deployment slots that include traffic routing](/azure/app-service/deploy-staging-slots) |
| Distributed tracing | OpenTelemetry, open-source tooling | [Built-in](/azure/container-apps/observability), Dapr tracing | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) |
| Stateful services | Persistent volumes, StatefulSets | [Volume mounts](/azure/container-apps/storage-mounts), [Dapr state](/azure/container-apps/dapr-overview) | [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) | [Azure Files mount](/azure/app-service/configure-connect-to-azure-storage) |
| Per-service identity | [Workload identity](/azure/aks/workload-identity-overview) | [Managed identity](/azure/container-apps/managed-identity) | [Managed identity](/azure/azure-functions/security-concepts#managed-identities) | [Managed identity](/azure/app-service/overview-managed-identity) |
| Kubernetes API access | Yes | No | No | No |
| Independent deployability | Yes (per-pod or per-deployment) | Yes (per-container app) | Yes (per-function app) | Yes (per-app or [per-deployment slot](/azure/app-service/deploy-staging-slots)) |
| Runs containers | Yes | Yes | Yes | Yes |
| Runs code without containers | No | No | Yes | Yes |

*App-level* in this table means that the platform doesn't provide the capability as a built-in feature. You implement it in application code through an SDK or an external service, which introduces a dependency on that service.

> [!NOTE]
> This table doesn't include Azure Red Hat OpenShift. It provides the full Kubernetes API, so its core microservices capabilities, like per-deployment scaling, service discovery, and rolling updates, are comparable to AKS.
>
> The platforms differ in their operational tooling, not in their core microservices capabilities. For example, AKS provides Dapr and KEDA as managed add-ons, but on OpenShift, you install and maintain them yourself. For more information, see [Azure Red Hat OpenShift documentation](/azure/openshift/).

## Choose your platform

- **Start with Container Apps** when you want built-in microservices primitives, like service discovery, Dapr, and per-app scaling that includes scale to zero, without cluster management.

- **Choose AKS** when you need direct Kubernetes API access, custom service mesh configuration, or fine-grained control over cluster infrastructure like node pools, networking policies, or scheduling constraints.

- **Use Functions** for event-driven microservices that have sporadic or sudden-spike traffic patterns that benefit from scale-to-zero billing and trigger-based execution.

- **Use App Service** for straightforward HTTP-based services that don't need platform-level service discovery or interservice communication features.

Your microservices workload doesn't need to run on a single platform. For example, you can run core services on AKS or Container Apps while Functions handles event-driven workloads. Evaluate each service in your composition against its own traffic pattern, scaling requirements, and communication needs. Choose the platform that fits that service instead of forcing the service to fit the platform.

## Key decision factors

The comparison table shows what each platform supports. The following sections help you weigh those capabilities based on which microservices concerns matter most to your workload.

### Interservice communication 

Microservices depend on reliable service-to-service communication with capabilities like service discovery, retries, and mTLS.

If your architecture depends on synchronous service-to-service calls across many services, prioritize a platform that has built-in communication primitives. Container Apps provides these primitives through Dapr without extra infrastructure. AKS provides them through service meshes like Istio, which give you control over traffic policies, retries, and circuit breaking at the mesh level. You manage the mesh life cycle, configuration, and upgrades.

If your services communicate primarily through asynchronous messaging like queues or event streams, the platform's built-in communication features matter less because you need to interact with those services through an SDK or an abstraction. Use the [Asynchronous Request-Reply pattern](../../patterns/asynchronous-request-reply.md) for long-running operations because platform timeouts can become a problem. For example, Functions and App Service enforce a [230-second HTTP response timeout](/troubleshoot/azure/app-service/web-request-times-out-app-service) because of Azure Load Balancer limits.

### Independent scaling 

Each microservice in a composition has different load characteristics.

If your services have highly variable or sudden-spike traffic, Container Apps and Functions scale per service and can scale idle services to zero. This approach avoids unused capacity charges. For Functions, each function app is the scaling unit, so deploy each microservice as its own function app. AKS provides per-deployment scaling. You manage shared node pools that remain provisioned, and user node pools can scale to zero.

Scale-to-zero platforms introduce cold start latency when an idle service receives its first request. In a microservices architecture, a single user request can traverse multiple services. If several services in the call chain are cold, the latency compounds. For synchronous interservice calls that require low latency, use the platform's cold start mitigation features or pay the cost to keep minimum instances active to avoid cold starts.

If your services have steady, predictable load, AKS or App Service can reduce costs because you pay for reserved capacity instead of consumption-based billing.

### Independent deployability 

You need to deploy, update, and roll back individual microservices without affecting the rest of the system. All four platforms support independent deployability, but they differ in how you validate changes. Container Apps and AKS provide traffic splitting natively for gradual rollouts. App Service supports percentage-based traffic routing across deployment slots. Functions supports deployment slots on Premium and Dedicated plans.

### Distributed observability

A single user request can traverse many services. If you need correlated traces across the full call chain, verify that your platform's observability tooling integrates with your tracing strategy. Container Apps provides built-in observability with Dapr tracing. AKS integrates with OpenTelemetry and open-source tracing tools, which lets you choose your tracing back end (like Jaeger, Zipkin, or Azure Monitor) but requires you to deploy and configure the collection pipeline. Functions and App Service integrate with Application Insights for end-to-end transaction tracing with minimal configuration.

Ensure that each service in the composition exposes per-service metrics like request rate, error rate, and latency. These metrics help you identify which service degrades without correlating logs across the full call chain.

### State management

In a microservices architecture, each service typically owns its data and externalizes state to a dedicated database or cache. This pattern keeps services independently deployable, and all four platforms support it equally because the data store is a separate Azure resource.

The platforms differ when a service needs platform-managed state abstractions, like actor-based patterns, workflow orchestration, or dedicated per-instance storage:

- AKS provides the most flexibility through persistent volumes and StatefulSets, which support in-cluster data stores and stable per-instance identity.

- Container Apps supports volume mounts and Dapr state management, including Dapr actors.

- Functions supports stateful orchestrations and entities through Durable Functions.

- App Service supports shared storage through Azure Files mounts but doesn't provide per-instance storage or platform-level state abstractions.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

In a microservices architecture, the primary reliability risk is cascading failure. One unhealthy service causes callers to accumulate timeouts, and the problem propagates outward through the call chain. Your platform choice affects how you mitigate this risk.

- AKS and Container Apps provide platform-level health probes that detect unhealthy instances and remove them from rotation automatically.

- Functions retries failed executions based on the trigger type.

Regardless of platform, implement [circuit breakers](../../patterns/circuit-breaker.md), retry policies with backoff, and timeouts in your interservice communication to prevent a single service failure from becoming a system-wide outage.

Deploy each service across [availability zones](/azure/reliability/availability-zones-overview) to protect against datacenter-level failures. In a mixed-platform composition, verify that all platforms in use support zone redundancy for your deployment region.

For platform-specific reliability guidance, see the reliability sections of the Well-Architected Framework service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#reliability), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#reliability), and [Functions](/azure/well-architected/service-guides/azure-functions#reliability).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Microservices increase the attack surface because every service-to-service call crosses a network boundary. Treat all interservice traffic as untrusted and encrypt it through mTLS. AKS supports mTLS through service meshes like [Istio](/azure/aks/istio-about). Container Apps provides mTLS through [Dapr](/azure/container-apps/dapr-overview) or [environment-level configuration](/azure/container-apps/networking). Functions and App Service don't provide platform-level mTLS. If those platforms host services in your composition, enforce transport security through application-layer HTTPS, API gateway policies, or virtual network isolation.

In a composition of many services, each service should authenticate to only the resources that it requires. Assign per-service identities rather than sharing a single identity across the workload. For platform-specific mechanisms, see the [per-service identity](#compare-platforms-for-microservices) row in the comparison table.

For platform-specific security guidance, see the security sections of the Well-Architected Framework service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#security), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#security), and [Functions](/azure/well-architected/service-guides/azure-functions#security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

A microservices architecture can include dozens of services, and each service handles different traffic volumes. Match each service to the billing model that fits its traffic pattern. Consumption-based platforms like Container Apps and Functions scale idle services to zero, but dedicated compute like AKS can be more cost-effective for services that have sustained load. In a mixed-platform composition, per-service billing flexibility is one of the main cost advantages. However, account for the overhead of maintaining separate deployment pipelines, monitoring configurations, and team expertise across platforms.

For platform-specific cost guidance, see the cost optimization sections of the Well-Architected Framework service guides for [AKS](/azure/well-architected/service-guides/azure-kubernetes-service#cost-optimization), [Container Apps](/azure/well-architected/service-guides/azure-container-apps#cost-optimization), and [Functions](/azure/well-architected/service-guides/azure-functions#cost-optimization).

## Reference architectures

Narrow your options to one or two platforms by applying the comparison criteria in this article. Run a proof of concept by deploying a representative subset of your services and testing interservice communication, scaling behavior, and deployment workflows against your requirements. Confirm that the platform meets your team's operational expectations before you commit to production. The following architectures provide production-ready starting points:

- **AKS:** [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- **Container Apps:** [Microservices with Container Apps and Dapr](../../example-scenario/serverless/microservices-with-container-apps-dapr.yml)
- **App Service:** [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- **Azure Red Hat OpenShift:** [Azure Red Hat OpenShift in a hybrid environment](../../reference-architectures/containers/aro/azure-redhat-openshift-financial-services-workloads.yml)

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
