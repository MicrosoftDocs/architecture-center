---
title: Related resources for multitenancy
titleSuffix: Azure Architecture Center
description: This article provides a set of links and resources for architects and developers of multitenant solutions.
author: johndowns
ms.author: jodowns
ms.date: 08/16/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.category:
  - fcp
ms.custom:
  - guide
---

# Resources for architects and developers of multitenant solutions

## Architectures for multitenant applications

The following articles provide examples of multitenant architectures on Azure.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Multitenant SaaS on Azure](../../example-scenario/multi-saas/multitenant-saas.yml) | Reference architecture for a multitenant SaaS scenario on Azure, which is deployed in multiple regions | Web |
| [Use Application Gateway Ingress Controller with a multi-tenant Azure Kubernetes Service](../../example-scenario/aks-agic/aks-agic.yml) | Example for implementing multitenancy with AKS and AGIC | Kubernetes |
| [Serverless batch processing with Durable Functions in Azure Container Instances](../../solution-ideas/articles/durable-functions-containers.yml) | Use cases include multitenant scenarios, where some tenants need large computing power, while other tenants have small computing requirements | Containers |
| [All multitenant architectures](../../browse/index.yml?terms=multitenant) | Lists all the architectures that include multitenancy | Multiple |

## Cloud design patterns

The following [cloud design patterns](../../patterns/index.md) are frequently used in multitenant architectures.

| Pattern | Summary |
| ------- | ------- |
| [Deployment Stamps pattern](../../patterns/deployment-stamp.yml) | Deploy multiple independent copies (scale units) of application components, including data stores. |
| [Federated Identity](../../patterns/federated-identity.yml) | Delegate authentication to an external identity provider. |
| [Gatekeeper](../../patterns/gatekeeper.yml) | Protect applications and services, by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. |
| [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.yml) | Use a queue that acts as a buffer between a task and a service that it invokes, in order to smooth intermittent heavy loads. |
| [Sharding](../../patterns/sharding.yml) | Divide a data store into a set of horizontal partitions or shards. |
| [Throttling](../../patterns/throttling.yml) | Control the consumption of resources that are used by an instance of an application, an individual tenant, or an entire service. |

## Antipatterns

Consider the [Noisy Neighbor antipattern](../../antipatterns/noisy-neighbor/noisy-neighbor.yml), in which the activity of one tenant can have a negative impact on another tenant's use of the system.

## Microsoft Azure Well-Architected Framework

