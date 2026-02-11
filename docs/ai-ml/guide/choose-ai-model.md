---
title: Choose the Right AI Model for Your Workload
description: Learn strategies to help you select the best model for your AI workload, including key criteria and practical considerations for decision-making.
author: claytonsiemens77
ms.author: csiemens
ms.date: 07/30/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---
# Choose the right AI model for your workload

In the rapidly evolving landscape of AI development, selecting the right model is both a foundational and strategic decision. Thousands of models are available for deployment, with more being developed and released regularly. This article focuses on strategies that you can use to improve the decision-making process.

> [!NOTE]
> If your chosen model meets your workload requirements, you can continue to use it. General-purpose models like GPT-5 can handle a wide range of tasks effectively. Continuing to use a proven model can save valuable development time compared to running a lengthy evaluation process.

## Key criteria for model selection

:::image type="complex" source="_images/choose-a-model.svg" alt-text="A decision tree flowchart for selecting AI models that shows a systematic filtering process." lightbox="_images/choose-a-model.svg" border="false":::
The diagram illustrates a decision tree for selecting AI models. It shows a step-by-step filtering process based on key criteria like task fit, cost, context window size, security, region availability, deployment strategy, domain specificity, performance, and tunability. The decision flow starts with task fit evaluation asking about standard task types, specialized task types, or custom domain needs. It then progresses through cost filtering with serverless versus managed compute options. Next comes availability filtering including region and data governance requirements. The process ends with comparison methods using benchmarks, evaluators, and playground testing. Each branch narrows the options and helps users systematically identify the most suitable AI model for their workload requirements, with final adaptation strategies for extending, replacing, or customizing models based on specific needs.
:::image-end:::

Several criteria can influence your model selection. Depending on your workload's unique characteristics and your organization's priorities, some criteria might be more important than others. Each criterion serves as a filter to reduce the thousands of available models to a more manageable set. The following list is ordered by general priority and starts with the factors that typically have the greatest impact.

### Task fit

Determine the purpose of the model, like chat, reasoning, embedding, retrieval-augmented generation (RAG), or multimodal processing.

When you select an AI model, choose a model that has capabilities that align with the specific task that you need it to do. Different models are optimized for different functions. Some models excel at natural language processing, like text classification and summarization. Convolutional neural networks (CNNs) are ideal for visual data, including image classification and object detection. Recurrent neural networks (RNNs) and transformers support audio analysis and speech recognition. Multimodal models handle tasks that combine text, image, or audio inputs. For example, GPT models are well-suited for text generation and understanding. To narrow your options and choose a model that delivers the best performance, accuracy, and efficiency for your use case, clearly define your task. Tasks include sentiment analysis, code generation, or real-time conversation.

#### Single model vs. multiple model considerations

When you consider task fit, factor in your workload application design. A single model that fulfills all task requirements works best for a simpler approach. Alternatively, you can structure the task into multiple steps that each use a model suited to its specific purpose. Multiple models are common in AI agent-based workload design, especially when you use [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns). For example, you might combine language understanding, reasoning, and retrieval. This modular approach enables greater flexibility, scalability, and adaptability, especially in dynamic environments where tasks evolve or require diverse capabilities.

Individually evaluate and select each model that you include in your workload. Apply the following considerations for each model.

### Cost constraints

Determine your budgetary limits for inference and deployment.

Consider cost considerations when you select an AI model, especially when you balance performance with budget constraints. High-performing models often require significant compute resources, which can increase infrastructure and operational costs, especially at scale. For workloads that have limited funding, open-source or pretrained models from cloud providers can be a cost-effective option that still meets performance requirements. Alternatively, workloads that have larger budgets might prefer proprietary models or custom training to promote higher precision and domain-specific capabilities. Align your model choice around a model that maximizes return on investment (ROI).

### Context window size

Determine the size of the context window required for your task.

