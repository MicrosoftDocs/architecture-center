This article provides guidance on running workloads that use GPU Nodes on Azure Kubernetes Service (AKS) cluster efficiently. It focuses on selecting the right SKU, using GPU nodes to train machine learning models, and using GPU nodes to run inferences on AKS.

## **Scenarios**

GPU workloads anywhere, including on AKS can be expensive, so cloud engineers should carefully consider deploying an AKS cluster with GPU nodes and understand when such a choice is necessary.

Although the need for GPU-based nodes isn't common, it's crucial to discern when deploying GPU nodes in your AKS cluster is warranted. GPUs are purpose-built for graphics, AI/ML, and other specialized tasks, which can seamlessly extend to any compute-intensive workload. In contrast, CPUs prioritize latency optimization, excelling in managing intricate logic and branching, while GPUs, optimized for throughput, effectively handle straightforward arithmetic and vector operations.

Despite understanding GPU optimization and utilizing compute-intensity as a decision factor, determining when to utilize GPUs for AKS workloads isn't always straightforward. To gain better insight into GPU utilization for AKS workloads, let's explore some workload examples.

Here are four scenarios where utilizing GPU nodes in your AKS cluster is advantageous:

### Computer Vision and Image Processing Workloads

Computer vision tasks involve interpreting visual data to extract meaningful information are becoming increasingly common in AI-powered applications, autonomous vehicles, medical imaging, surveillance systems, and augmented reality. With their parallel processing architecture, GPUs efficiently handle large-scale image data and complex computations required for tasks like object detection, image classification, and feature extraction.

### Video Processing and Streaming Workloads

As video becomes more prevalent in business, there's a growing need for GPU-powered hardware over CPUs. Video processing workloads, including transcoding, encoding, and streaming, are computationally intensive, especially with high-definition or 4K content. Whether it's streaming sports events or corporate videos, GPUs offer an efficient platform for delivering high-performance, low-latency video experiences across diverse applications.

### High-Performance Computing (HPC) Workloads

Scientific simulations, weather forecasting, computational fluid dynamics (CFD), and molecular modeling are examples of HPC applications that demand massive parallel processing power. GPUs, well-suited for parallel computations, significantly accelerate HPC workloads, making them indispensable for scientific and research-driven endeavors.

### Genomic Analysis and Bioinformatics Workloads

There has been a surge In the health and life sciences space, genomic analysis, and bioinformatics applications space. These workloads involve processing genetic data, such as DNA sequences and protein structures, and require complex algorithms for sequence alignment, variant calling, and genomic data mining. GPUs expedite genomic analysis workflows, enabling researchers to process data efficiently and uncover insights faster.

In summary, cloud engineers must consider cost implications before deploying GPU nodes in AKS clusters, and understand GPU optimization for compute-intensive tasks like computer vision, video processing, high-performance computing, and genomic analysis. This highlights the nuanced decision-making process for selecting GPU versus CPU resources in AKS clusters.

## Use cases for Accelerating Workloads with GPU-Enabled Agent Nodes

GPU-enabled agent nodes on Kubernetes provide a significant performance boost for a wide category of workloads that heavily rely on parallel processing and intensive computation. The use of GPUs over CPUs offers several advantages, making them highly beneficial in specific scenarios.

Examples of scenarios that can take advantage of GPU-enabled agent nodes on Kubernetes to deliver breakthrough performance with dramatically fewer servers, less power consumption, and reduced networking overhead, resulting in total cost savings are discussed here.

### Machine Learning (ML) and Deep Learning (DL)

