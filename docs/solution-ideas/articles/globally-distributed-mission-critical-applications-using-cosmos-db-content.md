Applications need to be highly responsive and always online. This article presents a solution that uses globally distributed applications to meet these requirements. It takes advantage of the high-availability and low-latency capabilities that are built into Azure Cosmos DB and Azure global datacenters.

## Architecture

:::image type="content" source="../media/globally-distributed-mission-critical-applications-using-cosmos-db.png" alt-text="Architecture diagram that shows how Azure Traffic Manager routes an app user to the best location for accessing Azure Cosmos DB.":::

*Download an [SVG](../media/globally-distributed-mission-critical-applications-using-cosmos-db.svg) version of this architecture.*

### Dataflow

1. A user accesses an application through a dedicated client.
1. Azure Traffic Manager uses a routing profile or nested profiles to route the user's connection to the best location for accessing the application.
1. In the region that the user gets routed to, the application establishes a database session and connection.
1. The solution can accommodate applications of various complexities. For instance, the app might be a basic, static page. Or it might be a microservices-oriented application that's hosted in Kubernetes.
1. The connection between the application landscape and Azure Cosmos DB is handled through an Azure Active Directory (Azure AD) user who retrieves keys to Azure Cosmos DB keys from Azure Key Vault.
1. The application is aware of the nearest region and can send requests to that region by using the Azure Cosmos DB multi-homing APIs. The nearest region is identified without any configuration changes. As you add and remove regions to and from your Azure Cosmos DB account, your application doesn't need to be redeployed or paused. The application continues to be highly available. Beneath the hood, Azure Cosmos DB handles the global distribution and replication of the data based on the number of defined regions. If the automatic failover option is turned on and a region becomes unavailable, the system fails over to the region with the highest failover priority. No user action is required for this failover. The region priorities can be modified when automatic failover is turned on.

