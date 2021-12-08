---
title: Cost for AI + Machine Learning services
description: Develop cost estimates and strategies for serverless technologies using Azure Machine Learning, Azure Cognitive Services, or Azure Bot Service.
author: PageWriter-MSFT
ms.date: 09/02/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-machine-learning
ms.custom:
  - article
categories:
  - ai-machine-learning
---

# AI + Machine Learning cost estimates

The main cost driver for machine learning workloads is the compute cost. Those resources are needed to run the training model and host the deployment. For information about choosing a compute target, see [What are compute targets in Azure Machine Learning?](/azure/machine-learning/concept-compute-target).

The compute cost depends on the cluster size, node type, and number of nodes. Billing starts while the cluster nodes are starting, running, or shutting down.

With services such as [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning), you have the option of creating fix-sized clusters or use autoscaling.
> ![Task](../../_images/i-best-practices.svg) If the amount of compute is not known, start with a zero-node cluster. The cluster will scale up when it detects jobs in the queue. A zero-node cluster is not charged.

Fix-sized clusters are appropriate for jobs that run at a constant rate and the amount of compute is known and measured beforehand. The time taken to spin up or down a cluster incurs additional cost.
> ![Task](../../_images/i-best-practices.svg) If you don't need retraining frequently, turn off the cluster when not in use.

To lower the cost for experimental or development workloads, choose Spot VMs. They aren't recommended for production workloads because they might be evicted by Azure at any time. For more information, see [Use Spot VMs in Azure](/azure/virtual-machines/windows/spot-vms).

For more information about the services that make up a machine learning workload, see [What are the machine learning products at Microsoft?](../../data-guide/technology-choices/data-science-and-machine-learning.md).

This article provides cost considerations for some technology choices. This is not meant to be an exhaustive list, but a subset of options.

## Azure Machine Learning
Training models don't incur the machine learning service surcharge. You're charged for these factors.

- The cost is driven by compute choices, such as, the virtual machine sizes and the region in which they are available. If you can commit to one or three years, choosing reserved instances can lower cost. For more information, see [Reserved instances](./optimize-vm.md#reserved-vms).

- As part of provisioning Machine Learning resources,  additional resource are deployed such as [Azure Container Registry](https://azure.microsoft.com/services/container-registry/), [Azure Block Blob Storage](https://azure.microsoft.com/pricing/details/storage/blobs/), and [Key Vault](https://azure.microsoft.com/pricing/details/key-vault/). You're charged for as per the pricing of those individual services.

- If you deploy models to a Kubernetes Service cluster, Machine Learning adds a [surcharge](https://azure.microsoft.com/pricing/details/machine-learning-service/) on top of the Kubernetes Service compute cost. This cost can be lowered through autoscaling.

For more information, see these articles:
- [Machine Learning pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=machine-learning-service)
- [Azure Machine Learning](https://azure.microsoft.com/pricing/details/machine-learning/)

#### Reference architecture

-   [Training of Python scikit-learn and deep learning models on Azure](../../reference-architectures/ai/training-python-models.yml)
-   [Distributed training of deep learning models on Azure](../../reference-architectures/ai/training-deep-learning.yml)
-   [Batch scoring of Python machine learning models on Azure](../../reference-architectures/ai/batch-scoring-python.yml)
-   [Batch scoring of deep learning models on Azure](../../reference-architectures/ai/batch-scoring-deep-learning.yml)
-   [Real-time scoring of Python scikit-learn and deep learning models on Azure](../../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)
-   [Machine learning operationalization (MLOps) for Python models using Azure MachineLearning](../../reference-architectures/ai/mlops-python.yml)
-   [Batch scoring of R machine learning models on Azure](../../reference-architectures/ai/batch-scoring-r-models.yml)
-   [Real-time scoring of R machine learning models on Azure](../../reference-architectures/ai/realtime-scoring-r.yml)
-   [Batch scoring of Spark machine learning models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)
-   [Enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)
-   [Build a real-time recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)

## Azure Cognitive Services
The billing depends on the type of service. The charges are based on the number of transactions for each type of operation specific to a service. Certain number of transactions are free. If you need additional transactions, choose from the **Standard** instances. For more information, see
- [Cognitive services pricing calculator](https://azure.microsoft.com/pricing/calculator/)
- [Cognitive services pricing](https://azure.microsoft.com/pricing/details/cognitive-services/)
#### Reference architecture
[Build an enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)

## Azure Bot Service

The Azure Bot Service is a managed service purpose-built for enterprise-grade bot development. Billing is based on the number of messages. Certain number of messages are free. If you need to create custom channels, choose **Premium channels**, which can drive up the cost of the workload.

For a Web App Bot, an [Azure App Service](https://azure.microsoft.com/pricing/details/app-service/) is provisioned to host the bot. Also, an instance of [Application Insights](https://azure.microsoft.com/pricing/details/application-insights/) is provisioned. You're charged for as per the pricing of those individual services.

#### Reference architecture
[Enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)
