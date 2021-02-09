


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This gaming solution architecture elastically scales your database to accommodate unpredictable bursts of traffic and deliver low-latency multi-player experiences on a global scale. This specific scenario is based on a gaming scenrio, but the design patterns are relevant for many industries requiring the process high-traffic web calls and API requests such as e-commerce, retail, and healthcare.

## Architecture

This architecture includes the following components:

Web app. A typical modern application might include both a website and one or more RESTful web APIs. A web API might be consumed by browser clients through AJAX, by native client applications, or by server-side applications. For considerations on designing web APIs, see API design guidance.
Front Door. Front Door is a layer 7 load balancer. In this architecture, it routes HTTP requests to the web front end. Front Door also provides a web application firewall (WAF) that protects the application from common exploits and vulnerabilities.
Function App. Use Function Apps to run background tasks. Functions are invoked by a trigger, such as a timer event or a message being placed on queue. For long-running stateful tasks, use Durable Functions.
Queue. In the architecture shown here, the application queues background tasks by putting a message onto an Azure Queue storage queue. The message triggers a function app. Alternatively, you can use Service Bus queues. For a comparison, see Azure Queues and Service Bus queues - compared and contrasted.
Cache. Store semi-static data in Azure Cache for Redis.
CDN. Use Azure Content Delivery Network (CDN) to cache publicly available content for lower latency and faster delivery of content.
Data storage. Use Azure SQL Database for relational data. For non-relational data, consider Cosmos DB.
Azure Cognitive Search. Use Azure Cognitive Search to add search functionality such as search suggestions, fuzzy search, and language-specific search. Azure Search is typically used in conjunction with another data store, especially if the primary data store requires strict consistency. In this approach, store authoritative data in the other data store and the search index in Azure Search. Azure Search can also be used to consolidate a single search index from multiple data stores.
Azure DNS. Azure DNS is a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

![Architecture Diagram](../media/gaming-using-cosmos-db.png)
*Download an [SVG](../media/gaming-using-cosmos-db.svg) of this architecture.*
