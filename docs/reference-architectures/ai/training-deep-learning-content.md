This reference architecture shows how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs. The scenario is image classification, but the solution can be generalized to other deep learning scenarios such as segmentation or object detection.

A reference implementation for this architecture is available on [GitHub][github].

![Architecture for distributed deep learning][0]

**Scenario:** Classifying images is a widely applied technique in computer vision, often tackled by training a convolutional neural network (CNN). For particularly large models with large datasets, the training process can take weeks or months on a single GPU. In some situations, the models are so large that it is not possible to fit reasonable batch sizes onto the GPU. Using distributed training in these situations can shorten the training time.

In this specific scenario, a [ResNet50 CNN model][resnet] is trained using [Horovod][horovod] on the [ImageNet dataset][imagenet] and on synthetic data. The reference implementation shows how to accomplish this task using [TensorFlow][tensorflow].

There are several ways to train a deep learning model in a distributed fashion, including data-parallel and model-parallel approaches based on synchronous or asynchronous updates. Currently the most common scenario is data-parallel training with synchronous updates. This approach is the easiest to implement and is sufficient for most use cases.

In data-parallel distributed training with synchronous updates, the model is replicated across *n* hardware devices. A mini-batch of training samples is divided into *n* micro-batches. Each device performs the forward and backward passes for a micro-batch. When a device finishes the process, it shares the updates with the other devices. These values are used to calculate the updated weights of the entire mini-batch, and the weights are synchronized across the models. This scenario is covered in the associated [GitHub][github] repository.

![Data-parallel distributed training][1]

This architecture can also be used for model-parallel and asynchronous updates. In model-parallel distributed training, the model is divided across *n* hardware devices, with each device holding a part of the model. In the simplest implementation, each device may hold a layer of the network, and information is passed between devices during the forward and backwards pass. Larger neural networks can be trained this way, but at the cost of performance, since devices are constantly waiting for each other to complete either the forward or backwards pass. Some advanced techniques try to partially alleviate this issue by using synthetic gradients.

The steps for training are:

1. Create scripts that will run on the cluster and train your model.
2. Write training data to Blob storage.
3. Create an Azure Machine Learning workspace. This will also create an Azure Container Registry to host your Docker images.
4. Create an Azure Machine Learning GPU-enabled Cluster.
5. Submit training jobs. For each job with unique dependencies, a new Docker image is built and pushed to your container registry. During execution, the appropriate Docker image runs and executes your script.
6. All the results and logs are written to Blob storage.

## Architecture

This architecture consists of the following components:

**[Azure Machine Learning Compute][aml-compute]** plays the central role in this architecture by scaling resources up and down according to need. Azure ML Compute is a service that helps provision and manage clusters of VMs, schedule jobs, gather results, scale resources, and handle failures. It supports GPU-enabled VMs for deep learning workloads.

**[Standard Blob storage][azure-blob]** is used to store the logs and results. **[Premium Blob storage][premium-storage]** is used to store the training data and is mounted in the nodes of the training cluster using [blobfuse][blobfuse]. The Premium tier of Blob storage offers better performance than the Standard tier and is recommended for distributed training scenarios. When mounted using blobfuse, during first the epoch, the training data is downloaded to the local disks of the training cluster and cached. For every subsequent epoch, the data is read from the local disks, which is the most performant option.

**[Container Registry][acr]** is used to store the Docker image that Azure Machine Learning Compute uses to run the training.

## Training cluster considerations

Azure provides several [GPU-enabled VM types][gpu] suitable for training deep learning models. They range in price and speed from low to high as follows:

| **Azure VM series**| **NVIDIA GPU**|
|---| ---|
| NC| K80|
| NDs| P40|
| NCsv2| P100|
| NCsv3| V100|
| NDv2| 8x V100 (NVLink)|
| ND A100 v4| 8x A100 (NVLink)|

We recommended scaling up your training before scaling out. For example, try a single V100 before trying a cluster of K80s. Similarly, one should consider using a single NDv2 instead of eight NCsv3.

The following graph shows the performance differences for different GPU types based on [benchmarking tests][benchmark] carried out using TensorFlow and Horovod. The graph shows throughput of 32 GPU clusters across various models, on different GPU types and MPI versions. Models were implemented in TensorFlow 1.9

![Throughput results for TensorFlow models on GPU clusters][2]

Each VM series shown in the previous table includes a configuration with InfiniBand. Use the InfiniBand configurations when you run distributed training, for faster communication between nodes. InfiniBand also increases the scaling efficiency of the training for the frameworks that can take advantage of it. For details, see the Infiniband [benchmark comparison][benchmark].

## Storage considerations

When training deep learning models, an often-overlooked aspect is where the training data is stored. If the storage is too slow to keep up with the demands of the GPUs, training performance can degrade.

Azure Machine Learning Compute supports many storage options. For best performance it is advisable that you download the data locally to each node. However, this can be cumbersome, because all the nodes must download the data from Blob Storage, and with the ImageNet dataset, this can take a considerable amount of time. By default Azure ML mounts storage such that it caches the data locally. This means, in practice, that after the first epoch the data is read from local storage. This combined with Premium Blob Storage offers a good compromise between ease of use and performance.

Although Azure Machine Learning Compute can mount Standard tier Blob storage using the [blobfuse][blobfuse] adapter, we do not recommend using the Standard tier for distributed training as the performance typically is not good enough to handle the necessary throughput. Use Premium tier as storage for training data as shown in the architecture diagram above. You may also refer to the following [blog post][premium-storage-comparison] for throughput and latency comparison between the two tiers.

