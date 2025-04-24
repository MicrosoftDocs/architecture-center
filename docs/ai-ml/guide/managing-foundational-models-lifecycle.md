---
title: Design to support foundational model lifecycles
description: Learn how you should manage new model versions and retired model versions in your generative AI application infrastructure.
author: robbagby
ms.author: robbag
ms.date: 04/29/2025
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

# Design to support foundational model lifecycles

There are different reasons to update the foundational model you use in your generative AI solution. The scope of your model update can vary between upgrading for a slight revision change to choosing a different model altogether. Some reasons to update models are voluntary, while others are required. For example, depending upon the model deployment option you choose in Azure, MaaS, MaaP, or self-hosting, you may be required to update to new model versions, as old versions are retired.

This article discusses the reasons for updating to new models or model versions and outlines the architectural choices to ensure your solution can accommodate these inevitable updates.

## Model update scopes

The scope of the model update in your generative AI solution can vary drastically, from upgrading for a minor revision change to choosing a new model altogether. There are a various reasons you may choose to upgrade the model in your solution. The following table lists different update scopes along with an example and some of the benefits of making a model upgrade of this scope:

| Scope of change | Example | Benefit of updating model |
| --- | --- | --- |
| Minor version update | Moving from GPT-3.5-Turbo to GPT-3.5-Turbo-0125 | A small, incremental change or improvement within the same major version. Some examples are performance improvements, bug fixes, and increased stability. |
| Intermediate version update | Moving from GPT-3 to GPT-3.5 | A significant but not major leap, often involving enhancements and optimizations. Some examples are improved accuracy through better natural language understanding and enhanced dialogue capabilities. |
| Major version update | Moving from GPT-3 to GPT-4 | A substantial upgrade with significant new features and improvements. Some examples are major version updates can include significant improvements in reasoning capabilities, may have larger context windows, an increased knowledge base, or may support multimodal capabilities. |
| Variant update | Moving from GPT-4 to GPT-4-Turbo or GPT-4o-mini | A variation of the same major version, often optimized for specific attributes like cost or speed. |
| Generational version update | Moving from GPT-4 to GPT-4o | A new generation of the model, typically introducing new features and capabilities similar to a major version update. Having multiple generations allows you to choose based on your requirements for features, performance, and cost. |
| Model change (general) | Moving from GPT-4 to DeepSeek | A change to a different general model for speed, cost, or model performance for your solution. |
| Model change (specialized) | Moving from GPT-4 to Prizedata | A change to a model that is trained on a specific domain to achieve better model performance for your solution. |
| Deployment option change | Moving from Llama-1 hosted as managed online endpoint in Azure AI Foundry to self-hosting Llama-1 on a virtual machine | Changing your hosting model to have more/less control and more/less hosting responsibility. |

## How the model deployment strategy in Azure effect version retirements

There are three main strategies for deploying models and it's important to understand how each handles version retirements.

- **MaaS (Models as a Service)** - Pretrained models in the cloud exposed as APIs that offer scalability and ease of integration with the tradeoff of potentially higher costs and lower control of the models.
- **MaaP (Models as a Platform)** - Models deployed and managed within a larger platform, such as Azure AI Foundry. This strategy provides greater control of the models, but requires more management and infrastructure.
- **Self-hosting models** - Models deployed on your own infrastructure, providing maximum control over the models but requiring significant responsibility for management and maintenance.

