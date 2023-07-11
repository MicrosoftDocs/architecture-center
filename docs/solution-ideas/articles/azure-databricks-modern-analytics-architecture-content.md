[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution outlines a modern data architecture. Azure Databricks forms the core of the solution. This platform works seamlessly with other services, such as Azure Data Lake Storage Gen2, Azure Data Factory, Azure Synapse Analytics, and Power BI.

*Apache® and Apache Spark™ are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" source="../media/azure-databricks-modern-analytics-architecture.svg" alt-text="Architecture diagram showing how a modern data architecture collects, processes, analyzes, and visualizes data." lightbox="../media/azure-databricks-modern-analytics-architecture.svg" border="false":::
   The diagram contains several gray rectangles. Labels on the rectangles read Ingest, Process, Serve, Store, and Monitor and govern. Each rectangle contains icons that represent Azure or partner services. The Azure Databricks icon is at the center, along with the Data Lake Storage Gen2 icon. Arrows point back and forth between icons. The arrows show how data flows through the system, as the diagram explanation steps describe. The lowest rectangle extends across the bottom of the diagram. It contains icons for services that monitor and govern operations and information.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-databricks-modern-analytics-architecture.vsdx) of this architecture.*

### Dataflow

1. Azure Databricks ingests raw streaming data from Azure Event Hubs.
1. Data Factory loads raw batch data into Data Lake Storage Gen2.
1. For data storage:

   - Data Lake Storage Gen2 houses data of all types, such as structured, unstructured, and semi-structured. It also stores batch and streaming data.
   - Delta Lake forms the curated layer of the data lake. It stores the refined data in an open-source format.
   - Azure Databricks works well with a [medallion architecture][Medallion model] that organizes data into layers:

     - Bronze: Holds raw data.
     - Silver: Contains cleaned, filtered data.
     - Gold: Stores aggregated data that's useful for business analytics.

1. The analytical platform ingests data from the disparate batch and streaming sources. Data scientists use this data for these tasks:

   - Data preparation.
   - Data exploration.
   - Model preparation.
   - Model training.

   MLflow manages parameter, metric, and model tracking in data science code runs. The coding possibilities are flexible:

   - Code can be in SQL, Python, R, and Scala.
   - Code can use popular open-source libraries and frameworks such as Koalas, Pandas, and scikit-learn, which are pre-installed and optimized.
   - Practitioners can optimize for performance and cost with single-node and multi-node compute options.

1. Machine learning models are available in several formats:

   - Azure Databricks stores information about models in the [MLflow Model Registry][MLflow Model Registry]. The registry makes models available through batch, streaming, and REST APIs.
   - The solution can also deploy models to Azure Machine Learning web services or Azure Kubernetes Service (AKS).

1. Services that work with the data connect to a single underlying data source to ensure consistency. For instance, users can run SQL queries on the data lake with Azure Databricks SQL Analytics. This service:

   - Provides a query editor and catalog, the query history, basic dashboarding, and alerting.
   - Uses integrated security that includes row-level and column-level permissions.
   - Uses a [Photon-powered Delta Engine to accelerate performance][Photon improves performance].

1. Power BI generates analytical and historical reports and dashboards from the unified data platform. This service uses these features when working with Azure Databricks:

   - A [built-in Azure Databricks connector][Power BI connector for Azure Databricks] for visualizing the underlying data.
   - Optimized Java Database Connectivity (JDBC) and Open Database Connectivity (ODBC) drivers.

1. Users can export gold data sets out of the data lake into Azure Synapse via the optimized Synapse connector. SQL pools in Azure Synapse provide a data warehousing and compute environment.

1. The solution uses Azure services for collaboration, performance, reliability, governance, and security:

   - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.
   - Azure DevOps offers continuous integration and continuous deployment (CI/CD) and other integrated version control features.
   - Azure Key Vault securely manages secrets, keys, and certificates.
   - Azure Active Directory (Azure AD) provides single sign-on (SSO) for Azure Databricks users. Azure Databricks supports automated user provisioning with Azure AD for these tasks:

     - Creating new users.
     - Assigning each user an access level.
     - Removing users and denying them access.

   - Azure Monitor collects and analyzes Azure resource telemetry. By proactively identifying problems, this service maximizes performance and reliability.
   - Azure Cost Management and Billing provide financial governance services for Azure workloads.

