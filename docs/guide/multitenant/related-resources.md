---
title: Related Resources for Multitenancy
description: This article provides a set of links and resources for architects and developers of multitenant solutions.
author: johndowns
ms.author: pnp
ms.date: 04/17/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---

# Related resources for multitenancy

This article provides a set of links and resources for architects and developers of multitenant solutions.


## Architectures for multitenant applications

The following articles provide examples of multitenant architectures on Azure.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Use Application Gateway Ingress Controller (AGIC) with a multitenant Azure Kubernetes Service (AKS) cluster](../../example-scenario/aks-agic/aks-agic.yml) | Example for how to implement multitenancy with AKS and AGIC | Kubernetes |
| [All multitenant architectures](../../browse/index.yml?terms=multitenant) | Lists all the architectures that include multitenancy | Multiple |

## Cloud design patterns

The following [cloud design patterns](../../patterns/index.md) are frequently used in multitenant architectures.

| Pattern | Summary |
| ------- | ------- |
| [Deployment Stamps pattern](../../patterns/deployment-stamp.yml) | Deploy multiple independent copies (or scale units) of application components, including data stores. |
| [Federated Identity](../../patterns/federated-identity.yml) | Delegate authentication to an external identity provider. |
| [Gatekeeper](../../patterns/gatekeeper.yml) | Protect applications and services by using a dedicated host instance that serves as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. |
| [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.yml) | Use a queue that serves as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. |
| [Sharding](../../patterns/sharding.yml) | Divide a data store into a set of horizontal partitions or shards. |
| [Throttling](../../patterns/throttling.yml) | Control the consumption of resources that an application instance, an individual tenant, or an entire service uses. |

## Antipatterns

Consider the [Noisy Neighbor antipattern](../../antipatterns/noisy-neighbor/noisy-neighbor.yml), in which the activity of one tenant can negatively affect another tenant's use of the system.

## Microsoft Azure Well-Architected Framework

If you design a SaaS, use the [Microsoft Azure Well-Architected Framework workload for SaaS](/azure/well-architected/saas/) to get actionable architectural guidance that's specific to SaaS solutions.

The entirety of the [Well-Architected Framework](/azure/well-architected/) is important for all solutions, including multitenant architectures, but pay special attention to the [Reliability pillar](/azure/well-architected/reliability/). The nature of cloud hosting results in applications that are often multitenant, use shared platform services, compete for resources and bandwidth, communicate over the internet, and run on commodity hardware. This environment increases the likelihood that both transient and more permanent faults will occur.

## Multitenant architectural guidance

