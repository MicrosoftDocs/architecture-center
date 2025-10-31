---
title: Technology choices for Azure solutions
description: View a list of resources that can help you make informed decisions about the technologies you choose for your Azure solutions.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/19/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: fcp
---

# Technology choices for Azure solutions

This article provides a list of resources that you can use to make informed decisions about the technologies that you choose for your Azure solutions. Explore comparison matrices, flowcharts, and decision trees to ensure that you find the best matches for your scenario.

## Choose a compute service

The term *compute* refers to the hosting model for the computing resources that your application runs on. The following articles can help you choose the right technologies:

|Article |Summary  |
|---------|---------|
|[Choose an Azure compute service](compute-decision-tree.md)  | Decide which compute service best suits your application.        |
|[Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)|     Learn about two compute options for microservices: service orchestrator and serverless architecture.    |
|[Choose between traditional web apps and SPAs](/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)  |  Learn how to choose between traditional web apps and single-page applications (SPAs).       |

## Choose a container option

There are many ways to build and deploy cloud-native and containerized applications in Azure. Review these articles to learn more:

|Article |Summary  |
|---------|---------|
|[Compare Container Apps with other Azure container options](/azure/container-apps/compare-options?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)   |     Understand when to use Azure Container Apps and how it compares to other container options, including Azure Container Instances, Azure App Service, Azure Functions, and Azure Kubernetes Service (AKS).    |
|[Choose a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md)     |   Learn about the pros and cons of various options for extending compute at the edge.      |

## Choose a hybrid option

Many organizations need a hybrid approach to analytics, automation, and services because their data is hosted both on-premises and in the cloud. The following articles can help you choose the best technologies for your scenario:

