[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution outlines the key principles and components of modern data architectures. Azure Databricks forms the core of the solution. This platform works seamlessly with other services, such as Azure Data Lake Storage, Microsoft Fabric, and Power BI.

*Apache® and Apache Spark™ are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" source="../media/azure-databricks-modern-analytics-architecture.svg" alt-text="Architecture diagram that shows how a modern data architecture collects, processes, analyzes, and visualizes data." lightbox="../media/azure-databricks-modern-analytics-architecture.svg" border="false":::
   The diagram contains several gray rectangles. Labels on the rectangles read Sources, Process, Serve, Store, Discover and govern, and Platform. Each rectangle contains icons that represent Azure or partner services. The Azure Databricks and the Data Lake Storage icons are in the center. Arrows point back and forth between icons. The arrows show how data flows through the system, which the diagram explanation steps describe. The lowest rectangle extends across the bottom of the diagram. It contains icons for services that monitor and govern operations and information.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-databricks-modern-analytics-architecture.vsdx) of this architecture.*

### Dataflow

1. Azure Databricks ingests raw streaming data from Azure Event Hubs by using Delta Live Tables.
1. Fabric Data Factory loads raw batch data into Data Lake Storage.
1. For data storage:

   - Data Lake Storage houses all types of data, including structured, unstructured, and partially structured data. It also stores batch and streaming data.
   - Delta Lake forms the curated layer of the data lake. It stores the refined data in an open-source format.
   - Azure Databricks works well with a [medallion architecture][Medallion model] that organizes data into layers:

     - Bronze layer: Holds raw data.
     - Silver layer: Contains cleaned, filtered data.
     - Gold layer: Stores aggregated data that's useful for business analytics.

1. The analytical platform ingests data from the disparate batch and streaming sources. Data scientists use this data for tasks like:

   - Data preparation.
   - Data exploration.
   - Model preparation.
   - Model training.

   MLflow manages parameter, metric, and model tracking in data science code runs. The coding possibilities are flexible:

   - Code can be in SQL, Python, R, and Scala.
   - Code can use popular open-source libraries and frameworks such as Koalas, Pandas, and scikit-learn, which are preinstalled and optimized.
   - Users can optimize for performance and cost by using single-node and multiple-node compute options.

1. Machine learning models are available in the following formats:

   - Azure Databricks stores information about models in the [MLflow Model Registry][MLflow Model Registry]. The registry makes models available through batch, streaming, and REST APIs.
   - The solution can also deploy models to Azure Machine Learning web services or Azure Kubernetes Service (AKS).

1. Services that work with the data connect to a single underlying data source to help ensure consistency. For instance, you can run SQL queries on the data lake by using Azure Databricks SQL warehouses. This service:

   - Provides a query editor and catalog, the query history, basic dashboarding, and alerting.
   - Uses integrated security that includes row-level permissions and column-level permissions.
   - Uses a [Photon-powered Delta Engine to improve performance][Photon improves performance].

1. You can mirror gold datasets out of Azure Databricks Unity Catalog into Fabric. Use [Azure Databricks mirroring in Fabric][Databricks mirroring in Fabric] to easily integrate without the need to move or replicate data.

1. Power BI generates analytical and historical reports and dashboards from the unified data platform. This service uses the following features when it works with Azure Databricks:

   - A [built-in Azure Databricks connector][Power BI connector for Azure Databricks] for visualizing the underlying data.
   - Optimized Java Database Connectivity and Open Database Connectivity drivers.
   - You can use [Direct Lake][Direct Lake] with Azure Databricks mirroring in Fabric to load your Power BI semantic models for higher-performance queries. 

1. The solution uses Unity Catalog and Azure services for collaboration, performance, reliability, governance, and security:

   - Azure Databricks Unity Catalog provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces.
   - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.
   - Azure DevOps offers continuous integration and continuous deployment (CI/CD) and other integrated version control features.
   - Azure Key Vault helps you securely manage secrets, keys, and certificates.
   - Microsoft Entra ID and the System for Cross-domain Identity Management (SCIM) provisioning provide single sign-on for Azure Databricks users and groups. Azure Databricks supports automated user provisioning with Microsoft Entra ID to:

     - Create new users and groups.
     - Assign each user an access level.
     - Remove users and denying them access.

   - Azure Monitor collects and analyzes Azure resource telemetry. By proactively identifying problems, this service maximizes performance and reliability.
   - Microsoft Cost Management provides financial governance services for Azure workloads.

### Components

This solution uses the following components.

#### Core components

- [Azure Databricks][Azure Databricks] is a data analytics platform that uses Spark clusters to process large data streams. It cleans and transforms unstructured data and combines it with structured data. It can also train and deploy machine learning models. In this architecture, Azure Databricks serves as the central tool for data ingestion, processing, and serving. It provides a unified environment for managing the entire data lifecycle.

