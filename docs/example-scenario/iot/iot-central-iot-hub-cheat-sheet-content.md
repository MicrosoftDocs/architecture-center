This article compares using [Azure IoT Central](https://azure.microsoft.com/services/iot-central) versus individual Azure platform-as-a-service (PaaS) components for building, deploying, and managing internet-of-things (IoT) solutions.

IoT solutions use a combination of technologies to connect devices, events, and actions through cloud applications. The technologies and services you choose depend on your scenario's development, deployment, and management requirements.

IoT Central provides a managed application platform-as-a-service (aPaaS) that combines many Azure components and capabilities. For greater customizability, you can combine [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) with other Azure PaaS components to create IoT solutions.

## Start with Azure IoT Central

IoT Central is a Microsoft aPaaS that assembles Azure PaaS components into an extensible, fully managed IoT app development and operations platform. IoT Central simplifies and accelerates solution development, streamlines operations, and eliminates guesswork and complexity to build reliable, scalable, and secure IoT solutions.

IoT Central offers:

- An out-of-the-box web user experience (UX) and API surface area that simplifies device management and rule creation.
- Extension of IoT intelligence into line-of-business applications to help act on insights.
- Built-in disaster recovery, multitenancy, global availability, and a predictable cost structure.

The following diagram shows an IoT Central-based architecture:

[ ![Diagram showing an IoT Central architecture and services like IoT Hub, Device Provisioning Service, and Azure Stream Analytics.](./media/iot-central-architecture.png) ](./media/iot-central-architecture.png#lightbox)

1. IoT Central takes device input through the [Azure IoT device SDKs](/azure/iot-develop/about-iot-sdks), [Azure RTOS](https://azure.microsoft.com/services/rtos), [Azure Sphere](https://azure.microsoft.com/services/azure-sphere), or [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge).
1. IoT Central provides:
   - Ingestion and provisioning services with IoT Hub and [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps/).
   - Hot path data storage and analytics through [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics).
   - Warm path data storage and analytics through [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer).
   - Cold path data storage and analytics through [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) and [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db).
   - A managed PaaS layer that delivers High Availability/Disaster Recovery (HADR) and elastic scale.
   - A management web user experience that lets you:
     - Manage devices with raw data view, connectivity status, device modeling, and jobs.
     - View and analyze device data with dashboards, analytics, and rules.
     - Secure data and devices with user management and organizations.
1. IoT Central extends solutions by triggering alerts, querying data, or exporting data.
1. IoT Central integrates with line-of-business apps like Power BI, Azure Maps, Search, API Management, Web Apps, Mobile Apps, Dynamics 365, Flow, or Logic Apps.

## Build with Azure PaaS services

If you need more control and customization, you can use individual Azure PaaS components to build an IoT solution.

The following diagram shows Azure PaaS services in an IoT-Hub based IoT architecture:

[ ![Diagram showing a reference architecture composed of Azure PaaS services.](./media/azure-iot-architecture.png) ](./media/azure-iot-architecture.png#lightbox)

1. IoT systems ingest device data through the Azure IoT device SDKs, Azure RTOS, Azure Sphere, or Azure IoT Edge.
1. IoT Hub, DPS, or [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) provide device provisioning, connectivity, and management.
1. The data storage and analytics hot path is through Azure Stream Analytics or [Azure HDInsight](https://azure.microsoft.com/services/hdinsight) Apache Spark and Storm. The warm path is through [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights) or Azure Data Explorer. The cold path is through Azure SQL Database or Azure Cosmos DB.
1. Management and business integration services include Power BI, Azure Maps, Search, API Management, Web Apps, Mobile Apps, Dynamics 365, Flow, and Logic Apps.

For a detailed PaaS IoT reference architecture and discussion, see [Azure IoT reference architecture](../../reference-architectures/iot.yml).

## Compare aPaas and PaaS approaches

IoT Central lets you avoid maintaining and updating a complex and evolving IoT infrastructure. You can focus time and money on transforming your business and designing innovative offerings.

If your solution requires customized features or services that IoT Central doesn't support, you can develop a PaaS solution with IoT Hub as a core element.

The following comparison tables and links can help you decide whether to use an IoT Central managed solution or build a PaaS solution with IoT Hub.

### IoT Central vs. IoT Hub-based PaaS system

The following table describes how IoT Central or an IoT Hub-based PaaS system supports various IoT features and capabilities.

| Feature | IoT Central | IoT Hub-based PaaS |
|---|---|---|
| Description | Fully managed aPaaS solution that simplifies device connectivity and management at scale. An aPaaS-based solution is less customizable than a PaaS-based solution. | Use IoT Hub as a central message hub between the IoT application and the devices it manages. Add more functionality with other Azure PaaS services. This approach provides great flexibility, but requires more development and management effort. |
| Application development | [Application templates](/azure/iot-central/core/concepts-app-templates) help kick-start IoT solution development. Use a generic application template, or a prebuilt industry-focused template for [retail](/azure/iot-central/retail/overview-iot-central-retail), [energy](/azure/iot-central/energy/overview-iot-central-energy), [government](/azure/iot-central/government/overview-iot-central-government), or [healthcare](/azure/iot-central/healthcare/overview-iot-central-healthcare). | Design and build your own application solution using by using IoT Hub and other PaaS services. |
| Device template | Defines and manages device templates that help structure device type characteristics and behaviors. Use the templates for supported device management tasks and visualizations. | Create a repository to define and manage device message templates. |
| Device management | Built-in Azure Device Provisioning Service (DPS) capabilities provide [device integration and device management](/azure/iot-central/core/overview-iot-central#manage-your-devices). | Design and build your own solutions using IoT Hub primitives, such as device twin and direct methods. Enable DPS separately. |
| OPC UA protocol | Not supported. | OPC Publisher bridges the gap between OPC UA–enabled industrial assets and Azure hosted resources by publishing telemetry data to IoT Hub. OPC Publisher uses IEC62541 OPC UA PubSub standard format and other formats. For more information, see [Microsoft OPC Publisher](https://github.com/Azure/iot-edge-opc-publisher). |
| SigFox and LoRaWAN protocols | Uses IoT Central Device Bridge. For more information, see [Azure IoT Central Device Bridge](https://github.com/Azure/iotc-device-bridge#azure-iot-central-device-bridge) | Write a custom module on Azure IoT Edge and integrate with Azure IoT Hub. |
| Multi-tenancy | [Organizations](/azure/iot-central/core/howto-create-organizations) enable in-app multi-tenancy. You can define a hierarchy to manage which users can see which devices in the IoT Central application. | You can achieve multi-tenancy by using separate hubs per customer. You can also build access control into the solution's data layer. |
| Message retention | IoT Central retains data on a rolling, 30-day basis. | IoT Hub allows data retention in built-in event hubs for a maximum of seven days. |
| Big data | Manage data from within IoT Central. | Add and manage big data Azure PaaS services. |
| Data export | Can continuously export data by using the [export feature](/azure/iot-central/howto-export-data). Exports data to Azure blob storage, event hubs, service bus, webhook, and Azure Data Explorer. Can filter, enrich, and transform messages on egress. | Iot Hub provides a built-in event hub endpoint, and can use message routing to export data to other storage locations. |
| Analytics | An integrated analytics experience explores device data in the context of device management. | Use separate Azure PaaS services to incorporate analytics, insights, and actions, like Stream Analytics, Time Series Insight, Azure Data Explorer, and Azure Synapse. |
| Visualizations | A UX makes it simple to visualize device data, perform analytics queries, and create custom dashboards. | No built-in user interface. |
| Rules and actions | Has built-in rules and actions processing capability with email notification, Azure Monitor group, Power Automate, and webhook actions. For more information, see [Azure IoT Central rules and actions](/azure/iot-central/core/overview-iot-central#rules-and-actions). | IoT Hub can send data to Azure Stream Analytics, Azure Time Series Insights, or Azure Event Grid. Those services can connect to Azure Logic apps or other custom applications to process rules and actions. For more information, see [IoT remote monitoring and notifications with Azure Logic Apps](/azure/iot-hub/iot-hub-monitoring-notifications-with-azure-logic-apps). |
| Scalability | Supports auto-scaling. | Deploy solutions to enable IoT Hub auto-scaling. For more information, see [Auto-scale your Azure IoT Hub](/samples/azure-samples/iot-hub-dotnet-autoscale/iot-hub-dotnet-autoscale/). |
| High Availability and Disaster Recovery (HADR)| Built-in HADR capabilities are managed automatically. For more information, see [Best practices for device development in Azure IoT Central](/azure/iot-central/core/concepts-best-practices). | Configure your solution to support multiple HADR scenarios. For more information, see [Azure IoT Hub high availability and disaster recovery](/azure/iot-hub/iot-hub-ha-dr). |
| Service Level Agreement (SLA) | Guarantees 99.9% connectivity. For more information, see [SLA for Azure IoT Central](https://azure.microsoft.com/support/legal/sla/iot-central). | IoT Hub standard and basic tiers guarantee 99.9% uptime. The IoT Hub free tier has no SLA. For more information, see [SLA for Azure IoT Hub](https://azure.microsoft.com/support/legal/sla/iot-hub/v1_2). |
| Pricing | The first two active devices are free, if their message volume doesn't exceed 800 (Standard Tier 0 plan), 10,000 (Standard Tier 1 plan), or 60,000 (Standard Tier 2 plan) per month. Added device pricing is prorated monthly. IoT Central counts and bills the highest number of active devices each hour. For more information, see [Azure IoT Central pricing](https://azure.microsoft.com/pricing/details/iot-central) | For details about IoT Hub pricing, see [Azure IoT Hub pricing](https://azure.microsoft.com/pricing/details/iot-hub). |

### IoT Central and other Azure PaaS capabilities

The following table shows the extent of support for various capabilities in IoT Central and other Azure PaaS services. A filled in circle means full support, a half-filled circle indicates partial support, and an empty circle means no support.

|  |IoT Central|IoT Hub + DPS|Stream Analytics + Azure Functions|Azure Cosmos DB + Azure Data Explorer|Active Directory|
|--|--|--|--|--|--|
|**Description**|Ready-made IoT solution development environment|IoT data ingestion services|Stream processing services|Data storage services|Universal identity management and security platform|
|**High Availability and Disaster Recovery (HADR), elastic scale**|⚫|⚪|⚪|⚪|⚪|
|**Device connectivity, management experience**|⚫|◐|⚪|⚪|⚪|
|**Data routing, filtering, rules**|◐|◐|◐|⚪|⚪|
|**Analytics, visualizations**|◐|⚪|◐|⚫|⚪|
|**Data storage and security**|⚫|⚪|⚪|⚫|⚫|
|**Export, integration with other services**|⚫|⚫|⚫|⚫|⚫|

## Next steps

- [Azure IoT Central overview](/azure/iot-central/core/overview-iot-central)
- [Azure IoT Hub overview](/azure/iot-hub/about-iot-hub)
- [Device management with Azure IoT Hub](/azure/iot-hub/iot-hub-device-management-overview)
- [Azure IoT Hub high availability and disaster recovery](/azure/iot-hub/iot-hub-ha-dr)
- [Azure IoT Hub SDKs](/azure/iot-hub/iot-hub-devguide-sdks)
- [IoT remote monitoring and notifications with Azure Logic Apps](/azure/iot-hub/iot-hub-monitoring-notifications-with-azure-logic-apps)

## Related resources

- [IoT conceptual overview](introduction-to-solutions.yml)
- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [IoT and data analytics](../data/big-data-with-iot.yml)
- [Azure Industrial IoT guidance](../../guide/iiot-guidance/iiot-architecture.yml)
- [Vision AI with Azure IoT Edge](../../guide/iot-edge-vision/index.md)
- [Retail buy online, pick up in store (BOPIS)](./vertical-buy-online-pickup-in-store.yml)
- [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)
- [Blockchain workflow application](../../solution-ideas/articles/blockchain-workflow-application.yml)
- [IoT using Cosmos DB](../../solution-ideas/articles/iot-using-cosmos-db.yml)
- [Predictive maintenance with the intelligent IoT Edge](../predictive-maintenance/iot-predictive-maintenance.yml)
- [Predictive Maintenance for Industrial IoT](../../solution-ideas/articles/iot-predictive-maintenance.yml)
- [Sustainability Project 15 open platform](../../solution-ideas/articles/project-15-iot-sustainability.yml)
- [IoT connected light, power, and internet for emerging markets](../../solution-ideas/articles/iot-power-management.yml)
- [Condition Monitoring for Industrial IoT](../../solution-ideas/articles/condition-monitoring.yml)
