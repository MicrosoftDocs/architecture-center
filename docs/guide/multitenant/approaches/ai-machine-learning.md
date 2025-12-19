---
title: Architectural Approaches for AI and Machine Learning in Multitenant Solutions
description: Learn approaches for AI and machine learning multitenancy, including tenant isolation, model training, inference, and how to use Azure AI services.
author: PlagueHO
ms.author: dascottr
ms.date: 07/28/2025
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-saas
---

# Architectural approaches for AI and machine learning in multitenant solutions

An ever-increasing number of multitenant solutions are built around AI and machine learning. A multitenant AI and machine learning solution provides uniform machine learning-based capabilities to any number of tenants. Tenants generally can't see or share the data of any other tenant, but in some cases, tenants might use the same models as other tenants.

Multitenant AI and machine learning architectures need to consider the requirements for data and models. These architectures also need to account for the compute resources required to train models and perform inference. It's important to consider how multitenant AI and machine learning models are deployed, distributed, and orchestrated, and to ensure that your solution is accurate, reliable, and scalable.

Generative AI technologies powered by both large and small language models continue to gain popularity. As a result, organizations must establish effective operational practices and strategies for managing these models in production environments by adopting machine learning operations (MLOps) and generative AI operations (GenAIOps), sometimes known as *LLMOps*.

## Key considerations and requirements

When you work with AI and machine learning, it's important to separately consider your requirements for *training* and for *inference*. The purpose of training is to build a predictive model that's based on a set of data. You perform inference when you use the model to predict something in your application. Each of these processes has different requirements. In a multitenant solution, you should consider how your [tenancy model](../considerations/tenancy-models.md) affects each process. By considering each of these requirements, you can ensure that your solution provides accurate results, performs well under load, is cost-efficient, and can scale for future growth.

### Tenant isolation

Ensure that tenants don't gain unauthorized or unwanted access to the data or models of other tenants. Treat models with a similar sensitivity to the raw data that trains them. Ensure that your tenants understand how their data is used to train models and how models trained on other tenants' data might be used for inference purposes on their workloads.

The three common approaches for working with machine learning models in multitenant solutions are tenant-specific models, shared models, and tuned shared models.

#### Tenant-specific models

Tenant-specific models are trained only on the data for a single tenant and then they're applied to that single tenant. Use tenant-specific models when your tenants' data is sensitive or when you can't effectively apply insights from one tenant's data to another tenant. The following diagram illustrates how you might build a solution with tenant-specific models for two tenants.

:::image type="complex" border="false" source="media/ai-ml/tenant-specific-models.svg" alt-text="Diagram that shows two tenant-specific models. Each model is trained with data from a single tenant." lightbox="media/ai-ml/tenant-specific-models.svg":::
   The diagram shows two horizontally aligned workflows labeled Tenant A and Tenant B. Each workflow begins with a blue cylindrical icon labeled Tenant A data or Tenant B data. A rightward arrow connects each data icon to a rectangular box labeled Training. Another rightward arrow labeled Produces points from the Training box to a box labeled Tenant A model or Tenant B model. From the right side of each model box, an arrow labeled Users points from a box labeled Inference to the Tenant model. A downward arrow labeled Triggers that has a lightning bolt icon connects the user icon to the Inference box. From the Inference box, a rightward arrow labeled Produces points to a box labeled Model output. A final arrow loops back from the Model output box to the user icon. The Microsoft Azure logo appears in the bottom left corner of the diagram.
:::image-end:::

#### Shared models

In solutions that use shared models, all tenants perform inference based on the same shared model. Shared models might be pretrained models that you acquire or obtain from a community source. The following diagram illustrates how all tenants can use a single pretrained model for inference.

:::image type="complex" border="false" source="media/ai-ml/shared-pretrained-models.svg" alt-text="Diagram that shows a single pretrained model. The model is used for inference by users from all tenants." lightbox="media/ai-ml/shared-pretrained-models.svg":::
   The diagram shows three rectangular boxes arranged horizontally from left to right labeled Pretrained model, Inference, and Model output. An arrow labeled Users points from the Inference box to the Pretrained model box. Above the Inference box is a user icon labeled All tenants' users. A downward arrow labeled Triggers connects the user icons to the Inference box. A rightward arrow labeled Produces points from the Inference box to the Model output box. A final arrow loops from the top of the Model output box back to the user icons.  The Microsoft Azure logo appears in the bottom left corner.
