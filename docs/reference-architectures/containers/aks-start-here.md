---
title: Azure Kubernetes Service (AKS) - planning
description: Learn how to plan, design, and operate Azure Kubernetes Service (AKS) clusters, from foundational concepts to production-ready baseline implementations.
author: francisnazareth
ms.author: fnazaret
ms.date: 06/26/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-containers
---

# Azure Kubernetes Service (AKS) - Plan your design and operations

Kubernetes is an open-source system that automates deployment, scaling, and management of containerized applications. We recommend [Azure Kubernetes Service (AKS)](/azure/aks/) to deploy a managed Kubernetes cluster in Azure.

Organizations adopt Kubernetes on Azure at different rates. Your organization's journey will likely follow a path similar to how you adopt other technologies. You learn the fundamentals, align your organization around roles and responsibilities, and deploy production-ready workloads. From there, you iterate and grow your solution as customer and business demands change.

:::image type="complex" alt-text="Diagram that shows the AKS adoption journey." source="images/aks-journey.svg" lightbox="images/aks-journey.svg" border="false":::
On the left, a continuous cycle connects three elements: AKS product roadmap, AKS best practices, and organizational readiness. On the right, a workflow begins with an introductory workshop, which leads to the AKS baseline cluster. From the baseline cluster, the path branches into workloads and infrastructures. It shows four options: microservices, regulatory, high availability workload, and your workload. All workload paths converge at day 2 operations.
:::image-end:::

## Introduction to AKS

If you're new to Kubernetes or AKS, start with Microsoft Learn. This free online platform provides interactive training for Microsoft products. The **Introduction to Kubernetes on Azure** learning path covers core concepts of containers, AKS cluster management, and workload deployment.

> [!div class="nextstepaction"]
> [Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure/)

## Path to production

After you understand the benefits and trade-offs of Kubernetes, evaluate whether AKS is the right Azure compute platform for your workload and establish organizational policies for this technology. When you're ready to deploy production-ready clusters, start with the **Microsoft AKS baseline cluster** and modify it to meet your workload's specific needs.

> [!div class="nextstepaction"]
> [Microsoft AKS baseline cluster](./aks/baseline-aks.yml)

## Suite of baseline implementations

The following baseline implementations describe how to set up components of the AKS baseline cluster for various scenarios.

### Microservices

When you run microservices in the baseline cluster, you must set up network policies and pod autoscaling and implement distributed tracing for observability.

> [!div class="nextstepaction"]
> [Microservices architecture that uses the baseline implementation](./aks-microservices/aks-microservices-advanced.yml)

### High-security compliance

For regulated environments, enhance the baseline implementation by using stronger security controls and restricted cluster interactions. The following example demonstrates a cluster that runs a financially regulated workload.

> [!div class="nextstepaction"]
> [Baseline cluster for a regulated use case](/azure/aks/pci-intro)

### Business continuity and disaster recovery

For resilient solutions, deploy multiple baseline cluster instances across regions in an active/active, highly available configuration.

> [!div class="nextstepaction"]
> [Baseline for multiregion clusters](./aks-multi-region/aks-multi-cluster.yml)

## Best practices

The [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/overview) provides guidance for each phase of the cloud adoption life cycle. It includes tools, programs, and content to simplify Kubernetes adoption and related cloud-native practices at scale.

> [!div class="nextstepaction"]
> [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)

As part of ongoing operations, periodically check your cluster to ensure that it aligns with recommended best practices. Start by aligning your cluster with the [AKS baseline cluster](../../reference-architectures/containers/aks/baseline-aks.yml).

For more information, see [Best practices for cluster operations](/azure/aks/best-practices) and [Best practices for AKS workloads](/azure/aks/best-practices#developer-best-practices).

## Operations guide

After you deploy your workload on AKS, [day-2 operations](https://dzone.com/articles/defining-day-2-operations) become a priority. The **AKS day-2 operations guide** helps you meet customer demands and handle incident response through optimized triage processes.

> [!div class="nextstepaction"]
> [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)

## Stay current with AKS

Kubernetes and AKS evolve rapidly. Review the roadmap to make informed architectural decisions and anticipate planned deprecations.

> [!div class="nextstepaction"]
> [AKS product roadmap](https://github.com/orgs/Azure/projects/685)

---

## Other resources

The typical AKS journey ranges from learning about AKS to growing your existing clusters to meet new product and customer demands. The following resources provide reference material for specific situations along the way.

### Example solutions

The following example solutions use AKS as their foundation:

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Blue-green deployment of AKS clusters](../../guide/aks/blue-green-deployment-for-aks.yml)

### Azure Arc-enabled Kubernetes

AKS provides a managed Kubernetes experience on Azure. But you might prefer to manage some workloads on your own Kubernetes clusters by using [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/). Supported clusters include Red Hat OpenShift, Red Hat Rancher Kubernetes Engine (RKE), and Canonical Charmed Kubernetes.

You can also use Azure Arc management with [Kubernetes Cluster API Provider Azure](https://capz.sigs.k8s.io/) clusters to benefit from Azure Resource Manager representation and cluster extensions like Azure Monitor container insights and Azure Policy. Azure Arc-enabled Kubernetes also supports [AKS on Azure Local](/azure/aks/aksarc/aks-overview) and Kubernetes clusters that run on other cloud providers.

> [!div class="nextstepaction"]
> [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview)

### Managed service provider

Managed service providers use Azure Lighthouse to manage resources for multiple customers. AKS supports Azure Lighthouse so that you can manage hosted Kubernetes environments and deploy containerized applications within your customers' tenants.

> [!div class="nextstepaction"]
> [AKS with Azure Lighthouse](/azure/lighthouse/how-to/manage-hybrid-infrastructure-arc#manage-hybrid-kubernetes-clusters-at-scale-with-azure-arc-enabled-kubernetes)

### AWS or Google Cloud professionals

The following articles compare Azure services with other cloud platforms to help you get started quickly on Azure:

- [Containers and container orchestrators for Amazon Web Services (AWS) professionals](../../aws-professional/compute.md#containers-and-container-orchestrators)
- [AKS for Amazon Elastic Kubernetes Service (EKS) professionals](../../aws-professional/eks-to-aks/index.md)
- [Migrate a web app from Amazon EKS to AKS](/azure/aks/eks-web-overview)
- [Migrate an event-driven workload from Amazon EKS to AKS](/azure/aks/eks-edw-overview)
- [Containers and container orchestrators for Google Cloud professionals](../../gcp-professional/services.md#containers-and-container-orchestrators)

