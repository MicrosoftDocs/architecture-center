Online transaction processing (OLTP) systems are the face of your business because they interact directly with customers. By migrating to a dynamically adaptable infrastructure, your business can create and launch products quickly so that customers can use your products sooner.

## Architecture

The following diagram shows an architecture of an OLTP system that runs on a z/OS mainframe before migration to Azure:

:::image type="complex" source="media/ibm-zos-online-transaction-processing-on-zos.svg" alt-text="Diagram of an OLTP architecture on z/OS." lightbox="media/ibm-zos-online-transaction-processing-on-zos.svg" border="false":::
   The diagram shows the architecture of an OLTP application that runs on a z/OS mainframe. An on-premises user accesses the system via a web interface and connects through various communication protocols such as HTTPS, SNA LU 6.2, and Telnet 3270. The system is divided into several layers that are depicted as numbered boxes. Arrows connect the boxes to show how different components interact within the mainframe environment. Box number one includes the communication protocols. Double-sided arrows connect box one with the on-premises user and the TN3270 terminal. Box number two includes transaction managers, including CICS and IMS. Double-sided arrows connect boxes one and two. The application layer includes boxes numbered four and five for front-end and business logic components. Double-sided arrows connect boxes three and four. One arrow points from the application layer to box six, which contains other services. Box number five is the data layer, which contains databases, like DB2 and IMS DB, and VSAM files. A double-sided arrow connects the data layer and the application layer. One arrow points from the data layer to box six. Box number six includes other services, such as security, management, monitoring, and reporting services.
:::image-end:::

### Workflow

The following workflow corresponds to the preceding diagram:

1. Users connect to the mainframe over Transmission Control Protocol (TCP) or Internet Protocol (IP) by using standard mainframe protocols like TN3270 and HTTPS.

1. The transaction managers interact with the users and invoke the application to satisfy user requests.

1. In the front end of the application layer, users interact with the Customer Information Control System (CICS) or Information Management System (IMS) screens or with webpages.

1. The transaction managers use the business logic written in common business-oriented language (COBOL) or Programming Language One (PL/I) to implement the transactions.

1. Application code uses the storage capabilities of the data layer, such as DB2, IMS DB, or VSAM.

1. In addition to transaction processing, other services provide authentication, security, management, monitoring, and reporting. These services interact with all other services in the system.

The following diagram shows how to migrate this architecture to Azure.

:::image type="complex" source="media/ibm-zos-online-transaction-processing-on-azure.svg" alt-text="Diagram that shows an architecture to migrate a z/OS OLTP workload to Azure." lightbox="media/ibm-zos-online-transaction-processing-on-azure.svg" border="false":::
   The diagram shows how to migrate a z/OS OLTP workload to Azure. The architecture is divided into several layers that represent different components and their interactions. Each layer uses numbers and arrows to highlight the flow of data. Layer 1 represents an on-premises user. A double-sided arrow connects the user and Azure ExpressRoute. Layer 2 represents input requests. This layer contains two boxes that are connected by a dotted, double-sided arrow labeled Azure web application firewall. The left box contains icons for Azure Front Door and Azure Traffic Manager. A double-sided arrow connects the left box with an icon that represents the internet. Another double-sided arrow connects the internet icon with Microsoft Entra ID. A box on the right contains icons for Azure Application Gateway and Azure Load Balancer. A double-sided arrow connects this box with a box labeled front end. The box labeled front end is inside of the application layer. It contains icons for Azure API Management, Azure App Service, Azure Kubernetes Service (AKS), and Azure Spring Apps. Three dotted, double-sided arrows connect the front-end box with a box labeled business logic. This box contains icons for Azure Functions, Azure WebJobs, AKS, and Azure Spring Apps. Icons for Azure Service Bus and Azure Queue Storage (asynchronous) are located on top of and below the three arrows. A double-sided arrow connects the application layer with the cache layer. The cache layer contains Azure Cache for Redis. An arrow points from the cache layer to the monitoring layer. In this layer, a dotted arrow passes from Azure Monitor through Azure Monitor logs and to a blue box that contains icons labeled Log Analytics dashboard and alerts. The monitoring layer also includes Application Insights. A dotted arrow points from Application Insights to the blue box. Another arrow points from the application layer to Application Insights. The data layer contains two boxes. One box contains icons for Azure Table Storage and Azure Files. The other box contains Azure SQL, Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Database for MySQL. A double-sided arrow connects the data layer and the application layer.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/ibm-zos-online-transaction-processing-on-azure.vsdx) of this architecture.*

