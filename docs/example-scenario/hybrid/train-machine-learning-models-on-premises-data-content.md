Many organizations want to unlock insights from their on-premises or legacy data by using the familiar tools of their data scientists. [Azure Machine Learning](/azure/machine-learning/) provides cloud-native tooling to train, tune, and deploy machine-learning and deep-learning models. However, some data is too large send to the cloud or can't be sent to the cloud for regulatory reasons. By using this architecture, data scientists can use Azure Machine Learning to train models by using on-premises data and compute resources.

## Architecture

:::image type="content" alt-text="Diagram of an architecture that uses components in Azure and Azure Stack for training machine learning models from on-premises data." source="media/train-machine-learning-on-premises-data-architecture.png":::

This architecture uses a virtual machine (VM) running on Azure Stack Hub. The VM is registered as a compute target in Azure Machine Learning, which allows it to access data that is only available on premises. In this case, Azure Stack Hub's blob storage contains the data.

After the model is trained, it's registered with Azure Machine Learning, containerized, and added to an Azure Container Registry for deployment. For this iteration of the solution, the Azure Stack Hub training VM must be reachable over the public internet.

### Components

This solution uses the following components:

| Layer | Component | Description |
|----------|-----------|-------------|
| Azure | Azure Machine Learning | [Azure Machine Learning](/azure/machine-learning/) orchestrates the training of the machine learning model. |
| | Azure Container Registry | Machine Learning packages the model into a container and stores it in an [Azure Container Registry](/azure/container-registry/) for deployment.|
| Azure Stack Hub | App Service | [Azure Stack Hub with App Service](/azure-stack/operator/azure-stack-app-service-overview) provides the base for the components at the edge. |
| | Compute | An Azure Stack Hub VM running Ubuntu with Docker is used to train the machine learning model. |
| | Storage | Private data can be hosted in Azure Stack Hub blob storage. |

- [Azure Machine Learning](/azure/machine-learning/) orchestrates the training of the machine learning model.
- [Azure Container Registry](/azure/container-registry/) stores the model that Azure Machine Learning produces and places in a container.
- [Azure Stack Hub with App Service](/azure-stack/operator/azure-stack-app-service-overview) provides the base for the components at the edge.
- An Azure Stack Hub VM running Ubuntu with Docker is used to train the machine learning model.
- Private data can be hosted in Azure Stack Hub blob storage.


### Workflow

1. Deploy the Azure Stack Hub VM and register it with Azure Machine Learning as a compute target.
2. Create an experiment in Machine Learning that uses the Azure Stack Hub VM as a compute target.
3. Once the model is trained, it's registered and containerized.
4. The model can now be deployed to locations that are either on-premises or in the cloud.


## Scenario details

Generate portable machine learning models from data that only exists on-premises.

The training at the edge pattern uses a virtual machine (VM) running on Azure Stack Hub. The VM is registered as a compute target in Azure Machine Learning, letting it access data only available on-premises. In this case, the data is stored in Azure Stack Hub's blob storage.

Once the model is trained, it's registered with Azure Machine Learning, containerized, and added to an Azure Container Registry for deployment. For this iteration of the pattern, the Azure Stack Hub training VM must be reachable over the public internet.

### Potential use cases

Many organizations would like to unlock insights from their on-premises or legacy data using tools that their data scientists understand. [Azure Machine Learning](/azure/machine-learning/) provides cloud-native tooling to train, tune, and deploy machine-learning and deep-learning models.  

However, some data is too large send to the cloud or can't be sent to the cloud for regulatory reasons. Using this pattern, data scientists can use Azure Machine Learning to train models using on-premises data and compute.

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