## Container registry considerations

Whenever an Azure Machine Learning workspace is provisioned, a set of dependent resources - Blob storage, Key Vault, Container Registry, and Application Insights - is also provisioned. Alternatively, one may use existing Azure resources and associate them with the new Azure Machine learning workspace during its creation.

By default, Basic tier Azure Container Registry is provisioned. For large-scale deep learning, we recommend that you customize your workspace to use Premium tier Container registry as it offers significantly higher bandwidth that will allow you to quicker pull Docker images across nodes of your training cluster.

## Scalability considerations

The scaling efficiency of distributed training is always less than 100 percent due to network overhead &mdash; syncing the entire model between devices becomes a bottleneck. Therefore, distributed training is most suited for large models that cannot be trained using a reasonable batch size on a single GPU, or for problems that cannot be addressed by distributing the model in a simple, parallel way.

Distributed training is not recommended for running hyperparameter searches. The scaling efficiency affects performance and makes a distributed approach less efficient than training multiple model configurations separately.

One way to increase scaling efficiency is to increase the batch size. That must be done carefully, however, because increasing the batch size without adjusting the other parameters can hurt the model's final performance.

## Data format considerations

With large datasets it is often advisable to use data formats such as [TFRecords][tfrecords] or [Petastorm][petastorm] that provide better I/O performance than multiple small image files.

## Security considerations

### Use High Business Impact-enabled workspace

In scenarios that use sensitive data, you should consider designating an Azure Machine Learning workspace as High Business Impact (HBI) by setting an *hbi_workspace* flag to true when creating it. An HBI-enabled workspace, among others, encrypts local scratch disks of compute clusters, enables IP filtering, and reduces the amount of diagnostic data Microsoft collects. For more information, see [Data encryption with Azure Machine Learning][data-encryption].

### Encrypt data at rest and in motion

Encrypt sensitive data at rest &mdash; that is, in the Blob storage. Each time data moves from one location to the other, use SSL to secure the data transfer. For more information, see the [Azure Storage security guide][security-guide].

### Secure data in a virtual network

For production deployments, consider deploying the Azure Machine Learning cluster into a subnet of a virtual network that you specify. This allows the compute nodes in the cluster to communicate securely with other virtual machines or with an on-premises network. You can also use [service or private endpoints][endpoints] for all associated resources to grant access from a virtual network.

## Monitoring considerations

While running your job, it is important to monitor the progress and make sure that things are working as expected. However, it can be a challenge to monitor across a cluster of active nodes.

Azure Machine Learning offers many ways to [instrument your experiments][azureml-logging]. The stdout/stderr from your scripts are automatically logged. These logs are automatically synced to your workspace Blob storage. You can either view these files through the Azure portal, or download or stream them using the Python SDK or Azure Machine Learning CLI. If you log your experiments using Tensorboard, these logs are automatically synced and you can access them directly or use the Azure Machine Learning SDK to stream them to a [Tensorboard session][azureml-tensorboard].

## Cost considerations

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs of running your deep learning workload. Here are [cost planning and management][costs] considerations specific to Azure ML. For more information, see the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

### Premium Blob Storage

Premium Blob Storage has higher data storage cost, however the transaction cost is lower compared to data stored in the Hot tier of Standard Blob Storage. So, Premium Blob Storage can be less expensive for workloads with high transaction rates. For more information, see [pricing page][block-blob-pricing].

### Azure Container Registry

Azure Container Registry offers Basic, Standard and Premium. Choose a tier depending on the storage you need. Choose Premium if you need geo replication or enhanced throughput for docker pulls across concurrent nodes. In addition, standard networking charges apply. For more information, see [Azure Container Registry pricing][az-container-registry-pricing].

### Azure Machine Learning Compute

In this architecture, Azure ML Compute is likely the main cost driver. The implementation needs a cluster of GPU compute nodes price of which is determined by their number and the selected VM size. For more information on the VM sizes that include GPUs, see [GPU-optimized virtual machine sizes][gpu-vm-sizes] and [Azure Virtual Machines Pricing][az-vm-pricing].

Typically, deep learning workloads checkpoint progress after every (few) epoch(s) to limit the impact of unexpected interruptions to the training. This can be nicely paired with the ability to leverage low-priority VMs for Azure Machine Learning compute clusters. Low-priority VMs use Azure's excess capacity at significantly reduced rates, however, they can be preempted if capacity demands increase.

## Deployment

The reference implementation of this architecture is available on [GitHub][github]. Follow the steps described there to conduct distributed training of deep learning models across clusters of GPU-enabled VMs.

## Next steps

The output from this architecture is a trained model that is saved to a Blob storage. You can operationalize this model for either real-time scoring or batch scoring. For more information, see the following reference architectures:

- [Real-time scoring of Python scikit-learn and deep learning models on Azure][real-time-scoring]
- [Batch scoring on Azure for deep learning models][batch-scoring]

You may also find the following resources useful:

- [Azure Machine Learning Cheat Sheet - distributed GPU training][distr-training]
- [Azure Machine Learning - distributed training examples][distr-training-examples]

<!-- links -->

[0]: ./_images/distributed_dl_architecture.png
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
[premium-storage-comparison]: https://azure.microsoft.com/blog/premium-block-blob-storage-a-new-level-of-performance/
[costs]: /azure/machine-learning/concept-plan-manage-cost
[data-encryption]: /azure/machine-learning/concept-data-encryption
[distr-training]: https://azure.github.io/azureml-cheatsheets/docs/cheatsheets/python/v1/distributed-training
[distr-training-examples]: https://github.com/Azure/azureml-examples
