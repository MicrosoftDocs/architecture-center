This article expands on [Citizen AI with the Power Platform](../ai/citizen-ai-power-platform.yml), which provides a high-level example of a low-code, end-to-end **lambda architecture** for real-time and batch data streaming. It covers how to deploy machine learning models for real-time and batch inference. The article also covers how to consume them by using an end-user application or analyzing results in Power BI.

This article guides you through a model-view-presenter (MVP) architecture by using semi-structured data stored in [Azure Data Lake Storage](/azure/machine-learning/concept-data). You use this data in [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) for machine learning model training. You deploy the model to a real-time endpoint deployed on an [Azure Container Instance](/azure/machine-learning/how-to-deploy-azure-container-instance) or [Azure Kubernetes Service (AKS)](/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python) cluster. Finally, the model is consumed through a low-code custom business user app by using Power Apps.

The ability to rapidly prototype and validate an AI application in a real-world setting is important to a fail-fast approach.

- **Machine Learning: a machine learning toolkit for all skill levels**:
  - Supports no-code to fully coded machine learning development
  - Has a flexible, low-code GUI
  - Enables users to rapidly source and prep data
  - Enables users to rapidly build and deploy models
  - Has advanced, automated machine learning capabilities for machine learning algorithm development
- **Power Apps and Power Automate: A low-code application development toolkit**
  - Enables users to build custom applications and automation workflows
  - Creates workflows so that consumers and business processes can interact with a machine learning model

## Potential use cases

This example workload is designed to help a buyer or a purchasing agent in the automotive industry estimate a car's market price. A user can use a Power App to submit vehicle details to a model that's trained on market data and receive a price prediction in return.

The applicability of this example workload **isn't limited to a specific industry and can apply to a variety of use cases**. Any use case that uses data stored on a data lake for model training and deployment to a real-time web application can also be used for unstructured or structured data.

Examples include:

- **Customer segmentation**: Identify target markets based on real-time data and indicators, like predicting what promotion a shopper might respond to based on purchase data and customer details.
  - Key industries: Banking, insurance, retail, telecommunications.
- **Churn prevention**: Identify signs of dissatisfaction among customers and identify customers who are at risk for leaving.
  - Key industries: Banking, insurance, automotive, retail
- **Predictive maintenance**: With operational reporting, and analyzing metrics and real-time data related to the lifecycle maintenance of technical equipment, companies can predict timelines and potential maintenance events with upcoming expenditure requirements to optimize maintenance costs and avoid critical downtime.
  - Key industries: Automotive, manufacturing, logistics, oil and gas
- **Real-time personalization**: Generate personalized recommendations for customers in real-time.
  - Key industries: Retail, e-commerce.

## Architecture

This architecture extends the [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml) scenario. With this scenario, a custom machine learning model can train in Machine Learning. Then you can implement the model with a custom application built by using Microsoft Power Platform.

[Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) fulfills the role of a low-code GUI for machine learning development. It has automated machine learning and deploys to batch or real-time endpoints. [Microsoft Power Platform](https://powerplatform.microsoft.com), which includes [Microsoft Power Apps](https://powerapps.microsoft.com) and [Microsoft Power Automate](https://flow.microsoft.com), provides the tools to rapidly build a custom application and workflow that implements your machine learning algorithm. Now your end business users can build production grade machine learning applications to transform their legacy business processes.

:::image type="content" source="media/deploy-real-time-machine-learning-model-application-ui.png" alt-text="Diagram that shows a machine learning model created in Machine Learning that obtains car data from Data Lake Storage and provides inferences to an endpoint. An app created with Power Platform accesses the endpoint and interacts with the user." lightbox="media/deploy-real-time-machine-learning-model-application-ui.png" :::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-real-time-machine-learning-model-application-ui.vsdx) of this architecture.*

### Dataflow

1. **Ingest:** Semi-structured data, like json, xml, csv, and logs, is loaded into Data Lake Storage. You can extend the scope of data ingestion by using [Azure Synapse pipelines](/azure/data-factory/concepts-pipelines-activities) to pull batch data from a wide variety of sources. You can extend the scope to more data types—without changing the architecture design—both on-premises and in the cloud. This data includes:

   - Unstructured data like video, images, audio, and free text.
   - Structured data like relational databases and Azure data services.

2. **Store:** You can ingest data in a raw format and then transform it in [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction).

