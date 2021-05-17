> If you'd like to see us expand this article with more information, implementation details, pricing guidance, or code examples, let us know with [GitHub Feedback](https://github.com/MicrosoftDocs/architecture-center/issues/new)!

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Modern data architectures offer many benefits:

- Unify data, analytics, and AI workloads.
- Perform efficiently and reliably at any scale.
- Provide insights through analytics dashboards, operational reports, or advanced analytics.

This solution uses Azure Databricks to provide modern analytics. In this system, Azure Databricks works seamlessly with other Azure services such as Azure Data Lake Storage, Azure Data Factory, Azure Synapse, and Power BI. Together, these services provide a solution with these qualities:

- Simple: Unified analytics, data science, and machine learning simplify the data architecture.
- Open: The solution supports open source, open standards, and open frameworks. It also integrates with popular integrated development environments (IDEs), libraries, and programming languages. Through native connectors and APIs, the architecture works with a broad range of other services, too.
- Collaborative: Data engineers, data scientists, and analysts work together with this solution. They can use collaborative notebooks, IDEs, dashboards, and other tools to access and analyze common underlying data.

## Architecture

:::image type="complex" source="../media/azure-databricks-modern-analytics-architecture-diagram.png" alt-text="Architecture diagram showing how to sync on-premises and Azure databases during mainframe modernization." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains rectangles, one that pictures databases and one that contains integration tools. A server icon that represents the self-hosted integration runtime is also located in the on-premises part. The Azure part also contains rectangles. One is for pipelines. Others are for services that the solution uses for staging and preparing data. Another contains Azure databases. Arrows point from on-premises components to Azure components. These arrows represent the flow of data in the replication and sync processes. One of the arrows goes through the on-premises data gateway.
:::image-end:::

This reference architecture is inspired by the system Swiss Re built for its Property & Casualty Reinsurance division.

1. Azure Databricks ingests raw streaming data from Azure Event Hubs.
1. Azure Data Factory loads raw batch data into Azure Data Lake Storage.
1. Intro sentence about how the solution stores and curates data:

   - Azure Data Lake Storage stores data of all types, such as structured, unstructured, and semi-structured. It also stores both batch and streaming data.
   - Delta Lake forms the curated layer of the data lake. It stores the refined data in an open-source format.
   - Azure Databricks uses a [medallion architecture][Medallion model] to organize the data:

     - A bronze layer holds raw data.
     - A silver layer contains cleaned, filtered data.
     - A gold layer stores aggregated data that's useful for business analysis.

1. Data scientists perform these tasks:

   - Data preparation
   - Data exploration
   - Model preparation
   - Model training

   MLflow manages parameter, metric, and model tracking in data science code runs. The coding possibilities are flexible:

   - Code can be in SQL, Python, R, Scala, and other languages.
   - Code can use popular open source libraries and frameworks such as Koalas, Pandas, and scikit-learn, which are pre-installed and optimized.
   - Practitioners can optimize for performance and cost with single-node and multi-node compute options.

1. Data about machine learning models is available in several formats:

   - Azure Databricks stores information about models in the [MLflow Model Registry][MLflow Model Registry]. The registry makes this information available through batch, streaming, and REST APIs.
   - The solution can also deploy models to Azure Machine Learning web services or Azure Kubernetes Service (AKS).

1. Users perform ad hoc SQL queries on the data lake with Azure Databricks SQL Analytics. This service:

   - Provides a query editor and catalog, the query history, basic dashboarding, and alerting.
   - Uses integrated security that includes row-level and column-level permissions.
   - Uses a [Photon-powered Delta Engine to accelerate performance][Photon improves performance].

1. Power BI generates reports and dashboards from the data lake data. When working with Azure Databricks data, this service uses these features:

   - A [built-in Azure Databricks connector][Power BI connector for Azure Databricks] that gives users access to visualizations and the underlying data.
   - Optimized Java Database Connectivity (JDBC) and Open Database Connectivity (ODBC) drivers.

