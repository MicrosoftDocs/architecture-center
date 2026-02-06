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

If you want to deploy your microservices as code instead of containerizing them, you might want to use Azure Functions. For more information, see the [list of programming and scripting languages supported by Functions](/azure/azure-functions/supported-languages#language-support-details). For microservices that you develop in other languages, you might want to implement a custom handler in Functions or consider containerizing the application.

## Use a GPU model

If your microservice requires GPU capacity, for example, to run machine learning tasks, consider choosing Container Apps or Azure Kubernetes Service (AKS) for your platform. AKS can [use any GPU models in Azure](/azure/aks/gpu-cluster), and Container Apps offers a [subset of GPU models to choose from](/azure/container-apps/workload-profiles-overview). 

## Use service orchestrators

An orchestrator handles tasks that relate to deploying and managing a set of services. These tasks include placing services on nodes, monitoring the health of services, restarting unhealthy services, load balancing network traffic across service instances, service discovery, scaling the number of instances of a service, and applying configuration updates. Popular orchestrators include Kubernetes, Azure Service Fabric, DC/OS, and Docker Swarm.

On the Azure platform, consider the following options:

- [Azure Kubernetes Service (AKS)](/azure/aks/) is a managed Kubernetes service. AKS provisions Kubernetes and exposes the Kubernetes API endpoints, hosts and manages the Kubernetes control plane, and performs automated upgrades, automated patching, autoscaling, and other management tasks. AKS provides direct access to Kubernetes APIs. 

- [Container Apps](/azure/container-apps) is a managed service built on Kubernetes that abstracts the complexities of container orchestration and other management tasks. Container Apps simplifies the deployment and management of containerized applications and microservices in a serverless environment while providing the features of Kubernetes. Container Apps is ideal for scenarios where direct access to Kubernetes APIs isn't required.

- [Service Fabric](/azure/service-fabric/) is a distributed systems platform for packaging, deploying, and managing microservices. You can deploy microservices to Service Fabric as containers, as binary executables, or as [Reliable Services](/azure/service-fabric/service-fabric-reliable-services-introduction). By using the Reliable Services programming model, services can directly use Service Fabric programming APIs to query the system, report health, receive notifications about configuration and code changes, and discover other services.

- Use [Azure Red Hat OpenShift](/azure/openshift) to deploy fully managed OpenShift clusters. Azure Red Hat OpenShift extends Kubernetes. Azure Red Hat OpenShift is jointly engineered, operated, and supported by Red Hat and Microsoft.

- Other options, such as Docker Enterprise Edition, can run in a cloud-computing environment on Azure. You can find deployment templates on [Azure Marketplace](https://azuremarketplace.microsoft.com).

### Use Kubernetes APIs

Access to Kubernetes APIs is often a deciding factor when you choose a compute option. AKS provides direct access to Kubernetes APIs, but Container Apps doesn't. Container Apps hides the complexities of Kubernetes and simplifies the container deployment experience. If you design your microservice deployment to directly interact with Kubernetes APIs, AKS might be the right choice.

### Other decision factors

There might be other factors that affect your microservice compute platform selection. These factors include service mesh options, platform scalability, and skill sets that you might use within the organization. 

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

Azure Functions, Container Apps, and AKS provide autoscaling options. Container Apps and Functions provide serverless platforms where the cost is based on consumption and can be zero. AKS provides only dedicated compute options.

If you choose AKS as the compute platform to deploy microservices, you need to understand cost optimization best practices. For more information, see [Optimize costs in Azure Kubernetes Service](/azure/aks/best-practices-cost). 

If you choose Container Apps as your microservices compute platform, you need to understand the various billing models and decide on the deployment model for your microservices based on your workload requirements. For more information, see [Billing in Container Apps](/azure/container-apps/billing). 

If you choose Azure Functions as your microservices compute platform, you need to understand the various billing models and decide on the Functions plan based on your workload requirements. For more information, see [Estimate consumption-based costs](/azure/azure-functions/functions-consumption-costs) and [Azure Functions plan details](/azure/azure-functions/functions-scale#billing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You can deploy all of the microservice compute choices that this article describes in an automated manner by using Terraform, Bicep, and other scripting languages. You can use [Application Insights](/azure/azure-monitor/app/app-insights-overview), [Azure Monitor](/azure/azure-monitor/overview), and other monitoring solutions to monitor these compute platforms and microservices.

Consider the following factors when you choose between an orchestrator approach and a serverless approach:

- **Flexibility and control:** An orchestrator gives you control over configuring and managing your services and the cluster. The trade-off is more complexity. With a serverless architecture, you give up some degree of control because these details are abstracted.

- **Portability:** All of the orchestrators listed in this article, including Kubernetes, DC/OS, Docker Swarm, and Service Fabric, can run on-premises or in multiple public clouds.

- **Application integration:** It can be challenging to build a complex application that uses a serverless architecture because you need to coordinate, deploy, and manage many small, independent functions. One option in Azure is to use [Azure Logic Apps](/azure/logic-apps/) to coordinate a set of Azure functions. For an example of this approach, see [Create a function that integrates with Logic Apps](/azure/azure-functions/functions-twitter-email).

## Next step

> [!div class="nextstepaction"]
> [Microservices on Azure](https://azure.microsoft.com/solutions/microservice-applications/?msockid=3bbaeb6b4c8a60711338fe44488a669b)

## Related resources

- [Design interservice communication for microservices](./interservice-communication.yml)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Design a microservices architecture](index.md)
- [Design APIs for microservices](../design/api-design.md)
