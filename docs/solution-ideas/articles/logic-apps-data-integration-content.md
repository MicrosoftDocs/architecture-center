With Azure Logic Apps it's possible to integrate cloud data into on-premises data storage. For instance, you can use a logic app to store HTTP request data in a SQL Server database. Logic Apps can also automate data-related tasks like sending Teams or email messages. Another benefit of this service is that it works with Azure API Management to keep data secure.

## Potential use cases

Data integration scenarios that can benefit from this solution include:

- Updating an on-premises database in response to API calls.
- Sending Teams or email messages in response to API calls.

## Architecture

:::image type="complex" source="../media/logic-apps-data-integration.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to web activity by reading data from or writing data to S Q L Server." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains rectangles, one that pictures databases and one that contains integration tools. A server icon that represents the self-hosted integration runtime is also located in the on-premises part. The Azure part also contains rectangles. One is for pipelines. Others are for services that the solution uses for staging and preparing data. Another contains Azure databases. Arrows point from on-premises components to Azure components. These arrows represent the flow of data in the replication and sync processes. One of the arrows goes through the on-premises data gateway.
:::image-end:::

1. API Management accepts API calls in the form of HTTP requests.

1. API Management securely routes the HTTP requests to Logic Apps.

1. Logic Apps sends a statement and encrypted database credentials to the on-premises data gateway.

1. The on-premises data gateway connects to a SQL Server database to run the statement.

1. SQL Server stores the data and makes it available to apps that users access.

## Components

This architecture uses the following components:

- [API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.

- [Logic Apps][Azure Logic Apps] automates workflows by connecting apps and data across clouds. This service provides a way to securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps.

- An [on-premises data gateway][On-premises data gateway] acts as a bridge that connects on-premises data with cloud services like Logic Apps. Typically, you install the gateway on a dedicated on-premises VM. The cloud services can then securely use on-premises data.

- [SQL Server][SQL Server] provides a solution for storing and querying structured and unstructured data. This database engine features industry-leading performance and security.


## Considerations

Keep these points in mind when considering this architecture.

### Availability considerations

For high availability, [add a gateway to a cluster][Install a gateway cluster] instead of installing a standalone gateway.

### Scalability considerations

With the serverless model that Logic Apps uses, the service automatically scales to meet demand. But be aware of [limits on read and write operations with the on-premises data gateway][Limits on read and write operations with the on-premises data gateway].

### Security considerations

- The on-premises data gateway provides data protection during transfers between on-premises and Azure systems.
- API Management secures mobile infrastructure by:

  - gating access with API keys.
  - preventing DOS attacks by using throttling.
  - using advanced security policies like JWT token validation.

## Pricing

Use the [Azure pricing calculator][Azure pricing calculator] to estimate the cost of implementing this solution.

## Next steps

- [Import a Logic App as an API][Import a Logic App as an API].
- [On-premises data gateways documentation][On-premises data gateways documentation].
- [Install on-premises data gateway for Azure Logic Apps][Install on-premises data gateway for Azure Logic Apps].
- [Connect to on-premises data sources from Azure Logic Apps][Connect to on-premises data sources from Azure Logic Apps].

[Azure API Management]: https://docs.microsoft.com/azure/api-management/api-management-key-concepts
[Azure Logic Apps]: https://docs.microsoft.com/azure/logic-apps/logic-apps-overview
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Connect to on-premises data sources from Azure Logic Apps]: https://docs.microsoft.com/azure/logic-apps/logic-apps-gateway-connection
[Import a Logic App as an API]: https://docs.microsoft.com/azure/api-management/import-logic-app-as-api
[Install a gateway cluster]: https://docs.microsoft.com/data-integration/gateway/service-gateway-install
[Install on-premises data gateway for Azure Logic Apps]: https://docs.microsoft.com/azure/logic-apps/logic-apps-gateway-install
[Limits on read and write operations with the on-premises data gateway]: https://docs.microsoft.com/data-integration/gateway/service-gateway-onprem#considerations
[On-premises data gateway]: https://docs.microsoft.com/power-bi/connect-data/service-gateway-onprem
[On-premises data gateways documentation]: https://docs.microsoft.com/data-integration/gateway/
[SQL Server]: https://docs.microsoft.com/sql/?view=sql-server-ver15
