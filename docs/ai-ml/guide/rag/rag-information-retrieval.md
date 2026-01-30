---
title: Develop a RAG Solution—Information-Retrieval Phase
description: Learn about how to configure a search index, the types of searches that you can run, how to break queries into subqueries, and why and how to rerank queries.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/10/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# Information retrieval

In the previous step of your Retrieval-Augmented Generation (RAG) solution, you generated the embeddings for your chunks. In this step, you generate the index in the vector database and experiment to determine your optimal searches. This article covers configuration options for a search index, types of searches, and reranking strategies.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.md).

## Configure your search index

> [!NOTE]
> This section describes specific recommendations for Azure AI Search. If you use a different store, review the appropriate documentation to find the key configurations for that service.

The search index in your store has a column for every field in your data. Search stores generally support [nonvector data types](/rest/api/searchservice/supported-data-types#edm-data-types-for-nonvector-fields), such as string, boolean, integer, single, double, and datetime. They also support collections, such as single-type collections and [vector data types](/rest/api/searchservice/supported-data-types#edm-data-types-for-vector-fields). For each column, you must [configure information](/azure/search/vector-search-how-to-create-index#add-a-vector-field-to-the-fields-collection), such as the data type and whether the field is filterable, retrievable, or searchable.

Consider the following [vector search configurations](/azure/search/vector-search-how-to-create-index#add-a-vector-search-configuration) that you can apply to vector fields:

- **Vector search algorithm:** The [vector search algorithm](/azure/search/vector-search-ranking) searches for relative matches. AI Search has a brute-force algorithm option, called exhaustive k-nearest neighbors (KNN), that scans the entire vector space. It also has a more performant algorithm option, called Hierarchical Navigable Small World (HNSW), that performs an [approximate nearest neighbor (ANN)](/azure/search/vector-search-overview#approximate-nearest-neighbors) search.

- **Similarity metric:** The algorithm uses a [similarity metric](/azure/search/vector-search-ranking#similarity-metrics-used-to-measure-nearness) to calculate nearness. The types of metrics in AI Search include cosine, dot product, and Euclidean. If you use Azure OpenAI Service embedding models, choose cosine.
- **The `efConstruction` parameter:** This parameter is used during the construction of an HNSW index. It determines the number of nearest neighbors that are connected to a vector during indexing. A larger `efConstruction` value results in a better-quality index than a smaller number. But a larger value requires more time, storage, and compute. For a large number of chunks, set the `efConstruction` value higher. For a low number of chunks, set the value lower. To determine the optimal value, experiment with your data and expected queries.
- **The `efSearch` parameter:** This parameter is used during query time to set the number of nearest neighbors, or similar chunks, that the search uses.
- **The `m` parameter:** This parameter is the bidirectional link count. The range is 4 to 10. Lower numbers return less noise in the results.

In AI Search, the vector configurations are encapsulated in a `vectorSearch` configuration. When you configure your vector columns, you reference the appropriate configuration for that vector column and set the number of dimensions. The vector column's dimensions attribute represents the number of dimensions that your embedding model generates. For example, the storage-optimized *text-embedding-3-small* model generates 1,536 dimensions.

## Choose your search approach

When you run queries from your prompt orchestrator against your search store, consider the following factors:

- The type of search that you want to run, like vector, keyword, or hybrid

- Whether you want to query against one or more columns
- Whether you want to manually run multiple queries, such as a keyword query and a vector search
- Whether you need to break down the query into subqueries
- Whether you should use filtering in your queries

Your prompt orchestrator might use a static approach or a dynamic approach that combines approaches based on context clues from the prompt. The following sections address these options to help you find the right approach for your workload.

### Search types

Search platforms generally support full-text and vector searches. Some platforms, like AI Search, support hybrid searches.

#### Vector search

[Vector searches](/azure/search/vector-search-how-to-query) compare the similarity between the vectorized query (prompt) and vector fields. For more information, see [Choose an Azure service for vector searches](../../../guide/technology-choices/vector-search.md).

> [!IMPORTANT]
> Before you embed the query, you should run the same [cleaning operations](./rag-enrichment-phase.md#clean-your-data) that you performed on chunks. For example, if you lowercased every word in your embedded chunk, you should lowercase every word in the query before embedding.

> [!NOTE]
> You can run a vector search against multiple vector fields in the same query. In AI Search, this practice is considered a hybrid search. For more information, see [Hybrid search](#hybrid-search).

The following sample code performs a vector search against the contentVector field. 

```python
embedding = embedding_model.generate_embedding(
    chunk=str(pre_process.preprocess(query))
)

vector = RawVectorQuery(
    k=retrieve_num_of_documents,
    fields="contentVector",
    vector=embedding,
)

results = client.search(
    search_text=None,
    vector_queries=[vector],
    top=retrieve_num_of_documents,
    select=["title", "content", "summary"],
)
```

The code that embeds the query preprocesses the query first. That preprocess should be the same code that preprocesses the chunks before embedding. You must use the same embedding model that embedded the chunks.

#### Full-text search

[Full-text searches](/azure/search/search-lucene-query-architecture) match plain text that's stored in an index. It's common practice to extract keywords from a query and use those extracted keywords in a full-text search against one or more indexed columns. You can configure full-text searches to return matches if any terms or all terms match.

Experiment to determine which fields to run full-text searches against. As described in the [enrichment phase article](./rag-enrichment-phase.md#augment-your-chunks), you should use keyword and entity metadata fields for full-text searches in scenarios where content has similar semantic meaning but entities or keywords differ. Other common fields to consider for full-text search include title, summary, and chunk text.

The following sample code performs a full-text search against the title, content, and summary fields.

```python
formatted_search_results = []

results = client.search(
    search_text=query,
    top=retrieve_num_of_documents,
    select=["title", "content", "summary"],
)

formatted_search_results = format_results(results)
```

#### Hybrid search

AI Search supports [hybrid queries](/azure/search/hybrid-search-ranking) that contain one or more text searches and one or more vector searches. The platform performs each query, gets the intermediate results, reranks the results by using [Reciprocal Rank Fusion](/azure/search/hybrid-search-ranking#how-rrf-ranking-works), and returns the top *N* results.

The following sample code performs a full-text search against the title, content, and summary fields. It also performs vector searches against the contentVector and questionVector fields. AI Search runs all the queries in parallel, reranks the results, and returns the top *retrieve_num_of_documents*.

```python
 embedding = embedding_model.generate_embedding(
    chunk=str(pre_process.preprocess(query))
)
vector1 = RawVectorQuery(
    k=retrieve_num_of_documents,
    fields="contentVector",
    vector=embedding,
)
vector2 = RawVectorQuery(
    k=retrieve_num_of_documents,
    fields="questionVector",
    vector=embedding,
)

results = client.search(
    search_text=query,
    vector_queries=[vector1, vector2],
    top=retrieve_num_of_documents,
    select=["title", "content", "summary"],
)
```

#### Manual multiple queries

You can run multiple queries, such as a vector search and a keyword full-text search, manually. You aggregate the results, [rerank](#use-reranking) the results manually, and return the top results. Consider the following use cases for manual multiple queries:

- You use a search platform that doesn't support hybrid searches. You use manual multiple queries to run your own hybrid search.

- You want to run full-text searches against different queries. For example, you might extract keywords from the query and run a full-text search against your keywords metadata field. You might then extract entities and run a query against the entities metadata field.
- You want to control the reranking process.
- The query requires that you run [decomposed subqueries](#decomposition) to retrieve grounding data from multiple sources.

### Query translation

Query translation is an optional step in the information retrieval phase of a RAG solution. This step transforms or translates a query into an optimized form to retrieve better results. Query translation methods include augmentation, decomposition, rewriting, and Hypothetical Document Embeddings (HyDE).

#### Query augmentation

Query augmentation is a translation step that simplifies the query, improves usability, and enhances context. You should consider augmentation if your query is small or vague. For example, consider the query "Compare the earnings of Microsoft." That query doesn't include time frames or time units to compare and only specifies earnings. Consider an augmented version of the query, such as "Compare the earnings and revenue of Microsoft in the current year versus last year by quarter." The new query is clear and specific.

When you augment a query, you maintain the original query but add more context. Don't remove or alter the original query, and don't change the nature of the query.

You can use a language model to augment a query. But you can't augment all queries. If you have context, you can pass it along to your language model to augment the query. If you don't have context, you have to determine whether your language model has information that you can use to augment the query. For example, if you use a large language model, like a GPT model, you can determine whether information about the query is readily available on the internet. If so, you can use the model to augment the query. Otherwise, you shouldn't augment the query.

In the following prompt, a language model augments a query. This prompt includes examples for when the query has context and doesn't. For more information, see [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator/).

```text
Input Processing:

Analyze the input query to identify the core concept or topic.
Check whether the query provides context.
If context is provided, use it as the primary basis for augmentation and explanation.
If no context is provided, determine the likely domain or field, such as science, technology, history, or arts, based on the query.

Query Augmentation:

If context is provided:

Use the given context to frame the query more specifically.
Identify other aspects of the topic not covered in the provided context that enrich the explanation.

If no context is provided, expand the original query by adding the following elements, as applicable:

Include definitions about every word, such as adjective or noun, and the meaning of each keyword, concept, and phrase including synonyms and antonyms.
Include historical context or background information, if relevant.
Identify key components or subtopics within the main concept.
Request information about practical applications or real-world relevance.
Ask for comparisons with related concepts or alternatives, if applicable.
Inquire about current developments or future prospects in the field.

Other Guidelines:

Prioritize information from provided context when available.
Adapt your language to suit the complexity of the topic, but aim for clarity.
Define technical terms or jargon when they're first introduced.
Use examples to illustrate complex ideas when appropriate.
If the topic is evolving, mention that your information might not reflect the very latest developments.
For scientific or technical topics, briefly mention the level of scientific consensus if relevant.
Use Markdown formatting for better readability when appropriate.

Example Input-Output:

Example 1 (With provided context):

Input: "Explain the impact of the Gutenberg Press"
Context Provided: "The query is part of a discussion about revolutionary inventions in medieval Europe and their long-term effects on society and culture."
Augmented Query: "Explain the impact of the Gutenberg Press in the context of revolutionary inventions in medieval Europe. Cover its role in the spread of information, its effects on literacy and education, its influence on the Reformation, and its long-term impact on European society and culture. Compare it to other medieval inventions in terms of societal influence."

Example 2 (Without provided context):

Input: "Explain CRISPR technology"
Augmented Query: "Explain CRISPR technology in the context of genetic engineering and its potential applications in medicine and biotechnology. Cover its discovery, how it works at a molecular level, its current uses in research and therapy, ethical considerations surrounding its use, and potential future developments in the field."
Now, provide a comprehensive explanation based on the appropriate augmented query.

Context: {context}

Query: {query}

Augmented Query:
```

#### Decomposition

Complex queries require more than one collection of data to ground the model. For example, the query "How do electric cars work, and how do they compare to internal combustion engine (ICE) vehicles?" likely requires grounding data from multiple sources. One source might describe how electric cars work, where another compares them to ICE vehicles.

Decomposition is the process of breaking down a complex query into multiple smaller and simpler subqueries. You run each of the decomposed queries independently and aggregate the top results of all the decomposed queries as accumulated context. You then run the original query, which passes the accumulated context to the language model.

You should determine whether the query requires multiple searches before you run any searches. If you require multiple subqueries, you can run [manual multiple queries](#manual-multiple-queries) for all the queries. Use a language model to determine whether multiple subqueries are recommended.

The following prompt categorizes a query as *simple* or *complex*. For more information, see [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator/blob/development/rag_experiment_accelerator/llm/prompt/prompt.py).

```text
Consider the given question to analyze and determine whether it falls into one of these categories:

1. Simple, factual question
  a. The question asks for a straightforward fact or piece of information.
  b. The answer can likely be found stated directly in a single passage of a relevant document.
  c. Breaking the question down further is unlikely to be beneficial.
  Examples: "What year did World War 2 end?", "What is the capital of France?", "What are the features of productX?"

2. Complex, multipart question
  a. The question has multiple distinct components or asks for information about several related topics.
  b. Different parts of the question likely need to be answered by separate passages or documents.
  c. Breaking the question down into subquestions for each component provides better results.
  d. The question is open-ended and likely to have a complex or nuanced answer.
  e. Answering the question might require synthesizing information from multiple sources.
  f. The question might not have a single definitive answer and could warrant analysis from multiple angles.
  Examples: "What were the key causes, major battles, and outcomes of the American Revolutionary War?", "How do electric cars work and how do they compare to gas-powered vehicles?"

Based on this rubric, does the given question fall under category 1 (simple) or category 2 (complex)? The output should be in strict JSON format. Ensure that the generated JSON is 100% structurally correct, with proper nesting, comma placement, and quotation marks. There shouldn't be a comma after the last element in the JSON.

Example output:
{
  "category": "simple"
}
```

You can also use a language model to decompose a complex query. The following prompt decomposes a complex query. For more information, see [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator/).

```text
Analyze the following query:

For each query, follow these specific instructions:

- Expand the query to be clear, complete, fully qualified, and concise.
- Identify the main elements of the sentence, typically a subject, an action or relationship, and an object or complement. Determine which element is being asked about or emphasized (usually the unknown or focus of the question). Invert the sentence structure. Make the original object or complement the new subject. Transform the original subject into a descriptor or qualifier. Adjust the verb or relationship to fit the new structure.
- Break the query down into a set of subqueries that have clear, complete, fully qualified, concise, and self-contained propositions.
- Include another subquery by using one more rule: Identify the main subject and object. Swap their positions in the sentence. Adjust the wording to make the new sentence grammatically correct and meaningful. Ensure that the new sentence asks about the original subject.
- Express each idea or fact as a standalone statement that can be understood with the help of the given context.
- Break down the query into ordered subquestions, from least to most dependent.
- The most independent subquestion doesn't require or depend on the answer to any other subquestion or prior knowledge.
- Try having a complete subquestion that has all information only from the base query. There's no other context or information available.
- Separate complex ideas into multiple simpler propositions when appropriate.
- Decontextualize each proposition by adding necessary modifiers to nouns or entire sentences. Replace pronouns, such as it, he, she, they, this, and that, with the full name of the entities that they refer to.
- If you still need more questions, the subquestion isn't relevant and should be removed.

Provide your analysis in the following YAML format, and strictly adhere to the following structure. Don't output anything extra, including the language itself.

type: interdependent
queries:
- [First query or subquery]
- [Second query or subquery, if applicable]
- [Third query or subquery, if applicable]
- ...

Examples:

1. Query: "What is the capital of France?"
type: interdependent
queries:
    - What is the capital of France?

2. Query: "Who is the current CEO of the company that created the iPhone?"
type: interdependent
queries:
    - Which company created the iPhone?
    - Who is the current CEO of Apple? (identified in the previous question)

3. Query: "What is the population of New York City, and what is the tallest building in Tokyo?"
type: multiple_independent
queries:
    - What is the population of New York City?
    - What is the tallest building in Tokyo?

Now, analyze the following query:

{query}
```

#### Rewriting

An input query might not be in the optimal form to retrieve grounding data. You can use a language model to rewrite the query and achieve better results. Rewrite a query to address the following challenges:

- Vagueness
- Missing keywords
- Unnecessary words
- Unclear semantics

The following prompt uses a language model to rewrite a query. For more information, see [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator/).

```text
Rewrite the given query to optimize it for both keyword-based and semantic-similarity search methods. Follow these guidelines:

- Identify the core concepts and intent of the original query.
- Expand the query by including relevant synonyms, related terms, and alternate phrasings.
- Maintain the original meaning and intent of the query.
- Include specific keywords that are likely to appear in relevant documents.
- Incorporate natural language phrasing to capture semantic meaning.
- Include domain-specific terminology if applicable to the query's context.
- Ensure that the rewritten query covers both broad and specific aspects of the topic.
- Remove ambiguous or unnecessary words that might confuse the search.
- Combine all elements into a single, coherent paragraph that flows naturally.
- Aim for a balance between keyword richness and semantic clarity.

Provide the rewritten query as a single paragraph that incorporates various search aspects, such as keyword-focused, semantically focused, or domain-specific aspects.

query: {original_query}
```

#### The HyDE technique

[HyDE](https://medium.com/towards-data-science/how-to-use-hyde-for-better-llm-rag-retrieval-a0aa5d0e23e8) is an alternate information-retrieval technique for RAG solutions. Rather than converting a query into embeddings and using those embeddings to find the closest matches in a vector database, HyDE uses a language model to generate answers from the query. These answers are converted into embeddings, which are used to find the closest matches. This process enables HyDE to run answer-to-answer embedding-similarity searches.

### Combine query translations into a pipeline

You can use multiple query translations. You can even use all four of these translations in conjunction. The following diagram shows an example of how you can combine these translations into a pipeline.

:::image type="complex" source="./_images/rag-query-transformation.svg" lightbox="./_images/rag-query-transformation.svg" alt-text="Diagram that shows a RAG pipeline that has query transformers." border="false":::
    The diagram shows a pipeline that has four steps. The original query is passed to the first step, a box called query augmenter. The query augmenter outputs the original query and an augmented query. The augmented query is passed to the second step, a box called query decomposer. The query decomposer outputs the original query, an augmented query, and four decomposed queries. The decomposed queries are passed to the third step. The third step has a box that says For each decomposed query. That box has three substeps: Query rewriter, query executor, and reranker. The output of step three is the original query, an augmented query, four decomposed queries, and the accumulated context. The original query and the accumulated context are passed to the fourth step. The fourth step has three substeps: Query rewriter, query executor, and reranker. The result of step four is the final result.
:::image-end:::

The pipeline has the following steps:

1. The optional query augmenter step receives the original query. This step outputs the original query and the augmented query.

1. The optional query decomposer step receives the augmented query. This step outputs the original query, the augmented query, and the decomposed queries.
1. Each decomposed query performs three substeps. After all the decomposed queries go through the substeps, the output includes the original query, the augmented query, the decomposed queries, and an accumulated context. The accumulated context includes the aggregation of the top *N* results from all the decomposed queries that go through the substeps. The substeps include the following tasks:

    1. The optional query rewriter rewrites the decomposed query.
    1. The search index processes the rewritten query or the original query. It runs the query by using search types, such as vector, full text, hybrid, or manual multiple. The search index can also use advanced query capabilities, such as HyDE.
    1. The results are reranked. The top *N* reranked results are added to the accumulated context.
1. The original query, along with the accumulated context, goes through the same three substeps as each decomposed query. But only one query goes through the steps, and the caller receives the top *N* results.

### Pass images in queries

Some multimodal models, such as GPT-4V and GPT-4o, can interpret images. If you use these models, you can avoid chunking your images and pass the image as part of the prompt to the multimodal model. You should experiment to determine how this approach performs compared to chunking the images with and without passing extra context. You should also compare the cost difference and do a cost-benefit analysis.

### Filter queries

To filter queries, you can use fields in the search store that are configured as filterable. Consider filtering keywords and entities for queries that use those fields to help narrow down the result. Use filtering to eliminate irrelevant data. Retrieve only the data that satisfies specific conditions from an index. This practice improves the overall performance of the query and provides more relevant results. To determine whether filtering benefits your scenario, do experiments and tests. Consider factors such as queries that don't have keywords or have inaccurate keywords, abbreviations, or acronyms.

### Weight fields

In AI Search, you can weight fields to influence the ranking of results based on criteria. 

> [!NOTE]
> This section describes AI Search weighting capabilities. If you use a different data platform, research the weighting capabilities of that platform.

AI Search supports scoring profiles that contain [parameters for weighted fields and functions for numeric data](/azure/search/index-add-scoring-profiles#key-points-about-scoring-profiles). Scoring profiles only apply to nonvector fields. Support for vector and hybrid search is in preview. You can create multiple scoring profiles on an index and optionally choose to use one on a per-query basis.

The fields that you weight depend on the type of query and the use case. For example, if the query is keyword-centric, such as "Where is Microsoft headquartered?", you want a scoring profile that weights entity or keyword fields higher. You might use different profiles for different users, allow users to choose their focus, or choose profiles based on the application.

In production systems, you should only maintain profiles that you actively use in production.

### Use reranking

Use reranking to run one or more queries, aggregate the results, and rank those results. Consider the following scenarios that benefit from reranking search results:

- You performed [manual multiple searches](#manual-multiple-queries), and you want to aggregate the results and rank them.

- Vector and keyword searches aren't always accurate. You want to increase the count of documents that you return from your search, which can include valid results that might otherwise be ignored, and use reranking to evaluate the results.

You can use a language model or cross‑encoder to rerank results. Some platforms, like AI Search, have proprietary methods to rerank results. You can evaluate these options for your data to determine what works best for your scenario. The following sections provide details about these methods.

#### Language model reranking

The following sample language model prompt reranks results. For more information, see [RAG experiment accelerator](https://github.com/microsoft/rag-experiment-accelerator/blob/development/rag_experiment_accelerator/llm/prompt/prompt.py).

```text
Each document in the following list has a number next to it along with a summary of the document. A question is also provided.
Respond with the numbers of the documents that you should consult to answer the question, in order of relevance, and the relevance score as a JSON string based on JSON format as shown in the schema section. The relevance score is a number from 1 to 10 based on how relevant you think the document is to the question. The relevance score can be repetitive. Don't output any other text, explanation, or metadata apart from the JSON string. Just output the JSON string, and strip every other text. Strictly remove the last comma from the nested JSON elements if it's present.
Don't include any documents that aren't relevant to the question. There should be exactly one document element.

Example format:
Document 1:
content of document 1
Document 2:
content of document 2
Document 3:
content of document 3
Document 4:
content of document 4
Document 5:
content of document 5
Document 6:
content of document 6
Question: user-defined question

schema:
{
    "documents": {
        "document_1": "Relevance",
        "document_2": "Relevance"
    }
}
```

#### Cross-encoder reranking

The following example uses a [cross encoder provided by Hugging Face](https://huggingface.co/cross-encoder) to load the Roberta model. It iterates over each chunk and uses the model to calculate similarity, which provides a value. It sorts the results and returns the top *N* results. For more information, see [RAG experiment accelerator GitHub repository](https://github.com/microsoft/rag-experiment-accelerator/blob/development/rag_experiment_accelerator/reranking/reranker.py).

```python
from sentence_transformers import CrossEncoder
...

model_name = 'cross-encoder/stsb-roberta-base'
model = CrossEncoder(model_name)

cross_scores_ques = model.predict(
    [[user_prompt, item] for item in documents],
    apply_softmax=True,
    convert_to_numpy=True,
)

top_indices_ques = cross_scores_ques.argsort()[-k:][::-1]
sub_context = []
for idx in list(top_indices_ques):
    sub_context.append(documents[idx])
```

#### Semantic ranking

AI Search has a proprietary feature called [semantic ranking](/azure/search/semantic-search-overview). This feature uses deep learning models that were adapted from Microsoft Bing that promote the most semantically relevant results. For more information, see [How semantic ranker works](/azure/search/semantic-search-overview#how-semantic-ranker-works).

### Consider other search guidance

Consider the following general guidance when you implement your search solution:

- Return the title, summary, source, and the raw uncleaned content fields from a search.

- Determine up front whether you need to break down a query into subqueries.
- Run vector and text queries on multiple fields. When you receive a query, you don't know whether vector search or text search is better. And you don't know the ideal fields that the vector search or keyword search should search. You can search on multiple fields, potentially with multiple queries, rerank the results, and return the results that have the highest scores.
- Filter on keyword and entity fields to narrow down results.
- Use keywords along with vector searches. The keywords filter the results to a smaller subset. The vector store works against that subset to find the best matches.

## Evaluate your search results

In the preparation phase, you [gathered test queries along with test document information](./rag-preparation-phase.md#gather-test-query-output). You can use the following information that you gathered in that phase to evaluate your search results:

- The query: The sample query
- The context: The collection of all the text in the test documents that address the sample query

To evaluate your search solution, you can use the following well-established retrieval evaluation methods:

- **Precision at K:** The percentage of correctly identified relevant items out of the total search results. This metric focuses on the accuracy of your search results.

- **Recall at K:** The percentage of relevant items in the top *K* out of the total possible relative items. This metric focuses on search results coverage.
- **Mean Reciprocal Rank (MRR):** The average of the reciprocal ranks of the first relevant answer in your ranked search results. This metric focuses on where the first relevant result occurs in the search results.

You should test positive and negative examples. For the positive examples, you want the metrics to be as close to 1 as possible. For the negative examples, where your data shouldn't be able to address the queries, you want the metrics to be as close to 0 as possible. You should test all your test queries. Average the positive query results and the negative query results to understand how your search results behave in aggregate.

## Next step

> [!div class="nextstepaction"]
> [LLM end-to-end evaluation phase](./rag-llm-evaluation-phase.md)

## Related resources

- [Quickstart: Chat with Azure OpenAI models by using your own data](/azure/ai-services/openai/use-your-data-quickstart)
- [Hybrid search via vectors and full text in AI Search](/azure/search/hybrid-search-overview)