While the entirety of the [Azure Well-Architected Framework](/azure/architecture/framework/index) is important for all solutions, pay special attention to the [Resiliency pillar](/azure/architecture/framework/resiliency/reliability-patterns#resiliency). The nature of cloud hosting leads to  applications that are often multitenant, use shared platform services, compete for resources and bandwidth, communicate over the internet, and run on commodity hardware. This increases the likelihood that both transient and more permanent faults will arise.

## Multitenant architectural guidance

* [Architecting multitenant solutions on Azure](https://www.youtube.com/watch?v=aem8elgN7iI) (video): This video discusses how to design, architect, and build multitenant solutions on Azure. If you're building a SaaS product or another multitenant service, there's a lot to consider to ensure high performance, tenant isolation, and to manage deployments. This session is aimed at developers and architects who are building multitenant or SaaS applications, including startups and ISVs.
* [Azure Friday - Architecting multitenant solutions on Azure](https://www.youtube.com/watch?v=9nJ8UdJYU4M) (video): This video from Azure Friday discusses how to design, architect, and build multitenant software-as-a-service (SaaS) solutions on Azure.
* [Accelerate and De-Risk Your Journey to SaaS](https://www.youtube.com/watch?v=B8dPAFIG1xA) (video): This video provides guidance for transitioning to the software as a service (SaaS) delivery model - whether you're starting by lifting-and-shifting an existing solution from on-premises to Azure, considering a multitenant architecture, or looking to modernize an existing SaaS web application.

## Resources for Azure services

### Governance and compliance

* [Organizing and managing multiple Azure subscriptions](/azure/cloud-adoption-framework/ready/azure-best-practices/organize-subscriptions): It's important to consider how you manage your Azure subscriptions, as well as how you allocate tenant resources to subscriptions.
* [Cross-tenant management experiences](/azure/lighthouse/concepts/cross-tenant-management-experience): As a service provider, you can use Azure Lighthouse to manage resources, for multiple customers from within your own Azure Active Directory (Azure AD) tenant. Many tasks and services can be performed across managed tenants, by using Azure delegated resource management.
* [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview): In a managed application, the resources are deployed to a resource group that's managed by the publisher of the app. The resource group is present in the consumer's subscription, but an identity in the publisher's tenant has access to the resource group.

### Compute

* [Best practices for cluster isolation in Azure Kubernetes Service](/azure/aks/operator-best-practices-cluster-isolation): AKS provides flexibility in how you can run multitenant clusters and can isolate resources. To maximize your investment in Kubernetes, you must first understand and implement AKS multitenancy and isolation features. This best practices article focuses on isolation for cluster operators.
* [Best practices for cluster security and upgrades in Azure Kubernetes Service](/azure/aks/operator-best-practices-cluster-security): As you manage clusters in Azure Kubernetes Service (AKS), workload and data security is a key consideration. When you run multitenant clusters using logical isolation, you especially need to secure resource and workload access.

### Storage and data

* [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems/): A blog post discussing how to build a multitenant system that uses Azure Cosmos DB.
* [Azure Cosmos DB hierarchical partition keys (private preview)](https://devblogs.microsoft.com/cosmosdb/hierarchical-partition-keys-private-preview/): A blog post announcing the private preview of hierarchical partition keys for the Azure Cosmos DB Core (SQL) API. With hierarchical partition keys, also known as sub-partitioning, you can now natively partition your container with up to three levels of partition keys. This enables more optimal partitioning strategies for multitenant scenarios or workloads that would otherwise use synthetic partition keys.
* [Azure SQL Database multitenant SaaS database tenancy patterns](/azure/azure-sql/database/saas-tenancy-app-design-patterns): A set of articles describing various tenancy models that are available for a multitenant SaaS application, using Azure SQL Database.
* [Running 1 million databases on Azure SQL for a large SaaS provider: Microsoft Dynamics 365 and Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/): A blog post describing how Dynamics 365 team manages databases at scale.
* [Design a multitenant database by using Azure Database for PostgreSQL Hyperscale](/azure/postgresql/tutorial-design-database-hyperscale-multi-tenant)
* [Horizontal, vertical, and functional data partitioning](../../best-practices/data-partitioning.yml): In many large-scale and multitenant solutions, data is divided into partitions that can be managed and accessed separately. Partitioning can improve scalability, reduce contention, and optimize performance. It can also provide a mechanism for dividing data, by the usage pattern and by the tenant.
* [Data partitioning strategies by Azure service](../../best-practices/data-partitioning-strategies.yml): This article describes some strategies for partitioning data in various Azure data stores.
* [Building multitenant applications with Azure Database for PostgreSQL Hyperscale Citus](https://www.youtube.com/watch?v=7gAW08du6kk) (video)
* [Multitenant applications with Azure Cosmos DB](https://www.youtube.com/watch?v=fOQoQnQqwwU) (video)
* [Building a multitenant SaaS with Azure Cosmos DB and Azure](https://www.youtube.com/watch?v=Tht_RV5QPJ0) (video): A real-world case study of how Whally, a multitenant SaaS startup, built a modern platform from scratch on Azure Cosmos DB and Azure. Whally shows the design and implementation decisions they made related to partitioning, data modeling, secure multitenancy, performance, real-time streaming from change feed to SignalR and more, all using ASP.NET Core on Azure App Services.
* [Multitenant design patterns for SaaS applications on Azure SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc) (video)

### Messaging

* [Azure Event Grid domains](/azure/event-grid/event-domains): Azure Event Grid domains allow you to manage multitenant eventing architectures, at scale.

### Identity

* [Tenancy in Azure Active Directory](/azure/active-directory/develop/single-and-multi-tenant-apps): When developing apps, developers can choose to configure their app to be either single-tenant or multitenant, during app registration, in Azure Active Directory.
* [Custom-branded identity solution with Azure AD B2C](/azure/active-directory-b2c/overview): Azure Active Directory B2C is a customer identity access management solution that is capable of supporting millions of users and billions of authentications per day.
* [Identity management in multitenant applications](../../multitenant-identity/index.yml): This series of articles describes best practices for multitenancy, when using Azure AD for authentication and identity management.
* [Build a multi-tenant daemon with the Microsoft identity platform endpoint](/samples/azure-samples/ms-identity-aspnet-daemon-webapp/build-multi-tenant-daemon-aad): This sample application shows how to use the [Microsoft identity platform](/azure/active-directory/develop/v2-overview) endpoint to access the data of Microsoft business customers in a long-running, non-interactive process. It uses the OAuth2 client credentials grant to acquire an access token, which it then uses to call the Microsoft Graph and access organizational data.
* [Authenticate and authorize multitenant apps using Azure Active Directory (Azure AD)](/learn/modules/cna-set-up-azure-ad-use-scale): Learn how Azure Active Directory enables you to improve the functionality of cloud-native apps in multitenant scenarios.
* [Azure Architecture Walkthrough: Building a multi-tenant Azure Architecture for a B2C scenario](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/azure-architecture-walkthrough-building-a-multi-tenant-azure/ba-p/1278357): a walk through the architecture behind a multi-tenant mobile app with Azure Active Directory B2C and API Management.

### Analytics

* [Multitenancy solutions with Power BI embedded analytics](/power-bi/developer/embedded/embed-multi-tenancy): When designing a multitenant application that contains Power BI Embedded, you must carefully choose the tenancy model that best fits your needs.

### IoT

* [Multitenancy in IoT Hub Device Provisioning Service](/azure/iot-dps/how-to-provision-multitenant): A multitenant IoT solution will commonly assign tenant devices, by using a group of IoT hubs that are scattered across regions.

### AI/ML

* [Design patterns for multitenant SaaS applications and Azure Cognitive Search](/azure/search/search-modeling-multitenant-saas-applications): This document discusses tenant isolation strategies for multitenant applications that are built with Azure Cognitive Search.

## Community Content

### Kubernetes
* [Three Tenancy Models For Kubernetes](https://kubernetes.io/blog/2021/04/15/three-tenancy-models-for-kubernetes/): Kubernetes clusters are typically used by several teams in an organization. This article explains three tenancy models for Kubernetes.
* [Understanding Kubernetes Multi Tenancy](https://cloudian.com/guides/kubernetes-storage/understanding-kubernetes-multi-tenancy/): Kubernetes is not a multi-tenant system out of the box. While it is possible to configure multi-tenancy, this can be challenging. This article explains Kubernetes multi-tenancy types.
* [Kubernetes Multi-Tenancy – A Best Practices Guide](https://loft.sh/blog/kubernetes-multi-tenancy-a-best-practices-guide/): Kubernetes multi-tenancy is a topic that more and more organizations are interested in as their Kubernetes usage spreads out. However, since Kubernetes is not a multi-tenant system per se, getting multi-tenancy right comes with some challenges. This article describes these challenges and how to overcome them as well as some useful tools for Kubernetes multi-tenancy.
* [Capsule: Kubernetes multi-tenancy made simple](https://github.com/clastix/capsule): Capsule helps to implement a multi-tenancy and policy-based environment in your Kubernetes cluster. It is not intended to be yet another PaaS, instead, it has been designed as a micro-services-based ecosystem with the minimalist approach, leveraging only on upstream Kubernetes.
* [Loft: Add Multi-Tenancy To Your Clusters](https://github.com/loft-sh/kiosk): Loft provides lightweight Kubernetes extensions for multi-tenancy.
