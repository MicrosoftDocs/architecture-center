This example scenario shows how using a dedicated search service can dramatically increase the relevance of search results for your e-commerce customers.

## Architecture

![Diagram showing an architecture overview of the Azure components involved in an intelligent product search engine for e-commerce.][architecture]

*Download a [Visio file](https://arch-center.azureedge.net/architecture-ecommerce-search.vsdx) of this architecture.*

### Workflow

This scenario covers an e-commerce solution where customers can search through a product catalog.

1. Customers go to the **e-commerce web application** from any device.
2. The product catalog is maintained in an **Azure SQL database** for transactional processing.
3. Azure AI Search uses a **search indexer** to automatically keep its search index up to date through integrated change tracking.
4. Customer's search queries are offloaded to the **AI Search** service, which processes the query and returns the most relevant results.
5. As an alternative to a web-based search experience, customers can also use a **conversational bot** in social media or straight from digital assistants to search for products and incrementally refine their search query and results.
6. Optionally, customers can use the **skillset** feature to apply artificial intelligence for even smarter processing.

### Components

- [Azure App Service - Web Apps](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications allowing autoscale and high availability without having to manage infrastructure.
- [Azure SQL Database][docs-sql-database-service-page] is a general-purpose relational database-managed service in Microsoft Azure that supports structures such as relational data, JSON, spatial, and XML.
- [AI Search][docs-search-service-page] is a cloud solution that provides a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.
- [Azure AI Bot Service][docs-botservice-service-page] provides tools to build, test, deploy, and manage intelligent bots.
- [Azure AI services][docs-ai-services-service-page] lets you use intelligent algorithms to see, hear, speak, understand, and interpret your user needs through natural methods of communication.

### Alternatives

- You could use **in-database search** capabilities, for example, through SQL Server full-text search, but then your transactional store also processes queries (increasing the need for processing power) and the search capabilities inside the database are more limited.
- You could host the open-source [Apache Lucene][apache-lucene] (on which AI Search is built) on Azure Virtual Machines, but then you're back to managing infrastructure as a service (IaaS) and don't benefit from the many features that AI Search provides on top of Lucene.
- You could also consider deploying [Elasticsearch][elastic-marketplace] from Azure Marketplace, which is an alternative and capable search product from a third-party vendor, but also in this case you're running an IaaS workload.

Other options for the data tier include:

- [Azure Cosmos DB](/azure/cosmos-db/introduction) - Microsoft's globally distributed, multi-model database. Azure Cosmos DB provides a platform to run other data models such as MongoDB, Cassandra, Graph data, or simple table storage. AI Search also supports indexing the data from Azure Cosmos DB directly.

## Scenario details

Search is the primary mechanism through which customers find and ultimately purchase products, making it essential that search results are relevant to the *intent* of the search query, and that the end-to-end search experience matches that of search giants by providing near-instant results, linguistic analysis, geo-location matching, filtering, faceting, autocomplete, and hit highlighting.

Imagine a typical e-commerce web application with product data stored in a relational database like SQL Server or SQL Database. Search queries are often handled inside the database by using `LIKE` queries or [full-text search][docs-sql-fts] features. By using [AI Search][docs-search] instead, you free up your operational database from the query processing and you can easily start taking advantage of those hard-to-implement features that provide your customers with the best possible search experience. Also, because AI Search is a platform as a service (PaaS) component, you don't have to worry about managing infrastructure or becoming a search expert.

### Potential use cases

This solution is optimized for the retail industry.

Other relevant use cases include:

- Finding real estate listings or stores near the user's physical location (for the facilities and real-estate industry).
- Searching for articles in a news site or looking for sports results, with a higher preference for more *recent* information (for the sports, media, and entertainment industries).
- Searching through large repositories for *document-centric* organizations, like policy makers and notaries.

Ultimately, *any* application that has some form of search functionality can benefit from a dedicated search service.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Scalability

The [pricing tier][search-tier] of the AI Search service is used mainly for [capacity planning][search-capacity] because it defines the maximum storage you get and how many partitions and replicas you can provision. **Partitions** allow you to index more documents and get higher write throughputs, whereas **replicas** provide more queries per second (QPS) and high availability.

You can dynamically change the number of partitions and replicas, but it's not possible to change the pricing tier. So, you should carefully consider the right tier for your target workload. If you need to change the tier anyway, you need to provision a new service side by side and reload your indexes there, at which point you can point your applications at the new service.

### Availability

AI Search provides a [99.9% availability service-level agreement (SLA)][search-sla] for *reads* (that is, querying) if you have at least two replicas, and for *updates* (that is, updating the search indexes) if you have at least three replicas. Therefore, you should provision at least two replicas if you want your customers to be able to *search* reliably, and three if actual *changes to the index* should also be considered high-availability operations.

If there's a need to make breaking changes to the index without downtime (for example, changing data types, deleting, or renaming fields), the index will need to be rebuilt. Similar to changing service tier, this means creating a new index, repopulating it with the data, and then updating your applications to point at the new index.

### Security

AI Search is compliant with many [security and data privacy standards][search-security], so you can use it in most industries.

To secure access to the service, you can use [Azure role-based access control (RBAC)](/azure/search/search-security-rbac) or connect with [API keys](/azure/search/search-security-api-keys).

We recommend that you use Azure RBAC because it uses Azure roles, which integrate with Microsoft Entra ID. When you use Azure roles, you can also use passwordless authentication methods like [Managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview).

API keys include **admin keys**, which provide full access for all content operations, and **query keys**, which provide read-only access to the documents collection of a search index. You should set up applications that don't need to update the index to use a query key and not an admin key, especially if an end-user device, like a script running in a web browser, performs the search.

You can also secure access to the AI Search service at the network level by [exposing it through a private endpoint](/azure/search/service-create-private-endpoint).

### Search relevance

How successful your e-commerce application is depends largely on the relevance of the search results to your customers. Carefully tuning your search service to provide optimal results based on user research, or relying on [search traffic analysis][search-analysis] to understand your customer's search patterns allows you to make decisions based on data.

Typical ways to tune your search service include:

- Using [scoring profiles][search-scoring] to influence the relevance of search results, for example, based on which field matched the query, how recent the data is, and the geographical distance to the user.
- Using [Microsoft-provided language analyzers][search-languages] that use an advanced natural language processing stack to better interpret queries.
- Using [custom analyzers][search-analyzers] to ensure your products are found correctly, especially if you want to search on non-language based information like a product's make and model.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all the services mentioned previously are preconfigured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected usage.

Consider these sample cost profiles based on the amount of traffic you expect to handle:

- [Small][small-pricing]: This profile uses a single `Standard S1` web app to host the website, the Free tier of the Azure AI Bot Service, a single `Basic` search service, and a `Standard S2` SQL Database.
- [Medium][medium-pricing]: This profile scales up the web app to two instances of the `Standard S3` tier, upgrades the search service to a `Standard S1` tier, and uses a `Standard S6` SQL Database.
- [Large][large-pricing]: This profile uses four instances of a `Premium P2V2` web app, upgrades the Azure AI Bot Service to the `Standard S1` tier (with 1.000.000 messages in Premium channels), and uses two units of the `Standard S3` search service and a `Premium P6` SQL Database.

## Deploy this scenario

To deploy a version of this scenario, you can follow this [step-by-step tutorial][end-to-end-walkthrough] that provides a .NET sample application that runs a job search website. It demonstrates most of the AI Search features discussed thus far.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To learn more about AI Search, visit the [documentation center][docs-search] or check out the [samples][search-samples].

To find out more about other Azure components, see these resources:

- [What is Azure SQL Database?][docs-sql-database]
- [App Service overview][docs-webapps]
- [Azure AI Bot Service documentation][docs-botservice]
- [What is Azure AI services?][docs-ai-services]

## Related resources

- [Build a content-based recommendation system](/azure/architecture/example-scenario/ai/scalable-personalization-with-content-based-recommendation-system)

<!-- links -->
[architecture]: ./_images/architecture-ecommerce-search.png
[docs-sql-fts]: /sql/relational-databases/search/query-with-full-text-search
[docs-search]: /azure/search/search-what-is-azure-search
[docs-search-service-page]: https://azure.microsoft.com/products/ai-services/ai-search
[docs-sql-database]: /azure/sql-database/sql-database-technical-overview
[docs-sql-database-service-page]: https://azure.microsoft.com/products/azure-sql/database
[docs-webapps]: /azure/app-service/app-service-web-overview
[docs-botservice]: /azure/bot-service/
[docs-botservice-service-page]: https://azure.microsoft.com/products/ai-services/ai-bot-service
[docs-ai-services]: /azure/ai-services/what-are-ai-services
[docs-ai-services-service-page]: https://azure.microsoft.com/products/ai-services
[apache-lucene]: https://lucene.apache.org/
[elastic-marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/elastic.ec-azure-pp
[end-to-end-walkthrough]: https://github.com/Azure-Samples/search-dotnet-asp-net-mvc-jobs
[search-sla]: https://go.microsoft.com/fwlink/?LinkId=716855
[search-tier]: /azure/search/search-sku-tier
[search-capacity]: /azure/search/search-capacity-planning
[search-security]: /azure/search/search-security-overview
[search-analysis]: /azure/search/search-traffic-analytics
[search-languages]: /rest/api/searchservice/language-support
[search-analyzers]: /azure/search/index-add-custom-analyzers
[search-scoring]: /rest/api/searchservice/add-scoring-profiles-to-a-search-index
[search-samples]: https://azure.microsoft.com/resources/samples/?service=search&sort=0
[small-pricing]: https://azure.com/e/db2672a55b6b4d768ef0060a8d9759bd
[medium-pricing]: https://azure.com/e/a5ad0706c9e74add811e83ef83766a1c
[large-pricing]: https://azure.com/e/57f95a898daa487795bd305599973ee6
