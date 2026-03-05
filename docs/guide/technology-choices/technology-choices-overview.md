---
title: Technology Choices for Azure Solutions
description: Learn where to find Azure technology guidance across compute, data, analytics, networking, and AI by using curated comparison and choice resources.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/16/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Technology choices for Azure solutions

When you design an Azure solution, you must select the right technologies for your workload across compute, data, networking, and other areas. The following resources include comparison matrices, flowcharts, and decision trees to help you evaluate your options and find the best match for your requirements.

## Choose a compute service

The term *compute* refers to the hosting model for the computing resources that your application runs on. The following articles can help you choose the right technologies.

| Article | Summary |
| :------ | :------ |
| [Choose an Azure compute service](compute-decision-tree.md) | Decide which compute service best suits your application. |
| [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md) | Learn about two compute options for microservices: service orchestrator and serverless architecture. |
| [Compare Java application hosting options on Azure](service-for-java-comparison.yml) | Explore recommended strategies for hosting Java applications on Azure, including platform types and supportability. |
| [Choose between traditional web apps and single-page applications (SPAs)](/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps) | Learn how to choose between traditional web apps and SPAs. |

## Choose a container option

You can use multiple methods to build and deploy containerized applications in Azure. The following articles can help you evaluate container services.

| Article | Summary |
| :------ | :------ |
| [Choose an Azure container service](../choose-azure-container-service.md) | Evaluate which Azure container service best suits your specific workload scenarios and requirements. |
| [Compare Azure Container Apps with other Azure container options](/azure/container-apps/compare-options) | Learn when to use Container Apps and how it compares to other container options, including Azure Container Instances, Azure App Service, Azure Functions, and Azure Kubernetes Service (AKS). |
| [Choose a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md) | Learn about trade-offs and considerations for various Kubernetes options for extending compute at the edge. |

## Choose a hybrid option

Many organizations need a hybrid approach for analytics, automation, and services because they host data both on-premises and in the cloud. The following articles can help you choose the best technologies for your scenario.

| Article | Summary |
| :------ | :------ |
| [Explore Azure hybrid options](hybrid-considerations.yml) | Learn about Azure hybrid solutions, including alternatives to deploy and host hybrid services on-premises, at the edge, in Azure, and in other clouds. |
| [Compare Azure Stack Hub to Azure](/azure-stack/user/azure-stack-considerations) | Learn the differences between Azure and Azure Stack Hub. |
| [Compare Azure Local to Windows Server](/azure/azure-local/concepts/compare-windows-server) | Choose between Azure Local and Windows Server for your organization. |
| [Choose drives for Azure Local and Windows Server clusters](/windows-server/storage/storage-spaces/choose-drives) | Learn how to choose drives for Azure Local and Windows Server clusters to meet performance and capacity requirements. |

## Choose an identity service

Identity solutions help you protect your data and resources. The following articles can help you choose an Azure identity service.

| Article | Summary |
| :------ | :------ |
| [Compare Microsoft Entra ID and Domain Services identity solutions](/entra/identity/domain-services/compare-identity-solutions) | Compare the identity services of Active Directory Domain Services, Microsoft Entra ID, and Microsoft Entra Domain Services. |
| [Choose a hybrid identity authentication method](/entra/identity/hybrid/connect/choose-ad-authn) | Choose an authentication method for a Microsoft Entra hybrid identity solution in a medium-sized to large organization. |

## Choose a storage service

Azure provides multiple storage services for different access patterns, performance tiers, and data types. The following articles can help you determine the best fit for your workload.

| Article | Summary |
| :------ | :------ |
| [Review your storage options](/azure/architecture/guide/technology-choices/storage-options) | Review the storage options for Azure workloads. |
| [Learn about Azure Managed Disk types](/azure/virtual-machines/disks-types) | Learn about the disk types for Azure virtual machines (VMs), including Azure Ultra Disk Storage, Azure Premium SSD v2, Premium SSD, and Azure Standard SSD. |
| [Choose a data transfer technology](../../data-guide/scenarios/data-transfer.md) | Learn about Azure data transfer options like the Azure Import/Export service, Azure Data Box, Azure Data Factory, and command-line and graphical interface tools. |

## Choose a data store

Choose the right data store based on your data model, access patterns, scale, and consistency requirements. The following articles can help you choose a data solution.

| Article | Summary |
| :------ | :------ |
| [Evaluate data models](../../data-guide/technology-choices/understand-data-store-models.md) | Learn how to evaluate Azure data store models based on workload patterns, scale, consistency, and governance. |
| [Prepare to choose a data store](data-stores-getting-started.md) | Learn how to choose the right Azure data store for your workloads by evaluating functional, performance, cost, and security requirements. |
| [Choose a big data storage technology](../../data-guide/technology-choices/data-storage.md) | Compare big data storage options in Azure. View key selection criteria and a capability matrix. |
| [OLAP solutions](../../data-guide/relational-data/online-analytical-processing.md) | Learn about online analytical processing (OLAP) solutions for organizing large databases and supporting complex analysis without affecting transactional systems. |
| [Learn about online transaction processing (OLTP) solutions](../../data-guide/relational-data/online-transaction-processing.md) | Learn about atomicity, consistency, and other features of OLTP, which manages transactional data and supports querying. |
| [Learn about data lakes](../../data-guide/scenarios/data-lake.md) | Learn about data lake storage repositories, which can hold terabytes (TBs) or petabytes (PBs) of data in a native, raw format. |
| [Choose a data pipeline orchestration technology](../../data-guide/technology-choices/pipeline-orchestration-data-movement.md) | Choose an Azure data pipeline orchestration technology to automate pipeline orchestration, control flow, and move data. |
| [Choose a search data store](../../data-guide/technology-choices/search-options.md) | Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs. |