- [Azure Databricks SQL warehouses][Azure Databricks SQL warehouses] are compute resources that you can use to query and explore data on Azure Databricks. In this architecture, you can use SQL endpoints to connect directly to your data from Power BI.

- [Azure Databricks Delta Live Tables][Azure Databricks Delta Live Tables] is a declarative framework for building reliable, maintainable, and testable data processing pipelines. In this architecture, Delta Live Tables helps you define transformations to perform on your data. It also helps you manage task orchestration, cluster management, monitoring, data quality, and error handling within Azure Databricks. 

- [Microsoft Fabric][Microsoft Fabric] is an end-to-end analytics and data platform for organizations that need a unified solution. The platform provides services like Data Engineering, Data Factory, Data Science, Real-Time Intelligence, Data Warehouse, and Databases. This architecture mirrors Unity Catalog tables into Fabric and uses Direct Lake in Power BI for better performance.

- [Data Factory in Microsoft Fabric][Data Factory in Microsoft Fabric] is a modern data integration platform that you can use to ingest, prepare, and transform data from a rich set of data sources in Fabric. This architecture uses built-in connectors to several data sources for quick ingestion into Data Lake Storage or OneLake. Azure Databricks later retrieves and further transforms the batch data.

- [Event Hubs][Event Hubs] is a fully managed, big data streaming platform. As a platform as a service, it provides event ingestion capabilities. This architecture uses Event Hubs for streaming data. Azure Databricks can connect to this data and process it by using Spark Streaming or Delta Live Tables.

- [Data Lake Storage][Azure Data Lake Storage] is a scalable and secure data lake for high-performance analytics. It handles multiple petabytes of data and supports hundreds of gigabits of throughput. Data Lake Storage can store structured, partially structured, and unstructured data. This architecture uses Data Lake Storage to store both batch and streaming data.

- [Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. By using these models, you can forecast behavior, outcomes, and trends. In this architecture, Machine Learning uses data that Azure Databricks transforms for training and inferring models.

- [AKS][Azure Kubernetes Service] is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications. In this architecture, AKS hosts machine learning models in a containerized environment for scalable inferencing.

- [Delta Lake][Databricks Delta Lake] is a storage layer that uses an open file format. This layer runs on top of cloud storage solutions like Data Lake Storage. Delta Lake supports data versioning, rollback, and transactions for updating, deleting, and merging data. In this architecture, Delta Lake works as the primary file format for writing and reading data from Data Lake Storage.

- [MLflow][MLflow] is an open-source platform for managing the machine learning lifecycle. Its components monitor machine learning models during training and operation. In this architecture, similar to Machine Learning, you can use MLflow in Azure Databricks to manage your machine learning lifecycle. Train and infer models by using the Unity Catalog data that you transformed within Azure Databricks.

#### Reporting and governing components

- [Azure Databricks Unity Catalog][Databricks Unity Catalog] provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces. In this architecture, Unity Catalog works as the primary tool within Azure Databricks to manage and secure data access. 

- [Power BI][What is Power BI?] is a collection of software services and apps. These services create and share reports that connect and visualize unrelated sources of data. Together with Azure Databricks, Power BI can provide root cause determination and raw data analysis. This architecture uses Power BI to create dashboards and reports that provide insights into the data that Azure Databricks and Fabric process.

- [Microsoft Purview][What is Microsoft Purview?] manages on-premises, multicloud, and software as a service (SaaS) data. This governance service maintains data landscape maps. Its features include automated data discovery, sensitive data classification, and data lineage. This architecture uses Microsoft Purview to scan and track data that's ingested in Unity Catalog, Fabric, Power BI, and Data Lake Storage.

- [Azure DevOps][DevOps solutions on Azure] is a DevOps orchestration platform. This SaaS provides tools and environments to build, deploy, and collaborate on applications. This architecture uses Azure DevOps to automate the deployment of Azure infrastructure. You can also use GitHub for automation and version control of Azure Databricks code for better collaboration, change tracking, and integration with CI/CD pipelines.

- [Key Vault][Key Vault] stores and controls access to secrets, such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates. This architecture uses Key Vault to store shared access signature keys from Data Lake Storage. These keys are then used in Azure Databricks and other services for authentication.

- [Microsoft Entra ID][Microsoft Entra ID] offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources. This architecture uses Microsoft Entra ID to authenticate and authorize users and services in Azure.

- [SCIM][SCIM] allows you to set up provisioning to the Azure Databricks account by using Microsoft Entra ID. This architecture uses SCIM to manage users who access Azure Databricks workspaces.
  
- [Azure Monitor][Azure Monitor] collects and analyzes data in environments and Azure resources. This data includes app telemetry, such as performance metrics and activity logs. This architecture uses Azure Monitor to monitor the health of compute resources in Azure Databricks and Machine Learning and other components that send logs to Azure Monitor.

- [Cost Management][Microsoft Cost Management] helps you manage cloud spending. By using budgets and recommendations, this service organizes expenses and shows you how to reduce costs. This architecture uses Cost Management to help monitor and control the cost of the entire solution.

## Scenario details

Modern data architectures:

- Unify data, analytics, and AI workloads.
- Run efficiently and reliably at any scale.
- Provide insights through analytics dashboards, operational reports, or advanced analytics.

This solution outlines a modern data architecture that achieves these goals. Azure Databricks forms the core of the solution. This platform works seamlessly with other services. Together, these services provide a solution that is:

- Simple: Unified analytics, data science, and machine learning simplify the data architecture.
- Open: The solution supports open-source code, open standards, and open frameworks. It also works with popular integrated development environments (IDEs), libraries, and programming languages. Through native connectors and APIs, the solution works with a broad range of other services, too.
- Collaborative: Data engineers, data scientists, and analysts work together with this solution. They can use collaborative notebooks, IDEs, dashboards, and other tools to access and analyze common underlying data.

### Potential use cases

The system that Swiss Re Group built for its Property & Casualty Reinsurance division inspired this solution. In addition to the insurance industry, any area that works with big data or machine learning can also benefit from this solution. Examples include:

- The energy sector.
- Retail and e-commerce.
- Banking and finance.
- Medicine and healthcare.

## Next steps

- [Build an end-to-end data pipeline in Azure Databricks][Get-Started with Databricks pipelines]
- [Run your first Delta Live Tables pipeline][Run your first DLT pipeline]

## Related resources

To learn about related solutions, see the following guides and architectures.

### Related architecture guides

- [Compare machine learning products from Microsoft][Compare the machine learning products and technologies from Microsoft]
- [Choose a natural language processing technology][Choosing a natural language processing technology in Azure]
- [Choose a stream processing technology][Choosing a stream processing technology in Azure]

### Related architecture

- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]