When you select an AI model, the context window size should align with the complexity and length of the input data that you expect to work with. Generally speaking, larger, full-featured models have larger context windows. These models also require more compute resources and are typically slower in returning responses than smaller, specialized models. A larger context window lets the model consider more information at one time, like longer documents, extended conversations, or complex codebases, without losing track of earlier content. This capability is especially important for tasks that require coherent responses, understanding nuanced context, or referencing earlier parts of a conversation or document. Conversely, models that have smaller context windows might be faster or more cost effective and are best suited for shorter, more focused tasks.

### Security and compliance

Check whether the model meets your organization's security and compliance standards and requirements.

Select a model that aligns with your organization's security standards and regulatory obligations to mitigate risk and maintain trust. Organizations that operate in regulated industries, like healthcare, finance, or government, must ensure that their models comply with standards like General Data Protection Regulation (GDPR), Health Insurance Portability and Accountability Act (HIPAA), or California Consumer Privacy Act (CCPA). They must choose models that provide robust data protection, secure deployment options, and transparency in decision-making processes. Open-source models might provide greater interpretability and control, while proprietary models might provide stronger built-in safeguards and support for compliance certifications.

### Region availability

Check whether you can deploy the model in the same region as your other workload resources.

Limited regional availability can significantly influence AI model selection, especially when you consider latency, data residency, and compliance requirements. Some models are hosted only in specific geographic regions, which might affect performance for users in other locations because of increased response times. Workloads subject to regional data protection laws, like GDPR in Europe or CCPA in California, must ensure that the selected model complies with local regulations for data storage and processing.

### Deployment strategy

Check whether you can host the model on serverless or managed infrastructure, your own infrastructure, or directly on a device.

Models must be deployed on compute before they can be consumed. That compute can come from your cloud provider on shared infrastructure with other cloud customers, or it can be local to your workload, like running in process within your code. Some models available through a serverless platform from the provider, sometimes known as *models as a service (MaaS)*, are either too large or not licensed for deployment in your own compute. Your provider's hosting doesn't support some specialized models, so you can only run them in your own inferencing environment.

Your workload requirements constrain what the compute platform options are for each task. This constraint effectively restricts which models can be used based on where they can be deployed to meet efficiency, cost, and compliance requirements. Depending on the available hosting, you might also have a choice in SDK to run inferencing against that model. Some platforms provide a unified SDK that supports calling all hosted models. Other compute platforms require you to use the SDK built by the model's provider.

### Domain specificity

Check whether the model is pretrained on data that's relevant to your industry, like finance or healthcare.

An AI model that's pretrained on data relevant to your industry, like healthcare, finance, or legal, can provide significant advantages in accuracy, efficiency, and contextual understanding. These models are trained on domain-specific terminology, regulatory nuances, and typical workflows. This training reduces the need for extensive retraining and fine-tuning. As a result, they can deliver more precise predictions, generate more relevant content, and support faster deployment in real-world applications. Industry-specific pretraining also helps ensure compliance and improves trustworthiness, especially in fields that prioritize precision and reliability.

### Performance

Determine how fast and accurate your responses must be.

Every AI model has built-in performance limits, and how you host the model can introduce extra restrictions. Both the model and its hosting setup determine how fast it can respond and how many requests it can handle at one time. Depending on how your system or application uses the model, you must either choose a model that fits your system's requirements or adjust your system to match what the model can realistically handle.

You generally want to select a model that meets your quality standards while responding as quickly as possible. It should also be hosted in a way that supports the expected volume of requests without causing delays or degrading the user experience.

> [!NOTE]
> Some cross-cutting concerns, like implementing responsible AI policies, might introduce extra performance limitations. You should include these limitations in your evaluation, but they shouldn't influence your model choice.

### Model tunability

Determine how much customization you need.

