---
title: Cognizant Safe Buildings with Azure IoT Hub
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: 
ms.date: 06/09/2020
ms.custom: fcp
ms.service: architecture-center
ms.subservice: solution-idea
---

# Create a safe building

As the world cautiously reopens in a business economy where COVID-19, [Cognizant](https://www.cognizant.com/) adapted their [OneFacility](https://azuremarketplace.microsoft.com/en-us/marketplace/consulting-services/cognizant.one_facility) solution to make workspaces safer for everyone who enters the. The Cognizant Safe Buildings solution provides a multi-layered strategy and approach to create safe buildings with sustainably healthy working environments. The solution monitors critical insights so you can act and respond to risks, while instilling confidence that you're focused on making sure people are safe.

The Cognizant Safe Buildings solution cohesively brings together people, regulations, processes, instrumentation, analytics, and technology to transform smart buildings into safe buildings. The use of technology to create safe spaces inspires trust and mitigates risk in meaningful and noticeable ways.

The solution layers safety controls to protect, monitor, and respond with real-time alerts. When any deviation to health and safety protocol is observed in a building, the solution is activated. The measurements the solution can react to are human body temperature, effective physical distancing, hand sanitization compliance, and air quality tracking.

Different people in different roles can take advantage of the features that the solution offers.

* Facility Admin/Manager or Enterprise Level personnel
  * Setup facility details
  * Onboard monitoring devices
  * Configure thresholds
  * View the unified dashboard
  * Receive body temperature and physical distancing alerts on mobile/wearable devices
  * Initiate workflow compliance actions
* HR Managers
  * View employee health status
  * Monitor adherence to policy
  * Perform contact tracing
  * Take action on employee safety & re-entry into the workforce
* Employees
  * Report their health status
  * Get reminders for personal hand hygiene
  * Receive alerts to maintain safe physical distancing

## Potential use cases

The solution adapts to stores, offices, factories, warehouses, recreation spaces, hotels, restaurants, and other places where people congregate.

## Architecture

![](../media/safe-building-arch-design.png)

> [!NOTE]
> This is an abbreviated explanation of the solution's dataflow. You can get detailed information about each service depicted in the data flow in the [Components](#components) section below.

1. Different devices collect data. That data flows into the building's IoT Edge server.

1. The server feeds the data to the Azure Data Factory, Azure Blob Storage, and Azure IoT Hub.

1. IoT Hub sends data through the Azure Kubernetes Service (AKS) to be analyzed and enriched by Azure Stream Analytics and Azure Databricks.

1. AKS sends the processed data to be housed in various data stores:

    * Data Lake - Azure Data Lake Storage

    * Time Insight - Azure Cosmos DB and Azure Database for PostgreSQL

    * Aggregate/Access data - Azure SQL Database

    * Reference Data - Azure Cache for Redis

1. From there, different services and APIs consume the data:

    * Data Service - These services consume the data, process it, and pass it on to downstream services that notify users of any abnormalities that the solution detected.

    * Platform Service - These services analyze device, asset, spacial, and user metrics and pass the information to a webapp instance of Power BI. Power BI displays the statistics in a meaningful and useful way.

    * Training - Azure Databrick and Azure Machine Learning take the data and create deep learning models. The solution uses Azure Container Registry to distribute the models to the IoT Edge server and the Data Service.

    * Command and Control - AKS passes the data from the Platform Service to Azure Functions.

## Components

* [Azure IoT Hub](https://azure.microsoft.com/en-us/services/iot-hub/)

* [Azure IoT Edge](https://azure.microsoft.com/en-us/services/iot-edge/)

* [Azure Blob storage](https://azure.microsoft.com/en-us/services/storage/blobs/)

* [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/)

* [Azure Kubernetes Service](https://azure.microsoft.com/en-us/services/kubernetes-service/)

* [Azure Stream Analytics](https://azure.microsoft.com/en-us/services/stream-analytics/)

* [Azure Databricks](https://azure.microsoft.com/en-us/services/databricks/)

* [Azure Data Lake Storage](https://azure.microsoft.com/en-us/services/storage/data-lake-storage/)

* [Azure Cosmos DB](https://azure.microsoft.com/en-us/services/cosmos-db/)

* [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/)

* [Azure SQL Database](https://azure.microsoft.com/en-us/services/sql-database/)

* [Azure Cache for Redis](https://azure.microsoft.com/en-us/services/cache/)

* [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/)

* [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/)

* [Azure Monitor](https://azure.microsoft.com/en-us/services/monitor/)

* [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)

* [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/)

* [Power BI](https://powerbi.microsoft.com/en-us/)

* [Azure Webapp Service](https://azure.microsoft.com/en-us/services/app-service/web/)

* [Azure API Management](https://azure.microsoft.com/en-us/services/api-management/)

* [Azure Logic App](https://azure.microsoft.com/en-us/services/logic-apps/)

* [Azure Notification Hubs](https://azure.microsoft.com/en-us/services/notification-hubs/)

* [Azure Event Hubs](https://azure.microsoft.com/en-us/services/event-hubs/)

* [Azure VMs](https://azure.microsoft.com/en-us/services/virtual-machines/)

## Next steps

* For more information, please contact [iotcovid@microsoft.com](mailto:iotcovid@microsoft.com).
