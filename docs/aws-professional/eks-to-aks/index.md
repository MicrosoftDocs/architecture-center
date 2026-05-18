---
title: AKS for Amazon EKS Professionals
description: Learn about the AKS managed solution, configurations, best practices, and similarities and differences compared to Amazon EKS.
author: pranabpaul-tech
ms.author: pranabp
ms.date: 05/18/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
ms.custom:
  - arb-containers
---

# AKS for Amazon EKS professionals

This series of articles guides Amazon EKS professionals transitioning to  [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks). This series evaluates the core similarities and differences between both managed Kubernetes platforms. The scope includes both EKS Standard and EKS Auto, and similar offerings within AKS - AKS Standard and AKS Automatic.

The articles compare AKS with Amazon EKS in the following Kubernetes design areas:

- [Identity and access management](workload-identity.md)
- [Cluster logging and monitoring](monitoring.md)
- [Secure network topologies](private-clusters.md)
- [Storage options](storage.md)
- [Cost optimization and management](cost-management.md)
- [Agent node and node pool management](node-pools.md)
- [Cluster governance](governance.md)

For greenfield AKS implementations, see [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml). To build a foundational understanding of AKS, review [Get started with Azure Kubernetes Service (AKS) basics - Azure Kubernetes Service | Microsoft Learn](/azure/aks/get-started-aks).

Both Azure Kubernetes Service (AKS) and Amazon Elastic Kubernetes Service (EKS) provides a fully managed Kubernetes environment that eliminates the complexity of operating Kubernetes clusters. In parallel, Azure as well as AWS offer multiple alternatives to their flagship Kubernetes services for running containers beyond just AKS and EKS. 

Azure Container Options
- Azure Container Apps: Best for serverless microservices.
- Azure Container Instances (ACI): Ideal for quick, isolated containers.
- Azure App Service: Optimized for web applications. 

AWS Container Options 
- Amazon ECS: A powerful, native alternative to Kubernetes.
- AWS Fargate: Serverless execution for containers.
- AWS App Runner: Simplified deployment for web apps

These articles don't compare Azure and AWS services mentioned above and keep focused on AKS and EKS only. Also, hybrid options such as AWS Outpost/Hybrid or Azure Local/Hybrid and RedHat OpenShift Services like Amazon ROSA or Azure ARO are not part of these articles.

For more information about other Azure services that can host containerized workloads, see the following articles:

- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md)
- [Choose an Azure container service](../../guide/choose-azure-container-service.md)
- [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options)
- [General architectural considerations to choose an Azure container service](../../guide/container-service-general-considerations.md)

## Migration resources

The following resources help you plan and carry out a migration from Amazon EKS to AKS:

- [Migrate from Amazon EKS to AKS](migrate.md): Strategies to migrate typical stateless and stateful workloads from EKS to AKS, including container image migration, Kubernetes manifest adaptation, and data migration.

- [Migrate compute from AWS to Azure](/azure/migration/migrate-compute-from-aws): A catalog of compute migration scenarios, including EKS-to-AKS scenarios. Examples of such scenarios include:

  - [Migrate an AWS event-driven workload to AKS](/azure/aks/eks-edw-overview): A step-by-step scenario for migrating an EKS event-driven workload that uses KEDA and Karpenter to AKS.

  - [Migrate an EKS web application to AKS](/azure/aks/eks-web-overview): A step-by-step scenario for migrating an EKS web application with AWS WAF to AKS with Azure Web Application Firewall.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect
- [Pranab Paul](https://www.linkedin.com/in/pranabpaul/) | Senior Global Partner Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
