[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows how you can bring your trained AI model to the edge with Azure Stack Hub and integrate it with your applications for low-latency intelligence.

## Architecture

:::image type="content" alt-text="Architecture diagram showing an AI -enabled application that's running at the edge with Azure Stack Hub." source="../media/ai-at-the-edge.png" lightbox="../media/ai-at-the-edge.png":::

*Download a [Visio file](https://arch-center.azureedge.net/ai-at-the-edge.vsdx) of this architecture.*

### Dataflow

1. Data is processed using Azure Data Factory, to be placed on Azure Data Lake.
1. Data from Azure Data Factory is placed into the Azure Data Lake Storage for training.
1. Data scientists train a model using Azure Machine Learning. The model is containerized and put into an Azure Container Registry.
1. The model is deployed to a Kubernetes cluster on Azure Stack Hub.
1. The on-premises web application can be used to score data that's provided by the end user, to score against the model that's deployed in the Kubernetes cluster.
1. End users provide data that's scored against the model.
1. Insights and anomalies from scoring are placed into a queue.
1. A function app gets triggered once scoring information is placed in the queue.
1. A function sends compliant data and anomalies to Azure Storage.
1. Globally relevant and compliant insights are available for consumption in Power BI and a global app.
1. Feedback loop: The model retraining can be triggered by a schedule. Data scientists work on the optimization. The improved model is deployed and containerized as an update to the container registry.

### Components

Key technologies used to implement this architecture:

* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Build, deploy, and manage predictive analytics solutions.
* [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Ingest data into Azure Data Factory.
* [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): Load data into Azure Data Lake Storage Gen2 with Azure Data Factory.
* [Container Registry](https://azure.microsoft.com/services/container-registry): Store and manage container images across all types of Azure deployments.
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): Simplify the deployment, management, and operations of Kubernetes.
* [Azure Storage](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage.
* [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries.
* [Azure Functions](https://azure.microsoft.com/services/functions): Event-driven serverless compute unit for on-demand tasks running without the needs of maintaining the computing server.
* [Azure App Service](/azure/app-service/overview): Path that captures end-user feedback data to enable model optimization.

## Scenario details

With the Azure AI tools, edge, and cloud platform, edge intelligence is possible. The next generation of AI-enabled hybrid applications can run where your data lives. With [Azure Stack Hub](/azure-stack/operator/azure-stack-overview), bring a trained AI model to the edge, integrate it with your applications for low-latency intelligence, and continuously feedback into a refined AI model for improved accuracy, with no tool or process changes for local applications. This solution idea shows a connected Stack Hub scenario, where edge applications are connected to Azure. For the disconnected-edge version of this scenario, see the article [AI at the edge - disconnected](./ai-at-the-edge-disconnected.yml).

### Potential use cases

There's a wide range of Edge AI applications that monitor and provide information in near real-time. Areas where Edge AI can help include:

* Security camera detection processes.
* Image and video analysis (the media and entertainment industry).
* Transportation and traffic (the automotive and mobility industry).
* Manufacturing.
* Energy (smart grids).

## Next steps

* Want to learn more? Check out the [Introduction to Azure Stack](/training/modules/intro-to-azure-stack/) module
* Get Microsoft Certified for Azure Stack Hub with the [Azure Stack Hub Operator Associate](/certifications/azure-stack-hub-operator/) certification
* How to [install the AKS Engine on Linux in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux)
* How to [install the AKS Engine on Windows in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows)
* Deploy your ML models to an edge device with [Azure Stack Edge Devices](https://azure.microsoft.com/products/azure-stack/edge/#devices)
* Innovate further and deploy [Azure Cognitive Services (Speech, Language, Decision, Vision) containers to Azure Stack Hub](/azure-stack/user/azure-stack-solution-template-cognitive-services)

For more information about the featured Azure services, see the following articles and samples:

* [App Service documentation](/azure/app-service)
* [Azure Data Lake Storage Gen 2](/azure/databricks/data/data-sources/azure/adls-gen2)
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning/service)
* [Azure Stack Hub documentation](/azure/azure-stack/user/azure-stack-solution-machine-learning)
* [Azure Stack Hub Deployment Options](/azure-stack/operator/azure-stack-overview#deployment-options)
* [Container Registry documentation](/azure/container-registry)
* [Storage documentation](/azure/storage)
* [AKS Engine on Azure Stack Hub (on GitHub)](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md)
* [Azure Samples - Edge Intelligence on Azure Stack Hub (on GitHub)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
* [Azure Samples -Azure Stack Hub Foundation (on GitHub)](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core)
* [Azure hybrid and multicloud patterns and solutions documentation](/hybrid/app-solutions)

## Related resources

See the following related architectures:

* [Disconnected AI at the edge with Azure Stack Hub](/azure/architecture/solution-ideas/articles/ai-at-the-edge-disconnected)
* [Machine learning in Azure IoT Edge vision AI](/azure/architecture/guide/iot-edge-vision/machine-learning)
* [Implement the Azure healthcare blueprint for AI](/azure/architecture/industries/healthcare/healthcare-ai-blueprint)
* [Deploy AI and machine learning computing on-premises and to the edge](/azure/architecture/hybrid/deploy-ai-ml-azure-stack-edge)
* [AI-based footfall detection](/azure/architecture/solution-ideas/articles/hybrid-footfall-detection)
