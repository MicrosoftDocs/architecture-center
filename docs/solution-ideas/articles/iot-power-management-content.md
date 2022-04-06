[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes an internet of things (IoT) solution that provides power, light, and internet services to remote locations. A large-scale telecommunications company based the solution on IoT devices that can act as energy and internet hubs for homes and small businesses.

The IoT devices use a rooftop solar panel to charge a battery, which delivers LED light, USB power, and cellular connectivity. An integrated SIM card and tablet provide a user interface. The devices have an IoT gateway that acts as a hub for data transfer and customized service delivery. The IoT gateway collects and transmits telemetry data from the solar panel, battery, and output devices.

The basic IoT device provides LED light, USB device charging, internet connectivity, and user support through alerts and chatbots. Users can get more services and content on demand or by subscription.

The overall solution combines IoT connected devices with Azure platform-based mobile apps. The solution delivers clean, low-cost power and internet services with high reliability and minimal downtime.

Azure supports two major workstreams in this IoT solution:

- Real-time IoT device telemetry detects transient or long-running anomalies. The system can respond via real-time chatbots and take device actions. For example, in low-power conditions, a device can reduce power usage for background or inactive features. The user continues to get a good experience with the services they're actively using.

- Post-processing data analytics and machine learning evaluate usage and incidents to determine predictive maintenance and future needs. Alerts can notify customers about parts that are predicted to fail soon.

## Potential use cases

The following scenarios and industries could use this solution:

- Locations with limited centralized power and internet connectivity.
- News, entertainment, and educational organizations, to deliver content and programming.
- Financial institutions, to provide online commerce and banking services.
- Government and public health agencies, for emergency and support communications.

## Architecture

The architecture consists of:

- A containerized microservices app with end-user interfaces.
- An analytics and machine learning workflow.

### Application dataflow

[![Diagram showing user interfaces interacting with Azure Application Gateway and the cloud application components.](../media/iot-power-architecture.png)](../media/iot-power-architecture.png#lightbox)

1. Field sales and service agents use a mobile platform to interact with the cloud application via Azure Application Gateway. End users use a built-in interface or mobile app to access and control their devices.
1. Application Gateway uses messaging protocols to interact with users and operators.
1. The cloud app consists of containerized microservices that provide functions and interfaces like identity and access management, device upgrades, notifications, and commerce services.
1. Depending on the functions used, the app accesses Azure services and resources like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for unstructured data storage, [Azure Cosmos DB](/azure/cosmos-db/introduction) for large structured databases, and [Azure Media Services](https://azure.microsoft.com/services/media-services/) for entertainment content.
1. The IoT gateway also sends streaming telemetry and user data to the cloud via Azure IoT Hub, to use for analytics and machine learning (ML).

### Analytics and machine learning dataflow

The business intelligence part of the process includes the following data analysis and control loop:

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

1. IoT Hub receives the streaming telemetry and user data from the IoT devices, and routes events to Azure Databricks via Azure Functions.
1. Azure Databricks [extracts, transforms, and loads (ETLs)](https://en.wikipedia.org/wiki/Extract,_transform,_load) the event data.
1. Azure Databricks uses Azure Functions to send some events, like alarms, directly to a customer support app for action.
1. Azure Databricks sends the ETL data to Azure Synapse, which performs analytics and stores the data.
1. Power BI reports use the analyzed data and insights. The service provider can use the data for system evaluation and future planning.
1. Azure Machine Learning combines current data with stored external data, like historical weather and forecasts, and uses the results to retrain the power management ML models.
1. IoT Hub sends the retrained models to the IoT devices, which adjust their behavior and schedules accordingly.

### Components

- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway) manages and load balances traffic to and from cloud web apps.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) hosts and simplifies [Kubernetes](https://kubernetes.io) orchestration of [Docker](https://www.docker.com) containerized apps.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) is a managed, private registry service that supports AKS applications at scale.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) is a central cloud message hub for bi-directional communications between IoT applications and devices.
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is a fast, easy, and collaborative [Apache Spark](https://spark.apache.org)-based analytics service for big data pipelines.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics), formerly SQL Data Warehouse, is an analytics service that brings together enterprise data warehousing and big data analytics.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that turn data into coherent, immersive, interactive visualizations and reports.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud-based ML environment that uses existing data to forecast future behaviors, outcomes, and trends.

## Next steps

- [IoT concepts and Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub)
- [Introduction to private Docker container registries in Azure](/azure/container-registry/container-registry-intro)
- [What is dedicated SQL pool (formerly SQL DW) in Azure Synapse Analytics?](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is)
- [A solar-powered device will bring online entertainment, education to villages](https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece)

## Related resources

- [Choose an Internet of Things (IoT) solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml)
- [Extract actionable insights from IoT data](../../industries/manufacturing/extract-insights-iot-data.yml)
- [Task-based consumer mobile app](task-based-consumer-mobile-app.yml)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](ingest-etl-stream-with-adb.yml)
