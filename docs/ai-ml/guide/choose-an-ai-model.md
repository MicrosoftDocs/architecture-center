---
title: Choose the right AI model for your workload
description: Learn strategies to help you select the best model for your AI workload
author: claytonsiemens77
ms.author: csiemens
ms.date: 07/30/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
---
# Choose the right model for your AI workload

In the rapidly evolving landscape of AI development, selecting the right model is both a foundational and strategic decision. There are thousands of models available to deploy with more being developed and released regularly. This article focuses on strategies that you can use to help make the decision making process more efficient.

> [!NOTE]
> If you have already chosen a model for your workload and it meets your requirements, staying with that model is a reasonable decision to make. Many general purpose models like GPT-5 are capable of performing many tasks very well, and using one instead of going through a lengthy evaluation process can save you time in your development.

## Key criteria for model selection

:::image type="complex" source="_images/choose-a-mode.png" alt-text="A decision tree flowchart for selecting AI models that shows a systematic filtering process starting from a model catalog and progressing through four main filter stages: Task Fit, Cost, Availability, and Comparison, ultimately leading to model selection and deployment.":::
The flowchart begins with "START" and "Start from Model Catalog" at the top. It then flows through four sequential purple filter boxes: "Filter by Task Fit," "Filter by Cost," "Filter by Availability," and "Select by Comparison." Under Task Fit are two gray boxes for "Standard Task Types" and "Specialized Task Types" with a "No Fit" path leading to a black "Custom Task or Domain" box that suggests using fine-tuning and loops back to "Restart Search." Under Cost are yellow boxes for "Serverless Options," "Managed Compute," and "Token Pricing," with a "No Match" path leading to "No Match for Your Budget" and back to restart. Under Availability are green boxes for "Region Availability" and "With Data Governance," with paths for requirements not being met. Under Comparison are pink boxes for "Explore Benchmarks," "Use Evaluators," and "Try on Playground." The flowchart culminates in a funnel labeled "Model Catalog" that filters down to a yellow "This One" box representing the selected model. Additional elements include decision points asking "Good Enough?" and "But What If...?" with paths for model evolution and requirement changes, and options to "Mitigate Choices" including "Extend It," "Replace It," and "Customize It" with sub-questions about working with others, model swappability, and fine-tuning capabilities.
:::

There are several criteria that can influence your model selection. Some of these criteria might be more important to you based on your own unique workload characteristics and the organizational priorities that apply to your workload. Each of these criteria act as a filter to be applied to the thousands of available models. The following list of criteria is ordered by general priority, with the decisions factors that typically have the most influence at the top.

### Task fit

**What is the model intended to do: chat, reasoning, embedding, RAG, or multimodal processing?**

When selecting an AI model, you should select a model whose capabilities align with the specific task you want it to perform. Different models are optimized for different functions: some excel at natural language processing, others at image recognition, audio analysis, or multimodal tasks. For example, convolutional neural networks (CNNs) are ideal for visual data, while generative pre-trained transformer (GPT) models are better suited for text generation and understanding. By clearly defining your task — whether it's sentiment analysis, code generation, or real-time conversation — you can narrow down your options and choose a model that delivers the best performance, accuracy, and efficiency for your use case.

#### Single model vs multiple model considerations

When considering task fit, your workload application design matters. Using a single model to fulfill all of the task requirements aligns better with a simpler approach. Alternatively, you could break the task into multiple steps, each using a model suited to its specific purpose. Using multiple models are common in AI agent-based workload design, especially when using [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns). For example, you might combine language understanding, reasoning, and retrieval. This modular approach allows for greater flexibility, scalability, and adaptability, especially in dynamic environments where tasks evolve or require diverse capabilities.

Each model that's included in your workload must be evaluated and selected individually, and you should follow these considerations for each one.

### Cost constraints

**What are the budgetary limits for inference and deployment?**

Cost considerations must be considered when selecting an AI model, especially when balancing performance with budget constraints. High-performing models often require significant compute resources, which can drive up infrastructure and operational costs, particularly at scale. For workloads with limited funding, open-source or pre-trained models offered by cloud providers can provide a cost-effective alternative without sacrificing too much performance. On the other hand, workloads with larger budgets may opt for proprietary models or custom training to achieve higher precision and domain-specific capabilities. Align your model choice around one that maximizes return on investment.

