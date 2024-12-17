This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml).

In the previous step, you divided your documents into chunks and enriched the chunks. Now you need to generate embeddings for those chunks and any metadata fields on which you plan to perform vector searches.

An embedding is a mathematical representation of an object, such as text. When a neural network is being trained, many representations of an object are created and each representation has connections to other objects in the network. An embedding is one of the representations of the object that's selected because it captures the semantic meaning of the object.

An embedding is a mathematical representation of that object and that representation has connections to representations of other objects, so you can compare objects mathematically. A famous example to show how embeddings capture semantic meaning and relationships between each other is:

`embedding (king) - embedding (man) + embedding (woman) = embedding (queen)`

Embeddings are compared to one another by using the notions of similarity and distance. The following diagram illustrates how embeddings can be compared.

:::image type="complex" source="./_images/embedding-similarity.svg" lightbox="./_images/embedding-similarity.svg" alt-text="Diagram showing how vectors are compared." border="false":::
   Diagram that shows a two-dimensional grid. The sentences "The cat is on the mat" and "The cat is sitting on the mat" are in boxes in the upper right hand quadrant of the grid, close to one another. There are two vectors that are pointing at each box. The angle between the vectors is small. There's a box in the lower right quadrant with the text "It is currently sunny in Phoenix" with a vector pointing at that box. The angle between that vector and the vector for "The cat is sitting on the mat" is large.
:::image-end:::

In a Retrieval-Augmented Generation (RAG) solution, you often embed the user query by using the same embedding model as your chunks and search for relevant vectors from your database to return the most semantically relevant chunks. The original text of the relevant chunks is then passed to the language model as grounding data.

> [!NOTE]
> This feature of vectors stresses the importance of cleaning the chunks so mathematical proximity can be tracked more closely with semantic relevancy.

## Importance of the embedding model

The embedding model you choose can have a significant effect on relevancy of your vector search results. One of the key factors you must consider when choosing an embedding model is the vocabulary of the model. Every embedding model is trained with a specific vocabulary. For example, the vocabulary size of [BERT](https://huggingface.co/docs/transformers/en/model_doc/bert) is around 30,000 words.

The vocabulary of an embedding model is important because of how embedding models treat words that aren't in their vocabulary. Even though the word isn't in its vocabulary, the model still needs to calculate a vector for it. To do this, many models break down the words into subwords, which they treat as distinct tokens or they aggregate the vectors for the subwords to create a single embedding.

:::image type="content" source="./_images/word-broken-into-subwords.png" lightbox="./_images/word-broken-into-subwords.png" alt-text="Diagram that shows the word histogram being broken down into the following subwords: his, ta, and mine." border="false":::

Let's take a fictitious example where the word "histamine" isn't in the embedding model vocabulary. "Histamine" has a semantic meaning as a chemical your body releases, which causes many symptoms of allergies. Because the embedding model doesn't contain "histamine", it might break it down into subwords that are in its vocabulary such as "his", "ta", and "mine". The semantic meanings of these subwords are nowhere close to the meaning of "histamine". The individual or aggregated vector values of the subwords produce worse vector matches than if "histamine" were in the model's vocabulary.

## Choose an embedding model

Determining the right embedding model for your use case is a human activity. The overlap with the embedding model's vocabulary with your data's words should be a key factor you consider when choosing your embedding model.

:::image type="complex" source="./_images/choose-an-embedding-model.png" lightbox="./_images/choose-an-embedding-model.png" alt-text="Diagram the flow of choosing an embedding model." border="false":::
   Diagram that shows a flow for choosing an embedding model. The first decision is "Domain-specific?". If no, the flow terminates at "Test top ranked general models." If yes, the next decision is "Domain model available?". If no, the flow terminates at "Fine tune general model." If yes, the flow terminates at "Test domain model".
:::image-end:::

The first thing you should determine is whether your content is domain-specific. For example, are your documents specific to a use case, your organization, or an industry? A good way to determine domain specificity is to see whether the entities and keywords in your content is generally available or findable on the internet. If they are, it's likely that a general embedding model does.

### General or non-domain-specific content

When you choose a general embedding model, a good place to start is the [Hugging Face leaderboard](https://huggingface.co/spaces/mteb/leaderboard). This site provides an up-to-date ranking of embedding models. Evaluate how the models work with your data, starting with the top-ranking models.

### Domain-specific content

For content that is domain-specific, the first step is to determine whether there's a domain-specific model available that you can use. Imagine, for example, that your data is in the biomedical domain. You should consider using the [BioGPT model](https://github.com/microsoft/BioGPT), which is a language model that was pretrained on a large corpus of biomedical literature. This model is intended for biomedical text mining and generation. If domain models are available, start by evaluating how these models work with your data.

If there are no domain-specific models available, or the domain-specific models don't perform well, the next option is to fine-tune a general embedding model with your domain-specific vocabulary.

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
