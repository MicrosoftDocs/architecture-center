This reference architecture illustrates how to use [Azure Stack Edge][azure-stack-edge] to extend rapid machine learning inference from the cloud to on-premises or edge scenarios. Azure Stack Hub delivers Azure capabilities such as compute, storage, networking, and hardware-accelerated machine learning to any edge location.

## Architecture

:::image type="content" border="false" source="./images/deploy-ai-ml-azure-stack-edge.svg" alt-text="Architecture diagram: on-premises data training a model in Azure Machine Learning, with model deployed back to the edge for inference" lightbox="./images/deploy-ai-ml-azure-stack-edge.svg":::

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

The architecture consists of the following steps:

- **[Azure Machine Learning][azure-machine-learning]**. Machine Learning lets you build, train, deploy, and manage machine learning models in a cloud-based environment. These models can then deploy to Azure services, including (but not limited to) Azure Container Instances, Azure Kubernetes Service (AKS), and Azure Functions.
- **[Azure Container Registry][azure-container-registry]**. Container Registry is a service that creates and manages the Docker Registry. Container Registry builds, stores, and manages Docker container images and can store containerized machine learning models.
- **[Azure Stack Edge][azure-stack-edge]**. Azure Stack Edge is an edge computing device that's designed for machine learning inference at the edge. Data is preprocessed at the edge before transfer to Azure. Azure Stack Edge includes compute acceleration hardware that's designed to improve performance of AI inference at the edge.
- **Local data**. Local data references any data that's used in the training of the machine learning model. The data can be in any local storage solution, including Azure Arc deployments.

### Components

- [Azure Machine Learning](https://azure.microsoft.com/free/machine-learning)
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry)
- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) 
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)

## Scenario details

### Potential use cases

This solution is ideal for the telecommunications industry. Typical uses for extending inference include when you need to:

- Run local, rapid machine learning inference against data as it's ingested and you have a significant on-premises hardware footprint.
- Create long-term research solutions where existing on-premises data is cleaned and used to generate a model. The model is then used both on-premises and in the cloud; it's retrained regularly as new data arrives.
- Build software applications that need to make inferences about users, both at a physical location and online.

## Recommendations

### Ingesting, transforming, and transferring data stored locally

Azure Stack Edge can transform data sourced from local storage before transferring that data to Azure. This transformation is done by an [Azure IoT Edge][azure-iot-edge] device that's deployed on the Azure Stack Edge device. These IoT Edge devices are associated with an [Azure IoT Hub][azure-iot-hub] resource on the Azure cloud platform.

Each IoT Edge module is a Docker container that does a specific task in an ingest, transform, and transfer workflow. For example, an IoT Edge module can collect data from an Azure Stack Edge local share and transform the data into a format that's ready for machine learning. Then, the module transfers the transformed data to an Azure Stack Edge cloud share. You can [add custom or built-in modules to your IoT Edge device][azure-stack-edge-modules-add] or [develop custom IoT Edge modules][azure-stack-edge-modules-add-custom]..

> [!NOTE]
> IoT Edge modules are registered as Docker container images in Container Registry.

In the Azure Stack Edge resource on the Azure cloud platform, the cloud share is backed by an Azure Blob storage account resource. All data in the cloud share will automatically upload to the associated storage account. You can [verify the data transformation and transfer][azure-stack-edge-transfer-verify] by either mounting the local or cloud share, or by traversing the Azure Storage account.

### Training and deploying a model

After preparing and storing data in Blob storage, you can [create a Machine Learning dataset][azure-machine-learning-datasets-create] that connects to Azure Storage. A dataset represents a single copy of your data in storage that's directly referenced by Machine Learning.

You can use the [Machine Learning command-line interface (CLI)][azure-machine-learning-cli], the [R SDK][azure-machine-learning-sdk-r], the [Python SDK][azure-machine-learning-sdk-python], [designer][azure-machine-learning-designer], or [Visual Studio Code][visual-studio-code] to build the scripts that are required to train your model.

After training and readying the model to deploy, you can deploy it to various Azure services, including but not limited to:

- **[Azure Container Registry][azure-container-registry]**. You can deploy the models to a private Docker Registry such as Azure Container Registry since they are Docker container images.
- **[Azure Container Instances][azure-container-instances]**. You can [deploy the model's Docker container image][azure-machine-learning-deploy-model-aci] directly to a container group.
- **[Azure Kubernetes Service][azure-kubernetes-service]**. You can use Azure Kubernetes Service to [automatically scale the model's Docker container image][azure-machine-learning-deploy-model-aks] for high-scale production deployments.
- **[Azure Functions][azure-functions]**. You can [package a model to run directly on a Functions][azure-machine-learning-deploy-model-functions] instance.
- **[Azure Machine Learning][azure-machine-learning]**. You can use [Compute instances][azure-machine-learning-compute-instance], managed cloud-based development workstations, for both training and inference of models. You can also similarly deploy the model to on-premises [IoT Edge][azure-iot-edge] and [Azure Stack Edge][azure-stack-edge] devices.

> [!NOTE]
> For this reference architecture, the model deploys to Azure Stack Edge to make the model available for inference on-premises. The model also deploys to Container Registry to ensure that the model is available for inference across the widest variety of Azure services.

### Inference with a newly deployed model

Azure Stack Edge can quickly [run machine learning models locally][azure-stack-edge-compute] against data on-premises by using its built-in compute acceleration hardware. This computation occurs entirely at the edge. The result is rapid insights from data by using hardware that's closer to the data source than a public cloud region.

Additionally, Azure Stack Edge continues to transfer data to Machine Learning for [continuous retraining and improvement by using a machine learning pipeline][azure-machine-learning-pipelines] that's associated with the model that's already running against data stored locally.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

- Consider placing your Azure Stack Edge resource in the same Azure region as other Azure services that will access it. To optimize upload performance, consider placing your Azure Blob storage account in the region where your appliance has the best network connection.
- Consider [Azure ExpressRoute][azure-expressroute] for a stable, redundant connection between your device and Azure.

### Manageability

- Administrators can verify that the data source from local storage has transferred to the Azure Stack Edge resource correctly. They can verify by mounting the Server Message Block (SMB)/Network File System (NFS) file share or connecting to the associated Blob storage account by using [Azure Storage Explorer][azure-storage-explorer].
- Use [Machine Learning datasets][azure-machine-learning-datasets] to reference your data in Blob storage while training your model. Referencing storage eliminates the need to embed secrets, data paths, or connection strings in your training scripts.
- In your Machine Learning workspace, [register and track ML models][azure-machine-learning-register-model] to track differences between your models at different points in time. You can similarly mirror the versioning and tracking metadata in the tags that you use for the Docker container images that deploy to Container Registry.

### DevOps

- Review the [MLOps][azure-machine-learning-mlops] lifecycle management approach for Machine Learning. For example, use GitHub or Azure Pipelines to create a continuous integration process that automatically trains and retrains a model. Training can be triggered either when new data populates the dataset or a change is made to the training scripts.
- The Azure Machine Learning workspace will automatically register and manage Docker container images for machine learning models and IoT Edge modules.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- [Azure Stack Edge pricing][azure-stack-edge-pricing] is calculated as a flat-rate monthly subscription with a one-time shipping fee.
- Azure Machine Learning also deploys Container Registry, Azure Storage, and Azure Key Vault services, which incur extra costs. For more information, see [How Azure Machine Learning works: Architecture and concepts][azure-machine-learning-architecture].
- [Azure Machine Learning pricing][azure-machine-learning-pricing] includes charges for the virtual machines that are used for training the model in the public cloud.

## Next steps

Product documentation

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure Container Registry][azure-container-registry]
- [Azure Stack Edge][azure-stack-edge]

Microsoft Learn modules:

- [Get started with AI on Azure](/training/modules/get-started-ai-fundamentals)
- [Work with data in Azure Machine Learning](/training/modules/work-with-data-in-aml)

## Related resources

 - [Distributed training of deep learning models on Azure](../reference-architectures/ai/training-deep-learning.yml)
 - [Build an enterprise-grade conversational bot](../reference-architectures/ai/conversational-bot.yml)
 - [Image classification on Azure](../example-scenario/ai/intelligent-apps-image-processing.yml)

[architectural-diagram]: ./images/deploy-ai-ml-azure-stack-edge.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/deploy-ai-ml-azure-stack-edge.vsdx
[azure-container-instances]: /azure/container-instances/
[azure-container-registry]: /azure/container-registry/
[azure-expressroute]: /azure/expressroute/
[azure-functions]: /azure/azure-functions/
[azure-iot-edge]: /azure/iot-edge/
[azure-iot-hub]: /azure/iot-hub/
[azure-kubernetes-service]: /azure/aks/
[azure-machine-learning]: /azure/machine-learning/
[azure-machine-learning-cli]: /azure/machine-learning/reference-azure-machine-learning-cli
[azure-machine-learning-architecture]: /azure/machine-learning/concept-azure-machine-learning-architecture
[azure-machine-learning-compute-instance]: /azure/machine-learning/concept-compute-instance
[azure-machine-learning-datasets-create]: /azure/machine-learning/how-to-access-data
[azure-machine-learning-datasets]: /azure/machine-learning/how-to-create-register-datasets
[azure-machine-learning-deploy-model-aci]: /azure/machine-learning/how-to-deploy-azure-container-instance
[azure-machine-learning-deploy-model-aks]: /azure/machine-learning/how-to-deploy-azure-kubernetes-service
[azure-machine-learning-deploy-model-functions]: /azure/machine-learning/how-to-deploy-functions
[azure-machine-learning-designer]: /azure/machine-learning/concept-designer
[azure-machine-learning-mlops]: /azure/machine-learning/concept-model-management-and-deployment
[azure-machine-learning-pipelines]: /azure/machine-learning/concept-ml-pipelines
[azure-machine-learning-pricing]: https://azure.microsoft.com/pricing/details/machine-learning/
[azure-machine-learning-register-model]: /azure/machine-learning/concept-model-management-and-deployment#register-and-track-ml-models
[azure-machine-learning-sdk-python]: /python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true
[azure-machine-learning-sdk-r]: https://azure.github.io/azureml-sdk-for-r/reference/index.html
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
[azure-stack-edge]: /azure/databox-online/
[azure-stack-edge-compute]: /azure/machine-learning/how-to-deploy-fpga-web-service#deploy-to-a-local-edge-server
[azure-stack-edge-modules-add]: /azure/databox-online/azure-stack-edge-deploy-configure-compute-advanced#add-a-module
[azure-stack-edge-modules-add-custom]: /azure/databox-online/azure-stack-edge-create-iot-edge-module
[azure-stack-edge-pricing]: https://azure.microsoft.com/pricing/details/azure-stack/edge/
[azure-stack-edge-transfer-verify]: /azure/databox-online/azure-stack-edge-deploy-configure-compute#verify-data-transform-and-transfer
[azure-storage-explorer]: https://azure.microsoft.com/features/storage-explorer/
[visual-studio-code]: https://code.visualstudio.com