### Components

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager): is a DNS-based traffic load balancer. You can use Traffic Manager to create load balancing options for your applications by using various DNS-based traffic routing options that can be nested.
- [Azure AD](https://azure.microsoft.com/services/active-directory): is a multi-tenant, cloud-based identity and access management service. You can use Azure AD to synchronize on-premises directories and enable single sign-on.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database for any scale.

### Alternatives

You can extend this scenario with several compute and serverless options.

#### Compute options

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources like Linux and Windows virtual machines (VMs).
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a highly available, secure, and fully managed Kubernetes service for application and microservice base workloads.
- [Azure App Service](https://azure.microsoft.com/services/app-service) provides a framework for building, deploying, and scaling powerful cloud apps for web and mobile scenarios.

#### Serverless options

- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) automates workflows. With this service, you can quickly build powerful integration solutions.

## Scenario details

Applications need to deliver fast response times. To achieve low latency, organizations deploy apps close to their users. They also keep data close to users. When organizations operate globally, they need to use multiple datacenters and globally distributed apps. These apps then use a local copy of globally replicated data to remain highly responsive.

This solution uses globally distributed apps. It also uses Azure Cosmos DB, which is a globally distributed database system that transparently replicates data to multiple regions. The apps use a local replica of the database to read and write data.

Besides offering low latency, the solution also benefits from the high availability that Azure Cosmos DB provides.

### Potential use cases

This solution is a good fit for industries that operate globally and need to keep data close to their users. Examples include the media, entertainment, travel, and hospitality industries. Some scenarios that utilize globally distributed applications include:

- Streaming consumer video services.
- App-based pickup and delivery services for people and goods.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The availability of the Azure Cosmos DB instance depends on many factors. The greater the number of regions that Azure Cosmos DB is replicated to, the greater the availability of the application. Each region contains all the data partitions of an Azure Cosmos DB container and can serve reads, by default. To increase the availability of the data layer, you can enable multi-region write. You can also increase availability by employing weaker consistency levels and availability zones.

To configure your solution to maximize the SLA that your application offers, use Azure Cosmos DB automatic failover.

For the application layer, configure Traffic Manager with nested profiles. When pushing this design to the highest level, you can scale the different application choices, per region. The per-region deployment also takes a high-availability approach.

For higher resiliency, you can use availability zones for Azure Cosmos DB deployments. Resiliency also depends on the consistency level that you use with your Azure Cosmos DB deployment. For more information, see [Consistency, availability, and performance tradeoffs](/azure/cosmos-db/consistency-levels).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

From a security perspective, strive for an identity-based system, where Azure AD can be used to secure access to the environment. In the backend, access the application through managed identities. As an alternative, consider using Azure AD users and Key Vault for securing access. The Azure Cosmos DB instance should be further secured. Make the various backends that are deployed to different regions the only entities that are capable of reading and writing to the database instance. Apply IP address restriction to the account by using the built-in [firewall](/azure/cosmos-db/how-to-configure-firewall).

Azure Cosmos DB also supports role-based access control with Azure AD. For more information, see [Configure role-based access control with Azure Active Directory for your Azure Cosmos DB account](/azure/cosmos-db/how-to-setup-rbac).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

System performance is affected by many factors at the compute and database level. The SKU for an App Service plan or other compute option affects the memory and cores that are available in each region. Also, the number of regions the compute layer is deployed to can dictate the scale that it's capable of handling. Deployment of more locations relieves the pressure from existing regions and should result in linear increases in the maximum throughput that the application can fulfill.

Configure Azure Cosmos DB so that it doesn't become a bottleneck for the compute tier resources. Each database and container in Azure Cosmos DB should be configured to auto-scale and should be supplied with a maximum request unit value that ensures Azure Cosmos DB doesn't throttle requests. To determine appropriate max request unit values for the Azure Cosmos DB entities, you can run load tests near approximate maximum throughput for the application. When compared with their stronger counterparts, weaker consistency levels offer higher throughput and performance benefits.

Crucially, when implementing the logic in code that reads from and writes to Azure Cosmos DB, whether it be through the SDK, Functions bindings, and so on, `PreferredLocations` should be used so that each regional API routes requests to the closest Azure Cosmos DB region. Based on the Azure Cosmos DB account configuration, current regional availability, and the preference list specified, the SDK chooses the most optimal endpoint to perform the read and write operations. This process results in significant performance boosts.

Scaling is based on many levels in this solution. Azure Cosmos DB is purpose-built for elastic scale and predictable performance. On the level of the application, you need to look at the compute model used. Functions and App Service can autoscale. For Azure VMs, you can use Azure Virtual Machine Scale Sets. When you're aware of this need, you should always consider a serverless option, when possible.

## Next steps

More about Azure Cosmos DB:

- [Manage an Azure Cosmos DB account](/azure/cosmos-db/how-to-manage-database-account)
- [Configure multi-region writes in your applications that use Azure Cosmos DB](/azure/cosmos-db/how-to-multi-master)
- [Distribute your data globally with Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
- [Manage consistency levels in Azure Cosmos DB](/azure/cosmos-db/how-to-manage-consistency)
- [Build a .NET web app using Azure Cosmos DB for NoSQL and the Azure portal](/azure/cosmos-db/create-sql-api-dotnet)
- [Use system-assigned managed identities to access Azure Cosmos DB data](/azure/cosmos-db/managed-identity-based-authentication)
- [How does Azure Cosmos DB provide high availability](/azure/cosmos-db/high-availability)
- [Enable automatic failover for your Azure Cosmos DB account](/azure/cosmos-db/how-to-manage-database-account#automatic-failover)

More about Traffic Manager:

- [What is Traffic Manager?](/azure/traffic-manager/traffic-manager-overview)
- [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods)
- [Tutorial: Configure the geographic traffic routing method using Traffic Manager](/azure/traffic-manager/traffic-manager-configure-geographic-routing-method)

## Related resources

Related solution ideas:

- [Deliver highly scalable customer service and ERP applications](./erp-customer-service.yml)
- [Gaming using Azure Cosmos DB](./gaming-using-cosmos-db.yml)
- [IoT using Azure Cosmos DB](./iot-using-cosmos-db.yml)
- [Personalization using Azure Cosmos DB](./personalization-using-cosmos-db.yml)
- [Retail and e-commerce using Azure Cosmos DB](./retail-and-e-commerce-using-cosmos-db.yml)
- [Serverless apps using Azure Cosmos DB](./serverless-apps-using-cosmos-db.yml)

Related full architectures:

- [CI/CD pipeline for container-based workloads](../../guide/aks/aks-cicd-github-actions-and-gitops.yml)
- [Mass ingestion and analysis of news feeds on Azure](../../example-scenario/ai/news-feed-ingestion-and-near-real-time-analysis.yml)
- [Scalable order processing](../../example-scenario/data/ecommerce-order-processing.yml)

Related architecture guidance:

- [Deploying multi-region APIs that write to Azure Cosmos DB](../../patterns/geodes.yml)
- [Choosing an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Choosing a big data storage technology in Azure](../../data-guide/technology-choices/data-storage.md)
