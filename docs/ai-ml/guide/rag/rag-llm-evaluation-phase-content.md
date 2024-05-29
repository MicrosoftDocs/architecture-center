Once you have reached this phase, you've generated your search index and determined what searches you want to perform. This phase addresses the process of evaluating of your Retrieval-Augmented Generation (RAG) solution from the perspective of evaluating expected user prompts containing the retrieved grounding data against the large language model. Before you reach this phase, you should have completed the preparation phase where you collected your test documents and queries, chunked your test documents, enriched the chunks, embedded the chunks, created a search index, and implemented a search strategy. You should have evaluated each of these phases and are happy with the results. At this point, you should feel comfortable that your solution returns relevant grounding data for a user query.

This grounding data forms the context for the prompt that you send to the large language model to address the user's query. [Prompt engineering strategies](https://platform.openai.com/docs/guides/prompt-engineering) are beyond the scope of this article. This article addresses the evaluation of the engineered call to the large language model from the perspective of the grounding data. This article covers *some* common large language model evaluation metrics, and some specific similarity and evaluation metrics that can be used in the large language model evaluation calculations or as stand alone metrics.

This article doesn't attempt to provide an exhaustive list of either large language model metrics or similarity and evaluation metrics. The number of these metrics are growing every day. What is important for you to take away from this article is that there are various metrics, each with their own distinct use case. You're the only one with a holistic understand your workload. You and your data scientists must determine what it is that you want to measure and which metrics help you accomplish that task.

> This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml).

## Large language model evaluation metrics

There are several metrics you can use to evaluate the large language model's response, including groundedness, completeness, utilization, and relevancy.

> [!IMPORTANT]
> Large language model responses are non-deterministic, meaning the same prompt to a large language model can and will often return different results. This is important to understand when using a large language model as part of your evaluation process. Consider using a target range over a single target when evaluating using a large language model.

### Groundedness

Groundedness, sometimes referred to as faithfulness, measures whether the response is completely based on the context. It validates that the response isn't using information other than what exists in the context. A low groundedness metric indicates that the large language model might be drifting into imaginative or nonsensical territory known as hallucinations.

**Calculating**

