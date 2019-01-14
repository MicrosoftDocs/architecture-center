---
title: Distributed training of deep learning models on Azure
description:  This reference architecture shows how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs using Azure Batch AI.
author: njray
ms.date: 01/14/19
ms.custom: azcat-ai
---

# Distributed training of deep learning models on Azure

This reference architecture shows how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs. The scenario is image classification, but the solution can be generalized for other deep learning scenarios such as segmentation and object detection. [Deploy this solution][github].

![Architecture for distributed deep learning][0]

**Scenario**: Image classification is a widely applied technique in computer vision applications and is often tackled by training a convolutional neural network (CNN). For particularly large models with large datasets, the training process can take weeks or months on a single GPU. In some situations, the models are so large that it isn’t possible to fit reasonable batch sizes onto the GPU. Using distributed training in these situations helps shorten the training time.

In this specific scenario, a [ResNet50 CNN model][resnet] is trained using [Horovod][horovod] on the [Imagenet dataset][imagenet] as well as on synthetic data. The [tutorial][tutorial] demonstrates how to accomplish this using three of the most popular deep learning frameworks: TensorFlow, Keras, and PyTorch.

There are number of ways to train a deep learning model in a distributed fashion, including data parallel and model parallel approaches based on synchronous and asynchronous updates. Currently the most common scenario is data parallel with synchronous updates—it’s the easiest to implement and sufficient for the majority of use cases.

In data parallel distributed training with synchronous updates, the model is replicated across *n* hardware devices, and a mini-batch of training samples is divided into *n* micro-batches (see Figure 2). Each device performs the forward and backward pass for a micro-batch. When it finishes the process, it shares the updates with the other devices. These are then used to calculate the updated weights of the entire mini-batch, and then the weights are synchronized across the models. This scenario is covered in the [GitHub][github] repository.

![Data parallel distributed training][1]

This architecture can also be used for model parallel and asynchronous updates. In model parallel distributed training, the model is divided across *n* hardware devices, with each device holding a part of the model. In the simplest implementation, each device may hold a layer of the network, and information is passed between devices during the forward and backwards pass. Larger neural networks can be trained this way but at the cost of performance, since devices are constantly waiting for each other to complete either the forward or backwards pass. Some advanced techniques try to partially alleviate this issue using synthetic gradients.

For deploying deep learning models once trained, see the [real-time scoring][real-time-scoring] and [batch scoring][batch-scoring] reference architectures on Azure.

The steps for training are:

1. Create scripts that will run on the cluster and train your model, then transfer them to file storage.

1. Write the data to Blob Storage.

1. Create a Batch AI file server and download the data from Blob Storage onto it.

1. Create the Docker containers for each deep learning framework and transfer them to a container registry (Docker Hub).

1. Create a Batch AI pool that will also mount the Batch AI file server.

1. Submit jobs. Each pulls in the appropriate Docker image and scripts.

1. Once the job is completed, write all the results to Files storage.

## Architecture

This architecture consists of the following components.

### Compute

[Azure Batch AI][batch-ai] plays the central role in this architecture by scaling resources up and down according to need. Batch AI is a service that helps provision and manage clusters of VMs, schedule jobs, gather results, scale resources, handle failures, and create appropriate storage. It supports GPU-enabled VMs for deep learning workloads and it provides a Python SDK as well as a command-line interface (CLI).

> [!NOTE]
> The Azure Batch AI service is retiring March 2019, and its at-scale training and scoring capabilities are now available in [Azure Machine Learning Service][amls]. This reference architecture will be updated soon to take advantage of Machine Learning, which offers a managed compute target called [Azure Machine Learning Compute][aml-compute] for training, deploying, and scoring machine learning models.

Azure [Blob storage][azure-blob] is used to store all the data initially. Later, this data is downloaded to a Batch AI file server. Batch AI uses the blobfuse adapter to mount Blob storage.

