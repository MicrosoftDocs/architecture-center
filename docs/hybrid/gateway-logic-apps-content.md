This reference architecture illustrates a logic app that's running in Microsoft Azure, which is triggered by Azure Spring Cloud. It then connects to on-premises resources such as Microsoft SQL Server and Microsoft SharePoint Server.

![The diagram illustrates an Azure Spring Cloud resource triggering a Logic App that advances through a workflow that connects to on-premises SQL Server and SharePoint Server resources by using a data gateway.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Cloud-based Azure Logic Apps workflows that require data from on-premises software as part of their run.
- Extending the capabilities of existing on-premises software by triggering Logic Apps workflows in the cloud.

## Architecture

The architecture consists of the following components:

- **[Azure Spring Cloud][azure-spring-cloud]**. Spring Cloud provides a managed service that's designed and optimized specifically for [Spring][spring] microservices that are written in [Java][java].
- **[Azure Logic Apps][azure-logic-app]**. Logic apps are automated workflows that are provided as a scalable cloud service for common enterprise orchestration tasks. Logic apps include [connectors][azure-logic-app-connectors] for many popular cloud services, on-premises products, or other software as a service applications. The Logic Apps workflow includes the following features:
  - **[Trigger][azure-logic-app-connectors-queue]** that fires whenever a new [Azure Queue storage][azure-storage-queues] message is received.
  - **[Action][azure-logic-app-actions-parse]** to parse the JavaScript Object Notation (JSON) body of the queue message.
  - **[Action][azure-logic-app-connectors-sql]** to query SQL Server for relevant data.
  - **[Action][azure-logic-app-actions-compose]** to compose a response from the collected data.
  - **[Action][azure-logic-app-connectors-sharepoint]** to persist the composed response to a list on the SharePoint Server.
- **[On-premises data gateway][integration-data-gateway]**. An on-premises data gateway is bridge software that connects on-premises data to cloud services. The gateway typically [installs on a dedicated on-premises virtual machine][azure-logic-app-data-gateway-install].
- **[SQL Server][sql-server]**. This is an installation of SQL Server.
- **[SharePoint Server][sharepoint-server]**. This is an installation of SharePoint Server.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have specific requirements that override them.

### On-premises data gateway

While it's possible to expose your on-premises servers to the public internet, it's preferable to use an [on-premises data gateway][integration-data-gateway]. This gateway creates a secure read/write connection between your on-premises data sources and Azure. The on-premises data gateway is used with Logic Apps [connectors][azure-logic-app-connectors-list] to [connect][azure-logic-app-data-gateway-connect] local data sources to Azure. Before [installing an on-premises data gateway][integration-data-gateway-installation], consider the following:

- You can install an on-premises data gateway on any on-premises virtual machine. You can choose to install it on the same virtual machine as your server applications or on a co-located virtual machine with the appropriate network connectivity.
- The [architecture of the on-premises data gateway][integration-data-gateway-architecture] is designed to make outbound connections to [Azure Service Bus][azure-relay].
- Review the [additional considerations][integration-data-gateway-installation-considerations] for installing an on-premises data gateway.

An on-premises data gateway can be used with more than just Logic Apps. It's possible to use the same data gateway [installation][azure-logic-app-data-gateway-install] with:

- [Power BI][power-bi]
- [Power Automate][power-automate]
- [Power Apps][power-apps]
- [Azure Analysis Services][azure-analysis-services]

## Scalability considerations

- As the amount of Logic Apps flows increase, consider the capacity constraints of the on-premises servers. You'll need to determine if the on-premises servers can handle the increased workload.

## Availability considerations

- Avoid single point of failure issues for an on-premises data gateway by [installing the software on multiple on-premises virtual machines][azure-logic-app-data-gateway-availability].
- Consider implementing high availability topologies for your on-premises servers by using techniques such as:
  - [High availability architecture for SharePoint Server][sharepoint-server-availability]
  - [SQL Server AlwaysOn][sql-server-alwayson]

## Manageability considerations

- [Service Bus][azure-relay] is used for outbound data gateway communication. This might require configuring your firewall to [allow outbound connections to Azure][integration-data-gateway-installation-outbound].
- Consider [Azure ExpressRoute][azure-expressroute] if you want consistent throughput from your on-premises data sources to Azure.

## DevOps considerations

- The corresponding Azure resource for an on-premises data gateway should only be created after the corresponding software is installed on an on-premises virtual machine.
- Consider storing workflow configuration as a [JSON template][azure-logic-app-schema] within an [Azure Resource Manager template][azure-logic-app-arm] to automate deployment.

## Security considerations

- While it's possible to expose your on-premises servers to the public internet, it's preferable to use an on-premises data gateway. This  gateway creates a secure read/write connection between your on-premises data sources and Azure.

## Cost considerations

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- This reference assumes that the [consumption plan][azure-logic-app-consumption-plan] is used to create a global Logic Apps resource.
- This reference only uses standard connectors, which are metered at a lower price than enterprise connectors.

## Next steps

* [Connect an on-premises network to Azure](../reference-architectures/hybrid-networking/index.yml)
* [Extend an on-premises network using ExpressRoute](../reference-architectures/hybrid-networking/expressroute.yml)
* [Extend an on-premises network using VPN](../reference-architectures/hybrid-networking/vpn.yml)

[architectural-diagram]: ./images/gateway-logic-apps.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/gateway-logic-apps.vsdx
[azure-analysis-services]: /azure/analysis-services/
[azure-expressroute]: /azure/expressroute/
[azure-logic-app]: /azure/logic-apps/
[azure-logic-app-actions-compose]: /azure/logic-apps/logic-apps-perform-data-operations#compose-action
[azure-logic-app-actions-parse]: /azure/logic-apps/logic-apps-perform-data-operations#parse-json-action
[azure-logic-app-arm]: /azure/templates/microsoft.logic/workflows
[azure-logic-app-connectors]: /connectors/
[azure-logic-app-connectors-list]: /connectors/connector-reference/
[azure-logic-app-connectors-queue]: /connectors/azurequeues/
[azure-logic-app-connectors-sharepoint]: /connectors/sharepointonline/
[azure-logic-app-connectors-sql]: /connectors/sql/
[azure-logic-app-consumption-plan]: /azure/logic-apps/logic-apps-pricing#consumption-pricing-model
[azure-logic-app-data-gateway-availability]: /azure/logic-apps/logic-apps-gateway-install#high-availability-support
[azure-logic-app-data-gateway-install]: /azure/logic-apps/
[azure-logic-app-data-gateway-connect]: /azure/logic-apps/logic-apps-gateway-connection
[azure-logic-app-schema]: /azure/logic-apps/logic-apps-workflow-definition-language
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
[azure-relay]: /azure/azure-relay/
[azure-storage-queues]: /azure/storage/queues/
[azure-spring-cloud]: /azure/spring-cloud/
[integration-data-gateway]: /data-integration/gateway/service-gateway-onprem
[integration-data-gateway-architecture]: /data-integration/gateway/service-gateway-onprem-indepth
[integration-data-gateway-installation]: /data-integration/gateway/service-gateway-install
[integration-data-gateway-installation-considerations]: /data-integration/gateway/service-gateway-install#related-considerations
[integration-data-gateway-installation-outbound]: /data-integration/gateway/service-gateway-communication#enable-outbound-azure-connections
[java]: https://www.java.com/
[power-apps]: /powerapps/
[power-automate]: /power-automate/
[power-bi]: /power-bi/
[sharepoint-server]: /sharepoint/
[sharepoint-server-availability]: /sharepoint/administration/plan-for-high-availability
[spring]: https://spring.io
[sql-server]: /sql/
[sql-server-alwayson]: /sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server
