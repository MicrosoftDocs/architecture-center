The Retrieval Augmented Generation (RAG) pattern is the industry standard approach to building applications that use large language models (LLMs) to reason over specific or proprietary data not already known to the LLM. While the architecture is straightforward, designing and evaluating RAG solutions that fit into this architecture involves many complex considerations. These considerations include determining what test documents and queries to use during evaluation, choosing a chunking strategy, determining what and how you should enrich the chunks, choosing the right embedding model, how to configure the search index, determining what searches you want to perform, and how to evaluate each step. The articles in this guide address all of those considerations.

## RAG Architecture

:::image type="complex" source="./_images/rag-high-level-architecture.svg" lightbox="./_images/rag-high-level-architecture.svg" alt-text="Diagram showing the high level architecture of a RAG solution, including the request flow and the data pipeline." border="false":::
   Diagram showing the high level architecture of a RAG solution, including the request flow and the data pipeline.
:::image-end:::
*Figure 1. High level RAG architecture*

### RAG application flow

The following is a high-level flow for a RAG application.

1. The user issues a query in an intelligent application.
2. The intelligent application makes an API call to an orchestrator. The orchestrator can be an App Service, Azure Machine Learning prompt flow, an app running on a virtual machine, an Azure Function, or a variety of other options.
3. The orchestrator determines what search to perform on Azure AI Search and issues the query.
4. The orchestrator packages the top N results from the query, packages them as context within a prompt, along with the query, and sends the prompt to the LLM. The orchestrator returns the response to the intelligent application for the user to read.

### RAG data pipeline flow

The following is a high-level flow for a data pipeline that supplies grounding data for a RAG application.

1. Documents are either pushed or pulled into the data pipeline.
2. The data pipeline processes each document with the following steps:

    * Chunks documents - Breaks the documents down into semantically relevant parts that ideally have a single idea or concept.
    * Enrich chunks - Adds metadata fields created from the content in the chunks to the chunk field, such as title, summary, and keywords. 
    * Embed chunks - Uses an embedding model to vectorize the chunk and any other metadata fields that will be used for vector searches.
    * Persists chunks - Stores the chunks in the search index.

## RAG design and evaluation considerations

As mentioned in the introduction, there are a variety of implementation decisions you must make when designing your RAG solution. The figure below illustrates some of those decisions.

:::image type="complex" source="./_images/rag-high-level-architecture-questions.svg" lightbox="./_images/rag-high-level-architecture-questions.svg" alt-text="Diagram showing the high level architecture of a RAG solution, including questions that arise when designing the solution." border="false":::
   Diagram showing the high level architecture of a RAG solution, including questions that arise when designing the solution.
:::image-end:::
*Figure 2. Questions that arise when designing RAG solution*

The series of articles in this guide addresses those considerations and more.

[Preparation phase](./rag-preparation-phase.yml)

* **Determine solution domain** - Discusses the importance of clearly defining the business requirements for the RAG solution
* **Gather representative test documents** - Discusses considerations and guidance on gathering test documents for your RAG solution that are representative of your corpus.
* **Gather test queries** - Discusses what information you should gather along with your test queries, provides guidance on generating synthetic queries and queries that your documents do not cover.

[Chunking phase](./rag-chunking-phase.yml)

* Understand the economics of chunking
* Document analysis
* Chunking approaches
* Document structure

[Chunk enrichment phase](./rag-enrichment-phase.yml)

* Cleaning
* Augmenting chunks

[Embedding phase](./rag-generating-embeddings.yml)

* Importance of the embedding model
* Choosing an embedding model
* Evaluate embedding models

[Information retrieval phase](./rag-information-retrieval.yml)

* Search index
* Searches
* Search evaluation

[LLM end to end evaluation phase](./rag-llm-evaluation-phase.yml)

* LLM evaluation metrics
* Similarity and evaluation metrics
* Documentation, reporting, and aggregation
* The RAG Experiment Accelerator
