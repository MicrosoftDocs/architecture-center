[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Globally, over 1 billion people lack access to electricity, and over 3 billion people have no internet access. Veriown is an energy provider working with Azure Internet-of-Things (IoT) cloud services to provide life-changing, low-cost electricity and connectivity to remote and rural customers. Veriown's IoT devices combine solar power with internet communications to deliver monumental improvements to users' quality of life.

Veriown has run large-scale network and telecommunications infrastructures for years, but has never before provided such a wide scope of services at such low cost. Veriown's Connect devices combine IoT hardware and mobile applications with Azure cloud capabilities to act as energy and internet hubs for homes and small businesses.

The Connect IoT device uses a rooftop solar panel and charged battery to deliver clean electricity, light, and cellular internet connectivity for pennies a day, with high reliability and minimal downtime. An integrated SIM card and tablet provide individualized access to online content and services like telemedicine, education, news and weather, entertainment, and commerce.

Azure supports two major workstreams in Veriown's IoT solution:

- Real-time IoT device telemetry detects transient or long-running anomalies, and the system can respond in real time with chatbots and retrained device actions. For example, in low-power conditions a customer's device can automatically reduce power usage for background or inactive features, so the customer continues to get a good experience with the services they're actively using.

- Post-processing data analytics evaluate usage and incidents to determine algorithms for future needs and preventive maintenance. For example, Veriown could send customers parts that are predicted to fail soon, or could improve the responses of an artificial intelligence (AI) chatbot.

Since bandwidth is limited and expensive in emerging markets, analyzing usage patterns and incidents can help content and service owners target customers with only the content and services they currently need.

## Potential use cases

A solar-powered Connect device in a customer's home or business can provide:
- LED light to replace kerosene lanterns
- USB device charging
- Telemedicine support
- Online education
- Commerce and banking services
- News and weather
- Entertainment programming
- Emergency and support communications

The basic Connect device provides light, electricity, internet connectivity, and customer support. Customers can purchase additional services and content as one-offs or subscriptions.

## Architecture

![Diagram showing data stream coming from the power subsystem to Azure IoT edge and cloud components.](../media/iot-power-architecture.png)

1. Field sales and service agents use a mobile platform to interact with the cloud application via Azure Application Gateway. End users use a built-in device or mobile interface to access and control their devices and interact with content.
1. Application Gateway uses messaging protocols to interact with users and operators.
1. The cloud app consists of containerized microservices that provide functions and interfaces like identity and access management, device upgrades, notifications, and commerce services.

   The app uses Azure services and resources like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for unstructured data storage, [Azure Cosmos DB](/azure/cosmos-db/introduction) for large structured databases, and [Azure Media Services](https://azure.microsoft.com/services/media-services/) to store and deliver entertainment content.

The Connect devices also send streaming telemetry and user data to the cloud via Azure IoT Hub. In the business intelligence part of the process:
1. [IoT Hub and Azure Event Hub](/azure/iot-hub/iot-hub-compare-event-hubs) receive the streaming data and route events.
1. Azure Databricks *extracts, transforms, and loads (ETLs)* the event data.
1. Azure Synapse, a SQL big-data warehouse, performs analytics and stores the transformed data.
1. The analyzed data populates Power BI reports for system evaluation and future planning.

### Analytics and machine learning data flow

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
