This reference architecture shows how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs. The scenario is image classification, but the solution can be generalized to other deep learning scenarios such as segmentation or object detection.

A reference implementation for this architecture is available on [GitHub][github].

## Architecture

:::image type="content" alt-text="Architecture diagram that shows distributed deep learning." source="./_images/distributed-dl-architecture.png" lightbox="./_images/distributed-dl-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/distributed-dl-architecture.vsdx) of this architecture.*

### Workflow

This architecture consists of the following services:

**[Azure Machine Learning Compute][aml-compute]** plays the central role in this architecture by scaling resources up and down according to need. Azure Machine Learning Compute is a service that helps provision and manage clusters of VMs, schedule jobs, gather results, scale resources, and handle failures. It supports GPU-enabled VMs for deep learning workloads.

**[Standard Blob Storage][azure-blob]** is used to store the logs and results. **[Premium Blob Storage][premium-storage]** is used to store the training data and is mounted in the nodes of the training cluster by using [blobfuse][blobfuse]. The Premium tier of Blob Storage offers better performance than the Standard tier and is recommended for distributed training scenarios. When mounted by using blobfuse, during the first epoch, the training data is downloaded to the local disks of the training cluster and cached. For every subsequent epoch, the data is read from the local disks, which is the most performant option.

**[Azure Container Registry][acr]** is used to store the Docker image that Azure Machine Learning Compute uses to run the training.