:::image-end:::

You also can build your own shared models by training them from the data that all your tenants provide. The following diagram illustrates a single shared model, which is trained on data from all tenants.

:::image type="complex" border="false" source="media/ai-ml/shared-tenant-trained-models.svg" alt-text="Diagram that shows a single shared model that's trained on the data from multiple tenants. The model is used for inference by users from all tenants." lightbox="media/ai-ml/shared-tenant-trained-models.svg":::
   The diagram shows two blue cylindrical icons labeled Tenant A data and Tenant B data. Both icons connect with arrows to a single rectangular box labeled Training. A rightward arrow labeled Produces points from the Training box to a rectangular box labeled Global model. A leftward arrow labeled Users points from a box labeled Inference to the Global model box. A downward arrow labeled Triggers points from All tenants' users to the Inference box. A rightward arrow labeled Produces points from the Inference box to a rectangular box labeled Model output. The Microsoft Azure logo appears in the bottom left corner.
:::image-end:::

> [!IMPORTANT]
>
> If you train a shared model from your tenants' data, ensure that your tenants understand and agree to the use of their data. Ensure that identifying information is removed from your tenants' data.
>
> Consider what to do if a tenant objects to their data being used to train a model that serves another tenant. For example, if a tenant objects to their data being used to train a model that serves another tenant, you might need to exclude that tenant's data from the training dataset.

#### Tuned shared models

You also might choose to acquire a pretrained base model, and then perform further model tuning to make it applicable to each of your tenants based on their own data. The following diagram illustrates this approach.

:::image type="complex" border="false" source="media/ai-ml/specialized-shared-models.svg" alt-text="Diagram that shows a pretrained base model that's specialized for each tenant, with their own data." lightbox="media/ai-ml/specialized-shared-models.svg":::
   The diagram shows two parallel workflows for Tenant A and Tenant B arranged vertically. Each workflow begins with a blue cylindrical icon labeled Tenant A data or Tenant B data. A rightward arrow connects each data icon to a rectangular box labeled Tuning for tenant A or Tuning for tenant B. Both tuning boxes connect to a shared rectangular box in the center labeled Pretrained base model. From the tuning boxes, rightward arrows labeled Produces point to separate boxes labeled Tenant A model and Tenant B model. Leftward arrows labeled Users point from boxes labeled Inference to each model box. Above each inference box is a user icon labeled Tenant A's users or Tenant B's users that has a downward arrow and lightning bolt icon labeled Triggers that points to the inference box. Rightward arrows labeled Produces connect each inference box to a final box labeled Model output. The model output boxes point to the Tenant users boxes. Microsoft Azure logo appears in the bottom left corner.
:::image-end:::

### Scalability

Consider how the growth of your solution affects your use of AI and machine learning components. Growth can refer to an increase in the number of tenants, the amount of data stored for each tenant, the number of users, and the volume of requests to your solution.

**Training:** There are several factors that influence the resources that are required to train your models. These factors include the number of models that you need to train, the amount of data that you use to train the models, and the frequency at which you train or retrain models. If you create tenant-specific models, then as your number of tenants grows, the amount of compute resources and storage that you require also likely grows. If you create shared models and train them by using data from all of your tenants, the training resources typically don't scale at the same rate as tenant growth. However, as the overall amount of training data increases, it affects the resources consumed to train both shared and tenant-specific models.

**Inference:** The resources that are required for inference are often proportional to the number of requests that access the models for inference. As the number of tenants increases, the number of requests is also likely to increase.

It's a good general practice to use Azure services that scale well. Because AI and machine learning workloads tend to make use of containers, Azure Kubernetes Service (AKS) and Azure Container Instances tend to be common choices for AI and machine learning workloads. AKS is often a good choice to enable high scale and to dynamically scale your compute resources based on demand. You can use Container Instances for small workloads. It's relatively easy to configure but doesn't scale as easily as AKS.

