[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Improve uptime and operations in travel and hospitality, manufacturing, retail, and more with mixed reality and IoT.

## Architecture

![Diagram that shows facilities management powered by mixed reality and I o T.](../media/facilities-management-powered-by-mixed-reality-and-iot.svg)

*Download a [Visio file](https://arch-center.azureedge.net/facilities-management-powered-by-mixed-reality-and-iot.vsdx) of this architecture.*

### Dataflow

1. The client authenticates to the facilities management web service and specifies the space's name in the [Azure Digital Twins](/azure/digital-twins) object model.
1. The client's web service authenticates itself to [Azure Active Directory (Azure AD)](/azure/active-directory).
1. The Azure AD token is then sent to the [Azure Spatial Anchors](/azure/spatial-anchors) service to retrieve an access token for the client to use later.
1. Your app service retrieves information about the IoT sensors present in the area specified by the client. It returns IoT sensor IDs and their anchor IDs in Azure Spatial Anchors.
1. The Azure Spatial Anchors authorization token is returned to the client alongside the anchor IDs of the IoT sensors and other metadata required by the client application.
1. The client application completes a visual scan of the environment and retrieves its position in the area. It retrieves the position of all nearby anchors by using the nearby API of Azure Spatial Anchors.
1. The client application requests IoT sensor data and controls to be displayed as holograms in the space where the sensors exist, making it easy for the operator to detect and fix any issues. The data is fetched by the app's web service from [Azure Cosmos DB](/azure/cosmos-db), the service storing this data.
1. When IoT sensor data is updated, Azure Digital Twins pushes it to [Event Hubs](/azure/event-hubs).
1. [Azure Functions](/azure/azure-functions) uses an Event Hubs trigger to process the change and update data in Azure Cosmos DB as needed.

### Components

* [Spatial Anchors](https://azure.microsoft.com/services/spatial-anchors): Create multi-user, spatially aware mixed-reality experiences.
* [Azure AD](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db): Globally distributed, multi-model database for any scale.
* [App Service](https://azure.microsoft.com/services/app-service): Quickly create powerful cloud apps for web and mobile.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs): Receive telemetry from millions of devices.
* [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins): Build next-generation IoT spatial intelligence solutions.

## Scenario details

### Potential use cases

This scenario shows how you can visualize a virtual replica of your physical space with real-time data in the context of your environment. It's built on [Azure Spatial Anchors](https://azure.microsoft.com/services/spatial-anchors) and [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins).

## Next steps

* [Share Spatial Anchors across devices](/azure/spatial-anchors/tutorials/tutorial-share-anchors-across-devices)
* [Create a new tenant in Azure Active Directory](/azure/active-directory/fundamentals/active-directory-access-create-new-tenant)
* [Build a .NET web app with Azure Cosmos DB for NoSQL and the Azure portal](/azure/cosmos-db/create-sql-api-dotnet)
* [Authenticate and authorize users end-to-end in Azure App Service](/azure/app-service/app-service-web-tutorial-auth-aad)
* [Azure Event Hubs - A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
* [Deploy Azure Digital Twins and configure a spatial graph](/azure/digital-twins/tutorial-facilities-setup)
* [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

## Related resources

* [Azure digital twins builder](../../solution-ideas/articles/azure-digital-twins-builder.yml)
* [Training and procedural guidance powered by mixed reality](../../solution-ideas/articles/training-and-procedural-guidance-powered-by-mixed-reality.yml)
* [Cognizant Safe Buildings with IoT and Azure](../../solution-ideas/articles/safe-buildings.yml)
* [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)