[Azure Files][files] is used to store the scripts, logs, and the final results from the training. File storage works well for storing logs and scripts, but it is not as performant as Blob Storage so should not be used for data-intensive tasks.

[Batch AI file server][batch-ai-files] is a single-node NFS share used in this architecture to store the training data. Batch AI creates an NFS share and mounts it on the cluster. Batch AI file servers are the recommended way to serve data to the cluster with the necessary throughput.

[Docker Hub][docker] is used to store the Docker image that Batch AI uses to run the training. Docker Hub was chosen for this architecture because it's easy to use and is the default image repository for Docker users. [Azure Container Registry][acr] can also be used.

## Performance considerations

Azure provides four [GPU-enabled VM types][gpu] suitable for training deep learning models. They range in price and speed from low to high as follows:

| **Azure VM series** | **NVIDIA GPU** |
|---------------------|----------------|
| NC                  | K80            |
| ND                  | P40            |
| NCv2                | P100           |
| NCv3                | V100           |

It is recommended that you scale up your training before scaling out, so it is best to try a single V100 before trying a cluster of K80s. The following figure shows the performance differences for different GPU types based on [benchmarking tests][benchmark] carried out using TensorFlow and Horovod on Batch AI.

![Throughput results for TensorFlow models on GPU clusters][2]

*Throughput of 32 GPU clusters across various models, on different GPU types and MPI versions. Models were implemented in TensorFlow 1.9*

Whenever running distributed training, use the configurations with InfiniBand. Each VM series shown in the table above includes a configuration with InfiniBand for faster communication between nodes. InfiniBand also increases the scaling efficiency of the training for the frameworks that can take advantage of it. For details, see the Infiniband [benchmark comparison][benchmark].

Batch AI is able to mount Blob storage using the [blobfuse][blobfuse] adapter, but it is not recommended to use Blob Storage this way for distributed training as Blob Storage performance isn’t good enough to handle the necessary throughput.

## Scalability considerations

The scaling efficiency of distributed training is always less than 100 percent because of the network overhead—syncing the entire model between devices becomes a bottleneck. Therefore, distributed training is most suited for large models that cannot be trained using a reasonable batch size on a single GPU, or for problems that cannot be addressed by distributing the model in a simple, parallel way.

Distributed training is not the recommended method for running hyperparameter searches. The scaling efficiency affects performance and makes a distributed approach less efficient than training multiple model configurations separately.

One way to increase scaling efficiency is to increase the batch size but this must be done carefully as increasing the batch size without adjusting the other parameters can detrimentally affect the model’s final performance.

## Storage considerations

When training deep learning models, an often-overlooked aspect is where the data is stored. If the storage is too slow to keep up with the demands of the GPUs, training performance can degrade.

Batch AI supports many storage solutions. This architecture uses a Batch AI file server since it provides the best tradeoff between ease of use and performance. For the best performance, load the data locally, but this can be cumbersome since all the nodes must download the data from Blob Storage, and with the ImageNet dataset, this can take hours.

[Azure Premium Blob Storage][blob] (limited public preview) is another good option to consider. This architecture mounts an NFS share on the cluster nodes, but Premium Blob storage could be used instead. Do not mount Blob and File storage as data stores for distributed training—they are too slow and will hinder training performance.

## Security considerations

### Restrict access to Azure Blob Storage

This architecture uses [storage account keys][security-guide] to access the Blob storage. For further control and protection, consider using a shared access signature (SAS) instead. This grants limited access to objects in storage, without needing to hard-code the account keys or save them in plaintext. Using a SAS also helps to ensure that the storage account has proper governance, and that access is granted only to the people intended to have it.

For scenarios with more sensitive data, make sure that all of your storage keys are protected, because these keys grant full access to all input and output data from the workload.

### Encrypt data at rest and in motion

