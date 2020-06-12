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

The world is cautiously reopening in a physical business environment where COVID-19 remains a factor. To help keep people healthy, [Cognizant](https://www.cognizant.com/) adapted their [OneFacility](https://azuremarketplace.microsoft.com/en-us/marketplace/consulting-services/cognizant.one_facility) solution to make workspaces safer for everyone who enters them. The **Cognizant Safe Buildings** solution provides a strategic approach to create safe buildings with sustainably healthy working environments. The solution monitors critical insights so you can act and respond to risks. It also builds confidence that you're focused on making sure people are safe. The measurements the solution reacts to are: human body temperature, effective physical distancing, hand sanitization compliance, and air quality tracking.

Using [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) and 24 other Azure services, the **Cognizant Safe Buildings** solution brings together people, regulations, processes, instrumentation, analytics, and technology to transform smart buildings into safe buildings. The use of technology to create safe spaces inspires trust and mitigates risk in meaningful and noticeable ways.

The solution layers safety controls to protect, monitor, and respond with real-time alerts. Through the use of different devices, the solution collects biometric and environmental data. When the system detects any deviation to health and safety protocol in a building, the solution activates.

<!-- Different people in different roles can take advantage of the features that the solution offers:

* Facility Admin/Manager or Enterprise-level personnel
  * Set up a facility's **Cognizant Safe Buildings** solution details
  * Onboard monitoring devices
  * Configure thresholds
  * View the unified dashboard
  * Receive body temperature and physical distancing alerts on mobile/wearable devices
  * Start workflow compliance actions
* HR Managers
  * View employee health status
  * Monitor adherence to policy
  * Conduct contact tracing
  * Take action on employee safety & re-entry into the workforce
* Employees
  * Report their health status
  * Get reminders for personal hand hygiene
  * Receive alerts to maintain safe physical distancing -->

## Potential use cases

The solution adapts to stores, offices, factories, warehouses, recreation spaces, hotels, and restaurants. It's adaptable to any interior space where people congregate.

## Architecture

![](../media/safe-building-arch-design.png)

1. Different devices collect data. That data flows into the building's IoT Edge server.

1. The server feeds the data to the [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/), [Azure Data Factory](https://azure.microsoft.com/services/data-factory/), and [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs/).

1. The Azure IoT Hub sends data through an [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) (AKS).

1. AKS routes the data so [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) and [Azure Databricks](https://azure.microsoft.com/services/databricks/) can analyze and enrich it.

1. The solution sends the processed data to various data stores:
<!-- 
    * Data Lake - [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/)

    * Time Insight - [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) and [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/)

    * Aggregate/Access data - [Azure SQL Database](https://azure.microsoft.com/services/sql-database/)

    * Reference Data - [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) -->

6. From there, different services and APIs consume the data:

    * Data Service - These services consume the data, process it, and pass it on to downstream services that notify users of any abnormalities that the solution detected.

    * Platform Service - These services analyze device, asset, spatial, and user metrics and pass the information to a webapp instance of [Power BI](https://powerbi.microsoft.com/). Power BI displays the statistics in a meaningful and useful way.

    * Training - Azure Databricks and [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) take the data and create deep learning models. The solution uses [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) to distribute the models to the IoT Edge server and the Data Service.

    * Command and Control - AKS passes the data from the Platform Service to [Azure Functions](https://azure.microsoft.com/services/functions/).

## Components

* [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) - Enable highly secure and reliable communication between your IoT application and the devices it manages.

* [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) - Deploy your cloud workloads—artificial intelligence, Azure and third-party services, or your own business logic—to run on Internet of Things (IoT) edge devices via standard containers.
<!-- 
* [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs/) - Helps you create data lakes for your analytics needs, and provides storage to build powerful cloud-native and mobile apps. -->
<!-- 
* [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) - Integrate data silos with Azure Data Factory, a service built for all data integration needs and skill levels. -->

* [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) - Deploy and manage containerized applications more easily with a fully managed Kubernetes service.

* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) - An easy-to-use, real-time analytics service designed for mission-critical workloads.

* [Azure Databricks](https://azure.microsoft.com/services/databricks/) - Unlock insights from all your data and build artificial intelligence (AI) solutions. Set up your Apache Spark environment in minutes, autoscale, and collaborate on shared projects in an interactive workspace.
<!-- 
* [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) - A highly scalable and cost-effective data lake solution for big data analytics.

* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) -  A fully managed NoSQL database service for modern app development. Azure Cosmos DB has guaranteed single-digit millisecond response times. It also guarantees 99.999-percent availability backed by SLAs, automatic and instant scalability, and open-source APIs for MongoDB and Cassandra.

* [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/) - Focus on application innovation, not database management, with fully managed and intelligent Azure Database for PostgreSQL.

* [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) - The intelligent, scalable, relational database service built for the cloud. It’s evergreen and always up to date, with AI-powered and automated features that optimize performance and durability for you.

* [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) - Fully managed, open source–compatible in-memory data store to power fast, scalable applications.

* [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) - Build, store, secure, scan, replicate, and manage container images and artifacts with a fully managed, geo-replicated instance of OCI distribution. -->

* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) - Empower developers and data scientists with a wide range of productive experiences for building, training, and deploying machine learning models faster.

* [Azure Monitor](https://azure.microsoft.com/services/monitor/) - Collect, analyze, and act on telemetry data from your Azure and on-premises environments.
<!-- 
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) - Safeguard cryptographic keys and other secrets used by cloud apps and services.

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) -  An enterprise identity service that provides single sign-on and multi-factor authentication to help protect your users from 99.9 percent of cybersecurity attacks. -->

* [Power BI](https://powerbi.microsoft.com/) - Empower team members to discover insights hidden in your data.

<!-- * [Azure Webapp Service](https://azure.microsoft.com/services/app-service/web/) - Get your web apps into users’ hands faster on Windows or .NET Core, Node.js, PHP, or Ruby on Linux.

* [Azure API Management](https://azure.microsoft.com/services/api-management/) - Streamline your work across hybrid and multi-cloud environments with a single place for managing all your APIs.

* [Azure Logic App](https://azure.microsoft.com/services/logic-apps/) - Connect your business-critical apps and services, automating your workflows without writing a single line of code.

* [Azure Notification Hubs](https://azure.microsoft.com/services/notification-hubs/) - Send push notifications to any platform from any back end.

* [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) -  Stream millions of events per second from any source to build dynamic data pipelines and immediately respond to business challenges. -->

<!-- * [Azure VMs](https://azure.microsoft.com/services/virtual-machines/) -  Run SQL Server, SAP, Oracle software, and high-performance computing applications on Azure Virtual Machines. Choose your favorite Linux distribution or Windows Server. -->

* [Azure Functions](https://azure.microsoft.com/services/functions/) - Build and debug locally without additional setup. Deploy and operate at scale in the cloud, and integrate services using triggers and bindings.

## Next steps

* For more information, please contact [iotcovid@microsoft.com](mailto:iotcovid@microsoft.com).

* Visit the Microsoft commercial marketplace for info on Cognizant's [OneFacility](https://azuremarketplace.microsoft.com/en-us/marketplace/consulting-services/cognizant.one_facility).
