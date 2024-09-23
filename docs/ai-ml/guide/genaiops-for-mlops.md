---
title: Generative AI Ops for organizations with existing MLOps investments
description: Guidance to workload teams that have existing MLOps investments and are interested in extending those investments to include generative AI in their workload.
author: robbagby
ms.author: robbag
ms.date: 09/25/2024
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

This article provides guidance to workload teams that have existing MLOps investments and are interested in extending those investments to include generative AI in their workload. To operationalize a generative AI workload, you need to extend your MLOps investments with GenAIOps (sometimes narrowly known as LLMOps). This article outlines technical patterns that are common between traditional machine learning and generative AI workloads, and specific patterns for generative AI. The article helps you understand where you're able to apply existing investments in operationalization and where you need to extend those investments.

## Generative AI technical patterns

Generative AI workloads differ from traditional machine learning workloads in a few ways:

- **Focus on generative models** - Traditional machine learning workloads center on training new models that are trained to perform specific tasks. Generative AI workloads consume generative models that can be used to address a wider variety of use cases, and in some cases are multi-modal.

- **Focus on extending the models** - The key asset in traditional machine learning is the deployed model. Access to the model is provided to client code in one or more workloads, but the workload is not part of the MLOps process. With generative AI solutions, a key facet of the solution is the prompt that is provided to the generative model. The prompt must be composed and can contain data from one or more data stores. The system that orchestrates the logic, calls to the various back ends, generates the prompt, and calls to the generative model is part of the generative AI system that you must govern with GenAIOps.

While some generative AI solutions use traditional machine learning practices such as model training and fine tuning, they all introduce new patterns that you should standardize. This section provides an overview of the three broad categories of technical patterns for generative AI solutions:

- Pre-training and fine tuning
- Prompt engineering
- Retrieval-augmented generation (RAG)

### Training and fine-tuning language models

Currently, many generative AI solutions use existing foundation language models that don't require fine-tuning before use. That said, there are use cases that can and do benefit from either fine-tuning a foundation model or training a new generative AI model, such as a small language model (SLM).

Training a new SLM or fine-tuning a generative foundation model are logically the same processes as training traditional machine learning models. These processes should use your existing MLOps investments.

### Prompt engineering

Prompt engineering includes all the processes involved in generating a prompt that is sent as input to a generative model. There's generally an orchestrator that controls a workflow that generates the prompt. The orchestrator can call into any number of data stores to gather information, such as grounding data, and apply the required logic to generate the most effective prompt. The orchestrator is then deployed as an API endpoint that is accessed by client code in an intelligent application.

:::image type="complex" source="_images/prompt-engineering-architecture.svg" lightbox="_images/prompt-engineering-architecture.png" alt-text="Diagram showing prompt engineering architecture." border="false":::
   The diagram shows a series of boxes pointing to other boxes, illustrating a flow. There's user icon pointing to a box called intelligent application. Along with the intelligent application box, is another box called headless intelligent applications. Both the intelligent application and the headless intelligent application boxes are pointing to box called orchestrator. The orchestrator box points to two boxes: a data stores box and the Azure OpenAI service box. The arrow from the orchestrator to the Azure OpenAI service box is annotated with the word 'Prompt.'
:::image-end:::
*Figure 1. Prompt engineering architecture*

This category of technical patterns can address many use cases, including:

- Classification
- Translation
- Summarization
- Retrieval-augmented generation which is discussed in the next section

### Retrieval-augmented generation

Retrieval-augmented generation (RAG) is an architectural pattern that uses prompt engineering whose goal is to use domain specific data as the grounding data for a language model. The language model is trained against a specific set of data. Your workload may require reasoning over data specific to your company, customers, or domain. With RAG solutions, your data is queried, and the results are provided to the language model as part of the prompt, usually through an orchestration layer.

A common RAG implementation is to break up your documents into chunks and store them in a vector store along with metadata. Vector stores, such as Azure AI Search, allow you to perform both textual and vector similarity searches to return contextually relevant results. RAG solutions can also [use other data stores](/azure/architecture/guide/technology-choices/vector-search) to return grounding data.

:::image type="complex" source="_images/rag-architecture.svg" lightbox="_images/rag-architecture.png" alt-text="Diagram showing retrieval-augmented generation (RAG) architecture." border="false":::
   The diagram shows two flows. The first flow shows a user with an arrow pointing to a box called 'Intelligent application.' The 'Intelligent application' box points to an 'Orchestrator' box. The 'Orchestrator' box points to both an 'Azure OpenAI service' box and an 'Azure AI Search' box. The other flow shows 'Documents' to a process flow with the following steps: 1. Chunk documents, 2. Enrich chunks, 3. Embed chunks, and 4. Persist chunks. That process flow points to the same 'Azure AI Search box' as the first flow.
