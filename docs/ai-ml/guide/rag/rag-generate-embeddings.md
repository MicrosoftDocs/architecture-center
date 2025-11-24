---
title: Develop a RAG Solution - Generate Embeddings Phase
description: Learn how embeddings work, how to choose an embedding model, and how your embedding model can affect your vector search results.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/10/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# RAG generate embeddings phase

In the previous steps of your retrieval-augmented generation (RAG) solution, you divided your documents into chunks and enriched the chunks. In this step, you generate embeddings for those chunks and any metadata fields on which you plan to perform vector searches.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.md).

An embedding is a mathematical representation of an object, such as text. When a neural network is being trained, the process creates many representations of an object. Each representation has connections to other objects in the network. An embedding is important because it captures the semantic meaning of the object.

The representation of one object has connections to representations of other objects, so you can compare objects mathematically. The following example shows how embeddings capture semantic meaning and relationships between objects:

`embedding (king) - embedding (man) + embedding (woman) = embedding (queen)`

Embeddings are compared to one another by using the notions of similarity and distance. The following grid shows a comparison of embeddings.

:::image type="complex" border="false" source="./_images/embedding-similarity.svg" lightbox="./_images/embedding-similarity.svg" alt-text="Diagram that shows a comparison of vectors.":::
   Diagram that shows a two-dimensional grid. The sentences "The cat is on the mat" and "The cat is sitting on the mat" are in boxes in the upper right quadrant of the grid, close to one another. There are two vectors that point at each box. The angle between the vectors is small. There's a box in the lower right quadrant with the text "It's currently sunny in Phoenix" with a vector that points at that box. The angle between that vector and the vector for "The cat is sitting on the mat" is large.
:::image-end:::

In a RAG solution, you embed the user query by using the same embedding model as your chunks. Then, you search your database for relevant vectors to return the most semantically relevant chunks. The original text of the relevant chunks passes to the language model as grounding data.

> [!NOTE]
> Vectors represent the semantic meaning of text in a way that allows for mathematical comparison. You must clean the chunks so that the mathematical proximity between vectors accurately reflects their semantic relevancy.

## Understand the importance of your embedding model

