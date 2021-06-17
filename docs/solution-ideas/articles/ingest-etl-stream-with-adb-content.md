[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Your organization needs to ingest data of any format, size, and speed into the cloud in a consistent way. The solution described in this article meets that need with an architecture that implements extract, transform, and load (ETL) from your data sources to a data lake. The data lake can hold all the data, including transformed and curated versions at various scales. The data can then be used for SQL analytics, business intelligence (BI), reporting, data science, and machine learning.

Ingestion, ETL, and stream processing with Microsoft Azure Databricks is simple, open, and collaborative:

- **Simple**: Simplify your data architecture with an open data lake to store your data, with a curated layer in an open-source format. Delta Lake, an open-source tool, provides access to the Azure Data Lake Storage data lake. Delta Lake on Azure Data Lake Storage supports atomicity, consistency, isolation, and durability (ACID) transactions for reliability. Delta Lake is optimized for efficient ingestion, processing, and queries.
- **Open**: Support for open source, standards, and frameworks help future-proof your architecture. Integrated with your favorite integrated development environments (IDEs), libraries, and programming languages. Integrate with a large ecosystem of other services through native connectors and APIs.
- **Collaborative**: Data teams can work together using their favorite tools to collaborate on the same underlying data. Data engineers, data scientists, and analysts can take advantage of a common data lake using shared notebooks, IDEs, and dashboards.

Azure Databricks seamlessly integrates with other Azure services like Azure Data Lake Storage, Azure Data Factory, Azure Event Hubs, and Azure IoT Hub.

## Potential use cases

This solution is inspired by the system that [Providence](https://customers.microsoft.com/story/862036-providence-health-provider-azure) built for real-time analytics. Any industry that ingests batch or streaming data should also consider this solution. Examples include:

- Retail and e-commerce
- Banking and finance
- Healthcare and life sciences
- Energy suppliers

## Architecture

:::image type="content" source="../media/ingest-etl-and-stream-processing-with-azure-databricks.png" alt-text="Diagram that shows the architecture and data flow for ETL and stream processing with Azure Databricks." border="false":::

*Download an [SVG](../media/ingest-etl-and-stream-processing-with-azure-databricks.svg) of this architecture.*

1. Azure Databricks uses the optimized Delta Engine to read streaming data from event queues such as Event Hubs, Azure IoT Hub, or Kafka. Azure Databricks then loads the raw events into optimized, compressed Delta Lake tables or folders in the bronze layer stored in Azure Data Lake Storage.
2. Scheduled or triggered Azure Data Factory pipelines copy data from different data sources in their raw format into Azure Data Lake Storage. The [Auto Loader in Azure Databricks](https://docs.microsoft.com/azure/databricks/spark/latest/structured-streaming/auto-loader) processes the files as they land and loads them into optimized, compressed Delta Lake tables or folders in the bronze layer. These tables or folders are then stored in Azure Data Lake Storage.
3. Streaming, scheduled, or triggered Azure Databricks jobs read new transactions from the bronze layer. The jobs then join, clean, transform, and aggregate them before using ACID transactions to load them into curated data sets in the silver and gold layers. These data sets are stored in Delta Lake on the Azure Data Lake Store.

Each service ingests data into a common format to ensure consistency. The architecture uses a shared data lake based on the open Delta Lake format. Raw data is ingested from different batch and streaming sources to form a unified data platform. The platform can be used for downstream use cases such as analytics, BI reporting, data science, AI, and machine learning.

### Components

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) parses and scores streaming messages from various sources, including on-premises systems, and provides real-time information.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) orchestrates data pipelines for ingestion, preparation, and transformation of all your data at any scale.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) brings together streaming and batch data, including structured, unstructured, and semi-structured data (logs, files, and media).
- [Azure Databricks](https://docs.microsoft.com/azure/azure-databricks/) cleans and transforms the structureless data sets and combines them with structured data from operational databases or data warehouses.
- [IoT Hub](https://azure.microsoft.com/services/iot-hub/) enables highly secure and reliable communication between your IoT application and the devices it manages.

## Next steps

- [Providence](https://customers.microsoft.com/story/862036-providence-health-provider-azure) built their data streaming solution using Azure Databricks and Azure Event Hubs to improve the National Emergency Department Overcrowding Score for each of its emergency departments.
- [Spanish Point Technologies](https://customers.microsoft.com/story/861222-spanish-point-technologies-professional-services-azure) built its Matching Engine using Azure Databricks and Azure Data Factory to ingest data at scale to help musicians get paid fairly.

## Related resources

Guides and fully deployable architectures:

- [Choosing an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
- [Stream processing with Azure Databricks](/azure/architecture/reference-architectures/data/stream-processing-databricks)
- [Automated enterprise BI](/azure/architecture/reference-architectures/data/enterprise-bi-adf)
