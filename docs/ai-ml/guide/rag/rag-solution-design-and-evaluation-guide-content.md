The Retrieval-Augmented Generation (RAG) pattern is an industry standard approach to building applications that use large language models to reason over specific or proprietary data that is not already known to the large language model. While the architecture is straightforward, designing, experimenting with, and evaluating RAG solutions that fit into this architecture involves many complex considerations that benefits from a rigorous, scientific approach.

> This guide is presented as a series. Each article in the series covers a specific phase in designing RAG solutions.

These considerations the articles in this guides cover include:

- Determining what test documents and queries to use during evaluation
- Choosing a chunking strategy
- Determining what and how you should enrich the chunks
- Choosing the right embedding model
- Determining how to configure the search index
- Determining what searches you want to perform: vector, full text, hybrid, manual multiple
- Evaluating each step

The articles in this guide address all of those considerations.

## RAG Architecture

:::image type="complex" source="_images/rag-high-level-architecture.svg" border="false" lightbox="_images/rag-high-level-architecture.png" alt-text="Diagram showing the high level architecture of a RAG solution, including the request flow and the data pipeline.":::
    Diagram showing the high level architecture of a RAG solution, including the request flow and the data pipeline.
:::image-end:::
*Figure 1. High level RAG architecture*

### RAG application flow

The following is a high-level flow for a RAG application.

1. The user issues a query in an intelligent application user interface.
2. The intelligent application makes an API call to an orchestrator. The orchestrator can be implemented with tools or platforms like Semantic Kernel, Azure Machine Learning prompt flow, or LangChain.
3. The orchestrator determines what search to perform on Azure AI Search and issues the query.
4. The orchestrator packages the top N results from the query, packages them as context within a prompt, along with the query, and sends the prompt to the large language model. The orchestrator returns the response to the intelligent application for the user to read.

### RAG data pipeline flow

The following is a high-level flow for a data pipeline that supplies grounding data for a RAG application.

1. Documents are either pushed or pulled into a data pipeline.
2. The data pipeline processes each document individually with the following steps:

    1. Chunk document - Break down the document into semantically relevant parts that ideally have a single idea or concept.
    1. Enrich chunks - Adds metadata fields created from the content in the chunks to discrete fields, such as title, summary, and keywords.
    1. Embed chunks - Uses an embedding model to vectorize the chunk and any other metadata fields that are used for vector searches.
    1. Persists chunks - Stores the chunks in the search index.

## RAG design and evaluation considerations

There are a variety of implementation decisions you must make when designing your RAG solution. The following figure illustrates some of those decisions.

:::image type="complex" source="_images/rag-high-level-architecture-questions.svg" border="false" lightbox="_images/rag-high-level-architecture-questions.png" alt-text="Diagram showing the high level architecture of a RAG solution, including questions that arise when designing the solution.":::
    Diagram showing the high level architecture of a RAG solution, including questions that arise when designing the solution.
:::image-end:::
*Figure 2. Questions that arise when designing RAG solution*

The series of articles in this guide addresses those considerations and more.

**[Preparation phase](./rag-preparation-phase.yml)**

- **Determine solution domain** - Discusses the importance of clearly defining the business requirements for the RAG solution
- **Gather representative test documents** - Discusses considerations and guidance on gathering test documents for your RAG solution that are representative of your corpus.
- **Gather test queries** - Discusses what information you should gather along with your test queries, provides guidance on generating synthetic queries and queries that your documents don't cover.

**[Chunking phase](./rag-chunking-phase.yml)**

- **Understand chunking economics** - Discusses the factors to consider when looking at the overall cost of your chunking solution for your text corpus
- **Perform document analysis** - Provides a list of questions you can ask when analyzing a document type that helps you determine what in the document you want to ignore or exclude, what you want to capture in chunks and how you want to chunk
- **Understand chunking approaches** - Outlines the different approaches to chunking like sentence-based, fixed-size, custom, large language model augmentation, document layout analysis, using machine learning models
- **Understand how document structure affects chunking** - Discusses how the degree of structure a document has influences your choice for a chunking approach

**[Chunk enrichment phase](./rag-enrichment-phase.yml)**

- **Clean chunks** - Discusses different cleaning approaches you can implement to support closeness matches by eliminating potential differences that aren't material to the semantics of the text
- **Augment chunks** - Discusses some common metadata fields you should consider augmenting your chunk data with along with some guidance about their potential uses in search, and tools or techniques that are commonly used to generate the metadata content

**[Embedding phase](./rag-generating-embeddings.yml)**

- **Understand the importance of the embedding model** - Discusses how an embedding model can have a significant effect on relevancy of your vector search results
- **Choosing an embedding model** - Provides guidance on choosing an embedding model
- **Evaluate embedding models** - Discusses two means of evaluating an embedding model: visualizing embeddings and calculating embedding distances

**[Information retrieval phase](./rag-information-retrieval.yml)**

- **Create search index** - Discusses some key decisions you must make for the vector search configuration that applies to vector fields
- **Understanding search options** - Provides an overview of the types of search you can consider such as vector, full text, hybrid, and manual multiple. Provides guidance on splitting a query into subqueries, filtering queries
- **Evaluate searches** - Provides guidance on evaluating your search solution

**[Large language model end to end evaluation phase](./rag-llm-evaluation-phase.yml)**

- **Understand large language model evaluation metrics** - Provides overview of several metrics you can use to evaluate the large language models response including groundedness, completeness, utilization, and relevancy
- **Understand similarity and evaluation metrics** - Provides a small list of similarity and evaluation metrics you can use when evaluating your RAG solution
- **Understand importance of documentation, reporting, and aggregation** - Discusses the importance of documenting the hyperparameters along with evaluation results, aggregating results from multiple queries, and visualizing the results
- **The RAG Experiment Accelerator** - Provides a link to the [Rag Experiment Accelerator](https://github.com/microsoft/rag-experiment-accelerator), which is a tool that is designed to help teams quickly find the best strategies for RAG implementation by running multiple experiments, persisting, and evaluating the results

## Structured approach

Because of the number of steps and variables, it's important to design your RAG solution through a structured evaluation process. Evaluate the results of each step and adapt, given your requirements. While you should evaluate each step independently for optimization, the end result is what is going to be experienced by your users. Be sure to understand all steps in this process before determining your own acceptance criteria for each individual step.

## Contributors

- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/)
- [Rob Bagby](https://www.linkedin.com/in/robbagby/)
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/)
- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/)
- [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/)
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/)
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/)

## Next steps

> [!div class="nextstepaction"]
> [Preparation phase](./rag-preparation-phase.yml)

## Related resources

- [Retrieval Augmented Generation (RAG) in Azure AI Search](/azure/search/retrieval-augmented-generation-overview)
- [Retrieval augmented generation and indexes](/azure/ai-studio/concepts/retrieval-augmented-generation)
