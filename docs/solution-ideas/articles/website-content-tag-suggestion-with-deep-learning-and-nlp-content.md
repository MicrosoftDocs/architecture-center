[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Social sites, forums, and other text-heavy Q&A services rely heavily on content tagging, which enables good indexing and user search. Often, however, content tagging is left to users' discretion. Because users do not have lists of commonly searched terms or a deep understanding of the site structure, they frequently mislabel content. Mislabeled content is difficult or impossible to find when it is needed later.

## Potential use cases

Using Natural language processing (NLP) with Deep Learning for content tagging enables a scalable solution creating tags across content. As users search for content by keywords, this multi-class classification process enriches untagged content with labels that will allow searching on substantial portions of text improving the information retrieval processes. New incoming content will be appropriately tagged running NLP inference.

## Architecture

![Architecture diagram: overview of using Azure Machine Learning to help suggest content tags for websites.](../media/website-content-tag-suggestion-with-deep-learning-and-nlp.png)

*Download an [SVG](../media/website-content-tag-suggestion-with-deep-learning-and-nlp.svg) of this architecture.*

### Workflow

1. Data is stored in various formats depending on its original source. Data can be stored as files within Azure Data Lake Storage or in tabular form in Azure Synapse or Azure SQL Database. 

2. Azure Machine Learning can connect and read from such sources to ingest the data into the NLP pipeline for pre-processing, model training, and post-processing. 

3. NLP pre-processing includes several steps to consume data with the purpose of text generalization. Once the text is broken up into sentences, NLP techniques such as lemmatization or stemming allow language to be tokenized in a general form. 

4. As NLP models are already available pre-trained, the transfer learning approach recommends downloading language specific embeddings and using an industry standard model for multi-class text classification such as variations of [BERT](https://arxiv.org/abs/1810.04805). 

5. NLP post-processing recommends storing the model in a model register in AML to track model metrics. Furthermore, text can be post-processed with specific business rules that are deterministically defined based on the business goals. Microsoft recommends using ethical AI tools to detect biased language ensuring fair training of language model. 

6. The model can be deployed through Azure Kubernetes Service running a Kubernetes-managed cluster while containers are deployed from images stored in Azure Container Registry. Endpoints can be made available to a front-end application. The model can be deployed through Azure Kubernetes Service as real-time endpoints 

7. Model results can be written to a storage option in file or tabular format, then properly indexed by Azure Cognitive Search. The model would run as batch inference and store results in the respective datastore. 

### Components

* [Data Lake Storage for Big Data Analytics](https://azure.microsoft.com/en-us/services/storage/data-lake-storage/)
* [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/)
* [Azure Cognitive Search](https://azure.microsoft.com/en-us/services/search/)
* [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/)

## Next steps

See product documentation:

* [Azure Data Lake Storage Gen2 Introduction](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction/)
* [Azure Machine Learning](/azure/machine-learning)
* [Azure Cognitive Search documentation](https://docs.microsoft.com/en-us/azure/search/)
* [Learn more about Azure Container Registry](/azure/container-registry/container-registry-intro)
* [Azure Kubernetes Service](/azure/aks/intro-kubernetes)

Try these Microsoft Learn modules:

* [Introduction to Natural Language Processing with PyTorch](/learn/modules/intro-natural-language-processing-pytorch/)
* [Train and evaluate deep learning models](/learn/modules/train-evaluate-deep-learn-models/)
* [Natural language processing technology](https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing)
* [Implement knowledge mining with Azure Cognitive Search](/learn/paths/implement-knowledge-mining-azure-cognitive-search/)
