[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Smart group spaces can help people get back to work and play As Soon And Safely As Possible (ASASAP) after COVID-19 shutdowns. Insight's [Connected Platform for Detection and Prevention](https://www.insight.com/en_US/what-we-do/digital-innovation/solutions/connected-platform-for-detection-and-prevention.html) rapidly deploys and manages a flexible, scalable [intelligent edge and cloud](https://azure.microsoft.com/overview/future-of-cloud/) ecosystem that helps detect and prevent COVID-19 infection in large group spaces.

This article describes a Connected Platform solution to help provide COVID-19 detection and prevention at a theme park.

- Thermal cameras and contactless thermometers take temperatures of people entering the park.
- Portable, interactive virus testing centers provide rapid, discreet onsite virus testing for people who fail temperature checks.
- Anomaly detecting smart cones monitor safe social distancing in groups and lines.
- Smart, connected hand sanitizer dispensers monitor usage and supply levels.
- Speakers and interactive bots deliver automated alerts, reminders, and instructions to employees and guests.
- Data driven messaging and reporting let stakeholders monitor events and overall trends.

## Potential use cases

- Large, high-usage spaces with controlled entry and access.
- Facilities like offices, factories, theaters, stadiums, malls, transportation centers, and tourist attractions.

## Architecture

![Insight Connected Platform architecture](../media/insight-connected-platform.png)

1. Thermal cameras and other sensors provide temperature and visual data through various network protocols like Bluetooth and WiFi to the Internet of Things (IoT) Edge gateway.
2. The IoT Edge gateway preprocesses data and can respond quickly using onboard resources.
2. In the cloud, Azure IoT Hub communicates with and controls the IoT Edge network, and streams data to Azure resources.
3. Azure Stream Analytics and Azure Databricks process data and send it to database and blob storage services.
4. Processed, stored data feeds into [Docker](https://www.docker.com/) containerized microservices apps in Azure Kubernetes Service (AKS).
5. The microservices apps trigger alerting and messaging services like email and bots.
6. Azure API Management incorporates internal and external APIs when deploying to endpoints like web apps, mobile apps, Azure maps, and [Power BI](https://powerbi.microsoft.com).
7. Azure components and deployed apps can share Azure services like [Azure Security](https://azure.microsoft.com/overview/security/), [Azure Active Directory](https://azure.microsoft.com/services/active-directory/), [Azure Key Vault](https://azure.microsoft.com/services/key-vault/), and [Azure Monitor](https://azure.microsoft.com/services/monitor/).

### Components

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) intelligent devices recognize and respond to sensor input by using onboard processing. These devices can respond rapidly, or even offline. Intelligent Edge devices limit costs by preprocessing and sending only necessary data to the cloud.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects virtually any IoT device with Azure cloud services. IoT Hub enables highly secure and reliable bi-directional communication, management, and provisioning for IoT Edge devices.
- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing with built-in machine learning (ML) models to perform anomaly detection directly in streaming jobs.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is a data lake storage solution for big data analytics, combining [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) capabilities with a high-performance file system.
- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a fast, easy, and collaborative Apache Spark-based analytics service that can read and analyze data lake data.
- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) are artificial intelligence (AI) services and cognitive APIs that help build intelligent apps. For example, [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/) helps count and monitor people density and movements. [Speech to Text](https://azure.microsoft.com/services/cognitive-services/speech-to-text/), [Text to Speech](https://azure.microsoft.com/services/cognitive-services/text-to-speech/), and [Language Understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service/) help provide verbal responses and interactions.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a managed, serverless Kubernetes platform for microservices apps. Kubernetes is open-source orchestration software for deploying, managing, and scaling containerized apps.
- Azure [API Management](https://azure.microsoft.com/services/api-management/) deploys Azure, third-party, and external APIs side by side to optimize traffic flow, provide unified control and visibility, and ensure security and compliance.
- [Microsoft Power BI](https://powerbi.microsoft.com) visualizations enable well-informed and data-driven reporting and decision making.

## Next steps

- For more information, please contact [iotcovidsupport@microsoft.com](mailto:iotcovidsupport@microsoft.com), and see [Connected Platform for Detection and Prevention](https://www.insight.com/en_US/what-we-do/digital-innovation/solutions/connected-platform-for-detection-and-prevention.html).
- For more information about the Insight Connected Platform, see [Connected Platform](https://www.insight.com/en_US/what-we-do/digital-innovation/connected-platform.html).

## Related resources

- [Anomaly detection in Azure Stream Analytics](/azure/stream-analytics/stream-analytics-machine-learning-anomaly-detection)
- [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
