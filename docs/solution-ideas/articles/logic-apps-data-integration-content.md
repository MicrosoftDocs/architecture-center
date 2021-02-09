With Azure Logic Apps, it's possible to integrate cloud data into on-premises data storage. For instance, a logic app can store HTTP request data in a SQL Server database. Because Logic Apps functions as a secure Azure API Management endpoint, calls to your API can trigger various data-related tasks. Besides updating on-premises databases, you can also send Teams or email messages.

## Potential use cases

Use this solution to automate data integration tasks you perform in response to API calls.

## Architecture

:::image type="complex" source="../media/logic-apps-data-integration.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from that file into an A P I Management icon that's inside the Azure box. A second arrow points from that icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from that icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Service icon that's inside the on-premises box. A final arrow points from the database icon to a person outside the on-premises box.
:::image-end:::

1. API Management accepts API calls in the form of HTTP requests.

1. API Management securely routes the HTTP requests to Logic Apps.

1. Logic Apps sends a database statement and encrypted database credentials to the on-premises data gateway.

1. The on-premises data gateway connects to a SQL Server database to run the statement.

1. SQL Server stores the data and makes it available to apps that users access.

## Alternatives

The architecture can use some alternative components. You may want to consider the following: 

To make your SQL server fully managed and up to date, while allowing you to use your SQL skills in the cloud, consider migrating your on-premises SQL server to Azure. To get started, explore the [Azure Database Migration Service](https://azure.microsoft.com/en-gb/services/database-migration/).

## Components

This architecture uses the following components:

- [API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.

- [Logic Apps][Azure Logic Apps] automates workflows by connecting apps and data across clouds. This service provides a way to securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps.

- An [on-premises data gateway][On-premises data gateway] acts as a bridge that connects on-premises data with cloud services like Logic Apps. Typically, you install the gateway on a dedicated on-premises virtual machine. The cloud services can then securely use on-premises data.

- [SQL Server][SQL Server] provides a solution for storing and querying structured and unstructured data. This database engine features industry-leading performance and security.

## Considerations

Keep these points in mind when considering this architecture.

### Availability considerations

For high availability, [add the on-premises gateway to a cluster][Install a gateway cluster] instead of installing a standalone gateway.

### Scalability considerations

With the serverless model that Logic Apps uses, the service automatically scales to meet demand. But be aware of [limits on read and write operations with the on-premises data gateway][Limits on read and write operations with the on-premises data gateway].

### Security considerations

- The on-premises data gateway provides data protection during transfers between on-premises and Azure systems.
- Since the Logic App should only be invoked via API Management, consider restricting the inbound IP addresses to the Azure Address range.
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

[Azure API Management]: /azure/api-management/api-management-key-concepts
[Azure Logic Apps]: /azure/logic-apps/logic-apps-overview
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Connect to on-premises data sources from Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-connection
[Import a Logic App as an API]: /azure/api-management/import-logic-app-as-api
[Install a gateway cluster]: /data-integration/gateway/service-gateway-install
[Install on-premises data gateway for Azure Logic Apps]: /azure/logic-apps/logic-apps-gateway-install
[Limits on read and write operations with the on-premises data gateway]: /data-integration/gateway/service-gateway-onprem#considerations
[On-premises data gateway]: /power-bi/connect-data/service-gateway-onprem
[On-premises data gateways documentation]: /data-integration/gateway/
[SQL Server]: /sql/?view=sql-server-ver15
