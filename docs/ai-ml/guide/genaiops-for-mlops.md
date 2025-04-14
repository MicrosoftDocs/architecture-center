---
title: Generative AI Ops for Organizations with MLOps Investments
description: Extend existing MLOps investments to include generative AI ops. Learn where you can apply existing investments and where you need to extend those investments.
author: robbagby
ms.author: robbag
ms.date: 04/09/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.custom: arb-aiml
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# GenAIOps for MLOps practitioners

This article provides guidance to workload teams that have existing machine learning operations (MLOps) investments and want to extend those investments to include generative AI technology and patterns in their workload. To operationalize generative AI workload features, you need to extend your MLOps investments with Generative AI Ops (GenAIOps, sometimes known as LLMOps). This article outlines technical patterns that are common to both traditional machine learning and generative AI workloads, and specific patterns for generative AI. The article helps you understand where you can apply existing investments in operationalization and where you need to extend those investments.

The planning and implementation of MLOps and GenAIOps are part of a core design area in AI workloads on Azure. To get a background on why these workloads need specialized operations, see [MLOps and GenAIOps for AI workloads on Azure](/azure/well-architected/ai/mlops-genaiops) in the Azure Well-Architected Framework.

## Generative AI technical patterns

Generative AI workloads differ from traditional machine learning workloads in a few ways:

- **Focus on generative models.** Traditional machine learning workloads focus on training new models to perform specific tasks. Generative AI workloads consume and sometimes finetune generative models that can address a wider variety of use cases, and in some cases are multi-modal.

- **Focus on extending the models.** The key asset in traditional machine learning is the trained and deployed model. Access to the model is provided to client code in one or more workloads, but the workload typically isn't part of the MLOps process. With generative AI solutions, a key facet of the solution is the prompt provided to the generative model. The prompt must be composed of instructions and often contains context data from one or more data stores. The system that orchestrates the logic, calls to the various back ends or agents, generates the prompt, and calls to the generative model, is part of the generative AI system that you govern with GenAIOps.

Although some generative AI solutions use traditional machine learning practices like model training and fine-tuning, these solutions introduce new patterns that you should standardize. There are three broad categories of technical patterns for generative AI solutions:

- Pretraining and fine-tuning
- Prompt engineering
- Retrieval-augmented generation (RAG)

### Training and fine-tuning language models

Many generative AI solutions use existing foundation language models that don't require fine-tuning before use. However, some use cases can benefit from fine-tuning a foundation model or training a new generative AI model, like a small language model (SLM).

Training a new SLM and fine-tuning a generative foundation model are logically the same processes as training traditional machine learning models. These processes should use your existing MLOps investments.

### Prompt engineering

Prompt engineering includes all the processes involved in designing an effective prompt that's sent as input to a generative model. There's generally an orchestrator that controls a workflow that generates the prompt. The orchestrator can call into any number of data stores directly or indirectly through agents to gather information, like grounding data, and apply the required logic to generate the most effective prompt. The orchestrator is then deployed as an API endpoint that's accessed by client code in an intelligent application.

The following diagram shows an architecture for prompt engineering.

:::image type="complex" source="_images/prompt-engineering-architecture.svg" lightbox="_images/prompt-engineering-architecture.png" alt-text="Diagram that shows an architecture for prompt engineering." border="false":::
   The diagram illustrates a flow. The flow starts with a user. From there, it goes to an intelligent application. The intelligent application and a headless intelligent application flow to an orchestrator. The orchestrator flows to data stores and, by way of a prompt, to Azure OpenI Service.
:::image-end:::

This category of technical patterns can address many use cases, including:

- Classification
- Translation
- Summarization
- Retrieval-augmented generation, which is discussed in the next section

### Retrieval-augmented generation

Retrieval-augmented generation (RAG) is an architectural pattern that uses prompt engineering to incorporate domain-specific data as the grounding data for a language model. The language model is trained against a specific set of data. Your workload might require reasoning over data that's specific to your company, customers, or domain. In RAG solutions, your data is queried, and the most relevant results are provided to the language model as part of the prompt, usually through an orchestration layer.

