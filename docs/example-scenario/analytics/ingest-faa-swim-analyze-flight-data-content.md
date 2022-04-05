This solution shows how to integrate Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions to fully automate and create data analytics environments. It uses an Azure Databricks cluster to analyze the data.

The solution uses the Federal Aviation Administration (FAA) System Wide Information Management (SWIM) system. It connects to TFMS (Traffic Flow Management Service) via a Kafka server. For information about SWIM and TFMS, see the [FAA SWIM page](https://www.faa.gov/air_traffic/technology/swim). 

The type of information that you want to analyze dictates the data source from SWIM that you need to subscribe to.

apache note 

## Potential use cases
This solution consumes multiple data sources for flight data patterns. It's ideal for the aerospace and aviation industries.

The solution environment is flexible, so it can be extended to analyze other SWIM data sources or similar streamed data sources. 

## Architecture

:::image type="content" border="false" source="media/faa-swim.png" alt-text="Diagram that shows an architecture for automating and creating a data analytics environment." lightbox="media/faa-swim.png"::: 

Download link 

The left side of the diagram shows SWIM and its data producers. The right side shows the Azure architecture.

The solution uses Kafka, which makes sense because the architecture is a Publisher-Subscriber architecture. (Kafka is a messaging system that's based on Publisher-Subscriber.) SWIM uses Solace, so Kafka uses a Solace source connector to ingest the data. Solace provides source and sink connectors that you can build and deploy in your Kafka cluster.

Azure Data Lake provides storage, and Power BI or Tableau displays the final data.

The messages from Kafka are cleaned, prepped, and parsed in Azure Databricks. This is where data scientists do their work. They use notebooks (Python, Scala, R, for example) that contain the logic they need to parse the data or even train models based on it.

### Workflow

- After the environment is ready, the Azure side is set up. This project has the following components:
   - A virtual network
   - Subnets 
   - A resource group
   - Kafka server
   - An Azure Databricks storage account  
   - Azure Data Lake Storage on top of the storage account
   - Network security groups (created in the script)
   - An Azure Databricks workspace created with VNet injection, so it keeps all the traffic internal (created in the script)
- Connect Kafka to SWIM. You need to request access to SWIM. You need to specify the data source you're going to connect to. FAA will send you a link to the data source endpoint and a user name, password, and port to connect with. Three of the most common data sources are shown in the diagram:
   - [STDDS](https://www.faa.gov/air_traffic/technology/swim/stdds). SWIM Terminal Data Distribution System
   - [TFMS](https://aviationsystems.arc.nasa.gov/atd2-industry-workshop/fuser/TFMS_85328087.html). Traffic Flow Management Service
   - [TBFM](https://www.faa.gov/air_traffic/publications/atpubs/foa_html/chap18_section_25.html). Time-Based Flow Management
- You can then connect a visualization dashboard to Azure Databricks. Power BI or Tableau, for example.
 
### Components

- [Azure Databricks](https://azure.microsoft.com/services/databricks). A data analytics platform that's optimized for the Azure cloud. 
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). A massively scalable and highly secure data lake for high-performance analytics workloads.
- [Power BI](https://powerbi.microsoft.com). An analytics and BI platform that can help you discover insights in your data. 
- [SWIM](https://www.faa.gov/air_traffic/technology/swim). A National Airspace System (NAS) information system that provides publicly available FAA SWIM content to FAA-approved consumers via Solace Java Message Service (JMS) messaging.
- [Kafka](https://kafka.apache.org). An Apache event streaming platform. 

### Alternatives

For ingestion, the solution uses Kafka in a single VM. This configuration creates a single point of failure. For a more robust solution, you can use:
- [Apache Kafka in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Apache Kafka for Confluent Cloud](/azure/partner-solutions/apache-kafka-confluent-cloud/overview)

Both are managed services and offer multiple benefits, like SLAs, simplified configuration, and scalability. They're also more expensive.

## SWIM architecture

SWIM is a NAS information system. It's an FAA cloud-based service that provides publicly available FAA SWIM content to FAA-approved consumers via Solace JMS messaging. 

 This information-sharing platform provides a single point of access for aviation data. Data producers publishing data once, and users access the information they need through a single connection. It provides multiple data producers. Depending on the type of data you need, you can subscribe to one or more of them. It's a typical Publisher-Subscriber architecture. 

## Considerations

### Operational excellence

#### CI/CD pipeline architecture

This architecture uses GitHub Actions to orchestrate the CI/CD pipeline.

:::image type="content" border="false" source="media/ci-cd-architecture.png" alt-text="Diagram that shows the CI/CD pipeline for the architecture." lightbox="media/ci-cd-architecture.png"::: 

download link 

So, putting it all together we have this flow where everything starts with the developers (1) pushing code to GitHub (2) either for the infrastructure side using Terraform (1.1) or the configuration part using Chef (1.2), then reviewing it using pull requests (PRs) and if approved, these trigger the GitHub Actions workflow (3), which result in changes either in the infrastructure (4) or in the configurations (5), such as Kafka, Databricks, and so on.

#### GitHub workflows

There are 2 GitHub Actions workflows that are used to automate the Infrastructure that will host the Data Analytics environment using Terraform for infrastructure and Chef for the post-provisioning configurations required to connect to FAA's System Wide Information System (SWIM) specifically to TFMS (Traffic Flow Management System) data source.
- **Chef-ApacheKafka** - Performs Static code analysis using **Cookstyle**, unit testing using **Chef InSpec**, and Integration tests using **Test Kitchen** to make sure the cookbook is properly tested before uploading it to the Chef Server.

screenshot 

- **Terraform-Azure** - Performs Terraform deployment using Terraform Cloud as remote state. It also creates a Databricks cluster and deploys a starter python notebook to test the connectivity to the Kafka server and retrieves the messages. All the infrastructure is created with proper naming convention and tagging.

screenshot 

### Security 

One of the key requirements for this architecture was that all the traffic must be internal and secured. To accomplish this:
- We deployed DataBricks using VNet injection so the communication between the cluster and the Kafka is internal.
- DataBricks workspace uses your Azure identity for authentication.
- NSGs are in place to to filter network traffic to and from DataBricks and Kafka VMs.
 
For more information about securing your solution, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Be aware that by running this project your account will get billed. See [Overview of the cost optimization pillars](/azure/architecture/framework/cost/overview).

## Deploy this scenario

To deploy this solution, see the GitHub repo, [Azure/SWIMDataIngestion](https://github.com/Azure/SWIMDataIngestion).

## Next steps
Editor: To add links to Docs articles and Learn modules.

## Related resources
Editor: To add links to AAC articles.
- [Predictive maintenance for aircraft monitoring](/azure/architecture/solution-ideas/articles/predictive-maintenance)
- [All aerospace architectures](/azure/architecture/browse/?terms=aircraft)

