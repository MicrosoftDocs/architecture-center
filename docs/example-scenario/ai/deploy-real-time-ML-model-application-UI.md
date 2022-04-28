>Title **name**

This article expands on the article [Citizen AI with the Power Platform](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/ai/citizen-ai-power-platform), which provides a high-level example of a low-code, end-to-end "lambda architecture" for real-time and batch data streaming. It will cover how to deploy ML models for real-time and batch inference and how to consume them using an end-user application or analyze results further in Power BI.

This article will guide you through an MVP architecture using semi-structured data stored in [Azure Data Lake](/azure/machine-learning/concept-data). This data is used in [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) for ML model training. The model is deployed to a real-time endpoint deployed on [Azure Container Instance (ACI)](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-container-instance) or [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python) cluster. Finally, the model is consumed through a low-code custom business user app using Power Apps.


**Solution Benefits**:
The ability to rapidly prototype and validate an AI application in a real-world setting becomes a key enabler to a fail-fast approach.

- **Azure Machine Learning: an ML toolkit for all skill levels**:
  - Supports no-code to fully-coded ML development
  - Has a flexible, low-code GUI
  - Enables users to rapidly source and prep data
  - Enables users to rapidly build and deploy models
  - Has advanced, automated ML capabilities for ML algorithm development
- **Power Apps and Power Automate: A low-code application development toolkit**
  - Enables users to build custom applications and automation workflows
  - Creates workflows so that consumers and business processes can interact with an ML model

## Potential use cases
- **Industry**: Automotive
- **Scenario**: The solution in this article is aimed at helping a buyer or a purchasing agent estimate a car's market price. Using a Power App, user can submit vehicle details to a model that has been trained on market data and receive a price prediction in return..

The applicability of this example scenario **is not limited to a specific industry and could be applied in a variety of use cases**. Any use case that leverages data stored on a data lake using those for model training and deployment to a real-time web application elements could be also used for unstructured/structured data.

Examples include (but not limited to):
- **Customer Segmentation**: identify target markets based on real-time data and indicators, e.g. predict what promotion a shopper might respond to based on purchase data and customer details.
    - Key industries: Banking, Insurance, Retail, Telecommunications.
- **Churn Prevention**: identifying signs of dissatisfaction among customers and identify customers who are at risk for leaving.
    - Key industries: Banking, Insurance, Automotive, Retail
- **Predictive Maintenance**: Operational reporting, as well as analyzing metrics and real-time data related to the lifecycle maintenance of technical equipment, companies can predict timelines and potential maintenance events with upcoming expenditure requirements in order to optimize heir maintenance costs and avoid critical downtime.
    - Key industries: Automotive, Manufacturing, Logistics, Oil & Gas
- **Real-time Personalization**: generating personalized recommendations for customers in real-time.
    - Key industries: Retail, e-commerce.