[Microsoft Entra ID]: /entra/fundamentals/whatis
[Microsoft Cost Management]: /azure/cost-management-billing/costs/overview-cost-management
[Azure Data Lake Storage]: /azure/storage/blobs/data-lake-storage-introduction
[Azure Databricks]: /azure/well-architected/service-guides/azure-databricks-security
[Azure Databricks SQL warehouses]: /azure/databricks/sql/
[Azure Kubernetes Service]: /azure/well-architected/service-guides/azure-kubernetes-service
[Azure Machine Learning]: /azure/well-architected/service-guides/azure-kubernetes-service
[Azure Monitor]: /azure/azure-monitor/overview
[Compare the machine learning products and technologies from Microsoft]: ../../ai-ml/guide/data-science-and-machine-learning.md
[Choosing a natural language processing technology in Azure]: ../../data-guide/technology-choices/natural-language-processing.md
[Choosing a stream processing technology in Azure]: ../../data-guide/technology-choices/stream-processing.md
[Databricks Delta Lake]: /azure/databricks/delta/
[Event Hubs]: /azure/well-architected/service-guides/event-hubs
[Key Vault]: /azure/key-vault/general/overview
[Medallion model]: /azure/databricks/lakehouse/medallion
[MLflow]: https://mlflow.org
[MLflow Model Registry]: https://www.mlflow.org/docs/latest/registry.html
[Photon improves performance]: /azure/databricks/compute/photon
[Power BI connector for Azure Databricks]: /azure/databricks/integrations/bi/power-bi
[Stream processing with Azure Databricks]: ../../reference-architectures/data/stream-processing-databricks.yml
[DevOps solutions on Azure]: /azure/devops/user-guide/what-is-azure-devops?view=azure-devops
[What is Microsoft Purview?]: /azure/purview/overview
[Databricks mirroring in Fabric]: /fabric/database/mirrored-database/azure-databricks
[What is Power BI?]: /power-bi/fundamentals/power-bi-overview
[Databricks Unity Catalog]: /azure/databricks/data-governance/unity-catalog/
[Get-Started with Databricks pipelines]: /azure/databricks/getting-started/data-pipeline-get-started/
[Run your first DLT pipeline]: /azure/databricks/delta-live-tables/tutorial-pipelines/
[SCIM]: /azure/databricks/admin/users-groups/scim/aad
[Azure Databricks Delta Live Tables]: /azure/databricks/delta-live-tables/
[Microsoft Fabric]: /fabric/get-started/microsoft-fabric-overview
[Data Factory in Microsoft Fabric]: /fabric/data-factory/data-factory-overview
[Direct Lake]: /fabric/get-started/direct-lake-overview
