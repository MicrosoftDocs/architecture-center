---
title: Training of Python scikit-learn and deep learning models on Azure
description:  This reference architecture shows recommended practices for tuning the hyperparameters (training parameters) of a scikit-learn Python model.
author: fboylu
ms.date: 07/17/2019
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: azcat-ai
---

# Training of Python scikit-learn and deep learning models on Azure

This reference architecture shows recommended practices for tuning the hyperparameters (training parameters) of python models. Two scenarios are covered: hyperparameter tuning of [scikit-learn][scikit] models and deep learning models with GPUs. Two reference implementation for this architecture are available on GitHub, one for [scikit-learn][github1] models and one for [deep learning][github2] models.

![Architecture diagram][0]

## Scenarios

**Scenario 1: FAQ matching.** The problem addressed here is Frequently Asked Question (FAQ) matching. This scenario uses a subset of Stack Overflow question data that includes original questions tagged as JavaScript, their duplicate questions, and their answers. It tunes a scikit-learn pipeline to predict the probability that a duplicate question matches one of the original questions.

Processing in this [Azure Machine Learning pipeline][pipeline] scenario involves the following steps:

1. The training Python script is submitted to [Azure Machine Learning][aml].

1. The script runs in Docker containers that are created on each node.

1. That script retrieves training and testing data from [Azure Storage][storage].

1. The script trains a model from the training data using its combination of training parameters.

1. The model's performance is evaluated on the testing data, and is written to Azure Storage.

1. The best performing model is [registered][mlops] with Azure Machine Learning.

See also considerations for training [deep learning models][training-deep-learning] with GPUs.

**Scenario2: Out of stock detection.** This scenario shows how to tune an object detection Mask RCNN model that can be deployed as a web service to provide predictions for empty spaces on store shelves. Images similar to retailer store shelves filled with products are used to predict empty spaces to help detect out of stock products by potentially marrying these predictions with other sources of information such as planograms and databases. In this scenario, only empty space prediction is covered. The dataset used is distributed under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.

Processing in this scenario involves the following steps:

1. The training Python script is submitted to [Azure Machine Learning][aml].

1. The script runs in Docker containers that are created on each node by pulling a custom image that is stored on [Azure Container Registry][acr].

1. The script trains a model from the training data saved in [Azure Storage][storage]. using its combination of training parameters.

1. The model's performance is evaluated on the testing data, and is written to Azure Storage.

1. The best performing model is registered with Azure Machine Learning.

See also considerations for distributed training of [deep learning models][training-deep-learning] with GPUs.

## Architecture

This architecture consists of several Azure cloud services that scale resources according to need. The services and their roles in this solution are described below.

[Microsoft Data Science Virtual Machine][dsvm] (DSVM) is a VM image configured with tools used for data analytics and machine learning. Both Windows Server and Linux versions are available. This deployment uses the Linux editions of the DSVM on Ubuntu 16.04 LTS.

[Azure Machine Learning][aml] is used to train, deploy, automate, and manage machine learning models at cloud scale. It's used in this architecture to manage the allocation and use of the Azure resources described below.

[Azure Machine Learning Compute][aml-compute] is the resource used to train and test machine learning and AI models at scale in Azure. The [compute target][target] in this scenario is a cluster of nodes that are allocated on demand based on an automatic [scaling][scaling] option. Each node is a VM that runs a training job for a particular [hyperparameter][hyperparameter] set.

[Azure Container Registry][acr] stores images for all types of Docker container deployments. These containers are created on each node and used to run the training Python script. The image used in the Machine Learning Compute cluster is created by Machine Learning in the local run and hyperparameter tuning notebooks, and then is pushed to Container Registry.

[Azure Blob][blob] storage receives the training and test data sets from Machine Learning that are used by the training Python script. Storage is mounted as a virtual drive onto each node of a Machine Learning Compute cluster.

## Performance considerations

Each set of [hyperparameters][hyperparameter] runs on one node of the Machine Learning [compute target][target]. For scenario 1, each node is a Standard D4 v2 VM, which has four cores. This scenario uses a [LightGBM][lightgbm] classifier for machine learning, a gradient boosting framework. This software can run on all four cores at the same time, speeding up each run by a factor of up to four. That way, the whole hyperparameter tuning run takes up to one-quarter of the time it would take had it been run on a Machine Learning Compute target based on Standard D1 v2 VMs, which have only one core each. For scenario 2, each node is a Standard NC6 with 1 GPU and each hyperparameter tuning run will use the single GPU on each node.

