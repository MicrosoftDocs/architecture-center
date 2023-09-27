This solution shows how to integrate Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions to fully automate and to create data analytics environments. It uses an Azure Databricks cluster to analyze the data. The solution relies on the Federal Aviation Administration (FAA) System Wide Information Management (SWIM) system. SWIM provides a single point of access for near real-time, relevant, and reliable aeronautical, flight, weather, and surveillance information. It delivers the infrastructure, standards, and services needed to optimize the secure exchange of relevant data across the National Airspace System (NAS) and the aviation community. As the digital data-sharing backbone of NextGen, SWIM enables both operational excellence and innovation.

This solution connects to the following FAA SWIM data sources via an Apache Kafka server:

- Traffic Flow Management Service (TFMS) distributes Traffic Flow Management (TFM) data to users via SWIM’s (System Wide Information Management) National Airspace System (NAS) Enterprise Messaging Service (NEMS).
- Time-Based Flow Management (TBFM) enhances National Airspace System efficiency by using the capabilities of the TBFM decision-support tool, a system already deployed at all high altitude air traffic control centers in the contiguous United States.
- SWIM Terminal Data Distribution System (STDDS) converts legacy terminal data collected from airport towers and Terminal Radar Approach Control (TRACON) facilities into easily accessible information, which is published via the National Airspace System (NAS) Enterprise Messaging Service (NEMS).

For information about SWIM, see the [FAA SWIM page](https://www.faa.gov/air_traffic/technology/swim).

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*Progress Chef and HashiCorp Terraform are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" border="false" source="media/faa-swim.svg" alt-text="Diagram that shows an architecture for automating and creating a data analytics environment." lightbox="media/faa-swim.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/faa-swim.vsdx) of this architecture.*

The left side of the diagram shows SWIM and three of its data producers. The right side shows the Azure architecture that connects, ingests and analyzes data coming from these sources.

This solution uses Apache Kafka because of its event-driven architecture. Apache Kafka is an open-source platform that allows you to collect, process, store, and integrate data from various sources in real-time. It's based on the concept of a commit log, which is a record of events that happen in a system. You can use Kafka to publish and/or subscribe to streams of events, and also to transform and analyze them using the Streams API or other external tools like Databricks.

Another important aspect of this architecture is that SWIM uses Solace, so Kafka uses a Solace source connector to connect and ingest the data. Solace provides support for open source and sink connectors that you can build and deploy in your Kafka cluster.

### Workflow

1. SWIM provides data. The architecture diagram shows three of the most common data sources (TFMS, TBFM, and STDDS). The type of information that you want to analyze dictates the data source from SWIM that you need to subscribe to.
1. A Solace source connector connects and ingests the data into Kafka.
1. Messages from Kafka are cleaned, prepped, and parsed in a workspace in Azure Databricks. This Azure Databricks workspace is where data scientists do their work. They use notebooks written in Python, Scala, and/or R that contain the logic they need to parse the data or even train models based on it.
1. Azure Data Lake provides storage.
1. Power BI or Tableau displays the final data.

### Components

