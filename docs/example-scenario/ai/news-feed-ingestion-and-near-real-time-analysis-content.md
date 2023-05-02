<!-- cSpell:ignore newsfeeds njray Redlock -->

This example scenario describes a pipeline for mass ingestion and near real-time analysis of documents coming from public RSS news feeds.  It uses [Azure Cognitive Services](/azure/cognitive-services/what-are-cognitive-services) to provide useful insights based on text translation, facial recognition, and sentiment detection. Specifically, image and natural language processing steps are connected together in a messaging pipeline based on [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview). The output of the pipeline is a notification containing the insight or analysis.

## Architecture

![Architecture diagram: ingest and analyze RSS feeds using image and text processing and send notifications.][architecture]

*Download a [Visio file][visio-download] of this architecture.*

### Dataflow

The data flows through the solution as follows:

1. An RSS news feed acts as the generator that obtains data from a document or article. For example, with an article, data typically includes a title, a summary of the original body of the news item, and sometimes images.

2. A generator or ingestion process inserts the article and any associated images into an Azure Cosmos DB [Collection][collection].

3. A notification triggers an ingest function in Azure Functions that stores the article text in Azure Cosmos DB and the article images (if any) in Azure Blob Storage.  The article is then passed to the next queue.

4. A translate function is triggered by the queue event. It uses the [Translate Text API][translate-text] of Azure Cognitive Services to detect the language, translate if necessary, and collect the sentiment, key phrases, and entities from the body and the title. Then it passes the article to the next queue.

5. A detect function is triggered from the queued article. It uses the [Computer Vision][vision] service to detect objects, landmarks, and written words in the associated image, then passes the article to the next queue.

6. A face function is triggered from the queued article. It uses the [Azure Face API][face] service to detect faces for gender and age in the associated image, then passes the article to the next queue.

7. When all functions are complete, the notify function is triggered. It loads the processed records for the article and scans them for any results you want. If found, the content is flagged and a notification is sent to the system of your choice.

At each processing step, the function writes the results to Azure Cosmos DB. Ultimately, the data can be used as desired. For example, you can use it to enhance business processes, locate new customers, or identify customer satisfaction issues.

### Components

The following list of Azure components is used in this example.

- [Azure Storage][storage] is used to hold raw image and video files associated with an article. A secondary storage account is created with Azure App Service and is used to host the Azure Function code and logs.

- [Azure Cosmos DB][cosmos-db] holds article text, image, and video tracking information. The results of the Cognitive Services steps are also stored here.

- [Azure Functions][functions] executes the function code used to respond to queue messages and transform the incoming content. [Azure App Service][aas] hosts the function code and processes the records serially. This scenario includes five functions: Ingest, Transform, Detect Object, Face, and Notify.

- [Azure Service Bus][service-bus] hosts the Azure Service Bus queues used by the functions.

- [Azure Cognitive Services][acs] provides the AI for the pipeline based on implementations of the [Computer Vision][vision] service, [Face API][face], and [Translate Text][translate-text] machine translation service.

- [Azure Application Insights][aai] provides analytics to help you diagnose issues and to understand functionality of your application.

### Alternatives

- Instead of using a pattern based on *queue notification* and Azure Functions, you could use a *topic and subscription* pattern for this data flow. [Azure Service Bus Topics][topics] can be used to process the various parts of the article in parallel as opposed to the serial processing done in this example. For more information, compare [queues and topics][queues-topics].

- Use [Azure Logic Apps][logic-app] to implement the function code and implement record-level locking such as that provided by the [Redlock algorithm][redlock] (which is needed for parallel processing until Azure Cosmos DB supports [partial document updates][partial]). For more information, [compare Functions and Logic Apps][compare].

- Implement this architecture using customized AI components rather than existing Azure services. For example, extend the pipeline using a customized model that detects certain people in an image as opposed to the generic people count, gender, and age data collected in this example. To use customized machine learning or AI models with this architecture, build the models as RESTful endpoints so they can be called from Azure Functions.

- Use a different input mechanism instead of RSS feeds. Use multiple generators or ingestion processes to feed Azure Cosmos DB and Azure Storage.

- [Azure Cognitive Search](/azure/search) is an AI feature in Azure Search that can also be used to extract text from images, blobs, and other unstructured data sources.

## Scenario details

This scenario contains examples for [English][english], [Russian][russian], and [German][german] news feeds, but you can easily extend it to other RSS feeds and other languages. For ease of deployment, the data collection, processing, and analysis are based entirely on Azure services.

### Potential use cases

While this scenario is based on processing of RSS feeds, it's relevant to any document, website, or article where you would need to:

- Translate text to a language of choice.
- Find key phrases, entities, and user sentiment in digital content.
- Detect objects, text, and landmarks in images associated with a digital article.
- Detect people by gender and age in images associated with digital content.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

