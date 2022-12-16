[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Develop sophisticated, transformational apps using state-of-the-art machine learning algorithms and integrated visualization tools to get actionable insights and analytics.

In this example of an intelligent app, PostgreSQL is the heart of the architecture as the main database for a common AIML use case of social media text analysis. 

## Potential use cases

PostgreSQL's support for unstructured data and ability to execute parallel queries and declarative partitioning makes it an effective database choice for a highly data-intensive AIML task. Since PostgreSQL is a cloud-based solution, this architecture isn't recommended for a mobile application, and it's more appropriate for downstream analysis.

## Architecture

![Architecture Diagram](../media/intelligent-apps-using-azure-database-for-postgresql.png)
*Download a [PNG file](../media/intelligent-apps-using-azure-database-for-postgresql.png) of this architecture.*

### Dataflow

1. A function that's hosted by Functions is triggered as part of an Azure Data Factory pipeline. A Functions *activity* uses a linked service connection to run the function in the Data Factory pipeline.
1. Data comes from various sources, such as Azure Blob Storage and Azure Event Hubs. Data is uploaded to Blob Storage, while Event Hubs ingests a high volume of data. When the system receives new data, the function in the pipeline is triggered.
1. The function calls the Cognitive Services API to analyze the data. For example, for sentiment analysis, the function uses the Text analytics API.
1. The results of the analysis are returned in JSON format from the Cognitive Services API.
1. The function stores the data and results from the Cognitive Services API in Azure Database for PostgreSQL.
1. Azure Machine Learning studio is used to further analyze the data. Custom machine learning algorithms provide other insights into the data. Results from this analysis are stored in Azure Database for PostgreSQL.
   - If you're approaching the machine learning step with a no-code perspective, you can implement further text analytics operations on the data, like feature hashing, Word2Vector, and n-gram extraction.
   - If you prefer a code-first approach, you can use an open-source natural language processing (NLP) model. You can run this model as an experiment in Azure Machine Learning.
1. The PostgreSQL connector for Power BI makes it possible to explore human-interpretable insights in Power BI or a custom web application.

### Components

- [Azure App Service](https://azure.microsoft.com/services/app-service) provides a fully managed platform for quickly building, deploying, and scaling web apps and APIs.
- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. For information about how to use an activity to run a function as part of a Data Factory pipeline, see [Azure Function activity in Azure Data Factory](/azure/data-factory/control-flow-azure-function-activity).
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a fully managed big data streaming platform.
- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) provides a suite of AI services and APIs that you can use to build cognitive intelligence into apps.
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service. It provides [high availability](https://www.azure.cn/support/sla/postgresql), elastic scaling, patching, and other management capabilities for PostgreSQL.
- [Azure Machine Learning studio](/azure/machine-learning/overview-what-is-machine-learning-studio) is a cloud service that you can use to train, deploy, and automate machine learning models. The studio supports code-first and no-code approaches.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services and apps that display analytics information and help you derive insights from data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Azure Cognitive Services Text Analytics API has a maximum size of 5120 characters for a single document and a maximum request size of 1 MB. [View the data and rate limits](/azure/cognitive-services/text-analytics/concepts/data-limits).

Depending on the volume and velocity of data being ingressed, you can select one of three deployment modes: single server, flexible, and Hyperscale (Citus). Assuming that you would be mining large workloads of customer opinions and reviews, Hyperscale is a recommended solution. Explore the [When to use Azure Database for PostgreSQL Learn Module](/training/modules/intro-to-postgres/5-when-to-use-azure-database-postgres) to understand when to use each deployment mode.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

All data in PostgreSQL is automatically [encrypted](/azure/postgresql/concepts-data-encryption-postgresql) and backed up. You can configure Azure Advanced Threat Protection for further mitigation of threats. Read more at [Advanced Threat Protection in Azure Database for PostgreSQL](/azure/postgresql/concepts-data-access-and-security-threat-protection).

### DevOps

You can configure GitHub Actions to connect to your Azure PostgreSQL database by using its connection string and setting up a workflow. For more information, see [Quickstart: Use GitHub Actions to connect to Azure PostgreSQL](/azure/postgresql/how-to-deploy-github-action).

Additionally, you can automate your Azure Machine Learning lifecycle by using [Azure Pipelines](/azure/devops/pipelines/targets/azure-machine-learning). The [MLOps with Azure ML GitHub repo](https://github.com/Microsoft/MLOpsPython) demonstrates how to operationalize an MLOps workflow and build out a CI/CD pipeline for your project.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Azure Cognitive Services Text Analytics API pricing is determined by the instance selected and the number of transactions per month. For further details, explore the [pricing calculator for Text Analytics here](https://azure.microsoft.com/pricing/details/cognitive-services/text-analytics).

## Next steps

- [Azure Functions overview](/azure/azure-functions/functions-overview)
- [Azure Function activity in Azure Data Factory](/azure/data-factory/control-flow-azure-function-activity)
- [Azure Event Hubs — A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- Call the [Text Analytics REST API using Postman](/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-call-api) synchronously and asynchronously
- [Explore and test the Text Analytics API v3.0](https://westus.dev.cognitive.microsoft.com/docs/services/TextAnalytics-v3-0/operations/Languages)
- [Use DirectQuery to link PostgreSQL to Power BI](/power-bi/connect-data/desktop-directquery-about)
- How to create an [Azure Database for PostgreSQL Hyperscale](/azure/postgresql/tutorial-hyperscale-server-group)
- How to link your [Azure Machine Learning Models in Power BI](/power-bi/connect-data/service-aml-integrate)

## Related resources

- Follow along with this Learn Module and apply the [Text Analytics API](/training/modules/classify-user-feedback-with-the-text-analytics-api)
- Expand your Azure Cognitive Services knowledge and [become a Microsoft Certified Azure AI Engineer](/certifications/azure-ai-engineer)