## Choose an analytics solution

Azure provides several services for analytics workloads, from data warehousing to real-time stream processing. The following articles can help you evaluate your options.

| Article | Summary |
| :------ | :------ |
| [Choose an analytical data store](../../data-guide/technology-choices/analytical-data-stores.md) | Evaluate analytical data store options for big data in Azure. |
| [Choose an analytical data store in Microsoft Fabric](../../data-guide/technology-choices/fabric-analytical-data-stores.md) | Evaluate analytical data store options in Fabric based on data volumes and types, compute engine, ingestion, transformation, and query patterns. |
| [Choose a data analytics and reporting technology](../../data-guide/technology-choices/analysis-visualizations-reporting.md) | Evaluate big data analytics technology options for Azure. |
| [Choose a batch processing technology](../../data-guide/technology-choices/batch-processing.md) | Compare technology choices for big data batch processing in Azure. |
| [Choose a stream processing technology](../../data-guide/technology-choices/stream-processing.md) | Compare options for real-time message stream processing in Azure. |

## Choose an AI and machine learning service

Azure provides AI services, machine learning platforms, and model hosting options for many workloads. The following articles can help you select the right AI and machine learning technologies for your solution.

| Article | Summary |
| :------ | :------ |
| [Choose the right AI model for your workload](../../ai-ml/guide/choose-ai-model.md) | Learn strategies to help you select the best model for your AI workload, including key criteria and practical considerations for decision-making. |
| [Choose an AI services technology](../../data-guide/technology-choices/ai-services.md) | Learn about services that you can use in AI applications and data flows. Choose the right service for your use case. |
| [Choose an Azure service for vector search](vector-search.md) | Learn how to decide which Azure service for vector search best suits your application. |
| [Choose a natural language processing technology](../../data-guide/technology-choices/natural-language-processing.md) | Choose a natural language processing service for sentiment analysis, topic and language detection, key phrase extraction, and document categorization. |
| [Compare Microsoft machine learning products and technologies](../../ai-ml/guide/data-science-and-machine-learning.md) | Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to use for your solution. |

## Choose a networking service

Azure provides several networking services for traffic routing, load distribution, and virtual network connectivity. The following articles can help you evaluate your options.

| Article | Summary |
| :------ | :------ |
| [Compare load balancing options](load-balancing-overview.md) | Compare Azure load balancing services and select one to distribute traffic across multiple computing resources. |
| [Compare virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml) | Compare virtual network peering and VPN gateways for connecting Azure virtual networks. Learn implementation patterns for spoke-to-spoke communication in hub-and-spoke architectures. |

## Choose an integration and automation service

Azure provides several services for integrating systems and automating workflows, from code-first to designer-first approaches. The following article can help you evaluate your options.

| Article | Summary |
| :------ | :------ |
| [Compare Azure Functions, Azure Logic Apps, Power Automate, and WebJobs](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs) | Compare integration and automation services in Azure. Learn the differences between code-first and designer-first approaches for building workflows and orchestrations. |

## Choose a messaging service

Learn about the services that Azure provides to help you deliver events or messages throughout your solution.

| Article | Summary |
| :------ | :------ |
| [Compare messaging services](/azure/service-bus-messaging/compare-messaging-services) | Learn about Azure Event Grid, Azure Event Hubs, and Azure Service Bus. Choose the best service for your scenario. |
| [Learn about asynchronous messaging options](messaging.md) | Learn about asynchronous messaging options in Azure, including the various types of messages and the entities that participate in a messaging infrastructure. |

## Choose an IoT option

Internet of Things (IoT) solutions use a combination of technologies to connect devices, events, and actions through cloud applications. The following articles describe IoT technology choices from Azure.

| Article | Summary |
| :------ | :------ |
| [Learn about Azure IoT services and technologies](/azure/iot/iot-services-and-technologies) | Learn about Azure IoT services and technologies, including Azure IoT Hub, Azure IoT Operations, Azure IoT Edge, and Azure IoT Central. Choose between cloud-based and edge-based solution types. |
| [Compare IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs) | Review a comparison between Azure IoT Hub and Event Hubs that highlights functional differences and use cases. The comparison includes supported protocols, device management, monitoring, and file uploads. |

## Next step

> [!div class="nextstepaction"]
> [Choose an Azure compute service](compute-decision-tree.md)