1. Azure Synapse uses an optimized Synapse connector to import gold data sets from the data lake. This step is optional. It only occurs when users need business-ready data warehouse data like aggregates.

1. The solution uses Azure services for collaboration, performance, reliability, governance, and security:

   - Azure Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.
   - Azure DevOps offers continuous integration and continuous deployment (CI/CD)and  other integrated version control features.
   - Azure Key Vault securely manages secrets, keys, and certificates.
   - Azure Active Directory provides single sign-on (SSO) for Azure Databricks users. Azure Databricks supports automated user provisioning with Azure AD for these tasks:

     - Creating new users.
     - Assigning each user an access level.
     - Removing users denying them access.

   - Azure Monitor collects and analyzes Azure resource telemetry. By proactively identifying problems, this service maximizes performance and reliability.
   - Azure Cost Management provides financial governance services for Azure workloads.




Each service connects to the same underlying data to ensure consistency. The architecture leverages a shared data lake leveraging the open Delta Lake format. The analytical platform ingests the data from the disparate batch and streaming sources to form a unified data platform which can be used to serve analytical reports, historical reports for end users and train ML models for a recommendation engine.

### Components

- [Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate data transformation workflows.

- [Data Lake Storage][Azure Data Lake Storage] is a scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data may be structured, semi-structured, or unstructured. It typically comes from multiple, heterogeneous sources like logs, files, and media.

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters process large streams of data from multiple sources. Azure Databricks cleans and transforms structureless data sets. It combines the processed data with structured data from operational databases or data warehouses. Azure Databricks also trains and deploys scalable machine learning and deep learning models.

- The [Azure Synapse connector][Native connectors] provides a way to access Azure Synapse from Azure Databricks. This connector efficiently transfers large volumes of data between Azure Databricks clusters and Azure Synapse instances.

- [Azure Kubernetes Service][Azure Kubernetes Service] is a highly available, secure, and fully managed Kubernetes service that makes it easy to deploy and manage containerized applications.

- [Azure Synapse Analytics][Azure Synapse Analytics] is an analytics service for data warehouses and big data systems. This service uses Spark technologies and integrates with Power BI, Azure Machine Learning, and other Azure services.

- [Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.




- [Synapse SQL Pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview) provide a data warehousing and compute environment.

- [Power BI](https://docs.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) leverages Azure Databricks capabilities to enable users to perform root cause determination and raw data analysis. Users create and share Power BI reports.

[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage
[Azure Databricks]: /azure/databricks/scenarios/what-is-azure-databricks
[Azure Kubernetes Service]: /azure/aks/
[Azure Machine Learning]: /azure/machine-learning
[Azure Synapse Analytics]: https://azure.microsoft.com/services/synapse-analytics/
[Native connectors]: /azure/databricks/data/data-sources/azure/synapse-analytics

## Next steps

- [Swiss Re](https://customers.microsoft.com/en-us/story/1335371880067885708-swiss-re-drives-deeper-faster-insights-with-azure-synapse-analytics) built their digital payment platform using Azure Databricks and Power BI
- [AGL](https://customers.microsoft.com/en-in/story/844796-agl-energy-azure) achieves machine learning at scale with a standardized platform using Azure Databricks and Azure Machine Learning



[Medallion model]: https://techcommunity.microsoft.com/t5/analytics-on-azure/how-to-reduce-infrastructure-costs-by-up-to-80-with-azure/ba-p/1820280
[MLflow Model Registry]: https://www.mlflow.org/docs/latest/registry.html
[Photon improves performance]: https://techcommunity.microsoft.com/t5/analytics-on-azure/turbocharge-azure-databricks-with-photon-powered-delta-engine/ba-p/1694929
[Power BI connector for Azure Databricks]: /azure/databricks/integrations/bi/power-bi