The embedding model that you choose can significantly affect the relevancy of your vector search results. You must carefully consider the vocabulary of the embedding model. Every embedding model is trained with a specific vocabulary. For example, the vocabulary size of the [bidirectional encoder representations from transformers (BERT) model](https://huggingface.co/docs/transformers/en/model_doc/bert) is about 30,000 words.

The vocabulary of an embedding model is important because it handles words that aren't in its vocabulary in a unique manner. If a word isn't in the model's vocabulary, it still calculates a vector for it. Many models break down the words into subwords. They treat the subwords as distinct tokens, or they aggregate the vectors for the subwords to create a single embedding.

For example, the word *histamine* might not be in an embedding model's vocabulary. The word *histamine* has a semantic meaning as a chemical that your body releases, which causes allergy symptoms. The embedding model doesn't contain *histamine*. So, it might separate the word into subwords that are in its vocabulary, such as *his*, *ta*, and *mine*.

:::image type="content" border="false" source="./_images/word-broken-into-subwords.png" lightbox="./_images/word-broken-into-subwords.png" alt-text="Diagram that shows the word histamine broken down into the following subwords: his, ta, and mine.":::

The semantic meanings of these subwords are far from the meaning of *histamine*. The individual or combined vector values of the subwords result in poorer vector match compared to if the word *histamine* were in the model's vocabulary.

## Choose an embedding model

Determine the right embedding model for your use case. Consider the overlap between the embedding model's vocabulary and your data's words when you choose an embedding model.

:::image type="complex" border="false" source="./_images/choose-embedding-model.png" lightbox="./_images/choose-embedding-model.png" alt-text="Diagram that shows the flow of how to choose an embedding model." ::: 
   The first decision is "Domain-specific?" If no, the flow terminates at "Test top-ranked general models." If yes, the next decision is "Domain model available?" If no, the flow terminates at "Fine-tune general model." If yes, the flow terminates at "Test domain model".
:::image-end:::

First, determine whether you have domain-specific content. For example, are your documents specific to a use case, your organization, or an industry? A good way to determine domain specificity is to check whether you can find the entities and keywords in your content on the internet. If you can, a general embedding model likely can, too.

### General or non-domain-specific content

When you choose a general embedding model, start with the [Hugging Face leaderboard](https://huggingface.co/spaces/mteb/leaderboard) model rankings. Evaluate how the models work with your data, and start with the top-ranking models.

### Domain-specific content

For domain-specific content, determine whether you can use a domain-specific model. For example, your data might be in the biomedical domain, so you might use the [BioGPT model](https://github.com/microsoft/BioGPT). This language model is pretrained on a large collection of biomedical literature. You can use it for biomedical text mining and generation. If domain-specific models are available, evaluate how these models work with your data.

If you don't have a domain-specific model, or the domain-specific model doesn't perform well, you can fine-tune a general embedding model with your domain-specific vocabulary.

> [!IMPORTANT]
> For any model that you choose, you need to verify that the license suits your needs and the model provides the necessary language support.

## Generate multimodal embeddings

Embeddings aren't limited to text. You can generate embeddings for text and other media types, such as images, audio, and video. The process for generating embeddings is similar across modalities. Load the content, pass it through the embedding model, and store the resulting vector. But the choice of model and preprocessing steps vary by media type.

For example, you can use models like [Contrastive Language–Image Pre-training (CLIP)](https://openai.com/research/clip) to generate image embeddings. You can then use the embeddings in vector search to retrieve semantically similar images. For video, you must define a schema that extracts specific features, like object presence or narrative summary and use specialized models to generate embeddings for those features.

> [!TIP]
> Use a schema to define the features that you want to extract from multimodal content. This approach optimizes your embeddings for your retrieval goals.

## Use dimensionality reduction

Embedding vectors can be high dimensional, which increases storage and compute costs. Dimensionality reduction techniques help make embeddings more manageable, cost effective, and interpretable.

You can use algorithms such as [t-distributed stochastic neighbor embedding (t-SNE)](https://lvdmaaten.github.io/tsne/) or [principal component analysis (PCA)](https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html) to reduce the number of dimensions in your vectors. These tools are available in libraries like PyTorch and scikit-learn.

Dimensionality reduction can improve semantic clarity and visualization. It also helps eliminate unused or noisy features in dense embeddings.

> [!NOTE]
> Dimensionality reduction is a post-processing step. You apply it after generating embeddings to optimize storage and retrieval performance.

## Compare embeddings

When you evaluate embeddings, you can use mathematical formulas to compare vectors. These formulas help you determine how similar or dissimilar two embeddings are.

Common comparison methods include:

- **Cosine similarity**: Measures the angle between two vectors. Useful for high-dimensional data.
- **Euclidean distance**: Measures the straight-line distance between two vectors.
- **Manhattan distance**: Measures the absolute difference between vector components.
- **Dot product**: Measures the projection of one vector onto another.

> [!TIP]
> Choose your comparison method based on your use case. For example, use cosine similarity when you want to measure semantic closeness, and use Euclidean distance when you want to measure literal proximity.

## Evaluate embedding models

To evaluate an embedding model, visualize the embeddings and evaluate the distance between the question and chunk vectors.

### Visualize embeddings

You can use libraries, such as t-SNE, to plot the vectors for your chunks and your question on an X-Y graph. You can then determine how far the chunks are from one another and from the question. The following graph shows chunk vectors plotted. The two arrows near one another represent two chunk vectors. The other arrow represents a question vector. You can use this visualization to understand how far the question is from the chunks.

:::image type="complex" border="false" source="./_images/visualize-embeddings.png" alt-text="Graph that shows a visualization of an embedding. The image shows several blue dots that are plotted on an X-Y scale." :::
   Two arrows point to plot points near one another, and another arrow shows a plot point far away from the other two.
:::image-end:::

### Calculate embedding distances

You can use a programmatic method to evaluate how well your embedding model works with your questions and chunks. Calculate the distance between the question vectors and the chunk vectors. You can use the Euclidean distance or the Manhattan distance.

## Evaluate embedding models by using retrieval performance

To choose the best embedding model, evaluate how well it performs in retrieval scenarios. Embed your content, perform vector search, and assess whether the correct items are retrieved.

You can experiment with different models, comparison formulas, and dimensionality settings. Use evaluation metrics to determine which model provides the best results for your use case.

> [!IMPORTANT]
> Retrieval performance is the most practical way to evaluate embedding quality. Use real-world queries and content to test your models.

## Fine-tune embedding models

If a general or domain-specific model doesn't meet your needs, you can fine-tune it with your own data. Fine-tuning adjusts the model's weights to better represent your vocabulary and semantics.

Fine-tuning can improve retrieval accuracy, especially for specialized domains like code search or legal documents. But it requires careful evaluation and can sometimes degrade performance if the training data is poor.

Modern techniques like one-bit reinforcement learning (RL) make your fine-tuning more cost effective.

> [!TIP]
> Before you fine-tune your model, evaluate whether prompt engineering or constrained decoding can solve your problem. Use evaluation metrics and retrieval performance to guide your fine-tuning.

## Use the Hugging Face leaderboard

The [Hugging Face leaderboard](https://huggingface.co/spaces/mteb/leaderboard) provides up-to-date rankings of embedding models. Use it to identify top-performing models for your use case.

When you review models, consider:

- **Tokens:** The size of the model's vocabulary.
- **Memory:** The model's size and inference cost.
- **Dimensions:** The size of the output vectors.

> [!NOTE]
> Larger models aren't always better. They might increase cost without improving performance. Use dimensionality reduction and retrieval evaluation to find the right balance.

## Understand embedding economics

When you choose an embedding model, you must find a trade-off between performance and cost. Large embedding models usually have better performance on benchmarking datasets. But, the increased performance adds cost. Large vectors require more space in a vector database. They also require more computational resources and time to compare embeddings. Small embedding models usually have lower performance on the same benchmarks. They require less space in your vector database and less compute and time to compare embeddings.

When you design your system, consider the cost of embedding in terms of storage, compute, and performance requirements. You must validate the performance of the models through experimentation. The publicly available benchmarks are often academic datasets and might not directly apply to your business data and use cases. Depending on the requirements, you can favor performance over cost or accept a trade-off of good-enough performance for lower cost.

## Next step

> [!div class="nextstepaction"]
> [Information-retrieval phase](./rag-information-retrieval.md)

## Related resources

- [Understand embeddings in Azure OpenAI](/azure/ai-foundry/openai/concepts/understand-embeddings)
- [Tutorial: Explore Azure OpenAI embeddings and document search](/azure/ai-foundry/openai/tutorials/embeddings)