1. Mainframe users are familiar with 3270 terminals and on-premises connectivity. In the migrated system, they interact with Azure applications via the public internet or via a private connection that's implemented via Azure ExpressRoute. Microsoft Entra ID provides authentication.
1. Input requests go to a global load balancer service, like Azure Front Door or Azure Traffic Manager. The load balancer can serve a geographically spread user base. It routes the requests according to rules defined for the supported workloads. These load balancers can coordinate with Azure Application Gateway or Azure Load Balancer to load balance the application layer. The Azure Content Delivery Network service caches static content in edge servers for quick response. A web application firewall (WAF) helps secure the service.
1. The front end of the application layer uses Azure services like Azure App Service to implement application screens and to interact with users. The screens are migrated versions of the mainframe screens.
1. COBOL and PL/I code in the back end of the application layer implement the business logic. The code can use services and features like Azure Functions, WebJobs, and Azure Spring Apps microservices. Applications can run in an Azure Kubernetes Service (AKS) container.
1. An in-memory data store accelerates high-throughput OLTP applications. Examples include In-Memory OLTP, which is a feature of Azure SQL Database and Azure SQL Managed Instance, and Azure Cache for Redis.
1. The data layer can include:

   - Files, tables, and blobs implemented by using Azure Storage.
   - Relational databases from the Azure SQL family.
   - Azure implementations of the PostgreSQL and MySQL open-source databases.
   - Azure Cosmos DB, which is a NoSQL database.

   These stores hold data migrated from the mainframe for the application layer to use.

1. Azure-native services like Application Insights and Azure Monitor proactively monitor the health of the system. You can integrate Azure Monitor Logs by using an Azure dashboard.

### Components

This architecture consists of several Azure cloud services. It's divided into four categories of resources: networking and identity, application, storage, and monitoring. The following sections describe the services for each resource and their roles.

#### Networking and identity

When you design application architecture, it's crucial to prioritize networking and identity components to help ensure security, performance, and manageability during interactions over the public internet or private connections. The following components in the architecture are essential to address this requirement effectively.

- [An Azure WAF](/azure/web-application-firewall/overview) is a web application firewall that protects applications from malicious attacks and common web vulnerabilities, such as SQL injection and cross-site scripting. In this architecture, it secures the migrated mainframe applications by filtering and inspecting incoming traffic to web-facing services.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a layer 7 application delivery controller. In this architecture, it manages HTTP traffic routing and provides load balancing for the migrated mainframe web applications.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a global HTTP load balancer with instant failover capabilities. In this architecture, it accelerates content delivery and ensures high availability for geographically distributed mainframe users.

  - [Content Delivery Network](/azure/cdn/cdn-overview) is a distributed caching service that optimizes static content delivery by storing cached copies on edge servers to enable faster response times for users. It uses network optimizations to improve response for dynamic content. Content Delivery Network is especially useful when the user base is global. In this architecture, it improves performance for mainframe screen elements and static assets across global edge locations.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a private connectivity service that establishes a dedicated connection between on-premises infrastructure and Azure. In this architecture, it provides secure network access for users familiar with mainframe terminal connectivity who require private connections.

[Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a service that distributes incoming network traffic across multiple back-end resources and handles layer 4 TCP and UDP traffic. In this architecture, it balances traffic for containerized applications and microservices that replace mainframe transaction processing components.

- [Traffic Manager](/azure/well-architected/service-guides/traffic-manager/reliability) is a DNS-based traffic routing service that helps distribute user requests across multiple endpoints. In this architecture, it distributes traffic across regional endpoints to optimize availability for mainframe users across different geographic locations.

#### Application

Azure provides managed services that support more secure, scalable, and efficient deployment of applications. The application-tier services that the preceding architecture uses can help you optimize your application architecture.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for containerized applications. AKS simplifies deployment of a managed AKS cluster in Azure by offloading the operational overhead to Azure. In this architecture, it hosts microservices that replace monolithic mainframe transaction processing components like CICS and IMS.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed service for building, deploying, and scaling web apps. You can build apps by using .NET, .NET Core, Node.js, Java, Python, or PHP. The apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated according to the mainframe application and can be stateless to orchestrate a microservices-based system. In this architecture, it delivers REST APIs and web interfaces that replace 3270 terminal screens and mainframe user interfaces.

  - [WebJobs](/azure/app-service/webjobs-create) is a feature of App Service that runs a program or script in the same instance as a web app, API app, or mobile app. A web job can be a good choice for implementing sharable and reusable program logic. In this architecture, it executes batch processing tasks and [background tasks](/azure/app-service/webjobs-create) that were previously handled by mainframe job schedulers.

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) is a fully managed platform as a service (PaaS) that supports the publishing, routing, securing, logging, and analytics of APIs. You can control how the data is presented and extended and which apps can access it. You can also restrict access to your apps or allow third parties. In this architecture, it manages access to modernized APIs that expose mainframe business logic and controls how legacy data is accessed by new applications.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a fully managed in-memory caching service for sharing data and state among compute resources. It includes open-source Redis and Redis Enterprise, a commercial product from Redis Labs, as a managed service. You can improve the performance of high-throughput OLTP applications by designing them to scale and to use an in-memory data store such as Azure Cache for Redis. In this architecture, it accelerates data access for high-throughput OLTP workloads that replace mainframe transaction processing systems.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless compute service. It provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with Internet of Things, and build simple APIs and microservices. Use microservices to create servers that connect to Azure services and are always up to date. In this architecture, it handles event-driven processing and lightweight business logic components migrated from mainframe transaction managers.

