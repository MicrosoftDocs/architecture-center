


This reference architecture illustrates how to use Microsoft Azure Stack Edge to extend the ability to perform rapid machine learning inferencing from the cloud to on-premises or edge scenarios.

![The diagram illustrates Azure Stack Edge sending data to Azure Machine Learning to train a model that is deployed to Azure Stack Edge and Azure Container Registry to make inferences against sampled data.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Performing local, rapid machine learning inference against data as it’s ingested by organizations with a significant on-premises hardware footprint .
- Creating long-term research solutions where existing on-premises data is cleaned and used to generate a model. The model is then used both on-premises and in the cloud; it's retrained regularly as new data arrives.
- Building software applications that need to make inferences about users, both at a physical location and online.

## Architecture

The architecture consists of the following components:

- **[Azure Machine Learning][azure-machine-learning]**. Machine Learning is a technology that lets you build, train, deploy, and manage machine learning models in a cloud-based environment. These models can then deploy to various Azure services, including (but not limited to) Azure Container Instances, Azure Kubernetes Service (AKS), and Azure Functions.
- **[Azure Container Registry][azure-container-registry]**. Container Registry is a service that creates and manages the Docker Registry. Container Registry builds, stores, and manages Docker container images and can store containerized machine learning models.
- **[Azure Stack Edge][azure-stack-edge]**. Azure Stack Edge is an edge computing device that's designed to perform machine learning inferencing at the edge and preprocess data before transferring it to Azure. Azure Stack Edge includes compute acceleration hardware that's designed to improve performance of any AI inferencing that occurs at the edge.
- **Local data**. Local data references any data that's used in the training of the machine learning model. The data can reside in any local storage solution, including Azure Arc deployments.

## Recommendations

### Ingesting, transforming, and transferring data stored locally

Azure Stack Edge can transform data sourced from local storage before transferring that data to Azure. This transformation is performed by using an [Azure IoT Edge][azure-iot-edge] device that's deployed on the Azure Stack Edge device. These IoT Edge devices are associated with an [Azure IoT Hub][azure-iot-hub] resource on the Azure cloud platform.

Each IoT Edge module is a Docker container that performs a specific task in an ingest, transform, and transfer workflow. For example, an IoT Edge module can collect data from an Azure Stack Edge local share, transform the data into a format that's ready for machine learning, and then transfer the transformed data to an Azure Stack Edge cloud share. You can [add custom or built-in modules to your IoT Edge device][azure-stack-edge-modules-add]; you can also [develop custom IoT Edge modules][azure-stack-edge-modules-add-custom] to use in Azure Stack Edge.

> [!NOTE]
> IoT Edge modules are registered as Docker container images in Container Registry.

In the Azure Stack Edge resource on the Azure cloud platform, the cloud share is backed by an Azure Blob storage account resource. All data in the cloud share will automatically upload to the associated storage account. You can [verify the data transformation and transfer][azure-stack-edge-transfer-verify] by either mounting the local or cloud share, or by traversing the Azure Storage account.

### Training and deploying a model

After preparing and storing data in Blob storage, you can [create a Machine Learning dataset][azure-machine-learning-datasets-create] that connects to Azure Storage. Creating a dataset ensures that you only keep a single copy of your data in storage that's directly referenced by Machine Learning.

You can use the [Machine Learning command-line interface (CLI)][azure-machine-learning-cli], the [R SDK][azure-machine-learning-sdk-r], the [Python SDK][azure-machine-learning-sdk-python], [designer][azure-machine-learning-designer], or [Visual Studio Code][visual-studio-code] to build the scripts that are required to train your model.

After training and readying the model to deploy, you can deploy it to a variety of Azure services, including but not limited to:

- **[Azure Container Registry][azure-container-registry]**. You can deploy the models to a private Docker Registry such as Azure Container Registry since they are Docker container images.
- **[Azure Container Instances][azure-container-instances]**. You can [deploy the model's Docker container image][azure-machine-learning-deploy-model-aci] directly to a container group.
- **[Azure Kubernetes Services][azure-kubernetes-service]**. You can use Azure Kubernetes Services to [automatically scale the model's Docker container image][azure-machine-learning-deploy-model-aks] for high-scale production deployments.
- **[Azure Functions][azure-functions]**. You can [package a model to run directly on a Functions][azure-machine-learning-deploy-model-functions] instance.
- **[Azure Machine Learning][azure-machine-learning]**. You can use [Compute instances][azure-machine-learning-compute-instance]; managed cloud-based development workstations, for both training and inferencing of models. You can also similarly deploy the model to on-premises [IoT Edge][azure-iot-edge] and [Azure Stack Edge][azure-stack-edge] devices.

> [!NOTE]
> For this reference architecture, the model deploys to Azure Stack Edge to make the model available for inferencing on-premises. The model also deploys to Container Registry to ensure that the model is available for inferencing across the widest variety of Azure services.

### Inferencing the newly deployed model

Azure Stack Edge can [run machine learning models locally][azure-stack-edge-compute] against data in your on-premises location quickly by using its built-in compute acceleration hardware. This computation is performed entirely at the edge and can be a way to get rapid insights from data by using hardware that's closer to the data source than a public cloud region.

Additionally, data can continue to transfer from Azure Stack Edge to Machine Learning for [continuous retraining and improvement by using a machine learning pipeline][azure-machine-learning-pipelines] that's associated with the model that's already running against data stored locally.

## Availability considerations

- Consider placing your Azure Stack Edge resource in the same Azure region where you will want to access it from other Azure services. To optimize upload performance, consider placing your Azure Blob storage account in the region where your appliance has the best network connection.
- Consider [Azure ExpressRoute][azure-expressroute] for a stable, redundant connection between your device and Azure.

## Manageability considerations

- As an administrator, you can verify that the data source from local storage has transferred to the Azure Stack Edge resource correctly by mounting the Server Message Block (SMB)/Network File System (NFS) file share or connecting to the associated Blob storage account by using [Azure Storage Explorer][azure-storage-explorer].
- Use [Machine Learning datasets][azure-machine-learning-datasets] to reference your data in Blob storage while training your model. This eliminates the need to embed secrets, data paths, or connection strings in your training scripts.
- In your **Azure Machine Learning** workspace, [register version models][azure-machine-learning-register-model] so that you can easily keep track of the differences between your models at different points in time. You can similarly mirror the versioning and tracking metadata in the tags that you use for the Docker container images that deploy to Container Registry.

## DevOps considerations

- Review the [MLOps][azure-machine-learning-mlops] lifecycle management approach for Machine Learning. For example, you can use GitHub or Azure Pipelines to create a continuous integration process to automatically train and retrain a model either when new data populates the dataset or a change is made to the training scripts.
- The **Azure Machine Learning** workspace will automatically register and manage Docker container images for machine learning models and IoT Edge modules.

## Cost considerations

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- [Azure Stack Edge pricing][azure-stack-edge-pricing] is calculated as a flat-rate monthly subscription with a one-time shipping fee.
- Azure Machine Learning also deploys Container Registry, Blob storage, and Azure Key Vault services, which incur additional costs.
- [Azure Machine Learning pricing][azure-machine-learning-pricing] includes charges for the virtual machines that are used for training the model in the public cloud.

[architectural-diagram]: ./images/deploy-ai-ml-azure-stack-edge.png
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