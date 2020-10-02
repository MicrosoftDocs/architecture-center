---
title: Azure Kubernetes Service (AKS) solution journey
titleSuffix: Azure Architecture Center
description: An overview of Microsoft's Azure Kubernetes Service (AKS) guidance offerings ranging from "just starting out", to production, and through sustained operations.
author: ckittel
ms.date: 09/10/2020
ms.topic: overview
ms.service: architecture-center
ms.subservice:
---

# Azure Kubernetes Service solution journey

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. [Azure Kubernetes Service (AKS)](/azure/aks/) makes it simple to deploy a managed Kubernetes cluster in Azure.

Organizations are at various points in their understanding, rationalizing, and adoption of Kubernetes on Azure. Your organization's journey will likely follow a similar path to many other technologies you've adopted; learning, aligning your organization around roles & responsibilities, and deploying production-ready workloads. From there, you'll iterate; growing your product as your customer and business demands change.

:::image type="content" source="images/aks-journey.svg" alt-text="Visualizes your journey through learn, align, baseline, workload, and then into a loop of operate, best practices, iterate.":::

## Learn about Azure Kubernetes Service (AKS)

If you're new to Kubernetes or AKS, the best place to learn about the service is with Microsoft Learn. Microsoft Learn is a free, online training platform that provides interactive learning for Microsoft products and more. The **Introduction to Kubernetes on Azure** learning path will provide you with foundational knowledge that will take you through core concepts of containers, AKS cluster management, and workload deployment.

> [!div class="nextstepaction"]
> [Introduction to Kubernetes on Azure](/learn/paths/intro-to-kubernetes-on-azure/)

## Organizational readiness

As organizations such as yours have adopted Azure, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/get-started/) provides them prescriptive guidance as they move between the phases of the cloud adoption lifecycle. The Cloud Adoption Framework includes tools, programs, and content to simplify adoption of Kubernetes and related cloud-native practices at scale.

> [!div class="nextstepaction"]
> [Kubernetes in the Cloud Adoption Framework](/azure/cloud-adoption-framework/innovate/kubernetes/)

## Path to production

You understand the benefits and trade-offs of Kubernetes, and have decided that AKS is the best Azure compute platform for your workload. Your organizational controls have been put into place; you're ready to learn how to deploy production-ready clusters for your workload.

**Microsoft's AKS Baseline Cluster** is the starting point to help you build production-ready AKS clusters. We recommend you start from this baseline implementation and modify it to align to your workload's specific needs and [Well-Architected Framework](../../framework/index.md) priorities.

> [!div class="nextstepaction"]
> [Microsoft's AKS Baseline Cluster](../../reference-architectures/containers/aks/secure-baseline-aks.md)

## Best practices

As part of on going operations, you may wish to spot check your cluster against current recommended best practices. The best place to start is to ensure your cluster is aligned with Microsoft's [AKS Baseline Cluster](../../reference-architectures/containers/aks/secure-baseline-aks.md).

See [Best Practices for Cluster Operations](/azure/aks/best-practices) and [Best Practices for AKS Workloads](/azure/aks/best-practices#developer-best-practices).

> You may also consider evaluating a community-driven utility like [The AKS Checklist](https://www.the-aks-checklist.com) as a way of organizing and tracking your alignment to these best practices.

## Stay current with AKS

Kubernetes and AKS are both moving fast. The platform is evolving and just knowing what's on the roadmap might help you make architectural decisions and understand planned deprecations; consider bookmarking it.

> [!div class="nextstepaction"]
> [AKS product roadmap](https://aka.ms/aks/roadmap)

<br>

---

## Additional resources

The typical AKS solution journey depicted above ranges from learning about AKS to growing your existing clusters to meet new product and customer demands. However, you might also just be looking for additional reference and supporting material to help along the way for your specific situation.

### Example solutions

If you're seeking additional reference material that use AKS as their foundation, here are a few to consider.

* [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.md)
* [Secure DevOps for AKS](../../solution-ideas/articles/secure-devops-for-kubernetes.md)
* [Building a telehealth system](../../example-scenario/apps/telehealth-system.md)
* [CI/CD pipeline for container-based workloads](../../example-scenario/apps/devops-with-aks.md)

### Azure Arc

Azure Kubernetes Service offers you a managed Kubernetes experience on Azure, however there are workloads or situations that might be best suited for placing your own Kubernetes clusters under [Azure Arc](/azure/azure-arc/) management. This includes your clusters such as RedHat OpenShift, RedHat RKE, and Canonical Charmed Kubernetes. Azure Arc management should also be used for [AKS Engine](https://github.com/Azure/aks-engine) clusters running in your datacenter, in another cloud, or on [Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview).

> [!div class="nextstepaction"]
> [Azure Arc enabled Kubernetes](/Azure/azure-arc/kubernetes/overview)

### Managed service provider

If you're a managed service provider, you already use Azure Lighthouse to manage resources for multiple customers. Azure Kubernetes Service supports Azure Lighthouse so that you can manage hosted Kubernetes environments and deploy containerized applications within your customers' tenants.

> [!div class="nextstepaction"]
> [AKS with Azure Lighthouse](/azure/lighthouse/overview)
