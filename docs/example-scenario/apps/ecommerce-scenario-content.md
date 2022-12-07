This example scenario walks you through an implementation of an e-commerce front end using Azure platform as a service (PaaS) tools. 

## Architecture

![Diagram that shows a sample scenario architecture for an e-commerce application.][architecture]

*Download a [Visio file][visio-download] of this architecture.*

### Dataflow

This scenario covers purchasing tickets from an e-commerce site, the data flows through the scenario as follows:

1. Azure Traffic Manager routes a user's request to the e-commerce site hosted in Azure App Service.
2. Azure CDN serves static images and content to the user.
3. User signs in to the application through an Azure Active Directory B2C tenant.
4. User searches for concerts using Azure Search.
5. Web site pulls concert details from Azure SQL Database.
6. Web site refers to purchased ticket images in Blob Storage.
7. Database query results are cached in Azure Cache for Redis to improve performance.
8. User submits ticket orders and concert reviews, which are placed in the queue.
9. Azure Functions processes order payment and concert reviews.
10. Cognitive Services provides an analysis of the concert review to determine the sentiment (positive or negative).
11. Application Insights provides performance metrics for monitoring the health of the web application.

### Components

- [Azure CDN][docs-cdn] delivers static, cached content from locations close to users to reduce latency.
- [Azure Traffic Manager][docs-traffic-manager] controls the distribution of user traffic for service endpoints in different Azure regions.
- [App Services - Web Apps][docs-webapps] hosts web applications allowing autoscale and high availability without having to manage infrastructure.
- [Azure Active Directory - B2C][docs-b2c] is an identity management service that enables customization and control over how customers sign up, sign in, and manage their profiles in an application.
- [Storage Queues][docs-storage-queues] stores large numbers of queue messages that can be accessed by an application.
- [Functions][docs-functions] are serverless compute options that allow applications to run on-demand without having to manage infrastructure.
- [Cognitive Services - Sentiment Analysis][docs-sentiment-analysis] uses machine learning APIs and enables developers to easily add intelligent features – such as emotion and video detection; facial, speech, and vision recognition; and speech and language understanding – into applications.
- [Azure Search][docs-search] is a search-as-a-service cloud solution that provides a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.
- [Storage Blobs][docs-storage-blobs] are optimized to store large amounts of unstructured data, such as text or binary data.
- [Azure Cache for Redis][docs-redis-cache] improves the performance and scalability of systems that rely heavily on back-end data stores by temporarily copying frequently accessed data to fast storage located close to the application.
- [Azure SQL Database][docs-sql-database] is a general-purpose relational database managed service that supports structures, such as relational data, JSON, spatial, and XML.
- [Application Insights][docs-application-insights] is designed to help you continuously improve performance and usability by automatically detecting performance anomalies through built-in analytics tools to help understand what users do with an app.

### Alternatives

Many other technologies are available for building a customer-facing application that's focused on e-commerce at scale. These technologies cover both the front end of the application, as well as the data tier.

Other options for the web tier and functions include:

- [Service Fabric][docs-service-fabric] - A platform focused around building distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
- [Azure Kubernetes Service][docs-kubernetes-service] - A platform for building and deploying container-based solutions that can be used as one implementation of a microservices architecture. The platform provides the agility of different components of the application, to scale independently, on demand.
- [Azure Container Instances][docs-container-instances] - A way of quickly deploying and running containers with a short lifecycle. Containers here are deployed to run a quick processing job such as processing a message or performing a calculation and then deprovisioned as soon as they are complete.
- [Service Bus][service-bus] could be used in place of a Storage Queue.

Other options for the data tier include:

- [Azure Cosmos DB](/azure/cosmos-db/introduction): Microsoft's globally distributed, multi-model database. This service provides a platform to run other data models such as MongoDB, Cassandra, Graph data, or simple table storage.

## Scenario details

Many e-commerce websites face seasonality and traffic variability over time. When demand for your products or services takes off, whether predictably or unpredictably, using PaaS tools will allow you to handle more customers and more transactions automatically. Additionally, this scenario takes advantage of cloud economics by paying only for the capacity you use.

This document will help you will learn about various Azure PaaS components and considerations used to bring together to deploy a sample e-commerce application, *Relecloud Concerts*, an online concert-ticketing platform.

### Potential use cases

This solution is optimized for the retail industry. Other relevant use cases include:

- Building an application that needs elastic scale to handle bursts of users at different times.
- Building an application that is designed to operate at high availability in different Azure regions around the world.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

- Consider using the [typical design patterns for availability](/azure/architecture/framework/resiliency/reliability-patterns) when building your cloud application. 
- Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
- For additional considerations concerning availability, see the [availability checklist][availability] in the Azure Architecture Center.

### Scalability

- When building a cloud application be aware of the [typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns).
- Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
- For other scalability topics, see the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency) available in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Consider using the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) where appropriate.
- Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- Consider following a [secure development lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
- Review the blueprint architecture for [Azure PCI DSS compliance][pci-dss-blueprint].

### Resiliency

- Consider using the [circuit breaker pattern][circuit-breaker] to provide graceful error handling should one part of the application not be available.
- Review the [typical design patterns for resiliency](/azure/architecture/framework/resiliency/reliability-patterns) and consider implementing these patterns where appropriate.
- You can find many [recommended practices for App Service][resiliency-app-service] in the Azure Architecture Center.
- Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redundancy] storage for images and queues.
- For a deeper discussion on [resiliency][resiliency], see the relevant article in the Azure Architecture Center.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

