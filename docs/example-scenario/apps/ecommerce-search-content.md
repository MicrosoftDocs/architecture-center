This example scenario shows how using a dedicated search service can dramatically increase the relevance of search results for your e-commerce customers.

## Architecture

![Diagram showing an architecture overview of the Azure components involved in an intelligent product search engine for e-commerce.][architecture]

*Download a [Visio file](https://arch-center.azureedge.net/architecture-ecommerce-search.vsdx) of this architecture.*

### Workflow

This scenario covers an e-commerce solution where customers can search through a product catalog.

1. Customers navigate to the **e-commerce web application** from any device.
2. The product catalog is maintained in an **Azure SQL Database** for transactional processing.
3. Azure Cognitive Search uses a **search indexer** to automatically keep its search index up-to-date through integrated change tracking.
4. Customer's search queries are offloaded to the **Azure Cognitive Search** service, which processes the query and returns the most relevant results.
5. As an alternative to a web-based search experience, customers can also use a **conversational bot** in social media or straight from digital assistants to search for products and incrementally refine their search query and results.
6. Optionally, the **skillset** feature can be used to apply artificial intelligence for even smarter processing.

### Components

- [App Services - Web Apps][docs-webapps-service-page] hosts web applications allowing autoscale and high availability without having to manage infrastructure.
- [SQL Database][docs-sql-database-service-page] is a general-purpose relational database-managed service in Microsoft Azure that supports structures such as relational data, JSON, spatial, and XML.
- [Azure Cognitive Search][docs-search-service-page] is a search-as-a-service cloud solution that provides a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.
- [Bot Service][docs-botservice-service-page] provides tools to build, test, deploy, and manage intelligent bots.
- [Cognitive Services][docs-cognitive-service-page] lets you use intelligent algorithms to see, hear, speak, understand, and interpret your user needs through natural methods of communication.

### Alternatives

- You could use **in-database search** capabilities, for example, through SQL Server full-text search, but then your transactional store also processes queries (increasing the need for processing power) and the search capabilities inside the database are more limited.
- You could host the open-source [Apache Lucene][apache-lucene] (on which Cognitive Search is built) on Azure Virtual Machines, but then you're back to managing Infrastructure-as-a-Service (IaaS) and don't benefit from the many features that Cognitive Search provides on top of Lucene.
- You could also consider deploying [Elasticsearch][elastic-marketplace] from the Azure Marketplace, which is an alternative and capable search product from a third-party vendor, but also in this case you're running an IaaS workload.

Other options for the data tier include:

- [Azure Cosmos DB](/azure/cosmos-db/introduction) - Microsoft's globally distributed, multi-model database. Azure Cosmos DB provides a platform to run other data models such as MongoDB, Cassandra, Graph data, or simple table storage. Cognitive Search also supports indexing the data from Azure Cosmos DB directly.

## Scenario details

Search is the primary mechanism through which customers find and ultimately purchase products, making it essential that search results are relevant to the _intent_ of the search query, and that the end-to-end search experience matches that of search giants by providing near-instant results, linguistic analysis, geo-location matching, filtering, faceting, autocomplete, hit highlighting, and so on.

Imagine a typical e-commerce web application with product data stored in a relational database like SQL Server or Azure SQL Database. Search queries are often handled inside the database using `LIKE` queries or [Full-Text Search][docs-sql-fts] features. By using [Azure Cognitive Search][docs-search] instead, you free up your operational database from the query processing and you can easily start taking advantage of those hard-to-implement features that provide your customers with the best possible search experience. Also, because Cognitive Search is a platform as a service (PaaS) component, you don't have to worry about managing infrastructure or becoming a search expert.

### Potential use cases

This solution is optimized for the retail industry.

Other relevant use cases include:

- Finding real estate listings or stores near the user's physical location (for the facilities and real-estate industry).
- Searching for articles in a news site or looking for sports results, with a higher preference for more _recent_ information (for the sports, media, and entertainment industries).
- Searching through large repositories for _document-centric_ organizations, like policy makers and notaries.

Ultimately, _any_ application that has some form of search functionality can benefit from a dedicated search service.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

The [pricing tier][search-tier] of the Azure Cognitive Search service is used mainly for [capacity planning][search-capacity] as it defines the maximum storage you get and how many partitions and replicas you can provision. **Partitions** allow you to index more documents and get higher write throughputs, whereas **replicas** provide more Queries-Per-Second (QPS) and High Availability.

You can dynamically change the number of partitions and replicas but it's not possible to change the pricing tier, so you should carefully consider the right tier for your target workload. If you need to change the tier anyway, you'll need to provision a new service side by side and reload your indexes there, at which point you can point your applications at the new service.

### Availability

Cognitive Search provides a [99.9% availability SLA][search-sla] for _reads_ (that is, querying) if you have at least two replicas, and for _updates_ (that is, updating the search indexes) if you have at least three replicas. Therefore you should provision at least two replicas if you want your customers to be able to _search_ reliably, and 3 if actual _changes to the index_ should also be considered high availability operations.

If there's a need to make breaking changes to the index without downtime (for example, changing data types, deleting or renaming fields), the index will need to be rebuilt. Similar to changing service tier, this means creating a new index, repopulating it with the data, and then updating your applications to point at the new index.

### Security

Cognitive Search is compliant with many [security and data privacy standards][search-security], which makes it possible to be used in most industries.

For securing access to the service, Cognitive Search uses two types of keys: **admin keys**, which allow you to perform _any_ task against the service, and **query keys**, which can only be used for read-only operations like querying. Typically, the application that performs the search doesn't update the index, so it should only be configured with a query key and not an admin key (especially if the search is performed from an end-user device like script running in a web browser).

### Search Relevance

How successful your e-commerce application is depends largely on the relevance of the search results to your customers. Carefully tuning your search service to provide optimal results based on user research, or relying on built-in features such as [search traffic analysis][search-analysis] to understand your customer's search patterns allows you to make decisions based on data.

Typical ways to tune your search service include:

- Using [scoring profiles][search-scoring] to influence the relevance of search results, for example, based on which field matched the query, how recent the data is, the geographical distance to the user, ...
- Using [Microsoft provided language analyzers][search-languages] that use an advanced Natural Language Processing (NLP) stack to better interpret queries
- Using [custom analyzers][search-analyzers] to ensure your products are found correctly, especially if you want to search on non-language based information like a product's make and model.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all the services mentioned above are pre-configured in the cost calculator. To see how the pricing would change for your particular use case change the appropriate variables to match your expected usage.

We've provided three sample cost profiles based on amount of traffic you expect to handle:

- [Small][small-pricing]: In this profile, we're using a single `Standard S1` Web App to host the website, the free tier of the Azure Bot service, a single `Basic` search service, and a `Standard S2` SQL Database.
- [Medium][medium-pricing]: Here we're scaling up the Web App to two instances of the `Standard S3` tier, upgrading the search service to a `Standard S1` tier, and using a `Standard S6` SQL Database.
- [Large][large-pricing]: In the largest profile, we use four instances of a `Premium P2V2` Web App, upgrade the Azure Bot service to the `Standard S1` tier (with 1.000.000 messages in Premium channels), use two units of the `Standard S3` search service, and a `Premium P6` SQL Database.

## Deploy this scenario

To deploy a version of this scenario, you can follow this [step-by-step tutorial][end-to-end-walkthrough] that provides a .NET sample application that runs a job search web site. It demonstrates most of the Azure Cognitive Search features discussed thus far.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer

## Next steps

To learn more about Azure Cognitive Search, visit the [documentation center][docs-search], check out the [samples][search-samples], or see a full-fledged [demo site][search-demo] in action.

To find out more about other Azure components, see these resources:

- [What is Azure SQL Database?][docs-sql-database]
- [App Service overview][docs-webapps]
- [Azure Bot Service documentation][docs-botservice]
- [What are Azure Cognitive Services?][docs-cognitive]

## Related resources

- [Visual search in retail with Azure Cosmos DB](/azure/architecture/industries/retail/visual-search-use-case-overview)
- [Migrate your e-commerce solution to Azure](/azure/architecture/industries/retail/migrate-ecommerce-solution)
- [Build a content-based recommendation system](/azure/architecture/example-scenario/ai/scalable-personalization-with-content-based-recommendation-system)
- [Build a real-time recommendation API on Azure](/azure/architecture/reference-architectures/ai/real-time-recommendation)

<!-- links -->
[architecture]: ./media/architecture-ecommerce-search.png
[docs-sql-fts]: /sql/relational-databases/search/query-with-full-text-search
[docs-search]: /azure/search/search-what-is-azure-search
[docs-search-service-page]: https://azure.microsoft.com/products/search
[docs-sql-database]: /azure/sql-database/sql-database-technical-overview
[docs-sql-database-service-page]: https://azure.microsoft.com/products/azure-sql/database
[docs-webapps]: /azure/app-service/app-service-web-overview
[docs-webapps-service-page]: https://azure.microsoft.com/products/app-service/web/
[docs-botservice]: /azure/bot-service/
[docs-botservice-service-page]: https://azure.microsoft.com/products/bot-services
[docs-cognitive]: /azure/cognitive-services/what-are-cognitive-services
[docs-cognitive-service-page]: https://azure.microsoft.com/products/cognitive-services
[apache-lucene]: https://lucene.apache.org/
[elastic-marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/elastic.elasticsearch
[end-to-end-walkthrough]: https://github.com/Azure-Samples/search-dotnet-asp-net-mvc-jobs
[search-sla]: https://go.microsoft.com/fwlink/?LinkId=716855
[search-tier]: /azure/search/search-sku-tier
[search-capacity]: /azure/search/search-capacity-planning
[search-security]: /azure/search/search-security-overview
[search-analysis]: /azure/search/search-traffic-analytics
[search-languages]: /rest/api/searchservice/language-support
[search-analyzers]: /rest/api/searchservice/custom-analyzers-in-azure-search
[search-scoring]: /rest/api/searchservice/add-scoring-profiles-to-a-search-index
[search-samples]: https://azure.microsoft.com/resources/samples/?service=search&sort=0
[search-demo]: https://azjobsdemo.azurewebsites.net/
[small-pricing]: https://azure.com/e/db2672a55b6b4d768ef0060a8d9759bd
[medium-pricing]: https://azure.com/e/a5ad0706c9e74add811e83ef83766a1c
[large-pricing]: https://azure.com/e/57f95a898daa487795bd305599973ee6
