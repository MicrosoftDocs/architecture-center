[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for using edge AI when you're disconnected from the internet. The solution uses Azure Stack Hub to move AI models to the edge.

*Apache®, [Apache Hadoop](https://hadoop.apache.org), [Apache Spark](http://spark.apache.org), [Apache HBase](http://hbase.apache.org), and [Apache Storm](https://storm.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/ai-at-the-edge-disconnected.png" alt-text="Architecture diagram that shows an AI-enabled application running at the edge with Azure Stack Hub and hybrid connectivity." lightbox="../media/ai-at-the-edge-disconnected.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ai-at-the-edge-disconnected.vsdx) of this architecture.*

### Dataflow

1. Data scientists use Azure Machine Learning and an Azure HDInsight cluster to train a machine learning model. The model is containerized and put into Azure Container Registry.
1. The model is deployed to an Azure Kubernetes Service (AKS) cluster on Azure Stack Hub.
1. End users provide data that's scored against the model.
1. Insights and anomalies from scoring are placed into storage for upload later.
1. Globally relevant and compliant insights are available in a global app.
1. Data scientists use scoring from the edge to improve the model.

### Components

* [Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud-based environment that you can use to build, deploy, and manage machine learning models. With these models, you can forecast future behavior, outcomes, and trends.
* [HDInsight](https://azure.microsoft.com/services/hdinsight) is a managed, full-spectrum, open-source analytics service in the cloud for enterprises. You can use open-source frameworks with HDInsight, such as Hadoop, Spark, HBase, and Storm.
* [Container Registry](https://azure.microsoft.com/services/container-registry) is a service that creates a managed registry of container images. You can use Container Registry to build, store, and manage the images. You can also use it to store containerized machine learning models.
* [AKS](https://azure.microsoft.com/services/kubernetes-service) is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications.
* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources like Windows and Linux virtual machines.
* [Azure Storage](https://azure.microsoft.com/services/storage) offers highly available, scalable, secure cloud storage for data, applications, and workloads.
* [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack) is an extension of Azure that provides a way to run apps in an on-premises environment and deliver Azure services to your datacenter.

## Scenario details

With the Azure AI tools and the Azure edge and cloud platform, edge intelligence is possible. AI-enabled hybrid applications can run where your data lives, on-premises. By using [Azure Stack Hub](/azure-stack/operator/azure-stack-overview), you can bring a trained AI model to the edge and integrate it with your applications for low-latency intelligence. With this approach, you don't need to make tool or process changes for local applications. When you use Azure Stack Hub, you can ensure that your cloud solutions work even when you're disconnected from the internet.

This solution is for a disconnected Azure Stack Hub scenario. Because of latency or intermittent connectivity issues or regulations, you might not always be connected to Azure. In disconnected scenarios, you can process data locally and aggregate it later in Azure for further analysis. For the connected version of this scenario, see [AI at the edge](./ai-at-the-edge.yml).

### Potential use cases

You might need to deploy in a disconnected state in the following scenarios:

* You have security or other restrictions that require you to deploy Azure Stack Hub in an environment that isn't connected to the internet.
* You want to block data (including usage data) from being sent to Azure.
* You want to use Azure Stack Hub purely as a private cloud solution that's deployed to your corporate intranet, and you aren't interested in hybrid scenarios.

## Next steps

For more information about Azure Stack solutions, see the following resources:

* [Training module: Introduction to Azure Stack](/training/modules/intro-to-azure-stack)
* [Microsoft Certified: Azure Stack Hub Operator Associate](/certifications/azure-stack-hub-operator) certification
* [Install the AKS engine on Linux in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux)
* [Install the AKS engine on Windows in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows)
* [Azure Stack Edge managed devices that bring Azure AI to the edge](https://azure.microsoft.com/products/azure-stack/edge/#devices)
* [Use Azure Cognitive Services containers to make Azure APIs available on-premises](/azure-stack/user/azure-stack-solution-template-cognitive-services)

For more information about solution components, see the following product documentation:

* [App Service documentation](/azure/app-service)
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning/service)
* [Azure Stack Hub documentation](/azure/azure-stack/user/azure-stack-solution-machine-learning)
* [Azure Stack Hub deployment options](/azure-stack/operator/azure-stack-overview#deployment-options)
* [Container Registry documentation](/azure/container-registry)
* [HDInsight documentation](/azure/hdinsight)
* [Storage documentation](/azure/storage)
* [Virtual Machines documentation](/azure/virtual-machines/workloads/sap/get-started)
* [Azure hybrid and multicloud patterns and solutions documentation](/hybrid/app-solutions)

For samples, see the following resources:

* [AKS engine on Azure Stack Hub (on GitHub)](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md)
* [Azure samples - edge intelligence on Azure Stack Hub (on GitHub)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
* [Azure samples - Azure Stack Hub foundation (on GitHub)](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core)

## Related resources

For related solutions, see the following articles:

* [AI at the edge with Azure Stack Hub](./ai-at-the-edge.yml)
* [AI-based footfall detection](./hybrid-footfall-detection.yml)
* [Deploy AI and machine learning computing on-premises and to the edge](../../hybrid/deploy-ai-ml-azure-stack-edge.yml)
* [Azure public multi-access edge compute deployment](../../example-scenario/hybrid/public-multi-access-edge-compute-deployment.yml)
* [Choose a bare-metal Kubernetes at the edge platform option](../../operator-guides/aks/choose-bare-metal-kubernetes.yml)
