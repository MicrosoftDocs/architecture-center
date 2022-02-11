Natural language processing (NLP) is used for tasks such as sentiment analysis, topic detection, language detection, key phrase extraction, and document categorization.

![Diagram of a natural language processing pipeline](../images/nlp-pipeline.png)

NLP can be use to classify documents, such as labeling documents as sensitive or spam. The output of NLP can be used for subsequent processing or search. Another use for NLP is to summarize text by identifying the entities present in the document. These entities can also be used to tag documents with keywords, which enables search and retrieval based on content. Entities might be combined into topics, with summaries that describe the important topics present in each document. The detected topics may be used to categorize the documents for navigation, or to enumerate related documents given a selected topic. Another use for NLP is to score text for sentiment, to assess the positive or negative tone of a document. These approaches use many techniques from natural language processing, such as:

- **Tokenizer**. Splitting the text into words or phrases.
- **Stemming and lemmatization**. Normalizing words so that different forms map to the canonical word with the same meaning. For example, "running" and "ran" map to "run."
- **Entity extraction**. Identifying subjects in the text.
- **Part of speech detection**. Identifying text as a verb, noun, participle, verb phrase, and so on.
- **Sentence boundary detection**. Detecting complete sentences within paragraphs of text.

When using NLP to extract information and insight from free-form text, the starting point is typically the raw documents stored in object storage such as Azure Storage or Azure Data Lake Store.

## Challenges

- Processing a collection of free-form text documents is typically computationally resource intensive, as well as being time intensive.
- Without a standardized document format, it can be difficult to achieve consistently accurate results using free-form text processing to extract specific facts from a document. For example, think of a text representation of an invoice&mdash;it can be difficult to build a process that correctly extracts the invoice number and invoice date for invoices across any number of vendors.

## What are your options when choosing an NLP service?

In Azure, the following services provide natural language processing (NLP) capabilities:

- [Azure HDInsight with Spark and Spark MLlib](/azure/hdinsight/spark/apache-spark-overview)
- [Azure Databricks](/azure/azure-databricks/what-is-azure-databricks)
- [Microsoft Cognitive Services](/azure/cognitive-services/welcome)

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want to use prebuilt models? If yes, consider using the APIs offered by Microsoft Cognitive Services.

- Do you need to train custom models against a large corpus of text data? If yes, consider using Azure HDInsight with Spark MLlib and Spark NLP.

- Do you need low-level NLP capabilities like tokenization, stemming, lemmatization, and term frequency/inverse document frequency (TF/IDF)? If yes, consider using Azure HDInsight with Spark MLlib and Spark NLP.

- Do you need simple, high-level NLP capabilities like entity and intent identification, topic detection, spell check, or sentiment analysis? If yes, consider using the APIs offered by Microsoft Cognitive Services.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Azure HDInsight | Microsoft Cognitive Services |
| --- | --- | --- |
| Provides pretrained models as a service | No | Yes |
| REST API | Yes | Yes |
| Programmability | Python, Scala, Java | C#, Java, Node.js, Python, PHP, Ruby |
| Support processing of big data sets and large documents | Yes | No |

### Low-level natural language processing capabilities

| Capability | Azure HDInsight | Microsoft Cognitive Services |
| --- | --- | --- |
| Tokenizer | Yes (Spark NLP) | Yes (Linguistic Analysis API) |
| Stemmer | Yes (Spark NLP) | No |
| Lemmatizer | Yes (Spark NLP) | No |
| Part of speech tagging | Yes (Spark NLP) | Yes (Linguistic Analysis API) |
| Term frequency/inverse-document frequency (TF/IDF) | Yes (Spark MLlib) | No |
| String similarity&mdash;edit distance calculation | Yes (Spark MLlib) | No |
| N-gram calculation | Yes (Spark MLlib) | No |
| Stop word removal | Yes (Spark MLlib) | No |

### High-level natural language processing capabilities

| Capability | Azure HDInsight | Microsoft Cognitive Services |
| --- | --- | --- |
| Entity/intent identification and extraction | No | Yes (Language Understanding Intelligent Service (LUIS) API) |
| Topic detection | Yes (Spark NLP) | Yes (Text Analytics API) |
| Spell checking | Yes (Spark NLP) | Yes (Bing Spell Check API) |
| Sentiment analysis | Yes (Spark NLP) | Yes (Text Analytics API) |
| Language detection | No | Yes (Text Analytics API) |
| Supports multiple languages besides English | No | Yes (varies by API) |

## See also

[Natural language processing](../technology-choices/natural-language-processing.yml)