A common RAG implementation is to break up your source data into chunks and store them in a vector store along with metadata. Vector stores, such as Azure AI Search, allow you to perform both textual and vector similarity searches to return contextually relevant results. RAG solutions can also [use other data stores](/azure/architecture/guide/technology-choices/vector-search) to return grounding data.

The following diagram illustrates a RAG architecture involving data from documents:

:::image type="complex" source="_images/rag-architecture.svg" lightbox="_images/rag-architecture.png" alt-text="Diagram that shows a RAG architecture." border="false":::
   The diagram illustrates two flows. The first flow starts with a user and then flows to an intelligent application. From there, the flow leads to an orchestrator. From the orchestrator, the flow leads to Azure OpenAI Service and to Azure AI Search, which is the last item in the second flow. The second flow starts with documents and then flows to four stages: chunk documents, enrich chunks, embed chunks, and index chunks. From there, the flow leads to the same Azure AI Search instance that connects to the first flow.
:::image-end:::

## Extending MLOps for generative AI technical patterns

Your MLOps process addresses both inner loop and outer loop processes. Generative AI technical patterns also have many of the same activities. In some cases, you apply your existing MLOps investments and in others, you need to extend them:

- **Inner loop**
  - [DataOps](#dataops)
  - [Experimentation](#experimentation)
  - [Evaluation](#evaluation-and-experimentation)

- **Outer loop**
  - [Deployment](#deployment)
  - [Inferencing and monitoring](#inferencing-and-monitoring)
  - Feedback loop

### DataOps

Both MLOps and GenAIOps apply the fundamentals of DataOps to create extensible and reproducible workflows that ensure that data is cleaned, transformed, and formatted correctly for experimentation and evaluation. Workflow reproducibility and data versioning are important features of DataOps for all technical patterns. The sources, types, and intent of the data are pattern dependent.

#### Training and fine-tuning

This technical pattern should fully take advantage of the existing DataOps investments that you made as part of your MLOps implementation. Reproducibility and data versioning allow you to experiment with different feature engineering data, compare the performance of the different models, and reproduce results.

#### RAG and prompt engineering

The intent for the data in RAG solutions is to provide grounding data (context) that's presented to the language model as part of a prompt. RAG solutions often require the processing of large documents or data sets into a collection of right-sized, semantically relevant chunks, and persisting those chunks in a vector store. See [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) for details. Reproducibility and data versioning for RAG solutions allows you to experiment with different chunking and embedding strategies, compare performance, and roll back to previous versions.

Data pipelines for chunking documents aren't part of DataOps in traditional MLOps, so you have to extend your architecture and operations. The data pipelines can read data from disparate sources that include both structured and unstructured data. They can also write the transformed data to different targets. You must extend your pipelines to include the data stores that you use for grounding data. Common data stores for these patterns are vector stores like AI Search.

As with training and fine-tuning, you can use Azure Machine Learning pipelines or other data pipelining tools to orchestrate the stages of chunking. You can take advantage of prompt flows in Azure Machine Learning pipelines to process and enrich your data in a consistent and reproducible manner.

##### Search index maintenance

You also must extend your operations to maintain the freshness and validity of the search indexes in your data stores. These indexes might need to be periodically rebuilt if you can't incrementally add, remove, or update data in place. Index updates must meet the business requirements for data freshness, the nonfunctional requirements, such as performance and availability, and the compliance requirements, such as *right to be forgotten* requests. You need to extend your existing MLOps process to account for this data management activity.

### Experimentation

Experimentation, a part of the inner loop, is the iterative process of creating, [evaluating](#evaluation-and-experimentation), and refining your solution. The following sections discuss experimentation for the common generative AI technical patterns.

#### Training and fine-tuning

When you fine-tune an existing language model or train a small language model, you can take advantage of your current MLOps investments. For instance, Azure Machine Learning pipelines provide a toolkit for conducting experiments efficiently and effectively. These pipelines enable you to manage the entire fine-tuning process, from data preprocessing to model training and evaluation.

#### RAG and prompt engineering

Experimentation with prompt engineering and RAG workloads requires you to extend your MLOps investments. For these technical patterns, the workload doesn't end with the model. The workload requires an orchestrator, which is a system that can run logic, call data stores or agents for required information like grounding data, generate prompts, call language models, and more. The data stores and the indexes in the stores are also part of the workload. You need to extend your operations to govern these aspects of the workload.

You can experiment on multiple dimensions for prompt engineering solutions, including different instructions, personas, examples, constraints, and advanced techniques like prompt chaining. When you [experiment with RAG solutions](rag/rag-solution-design-and-evaluation-guide.md), you can experiment with other areas as well:

- Chunking strategy
- What and how to enrich chunks
- Your embedding model
- Configuration of your search index
- What searches to perform (vector, full text, hybrid, and so on)

As discussed in [DataOps](#dataops), reproducibility and data versioning are key to experimentation. A good experimentation framework enables you to store inputs, such as changes to hyperparameters or prompts, along with outputs to be used when you [evaluate the experiment](#evaluation-and-experimentation).

As in your existing MLOps environment, you can take advantage of frameworks like Azure Machine Learning pipelines. Azure Machine Learning pipelines have features that support indexing by integrating with vector stores like AI Search. Your GenAIOps environment can take advantage of these pipeline features and combine them with prompt flow features that manage prompt engineering and custom preprocessing logic.

### Evaluation and experimentation

Evaluation is key in the iterative experimentation process of building, evaluating, and refining your solution. The evaluation of your changes provides the feedback that you need to make your refinements or validate that the current iteration meets your requirements. The following sections discuss evaluation in the experimentation phase for the common generative AI technical patterns.

#### Training and fine-tuning

For the evaluation of fine-tuned or trained generative AI models, you should take advantage of your existing MLOps investments. For example, if you use Azure Machine Learning pipelines to orchestrate your machine learning model training, you can use the same evaluation features to fine-tune foundation language models or train new small language models. These features include the [Evaluate Model component](/azure/machine-learning/component-reference/evaluate-model), which computes industry-standard evaluation metrics for specific model types and compares results across models. If your workload is using Azure AI Foundry, you could instead extend your MLOps process to include its [evaluation capabilities](/azure/ai-foundry/how-to/develop/evaluate-sdk) found in the Evaluation SDK.

#### RAG and prompt engineering

You need to extend your existing MLOps investments to evaluate generative AI solutions. You can use tools like prompt flow, which provides a framework for evaluation. Prompt flow enables teams to define custom evaluation logic by specifying criteria and metrics to assess the performance of various [prompt variants](/azure/machine-learning/prompt-flow/concept-variants) and large language models (LLMs). This structured approach allows you to compare different configurations side by side, like hyperparameter or architectural variations, to identify the optimal setup for specific tasks.

Jobs in prompt flow automatically capture input and output data throughout the experimentation process to create a comprehensive trial record. You can gain insights and identify promising configurations that can inform future iterations by analyzing this data. You can accelerate the development of your generative AI solutions by using prompt flows to conduct efficient and systematic experimentation.

The experimentation process is the same regardless of the use case for your generative AI solution. These use cases include classification, summarization, translation, and even RAG. The important difference is the metrics that you use to evaluate the different use cases. Following are some metrics, based on use case, to consider.

- Translation: BLEU
- Summarization: ROUGE. BLEU, BERTScore, METEOR
- Classification: Precision, Recall, Accuracy, Cross-entropy
- RAG: Groundedness, Relevancy

> [!NOTE]
> See [LLM end-to-end evaluation](rag/rag-llm-evaluation-phase.md) for more information on evaluating language models and RAG solutions.

In general, generative AI solutions extend the responsibilities of the machine learning team from training models to prompt engineering and managing grounding data. Because prompt engineering and RAG experimentation and evaluation don't necessarily require data scientists, you might be tempted to use other roles, like software engineers and data engineers, to perform these functions. You'll experience challenges if you omit data scientists from the process of experimenting with prompt engineering and RAG solutions. Other roles aren't commonly trained on scientifically evaluating the results, as many data scientists are. Read the seven-part article series [Designing and developing a RAG solution](rag/rag-solution-design-and-evaluation-guide.md) to get an understanding of the complexity of designing generative AI solutions.

Investing in generative AI solutions enables you to take some pressure off your data science resources. The role of software engineers expands in these solutions. For example, software engineers are great resources for managing the orchestration responsibility in generative AI solutions, and they're adept at setting up the evaluation metrics in tools like prompt flow. It's important to have data scientists review this work. They have the training and experience to understand how to properly evaluate the experiments.

### Deployment

Some generative AI solutions involve deploying custom-trained models or fine-tuning existing models, but others don't. For generative AI solutions, you need to include the additional tasks of deploying the orchestrators and any data stores. The following sections discuss deployment for common generative AI technical patterns.

#### Training and fine-tuning

You should use your existing MLOps investments, with some possible adjustments, to deploy generative AI models and fine-tune foundation models. For example, to fine-tune a large language model in Azure OpenAI, you need to ensure that your training and validation datasets are in JSONL format, and you need to upload the data via a REST API. You also need to create a fine-tuning job. To deploy a trained small language model, you can take advantage of your existing MLOps investments.

#### RAG and prompt engineering

For RAG and prompt engineering, there are other concerns, including orchestration logic, changes to data stores like indexes and schemas, and changes to data pipeline logic. Orchestration logic is typically encapsulated in frameworks like prompt flow, Semantic Kernel, or LangChain. You can deploy the orchestrator to different compute resources, including resources that you might currently deploy custom models to. See [Azure OpenAI end-to-end chat architecture](../architecture/baseline-openai-e2e-chat.yml) for examples of deploying prompt flow to either online endpoints managed by Azure Machine Learning or to Azure App Service. To deploy to App Service, the Azure OpenAI chat architecture packages the flow and its dependencies as a container, a practice that increases portability and consistency across different environments.

Deployments of changes to database resources, like changes to data models or indexes, are new tasks that need to be handled in GenAIOps. A common practice when working with large language models is to [use a gateway in front of the LLM](azure-openai-gateway-guide.yml).

Many generative AI architectures that consume platform-hosted language models, like those served from Azure OpenAI, include a [gateway like Azure API Management](azure-openai-gateway-guide.yml#implementation-options). The gateway use cases include load balancing, authentication, and monitoring. The gateway can play a role in deployment of newly trained or fine-tuned models, allowing you to progressively roll out new models. The use of a gateway, along with model versioning, enables you to minimize risk when you deploy changes and to roll back to previous versions when problems occur.

Deployments of elements that are specific to generative AI, such as the orchestrator, should follow proper operational procedures, like:

- Rigorous testing, including unit tests
- Integration tests
- A/B tests
- End-to-end tests
- Roll-out strategies, like canary or blue/green deployments

Because the deployment responsibilities for generative AI applications extend beyond model deployment, you might need additional job roles to manage the deployment and monitoring of things like the user interface, the orchestrator, and the data stores. These roles are often aligned to DevOps engineer skill sets.

### Inferencing and monitoring

Inferencing is the process of passing input to a trained and deployed model, which then generates a response. You should monitor both traditional machine learning and generative AI solutions from three perspectives: operational monitoring, learning from production, and resource management.

#### Operational monitoring

Operational monitoring is the process of observing the ongoing operations of the system, including data operations (DataOps) and model training. This type of monitoring looks for deviations, including errors, changes to error rates, and changes to processing times.

For model training and fine-tuning, you generally observe the data operations for processing feature data, model training, and fine-tuning. The monitoring of these inner-loop processes should take advantage of your existing MLOps and DataOps investments.

For prompt engineering in generative AI solutions, you have extra monitoring concerns. You must monitor the data pipelines that process the grounding data or other data that's used to generate prompts. This processing might include data store operations like building or rebuilding indexes.

In a multi-agent system, you need to monitor the availability, performance characteristics, and response quality & consistency of the agents that your orchestrator interfaces with.

#### Learning from production

A critical aspect to monitoring during the inferencing stage is learning from production. Monitoring for traditional machine learning models tracks metrics like accuracy, precision, and recall. A key goal is to avoid prediction drift. Solutions that use generative models to make predictions, for example, using a GPT model for classification, should take advantage of your existing MLOps monitoring investments.

Solutions that use generative models to reason over grounding data use [metrics like groundedness, completeness, utilization, and relevancy](rag/rag-llm-evaluation-phase.md#language-model-evaluation-metrics). The goal is to ensure that the model fully answers the query and bases the response on its context. Here, you need to try to prevent problems like data drift. You want to ensure that the grounding data and the prompt that you provide to the model are maximally relevant to the user query.

Solutions that use generative models for nonpredictive tasks, like RAG solutions, often benefit from human feedback from end users to evaluate usefulness sentiments. User interfaces can capture feedback like thumbs up or down, and you can use this data to periodically evaluate the responses.

A common pattern for generative AI solutions is to [deploy a gateway in front of the generative models](azure-openai-gateway-guide.yml). One of the [use cases for the gateway is for monitoring the foundation models](azure-openai-gateway-monitoring.yml). You can use the gateway to log input prompts and output.

Another key area to monitor for generative solutions is content safety. The goal is to moderate responses and detect harmful or undesirable content. [Azure AI Content Safety Studio](/azure/ai-services/content-safety/overview#content-safety-studio) is an example of a tool that you can use to moderate content.

#### Resource management

Generative solutions that use models exposed as a service, like Azure OpenAI, have different resource management concerns than models that you deploy yourself. For models that are exposed as a service, you aren't concerned with the infrastructure. Instead, you're concerned with your service throughput, quota, and throttling. Azure OpenAI uses tokens for billing, throttling, and quotas. You should monitor quota usage for cost management and performance efficiency. Azure OpenAI enables you to log token usage.

## Tooling

Many MLOps practitioners have standardized on a toolkit for organizing various activities for automation, tracking, deployment, experimentation, and so on, to abstract away the common concerns and implementation details of those processes. A common unified platform is [MLflow](/azure/machine-learning/concept-mlflow). Before you look for new tools to support GenAIOps patterns, you should review your existing MLOps tooling to evaluate its support for generative AI. For example, MLflow supports a [wide range features for language models](https://mlflow.org/docs/latest/llms/index.html).

You can also explore the benefits and tradeoffs introducing new tools into your flow. For example, the [Azure AI Evaluation SDK](/python/api/overview/azure/ai-evaluation-readme) for Python could be considered as it has native support in the Azure AI Foundry portal.

## MLOps and GenAIOps maturity models

You might have used the [MLOps maturity model](mlops-maturity-model.yml) to evaluate the maturity of your current machine learning operations and environment. As you extend your MLOps investments for generative AI workloads, you should use the GenAIOps [maturity model](/azure/machine-learning/prompt-flow/concept-llmops-maturity) to evaluate those operations. You might be tempted to combine the two maturity models, but we recommend that you measure each independently. MLOps and GenAIOps will evolve independently from each other. For example, you might be at level four in the MLOps maturity model but at level one for generative AI.

Use the [GenAIOps maturity model assessment](/assessments/e14e1e9f-d339-4d7e-b2bb-24f056cf08b6/). This assessment helps you understand how your investments in GenAIOps are progressing.

## Summary

As you start extending your MLOps investments to include generative AI, it's important to understand that you don't need to start over. You can use your existing MLOps investments for some of the generative AI technical patterns. Fine-tuning generative models is a great example. There are areas of generative AI solutions, like prompt engineering and RAG, that are new processes, so you need to extend your existing operations investments and gain new skills.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Luiz Braz](https://www.linkedin.com/in/lfbraz/) | Senior Technical Specialist
- [Marco Aurelio Cardoso](https://www.linkedin.com/in/marco-cardoso/) | Senior Software Engineer  
- [Paulo Lacerda](https://www.linkedin.com/in/paulolacerda/) | Cloud Solution Architect  
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer  

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Machine Learning](/azure/machine-learning)
- [Azure OpenAI Service](/azure/ai-services/openai/overview)

## Related resources

- [Azure OpenAI](rag/rag-solution-design-and-evaluation-guide.md)
- [Designing and developing a RAG solution](rag/rag-solution-design-and-evaluation-guide.md)
- [Baseline OpenAI end-to-end chat reference architecture](../architecture/baseline-openai-e2e-chat.yml)
- [Machine learning operations](machine-learning-operations-v2.md)