### Performance

Consider the performance requirements for the AI and machine learning components of your solution, including both training and inference. Clearly define the latency and performance expectations for each process so that you can measure and improve them as needed.

**Training:** Training is often performed as a batch process, which means that it might not be as performance-sensitive as other parts of your workload. However, you need to ensure that you provision sufficient resources to perform your model training efficiently, including as you scale.

**Inference:** Inference is a latency-sensitive process that often requires a fast or even real-time response. Even if you don't need to perform inference in real time, ensure that you monitor the performance of your solution and use the appropriate services to optimize your workload.

Consider using Azure high-performance computing capabilities for your AI and machine learning workloads. Azure provides many different types of virtual machines and other hardware instances. Consider whether your solution can benefit from using CPUs, GPUs, field-programmable gate arrays (FPGAs), or other hardware-accelerated environments. Azure also provides real-time inference with NVIDIA GPUs, including NVIDIA Triton Inference Server. For low-priority compute requirements, consider using [AKS spot node pools](/azure/aks/spot-node-pool). For more information about how to optimize compute services in a multitenant solution, see [Architectural approaches for compute in multitenant solutions](compute.md).

Model training typically requires many interactions with your data stores, so it's also important to consider your data strategy and the performance that your data tier provides. For more information about multitenancy and data services, see [Architectural approaches for storage and data in multitenant solutions](storage-data.md).

Consider profiling your solution's performance. For example, [Azure Machine Learning provides profiling capabilities](/azure/machine-learning/how-to-deploy-profile-model) that you can use when you develop and instrument your solution.

### Implementation complexity

When you build a solution to use AI and machine learning, you can use prebuilt components or build custom components. You must make two key decisions. First, select the *platform or service* to use for AI and machine learning. Second, decide whether to use pretrained models or build your own custom models.

**Platforms:** There are many Azure services that you can use for your AI and machine learning workloads. For example, Microsoft Foundry provides APIs to perform inference against prebuilt models, and Microsoft manages the underlying resources. Foundry enables you to quickly deploy a new solution, but it limits control over training and inference processes and might not suit every type of workload. In contrast, Machine Learning is a platform that enables you to build, train, and use your own machine learning models. Machine Learning provides control and flexibility, but it increases the complexity of your design and implementation. Review the [machine learning products and technologies from Microsoft](../../../ai-ml/guide/data-science-and-machine-learning.md) to make an informed decision when you select an approach.

**Models:** Even when you don't use a full model that a service like Foundry provides, you can still use a pretrained model to accelerate your development. If a pretrained model doesn't precisely suit your needs, consider extending a pretrained model by applying a technique known as *fine-tuning* or *transfer learning*. Fine-tuning enables you to extend an existing model and apply it to a different domain. For example, if you build a multitenant music recommendation service, you might consider starting from a pretrained model of music recommendations and use fine-tuning to train the model for a specific user's music preferences.

By using a prebuilt machine learning platform like Foundry or a pretrained model, you can significantly reduce your initial research and development costs. The use of prebuilt platforms might save you many months of research and avoid the need to recruit highly qualified data scientists to train, design, and optimize models.

### Cost optimization

Generally, AI and machine learning workloads incur the greatest proportion of their costs from the compute resources that are required for model training and inference. For more information about how to optimize the cost of your compute workload for your requirements, see [Architectural approaches for compute in multitenant solutions](compute.md).

Consider the following requirements when you plan your AI and machine learning costs:

- **Determine compute SKUs for training and inference.** You might use different SKUs for training and for inference. Select SKUs that meet your requirements for performance and cost, and that are available in the regions you use. For more information, see [Compute recommendations for AI workloads on Azure infrastructure (IaaS)](/azure/cloud-adoption-framework/scenarios/ai/infrastructure/compute).

- **Monitor your usage.** By observing the usage of your compute resources, you can determine whether you should decrease or increase their capacity by deploying different SKUs, or scale the compute resources as your requirements change. For more information, see [Monitor Machine Learning](/azure/machine-learning/monitor-azure-machine-learning).

