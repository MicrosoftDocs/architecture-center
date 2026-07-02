---
title: AI Technology Overview
description: Learn about AI concepts, development platforms, language models, agents, and architecture patterns for designing AI workloads on Azure.
author: davihern
ms.author: davihern
ms.date: 06/15/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# AI technology overview

AI is a set of technologies that enable machines to perceive, learn, reason, generate content, and make predictions. This article provides an overview of AI concepts, development platforms, and architecture patterns to help you design AI workloads on Azure. Incorporate AI into applications to perform functions or make decisions that traditional logic or processing can't handle effectively. As an architect who designs solutions, you need to understand the AI and machine learning landscape and how to integrate Azure solutions into your workload design.

## Integrate AI in Azure workloads

Azure Architecture Center provides example architectures, architecture guides, architectural baselines, and ideas to apply to your scenario. Workloads that implement generative or discriminative AI use cases should follow the Azure Well-Architected Framework [AI workloads on Azure](/azure/well-architected/ai/get-started) guidance. This guidance includes principles and design guides that influence AI and machine learning workloads across the Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency architecture pillars.

The following workload types are out of scope for Azure Well-Architected Framework guidance:

- **Low-code and no-code AI workloads**, such as solutions built with Microsoft Copilot Studio. For architecture guidance on these workloads, see [Microsoft Copilot Studio reference architectures and solution ideas](/power-platform/architecture/products/copilot-studio).

- **High-performance computing (HPC) workloads**. For architecture guidance on HPC, see [HPC on Azure](/azure/architecture/guide/compute/high-performance-computing).

- **Workloads that don't implement generative or discriminative AI use cases**, such as traditional analytics or rule-based automation.

## AI concepts

AI concepts encompass a wide range of technologies and methodologies that machines use to do tasks that typically require human intelligence. The following sections provide an overview of key AI concepts.