- [Architect multitenant solutions on Azure](https://www.youtube.com/watch?v=aem8elgN7iI) (video): This video describes how to design, architect, and build multitenant solutions on Azure. If you build a SaaS product or another multitenant service, there's a lot to consider when you plan for high performance, tenant isolation, and deployment management. This session is aimed at developers and architects who build multitenant or SaaS applications, including startups and ISVs.

- [Azure Friday - Architect multitenant solutions on Azure](https://www.youtube.com/watch?v=9nJ8UdJYU4M) (video): This video from Azure Friday describes how to design, architect, and build multitenant SaaS solutions on Azure.

- [Accelerate and de-risk your journey to SaaS](https://www.youtube.com/watch?v=B8dPAFIG1xA) (video): This video provides guidance on how to transition to the SaaS delivery model, whether you're lifting and shifting an existing solution from on-premises to Azure, considering a multitenant architecture, or modernizing an existing SaaS web application.

## Resources for Azure services

Use the following resources to help you build multitenant architectures on Azure.

### Governance and compliance

- [Organize and manage multiple Azure subscriptions](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions): It's important to consider how you manage your Azure subscriptions and how you allocate tenant resources to subscriptions.

- [Cross-tenant management experiences](/azure/lighthouse/concepts/cross-tenant-management-experience): As a service provider, you can use Azure Lighthouse to manage resources for multiple customers from within your own Microsoft Entra tenant. Many tasks and services can be performed across managed tenants by using Azure delegated resource management.

- [Azure-managed applications](/azure/azure-resource-manager/managed-applications/overview): In a managed application, the resources are deployed to a resource group that the publisher of the app manages. The resource group is present in the consumer's subscription, but an identity in the publisher's tenant has access to the resource group.

### Compute

- [Best practices for cluster isolation in AKS](/azure/aks/operator-best-practices-cluster-isolation): AKS provides flexibility in how you can run multitenant clusters and can isolate resources. To maximize your investment in Kubernetes, you must first understand and implement AKS multitenancy and isolation features. This best practices article focuses on isolation for cluster operators.

- [Best practices for cluster security and upgrades in AKS](/azure/aks/operator-best-practices-cluster-security): As you manage clusters in AKS, workload and data security is a key consideration. When you run multitenant clusters by using logical isolation, securing resource and workload access is crucial.

### Networking

#### Azure Private Link

[!INCLUDE[](includes/private-link-resources.md)]

#### Web

- [Claims-based routing for SaaS solutions](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/claims-based-routing-for-saas-solutions/ba-p/3865707): This article describes the usage of a reverse proxy to facilitate tenant routing and mapping requests to tenants, enhancing the management of back-end services in SaaS solutions.
  
### Storage and data

- [Design and build multitenant SaaS apps at scale with Azure Cosmos DB](https://www.youtube.com/watch?v=dd7W_kMh-z4) (video): Learn how to design and optimize multitenant SaaS applications by using Azure Cosmos DB. This session explores key design considerations related to tenant isolation, cost optimization, and global distribution. The contents of this session apply whether you have a high volume of small business-to-consumer (B2C) tenants or a low volume of highly skewed business-to-business tenants.

- [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems/): A blog post that discusses how to build a multitenant system that uses Azure Cosmos DB.

- [Azure Cosmos DB hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys): By using hierarchical partition keys, also known as subpartitioning, you can natively partition your container with multiple levels of partition keys. This approach enables more optimal partitioning strategies for multitenant scenarios or workloads that would otherwise use synthetic partition keys.

- [Azure SQL Database multitenant SaaS database tenancy patterns](/azure/azure-sql/database/saas-tenancy-app-design-patterns): A set of articles that describe various tenancy models that are available for a multitenant SaaS application, using Azure SQL Database.

- [Running 1 million databases on Azure SQL for a large SaaS provider: Microsoft Dynamics 365 and Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/): A blog post that describes how the Dynamics 365 team manages databases at scale.

- [Design a multitenant database by using Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/tutorial-design-database-multi-tenant)

- [Horizontal, vertical, and functional data partitioning](../../best-practices/data-partitioning.yml): In many large-scale and multitenant solutions, data is divided into partitions that can be managed and accessed separately. Partitioning can improve scalability, reduce contention, and optimize performance. It can also provide a mechanism for dividing data, by the usage pattern and by the tenant.

- [Data partitioning strategies by Azure service](../../best-practices/data-partitioning-strategies.yml): This article describes some strategies for partitioning data in various Azure data stores.

- [Build multitenant applications with Azure Database for PostgreSQL Hyperscale Citus](https://www.youtube.com/watch?v=7gAW08du6kk) (video)

- [Multitenant applications with Azure Cosmos DB](https://www.youtube.com/watch?v=fOQoQnQqwwU) (video)

- [Build a multitenant SaaS with Azure Cosmos DB and Azure](https://www.youtube.com/watch?v=Tht_RV5QPJ0) (video): A real-world case study of how Whally, a multitenant SaaS startup, built a modern platform from scratch on Azure Cosmos DB and Azure. Whally shows the design and implementation decisions they made related to partitioning, data modeling, secure multitenancy, performance, and real-time streaming from change feed to SignalR, all using ASP.NET Core on Azure App Services.

- [Multitenant design patterns for SaaS applications on Azure SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc) (video)

### Messaging

- [Azure Event Grid domains](/azure/event-grid/event-domains): Azure Event Grid domains allow you to manage multitenant eventing architectures, at scale.

- [Cross-tenant communication by using Azure Service Bus](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus): Sample implementation of Azure Service Bus that shows how to communicate between a central provider and one or more customers (or tenants).

### Identity

- [Tenancy in Microsoft Entra ID](/entra/identity-platform/single-and-multi-tenant-apps): Microsoft Entra ID has its own concept of multitenancy, which refers to operating across multiple Microsoft Entra directories. When developers work with Microsoft Entra apps, they can choose to configure their app to be either single-tenant or multitenant to support different scenarios.

- [Build a multitenant daemon with the Microsoft identity platform endpoint](https://github.com/Azure-Samples/ms-identity-aspnet-daemon-webapp): This sample application shows how to use the [Microsoft identity platform](/entra/identity-platform/v2-overview) endpoint to access the data of Microsoft business customers in a long-running, non-interactive process. It uses the OAuth2 client credentials grant to acquire an access token, which it then uses to call the Microsoft Graph and access organizational data.

- [Authenticate and authorize multitenant apps using Microsoft Entra ID](/training/modules/cna-set-up-azure-ad-use-scale): Learn how Microsoft Entra ID enables you to improve the functionality of cloud-native apps in multitenant scenarios.

- [Define and implement permissions, roles, and scopes with Microsoft Entra ID in SaaS solutions](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/define-and-implement-permissions-roles-and-scopes-with-azure/ba-p/3810264): This article covers three main concepts related to Microsoft Entra authentication and authorization, which SaaS providers can use. It covers Application Roles functionality, Delegated & Application permissions, and Scopes functionality.
  
### Analytics

- [Multitenancy solutions with Power BI embedded analytics](/power-bi/developer/embedded/embed-multi-tenancy): When you design a multitenant application that contains Power BI Embedded, you must carefully choose the tenancy model that best fits your needs.

### IoT

- [Multitenancy in IoT Hub Device Provisioning Service](/azure/iot-dps/how-to-provision-multitenant): A multitenant IoT solution commonly assigns tenant devices by using a group of IoT hubs that are spread across regions.

### AI and machine learning

- [Guide to design a secure multitenant Retrieval-Augmented Generation (RAG) inferencing solution](../../ai-ml/guide/secure-multitenant-rag.md): This document describes how to apply the RAG pattern within multitenant solutions, where tenant-specific data needs to be used for inferencing.

- [Design patterns for multitenant SaaS applications and Azure AI Search](/azure/search/search-modeling-multitenant-saas-applications): This document describes tenant isolation strategies for multitenant applications that are built with AI Search.

- [A solution for the machine learning pipeline in multitenancy manner](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/a-solution-for-ml-pipeline-in-multi-tenancy-manner/ba-p/4124818): This blog post describes how Azure Machine Learning pipelines can be designed to support multiple tenants by using Azure Machine Learning workspaces.

## Community content

### Kubernetes

- [Three tenancy models for Kubernetes](https://kubernetes.io/blog/2021/04/15/three-tenancy-models-for-kubernetes/): Kubernetes clusters are typically used by several teams in an organization. This article explains three tenancy models for Kubernetes.

- [Understand Kubernetes multitenancy](https://cloudian.com/guides/kubernetes-storage/understanding-kubernetes-multi-tenancy/): Kubernetes isn't a multitenant system out of the box. It requires custom configuration. This article explains Kubernetes multitenancy types.

- [Kubernetes multitenancy best practices guide](https://loft.sh/blog/kubernetes-multi-tenancy-a-best-practices-guide/): Kubernetes multitenancy is a topic that organizations are increasingly interested in as their Kubernetes usage spreads out. However, because Kubernetes isn't explicitly a multitenant system, it can be challenging to design a multitenant Kubernetes implementation. This article describes these challenges, how to overcome them, and some useful tools for Kubernetes multitenancy.

- [Capsule: Kubernetes multitenancy made simple](https://capsule.clastix.io/): Capsule helps to implement a multitenancy and policy-based environment in your Kubernetes cluster. It isn't a platform as a service (PaaS) offering, but instead is a microservices-based ecosystem with a minimalist design approach, using only upstream Kubernetes.

- [Crossplane: The cloud-native control plane framework](https://www.crossplane.io/): Crossplane enables you to build control planes for your own solution by using a Kubernetes-based approach.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [LaBrina Loving](https://www.linkedin.com/in/chixcancode) | Principal Customer Engineering Manager, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*
