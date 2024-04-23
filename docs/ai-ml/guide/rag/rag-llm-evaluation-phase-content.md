This phase addresses the process of evaluating of your RAG solution from the perspective of evaluating expected user prompts containing the retrieved grounding data against the LLM. Prior to reaching this phase, you will have completed the preparation phase where you collected your test documents and queries, chunked your test documents, enriched the chunks, embedded the chunks, created a search index, and implemented a search strategy. You have evaluated each of these phases and are happy with the results. At this point, you should feel comfortable that your solution will return relevant grounding data for a user query.

This grounding data forms the context for the prompt that you will send to the LLM to address the user's query. [Prompt engineering strategies](https://platform.openai.com/docs/guides/prompt-engineering) are beyond the scope of this article. This article addresses the evaluation of the engineered call to the LLM from the perspective of the grounding data. This article will cover *some* common high-level metrics that you can use to evaluate the responses from your LLM, as well as some specific similarity and evaluation metrics that can be used in the effectiveness calculations or as stand alone metrics.

This article does not attempt to provide an exhaustive list of either LLM metrics or similarity and evaluation metrics. The number of these metrics are growing every day. What is important for you to take away from this article is that there are a variety of metrics, each with their own distinct use case. You are the only one with a wholistic understand your workload, so you and your data scientists must determine what it is that you want to measure and which metrics will help you accomplish that task.

## LLM evaluation metrics

There are several metrics you can use to evaluate the LLMs response, from both the perspective of the query and the grounding data you provided as part of the context, including groundedness, completeness, utilization, and relevancy.

> [!IMPORTANT]
> LLM responses are non-deterministic, meaning the same prompt to an LLM can and will often return different results. This is important to understand when using LLMs as part of your evaluation process. Consider using a target range over a single target when evaluating using an LLM.

### Groundedness

Groundedness, sometimes referred to as faithfulness, measures whether the response is completely based on the context. It validates that the response is not using information other what exists in the context. A low groundedness metric indicates that the LLM might be drifting into imaginative or nonsensical territory known as hallucinations.

**Calculating**

* [Azure AI Content Safety Service (AACS) based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#aacs-based-groundedness) is a custom model that uses Natural Language Inference (NLI) to determine whether claims, in this case chunks, are entailed or not entailed by a source document.
* [LLM Based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#prompt-only-based-groundedness) uses an LLM to determine the level of groundedness of the response.
* [Ragas faithfulness library](https://docs.ragas.io/en/latest/concepts/metrics/faithfulness.html)
* [Mlflow faithfulness calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge)

**Evaluating** - If groundedness is low, this indicates that the LLM does not see the chunks as relevant. You should evaluate if you need to add data to your corpus, adjust your chunking strategy or chunk size, or fine tune your prompt.

### Completeness

Completeness measures whether the response is answering all parts of the query. This helps you understand whether the chunks in the context are adequate to answer the query completely.

**Calculating**

* You can use an LLM to calculate the completeness of the LLM response. You can use the LLM to restate the question. You then pass the restated question and the response to the LLM and ask it to evaluate the completeness of the response. TODO: Do we need an example or a link?

**Evaluating** - If completeness is low, you can start by evaluating your embedding model. TODO: why? What next?

### Utilization

Utilization measures the extent to which the response is made up of information from the chunks in the context. The goal is to determine the extent to which each chunk is part of the response. If utilization is low, this indicates that our results may not be relevant to the query.

**Calculating**

* You can use an LLM to calculate the utilization. You can pass the response and the context containing the chunks to the LLM. You can ask the LLM to determine the number of chunks that entail the answer.

**Evaluating** - TODO: What are the logical steps

### Relevance

Measures the extent to which the LLM's response is pertinent and related to the query.

**Calculating**

* [AI-assisted: Retrieval Score in Azure AI Studio](/azure/ai-studio/concepts/evaluation-metrics-built-in#ai-assisted-retrieval-score)
* [Ragas answer relevancy library](https://docs.ragas.io/en/latest/concepts/metrics/answer_relevance.html)
* [Mlflow relevance calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge)

**Evaluating**  - TODO: What are the relevant steps?

## Similarity and evaluation metrics

As mentioned in the introduction, there are hundreds of similarity and evaluation metrics used in data science. Some algorithms are specific to a domain, such as speech to text or language to language translation. Each algorithm has a unique strategy for calculating its metric.

The data scientist will determine what it is you want to measure and what metric or combination of metrics you can use to measure it. For example, in the area of language translation, the Bleu metric checks how many n-grams appear in both the machine translation and human translation to measure similarity based on using the same words. Cosine similarity uses embeddings between the machine and human translations to measure semantic similarity. If your goal was to have high semantic similarity and use similar words to the human translation, your goal would be a high Bleu score with high cosine similarity. If you only cared about semantic similarity, you would focus on cosine similarity.

The following is a small list of some common similarity and evaluation metrics. Notice that the similarity metrics listed are described as token based, sequence based, or edit based, illustrating how they use vastly different approaches to calculating similarity. Also note that the list contains 3 algorithms for evaluating the quality of text translation from one language to another.

* **[Longest common substring](https://en.wikipedia.org/wiki/Longest_common_substring)** - Sequence based algorithm that finds the longest common substring between two strings. The longest common substring percentage takes the longest common substring and divides it by either the number of characters of the smaller or larger input string.
* **[Longest common subsequence (LCS)](https://en.wikipedia.org/wiki/Longest_common_subsequence)** - Sequence based algorithm that finds the longest subsequence between two strings. LCS does not require the subsequences to be in consecutive order.
* **[Cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity)** - Token based algorithm that calculates the cosine of the angle between the two vectors.
* **[Jaro Winkler](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)** - Edit based algorithm that counts the minimum number of steps to transform one string into another.
* **[Hamming](https://en.wikipedia.org/wiki/Hamming_distance)** - Edit based algorithm that measures the minimum number of substitutions that are required to transform one string to another.
* **[Jaccard](https://en.wikipedia.org/wiki/Jaccard_index)** - Token based algorithm that calculates similarity by dividing the intersection of two strings by the union of those strings.
* **[Levenshtein](https://en.wikipedia.org/wiki/Levenshtein_distance)** - Edit based algorithm that calculates similarity by determining the minimum number of single character edits required to transform one string to another.
* **[Bleu](https://en.wikipedia.org/wiki/BLEU) - Evaluates the quality of text that is the result of machine translation from one language to another by determining the overlap of n-grams in a machine translation and a human quality translation.
* **[Rouge](https://en.wikipedia.org/wiki/ROUGE_(metric)) - Compare a machine translation of one language to another to a human created translation. There are several Rouge variants that use the overlap of n-grams, skip-bigrams or longest common subsequence.
* **[Meteor](https://en.wikipedia.org/wiki/METEOR) - Evaluates the quality of text that is the result of machine translation by looking at exact matches, matches after stemming, synonyms, paraphrasing, and alignment.

Refer to the following resources for common similarity and evaluation metrics: TODO: Verify and add to list

* [PyPi textdistance package](https://pypi.org/project/textdistance/)
* [Wikipedia list of similarity algorithms](https://en.wikipedia.org/wiki/Similarity_measure)

## Documentation, reporting, and aggregation


