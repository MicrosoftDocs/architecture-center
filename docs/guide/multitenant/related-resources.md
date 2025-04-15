---
title: Related resources for multitenancy
titleSuffix: Azure Architecture Center
description: This article provides a set of links and resources for architects and developers of multitenant solutions.
author: johndowns
ms.author: jodowns
ms.date: 07/10/2024
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - arb-saas
---

# Resources for architects and developers of multitenant solutions

## Architectures for multitenant applications

The following articles provide examples of multitenant architectures on Azure.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Multitenant SaaS on Azure](../../example-scenario/multi-saas/multitenant-saas.yml) | Reference architecture for a multitenant SaaS scenario on Azure, which is deployed in multiple regions | Web |
| [Use Application Gateway Ingress Controller with a multitenant Azure Kubernetes Service (AKS)](../../example-scenario/aks-agic/aks-agic.yml) | Example for implementing multitenancy with AKS and AGIC | Kubernetes |
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

If you're designing software as a service (SaaS), use the [Azure Well-Architected Framework workload for SaaS](/azure/well-architected/saas/) to get actionable architectural guidance specific to SaaS solutions.

While the entirety of the [Azure Well-Architected Framework](/azure/well-architected/) is important for all solutions, including multitenant architectures, pay special attention to the [Reliability pillar](/azure/well-architected/reliability/). The nature of cloud hosting leads to applications that are often multitenant, use shared platform services, compete for resources and bandwidth, communicate over the internet, and run on commodity hardware. This increases the likelihood that both transient and more permanent faults will arise.

## Multitenant architectural guidance

