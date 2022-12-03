Many organizations want to unlock insights from their on-premises or legacy data by using the familiar tools of their data scientists. [Azure Machine Learning](/azure/machine-learning/) provides cloud-native tooling to train, tune, and deploy machine-learning and deep-learning models. However, some data is too large send to the cloud or can't be sent to the cloud for regulatory reasons. By using this architecture, data scientists can use Azure Machine Learning to train models by using on-premises data and compute resources.

## Architecture

:::image type="content" alt-text="Diagram of an architecture that uses components in Azure and Azure Stack for training machine learning models from on-premises data." source="media/train-machine-learning-on-premises-data-architecture.png":::

This architecture uses a virtual machine (VM) running on Azure Stack Hub. The VM is registered as a compute target in Azure Machine Learning, which allows it to access data that is only available on premises. In this case, Azure Stack Hub's blob storage contains the data.

After the model is trained, it's registered with Azure Machine Learning, containerized, and added to an Azure Container Registry for deployment. For this iteration of the solution, the Azure Stack Hub training VM must be reachable over the public internet.

### Components

This solution uses the following components:

- [Azure Machine Learning](https://azure.microsoft.com/products/machine-learning/) orchestrates the training of the machine learning model.
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) stores the model that Azure Machine Learning produces and places in a container for deployment.
- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/) provides an on-premises Azure environment to run the following components:
  - [App Service](/azure-stack/operator/azure-stack-app-service-overview) provides the base for the components at the edge.
  - [Ubuntu](https://azure.microsoft.com//ubuntu/) with [Docker](https://azure.microsoft.com/products/kubernetes-service/docker/) runs in a VM to train the machine learning model.
  - [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/) can store private data.


### Workflow

1. Deploy the Azure Stack Hub VM and register it with Azure Machine Learning as a compute target.
2. Create an experiment in Machine Learning that uses the VM in Azure Stack Hub as a compute target.
3. After the model is trained, it's registered and containerized.
4. The model is ready for deployment to locations that are either on-premises or in the cloud.


## Scenario details

This scenario generates portable machine learning models from data that exists only on-premises. It uses a virtual machine (VM) running on Azure Stack Hub. The VM is registered as a compute target in Azure Machine Learning, which lets it access data that is only available on-premises. In this scenario, the data is stored in Azure Blob Storage running in the on-premises environment of Azure Stack Hub.

After Machine Learning trains the model, it's registered, containerized, and added to an Azure Container Registry for deployment. For this iteration of the pattern, the Azure Stack Hub training VM must be reachable over the public internet.

### Potential use cases

Many organizations would like to unlock insights from their on-premises or legacy data by using tools that their data scientists understand. [Azure Machine Learning](/azure/machine-learning/) provides cloud-native tooling to train, tune, and deploy machine-learning and deep-learning models.  

However, some data is too large to send to the cloud or can't be sent to the cloud for regulatory reasons. Using this pattern, data scientists can use Azure Machine Learning to train models by using on-premises data and compute.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider the following points when deciding how to implement this solution.

### Scalability

To enable this solution to scale, you'll need to create an appropriately sized VM on Azure Stack Hub for training.

### Availability

Ensure that the training scripts and Azure Stack Hub VM have access to the on-premises data that's used for training.

### Manageability

Ensure that models and experiments are appropriately registered, versioned, and tagged to avoid confusion during deployment of the model.

### Security

This architecture lets Azure Machine Learning access possibly sensitive on-premises data. Ensure that the account that connects via SSH to the Azure Stack Hub VM has a strong password and that training scripts don't preserve or upload data to the cloud.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).


## Next steps

To learn more about topics introduced in this article:

- See the [Azure Machine Learning documentation](/azure/machine-learning) for an overview of machine learning and related topics.
- See [Azure Container Registry](/azure/container-registry/) to learn how to build, store, and manage images for container deployments.
- Refer to [App Service on Azure Stack Hub](/azure-stack/operator/azure-stack-app-service-overview) to learn more about the resource provider and how to deploy.
- See [Hybrid application design considerations](/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices and to get any additional questions answered.
- See the [Azure Stack family of products and solutions](/azure-stack) to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with [Deploy an Edge Training Solution](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/edge-training). This deployment guide provides step-by-step instructions for deploying and testing its components.

## Related resources

- [AI at the edge with Azure Stack Hub](../../solution-ideas/articles/ai-at-the-edge)
- [Disconnected AI at the edge with Azure Stack Hub](../../solution-ideas/articles/ai-at-the-edge-disconnected)