Some AI models provide many hyperparameters that you can tune to meet your application needs. Examples include deep neural networks and gradient boosting machines. These models provide fine-grained control over parameters like learning rate and architecture, which makes them ideal for high-stakes tasks where accuracy is crucial. Alternatively, simpler models like linear regression or decision trees are easier to deploy and interpret, which makes them suitable for smaller datasets, real-time use cases, or teams that have limited machine learning experience. Tunability also affects generalization. Overly complex models risk overfitting, while simpler models might underfit but provide more stable performance. Also consider resource constraints because highly tunable models often require more training time, memory, and automated tuning tools.

### Other factors

The previous criteria are often closely aligned with your workload's functional and nonfunctional requirements. But other factors are sometimes relevant to your decision-making process. These factors are typically the lowest priority for most workloads, but your workload might assign greater importance to them in specific situations. The following factors can also influence model selection decisions:

- License type
- Multilingual capabilities
- Support plan (community or paid)
- Sustainability and environmental impact reporting
- Update life cycle (bug fixes and model revisions) and retirement strategy

## Noncriteria for model selection

Don't include the following factors in your decision-making because they rarely align with your workload's functional or nonfunctional requirements:

- Cultural popularity
- The publisher, like OpenAI, Meta, Microsoft, xAI, and others

### Refine your model selection

To help you apply the selection criteria efficiently, use a catalog like the catalogs in [Hugging Face](https://huggingface.co/models), [Foundry Models](https://ai.azure.com/explore/models), and [GitHub models](https://github.com/marketplace?type=models). These services provide filters that align with many of the previous decision criteria, like tasks, to help you reduce the number of models to choose from.

## Evaluation and benchmarking

To do a side-by-side AI model evaluation, start by defining a clear set of criteria based on your application's specific needs, like accuracy, speed, cost, context retention, and output quality. Then run candidate models on the same representative dataset or set of tasks to ensure consistent input and evaluation conditions. Compare the outputs both qualitatively and quantitatively by using metrics like relevance, coherence, latency, and user satisfaction. It's also helpful to involve stakeholders or users in the evaluation process to gather feedback on which model best aligns with real-world expectations. This structured approach helps you make an informed decision about which model is the best fit for your use case.

You can also use tools like Hugging Face benchmark collections to assess models for language support, reasoning, and safety. Consult multiple benchmarking sources to learn how specific models behave across a wide range of real-world scenarios. This approach reduces the risk of bias from any single model host.

Your model host might provide built-in evaluation tools on their platform, and we recommend that you take advantage of them. For more information, see [Evaluate generative AI models by using Microsoft Foundry](/azure/ai-foundry/how-to/evaluate-generative-ai-app).

## Fine-tuning and distillation

In many cases, you need to do some fine-tuning to train your model on your dataset. This requirement can influence your model choice because some models don't support fine-tuning. Distillation refers to using a model trained on your dataset to train another model that's often smaller and more specialized. This practice lets you build a more efficient workload by increasing performance and reducing costs. Like with fine-tuning, some models don't support distillation, so consider this requirement when you plan your workload design.

## Plan for model changes

Selecting a model isn't a one-time activity. In your proof of concept (POC) or prototype phase, you might choose a frontier model to expedite the build-out. When you move to production, a more specialized model or even a small language model might be a better fit. As your workload evolves, the model that you initially chose might not perform as expected, or your planned features might not align well with that model. To keep up with market advances, you might also need to regularly replace your model with newer releases. For more information about model life cycle considerations, see [Design to support foundation model life cycles](/azure/architecture/ai-ml/guide/manage-foundation-models-lifecycle).

To future-proof your architecture, consider the following derisking approaches:

- Use abstraction layers like the Azure AI Inference SDK to avoid vendor lock-in.

- Test models in parallel by switching environment variables and comparing outputs.

- Avoid opaque routing unless observability and traceability are guaranteed.

## Next steps

- [Explore Models](/azure/ai-foundry/concepts/foundry-models-overview)
- [Models and capabilities that Azure sells directly](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure)
