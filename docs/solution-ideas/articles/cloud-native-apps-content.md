[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for using Azure services to build cloud-native applications.

## Architecture

![Diagram  showing cloud native application data flow with Azure Cosmos DB, Azure Database for PostgreSQL and Azure Cache for Redis.](../media/cloud-native-apps.png)

*Download a [Visio file](https://arch-center.azureedge.net/cloud-native-apps.vsdx) of this architecture.*

### Dataflow

1. Deploy and manage containerized applications easily with a continuous integration and delivery experience (CI/CD), and enterprise grade security and governance.
1. Focus on your app, not the database, with a fully managed database as a service for PostgreSQL. With built-in high availability and the rich feature set of Postgres, you can build design modern experiences free from legacy constraints.
1. Offload database demands by managing sessions state and asset caching with Azure Cache for Redis
1. Alert based on key events such as location or user activity using the serverless compute platform of Azure Functions.
1. Push timely notifications directly to your users on their preferred service or medium.
1. Derive deep insights by analyzing your data with Azure Synapse Analytics, with natively integrated Apache Spark for big data processing and machine learning.
1. Monitor your application's performance for degradation or anomalies, and auto-scale your application to changing performance requirements.
1. Track user interactions with your application at scale using Azure Cosmos DB. Easily scale to meet changing demand requirements with a fully managed NoSQL database.
1. Provide near real-time analytics and insight into user interaction by leveraging Azure Synapse Link for Azure Cosmos DB HTAP capabilities.
1. Finally, surface powerful visualizations of predictive, real-time, and historical transaction data using Power BI.

### Components

- [Azure Kubernetes Service](/azure/aks/intro-kubernetes) allows you to quickly deploy a production ready Kubernetes cluster in Azure.
- [Azure Database for PostgreSQL](/azure/postgresql/overview) is a fully managed relational database service based on the community edition of the open-source PostgreSQL database engine.
- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a secure data cache and messaging broker that provides high throughput and low-latency access to data for applications.
- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a fully managed NoSQL database service for building and modernizing scalable, high performance applications.
- [Azure Notification Hubs](/azure/notification-hubs/notification-hubs-push-notification-overview) sends push notifications from any backend to any mobile device.
- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless compute service that lets you run event-triggered code without having to explicitly provision or manage infrastructure.
- [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is an Apache Spark-based analytics service for big data analytics and AI
- [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extensible Application Performance Management service used to monitor live applications and continuously improve performance and usability.
- [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) is an analytics service that brings together enterprise data warehousing and Big Data analytics within a unified experience.
- [Power BI](/power-bi/fundamentals/power-bi-overview) is a suite of business tools for self-service and enterprise business intelligence (BI). Here, it's used to analyze and visualize data.

## Scenario details

Cloud-native applications are a key part of a successful digital transformation strategy. These applications use technologies like microservices, containers, managed services, and CI/CD. As a result, these apps offer advantages, such as agility, scalability, and reduced time to market, over other apps.

This solution uses various cloud-native technologies:

- containerized applications somehow mention AKS
- A CI/CD experience
- The Functions serverless compute platform
- fully managed cloud services:
  - database as a service for PostgreSQL
  - a fully managed Azure Cosmos DB
  - Azure Cache for Redis
  - Synapse for analytics

This solution also uses ML, Synapse for analytics to meet customer needs by responding to events in real time.


### Potential use cases

Organizations can build cloud-native applications using Azure managed databases, Azure Kubernetes Service, and analytics/ML for applications that are incredibly responsive to customer needs.

## Next steps

- Read about customers that are building cloud-native applications on Azure: [Mars Veterinary Health](https://customers.microsoft.com/story/815549-pet-care-leader-turns-monolith-app-into-a-global-distributed-solution-on-azure) and [Chipotle Mexican Grill](https://customers.microsoft.com/story/787157-chipotle-retailers-azure)
- Learn more about how [Azure Synapse Link](/azure/cosmos-db/synapse-link) can enable you to run near real-time analytics over operational data in Azure Cosmos DB, and [explore common use cases](/azure/cosmos-db/synapse-link-use-cases) like real-time personalization, predictive maintenance and anomaly detection in IoT scenarios, and supply chain analytics, forecasting, and reporting.

## Related resources

- Learn more about [building a microservices architecture](../../microservices/index.yml) on Azure
- Learn more about [building serverless applications](../../serverless/code.yml) on Azure
