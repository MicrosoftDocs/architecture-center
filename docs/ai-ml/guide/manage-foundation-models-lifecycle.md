---
title: Design to Support Foundation Model Life Cycles
description: Learn about how to manage both new model versions and retired model versions in your generative AI application infrastructure.
author: robbagby
ms.author: pnp
ms.date: 05/13/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
products:
  - azure-machine-learning
  - azure-ai-foundry
categories:
  - ai-machine-learning
---

# Design to support foundation model life cycles

Foundation models are versioned dependencies that you use in your AI workload. Each foundation model has a life cycle that must be considered. Like code libraries and other dependencies in your workload, foundation models receive minor version updates to enhance performance and optimizations. Major version updates introduce substantive changes to capabilities, performance, or training data freshness. Over time, foundation models might be deprecated because of obsolescence or your model's host preferences that are beyond your control.

You must design your workload to support the documented model life cycles of the models that you choose as dependencies. If you don't consider the models' life cycles, you might unnecessarily perform risky upgrades, introduce untested behavior changes, take unnecessary workload downtime, or experience outages because of the way that your hosting platform handles end-of-life models.

A workload that's designed to support the life cycles of its models is well suited for experimentation and safe migration to different foundation models as new foundation models enter the marketplace.

## Types of model updates

The scope of the model update in your generative AI solution can vary drastically, from upgrading for a minor revision change to choosing a new model family. There are various reasons you might choose to upgrade the model in your solution. The following table lists different update scopes, along with an example and benefits of making this upgrade.

| Scope of change | Benefit of updating model | Example |
| :--- | :--- | :--- |
| Minor version update | Delivers improved performance and refined capabilities, usually without requiring significant changes to your existing implementation | Moving from GPT-4o v2024-08-06 to GPT-4o v2024-11-20 |
| Intermediate version update | Provides substantial performance improvements, new capabilities, and enhanced reliability while maintaining most backward compatibility and requiring only moderate implementation adjustments | Moving from GPT-3 to GPT-35 |
| Major version update | Delivers transformational improvements in reasoning, capabilities, context size, and performance that justify the significant implementation changes and adjustment of prompts | Moving from GPT-3 to GPT-4 |
| Variant update | Provides specialized optimizations, such as increased processing speed and reduced latency, while maintaining the core architecture and usually ensuring backward compatibility with the base model | Moving from GPT-4 to GPT-4-Turbo |
| Generational version update | Delivers significant improvements in reasoning, multimodal capabilities, and performance that fundamentally expand the model's utility while potentially requiring complete reimagining of implementation strategies | Moving from GPT-4 to GPT-4o |
| Model change (general) | Provides access to specialized capabilities, different price-performance ratios, and potentially better alignment with specific use cases | Moving from GPT-4 to DeepSeek |
| Model change (specialized) | Provides domain-specific optimization, enhanced performance for particular tasks, and potentially lower costs compared to using general-purpose models for specialized applications | Moving from GPT-4 to Prizedata |
| Deployment option change | Provides greater control over infrastructure, customization options, and potential cost savings while allowing for specialized optimization and enhanced data privacy at the expense of increased management responsibility | Moving from Llama-1 hosted as managed online endpoint in Azure AI Foundry to self-hosting Llama-1 on a virtual machine |

As illustrated in the table, the benefits of moving to a new model are typically a combination of the following factors:

- Performance, such as speed and latency

- Capacity, such as throughput that's measured in transactions per minute

- Quota availability

- Cost efficiency

- Regional availability

- Multimodel capabilities

- Updated training knowledge

- Bug fixes

- Specialization or despecialization to better align with your use case

- Avoiding workload outages because of model host life cycle policies

## Model retirement behavior depends on your model deployment strategy

There are three key strategies for deploying models. It's important to understand how each strategy handles version retirements:

- **MaaS (Models as a Service):** Pretrained models exposed as APIs that provide scalability and ease of integration with the trade-off of potentially higher costs and lower control of the models. Examples of MaaS include models deployed in the Azure OpenAI service and models from the model catalog deployed as serverless APIs.

