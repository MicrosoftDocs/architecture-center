Natural language processing (NLP) is used for tasks such as sentiment analysis, topic detection, language detection, key phrase extraction, and document categorization.

You can use NLP to classify documents. For instance, you can label documents as sensitive or spam. You can use NLP output for subsequent processing or for searches. Another use for NLP is to summarize text by identifying the entities that are present in the document. These entities can also be used to tag documents with keywords. Tagging makes search and retrieval that's based on content possible. You might combine entities into topics and include summaries that describe the important topics that are present in each document. You might use the detected topics to categorize the documents for navigation, or to enumerate related documents given a selected topic. Another use for NLP is to score text for sentiment. This capability provides a way to assess the positive or negative tone of a document.

Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big-data analytic applications. Apache Spark in [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/), [Azure HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/spark/apache-spark-overview), and [Azure Databricks](https://docs.microsoft.com/en-us/azure/databricks/scenarios/what-is-azure-databricks) offer Spark access that uses its processing power.

For customized NLP workloads, Spark NLP serves as an efficient framework for processing a large amount of text. 

Spark NLP provides Python, Java, and Scala libraries with the full functionality of traditional NLP libraries, such as spaCy, nltk, Stanford CoreNLP and Open NLP. Spark NLP also adds functionality such as spell checking, sentiment analysis, and document classification. It improves on previous versions by providing state-of-the-art accuracy, speed, and scalability.

## Potential use cases

Business scenarios that can benefit from custom NLP include:

- Document intelligence for handwritten or machine-created documents in finance, healthcare, retail, government, and other sectors.

- Industry-agnostic NLP tasks for text processing, such as name entity recognition (NER), classification, summarization, and relation extraction. These processes retrieve information from documents and help to automate, analyze, and understand textual structures and unstructured data better. Examples include risk stratification models, ontology classification, and retail summarizations.

- Information retrieval and knowledge graph creation for semantic search enables medical knowledge graphs serving drug discovery and clinical trials.

- Translation of text for conversational AI systems in customer-facing applications across retail, finance, travel, and more.

:::image type="content" source="./images/natural-language-processing-functionality.png" alt-text="." border="false":::

Spark NLP is a fast open-source NLP library, with recent public benchmarks showing it to be 38x and 80x faster than spaCy with comparable accuracy for training custom models. Spark NLP is also the only open-source library which can leverage a distributed Spark cluster, since it is a native extension of Spark ML and operates directly on data frames. Therefore, speedups on a cluster result in another order of magnitude of performance gain. Since every Spark NLP pipeline is a Spark ML pipeline, it is particularly well-suited to building unified NLP & ML pipelines such as document classification, risk prediction, and recommenders.

In addition to performance, Spark NLP also delivers state-of-the-art accuracy for a growing number of NLP tasks. The team regularly reads the latest academic papers in this area and implements new state-of-the-art models. In the past 2-3 years, the best performing models use deep learning, and as such the library comes with prebuilt deep learning models for named entity recognition, document classification, sentiment and emotion detection, and sentence detection. The library also includes dozens of pre-trained language models including support for word, chunk, sentence, and document embeddings.

The library has optimized builds for CPUs, GPUS, and the latest Intel Xeon chips. Both training and inference can scale to leverage Spark clusters and run in production in all popular analytics platforms.

The NLP Server is available in the Azure Marketplace to get started exploring the full end-to-end NLP experience for [Large Scale Custom Natural Language Processing in Azure](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/johnsnowlabsinc1646051154808.nlp_server?ocid=GTMRewards_WhatsNewBlog_nlp_server_040622).

## Challenges

- Processing a collection of free-form text documents is typically computationally resource intensive, as well as being time intensive. Often such processes involve GPU compute deployment.
- Without a standardized document format, it can be difficult to achieve consistently accurate results using free-form text processing to extract specific facts from a document. For example, think of a text representation of an invoice&mdash;it can be difficult to build a process that correctly extracts the invoice number and invoice date for invoices across any number of vendors.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want to use prebuilt/pretrained models? If yes, consider using the APIs offered by Microsoft Cognitive Services or download through Spark NLP your model of choice

- Do you need to train custom models against a large corpus of text data? If yes, consider using Azure Databricks, Azure Synapse Analytics or Azure HDInsight with Spark NLP.

- Do you need low-level NLP capabilities like tokenization, stemming, lemmatization, and term frequency/inverse document frequency (TF/IDF)? If yes, consider using Azure Databricks, Azure Synapse Analytics or Azure HDInsight with Spark NLP or an OSS library in your processing tool of choice.

- Do you need simple, high-level NLP capabilities like entity and intent identification, topic detection, spell check, or sentiment analysis? If yes, consider using the APIs offered by Microsoft Cognitive Services or download through Spark NLP your model of choice.

## Capability matrix

The following tables summarize the key differences in general capabilities.

### General capabilities

| Capability | Spark Service (Azure Databricks, Azure Synapse Analytics, Azure HDInsight) with Spark NLP | Microsoft Cognitive Services |
| --- | --- | --- |
| Provides pretrained models as a service | Yes | Yes |
| REST API | Yes | Yes |
| Programmability | Python, Scala | For supported languages, see [Additional Resources](https://docs.microsoft.com/en-us/azure/cognitive-services/#additional-resources) |
| Support processing of big data sets and large documents | Yes | No |

### Low-level natural language processing capabilities

| Capability of Annotators | Spark Service (Azure Databricks, Azure Synapse Analytics, Azure HDInsight) with Spark NLP | Microsoft Cognitive Services |
| --- | --- | --- |
| Sentence detector | Yes | No |
| Deep sentence detector | Yes | Yes |
| Tokenizer | Yes | Yes |
| N-gram generator | Yes | No |
| Word segmentation | Yes | Yes |
| Stemmer | Yes | No |
| Lemmatizer | Yes | No |
| Part of speech tagging | Yes | No |
| Dependency Parser | Yes | No |
| Translation | Yes | No |
| Stopword Cleaner | Yes | No |
| Spell Correction | Yes | No |
| Normalizer | Yes | Yes |
| Text Matcher | Yes | No |
| Term frequency/inverse-document frequency (TF/IDF) | Yes | No |
| Regex Matcher | Yes | No* |
| Date Matcher | Yes | No** |
| Chunker | Yes | No |

* This is a capability that is embedded in the Language Understanding Service (LUIS), which is on track to be deprecated and replaced with the Conversational Language Understanding (CLU) which doesn’t support the applicable capability

** Date matching is possible in both LUIS and CLU through the DateTime recognizers


### High-level natural language processing capabilities

| Spell Checking | Yes | No |
| Summarization | Yes | Yes |
| Question/Answering | Yes | Yes |
| Sentiment/Emotion Detection | Yes | Yes/No (Also includes opinion mining) |
| Token Classification | Yes | Yes/No (Also includes opinion mining) |
| Text Classification | Yes | Yes/No (Also includes opinion mining) |
| Text Representation | Yes | No |
| Name Entity Extraction (NER) | Yes | Yes (Text Analytics provides a set of NER, and custom models would be in Entity Recognition) |
| Entity Recognition | Yes | Yes (Through custom models) |
| Language detection | Yes | Yes |
| Supports multiple languages besides English | Yes (supports 200+ languages) | Yes (supports 97+ languages) |



## Set-up of Spark NLP in Azure

For Spark NLP installation please see the Spark NLP Documentation or use the following by replacing version with the latest version number:

```bash

# Install Spark NLP from PyPI
pip install spark-nlp==[version]

# Install Spark NLP from Anacodna/Conda
conda install -c johnsnowlabs spark-nlp

# Load Spark NLP with Spark Shell
spark-shell --packages com.johnsnowlabs.nlp:spark-nlp_ [version]

# Load Spark NLP with PySpark
pyspark --packages com.johnsnowlabs.nlp:spark-nlp_ [version]

# Load Spark NLP with Spark Submit
spark-submit --packages com.johnsnowlabs.nlp:spark-nlp_ [version]

# Load Spark NLP as external JAR after compiling and building Spark NLP by `sbt assembly`
spark-shell --jars spark-nlp-assembly-3 [version].jar
```

For NLP pipeline development, Spark NLP follows by execution order the same development concept as classical Machine Learning models developed with SparkMML only applying NLP techniques. The following components core to an Spark NLP pipeline:

:::image type="content" source="./images/spark-natural-language-processing-pipeline.png" alt-text="." border="false":::

- **DocumentAssembler**: Prepares data into a format that is processable by Spark NLP. This is the entry point for every Spark NLP pipeline. The DocumentAssembler can read either a String column or an Array[String]. Additionally, setCleanupMode can be used to pre-process the text (Default: disabled).

- **SentenceDetector**: Annotator that detects sentence boundaries using any provided approach. Each extracted sentence can be returned in an Array or exploded to separate rows, if explodeSentences is set to true.

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

- [Choose a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)
- [Compare the machine learning products and technologies from Microsoft](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning)
- [Azure Machine Learning decision guide for optimal tool selection](/azure/architecture/example-scenario/mlops/aml-decision-tree)
- [MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow?toc=%2Fazure%2Farchitecture%2Ftoc.json&bc=%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
