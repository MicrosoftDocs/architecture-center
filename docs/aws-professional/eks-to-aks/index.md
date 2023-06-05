---
title: AKS for Amazon EKS professionals
description: Read about the Azure Kubernetes Service (AKS) managed solution, configurations, best practices, and similarities and differences with Amazon EKS.
author: lanicolas
ms.author: lanicola
ms.date: 12/30/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - containers
  - compute
products:
  - azure-kubernetes-service
---

# AKS for Amazon EKS professionals

This series of articles helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes). The series highlights key similarities and differences between these two managed Kubernetes solutions.

The series articles compare AKS with Amazon EKS for the following Kubernetes design areas:

- [Identity and access management](workload-identity.yml)
- [Cluster logging and monitoring](monitoring.yml)
- [Secure network topologies](private-clusters.yml)
- [Storage options](storage.md)
- [Cost optimization and management](cost-management.yml)
- [Agent node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)

These articles provide recommended architectures and practices to improve AKS deployment security, compliance, management, and observability. For basic AKS implementation, see [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks) and [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator).

AKS isn't the only way to run containers in Azure, and Amazon EKS is only one of the container options for Amazon Web Services (AWS). These articles don't compare Azure services like Azure Container Apps, Azure Container Instances, and Azure App Service with AWS services like Amazon Elastic Container Service or AWS Fargate.

For more information about other Azure services that can host containerized workloads, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree) and [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options).

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

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Software Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.yml)
- [Kubernetes node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)


## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
- [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)

