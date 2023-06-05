<!-- # Azure Digital Twins Builder -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea uses Azure Digital Twins and other Azure services to enable the process more effectively, from building information modeling (BIM) to digital twins (DT). The solution in this article uses Autodesk Forge data specifically, but using BIM data from other providers can work also. The idea is broadly applicable to the process of creating a DT from BIM data.

## Architecture

:::image type="content" source="../media/azure-digital-twins-builder-new.png" alt-text="Architecture for creating digital twins by using Azure Digital Twins and an app that makes use of BIM data." lightbox="../media/azure-digital-twins-builder-new.png" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/azure-digital-twins-builder.vsdx) of this architecture.*

### Dataflow

1. A web app that was built by using Static Web Apps presents two buttons to the user. One of them initiates sign-in to Azure, the other initiates sign-in to Autodesk BIM 360. The user signs into both accounts.
1. The web app uses the Autodesk Forge API to build a list of the BIM models that are shared with the BIM 360 account. The user selects a model for the web app to display, which it does by once again making use of the Autodesk Forge API.
1. The user selects **Parse Model**, which triggers a request to a function that was built by using Azure Functions. The function uses the Autodesk Forge API to extract the metadata of the model that the user selected.
1. Data such as an entity's family type—for example, space, HVAC, mechanical—and its relationship to other entities—for example, the space where an asset is located—is stored by the function in an Azure SQL database. The function uses this data to map the entities to Digital Twin Definition Language (DTDL) models. The results are returned to the web app in a table for the user to view.
1. The user updates the table to correct any mapping mistakes, and to add additional initialization properties to the digital twins that are instantiated from this data. The user can also remove records and create additional assets like sensors or IoT devices.
1. When satisfied that the table is correct, the user selects **Upload to ADT** to cause the web app to load the table to Azure Digital Twins as a DT.

### Components

- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) stores digital representations of IoT devices and environments. You can use this data for data propagation or real-time analysis. Azure Digital Twins:

  - Models environments with DTDL.
  - Has a REST API for entering data.
  - Provides SDKs that support control and data plane operations for various languages.

  You can build ontologies by using DTDL. You can also start with an industry-supported model such as the [Digital Twins Definition Language-based RealEstateCore ontology for smart buildings](https://github.com/azure/opendigitaltwins-building).
- [Autodesk Forge](https://forge.autodesk.com) is the API service for Autodesk and BIM 360. It provides the model viewer and BIM models metadata.
- [Static Web Apps](https://azure.microsoft.com/services/app-service/static) is an Azure service that, in this architecture, hosts the front-end code of the web app. The Autodesk Forge Viewer API is well supported by React.
- [Azure Functions](https://azure.microsoft.com/services/functions/#overview) is an event-driven serverless compute platform. It runs on demand and at scale in the cloud. With it, you can develop without having to worry about managing a server. In this architecture, it hosts the back-end code for the web app.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/#overview) stores and parses the extracted metadata from a model. Due to the complexity of a model's metadata, Autodesk recommends parsing the data by uploading it to Azure SQL Database in a specific structure, and then using a query that Autodesk provides.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) provides temporary storage for data that will be used to create a DT, but isn't yet ready for publishing by Azure Twins Service.

## Scenario details

Creating a digital twins (DT) solution for a facility requires extensive data entry that's done by using either Azure native tools or external tools. The data often requires interpretations of drawings, documentation, and data models of other relevant systems of record. Such interpretations risk data fidelity, and cause inefficiencies in the DT implementation process, inefficiencies that hinder the adoption of DTs.

Architecture, engineering, and construction (AEC) professionals use building information modeling (BIM) as a foundation for efficient design and construction processes. BIM is the most effective tool for modeling a facility and its supporting systems, and produces a flexible, parametric, and relational dataset that can comprehensively document a built asset. It's becoming the industry standard tool for planning and managing the built environment.

BIM data is exceptionally valuable, and it can be improved with a digital representation, based on sensor telemetry, of the physical environment. Such a representation is known as a digital twin (DT). DTs help real estate owners and operators manage the operations of their buildings. This is the digital building lifecycle approach to managing.

This solution idea uses Azure Digital Twins and other Azure services to enable this process more effectively, from BIM to DT. Creating a DT for a facility requires extensive data entry that's done by using either Azure native tools or external tools. The data often requires interpretations of drawings, documentation, and data models of other relevant systems of record. Such interpretations risk data fidelity, and cause inefficiencies in the DT implementation process, inefficiencies that hinder the adoption of DTs.

The key to the solution is having a web app that uses BIM data from Autodesk Forge to automate the creation of an Azure Digital Twins foundational dataset. The app provides both visual and relational context to support the instantiation of a DT in the Azure Digital Twins build process.

By providing the basis for holistic, responsive, and automated building management systems, this app helps address the vast range of challenges that arise when managing buildings digitally at large scale.

The solution in this article uses Autodesk Forge data specifically, but using BIM data from other providers can work also. The idea is broadly applicable to the process of creating a DT from BIM data.

> [!Important]
> This document is created strictly for informative purposes to demonstrate how Autodesk Forge API can supply BIM data to a web app that creates a DT. Your use of third-party applications is subject to terms between you and the third party. Microsoft Corporation is not affiliated with, is not a partner to, and does not endorse or sponsor Autodesk or any of Autodesk's products. There are other sources of BIM data that you can use to create DTs.

### Potential use cases

This solution is ideal for the facilities, real-estate, manufacturing, energy, and government industries. 

BIM models can describe many structures besides offices, including:

- Datacenters.
- Factories.
- Power plants.
- Bridges.

These structures become more intelligent and advanced as sensors and connected devices become smaller and more affordable. Azure Digital Twins can bring greater accuracy, control, and predictability to the building owner’s building management data. You can, for example, manage frequency sensors within Azure Digital Twins for predictive maintenance of building roof chillers.

Real estate portfolio managers can use BIM and DTs to improve their understanding of the elements within defined spaces, for better building space management.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Marcus Farquhar](https://www.linkedin.com/in/marcusfarquhar) | Technology Innovation and Experimentation Lead
- [Kian Lutu](https://www.linkedin.com/in/kianlutu) | Program Manager for the Center of Innovation

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Digital Twins Documentation](/azure/digital-twins)
- [Autodesk Forge](https://forge.autodesk.com/developer/documentation)
- [Digital Twins Definition Language (GitHub)](https://github.com/azure/opendigitaltwins-dtdl)
- [RealEstateCore, a smart building ontology for digital twins (video)](/shows/internet-of-things-show/realestatecore-a-smart-building-ontology-for-digital-twins)
- [RealEstateCore ontology](https://github.com/Azure/opendigitaltwins-building)

## Related resources

- [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)
- [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml)
- [Facilities management powered by mixed reality and IoT](facilities-management-powered-by-mixed-reality-and-iot.yml)
- [Cognizant Safe Buildings with IoT and Azure](safe-buildings.yml)
- [COVID-19 safe environments with IoT Edge monitoring and alerting](cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)
- [Facilities architectures](../../browse/index.yml?terms=facilities)
