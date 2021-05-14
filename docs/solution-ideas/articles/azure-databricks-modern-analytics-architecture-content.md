> If you'd like to see us expand this article with more information, implementation details, pricing guidance, or code examples, let us know with [GitHub Feedback](https://github.com/MicrosoftDocs/architecture-center/issues/new)!

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A modern data architecture enables you to unify all of your data, analytics, and AI workloads at any scale, and to get insights through analytics dashboards, operational reports, or advanced analytics for all your users. Modern analytics with Azure Databricks is simple, open and collaborative, and seamlessly integrated with Azure services such as Azure Data Lake Storage, Azure Data Factory, Synapse and Power BI.

- **Simple**: Simplify your data architecture by unifying analytics, data science and machine learning together. 
- **Open**: Support for open source, open standards, and open frameworks help future proof your architecture. Integration with your favorite integrated development environments (IDEs), libraries, and programming languages. Integrate with a broad ecosystem of other services through native connectors and APIs.
- **Collaborative**: Data teams can work together, using their favorite tools to collaborate on the same underlying data. Data engineers, data scientists, and analysts can leverage a common data lake using collaborative notebooks, IDEs, and dashboards.

## Architecture

_Architecture diagram goes here_

## Data Flow
This reference architecture is inspired by the system Swiss Re built for its Property & Casualty Reinsurance division. 
1. Azure Databricks ingests raw streaming data from Azure Event Hubs.
1. Azure Data Factory loads raw batch data into Azure Data Lake Storage.
1. Intro sentence about how the solution stores and curates data:

   - Azure Data Lake Storage stores all types of data, such as structured, unstructured, and semi-structured data. It also stores both batch and streaming data.
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
   - Practitioners can optimize for performance and cost with single and multi-node compute options.

1. Data about machine learning models is available in several formats:

   - Azure Databricks stores information about models in the [MLflow Model Registry][MLflow Model Registry]. The registry makes this information available through batch, streaming, and REST APIs.
   - The solution can also deploy models to Azure Machine Learning web services or Azure Kubernetes Service (AKS).

1. Users perform ad hoc SQL queries on the data lake with Azure Databricks SQL Analytics. This service:

   - Provides a query editor and catalog, the query history, basic dashboarding, and alerting.
   - Uses integrated security that includes row-level and column-level permissions.
   - Uses a [Photon-powered Delta Engine to accelerate performance][Photon improves performance].


7. Data lake exploration, reports and dashboards in Power BI using a [native connector](https://docs.microsoft.com/en-us/azure/databricks/integrations/bi/power-bi) and optimized JDBC/ODBC drivers.
8. Optionally, if a data warehouse is needed for business-ready data and aggregates, gold data sets can be exported out of the data lake into Azure Synapse via the optimized Synapse connector.
9. Leverage Azure platform services for collaboration, performance, reliability, governance and security:
    - **Azure Purview**: data discovery and governance insights, data classification and sensitivity insights across all of your entire data estate.
    - **Azure DevOps**: continuous integration and continuous deployment (CI/CD). Configure Azure DevOps as your Git provider and take advantage of the integrated version control features.
    - **Azure Key Vault**: securely manage your secrets such as keys and passwords.
    - **Azure Active Directory**: single sign-on (SSO) to Azure Databricks. Azure Databricks also supports automated user provisioning with Azure AD to create new users, give them the proper level of access, and remove users to deprovision access.
    - **Azure Monitor**: collect, analyze, and act on telemetry information of your Azure resources to proactively identify problems and maximize performance and reliability.
    - **Azure Cost Management**: financial governance over your Azure workloads.

Each service connects to the same underlying data to ensure consistency. The architecture leverages a shared data lake leveraging the open Delta Lake format. The analytical platform ingests the data from the disparate batch and streaming sources to form a unified data platform which can be used to serve analytical reports, historical reports for end users and train ML models for a recommendation engine.

### Components

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) and [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) bring together structured, unstructured, and semi-structured data (logs, files, and media). 
- [Azure Databricks](https://docs.microsoft.com/en-us/azure/azure-databricks/) cleans and transforms the structureless data sets and combines them with structured data from operational databases or data warehouses.
- [Azure Databricks](https://docs.microsoft.com/en-us/azure/azure-databricks/) adds scalable machine learning and deep learning techniques. 
- [Native connectors](https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/azure/synapse-analytics) integrate Azure Databricks and Azure Synapse Analytics to access and move data at scale.
- [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/) is a highly available, secure, and fully managed Kubernetes service that makes it easy to deploy and manage containerized applications.
- [Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning) helps you easily build, deploy, and manage predictive analytics solutions.
- [Synapse SQL Pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview) provide a data warehousing and compute environment.
- [Power BI](https://docs.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) leverages Azure Databricks capabilities to enable users to perform root cause determination and raw data analysis. Users create and share Power BI reports.

## Next steps

- [Swiss Re](https://customers.microsoft.com/en-us/story/1335371880067885708-swiss-re-drives-deeper-faster-insights-with-azure-synapse-analytics) built their digital payment platform using Azure Databricks and Power BI
- [AGL](https://customers.microsoft.com/en-in/story/844796-agl-energy-azure) achieves machine learning at scale with a standardized platform using Azure Databricks and Azure Machine Learning



[Medallion model]: https://techcommunity.microsoft.com/t5/analytics-on-azure/how-to-reduce-infrastructure-costs-by-up-to-80-with-azure/ba-p/1820280
[MLflow Model Registry]: https://www.mlflow.org/docs/latest/registry.html
[Photon improves performance]: https://techcommunity.microsoft.com/t5/analytics-on-azure/turbocharge-azure-databricks-with-photon-powered-delta-engine/ba-p/1694929