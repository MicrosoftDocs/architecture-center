Modern times call for modern master data management (MDM) solutions. Sophisticated data merging techniques provide a proper data foundation for a data-driven business. The CluedIn Data Hub is an end-to-end solution for integrating data into a data pipeline that cleans, prepares, models, governs, enriches, deduplicates, catalogs, and makes data easily available and accessible to businesses.

The CluedIn *eventual connectivity* data integration technique uses a GraphQL database to blend data seamlessly from across many siloed data sources. Eventual connectivity yields better results than classic *extract, transform, load (ETL)* or *extract, load, transform (ELT)* models.

CluedIn provides metrics about the quality of data it ingests into its hub, intelligently detects dirty data, and loads it up to be cleaned by a data engineer. Using modern machine learning techniques, CluedIn lets data stewards, business users, and curators label data and teach the system how to get better at cleaning data automatically over time.

CluedIn includes enterprise-grade governance, for assurance that you can use your data confidently. CluedIn can stream data to systems like Power BI and Azure Machine Learning to easily make the clean, governed data available to the rest of the business. Native support for autoscaling leverages the power of Azure to provide a scalable environment for the biggest data workloads.

## Architecture

![Diagram showing CluedIn architectural structure.](images/cluedin-architecture.png)

- CluedIn ingests data via Azure Data Factory from sources like Azure SQL DB, Azure Cosmos DB, and PostgreSQL and Salesforce databases.

- The CluedIn solution consists of various functional layers that run in a Kubernetes cluster in Azure Kubernetes Service (AKS). A combination of .NET Core microservices handle various distinct functions, from the UI, to queuing, to ingesting and processing large streams of data.

- The CluedIn .NET Core Web API application communicates through a combination of REST and GraphQL calls. All GraphQL, REST, and web sockets run on port 443. Web sockets use a push model, and GraphQL and REST use pull.

- CluedIn handles secure data access with throttling and Cross-Site Request Forgery (CSRF) prevention.

- On the server, the data abstraction application layer communicates with the different data stores through the ports for each store.

- In the persistence layer, databases consume data from the transaction log and persist the data to provide eventual consistency across the different data stores. All the stores run in high-availability (HA) mode.

- The enterprise service bus runs on ports 5672 and 15672 for admin endpoints. Crawlers send data to the bus on the 5672 port. The processing layer consumes data from the bus on port 5672.

- CluedIn stores the processed data in Azure SQL Database or Azure Cache for Redis databases, and provides the data to analytics services to generate insights.

- CluedIn security grants permissions and controls access to different services through Azure Active Directory (Azure AD) role-based access control, backed up with Azure Key Vault and Azure Monitor.

- For development and testing, CluedIn integrates with Azure Pipelines continuous integration and continuous delivery (CI/CD) pipelines.

## Components

The CluedIn solution itself is based on Azure Kubernetes Service (AKS).

CluedIn uses and works with many Azure components, including:

- Azure SQL Database
- Azure Cosmos DB
- Azure Data Lake
- Azure Data Factory
- Azure SQL Database Managed Instance
- Azure Cache for Redis
- Azure Databricks
- Azure Synapse
- Azure SignalR Service
- Azure AD
- Azure Key Vault
- Azure Monitor Log Analytics
- Azure Pipelines

## Considerations

### Security
- CluedIn handles secure data access with throttling and Cross-Site Request Forgery (CSRF) prevention.
- CluedIn security grants permissions and controls access to different services through Azure AD role-based access control, backed up with Azure Key Vault and Azure Monitor.

### Scalability
Native support for autoscaling leverages the power of Azure to provide a scalable environment for the biggest data workloads.

### Availability and resiliency
All the stores run in high-availability (HA) mode.

### DevOps
For development and testing, CluedIn integrates with Azure Pipelines continuous integration and continuous delivery (CI/CD) pipelines.
docker
helm updates