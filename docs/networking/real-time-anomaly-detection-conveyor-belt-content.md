The manufacturing industry is undergoing revolutionary changes as an increasing number of firms adopt smart factory floors enabled by artificial intelligence and machine learning. Smart factory floors digitally enable collaborative systems to provide real time responses to changing conditions and customer demands throughout their supply network.

AI (Artificial Intelligence) and ML (Machine Learning) have been applied in a variety of unique ways throughout the manufacturing sector. The most impactful of these applications are predictive maintenance and fault prevention. Particularly, detecting anomalies in temperature and vibrations of motors attached to conveyor belts has reduced maintenance costs, repair/overhaul time, and the need for spare part inventory, all while simultaneously increasing the uptime of the machinery. The introduction of predictive maintenance and fault prevention saves millions of dollars a year and in some cases saves lives by removing personnel from dangerous situations.

There are several ways to achieve predictive maintenance including rule-based, supervised, and unsupervised machine learning. Rule-based ML requires known threshold levels. In the case where labels are available for anomalies, supervised ML has proven the most viable option. If no labels are available for the detection of anomalous behavior, unsupervised anomaly detection is the method of choice. Irrespective of the methodology, the model's outcome is to predict if the incoming data is anomalous.

As sensors capture data in real time, anomaly detection methodology should be able to detect them immediately. Potential risks that would otherwise go undetected can be addressed before they escalate. This document provides an overview of an architecture to enable real-time anomaly detection.

## Potential use cases

This solution can apply to the following scenarios:
- **Mining use case:** Predictive maintenance of conveyor belts for ore mining, specifically relevant for underground ore mining, opencast ore mining, and ore processing.
- **Healthcare use case:** Predictive maintenance of conveyor belts used for pharmaceutical products and medical packaging.
- **Food Industry use case:** Predictive maintenance of conveyor belts used for food production and packaging.
 
## Architecture

diagram 

