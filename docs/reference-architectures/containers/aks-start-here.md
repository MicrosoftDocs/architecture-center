---
title: Azure Kubernetes Service (AKS) design
titleSuffix: Azure Architecture Center
description: An overview of Microsoft Azure Kubernetes Service (AKS) guidance offerings ranging from &quot;just starting out&quot;, to production, and through sustained operations.
author: ckittel
ms.author: architectures
ms.date: 07/28/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
categories:
  - containers
products:
  - azure-kubernetes-service
ms.custom:
  - overview
  - e2e-aks
---

# Azure Kubernetes Service (AKS) architecture design

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. [Azure Kubernetes Service (AKS)](/azure/aks/) makes it simple to deploy a managed Kubernetes cluster in Azure.

Organizations are at various points in their understanding, rationalizing, and adoption of Kubernetes on Azure. Your organization's journey will likely follow a similar path to many other technologies you've adopted; learning, aligning your organization around roles &amp; responsibilities, and deploying production-ready workloads. From there, you'll iterate; growing your product as your customer and business demands change.

:::image type="content" alt-text="Visualizes your journey through learn, align, baseline, workload, and then into a loop of operate, best practices, iterate." source="images/aks-journey.svg" lightbox="images/aks-journey.svg":::

## Introduction to Azure Kubernetes Service (AKS)

If you're new to Kubernetes or AKS, the best place to learn about the service is Microsoft Learn. This free online platform provides interactive training for Microsoft products and more. The **Introduction to Kubernetes on Azure** learning path will provide you with foundational knowledge that will take you through core concepts of containers, AKS cluster management, and workload deployment.

> [!div class="nextstepaction"]
> [Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure/)

## Path to production

You understand the benefits and trade-offs of Kubernetes, and have decided that AKS is the best Azure compute platform for your workload. Your organizational controls have been put into place; you're ready to learn how to deploy production-ready clusters for your workload.

**Microsoft's AKS Baseline Cluster** is the starting point to help you build production-ready AKS clusters.

> [!div class="nextstepaction"]
> [Microsoft's AKS Baseline Cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)

We recommend you start from the baseline implementation and modify it to align to your workload's specific needs.

## Suite of baseline implementations

We've provided a set of more baseline implementations to illustrate how you can adopt and configure components of AKS Baseline Cluster for various scenarios.

### Microservices

When running microservices in the baseline cluster, you'll need to configure network policies, pod autoscaling, and set up distributed tracing for observability.

> [!div class="nextstepaction"]
> [Microservices architecture using the baseline implementation](./aks-microservices/aks-microservices-advanced.yml)

### High security compliance

If you need a regulated environment, make the baseline implementation highly secure and restrict interactions to and from of the cluster. This use case is demonstrated in a cluster that's designed to run a PCI-DSS 3.2.1 workload.

> [!div class="nextstepaction"]
> [Regulated baseline cluster for PCI-DSS 3.2.1](./aks-pci/aks-pci-intro.yml)

### Business continuity and disaster recovery

A resilient solution needs multiple instances of the baseline cluster across regions in an active/active and highly available configuration.

> [!div class="nextstepaction"]
> [Baseline for multiregion clusters](./aks-multi-region/aks-multi-cluster.yml)

## Best practices

As organizations such as yours have adopted Azure, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/get-started/) provides them prescriptive guidance as they move between the phases of the cloud adoption lifecycle. The Cloud Adoption Framework includes tools, programs, and content to simplify adoption of Kubernetes and related cloud-native practices at scale.

> [!div class="nextstepaction"]
> [Kubernetes in the Cloud Adoption Framework](/azure/cloud-adoption-framework/innovate/kubernetes/)

As part of ongoing operations, you might want to spot check your cluster against current recommended best practices. Start by aligning your cluster with Microsoft's [AKS Baseline Cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks).

See [Best Practices for Cluster Operations](/azure/aks/best-practices) and [Best Practices for AKS Workloads](/azure/aks/best-practices#developer-best-practices).

> You may also consider evaluating a community-driven utility like [The AKS Checklist](https://www.the-aks-checklist.com) as a way of organizing and tracking your alignment to these best practices.

## Operations guide

Getting your workload deployed on AKS is a great milestone and this is when [day-2 operations](https://dzone.com/articles/defining-day-2-operations) are going to be top-of-mind. **Microsoft's AKS Day 2 Operations Guide** was built for your ease of reference. This will help ensure you are ready to meet the demands of your customers and ensure you are prepared for break-fix situations via optimized triage processes.

> [!div class="nextstepaction"]
> [Microsoft's AKS Day 2 Operations Guide](../../operator-guides/aks/day-2-operations-guide.md)

## Stay current with AKS

Kubernetes and AKS are both moving fast. The platform is evolving and just knowing what's on the roadmap might help you make architectural decisions and understand planned deprecations; consider bookmarking it.

> [!div class="nextstepaction"]
> [AKS product roadmap](https://aka.ms/aks/roadmap)

---

## Additional resources

The typical AKS solution journey shown ranges from learning about AKS to growing your existing clusters to meet new product and customer demands. However, you might also just be looking for additional reference and supporting material to help along the way for your specific situation.

### Example solutions

If you're seeking additional references that use AKS as their foundation, here are a few to consider.

* [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
* [Secure DevOps for AKS](../../solution-ideas/articles/secure-devops-for-kubernetes.yml)
* [Building a telehealth system](../../example-scenario/apps/telehealth-system.yml)
* [CI/CD pipeline for container-based workloads](../../guide/aks/aks-cicd-github-actions-and-gitops.yml)

### Azure Arc-enabled Kubernetes

Azure Kubernetes Service offers you a managed Kubernetes experience on Azure, however there are workloads or situations that might be best suited for placing your own Kubernetes clusters under [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes) management. This includes your clusters such as RedHat OpenShift, RedHat RKE, and Canonical Charmed Kubernetes. Azure Arc management can also be used with [Cluster API provider Azure](https://github.com/kubernetes-sigs/cluster-api-provider-azure) clusters to benefit from the Azure Resource Manager representation of the cluster and availability of cluster extensions like Azure Monitor container insights and Azure Policy. Azure Arc-enabled Kubernetes can also be used with [AKS on Azure Stack HCI clusters](/azure-stack/aks-hci/connect-to-arc) and with Kubernetes clusters running on other cloud providers.

> [!div class="nextstepaction"]
> [Azure Arc-enabled Kubernetes](/Azure/azure-arc/kubernetes/overview)

### Managed service provider

If you're a managed service provider, you already use Azure Lighthouse to manage resources for multiple customers. Azure Kubernetes Service supports Azure Lighthouse so that you can manage hosted Kubernetes environments and deploy containerized applications within your customers' tenants.

> [!div class="nextstepaction"]
> [AKS with Azure Lighthouse](/azure/lighthouse/overview)

### AWS or Google Cloud professionals

These articles provide service mapping and comparison between Azure and other cloud services. This reference can help you ramp up quickly on Azure.

* [Containers and container orchestrators for AWS Professionals](../../aws-professional/compute.md#containers-and-container-orchestrators)
* [Containers and container orchestrators for Google Cloud Professionals](../../gcp-professional/services.md#containers-and-container-orchestrators)
