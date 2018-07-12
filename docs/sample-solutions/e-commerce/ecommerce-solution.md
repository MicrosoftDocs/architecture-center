---
title: E-Commerce on Azure Platform as a Service
description: An example of building an e-commerce site using Azure PaaS components
author: masonch
ms.date: <publish or update date>
---
# E-Commerce on Azure Platform as a Service

Azure Platform-as-a-Service (PaaS) enables you to deploy enterprise grade e-commerce applications, and lets you adapt to the size and seasonality of your business. When demand for your products or services takes off — predictably or unpredictably — you can be prepared to handle more customers and more transactions automatically. Additionally, take advantage of cloud economics by paying only for the capacity you use. In short, focus on your sales and leave the infrastructure management to your cloud provider.

This document will help you will learn about various Azure PaaS components and considerations used to bring together to deploy a sample e-commerce application, *Relecloud Concerts*, an online concert ticketing platform.

## Potential use cases

You should consider this solution for the following use cases:

* Building an application that needs elastic scale to handle bursts of users at different times.
* Building an application that is designed to operate at high availability in different Azure regions around the world.

## Architecture diagram

The solution diagram below is an example of this solution:

![Sample solution architecture for an e-commerce application][architecture-diagram]

## Architecture

This solution covers purchasing tickets from an e-commerce site, the data flows through the solution as follows:

1. Azure Traffic Manager routes a user's request to the e-commerce site hosted in Azure App Service.
2. Azure CDN serves static images and content to the user.
3. User signs in to the application through an Azure Active Directory B2C tenant.
4. User searches for concerts using Azure Search.
5. Web site pulls concert details from Azure SQL Database. 
6. Web site refers to purchased ticket images in Blob Storage.
7. Database query results are cached in Azure Redis Cache for better performance.
8. User submits ticket orders and concert reviews which are placed in the queue.
9. Azure Functions processes order payment and concert reviews.
10. Cognitive services provide an analysis of the concert review to determine the sentiment (positive or negative).
11. Application Insights provides performance metrics for monitoring the health of the web application.

### Components

* [Azure CDN][docs-cdn] delivers static, cached content from locations close to users to reduce latency.
* [Azure Traffic Manager][docs-traffic-manager] controls the distribution of user traffic for service endpoints in different Azure datacenters.
* [App Services - Web Apps][docs-webapps] hosts web applications allowing auto-scale and high availability without having to manage infrastructure.
* [Azure Active Directory - B2C][docs-b2c] is an identity management service that enables customization and control over how customers sign up, sign in, and manage their profiles in an application.
* [Storage Queues][docs-storage-queues] stores large numbers of queue messages that can be accessed by an application.
* [Functions][docs-functions] are serverless compute options that allow applications to run on-demand without having to manage infrastructure.
* [Cognitive Services - Sentiment Analysis][docs-sentiment-analysis] uses machine learning APIs and enables developers to easily add intelligent features – such as emotion and video detection; facial, speech and vision recognition; and speech and language understanding – into applications.
* [Azure Search][docs-search] is a search-as-a-service cloud solution that provides a rich search experience over private, heterogenous content in web, mobile, and enterprise applications.
* [Storage Blobs][docs-storage-blobs] are optimized to store large amounts of unstructured data, such as text or binary data.
* [Redis Cache][docs-redis-cache] improves the performance and scalability of systems that rely heavily on backend data-stores by temporarily copying frequently accessed data to fast storage located close to the application.
* [SQL Database][docs-sql-database] is a general-purpose relational database managed service in Microsoft Azure that supports structures such as relational data, JSON, spatial, and XML.
* [Application Insights][docs-application-insights] is designed to help you continuously improve performance and usability by automatically detecting performance anomalies through built-in analytics tools to help understand what users do with an app.

### Alternatives

Many other technologies are available for building a customer facing application focused on e-commerce at scale. These cover both the front end of the application as well as the data tier.

Other options for the web tier and functions include:

* [Service Fabric][docs-service-fabric] - A platform focused around building distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
* [Azure Kubernetes Service][docs-kubernetes-service] - A platform for building and deploying container based solutions which can be used as one implementation of a microservices architecture. This allows for agility of different components of the application to be able to scale independently on demand.
* [Azure Container Instances][docs-container-instances] - A way of quickly deploying and running containers with a short lifecycle. Containers here are usually deployed to run a quick processing job such as processing a message or performing a calculation and then deprovisioned as soon as they are complete.

Other options for the data tier include:

* [Cosmos DB][docs-cosmosdb] - Microsoft's globally distributed, multi-model database. This provides a platform to run other data models such as Mongo DB, Cassandra, Graph data, or simple table storage.

### Availability

* Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.
* Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For additional considerations concerning availability, please see the [availability checklist][availability] in the architecture center.

### Scalability

* When building a cloud application be aware of the [typical design patterns for scalability][design-patterns-scalability].
* Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For other scalability topics please see the [scalability checklist][scalability] available in the architecture center.

### Security

* Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.
* Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
* Consider following a [secure development lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
* Review the blueprint architecture for [Azure PCI DSS compliance][pci-dss-blueprint].

### Resiliency

* Consider leveraging the [circuit breaker pattern][circuit-breaker] to provide graceful error handling should one part of the application not be available.
* Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.
* You can find a number of [resiliency recommended practices for App Service][resiliency-app-service] on the architecture center.
* Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redudancy] storage for images and queues.
* For a deeper discussion on [resiliency][resiliency] please see the relevant article in the architecture center.

## Deploy the solution

To deploy this solution, you can follow this [step-by-step tutorial][end-to-end-walkthrough] demonstrating how to manually deploy each component of the solution. This tutorial also provides a .NET sample application that runs a simple ticket purchasing application. It also includes an ARM template to automate the deployment of the majority of the Azure services that are used in the solution.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: This represents the components necessary to build the out for a minimum production level instance. Here we are assuming a small amount of users, numbering only in a few thousand per month. The app is using a single instance of a standard web app which will be enough to enable autoscaling. Each of the other components are scaled to a basic tier which will allow for a minimum amount of cost but still ensure that there is SLA support for each solution and enough capacity to handle a production level workload.
* [Medium][medium-pricing]: This represents the components indicative of a moderate size solution. Here we estimate approximately 100,000 users using the system over the course of a month. We have the solution running in a single app service instance with a moderate standard tier. We have allocated moderate tiers of cognative service and search services as well.
* [Large][large-pricing]: This represents an application meant for high level scale on the range of millions of users per month moving through terabytes of data. This solution is now using high performance, premium tier web apps deployed in multiple regions fronted by traffic manager. The data solutions: storage, databases, and CDN, are configured for terabytes of data.

## Related Resources

* [Reference Architecture for Multi-Region Web Application][multi-region-web-app]
* [eShop on Containers Reference Example][microservices-ecommerce]

<!-- links -->
[small-pricing]: https://azure.com/e/90fbb6a661a04888a57322985f9b34ac
[medium-pricing]: https://azure.com/e/38d5d387e3234537b6859660db1c9973
[large-pricing]: https://azure.com/e/f07f99b6c3134803a14c9b43fcba3e2f
[app-service-reference-architecture]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/
[architecture-diagram]: ./media/architecture-diagram-ecommerce-solution.png
[availability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/availability
[circuit-breaker]: https://docs.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker
[design-patterns-availability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/availability
[design-patterns-resiliency]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/security
[docs-application-insights]: https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview
[docs-b2c]: https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-overview
[docs-cdn]: https://docs.microsoft.com/en-us/azure/cdn/cdn-overview
[docs-container-instances]: https://docs.microsoft.com/en-us/azure/container-instances/
[docs-kubernetes-service]: https://docs.microsoft.com/en-us/azure/aks/
[docs-cosmosdb]: https://docs.microsoft.com/en-us/azure/cosmos-db/
[docs-functions]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview
[docs-redis-cache]: https://docs.microsoft.com/en-us/azure/redis-cache/cache-overview
[docs-search]: https://docs.microsoft.com/en-us/azure/search/search-what-is-azure-search
[docs-service-fabric]: https://docs.microsoft.com/en-us/azure/service-fabric/
[docs-sentiment-analysis]: https://docs.microsoft.com/en-us/azure/cognitive-services/welcome
[docs-sql-database]: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-technical-overview
[docs-storage-blobs]: https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction
[docs-storage-queues]: https://docs.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction
[docs-traffic-manager]: https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview
[docs-webapps]: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview
[end-to-end-walkthrough]: https://github.com/Azure/fta-customerfacingapps/tree/master/ecommerce/articles
[microservices-ecommerce]: https://github.com/dotnet-architecture/eShopOnContainers
[multi-region-web-app]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/multi-region
[pci-dss-blueprint]: https://docs.microsoft.com/en-us/azure/security/blueprints/payment-processing-blueprint
[resiliency-app-service]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[secure-development]: https://www.microsoft.com/en-us/SDL/process/design.aspx
[sql-geo-replication]: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redudancy]: https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy-grs