### Components

The solution uses the following components.

#### Core components

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters process large streams of data from multiple sources. Azure Databricks cleans and transforms structureless data sets. It combines the processed data with structured data from operational databases or data warehouses. Azure Databricks also trains and deploys scalable machine learning and deep learning models.

- [Event Hubs][Event Hubs] is a big data streaming platform. As a platform as a service (PaaS), this event ingestion service is fully managed.

- [Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate data transformation workflows.

- [Data Lake Storage Gen2][Azure Data Lake Storage Gen2] is a scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data may be structured, semi-structured, or unstructured. It typically comes from multiple, heterogeneous sources like logs, files, and media.

- [Azure Databricks SQL Analytics][Azure Databricks SQL Analytics guide] runs queries on data lakes. This service also visualizes data in dashboards.

- [Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.

- [AKS][Azure Kubernetes Service] is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications.

- [Azure Synapse][Azure Synapse Analytics] is an analytics service for data warehouses and big data systems. This service integrates with Power BI, Machine Learning, and other Azure services.

- [Azure Synapse connectors][Native connectors] provide a way to access Azure Synapse from Azure Databricks. These connectors efficiently transfer large volumes of data between Azure Databricks clusters and Azure Synapse instances.

- [SQL pools][Spark SQL pools] provide a data warehousing and compute environment in Azure Synapse. The pools are compatible with Azure Storage and Data Lake Storage Gen2.

- [Delta Lake][Databricks Delta Lake] is a storage layer that uses an open file format. This layer runs on top of cloud storage such as Data Lake Storage Gen2. Delta Lake supports data versioning, rollback, and transactions for updating, deleting, and merging data.

- [MLflow][MLflow] is an open-source platform for the machine learning lifecycle. Its components monitor machine learning models during training and running. MLflow also stores models and loads them in production.

#### Reporting and governing components

- [Power BI][What is Power BI?] is a collection of software services and apps. These services create and share reports that connect and visualize unrelated sources of data. Together with Azure Databricks, Power BI can provide root cause determination and raw data analysis.

- [Microsoft Purview][What is Microsoft Purview?] manages on-premises, multicloud, and software as a service (SaaS) data. This governance service maintains data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- [Azure DevOps][DevOps solutions on Azure] is a DevOps orchestration platform. This SaaS provides tools and environments for building, deploying, and collaborating on applications.

- [Azure Key Vault][Key Vault] stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [Azure AD][Azure Active Directory] offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources.

- [Azure Monitor][Azure Monitor] collects and analyzes data on environments and Azure resources. This data includes app telemetry, such as performance metrics and activity logs.

- [Azure Cost Management and Billing][Azure Cost Management and Billing] manage cloud spending. By using budgets and recommendations, this service organizes expenses and shows how to reduce costs.

## Scenario details

Modern data architectures meet these criteria:

- Unify data, analytics, and AI workloads.
- Run efficiently and reliably at any scale.
- Provide insights through analytics dashboards, operational reports, or advanced analytics.

This solution outlines a modern data architecture that achieves these goals. Azure Databricks forms the core of the solution. This platform works seamlessly with other services. Together, these services provide a solution with these qualities:

- Simple: Unified analytics, data science, and machine learning simplify the data architecture.
- Open: The solution supports open-source code, open standards, and open frameworks. It also works with popular integrated development environments (IDEs), libraries, and programming languages. Through native connectors and APIs, the solution works with a broad range of other services, too.
- Collaborative: Data engineers, data scientists, and analysts work together with this solution. They can use collaborative notebooks, IDEs, dashboards, and other tools to access and analyze common underlying data.

### Potential use cases

The system that Swiss Re Group built for its Property & Casualty Reinsurance division inspired this solution. Besides the insurance industry, any area that works with big data or machine learning can also benefit from this solution. Examples include:

- The energy sector
- Retail and e-commerce
- Banking and finance
- Medicine and healthcare

## Next steps

- [Swiss Re builds a digital payment platform by using Azure Databricks and Power BI][Swiss Re builds a digital payment platform by using Azure Databricks and Power BI].
- [AGL achieves machine learning at scale][AGL achieves machine learning at scale] with a standardized platform that uses Azure Databricks and Machine Learning.

## Related resources

To learn about related solutions, see this information:

### Related architecture guides

- [Monitor Azure Databricks with Azure Monitor][Monitoring Azure Databricks]
- [Compare machine learning products from Microsoft][Compare the machine learning products and technologies from Microsoft]
- [Choose a natural language processing technology][Choosing a natural language processing technology in Azure]
- [Choose a stream processing technology][Choosing a stream processing technology in Azure]

### Related architectures

- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]
- [Batch scoring of Spark models on Azure Databricks][Batch scoring of Spark models on Azure Databricks]
- [Observability patterns and metrics for performance tuning][Observability patterns and metrics for performance tuning]
- [Build a real-time recommendation API on Azure][Build a Real-time Recommendation API on Azure]

[AGL achieves machine learning at scale]: https://customers.microsoft.com/story/844796-agl-energy-azure
[Azure Active Directory]: https://azure.microsoft.com/services/active-directory
[Azure Cost Management and Billing]: https://azure.microsoft.com/services/cost-management
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory
[Azure Data Lake Storage Gen2]: https://azure.microsoft.com/services/storage/data-lake-storage
[Azure Databricks]: https://azure.microsoft.com/services/databricks
[Azure Databricks SQL Analytics guide]: /azure/databricks/sql
[Azure Kubernetes Service]: https://azure.microsoft.com/services/kubernetes-service
[Azure Machine Learning]: https://azure.microsoft.com/services/machine-learning
[Azure Monitor]: https://azure.microsoft.com/services/monitor
[Azure Synapse Analytics]: https://azure.microsoft.com/services/synapse-analytics
[Batch scoring of Spark models on Azure Databricks]: ../../reference-architectures/ai/batch-scoring-databricks.yml
[Build a Real-time Recommendation API on Azure]: ../../reference-architectures/ai/real-time-recommendation.yml
[Compare the machine learning products and technologies from Microsoft]: ../../data-guide/technology-choices/data-science-and-machine-learning.md
[Choosing a natural language processing technology in Azure]: ../../data-guide/technology-choices/natural-language-processing.yml
[Choosing a stream processing technology in Azure]: ../../data-guide/technology-choices/stream-processing.md
[Databricks Delta Lake]: https://databricks.com/product/delta-lake-on-databricks
[Event Hubs]: https://azure.microsoft.com/services/event-hubs
[Key Vault]: https://azure.microsoft.com/services/key-vault
[Medallion model]: https://techcommunity.microsoft.com/t5/analytics-on-azure/how-to-reduce-infrastructure-costs-by-up-to-80-with-azure/ba-p/1820280
[MLflow]: https://mlflow.org
[MLflow Model Registry]: https://www.mlflow.org/docs/latest/registry.html
[Monitoring Azure Databricks]: ../../databricks-monitoring/index.md
[Native connectors]: /azure/databricks/data/data-sources/azure/synapse-analytics
[Observability patterns and metrics for performance tuning]: ../../databricks-monitoring/databricks-observability.yml
[Photon improves performance]: https://techcommunity.microsoft.com/t5/analytics-on-azure/turbocharge-azure-databricks-with-photon-powered-delta-engine/ba-p/1694929
[Power BI connector for Azure Databricks]: /azure/databricks/integrations/bi/power-bi
[Spark SQL pools]: /azure/synapse-analytics/spark/apache-spark-overview
[Stream processing with Azure Databricks]: ../../reference-architectures/data/stream-processing-databricks.yml
[Swiss Re builds a digital payment platform by using Azure Databricks and Power BI]: https://customers.microsoft.com/story/1335371880067885708-swiss-re-drives-deeper-faster-insights-with-azure-synapse-analytics
[DevOps solutions on Azure]: https://azure.microsoft.com/solutions/devops
[What is Microsoft Purview?]: /azure/purview/overview
[What is Power BI?]: /power-bi/fundamentals/power-bi-overview
