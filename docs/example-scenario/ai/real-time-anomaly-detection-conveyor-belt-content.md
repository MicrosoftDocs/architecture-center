The manufacturing industry is undergoing revolutionary changes as an increasing number of firms adopt smart factory floors enabled by AI and machine learning. This article provides an overview of an architecture to enable real-time anomaly detection for conveyor belts.
 
## Architecture

:::image type="content" source="media/real-time-anomaly-detection.png" alt-text="Architecture diagram that shows a solution for real-time anomaly detection." lightbox="media/real-time-anomaly-detection.png" border="false"::: 

*Download a [Visio file](https://arch-center.azureedge.net/realtime-anomaly-detection.vsdx) of this architecture.*

### Workflow

1. Data source

   A sophisticated data-collection sensor is a crucial Internet of Things (IoT) component. Sensors collect analog data from the physical world and translate it into digital data assets. Sensors can measure just about any aspect of the physical world. The calibration of sensors allows them to be tailored to application-specific functions. In this dataset, sensors are calibrated to accurately measure temperature and vibrations.
   
   On most factory floors, conveyor belts run on schedules. Anomaly detection of temperature and vibrations is needed when the conveyor belt is running. Time Series API is used to capture and relay conveyor belt status.

1. Ingest

   We recommend [Azure IoT Hub](/azure/iot-fundamentals/iot-introduction) for streaming data from IoT sensors and connecting IoT devices. For ingesting data from Time Series API and data orchestration, we recommend [Azure Data Factory](/azure/data-factory/introduction).

1. Store
   
   Data collected from IoT sensors (temperature and vibrations) and Time Series API (conveyor belt status) are all time series. Time series data is a collection of observations obtained through repeated measurements over time. This data is collected as flat files. Each flat file is tagged with an IoT sensor ID and the date and time of collection and stored in [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake).

1. AI / machine learning - data preparation and training

   *Data preparation* is the process of gathering, combining, structuring, and organizing data so it can be used to build machine learning models, business intelligence (BI), and analytics and data visualization applications.
   
   [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is used to prepare the data before the data is used to build models. Azure Databricks provides an interactive workspace that enables collaboration between data engineers, data scientists, and machine learning engineers. In analytics workflow, Azure Databricks is used to read data from [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) to perform data wrangling and data exploration.

   *Model training* is the process of using a machine learning algorithm to learn patterns based on data and pick a suitable model for making predictions.
 
   [Azure Machine learning](https://azure.microsoft.com/services/machine-learning) is used to train the model. Azure Machine Learning is a cloud service that accelerates and manages the machine learning project lifecycle. The lifecycle includes training, deploying models, and managing machine learning operations (MLOps).

1. AI / machine learning - inference

   *Machine learning inference* is the process of feeding previously unseen data points into a machine learning model to calculate an output, like a numerical score. In this case, it's used to determine whether input data is anomalous.

   The model registry is built into [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning). It's used to store and version models in Azure. The model registry makes it easy to organize and keep track of trained models.

   After a machine learning model is trained, the model needs to be deployed so that newly available data can be fed through it for inferencing. The recommended deployment target is an [Azure managed endpoint](/azure/machine-learning/concept-endpoints). 

1. Analytical workload

   The results of model scoring are saved back into the analytics systems, in this case [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake), where the input data was collected. This helps in sourcing the results to the front end and in model monitoring and retraining.

1. Front-end model consumption

   You can consume the scored results via an app or on the [Power BI](/power-bi/fundamentals/power-bi-overview) platform. In this scenario, which provides real-time inferencing as soon as anomalies are detected, you can route alerts to stakeholders through custom Microsoft or third-party event management APIs that are hosted in Azure or elsewhere.

### Components

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) is a collection of Microsoft-managed cloud services that connect, monitor, and control billions of IoT assets.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a cloud-based data integration service that automates data movement and transformation.
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a limitless data storage service for housing data in various shapes and formats. It provides easy integration with the analytics tools in Azure. It has enterprise-grade security and monitoring support. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for the machine learning data and a premium data cache to train the machine learning model.
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is a data analytics platform that's optimized for the Azure platform. It offers three environments for developing data-intensive applications: Databricks SQL, Databricks Data Science & Engineering, and Databricks Machine Learning.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is the enterprise-grade machine learning service for easier model development and deployment to a wide range of machine learning target computes. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various integrated development environments.
- [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints) are HTTPS endpoints that clients can call to receive the inferencing (scoring) output of a trained model. An endpoint provides a stable scoring URI with key-token authentication.
- [Power BI](https://powerbi.microsoft.com) is the Azure software as a service (SaaS) for business analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easy transformation capabilities, and sophisticated visualization.

### Alternatives

- Azure Machine Learning provides data modeling and deployment in this solution. You can also build the solution in Azure Databricks, using a code-first approach.
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a suitable alternative to IoT Hub for ingesting big data. Both Event Hubs and IoT Hub are designed for data ingestion at a massive scale.
- You can stage data in [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) or [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) instead of Data Lake. You can use Data Factory for data staging and analysis.
- For data exploration, you can use [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) as an alternative to Azure Databricks.
- You can use Grafana instead of Power BI for visualization.
- You can use [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) as an alternative to managed endpoints if you want more control over that compute tier.

## Scenario details

Smart factory floors enable collaborative systems to provide real-time responses to changing conditions and customer demands throughout the supply network.

AI and machine learning are used in unique ways throughout the manufacturing sector. The most impactful of these applications are predictive maintenance and fault prevention. Specifically, detecting anomalies in temperature and vibrations of motors attached to conveyor belts reduces maintenance costs, repair and overhaul time, and the need for spare part inventory. It also increases the uptime of the machinery. The introduction of predictive maintenance and fault prevention saves millions of dollars a year, and in some cases saves lives by removing personnel from dangerous situations.

You can achieve predictive maintenance in several ways, including rule-based, supervised, and unsupervised machine learning. Rule-based machine learning requires known threshold levels. When labels are available for anomalies, supervised machine learning is the most viable option. If no labels are available for the detection of anomalous behavior, unsupervised anomaly detection is the best method. Whatever the methodology, the model's outcome is to predict whether the incoming data is anomalous.

Because sensors capture data in real time, anomaly detection should be able to detect anomalies immediately. You can address potential risks that would otherwise go undetected before they escalate.

### Sample temperature, vibration and conveyor belt status data

The data necessary to predictively maintain motors attached to conveyor belts are temperature, vibrations, and conveyor belt status. Sample data is presented here.

**Conveyor belt status:** On most factory floors, conveyor belts are run on specific schedules. Anomaly detection of temperature and vibration is needed only when the conveyor belt is running. A conveyer belt value of zero indicates that the conveyor belt is inactive. A value of one means it's active. This sample graph shows how conveyor belt status is recorded:

:::image type="content" source="media/conveyor-belt-status.png" alt-text="Graph that shows conveyor belt status data." lightbox="media/conveyor-belt-status.png" border="false":::

**Temperature:** Sensors attached to conveyor belts and the factory floor can record the temperature of the motor and baseline the ambient temperature. Temperature is seasonally affected because of sunlight exposure, air conditioning settings, and numerous other factors. You need to address the seasonal aspect of temperature. There are many ways to do so. One method, if we take motor temperature as an example, is to subtract the baseline ambient temperature of the factory floor from the motor temperature:

*(Adjusted Temperature = Motor Temperature - Ambient Temperature)*

 This sample graph shows temperatures recorded from motors and the ambient baseline temperature:

:::image type="content" source="media/motor-ambient-baseline-temperatures.png" alt-text="Graph that shows temperatures recorded from motors and the ambient baseline temperature." lightbox="media/motor-ambient-baseline-temperatures.png" border="false":::


The following sample graph shows how the temperature from a conveyor belt motor is adjusted for seasonality by using the ambient temperature of the factory floor. It also shows anomalies, in red, that are detected by a model that uses the architecture suggested in this article.

:::image type="content" source="media/temperatures-adjusted-anomalies.png" alt-text="Graph that shows how temperatures are adjusted for seasonality. It also shows anomalies." lightbox="media/temperatures-adjusted-anomalies.png" border="false":::

**Vibrations:** Sensors collect vibrations as RMS (root mean square) of the half sinusoidal wave. Because RMS represents the area and not the peak value, you need to convert RMS to peak before you test for anomalies. This sample graph shows how vibration peak data is collected by a sensor that's attached to a motor:

:::image type="content" source="media/vibration-peak-data.png" alt-text="Graph that shows how vibration peak data is collected by a sensor that's attached to a motor." lightbox="media/vibration-peak-data.png" border="false":::

This sample graph shows vibration anomalies, in red, that are detected by a model that uses the architecture suggested in this article:

:::image type="content" source="media/vibration-anomalies.png" alt-text="Sample graph that shows vibration anomalies." lightbox="media/vibration-anomalies.png" border="false":::

### Potential use cases

You can apply this solution to the following scenarios:

- **Manufacturing.** Predictive maintenance and fault prevention for conveyor belts.
- **Energy industry.** Predictive maintenance of conveyor belts for ore mining, specifically relevant for underground ore mining, open-cast ore mining, and ore processing.
- **Healthcare.** Predictive maintenance of conveyor belts used for pharmaceutical products and medical packaging.
- **Food, travel, and hospitality.** Predictive maintenance of conveyor belts used for food production and packaging.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).
 
The technologies in this architecture were chosen for scalability and availability, with the aim of managing and controlling costs.

Azure Industrial IoT can help you accelerate your path to modernize your connected factory. Also, Azure Digital Twins can help you to model the connected physical environments in a manufacturing setup. For more information, see these resources:

- [Azure Industrial IoT – IoT for Industry 4.0](https://azure.microsoft.com/solutions/industry/manufacturing/iot/#overview)
- [Azure Digital Twins – modeling and simulations](https://azure.microsoft.com/services/digital-twins/#overview)

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The components in this architecture provide high availability. However, machine learning and analytics tasks are made up of two parts: training and production deployment.

Resources required for training don't typically require high availability. For production deployment, high availability is fully supported by [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario provides improved security that's built into the components. It also provides permissions that you can manage via Azure Active Directory authentication or role-based access control. Consider the following [Azure Machine Learning best practices for enterprise security](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-enterprise-security) to establish suitable security levels.

Manage security for and access to the IoT hub that interacts with the IoT sensors by following the baseline guidance in [Azure security baseline for Azure IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline).

See the following resources for more information about security features for this architecture:

- [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise security and governance for Azure Machine Learning](/azure/machine-learning/concept-enterprise-security)
- [Overview of the security pillar](/azure/architecture/framework/security/overview)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To optimize costs, scalability of the resources is based on the analytics workload and the training and deployment workloads.
- Choose the appropriate pricing tier for the IoT hub and appropriate compute sizes for machine learning and data processing components.
- To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), inputting the services described in this article. [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview) can also be helpful.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Follow MLOps guidelines to standardize and manage an end-to-end machine learning lifecycle that's scalable across multiple workspaces. Before going into production, ensure that the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. Here are some resources to consider:
- [MLOps v2](https://microsoft.sharepoint.com/teams/CS_AzureDataAI/SitePages/Mlops.aspx?xsdata=MDV8MDF8fDVhM2M4ZDViNjM1ODRhMWFjMDM3MDhkYTFiZjIwYTkzfDcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3fDB8MHw2Mzc4NTMwMjM1OTk4MzcyMzl8R29vZHxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazkwYUdWeUlpd2lWMVFpT2pFeGZRPT18MXxNVGs2TXpCak9HUmlOR1JsTkRSbE5EVmlaR0UwWVRNMFpqQmpPV1kzT1RWa1pqaEFkR2h5WldGa0xuWXl8fA%3D%3D&sdata=czFMOUVSa3J1WjBSbm5haDc3NStGUVVGYTZyZE93MmF4d3U1cW92NlB2QT0%3D&ovuser=72f988bf-86f1-41af-91ab-2d7cd011db47%2Cchulahlou%40microsoft.com&OR=Teams-HL&CT=1649705566054&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyOC8yMjAzMjEwMDEwNyJ9)
- [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Most components in this scenario can be scaled up or down based on the analysis activity levels.
- You can scale [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) based on the data size and the necessary compute resources for model training. For the deployment, you can scale compute resources based on the expected load and scoring service and latency requirements with the AKS service.
- You can scale and tune the IoT hub and Azure Data Factory to handle large data ingestions.
- For more information about designing scalable solutions, see [Performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

## Contributors
*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | Principal Cloud Solution Architect, US National CSA Team

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
- [Charitha Basani](https://www.linkedin.com/in/charitha-basani-54196031) | Senior Cloud Solution Architect, US National CSA Team

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Track ML models with MLflow and Azure Machine Learning](/azure/machine-learning/how-to-use-mlflow)
- [Azure Databricks documentation](/azure/databricks/index)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure IoT Edge documentation](/azure/iot-edge/index)
- [Azure IoT Hub documentation](/azure/iot-hub/index)
- [Azure Time Series Insights documentation](/azure/time-series-insights/index)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Detect and visualize anomalies in your data with the Anomaly Detector API - Jupyter Notebook demo](https://github.com/Azure-Samples/AnomalyDetector/tree/master/ipython-notebook)
- [Identify anomalies by routing data via IoT Hub to a built-in machine learning model in Azure Stream Analytics](/training/modules/examine-iot-hub-message-routing)
- [Recipe: Predictive maintenance with the Cognitive Services for Big Data](/azure/cognitive-services/big-data/recipes/anomaly-detection)

## Related resources

- [Predictive maintenance solution](../../industries/manufacturing/predictive-maintenance-solution.yml)
- [Extract actionable insights from IoT data](../..//industries/manufacturing/extract-insights-iot-data.yml)
- [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.yml)
- [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml)
- [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml)
- [IoT Edge railroad maintenance and safety system](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml)
- [Quality assurance](../../solution-ideas/articles/quality-assurance.yml)
- [Deploy AI and machine learning computing on-premises and to the edge](../../hybrid/deploy-ai-ml-azure-stack-edge.yml)
- [MLOps for Python models using Azure Machine Learning](../../reference-architectures/ai/mlops-python.yml)
- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
