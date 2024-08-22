This article provides guidance on efficiently running workloads that use GPU Nodes on an Azure Kubernetes Service (AKS) cluster. It focuses on selecting the right SKU, using GPU nodes to train machine learning models, and using GPU nodes to run inferences on AKS.

## Scenarios

Running GPU workloads can be expensive. It's crucial to understand when to deploy GPU-based nodes in your AKS clusters to avoid unnecessary cost.

GPUs are purpose-built for graphics, AI/ML, and specialized tasks, making them ideal for compute-intensive workloads. While CPUs excel in managing intricate logic and branching, GPUs are optimized for throughput and efficient handling of straightforward arithmetic and vector operations.

Despite understanding GPU optimization and utilizing compute-intensity as a decision factor, determining when to use GPUs for AKS workloads isn't always straightforward. To gain better insight into GPU utilization for AKS workloads, let's explore some workload examples.

Here are scenarios where utilizing GPU nodes in your AKS cluster is advantageous:

### Data Science and Analytics

Data preprocessing, feature engineering, and model training in data science workflows can be accelerated using GPUs. Frameworks like [RAPIDS](https://rapids.ai/) and [Dask GPU](https://docs.dask.org/en/stable/gpu.html) extend popular data processing libraries, such as Pandas and Scikit-learn, to efficiently use GPUs.

OSS accelerated SQL query engines and columnar databases like [BlazingSQL](https://github.com/BlazingDB/blazingsql) and [HeavyDB](https://github.com/heavyai/heavydb) use GPUs for fast querying and analytics on large datasets.

### Machine Learning (ML) and Deep Learning (DL)

Popular machine and deep learning frameworks like [TensorFlow](https://www.tensorflow.org/) , [PyTorch](https://pytorch.org/), and [MXNet](https://mxnet.apache.org/versions/1.9.1/) greatly benefit from GPUs as they can accelerate training and inference tasks.

DL models, with their complex neural networks, can take advantage of parallel processing on GPUs to significantly speed up computations. GPUs provide highly efficient matrix multiplication and convolutions, which are core operations in DL.

Tasks such as image classification, object detection, natural language processing, and speech recognition can be accelerated using GPUs.

### Computer Vision and Image Processing Workloads

Computer vision tasks involve interpreting visual data to extract meaningful information and are becoming increasingly common in AI-powered applications, autonomous vehicles, medical imaging, surveillance systems, and augmented reality. With their parallel processing architecture, GPUs efficiently handle large-scale image data and complex computations required for tasks like object detection, image classification, and feature extraction.

### Video Processing and Streaming Workloads

As video becomes more prevalent in business, there's a growing need for GPU-powered hardware over CPUs. Video processing workloads, including transcoding, encoding, and streaming, are computationally intensive, especially with high-definition or 4K content. Whether it's streaming sports events or corporate videos, GPUs offer an efficient platform for delivering high-performance, low-latency video experiences across diverse applications.

GPU-enabled agent nodes are essential for providing a rich user experience in virtual desktop environments by offloading graphics-intensive tasks to the GPU.GPU-accelerated video encoding and decoding capabilities help in real-time video streaming, video transcoding, and video analytics.

Computer Vision tasks like object detection, tracking, and image/video processing can be accelerated using frameworks like [OpenCV](https://opencv.org/), [OpenCL](https://www.khronos.org/opencl/), [NVIDIA CUDA](https://developer.nvidia.com/cuda-toolkit), and [NVIDIA cuDNN](https://developer.nvidia.com/cudnn).

Gaming platforms and cloud gaming services rely on GPUs to deliver high-quality graphics and smooth gameplay experiences.

### High-Performance Computing (HPC) Workloads

HPC applications often require complex simulations, numerical analysis, and scientific computations. Using GPUs allows for faster execution of these tasks by parallelizing the workload across multiple cores. Scientific simulations, weather forecasting, computational fluid dynamics (CFD), and molecular modeling are examples of HPC applications that demand massive parallel processing power. GPUs are well-suited for parallel computations and significantly accelerate HPC workloads, making them indispensable for scientific and research-driven endeavors.

Frameworks like [NVIDIA CUDA](https://developer.nvidia.com/cuda-toolkit), [OpenCL](https://www.khronos.org/opencl/), and [OpenACC](https://www.openacc.org/) provide GPU-enabled APIs and libraries to accelerate HPC applications.

### Genomic Analysis and Bioinformatics Workloads

There has been a surge in the health and life sciences space, including genomic analysis and bioinformatics applications. These workloads involve processing genetic data, such as DNA sequences and protein structures, and require complex algorithms for sequence alignment, variant calling, and genomic data mining. GPUs expedite genomic analysis workflows, enabling researchers to process data efficiently and uncover insights faster.

In summary, cloud engineers must consider cost implications before deploying GPU nodes in AKS clusters, and understand GPU optimization for compute-intensive tasks like computer vision, video processing, high-performance computing, and genomic analysis. This highlights the nuanced decision-making process for selecting GPU versus CPU resources in AKS clusters.

### Generative AI models

Large language models like [OpenAI GPT](https://platform.openai.com/docs/models), [Meta Llama](https://llama.meta.com/llama3/), [Falcon](https://falconllm.tii.ae/), or [Mistral](https://mistral.ai/news/mistral-large/), can take advantage of GPUs through parallel processing, leading to significant improvements in performance.

GPUs can significantly speed up the training and inference tasks of these language models, which involve complex computations and a large amount of data.

This is achieved through the parallel processing capabilities of GPUs, or dividing the large computational tasks of a given model into smaller subtasks executed concurrently, which leads to faster results and improved performance.

Language models often involve complex neural networks with numerous layers and parameters, which can be computationally demanding. GPUs provide accelerations for key operations involved in language processing, such as matrix multiplication and convolutions, resulting in faster training and inference times.

GPUs can offer sufficient memory capacity, bandwidth, and processing power to handle LLM-based applications with conversational interfaces, text generation, and more. Users interacting with chatbots and AI assistants, for example, can see a significant speed-up in response time as a result of these GPU enhancements.

It's important to note that not all workloads benefit from GPU-enabled agent nodes, and in some cases, CPUs might be sufficient. For example, workloads that are primarily I/O-bound or don't require heavy computation might not see significant improvements with GPUs.

### Customer Stories

Many Microsoft customers are already leveraging GPU workloads to innovate for their customers. You can find some examples below:

- NBA on streaming sports use case: [NBA players are improving performance with AI on Azure AI infrastructure](https://customers.microsoft.com/story/1769559716293357869-nba-azure-kubernetes-service-media-and-entertainment-en-united-states)
- MR.Turing on natural language processing: [Mr. Turing uses AI and Azure Kubernetes Service to unlock and retain company information—and make it searchable](https://customers.microsoft.com/story/1696908458386008536-misterturing-azure-kubernetes-service-brazil)
- OriGen on Energy/HPC: [OriGen accelerates reservoir simulations by 1,000 times with Azure AI infrastructure](https://customers.microsoft.com/story/1665511423001946809-OriGen-partner-professional-services-azure)
- Sensyne on Healthcare use case: [Sensyne Health aids National Health Service in the COVID-19 struggle with Microsoft HPC and AI technologies](https://customers.microsoft.com/story/1430377058968477645-sensyne-health-partner-professional-services-azure-hpc)
- Constellation on Energy: [Clearsight augments electrical infrastructure inspection with AutoML for Images from Azure Machine Learning](https://customers.microsoft.com/story/1548724923828850434-constellation-clearsight-energy-azure-machine-learning)

## Best Practices for deploying GPU workloads

AKS provides different options to deploy GPU-enabled Linux and Windows node pools and workloads. To ensure the smooth operation of your GPU workload, follow these best practices:

### Linux Workload Deployment

* The recommended approach for deploying GPU-enabled Linux node pools is to create a node pool with a [supported GPU-enabled VM](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#supported-gpu-enabled-vms) and manually install the NVIDIA device plugin. Instructions can be found in the [AKS documentation](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool). Updating an existing node pool to add GPU isn't supported.
* View the [supported GPU-enabled VMs](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#supported-gpu-enabled-vms) in Azure. It's recommended to use a minimum size of _Standard_NC6s_v3_ for AKS node pools. Note, NVv4 series (based on AMD GPUs) aren't currently supported on AKS.
* Be aware of the limitations when using an Azure Linux GPU-enabled node pool. Automatic security patches aren't applied and the default behavior for the cluster is _Unmanaged_.
* When scheduling workloads on your GPU-enabled node pools, you can use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), [taints, and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

### Windows Workload Deployment

* The recommended approach for deploying GPU-enabled Windows node pools is to create a node pool with a [supported GPU-enabled VM](/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#supported-gpu-enabled-vms). AKS will automatically install the drivers and necessary NVIDIA components. Instructions can be found in the [AKS documentation](/azure/aks/use-windows-gpu#using-windows-gpu-with-automatic-driver-installation). Updating an existing node pool to add GPU isn't supported.
* View the [supported GPU-enabled VMs](/azure/aks/use-windows-gpu#supported-gpu-enabled-virtual-machines-vms) in Azure. It's recommended to use a minimum size of _Standard_NC6s_v3_ for AKS node pools. Note that the NVv4 series (based on AMD GPUs) aren't supported on AKS.
* When selecting a supported GPU-enabled VM, AKS will automatically install the appropriate NVIDIA CUDA or GRID driver. Some workloads may be dependent on a particular driver which can impact your deployment. For NC and ND series VM sizes, the CUDA driver is installed. For NV series VM sizes, the GRID driver is installed. 
* Be aware of the limitations when using a Windows node pool. Windows GPUs are not supported on Kubernetes version 1.28 and below.
* When scheduling workloads on your GPU-enabled node pools, you can use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), [taints, and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

> [!NOTE]
> Windows GPU is a preview feature and requires you to register the `WindowsGPUPreview` feature flag.

### Deploying with the NVIDIA GPU Operator

The NVIDIA GPU Operator is a tool designed to streamline the deployment and management of GPU resources within Kubernetes clusters. It automates the installation, configuration, and maintenance of the necessary software components to ensure optimal utilization of NVIDIA GPUs for demanding workloads such as artificial intelligence (AI) and machine learning (ML). The [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html) automates the management of all NVIDIA software components needed to deploy GPU including driver installation, the [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin?tab=readme-ov-file), the NVIDIA container runtime, and more. For more information, see [NVIDIA documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/overview.html).

For more advanced GPU workloads where you may want increased control and flexibility, you can use the NVIDIA GPU Operator with your GPU-enabled nodes on AKS. Instructions can be found in the [AKS documentation](https://learn.microsoft.com/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#:~:text=Use%20NVIDIA%20GPU%20Operator%20with%20AKS).

Keep in mind the following best practices:
* NVIDIA GPU Operator does not support Windows GPUs.
* The NVIDIA GPU Operator is the recommended way to do advanced GPU configurations such as driver version selection and time-slicing.
* Skipping automatic driver installation is required before using the GPU Operator.
* When using the GPU Operator with Cluster Autoscaler, the min-count should be set to 1.

> [!NOTE]
> Microsoft **doesn't support or manage** the maintenance and compatibility of the NVIDIA drivers as part of the node image deployment when you use the GPU Operator.

### Deploying GPU Workloads for Large Language Models (LLMs)

#### Kubernetes AI Toolchain Operator (KAITO) add-on for AKS

The [Kubernetes AI toolchain operator (KAITO)](/azure/aks/ai-toolchain-operator) is a Kubernetes operator that simplifies the experience of running open-source large language models (LLMs) like [Falcon](https://huggingface.co/tiiuae) and [Llama2](https://github.com/meta-llama/llama) on your Kubernetes cluster. You can deploy KAITO on your AKS cluster as a managed add-on for [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes). KAITO leverages [Karpenter](https://karpenter.sh/) to automatically provision and deploy GPU nodes based on a specification provided in the Workspace custom resource definition (CRD) of your chosen model. KAITO creates the inference server as an endpoint for your LLM, reduces overall onboarding time, and allows you to focus on ML operations rather than infrastructure setup and maintenance.

KAITO improves your ML operations with the following capabilities:

- **Container Image Management**: Manage large language models using container images. KAITO provides an HTTP server to perform inference calls using the [supported model library](https://github.com/Azure/kaito/tree/main/examples/inference).
- **GPU Hardware Configuration**: KAITO eliminates manual tuning of deployment parameters to fit GPU hardware. It provides preset configurations that are automatically applied based on the model requirements.
- **Auto-provisioning of GPU Nodes**: KAITO automatically provisions GPU nodes based on model requirements and recommends lower-cost GPU VM sizes to configure distributed inferencing.
- **Integration with Microsoft Container Registry**: If the LLM license allows, KAITO can host model images in the public Microsoft Container Registry (MCR), simplifying access to and deployment of supported models. (For open-source models with MIT or Apache2 license not yet included in the KAITO repository, submit a request [here](https://github.com/Azure/kaito/blob/main/docs/How-to-add-new-models.md) for new model onboarding).

To learn more about KAITO, see the following resources:

- [KAITO](https://github.com/Azure/Kaito) open source project
- [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](https://learn.microsoft.com/en-us/azure/aks/ai-toolchain-operator)
- [Fine tune your language models with open-source KAITO](https://learn.microsoft.com/en-us/azure/aks/concepts-fine-tune-language-models)
- [Deploy Kaito on AKS using Terraform](https://techcommunity.microsoft.com/t5/azure-for-isv-and-startups/deploy-kaito-on-aks-using-terraform/ba-p/4108930)

## Workload and cluster scaling

When it comes to your AI/ML scenarios, it’s important to differentiate training workloads from inferencing with pretrained models. To build and train your machine learning model, consider using GPU compute designed for deep learning and parallelizing AI computations. Training often requires gradual scaling and distributing large quantities of data across GPUs to achieve high accuracy with data parallelism. Model sharding is a common advanced technique to split certain stages of model training where GPUs can be assigned distinct tasks and maximize their utilization. GPUs have the ability to scale-up and scale-out HPC workloads, such as the NV- or ND-series virtual machines on Azure, to help maintain high resource utilization and reduce user intervention for long-running, and typically expensive, ML training processes.

Alternatively, many organizations use pretrained, open-source AI/ML models for inferencing only. Getting started with popular models like LLaMA, Falcon, or Mistral is a faster and more cost-effective option than building and training a large language model (LLM) from scratch (to learn more, see [Language models on AKS](/azure/aks/concepts-ai-ml-language-models)). In this case, resource utilization can be dynamic and fluctuate more frequently, depending on the volume of data you want to process for inferencing. When running live data through your chosen model, spikes in traffic sometimes occur depending on the model size and requirements. Maintaining an acceptable, low level of latency throughout the inferencing process is an important consideration. To effectively make use of your GPUs for high performance and low latency, you can conduct distributed inference with the models supported by KAITO. This route expands your compute options to lower GPU-count SKUs, having 1 or 2 GPUs each, with high availability across Azure regions and low maintenance costs.

## Cost Management of GPU workloads

Using GPUs can be expensive. Proper monitoring helps you understand drivers of GPU costs and identify optimization opportunities. You can use the [AKS Cost Analysis](https://learn.microsoft.com/azure/cost-management-billing/costs/quick-acm-cost-analysis) add-on to increase cost visibility.

Here are three scenarios where cost visibility might be advantageous:

### GPU-enabled VM size cost

Selecting a GPU-enabled VM size is an important process that can significantly affect the cost of running GPUs. Daily costs can vary significantly depending on the VM size you select. A100 GPUs are costly and should be avoided unless your workload specifically requires them. AKS Cost Analysis displays the daily cost for each of your VMs and break down the associated costs of each workload running on the GPU enabled VM. Use this data to evaluate if the VM size used is satisfactory or if there's an alternative option that might be more cost effective.

### Idle cost

After you create a GPU-enabled node pool, you begin incurring costs on the Azure resource even if you haven't run a GPU workload. Idle costs represent the cost of available resource capacity that isn’t used by any workload. This cost adds up quickly if you have many unused nodes. To avoid high idle costs, only create node pools when you’re ready to run your workload and use methods such as [cluster stop](https://learn.microsoft.com/azure/aks/start-stop-cluster?tabs=azure-cli) when you’re not running a workload. AKS Cost Analysis displays idle costs for each of your nodes.

### Overprovisioning and underutilization

Overprovisioning, which is when more resources are allocated than necessary for a pod, leads to resource wastage and underutilization. The excess resources remain reserved for the node even if it isn't used. To reduce overprovisioning, use [vertical pod autoscaler](https://learn.microsoft.com/azure/aks/vertical-pod-autoscaler) to set accurate requests and limits based on historical usage patterns.

Underutilization can occur when the GPUs aren't fully utilized by your workloads. Consider advanced GPU sharing and partitioning techniques. Rather than using multiple nodes, you might be able to use a single node with partitioning to maximize GPU utilization. These techniques can help you allocate the appropriate amount of GPU acceleration for each workload, which can enhance utilization and lower the operational costs of deployment.

[Multi-instance GPUs](https://learn.microsoft.com/azure/aks/gpu-multi-instance?tabs=azure-cli) are supported for Linux GPU workload deployments on AKS. This feature allows you to partition NVIDIA's A100 GPU into seven independent instances. Each instance has its own memory and Stream Multiprocessor (SM).

NVIDIA supports other partitioning techniques, such as time-slicing and MPS. You can [manually apply these configurations](https://learn.microsoft.com/azure/aks/gpu-cluster?tabs=add-ubuntu-gpu-node-pool#:~:text=Skip%20GPU%20driver%20installation%20%28preview%29) using the NVIDIA GPU Operator.

For advanced scenarios, you can improve resource bin-packing on your nodes with the help of scheduler configurations and running a second scheduler. Learn more about configuring and maintaining a secondary scheduler that can use alternative workload placement strategies from the default AKS scheduler, see [Configure Multiple Schedulers on Kubernetes](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/).

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Steve Buchanan](https://www.linkedin.com/in/steveabuchanan/) | Principal Program Manager
- [Ally Ford](https://www.linkedin.com/in/allison-ford-pm/) | Product Manager 2
- [Sachi Desai](https://www.linkedin.com/in/sachi-desai/) | Product Manager
- [Erin Schaffer](https://www.linkedin.com/in/erin-schaffer-65800215b/) | Content Developer 2

_To see nonpublic LinkedIn profiles, sign in to LinkedIn._

## Next steps

- The AI toolchain operator (KAITO) is a managed add-on for AKS that simplifies the experience of running OSS AI models on your AKS clusters. For more information, see [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](/azure/aks/ai-toolchain-operator).
- For instructions on running GPU workloads on AKS, see:
    - [Use GPUs on Azure Kubernetes Service (AKS)](/azure/aks/gpu-cluster)
    - [Use GPUs for Windows node pools on Azure Kubernetes Service (AKS)](/azure/aks/use-windows-gpu)
- [Deploy an AI model on Azure Kubernetes Service (AKS) with the AI toolchain operator](/azure/aks/ai-toolchain-operator)
- [Deploy an application that uses OpenAI on Azure Kubernetes Service (AKS)](/azure/aks/open-ai-quickstart?tabs=aoai)
- [Deploy Kaito on AKS using Terraform](https://techcommunity.microsoft.com/t5/azure-for-isv-and-startups/deploy-kaito-on-aks-using-terraform/ba-p/4108930)
- [Bring Your Own AI Models to Intelligent Apps on AKS with Kaito](https://learn.microsoft.com/shows/learn-live/intelligent-apps-on-aks-ep02-bring-your-own-ai-models-to-intelligent-apps-on-aks-with-kaito)
- [Open-Source Models on AKS with Kaito](https://moaw.dev/workshop/?src=gh:pauldotyu/moaw/learnlive/workshops/opensource-models-on-aks-with-kaito)

## Related resources
See the following related guides:
- [Deploy Azure Machine Learning extension on AKS or Arc Kubernetes cluster](/azure/machine-learning/how-to-deploy-kubernetes-extension?view=azureml-api-2&tabs=deploy-extension-with-cli)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [Model Catalog and Collections on Azure](/azure/machine-learning/concept-model-catalog?view=azureml-api-2)
- 