[Azure Machine Learning](/azure/machine-learning/) provides cloud-native tooling to train, tune, and deploy machine-learning and deep-learning models. However, some data sets can't be sent to the cloud. By using this solution, data scientists can use Machine Learning to train portable models with on-premises data and compute resources.

## Architecture

:::image type="content" alt-text="Architecture diagram of an architecture that uses components in Azure and Azure Stack for training machine learning models from on-premises data." source="media/train-machine-learning-on-premises-data-at-edge-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/train-machine-learning-models-on-premises-data-at-edge.vsdx) of this architecture.*

### Workflow

1. Deploy the Azure Stack Hub virtual machine (VM) and register it with Azure Machine Learning as a compute target.
2. Create an experiment in Machine Learning that uses the VM in Azure Stack Hub as a compute target.
3. After the model is trained, it's registered and containerized.
4. The model is ready for deployment to locations that are either on-premises or in the cloud.

### Components

This solution uses the following components:

- [Azure Machine Learning](https://azure.microsoft.com/products/machine-learning) orchestrates the training of the machine learning model.
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) stores the model that Machine Learning produces and places in a container for deployment.
- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub) provides an on-premises Azure environment to run the following components:
  - [Azure App Service](/azure-stack/operator/azure-stack-app-service-overview) provides the base for the components at the edge.
  - [VM](/azure/virtual-machines/) running [Ubuntu](https://azure.microsoft.com/ubuntu) with [Docker](https://azure.microsoft.com/products/kubernetes-service/docker) trains the machine learning model.
  - [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) stores private data.


## Scenario details

This scenario generates portable machine learning models from data that exists only on-premises. It uses a VM that runs on Azure Stack Hub. The VM is registered as a compute target in Machine Learning, which lets it access data that is only available on-premises. In this scenario, the data is stored in Blob Storage running in the on-premises environment of Azure Stack Hub.

After Machine Learning trains the model, it's registered, containerized, and added to Container Registry for deployment. For this iteration of the pattern, the VM that trains the model and runs in Azure Stack Hub must be reachable over the public internet.

### Potential use cases

An organization that has on-premises or legacy data can use this solution to support their data scientists in unlocking insights by using tools that they understand. This solution also supports scenarios in which the data for training can't be stored in the cloud due to regulations or due to the size of the data set.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider the following points when deciding how to implement this solution.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Ensure that the training scripts and Azure Stack Hub VM have access to the on-premises data that's used for training.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution lets Machine Learning access possibly sensitive on-premises data. Ensure that the account that connects via secure shell (SSH) to the Azure Stack Hub VM has a strong password and that training scripts don't preserve or upload data to the cloud.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), which preconfigures all Azure services.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Ensure that models and experiments are appropriately registered, versioned, and tagged to avoid confusion during deployment of the model.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

To enable this solution to scale, you'll need to create an appropriately sized VM on Azure Stack Hub for training.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Ronmia Bess](https://www.linkedin.com/in/ronmia-bess-8715625) | Content Developer 2

Other contributors:

 - [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*


## Next steps

- [Deploy an Edge Training Solution](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/edge-training). When you're ready to test the example solution, continue with this deployment guide.
- [Azure Machine Learning documentation](/azure/machine-learning) provides an overview of machine learning and related topics.
- [Azure Container Registry documentation](/azure/container-registry/) describes how to build, store, and manage images for container deployments.
- [Azure App Service and Azure Functions on Azure Stack Hub overview](/azure-stack/operator/azure-stack-app-service-overview) describes the resource provider and how to deploy it.
- [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations) describes best practices and how to get your questions answered.
- [Azure Stack documentation](/azure-stack) provides an overview of the entire portfolio of Azure Stack products and solutions.


## Related resources

- [AI at the edge with Azure Stack Hub](../../solution-ideas/articles/ai-at-the-edge.yml)
- [Disconnected AI at the edge with Azure Stack Hub](../../solution-ideas/articles/ai-at-the-edge-disconnected.yml)
- [Tiered data for analytics](../../example-scenario/hybrid/hybrid-tiered-data-analytics.yml)
- [Disaster recovery for Azure Stack Hub virtual machines](../../hybrid/azure-stack-vm-disaster-recovery.yml)
- [Run containers in a hybrid environment](../../hybrid/hybrid-containers.yml)