- [Azure Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a reliable cloud messaging service for simple hybrid integration. Service Bus and Storage queues can connect the front end with the business logic in the migrated system. Azure Service Bus enables reliable messaging between distributed systems. In this architecture, it facilitates asynchronous communication between migrated mainframe components that previously used mainframe messaging systems.

#### Storage and database

This architecture addresses scalable and secure cloud storage as well as managed databases for migrating mainframe data and supporting modern application requirements.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that you can use Azure Cosmos DB to migrate mainframe, nontabular data to Azure. In this architecture, it stores nonrelational data migrated from mainframe systems like VSAM files and provides global distribution for international user bases.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed MySQL database service. In this architecture, it supports applications that require open-source database compatibility during the mainframe modernization process.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed, intelligent, and scalable PostgreSQL that has native connectivity with Azure services. In this architecture, it hosts relational data migrated from mainframe databases with advanced indexing and analytics capabilities.

- [Azure SQL](/azure/azure-sql/) is a family of cloud-based SQL database services. In this architecture, it hosts relational data migrated from mainframe databases like DB2 and IMS DB:

  - [Azure SQL Edge](/azure/azure-sql-edge/overview) is a specialized version of the SQL Server database engine that's optimized for IoT and edge deployments. In this architecture, it processes data close to edge devices in scenarios where mainframe applications have been distributed to edge locations.

  - [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed relational database service. In this architecture, it supports modernized workloads with elastic scaling for variable mainframe transaction loads.

  - [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a fully managed, cloud-based deployment option that provides near 100% SQL Server compatibility. In this architecture, it hosts migrated mainframe databases with minimal code changes and built-in high availability.

  - [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is an infrastructure as a service (IaaS) offering that provides full SQL Server functionality. In this architecture, it supports legacy workloads that require specific database engine features during migration.

  - [In-Memory OLTP](/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios) is a high-performance feature that accelerates transaction processing in SQL Database and SQL Managed Instance. In this architecture, it provides the high-performance transaction processing capabilities that mainframe OLTP workloads require.

- [Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a set of massively scalable and more secure cloud services for data, apps, and workloads that provides foundational cloud storage services. In this architecture, it supports [Azure Files](/azure/well-architected/service-guides/azure-files), [Azure Table Storage](/azure/storage/tables/table-storage-overview), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues) for various mainframe data migration scenarios.

#### Monitoring

The following monitoring tools provide comprehensive data analysis and valuable insights into application performance.

- [Application Insights](/azure/well-architected/service-guides/application-insights) is a feature of Azure Monitor that provides code-level telemetry for applications. It monitors the application, detects anomalies such as mediocre performance and failures, and sends personal data to the Azure portal. You can also use Application Insights for logging, distributed tracing, and custom application metrics. In this architecture, it tracks application performance, detects anomalies, and supports distributed tracing and custom metrics to ensure reliability and responsiveness.

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive platform for collecting, analyzing, and acting on telemetry from Azure and on-premises environments. In this architecture, it serves as the central hub for monitoring infrastructure, applications, and services.

  - [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-metric) are a feature of Azure Monitor that notifies users when metrics or logs exceed defined thresholds. In this architecture, they trigger automated responses or escalate problems to operations teams for timely intervention.

  - [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a query tool within Azure Monitor that uses a powerful language to analyze log data. In this architecture, it enables deep diagnostics, supports custom dashboards, and integrates with alerts and workbooks for operational insights.

## Scenario details

Because of evolving business needs and data, applications must scale and produce results without creating infrastructure problems. This example workload shows how you can migrate a z/OS mainframe OLTP application to a more secure, scalable, and highly available system in the cloud by using Azure platform as a service (PaaS) services. This migration helps businesses in finance, health, insurance, and retail minimize application delivery timelines. It also helps reduce the costs of running the applications.

### Potential use cases

This architecture is ideal for OLTP workloads that have the following characteristics:

- They serve an international user base.

- Their usage varies greatly over time, so they benefit from flexible scaling and usage-based pricing.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- You can deploy this OLTP architecture in multiple regions. It can also have a geo-replicated data layer.

- The Azure database services support zone redundancy and can fail over to a secondary node if an outage occurs or to allow for maintenance activities.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- ExpressRoute creates a private connection to Azure from an on-premises environment. You can also use site-to-site VPN.

- Microsoft Entra ID can authenticate resources and control access by using Azure role-based access control.

- Database services in Azure support various security options like data encryption at rest.

- For general guidance about how to design more secure solutions, see [Security quick links](/azure/architecture/framework/security/overview).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

This scenario uses Azure Monitor and Application Insights to monitor the health of the Azure resources. You can set alerts for proactive management.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- This architecture uses Azure PaaS services like App Service, which has autoscaling capabilities.

- For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager
- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact [datasqlninja@microsoft.com](mailto:datasqlninja@microsoft.com).
- [Azure Database migration guides](/data-migration)

## Related resources

See the following related architectures and related technical information.

### Related architectures

- [High-volume batch transaction processing](./process-batch-transactions.yml)
- [IBM z/OS mainframe migration by using Avanade AMT](./avanade-amt-zos-migration.yml)
- [Micro Focus Enterprise Server on Azure VMs](./micro-focus-server.yml)
- [Refactor IBM z/OS mainframe coupling facility to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Migrate IBM mainframe applications to Azure by using TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)

### Related technical information

- [Run background tasks by using WebJobs in App Service](/azure/app-service/webjobs-create)
- [Optimize performance by using in-memory technologies in SQL Database](/azure/azure-sql/in-memory-oltp-overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Create or edit a metric alert rule](/azure/azure-monitor/alerts/alerts-create-metric-alert-rule)
- [Create and share dashboards of Log Analytics data](/azure/azure-monitor/visualize/tutorial-logs-dashboards)
