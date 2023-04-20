[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for using edge AI when you're disconnected from the internet. The solution also uses Azure Stack Hub to move AI models to the edge.

## Architecture

:::image type="content" source="../media/ai-at-the-edge-disconnected.png" alt-text="Architecture diagram that shows an AI-enabled application running at the edge with Azure Stack Hub and hybrid connectivity." lightbox="../media/ai-at-the-edge-disconnected.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ai-at-the-edge-disconnected.vsdx) of this architecture.*

### Dataflow

1. Data scientists use Azure Machine Learning and an HDInsight cluster to train a machine learning model. The model is containerized and put into Azure Container Registry.
1. The model is deployed to an Azure Kubernetes Service (AKS) cluster on Azure Stack Hub.
1. End users provide data that's scored against the model.
1. Insights and anomalies from scoring are placed into storage for upload later.
1. Globally relevant and compliant insights are available in the global app.
1. Data scientists use scoring from the edge to improve the model.

### Components

* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud-based environment that you can use to build, deploy, and manage  machine learning models. With these models, you can forecast future behavior, outcomes, and trends.
* [HDInsight](https://azure.microsoft.com/services/hdinsight) is a managed, full-spectrum, open-source analytics service in the cloud for enterprises. You can use open-source frameworks with Azure HDInsight, such as Hadoop, Spark, HBase, and Storm.
* [Container Registry](https://azure.microsoft.com/services/container-registry) is a service that creates a managed registry of container images. You can use Container Registry to build, store, and manage the images. You can also use it to store containerized machine learning models.
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): Simplify the deployment, management, and operations of Kubernetes
* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines): Provision Windows and Linux virtual machines in seconds
* [Storage](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries

## Scenario details

With the Azure AI tools, edge, and cloud platform, edge intelligence is possible. AI-enabled hybrid applications can run where your data lives, on-premises. With [Azure Stack Hub](/azure-stack/operator/azure-stack-overview), bring a trained AI model to the edge and integrate it with your applications for low-latency intelligence, with no tool or process changes for local applications. With Azure Stack Hub, you can ensure that your cloud solutions work even when disconnected from the internet.

This solution idea shows a disconnected Stack Hub scenario. Issues of latency, intermittent connectivity, or regulations might not always allow for connectivity to Azure. In the disconnected scenario, data is processed locally and later aggregated in Azure for further analytics. For the connected version of this scenario, see the article [AI at the edge](./ai-at-the-edge.yml).

### Potential use cases

You might need to deploy as disconnected if you have the following concerns or considerations:

* You have security or other restrictions that require you to deploy Azure Stack Hub in an environment that isn't connected to the internet.
* You want to block data (including usage data) from being sent to Azure.
* You want to use Azure Stack Hub purely as a private cloud solution that's deployed to your corporate intranet, and aren't interested in hybrid scenarios.

## Next steps

* Want to learn more? Check out the related module [Introduction to Azure Stack](/training/modules/intro-to-azure-stack)
* Get Microsoft Certified for Azure Stack Hub with the [Azure Stack Hub Operator Associate](/certifications/azure-stack-hub-operator) certification
* How to [install the AKS Engine on Linux in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux)
* How to [install the AKS Engine on Windows in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows)
* Deploy your ML models to an edge device with [Azure Stack Edge devices](https://azure.microsoft.com/products/azure-stack/edge/#devices)
* Innovate further and deploy [Azure Cognitive Services (Speech, Language, Decision, Vision) containers to Azure Stack Hub](/azure-stack/user/azure-stack-solution-template-cognitive-services)

See the following product documentation for more information:

* [App Service documentation](/azure/app-service)
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning/service)
* [Azure Stack Hub documentation](/azure/azure-stack/user/azure-stack-solution-machine-learning)
* [Azure Stack Hub Deployment Options](/azure-stack/operator/azure-stack-overview#deployment-options)
* [Container Registry documentation](/azure/container-registry)
* [HDInsight documentation](/azure/hdinsight)
* [Storage documentation](/azure/storage)
* [Virtual Machines documentation](/azure/virtual-machines/workloads/sap/get-started)
* [Azure hybrid and multicloud patterns and solutions documentation](/hybrid/app-solutions)

See the following samples to interact with related solutions:

* [AKS Engine on Azure Stack Hub (on GitHub)](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md)
* [Azure Samples - Edge Intelligence on Azure Stack Hub (on GitHub)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
* [Azure Samples -Azure Stack Hub Foundation (on GitHub)](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core)

## Related resources

See the following related architectures:

* [AI at the edge with Azure Stack Hub](/azure/architecture/solution-ideas/articles/ai-at-the-edge)
* [AI-based footfall detection](/azure/architecture/solution-ideas/articles/hybrid-footfall-detection)
* [Deploy AI and machine learning computing on-premises and to the edge](/azure/architecture/hybrid/deploy-ai-ml-azure-stack-edge)
* [Azure public multi-access edge compute deployment](/azure/architecture/example-scenario/hybrid/public-multi-access-edge-compute-deployment)
* [Choose a bare-metal Kubernetes at the edge platform option](/azure/architecture/operator-guides/aks/choose-bare-metal-kubernetes)