For simplicity, this example scenario uses only a few of the available APIs and services from Azure Cognitive Services. For example, text in images can be analyzed using the [Text Analytics API][text-analytics]. The target language in this scenario is assumed to be English, but you can change the input to any [supported language][language].

### Scalability

Azure Functions scaling depends on the [hosting plan][plan] you use. This solution assumes a [Consumption plan][plan-c], in which compute power is automatically allocated to the functions when required. You pay only when your functions are running. Another option is to use a [Dedicated plan][plan-ded], which allows you to scale between tiers to allocate a different amount of resources.

With Azure Cosmos DB, the key is to distribute your workload roughly evenly among a sufficiently large number of [partition keys][keys]. There's no limit to the total amount of data that a container can store or to the total amount of
[throughput][throughput] that a container can support.

### Management and logging

This solution uses [Application Insights][aai] to collect performance and logging information. An instance of Application Insights is created with the deployment in the same resource group as the other services needed for this deployment.

To view the logs generated by the solution:

1. Go to [Azure portal][portal] and navigate to the resource group created for the deployment.

2. Select the **Application Insights** instance.

3. From the **Application Insights** section, navigate to **Investigate\\Search** and search the data.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Azure Cosmos DB uses a secured connection and shared access signature through the C\# SDK provided by Microsoft. There are no other externally facing surface areas. Learn more about security [best practices][db-practices] for Azure Cosmos DB.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Azure Cosmos DB is powerful but incurs the greatest [cost][db-cost] in this deployment. You can use another storage solution by refactoring the Azure Functions code provided.

Pricing for Azure Functions varies depending on the [plan][function-plan] it runs in.

## Deploy this scenario

> [!NOTE]
> You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][free] before you begin.

All the code for this scenario is available in the [GitHub][github] repository. This repository contains the source code used to build the generator application that feeds the pipeline for this demo.

## Next steps

* [Choosing an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
* [Choosing a data analytics technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
* [Choosing a big data storage technology in Azure](../../data-guide/technology-choices/data-storage.md)
* [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
* [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
* [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

## Related resources

Additional analytics architectures:

* [Automated enterprise BI](../../reference-architectures/data/enterprise-bi-adf.yml)
* [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
* [Data warehousing and analytics](../data/data-warehouse.yml)
* [Mass ingestion and analysis of news feeds on Azure](./news-feed-ingestion-and-near-real-time-analysis.yml)
* [Stream processing with Azure Databricks](../../reference-architectures/data/stream-processing-databricks.yml)
* [Stream processing with Azure Stream Analytics](../../reference-architectures/data/stream-processing-stream-analytics.yml)

[architecture]: ./media/mass-ingestion-newsfeeds-architecture.svg
[visio-download]: https://arch-center.azureedge.net/news-feed-ingestion-and-near-real-time.vsdx
[aai]: /azure/azure-monitor/app/app-insights-overview
[aas]: https://azure.microsoft.com/try/app-service
[acs]: https://azure.microsoft.com/services/cognitive-services/directory
[collection]: /rest/api/cosmos-db/collections
[compare]: /azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps
[cosmos-db]: /azure/cosmos-db/introduction
[db-cost]: https://azure.microsoft.com/pricing/details/cosmos-db
[db-practices]: /azure/cosmos-db/database-security
[english]: https://www.nasa.gov/rss/dyn/breaking_news.rss
[face]: /azure/cognitive-services/face/overview
[free]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[functions]: /azure/azure-functions/functions-overview
[function-plan]: /azure/azure-functions/functions-scale
[german]: http://www.bamf.de/SiteGlobals/Functions/RSS/DE/Feed/RSSNewsfeed_Meldungen
[github]: https://github.com/Azure/cognitive-services
[keys]: /azure/cosmos-db/partition-data
[language]: /azure/cognitive-services/translator/reference/v3-0-languages
[logic-app]: /azure/logic-apps/logic-apps-overview
[queues-topics]: /azure/service-bus-messaging/service-bus-queues-topics-subscriptions
[partial]: https://feedback.azure.com/d365community/idea/eebcd50e-0e25-ec11-b6e6-000d3a4f0858
[plan]: /azure/azure-functions/functions-scale
[plan-c]: /azure/azure-functions/consumption-plan
[plan-ded]: /azure/azure-functions/dedicated-plan
[portal]: https://portal.azure.com
[redlock]: https://redis.io/topics/distlock
[russian]: http://government.ru/all/rss
[service-bus]: /azure/service-bus-messaging
[storage]: /azure/storage/common/storage-account-overview
[throughput]: /azure/cosmos-db/scaling-throughput
[topics]: /azure/service-bus-messaging/service-bus-dotnet-how-to-use-topics-subscriptions
[text-analytics]: /azure/cognitive-services/text-analytics
[translate-text]: /azure/cognitive-services/translator/translator-info-overview
[vision]: /azure/cognitive-services/computer-vision/home