:::image-end:::
*Figure 2. Retrieval-augmented generation (RAG) architecture*

## Extending MLOps for generative AI technical patterns

In this section, we examine the following key aspects of the inner and outer loop phases for the generative AI technical patterns to see where you can apply your existing MLOps investments and where you need to extend them:

- **Inner loop**
  - [DataOps](#dataops)
  - [Experimentation](#experimentation)
  - [Evaluation](#evaluation-and-experimentation)

- **Outer loop**
  - [Deployment](#deployment)
  - [Inferencing/monitoring](#inferencing-and-monitoring)
  - Feedback loop

### DataOps

Both MLOps and GenAIOps use the fundamentals of DataOps to create extensible and reproducible workflows to ensure that data is cleaned, transformed, and formatted correctly for experimentation and evaluation. Workflow reproducibility and data versioning are important features for DataOps for all the technical patterns, while the sources, types, and intent of the data is pattern dependent.

#### Training and fine tuning

This technical pattern should fully use your existing DataOps investments you made as part of your MLOps implementation. Reproducibility and data versioning allows you to experiment with different feature engineering data, compare the different model's performance, and reproduce results.

#### RAG and prompt engineering

The intent for the data in RAG solutions is to provide grounding data that is presented to the language model as part of a prompt. RAG solutions often require the processing of large documents into a collection of right-sized, semantically relevant chunks, and persisting those chunks in a vector store. See [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) for details. Reproducibility and data versioning for RAG solutions allows you to experiment with different chunking and embedding strategies, compare performance, and roll back to previous versions.

Data pipelines for chunking documents aren't part of DataOps in traditional MLOps so you have to extend both your architecture and operations. The data pipelines can read data from multiple disparate sources with both structured and unstructured data. They can write the transformed data to different targets, as well. You must extend your architecture to include the data stores you use for grounding data. Common data stores for these patterns are vector stores like Azure AI Search. Like with training and fine tuning, you can take advantage of Azure Machine Learning pipelines or other data pipelining tools to orchestrate the stages of chunking. You can take advantage of prompt flows in Azure Machine Learning pipelines to process and enrich your data in a consistent and reproducible manner. You also must extend your operations to maintain the freshness and validity of the search indexes in your data stores.

### Experimentation

As part of the inner loop, experimentation is the iterative process of building, evaluating (covered in the next section), and refining your solution. The following sections discuss experimentation for the common generative AI technical patterns.

#### Training and fine tuning

When fine-tuning an existing language model or training a small language model, you can utilize your current MLOps investments. For instance, Azure Machine Learning pipelines offer a robust toolkit for conducting experiments efficiently and effectively. These pipelines allow you to manage the entire fine-tuning process, from data preprocessing to model training and evaluation.

#### RAG and prompt engineering

Experimentation with prompt engineering and RAG workloads requires extending your MLOps investments. For these technical patterns, the workload doesn't end with the model. Your workload requires an orchestrator which is a system that knows how to run logic, call data stores for required information like grounding data, generate prompts, call language models, and more. The data stores and the indexes in the stores are also part of the workload. Your operations have to extend to govern these aspects of the workload.

There are multiple dimensions to experiment on for prompt engineering solutions, including different instructions, personas, examples, constraints, and advanced techniques like prompt chaining. When you're [experimenting with RAG solutions](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide), there are additional areas to experiment with, including the following areas:

- Chunking strategy
- What and how you should enrich chunks
- Your embedding model
- Configuration of your search index
- What searches to perform (vector, full text, hybrid, etc.)

As discussed in [DataOps](#dataops), keys to experimentation are reproducibility and data versioning. A good experimentation framework allows you to store inputs, such as changes to hyperparameters or prompts, along with outputs to be used when [evaluating the experiment](#evaluation-and-experimentation).

Like with your existing MLOps environment, you can take advantage of frameworks like Azure Machine Learning pipelines. Azure Machine Learning pipelines have features that support indexing, integrating with vector stores such as Azure AI Search. Your GenAIOps environment can take advantage of these features of pipelines and combine them with prompt flow features that manage prompt engineering and custom preprocessing logic.

### Evaluation and experimentation

Evaluation is key in the iterative experimentation process of building, evaluating, and refining your solution. The evaluation of your changes provides you with the feedback necessary to make your refinements or validate that the current iteration meets your requirements. The following sections discuss evaluation in the experimentation phase for the common generative AI technical patterns.

#### Training and fine tuning

The evaluation of fine-tuned or trained generative AI models should utilize your existing MLOps investments. For example, if you're using Azure Machine Learning pipelines to orchestrate your machine learning model training, you can take advantage of the same evaluation features for fine-tuning foundation language models or training new small language models. These features include taking advantage of the [Evaluate Model component](/azure/machine-learning/component-reference/evaluate-model) that computes industry-standard evaluation metrics for specific model types and compare results across models.

#### RAG and prompt engineering

You have to extend your existing MLOps investments to evaluate generative AI solutions. You can take advantage of tools like prompt flow that offers a robust framework for evaluation. Prompt flows enable teams to define custom evaluation logic, specifying criteria and metrics to assess the performance of various [prompt variants]( /azure/machine-learning/prompt-flow/concept-variants) and language models (LLMs). This structured approach allows for side-by-side comparison of different configurations, such as hyperparameter adjustments or architectural variations, to identify the optimal setup for specific tasks.

 Jobs in prompt flow automatically capture input and output data throughout the experimentation process, creating a comprehensive trial record. You can gain insights and identify promising configurations that can inform future iterations by analyzing this data. You can accelerate the development of your generative AI solutions by conducting efficient and systematic experimentation using prompt flows.

The experimentation process is the same regardless of the use case for your generative AI solution, such as classification, summarization, translation, or even RAG. The important difference is the metrics that you use to evaluate the different use cases. The following are some examples of metrics you should consider per use case:

- Translation: BLEU
- Summarization: ROUGE. BLEU, BERTScore, METEOR
- Classification: Precision, Recall, Accuracy, Cross-entropy
- RAG: Groundedness, Relevancy

> [!NOTE]
> See [LLM end to end evaluation](/azure/architecture/ai-ml/guide/rag/rag-llm-evaluation-phase) for more information on evaluating language models and RAG solutions.

Generative AI solutions, in general, extend the responsibilities of the machine learning team from training models to prompt engineering and managing grounding data. Because prompt engineering and RAG experimentation and evaluation don't necessarily require data scientists, it's tempting to perform these functions with other roles such as software engineers and data engineers. You will run into challenges when you omit data scientists from experimenting with prompt engineering and RAG solutions. Other roles aren't commonly trained on how to scientifically evaluate the results like many data scientists are. Read the seven-part article series [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) to get an understanding of the complexity of designing generative AI solutions.

Investing in generative AI solutions allows you to take some of the pressure off your data science resources. The role of software engineers grows in these solutions. For example, software engineers are great resources to manage the orchestration responsibility in generative AI solutions and they're adept at setting up the evaluation metrics in tools like prompt flow. It's important that this work is done under the watchful eye of your data scientists. Data scientists have the training and experience to understand how to properly evaluate the experiments.

### Deployment

Some generative AI solutions involve deploying custom trained models or fine-tuning existing models, while others don't. Generative AI solutions add additional responsibility to deploy the orchestrators and any data stores. The following sections discuss deployment for the common generative AI technical patterns.

#### Training and fine tuning

Deploying generative AI models and fine-tuning foundational models should use your existing MLOps investments, with some possible adjustments. For example, for fine-tuning a large language model in Azure OpenAI, you need to ensure your training and validation datasets are in JSONL format and you need to upload the data via a REST API. You also need to create a fine-tuning job. Deploying a trained small language model can take advantage of your existing MLOps investments.

#### RAG and prompt engineering

For RAG and prompt engineering, there are additional concerns that you need to deploy, including the orchestration logic, changes to data stores such as indexes or schemas, and changes to data pipeline logic. Orchestration logic is normally encapsulated in frameworks like prompt flow, Semantic Kernel, or LangChain. You can deploy the orchestrator to differing compute resources, including those resources you may currently deploy custom models to. See [Baseline Azure OpenAI end-to-end chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat) for examples of deploying prompt flow to either Azure Machine Learning managed online endpoints or Azure App Services. To deploy to Azure App Service, the baseline Azure OpenAI chat architecture packages the flow and its dependencies as a container, a practice that increases portability and consistency across different environments.

Deployments of changes to database resources such as changes to data models or indexes are new responsibilities that need to be handled in GenAIOps. A common practice when working with large language models is to [use a gateway in front of the LLM](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide).

Many generative AI architectures that consume platform hosted language models, like those served from Azure OpenAI, include a [gateway such as Azure API Management](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide). The gateway use cases include load balancing, authentication, monitoring, and more. The gateway can play a role in deployment of newly trained or fine-tuned models, allowing you to progressively roll out new models. The use of a gateway, along with model versioning, allows you to minimize risk when deploying changes, and roll back to previous versions when there are issues.

Deployments of generative AI specific concerns, such as the orchestrator, should follow proper operational procedures like:

- Rigorous testing, including unit tests
- Integration tests
- A/B tests
- End-to-end tests
- Roll out strategies such canary or blue/green deployments

Because the deployment responsibilities for generative AI applications extend beyond just model deployment, you may need additional job roles to manage the deployment and monitoring of things like the user interface, the orchestrator, and the data stores. These roles are often aligned to DevOps engineer skillsets.

### Inferencing and monitoring

Inferencing is the process of passing input to a trained and deployed model, which then generates a response. You should monitor both traditional machine learning and generative AI solutions from three perspectives: operational monitoring, learning from production, and resource management.

#### Operational monitoring

Operational monitoring is concerned with observing the ongoing operations of the system, including data operations (DataOps) and model training. You're looking for deviations including errors, changes to error rates, and changes to processing times.

For model training and fine tuning, the operational processes you're generally observing the data operations around processing feature data, model training, and fine-tuning. The monitoring for these inner-loop concerns should use your existing MLOps and DataOps investments.

For prompt engineering in generative AI solutions, you have additional monitoring concerns. You must monitor the data pipelines that process the grounding data or other data that is used to generate prompts. This processing might include data store operations such as building or rebuilding indexes.

#### Learning from production

A critical aspect to monitoring at the inferencing stage is learning from production. Monitoring for traditional machine learning models tracks metrics such as accuracy, precision, and recall. A key goal is to guard against prediction drift. Solutions that are using generative models for making predictions, for example using a GPT model for classification, should use your existing MLOps monitoring investments.

Solutions that are using generative models to reason over grounding data use [metrics such as groundedness, completeness, utilization, and relevancy](/azure/architecture/ai-ml/guide/rag/rag-llm-evaluation-phase#large-language-model-evaluation-metrics). The goal is to ensure the model is fully answering the query and is basing the response on its context. Here, you're guarding against things like data drift. You want to ensure that the grounding data and the prompt you're providing the model are maximally relevant to the user query.

Solutions that use generative models for non-predictive tasks, such as RAG solutions often benefit from human feedback to evaluate usefulness sentiments from end users. User interfaces can capture feedback such as thumbs up/down and this data can be used to periodically evaluate the responses.

A common pattern for generative AI solutions is to [deploy a gateway in front of the generative models](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide). One of the [use cases for the gateway is for monitoring the foundational models](/azure/architecture/ai-ml/openai/architecture/log-monitor-azure-openai). The gateway can be used to log input prompts and output.

Another key area to monitor for generative solutions is content safety. The goal is to moderate responses and detect harmful or undesirable content. [Azure AI Content Safety Studio](/azure/ai-services/content-safety/overview#content-safety-studio) is an example of a tool you can use to moderate content.

#### Resource management

For generative solutions that are using models exposed as a service, such as Azure OpenAI, have different resource management concerns than models you deploy yourself. You are not concerned with the infrastructure, rather you are concerned with your service throughput, quota, and throttling. Azure OpenAI uses the concept of tokens for billing, throttling and quotas. You should monitor quota usage for cost management and performance efficiency. Azure OpenAI allows you to log token usage.

## Tooling

Many MLOps practitioners have standardized on a toolkit to organize the various activities around automation, tracking, deployment, experimentation, and so on to abstract away the many common concerns and implementation details of those processes. A common unified platform is [MLflow](/azure/machine-learning/concept-mlflow). Before looking for new tooling to support GenAIOps patterns, you should look to your existing MLOps tooling to evaluate its support for generative AI. For example, MLflow supports a [wide range features for language models](https://mlflow.org/docs/latest/llms/index.html).

## MLOps and GenAIOps maturity models

As part of your current MLOps investments, you might have leveraged the [MLOps maturity model](/azure/architecture/ai-ml/guide/mlops-maturity-model) to evaluate the maturity of you machine learning operations and environment. As you extend your MLOps investments for generative AI workloads, you should use the GenAIOps [maturity model](/azure/machine-learning/prompt-flow/concept-llmops-maturity) to evaluate those operations. You might be tempted to try to combine the two maturity models, but it is our recommendation to measure each independently. MLOps and GenAIOps will evolve independently from each other. As an example, you may be at level four in the MLOps maturity model, but just starting with generative AI and may only be at level one.

## Summary

As you start extending your MLOps investments to include generative AI, it is important to understand that you don't need to start over. You can leverage your existing MLOps investments for some of the generative AI technical patterns. Fine-tuning generative models is a great example. There are areas of generative AI solutions, such as prompt engineering and RAG, that are net new processes and you will have to extend your existing operations investments and gain new skills.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Paulo Lacerda](https://www.linkedin.com/in/paulolacerda/) | Cloud Solution Architect - Microsoft
- [Marco Aurelio Cardoso](https://www.linkedin.com/in/marco-cardoso/) | Senior Software Engineer - Microsoft
- [Luiz Braz](https://www.linkedin.com/in/lfbraz/) | Sr. Technical Specialist - Microsoft
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer - Microsoft

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

> [!div class="nextstepaction"]
> [Azure OpenAI](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide)

## Related resources

- [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide)
- [Baseline OpenAI end-to-end chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat)
- [Machine learning operations](/azure/architecture/ai-ml/guide/machine-learning-operations-v2)