- [Azure AI Content Safety Service (AACS) based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#aacs-based-groundedness) is a custom model that uses Natural Language Inference (NLI) to determine whether claims, in this case chunks, are entailed or not entailed by a source document.
- [Large language model based groundedness](/azure/ai-studio/concepts/evaluation-metrics-built-in#prompt-only-based-groundedness) uses a large language model to determine the level of groundedness of the response.
- [Ragas faithfulness library](https://docs.ragas.io/en/latest/concepts/metrics/faithfulness.html)
- [MLflow faithfulness calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge)

**Evaluating**

If groundedness is low, it indicates that the large language model doesn't see the chunks as relevant. You should evaluate whether you need to add data to your corpus, adjust your chunking strategy or chunk size, or fine tune your prompt.

### Completeness

Completeness measures whether the response is answering all parts of the query. This helps you understand whether the chunks in the context are pertinent and directly related to the query and provide a complete answer.

**Calculating**

- [AI-assisted: Retrieval Score prompting](/azure/ai-studio/concepts/evaluation-metrics-built-in#ai-assisted-retrieval-score)
- A large language model can help you measure the quality of the large language model response. You need the question, context, and generated answer to do this. The following outlines the high level process:
  1. Use the large language model to rephrase, summarize, or simplify the question. This identifies the intent.
  2. Ask the model to check if the intent or the answer to the intent is found or can be derived from retrieved documents where the answer can be "No", or "Yes" for each document. Answers that start with "Yes" indicate that the retrieved documents are relevant to the intent or answer to the intent.
  3. Calculate the ratio of the intents that have an answer beginning with "Yes".
  4. Square the score to highlight the errors.

**Evaluating**

If completeness is low, start by evaluating your embedding model. Compare the vocabulary in your content with the vocabulary in your chosen embedding model. Determine whether you need a domain specific embedding model or you need to fine-tune an existing model. As a next step, evaluate your chunking strategy. If you are using fixed length, consider increasing your chunk size. You can also evaluate whether your test data has enough data to completely address the question.

### Utilization

Utilization measures the extent to which the response is made up of information from the chunks in the context. The goal is to determine the extent to which each chunk is part of the response. If utilization is low, this indicates that our results might not be relevant to the query. Utilization should be evaluated along side completeness.

**Calculating**

You can use a large language model to calculate the utilization. You can pass the response and the context containing the chunks to the large language model. You can ask the large language model to determine the number of chunks that entail the answer.

**Evaluating**

The following table provides guidance, taking both completeness and utilization together.

| | High utilization | Low utilization |
| --- | --- | --- |
| **High completeness** | No action needed | In this case, the data returned is able to address the question, but irrelevant chunks were returned. Consider reducing the top-k parameter value to yield more probable/deterministic results. |
| **Low completeness** | In this case, the chunks you are providing are being used, but are not fully addressing the question. Consider the following:<br /><ul><li>Review your chunking strategy to increase the context within the chunks</li><li>Increase the number of chunks by increasing the top-k parameter value</li><li>Evaluate whether you have chunks that were not returned that can increase the completeness. If so, investigate why they were not returned.</li><li>Follow the guidance in the [completeness section](#completeness)</li></ul> | In this case, you are not fully answering the question and the chunks you are providing are not being well utilized. Consider the following to address these issues:<br /><ul><li>Review your chunking strategy to increase the context within the chunks. If you are using fixed size chunking, consider increasing the chunk sizes.</li><li>Tune your prompts to improve responses</li></ul> |

### Relevance

Measures the extent to which the large language model's response is pertinent and related to the query.

**Calculating**

- [AI-assisted: Relevance in Azure AI Studio](/azure/ai-studio/concepts/evaluation-metrics-built-in#ai-assisted-relevance) - You can use Azure AI Studio to perform the calculations, or use the guidance in this article to calculate relevance for yourself.
- [Ragas answer relevancy library](https://docs.ragas.io/en/latest/concepts/metrics/answer_relevance.html)
- [MLflow relevance calculation](https://mlflow.org/docs/latest/llms/llm-evaluate/index.html#metrics-with-llm-as-the-judge)

**Evaluating**

When relevance is low, evaluate the following:

- Ensure that the chunks provided to the large language model are relevant.
  - Determine whether there are viable chunks that are relevant that were not returned. If there are, evaluate your embedding model.
  - If there are not viable chunks, look to see whether relevant data exists. If it does, evaluate your chunking strategy.
- If relevant chunks were returned, evaluate your prompt.

Other evaluation methods like [Completeness](#completeness) should be calculated and should yield similar scores to the ones observed in the relevance measure.

## Similarity and evaluation metrics

As mentioned in the introduction, there are hundreds of similarity and evaluation metrics used in data science. Some algorithms are specific to a domain, such as speech to text or language to language translation. Each algorithm has a unique strategy for calculating its metric.

The data scientist determines what it is you want to measure and what metric or combination of metrics you can use to measure it. For example, in the area of language translation, the Bleu metric checks how many n-grams appear in both the machine translation and human translation to measure similarity based on using the same words. Cosine similarity uses embeddings between the machine and human translations to measure semantic similarity. If your goal was to have high semantic similarity and use similar words to the human translation, your goal would be a high Bleu score with high cosine similarity. If you only cared about semantic similarity, you would focus on cosine similarity.

The following list contains a small sample of common similarity and evaluation metrics. Notice that the similarity metrics listed are described as token based, sequence based, or edit based, illustrating how they use vastly different approaches to calculating similarity. Also note that the list contains three algorithms for evaluating the quality of text translation from one language to another.

- **[Longest common substring](https://en.wikipedia.org/wiki/Longest_common_substring)** - Sequence based algorithm that finds the longest common substring between two strings. The longest common substring percentage takes the longest common substring and divides it by either the number of characters of the smaller or larger input string.
- **[Longest common subsequence (LCS)](https://en.wikipedia.org/wiki/Longest_common_subsequence)** - Sequence based algorithm that finds the longest subsequence between two strings. LCS doesn't require the subsequences to be in consecutive order.
- **[Cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity)** - Token based algorithm that calculates the cosine of the angle between the two vectors.
- **[Jaro Winkler](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)** - Edit based algorithm that counts the minimum number of steps to transform one string into another.
- **[Hamming](https://en.wikipedia.org/wiki/Hamming_distance)** - Edit based algorithm that measures the minimum number of substitutions that are required to transform one string to another.
- **[Jaccard](https://en.wikipedia.org/wiki/Jaccard_index)** - Token based algorithm that calculates similarity by dividing the intersection of two strings by the union of those strings.
- **[Levenshtein](https://en.wikipedia.org/wiki/Levenshtein_distance)** - Edit based algorithm that calculates similarity by determining the minimum number of single character edits required to transform one string to another.
- **[BLEU](https://en.wikipedia.org/wiki/BLEU)** - Evaluates the quality of text that is the result of machine translation from one language to another. Bleu calculates the overlap of n-grams between a machine translation and a human quality translation to make this evaluation.
- **[ROUGE](https://en.wikipedia.org/wiki/ROUGE_(metric))** - Compare a machine translation of one language to another to a human created translation. There are several ROUGE variants that use the overlap of n-grams, skip-bigrams, or longest common subsequence.
- **[METEOR](https://en.wikipedia.org/wiki/METEOR)** - Evaluates the quality of text that is the result of machine translation by looking at exact matches, matches after stemming, synonyms, paraphrasing, and alignment.

Refer to the following resources for common similarity and evaluation metrics:

- [PyPi textdistance package](https://pypi.org/project/textdistance/)
- [Wikipedia list of similarity algorithms](https://en.wikipedia.org/wiki/Similarity_measure)

## Documentation, reporting, and aggregation

You should document both the hyperparameters you chose for an experiment and the resulting evaluation metrics so you can understand the impact of the hyperparameters on your results. You should document hyperparameters and results at granular levels like embedding or search evaluation and at a macro level, like testing the entire system end to end.

During design and development, you might be able to track the hyperparameters and results manually. However, while performing multiple evaluations against your entire test document and test query corpus might involve hundreds of evaluation runs and thousands of results. You should automate the persistence of parameters and results for your evaluations.

Once your hyperparameters and results are persisted, you should consider building charts and graphs to allow you to more easily visualize the effects the hyperparameter choices have on the metrics. This will help you identify which choices lead to dips or spikes in performance.

It is important for you to understand that designing and evaluating your RAG solution isn't a one-time operation. Your corpus of documents will change over time. The questions your customers are asking will change over time and your understanding of the types of questions will evolve as you learn from production. You should revisit this process again and again. Maintaining documentation of past evaluations is critical for future design and evaluation efforts.

## The RAG Experiment Accelerator

These articles walk you through all the phases and design choices involved in designing and evaluating a RAG solution. The articles focus on what you should do, not how to do it. An engineering team that works with Microsoft's top customers has developed a tool called the [RAG Experiment Accelerator](https://github.com/microsoft/rag-experiment-accelerator). The RAG Experiment Accelerator is a state-of-the-art experimentation framework designed to optimize and enhance the development of Retrieval Augmented Generation (RAG) solutions. RAG Experiment Accelerator empowers researchers and developers to efficiently explore and fine-tune the critical components that drive RAG performance, ultimately leading to more accurate and coherent text generation.

With its CLI based interface, you can effortlessly experiment with various embedding models, refine chunking strategies, and evaluate different search approaches to unlock the full potential of your RAG system. It allows you to focus on the core aspects of RAG development while abstracting away the complexities of hyper-parameter tuning using simple configuration.

Moreover, the framework provides comprehensive support for large language model configuration, enabling you to strike the perfect balance between model complexity and generation quality. This tool allows you to streamline the experimentation process, save valuable time, and significantly improve the performance of your RAG models.

Whether you are a seasoned researcher pushing the boundaries of natural language understanding or an industry professional seeking to enhance text generation capabilities, this experimentation framework is the ultimate solution to accelerate your RAG development journey. Embrace the future of RAG experimentation and unlock the true potential of your models with this cutting-edge tool.

## Contributors

- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/)
- [Rob Bagby](https://www.linkedin.com/in/robbagby/)
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/)
- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/)
- [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/)
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/)

## Next steps

> [!div class="nextstepaction"]
> [Rag accelerator](https://github.com/microsoft/rag-experiment-accelerator)

## Related resources

- [Develop an evaluation flow in Azure AI Studio](/azure/ai-studio/how-to/flow-develop-evaluation)