- [Small][small-pricing]: This pricing example represents the components necessary to build the out for a minimum production level instance. Here we are assuming a small number of users, numbering only in a few thousand per month. The app is using a single instance of a standard web app that will be enough to enable autoscaling. The other components are each scaled to a basic tier that will allow for a minimum amount of cost but still ensure that there is SLA support and enough capacity to handle a production level workload.
- [Medium][medium-pricing]: This pricing example represents the components indicative of a moderate size deployment. Here we estimate approximately 100,000 users using the system over the course of a month. The expected traffic is handled in a single app service instance with a moderate standard tier. Additionally, moderate tiers of cognitive and search services are added to the calculator.
- [Large][large-pricing]: This pricing example represents an application meant for high scale, at the order of millions of users per month, moving terabytes of data. At this level of usage high performance, premium tier web apps deployed in multiple regions fronted by traffic manager is required. Data consists of the following: storage, databases, and CDN, are configured for terabytes of data.

## Deploy this scenario

To deploy this scenario, you can follow this [step-by-step tutorial][end-to-end-walkthrough] demonstrating how to manually deploy each component. This tutorial also provides a .NET sample application that runs a simple ticket purchasing application. Additionally, there is a Resource Manager template to automate the deployment of most of the Azure resources.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Chris Mason | Senior Manager, Software Engineering

## Next steps

- [Typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns)
- [Secure development lifecycle][secure-development]
- [Resiliency][resiliency]
- [Recommended practices for App Service][resiliency-app-service]

## Related resources

- [Reference architecture for a multi-region web application][multi-region-web-app]
- [eShop on containers reference example][microservices-ecommerce]
- [Circuit Breaker pattern][circuit-breaker]

<!-- links -->

[architecture]: ./media/architecture-ecommerce-scenario.png
[small-pricing]: https://azure.com/e/90fbb6a661a04888a57322985f9b34ac
[medium-pricing]: https://azure.com/e/38d5d387e3234537b6859660db1c9973
[large-pricing]: https://azure.com/e/f07f99b6c3134803a14c9b43fcba3e2f
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.yml
[availability]: /azure/architecture/framework/resiliency/reliability-patterns
[circuit-breaker]: ../../patterns/circuit-breaker.yml
[design-patterns-availability]: /azure/architecture/framework/resiliency/reliability-patterns
[design-patterns-resiliency]: /azure/architecture/framework/resiliency/reliability-patterns
[design-patterns-performance efficiency]: /azure/architecture/framework/scalability/performance-efficiency-patterns
[design-patterns-security]: /azure/architecture/framework/security/security-patterns
[docs-application-insights]: https://www.microsoft.com/azure/application-insights/app-insights-overview
[docs-b2c]: https://www.microsoft.com/azure/active-directory-b2c/active-directory-b2c-overview
[docs-cdn]: https://www.microsoft.com/azure/cdn/cdn-overview
[docs-container-instances]: https://www.microsoft.com/azure/container-instances
[docs-kubernetes-service]: https://www.microsoft.com/azure/aks
[docs-functions]: https://www.microsoft.com/azure/azure-functions/functions-overview
[docs-redis-cache]: https://www.microsoft.com/azure/redis-cache/cache-overview
[docs-search]: https://www.microsoft.com/azure/search/search-what-is-azure-search
[docs-service-fabric]: https://www.microsoft.com/azure/service-fabric
[docs-sentiment-analysis]: https://www.microsoft.com/azure/cognitive-services/welcome
[docs-sql-database]: https://www.microsoft.com/azure/sql-database/sql-database-technical-overview
[docs-storage-blobs]: https://www.microsoft.com/azure/storage/blobs/storage-blobs-introduction
[docs-storage-queues]: https://www.microsoft.com/azure/storage/queues/storage-queues-introduction
[docs-traffic-manager]: https://www.microsoft.com/azure/traffic-manager/traffic-manager-overview
[docs-webapps]: https://www.microsoft.com/azure/app-service/app-service-web-overview
[end-to-end-walkthrough]: https://github.com/Azure/fta-customerfacingapps/tree/master/ecommerce/articles
[microservices-ecommerce]: https://github.com/dotnet-architecture/eShopOnContainers
[multi-region-web-app]: ../../reference-architectures/app-service-web-app/multi-region.yml
[pci-dss-blueprint]: /azure/security/blueprints/payment-processing-blueprint
[resiliency-app-service]: ../../checklist/resiliency-per-service.md#app-service
[resiliency]: /azure/architecture/framework/resiliency/principles
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[secure-development]: https://www.microsoft.com/SDL/process/design.aspx
[service-bus]: /azure/service-bus-messaging
[sql-geo-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redundancy]: /azure/storage/common/storage-redundancy-grs
[visio-download]: https://arch-center.azureedge.net/architecture-ecommerce-scenario.vsdx