### Components

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an open platform for managing the development and deployment of machine-learning models at scale. The platform supports commonly used open frameworks and offers automated featurization and algorithm selection. You can use Machine Learning to deploy models to various targets, including Azure Container Instances.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is a service that's part of [Azure Storage](https://azure.microsoft.com/products/category/storage). Blob Storage offers optimized cloud object storage for large amounts of unstructured data.
- [Container Registry](https://azure.microsoft.com/services/container-registry) is a cloud-based, private registry service. You can use Container Registry to store and manage private Docker container images and related artifacts.

## Scenario details

**Scenario:** Classifying images is a widely applied technique in computer vision, often tackled by training a convolutional neural network (CNN). For particularly large models with large datasets, the training process can take weeks or months on a single GPU. In some situations, the models are so large that it's not possible to fit reasonable batch sizes onto the GPU. Using distributed training in these situations can shorten the training time.

In this specific scenario, a [ResNet50 CNN model][resnet] is trained using [Horovod][horovod] on the [ImageNet dataset][imagenet] and on synthetic data. The reference implementation shows how to accomplish this task using [TensorFlow][tensorflow].

There are several ways to train a deep learning model in a distributed fashion, including data-parallel and model-parallel approaches that are based on synchronous or asynchronous updates. Currently the most common scenario is data-parallel training with synchronous updates. This approach is the easiest to implement and is sufficient for most use cases.

In data-parallel distributed training with synchronous updates, the model is replicated across *n* hardware devices. A mini-batch of training samples is divided into *n* micro-batches. Each device performs forward and backward passes for a micro-batch. When a device finishes the process, it shares the updates with the other devices. These values are used to calculate the updated weights of the entire mini-batch, and the weights are synchronized across the models. This scenario is covered in the associated [GitHub][github] repository.

![Data-parallel distributed training.][1]

This architecture can also be used for model-parallel and asynchronous updates. In model-parallel distributed training, the model is divided across *n* hardware devices, with each device holding a part of the model. In the simplest implementation, each device holds a layer of the network, and information is passed between devices during the forward and backward passes. Larger neural networks can be trained this way, but at the cost of performance, because devices are constantly waiting for each other to complete either the forward or backward pass. Some advanced techniques try to partially alleviate this issue by using synthetic gradients.

The steps for training are:

1. Create scripts that run on the cluster and train your model.
2. Write training data to Blob Storage.
3. Create a Machine Learning workspace. This step also creates an instance of Container Registry to host your Docker images.
4. Create a Machine Learning GPU-enabled cluster.
5. Submit training jobs. For each job with unique dependencies, a new Docker image is built and pushed to your container registry. During execution, the appropriate Docker image runs and executes your script.
6. All the results and logs are written to Blob Storage.

### Training cluster considerations

Azure provides several [GPU-enabled VM types][gpu] that are suitable for training deep learning models. They range in price and speed from low to high as follows:

| **Azure VM series**| **NVIDIA GPU**|
|---| ---|
| NC| K80|
| NDs| P40|
| NCsv2| P100|
| NCsv3| V100|
| NDv2| 8x V100 (NVLink)|
| ND A100 v4| 8x A100 (NVLink)|

We recommend scaling up your training before scaling out. For example, try a single V100 before trying a cluster of K80s. Similarly, consider using a single NDv2 instead of eight NCsv3 VMs.

The following graph shows the performance differences for different GPU types based on [benchmarking tests][benchmark] carried out using TensorFlow and Horovod. The graph shows throughput of 32 GPU clusters across various models, on different GPU types and MPI versions. Models were implemented in TensorFlow 1.9

![Throughput results for TensorFlow models on GPU clusters.][2]

Each VM series shown in the previous table includes a configuration with InfiniBand. Use the InfiniBand configurations when you run distributed training, for faster communication between nodes. InfiniBand also increases the scaling efficiency of the training for the frameworks that can take advantage of it. For details, see the Infiniband [benchmark comparison][benchmark].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Storage

When you train deep learning models, an often overlooked aspect is where to store the training data. If the storage is too slow to keep up with the demands of the GPUs, training performance can degrade.

Azure Machine Learning Compute supports many storage options. For best performance, download the data locally to each node. However, this process can be cumbersome, because you have to download the data to each node from Blob Storage. With the ImageNet dataset, this process can take a considerable amount of time. By default, Machine Learning mounts storage so that it caches the data locally. As a result, in practice, after the first epoch, the data is read from local storage. Combined with Premium Blob Storage, this arrangement offers a good compromise between ease of use and performance.

Although Azure Machine Learning Compute can mount Standard tier Blob Storage using the [blobfuse][blobfuse] adapter, we don't recommend using the Standard tier for distributed training, because the performance typically isn't good enough to handle the necessary throughput. Use Premium tier as storage for training data, as shown earlier in the architecture diagram. For a blog post with a throughput and latency comparison between the two tiers, see [Premium Block Blob Storage - a new level of performance][premium-storage-comparison].

### Container Registry

Whenever a Machine Learning workspace is provisioned, a set of dependent resources—Blob Storage, Key Vault, Container Registry, and Application Insights—is also provisioned. Alternatively, you can use existing Azure resources and associate them with the new Machine Learning workspace during its creation.

By default, Basic tier Container Registry is provisioned. For large-scale deep learning, we recommend that you customize your workspace to use Premium tier Container Registry. It offers significantly higher bandwidth that allows you to quickly pull Docker images across nodes of your training cluster.

### Data format

With large datasets, it's often advisable to use data formats such as [TFRecords][tfrecords] or [Petastorm][petastorm] that provide better I/O performance than multiple small image files.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

#### Use a High Business Impact-enabled workspace

In scenarios that use sensitive data, you should consider designating a Machine Learning workspace as High Business Impact (HBI) by setting an *hbi_workspace* flag to true when creating it. An HBI-enabled workspace, among others, encrypts local scratch disks of compute clusters, enables IP filtering, and reduces the amount of diagnostic data that Microsoft collects. For more information, see [Data encryption with Azure Machine Learning][data-encryption].

#### Encrypt data at rest and in motion

Encrypt sensitive data at rest&mdash;that is, in the blob storage. Each time data moves from one location to the other, use SSL to secure the data transfer. For more information, see [Azure Storage security guide][security-guide].

#### Secure data in a virtual network

For production deployments, consider deploying the Machine Learning cluster into a subnet of a virtual network that you specify. With this setup, the compute nodes in the cluster can communicate securely with other virtual machines or with an on-premises network. You can also use [service or private endpoints][endpoints] for all associated resources to grant access from a virtual network.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate the cost of running your deep learning workload. For cost planning and management considerations that are specific to Machine Learning, see [Plan to manage costs for Azure Machine Learning][costs]. For more information, see [Overview of the cost optimization pillar][aaf-cost].

#### Premium Blob Storage

Premium Blob Storage has a high data storage cost, but the transaction cost is lower than the cost of storing data in the Hot tier of Standard Blob Storage. So Premium Blob Storage can be less expensive for workloads with high transaction rates. For more information, see [Azure Blob Storage pricing][block-blob-pricing].

#### Container Registry

Container Registry offers Basic, Standard and Premium tiers. Choose a tier depending on the storage you need. Choose Premium if you need geo replication or enhanced throughput for Docker pulls across concurrent nodes. In addition, standard networking charges apply. For more information, see [Azure Container Registry pricing][az-container-registry-pricing].

#### Azure Machine Learning Compute

In this architecture, Azure Machine Learning Compute is likely the main cost driver. The implementation needs a cluster of GPU compute nodes. The price of those nodes is determined by their number and the VM size that you select. For more information on the VM sizes that include GPUs, see [GPU-optimized virtual machine sizes][gpu-vm-sizes] and [Azure Virtual Machines Pricing][az-vm-pricing].

Typically, deep learning workloads track the progress after every epoch or every few epochs. This practice limits the impact of unexpected interruptions to the training. You can pair this practice with the use of low-priority VMs for Machine Learning compute clusters. Low-priority VMs use excess Azure capacity at significantly reduced rates, but they can be preempted if capacity demands increase.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

While running your job, it's important to monitor the progress and make sure that things are working as expected. However, it can be a challenge to monitor across a cluster of active nodes.

Machine Learning offers many ways to [instrument your experiments][azureml-logging]. The stdout and stderr streams from your scripts are automatically logged. These logs are automatically synced to your workspace blob storage. You can either view these files through the Azure portal, or download or stream them using the Python SDK or Machine Learning CLI. If you log your experiments by using Tensorboard, these logs are automatically synced. You can access them directly or use the Machine Learning SDK to stream them to a [Tensorboard session][azureml-tensorboard].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The scaling efficiency of distributed training is always less than 100 percent due to network overhead&mdash;syncing the entire model between devices becomes a bottleneck. Therefore, distributed training is best suited for:

- Large models that can't be trained by using a reasonable batch size on a single GPU.
- Problems that can't be addressed by distributing the model in a simple, parallel way.

Distributed training isn't recommended for running hyperparameter searches. The scaling efficiency affects performance and makes a distributed approach less efficient than training multiple model configurations separately.

One way to increase scaling efficiency is to increase the batch size. But make this adjustment carefully. Increasing the batch size without adjusting the other parameters can impair the model's final performance.

## Deploy this scenario

The reference implementation of this architecture is available on [GitHub][github]. Follow the steps described there to conduct distributed training of deep learning models across clusters of GPU-enabled VMs.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

- [Ilia Karmanov](https://www.linkedin.com/in/ilia-karmanov-09aa588b) | Senior Applied Scientist
- [Mathew Salvaris](https://www.linkedin.com/in/drmathewsalvaris) | Principal Data Scientist Lead
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Machine Learning Cheat Sheet - distributed GPU training][distr-training]
- [Azure Machine Learning - distributed training examples][distr-training-examples]
- [What is Azure Machine Learning?][what-is-azure-machine-learning]
- [Introduction to Container registries in Azure][introduction-to-container-registries-in-azure]
- [Introduction to Azure Blob Storage][introduction-to-azure-blob-storage]
- [Train compute-intensive models with Azure Machine Learning][train-compute-intensive-models-with-azure-machine-learning]
- [Train and evaluate deep learning models][train-and-evaluate-deep-learning-models]

## Related resources

The output from this architecture is a trained model that is saved to a blob storage. You can operationalize this model for either real-time scoring or batch scoring. For more information, see the following reference architectures:

- [Real-time scoring of Python scikit-learn and deep learning models on Azure][real-time-scoring]
- [Batch scoring on Azure for deep learning models][batch-scoring]

For architectures that involve distributed training or deep learning, see the following resources:

- [Build a content-based recommendation system][build-a-content-based-recommendation-system]
- [Suggest content tags with NLP using deep learning][suggest-content-tags-with-nlp-using-deep-learning]

<!-- links -->

[1]: ./_images/distributed_dl_flow.png
[2]: ./_images/distributed_dl_tests.png
[acr]: /azure/container-registry/container-registry-intro
[aaf-cost]: /azure/architecture/framework/cost/overview
[aml-compute]: /azure/machine-learning/service/how-to-set-up-training-targets#amlcompute
[az-container-registry-pricing]: https://azure.microsoft.com/pricing/details/container-registry
[az-vm-pricing]: https://azure.microsoft.com/pricing/details/virtual-machines
[azure-blob]: /azure/storage/blobs/storage-blobs-introduction
[blobfuse]: https://github.com/Azure/azure-storage-fuse
[batch-scoring]: ../../reference-architectures/ai/batch-scoring-deep-learning.yml
[benchmark]: https://github.com/msalvaris/BatchAIHorovodBenchmark
[blobfuse]: https://github.com/Azure/azure-storage-fuse
[block-blob-pricing]: https://azure.microsoft.com/pricing/details/storage/blobs
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[endpoints]: /azure/machine-learning/how-to-network-security-overview#secure-the-training-environment
[github]: https://github.com/microsoft/DistributedDeepLearning
[gpu]: /azure/virtual-machines/sizes-gpu
[gpu-vm-sizes]: /azure/virtual-machines/linux/sizes-gpu
[horovod]: https://github.com/uber/horovod
[imagenet]: http://www.image-net.org
[tensorflow]: https://github.com/tensorflow/tensorflow
[real-time-scoring]: ../../reference-architectures/ai/real-time-scoring-machine-learning-models.yml
[resnet]: https://arxiv.org/abs/1512.03385
[security-guide]: /azure/storage/common/storage-security-guide
[azureml-logging]: /azure/machine-learning/how-to-track-experiments
[azureml-tensorboard]: https://github.com/Azure/MachineLearningNotebooks/blob/master/how-to-use-azureml/track-and-monitor-experiments/tensorboard/tensorboard/tensorboard.ipynb
[tfrecords]: https://www.tensorflow.org/tutorials/load_data/tfrecord
[petastorm]: https://github.com/uber/petastorm
[premium-storage]: /azure/storage/blobs/storage-blob-performance-tiers
[premium-storage-comparison]: https://azure.microsoft.com/blog/premium-block-blob-storage-a-new-level-of-performance
[costs]: /azure/machine-learning/concept-plan-manage-cost
[data-encryption]: /azure/machine-learning/concept-data-encryption
[distr-training]: https://azure.github.io/azureml-cheatsheets/docs/cheatsheets/python/v1/distributed-training
[distr-training-examples]: https://github.com/Azure/azureml-examples
[what-is-azure-machine-learning]: /azure/machine-learning/overview-what-is-azure-machine-learning
[introduction-to-container-registries-in-azure]: /azure/container-registry/container-registry-intro
[introduction-to-azure-blob-storage]: /azure/storage/blobs/storage-blobs-introduction
[train-compute-intensive-models-with-azure-machine-learning]: /training/paths/train-compute-intensive-models-azure-machine-learning
[train-and-evaluate-deep-learning-models]: /training/modules/train-evaluate-deep-learn-models
[build-a-content-based-recommendation-system]: /azure/architecture/solution-ideas/articles/build-content-based-recommendation-system-using-recommender
[suggest-content-tags-with-nlp-using-deep-learning]: ../../solution-ideas/articles/website-content-tag-suggestion-with-deep-learning-and-nlp.yml
