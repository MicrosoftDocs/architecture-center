---
title: AKS for Amazon EKS professionals
description: Understand AKS as a managed solution, configurations, best practices, similarities and differences with Amazon EKS.
author: lanicolas
ms.author: lanicola, paolos
ms.date: 09/19/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - containers
  - compute
products:
  - azure-kubernetes-service
---

## AKS for Amazon EKS professionals

This series of articles helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS). The series highlights key similarities and differences between these two managed Kubernetes solutions.

The following articles compare AKS and Amazon EKS for specific Kubernetes design areas:

- [Identity and access management](workload-identity.yml)
- [Cluster observability and monitoring](monitoring.yml)
- [Network topologies and security](private-clusters.yml)
- [Storage options](storage.md)
- [Cost management and optimization](cost-management.yml)
- [Agent node management](node-pools.yml)

AKS isn't the only way to run containers in Azure, and Amazon EKS is only one of the container options for Amazon Web Services (AWS). These articles don't compare Azure services like Azure Container Apps, Azure Red Hat Openshift, Azure Container Instance, or Azure App Service with AWS services like Amazon Elastic Container Service or AWS Fargate. For more information on the Azure services that can host containerized workloads, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree) and [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options).

These articles provide best practices and recommended architectures to improve AKS deployment security, compliance, and observability. For basic AKS implementation references and content, see the [AKS baseline](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks) and the [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator).

## Next step

> [!div class="nextstepaction"]
> [Kubernetes identity and access management](workload-identity.yml)

## Related resources

The following articles compare Azure and AWS core platform components and capabilities:

- [Azure and AWS accounts and subscriptions](../accounts.md)
- [Compute services on Azure and AWS](../compute.md)
- [Relational database technologies on Azure and AWS](../databases.md)
- [Messaging services on Azure and AWS](../messaging.md)
- [Networking on Azure and AWS](../networking.md)
- [Regions and zones on Azure and AWS](../regions-zones.md)
- [Resource management on Azure and AWS](../resources.md)
- [Multicloud security and identity with Azure and AWS](../security-identity.md)
- [Compare storage on Azure and AWS](../storage.md)