### Context window size

**How large of a context window will you need?**

When selecting an AI model, the context window size should align with the complexity and length of the input data you expect to work with. Generally speaking, larger, full-feature models have larger context windows. These models also require more compute resources and are generally slower in returning responses than smaller, specialized models. A larger context window allows the model to consider more information at once—such as longer documents, extended conversations, or complex codebases—without losing track of earlier content. This is especially important for tasks that require maintaining coherence, understanding nuanced context, or referencing earlier parts of a conversation or document. Conversely, models with smaller context windows may be faster or more cost-effective and are best suited for shorter, more focused tasks.

### Security and compliance

**Will the model meet your organization's security and compliance standards and requirements?**

Selecting a model that aligns with your organization’s security standards and regulatory obligations is essential to mitigate risk and maintain trust. Organizations operating in regulated industries, such as healthcare, finance, or government, must ensure their models comply with standards like GDPR, HIPAA, or CCPA. This means choosing models that offer robust data protection, secure deployment options, and transparency in decision-making processes. Open-source models may provide greater interpretability and control, while proprietary models might offer stronger built-in safeguards and support for compliance certifications.
 
### Region availability

**Can the model be deployed in the same region as your other workload resources?**

Limited regional availability significantly influences the selection of an AI model, especially when considering latency, data residency, and compliance requirements. Models might only be hosted in specific geographic regions, which can affect performance for users in other locations due to increased response times. Additionally, workloads operating under regional data protection laws, like GDPR in Europe or CCPA in California, must ensure that their chosen model complies with local regulations regarding data storage and processing.

### Deployment strategy

**Will the model be hosted on serverless or managed infrastructure, your own infrastructure, or on-device?**

Models need to be deployed on compute before they can be consumed. That compute can come from your cloud provider on shared infrastructure with other cloud customers. Or that compute could be local to your workload, such as running within process in your code. Some models that are available in a serverless platform from the provider, sometimes known as Models-as-a-Service (MaaS), might be too big or not licensed to be hosted in your own compute. Some specialized models might not be available through your provider's hosting and are only available to run in your own inferencing environment.

Your workload requirements will constrain what the compute platform options are per task, which effectively applies a restriction on which models can be used based on where they can be deployed to meet efficiency, cost, and compliance requirements. Depending on the available hosting, you might also have a choice in SDK to perform inferencing against that model. Some platforms provide a unified SDK that supports calling all hosted models, others require you to use the SDK specifically built by the model's provider.

### Domain specificity

**Is the model pretrained on data relevant to your industry, such as finance or healthcare?**

Using an AI model pretrained on data relevant to your industry—such as healthcare, finance, or legal—offers significant advantages in accuracy, efficiency, and contextual understanding. These models are already familiar with domain-specific terminology, regulatory nuances, and typical workflows, which reduces the need for extensive retraining and fine-tuning. As a result, they can deliver more precise predictions, generate more relevant content, and support faster deployment in real-world applications. Leveraging industry-specific pretraining also helps ensure compliance and improves trustworthiness, especially in fields where precision and reliability are critical.

### Performance

**How fast and accurate must your responses be?**

Every AI model has built-in performance limits, and how you host the model can add more restrictions. Together, the model and its hosting setup determine how fast it can respond and how many requests it can handle at once. Depending on how your system or application will use the model, you'll need to either choose a model that fits your system’s needs or adjust your system to match what the model can realistically handle.

In general, you want to pick a model that meets your quality standards while working as quickly as possible. It should also be hosted in a way that supports the number of requests your system expects, without slowing things down or creating a poor user experience.

> [!NOTE]
> Some cross-cutting concerns, like implementing responsible AI policies, might introduce additional performance limitations. While you should include these limitations in your evaluation, they shouldn’t influence your model choice.

### Model tunability

**How much customization do you need to perform?**

