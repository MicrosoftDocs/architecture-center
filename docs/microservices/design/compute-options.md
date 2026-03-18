---
title: Choose a Compute Option for Microservices
description: Learn about compute options, the hosting models for the computing resources that your application runs on, like service orchestrator and serverless architectures.
author: francisnazareth
ms.author: fnazaret
ms.date: 11/05/2024
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Choose an Azure compute option for microservices

The term *compute* refers to the hosting model for the computing resources that your application runs on. This article provides prescriptive guidance to help you choose a compute platform for microservices. Your microservice compute platform selection might depend on more nuanced requirements.

For a microservices architecture, the following approaches are popular:

- Deploy microservices on dedicated compute platforms, typically by using a microservice orchestrator.
- Deploy microservices on a serverless platform.

Although these options aren't the only ones, they're both proven approaches to building microservices. An application might include both approaches.

:::image type="content" source="../design/images/microservice-compute-options.svg" alt-text="A diagram that shows microservice compute options in Azure." border="false" lightbox="../design/images/microservice-compute-options.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/microservice-compute-options.vsdx) of this architecture.*

## Use a serverless platform

You can use serverless platforms to deploy microservices on Azure Container Apps or Azure Functions. Both Container Apps and Functions provide serverless compute options that bill based on the volume of requests rather than compute consumption. Both platforms also give you the option to host the workloads on dedicated capacity. 

## Deploy code-based microservices 

If you want to deploy your microservices as code instead of containerizing them, consider Azure Functions or Azure App Service.

[Azure Functions](/azure/azure-functions/functions-overview) is suited for event-driven microservices. For more information, see the [list of programming and scripting languages supported by Functions](/azure/azure-functions/supported-languages#language-support-details). For microservices that you develop in other languages, you might want to implement a custom handler in Functions or consider containerizing the application. You can also run the Azure Functions programming model [on Container Apps](/azure/container-apps/functions-overview), which lets you combine Functions triggers and bindings with Container Apps scaling and networking features.

[Azure App Service](/azure/app-service/overview) is suited for HTTP-based microservices such as web APIs. App Service supports deploying as code or as a single container. It provides built-in autoscaling, deployment slots for blue-green deployments, and integration with CI/CD pipelines. App Service doesn't provide rich container orchestration features like service discovery or traffic splitting, so it's a better fit for simpler microservices that are independently deployable and don't require inter-service communication features from the platform.

## Use a GPU model

If your microservice requires GPU capacity, for example, to run machine learning tasks, consider choosing Container Apps or Azure Kubernetes Service (AKS) for your platform. AKS can [use any GPU models in Azure](/azure/aks/gpu-cluster). Container Apps supports GPU workloads through [dedicated workload profiles](/azure/container-apps/workload-profiles-overview), which offer a subset of GPU models.

## Use service orchestrators

An orchestrator handles tasks that relate to deploying and managing a set of services. These tasks include placing services on nodes, monitoring the health of services, restarting unhealthy services, load balancing network traffic across service instances, service discovery, scaling the number of instances of a service, and applying configuration updates. Kubernetes is the dominant orchestrator for microservices.

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

If you choose Azure Functions as your microservice computing platform, consider deploying the [Functions Premium plan](/azure/azure-functions/functions-premium-plan?tabs=portal) or Azure App Service plan in a zone-redundant configuration. For more information, see [Reliability in Functions](/azure/reliability/reliability-functions?tabs=azure-portal). 

If you choose AKS as your microservice computing platform, you can enhance microservice reliability by deploying an [AKS cluster that uses availability zones](/azure/aks/availability-zones), by using the [Standard or Premium tier](/azure/aks/free-standard-pricing-tiers) for Azure Kubernetes clusters, and by increasing the minimum number of pods and nodes. For more information, see [Deployment and cluster reliability best practices for AKS](/azure/aks/best-practices-app-cluster-reliability).

If you choose Container Apps as your microservice computing platform, you can enhance reliability by using availability zones. For more information, see [Reliability in Container Apps](/azure/reliability/reliability-azure-container-apps).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

If you choose Azure Functions as your compute platform to deploy microservices, the principles of [securing Azure Functions](/azure/azure-functions/security-concepts) apply to microservices as well.

If you choose AKS as your compute platform to deploy microservices, the [AKS security baseline architecture](/security/benchmark/azure/baselines/azure-kubernetes-service-aks-security-baseline) provides guidance for securing the compute platform. For best practices on microservice security on AKS, see [Advanced AKS microservice architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced). 

If you choose Container Apps as your compute platform to deploy microservices, see the [security baseline for Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline) for security best practices.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

When you use an orchestrator, you pay for the virtual machines that run in the cluster. When you use a serverless application, you pay only for the actual compute resources that you consume. In both cases, you need to factor in the cost of any extra services, such as storage, databases, and messaging services.

Azure Functions, Container Apps, and AKS provide autoscaling options. Container Apps and Functions provide serverless platforms where the cost is based on consumption and can scale to zero. Container Apps also offers [dedicated workload profiles](/azure/container-apps/workload-profiles-overview) for workloads that need reserved capacity or specialized hardware. AKS provides only dedicated compute options.

If you choose AKS as the compute platform to deploy microservices, you need to understand cost optimization best practices. For more information, see [Optimize costs in Azure Kubernetes Service](/azure/aks/best-practices-cost).

If you choose Container Apps as your microservices compute platform, you need to understand the consumption and dedicated billing models and decide on the deployment model for your microservices based on your workload requirements. For more information, see [Billing in Container Apps](/azure/container-apps/billing).

If you choose Azure Functions as your microservices compute platform, you need to understand the various billing models and decide on the Functions plan based on your workload requirements. For more information, see [Estimate consumption-based costs](/azure/azure-functions/functions-consumption-costs) and [Azure Functions plan details](/azure/azure-functions/functions-scale#billing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You can deploy all of the microservice compute choices that this article describes in an automated manner by using Terraform, Bicep, and other scripting languages. You can use [Application Insights](/azure/azure-monitor/app/app-insights-overview), [Azure Monitor](/azure/azure-monitor/overview), and other monitoring solutions to monitor these compute platforms and microservices.

Consider the following factors when you choose between an orchestrator approach and a serverless approach:

- **Flexibility and control:** An orchestrator gives you control over configuring and managing your services and the cluster. The trade-off is more complexity. With a serverless architecture, you give up some degree of control because these details are abstracted.

- **Portability:** Kubernetes-based workloads are portable across environments because Kubernetes runs on-premises and across multiple public clouds. However, the managed Azure services listed in this article, such as AKS, Container Apps, and Azure Red Hat OpenShift, are Azure-specific. If you design your workloads against standard Kubernetes APIs, you reduce the effort to host between Kubernetes environments.

- **Application integration:** It can be challenging to build a complex application that uses a serverless architecture because you need to coordinate, deploy, and manage many small, independent functions. One option in Azure is to use [Azure Logic Apps](/azure/logic-apps/) to coordinate a set of Azure functions. For an example of this approach, see [Create a function that integrates with Logic Apps](/azure/azure-functions/functions-twitter-email).

## Next step

> [!div class="nextstepaction"]
> [Microservices on Azure](https://azure.microsoft.com/solutions/microservice-applications/?msockid=3bbaeb6b4c8a60711338fe44488a669b)

## Related resources

- [Design interservice communication for microservices](./interservice-communication.yml)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Design a microservices architecture](index.md)
- [Design APIs for microservices](../design/api-design.md)
