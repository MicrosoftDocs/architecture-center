The Retrieval-Augmented Generation (RAG) pattern is an industry standard approach to building applications that use language models to process specific or proprietary data that the model doesn't already know. Although the architecture is straightforward, designing, experimenting with, and evaluating RAG solutions that fit into this architecture involve many complex considerations that benefit from a rigorous, scientific approach.

> This guide is presented as a series. Each article in the series covers a specific phase in RAG solution design.

The articles in this guide cover the following considerations:

- How to determine which test documents and queries to use during evaluation
- How to choose a chunking strategy
- How to determine which chunks you should enrich and how to enrich them
- How to choose the right embedding model
- How to configure the search index
- How to determine which searches, such as vector, full text, hybrid, and manual multiple searches, you should perform
- How to evaluate each step

## RAG architecture

:::image type="content" source="_images/rag-high-level-architecture.svg" border="false" lightbox="_images/rag-high-level-architecture.png" alt-text="Diagram that shows the high-level architecture of a RAG solution, including the request flow and the data pipeline.":::

### RAG application flow

The following workflow describes a high-level flow for a RAG application.

1. The user issues a query in an intelligent application user interface.
1. The intelligent application makes an API call to an orchestrator. You can implement the orchestrator with tools or platforms like Semantic Kernel, Azure Machine Learning prompt flow, or LangChain.
1. The orchestrator determines which search to perform on Azure AI Search and issues the query.
1. The orchestrator packages the top N results from the query. It packages the top results and the query as context within a prompt and sends the prompt to the language model. The orchestrator returns the response to the intelligent application for the user to read.

### RAG data pipeline flow

The following workflow describes a high-level flow for a data pipeline that supplies grounding data for a RAG application.

1. Documents are either pushed or pulled into a data pipeline.
1. The data pipeline processes each document individually by completing the following steps:
    1. Chunk document: Break down the document into semantically relevant parts that ideally have a single idea or concept.
    1. Enrich chunks: Add metadata fields that the pipeline creates based on the content in the chunks. Categorize the metadata into discrete fields, such as title, summary, and keywords.
    1. Embed chunks: Use an embedding model to vectorize the chunk and any other metadata fields that you use for vector searches.
    1. Persist chunks: Store the chunks in the search index.

## RAG design and evaluation considerations

You must make various implementation decisions as you design your RAG solution. The following figure illustrates some of the questions you should ask when you make those decisions.

:::image type="content" source="_images/rag-high-level-architecture-questions.svg" border="false" lightbox="_images/rag-high-level-architecture-questions.png" alt-text="Diagram that shows the high-level architecture of a RAG solution, including the questions that you should ask as you design the solution.":::

The following list provides a brief description of what you should do during each phase of RAG solution development.

- During the preparation phase, you should:

   - **Determine the solution domain.** Clearly define the business requirements for the RAG solution.
   - **Gather representative test documents.** Gather test documents for your RAG solution that are representative of your corpus.
   - **Gather test queries.** Gather information and test queries and generate synthetic queries and queries that your documents don't cover.
   
   For more information, see [Preparation](./rag-preparation-phase.yml).

- During the chunking phase, you should:

   - **Understand chunking economics.** Understand which factors to consider as you evaluate the overall cost of your chunking solution for your text corpus.
   - **Perform document analysis.** Ask questions that help you make the following decisions when you analyze a document type:
      - What content in the document do you want to ignore or exclude?
      - What content do you want to capture in chunks?
      - How do you want to chunk that content?
   - **Understand chunking approaches.** Understand the different approaches to chunking, including sentence-based, fixed-size, and custom approaches or by using language model augmentation, document layout analysis, and machine learning models.
   - **Understand how document structure affects chunking.** Choose a chunking approach based on the degree of structure that the document has.

   For more information, see [Chunking](./rag-chunking-phase.yml).

- During the chunk enrichment phase, you should:

   - **Clean chunks.** Implement cleaning approaches that support closeness matches by eliminating potential differences that aren't material to the semantics of the text.
   - **Augment chunks.** Consider augmenting your chunk data with common metadata fields and understand their potential uses in search. Learn about commonly used tools or techniques for generating metadata content.

   For more information, see [Chunk enrichment](./rag-enrichment-phase.yml).

- During the embedding phase, you should:

   - **Understand the importance of the embedding model.** An embedding model can significantly affect the relevancy of your vector search results.
   - **Choose the right embedding model for your use case.**
   - **Evaluate embedding models.** Evaluate embedding models by visualizing embeddings and calculating embedding distances.

   For more information, see [Generate embeddings](./rag-generating-embeddings.yml).

- During the information retrieval phase, you should:

   - **Create a search index.** Apply the appropriate vector search configurations to your vector fields.
   - **Understand search options.** Consider the different types of searches, including vector, full-text, hybrid, and manual multiple searches. Learn about how to split a query into subqueries and filter queries.
   - **Evaluate searches.** Use retrieval evaluation methods to evaluate your search solution.

   For more information, see [Information retrieval](./rag-information-retrieval.yml).

- During the language model end-to-end evaluation phase, you should:

   - **Understand language model evaluation metrics.** There are several metrics, including groundedness, completeness, utilization, and relevancy, that you can use to evaluate the language model's response.
   - **Understand similarity and evaluation metrics.** You can use similarity and evaluation metrics to evaluate your RAG solution.
   - **Understand the importance of documentation, reporting, and aggregation.** Document the hyperparameters and the evaluation results. Aggregate the results from multiple queries and visualize the results.
   - **Use the RAG Experiment Accelerator.** You can use the [RAG Experiment Accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator) to help teams find the best strategies for RAG implementation by running multiple experiments, persisting, and evaluating the results.

   For more information, see [Language model end-to-end evaluation](./rag-llm-evaluation-phase.yml).

## Structured approach

Because of the number of steps and variables, it's important that you follow a structured evaluation process for your RAG solution. Evaluate the results of each step and make changes based on your requirements. You should evaluate each step independently for optimization, but remember that the end result is what your customers experience. Make sure that you understand all of the steps in this process before you determine your own acceptance criteria for each step.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/)
- [Rob Bagby](https://www.linkedin.com/in/robbagby/)
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/)
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/)
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/)
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/)
- [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/)

## Next steps

- [Retrieval Augmented Generation (RAG) in Azure AI Search](/azure/search/retrieval-augmented-generation-overview)
- [Retrieval augmented generation and indexes](/azure/ai-studio/concepts/retrieval-augmented-generation)

## Related resources

> [!div class="nextstepaction"]
> [Preparation phase](./rag-preparation-phase.yml)