- [Azure Databricks](https://azure.microsoft.com/services/databricks). A data analytics platform that's optimized for the Azure cloud.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). A massively scalable and highly secure data lake for high-performance analytics workloads.
- [Power BI](https://powerbi.microsoft.com). An analytics and BI platform that can help you discover insights in your data.
- [SWIM](https://www.faa.gov/air_traffic/technology/swim). A National Airspace System (NAS) information system that provides publicly available FAA data to FAA-approved consumers via Solace Java Message Service (JMS) messaging.
- [Apache Kafka](https://kafka.apache.org). An Apache event streaming platform.

### Alternatives

For ingestion, the solution uses Apache Kafka in a single VM. This design configuration creates a single point of failure, but for a more robust solution, you can use:

- [Apache Kafka in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Apache Kafka for Confluent Cloud](/azure/partner-solutions/apache-kafka-confluent-cloud/overview)

Both are managed services and offer multiple benefits, like SLAs, simplified configuration, and scalability. They're also more expensive.

As an alternative to Power BI, you can use Tableau or another visualization option.

## Scenario details

### Potential use cases

This solution consumes multiple data sources for flight data patterns. It's ideal for the aerospace, aircraft, and aviation industries. It can be used to analyze flight data patterns and to predict future flight patterns. It can also be used to analyze flight data to improve flight safety.

The solution environment is flexible, so it can be extended to analyze other SWIM data sources or similar streamed data sources.

It also shows how to automate and create data analytics environments by using Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions. This automation can be extended to other data analytics environments. For example, you can use it to automate the deployment of an Azure Databricks cluster that analyzes data from a different source.

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

In this solution, two GitHub Actions workflows automate the infrastructure that hosts the data analytics environment. Terraform deploys the infrastructure. After provisioning is complete Chef configures the resources that are required to connect to TFMS, TBFM and STDDS and others if needed.

- **terraform-azure.yml** performs Terraform deployment. It uses Terraform Cloud's remote state. It also creates an Azure Databricks cluster, deploys some starter Python notebooks to test connectivity to the Kafka server, and retrieves messages. It creates all infrastructure with proper naming conventions and tagging.

   :::image type="content" source="media/terraform-azure.png" alt-text="Screenshot that shows the results of the Terraform-Azure GitHub action.":::

- **chef-kafka.yml** performs static code analysis by using ***Cookstyle***, unit tests by using ***Chef InSpec***, and integration tests by using ***Test Kitchen***. These tests ensure the cookbook is properly tested before it's uploaded to Chef Server.

   :::image type="content" source="media/chef-kafka.png" alt-text="Screenshot that shows the results of the Chef-ApacheKafka GitHub action.":::  

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

A key requirement for this architecture is that all traffic must be internal and highly secure. To meet this requirement:

- Virtual network injection is used to deploy Azure Databricks. This deployment method keeps communication between the cluster and Kafka internal.
- The Azure Databricks workspace uses your Azure identity for authentication.
- Network security groups (NSGs) filter network traffic to and from Azure Databricks and Kafka VMs.

For more information about improving the security of your solution, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

If you run this project, your account is billed. For information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

## Deploy this scenario

For information about deploying this solution, workflows, cookbooks, sample notebooks, Terraform files, and more, see the [Azure/SWIMDataIngestion](https://github.com/Azure/SWIMDataIngestion) GitHub repository.
The repository contains step by step instructions to deploy the solution. The deployment process is fully automated using GitHub Actions, but in order for it to work it requires some secrets to be set up in GitHub.

The deployment process is divided into three parts: infrastructure, configuration and visualization.

1. The infrastructure part deploys the following Azure resources:
   - A virtual network
   - Subnets
   - A resource group
   - Kafka server
   - An Azure storage account  
   - Azure Data Lake Storage on top of the storage account
   - NSGs
   - An Azure Databricks workspace created with virtual network injection, so that keeps the traffic internal
1. The configuration part configures the resources that are required to connect to TFMS, TBFM and STDDS and others if needed. Connecting Kafka to SWIM; Request access to SWIM and specify the data source to connect to. Once approved, FAA sends a link to the data source endpoint, user name, password, and port for connection. Here are three of the most common data sources:
   - [STDDS](https://www.faa.gov/air_traffic/technology/swim/stdds). SWIM Terminal Data Distribution System.
   - [TFMS](https://aviationsystems.arc.nasa.gov/atd2-industry-workshop/fuser/TFMS_85328087.html). Traffic Flow Management Service.
   - [TBFM](https://www.faa.gov/air_traffic/publications/atpubs/foa_html/chap18_section_25.html). Time-Based Flow Management.
1. Lastly, connect a visualization dashboard like Power BI or Tableau to Azure Databricks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Marcelo Zambrana](https://www.linkedin.com/in/marcelozambrana) | Senior Software Engineer

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

## Next steps

- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Introduction to Power BI](/training/modules/introduction-power-bi)

## Related resources

- [All aerospace architectures](/azure/architecture/browse/?terms=aircraft)
- [Publisher-Subscriber pattern](../../patterns/publisher-subscriber.yml)
- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
