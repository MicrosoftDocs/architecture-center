[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article is a solution idea for creating and maintaining a data pipeline by using a configuration file. The file can, for example, contain a configuration that's specified by using JSON format. The file defines the ingestion, transformations, and curation of the data. It's the only file that needs to be maintained for data processing, so the business users or operations team can manage the data pipeline without the aid of a developer.

*[Apache](https://www.apache.org)®, [Apache Spark®](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/configuration-driven-data-pipeline-architecture.png" alt-text="Diagram of the architecture for configuration-driven data pipeline." lightbox="../media/configuration-driven-data-pipeline-architecture.png" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-2003744-configuration-driven-data-pipelines.pptx) of this architecture.*

### Dataflow

1. **Configuration:** The metadata of the pipeline defines the pipeline stages, data sources, transformations, and aggregation logic. There are three pipeline stages: staging, standardization, and serving. The aggregation logic can be implemented in Spark SQL.
1. **REST APIs:** The REST APIs are used to manage the pipeline configuration. The business users or operations team can manage the pipeline configuration by using a web UI that's based on the API layer.
1. **Framework:** The framework loads the configuration files and converts them into Azure Databricks jobs. It encapsulates the complex Spark cluster and job runtime and presents an interface that's easy to use so that the business users can focus on business logic. The framework is based on PySpark and Azure Delta Lake. It's created and managed by data engineers.

### Components

- [Azure Data Factory](https://azure.microsoft.com/products/data-factory) loads external data and stores it in Azure Data Lake Storage.
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) accepts streaming data from various sources. Azure Databricks loads streaming data directly from Event Hubs.
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) is the data storage layer of the staging, standardization, and serving zones.
- [Azure Databricks](https://azure.microsoft.com/products/databricks) is the calculation engine for data transformation. The transformation logic is implemented with Spark SQL.
- [Azure Databricks Client Library](https://github.com/Azure/azure-databricks-client) provides a convenient interface to the Azure Databricks REST API, which is used to deploy the Azure Databricks job that's converted from the configuration file.
- [Azure Functions](https://azure.microsoft.com/products/functions) provides a way to implement the API layer that's used to create and deploy Azure Databricks jobs.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines) is the [Azure Devops](https://azure.microsoft.com/products/devops) service that provides the pipelines that automate the builds and deployments in the framework. The framework can be built as a wheel (.whl) file and published to Azure Databricks clusters as a library.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that can work together to turn unrelated sources of data into coherent, visually immersive, and interactive insights.

## Scenario details

This section has additional information about applying and implementing configuration-driven pipelines.

### The medallion architecture

In the medallion architecture that Azure Databricks introduced, a data pipeline has three stages: staging, standardization, and serving.

| Stage | Description |
|-|-|
| Bronze/Staging | The data from external systems is ingested and stored. The data structures in this stage correspond to the table structures as they are on the source systems, along with additional metadata columns like the date and time of the load, the process ID, and so on. |
| Silver/Standardization | The staged data is cleansed and transformed and then stored. It provides enriched datasets that are suited for further business analysis. The master data can be versioned with slowly changed dimension (SCD) patterns, and the transaction data is deduplicated and contextualized by using master data. |
| Gold/Serving | The data from the standardization stage is aggregated and then stored. The data is organized in consumption-ready, project-specific databases that are provided by services such as those in the [Azure SQL](https://azure.microsoft.com/products/azure-sql) family. |

Enterprise data warehouses can have large numbers of existing data pipelines. The data pipelines are usually managed by data engineers who write and maintain the code that implements data ingestion, data transformation, and data curation. The code is usually written in Spark SQL, Scala, or Python, and stored in a Git repository. The data engineers need to maintain the code and deploy the pipelines with complicated DevOps deployment pipelines. As business requirements increase and change, the need for engineering effort can become a bottleneck to data pipeline development. As a consequence, the business users or operations teams can wait for a long time to get the data they need.

This solution proposes a data pipeline that's driven by a configuration file. The configuration file can be in JSON format. It specifies the data ingestion, transformation, and curation processes. The configuration file is the only file that needs to be maintained for data processing. In this way, business users or operations teams can maintain the data pipeline without help from developers.

### Potential use cases

- In a manufacturing company, the factory operator wants to ingest all recipe data from the on-premises servers in its factories, which number more than 30. It provides a curated view of the data to ensure that it's complete, so that production can start. The factories can have different data schemas. Configuration-driven data pipelines can simplify the data ingestion and standardization process.
- A solution provider hopes to build a common data platform for customers. The platform should significantly reduce development efforts by engineers and the need to handle various data sources, data schemas, and transformation logic. This helps the solution provider to onboard the customers rapidly.

## Deploy this solution

### Configuration file example

The metadata of the pipeline defines the pipeline stages, data sources, transformations, and aggregation logic. Here's an example of a configuration file:

   ```json
   {
     "name": "fruit_data_app",
     "staging": [
       {
         "name": "sales",
         "format": "csv",
         "target": "raw_sales",
         "location": "sales/",
         "type": "batch",
         "output": ["file", "view"],
         "schema": {...}
       },
       {
         "name": "price",
         "format": "csv",
         "target": "raw_price",
         "location": "price/",
         "type": "batch",
         "output": ["file", "view"],
         "schema": {...}
       }
     ],
     "standardization": [
       {
         "name": "fruit_sales",
         "sql": "select price.fruit, price.id, sales.amount, price.price from raw_sales sales left outer join raw_price price on sales.id = price.id",
         "target": "fruit_sales",
         "type": "batch",
         "output": ["file", "view"]
       }
     ],
     "serving": [
       {
         "name": "fruit_sales_total",
         "sql": "select id, fruit, sum(amount*price) as total from fruit_sales group by id, fruit order by total desc",
         "target": "fruit_sales_total",
         "type": "batch",
         "output": ["table", "file"]
       }
     ]
   }
   ```

There are three pipeline stages: **staging**, **standardization**, and **serving**. The aggregation logic can be implemented in Spark SQL. In this example, there are two Spark SQL procedures. The one in **standardization** merges price and sales data. The one in **serving** aggregates the sales data.

### Framework code snippets

Here are some code snippets of the framework, which runs Spark jobs based on the configuration file.

- In the staging zone, it reads raw data from the source system and stores it in the staging zone of Data Lake Storage. The input and output are defined in the configuration file as follows:

  ```json
  df = spark \
      .readStream \
      .format(format) \
      .option("multiline", "true") \
      .option("header", "true") \
      .schema(schema) \
      .load(landing_path+"/"+location)    
  
  if "table" in output:
      query = df.writeStream \
          .format(storage_format) \
          .outputMode("append") \
          .option("checkpointLocation", staging_path+"/"+target+"_chkpt") \
          .toTable(target)
  ```

- In the standardization zone, it transforms data by using Spark SQL that's defined in the configuration file, and outputs the result to the standardization zone of Data Lake Storage.

  ```json
  df = spark.sql(sql)
  if type == "streaming":
      query = df.writeStream \
          .format(storage_format) \
          .outputMode("append") \
          .option("checkpointLocation", standardization_path+"/"+target+"_chkpt") \
          .toTable(target)
  ```
  
- In the serving zone, it aggregates data by using Spark SQL that's defined in the configuration file, and outputs the result to the serving zone of Data Lake Storage.

```json
  df = spark.sql(sql)
  if type == "streaming":
      query = df.writeStream \
          .format(storage_format) \
          .outputMode("complete") \
          .option("checkpointLocation", serving_path+"/"+target+"_chkpt") \
          .toTable(target)
  ```

## Contributors

Principal authors:

- [Sean Ma](https://www.linkedin.com/in/sean-ma-032b77a8) | Principal Software Engineering Lead
- [Jason Mostella](https://www.linkedin.com/in/jasonmostella) | Senior Software Engineer

## Next steps

- [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture)
- [Delta Lake](https://delta.io)
- [Config-Driven Data Pipeline](https://github.com/Azure/config-driven-data-pipeline)
- [Azure Data Factory documentation](/azure/data-factory)
- [Azure Event Hubs documentation](/azure/event-hubs)
- [Azure Databricks documentation](/azure/databricks)
- [Azure Databricks libraries](/azure/databricks/libraries)
- [Azure Pipelines documentation](/azure/devops/pipelines)
- [Power BI documentation](/power-bi)

## Related resources

- [DevOps checklist](../../checklist/dev-ops.md)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](../../solution-ideas/articles/ingest-etl-stream-with-adb.yml)
- [DataOps for the modern data warehouse](../../example-scenario/data-warehouse/dataops-mdw.yml)
- [Automate multistage Azure pipelines with Azure Pipelines](../../example-scenario/devops/automate-azure-pipelines.yml)
- [Design a CI/CD pipeline using Azure DevOps](/azure/architecture/example-scenario/apps/devops-dotnet-baseline)