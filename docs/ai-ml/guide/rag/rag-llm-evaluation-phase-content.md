In this phase, you evaluate your Retrieval-Augmented Generation (RAG) solution by examining the expected user prompts that contain the retrieved grounding data against the language model. Before you reach this phase, you should complete the preceding phases. You need to collect your test documents and queries, chunk your test documents, enrich the chunks, embed the chunks, create a search index, and implement a search strategy. Then you should evaluate each of these phases and ensure that the results meet your expectations. At this point, you should be confident that your solution returns relevant grounding data for a user query.

This grounding data forms the context for the prompt that you send to the language model to address the user's query. [Prompt engineering strategies](https://platform.openai.com/docs/guides/prompt-engineering) are beyond the scope of this article. This article addresses the evaluation of the engineered call to the language model from the perspective of the grounding data. This article covers common language model evaluation metrics and specific similarity and evaluation metrics that you can use in model evaluation calculations or as standalone metrics.

This article doesn't attempt to provide an exhaustive list of language model metrics or similarity and evaluation metrics. The number of these metrics grows every day. What's important for you to take away from this article is that there are various metrics that each have distinct use cases. Only you have a holistic understanding your workload. You and your data scientists must determine what you want to measure and which metrics are appropriate.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml) first.

## Language model evaluation metrics

There are several metrics that you can use to evaluate the language model's response. A few of these metrics are groundedness, completeness, utilization, and relevancy.

> [!IMPORTANT]
> Language model responses are nondeterministic, which means that the same prompt to a language model often returns different results. This concept is important to understand when you use a language model as part of your evaluation process. Consider using a target range instead of a single target when you evaluate language model use.

### Groundedness

*Groundedness*, sometimes referred to as *faithfulness*, measures whether the response is based completely on the context. It validates that the response isn't using information other than what exists in the context. A low groundedness metric indicates that the language model might be outputting inaccurate or nonsensical responses.

#### Calculate groundedness

Use the following methods to calculate the groundedness of responses:

- [Azure AI Content Safety-based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#aacs-based-groundedness) is a custom model that uses natural language inference to determine whether claims, or in this case chunks, are based on context in the source document.
- [Large language model-based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#prompt-only-based-groundedness) uses a language model to determine the level of groundedness of the response.
- [Ragas faithfulness library](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/).
- [MLflow faithfulness calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge).

#### Evaluate groundedness

A low groundedness calculation indicates that the language model doesn't see the chunks as relevant. You should evaluate whether you need to add data to your collection, adjust your chunking strategy or chunk size, or fine-tune your prompt.

### Completeness

*Completeness* measures whether the response answers all parts of the query. Completeness helps you understand whether the chunks in the context are pertinent, directly relate to the query, and provide a complete answer.

#### Calculate completeness

Use the following methods to calculate the completeness of responses:

- [AI-assisted retrieval score prompting](/azure/ai-studio/concepts/evaluation-metrics-built-in#ai-assisted-retrieval-score).
- A language model can help you measure the quality of the language model response. You need the question, context, and generated answer to take this measurement. The following steps outline the high-level process:
  1. Use the language model to rephrase, summarize, or simplify the question. This step identifies the intent.
  2. Ask the model to check whether the intent or the answer to the intent is found in or can be derived from the retrieved documents. The answer can be "yes" or "no" for each document. Answers that start with "yes" indicate that the retrieved documents are relevant to the intent or answer to the intent.
  3. Calculate the ratio of the intents that have an answer that begins with "yes."
  4. Square the score to highlight the errors.

#### Evaluate completeness

If completeness is low, start working to increase it by evaluating your embedding model. Compare the vocabulary in your content to the vocabulary in your embedding model. Determine whether you need a domain-specific embedding model or whether you should fine-tune an existing model. The next step is to evaluate your chunking strategy. If you use fixed-sized chunking, consider increasing your chunk size. You can also evaluate whether your test data has enough data to completely address the question.

### Utilization

*Utilization* measures the extent to which the response consists of information from the chunks in the context. The goal is to determine the extent to which each chunk is part of the response. Low utilization indicates that your results might not be relevant to the query. You should evaluate utilization alongside completeness.

#### Calculate utilization

Use a language model to calculate utilization. You can pass the response and the context that contains the chunks to the language model. You can ask the language model to determine the number of chunks that entail the answer.

#### Evaluate utilization

The following table provides guidance for how to evaluate completeness and utilization.

| | High utilization | Low utilization |
| --- | --- | --- |
| **High completeness** | No action needed. | In this case, the returned data addresses the question but also returns irrelevant chunks. Consider reducing the top-k parameter value to yield more probable or deterministic results. |
| **Low completeness** | In this case, the language model uses the chunks that you provide, but they don't fully address the question. Consider taking the following steps:<br /><ul><li>Review your chunking strategy to increase the context within the chunks.</li><li>Increase the number of chunks by increasing the top-k parameter value.</li><li>Evaluate whether you have chunks that weren't returned that can increase the completeness. If so, investigate why they weren't returned.</li><li>Follow the guidance in the [completeness section](#completeness).</li></ul> | In this case, the returned data doesn't fully answer the question, and the chunks you provide aren't utilized completely. Consider taking the following steps:<br /><ul><li>Review your chunking strategy to increase the context within the chunks. If you use fixed-size chunking, consider increasing the chunk sizes.</li><li>Fine-tune your prompts to improve responses.</li></ul> |

### Relevance

*Relevance* measures the extent to which the language model's response is pertinent and related to the query.

#### Calculate relevance

Use the following methods to calculate the relevance of responses:

- [AI-assisted: Relevance in Azure AI Foundry](/azure/ai-studio/concepts/evaluation-metrics-built-in#ai-assisted-relevance)
- [Ragas answer relevancy library](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/)
- [MLflow relevance calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge)

> [!NOTE]
> You can use Azure AI Foundry portal to perform the calculations or use the guidance in this article to calculate relevance yourself.

#### Evaluate relevance

When relevance is low, do the following tasks:

1. Ensure that the chunks provided to the language model are relevant.
  - Determine whether any relevant, viable chunks aren't returned. If you discover these chunks, evaluate your embedding model.
  - If there aren't viable chunks, look to see whether relevant data exists. If it does, evaluate your chunking strategy.
1. If relevant chunks are returned, evaluate your prompt.

The scores that evaluation methods like [completeness](#completeness) output should yield results that are similar to the relevance score.

## Similarity and evaluation metrics

There are hundreds of similarity and evaluation metrics that you can use in data science. Some algorithms are specific to a domain, such as speech-to-text or language-to-language translation. Each algorithm has a unique strategy for calculating its metric.

Data scientists determine what you want to measure and which metric or combination of metrics you can use to measure it. For example, for language translation, the bilingual evaluation understudy (BLEU) metric checks how many n-grams appear in both the machine translation and human translation to measure similarity based on whether the translations use the same words. Cosine similarity uses embeddings between the machine and human translations to measure semantic similarity. If your goal is to have high semantic similarity and use similar words to the human translation, you want a high BLEU score with high cosine similarity. If you only care about semantic similarity, focus on cosine similarity.

The following list contains a sample of common similarity and evaluation metrics. Notice that the listed similarity metrics are described as token based, sequence based, or edit based. These descriptions illustrate which approaches the metrics use to calculate similarity. The list also contains three algorithms to evaluate the quality of text translation from one language to another.

- **[Longest common substring](https://en.wikipedia.org/wiki/Longest_common_substring)** is a sequence-based algorithm that finds the longest common substring between two strings. The longest common substring percentage takes the longest common substring and divides it by the number of characters of the smaller or larger input string.
- **[Longest common subsequence (LCS)](https://en.wikipedia.org/wiki/Longest_common_subsequence)** is a sequence-based algorithm that finds the longest subsequence between two strings. LCS doesn't require the subsequences to be in consecutive order.
- **[Cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity)** is a token-based algorithm that calculates the cosine of the angle between the two vectors.
- **[Jaro-Winkler distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)** is an edit-based algorithm that counts the minimum number of steps to transform one string into another.
- **[Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance)** is an edit-based algorithm that measures the minimum number of substitutions that are required to transform one string into another.
- **[Jaccard index](https://en.wikipedia.org/wiki/Jaccard_index)** is a token-based algorithm that calculates similarity by dividing the intersection of two strings by the union of those strings.
- **[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)** is an edit-based algorithm that calculates similarity by determining the minimum number of single character edits that are required to transform one string into another.
- **[BLEU](https://en.wikipedia.org/wiki/BLEU)** evaluates the quality of text that is the result of machine translation from one language to another. BLEU calculates the overlap of n-grams between a machine translation and a human-quality translation to make this evaluation.
- **[ROUGE](https://en.wikipedia.org/wiki/ROUGE_(metric))** is a metric that compares a machine translation of one language to another to a human-created translation. There are several ROUGE variants that use the overlap of n-grams, skip-bigrams, or longest common subsequence.
- **[METEOR](https://en.wikipedia.org/wiki/METEOR)** evaluates the quality of text that is the result of machine translation by looking at exact matches, matches after stemming, synonyms, paraphrasing, and alignment.

For more information about common similarity and evaluation metrics, see the following resources:

- [PyPi textdistance package](https://pypi.org/project/textdistance/)
- [Wikipedia list of similarity algorithms](https://en.wikipedia.org/wiki/Similarity_measure)

## Documentation, reporting, and aggregation

You should document both the hyperparameters that you choose for an experiment and the resulting evaluation metrics so that you can understand how the hyperparameters affect your results. You should document hyperparameters and results at granular levels, like embedding or search evaluation, and at a macro level, like testing the entire system end to end.

During design and development, you might be able to track the hyperparameters and results manually. However, performing multiple evaluations against your entire test document and test query collection might involve hundreds of evaluation runs and thousands of results. You should automate the persistence of parameters and results for your evaluations.

After your hyperparameters and results are persisted, you should consider making charts and graphs to help you visualize how the hyperparameters affect the metrics. Visualization helps you identify which choices lead to dips or spikes in performance.

It's important to understand that designing and evaluating your RAG solution isn't a one-time operation. Your collection of documents changes over time. The questions that your customers ask change over time, and your understanding of the types of questions evolves as you learn from production. You should revisit this process again and again. Maintaining documentation of past evaluations is critical for future design and evaluation efforts.

## The RAG Experiment Accelerator

These articles walk you through all the phases and design choices that are involved in designing and evaluating a RAG solution. The articles focus on what you should do, not how to do it. An engineering team that works with Microsoft top customers developed a tool called the [RAG Experiment Accelerator](https://github.com/microsoft/rag-experiment-accelerator). The RAG Experiment Accelerator is a state-of-the-art experimentation framework. It was designed to optimize and enhance the development of RAG solutions. The RAG Experiment Accelerator empowers researchers and developers to efficiently explore and fine-tune the critical components that drive RAG performance. This innovation ultimately results in more accurate and coherent text generation.

The RAG Experiment Accelerator uses a command-line interface, so you can easily experiment with various embedding models, refine chunking strategies, and evaluate different search approaches to unlock the full potential of your RAG system. It allows you to focus on the core aspects of RAG development by using a simple configuration for hyperparameter tuning.

The framework also provides comprehensive support for language model configuration. This support helps you strike the perfect balance between model complexity and generation quality. This tool helps you streamline the experimentation process, save time, and significantly improve the performance of your RAG models.

## RAG with Vision Application Framework

Much of the guidance in this article about working with media in your RAG solution came from another engineering team that works with Microsoft top customers. This team wrote a framework called the [RAG with Vision Application Framework](https://github.com/Azure-Samples/rag-as-a-service-with-vision). This framework provides a Python-based RAG pipeline that processes both textual and image content from MHTML documents.

The framework loads, chunks, and enriches text and images from MHTML files. It then ingests the chunks into Azure Cognitive Search. The framework implements caching for image enrichment for processing and cost efficiency. The framework also incorporates evaluation as part of the pipeline.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/) | Software Engineer II
- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Architecture Center Content Lead
- [Paul Butler](https://www.linkedin.com/in/paulfbutler2016/) | Software Engineer
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Principal Software Engineer
- [Soubhi Hadri](https://www.linkedin.com/in/soubhihadri/) | Senior Data Scientist
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Engineer
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/) | Senior Technical Program Manager
- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer
- [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/) | Principal AI Cloud Solution Architect

## Next steps

> [!div class="nextstepaction"]
> [RAG Experimentation Accelerator](https://github.com/microsoft/rag-experiment-accelerator)

> [!div class="nextstepaction"]
> [RAG with Vision Application Framework](https://github.com/Azure-Samples/rag-as-a-service-with-vision)

## Related resource

- [Develop an evaluation flow](/azure/ai-studio/how-to/flow-develop-evaluation)
