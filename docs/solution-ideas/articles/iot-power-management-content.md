[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes an internet of things (IoT) solution that provides power, light, and internet services to remote locations. Veriown, a telecommunications company, has developed Connect IoT devices that can act as energy and internet hubs for homes and small businesses.

The Connect devices use a rooftop solar panel to charge a battery, which delivers LED light and power. An integrated SIM card and tablet provide individualized access to online content and services. The overall solution combines Connect devices with mobile apps and Azure cloud capabilities. The solution delivers clean, low-cost power and connectivity with high reliability and minimal downtime.

Azure supports two major workstreams in the Connect IoT solution:

- Real-time IoT device telemetry detects transient or long-running anomalies. The system can respond in real-time with chatbots and retrained device actions. For example, in low-power conditions, a customer's device can automatically reduce power usage for background or inactive features. The customer continues to get a good experience with the services they're actively using.

- Post-processing data analytics and machine learning evaluate usage and incidents to determine predictive maintenance and future needs. For example, alerts can notify customers about parts that are predicted to fail soon.

## Potential use cases

The basic Connect device provides LED light, USB device charging, internet connectivity, and customer support. Customers can get more services and content on demand or by subscription. The following scenarios and industries could use this solution:

- Locations with limited centralized power and internet connectivity.
- News, entertainment, and educational organizations, to deliver content and programming.
- Financial institutions, to provide online commerce and banking services.
- Government and public health agencies, for emergency and support communications.

## Architecture

The architecture consists of a cloud-based app with end-user interfaces, and a cloud-based analytics and machine learning workflow.

### Application dataflow

![Diagram showing data stream coming from the power subsystem to Azure IoT edge and cloud components.](../media/iot-power-architecture.png)

1. Field sales and service agents use a mobile platform to interact with the cloud application via Azure Application Gateway. End users use a built-in interface or mobile app to access and control their devices.
1. Application Gateway uses messaging protocols to interact with users and operators.
1. The cloud app consists of containerized microservices that provide functions and interfaces like identity and access management, device upgrades, notifications, and commerce services.
1. Depending on the functions used, the app accesses Azure services and resources like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for unstructured data storage, [Azure Cosmos DB](/azure/cosmos-db/introduction) for large structured databases, and [Azure Media Services](https://azure.microsoft.com/services/media-services/) for entertainment content.
1. The Connect devices also send streaming telemetry and user data to the cloud via Azure IoT Hub, to use for analytics and machine learning (ML).

### Analytics and machine learning dataflow

The business intelligence part of the process includes the following data analysis and control loop:

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

1. IoT Hub receives the streaming telemetry and user data from the Connect devices, and routes events to Azure Databricks and Azure Machine Learning.
1. Azure Databricks [extracts, transforms, and loads (ETLs)](https://en.wikipedia.org/wiki/Extract,_transform,_load) the event data.
1. Azure Databricks sends some events, like alarms, directly to customer support for intervention.
1. Azure Databricks sends ETL data to Azure Synapse and to Azure Machine Learning (Azure ML).
1. Azure Synapse performs analytics and stores the ETL data.
1. The analyzed data populates Power BI reports for system evaluation and future planning.
1. Azure ML combines current data with stored external data, like historical weather and forecasts, and uses the results to retrain the power management ML models.
1. IoT Hub sends the retrained models to the Connect devices, which adjust their behavior and schedules accordingly.

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

- [Introduction to private Docker container registries in Azure](/azure/container-registry/container-registry-intro)
- [IoT concepts and Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub)
- [What is dedicated SQL pool (formerly SQL DW) in Azure Synapse Analytics?](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is)
- [A solar-powered device will bring online entertainment, education to villages](https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece)

## Related resources

- [Choose an Internet of Things (IoT) solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml)
- [Extract actionable insights from IoT data](../../industries/manufacturing/extract-insights-iot-data.yml)
- [Task-based consumer mobile app](task-based-consumer-mobile-app.yml)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](ingest-etl-stream-with-adb.yml)