The maximum number of Machine Learning Compute nodes affects the total run time. The recommended minimum number of nodes is zero. With this setting, the time it takes for a job to start up includes some minutes for auto-scaling at least one node into the cluster. If the hyperparameter tuning runs for a short time, however, scaling up the job adds to the overhead. For example, a job can run in under five minutes, but scaling up to one node might take another five minutes. In this case, setting the minimum to one node saves time but adds to the cost.

## Monitoring and logging considerations

Submit a [HyperDrive][hyperparameter] run configuration to return a Run object for use in monitoring the run's progress.

### RunDetails Jupyter Widget

Use the Run object with the RunDetails [Jupyter widget][jupyter] to conveniently monitor its progress at queuing and when running its children jobs. It also shows the values of the primary statistic that they log in real time.

### Azure portal

Print a Run object to display a link to the run's page in Azure portal like this:

![Run object][1]

Use this page to monitor the status of the run and its children runs. Each child run has a driver log containing the output of the training script it has run.

## Cost considerations

The cost of a hyperparameter tuning run depends linearly on the choice of Machine Learning Compute VM size, whether low-priority nodes are used, and the maximum number of nodes allowed in the cluster.

Ongoing costs when the cluster is not in use depend on the minimum number of nodes required by the cluster. With cluster autoscaling, the system automatically adds nodes up to the allowed maximum to match the number of jobs, and then removes nodes down to the requested minimum as they are no longer needed. If the cluster can autoscale down to zero nodes, it does not cost anything when it is not in use.

## Security considerations

### Restrict access to Azure Blob Storage

This architecture uses [storage account keys][storage-security] to access the Blob storage. For further control and protection, consider using a shared access signature (SAS) instead. This grants limited access to objects in storage, without needing to hard-code the account keys or save them in plaintext. Using a SAS also helps to ensure that the storage account has proper governance, and that access is granted only to the people intended to have it.

For scenarios with more sensitive data, make sure that all of your storage keys are protected, because these keys grant full access to all input and output data from the workload.

### Encrypt data at rest and in motion

In scenarios that use sensitive data, encrypt the data at rest—that is, the data in storage. Each time data moves from one location to the next, use SSL to secure the data transfer. For more information, see the [Azure Storage security guide][storage-security].

### Secure data in a virtual network

For production deployments, consider deploying the cluster into a subnet of a virtual network that you specify. This allows the compute nodes in the cluster to communicate securely with other virtual machines or with an on-premises network. You can also use [service endpoints][endpoints] with blob storage to grant access from a virtual network or use a single-node NFS inside the virtual network with Azure Machine Learning.

## Deployment

To deploy the reference implementation for this architecture, follow the steps described in the Github repos:
-  [Regular Python models][github1] 
-  [Deep learning models][github2] 

## Next steps

To operationalize the model, see [Machine learning operationalization (MLOps) for Python models using Azure Machine Learning](./mlops-python.md).

[0]: ./_images//training-python-models.png
[1]: ./_images/run-object.png
[acr]: /azure/container-registry/container-registry-intro
[ai]: /azure/application-insights/app-insights-overview
[aml]: /azure/machine-learning/service/overview-what-is-azure-ml
[aml-compute]: /azure/machine-learning/service/concept-compute-target
[amls]: /azure/machine-learning/service/overview-what-is-azure-ml
[blob]: /azure/storage/blobs/storage-blobs-introduction
[dsvm]: /azure/machine-learning/data-science-virtual-machine/overview
[endpoints]: /azure/storage/common/storage-network-security?toc=%2fazure%2fvirtual-network%2ftoc.json#grant-access-from-a-virtual-network
[github1]: https://github.com/Microsoft/MLHyperparameterTuning
[github2]: https://github.com/Microsoft/HyperdriveDeepLearning
[hyperparameter]: /azure/machine-learning/service/how-to-tune-hyperparameters
[jupyter]: http://jupyter.org/widgets
[lightgbm]: https://github.com/Microsoft/LightGBM
[mlops]: /azure/machine-learning/service/concept-model-management-and-deployment
[pipeline]: /azure/machine-learning/service/concept-ml-pipelines
[scaling]: /azure/virtual-machine-scale-sets/overview
[scikit]: https://pypi.org/project/scikit-learn/
[scikit-sample]:/azure/machine-learning/service/how-to-train-scikit-learn
[storage]: /azure/storage/common/storage-introduction
[storage-security]: /azure/storage/common/storage-security-guide
[target]: /azure/machine-learning/service/how-to-auto-train-remote
[training-deep-learning]: /azure/architecture/reference-architectures/ai/training-deep-learning
