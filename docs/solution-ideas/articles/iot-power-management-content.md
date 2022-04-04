[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how internet of things (IoT) devices can work with cloud services to provide life-changing, low-cost electricity and connectivity.

Veriown has run large-scale network and telecommunications infrastructures for years, but has never before provided such a wide scope of services at such low cost. Veriown's Connect devices combine IoT hardware and mobile applications with Azure cloud capabilities to act as energy and internet hubs for homes and small businesses.

Connect IoT devices use a rooftop solar panel to charge a battery that delivers clean power, light, and internet connectivity for pennies a day, with high reliability and minimal downtime. An integrated SIM card and tablet provide individualized access to online content and services like telemedicine, education, news and weather, entertainment, and commerce.

an energy provider working with Azure Internet-of-Things (IoT) cloud services to provide Veriown's IoT devices combine solar power with internet communications to deliver monumental improvements to users' quality of life.
Globally, over 1 billion people lack access to electricity, and over 3 billion people have no internet access. 

Azure supports two major workstreams in the Connect IoT solution:

- Real-time IoT device telemetry detects transient or long-running anomalies. The system can respond in real-time with chatbots and retrained device actions. For example, in low-power conditions, a customer's device can automatically reduce power usage for background or inactive features. The customer continues to get a good experience with the services they're actively using.

- Post-processing data analytics evaluate usage and incidents to determine preventive maintenance and future needs. For example, alerts can notify customers about parts that are predicted to fail soon.

## Potential use cases

The basic Connect device provides LED light, USB device charging, internet connectivity, and customer support. Customers can get additional services and content ad hoc or by subscription. The following scenarios and industries can use these solar-powered, cloud-connected devices:

- In locations where centralized power and internet connectivity are limited.
- News and media organizations, to provide news, weather, and entertainment programming.
- Financial institutions, to provide online commerce and banking services.
- Delivering and evaluating online learning.
- Government agencies, to provide emergency and support communications.

## Architecture

![Diagram showing data stream coming from the power subsystem to Azure IoT edge and cloud components.](../media/iot-power-architecture.png)

### Dataflow

1. Field sales and service agents use a mobile platform to interact with the cloud application via Azure Application Gateway. End users use a built-in interface or mobile app to access and control their devices.
1. Application Gateway uses messaging protocols to interact with users and operators.
1. The cloud app consists of containerized microservices that provide functions and interfaces like identity and access management, device upgrades, notifications, and commerce services.

   Depending on the functions used, the app accesses Azure services and resources like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for unstructured data storage, [Azure Cosmos DB](/azure/cosmos-db/introduction) for large structured databases, and [Azure Media Services](https://azure.microsoft.com/services/media-services/) for entertainment content.

1. The Connect devices also send streaming telemetry and user data to the cloud via Azure IoT Hub.

#### Analytics and business intelligence dataflow

In the business intelligence part of the process:

1. IoT Hub receives the streaming data and routes events.
1. Azure Databricks *extracts, transforms, and loads (ETLs)* the event data.
1. Azure Synapse performs analytics and stores the transformed data.
1. The analyzed data populates Power BI reports for system evaluation and future planning.

#### Machine learning dataflow

The system includes the following data analysis and control loop:

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

1. The Connect devices stream telemetry and user behavior to IoT Hub.
1. IoT Hub sends the data to Azure Databricks and to Azure Machine Learning (ML).
1. Databricks sends some events, like alarms, directly to Customer Support for intervention.
1. Synapse Analytics performs analytics on the ETL data.
1. The analyzed data populates Power BI reports.
1. Azure ML combines current data with stored external data, like historical weather and forecasts, and uses the results to retrain the power management ML models.
1. IoT Hub sends the retrained models to the Connect devices, which adjust their behavior and schedules accordingly.

### Components
- [Azure Application Gateway](/azure/application-gateway/overview) manages and load balances traffic to and from cloud web apps.
- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) hosts and simplifies [Kubernetes](https://kubernetes.io/) orchestration of [Docker](https://www.docker.com/) containerized apps.
- [Azure Container Registry (ACR)](/azure/container-registry/container-registry-intro) is a managed, private registry service that supports AKS applications at scale.
- [Azure IoT Hub](/azure/iot-hub/about-iot-hub) is a central cloud message hub for bi-directional communications between IoT applications and devices.
- [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is a fast, easy, and collaborative [Apache Spark](https://spark.apache.org/)-based analytics service for big data pipelines.
- [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is), formerly SQL Data Warehouse, is an analytics service that brings together enterprise data warehousing and big data analytics.
- [Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that turn data into coherent, immersive, interactive visualizations and reports.
- [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml) is a cloud-based ML environment that uses existing data to forecast future behaviors, outcomes, and trends.

## Next steps
- [Azure IoT documentation](/azure/iot-fundamentals/)
- [A solar-powered device will bring online entertainment, education to villages](https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece)
- [Veriown website](https://veriown.com)
