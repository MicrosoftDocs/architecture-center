Once you've broken down your documents down into a collection of chunks, the next step is to enrich each chunk by both cleaning and augmenting the chunks with metadata. Cleaning the chunks allows you to achieve better matches for semantic queries in a vector search. Adding information allows you to support searches beyond semantic searches of the chunks. Both cleaning and augmenting involve extending the schema for the chunk.

This article discusses various ways to augment your chunks, including some common cleaning operations you can perform on chunks to improve vector comparisons, and describes some common metadata fields you can add to your chunks to augment your search index.

> This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml).

:::image type="complex" source="./_images/enriching-chunks.png" lightbox="./_images/enriching-chunks.png" alt-text="Diagram showing json records with a single field being enriched." border="false":::
   The diagram shows json with two rows. Each row has a single name-value pair called Chunk. The diagram shows how each of those rows is enriched into 2 json rows, each with six fields: Chunk, CleanedChunk, Title, Summary, Keywords and Questions, where Keywords and Questions are arrays and the other fields are name-value pairs.
:::image-end:::
*Figure 1. Enriching chunks with metadata*

## Cleaning

Chunking your data supports your workload in its efforts to find the most relevant chunks, typically through vectorizing those chunks and storing them in a vector database. An optimized vector search returns only those rows in that database which have the closest semantic matches to the query. The goal of cleaning the data to support closeness matches by eliminating potential differences that aren't material to the semantics of the text. The following are some common cleaning procedures.

> [!NOTE]
> You will want to return the original, uncleaned chunk as the query result, so you will add an additional field to store the cleaned and vectorized data.

- **Lowercasing** - Lowercasing allows words that are capitalized, such as words at the beginning of a sentence, to match with those same words within a sentence. Embeddings are typically case-sensitive meaning "Cheetah" and "cheetah" would result in a different vector for the same logical word. For example, for the embedded query: "what is faster, a cheetah or a puma?" The following embedding: "cheetahs are faster than pumas" is a closer match than embedding "Cheetahs are faster than pumas." Some lowercasing strategies lowercase all words, including proper nouns, while other strategies include just lowercasing the first words in a sentence.
- **Remove stop words** - Stop words are words such as "a", "an" and "the" that commonly occur in sentences. You can remove stop words to reduce the dimensionality of the resulting vector. Removing stop words would allow both "a cheetah is faster than a puma" and "the cheetah is faster than the puma" to both be vectorially equal to "cheetah faster puma." However, it's important to understand that some stop words hold semantic meaning. For example, "not" might be considered a stop word, but would hold significant semantic meaning. It's important to test to see the effect of removing stop words.
- **Fix spelling mistakes** - A misspelled word doesn't match with the correctly spelled word in the embedding model. For example, "cheatah" (*sic*) isn't the same as "cheetah" in the embedding. You should fix spelling mistakes to address this challenge.
- **Remove unicode characters** - Removing Unicode characters can reduce noise in your chunks and reduce dimensionality. Like stop words, some Unicode characters might contain relevant information. It's important to test to understand the impact of removing Unicode characters.
- **Normalization** - Normalizing the text to standards such as expanding abbreviations, converting numbers to words, and expanding contractions like "I'm" to "I am" can help increase the performance of vector searches.

## Augmenting chunks

Semantic searches against the vectorized chunks work well for some types of queries, but not as well for others. Depending upon the types of queries you need to support, you might need to augment your chunks with additional information. The additional metadata fields are all stored in the same row as your embeddings and can be used in the search solution as either filters or as part of the search.

:::image type="complex" source="./_images/augmented-metadata-usage-in-search.svg" lightbox="./_images/augmented-metadata-usage-in-search.png" alt-text="Diagram showing json of fully enriched content and how it might be used in a search platform." border="false":::
   The diagram shows json for one chunk with six fields: Chunk, CleanedChunk, Title, Summary, Keywords, and questions. It has the following name-value pairs: Chunk, CleanedChunk, Title, and Summary. It has the following arrays: Keywords and questions. Each field points to a column in a table that shows its data type, Usage, and Query type. The following are the values for each: Chunk (String, Return, Full text), CleanedChunk (Vector: Float, Search, Vector), Title (String, Search/Return, Full text), Summary (String, Search/Return, Full text), Keywords (Collection of strings, Search/Filter, Full text), and questions (Vector: Float, Search, Vector)
:::image-end:::
*Figure 2. Use of augmented metadata in search solution*

The metadata columns that you need to add depend on decisions specific to your problem domain. This includes the type of data you have and the types of queries you want to support. You need to analyze the user experience, available data, and result quality you're trying to achieve. From there, you can determine what metadata might help you address your workload's requirements.

The following are some common metadata fields, along with the original chunk text, some guidance about their potential uses, and tools or techniques that are commonly used to generate the metadata content.

- **ID** - ID is a key metadata field that is used to uniquely identify a chunk. A unique ID is useful in processing to determine whether a chunk already exists in the store or not. An ID can be a hash of some key field. **Tools**: Hashing library
- **Title** - A title is a useful return value for a chunk. It provides a quick summary of the content in the chunk. The summary can also be useful to query with an indexed search as it can contain keywords for matching. **Tools**: large language model
- **Summary** - The summary is similar to the title in that it's a common return value and can be used in indexed searches. Summaries are generally longer than the title. **Tools**: large language model
- **Rephrasing of chunk** - Rephrasing of a chunk can be helpful as a vector search field because rephrasing captures variations in language such as synonyms and paraphrasing. **Tools**: large language model
- **Keywords** - Keyword searches are good for data that is noncontextual, for searching for an exact match, and when a specific term or value is important. For example, an auto manufacturer might have reviews or performance data for each of their models for multiple years. Review for product X for year 2009" is semantically like "Review for product X for 2010" and "Review for product Y for 2009." In this case, you would be better off matching on keywords for the product and year. **Tools**: large language model, RAKE, KeyBERT, MultiRake
- **Entities** - Entities are specific pieces of information such as people, organizations, and locations. Like keywords, entities are good for exact match searches or when specific entities are important. **Tools**: SpaCy, Stanford Named Entity Recognizer (SNER, scikit-learn, Natural Language Toolkit (NLTK).
- **Cleaned chunk text** - The cleaned chunk text. **Tools**: large language model
- **Questions that the chunk can answer** - Sometimes, the query that is embedded and the chunk embedded isn't a great match. For example, the query might be small regarding the chunk size. It might be better to formulate the queries that the chunk can answer and do a vector search between the user's actual query and the preformulated queries. **Tools**: large language model
- **Source** - The source of the chunk can be valuable as a return for queries. It allows the querier to cite the original source.
- **Language** - The language of the chunk can be good as a filter in queries.

## Augmenting economics

The use of large language models for augmenting chunks can be expensive. You need to calculate the cost of each enrichment you're considering and multiply it by the estimated number of chunks over time. You should use this information, along with your testing of those enriched fields as part of the search to make a good business decision.

## Next steps

> [!div class="nextstepaction"]
> [Generate embeddings phase](./rag-generating-embeddings.yml)

## Related resources

- [AI enrichment in Azure AI Search](/azure/search/cognitive-search-concept-intro)
- [Skill set concepts in Azure AI Search](/azure/search/cognitive-search-working-with-skillsets)
