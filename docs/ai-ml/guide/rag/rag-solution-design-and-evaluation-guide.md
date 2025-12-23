---
title: Design and Develop a RAG Solution
description: Learn about what to consider when you design a large language model RAG solution, including each step of the development process and how to evaluate those steps.
author: claytonsiemens77
ms.author: pnp
ms.date: 12/17/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# Design and develop a RAG solution

The retrieval-augmented generation (RAG) pattern is an industry-standard approach to building applications that use language models to process specific or proprietary data that the model doesn't already know. The architecture is straightforward, but designing, experimenting with, and evaluating RAG solutions that fit into this architecture involve many complex considerations that benefit from a rigorous, scientific approach.

This article is the introduction of a series. Each article in the series covers a specific phase in RAG solution design.

The other articles in this series cover the following considerations:

- How to determine which test media and queries to use during evaluation
- How to choose a chunking strategy
- How to determine which chunks you should enrich and how to enrich them
- How to choose the right embedding model
- How to configure the search index
- How to determine which searches, such as vector, full text, hybrid, and manual multiple searches, you should perform
- How to evaluate each step

## RAG architecture

:::image type="content" source="_images/rag-high-level-architecture.svg" border="false" lightbox="_images/rag-high-level-architecture.svg" alt-text="Diagram that shows the high-level architecture of a RAG solution, including the request flow and the data pipeline.":::

### RAG application flow

The following workflow describes a high-level flow for a RAG application.

1. The user issues a query in an intelligent application user interface.
1. The intelligent application makes an API call to an orchestrator. You can implement the orchestrator with tools or platforms like the Microsoft Agent Framework, Semantic Kernel, Azure AI Agent service, or LangChain.
1. The orchestrator determines which search to perform on Azure AI Search and issues the query.
1. The orchestrator packages the top *N* results from the query. It packages the top results and the query as context within a prompt and sends the prompt to the language model. The orchestrator returns the response to the intelligent application for the user to read.

### RAG data pipeline flow

The following workflow describes a high-level flow for a data pipeline that supplies grounding data for a RAG application.

1. Documents or other media are either pushed or pulled into a data pipeline.
1. The data pipeline processes each media file individually by completing the following steps:
   1. Chunking: Breaks down the media file into semantically relevant parts that ideally have a single idea or concept.
   1. Enrich chunks: Adds metadata fields that the pipeline creates based on the content in the chunks. The data pipeline categorizes the metadata into discrete fields, such as title, summary, and keywords.
   1. Embed chunks: Uses an embedding model to vectorize the chunk and any other metadata fields that are used for vector searches.
   1. Persist chunks: Stores the chunks in the search index.

## RAG design and evaluation considerations

You must make various implementation decisions as you design your RAG solution. The following diagram illustrates some of the questions you should ask when you make those decisions.

:::image type="content" source="_images/rag-high-level-architecture-questions.svg" border="false" lightbox="_images/rag-high-level-architecture-questions.svg" alt-text="Diagram that shows the high-level architecture of a RAG solution, including the questions that you should ask as you design the solution.":::

The following list provides a brief description of what you should do during each phase of RAG solution development.

- During the [preparation phase](./rag-preparation-phase.md), you should:

  - **Determine the solution domain.** Clearly define the business requirements for the RAG solution.
  - **Gather representative test media.** Gather test media files for your RAG solution that are representative of your overall collection.
  - **Gather test queries.** Gather information and test queries and generate synthetic queries and queries that your media files don't cover.

- During the [chunking phase](./rag-chunking-phase.md), you should:

  - **Understand chunking economics.** Understand which factors to consider as you evaluate the overall cost of your chunking solution for your media collection.
  - **Perform media analysis.** Ask the following questions to help you make decisions when you analyze a media file type:
    - What content in the media file do you want to ignore or exclude?
    - What content do you want to capture in chunks?
    - How do you want to chunk that content?
  - **Understand chunking approaches.** Understand the different approaches to chunking, including sentence-based, fixed-size, and custom approaches or by using language model augmentation, document layout analysis, and machine learning models.
  - **Understand how file structure affects chunking.** Choose a chunking approach based on the degree of structure that the media file has.

- During the [chunk enrichment phase](./rag-enrichment-phase.md), you should:

  - **Clean chunks.** Implement cleaning approaches to eliminate differences that don't affect the meaning of the content. This method supports closeness matches.
  - **Augment chunks.** Consider augmenting your chunk data with common metadata fields and understand their potential uses in search. Learn about commonly used tools or techniques for generating metadata content.

- During the [embedding phase](./rag-generate-embeddings.md), you should:

  - **Understand the importance of the embedding model.** An embedding model can significantly affect the relevancy of your vector search results.
  - **Choose the right embedding model for your use case.**
  - **Evaluate embedding models.** Evaluate embedding models by visualizing embeddings and calculating embedding distances.

- During the [information retrieval phase](./rag-information-retrieval.md), you should:

  - **Create a search index.** Apply the appropriate vector search configurations to your vector fields.
  - **Understand search options.** Consider the different types of searches, including vector, full-text, hybrid, and manual multiple searches. Learn about how to split a query into subqueries and filter queries.
  - **Evaluate searches.** Use retrieval evaluation methods to evaluate your search solution.

- During the [language model end-to-end evaluation phase](./rag-llm-evaluation-phase.md), you should:

  - **Understand language model evaluation metrics.** There are several metrics, including groundedness, completeness, utilization, and relevancy, that you can use to evaluate the language model's response.
  - **Understand similarity and evaluation metrics.** You can use similarity and evaluation metrics to evaluate your RAG solution.
  - **Understand the importance of documentation, reporting, and aggregation.** Document the hyperparameters and the evaluation results. Aggregate the results from multiple queries and visualize the results.
  - **Use the RAG experiment accelerator.** Use the [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator) to help your team find the best strategies for RAG implementation by running multiple experiments, persisting, and evaluating the results.

## Structured approach

Because of the number of steps and variables, it's important that you follow a structured evaluation process for your RAG solution. Evaluate the results of each step and make changes based on your requirements. You should evaluate each step independently for optimization, but remember that the end result is what your customers experience. Make sure that you understand all of the steps in this process before you determine your own acceptance criteria for each step.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/) | Software Engineer II
- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Content Developer - Azure Patterns & Practices
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Principal Software Engineer
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Engineer
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/) | Senior Technical Program Manager
- [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/) | Principal AI Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Retrieval Augmented Generation (RAG) in Azure AI Search](/azure/search/retrieval-augmented-generation-overview)
- [Retrieval augmented generation and indexes](/azure/ai-foundry/concepts/retrieval-augmented-generation)

## Related resources

> [!div class="nextstepaction"]
> [Preparation phase](./rag-preparation-phase.md)
