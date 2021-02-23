With Azure Logic Apps, you can integrate cloud data into on-premises data storage. For instance, a logic app can store HTTP request data in a SQL Server database. Because Logic Apps functions as a secure Azure API Management endpoint, calls to your API can trigger various data-related tasks. Besides updating on-premises databases, you can also send Teams or email messages.

## Potential use cases

Use this solution to automate data integration tasks that you perform in response to API calls.

## Architecture

:::image type="complex" source="./media/logic-apps-data-integration.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from the Logic Apps icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

1. API Management accepts API calls in the form of HTTP requests.

1. API Management securely routes the HTTP requests to Logic Apps.

1. Logic Apps sends a database statement and encrypted database credentials to the on-premises data gateway.

1. The on-premises data gateway connects to a SQL Server database to run the statement.

1. SQL Server stores the data and makes it available to apps that users access.

### Components

This architecture uses the following components:

- [Azure API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.

- [Azure Logic Apps][Azure Logic Apps] automates workflows by connecting apps and data across clouds. This service provides a way to securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps.

- An [on-premises data gateway][On-premises data gateway] acts as a bridge that connects on-premises data with cloud services like Logic Apps. Typically, you install the gateway on a dedicated on-premises virtual machine. The cloud services can then securely use on-premises data.

- [SQL Server][SQL Server] provides a solution for storing and querying structured and unstructured data. This database engine features industry-leading performance and security.

### Alternatives

A few alternatives exist for this solution:

- Instead of using an on-premises instance of SQL Server, consider migrating to an up-to-date, fully managed Azure database service. The SQL Server connector that Logic Apps uses also works for [Azure SQL Database][Azure SQL Database] and [Azure SQL Managed Instance][Azure SQL Managed Instance]. For more information, see [Automate workflows for a SQL database by using Azure Logic Apps][Automate workflows for a SQL database by using Azure Logic Apps]. To get started with migration, see [Azure Database Migration Service][Azure Database Migration Service].

- For complex automation tasks, consider using [Azure Functions][Azure Functions] instead of Logic Apps. For more information, see [Compare Azure Functions and Azure Logic Apps][Compare Azure Functions and Azure Logic Apps].

## Considerations

Keep these points in mind when considering this architecture.

### Availability considerations

For high availability, [add the on-premises gateway to a cluster][Install a gateway cluster] instead of installing a standalone gateway.

### Scalability considerations

With the serverless model that Logic Apps uses, the service automatically scales to meet demand. But be aware of [limits on read and write operations with the on-premises data gateway][Limits on read and write operations with the on-premises data gateway].

### Security considerations

- The on-premises data gateway uses credential encryption and user authentication to protect data during transfers between on-premises and Azure systems.
- API Management secures mobile infrastructure by:

  - Gating access with API keys.
  - Preventing denial-of-service (DoS) attacks by using throttling.
  - Using advanced security policies like JSON Web Token (JWT) validation.
- Since API Management is the only client that should call your logic app, consider [restricting its inbound IP addresses][Restrict inbound IP addresses]. You can configure your logic app to only accept requests from the IP address of your API Management service instance.

## Pricing

The following table provides cost profiles and estimates of monthly costs for three implementations of this architecture:

|Level|API Management|Logic Apps action executions|Logic Apps connector executions|Total monthly cost|Profile|
|-----|-----|-----|-----|-----|-----|
|Basic|$147.17|$0.78 (1,000/day)|$3.88 (1,000/day)|$151.82|[Basic profile][Monthly cost profile - basic]|
|Standard|$686.71|$7.75 (10,000/day)|$38.75 (10,000/day)|$733.21|[Standard profile][Monthly cost profile - standard]|
|Premium|$2,795.17|$77.50 (100,000/day)|$387.50 (100,000/day)|$3,260.17|[Premium profile][Monthly cost profile - premium]|

The profiles and estimates include the following components:

- API Management
- Logic Apps:
  - Action executions
  - Standard connector executions

The monthly prices don't include the [costs of a SQL Server database][SQL Server 2019 pricing].

To adjust the parameters and explore the cost of running this solution in your environment, use the [Azure pricing calculator][Azure pricing calculator].

## Next steps

- [Import a Logic App as an API][Import a Logic App as an API]
- [Install an on-premises data gateway for Azure Logic Apps][Install on-premises data gateway for Azure Logic Apps]
- [Connect to on-premises data sources from Azure Logic Apps][Connect to on-premises data sources from Azure Logic Apps]

## Related resources

- [Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions][Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions]
- [Automate workflows for a SQL database by using Azure Logic Apps][Automate workflows for a SQL database by using Azure Logic Apps]
- [On-premises data gateway documentation][On-premises data gateways documentation]
- Similar architectures:

  - [On-premises data gateway for Azure Logic Apps][On-premises data gateway for Azure Logic Apps]: A logic app triggered by Azure Spring Cloud that connects to an on-premises SQL Server instance.
  - [Enterprise integration using queues and events][Enterprise integration using queues and events]: Logic apps that respond to API calls by integrating backend systems.
  - [Serverless web application][Serverless web application]: A serverless web app that uses Azure Functions to read database data.

[Automate workflows for a SQL database by using Azure Logic Apps]: /azure/connectors/connectors-create-api-sqlazure
[Azure API Management]: /azure/api-management/api-management-key-concepts
[Azure Database Migration Service]: https://azure.microsoft.com/services/database-migration/
[Azure Functions]: /azure/azure-functions/functions-overview
[Azure Logic Apps]: /azure/logic-apps/logic-apps-overview
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Azure Serverless: Overview for building cloud-based apps and solutions with Azure Logic Apps and Azure Functions]: /azure/logic-apps/logic-apps-serverless-overview
[Azure SQL Database]: /azure/azure-sql/database/sql-database-paas-overview
[Azure SQL Managed Instance]: /azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[Compare Azure Functions and Azure Logic Apps]: /azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps
[Connect to on-premises data sources from Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-connection
[Enterprise integration using queues and events]: /azure/architecture/reference-architectures/enterprise-integration/queues-events
[Import a Logic App as an API]: /azure/api-management/import-logic-app-as-api
[Install a gateway cluster]: /data-integration/gateway/service-gateway-install#add-another-gateway-to-create-a-cluster
[Install on-premises data gateway for Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-install
[Limits on read and write operations with the on-premises data gateway]: /data-integration/gateway/service-gateway-onprem#considerations
[Monthly cost profile - basic]: https://azure.com/e/aadf2d9bbe7443378c5fe429791dcf73
[Monthly cost profile - premium]: https://azure.com/e/071417b6c2d44062b4791e016230f001
[Monthly cost profile - standard]: https://azure.com/e/afa93fbed30749cab64db4d2779837ee
[On-premises data gateway]: /data-integration/gateway/service-gateway-onprem
[On-premises data gateways documentation]: /data-integration/gateway/
[On-premises data gateway for Azure Logic Apps]: /azure/architecture/hybrid/gateway-logic-apps
[Restrict inbound IP addresses]: /azure/logic-apps/logic-apps-securing-a-logic-app#restrict-inbound-ip-addresses
[Serverless web application]: /azure/architecture/reference-architectures/serverless/web-app
[SQL Server 2019 pricing]: https://www.microsoft.com/sql-server/sql-server-2019-pricing
[SQL Server]: /sql/?view=sql-server-ver15