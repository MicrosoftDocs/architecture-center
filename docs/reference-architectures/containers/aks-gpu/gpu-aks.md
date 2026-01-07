---
title: Use Azure Kubernetes Service to Host GPU-Based Workloads
description: Learn how to use Azure Kubernetes Service to host GPU-based workloads, including machine learning, deep learning, and high-performance computing (HPC) workloads.
author: sdesai345
ms.author: sachidesai
ai-usage: ai-assisted
ms.date: 12/17/2025
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.category:
  - containers
ms.collection: ce-skilling-ai-copilot
ms.custom:
  - arb-containers
  - arb-aiml

---

# Use Azure Kubernetes Service to host GPU-based workloads

This article describes how to efficiently run workloads that use graphics processing unit (GPU) nodes on an Azure Kubernetes Service (AKS) cluster. Learn how to choose the right SKU, use GPU nodes to train machine learning models, and use GPU nodes to run inference on AKS.

## Scenarios

GPU workloads can be expensive to run. To avoid unnecessary cost, know when to deploy GPU-based nodes in your AKS clusters.

GPUs are purpose-built for graphics, AI and machine learning, and specialized tasks, which makes them ideal for compute-intensive workloads. Central processing units (CPUs) effectively manage complex logic and branching. GPUs are optimized for throughput and efficiently handle basic arithmetic and vector operations.

To determine when to use GPUs for AKS workloads, you must understand GPU optimization, compute intensity, and other factors that affect performance. To gain better insight into GPU usage for AKS workloads, consider the following workload examples that benefit from GPU nodes in an AKS cluster.

### Data science and analytics

