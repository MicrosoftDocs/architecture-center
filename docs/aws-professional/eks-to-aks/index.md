---
title: Azure Kubernetes Service for EKS professionals
description: Learn about Azure Kubernetes Service as a managed solution, configurations, and best practices along with key similarities and differences between the EKS offering in AWS.
author: lanicolas
categories: azure
ms.author: lanicola, paolos
ms.date: 07/11/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: 
  - azure-kubernetes-service
products:
  - containers
  - storage
  - networking
ms.custom:
  - fcp
---

# Azure Kubernetes Service for EKS professionals

This series of articles will help professionals who are familiar with Amazon Elastic Kubernetes Service (EKS) to understand Azure Kubernetes Service (AKS) while highlighting key similarities and differences between the two managed Kubernetes solutions. The articles provide best practices and automated reference implementations to improve the security, compliance, and observability of your Azure Kubernetes Service deployments.

These articles describe:

- Identity and Access management.
- Cluster observability and monitoring.
- Network topologies.
- Storage options.
- Cost management and optimizations.
- Agent node management.

## Similarities and differences

Please note that AKS is not the only way to run containers Azure, just like EKS is one of the options for AWS. For more information, see [Comparing Container Apps with other Azure container options](https://docs.microsoft.com/en-us/azure/container-apps/compare-options). The scope of this series of articles is to compare AWS EKS with [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS). It does not contrast other Azure services such as Azure Container Apps, Azure Red Hat Openshift, Azure Container Instance, or Azure App Service with AWS services like Amazon Elastic Container Service or AWS Fargate. For more information on the different Azure services you can use to host your containerized workloads, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree)

Azure Kubernetes service is a managed Kubernetes cluster just like EKS, this means that Microsoft as a service provider is responsible for the deployment and management of the control plane, this reduces the complexity of deployment and core management tasks. The Azure platform manages the AKS control plane, and you only pay for the AKS agent nodes that run your applications.

Just like EKS, Azure Kubernetes Service (AKS) builds on top of a core set of compute, storage and networking services along with operational tooling. In many cases, the platforms offer comparable products and services, however, there may be important best practices and design differences.

## Amazon Elastic Kubernetes Service (EKS) to Azure Kubernetes Service guidance

The following articles provide best practices for the specific design areas:

- [Kubernetes Pod Identity](./iam/pod-identity-content.md)
- [Cost Management for a Kubernetes Cluster](./cost-management/cost-management-content.md)
- [Kubernetes Monitoring and Logging](./monitoring/monitoring-content.md)
- [Secure network access to Kubernetes API](./networking/private-clusters-content.md)
- [Agent node management](./nodes/node-pools-content.md)
- [Kubernetes Storage options](./storage/storage-content.md)

## Next Steps

To review and compare Azure and AWS core components review the following articles that compare the platforms' capabilities in these core areas:

- [Azure and AWS accounts and subscriptions](../accounts.md)
- [Compute services on Azure and AWS](../compute.md)
- [Relational database technologies on Azure and AWS](../databases.md)
- [Messaging services on Azure and AWS](../messaging.md)
- [Networking on Azure and AWS](../networking.md)
- [Regions and zones on Azure and AWS](../regions-zones.md)
- [Resource management on Azure and AWS](../resources.md)
- [Multi-cloud security and identity with Azure and AWS](../security-identity.md)
- [Compare storage on Azure and AWS](../storage.md)