- **Optimize your compute clustering environment.** When you use compute clusters, monitor cluster usage or configure [autoscaling](/python/api/azureml-core/azureml.core.compute.amlcompute.scalesettings) to scale down compute nodes.  

- **Share your compute resources.** Consider whether you can optimize the cost of your compute resources by sharing them across multiple tenants.

- **Consider your budget.** Understand whether you have a fixed budget and monitor your consumption accordingly. You can [set up budgets](/azure/machine-learning/concept-plan-manage-cost#create-budgets) to prevent overspending and to allocate quotas based on tenant priority.

## Approaches and patterns to consider

Azure provides a set of services to enable AI and machine learning workloads. There are several common architectural approaches used in multitenant solutions:

- Use prebuilt AI and machine learning solutions.

- Build a custom AI and machine learning architecture by using Machine Learning.

- Use one of the Azure analytics platforms.

### Use prebuilt AI and machine learning services

It's a good practice to try to use prebuilt AI and machine learning services when you can. For example, your organization might be starting to explore AI and machine learning and want to quickly integrate with a useful service. Or you might have basic requirements that don't require custom machine learning model training and development. Prebuilt machine learning services enable you to use inference without building and training your own models.

Azure has several services that provide AI and machine learning technology across a range of domains. These domains include language understanding, speech recognition, knowledge, document and form recognition, and computer vision. Azure delivers prebuilt AI and machine learning services through [Foundry](https://azure.microsoft.com/products/ai-foundry), which is a unified AI application service. This service gives users access to various models, including [Azure OpenAI in Foundry Models](https://azure.microsoft.com/products/ai-services/openai-service). Azure also provides a set of standalone AI services, including [Azure AI Search](/azure/search/search-what-is-azure-search) and [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence). Each service provides a simple interface for integration and a collection of pretrained and tested models. As managed services, they provide service-level agreements and require little configuration or ongoing management. You don't need to develop or test your own models to use these services.

Many managed machine learning services don't require model training or data, so there's usually no tenant data isolation concerns. However, some managed AI and machine learning services do provide a model customization capability:

- [Azure custom voice](/azure/ai-services/speech-service/custom-neural-voice)
- [Automated ML (AutoML) in Azure Machine Learning](/azure/machine-learning/concept-automated-ml)
- [Face API](/azure/ai-services/computer-vision/how-to/add-faces)
- [Document Intelligence custom models](/azure/ai-services/document-intelligence/concept-custom)
- [Azure OpenAI models that support customization and fine-tuning](/azure/ai-services/openai/how-to/fine-tuning)

When you work with these services, it's important to consider the [isolation requirements](#tenant-isolation) for your tenants' data.

Consider the scale requirements for the components in your solution. For example, many of the APIs within Azure AI services support a maximum number of requests per second. If you deploy a single AI services resource to share across your tenants, then as the number of tenants increases, you might need to [scale to multiple resources](resource-organization.md).

### Custom AI and machine learning architecture

If your solution requires custom models or operates in a domain that isn't covered by a managed machine learning service, then consider building your own AI and machine learning architecture. [Machine Learning](/azure/machine-learning) provides a suite of capabilities to orchestrate the training and deployment of machine learning models:

- Use various open-source machine learning libraries, including [PyTorch](https://azure.microsoft.com/develop/pytorch), [TensorFlow](/azure/machine-learning/how-to-train-tensorflow), [Scikit](/azure/machine-learning/how-to-train-scikit-learn), and [Keras](/azure/machine-learning/how-to-train-keras).

- Monitor models' performance metrics continuously.

- Detect *data drift*, which is when model input data changes over time.

- Trigger retraining to improve model performance.

- Apply auditability and governance throughout the life cycle of your machine learning models. Use built-in tracking and lineage (which is the tracking of data and model relationships) for all your machine learning artifacts.

When you work in a multitenant solution, it's important to consider the [isolation requirements of your tenants](#tenant-isolation) during both the training and inference stages. You also need to determine your model training and deployment process. Machine learning provides a pipeline to train models and deploy them to an environment for inference. This process enables models to generate predictions or insights based on new data. In a multitenant context, consider whether models should be deployed to shared compute resources or if each tenant has dedicated resources. Design your model deployment pipelines based on your [isolation model](../considerations/tenancy-models.md) and your [tenant deployment process](deployment-configuration.md).

When you use open-source models, you might need to retrain these models by using transfer learning or tuning. Consider how to manage different models and training data for each tenant, along with the versions of each model.

The following diagram illustrates an example architecture that uses Machine Learning. Alternatively, you can leverage Microsoft Fabric Data Science experience, which provides capabilities such as experiments, model management, and endpoint deployment. The example uses the [tenant-specific models](#tenant-specific-models) isolation approach.

:::image type="complex" border="false" source="media/ai-ml/approach-azure-machine-learning.svg" alt-text="Diagram that shows an architecture that uses Machine Learning." lightbox="media/ai-ml/approach-azure-machine-learning.svg":::
   The diagram shows a large box on the left labeled Azure Machine Learning workspace. Inside this box are three sections labeled Projects, Experiments, and Data plane. Three arrows extend from the Data plane section to three separate boxes labeled Tenant A model, Tenant B model, and Tenant C model. Each tenant model box connects via an arrow that points from a central box labeled Azure Machine Learning compute. An arrow points from a box labeled Shared API that contains an icon with interlinked green and blue chains to the Azure Machine Learning compute box. Three arrows extend from three groups of user icons labeled Tenant A users, Tenant B users, and Tenant C users and point to the Shared API box. Microsoft Azure logo appears in the bottom left corner.
:::image-end:::

### Integrated AI and machine learning solutions

Azure provides several powerful analytics platforms that can be used for various purposes. These platforms include [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview), [Azure Databricks](/azure/databricks/scenarios/ml/), and [Apache Spark](/fabric/data-science/).

You can consider using these platforms for AI and machine learning when you need to scale your capabilities to support a high volume of tenants and require large-scale compute and orchestration. You might also consider using these platforms when you need a broad analytics solution for other parts of your system, such as data analytics and integration with reporting through Power BI. You can deploy a single platform that supports all of your analytics and AI and machine learning needs. When you implement data platforms in a multitenant solution, review [Architectural approaches for storage and data in multitenant solutions](storage-data.md).

## Machine learning operational model

When you adopt AI and machine learning, including generative AI practices, it's a good practice to continually improve and assess your organizational capabilities in managing them. The introduction of MLOps and GenAIOps objectively provides a framework to continually expand capabilities of your AI and machine learning practices in your organization. For more information, see [MLOps maturity model](../../../ai-ml/guide/mlops-maturity-model.md) and [GenAIOps maturity model](/azure/machine-learning/prompt-flow/concept-llmops-maturity).

## Antipatterns to avoid

- **Failure to consider isolation requirements:** It's important to carefully consider how you [isolate tenants' data and models](#tenant-isolation) for both training and inference. Failing to isolate tenants' data and models might violate legal or contractual requirements. It also might reduce the accuracy of your models to train across multiple tenants' data if the data is substantially different.

- **Noisy neighbors:** Consider whether your training or inference processes might be subject to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). For example, if you have several large tenants and a single small tenant, ensure that the model training for the large tenants doesn't inadvertently consume all of the compute resources and deprive the smaller tenants. Use resource governance and monitoring to mitigate the risk that the activity of other tenants affects a tenant's compute workload.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Kevin Ashley](https://www.linkedin.com/in/kashlik/) | Senior Customer Engineer, FastTrack for Azure

Other contributors:

- [Paul Burpo](https://www.linkedin.com/in/paul-burpo/) | Principal Customer Engineer, FastTrack for Azure
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Vic Perdana](https://www.linkedin.com/in/vperdana/) | ISV Partner Solution Architect
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Solution Architect
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure
- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [A solution for machine learning pipelines in a multitenant environment](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/a-solution-for-ml-pipeline-in-multi-tenancy-manner/ba-p/4124818)

## Related resource

- [Architectural approaches for compute in multitenant solutions](compute.md)