## Architecture
The architecture below extends on the [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml) scenario. It allows for a custom ML model to be trained in Azure Machine Learning, and implemented with a custom application built using Microsoft Power Platform.
[Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) fulfills the role of a low-code GUI for ML development. It has automated ML, and deployment to batch or real-time endpoints. [Microsoft Power Platform](https://powerplatform.microsoft.com), which includes [Microsoft Power Apps](https://powerapps.microsoft.com) and [Microsoft Power Automate](https://flow.microsoft.com), provides the toolkits to rapidly build a custom application and workflow that implements your ML algorithm. End business users can now build production grade ML applications to transform legacy business processes.

:::image type="content" source="media/deploy-real-time-ML-model-application-UI.png" alt-text="An ML model created in Machine Learning obtains car data from Azure Data Lake, and provides inferences to an endpoint. An app created with Power Platform accesses the endpoint and interacts with the user." lightbox="media/deploy-real-time-ML-model-application-UI.png" :::

_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

### Dataflow

**1 - Ingest:** Semi-structured data (e.g. json, xml, csv, logs) is loaded into Azure Storage. You could easily extend the scope of data ingestion - using [Azure Synapse pipelines](/azure/data-factory/concepts-pipelines-activities) to pull batch data from a wide variety of sources, both on-premises and in the cloud - to additional data types such as (without changing the architecture design):  
- Unstructured data (e.g. video, images, audio, free text).
- Structured data (e.g. relational databases, Azure Data Services).

**2 - Store:** Ingested data can be landed directly in raw format and then transformed on the [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction).

**3 - Train and deploy model:** [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) provides an enterprise-grade ML service for building and deploying models faster. It provides users at all skill levels with a low-code designer, automated ML (autoML), and a hosted Jupyter notebook environment. Models can be deployed either as real-time endpoints on [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/machine-learning/), or as a Machine Learning [Managed online endpoint](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-managed-online-endpoints). For batch inferencing of ML models, you can use [Machine Learning pipelines](/azure/machine-learning/concept-ml-pipelines).

**4 - Consume:** A real-time—published model in Machine Learning can generate a REST endpoint that can be consumed in a [custom application built using the low-code Power Apps platform](/connectors/custom-connectors/use-custom-connector-powerapps). You can also call a [real-time Machine Learning endpoint from a Power BI report](/power-bi/connect-data/service-aml-integrate) to present predictions in business reports.

[!NOTE] Both Machine Learning and Power Platform stack have a range of built-in connectors to help ingest data directly. These may be useful for a one-off minimum viable product (MVP). However, the **Ingest** and **Store** sections of the architecture advise on the role of standardized data pipelines for the sourcing and storage of data from different sources at scale – patterns that are typically implemented and maintained by the enterprise data platform teams.

Here's a user interface for the app, created in Power Apps by using the low-code interface that Power Apps provides.

:::image type="content" source="media/deploy-real-time-ML-model-car-price-predictor.png" alt-text="The UI provides various controls, such as buttons and drop-down lists, for the user to enter car data. The app predicts a price and displays it when the when the user selects the Predict button." lightbox="media/deploy-real-time-ML-model-car-price-predictor.png" :::

You can use Power Automate to build a low-code workflow to parse the user's input, pass it to the Machine Learning endpoint, and retrieve the prediction. You can also use [Power BI to interact with the Machine Learning model](/power-bi/connect-data/service-aml-integrate) and create custom business reports and dashboards.

:::image type="content" source="media/deploy-real-time-ML-model-car-price-predictor-dashboard.png" alt-text="Schematic of the workflow." lightbox="media/deploy-real-time-ML-model-car-price-predictor-dashboard.png" :::

To deploy this end-to-end example, follow [step by step instructions using this sample Power App](https://github.com/Azure/carprice-aml-powerapp).

### Components
#### Azure Data & AI services
- [Azure Data Lake](/azure/machine-learning/concept-data): A Hadoop compatible file system. It has an integrated hierarchical namespace and the massive scale and economy of Azure Blob Storage.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): An enterprise-grade ML service for building and deploying models quickly. It provides users at all skill levels with a low-code designer, automated ML, and a hosted Jupyter notebook environment to support your own preferred IDE of choice.
- [Machine Learning managed endpoints](/azure/machine-learning/how-to-deploy-managed-online-endpoints): Online endpoints that enable you to deploy your model without having to create and manage the underlying infrastructure.
- [Azure Kubernetes Service](/azure/machine-learning/how-to-create-attach-kubernetes?tabs=python): Machine Learning has varying support across different compute targets. Azure Kubernetes Service is one such target, which is a great fit for enterprise high-scale production deployments. Provides fast response time and autoscaling of the deployed service. 
- [Azure Container Instance (ACI)](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-container-instance): Azure Container Instance is great fit for Real-time inference and it is recommended for dev/test purposes only. Use for low-scale CPU-based workloads that require less than 48 GB of RAM and you don't need to manage a cluster.

#### Power Platform services
- [Microsoft Power Platform](https://powerplatform.microsoft.com): A set of tools for analyzing data, building solutions, automating processes, and creating virtual agents. It includes Power App, Power Automate, Power BI, and Power Virtual Agents.
- [Microsoft Power Apps](https://powerapps.microsoft.com): A suite of apps, services, connectors, and data platform. It provides a rapid application development environment to build custom apps for your business needs.
- [Microsoft Power Automate](https://flow.microsoft.com): A service that helps you create automated workflows between your favorite apps and services. Use it to synchronize files, get notifications, collect data, and so on.

### Alternatives
The solution in this article focuses on an architecture which benefits of speed to outcome. In some specific use cases, the needs of a custom model can be met by pre-trained models using [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) or [Azure Applied AI Services](https://azure.microsoft.com/product-categories/applied-ai-services). In others, [Power Apps AI Builder](https://powerapps.microsoft.com/ai-builder) may provide a fit-for-purpose model.

## Considerations

This article outlines an MVP or proof-of-concept solution. In order to take this implementation to production level and scale, you would need to take into account some additional consideretions depending on the use case. Frameworks such as the [Azure Well-Architected Framework](/azure/architecture/framework) provide reference guidance and best practices to apply to your architecture.

In addition, in the world of machine learning and custom model training and deployment, you should consider to implementing additional governance and adopt practices for operations, such as [MLOps](https://azure.microsoft.com/en-au/services/machine-learning/mlops/?msclkid=582fd3e1b10711ecb0ef71c8772fc3df), [DevOps](https://azure.microsoft.com/overview/what-is-devops/) and CI/CD, etc.

### Availability

Most of the components used in this example scenario are managed services that will automatically scale. The [availability of the services](https://azure.microsoft.com/global-infrastructure/services/?products=machine-learning-service%2Cvirtual-machines&regions=all) used in this example varies by region.

Apps based on ML typically require one set of resources for training and another for serving. Resources required for training generally don't need high availability, as live production requests don't directly hit these resources. Resources required for serving requests need high availability.

### Security

[Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview): Think about security throughout the entire lifecycle of an application, from design and implementation to deployment and operations. The Azure platform provides protections against various threats, such as network intrusion and DDoS attacks. But you still need to build security into your application and into your DevOps processes.

### Cost optimization

**Azure Pricing:** First party Infrastructure-as-a-Service (IaaS) and Platform-as-a-Service (PaaS) services on Azure use a consumption-based pricing model. They don't require a license or subscription fee. In general, you can easily use the [pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator) in order to estimate the cost of using the above services in conjunction with your specific data size and workloads. For other considerations, see [Cost Optimization](/azure/architecture/framework/cost/index) in the Well-Architected Framework.

Links to additional resources in regards to pricing:

- [Azure Data Lake Storage - pricing table](https://azure.microsoft.com/en-us/pricing/details/storage/data-lake/?msclkid=65cae5d2b10611eca749c2e020fbdb33#pricing)
- [Azure Machine Learning - pricing table](https://azure.microsoft.com/en-us/pricing/details/machine-learning/?msclkid=c44a0944b10611eca46b8cf6d22ed8a5#pricing)

**Power Platform Pricing:** Power Apps and  Power Automate are Software-as-a-Service (SaaS) applications and have their own pricing models, including per app plan, and per user.

Links to additional resources in regards to pricing:

- [Power Apps - pricing](https://powerapps.microsoft.com/en-gb/pricing/?msclkid=f8e8f44fb10611ecb4121fb6e8f9b9e9)
- [Power Automate - pricing](https://powerautomate.microsoft.com/en-us/pricing/?msclkid=13755fd5b10711eca34228766c562f61)

### Operational excellence

- Azure Machine Learning capabilities that automate and accelerate the machine learning lifecycle with [MLOps](https://azure.microsoft.com/en-au/services/machine-learning/mlops/?msclkid=582fd3e1b10711ecb0ef71c8772fc3df).
- Learn how [DevOps](https://azure.microsoft.com/overview/what-is-devops/)unifies people, process, and technology to bring better products to customers faster.
- The [overview of the operational excellence pillar](/azure/architecture/framework/devops/overview) covers the operations processes that keep an application running in production. Deployments must be reliable and predictable. Automated deployments reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must be able to quickly roll back or roll forward if an update has problems.

- How Azure Machine Learning works: [Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture)
- [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
- [End-to-end manufacturing using computer vision on the edge](../../reference-architectures/ai/end-to-end-smart-factory.yml)

### Performance efficiency

[Performance efficiency](/azure/architecture/framework/scalability/overview) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. The main ways to achieve performance efficiency include using scaling appropriately and implementing PaaS offerings that have scaling built in.

## Deploy this scenario

You can use Power Automate to build a low-code workflow to parse the user's input, pass it to the Machine Learning endpoint, and retrieve the prediction. You can also use [Power BI to interact with the Machine Learning model](/power-bi/connect-data/service-aml-integrate) and create custom business reports and dashboards.

To deploy this end-to-end example, follow [step by step instructions using this sample Power App](https://github.com/Azure/carprice-aml-powerapp).

## Contributors

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:**

- [Christina Skarpathiotaki](http://www.linkedin.com/in/christinaskarpathiotaki/) | [AI Cloud Solution Architect]

**Additional contributors:**
- [Brady Leavitt](https://www.linkedin.com/in/bradyleavitt/) | [Technical Specialist, AI/ML]

## Related resources

- [Build intelligent applications infused with world-class AI](https://mybuild.microsoft.com/sessions/2ba55238-d398-46f9-9ff2-eafcd9d69df3)
- [Artificial intelligence (AI)](/azure/architecture/data-guide/big-data/ai-overview)
- [Compare the ML products and technologies from Microsoft](../../data-guide/technology-choices/data-science-and-machine-learning.md)
- [Machine learning at scale](../../data-guide/big-data/machine-learning-at-scale.md)
- [Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../mlops/mlops-technical-paper.yml)