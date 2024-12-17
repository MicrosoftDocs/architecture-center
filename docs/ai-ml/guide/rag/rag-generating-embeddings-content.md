In the previous steps of your Retrieval-Augmented Generation (RAG) solution, you divided your documents into chunks and enriched the chunks. Now you need to generate embeddings for those chunks and any metadata fields on which you plan to perform vector searches.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml).

An embedding is a mathematical representation of an object, such as text. When a neural network is being trained, many representations of an object are created and each representation has connections to other objects in the network. An embedding is one of the representations of the object that's selected because it captures the semantic meaning of the object.

The representation of one object has connections to representations of other objects, so you can compare objects mathematically. The following example shows how embeddings capture semantic meaning and relationships between each other:

`embedding (king) - embedding (man) + embedding (woman) = embedding (queen)`

Embeddings are compared to one another by using the notions of similarity and distance. The following diagram shows a comparison of embeddings.

:::image type="complex" source="./_images/embedding-similarity.svg" lightbox="./_images/embedding-similarity.svg" alt-text="Diagram showing how vectors are compared." border="false":::
   Diagram that shows a two-dimensional grid. The sentences "The cat is on the mat" and "The cat is sitting on the mat" are in boxes in the upper right hand quadrant of the grid, close to one another. There are two vectors that are pointing at each box. The angle between the vectors is small. There's a box in the lower right quadrant with the text "It is currently sunny in Phoenix" with a vector pointing at that box. The angle between that vector and the vector for "The cat is sitting on the mat" is large.
:::image-end:::

In a RAG solution, you often embed the user query by using the same embedding model as your chunks. Then, you search your database for relevant vectors to return the most semantically relevant chunks. The original text of the relevant chunks is passed to the language model as grounding data.

> [!NOTE]
> Vectors represent the semantic meaning of text in a way that allows for mathematical comparison. So, you must clean the chunks so that mathematical proximity between vectors accurately reflects their semantic relevancy.

## The importance of the embedding model

The embedding model that you choose can significantly affect the relevancy of your vector search results. You must consider the vocabulary of the embedding model. Every embedding model is trained with a specific vocabulary. For example, the vocabulary size of the [BERT model](https://huggingface.co/docs/transformers/en/model_doc/bert) is about 30,000 words.

The vocabulary of an embedding model is important because it handles words that aren't in its vocabulary in a unique manner. If a word isn't in the model's vocabulary, it still needs to calculate a vector for it. To do this, many models break down the words into subwords. They treat the subwords as distinct tokens, or they aggregate the vectors for the subwords to create a single embedding.

For example, the word *histamine* might not be in an embedding model's vocabulary. *Histamine* has a semantic meaning of a chemical that your body releases, which causes allergy symptoms. The embedding model doesn't contain *histamine*. So, it might break the word down into subwords that are in its vocabulary, such as *his*, *ta*, and *mine*.

:::image type="content" source="./_images/word-broken-into-subwords.png" lightbox="./_images/word-broken-into-subwords.png" alt-text="Diagram that shows the word histogram broken down into the following subwords: his, ta, and mine." border="false":::

The semantic meanings of these subwords are far from the meaning of *histamine*. The individual or combined vector values of the subwords result in poorer vector matches compared to if *histamine* were in the model's vocabulary.

## Choose an embedding model

Determine the right embedding model for your use case. Consider the overlap between the embedding model's vocabulary and your data's words when you choose an embedding model.

:::image type="complex" source="./_images/choose-an-embedding-model.png" lightbox="./_images/choose-an-embedding-model.png" alt-text="Diagram that shows the flow of how to choose an embedding model." border="false":::
Diagram that shows a flow for choosing an embedding model. The first decision is "Domain-specific?". If no, the flow terminates at "Test top ranked general models." If yes, the next decision is "Domain model available?". If no, the flow terminates at "Fine tune general model." If yes, the flow terminates at "Test domain model".
:::image-end:::

First, determine whether you have domain-specific content. For example, are your documents specific to a use case, your organization, or an industry? A good way to determine domain specificity is to check whether you can find the entities and keywords in your content on the internet. If you can, a general embedding model likely can, too.

### General or non-domain-specific content

When you choose a general embedding model, start with the [Hugging Face leaderboard](https://huggingface.co/spaces/mteb/leaderboard). Get up-to-date embedding model rankings. Evaluate how the models work with your data, and start with the top-ranking models.

### Domain-specific content

For domain-specific content, determine whether there's a domain-specific model available that you can use. For example, your data might be in the biomedical domain, so you might use the [BioGPT model](https://github.com/microsoft/BioGPT). This language model is pretrained on a large collection of biomedical literature. You can use it for biomedical text mining and generation. If domain models are available, evaluate how these models work with your data.

If you don't have a domain-specific model, or the domain-specific model doesn't perform well, you can fine-tune a general embedding model with your domain-specific vocabulary.

> [!IMPORTANT]
> For any model that you choose, you need to verify that the license is suitable for your needs and the model provides the necessary language support.

### Evaluate embedding models

Two effective means of evaluating an embedding model are visualizing the embeddings and evaluating the distance between question and chunk vectors.

#### Visualize embeddings

You can use libraries such as t-SNE to plot the vectors for your chunks and your question on an X-Y graph. You can then determine how far apart the chunks are from one another and the question. The figure shows chunk vectors plotted. The two arrows near one another represent two chunks vectors while the other arrow represents a question vector. You can use this visualization to understand how far the question is from the chunks.

:::image type="complex" source="./_images/visualize-embeddings.png" lightbox="./_images/visualize-embeddings.png" alt-text="Visualization of an embedding. The image shows a bunch of blue dots plotted on an X-Y scale." border="false":::
   Visualization of an embedding. The image shows a bunch of blue dots plotted on an X-Y scale. It also shows two arrows pointing to plot points near one another and another arrow showing a plot point far away from the other two.
:::image-end:::

#### Calculate embedding distances

A programmatic means of evaluating how well your embedding model is working with your questions and chunks is to calculate the distance between the question vectors and the chunk vectors. You can use the Euclidean distance or the Manhattan distance.

## Embedding economics

When you choose an embedding model, there's a trade-off between performance and cost. Larger embedding models usually have better performance on benchmarking datasets. However, the increased performance comes at a cost. Larger vectors require more space to be stored in a vector database, and require more computational resources and time when comparing embeddings. Smaller embedding models usually have lower performance on the same benchmarks. They require less space in your vector database, and require less compute and time when comparing embeddings.

When you design your system, you should account for the cost of embedding in terms of both storage, compute, and the performance requirements. Validating the performance of the models through experimentation is crucial. The publicly available benchmarks are mainly academic datasets. Most results can't be directly transposed to business data and use cases. Depending on the requirements, you can favor performance over cost, or accept a trade-off of good-enough performance in exchange for lower cost.

## Next step

> [!div class="nextstepaction"]
> [Information retrieval phase](./rag-information-retrieval.yml)

## Related resources

- [Understand embeddings in Azure OpenAI Service](/azure/ai-services/openai/concepts/understand-embeddings)
- [Tutorial: Explore Azure OpenAI Service embeddings and document search](/azure/ai-services/openai/tutorials/embeddings)