In scenarios that use sensitive data, encrypt the data at rest—that is, the data in storage. In addition, each time data moves from one location to the next, use SSL to secure the data transfer. For more information, see the [Azure Storage security guide][security-guide].

### Secure data in a virtual network

This reference implementation is meant for non-production use and does not configure a virtual network. However, when deploying your Batch AI cluster, you can configure your cluster to be provisioned inside a subnet of a virtual network. This allows the compute nodes in the cluster to communicate securely with other virtual machines, and even with an on-premises network. You can also use [service endpoints][endpoints] with blob storage to grant access from a virtual network or use a single-node NFS inside the virtual network with Batch AI.

## Monitoring considerations

While running your job, it's important to monitor the progress and make sure that things are working as expected. However, it can be a challenge to monitor across a cluster of active nodes.

The Batch AI file servers can be completely managed through the Azure portal or though the [Azure CLI][cli] and Python SDK. To get a sense of the overall state of the cluster, go to the **Batch AI** blade of the Azure Portal to inspect the state of the nodes in the cluster. If a node is inactive or a job has failed, the error logs are saved to blob storage, and are also accessible in the **Jobs** blade in the Azure Portal.

Enrich monitoring by connecting logs to [Azure Application Insights][ai] or by running separate processes to poll for the state of the Batch AI cluster and its jobs.

Batch AI automatically logs all stdout/stderr to the associate Blob storage account. Use a storage navigation tool such as [Azure Storage Explorer][storage-explorer] for an easier experience when navigating log files.

It is also possible to stream the logs for each job. For details about this option, see the development steps on [GitHub][github].

## Deployment

The reference implementation of this architecture is available on [GitHub][github]. Follow the steps described there to conduct distributed training of deep learning models across clusters of GPU-enabled VMs.

## Next steps

The output of the this reference deployment is a trained model that is saved to blob. You can operationalize this model for either [real-time scoring][real-time-scoring]
or [batch scoring][batch-scoring].

[0]: ./_images/distributed_dl_architecture.png
[1]: ./_images/distributed_dl_flow.png
[2]: ./_images/distributed_dl_tests.png
[acr]: /azure/container-registry/container-registry-intro
[ai]: /azure/application-insights/app-insights-overview
[aml-compute]: /azure/machine-learning/service/how-to-set-up-training-targets#amlcompute
[amls]: /azure/machine-learning/service/overview-what-is-azure-ml
[azure-blob]: /azure/storage/blobs/storage-blobs-introduction
[batch-ai]: /azure/batch-ai/overview
[batch-ai-files]: /azure/batch-ai/resource-concepts#file-server
[batch-scoring]: /azure/architecture/reference-architectures/ai/batch-scoring-deep-learning
[benchmark]: https://github.com/msalvaris/BatchAIHorovodBenchmark
[blob]: https://azure.microsoft.com/en-gb/blog/introducing-azure-premium-blob-storage-limited-public-preview/
[blobfuse]: https://github.com/Azure/azure-storage-fuse
[cli]: https://github.com/Azure/BatchAI/blob/master/documentation/using-azure-cli-20.md
[docker]: https://hub.docker.com/
[endpoints]: /azure/storage/common/storage-network-security?toc=%2fazure%2fvirtual-network%2ftoc.json#grant-access-from-a-virtual-network
[files]: /azure/storage/files/storage-files-introduction
[github]: https://github.com/Azure/DistributedDeepLearning/
[gpu]: /azure/virtual-machines/windows/sizes-gpu
[horovod]: https://github.com/uber/horovod
[imagenet]: http://www.image-net.org/
[real-time-scoring]: /azure/architecture/reference-architectures/ai/realtime-scoring-python
[resnet]: https://arxiv.org/abs/1512.03385
[security-guide]: /azure/storage/common/storage-security-guide
[storage-explorer]: /azure/vs-azure-tools-storage-manage-with-storage-explorer?tabs=windows
[tutorial]: https://github.com/Azure/DistributedDeepLearning