Both MaaS and MaaP strategies in Azure source models from the Azure AI model catalog. Models in the model catalog follow a lifecycle where models are eventually [deprecated](/azure/ai-foundry/concepts/model-lifecycle-retirement#deprecated) and [retired](/azure/ai-foundry/concepts/model-lifecycle-retirement#retired).

> [!WARNING]
> For both MaaS services such as Azure OpenAI and MaaP services using the serverless API model, it's critical to understand that existing deployments for retired models return HTTP errors. If you fail to upgrade to a newer, supported model, your application no longer operates as expected. For deprecated models, you aren't able to create new deployments for deprecated models, but existing deployments continue to work. See [Azure OpenAI Service model deprecations and retirements](/azure/ai-services/openai/concepts/model-retirements) and [Serverless API model deprecations and retirements](/azure/ai-foundry/concepts/model-lifecycle-retirement) for more information.

When you're self-hosting models, or using managed compute you have full control and you aren't forced to update models.

## Breadth of change for model updates

:::image type="complex" source="_images/model-lifecycle-breadth-change.svg" alt-text="Simple architecture diagram of a chat scenario showing the different breadths of change when updating a model." lightbox="_images/model-lifecycle-breadth-change.svg":::
   A diagram showing an intelligent client connecting to an orchestrator. There are three boxes pointing to the orchestrator with dashed lines: Config, Prompt, and Orchestration logic. The orchestrator has solid lines pointing to three different AI models: model-x-v1, model-x-v1.1, and model-y-v1. The orchestrator also has an arrow pointing to a box labeled API/Agent. The API/Agent box has a solid line pointing to a box labeled Vector database. There's a pipeline with four steps that is pointing to the vector database with a dashed line. The four steps are: Chunk documents, Enrich chunks, Embed chunks, and Persist chunks. There are numbered circles annotating several parts of the diagram. The first is next to the models. The second is between prompt and config. The third is where the pipeline is pointing to the vector database. The fourth is next to the orchestration logic. The fifth is next to the intelligent application.
:::image-end:::

Updating the model in your solution necessitates varying degrees of architectural changes, depending on factors such as the scope of the update, its purpose, and the differences between the old and new models. The diagram shows a simplified chat architecture, numbered to point out some of the areas of change in your architecture a model update might influence.

1. **The model** - The obvious change is to the model itself. You deploy the new model using your chosen model deployment strategy. When moving to a new model version from a fine-tuned model, you likely need to fine-tune the new model version. When updating to use a different model, you need to determine if fine-tuning is required.
1. **The model config** - When updating the model in your generative AI solution, you might need to adjust hyperparameters or configurations to optimize performance for the new model's architecture and capabilities. For example, switching from a transformer-based model to a recurrent neural network might require different learning rates and batch sizes to achieve optimal results.
1. **The prompt** - When changing models in a generative AI solution, you may need to adjust the prompt to align with the new model's strengths and capabilities. Along with updating the model config, updating the prompt is the most common change when updating models. When evaluating a new model, even for a minor version update, if the model isn't performing to your requirements, you should start with testing changes to the prompt. You certainly need to address the prompt when changing to new models and it's likely that you need to address the prompt when making large revision changes.
1. **The orchestration logic** - Some model updates, especially when taking advantage of new features, lead you to making changes to your orchestration logic. For example, if you update your model to GPT-35 or GPT-4 to take advantage of [function calling](/azure/ai-services/openai/how-to/function-calling), you have to update your orchestration logic. Your old model returned a result which you could return to the caller. With function calling, the call to the model returns a function that your orchestration logic must call.
1. **The grounding data** - Some model updates, larger scoped changes, leads you to making changes to your grounding data. For example, when moving from a generalized model to a domain specific model, such as one focused on finance or medicine, you may no longer need to pass domain specific grounding data to the model. For more information, see [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

## Architecting for change

It's highly likely that you'll be updating models. If you're using MaaS or MaaP deployment strategies in Azure, models are retired and you need to upgrade to a newer version. You may also choose to move to different models or model versions to take advantage of new features, lower pricing, or better performance. Either way, it should be clear that your architecture should support updating the model your generative AI workload is using.

The previous section discussed the [different breadths of change](#breadth-of-change-for-model-updates). You should follow proper MLOps, DataOps, and GenAIOps practices to build and maintain automated pipelines for model fine-tuning, your data operations, and generative AI operations like prompt engineering, changing hyperparameters, and orchestration logic.

It was discussed that updates to the hyperparameters and the prompt are likely for most model updates. Because these changes are so likely, your architecture should take them into account. An important consideration is that prompts and hyperparameters are designed for specific model versions. You need to ensure that the prompts and hyperparameters are used with the correct model and version.

### Automated pipelines

Implement automated pipelines that allow you to test and evaluate the differing aspects of your generative AI application:

- **MLOps** - Follow the guidance in [Machine learning operations](/azure/architecture/ai-ml/guide/machine-learning-operations-v2) to build pipelines for model fine-tuning, if applicable.
- **GenAIOps** - Implement GenAIOps pipelines to [test and evaluate changes to the model, model hyperparameters, the prompt, and changes to orchestration logic](/azure/architecture/ai-ml/guide/genaiops-for-mlops#rag-and-prompt-engineering-2).
- **DataOps** - Implement [DataOps](/azure/architecture/ai-ml/guide/genaiops-for-mlops#dataops) pipelines to [test and evaluate changes to your RAG grounding data](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

You should implement pipelines to:

- Help you in your iterative development and experimentation (Inner Loop)
- Deployment and operationalization of your generative AI solution (Outer Loop)

### Architecture considerations

In simple architectures, like the following, the client directly calls the model with the correct prompt version and configuration. If there are changes to the prompt, a new client is deployed with the new prompt and it calls the new model. Tying the prompt, config, and model versions isn't a challenge.

:::image type="complex" source="_images/model-lifecycle-direct-access-from-client.svg" alt-text="Simple architecture diagram of a chat scenario showing an intelligent app directly accessing a model." lightbox="_images/model-lifecycle-direct-access-from-client.svg":::
   A diagram showing an intelligent client connecting directly to a model. The intelligent app shows three elements pointing to it, illustrating that it contains those elements. The elements are the config, the prompt, and orchestration logic.
:::image-end:::

Production architectures aren't so simple. You generally implement an orchestrator whose responsibility is to manage the flow of the interactions between any knowledge database and the models. Your architecture may also implement one or more layers of abstraction, such as a router or a gateway:

- **Router** - Routes traffic to different deployments. A router is useful in deployment strategies such as A/B deployments where you may choose to route a certain percentage of traffic to a new orchestrator version.
- **Gateway** - It's common to [proxy access to AI models for a various reasons](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide) including load balancing or failover between multiple backend instances, implementing custom authentication and authorization for client applications, and implementing logging and monitoring for your models.

:::image type="complex" source="_images/model-lifecycle-layers-of-abstraction.svg" alt-text="Simple architecture diagram of a chat scenario showing two common layers of abstraction in a generative AI workload." lightbox="_images/model-lifecycle-layers-of-abstraction.svg":::
   A diagram showing an intelligent client connecting to a router. The router has connections to two deployment boxes. Each deployment box has a connection line to the gateway box. The gateway box has connection lines to three different models boxes: model-x-v1, model-x-v1.1, and model-y-v1. The orchestrator boxes connect to an API/Agent box, which connects to a knowledge database box. There are arrows pointing to the router and gateway boxes with a label that reads 'Common layers of abstraction in a generative AI workload.'
:::image-end:::

Due to the layers of indirection involved, your architecture must be designed to support sending specific versions of prompts to specific models or model versions. For instance, you might have a prompt in production, prompt1, that is designed for model1. If you upgrade to model1.1, you may need to update the prompt to prompt2. In this example, your architecture needs to always use prompt1 with model1 and prompt2 with model1.1.

#### Router

The following diagram illustrates an architecture using a router to route requests to multiple deployments. An [example of this architecture with Azure AI Foundry](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#architecture) uses a managed online endpoint as the router and the different versions of the orchestrator are deployed to managed compute.

:::image type="complex" source="_images/model-lifecycle-single-layer-abstraction.svg" alt-text="Architecture diagram of a chat scenario that uses a router to route between deployments." lightbox="_images/model-lifecycle-single-layer-abstraction.svg":::
   A diagram showing an intelligent client connecting to a router (labeled 1). The router has connections to two deployment boxes that are contained in an Orchestrator box (labeled 2). In each deployment box, there's config, a prompt (labeled 3), and orchestration logic (labeled 4). Each deployment box has a connection line to a specific model box (labeled 5). Deployment 1 is connected to model-x-v1, while Deployment 2 is connected to model-x-v1.1. The orchestrator box connected to an API/Agent box, which connects to a knowledge database box. There are arrows pointing to the router and gateway boxes with a label that reads 'Common layers of abstraction in a generative AI workload'.
:::image-end:::

The following flow describes how different deployments of an orchestrator, each with their own version of model configuration and a prompt, call the correct model:

1. A user issues a request from an intelligent application and that request is sent to a router.
1. The router routes to either 'Deployment 1' or 'Deployment 2,' depending upon its logic.
1. Each deployment has its own version of the prompt.
1. The orchestrator is configured with the specific model and version. It uses this information to call the appropriate model and version directly.
1. Because the specific version of the prompt is deployed along with the orchestrator that is configured with the specific model and version, the correct prompt is sent to the correct model version.

#### Gateway

The following diagram illustrates an architecture using a router to route requests to multiple deployments. However, in this architecture, all model requests are routed through a gateway.

:::image type="complex" source="_images/model-lifecycle-two-layers-abstraction.svg" alt-text="Architecture diagram of a chat scenario that uses a router to route between deployments and a gateway to route between models." lightbox="_images/model-lifecycle-two-layers-abstraction.svg":::
   A diagram showing an intelligent client connecting to a router (labeled 1). The router has connections to two deployment boxes that are contained in an Orchestrator box (labeled 2). In each deployment box, there's config, a prompt (labeled 3), and orchestration logic (labeled 4). Each deployment box has a connection line to a gateway box (labeled 5). Each connector line has a label showing an HTTP header indicating the model and version. Deployment 1 indicates model-x-v1, while Deployment 2 indicates model-x-v1.1. The gateway box has connectors to model-x-v1 box and model-x-v1.1 box (labeled 6). The orchestrator box connected to an API/Agent box, which connects to a knowledge database box. There are arrows pointing to the router and gateway boxes with a label that reads 'Common layers of abstraction in a generative AI workload.'
:::image-end:::

The following flow describes how different deployments of an orchestrator, each with their own version of model configuration and a prompt, call the correct model through a gateway:

1. A user issues a request from an intelligent application and that request is sent to a router.
1. The router routes to either 'Deployment 1' or 'Deployment 2,' depending upon its logic.
1. Each deployment has its own version of the prompt.
1. The orchestrator is configured with the specific model and version. It uses this information to set an HTTP header indicating the correct model and version to call.
1. The orchestrator calls the gateway. The request contains the HTTP header indicating the name and version of the model to use.
1. The gateway uses the HTTP header to route the request to the appropriate model and version.

## Recommendation

Be intentional about updating models. Test and evaluate new versions and new models using automated pipelines. Avoid using platform features that auto-upgrade models to new versions. You should be aware of how each model update affects your workload. Ensure that your service configuration doesn't enable auto-upgrade.

## Summary

There are a various reasons to update the foundational model in your generative workload ranging from version upgrades required when models are retired to choosing a different model. Depending on the scope of the model update, you may need to implement and evaluate changes to the model, if it's fine-tuned, the prompt, your model configuration, your orchestration logic, or your data pipeline. You should follow MLOps, DataOps, and GenAIOps guidance to build automated workflows for the different aspects of your solution, allowing you to test, evaluate, and deploy new versions. You also need to ensure that your architecture supports running multiple versions of an orchestrator where each version ties its config and prompt version to a specific model version.

Your architecture should support updating to new or different models, along with any required changes to the prompt or model config, without requiring changes to the intelligent application or to the user experience. The changes should be encapsulated within their appropriate components and your operations should automate the testing, evaluation, and deployment of those changes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer  

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

[GenAIOps for MLOps practitioners](/azure/architecture/ai-ml/guide/genaiops-for-mlops)

## Related resources

- [Azure OpenAI Service model deprecations and retirements](/azure/ai-services/openai/concepts/model-retirements)
- [Baseline OpenAI end-to-end chat reference architecture](../architecture/baseline-openai-e2e-chat.yml)
- [Machine learning operations](machine-learning-operations-v2.md)
