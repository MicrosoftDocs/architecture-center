This solution shows you how to integrate Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions in order to fully automate and create Data Analytics environments. It uses a Databricks cluster in order to analyze the data.

It uses Federal Aviation Administration's (FAA's) System Wide Information System (SWIM) and connects to TFMS (Traffic Flow Management System) using a Kafka server. More information about SWIM and TFMS can be found [here]. 

Depending on what kind of information you want to analyze, you need to subscribe to a different data source from SWIM.

## Potential use cases
- This is to consume multiple data sources for flight data patterns. 
- This solution is ideal for the aerospace and aviation industry.

## Architecture

On the left side we have SWIM and its data producers, and on the right side we have our proposed architecture in Azure.

Couple of things to notice here is that we are using Kafka which makes sense since this is a publish and subscribe architecture. SWIM uses solace so we have a solace source connector in Kafka in order to ingest the data. Solace provides source and sink connectors that you can build and deploy in your Kafka cluster.

We have an azure data lake for storage and at the end we could have PowerBI or Tableau to display the final information.

We also have Databricks to clean, prep and parse all the messages coming from Kafka. Here is where Data Scientists are going to be doing their work, have their notebooks (python, Scala, R, etc.) where they can write all the logic, they need in order to properly parse this data or even train some models based on it.

:::image type="content" border="false" source="media/faa-swim.png" alt-text="Diagram that shows an architecture for automating and creating a data analytics environment." lightbox="media/article-folder-name/faa-swim.png"::: 

Download link 

### Workflow

- Once the environment is ready, the Azure side is set up. This project has only created the following components:
   - VNet
   - Subnets 
   - Resource Group
   - Kafka server
   - Storage account: Databricks 
   - Data Lake Gen2 is on top of the storage account.
   - Creates the network security groups.
   - Creates the Databricks workspace with VNet injection, so it keeps all the traffic internal.
- Connect your Kafka to SWIM. You need to request access to SWIM. You need to specify to which data source you need access (that you’re going to connect to). They send you a special link to their data source endpoint with a username, password, and port to connect with. In this diagram, we show three of the most common data sources:
   - [STDDS] - SWIM Terminal Data Distribution System
   - [TFMS] - Traffic Flow Management System
   - [TBFM] - Time-Based Flow Management
- You can then connect a visualization dashboard to Databricks, using Power BI or Tableau, for example.
 
### Components

The following links are the components that we’re using in this solution:
- [SWIM]()
- [Kafka]()
- Azure Databricks
- Azure Data Lake Storage
- Power BI

### Alternatives

In the ingestion part we are using Apache Kafka deployed in a single VM which is a single point of failure, for a more robust solution we could use:
- [Apache Kafka in Azure HDInsight]()
- [Apache Kafka for Confluent Cloud]()

Both are managed services and offer multiple benefits like: SLAs, simplified configuration, scalability and a lot more, but they are also more expensive.

SWIM architecture

The System Wide Information Management or SWIM for short. Is a program part of the National Airspace System NAS in the US. It is a Federal Aviation Administration (FAA) cloud-based service that provides publicly available FAA SWIM content to FAA approved consumers via Solace JMS messaging. 

SWIM's goal is to deliver the right information to the right people at the right time. This information-sharing platform offers a single point of access for aviation data, with producers of data publishing it once and users accessing the information they need through a single connection. And as you can see it has multiple data producers and depending on what type of data you need; you can subscribe to one or more of them. Basically, this is a typical publish and subscribe architecture. So, in Summary SWIM provides access to aviation information through a single connection. The goal is to ingest and analyze it.

## Considerations

### Operational excellence

#### CI/CD pipeline architecture

It uses GitHub Actions in order to orchestrate the CI/CD pipeline.

diagram 2

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

