---
title: AKS for Amazon EKS Professionals
description: Learn about the AKS managed solution, configurations, best practices, and similarities and differences compared to Amazon EKS.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
ms.custom:
  - arb-containers
---

# AKS for Amazon EKS professionals

This series of articles helps professionals who are familiar with Amazon Elastic Kubernetes Service (EKS) understand [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes). The series highlights key similarities and differences between these two managed Kubernetes solutions.

The articles compare AKS with Amazon EKS in the following Kubernetes design areas:

- [Identity and access management](workload-identity.md)
- [Cluster logging and monitoring](monitoring.md)
- [Secure network topologies](private-clusters.md)
- [Storage options](storage.md)
- [Cost optimization and management](cost-management.md)
- [Agent node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
- [Workload migration](migrate.md)

These articles provide recommended architectures and practices to improve AKS deployment security, compliance, management, and observability. Specifically, the [Migrate EKS to AKS](migrate.md) article provides strategies to migrate typical stateless and stateful workloads. For basic AKS implementation, see [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks) and [Cloud Adoption Framework guidance for adopting AKS in an Azure landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator).

AKS isn't the only way to run containers in Azure, and Amazon EKS is only one of the container options for Amazon Web Services (AWS). These articles don't compare Azure services like Azure Container Apps, Azure Container Instances, and Azure App Service with AWS services like Amazon Elastic Container Service or AWS Fargate.

For more information about other Azure services that can host containerized workloads, see the following articles:

- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md)
- [Choose an Azure container service](../../guide/choose-azure-container-service.md)
- [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options)
- [General architectural considerations to choose an Azure container service](../../guide/container-service-general-considerations.md)

The following articles compare Azure and AWS core platform components and capabilities:

- [Azure and AWS accounts and subscriptions](../accounts.md)
- [Compute services on Azure and AWS](../compute.md)
- [Relational database technologies on Azure and AWS](../databases.md)
- [Messaging services on Azure and AWS](../messaging.md)
- [Networking on Azure and AWS](../networking.md)
- [Regions and zones on Azure and AWS](../regions-zones.md)
- [Resource management on Azure and AWS](../resources.md)
- [Multicloud identity with Azure and AWS](../security-identity.md)
- [Storage on Azure and AWS](../storage.md)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml)
- [Cloud Adoption Framework guidance for adopting AKS in Azure landing zones](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)

## Related resources

- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
