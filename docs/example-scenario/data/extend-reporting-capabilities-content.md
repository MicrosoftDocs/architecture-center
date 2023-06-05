This scenario describes how to use Azure Logic Apps and Power BI to extend the reporting capabilities of Project Online. You can track and process data from various unrelated sources, and then clean, transform, and combine that data in order to create complex reports and provide actionable metrics.

## Architecture

[ ![Diagram of the Project Online extension architecture.](media/extend-reporting-architecture.svg)](media/extend-reporting-architecture.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/extend-reporting-architecture.vsdx) of this architecture.*

### Dataflow

1. Data is generated in its source system. Azure Logic Apps makes a request to the source system with credentials more safely stored in Azure Key Vault. Key Vault stores Project Online OData endpoint configurations from one or more Microsoft 365 tenants, or any other data sources. The cloud credentials are used in Logic Apps to connect each Project Online data source.

    > [!NOTE]
    > Government customers should follow the guidance under [Common access cards (CAC) or personal identity verification (PIV)](#common-access-cards-cac-or-personal-identity-verification-piv).

2. The source system responds to the Logic Apps request with the data. Logic Apps parses and converts the data into JSON format. If the source data is formatted in an OData protocol, as Project Online is, use the `odata.nextlink` variable in order to overcome the limitations of the protocol.

3. After the data is parsed, Logic Apps places the data into Azure SQL Server or in data lake storage for further processing. The ability to set up data pulls differs by organization and by system. Follow the process required, such as by Logic Apps, Azure Data Factory, or Azure Synapse Pipelines.

4. Data is processed within the initial tier, where all the source data is consolidated.

5. Data is further processed at the next level, where data is ready to use for the final tier.

6. Complex calculations and metrics complete the transformation processes. Data is published to either the Power BI Report Server in Microsoft 365, or to a Power BI server in Azure or on-premises. Transformed data can be directly queried or imported into Power BI Service or Power BI Report Server. Alternatively, the data can be pushed to Azure Analysis Services.

7. Data is published and reports are created and made available for consumption.

### Components

This architecture uses the following components:

- [Project Online](https://powerautomate.microsoft.com/connectors/details/shared_projectonline/project-online) is a flexible solution for project portfolio management (PPM) and everyday work. Delivered through Microsoft 365, Project Online provides powerful project management capabilities for planning, prioritizing, and managing projects, from almost anywhere on almost any device. Its data store is the source of truth for project and program schema relationships for your reports.

- [Azure Logic Apps](https://azure.microsoft.com/products/logic-apps) automates workflows by connecting apps and data across clouds. This service provides a way to more securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps. It's used to automate the data flow processes. Depending on the scale, it might make more sense to use Azure Data Factory and Azure Functions.

- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates. It's used to help secure Project Online and other data source credentials, certificates, and secrets.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions, such as upgrading, patching, backups, and monitoring, without user involvement. It's used as a cost-effective data sync for project data. In addition to storing data, it can also be used to hold materialized views of data and metrics.

- [Azure Monitor](https://azure.microsoft.com/products/monitor) collects data on environments and Azure resources. It helps maintain availability and performance monitoring. In addition to analyzing and maintaining costs for other Azure services, such as [Azure Storage](https://azure.microsoft.com/free/storage) and [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs), Monitor can also help to quickly resolve issues by using diagnostic data. Monitor uses two data platforms:

    - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) records and stores log and performance data. For Logic Apps, this data includes information on trigger events, run events, and action events.
    - [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics) collects numerical values at regular intervals. For Logic Apps, this data includes the run latency, rate, and success percentage.

- [Power BI Service](https://powerbi.microsoft.com/what-is-power-bi) is a collection of software services, apps, and connectors that work together to help you create, share, and consume business insights. In the context of this solution, you'll use Power BI Service to neatly display the state of a dynamic, complex project to stakeholders.

### Alternatives

Using the schema provided in Project Online can save time and money, but the general concept can be applied to any data source connected through Logic Apps. Logic Apps is a powerful workflow tool that can connect many Microsoft first-party and third-party data sources, such as SharePoint, Microsoft Dataverse, or even data in on-premises networks.

Furthermore, other components can be replaced based on the type of data and how those datasets are transformed. You can use different data storage and processing types, from Dataverse to traditional SQL on VMs, Azure SQL, Databricks, data lakes, or Oracle on IaaS in Azure.

Logic Apps isn't the only option to consider. For example, Azure Data Factory and Azure Functions are excellent data and job-processing services, especially as the scale of the data grows.

## Scenario details

Project Online offers strong functionality to track and understand data relationships. Features include:

- Easy setup
- Near real-time data refreshes
- Can accommodate more than 100 GB of unstructured and structured data at any given time
- Not domain or tenant dependent
- Flexible
- Follows the CIA or AIC triad model, which is made up of *confidentiality*, *integrity*, and *availability*

### Potential use cases

When working on complex reports with Project Online data, you might face challenges like:

- Combining data from multiple Project Online instances of unrelated Microsoft 365 tenants.
- Importing extremely large datasets, in a wide variety of states. Some data might be clean, but most datasets require "help" and transformations.
- Joining and filtering from multiple tables.
- Tracking changes of major data points.
- Tracking baselines for trends over months or even years.
- Always ensuring compliance and government retention policies.

Although the out-of-the-box reporting model might work in many cases, directly querying Project Online data from Power BI isn't always sufficient. You might need to collect, consolidate, and transform data before visualizing in Power BI.

Here are some more potential use cases:

- Microsoft Project portfolio tracking and reporting from multiple Project Online tenants
- Multi-tenant data sources: portfolio and program
- Timesheet and project cost code rollup reporting: cash flow report for programs/projects
- Flight test scheduling and tracking
- Trending metrics that track data changes, from baseline to current, and capture the deltas over long time periods.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This scenario is built on top of Azure Logic Apps and Azure SQL Database, which are reliable products from Microsoft. Azure SQL Database has 99.99% reliability.

Aside from the underlying technology, the scenario adds retry policy, additional behaviors for error handling, and uses Azure Monitor to capture logs from the solution.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario requires a *cloud-only* account to authenticate into Project Online and read project data. The account is reserved for this
app and should only grant minimum required permissions on Project Online - Access Project Server Reporting Service.

The cloud-only account is stored in Azure Key vault. For every Project Online data source, meaning different tenants, a cloud-only account is required.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

The following sample cost estimates are based on the amount of traffic and data:

- [Small pricing example](https://azure.com/e/f96c5a16b2c44ce78e1957f22d49895a) for 30 GB Project Online instance.

- [Medium pricing example](https://azure.com/e/f1158343bc954bd0b5a97ff21aad869a) for 30 GB \* 5 Project Online instances.

- [Large pricing example](https://azure.com/e/49491ee9585d4711926b6661b691e1f3) for 50 GB \* 10 Project Online instances.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This scenario uses Azure Logic Apps and Azure SQL Database. With Logic Apps and Azure SQL Database, you can scale up or down depending on how much data you process and the overall data size. This functionality lets you keep up with customer demand and keep the initial costs down.

One major concern of this scenario is the size of data it processes. In Project Online, most data won't change day by day. It's a waste of bandwidth to reload every bit of data even if it isn't changed. This scenario reduces the amount of data to pull and process by keeping a timestamp of all objects. Only data that has changed is reloaded.

### Common access cards (CAC) or personal identity verification (PIV)

The Logic Apps connector to Project Online doesn't natively support tenants that require the use of CAC or PIV for user-less connections. In order for Logic Apps to establish authentication to Project Online, a service principal needs to exist with appropriate permissions, or scopes, and licensing within the source tenant. Use the OAuth [client credential grant flow](/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow) to acquire an access token for API access to Project Online.

You need the following information from your Azure AD client registration:

- Application (client) ID
- Client secret

The client secret should be stored in, and then come from, Key Vault. Create an HTTP request method in Logic Apps to post to your appropriate [token endpoint](/azure/active-directory/develop/v2-app-types#daemons-and-server-side-apps), and parse out the `access_token` in the HTTP response.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [Amber Michael](https://www.linkedin.com/in/amberdawnsd) | Technical Consultant
 - [Sean Day](https://www.linkedin.com/in/sean-day-1987168b) | Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learn about Project Online](/projectonline/project-online)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Azure Event Hubs?](/azure/event-hubs/event-hubs-about)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Learn how to describe analytics capabilities in Microsoft 365](/training/modules/describe-analytics-capabilities-microsoft-365)
- [Learn about deploying serverless APIs with Azure Functions, Logic Apps, and Azure SQL Database](/training/modules/deploy-backend-apis)

## Related resources

- [Data warehousing in Microsoft Azure](../../data-guide/relational-data/data-warehousing.yml)
- [Enterprise business intelligence](../analytics/enterprise-bi-synapse.yml)
- [Manage Microsoft 365 tenant configuration](../devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops.yml)
