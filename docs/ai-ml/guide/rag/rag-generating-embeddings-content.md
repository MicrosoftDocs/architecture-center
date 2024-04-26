An embedding is a vector representation of an object, such as text. Embeddings are used to mathematically compare the semantic similarity of two objects. Since embedding vectors are a mathematical representation of objects, texts that are similar to one another have embedding vector representations similar to one another. The distance between two embedding vectors in high dimensional space determines how similar the text they represent are. In a RAG solution, you might embed the user query and search a vector database containing embeddings for text like chunks to return the most semantically relevant chunks. Those relevant chunks are then passed to the large language model as grounding data.

> [!NOTE]
> This feature of vectors stresses the importance of cleaning the chunks so mathematical proximity can be tracked more closely with semantic relevancy.

## Importance of the embedding model

The embedding model you choose can have a significant effect on relevancy of your vector search results. One of the key factors you must consider when choosing an embedding model is the vocabulary of the model. Every embedding model is trained with a specific vocabulary. For example, the vocabulary size of [BERT](https://huggingface.co/docs/transformers/en/model_doc/bert) is around 30,000.

The vocabulary of an embedding model is important because of how embedding models treat words that aren't in their vocabulary. Even though the word isn't in its vocabulary, the model still needs to calculate a vector for it. To do this, many models break down the words into subwords, which they treat as distinct tokens or they aggregate the vectors for the subwords to create a single embedding.

:::image type="complex" source="./_images/word-broken-into-subwords.png" lightbox="./_images/word-broken-into-subwords.png" alt-text="Diagram showing the word histogram being broken down into the following subwords: his, ta, and mine" border="false":::
   Diagram showing the word histogram being broken down into the following subwords: his, ta, and mine
:::image-end:::
*Figure 1. Breaking down an unknown word into subwords*

Let's take a fictitious example where the word "histamine" isn't in the embedding model vocabulary. "Histamine" has a semantic meaning as a chemical your body releases, which causes many symptoms of allergies. Because the embedding model doesn't contain "histamine", it might break it down into subwords that are in its vocabulary such as "his", "ta", and "mine". The semantic meanings of these subwords are nowhere close to the meaning of "histamine". The individual or aggregated vector values of the subwords produce worse vector matches than if "histamine" were in the model's vocabulary.

## Choosing an embedding model

Determining the right embedding model for your use case is a human activity. Embedding model vocabulary should be a key factor you consider when choosing your embedding model.

:::image type="complex" source="./_images/choose-an-embedding-model.png" lightbox="./_images/choose-an-embedding-model.png" alt-text="Diagram the flow of choosing an embedding model." border="false":::
   Diagram showing a flow for choosing an embedding model. The first decision is "Domain specific?". If no, the flow terminates at "Test top ranked general models." If yes, the next decision is "Domain model available?". If no, the flow terminates at "Fine tune general model." If yes, the flow terminates at "Test domain model".
:::image-end:::
*Figure 2. Choosing an embedding model flow*

The first thing you should determine is whether your content is domain specific. For example, are your documents specific to a use case, your organization, or an industry? . A good way to determine domain specificity is to see if the entities and keywords in your content is generally available or findable on the internet. If they are, it's likely that a general embedding model does.

### General or non domain specific content

When you're choosing a general embedding model, a good place to start is the [Hugging Face leaderboard](https://huggingface.co/spaces/mteb/leaderboard). This site provides an up-to-date ranking of embedding models. Evaluate how the models work with your data, starting with the top-ranking models.

### Domain specific content

For content that is domain specific, the first step is to determine if there's a domain specific model available that you can use. Imagine, for example, that your data is in the biomedical domain. You consider consider using the [BioGPT model](https://github.com/microsoft/BioGPT), which is a language model that was pretrained on a large corpus of biomedical literature. This model is specifically intended for biomedical text mining and generation. If domain models are available, start by evaluating how these models work with your data.

If there are no domain specific models available, or the domain specific models don't perform well, the next option is to fine-tune a general embedding model with your domain-specific vocabulary.

> [!IMPORTANT]
> For any model you choose, you need to verify that the license is suitable for your needs and the model provides the necessary language support.

### Evaluate embedding models

Two effective means of evaluating an embedding model are visualizing the embeddings and evaluating the distance between question and chunk vectors.

#### Visualizing embeddings

You can use libraries such as t-SNE to plot the vectors for your chunks and your question on an X-Y graph. You can then determine how far apart the chunks are from one another and the question. The figure shows chunk vectors plotted. The two arrows near one another represent two chunks vectors while the other arrow represents a question vector. You can use this visualization to understand how far the question is from the chunks.

:::image type="complex" source="./_images/visualize-embeddings.png" lightbox="./_images/visualize-embeddings.png" alt-text="Visualization of an embedding. The image shows a bunch of blue dots plotted on an X-Y scale." border="false":::
   Visualization of an embedding. The image shows a bunch of blue dots plotted on an X-Y scale. It also shows two arrows pointing to plot points near one another and another arrow showing a plot point far away from the other two.
:::image-end:::
*Figure 3. Plotting embeddings*

TODO: Can someone put together a real example with TSNE that we can use to replace this image?

#### Calculating embedding distances

A programmatic means of evaluating how well your embedding model is working with your questions and chunks is to calculate the distance between the question vectors and the chunk vectors. You can use the Euclidean distance or the Manhattan distance.

## Contributors

* [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/)
* [Rob Bagby](https://www.linkedin.com/in/robbagby/)
* [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/)
* [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/)
* [Randy Thurman](https://www.linkedin.com/in/randy-thurman-2917549/)
* [Prabal Deb](https://www.linkedin.com/in/prabaldeb/)

## Next steps

> [!div class="nextstepaction"]
> [Information retrieval phase](./rag-information-retrieval.yml)

## Related resources
