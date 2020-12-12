


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Training of models using large datasets is a complex and resource intensive task. Use familiar tools such as TensorFlow and Kubeflow to simplify training of Machine Learning models. Your ML models will run in AKS clusters backed by GPU enabled VMs.

## Architecture

![Architecture diagram](../media/machine-learning-with-aks.png)
*Download an [SVG](../media/machine-learning-with-aks.svg) of this architecture.*

## Data Flow

1. Package ML model into a container and publish to ACR
1. Azure Blob storage hosts training data sets and trained model
1. Use Kubeflow to deploy training job to AKS, distributed training job to AKS includes Parameter servers and Worker nodes
1. Serve production model using Kubeflow, promoting a consistent environment across test, control and production
1. AKS supports GPU enabled VM
1. Developer can build features querying the model running in AKS cluster