|Article |Summary  |
|---------|---------|
|[Azure hybrid options](hybrid-considerations.yml)     |    Learn about Azure hybrid solutions, including alternatives to deploy and host hybrid services on-premises, at the edge, in Azure, and in other clouds.     |
|[Compare Azure Stack Hub to Azure](/azure-stack/user/azure-stack-considerations?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |    Learn the differences between Azure and Azure Stack Hub.     |
|[Compare Azure, Azure Stack Hub, and Azure Local](/azure-stack/operator/compare-azure-azure-stack?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)   |    Learn the differences between Azure, Azure Stack Hub, and Azure Local.     |
|[Compare Azure Local to Azure Stack Hub](/azure-stack/hci/concepts/compare-azure-stack-hub?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |    Determine whether Azure Local or Azure Stack Hub is right for your organization.     |
|[Compare Azure Local to Windows Server](/azure-stack/hci/concepts/compare-windows-server?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|     Determine whether Azure Local or Windows Server is right for your organization.    |
|[Choose drives for Azure Local and Windows Server clusters](/azure-stack/hci/concepts/choose-drives?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |    Learn how to choose drives for Azure Local and Windows Server clusters to meet performance and capacity requirements.     |

## Choose an identity service

Identity solutions help you protect your data and resources. These articles can help you choose an Azure identity service:

|Article |Summary  |
|---------|---------|
|[Active Directory services](/entra/identity/domain-services/compare-identity-solutions?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |    Compare the identity services that are provided by Active Directory Domain Services, Microsoft Entra ID, and Microsoft Entra Domain Services.     |
|[Hybrid identity authentication methods](/entra/identity/hybrid/connect/choose-ad-authn?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |   Choose an authentication method for a Microsoft Entra hybrid identity solution in a medium-sized to large organization.      |

## Choose a storage service

The Azure Storage platform is the Microsoft cloud storage solution for modern data storage scenarios. Review these articles to determine the best solution for your use case:

|Article |Summary  |
|---------|---------|
|[Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Review the storage options for Azure workloads.     |
|[Azure managed disk types](/azure/virtual-machines/disks-types?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |   Learn about the disk types that are available for Azure virtual machines, including Ultra disks, Premium SSDs v2 (preview), Premium SSDs, and Standard SSDs.      |
|[Choose an Azure solution for data transfer](/azure/storage/common/storage-choose-data-transfer-solution?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Choose an Azure solution for data transfer, based on the amount of data and the available network bandwidth in your environment.    |

## Choose a data store

The cloud is changing the way applications are designed, including how data is processed and stored. These articles can help you choose a data solution:

|Article |Summary  |
|---------|---------|
|[Understand data store models](data-store-overview.md)     |   Learn about the high-level differences between the various data storage models in Azure data services.      |
|[Choose an Azure data store for your application](data-store-decision-tree.md)    |    Use a flowchart to choose an Azure data store.    |
|[Criteria for choosing a data store](data-store-considerations.md)|Review some general considerations for choosing a data store. |
|[Choose a big data storage technology in Azure](../../data-guide/technology-choices/data-storage.md)     |    Compare big data storage options in Azure. View key selection criteria and a capability matrix.     |
|[OLAP solutions](../../data-guide/relational-data/online-analytical-processing.md)|Learn about online analytical processing (OLAP) solutions for organizing large databases and supporting complex analysis without affecting transactional systems.|
|[OLTP solutions](../../data-guide/relational-data/online-transaction-processing.md)|Learn about atomicity, consistency, and other features of online transaction processing (OLTP), which manages transactional data and supports querying.|
|[Data lakes](../../data-guide/scenarios/data-lake.md)|Learn about data lake storage repositories, which can hold terabytes or petabytes of data in a native, raw format.|
|[Non-relational data and NoSQL](../../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key/value pairs, graphs, time series, objects, and other storage models.|
|[Choose a data pipeline orchestration technology](../../data-guide/technology-choices/pipeline-orchestration-data-movement.md) |Choose an Azure data pipeline orchestration technology to automate pipeline orchestration, control flow, and data movement workflows.|
|[Choose a search data store](../../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs.|
|[Transfer data to and from Azure](../../data-guide/scenarios/data-transfer.md)|Learn about Azure data transfer options like Azure Import/Export, Azure Data Box, Azure Data Factory, and command-line and graphical interface tools.|

## Choose an analytics solution

With the exponential growth in data, organizations rely on the limitless compute, storage, and analytical power of Azure. Review these articles to learn about the available analytics solutions:

|Article |Summary  |
|---------|---------|
|[Choose an analytical data store](../../data-guide/technology-choices/analytical-data-stores.md)     |      Evaluate analytical data store options for big data in Azure.   |
|[Choose a data analytics and reporting technology](../../data-guide/technology-choices/analysis-visualizations-reporting.md)     |  Evaluate big data analytics technology options for Azure.       |
|[Choose a batch processing technology](../../data-guide/technology-choices/batch-processing.md)     |    Compare technology choices for big data batch processing in Azure.     |
|[Choose a stream processing technology](../../data-guide/technology-choices/stream-processing.md)     |   Compare options for real-time message stream processing in Azure.      |

## Choose an AI / machine learning service

AI is the capability of a computer to imitate intelligent human behavior. Through AI, machines can analyze images, comprehend speech, interact in natural ways, and make predictions based on data. Review these articles to learn about the AI and machine learning technology choices that are available in Azure:

|Article |Summary  |
|---------|---------|
|[Choose an Azure AI services technology](../../data-guide/technology-choices/ai-services.md)| Learn about AI services that you can use in intelligent applications and data flows. |
|[Natural language processing technology](../../data-guide/technology-choices/natural-language-processing.md)     |     Choose a natural language processing service for sentiment analysis, topic and language detection, key phrase extraction, and document categorization.    |
|[Compare machine learning products and technologies](../../ai-ml/guide/data-science-and-machine-learning.md)     |  Compare options for building, deploying, and managing your machine learning models. Decide which products to use for your solution.       |
|[MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Learn about how Azure Machine Learning uses MLflow to log metrics and artifacts from machine learning models and deploy your machine learning models to an endpoint.    |

## Choose a networking service

These articles can help you explore the networking technologies that are available in Azure:

|Article |Summary  |
|---------|---------|
|[Load balancing options](load-balancing-overview.md)    |    Learn about Azure load balancing services and how you can use them to distribute your workloads across multiple computing resources.     |
|[Virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml) | Compare virtual network peering and VPN gateways for connecting Azure virtual networks. Learn implementation patterns for spoke-to-spoke communication in hub-and-spoke architectures. |

## Choose a messaging service

Learn about the services that Azure provides to help you deliver events or messages throughout your solution:

|Article |Summary  |
|---------|---------|
|[Compare messaging services](/azure/event-grid/compare-messaging-services?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Learn about the three Azure messaging services: Azure Event Grid, Azure Event Hubs, and Azure Service Bus. Choose the best service for your scenario.    |
|[Asynchronous messaging options](messaging.yml)     |     Learn about asynchronous messaging options in Azure, including the various types of messages and the entities that participate in a messaging infrastructure.    |

## Choose an IoT option

IoT solutions use a combination of technologies to connect devices, events, and actions through cloud applications. Review these articles to learn more about the IoT technology choices that Azure provides:

|Article |Summary  |
|---------|---------|
|[Choose an IoT solution](/azure/iot/iot-services-and-technologies?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |  To evaluate your IoT solution, use Azure IoT Central, a managed IoT application platform. To build a custom IoT solution from scratch, use Azure IoT platform services such as Azure IoT Hub and the Device Provisioning Service.       |
|[Compare IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Review a comparison between Azure IoT Hub and Event Hubs that highlights functional differences and use cases. The comparison includes supported protocols, device management, monitoring, and file uploads.    |

## Choose a mobile development framework

|Article |Summary  |
|---------|---------|
|[Choose a mobile development framework](/azure/developer/mobile-apps/choose-mobile-framework?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)     |     Learn about the supported native and cross-platform languages for building client applications.    |