Some AI models offer a many hyperparamaters that you can tune to meet your application needs. Examples of these models are deep neural networks or gradient boosting machines. These models offer fine-grained control over parameters such as learning rate and architecture, making them ideal for high-stakes tasks where accuracy is critical. In contrast, simpler models like linear regression or decision trees are easier to deploy and interpret, making them suitable for smaller datasets, real-time use cases, or teams with limited machine learning experience. However, tunability also affects generalization: overly complex models risk overfitting, while simpler ones may underfit but offer more stable performance. Resource constraints are another consideration, as highly tunable models often require more training time, memory, and automated tuning tools. 

### Additional factors

While the criteria above are usually closely aligned with your workload's functional and non-functional requirements, there are sometimes other factors that can be considered relevant to your decision making. These are typically the lowest priority for most workloads, but your workload could apply a higher level of importance to them in certain situations.

- License
- Multi-lingual capabilities
- Support plan (community or paid)
- Sustainability and environmental impact reporting
- Update lifecycle (bug fixes and model revisions) and retirement strategy

## Non-criteria for model selection

There are some factors that you should probably not factor into your decision making, as they are rarely aligned with your workloads functional or non-functional requirements.

- Cultural popularity
- Publisher (OpenAI, Meta, Microsoft, xAI, and so on)

### Narrowing the search space

To help you apply the selection criteria in an efficient manner use a catalog such as those found in [Hugging Face](https://huggingface.co/models), [Azure AI Foundry](https://ai.azure.com/explore/models), and [GitHub models](https://github.com/marketplace?type=models). These services offer filters that align with many of the decision criteria above, like tasks, to help you reduce the number of models to choose from.

## Evaluation and benchmarking

To perform a side-by-side AI model evaluation, start by defining a clear set of criteria based on your application’s specific needs, such as accuracy, speed, cost, context retention, and output quality. Then, run candidate models on the same representative dataset or set of tasks, ensuring consistent input and evaluation conditions. Compare the outputs qualitatively and quantitatively, using metrics like relevance, coherence, latency, and user satisfaction. It’s also helpful to involve stakeholders or end users in the evaluation process to gather feedback on which model better aligns with real-world expectations. This structured approach helps you make an informed decision about which model is the best fit for your use case.

You can also use tools like Hugging Face's benchmark collections to assess models for language support, reasoning, and safety. Using multiple benchmarking sources helps you understand how specific models have performed across many different real-world scenarios without fear of bias from your model host.

Your model host might have evaluation capabilities built into their platform, it's recommended you use those tools. For example, see [Evaluate generative AI models using Azure AI Foundry](/azure/ai-foundry/how-to/evaluate-generative-ai-app).

## Fine-tuning and distillation

In many cases, you'll need to do some amount of fine-tuning to train your model on your dataset. This requirement might influence your model choice as some models don't support fine-tuning. Distillation refers to using a model trained on your dataset to train another model, usually a smaller, specialized model. This practice allows you to build a more efficient workload, increasing performance and decreasing costs. As with fine-tuning, some models don't support distillation, so consider this requirement as you plan your workload design.

## Plan for model changes

Choosing a model isn't a one-time activity. In your proof of concept or prototype phase, you might choose a frontier model to start with to expedite the build-out. When you get to production, you might decide that a more specialized model, or even a small language model is a better fit. And as your workload evolves, you may find that the model you initially chose doesn't perform as anticipated, or your planned features aren't a good fit for that model. Likewise, to keep up with market advances, you might need to regularly swap out your model with new releases. For a detailed review of model lifecycle considerations, see the [Design to support foundation model life cycles](/azure/architecture/ai-ml/guide/manage-foundation-models-lifecycle) article.

To future-proof your architecture, consider these de-risking approaches:

- Use abstraction layers like the Azure AI Inference SDK to avoid vendor lock-in.
- Test models in parallel by switching environment variables and comparing outputs.
- Avoid opaque routing unless observability and traceability are guaranteed.

## Next steps

- [Explore Azure AI Foundry Models](/azure/ai-foundry/concepts/foundry-models-overview)
- [Foundry Models and capabilities](/azure/ai-foundry/foundry-models/concepts/models)
