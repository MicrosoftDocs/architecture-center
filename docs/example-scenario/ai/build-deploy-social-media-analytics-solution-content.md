To best address customer needs, organizations need to extract insights from social media about their customers. This article presents a solution for analyzing news and social media data. The solution extends the [Azure Social Media Analytics Solution Accelerator](https://github.com/microsoft/Azure-Social-Media-Analytics-Solution-Accelerator), which gives developers the resources needed to build and deploy a social media monitoring platform on Azure in a few hours. That platform collects social media and website data and presents the data in a format that supports the business decision–making process.

*Apache®, [Apache Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/build-deploy-social-media-analytics-solution-architecture.png" alt-text="Architecture diagram that shows how data flows from news and Twitter feeds to dashboards and inferencing apps in a social media analytics solution." lightbox="./media/build-deploy-social-media-analytics-solution-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1996849-build-deploy-social-media-analytics-solution.vsdx) of this architecture.*

### Dataflow

1. Azure Synapse Analytics pipelines ingest external data and store that data in Azure Data Lake. One pipeline ingests data from news APIs. The other pipeline ingests data from the Twitter API.

1. Apache Spark pools in Azure Synapse Analytics are used to process and enrich the data.

1. The Spark pools use the following services:
   - Azure Cognitive Service for Language, for named entity recognition (NER), key phrase extraction, and sentiment analysis
   - Azure Cognitive Services Translator, to translate text
   - Azure Maps, to link data to geographical coordinates

1. The enriched data is stored in Data Lake.

1. A serverless SQL pool in Azure Synapse Analytics makes the enriched data available to Power BI.

1. Power BI Desktop dashboards provide insights into the data.

1. As an alternative to the previous step, Power BI dashboards that are embedded in Azure App Service web apps provide web and mobile app users with insights into the data.

1. As an alternative to steps 5 through 7, the enriched data is used to train a custom machine learning model in Azure Machine Learning.

1. The model is deployed to a Machine Learning endpoint.

1. A managed online endpoint is used for online, real-time inferencing, for instance, on a mobile app (**A**). Alternatively, a batch endpoint is used for offline model inferencing (**B**).

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is an integrated analytics service that accelerates time to insight across data warehouses and big data systems.

- [Cognitive Service for Language](https://azure.microsoft.com/products/cognitive-services/language-service) consists of cloud-based services that provide AI functionality. You can use the REST APIs and client library SDKs to build cognitive intelligence into apps even if you don't have AI or data science skills. Features include:
  - [Named entity recognition (NER)](/azure/cognitive-services/language-service/named-entity-recognition/overview) for identifying and categorizing people, places, organizations, and quantities in unstructured text.
  - [Key phrase extraction](/azure/cognitive-services/language-service/key-phrase-extraction/overview) for identifying key talking points in a post or an article.
  - [Sentiment analysis](/azure/cognitive-services/language-service/sentiment-opinion-mining/overview#sentiment-analysis) for providing insight into the sentiment of posts by detecting positive, negative, neutral, and mixed-sentiment content.

- [Translator](https://azure.microsoft.com/products/cognitive-services/translator) helps you to translate text instantly or in batches across more than 100 languages. This service uses the latest innovations in machine translation. Translator supports a wide range of use cases, such as translation for call centers, multilingual conversational agents, and in-app communication. For the languages that Translator supports, see [Translation](/azure/cognitive-services/translator/language-support#translation).

- [Azure Maps](https://azure.microsoft.com/products/azure-maps) is a suite of geospatial services that help you incorporate location-based data into web and mobile solutions. You can use the location and map data to generate insights, inform data-driven decisions, enhance security, and improve customer experiences. This solution uses Azure Maps to link news and posts to geographical coordinates.

- [Data Lake](https://azure.microsoft.com/solutions/data-lake) is a massively scalable data lake for high-performance analytics workloads.

- [App Service](https://azure.microsoft.com/services/app-service) provides a framework for building, deploying, and scaling web apps. The [Web Apps](https://azure.microsoft.com/services/app-service/web) feature is a service for hosting web applications, REST APIs, and mobile back ends.

- [Machine Learning](https://azure.microsoft.com/products/machine-learning) is a cloud-based environment that you can use to train, deploy, automate, manage, and track machine learning models.

- [Power BI](https://powerbi.microsoft.com) is a collection of analytics services and apps. You can use Power BI to connect and display unrelated sources of data.

### Alternatives

You can simplify this solution by eliminating Machine Learning and the custom machine learning models, as the following diagram shows. For more information, see [Deploy this scenario](#deploy-this-scenario), later in this article.

:::image type="content" source="./media/build-deploy-social-media-analytics-solution-alternative.png" alt-text="Architecture diagram that shows how data flows from news and Twitter feeds to dashboards in a social media analytics solution." lightbox="./media/build-deploy-social-media-analytics-solution-alternative.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1996849-build-deploy-social-media-analytics-solution.vsdx) of this architecture.*

## Scenario details

Marketing campaigns are about more than the message that you deliver. When and how you deliver that message is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction. Those campaigns are often based on social media analysis, which has become increasingly important for companies and organizations around the world. Social media analysis is a powerful tool that you can use to receive instant feedback on products and services, improve interactions with customers to increase customer satisfaction, keep up with the competition, and more. Companies often lack efficient, viable ways to monitor social media conversations. As a result, they miss opportunities to use these insights to inform their strategies and plans.

This article's solution benefits a wide spectrum of social media and news analysis applications. By deploying the solution instead of manually deploying its resources, you can reduce your time to market. You can also:

- Extract news and Twitter posts about a specific subject.
- Translate the extracted text to your preferred language.
- Extract key points and entities from the news and posts.
- Identify the sentiment about the subject.

For instance, to see the latest discussions about Satya Nadella, you enter his name in a query. The solution then accesses news APIs and the Twitter API to provide information about him from around the web.

### Potential use cases

By extracting information about your customers from social media, you can enhance customer experiences, increase customer satisfaction, gain new leads, and prevent customer churn. These applications of social media analytics fall into three main areas:

- Measuring brand health:
  - Capturing customer reactions and feedback for new products or services on social media
  - Analyzing sentiment on social media interactions for a new product or service
  - Capturing the sentiment about a brand and determining whether the overall perception is positive or negative

- Building and maintaining customer relationships:
  - Quickly identifying customer concerns
  - Listening to untagged brand mentions

- Optimizing marketing investments:
  - Extracting insights from social media for campaign analysis
  - Doing targeted marketing optimization
  - Reaching a wider audience by finding new leads and influencers

Marketing is an integral part of every organization. As a result, you can use this social media analytics solution for these use cases in various industries:

- Retail
- Finance
- Manufacturing
- Healthcare
- Government
- Energy
- Telecommunications
- Automotive
- Nonprofit
- Gaming
- Media and entertainment
- Travel, including hospitality and restaurants
- Facilities, including real estate
- Sports

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Use Azure Monitor and Application Insights to monitor the health of Azure resources.
- Review the following resiliency considerations before you implement this solution:
  - [Azure Synapse Analytics](../../checklist/resiliency-per-service.md#azure-synapse-analytics)
  - [App Service](../../checklist/resiliency-per-service.md#app-service)
- For more information about resiliency in Azure, see [Design reliable Azure applications](/azure/architecture/framework/resiliency/app-design).
- For availability guarantees of various Azure components, see the following service level agreements (SLAs):
  - [SLA for Azure Synapse Analytics](https://azure.microsoft.com/support/legal/sla/synapse-analytics/v1_1)
  - [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5)
  - [SLA for Azure Maps](https://azure.microsoft.com/support/legal/sla/azure-maps/v1_0)
  - [SLA for Azure Cognitive Services](https://azure.microsoft.com/support/legal/sla/cognitive-services/v1_1)
  - [SLA for Azure Machine Learning](https://azure.microsoft.com/support/legal/sla/machine-learning-service/v1_0)
  - [SLA for App Service](https://azure.microsoft.com/support/legal/sla/app-service/v1_5)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To estimate the cost of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- For information about Spark pool scaling and node sizes, see [Apache Spark pool configurations in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-pool-configurations).
- You can scale Machine Learning training pipelines up and down based on data size and other configuration parameters.
- Serverless SQL pools are available on demand. [They don't require scaling up, down, in, or out](../data/synapse-exploratory-data-analytics.yml#availability).
- Azure Synapse Analytics supports [Apache Spark 3.1.2, which delivers significant performance improvements over its predecessors](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/speed-up-your-data-workloads-with-performance-updates-to-apache/ba-p/2769467).

## Deploy this scenario

To deploy this solution and run a sample social media analytics scenario, see the deployment guide in [Getting Started](https://github.com/microsoft/Azure-Social-Media-Analytics-Solution-Accelerator#getting-started). That guide helps you set up the [Social Media Analytics Solution Accelerator](https://github.com/microsoft/Azure-Social-Media-Analytics-Solution-Accelerator.git) resources, which the architecture diagram in [Alternatives](#alternatives) shows. The deployment doesn't include the following components: Machine Learning, the managed endpoints, and the App Service web app.

### Prerequisites

- To use the solution accelerator, you need access to an [Azure subscription](https://azure.microsoft.com/free).
- A basic understanding of Azure Synapse Analytics, Azure Cognitive Services, Azure Maps, and Power BI is helpful but not required.
- A news API account is required.
- A Twitter developer account with **Elevated** access to Twitter API features is required.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki) | AI Specialized Cloud Solution Architect

## Next steps

- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Azure Machine Learning documentation](/azure/machine-learning)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [Azure Cognitive Service for Language documentation](/azure/cognitive-services/language-service)
- [What is Azure Cognitive Services Translator?](/azure/cognitive-services/translator/translator-overview)
- [What is Azure Maps?](/azure/azure-maps/about-azure-maps)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Tutorial: Sentiment analysis with Cognitive Services in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/tutorial-cognitive-services-sentiment)
- [Tutorial: Text Analytics with Cognitive Service in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/tutorial-text-analytics-use-mmlspark)

## Related resources

- [Artificial intelligence (AI) architecture design](../../data-guide/big-data/ai-overview.md)
- [Choose a Microsoft cognitive services technology](../../data-guide/technology-choices/cognitive-services.md)
- [Optimize marketing with machine learning](../../solution-ideas/articles/optimize-marketing-with-machine-learning.yml)
- [Spaceborne data analysis with Azure Synapse Analytics](../../industries/aerospace/geospatial-processing-analytics.yml)
