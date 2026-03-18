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

This article provides guidance for choosing an Azure compute platform for a microservices architecture. A microservices architecture is a composition of small, services that communicate over the network. Your compute platform needs to support independent scaling, independent deployment, and reliable inter-service communication across many services.

For a microservices architecture, the following approaches are common:

- Deploy microservices on dedicated compute platforms, typically by using a microservice orchestrator.
- Deploy microservices on a serverless platform.

Although these options aren't the only ones, they're both proven approaches to building microservices. An application might include both approaches.

:::image type="content" source="../design/images/microservice-compute-options.svg" alt-text="A diagram that shows microservice compute options in Azure." border="false" lightbox="../design/images/microservice-compute-options.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/microservice-compute-options.vsdx) of this architecture.*

## Use a serverless platform

Serverless platforms let you deploy each microservice without provisioning or managing infrastructure. Each service scales independently based on its own demand, including scaling to zero when idle. This model is well suited for microservices architectures where services have different traffic patterns and you want to avoid paying for idle capacity across many services. Azure Container Apps and Azure Functions both provide serverless compute options. Both platforms also give you the option to host workloads on dedicated capacity.

## Deploy code-based microservices

If you want to deploy your microservices as code instead of containerizing them, consider Azure Functions or Azure App Service.

[Azure Functions](/azure/azure-functions/functions-overview) is suited for event-driven microservices. For more information, see the [list of programming and scripting languages supported by Functions](/azure/azure-functions/supported-languages#language-support-details). For microservices that you develop in other languages, you might want to implement a custom handler in Functions or consider containerizing the application. You can also run the Azure Functions programming model [on Container Apps](/azure/container-apps/functions-overview), which lets you combine Functions triggers and bindings with Container Apps scaling and networking features.

[Azure App Service](/azure/app-service/overview) is suited for HTTP-based microservices such as web APIs. App Service supports deploying as code or as a single container. It provides built-in autoscaling, deployment slots for blue-green deployments, and integration with CI/CD pipelines. App Service doesn't provide rich container orchestration features like service discovery or traffic splitting, so it's a better fit for simpler microservices that are independently deployable and don't require inter-service communication features from the platform.

## Use service orchestrators

A service orchestrator manages the deployment, scaling, health monitoring, and networking of your services across a cluster instance. For microservices architectures with many containerized services, an orchestrator handles the operational complexity of keeping those services running and communicating with each other.

On the Azure platform, consider the following options:

- [Azure Kubernetes Service (AKS)](/azure/aks/) is a managed Kubernetes service. AKS provisions Kubernetes and exposes the Kubernetes API endpoints, hosts and manages the Kubernetes control plane, and performs automated upgrades, automated patching, autoscaling, and other management tasks. AKS provides direct access to Kubernetes APIs.

  [AKS Automatic](/azure/aks/intro-aks-automatic) is a mode of AKS that preconfigures node management, scaling, security, and observability based on AKS well-architected recommendations, so that teams get a production-ready cluster without configuring each capability individually.

- [Container Apps](/azure/container-apps) is a managed service built on Kubernetes that abstracts the complexities of container orchestration and other management tasks. Container Apps simplifies the deployment and management of containerized applications and microservices in a serverless environment.

  Container Apps is ideal for scenarios where direct access to Kubernetes APIs isn't required. Container Apps provides built-in features for microservices, including [service discovery](/azure/container-apps/connect-apps), [Dapr integration](/azure/container-apps/dapr-overview) for service-to-service invocation with mutual TLS (mTLS), publish/subscribe messaging, and state management.

  [KEDA-based autoscaling](/azure/container-apps/scale-app) enables event-driven scaling, including scale to zero. Container Apps also supports [traffic splitting](/azure/container-apps/revisions) across revisions for canary deployments and [jobs](/azure/container-apps/jobs) for on-demand, scheduled, or event-driven tasks.

- Use [Azure Red Hat OpenShift](/azure/openshift) to deploy fully managed OpenShift clusters. Azure Red Hat OpenShift extends Kubernetes. Azure Red Hat OpenShift is jointly engineered, operated, and supported by Red Hat and Microsoft.

- You can find additional Kubernetes-based container solutions from partners on [Microsoft Marketplace](https://marketplace.microsoft.com).

### Key decision factors

When you select a compute platform for microservices, focus on how well the platform supports the defining characteristics of a microservices architecture: independently deployable services that communicate over the network, scale independently, and are potentially owned by separate teams. For decision factors that apply to any workload, such as Kubernetes API access, team skills, networking, and portability, see [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md).

- **Inter-service communication.** Microservices depend on reliable service-to-service communication with capabilities like service discovery, retries, and mutual TLS (mTLS).

  - AKS supports service meshes like [Istio](/azure/aks/istio-about) that provide traffic management, mTLS, and observability across the full mesh.
  - Container Apps provides [built-in Dapr integration](/azure/container-apps/dapr-overview) for service invocation, pub/sub messaging, and mTLS without deploying a separate mesh.
  - Functions and App Service don't provide platform-level inter-service communication; you implement service discovery and resilient calls in application code or through external services like [Azure API Management](/azure/api-management/api-management-key-concepts).

- **Independent scaling.** Each microservice in a composition has different load characteristics. The platform needs to let you scale services independently rather than scaling the entire application as a unit.

  - Container Apps and Functions scale each service independently based on its own triggers, including HTTP traffic, queue depth, or custom metrics, and can scale to zero when a service is idle.
  - AKS provides per-deployment scaling through Horizontal Pod Autoscaler and [KEDA](/azure/aks/keda-about), but the underlying node pool is shared and doesn't scale to zero.
  - App Service scales each App Service plan, which can host multiple microservices; less granular if you colocate services.

- **Independent deployability.** You need to deploy, update, and roll back individual microservices without redeploying the rest of the system.

  - Container Apps supports [traffic splitting](/azure/container-apps/revisions) across revisions, so you can canary-test a single service. AKS supports rolling updates, canary, and blue-green patterns through Kubernetes-native mechanisms or service mesh traffic policies.
  - App Service provides [deployment slots](/azure/app-service/deploy-staging-slots) per app. Functions supports deployment slots through App Service plans.

- **Distributed observability.** A single user request in a microservices architecture can traverse many services. Debugging failures requires correlated distributed tracing, not just per-service logs.

  - AKS integrates with [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) and supports open-source tracing tools.
  - Container Apps provides [built-in observability](/azure/container-apps/observability) and Dapr's distributed tracing support.
  - Functions and App Service integrate with [Application Insights](/azure/azure-monitor/app/app-insights-overview), which provides end-to-end transaction tracing.

- **State management.** Microservices typically externalize state to databases or caches, but some patterns like event sourcing or CQRS require services with local persistent state.

  - AKS supports stateful workloads through persistent volumes and StatefulSets.
  - Container Apps supports [volume mounts](/azure/container-apps/storage-mounts) and Dapr [state management APIs](/azure/container-apps/dapr-overview).
  - Functions supports stateful orchestrations through [Durable Functions](/azure/azure-functions/durable/durable-functions-overview).

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
