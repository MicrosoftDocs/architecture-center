This solution uses Azure Logic Apps to integrate cloud data into on-premises data storage.

## Architecture

:::image type="complex" source="./media/logic-apps-data-integration.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. Three arrows point away from the Logic Apps icon. One leads to a Key Vault icon that's inside the Azure box. One leads to an on-premises data gateway icon that's between the two boxes. And the third leads to an Azure Monitor icon that's inside the Azure box. Another arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/logic-apps-data-integration.vsdx) of this architecture.*

### Workflow

1. API Management accepts API calls in the form of HTTP requests.

1. API Management securely routes the HTTP requests to Logic Apps.

1. Each HTTP request triggers a run in Logic Apps:

   1. Logic Apps uses secured template parameters to retrieve database credentials from Azure Key Vault.
   1. Logic Apps uses Transport Layer Security (TLS) to send the database credentials and a database statement to the on-premises data gateway.

1. The on-premises data gateway connects to a SQL Server database to run the statement.

1. SQL Server stores the data and makes it available to apps that users access.

1. Azure Monitor collects information on Logic Apps events and performance.

### Components

This architecture uses the following components:

- [Azure API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.

- [Azure Logic Apps][Azure Logic Apps] automates workflows by connecting apps and data across clouds. This service provides a way to securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps.

- An [on-premises data gateway][On-premises data gateway] acts as a bridge that connects on-premises data with cloud services like Logic Apps. Typically, you install the gateway on a dedicated on-premises virtual machine. The cloud services can then securely use on-premises data.

- [Azure Key Vault][About Azure Key Vault] stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [SQL Server][SQL Server] provides a solution for storing and querying structured and unstructured data. This database engine features industry-leading performance and security.

- [Azure Monitor][Azure Monitor overview] collects data on environments and Azure resources. This information is helpful for maintaining availability and performance. Other Azure services, such as [Azure Storage][Azure Storage documentation] and [Azure Event Hubs][Azure Event Hubs - A big data streaming platform and event ingestion service], can also use this diagnostics data. Two data platforms make up Monitor:

   - [Azure Monitor Logs][Azure Monitor Logs overview] records and stores log and performance data. For Logic Apps, this data includes information on trigger events, run events, and action events.
   - [Azure Monitor Metrics][Azure Monitor Metrics overview] collects numerical values at regular intervals. For Logic Apps, this data includes the run latency, rate, and success percentage.

### Alternatives

A few alternatives exist for this solution:

- Instead of using an on-premises instance of SQL Server, consider migrating to an up-to-date, fully managed Azure database service. The SQL Server connector that Logic Apps uses also works for [Azure SQL Database][Azure SQL Database] and [Azure SQL Managed Instance][Azure SQL Managed Instance]. For more information, see [Automate workflows for a SQL database by using Azure Logic Apps][Automate workflows for a SQL database by using Azure Logic Apps]. To get started with migration, see [Azure Database Migration Service][Azure Database Migration Service].

- For complex automation tasks, consider using [Azure Functions][Azure Functions] instead of Logic Apps. For more information, see [Compare Azure Functions and Azure Logic Apps][Compare Azure Functions and Azure Logic Apps].

- For simple integrations, consider using [Power Automate][Get started with Power Automate] instead of Logic Apps. For more information, see [Compare Microsoft Power Automate and Azure Logic Apps][Compare Microsoft Power Automate and Azure Logic Apps].

- [Power Apps][What is Power Apps?] also provides solutions for automating workflows that involve connecting to on-premises data sources.

## Scenario details

A logic app can store HTTP request data in a SQL Server database. Because Logic Apps functions as a secure Azure API Management endpoint, calls to your API can trigger various data-related tasks. Besides updating on-premises databases, you can also send Teams or email messages.

### Potential use cases

Use this solution to automate data integration tasks that you perform in response to API calls.

## Considerations

Keep these points in mind when considering this architecture.

### Availability

For high availability, [add the on-premises gateway to a cluster][Install a gateway cluster] instead of installing a standalone gateway.

### Scalability

With the serverless model that Logic Apps uses, the service automatically scales to meet demand. But be aware of [limits on read and write operations with the on-premises data gateway][Limits on read and write operations with the on-premises data gateway].

### Security

- The on-premises data gateway uses credential encryption and user authentication to protect data during transfers between on-premises and Azure systems.
- API Management helps to ensure that only authorized clients call your logic app. You can also take these steps:

  - Since API Management is the only client that should call your logic app, consider [restricting your app's inbound IP addresses][Restrict inbound IP addresses]. You can configure your logic app to only accept requests from the IP address of your API Management service instance.
  - You can also use one of these authorization schemes to limit access to your logic app:

    - [Shared access signatures (SAS)][Generate shared access signatures (SAS)].
    - [Azure Active Directory Open Authentication (Azure AD OAuth)][Enable Azure Active Directory Open Authentication (Azure AD OAuth)].

- Consider using [Azure role-based access control (Azure RBAC)][What is Azure role-based access control (Azure RBAC)?] to only [permit specific users or groups to manage, edit, and view your logic apps][Access to logic app operations].

- [Information is available on each logic app run][Access to run history data], such as the status, duration, inputs, and outputs for each action. Use one of these methods to control who can access the inputs and outputs in the run history:

  - [Restrict access by IP address range][Restrict access by IP address range].
  - [Use obfuscation to secure run history data][Secure data in run history by using obfuscation].

### Cost optimization

The following table provides cost profiles that use varying levels of expected throughput:

|API Management|Logic Apps action executions|Logic Apps connector executions|Profile|
|-----|-----|-----|-----|
|Basic|1,000/day|1,000/day|[Basic profile][Monthly cost profile - basic]|
|Standard|10,000/day|10,000/day|[Standard profile][Monthly cost profile - standard]|
|Premium|100,000/day|100,000/day|[Premium profile][Monthly cost profile - premium]|

The profiles don't include the [costs of a SQL Server database][SQL Server 2019 pricing]. To adjust the parameters and explore the cost of running this solution in your environment, use the [Azure pricing calculator][Azure pricing calculator].

Explore these strategies for minimizing Logic Apps costs:

- Run SQL statements in batches.
- [Create stored procedures][Stored Procedures (Database Engine)] to organize database results in an efficient way.
- [Specify precise trigger conditions][Trigger conditions] for workflows.
- [Turn off logic apps][Disable or enable logic apps] that don't have to run constantly.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Shan Singh](https://uk.linkedin.com/in/shantnus) | Software Engineer
- [Beatriz Matsui](https://br.linkedin.com/in/beatrizmatsui) | Consultant – Azure Cloud & AI

## Next steps

- [Import a Logic App as an API][Import a Logic App as an API]
- [Install an on-premises data gateway for Azure Logic Apps][Install on-premises data gateway for Azure Logic Apps]
- [Connect to on-premises data sources from Azure Logic Apps][Connect to on-premises data sources from Azure Logic Apps]

## Related resources

- [Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions][Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions]
- [Automate workflows for a SQL database by using Azure Logic Apps][Automate workflows for a SQL database by using Azure Logic Apps]
- [On-premises data gateway documentation][On-premises data gateways documentation]
- Similar architectures:

  - [On-premises data gateway for Azure Logic Apps][On-premises data gateway for Azure Logic Apps]: A logic app triggered by Azure Spring Apps that connects to an on-premises SQL Server instance.
  - [Enterprise integration using queues and events][Enterprise integration using queues and events]: Logic apps that respond to API calls by integrating backend systems.
  - [Serverless web application][Serverless web application]: A serverless web app that uses Azure Functions to read database data.

[About Azure Key Vault]: /azure/key-vault/general/overview
[Access to logic app operations]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#access-to-logic-app-operations
[Access to run history data]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#access-to-run-history-data
[Automate workflows for a SQL database by using Azure Logic Apps]: /azure/connectors/connectors-create-api-sqlazure
[Azure API Management]: /azure/api-management/api-management-key-concepts
[Azure Database Migration Service]: https://azure.microsoft.com/services/database-migration/
[Azure Event Hubs - A big data streaming platform and event ingestion service]: /azure/event-hubs/event-hubs-about
[Azure Functions]: /azure/azure-functions/functions-overview
[Azure Logic Apps]: /azure/logic-apps/logic-apps-overview
[Azure Monitor Logs overview]: /azure/azure-monitor/logs/data-platform-logs
[Azure Monitor Metrics overview]: /azure/azure-monitor/essentials/data-platform-metrics
[Azure Monitor overview]: /azure/azure-monitor/overview
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions]: /azure/logic-apps/logic-apps-serverless-overview
[Azure SQL Database]: /azure/azure-sql/database/sql-database-paas-overview
[Azure SQL Managed Instance]: /azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[Azure Storage documentation]: /azure/storage/
[Compare Azure Functions and Azure Logic Apps]: /azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps
[Compare Microsoft Power Automate and Azure Logic Apps]: /azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-microsoft-power-automate-and-azure-logic-apps
[Connect to on-premises data sources from Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-connection
[Disable or enable logic apps]: /azure/logic-apps/manage-logic-apps-with-azure-portal#disable-or-enable-logic-apps
[Enable Azure Active Directory Open Authentication (Azure AD OAuth)]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#enable-azure-active-directory-open-authentication-azure-ad-oauth
[Enterprise integration using queues and events]: ./queues-events.yml
[Get started with Power Automate]: /power-automate/getting-started
[Import a Logic App as an API]: /azure/api-management/import-logic-app-as-api
[Install a gateway cluster]: /data-integration/gateway/service-gateway-install#add-another-gateway-to-create-a-cluster
[Install on-premises data gateway for Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-install
[Generate shared access signatures (SAS)]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#generate-shared-access-signatures-sas
[Limits on read and write operations with the on-premises data gateway]: /data-integration/gateway/service-gateway-onprem#considerations
[Monthly cost profile - basic]: https://azure.com/e/aadf2d9bbe7443378c5fe429791dcf73
[Monthly cost profile - premium]: https://azure.com/e/071417b6c2d44062b4791e016230f001
[Monthly cost profile - standard]: https://azure.com/e/afa93fbed30749cab64db4d2779837ee
[On-premises data gateway]: /data-integration/gateway/service-gateway-onprem
[On-premises data gateways documentation]: /data-integration/gateway/
[On-premises data gateway for Azure Logic Apps]: ../../hybrid/gateway-logic-apps.yml
[Restrict access by IP address range]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#restrict-access-by-ip-address-range
[Restrict inbound IP addresses]: /azure/logic-apps/logic-apps-securing-a-logic-app#restrict-inbound-ip-addresses
[Secure data in run history by using obfuscation]: /azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#secure-data-in-run-history-by-using-obfuscation
[Serverless web application]: /azure/architecture/web-apps/serverless/architecture/web-app
[SQL Server 2019 pricing]: https://www.microsoft.com/sql-server/sql-server-2019-pricing
[SQL Server]: /sql/?view=sql-server-ver15
[Stored Procedures (Database Engine)]: /sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver15
[Trigger conditions]: /azure/logic-apps/logic-apps-workflow-actions-triggers#trigger-conditions
[What is Azure role-based access control (Azure RBAC)?]: /azure/role-based-access-control/overview
[What is Power Apps?]: /powerapps/powerapps-overview
