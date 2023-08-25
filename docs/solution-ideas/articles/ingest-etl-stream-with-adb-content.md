[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Your organization needs to ingest data of any format, size, and speed into the cloud in a consistent way. The solution in this article meets that need with an architecture that implements extract, transform, and load (ETL) from your data sources to a data lake. The data lake can hold all the data, including transformed and curated versions at various scales. The data can be used for data analytics, business intelligence (BI), reporting, data science, and machine learning.

*Apache® and Apache Spark™ are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/ingest-etl-and-stream-processing-with-azure-databricks.svg" alt-text="Diagram that shows the architecture and data flow for ETL and stream processing with Azure Databricks." lightbox="../media/ingest-etl-and-stream-processing-with-azure-databricks.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ingest-etl-and-stream-processing-with-azure-databricks.vsdx) of this architecture.*

### Dataflow

1. Data is ingested in the following ways:

    - Event queues like Event Hubs, IoT Hub, or Kafka send streaming data to Azure Databricks, which uses the optimized Delta Engine to read the data.
    - Scheduled or triggered Data Factory pipelines copy data from different data sources in raw formats. The [Auto Loader in Azure Databricks](/azure/databricks/spark/latest/structured-streaming/auto-loader) processes the data as it arrives.

1. Azure Databricks loads the data into optimized, compressed Delta Lake tables or folders in the Bronze layer in Data Lake Storage.
1. Streaming, scheduled, or triggered Azure Databricks jobs read new transactions from the Data Lake Storage Bronze layer. The jobs join, clean, transform, and aggregate the data before using ACID transactions to load it into curated data sets in the Data Lake Storage Silver and Gold layers.
1. The data sets are stored in Delta Lake in Data Lake Storage.

Each service ingests data into a common format to ensure consistency. The architecture uses a shared data lake based on the open Delta Lake format. Raw data is ingested from different batch and streaming sources to form a unified data platform. The platform can be used for downstream use cases such as analytics, BI reporting, data science, AI, and machine learning.

### Bronze, Silver, and Gold storage layers

With the medallion pattern, consisting of Bronze, Silver, and Gold storage layers, customers have flexible access and extendable data processing.

- **Bronze** tables provide the entry point for raw data when it lands in Data Lake Storage. The data is taken in its raw source format and converted to the open, transactional Delta Lake format for processing. The solution ingests the data into the Bronze layer by using:
  - Apache Spark APIs in Azure Databricks. The APIs read streaming events from Event Hubs or IoT Hub, and then convert those events or raw files to the Delta Lake format.
  - The **COPY INTO** command. Use the command to copy data directly from a source file or directory into Delta Lake.
  - The Azure Databricks Auto Loader. The Auto Loader grabs files when they arrive in the data lake and writes them to the Delta Lake format.
  - The Data Factory Copy Activity. Customers can use this option to convert the data from any of its supported formats into the Delta Lake format.
- **Silver** tables store data while it's being optimized for BI and data science use cases. The Bronze layer ingests raw data, and then more ETL and stream processing tasks are done to filter, clean, transform, join, and aggregate the data into Silver curated datasets. Companies can use a consistent compute engine, like the open-standards [Delta Engine](/azure/databricks/optimizations), when using Azure Databricks as the initial service for these tasks. They can then use familiar programming languages like SQL, Python, R, or Scala.  Companies can also use repeatable DevOps processes and ephemeral compute clusters sized to their individual workloads.
- **Gold** tables contain enriched data, ready for analytics and reporting. Analysts can use their method of choice, such as PySpark, Koalas, SQL, Power BI, and Excel to gain new insights and formulate queries.

### Components

- [Event Hubs](https://azure.microsoft.com/services/event-hubs) parses and scores streaming messages from various sources, including on-premises systems, and provides real-time information.
- [Data Factory](https://azure.microsoft.com/services/data-factory) orchestrates data pipelines for ingestion, preparation, and transformation of all your data at any scale.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) brings together streaming and batch data, including structured, unstructured, and semi-structured data like logs, files, and media.
- [Azure Databricks](/azure/azure-databricks) cleans and transforms the structureless data sets and combines them with structured data from operational databases or data warehouses.
- [IoT Hub](https://azure.microsoft.com/services/iot-hub) gives you highly secure and reliable communication between your IoT application and devices.
- [Delta Lake](https://delta.io) on Data Lake Storage supports ACID transactions for reliability and is optimized for efficient ingestion, processing, and queries.

## Scenario details


Ingestion, ETL, and stream processing with Azure Databricks is simple, open, and collaborative:

- **Simple**: An open data lake with a curated layer in an open-source format simplifies the data architecture. Delta Lake, an open-source tool, provides access to the Azure Data Lake Storage data lake. Delta Lake on Data Lake Storage supports atomicity, consistency, isolation, and durability (ACID) transactions for reliability. Delta Lake is optimized for efficient ingestion, processing, and queries.
- **Open**: The solution supports open-source code, open standards, and open frameworks. It also works with popular integrated development environments (IDEs), libraries, and programming languages. Through native connectors and APIs, the solution works with a broad range of other services, too.
- **Collaborative**: Data engineers, data scientists, and analysts work together with this solution. They can use collaborative notebooks, IDEs, dashboards, and other tools to access and analyze common underlying data.

Azure Databricks seamlessly integrates with other Azure services like Data Lake Storage, Azure Data Factory, Azure Event Hubs, and Azure IoT Hub.

### Potential use cases

This solution is inspired by the system that [Providence Health Care](https://customers.microsoft.com/story/862036-providence-health-provider-azure) built for real-time analytics. Any industry that ingests batch or streaming data could also consider this solution. Examples include:

- Retail and e-commerce
- Finance
- Healthcare and life sciences
- Energy suppliers

## Next steps

- [Providence Health Care](https://customers.microsoft.com/story/862036-providence-health-provider-azure) builds their data streaming solution using Azure Databricks and Azure Event Hubs to improve the National Emergency Department Overcrowding Score for each of its emergency departments.
- [Spanish Point Technologies](https://customers.microsoft.com/story/861222-spanish-point-technologies-professional-services-azure) builds its Matching Engine using Azure Databricks and Azure Data Factory to ingest data at scale to help musicians get paid fairly.

## Related resources

Guides and fully deployable architectures:

- [Choose an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Stream processing with Azure Databricks](../../reference-architectures/data/stream-processing-databricks.yml)
- [Automated enterprise BI](../../reference-architectures/data/enterprise-bi-adf.yml)
