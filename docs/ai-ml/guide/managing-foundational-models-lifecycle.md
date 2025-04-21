---
title: Managing foundational model lifecycles in your generative AI application infrastructure
description: Learn how you should manage new model versions and retired model versions in your generative AI application infrastructure.
author: robbagby
ms.author: robbag
ms.date: 04/18/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.custom: arb-aiml
products:
  - azure-machine-learning
  - azure-ai-foundry
categories:
  - ai-machine-learning
---

# Managing foundational model lifecycles

There are different reasons to update the foundational model you use in your generative AI solution and the scope of your model update can vary between upgrading for a slight revision change to choosing a different model altogether. Some reasons to update models are voluntary, while others are required. For example, depending upon the model deployment option you choose in Azure, MaaS, MaaP, or self-hosting, you may be required to update to new model versions, as old versions are retired.

This article will touch on some of the reasons for updating to new models or model versions and will detail the architectural choices you should consider to make sure your solution supports these inevitable model updates.

## Model update scopes

The scope of the model update in your generative AI solution can vary drastically, from upgrading for a minor revision change to choosing a new model altogether. There are a variety of reasons you may choose to upgrade the model in your solution. The following table lists different update scopes along with an example and some of the reasons you might choose to make a model upgrade of this scope:

| Scope of change | Example | Reason for updating model |
| --- | --- | --- |
| Minor version update | Moving from GPT-3.5-Turbo to GPT-3.5-Turbo-0125 | A small, incremental change or improvement within the same major version |
| Intermediate version update | Moving from GPT-3 to GPT-3.5 | A significant but not major leap, often involving enhancements and optimizations |
| Major version update | Moving from GPT-3 to GPT-4 | A substantial upgrade with significant new features and improvements |
| Variant update | Moving from GPT-4 to GPT-4-Turbo or GPT-4o-mini | A variation of the same major version, often optimized for specific attributes like cost or speed |
| Generational version update | Moving from GPT-4 to GPT-4o | A new generation of the model, typically introducing new features and capabilities |
| Model change (general) | Moving from GPT-4 to DeepSeek | A change to a different general model for speed, cost, or model performance for your solution |
| Model change (specialized) | Moving from GPT-4 to Prizedata | A change to a model that is trained on a specific domain to achieve better model performance for your solution |
| Deployment option change | Moving from Llama-1 hosted as managed online endpoint in Azure AI Foundry to self-hosting Llama-1 on a virtual machine | Changing your hosting model to have more/less control and more/less hosting responsibility |

## How the model deployment strategy in Azure effect version retirements

There are three main strategies for deploying models and it is important to understand how each handles version retirements.

- **MaaS (Models as a Service)** - Pre-trained models in the cloud exposed as APIs that offer scalability and ease of integration with the tradeoff of potentially higher costs and lower control of the models.
- **MaaP (Models as a Platform)** - Models deployed and managed within a larger platform, such as Azure AI Foundry. This strategy provides greater control of the models, but requires more management and infrastructure.
- **Self-hosting models** - Models deployed on your own infrastructure, providing maximum control over the models but requiring significant responsibility for management and maintenance.

Both MaaS and MaaP strategies in Azure source models from the Azure AI model catalog. Models in the model catalog follow a lifecycle where models are eventually [deprecated](/azure/ai-foundry/concepts/model-lifecycle-retirement#deprecated) and [retired](/azure/ai-foundry/concepts/model-lifecycle-retirement#retired). You are not able to create new deployments for deprecated models, but existing deployments continue to work. Existing deployments for retired models return errors. Using these two strategies will require you to update your solution to use newer model versions. When you are self-hosting models, you have full control and you are not forced to update models.

## Breadth of change for model updates

:::image type="complex" source="_images/model-lifecycle-breadth-change.svg" alt-text="Simple architecture diagram of a chat scenario showing the different breadths of change when updating a model." lightbox="_images/model-lifecycle-breadth-change.svg":::
   A diagram showing an intelligent client connecting to an orchestrator. There are three boxes pointing to the orchestrator with dashed lines: 1. config, 2. prompt, and 3. orchestration logic. The orchestrator has solid lines pointing to three different AI models: 1. model x-1, 2. model x-1.1, and 3. model y-1. The orchestrator also has an arrow pointing to a box labeled API/Agent. The API/Agent box has a solid line pointing to a box labled Vector database. There is a pipeline with four steps that is pointing to the vector database with a dashed line. The four steps are: 1. chunk documents, 2. enrich chunks, 3. embed chunks, and 4. persist chunks. There are green numbered circles annotating several parts of the diagram. The first is next to the models. The second is between prompt and config. The third is where the pipeline is pointing to the vector database. The fourth is next to the orchestration logic. The fifth is next to the intelligent application.
:::image-end:::

Updating the model in your solution will require different breadths of change within your architecture depending upon factors such as the model update scope, the purpose of the update, and differences between the old and updated model. The diagram shows a simplified chat architecture, numbered to point out some of the areas of change in your architecture a model update might influence.

1. **The model** - The obvious change is to the model itself. You deploy the new model using your chosen model deployment strategy.
1. **The model config** - When updating the model in your generative AI solution, you might need to adjust hyperparameters or configurations to optimize performance for the new model's architecture and capabilities. For example, switching from a transformer-based model to a recurrent neural network might require different learning rates and batch sizes to achieve optimal results.
1. **The prompt** - When changing models in a generative AI solution, you might need to adjust the prompt to align with the new model's strengths and capabilities. Along with updating the model config, updating the prompt is the most common change when updating models. When evaluating a new model, even for a minor version update, if the model is not performing to your requirements, you should start with testing the prompt.
1. **The grounding data** - Some model updates, usually larger scoped changes, will lead you to making changes to your grounding data. For example, when moving from a generalized model to a domain specific model, such as one focused on finance or medicine, you may no longer need to pass domain specific grounding data to the model. See [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) for more information.
1. **The orchestration logic** - Some model updates, especially when taking advantage of new features, will lead you to making changes to your orchestration logic. For example, if you update your model to GPT-35 or GPT-4 to take advantage of [function calling](/azure/ai-services/openai/how-to/function-calling), you have to update your orchestration logic. Your old model returned a result which you could return to the caller. With function calling, the call to the model will return a function that your orchestration logic must call.