3. **Train and deploy model:** [Machine Learning](https://azure.microsoft.com/services/machine-learning) provides an enterprise-grade machine learning service to quickly build and deploy models. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment. You can deploy models as real-time endpoints on [AKS](/azure/machine-learning) or as a Machine Learning [managed online endpoint](/azure/machine-learning/how-to-deploy-managed-online-endpoints). For batch inferencing of machine learning models, you can use [Machine Learning pipelines](/azure/machine-learning/concept-ml-pipelines).

4. **Consume:** A real-time published model in Machine Learning can generate a REST endpoint that can be consumed in a [custom application built using the low-code Power Apps platform](/connectors/custom-connectors/use-custom-connector-powerapps). You can also call a [real-time Machine Learning endpoint from a Power BI report](/power-bi/connect-data/service-aml-integrate) to present predictions in business reports.

[!NOTE] Both the Machine Learning and Power Platform stack have a range of built-in connectors to help ingest data directly. These connectors might be useful for a one-off minimally viable product. However, the **Ingest** and **Store** sections of the architecture promote the role of standardized data pipelines for the sourcing and storage of data from different sources at scale. These patterns are typically implemented and maintained by the enterprise data platform teams.

### Components

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): A Hadoop compatible file system. It has an integrated hierarchical namespace and the scale and economy of Azure Blob Storage.
- [Machine Learning](https://azure.microsoft.com/services/machine-learning): An enterprise-grade machine learning service used to quickly build and deploy models. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment to support your own preferred IDE of choice.
- [AKS](https://azure.microsoft.com/services/kubernetes-service): Machine Learning has varying support across different compute targets. Azure Kubernetes Service is one such target, which is a great fit for enterprise high-scale production deployments. It provides a fast response time and autoscaling of the deployed service.
- [Container Instances](https://azure.microsoft.com/services/container-instances): Container Instances is great fit for real-time inference and it's recommended for development and test purposes only. Use it for low-scale CPU-based workloads that require less than 48 gigabytes of RAM and if you don't need to manage a cluster.
- [Power Platform](https://powerplatform.microsoft.com): A set of tools for analyzing data, building solutions, automating processes, and creating virtual agents. It includes Power App, Power Automate, Power BI, and Power Virtual Agents.
- [Power Apps](https://powerapps.microsoft.com): A suite of apps, services, connectors, and data platform. It provides a rapid application development environment to build custom apps for your business needs.
- [Power Automate](https://flow.microsoft.com): A service that helps you create automated workflows between your favorite apps and services. Use it to synchronize files, get notifications, collect data, and so on.

### Alternatives

The solution in this article focuses on an architecture that benefits from speed-to-outcome. In specific use cases, the needs of a custom model can be met by pre-trained models by using [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) or [Azure Applied AI Services](https://azure.microsoft.com/product-categories/applied-ai-services). In others, [Power Apps AI Builder](https://powerapps.microsoft.com/ai-builder) might provide a fit-for-purpose model.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

In the world of machine learning and custom model training and deployment, you should consider implementing more governance and adopt practices for operations like [MLOps](https://azure.microsoft.com/services/machine-learning/mlops/?msclkid=582fd3e1b10711ecb0ef71c8772fc3df), [DevOps](https://azure.microsoft.com/overview/what-is-devops), and continuous integration/continuous delivery (CI/CD).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Most of the components used in this example scenario are managed services that automatically scale. The [availability of the services](https://azure.microsoft.com/global-infrastructure/services/?products=machine-learning-service%2Cvirtual-machines&regions=all) used in this example varies by region.

Apps based on machine learning usually require one set of resources for training and another for serving. Resources required for training generally don't need high availability, as live production requests don't directly hit these resources. Resources required for serving requests need high availability.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

**Azure Pricing:** First party infrastructure-as-a-service (IaaS) and platform-as-a-service (PaaS) services on Azure use a consumption-based pricing model. They don't require a license or subscription fee. You can use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of using the services with your specific data size and workloads.

See the following links for more Azure service pricing resources:

- [Data Lake Storage](https://azure.microsoft.com/pricing/details/storage/data-lake/?msclkid=65cae5d2b10611eca749c2e020fbdb33#pricing)
- [Machine Learning](https://azure.microsoft.com/pricing/details/machine-learning/?msclkid=c44a0944b10611eca46b8cf6d22ed8a5#pricing)

**Power Platform Pricing:** Power Apps and  Power Automate are software-as-a-service (SaaS) applications and have their own pricing models, including per app plan and per user.

- [Power Apps](https://powerapps.microsoft.com/pricing/?msclkid=f8e8f44fb10611ecb4121fb6e8f9b9e9)
- [Power Automate](https://powerautomate.microsoft.com/pricing/?msclkid=13755fd5b10711eca34228766c562f61)

## Deploy this scenario

Here's an example user interface for the app, which was created in Power Apps by using the low-code interface that Power Apps provides.

:::image type="content" source="media/deploy-real-time-machine-learning-model-car-price-predictor.png" alt-text="Screenshot that shows the UI controls, like buttons and drop-down lists, for the user to enter car data." lightbox="media/deploy-real-time-machine-learning-model-car-price-predictor.png" :::

You can use Power Automate to build a low-code workflow to parse the user's input, pass it to the Machine Learning endpoint, and retrieve the prediction. You can also use [Power BI to interact with the Machine Learning model](/power-bi/connect-data/service-aml-integrate) and create custom business reports and dashboards.

:::image type="content" source="media/deploy-real-time-machine-learning-model-car-price-predictor-dashboard.png" alt-text="Diagram that shows the workflow." lightbox="media/deploy-real-time-machine-learning-model-car-price-predictor-dashboard.png" :::

To deploy this end-to-end example, follow the [step by step instructions by using this sample Power App](https://github.com/Azure/carprice-aml-powerapp).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Christina Skarpathiotaki](http://www.linkedin.com/in/christinaskarpathiotaki) | AI Cloud Solution Architect

Other contributors:

- [Brady Leavitt](https://www.linkedin.com/in/bradyleavitt) | Technical Specialist, AI/ML
- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

## Next steps

- [Build intelligent applications infused with world-class AI](https://mybuild.microsoft.com/sessions/2ba55238-d398-46f9-9ff2-eafcd9d69df3)
- [Data Lake Storage](/azure/machine-learning/concept-data)
- [Machine Learning managed endpoints](/azure/machine-learning/how-to-deploy-managed-online-endpoints)
- [AKS](/azure/machine-learning/how-to-create-attach-kubernetes?tabs=python)
- [Container Instances](https://docs.microsoft.com/azure/machine-learning/how-to-deploy-azure-container-instance)
- [Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture)

## Related resources

- [Artificial intelligence (AI)](/azure/architecture/data-guide/big-data/ai-overview)
- [Compare the machine learning products and technologies from Microsoft](../../data-guide/technology-choices/data-science-and-machine-learning.md)
- [Machine learning at scale](../../data-guide/big-data/machine-learning-at-scale.md)
- [Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../mlops/mlops-technical-paper.yml)
- [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
- [End-to-end manufacturing using computer vision on the edge](../../reference-architectures/ai/end-to-end-smart-factory.yml)