- **MaaP (Models as a Platform):** Models deployed and managed within a larger platform, such as models from the Azure model catalog deployed in [managed compute](/azure/ai-foundry/how-to/model-catalog-overview#managed-compute). This strategy usually provides greater control of the models but requires more management than MaaS.

- **Self-hosting models:** Models deployed on your own infrastructure. This deployment provides maximum control over the models but requires significant responsibility for infrastructure, management, and maintenance.

Both MaaS and MaaP strategies in Azure source models from the Azure AI model catalog. Models in the model catalog follow a life cycle where models are [deprecated](/azure/ai-foundry/concepts/model-lifecycle-retirement#deprecated) and then [retired](/azure/ai-foundry/concepts/model-lifecycle-retirement#retired). You must plan for these eventualities in your workload.

> [!WARNING]
> For MaaS services, including Azure OpenAI-deployed models and models deployed by using the serverless API model, it's crucial to understand that existing deployments for *retired* models return HTTP errors. If you don't upgrade to a supported model, your application no longer operates as expected. For *deprecated* models, you can't create new deployments for those models, but existing deployments continue to work until they're retired. For more information, see [Serverless API model deprecations and retirements](/azure/ai-foundry/concepts/model-lifecycle-retirement) and [Azure OpenAI Service model deprecations and retirements](/azure/ai-services/openai/concepts/model-retirements).

When you self-host models or use managed compute, you maintain full control and aren't required to update models. But you might want to replicate a model life cycle for the added benefits that a newer model can bring to your workload.

## Breadth of change for model updates

:::image type="complex" source="_images/model-lifecycle-breadth-change.svg" alt-text="Diagram that shows a chat scenario that shows the different breadths of change when you update a model." lightbox="_images/model-lifecycle-breadth-change.svg":::
   A diagram that shows an intelligent client connecting to an orchestrator. Three boxes point to the orchestrator with dashed lines: Configuration, Prompt, and Orchestration logic. The orchestrator has solid lines that point to three different AI models: model-x-v1, model-x-v1.1, and model-y-v1. The orchestrator also has an arrow that points to a box labeled API or agent. The API or agent box has a solid line that points to a box labeled Vector database. There's a pipeline with four steps that points to the vector database with a dashed line. The four steps are: Chunk documents, Enrich chunks, Embed chunks, and Persist chunks. Numbered circles annotate several parts of the diagram. The first circle is next to the models. The second circle is between prompt and configuration. The third circle is where the pipeline points to the vector database. The fourth circle is next to the orchestration logic. The fifth circle is next to the intelligent application. The sixth circle is below the models.
:::image-end:::

You need to evaluate how a model update affects your workload so that you can plan the transition from the old model to the new model. The extent of workload change depends on the functional and nonfunctional differences between the old and new models. The diagram shows a simplified chat architecture that has numbered sections that highlight areas where a model update might have an effect.

For each of these areas, consider downtime caused by updates and how you handle any requests that the system is processing. If maintenance windows are available for your workload, use those windows when the scope of change is large. If maintenance windows aren't available, address changes in these areas to maintain your workload's functionality and service-level objectives during the model update.

- **The model:** The obvious change is to the model itself. You deploy the new model by using your chosen model deployment strategy. You need to evaluate trade-offs between in-place upgrades versus side-by-side deployment.

   When you move to a new model revision from a fine-tuned model, you need to perform the fine-tuning on the new model version again before you use it. When you update to use a different model, you need to determine if fine-tuning is required.

- **The model configuration:** When you update the foundation model in your AI solution, you might need to adjust hyperparameters or configurations to optimize performance for the new model's architecture and capabilities. For example, switching from a transformer-based model to a recurrent neural network might require different learning rates and batch sizes to achieve optimal results.

- **The prompt:** When you change foundation models in your workload, you might need to adjust system prompts in your orchestrators or agents to align with the new model's strengths and capabilities.

   Along with updating the model configuration, updating the prompt is one of the most common changes when you update models. When you evaluate a new model, even for a minor version update, test changes to the prompt if it doesn’t meet your requirements. This approach ensures that you address performance problems before exploring other modifications. You need to address the prompt when you change to new models. It's also likely that you need to address the prompt when you make large revision changes.

- **The orchestration logic:** Some model updates, especially when you take advantage of new features, require you to make changes to your orchestration or agent logic.

   For example, if you update your model to GPT-4 to take advantage of [function calling](/azure/ai-services/openai/how-to/function-calling), you have to change your orchestration logic. Your old model returned a result that you could return to the caller. With function calling, the call to the model returns a function that your orchestration logic must call. In Azure, it's typical to implement orchestration logic in the [Azure AI Agent Service](/azure/ai-services/agents/overview) or by using code based solutions like [Semantic Kernel](/semantic-kernel/overview/) or [LangChain](/azure/ai-foundry/how-to/develop/langchain) hosted in Azure.

- **The grounding data:** Some model updates and larger scoped changes might require you to make changes to your grounding or fine-tuning data or how you retrieve that data.

   For example, when you move from a generalized model to a domain-specific model, such as a model focused on finance or medicine, you might no longer need to pass domain-specific grounding data to the model. Another example is when a new model can handle a larger context window. In this scenario, you might want to retrieve additional relevant chunks or tune the size of your chunks. For more information, see [Design and develop a retrieval-augmented generation (RAG) solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

- **Hardware:** For models that run in MaaP, a model change might require new hardware. Only specific compute SKUs are enabled for models from the catalog. Also, hardware can be deprecated, which requires you to run the model on new hardware.

## Design for change

You will most likely update models in your workload. If you use the MaaS deployment strategy in Azure, models are retired and you need to upgrade to a newer version. You might also choose to move to different models or model versions to take advantage of new features, lower pricing, or improved performance. Either way, your architecture must support updating the model that your generative AI workload uses.

The previous section discussed the [different breadths of change](#breadth-of-change-for-model-updates). You should follow proper machine learning operations (MLOps), data operations (DataOps), and generative AI operations (GenAIOps) practices to build and maintain automated pipelines for model fine-tuning, your DataOps, and GenAIOps like prompt engineering, changing hyperparameters, and orchestration logic.

Updates to the hyperparameters and the prompt are common in most model updates. Because these changes are so common, your architecture should support a controlled change mechanism for these areas. An important consideration is that prompts and hyperparameters are designed for specific model versions. You need to ensure that the prompts and hyperparameters are always used with the correct model and version.

### Automated pipelines

Implement automated pipelines that allow you to test and evaluate the differing aspects of your generative AI application:

- **MLOps:** Follow the guidance in [MLOps](/azure/architecture/ai-ml/guide/machine-learning-operations-v2) to build pipelines for model fine-tuning, if applicable.

- **GenAIOps:** Implement GenAIOps pipelines to [test and evaluate changes to the model, model hyperparameters, the prompt, and changes to orchestration logic](/azure/architecture/ai-ml/guide/genaiops-for-mlops#rag-and-prompt-engineering-2).

- **DataOps:** Implement [DataOps](/azure/architecture/ai-ml/guide/genaiops-for-mlops#dataops) pipelines to [test and evaluate changes to your RAG grounding data](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

You should implement pipelines for the following reasons:

- To help you in your iterative development and experimentation. (Inner loop)
- To perform safe deployment and operationalization of your generative AI solution. (Outer loop)

When possible, use the same baseline data that you use with the production application to test the changes to your generative AI application. This approach might not be possible if the updated application uses new model features that require a change to the data.

### Architecture considerations

In simple architectures, like the following architecture, the client directly calls the model with the correct prompt version and configuration. If there are changes to the prompt, a new client is deployed with the new prompt and it calls the new model. Tying the prompt, configuration, and model versions isn't a challenge.

:::image type="complex" source="_images/model-lifecycle-direct-access-from-client.svg" alt-text="Diagram of a chat scenario that shows an intelligent app directly accessing a model." lightbox="_images/model-lifecycle-direct-access-from-client.svg":::
   A diagram that shows an intelligent client connecting directly to a model. The intelligent app shows three elements that point to it, which illustrates that it contains those elements. The elements are the configuration, the prompt, and orchestration logic.
:::image-end:::

Production architectures aren't simple. You generally implement an orchestrator or agent whose responsibility is to manage the flow of the interactions between any knowledge database and the models. Your architecture might also implement one or more layers of abstraction, such as a router or a gateway:

- **Router:** A router directs traffic to different orchestrator deployments. A router is useful in deployment strategies such as blue-green deployments where you might choose to route a specific percentage of traffic to a new orchestrator version as part of your safe deployment practices. This component can also be used for A/B testing or traffic mirroring to evaluate tested, but unvalidated, changes with production traffic.

- **Gateway:** It's common to [proxy access to AI models for various reasons](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide), including load balancing or failover between multiple back-end instances, implementing custom authentication and authorization, and implementing logging and monitoring for your models.

:::image type="complex" source="_images/model-lifecycle-layers-of-abstraction.svg" alt-text="Diagram of a chat scenario that shows two common layers of abstraction in a generative AI workload." lightbox="_images/model-lifecycle-layers-of-abstraction.svg":::
   A diagram that shows an intelligent client connecting to a router. The router has connections to two deployment boxes. Each deployment box has a connection line to the gateway box. The gateway box has connection lines to three different models boxes: model-x-v1, model-x-v1.1, and model-y-v1. The orchestrator boxes connect to an API or agent box, which connects to a knowledge database box. Arrows point to the router and gateway boxes with a label that reads Common layers of abstraction in a generative AI workload.
:::image-end:::

Because of the layers of indirection involved, your architecture must be designed to support sending specific versions of prompts to specific models or model versions. For instance, you might have a prompt in production, prompt1, that's designed for model1. If you upgrade to model1.1, you might need to update the prompt1 to prompt2. In this example, your architecture needs to always use prompt1 with model1 and prompt2 with model1.1.

#### Router

The following diagram illustrates an architecture that uses a router to route requests to multiple deployments. An [example of this architecture with Azure AI Foundry](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#architecture) uses a managed online endpoint as the router and the different versions of the orchestrator are deployed to managed compute.

:::image type="complex" source="_images/model-lifecycle-single-layer-abstraction.svg" alt-text="Diagram of a chat scenario that uses a router to route between deployments." lightbox="_images/model-lifecycle-single-layer-abstraction.svg":::
   A diagram that shows an intelligent client connecting to a router (labeled 1). The router has connections to two deployment boxes that are contained in an Orchestrator box (labeled 2). In each deployment box, there's configuration, a prompt (labeled 3), and orchestration logic (labeled 4). Each deployment box has a connection line to a specific model box (labeled 5). Deployment 1 is connected to model-x-v1, while Deployment 2 is connected to model-x-v1.1. The orchestrator box connected to an API or agent box, which connects to a knowledge database box. Arrows point to the router and gateway boxes with a label that reads Common layers of abstraction in a generative AI workload.
:::image-end:::

The following flow describes how different deployments of an orchestrator call the correct model. Each deployment has its own version of model configuration and a prompt:

1. A user issues a request from an intelligent application and that request is sent to a router.

1. The router routes to either Deployment 1 or Deployment 2 of the orchestrator, depending on its logic.

1. Each deployment has its own version of the prompt and configuration.

1. The orchestrator is configured with the specific model and version. It uses this information to call the appropriate model and version directly.

1. Because the specific version of the prompt is deployed along with the orchestrator that's configured with the specific model and version, the correct prompt is sent to the correct model version.

#### Gateway

The following diagram illustrates an architecture that uses a router to route requests to multiple deployments. However, in this architecture, all model requests are routed through a gateway. It's common to [proxy access to AI models for various reasons](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide), including load balancing, failover between multiple back-end instances in a single or in multiple regions, and implementing a provisioned throughput unit with a pay-as-you-go spillover strategy.

:::image type="complex" source="_images/model-lifecycle-two-layers-abstraction.svg" alt-text="Diagram of a chat scenario that uses a router to route between deployments and a gateway to route between models." lightbox="_images/model-lifecycle-two-layers-abstraction.svg":::
   A diagram that shows an intelligent client connecting to a router (labeled 1). The router has connections to two deployment boxes that are contained in an Orchestrator box (labeled 2). In each deployment box, there's configuration, a prompt (labeled 3), and orchestration logic (labeled 4). Each deployment box has a connection line to a gateway box (labeled 5). Each connector line has a label that shows an HTTP header, which indicates the model and version. Deployment 1 indicates model-x-v1, while Deployment 2 indicates model-x-v1.1. The gateway box has connectors to model-x-v1 box and model-x-v1.1 box (labeled 6). The orchestrator box connected to an API or agent box, which connects to a knowledge database box. Arrows point to the router and gateway boxes with a label that reads Common layers of abstraction in a generative AI workload.
:::image-end:::

The following flow describes how different deployments of an orchestrator call the correct model through a gateway. Each deployment has its own version of model configuration and a prompt:

1. A user issues a request from an intelligent application and that request is sent to a router.

1. The router routes to either Deployment 1 or Deployment 2, depending on its logic.

1. Each deployment has its own version of the prompt.

1. The orchestrator is configured with the specific model and version. It uses this information to set an HTTP header that indicates the correct model and version to call.

1. The orchestrator calls the gateway. The request contains the HTTP header that indicates the name and version of the model to use.

1. The gateway uses the HTTP header to route the request to the appropriate model and version. It might also apply configuration defined at the gateway.

### Externalize configuration

The [External Configuration Store](/azure/architecture/patterns/external-configuration-store) cloud design pattern is a good way to handle storing prompts and configuration. For some scopes of model changes, you might be able to coordinate the model deployment with the system prompt and configuration changes if they're stored in an updatable location outside of your orchestrator or agent's code. This approach won't work if you have orchestration logic to adjust, but is useful in many smaller scope model updates.

### Compute choice

For MaaP hosting, models are often limited to a subset of host-provided compute. All compute is subject to quota, availability constraints, and end-of-life announcements. Use the routing patterns to support transition to new hardware when your current hardware is no longer supported or there are constraints that prevent additional scale out.

An example of an end-of-life announcement is [NC A100 vv4 series of compute announcement](/azure/virtual-machines/sizes/retirement/nc-series-retirement). If you host models on this hardware, you have to transition to another supported SKU that isn't end-of-life and has more availability. This transition might also concurrently require a model change if the new SKU doesn't support your current model.

## Recommendations

- Add layers of abstraction and indirection to enable controlled modifications to specific areas of your workload. These areas include the client, intelligent application API, orchestration, model hosting, and grounding knowledge.

- All changes to model versions, prompts, configuration, orchestration logic, and grounding knowledge retrieval must be tested before use in production. Ensure that tested combinations are *pinned together* in production, which means that they remain tightly linked when deployed. A/B testing, load balancing, and blue-green deployments must not mix components to avoid exposing users to untested combinations.

- Test and evaluate new versions and new models by using automated pipelines. You should compare the results to the results of your baseline to ensure that you get the results that you require.

- Be intentional about updating models. Avoid using platform features that auto-upgrade production models to new versions without opportunity to test. You need to be aware of how every model update affects your workload. If you use [Azure AI model inference](/azure/ai-foundry/model-inference/concepts/model-versions#how-model-versions-work), set your deployments with a specific version and don't provide an upgrade policy. This setup requires a manual upgrade if a new version is released. For Azure OpenAI, set deployments to [No Auto Upgrade](/azure/ai-services/openai/concepts/model-versions#how-model-versions-work) to turn off auto-upgrades.

- Ensure that your observability and logging solution collects enough metadata to correlate observed behavior with the specific prompt, configuration, model, and data retrieval solution involved. This correlation enables you to identify unexpected regressions in system performance.

## Summary

There are various reasons to update the foundational model in your generative workload. These reasons range from required version upgrades when models are retired to the decision to switch to a different model. Depending on the scope of the model update, you might need to implement and evaluate changes to the model, if it's fine-tuned, the prompt, your model configuration, your orchestration logic, or your data pipeline. You should follow MLOps, DataOps, and GenAIOps guidance to build automated workflows for the different aspects of your solution. Automated workflows enable you to test, evaluate, and deploy new versions. You also need to ensure that your architecture supports running multiple versions of an orchestrator where each version ties its configuration and prompt version to a specific model version.

Your architecture should support updates to new or different models and any necessary changes to the prompt or model configuration, without requiring modifications to the intelligent application or the user experience. These updates should be encapsulated within their appropriate components and your operations should automate the testing, evaluation, and deployment of those changes.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer  

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GenAIOps for MLOps practitioners](/azure/architecture/ai-ml/guide/genaiops-for-mlops)
- [Azure OpenAI Service model deprecations and retirements](/azure/ai-services/openai/concepts/model-retirements)

## Related resources

- [Baseline OpenAI end-to-end chat reference architecture](../architecture/baseline-openai-e2e-chat.yml)
- [MLOps](machine-learning-operations-v2.md)