*Download a [Visio file] (https://arch-center.azureedge.net/[filename].vsdx) of this architecture.*

### Workflow

1. Data source

   A sophisticated data-collection sensor is a crucial component of the Internet of Things (IoT). The purpose of sensors is to collect analog data from the physical world and translate it into digital data assets. Sensors can measure just about any aspect of the physical world. The calibration of sensors allows them to be tailored to application-specific functions. In this dataset, sensors have been calibrated to accurately measure temperature and vibrations.
   
   On most factory floors, conveyor belts are run between specific schedules. Anomaly detection of temperature and vibrations are needed when the conveyor belt is up and running. Conveyor belt status is captured and relayed using a Time Series API.

1. Ingest

   [Azure IoT](/azure/iot-fundamentals/iot-introduction) Hub is recommended for streaming data from IoT sensors and connecting IoT devices. For ingesting data from Time Series API and data orchestration, [Azure Data Factory](/azure/data-factory/introduction) is recommended.

1. Store
   
   Data collected from IoT sensors (Temperature and vibrations) and Timeseries API (conveyor belt status) are all time series. Time series data is a collection of observations obtained through repeated measurements over time. This data is collected as flat files. Each flat file is tagged with IoT Sensor ID, and the date/time when it is collected and stored in [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake).

1. AI/ML - Data prep/Train

   **Data preparation** is the process of gathering, combining, structuring, and organizing data so it can be used to build machine learning models, business intelligence (BI), and analytics and data visualization applications.
   
   [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is used to prepare the data before it is used to build models. Databricks provide an interactive workspace that enables collaboration between data engineers, data scientists, and machine learning engineers. As part of the analytics workflow, [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is used to read data from [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) to perform data wrangling and data exploration.

   **Model training** refers to the process of allowing a machine learning algorithm to learn patterns based on data and to pick a suitable model capable of predicting the attrition of previously unseen students.
 
   [Azure Machine learning (AML) Studio](https://azure.microsoft.com/services/machine-learning) is used to train the model. AML is a cloud service used for accelerating and managing the machine learning project lifecycle including training, deploying models, and managing MLOps (Machine Learning Operations).

1. AI/ML - Inference

   Machine learning Inference is the process of feeding previously unseen data points into a machine learning model to calculate an output such as a numerical score, in this case determining if input data is anomalous.

   The model registry is built into [AML (Azure Machine Learning)](https://azure.microsoft.com/services/machine-learning) and is used to store and version models in the Azure cloud. The model registry makes it easy to organize and keep track of trained models.

   After a machine learning model is trained, the model needs to be deployed so newly available data can be fed through it for inferencing. The deployment target is [Azure Managed Endpoint](/azure/machine-learning/concept-endpoints). Azure managed endpoint is the recommended deployment option that can be implemented easily.

1. Analytical workload

   The results of model scoring are saved back into the analytic systems in this case [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) where the input data was collected. This helps in sourcing the results to the front-end and model monitoring and retraining.

1. Frontend model consumption

   The scored results can be consumed through an app or on the [Power BI](/power-bi/fundamentals/power-bi-overview) platform. In this use case, with real time inferencing as soon as the anomalies are detected alerts can be routed to stakeholders through custom 1st or 3rd-party event management APIs hosted in Azure or elsewhere.

## Sample temperature, vibrations, and conveyor belt status data

The data necessary to predictively maintain motors attached to conveyor belts are temperature, vibrations, and conveyor belt status. The data exhibited below is a sample for the reference.

**Conveyor Belt Status:** On most factory floors, conveyor belts are run on specific schedules. Anomaly detection of temperature and vibrations are needed only when the conveyor belt is up and running. Convery belt value zero means the conveyor belt was inactive and one means it is active. Below is a sample plot of how conveyor belt status is recorded.

image 

**Temperature:** Sensors attached to conveyor belts and the factory floor can record the temperature of the motor and baseline the ambient temperature. Temperature is seasonally affected due to sunlight exposure, air conditioning settings, and numerous other factors. It is important to address the seasonality aspect of temperature. One of the many ways is to use the baseline ambient temperature on the factory floor and take the difference with the motor temperature to adjust the seasonality in the motor temperature *(Adjusted Temperature = Motor Temperature - Ambient Temperature)*. Below is a sample plot showing temperatures recorded from motors and the ambient baseline temperature.

image

Below is a sample plot where the temperature from a conveyor belt motor has been adjusted for seasonality using the ambient temperature of the factory floor. It also shows anomalies in red that are detected by the model using the architecture suggested in the document.

image 

**Vibrations:** Sensors collect vibrations as RMS (Root Mean Square) of the half sinusoidal wave. Since RMS represents the area and not the peak value, it is important to convert RMS to peak before anomalies are found. Below is a sample plot of how vibration peak data is collected by a sensor attached to a motor.

image 

Below is a sample plot that shows vibration anomalies in red that are detected by the model using the architecture suggested in this document.

image 

### Components

- [Azure IoT Hub]() is a collection of Microsoft-managed cloud services that connect, monitor, and control billions of IoT assets. In simpler terms, an IoT solution is made up of one or more IoT devices that communicate with one or more back-end services hosted in the cloud.
- [Azure Data Factory]() is a cloud-based data integration service that automates data movement and transformation.
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a limitless data storage to house data in different shapes/formats and provides easier integration to the Analytics tools in Azure. The component has enterprise grade security and monitoring support. One can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for the ML (MACHINE LEARNING) data and a Premium data cache for training the ML model.
- [Azure Databricks]() is a data analytics platform optimized for the Microsoft Azure cloud services platform. Azure Databricks offers three environments for developing data intensive applications: Databricks SQL, Databricks Data Science & Engineering, and Databricks Machine Learning.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is the enterprise grade machine learning service for easier model development and deployment to a wide range of ML target computes. It provides users, at all skill levels, with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs (Integrated Development Environments).
- [Azure Managed Endpoint for Machine Learning](https://docs.microsoft.com/azure/machine-learning/concept-endpoints) are the HTTPS endpoints that clients can call to receive inferencing(scoring) output of a trained model that provides a stable scoring URI with a key-token authentication.
- [Power BI]() is the Azure SaaS (software as a service) for Business Analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easier transformation capabilities, and sophisticated visualization capabilities.

### Alternatives

- Azure ML is the data modeling and deployment tool in this solution. One can also build the solution in Azure Databricks with a code-first approach. 
- Event Hubs can be a suitable alternative to IoT Hub for ingesting big data. Both Event Hub and IoT Hub are designed for data ingestion at a massive scale.
- One can have the data staged in Cosmos DB or Azure SQL Database instead of Azure Data Lake and the data staging/analysis can be accomplished using Azure Data Factory.
- As an alternative to Databricks, Azure Synapse could be used for Data exploration.
- Grafana could be used as the visualization tool instead of Power BI.
- AKS can be an alternative to managed endpoints if one wants more control over that compute tier.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).
 
The technologies in this architecture were chosen for scalability and availability reasons with the aim of managing and controlling the costs.

The Azure Industrial IoT helps you accelerate your path to modernize your connected factory. Also, Azure Digital Twin helps you to model the connected physical environments in a manufacturing setup. The following are some resources to consider:

- [Azure Industrial IoT – IoT for Industry 4.0](https://azure.microsoft.com/solutions/industry/manufacturing/iot/#overview)
- [Digital Twins – Modeling and Simulations](https://azure.microsoft.com/services/digital-twins/#overview)

### Reliability

The components in this architecture feature high availability. However, machine learning and analytics tasks are comprised of two parts: training and production deployment.

Resources required for training do not typically require high availability, as for production deployment high availability is fully supported by [Azure Managed Endpoint](/azure/machine-learning/concept-endpoints).

### Security

This scenario features built in security within the components, as well as permissions that can be managed via Azure Active Directory authentication or role-based access control. Consider the following [Azure Machine learning best practices for enterprise security](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-enterprise-security) to establish suitable security levels.

Manage the security and access to the IoT Hub which interacts with the IoT sensors following the baseline outlines in [IoT Hub Security](/security/benchmark/azure/baselines/iot-hub-security-baseline).

Consider implementing the following security features in this architecture: 

- [Deploy Azure services in Azure Virtual Network](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise Security and Governance - Azure ML](/azure/machine-learning/concept-enterprise-security)
- [Overview of the security pillar](/azure/architecture/framework/security/overview)

### Cost optimization

- Scalability of the resources depends on the analytics workload and training and deployment workloads enabled to optimize costs as needed.
- Choose the appropriate pricing tier for the IoT hub and appropriate compute sizes for ML and data processing components.
- To estimate the cost of implementing this solution, please utilize [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) for the services mentioned above. It is also valuable to refer to the [Overview of the cost optimization pillars](/azure/architecture/framework/cost/overview).
 
### Operational excellence

Follow MLOps guidelines to standardize and manage an end-to-end Machine Learning lifecycle scalable across multiple workspaces. Before going into production, ensure the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. Below are a few resources to consider:
- [MLOps v2 (sharepoint.com)](https://microsoft.sharepoint.com/teams/CS_AzureDataAI/SitePages/Mlops.aspx?xsdata=MDV8MDF8fDVhM2M4ZDViNjM1ODRhMWFjMDM3MDhkYTFiZjIwYTkzfDcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3fDB8MHw2Mzc4NTMwMjM1OTk4MzcyMzl8R29vZHxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazkwYUdWeUlpd2lWMVFpT2pFeGZRPT18MXxNVGs2TXpCak9HUmlOR1JsTkRSbE5EVmlaR0UwWVRNMFpqQmpPV1kzT1RWa1pqaEFkR2h5WldGa0xuWXl8fA%3D%3D&sdata=czFMOUVSa3J1WjBSbm5haDc3NStGUVVGYTZyZE93MmF4d3U1cW92NlB2QT0%3D&ovuser=72f988bf-86f1-41af-91ab-2d7cd011db47%2Cchulahlou%40microsoft.com&OR=Teams-HL&CT=1649705566054&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyOC8yMjAzMjEwMDEwNyJ9)
- [Azure/mlops-v2: Azure MLOps (v2) solution accelerators. (github.com)](https://github.com/Azure/mlops-v2)

### Performance efficiency

- Most components in this scenario can be scaled up or down depending on the analysis activity levels. 
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) can be scaled depending on the data size and the necessary compute resources for model training. For the deployment, compute resources can be scaled based on expected load and scoring service and latency requirements with the AKS (Azure Kubernetes Service) service.
- The IoT hub and Azure Data Factory can be scaled /tuned to handle large data ingestions. 
- Consult the [Performance Efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency) for guidance on designing scalable solutions.

## Contributors
*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 
- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | [Senior Cloud Solution Architect, US National CSA Team
- [Charitha Basani](https://www.linkedin.com/in/charitha-basani-54196031) | [Senior Cloud Solution Architect, US National CSA Team

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- What is Azure Machine Learning?
- Track ML models with MLflow and Azure Machine Learning
- Azure Databricks Documentation
- Azure DataFactory Documentation
- Introduction to Azure Blob Storage
- Introduction to Azure Data Lake Storage Gen2
- Azure IoT Edge documentation
- Azure IoT Hub Documentation
- Azure Time Series Insights Documentation
- Advanced analytics architecture
- What is Power BI?
- Detect and visualize anomalies in your data with the Anomaly Detector API - Demo on Jupyter Notebook
- Identify anomalies by routing data via IoT Hub to a built-in ML model in Azure Stream Analytics
- Recipe: Predictive maintenance with the Cognitive Services for Big Data

## Related resources

- Predictive maintenance solution
- Extract actionable insights from IoT data
- Azure industrial IoT analytics guidance
- Connected factory hierarchy service
- Connected factory signal pipeline
- IoT Edge railroad maintenance and safety system
- Quality assurance
- Deploy AI and ML computing on-premises and to the edge
- MLOps for Python models using Azure Machine Learning

