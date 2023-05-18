This solution shows how to integrate Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions to fully automate and create data analytics environments. It uses an Azure Databricks cluster to analyze the data. The solution uses the Federal Aviation Administration (FAA) System Wide Information Management (SWIM) system. It connects to Traffic Flow Management Service (TFMS) via a Kafka server. For information about SWIM and TFMS, see the [FAA SWIM page](https://www.faa.gov/air_traffic/technology/swim).

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*Progress Chef and HashiCorp Terraform are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" border="false" source="media/faa-swim.svg" alt-text="Diagram that shows an architecture for automating and creating a data analytics environment." lightbox="media/faa-swim.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/faa-swim.vsdx) of this architecture.*

The left side of the diagram shows SWIM and its data producers. The right side shows the Azure architecture.

The solution uses Kafka because the architecture is a Publisher-Subscriber architecture. (Kafka is a messaging system that's based on Publisher-Subscriber.) SWIM uses Solace, so Kafka uses a Solace source connector to ingest the data. Solace provides source and sink connectors that you can build and deploy in your Kafka cluster.

### Workflow

1. SWIM provides data. The architecture diagram shows three of the most common data sources. The type of information that you want to analyze dictates the data source from SWIM that you need to subscribe to.
1. A Solace source connector ingests the data into Kafka.
1. Messages from Kafka are cleaned, prepped, and parsed in Azure Databricks. This is where data scientists do their work. They use notebooks (Python, Scala, or R, for example) that contain the logic they need to parse the data or even train models based on it.
1. Azure Data Lake provides storage.
1. Power BI or Tableau displays the final data.

### Components

- [Azure Databricks](https://azure.microsoft.com/services/databricks). A data analytics platform that's optimized for the Azure cloud. 
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). A massively scalable and highly secure data lake for high-performance analytics workloads.
- [Power BI](https://powerbi.microsoft.com). An analytics and BI platform that can help you discover insights in your data. 
- [SWIM](https://www.faa.gov/air_traffic/technology/swim). A National Airspace System (NAS) information system that provides publicly available FAA data to FAA-approved consumers via Solace Java Message Service (JMS) messaging.
- [Kafka](https://kafka.apache.org). An Apache event streaming platform. 

### Alternatives

For ingestion, the solution uses Kafka in a single VM. This configuration creates a single point of failure. For a more robust solution, you can use:

- [Apache Kafka in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Apache Kafka for Confluent Cloud](/azure/partner-solutions/apache-kafka-confluent-cloud/overview)

Both are managed services and offer multiple benefits, like SLAs, simplified configuration, and scalability. They're also more expensive.

As an alternative to Power BI, you can use Tableau or another visualization option.

## Scenario details

### Potential use cases

This solution consumes multiple data sources for flight data patterns. It's ideal for the aerospace, aircraft, and aviation industries.

The solution environment is flexible, so it can be extended to analyze other SWIM data sources or similar streamed data sources.

### SWIM architecture

SWIM is a NAS information system. It's an FAA cloud-based service that provides publicly available FAA SWIM content to FAA-approved consumers via Solace JMS messaging.

SWIM provides a single point of access for aviation data. Data producers publish data once, and users access the information they need through a single connection. SWIM provides multiple data producers. Depending on the type of data you need, you can subscribe to one or more of them. SWIM has a typical Publisher-Subscriber architecture.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### CI/CD pipeline architecture

This architecture uses GitHub Actions to orchestrate the CI/CD pipeline:

:::image type="content" border="false" source="media/ci-cd-architecture.png" alt-text="Diagram that shows the CI/CD pipeline for the architecture." lightbox="media/ci-cd-architecture.png"::: 

*Download a [Visio file](https://arch-center.azureedge.net/ci-cd-architecture.vsdx) of this architecture.*

- Developers push code to GitHub, either for the infrastructure via Terraform or for configuration via Chef. 
- If the GitHub pull request is approved, it triggers a GitHub Actions workflow.
- The Actions workflow pushes changes in either the infrastructure or in the configurations for Kafka, Azure Databricks, and so on.

#### GitHub workflows

In this solution, two GitHub Actions workflows automate the infrastructure that hosts the data analytics environment. Terraform deploys the infrastructure. Chef configures the resources that are required to connect to TFMS after provisioning is complete.

- **terraform-azure.yml** performs Terraform deployment. It uses Terraform Cloud in the remote state. It also creates an Azure Databricks cluster, deploys a starter Python notebook to test connectivity to the Kafka server, and retrieves messages. It creates all infrastructure with proper naming conventions and tagging.

   :::image type="content" source="media/terraform-azure.png" alt-text="Screenshot that shows the results of the Terraform-Azure GitHub action.":::
 
- **chef-kafka.yml** performs static code analysis by using Cookstyle, unit tests by using Chef InSpec, and integration tests by using Test Kitchen. These tests ensure the cookbook is properly tested before it's uploaded to Chef Server.

   :::image type="content" source="media/chef-kafka.png" alt-text="Screenshot that shows the results of the Chef-ApacheKafka GitHub action.":::  

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

A key requirement for this architecture is that all traffic must be internal and highly secure. To meet this requirement:

- VNet injection is used to deploy Azure Databricks. This deployment method keeps communication between the cluster and Kafka internal.
- The Azure Databricks workspace uses your Azure identity for authentication.
- Network security groups (NSGs) filter network traffic to and from Azure Databricks and Kafka VMs.
 
For more information about improving the security of your solution, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

If you run this project, your account will be billed. For information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

## Deploy this scenario

For information about deploying this solution, workflows, cookbooks, a notebook, Terraform files, and more, see the [Azure/SWIMDataIngestion](https://github.com/Azure/SWIMDataIngestion) GitHub repo.

The following steps summarize deployment of this scenario after the environment is prepared:

1. Configure the Azure resources. The project contains the following components:
   - A virtual network
   - Subnets
   - A resource group
   - Kafka server
   - An Azure Databricks storage account  
   - Azure Data Lake Storage on top of the storage account
   - NSGs
   - An Azure Databricks workspace created with VNet injection, so that it keeps the traffic internal 
1. Connect Kafka to SWIM. You need to request access to SWIM and specify the data source that you want to connect to. FAA will send you a link to the data source endpoint and a user name, password, and port for connection. Here are three of the most common data sources:
   - [STDDS](https://www.faa.gov/air_traffic/technology/swim/stdds). SWIM Terminal Data Distribution System.
   - [TFMS](https://aviationsystems.arc.nasa.gov/atd2-industry-workshop/fuser/TFMS_85328087.html). Traffic Flow Management Service.
   - [TBFM](https://www.faa.gov/air_traffic/publications/atpubs/foa_html/chap18_section_25.html). Time-Based Flow Management.
1. Connect a visualization dashboard like Power BI or Tableau to Azure Databricks. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Marcelo Zambrana](https://www.linkedin.com/in/marcelozambrana) | Senior Cloud Solution Architect

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

## Next steps

- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Introduction to Power BI](/training/modules/introduction-power-bi)

## Related resources

- [All aerospace architectures](/azure/architecture/browse/?terms=aircraft)
- [Predictive maintenance for aircraft monitoring](../../solution-ideas/articles/predictive-maintenance.yml)
- [Publisher-Subscriber pattern](../../patterns/publisher-subscriber.yml)
- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
