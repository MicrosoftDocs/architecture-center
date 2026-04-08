[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution outlines the key principles and components of modern data architectures. Azure Databricks is central to the solution. This platform integrates directly with other services, such as Azure Data Lake Storage, Microsoft Fabric, and Power BI.

*Apache® and Apache Spark™ are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" source="../media/azure-databricks-modern-analytics-architecture.svg" alt-text="Architecture diagram that shows how a modern data architecture collects, processes, analyzes, and visualizes data." lightbox="../media/azure-databricks-modern-analytics-architecture.svg" border="false":::
   Diagram that shows a modern data platform arranged from left to right, with data sources on the left, processing and storage in the center, and analytics, governance, and reporting on the right. Azure Databricks and Azure Data Lake Storage appear in the middle as the visual hub of the diagram. Around them are icons for batch and streaming ingestion, machine learning, SQL querying, Microsoft Fabric, and Power BI. Arrows connect the services in both directions to show how data moves into the platform to be refined and stored, and then used for analytics and business reporting. A horizontal band across the bottom groups services for governance, identity, monitoring, DevOps, and cost management.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-databricks-modern-analytics-architecture.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Azure Databricks ingests raw streaming data from Azure Event Hubs by using Lakeflow Spark Declarative Pipelines (SDP).

1. Fabric Data Factory loads raw batch data into Data Lake Storage.

1. The following components store, curate, and organize data in the data lake:

   - Data Lake Storage stores all types of data, including structured, unstructured, and partially structured data. It also stores batch and streaming data.

   - Delta Lake is the curated layer of the data lake. It stores the refined data in an open-source format.

   Azure Databricks uses a [medallion architecture][Medallion model] to organize data into the following layers:

     - **The Bronze layer** holds raw data.
   
     - **The Silver layer** contains cleaned, filtered data.
   
     - **The Gold layer** stores aggregated data that supports business analytics.

1. The analytical platform ingests data from the different batch and stream sources. Data scientists use this data for tasks like:

   - Data preparation

   - Data exploration

   - Model preparation

   - Model training

   MLflow manages parameter, metric, and model tracking in data science code runs. Azure Databricks provides flexible coding options for these workloads, including:

   - Support for SQL, Python, R, and Scala.

   - Integration with popular open-source libraries and frameworks such as PySpark, pandas API on Spark, pandas, and scikit-learn.

   - Single-node and multiple-node compute options that help optimize performance and cost.

1. Machine learning models are available and deployable by using Azure Databricks, which stores information about models in the [MLflow Model Registry][MLflow Model Registry]. The registry makes models available through batch, streaming, and REST APIs. The solution can also make models available by deploying them to Azure Machine Learning endpoints, including managed online endpoints, batch endpoints, and Azure Kubernetes Service (AKS)-backed Kubernetes endpoints.

1. To help ensure consistency, the services that manage the data connect to a single underlying data source. For example, you can run SQL queries on the data lake by using Azure Databricks SQL warehouses. This service:

   - Provides a query editor and catalog, the query history, basic dashboarding, and alerts.

   - Uses integrated security that includes row-level permissions and column-level permissions.

   - Uses a [Photon-powered Delta Engine to improve performance][Photon improves performance].

1. You can mirror gold datasets from Azure Databricks Unity Catalog to Microsoft OneLake. Use [Azure Databricks mirroring in Fabric][Databricks mirroring in Fabric] to integrate data without replication or movement.

1. Power BI generates analytical and historical reports and dashboards from the unified data platform. Power BI integration with Azure Databricks provides the following features:

   - A [built-in Azure Databricks connector][Power BI connector for Azure Databricks] to visualize the underlying data

   - Optimized Java Database Connectivity (JDBC) and Open Database Connectivity (ODBC) drivers

    To load your Power BI semantic models for higher-performance queries, you can use [Direct Lake mode][Direct Lake] with Azure Databricks mirrored into OneLake. 

1. The solution uses Unity Catalog and Azure services for collaboration, performance, reliability, governance, and security. The following services and capabilities support platform governance and management:

   - Azure Databricks Unity Catalog provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces.

   - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.

   - For Data Lake Storage access, use identity-based authentication tools, like managed identities and service principals, as the default across data services. Use Azure Key Vault only when a workload requires nonidentity credentials, such as tokens, passwords, or shared keys. Treat secrets as a cross-cutting control. Centralize storage, restrict access, rotate regularly, and set up workloads to retrieve secrets at runtime rather than via embedded connection strings.

   - Azure DevOps and other DevOps platforms, such as GitHub, offer continuous integration and continuous delivery (CI/CD) and other integrated version-control features for automating infrastructure deployment and code management.

   - Power BI accesses curated (Gold) data through Azure Databricks SQL endpoints by using Microsoft Entra ID-based authentication and authorization. Databricks Unity Catalog and enterprise governance services control data access, which means that Power BI doesn't need direct storage credentials and only authorized users and datasets can access the data.

   - Microsoft Entra ID provides single sign-on (SSO) and automatic identity management for Azure Databricks users and groups. Automatic identity management syncs users, service principals, and groups from Microsoft Entra ID without separate provisioning configuration. Azure Databricks supports automated identity provisioning with Microsoft Entra ID to:

     - Create and sync users, groups, and service principals.
   
     - Manage nested group memberships.
   
     - Remove users and deny access when identities are deleted from Microsoft Entra ID.

   - Azure Monitor collects and analyzes Azure resource telemetry. This service maximizes performance and reliability by proactively identifying problems.

   - Microsoft Cost Management provides financial governance services for Azure workloads.

### Components

This solution uses the following components.

#### Core components

- [Azure Databricks][Azure Databricks] is a data analytics platform that uses Spark clusters to process large data streams. It cleans and transforms unstructured data and combines it with structured data. It can also train and deploy machine learning models. In this architecture, Azure Databricks serves as the central tool for data ingestion, processing, and serving. It provides a unified environment for managing the entire data life cycle.

- [Azure Databricks SQL warehouses][Azure Databricks SQL warehouses] are compute resources that you can use to query and explore data on Azure Databricks. In this architecture, you can use SQL endpoints to connect directly to your data from Power BI.

- [Lakeflow SDP][Lakeflow SDP], formerly Delta Live Tables, is a declarative framework for building reliable, maintainable, and testable data processing pipelines. In this architecture, Lakeflow SDP helps you define transformations to perform on your data. It also helps you manage task orchestration, cluster management, monitoring, data quality, and error handling within Azure Databricks.

- [Fabric][Microsoft Fabric] is an end-to-end analytics and data platform for organizations that need a unified solution. The platform provides services like Fabric Data Engineering, Fabric Data Factory, Fabric Data Science, Fabric Real-Time Intelligence, Fabric Data Warehouse, Fabric Databases, and OneLake. This architecture mirrors Unity Catalog tables into OneLake and uses Direct Lake mode in Power BI for better performance.

- [Data Factory][Fabric Data Factory] is a modern data integration platform that you can use to ingest, prepare, and transform data from a set of data sources in Fabric. This architecture uses built-in connectors to several data sources for quick ingestion into Data Lake Storage or OneLake. Azure Databricks later retrieves and further transforms the batch data.

- [Event Hubs][Event Hubs] is a fully managed, big data streaming platform. As a platform as a service (PaaS), it provides event ingestion capabilities. This architecture uses Event Hubs for streaming data. Azure Databricks can connect to this data and process it by using Spark Streaming or Lakeflow SDP.

- [Data Lake Storage][Azure Data Lake Storage] is a scalable and secure data lake for high-performance analytics. It handles multiple petabytes of data and supports hundreds of gigabits of throughput. Data Lake Storage can store structured, partially structured, and unstructured data. This architecture uses Data Lake Storage to store both batch and streaming data.

- [Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. You can forecast behavior, outcomes, and trends by using these models. In this architecture, Machine Learning uses data that Azure Databricks transforms to train and infer models.

- [AKS][Azure Kubernetes Service] is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications. In this architecture, AKS hosts machine learning models in a containerized environment for scalable inferencing.

- [Delta Lake][Databricks Delta Lake] is a storage layer that uses an open file format. This layer runs on top of cloud storage solutions like Data Lake Storage. Delta Lake supports data versioning, rollback, and transactions for updating, deleting, and merging data. In this architecture, Delta Lake serves as the primary file format for writing to and reading data from Data Lake Storage.

- [MLflow][MLflow] is an open-source platform for machine learning life cycle management. Its components monitor machine learning models during training and operation. In this architecture, similar to Machine Learning, you can use MLflow in Azure Databricks to manage your machine learning life cycle. Train and infer models by using the Unity Catalog data that you transform within Azure Databricks.

#### Reporting and governing components

- [Azure Databricks Unity Catalog][Databricks Unity Catalog] provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces. In this architecture, Unity Catalog serves as the primary tool within Azure Databricks to manage and secure data access. 

- [Power BI][What is Power BI?] is a collection of software services and apps. These services create and share reports that connect and visualize unrelated sources of data. Together with Azure Databricks, Power BI can provide root cause determination and raw data analysis. In this architecture, you use Power BI to create dashboards and reports that provide insights into the data that Azure Databricks and Fabric process.

- [Microsoft Purview][Data governance with Microsoft Purview] manages on-premises, multicloud, and software as a service (SaaS) data. This governance service maintains data landscape maps. Its features include automated data discovery, sensitive data classification, and data lineage. In this architecture, Microsoft Purview scans and tracks data ingested by Unity Catalog, Fabric, Power BI, and Data Lake Storage.

- [Azure DevOps][DevOps solutions on Azure] is a DevOps orchestration platform. This SaaS provides tools and environments to build, deploy, and collaborate on applications. In this architecture, Azure DevOps automates the deployment of Azure infrastructure. You can also use GitHub for automation and version control of Azure Databricks code for better collaboration, change tracking, and integration with CI/CD pipelines.

- [Key Vault][Key Vault] stores and controls access to secrets, such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates. In this architecture, Key Vault stores shared access signature keys from Data Lake Storage. These keys are then used in Azure Databricks and other services for authentication.

- [Microsoft Entra ID][Microsoft Entra ID] offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources. In this architecture, Microsoft Entra ID authenticates and authorizes users and services in Azure.

- [Automatic identity management][Automatic Identity Management] automatically syncs users, service principals, and groups from Microsoft Entra ID to Azure Databricks without separate application configuration. Azure Databricks activates this feature by default and includes support for nested groups and service principals. In this architecture, you can use System for Cross-domain Identity Management (SCIM) provisioning if your organization has specific identity management requirements.
  
- [Azure Monitor][Azure Monitor] collects and analyzes data in environments and Azure resources. This data includes app telemetry, such as performance metrics and activity logs. In this architecture, Azure Monitor tracks the health of compute resources in Azure Databricks and Machine Learning, and other components that send logs to Azure Monitor.

- [Cost Management][Microsoft Cost Management] helps you manage cloud spending. This service organizes expenses and shows you how to reduce costs by using budgets and recommendations. In this architecture, Cost Management helps to monitor and control the cost of the entire solution.

## Scenario details

Modern data architectures:

- Unify data, analytics, and AI workloads.
- Run efficiently and reliably at any scale.
- Provide insights through analytics dashboards, operational reports, or advanced analytics.

This solution outlines a modern data architecture that achieves these goals. Azure Databricks forms the core of the solution. This platform integrates directly with other services. Together, these services provide a solution that's:

- **Simple:** Unified analytics, data science, and machine learning simplify the data architecture.

- **Open:** The solution supports open-source code, open standards, and open frameworks. It also works with popular integrated development environments (IDEs), libraries, and programming languages. The solution also integrates with a broad range of other services.

- **Collaborative:** Data engineers, data scientists, and analysts work together with this solution. They can use collaborative notebooks, IDEs, dashboards, and other tools to access and analyze common underlying data.

### Potential use cases

This solution applies to organizations that already use both PaaS‑based analytics platforms and SaaS‑based business intelligence (BI) tools, often across different teams. The solution helps data engineers and data science teams who rely on Azure Databricks for scalable processing and machine learning. Analytics and business users use Power BI for standardized reporting, which requires a unified architecture that supports both workloads without data duplication or governance fragmentation.

Use this architecture if you:

- Have data engineers and data science teams that already use Azure Databricks for scalable data processing, advanced analytics, and machine learning.

- Have analytics and business user communities that depend on Power BI for standardized, governed reporting and self‑service insights.

- Require a unified data architecture so that both platforms can use a shared data foundation.

- Want to avoid data duplication or the creation of parallel pipelines solely to satisfy different analytics workloads.

- Need to maintain consistent governance, security, and access controls across engineering and BI workloads.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Lorrin Ferdinand](https://www.linkedin.com/in/lorrin-ferdinand/) | Principal Author

Other contributor:

- [Kranthi Kumar Manchhikanti](https://www.linkedin.com/in/kranthimanchikanti/) | Contributor

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Build an extract, transform, and load (ETL) pipeline by using change data capture][Build an ETL pipeline using change data capture]
- [Create an end-to-end pipeline by using Data Factory](/fabric/data-factory/tutorial-end-to-end-pipeline)
- [Use Direct Lake for high‑performance analytics on OneLake data][Direct Lake]
- [Understand supported Databricks and Fabric integration patterns](https://techcommunity.microsoft.com/blog/analyticsonazure/approaches-to-integrating-azure-databricks-with-microsoft-fabric-the-better-toge/4453643)

## Related resources

- [Choose a data analytics and reporting technology in Azure][Choose a data analytics and reporting technology in Azure]
- [Choose a data pipeline orchestration technology in Azure][Choose a data pipeline orchestration technology in Azure]
- [Compare machine learning products from Microsoft][Compare the machine learning products and technologies from Microsoft]
- [Choose a stream processing technology][Choosing a stream processing technology in Azure]
- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]

[Automatic Identity Management]: /azure/databricks/admin/users-groups/automatic-identity-management
[Azure Data Lake Storage]: /azure/storage/blobs/data-lake-storage-introduction
[Azure Databricks]: /azure/well-architected/service-guides/azure-databricks
[Lakeflow SDP]: /azure/databricks/ldp
[Azure Databricks SQL warehouses]: /azure/databricks/sql/
[Azure Kubernetes Service]: /azure/well-architected/service-guides/azure-kubernetes-service
[Azure Machine Learning]: /azure/well-architected/service-guides/azure-machine-learning
[Azure Monitor]: /azure/azure-monitor/overview
[Compare the machine learning products and technologies from Microsoft]: ../../ai-ml/guide/data-science-and-machine-learning.md
[Databricks Delta Lake]: /azure/databricks/delta/
[Fabric Data Factory]: /fabric/data-factory/data-factory-overview
[Databricks Unity Catalog]: /azure/databricks/data-governance/unity-catalog/
[Databricks mirroring in Fabric]: /fabric/database/mirrored-database/azure-databricks
[DevOps solutions on Azure]: /azure/devops/user-guide/what-is-azure-devops?view=azure-devops
[Direct Lake]: /fabric/get-started/direct-lake-overview
[Event Hubs]: /azure/well-architected/service-guides/azure-event-hubs
[Key Vault]: /azure/key-vault/general/overview
[Medallion model]: /azure/databricks/lakehouse/medallion
[Microsoft Cost Management]: /azure/cost-management-billing/costs/overview-cost-management
[Microsoft Entra ID]: /entra/fundamentals/whatis
[Microsoft Fabric]: /fabric/get-started/microsoft-fabric-overview
[MLflow]: https://mlflow.org
[MLflow Model Registry]: https://www.mlflow.org/docs/latest/registry.html
[Photon improves performance]: /azure/databricks/compute/photon
[Power BI connector for Azure Databricks]: /azure/databricks/integrations/bi/power-bi
[Build an ETL pipeline using change data capture]: /azure/databricks/ldp/tutorial-pipelines/
[Stream processing with Azure Databricks]: ../../reference-architectures/data/stream-processing-databricks.yml
[Choosing a stream processing technology in Azure]: ../../data-guide/technology-choices/stream-processing.md
[Choose a data analytics and reporting technology in Azure]: ../../data-guide/technology-choices/analysis-visualizations-reporting.md
[Choose a data pipeline orchestration technology in Azure]: ../../data-guide/technology-choices/pipeline-orchestration-data-movement.md
[What is Power BI?]: /power-bi/fundamentals/power-bi-overview
[Data governance with Microsoft Purview]: /purview/data-governance-overview