- [Algorithms](#algorithms)
- [Machine learning](#machine-learning)
- [Deep learning](#deep-learning)
- [Generative AI](#generative-ai)
- [Language models](#language-models)
- [Copilots](#copilots)
- [Retrieval-augmented generation](#retrieval-augmented-generation)
- [Context engineering](#context-engineering)

### Algorithms

*Algorithms* or *machine learning algorithms* are pieces of code that help you explore, analyze, and find meaning in complex datasets. Each algorithm is a finite set of unambiguous step-by-step instructions that a machine can follow to achieve a specific goal. The goal of a machine learning model is to establish or discover patterns that humans can use to make predictions or categorize information. An algorithm might describe how to check whether a pet is a cat, dog, fish, bird, or lizard. A more complicated algorithm might describe how to identify a written or spoken language, analyze its words, translate them into a different language, and then check the translation for accuracy.

Choose an algorithm family that best suits your task. Evaluate the different algorithms within the family to find the appropriate fit for your workload. For more information, see [What are machine learning algorithms?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-are-machine-learning-algorithms) in the Microsoft cloud computing dictionary.

### Machine learning

*Machine learning* is an AI technique that uses algorithms to create predictive models. These algorithms parse data fields and learn from the patterns within data to generate models. The models can then make informed predictions or decisions based on new data.

The predictive models are validated against known data, measured by performance metrics for specific business scenarios, and then adjusted as needed. This process of learning and validation is called *training*. Through periodic retraining, machine learning models improve over time.

In your workload design, you might use machine learning if your scenario includes past observations that reliably predict future situations. These observations might be universal truths, like computer vision that distinguishes one type of animal from another. Or these observations might be specific to your situation, like computer vision that detects a potential assembly mistake on your assembly lines based on past warranty claim data.

For more information, see [What is machine learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-machine-learning-platform/) in the Microsoft cloud computing dictionary.

### Deep learning

*Deep learning* is a type of machine learning that can learn through its own data processing. Like machine learning, it also uses algorithms to analyze data. But it analyzes data by using artificial neural networks that have many inputs, outputs, and layers of processing. Each layer can process the data in a different way. The output of one layer becomes the input for the next. Deep learning uses this process to create more complex models than traditional machine learning can create.

Deep learning requires a large investment to generate highly customized or exploratory models. You might consider other solutions in this article before you add deep learning to your workload.

For more information, see [What is deep learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-deep-learning) in the Microsoft cloud computing dictionary.

### Generative AI

*Generative AI* trains models to generate original content based on many forms of content, including natural language, computer vision, audio, or image input. Generative AI lets you describe a desired output in everyday language, and the model responds by creating appropriate text, image, and code. Examples of generative AI applications include Microsoft 365 Copilot and Microsoft Foundry.

- [Microsoft 365 Copilot](https://m365.cloud.microsoft/chat/) is primarily a UI that helps you write code, documents, and other text-based content. It's based on popular models from OpenAI and Anthropic and is integrated into a wide range of Microsoft applications and user experiences.

- [Microsoft Foundry](/azure/foundry/what-is-foundry) is a development platform as a service (PaaS) that provides access to agent hosting and a catalog of language models from OpenAI, Anthropic, Microsoft, xAI, and other providers. For current model availability, see the [Microsoft Foundry model catalog](https://ai.azure.com/explore/models).

### Language models

*Language models* are a subset of generative AI that focus on natural language processing tasks, like text generation and sentiment analysis. These models represent natural language based on the probability of words or sequences of words that occur in a given context.

Researchers use conventional language models in supervised settings for research purposes. These models are trained on well-labeled text datasets for specific tasks. Pretrained language models provide an easy way to start using AI. They're more widely used in recent years. These models are trained on large-scale text collections from the internet via deep learning neural networks. Fine-tune them on smaller datasets for specific tasks.

The number of parameters, or *weights*, determines the size of a language model. Parameters influence how the model processes input data and generates an output. During training, the model adjusts the weights to minimize the difference between its predictions and the actual data. This process is how the model learns parameters. The more parameters a model has, the more complex and expressive it is. But it's also more computationally expensive to train and use.

Small language models usually have fewer than 10 billion parameters, and large language models have more than 10 billion parameters. For example, the [Microsoft Phi model family](https://ai.azure.com/explore/models?selectedCollection=phi) includes small models designed for efficiency and cost-effectiveness, and the family continues to expand with new variants for reasoning, multimodal, and other tasks. For current model names, sizes, and capabilities, see the [Foundry model catalog](https://ai.azure.com/explore/models).

### Copilots

[Microsoft 365 Copilot](https://m365.cloud.microsoft/chat/) integrates with a wide range of Microsoft applications and user experiences. It's based on an open architecture where non-Microsoft developers can create their own plug-ins to extend or customize the user experience by using Microsoft 365 Copilot. Partner developers can also create their own agents by using the same open architecture.

For more information, see the following resources:

- [Adopt, extend, and build Microsoft 365 Copilot experiences across the Microsoft Cloud](/microsoft-cloud/dev/copilot/overview)
- [Microsoft Copilot Studio overview](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)
- [Microsoft Foundry overview](/azure/foundry/what-is-foundry)

### Retrieval-augmented generation

*Retrieval-augmented generation (RAG)* is an architecture pattern that augments the capabilities of a language model, like ChatGPT, that's trained only on public data. Use this pattern to add a retrieval system that provides relevant grounding data in the context with the user request. An information retrieval system provides control over grounding data that a language model uses when it formulates a response. RAG architecture helps you scope generative AI to content sourced from vectorized documents, images, and other data formats. RAG isn't limited to vector search storage. RAG supports any data store technology.

For more information, see [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) and [Choose an Azure service for vector search](../guide/technology-choices/vector-search.md). Use [Foundry IQ knowledge bases](/azure/foundry/agents/how-to/foundry-iq-connect) for grounding data that Microsoft Foundry agents need as a turnkey approach to RAG.

### Context engineering

*Context engineering* is the practice of designing how to select, scope, and structure context, such as retrieved documents, conversation history, tool outputs, system instructions, and enterprise data, so that an AI model can produce reliable and relevant outputs. RAG addresses grounding data retrieval, and context engineering is the broader architectural discipline that governs the input that the model receives and the form that the input is in.

In modern AI architectures, especially agent-based and generative AI solutions, context is a critical design element. Models have limited built-in knowledge and no inherent awareness of enterprise-specific data or workflows. Effective architectures include retrieval pipelines, memory stores, tool integrations, guardrails, and prompt management to supply the right context at the right time. Without deliberate context design, architectures are susceptible to mistakes, stale answers, and unintended exposure of sensitive data.

## Agent-based architecture

An AI agent is a system that uses a language model to decide which actions to take, which tools to call, and how to sequence steps to complete a task. Unlike a standard AI integration in which application code controls the workflow, an agent reasons about goals and autonomously determines its own execution path. This autonomy makes agents suitable for complex, multistep tasks that require dynamic decision-making.

Multi-agent architecture lets you break complex problems into specialized agents that coordinate to produce a solution. To coordinate multiple agents in complex AI scenarios, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns).

Azure provides two complementary tools for building agent-based architectures:

- **[Microsoft Agent Framework](/agent-framework/overview/)** is a code-first SDK for building agents and multi-agent workflows. It provides the programming model for defining agent behavior, tool integration, and orchestration logic.

- **[Foundry Agent Service](/azure/foundry/agents/overview)** hosts agents that you define. These agents connect to a foundation model in the AI model catalog and, optionally, your own custom knowledge stores or APIs. You can define these agents declaratively or Microsoft Foundry can containerize and [host them](/azure/foundry/agents/concepts/hosted-agents).

## Foundry Tools

[Foundry Tools](/azure/ai-services/what-are-ai-services) are prebuilt and customizable AI models and APIs that add intelligent capabilities to applications. Use cases include natural language processing, search, translation, speech, vision, and decision-making. Use Foundry Tools to add AI to applications without building and training custom models.

For more information, see [Choose a Foundry Tools technology](../data-guide/technology-choices/ai-services.md).

## AI language models

Azure provides access to language models through multiple services and deployment options. For a foundational explanation of what language models are and how they work, see [Language models](#language-models). This section covers the models available on Azure and the architectural factors that influence model selection and hosting.

- [Azure OpenAI](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) provides managed API access to OpenAI models, including the o3, o4-mini, GPT-4.1, GPT-4o, and GPT-4o mini families. These models support content generation, summarization, reasoning, image understanding, semantic search, and natural-language-to-code translation. Azure OpenAI manages hosting, scaling, and content filtering. It supports virtual network integration and Microsoft Entra ID authentication.

    For current model availability by region, see [Azure OpenAI models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure).

- [Foundry Models](/azure/foundry/concepts/foundry-models-overview) provides a catalog of more than 1,900 models from Microsoft, OpenAI, DeepSeek, Meta, Hugging Face, and other providers. The catalog includes foundation models, reasoning models, small language models, multimodal models, and domain-specific models. You can compare, evaluate, fine-tune, and deploy models directly from the catalog.

- [Phi models](https://ai.azure.com/explore/models?selectedCollection=phi) are small language models that Microsoft offers. Small language models are less compute-intensive than large models and can be more efficient, interpretable, and cost-effective for targeted tasks. Depending on the model size, host small language models in-process or on the same compute as the consumer, which reduces latency and simplifies the architecture.

### Model selection considerations

When you select a language model for your workload, consider the following architectural factors:

- **Hosting topology.** Azure offers managed API endpoints, serverless model deployments, managed compute deployments, and container-based self-hosting. Your choice affects latency, cost, data residency, and operational responsibility.

- **Model size versus cost and latency.** Larger models typically provide broader capabilities but require more compute and incur higher costs. Smaller models can be more efficient for focused tasks.

- **Data privacy.** Evaluate whether you can send your data to a hosted API or whether regulatory or organizational requirements demand self-hosted inference.

- **Fine-tuning versus prompt engineering.** Determine whether prompt engineering and RAG are sufficient for your use case, or whether fine-tuning a model on your data produces materially better results.

- **Accuracy and bias.** Validate model outputs against your domain requirements. Consider content filtering, grounding, and evaluation strategies to manage output quality.

## AI development platforms and tools

The following AI development platforms and tools can help you build, deploy, and manage machine learning and AI models.

### Azure Machine Learning

Azure Machine Learning is a machine learning service for building and deploying models. Azure Machine Learning provides web interfaces and SDKs for you to train and deploy your machine learning models and pipelines at scale. Use these capabilities with open-source Python frameworks like PyTorch, TensorFlow, and scikit-learn.

For more information, see the following resources:

- [Compare Microsoft machine learning products and technologies](/azure/architecture/ai-ml/guide/data-science-and-machine-learning)
- [Azure Machine Learning documentation](/azure/machine-learning/)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

### Automated machine learning

*Automated machine learning (AutoML)* is the process of automating the time-consuming, iterative tasks of machine learning model development. AutoML helps data scientists, analysts, and developers build machine learning models that have high scale, efficiency, and productivity while sustaining model quality.

For more information, see the following resources:

- [What is AutoML?](/azure/machine-learning/concept-automated-ml)
- [Train a classification model by using AutoML in Azure Machine Learning studio](/azure/machine-learning/tutorial-first-experiment-automated-ml)
- [Set up AutoML experiments in Python](/azure/machine-learning/how-to-configure-auto-train)

### MLflow

Azure Machine Learning workspaces are MLflow-compatible, which means that an Azure Machine Learning workspace works the same way as an MLflow server. This compatibility provides the following advantages:

- Azure Machine Learning doesn't host MLflow server instances but can use the MLflow APIs directly.

- Use an Azure Machine Learning workspace as your tracking server for any MLflow code, whether or not it runs in Azure Machine Learning. You need to set up MLflow to point to the workspace where the tracking should occur.

- Run training routines that use MLflow in Azure Machine Learning without making any changes.

For more information, see [MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow) and [MLflow](https://www.mlflow.org/).

### Generative AI tools

- [Microsoft Foundry](/azure/foundry/what-is-foundry) provides a platform to help you experiment, develop, and deploy generative AI apps and APIs responsibly. Use the [Foundry portal](https://ai.azure.com?cid=learnDocs) to find Foundry Tools, foundation models, a playground, and resources to help you fine-tune, evaluate, and deploy AI models and AI agents.

    [Foundry Agent Service](/azure/foundry/agents/overview) hosts agents that you define. These agents connect to a foundation model in the AI model catalog and, optionally, your own custom knowledge stores or APIs. Define these agents declaratively, or let Microsoft Foundry containerize and host them.

- [Microsoft Copilot Studio](/microsoft-copilot-studio/) extends Microsoft 365 Copilot. Build custom agents for internal and external scenarios. Use an authoring canvas to design, test, and publish agents. Create generative AI-enabled conversations, provide greater control of responses for existing agents, and accelerate productivity by using automated workflows.

### Prebuilt AI tools

[Foundry Tools](/azure/ai-services/what-are-ai-services) are prebuilt and customizable AI models and APIs that target specific scenarios such as speech, translation, language understanding, document intelligence, vision, and content safety. Use them when your workload needs a well-defined AI capability and you don't need to design, train, or host a model yourself.

For a list of available services organized by capability, see [Choose an AI services technology](../data-guide/technology-choices/ai-services.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

[David Hernández Díez](https://www.linkedin.com/in/davidhernandezdiez/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To continue learning about AI on Azure, explore the following resources:

- [Get started with AI architecture design](./ai-get-started.md)
- [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide)
- [What is Microsoft Foundry?](/azure/foundry/what-is-foundry)
- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns)

## Related resources

- [Browse Azure Architecture Center AI and machine learning architectures](/azure/architecture/browse/?azure_categories=ai-machine-learning)
- [Baseline Microsoft Foundry chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-chat)
- [Baseline Microsoft Foundry chat reference architecture in an Azure landing zone](/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-landing-zone)
- [Microsoft AI](https://www.microsoft.com/ai/)
- [AI learning hub](/ai/)
- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)
