


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

With the Azure AI tools, edge, and cloud platform, edge intelligence is possible. The next generation of AI-enabled hybrid applications can run where your data lives. With Azure Stack Hub, bring a trained AI model to the edge, integrate it with your applications for low-latency intelligence, and continuously feedback into a refined AI model for improved accuracy, with no tool or process changes for local applications.

## Architecture

![Architecture diagram](../media/ai-at-the-edge.png)
*Download an [SVG](../media/ai-at-the-edge.svg) of this architecture.*

## Data flow

1. Data scientists train a model using Azure Machine Learning workbench and an HDInsight cluster. The model is containerized and put into an Azure Container Registry.
1. The model is deployed to a Kubernetes cluster on Azure Stack Hub.
1. End users provide data that's scored against the model.
1. Insights and anomalies from scoring are placed into a queue.
1. A function sends compliant data and anomalies to Azure Storage.
1. Globally relevant and compliant insights are available in the global app.
1. Data from edge scoring is used to improve the model.
1. (feedback loop) The model re-training can be triggered by schedule. The data scientists works on the optimization. The improved model is deployed and containerized as an update to the container registry.

## Components

Key technologies used to implement this architecture:

* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Build, deploy, and manage predictive analytics solutions
* [HDInsight](https://azure.microsoft.com/services/hdinsight): Provision cloud Hadoop, Spark, R Server, HBase, and Storm clusters
* [Container Registry](https://azure.microsoft.com/services/container-registry): Store and manage container images across all types of Azure deployments
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): Simplify the deployment, management, and operations of Kubernetes
* [Storage](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries
* [Azure Functions](https://azure.microsoft.com/services/functions/): Event-driven serverless compute unit for on-demand tasks running without the needs of maintaining the computing server
* [App Service](/azure/app-service/overview): Path that captures end user feedback data to enable model optimization

## Next steps

* Want to learn more? Check out the related Learn pathway: [Microsoft Learn Azure Stack Module](/learn/modules/intro-to-azure-stack/)
* Get Microsoft Certified for Azure Stack Hub with the [Azure Stack Hub Operator Associate](/learn/certifications/azure-stack-hub-operator/) certification
* How to [install the AKS Engine on Linux in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux)
* How to [install the AKS Engine on Windows in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows)
* Deploy your ML models to an Edge device with [Azure Stack Edge Devices](https://azure.microsoft.com/products/azure-stack/edge/#devices)
* Innovate further and deploy [Azure Cognitive Services (Speech, Language, Decision, Vision) containers to Azure Stack Hub](/azure-stack/user/azure-stack-solution-template-cognitive-services/)

## Related resources

* [App Service documentation](/azure/app-service/)
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning/service)
* [Azure Stack Hub documentation](/azure/azure-stack/user/azure-stack-solution-machine-learning)
* [Azure Stack Hub Deployment Options](/azure/azure-stack/operator/azure-stack-overview)
* [Container Registry documentation](/azure/container-registry)
* [HDInsight documentation](/azure/hdinsight)
* [Storage documentation](/azure/storage)
* [AKS Engine on Azure Stack Hub (on GitHub)](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md)
* [Azure Samples - Edge Intelligence on Azure Stack Hub (on GitHub)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
* [Azure Samples -Azure Stack Hub Foundation (on GitHub)](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core)