Popular machine and deep learning frameworks like [TensorFlow](https://www.tensorflow.org/) , [PyTorch](https://pytorch.org/), and [MXNet](https://mxnet.apache.org/versions/1.9.1/) greatly benefit from GPUs as they can accelerate training and inference tasks.

DL models, with their complex neural networks, can take advantage of parallel processing on GPUs to significantly speed up computations. GPUs provide highly efficient matrix multiplication and convolutions, which are core operations in DL.

Tasks such as image classification, object detection, natural language processing, and speech recognition can be accelerated using GPUs.

### High-Performance Computing (HPC)

HPC applications often require complex simulations, numerical analysis, and scientific computations. Using GPUs allows for faster execution of these tasks by parallelizing the workload across multiple cores.

Frameworks like [NVIDIA CUDA](https://developer.nvidia.com/cuda-toolkit), [OpenCL](https://www.khronos.org/opencl/), and [OpenACC](https://www.openacc.org/) provide GPU-enabled APIs and libraries to accelerate HPC applications.

### Data Science and Analytics

Data preprocessing, feature engineering, and model training in data science workflows can be accelerated using GPUs. Frameworks like [RAPIDS](https://rapids.ai/) and [Dask GPU](https://docs.dask.org/en/stable/gpu.html) extend popular data processing libraries such as Pandas and Scikit-learn to utilize GPUs efficiently.

OSS accelerated SQL query engines and columnar databases like [BlazingSQL](https://github.com/BlazingDB/blazingsql) and [HeavyDB](https://github.com/heavyai/heavydb) use GPUs for fast querying and analytics on large datasets.

### Video Processing and Computer Vision

GPU-accelerated video encoding and decoding capabilities help in real-time video streaming, video transcoding, and video analytics.

Computer Vision tasks like object detection, tracking, and image/video processing can be accelerated using frameworks like [OpenCV](https://opencv.org/), [OpenCL](https://www.khronos.org/opencl/), [NVIDIA CUDA](https://developer.nvidia.com/cuda-toolkit), and [NVIDIA cuDNN](https://developer.nvidia.com/cudnn).

### Virtual Desktop Infrastructure (VDI) and Gaming

GPU-enabled agent nodes are essential for providing a rich user experience in virtual desktop environments by offloading graphics-intensive tasks to the GPU.

Gaming platforms and cloud gaming services rely on GPUs to deliver high-quality graphics and smooth gameplay experiences.

### Large Language Models

Running large language models such as [OpenAI GPT](https://platform.openai.com/docs/models), [Meta Llama](https://llama.meta.com/llama3/), [Falcon](https://falconllm.tii.ae/), and [Mistral](https://mistral.ai/news/mistral-large/) can get advantage of GPUs through parallel processing, leading to significant improvements in performance.

GPUs can significantly speed up the training and inference tasks of these language models, which involve complex computations and a large amount of data.

Parallel processing capabilities of GPUs can handle the intensive computation requirements of language models, leading to faster results and improved performance.

Language models often involve complex neural networks with numerous layers and parameters, which can be computationally demanding. GPUs provide accelerations for key operations involved in language processing, such as matrix multiplication and convolutions, resulting in faster training and inference times.

The utilization of GPUs for large language models can lead to breakthrough performances with reduced training time and improved real-time inference capabilities. This enables applications like natural language processing, machine translation, chatbots, and text generation to deliver faster and more accurate results.

It's important to note that not all workloads benefit from GPU-enabled agent nodes, and in some cases, CPUs might be sufficient. For example, workloads that are primarily I/O-bound or don't require heavy computation might not see significant improvements with GPUs.

To get started with GPU-enabled agent nodes on Azure Kubernetes Service (AKS), you can explore frameworks like [NVIDIA Kubernetes Device Plugin](https://github.com/NVIDIA/k8s-device-plugin) and [NVIDIA GPU Operator](https://github.com/NVIDIA/gpu-operator), which help manage and schedule GPU resources effectively in Kubernetes clusters. For more information on how to get advantage of GPU-enabled agent nodes on AKS, see the following resources:

- [Use GPUs on Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/gpu-cluster)
- [Use GPUs for Windows node pools on Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/use-windows-gpu)
- [Create a multi-instance GPU node pool in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/gpu-multi-instance?tabs=azure-cli)
- [Running GPU accelerated workloads with NVIDIA GPU Operator on AKS](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/running-gpu-accelerated-workloads-with-nvidia-gpu-operator-on/ba-p/4061318)
- [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator)
- [Deploy an application that uses OpenAI on Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/open-ai-quickstart?tabs=aoai)
- [Deploy Kaito on AKS using Terraform](https://techcommunity.microsoft.com/t5/azure-for-isv-and-startups/deploy-kaito-on-aks-using-terraform/ba-p/4108930)
- [Bring Your Own AI Models to Intelligent Apps on AKS with Kaito](https://learn.microsoft.com/shows/learn-live/intelligent-apps-on-aks-ep02-bring-your-own-ai-models-to-intelligent-apps-on-aks-with-kaito)
- [Open-Source Models on AKS with Kaito](https://moaw.dev/workshop/?src=gh:pauldotyu/moaw/learnlive/workshops/opensource-models-on-aks-with-kaito/)

## Workload Deployment

AKS provides different options to deploy GPU-enabled Linux and Windows node pools and workloads.

### Linux Workload Deployment

To deploy GPU-enabled Linux node pools and workloads on AKS, you can follow these steps:

1. View the [supported GPU-enabled VMs](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#supported-gpu-enabled-vms) in Azure. It's recommended to use a minimum size of _Standard_NC6s_v3_ for AKS node pools. Note, NVv4 series (based on AMD GPUs) aren't currently supported on AKS.
2. Be aware of the limitations when using an Azure Linux GPU-enabled node pool. Automatic security patches aren't applied and the default behavior for the cluster is _Unmanaged_. [NVadsA10](/azure/virtual-machines/nva10v5-series) v5-series isn't a recommended SKU for GPU VHD. Updating an existing node pool to add GPU isn't supported.
3. Using NVIDIA GPUs involves the installation of various NVIDIA software components such as the [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin?tab=readme-ov-file), GPU driver installation, and more. There are two options for using NVIDIA GPUs on AKS:
    - **Skip GPU driver installation:** When you create a new AKS cluster or add a GPU-enabled node pool to an existing cluster, this option allows you to skip GPU driver installation and is useful when you want to install your own drivers or use the [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html). For more information, see [Skip GPU driver installation](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#skip-gpu-driver-installation-preview).
    - **NVIDIA device plugin installation:** The [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin/blob/main/README.md) is required when using GPUs on AKS. You can manually install the NVIDIA device plugin. You can use a YAML manifest to deploy a [DaemonSet](https:/kubernetes.io/docs/concepts/workloads/controllers/daemonset/) that runs a pod on each node to provide the required drivers for the GPUs. This is the recommended approach when using GPU-enabled node pools for Azure Linux. For more information and detailed instructions, see [NVIDIA device plugin installation](https://learn.microsoft.com/en-us/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool"%20\l%20"nvidia-device-plugin-installation).
    - **Use NVIDIA GPU Operator with AKS:** The [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html) is a management tool that simplifies the deployment and lifecycle management of NVIDIA GPUs in Kubernetes clusters. It provides a Kubernetes-native way to manage NVIDIA GPUs and their associated software stack. The [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html) automates the management of all NVIDIA software components needed to deploy GPU including driver installation, the [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin?tab=readme-ov-file), the NVIDIA container runtime, and more. Since the GPU Operator handles these components, it's not necessary to manually install the NVIDIA device plugin. This also means that the automatic GPU driver installation on AKS is no longer required. For more information and instructions, see [Running GPU accelerated workloads with NVIDIA GPU Operator on AKS](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/running-gpu-accelerated-workloads-with-nvidia-gpu-operator-on/ba-p/4061318).
4. Once the necessary components are installed, you can check that your GPUs are schedulable. Then you can proceed to deploy and run GPU-enabled workloads on GPU-enabled node pools. You can use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), [taints, and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to schedule workloads on GPU-enabled nodes.

For more information, see [Use GPUs for compute-intensive workloads on Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool)

### Windows Workload Deployment

To deploy GPU-enabled Windows node pools and workloads on AKS, follow these steps:

1. View the [supported GPU-enabled VMs](https://learn.microsoft.com/en-us/azure/aks/use-windows-gpu#supported-gpu-enabled-virtual-machines-vms) in Azure. It's recommended to use a minimum size of _Standard_NC6s_v3_ for AKS node pools. Note that the NVv4 series (based on AMD GPUs) aren't supported on AKS.
2. Be aware of the limitations when using a Windows node pool. Updating an existing Windows node pool to add GPU isn't supported. It's also not supported on Kubernetes version 1.28 and below.
3. There are two options for using Windows GPUs on AKS:
    - **Using Windows GPU with automatic driver installation:** When creating a Windows node pool with a supported GPU-enabled VM size, the GPU driver and Kubernetes DirectX device plugin are installed automatically. For more information, see [Using Windows GPU with automatic driver installation](https://learn.microsoft.com/en-us/azure/aks/use-windows-gpu#using-windows-gpu-with-automatic-driver-installation).
    - **Using Windows GPU with manual driver installation:** Create a Windows node pool with N-series (NVIDIA GPU) VM sizes in AKS, the GPU driver, and Kubernetes DirectX device plugin are installed automatically. For more information, see [Using Windows GPU with manual driver installation](https://learn.microsoft.com/en-us/azure/aks/use-windows-gpu#using-windows-gpu-with-manual-driver-installation).
4. Once you install the necessary components, you can check that your GPUs are schedulable. Then you can proceed to deploy and run GPU-enabled workloads on GPU-enabled node pools. Use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to schedule workloads on GPU-enabled nodes.

For more information and instructions, see [Use Windows GPUs for compute-intensive workloads on Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/use-windows-gpu).

### Multi-Instance GPU (MIG) on AKS

Multi-instance GPU (MIG) is a feature provided by NVIDIA GPUs that allows a single physical GPU to be partitioned into multiple smaller instances, each running independently and appearing as a separate GPU to the host system. This enables efficient sharing of GPU resources among multiple users or workloads, improving GPU utilization and flexibility.

By using MIG, users can run their own GPU-accelerated workloads on a shared GPU, without interfering with other users' workloads. Each MIG instance can be assigned a specific amount of GPU memory, compute resources (such as CUDA cores and tensor cores), and other parameters, tailored to the requirements of the workload.

MIG is useful in scenarios where GPU resources are over-provisioned, allowing users to achieve higher GPU utilization by running multiple workloads concurrently on the same physical GPU. For more information on MIG, you can refer to the official NVIDIA documentation: [Multi-Instance GPU (MIG) Documentation](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html).

When you deploy a multi-instance GPU node pool in Azure Kubernetes Service (AKS), there are a few considerations to keep in mind:

- **Prerequisites and limitations:** Ensure that you have an Azure account with an active subscription, Azure CLI version 2.2.0 or later, kubectl installed and configured, and Helm v3 installed and configured. Also, be aware of the limitations, such as the inability to use Cluster Autoscaler with multi-instance node pools.
- **GPU instance profiles:** Understand the available [GPU instance profiles](https://learn.microsoft.com/en-us/azure/aks/gpu-multi-instance?tabs=azure-cli"%20\l%20"gpu-instance-profiles) for partitioning GPUs. These profiles define how GPUs are divided into instances, with each instance having its own memory and Stream Multiprocessor (SM). The number of instances created depends on the GPU instance profile used.
- **Create a multi-instance GPU node pool:** when you create a multi-instance GPU node pool within the AKS cluster, specify one of the available [GPU instance profiles](https://learn.microsoft.com/en-us/azure/aks/gpu-multi-instance?tabs=azure-cli"%20\l%20"gpu-instance-profiles) to determine how the GPUs are partitioned.
- **Determine multi-instance GPU (MIG) strategy:** Choose between the single strategy and mixed strategy for MIG. The single strategy treats each GPU instance as a separate GPU, while the mixed strategy exposes both the GPU instances and the GPU instance profile.
- **Install the NVIDIA device plugin and GPU feature discovery:** Use Helm to install the NVIDIA device plugin and GPU feature discovery. These plugins enable the proper scheduling and management of multi-instance GPU workloads in the AKS cluster. For more information, see [Create a multi-instance GPU node pool in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/gpu-multi-instance?tabs=azure-cli). Alternatively, install the [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html) and Node Feature Discovery separately via Helm, as shown in [Running GPU accelerated workloads with NVIDIA GPU Operator on AKS](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/running-gpu-accelerated-workloads-with-nvidia-gpu-operator-on/ba-p/4061318).
- **Confirm multi-instance GPU capability:** Confirm that the multi-instance GPU node pool is functioning correctly by verifying the allocated GPU devices using the kubectl exec command. This ensures that the GPUs are being partitioned and assigned properly.
- **Schedule work:** Once the multi-instance GPU node pool is set up, you can schedule GPU-enabled workloads on it. Use the appropriate YAML manifest to deploy your application, specifying the GPU resources needed based on the chosen MIG strategy. Use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to schedule workloads on GPU-enabled nodes.
- **Troubleshooting:** If you encounter any issues during the deployment or usage of the multi-instance GPU node pool, refer to the troubleshooting section for guidance. Make sure that the API version is up to date and not older than `2021-08-01`.

These considerations help you successfully deploy and manage multi-instance GPU workloads on AKS. For more information, see the official documentation on managing AKS node pools and multi-instance GPU deployment on AKS.

### Time-slicing for GPU oversubscription on AKS

Time-slicing for GPU oversubscription is a technique that allows multiple users or workloads to share a single GPU by time-sharing its compute resources. Rather than dedicating the entire GPU to a single workload, time-slicing allows multiple workloads to take turns utilizing the GPU hardware.

With time-slicing, the GPU scheduler divides the available GPU resources into time slices and allocates them to different workloads in a round-robin fashion. Each workload is given a certain amount of time to execute its GPU tasks before the scheduler switches to the next workload. This enables multiple users or workloads to share the GPU resources fairly and efficiently.

Time-slicing is beneficial when there's a higher demand for GPU resources than what is available, allowing more users or workloads to utilize the GPU without requiring more physical GPUs.

In the official [NVIDIA GPU operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html) documentation, there are various methods for configuring time-slicing. In Azure Kubernetes Service (AKS), where multiple node pools with different GPU or configurations are possible, you can define time-slicing at the node pool level. There are three steps to enable time-slicing:

1. Label the nodes to identify them for time-slicing configuration.
2. Create a ConfigMap for time-slicing.
3. Enable time-slicing based on the ConfigMap in the GPU operator cluster policy.

For more information, see [Running GPU accelerated workloads with NVIDIA GPU Operator on AKS](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/running-gpu-accelerated-workloads-with-nvidia-gpu-operator-on/ba-p/4061318).

### Kubernetes AI Toolchain Operator (KAITO) add-on for AKS

The [Kubernetes AI toolchain operator (Kaito)](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator) is a Kubernetes operator that simplifies the experience of running OSS AI models like [Falcon](https://huggingface.co/tiiuae) and [Llama2](https://github.com/meta-llama/llama) on your AKS cluster. You can deploy Kaito on your AKS cluster as a managed add-on for [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes). The [Kubernetes AI toolchain operator (Kaito)](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator) uses [Karpenter](https://karpenter.sh/) to automatically deploy the necessary GPU nodes based on a specification provided in the Workspace custom resource definition (CRD). Kaito sets up the inference server as an endpoint for your AI models. The Kaito add-on reduces onboarding time and allows you to focus on AI model usage and development rather than infrastructure setup.

The [Kubernetes AI toolchain operator (Kaito)](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator) is a managed add-on for AKS that simplifies the experience of running OSS AI models on your AKS clusters. The AI toolchain operator automatically provisions the necessary GPU nodes and sets up the associated inference server as an endpoint server to your AI models. Using the Kaito add-on reduces your onboarding time and enables you to focus on AI model usage and development rather than infrastructure setup.

Kaito provides the following features:

1. **Container Image Management**: Kaito allows you to manage large language models using container images. It provides an HTTP server to perform inference calls using the model library.
2. **GPU Hardware Configuration**: Kaito eliminates the need for manual tuning of deployment parameters to fit GPU hardware. It provides preset configurations that are automatically applied based on the model requirements.
3. **Auto-provisioning of GPU Nodes**: Kaito automatically provisions GPU nodes based on the requirements of your models. This ensures that your AI inference workloads have the necessary resources to run efficiently.
4. **Integration with Microsoft Container Registry**: If the license allows, Kaito can host large language model images in the public Microsoft Container Registry (MCR). This simplifies the process of accessing and deploying the models.

For more information on Kaito, see the following resources:

- [Kubernetes AI Toolchain Operator (Kaito)](https://github.com/Azure/Kaito)
- [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator)
- [Intelligent Apps on AKS Ep02: Bring Your Own AI Models to Intelligent Apps on AKS with Kaito](https://learn.microsoft.com/en-us/shows/learn-live/intelligent-apps-on-aks-ep02-bring-your-own-ai-models-to-intelligent-apps-on-aks-with-Kaito)
- [Deploy Kaito on AKS using Terraform](https://techcommunity.microsoft.com/t5/azure-for-isv-and-startups/deploy-kaito-on-aks-using-terraform/ba-p/4108930)

## Workload and cluster scaling

When it comes to your AI/ML scenarios, it’s important to differentiate training workloads from inferencing with pretrained models. To build and train your machine learning model, consider using GPU compute designed for deep learning and parallelizing AI computations. Training often requires gradual scaling and distributing large quantities of data across GPUs to achieve high accuracy with data parallelism. Model sharding is a common advanced technique to split certain stages of model training, through which GPUs can be assigned distinct tasks and maximized in their utilization. Thus, GPUs with the ability to scale-up and scale-out HPC workloads, such as the NV- or ND-series virtual machines on Azure help maintain high resource utilization and reduce user intervention for long-running, and typically expensive, ML training processes.

Alternatively, many organizations use pretrained, open-source AI/ML models for inferencing only. Getting started with popular models like LLaMA, Falcon, Mistral, is a faster and more cost-effective option than building and training a large language model (LLM) from scratch. In this case, resource utilization can be dynamic and fluctuate more frequently, depending on the volume of data you want to process for inferencing. When running live data through your chosen model, spikes in traffic sometimes occur, depending on the model size and requirements, but maintaining an acceptable, low level of latency throughout the inferencing process is an important consideration. To effectively make use of your GPUs for high performance and low latency, you can conduct distributed inference with certain model libraries (for example, [Distributed inference with multiple GPUs)](https://huggingface.co/docs/diffusers/main/en/training/distributed_inference). This route expands your compute options to lower GPU-count skus, having 1 or 2 GPUs each, with high availability across Azure regions and low maintenance costs.

## Configuring the environment

Below are two options for configuring your environment.

### Default GPU configurations

AKS supports GPU workloads on Ubuntu, Azure Linux, and Windows nodepools with NVIDIA GPUs. When running GPU workloads, most of the above scenarios can be satisfied by running the default configuration on AKS.

You can create gpu-enabled Ubuntu and Azure Linux nodepools by either of the following options.
1. Selecting a gpu-enabled vm size 
1. Manually installing the NVIDIA device plugin. See [AKS documentation](https://learn.microsoft.com/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool) for detailed steps and limitations.

You can create a gpu-enabled Windows nodepool by selecting a gpu-enabled vm size. All necessary NVIDIA components are automatically installed. See [AKS documentation](https://learn.microsoft.com/azure/aks/use-windows-gpu) for detailed steps and limitations.

> [!NOTE]
> Windows GPU is a preview feature and requires you to register the `WindowsGPUPreview` feature flag.

### Improving GPU Utilization with advanced GPU configurations

The computational needs of applications can vary. For applications that demand massive parallel processing power such as training huge AI models, the GPUs are fully utilized while the workload is running. However, other applications might require GPUs, but can only use a small part of the available GPU compute, resulting in underutilization.

If your applications aren't using the full capacity of the GPUs, you might want to consider advanced sharing or partitioning techniques. These techniques can help you allocate the appropriate amount of GPU acceleration for each workload, which can enhance utilization and lower the operational costs of deployment.

[Multi-instance GPU](https://learn.microsoft.com/azure/aks/gpu-multi-instance?tabs=azure-cli)s are supported for the default configuration on AKS. This feature allows you to partition Nvidia's A100 GPU into seven independent instances. Each instance has its own memory and Stream Multiprocessor (SM).

NVIDIA supports other partitioning techniques such as time-slicing and MPS, which aren't currently supported for the default configuration on AKS. You can [manually apply these configurations](https://learn.microsoft.com/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#:~:text=Skip%20GPU%20driver%20installation%20%28preview%29) using the NVIDIA GPU Operator.

### Cost Management of GPU workloads

Using GPUs can be expensive. Proper monitoring helps you understand drivers of GPU costs and identify optimization opportunities. You can use the [AKS Cost Analysis](https://learn.microsoft.com/azure/cost-management-billing/costs/quick-acm-cost-analysis) add-on to increase cost visibility.

Here are three scenarios where cost visibility might be advantageous:

#### GPU-enabled VM size cost

Selecting a GPU-enabled VM size is an important process that can significantly affect the cost of running GPUs. Daily costs can vary significantly depending on the VM size you select. A100 GPUs are costly and should be avoided unless your workload specifically requires them. AKS Cost Analysis displays the daily cost for each of your VMs and break down the associated costs of each workload running on the GPU enabled VM. Use this data to evaluate if the VM size used is satisfactory or if there's an alternative option that might be more cost effective.

#### Idle cost

After you create a GPU-enabled nodepool, you’ll begin incurring costs on the Azure resource even if you have not run a GPU workload. Idle costs represent the cost of available resource capacity that isn’t used by any workload. This cost adds up quickly if you have many unused nodes. To avoid high idle costs, only create nodepools when you’re ready to run your workload and use methods such as [cluster stop](https://learn.microsoft.com/azure/aks/start-stop-cluster?tabs=azure-cli) when you’re not running a workload. AKS Cost Analysis displays idle costs for each of your nodes.

#### Overprovisioning and underutilization

Overprovisioning, when more resources are allocated than necessary for a pod, leads to resource wastage and underutilization. The excess resources remain reserved for the node even if it isn't used. To reduce overprovisioning, use [vertical pod autoscaler](https://learn.microsoft.com/azure/aks/vertical-pod-autoscaler) to set accurate requests and limits based on historical usage patterns.

Underutilization can occur when the GPUs aren't fully utilized by your workloads. Consider advanced GPU sharing and partitioning techniques. Rather than using multiple nodes, you might be able to use a single node with partitioning to maximize GPU utilization. For advanced scenarios, you can improve resource bin-packing on your nodes with the help of scheduler configurations and running a second scheduler. Learn more about configuring and maintaining a secondary scheduler that can use alternative workload placement strategies from the default AKS scheduler, at [Configure Multiple Schedulers on Kubernetes](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Steve Buchanan](https://www.linkedin.com/in/steveabuchanan/) | Principal Program Manager
- [Ally Ford](https://www.linkedin.com/in/allison-ford-pm/) | Product Manager 2
- [Sachi Desai](https://www.linkedin.com/in/sachi-desai/) | Product Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

The AI toolchain operator (KAITO) is a managed add-on for AKS that simplifies the experience of running OSS AI models on your AKS clusters. For more information, check out [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](/azure/aks/ai-toolchain-operator).