* [Architecting multitenant solutions on Azure](https://www.youtube.com/watch?v=aem8elgN7iI) (video): This video discusses how to design, architect, and build multitenant solutions on Azure. If you're building a SaaS product or another multitenant service, there's a lot to consider when you plan for high performance, tenant isolation, and to manage deployments. This session is aimed at developers and architects who are building multitenant or SaaS applications, including startups and ISVs.
* [Azure Friday - Architecting multitenant solutions on Azure](https://www.youtube.com/watch?v=9nJ8UdJYU4M) (video): This video from Azure Friday discusses how to design, architect, and build multitenant software-as-a-service (SaaS) solutions on Azure.
* [Accelerate and De-Risk Your Journey to SaaS](https://www.youtube.com/watch?v=B8dPAFIG1xA) (video): This video provides guidance for transitioning to the software as a service (SaaS) delivery model - whether you're starting by lifting-and-shifting an existing solution from on-premises to Azure, considering a multitenant architecture, or looking to modernize an existing SaaS web application.

## Resources for Azure services

### Governance and compliance

* [Organizing and managing multiple Azure subscriptions](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions): It's important to consider how you manage your Azure subscriptions, as well as how you allocate tenant resources to subscriptions.
* [Cross-tenant management experiences](/azure/lighthouse/concepts/cross-tenant-management-experience): As a service provider, you can use Azure Lighthouse to manage resources, for multiple customers from within your own Microsoft Entra tenant. Many tasks and services can be performed across managed tenants, by using Azure delegated resource management.
* [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview): In a managed application, the resources are deployed to a resource group that's managed by the publisher of the app. The resource group is present in the consumer's subscription, but an identity in the publisher's tenant has access to the resource group.

### Compute

* [Best practices for cluster isolation in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-cluster-isolation): AKS provides flexibility in how you can run multitenant clusters and can isolate resources. To maximize your investment in Kubernetes, you must first understand and implement AKS multitenancy and isolation features. This best practices article focuses on isolation for cluster operators.
* [Best practices for cluster security and upgrades in Azure Kubernetes Service](/azure/aks/operator-best-practices-cluster-security): As you manage clusters in Azure Kubernetes Service (AKS), workload and data security is a key consideration. When you run multitenant clusters using logical isolation, you especially need to secure resource and workload access.

### Networking

#### Private Link

[!include[](includes/private-link-resources.md)]

#### Web

* [Claims based routing for SaaS solutions](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/claims-based-routing-for-saas-solutions/ba-p/3865707): This article discusses the usage of a reverse proxy to facilitate tenant routing and mapping requests to tenants, enhancing the management of backend services in SaaS solutions.
  
### Storage and data

* [Design and build multitenant SaaS apps at scale with Azure Cosmos DB](https://www.youtube.com/watch?v=dd7W_kMh-z4) (video): Learn how to design and optimize multitenant SaaS applications using Azure Cosmos DB. This session explores key design considerations related to tenant isolation, cost optimization, and global distribution. The contents of this session applies whether you have a high volume of small B2C tenants or a low volume of highly skewed B2B tenants.
* [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems/): A blog post discussing how to build a multitenant system that uses Azure Cosmos DB.
* [Azure Cosmos DB hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys): By using hierarchical partition keys, also known as subpartitioning, you can natively partition your container with multiple levels of partition keys. This enables more optimal partitioning strategies for multitenant scenarios or workloads that would otherwise use synthetic partition keys.
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
* [Service Bus sample: Cross-tenant communication using Azure Service Bus](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus): Sample implementation of Azure Service Bus that shows how to communicate between a central provider and one or more customers (tenants).

### Identity

* [Tenancy in Microsoft Entra ID](/azure/active-directory/develop/single-and-multi-tenant-apps): Microsoft Entra ID has its own concept of multitenancy, which refers to operating across multiple Microsoft Entra directories. When developers work with Microsoft Entra apps, they can choose to configure their app to be either single-tenant or multitenant to support different scenarios.
* [Custom-branded identity solution with Azure AD B2C](/azure/active-directory-b2c/overview): Azure Active Directory B2C is a customer identity access management solution that is capable of supporting millions of users and billions of authentications per day.
* [Build a multitenant daemon with the Microsoft identity platform endpoint](https://github.com/Azure-Samples/ms-identity-aspnet-daemon-webapp): This sample application shows how to use the [Microsoft identity platform](/azure/active-directory/develop/v2-overview) endpoint to access the data of Microsoft business customers in a long-running, non-interactive process. It uses the OAuth2 client credentials grant to acquire an access token, which it then uses to call the Microsoft Graph and access organizational data.
* [Authenticate and authorize multitenant apps using Microsoft Entra ID](/training/modules/cna-set-up-azure-ad-use-scale): Learn how Microsoft Entra ID enables you to improve the functionality of cloud-native apps in multitenant scenarios.
* [Azure Architecture Walkthrough: Building a multitenant Azure Architecture for a B2C scenario](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/azure-architecture-walkthrough-building-a-multi-tenant-azure/ba-p/1278357): a walk through the architecture behind a multitenant mobile app with Azure Active Directory B2C and API Management.
* [Define and implement permissions, roles, and scopes with Microsoft Entra ID in SaaS solution](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/define-and-implement-permissions-roles-and-scopes-with-azure/ba-p/3810264): This article covers three main concepts related to Microsoft Entra authentication & authorization, which can be used by SaaS providers. It covers Application Roles functionality, Delegated & Application permissions, and Scopes functionality.
  
### Analytics

* [Multitenancy solutions with Power BI embedded analytics](/power-bi/developer/embedded/embed-multi-tenancy): When designing a multitenant application that contains Power BI Embedded, you must carefully choose the tenancy model that best fits your needs.

### IoT

* [Multitenancy in IoT Hub Device Provisioning Service](/azure/iot-dps/how-to-provision-multitenant): A multitenant IoT solution commonly assigns tenant devices by using a group of IoT hubs that are spread across regions.

### AI/ML

* [Guide to design a secure multitenant RAG inferencing solution](../../ai-ml/guide/secure-multitenant-rag.md): This document describes how to apply the Retrieval-Augmented Generation (RAG) pattern within multitenant solutions, where tenant-specific data needs to be used for inferencing.
* [Design patterns for multitenant SaaS applications and Azure AI Search](/azure/search/search-modeling-multitenant-saas-applications): This document discusses tenant isolation strategies for multitenant applications that are built with AI Search.
* [A Solution for ML Pipeline in Multi-tenancy Manner](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/a-solution-for-ml-pipeline-in-multi-tenancy-manner/ba-p/4124818): This blog post describes how Azure Machine Learning pipelines can be designed to support multiple tenants by using Azure Machine Learning workspaces.

## Community content

### Kubernetes

* [Three Tenancy Models For Kubernetes](https://kubernetes.io/blog/2021/04/15/three-tenancy-models-for-kubernetes/): Kubernetes clusters are typically used by several teams in an organization. This article explains three tenancy models for Kubernetes.
* [Understanding Kubernetes Multi Tenancy](https://cloudian.com/guides/kubernetes-storage/understanding-kubernetes-multi-tenancy/): Kubernetes isn't a multitenant system out of the box, and requires custom configuration. This article explains Kubernetes multitenancy types.
* [Kubernetes Multi-Tenancy – A Best Practices Guide](https://loft.sh/blog/kubernetes-multi-tenancy-a-best-practices-guide/): Kubernetes multitenancy is a topic that organizations are increasingly interested in as their Kubernetes usage spreads out. However, because Kubernetes isn't explicitly a multitenant system, it can be challenging to design a multitenant Kubernetes implementation. This article describes these challenges and how to overcome them, and some useful tools for Kubernetes multitenancy.
* [Capsule: Kubernetes multi-tenancy made simple](https://capsule.clastix.io/): Capsule helps to implement a multitenancy and policy-based environment in your Kubernetes cluster. It isn't a platform as a service (PaaS) offering, but instead is a microservices-based ecosystem with a minimalist design approach, using only upstream Kubernetes.
* [Crossplane: The cloud native control plane framework](https://www.crossplane.io/): Crossplane enables you to build control planes for your own solution, by using a Kubernetes-based approach.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs) | Principal Software Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [LaBrina Loving](https://www.linkedin.com/in/chixcancode) | Principal Customer Engineering Manager, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
