## Architecture

:::image type="content" source="../media/large-scale-custom-natural-language-processing-architecture.png" alt-text="Diagram that shows the flow of data through an N L P pipeline. Stages include ingesting, storing, processing, and serving." border="false":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1943666-large-scale-custom-natural-language-processing-architecture.vsdx

### Workflow

1. Azure Event Hubs, Azure Data Factory, or both services receive documents or unstructured text data.
1. Event Hubs and Data Factory store the data in file format in Azure Data Lake Storage. The directory structure in Data Lake Storage complies with business requirements.
1. The Azure Computer Vision API uses its optical character recognition (OCR) capability to consume the data. The API then writes the data to the bronze layer. This consumption platform uses a lakehouse architecture.
1. In the bronze layer, various Spark NLP features preprocess the text. Examples include splitting, correcting spelling, cleaning, and understanding grammar. We recommend running document classification at the bronze layer and then writing the results to the silver layer.
1. In the silver layer, advanced Spark NLP features perform document analysis tasks like named entity recognition, summarization, and information retrieval. In some architectures, the outcome is written to the gold layer.
1. In the gold layer, Spark NLP runs various linguistic visual analyses on the text data. These analyses provide insight into language dependencies and help with the visualization of NER labels.
1. Users query the gold layer text data as a dataframe and view the results in PowerBI or web apps.

### Components

- [Azure Data Lake Storage](https://docs.microsoft.com/en-us/azure/machine-learning/concept-data) is a Hadoop-compatible file system that has an integrated hierarchical namespace and the massive scale and economy of Azure Blob Storage.
- [Azure Synapse Analytics]() is an analytics service for data warehouses and big data systems.


## Next steps

- [Data in Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/concept-data)