Use GPUs to accelerate data preprocessing, feature engineering, and model training in data science workflows. To use GPUs efficiently, frameworks like [RAPIDS](https://rapids.ai) and the GPU support in [Dask](https://docs.dask.org/en/stable/gpu.html) extend popular data processing libraries, like pandas and scikit-learn.

Open-source software (OSS)-accelerated SQL query engines and columnar databases like [HeavyDB](https://docs.heavy.ai/overview/overview#heavydb) use GPUs to perform queries and analytics on large datasets.

### Machine learning and deep learning

Popular machine learning and deep learning frameworks like [TensorFlow](https://www.tensorflow.org), [PyTorch](https://pytorch.org), [vLLM](https://docs.vllm.ai), and [Triton Inference Server](https://github.com/triton-inference-server/server) benefit from GPUs because they accelerate tasks that train models and run inference. For example, Azure Machine Learning supports high-performance model serving on a managed online endpoint by using [Triton Inference Server](/azure/machine-learning/how-to-deploy-with-triton).

Deep learning models use complex neural networks. Parallel processing on GPUs accelerates their computations. GPUs provide highly efficient matrix multiplication and convolution operations, which are fundamental operations in deep learning.

You can also use GPUs to accelerate tasks like image classification, object detection, natural language processing, and speech recognition.

### Computer vision and image processing

Computer vision tasks interpret visual data to extract meaningful information. These tasks appear in AI-powered applications like autonomous vehicles, medical imaging, surveillance systems, and augmented reality. GPUs use parallel processing to efficiently handle large-scale image data and complex computations for tasks like object detection, image classification, and feature extraction.

### Video processing and streaming

Workloads that transcode, encode, and stream video are compute intensive, especially if they have high-resolution content. GPUs provide an efficient platform for low-latency, high-throughput video processing across applications like sports event streams and corporate videos.

GPU-enabled agent nodes offload graphics-intensive tasks to the GPU in virtual desktop environments. Video encoding and decoding capabilities that use GPUs support real-time video streaming, transcoding, and analytics.

To accelerate computer vision tasks like object detection, object tracking, and image or video processing, use frameworks like [OpenCV](https://opencv.org), [OpenCL](https://www.khronos.org/opencl/), [NVIDIA CUDA](https://developer.nvidia.com/cuda/toolkit), and [NVIDIA cuDNN](https://developer.nvidia.com/cudnn).

Gaming platforms and cloud gaming services use GPUs to render high-resolution graphics and stream smooth gameplay over the internet.

### High-performance computing

High-performance computing (HPC) applications often require complex simulations, numerical analysis, and scientific computations. To run these tasks efficiently, you can use GPUs to parallelize the workload across multiple cores. Examples of HPC applications that need massive parallel-processing power include scientific simulations, weather forecasting, computational fluid dynamics, and molecular modeling. GPUs support parallel computations and accelerate HPC workloads. They also enhance performance across scientific and research computing.

To accelerate HPC applications, frameworks like NVIDIA CUDA, OpenCL, and [OpenACC](https://www.openacc.org) provide GPU-enabled APIs and libraries.

### Genomic analysis and bioinformatics

Health and life sciences workloads, like genomic analysis and bioinformatics applications, process genetic data, like DNA sequences and protein structures. They rely on complex algorithms to align sequences, call variants, and mine genomic data. GPUs accelerate genomic analysis workflows so that researchers can process data and uncover insights quickly.

### Generative AI models

Language models like [OpenAI GPT](https://platform.openai.com/docs/models), [Meta Llama](https://www.llama.com), [Falcon](https://falconllm.tii.ae), and [Phi open models](https://azure.microsoft.com/products/phi/) can take advantage of GPU parallel-processing capabilities. Use GPUs to run these models and improve performance.

GPUs accelerate training and inference tasks, which involve complex computations and large amounts of data. GPUs have parallel-processing capabilities that divide the large computational tasks of a given model into smaller subtasks that run concurrently. This process reduces latency and improves performance.

Language models often have complex neural networks with several layers and parameters, which can increase computational demand. GPUs accelerate key operations in language processing, like matrix multiplication and convolutions, which reduces the time required for training and inference.

GPUs provide sufficient memory capacity, bandwidth, and processing power to handle language model-based applications that have conversational interfaces and generate text. For example, GPU enhancements provide low-latency responses for users who interact with chatbots and AI assistants.

Not all workloads benefit from GPU-enabled agent nodes. In some cases, CPUs are sufficient. For example, workloads that are primarily input and output-bound or don't require heavy computation might not benefit from GPUs.

## Customer stories

Many Microsoft customers take advantage of GPU workloads to innovate for their customers. Consider the following examples:

- [Royal Bank of Canada (RBC) accelerates inference at scale by using the AI toolchain operator and GPUs on AKS](https://ignite.microsoft.com/sessions/6322e0f4-63f1-4e57-b311-d230e1f63995)
- [NBA players improve performance with AI on Azure AI infrastructure](https://www.microsoft.com/customers/story/1769559716293357869-nba-azure-kubernetes-service-media-and-entertainment-en-united-states?msockid=0495d219989b64dc145fc4a799fd65d1)
- [An AI company called Mr. Turing uses AI and AKS to make company information searchable](https://www.microsoft.com/customers/story/1696908458386008536-misterturing-azure-kubernetes-service-brazil?msockid=0495d219989b64dc145fc4a799fd65d1)

## GPU workload deployment best practices

AKS provides various options to deploy GPU-enabled Linux and Windows node pools and workloads.

### Linux workload deployment

- Create a node pool that has a supported GPU-enabled virtual machine (VM) that uses [NVIDIA GPUs](/azure/aks/use-nvidia-gpu) or [AMD GPUs](/azure/aks/use-amd-gpus). Follow the GPU vendor guidance to install the associated Kubernetes device plugin. This method doesn't let you update an existing node pool to add GPUs.

- Understand the limitations when you use an Azure Linux GPU-enabled node pool. AKS doesn't apply automatic security patches, and the default behavior for the cluster is *unmanaged*.

- Use Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity), and [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) when you schedule workloads on your GPU-enabled node pools.

### Windows workload deployment

- Create a node pool by using a [supported GPU-enabled VM](/azure/aks/use-windows-gpu). This approach creates a GPU-enabled Windows node pool. AKS [automatically installs the drivers and Kubernetes device plugin](/azure/aks/use-windows-gpu#using-windows-gpu-with-automatic-driver-installation). This method doesn't let you update an existing node pool to add GPUs.

  When you select a supported GPU-enabled VM, AKS automatically installs the required NVIDIA CUDA or GRID driver. Some workloads depend on a specific driver, which can affect your deployment. For NC-series and ND-series VM sizes, AKS installs the CUDA driver. For NV-series VM sizes, AKS installs the GRID driver.

- Understand the limitations when you use a Windows node pool.

- Use Kubernetes node selectors, node affinity, and taints and tolerations when you schedule workloads on your GPU-enabled node pools.

> [!NOTE]
> Windows GPU is a preview feature. You need to [register the WindowsGPUPreview feature flag](/azure/aks/use-windows-gpu#register-the-windowsgpupreview-feature-flag).

### NVIDIA GPU Operator

Use the [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html) to deploy and manage GPU resources in Kubernetes clusters. The operator automates the installation, configuration, and maintenance of required software components. This approach helps ensure optimal use of NVIDIA GPUs for resource-intensive workloads, like AI and machine learning.

The NVIDIA GPU Operator automatically manages the NVIDIA software components that you need to deploy GPUs, like the [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin) and the NVIDIA container runtime. The operator automatically installs the driver. For more information, see [NVIDIA GPU Operator overview](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/overview.html).

If you want improved control and flexibility for advanced GPU workloads, use the [NVIDIA GPU Operator with your GPU-enabled nodes on AKS](/azure/aks/nvidia-gpu-operator). The operator doesn't support Windows GPUs.

Consider the following best practices:

- Use the NVIDIA GPU Operator to do advanced GPU configurations, like driver version selection and GPU time-slicing.

- [Skip the automatic driver installation](/azure/aks/use-nvidia-gpu#skip-gpu-driver-installation) before you use the operator.

- Set the minimum count to 1 when you use the operator with the cluster autoscaler.

> [!NOTE]
> Microsoft doesn't support or manage the maintenance and compatibility of the NVIDIA drivers as part of the node image deployment when you use the NVIDIA GPU Operator. For more information, see [GPU best practices for AKS](/azure/aks/best-practices-gpu).

### GPU workload deployment for language models

The [AI toolchain operator](/azure/aks/ai-toolchain-operator) simplifies how you run open-source language models, like [Falcon](https://huggingface.co/tiiuae), on your Kubernetes cluster. You can deploy the AI toolchain operator on your AKS cluster as a managed feature for [AKS](/azure/aks/intro-kubernetes). The AI toolchain operator uses [Karpenter](https://karpenter.sh/) to automatically provision and deploy GPU nodes based on a specification in the workspace custom resource definition of your chosen model. The AI toolchain operator creates the inference server as an endpoint for your language model and reduces onboarding time so that you focus on machine learning operations instead of infrastructure setup and maintenance.

To improve AI operations on AKS, the AI toolchain operator provides the following capabilities:

- **Manages container images:** Use container images to manage language models. The AI toolchain operator provides an HTTP server so that you can use [preset model workspaces](https://github.com/kaito-project/kaito/tree/main/examples/inference) to perform inference, call tools, and use the Model Context Protocol (MCP).

- **Supports bring-your-own (BYO) models:** Use the AI toolchain operator to bring in-house, pretrained language models by using a [custom deployment template](https://kaito-project.github.io/kaito/docs/custom-model) and HuggingFace Transformers for inference.

- **Configures GPU hardware:** The AI toolchain operator automatically applies preset configurations based on model requirements. You don't need to manually tune deployment parameters to fit GPU hardware or troubleshoot costly GPU out-of-memory (OOM) errors.

- **Provides built-in inference monitoring:** When you deploy a model by using the default vLLM inference engine, the [AI toolchain operator surfaces real-time vLLM metrics](/azure/aks/ai-toolchain-operator-monitoring) via Prometheus and Grafana and exposes metrics about inference performance and health in your AKS cluster.

For more information about the AI toolchain operator, see the following resources:

- [Explore the AI toolchain operator open-source project](https://kaito-project.github.io/kaito/docs/)
- [Fine-tune your language models by using the AI toolchain operator](/azure/aks/ai-toolchain-operator-fine-tune)
- [Deploy a language model that supports tool calling](/azure/aks/ai-toolchain-operator-tool-calling)
- [Connect to an MCP server by using the AI toolchain operator](/azure/aks/ai-toolchain-operator-mcp)

## Workload and cluster scaling

For AI and machine learning scenarios, you must differentiate between training workloads and inferencing with pretrained models. To build and train a machine learning model, use GPU compute designed for deep learning and parallelize AI computations. Training often requires you to scale GPU resources gradually and distribute large quantities of data across GPUs to achieve high accuracy through data parallelism.

Model sharding is a common advanced technique for dividing stages of model training. You can assign GPUs to distinct tasks and maximize their use by enabling [multiple-instance GPU (MIG)](/azure/aks/gpu-multi-instance) on NVIDIA GPU node pools in AKS. GPUs can scale up and scale out HPC workloads, like NV-series or ND-series VMs on Azure. This capability helps maintain high resource usage and reduce user intervention for machine learning training processes that are lengthy and expensive.

Alternatively, you can use pretrained, open-source AI and machine learning models for inference. Start with popular models like Llama, Falcon, or Phi as a more cost-effective option than building and training a fully custom language model. For more information, see [Language models on AKS](/azure/aks/concepts-ai-ml-language-models).

When you use pretrained models for inference, resource usage can fluctuate based on the volume of data that you process. When you run live data through your chosen model, traffic can spike depending on the model size and requirements. Maintain low latency throughout the inference process. To use your GPUs effectively for high performance and low latency, conduct distributed inference by using models that the AI toolchain operator supports. This approach expands your compute options to include lower GPU-count SKUs that have one or two GPUs each, provides high availability across Azure regions, and reduces maintenance costs.

## GPU health monitoring

GPU problems can be difficult to detect and often cause silent errors or degrade performance instead of failing outright. These problems add time to troubleshoot, consume resources unnecessarily, and increase operational costs.

[GPU health monitoring on AKS](/azure/aks/node-problem-detector) provides consistent and frequent checks of node events and conditions. Node Problem Detector (NPD) reports these events on specific GPU VM sizes. NPD surfaces key signals like incorrect GPU count or network connectivity faults directly into Kubernetes node conditions, which helps teams identify and respond to problems. This approach supports automated alerting, node cordoning, and workload rescheduling. It also helps maintain application reliability and performance in compute-intensive environments.

## GPU workload cost management

GPUs can increase cost. Monitor workloads to understand what drives GPU costs and identify optimization opportunities. To increase cost visibility, use the [AKS cost analysis tool](/azure/cost-management-billing/costs/quick-acm-cost-analysis).

The following scenarios benefit from cost visibility.

### GPU-enabled VM size cost

Select the right GPU-enabled VM size to optimize the cost to run GPUs. Daily costs can vary depending on the VM size that you choose. A100 GPUs are costly, so avoid them unless your workload requires them. AKS cost analysis shows the daily cost for each of your VMs and shows the associated costs of each workload that runs on the GPU-enabled VM. Use this data to evaluate whether you have an appropriate VM size or if you need a more cost-effective option.

### Idle cost

After you create a GPU-enabled node pool, you incur costs on the Azure resource even if you don't run a GPU workload. Idle costs represent the cost of available resource capacity that workloads don't use. These costs can add up quickly if you have several unused nodes. To avoid high idle costs, create node pools only when you run a workload, and use methods like the [cluster stop feature](/azure/aks/start-stop-cluster) when you don't run a workload. AKS cost analysis shows idle costs for each of your nodes.

### Overprovisioning and underuse

Overprovisioning is when you allocate more resources than necessary for a pod. Overprovisioning leads to resource waste and underuse. The node continues to reserve excess resources even if workloads don't use them. To reduce overprovisioning, use the [vertical pod autoscaler](/azure/aks/vertical-pod-autoscaler) to set accurate requests and limits based on previous usage patterns.

Underuse can occur when your workloads don't use GPUs fully. Consider advanced techniques to share and partition GPUs. Instead of deploying multiple nodes, you can use a single node with partitions to maximize GPU usage. These techniques help you allocate the appropriate amount of GPU acceleration for each workload, which can enhance usage and lower the operational costs of deployment.

Linux GPU workload deployments on AKS support multiple-instance GPUs. Use this feature to partition NVIDIA A100 and H100 GPUs into up to seven independent instances. Each instance has its own memory and stream multiprocessor.

NVIDIA supports other partitioning techniques, like time-slicing and Multi-Process Service (MPS). To manually apply these configurations, use the NVIDIA GPU Operator.

For advanced scenarios, you can improve resource bin packing on AKS nodes and optimize the utilization of GPU resources in your cluster. You can set scheduler configurations by using one or more built-in (or *in-tree*) Kubernetes scheduling plugins to introduce workload placement strategies that differ from the default AKS scheduler. For more information, see [Scheduler configuration concepts for workload placement in AKS (preview)](/azure/aks/concepts-scheduler-configuration).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager

Other contributors:

- [Sachi Desai](https://www.linkedin.com/in/sachi-desai/) | Product Manager 2
- [Ally Ford](https://www.linkedin.com/in/allison-ford-pm/) | Product Manager 2
- [Erin Schaffer](https://www.linkedin.com/in/erin-schaffer-65800215b/) | Content Developer 2

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Bring your own AI models to intelligent apps on AKS by using the AI toolchain operator](/shows/learn-live/intelligent-apps-on-aks-ep02-bring-your-own-ai-models-to-intelligent-apps-on-aks-with-kaito)
- [Deploy the AI toolchain operator on AKS by using Terraform](https://techcommunity.microsoft.com/t5/azure-for-isv-and-startups/deploy-kaito-on-aks-using-terraform/ba-p/4108930)

## Related resource

- [Baseline architecture for an AKS cluster](../aks/baseline-aks.yml)
