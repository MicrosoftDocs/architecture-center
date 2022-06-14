Natural language processing (NLP) has many uses: sentiment analysis, topic detection, language detection, key phrase extraction, and document categorization.

Specifically, you can use NLP to:

- Classify documents. For instance, you can label documents as sensitive or spam.
- Do subsequent processing or searches. You can use NLP output for these purposes.
- Summarize text by identifying the entities that are present in the document.
- Tag documents with keywords. For the keywords, you can use the entities that NLP identifies.
- Do content-based search and retrieval. The tagging keywords make this functionality possible.
- Summarize a document's important topics. NLP can combine the entities that it identifies into topics.
- Categorize documents for navigation. The topics that NLP detects are used for this purpose.
- Enumerate related documents based on a selected topic. The topics that NLP detects are used for this purpose.
- Score text for sentiment. By using this functionality, you can assess the positive or negative tone of a document.

## Potential use cases

Business scenarios that can benefit from custom NLP include:

- Document intelligence for handwritten or machine-created documents in finance, healthcare, retail, government, and other sectors.
- Industry-agnostic NLP tasks for text processing, such as name entity recognition (NER), classification, summarization, and relation extraction. These tasks automate the process of retrieving, identifying, and analyzing document information like text and unstructured data. Examples of these tasks include risk stratification models, ontology classification, and retail summarizations.
- Information retrieval and knowledge graph creation for semantic search. This functionality makes it possible to create medical knowledge graphs that support drug discovery and clinical trials.
- Text translation for conversational AI systems in customer-facing applications across retail, finance, travel, and other industries.

## Apache Spark as a customized NLP framework

Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big-data analytic applications. [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/), [Azure HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/spark/apache-spark-overview), and [Azure Databricks](https://docs.microsoft.com/en-us/azure/databricks/scenarios/what-is-azure-databricks) offer access to Spark and take advantage of its processing power.

For customized NLP workloads, Spark NLP serves as an efficient framework for processing a large amount of text. This open-source NLP library provides Python, Java, and Scala libraries that offer the full functionality of traditional NLP libraries such as spaCy, NLTK, Stanford CoreNLP, and Open NLP. Spark NLP also adds functionality such as spell checking, sentiment analysis, and document classification. It improves on previous versions by providing state-of-the-art accuracy, speed, and scalability.

:::image type="content" source="./images/natural-language-processing-functionality.png" alt-text="." border="false":::

Recent public benchmarks show Spark NLP as 38 and 80 times faster than spaCy, with comparable accuracy for training custom models. Spark NLP is the only open-source library that can use a distributed Spark cluster. Spark NLP is a native extension of Spark ML that operates directly on data frames. As a result, speedups on a cluster result in another order of magnitude of performance gain. Because every Spark NLP pipeline is a Spark ML pipeline, Spark NLP is particularly well-suited for building unified NLP and machine learning pipelines such as document classification, risk prediction, and recommender pipelines.

Besides excellent performance, Spark NLP also delivers state-of-the-art accuracy for a growing number of NLP tasks. The Spark NLP team regularly reads the latest relevant academic papers and implements state-of-the-art models. In the past two to three years, the best performing models have used deep learning. The library comes with prebuilt deep learning models for named entity recognition, document classification, sentiment and emotion detection, and sentence detection. The library also includes dozens of pre-trained language models that include support for word, chunk, sentence, and document embeddings.

The library has optimized builds for CPUs, GPUS, and the latest Intel Xeon chips. You can scale training and inference processes to take advantage of Spark clusters and run in production in all popular analytics platforms.

The NLP Server is available in the Azure Marketplace. To explore large-scale custom NLP in Azure, see [NLP Server](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/johnsnowlabsinc1646051154808.nlp_server?ocid=GTMRewards_WhatsNewBlog_nlp_server_040622).

## Challenges

- Processing a collection of free-form text documents requires a significant amount of computational resources. The processing is also time intensive. Such processes often involve GPU compute deployment.
- Without a standardized document format, it can be difficult to achieve consistently accurate results when you use free-form text processing to extract specific facts from a document. For example, think of a text representation of an invoice&mdash;it can be difficult to build a process that correctly extracts the invoice number and date when invoices are from various vendors.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want to use prebuilt or pretrained models? If yes, consider using the APIs that Microsoft Cognitive Services offers. Or download your model of choice through Spark NLP.

- Do you need to train custom models against a large corpus of text data? If yes, consider using Azure Databricks, Azure Synapse Analytics or Azure HDInsight with Spark NLP.

- Do you need low-level NLP capabilities like tokenization, stemming, lemmatization, and term frequency/inverse document frequency (TF/IDF)? If yes, consider using Azure Databricks, Azure Synapse Analytics or Azure HDInsight with Spark NLP or an open-source software library in your processing tool of choice.

- Do you need simple, high-level NLP capabilities like entity and intent identification, topic detection, spell check, or sentiment analysis? If yes, consider using the APIs that Microsoft Cognitive Services offers. Or download your model of choice through Spark NLP.

## Capability matrix

The following tables summarize the key differences in the capabilities of NLP services.

### General capabilities

| Capability | Spark service (Azure Databricks, Azure Synapse Analytics, Azure HDInsight) with Spark NLP | Microsoft Cognitive Services |
| --- | --- | --- |
| Provides pretrained models as a service | Yes | Yes |
| REST API | Yes | Yes |
| Programmability | Python, Scala | For supported languages, see [Additional Resources](https://docs.microsoft.com/en-us/azure/cognitive-services/#additional-resources) |
| Support processing of big data sets and large documents | Yes | No |

### Low-level natural language processing capabilities

| Capability of annotators | Spark service (Azure Databricks, Azure Synapse Analytics, Azure HDInsight) with Spark NLP | Microsoft Cognitive Services |
| --- | --- | --- |
| Sentence detector | Yes | No |
| Deep sentence detector | Yes | Yes |
| Tokenizer | Yes | Yes |
| N-gram generator | Yes | No |
| Word segmentation | Yes | Yes |
| Stemmer | Yes | No |
| Lemmatizer | Yes | No |
| Part-of-speech tagging | Yes | No |
| Dependency parser | Yes | No |
| Translation | Yes | No |
| Stopword cleaner | Yes | No |
| Spell correction | Yes | No |
| Normalizer | Yes | Yes |
| Text matcher | Yes | No |
| TF/IDF | Yes | No |
| Regular expression matcher | Yes | Embedded in Language Understanding Service (LUIS). Not supported in Conversational Language Understanding (CLU), which is replacing LUIS. |
| Date matcher | Yes | Possible in LUIS and CLU through DateTime recognizers |
| Chunker | Yes | No |

### High-level natural language processing capabilities

| Capability | Spark service (Azure Databricks, Azure Synapse Analytics, Azure HDInsight) with Spark NLP | Microsoft Cognitive Services |
| --- | --- | --- |
| Spell checking | Yes | No |
| Summarization | Yes | Yes |
| Question answering | Yes | Yes |
| Sentiment and emotion detection | Yes | Yes/No (Also includes opinion mining) Supports sentiment detection and opinion mining |
| Token classification | Yes | Yes/No (Also includes opinion mining) |
| Text classification | Yes | Yes/No (Also includes opinion mining) |
| Text representation | Yes | No |
| NER | Yes | Yes, text analytics provides a set of NER, and custom models are in entity recognition |
| Entity Recognition | Yes | Yes, through custom models |
| Language detection | Yes | Yes |
| Supports multiple languages besides English | Yes, supports over 200 languages | Yes, supports over 97 languages |

## Set up Spark NLP in Azure

To install Spark NLP, use the following code, but replace `<version>` with the latest version number. For more information, see the [Spark NLP documentation](https://nlp.johnsnowlabs.com/docs/en/quickstart).

```bash
# Install Spark NLP from PyPI.
pip install spark-nlp==<version>

# Install Spark NLP from Anacodna or Conda.
conda install -c johnsnowlabs spark-nlp

# Load Spark NLP with Spark Shell.
spark-shell --packages com.johnsnowlabs.nlp:spark-nlp_<version>

# Load Spark NLP with PySpark.
pyspark --packages com.johnsnowlabs.nlp:spark-nlp_<version>

# Load Spark NLP with Spark Submit.
spark-submit --packages com.johnsnowlabs.nlp:spark-nlp_<version>

# Load Spark NLP as an external JAR after compiling and building Spark NLP by using sbt assembly.
spark-shell --jars spark-nlp-assembly-3 <version>.jar
```

## Develop NLP pipelines

For the execution order of an NLP pipeline, Spark NLP follows the same development concept as SparkMML classical machine learning models. But Spark NLP applies NLP techniques. The core components of a Spark NLP pipeline are:

:::image type="content" source="./images/spark-natural-language-processing-pipeline.png" alt-text="." border="false":::

- **DocumentAssembler**: A transformer that prepares data by changing it into a format that Spark NLP can process. This step is the entry point for every Spark NLP pipeline. The DocumentAssembler can read either a `String` column or an `Array[String]`. You can use `setCleanupMode` to preprocess the text. By default, this mode is turned off.

- **SentenceDetector**: An annotator that detects sentence boundaries by using the approach that it's given. This annotator can return each extracted sentence in an `Array`. It can also return each sentence in a different row, if you set `explodeSentences` to true.

- **Tokenizer**: Tokenizes raw text in document type columns into TokenizedSentence. This class represents a non-fitted tokenizer. Fitting it will cause the internal RuleFactory to construct the rules for tokenizing from the input configuration. The Tokenizer identifies tokens with tokenization open standards. A few rules will help customizing it if defaults do not fit user needs.

- **Normalizer**: Annotator that cleans out tokens. It requires stems, hence tokens and removes all dirty characters from text following a regex pattern and transforms words based on a provided dictionary

- **WordEmbeddings**: Word Embeddings are lookup annotators that map tokens to vectors. A custom token lookup dictionary for embeddings can be set with setStoragePath. Each line of the provided file needs to have a token, followed by their vector representation, delimited by spaces. If a token is not found in the dictionary, then the result will be a zero vector of the same dimension.

For more information about your NLP pipeline see: [NLP Pipeline](https://nlp.johnsnowlabs.com/docs/en/pipelines).

See here for available [Annotators](https://nlp.johnsnowlabs.com/docs/en/annotators#available-annotators).

See here for available [Transformers](https://nlp.johnsnowlabs.com/docs/en/annotators#available-transformers).

For solutioning capabilities please see Large Scale Custom Natural Language Processing in Azure in the Azure Architecture Center.

Spark NLP uses Spark MLlib Pipelines, what are natively supported by MLFlow. MLFlow is, as stated in their [official webpage](https://mlflow.org/), an open source platform for the machine learning lifecycle, that includes:

- Mlflow Tracking: Record and query experiments: code, data, config, and results
- MLflow Projects: Package data science code in a format to reproduce runs on any platform
- MLflow Models: Deploy machine learning models in diverse serving environments
- Model Registry: Store, annotate, discover, and manage models in a central repository

MLFlow is also integrated in Databricks or can be installed on any other Spark-based environment to track your experiments accordingly and even use MLFLow Model Registry to serve models for production purposes.

## Next steps

- [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/)
- [Azure HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/spark/apache-spark-overview)
- [Azure Databricks](https://docs.microsoft.com/en-us/azure/databricks/scenarios/what-is-azure-databricks)
- [Cognitive Services](https://docs.microsoft.com/en-us/azure/cognitive-services/what-are-cognitive-services)
- [Microsoft Azure AI Fundamentals: Explore natural language processing](https://docs.microsoft.com/en-us/learn/paths/explore-natural-language-processing/)
- [Create a Language Understanding solution](https://docs.microsoft.com/en-us/learn/paths/create-language-understanding-solution/)
- Spark NLP resources:

  - [Spark NLP](https://nlp.johnsnowlabs.com/)
  - [Spark NLP Documentation](https://nlp.johnsnowlabs.com/docs/en/quickstart)
  - [Spark NLP Github](https://github.com/JohnSnowLabs/spark-nlp)
  - [Spark NLP Demo](https://github.com/JohnSnowLabs/spark-nlp-workshop)

## Related resources

- [Choose a Microsoft cognitive services technology](./cognitive-services.md)
- [Compare the machine learning products and technologies from Microsoft](./data-science-and-machine-learning.md)
- [Azure Machine Learning decision guide for optimal tool selection](../../example-scenario/mlops/aml-decision-tree.yml)
- [MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow?toc=%2Fazure%2Farchitecture%2Ftoc.json&bc=%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [AI enrichment with image and natural language processing in Azure Cognitive Search](../../solution-ideas/articles/cognitive-search-with-skillsets.yml)
- [Analyze news feeds with near real-time analytics using image and natural language processing](../../example-scenario/ai/news-feed-ingestion-and-near-real-time-analysis.yml)
- [Suggest content tags with NLP using deep learning](../../solution-ideas/articles/website-content-tag-suggestion-with-deep-learning-and-nlp.yml)
