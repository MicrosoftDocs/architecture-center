Schematic and industrial diagrams have objects with text inside. Instead of manually extracting the text from these objects, AI Builder can retrieve this information for you. The Power Automate workflow can use a trained model to extract text from an image. This would allow your organization to index and retrieve this information in SharePoint.

## Potential use cases

Search documents for meaningful text imbedded in shapes and objects. Manually scanning an entire document, reduces the contextual relevancy for the specific object you’re trying to isolate.

Use cases include:

- Engineering schematic diagrams are complicated and contains various types of objects. A user can search for a specific component on a diagram. This can be helpful for investigations, exposing shortages, or looking for recall/failure notices.
- Industrial diagrams show the components in a manufacturing assembly. You can identify pumps, valves, automated switches, and other components. This will help with preventative maintenance, isolating hazardous components, and an organization-wide exposure for risk management.

## Architecture

![Architecture diagram for using AI Builder to create text from objects using AI.](./media/architecture-extract-object-text.png)

1. An AI Builder model using the Object Detection template is created, identifying the objects you want to capture. This will produce a JSON file, detecting the object and pixel coordinates.
1. Forms Recognition in Azure Cognitive Services is configured to receive the document where an optical character recognition (OCR) scan is conducted. The result is a JSON file with text captured and pixel coordinates.
1. An Azure Function analyzes both JSON file outputs and determines if the object detected, intersects with text from Azure Cognitive Services.
1. Documents are ingested through SharePoint document libraries, OneDrive, or Teams collaboration.
1. Power Automate is configured to trigger an event when a new document is received, calling the AI Builder Model, Cognitive Services, and the Azure function. This process populates the document library with metadata from the documents
1. Metadata is captured in the SharePoint search index.
1. Users can search for text only, within a given object, using the Modern PnP Search Web Parts.

### Components

- [AI Builder](https://docs.microsoft.com/en-us/ai-builder/overview) in the Power Platform, is used to train an [object detection model](https://docs.microsoft.com/en-us/ai-builder/object-detection-model-in-flow) to recognize  objects the user specifies.
- [Form Recognizer](https://azure.microsoft.com/en-us/services/form-recognizer/) in [Azure Cognitive Services](https://azure.microsoft.com/en-us/services/cognitive-services/) will receive the document and then it will go through a full OCR scan.
- The AI Builder model and Forms Recognizer both return a JSON file containing pixel coordinates for the object and text OCR'd. These files are then passed to an Azure function, where analysis is done. This analysis determines whether the pixel coordinates for the object detected, in AI Builder, intersect with the text OCR'd in Forms Recognizer. If they do, then it's considered a match and the text is returned in a JSON file for consumption.
- [Power Automate](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/power-automate/power-automate) is used as the trigger for a SharePoint document library, OneDrive location, or Microsoft Teams. When a new document is added, the above components are used to process the document, ultimately retrieving metadata (text from the object) to store.
- The [PnP Modern Search](https://microsoft-search.github.io/pnp-modern-search/) web parts are configured, so users can search for metadata related to the documents processed.

### Alternatives

- [Cognitive Services](https://docs.microsoft.com/en-us/azure/cognitive-services/what-are-cognitive-services) can do a full OCR scan of the document, with the resulting metadata stored in SharePoint.
- SharePoint can OCR documents and add the entire content to the index for retrieval. Search techniques can be used to target key information on the documents.

### Considerations

As the documents are analyzed and processed, here are some considerations:

- AI Builder will only allow you to capture square coordinates when training a model. Objects with text outside their boundaries, like triangles and circles, could potentially add unwanted and unnecessary information.
- The metadata that is output from the Azure Function, as it processes both JSON files, could contain extra characters if there's text outside the object’s boundaries.
- There can be more than one object tagged during the AI Builder creation process. The resulting JSON file from the Azure function will contain all object types and text. The application consuming the metadata will need to parse through and process the results, based on the use cases.

### Availability

In [Cognitive Search]( https://docs.microsoft.com/en-us/azure/search/search-performance-optimization#high-availability), availability is achieved through multiple replicas, but business continuity (and disaster recovery) is achieved through multiple search services.  [Create multiple replicas]( https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#add-or-reduce-replicas-and-partitions) ensuring durability and high availability.

Data redundancy protects you from planned and unplanned events—including transient hardware failures, network or power outages, and massive natural disasters. You can choose to replicate your data within the same data center, across zonal data centers within the same region, or across geographically separated regions.  For more information on [data recovery](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/cognitive-services-security-baseline#data-recovery).

No SLA is provided for the Free tier. For more information, see [SLA for Azure Cognitive Search](https://azure.microsoft.com/en-us/support/legal/sla/search/v1_0/)

### Scalability

[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) offers multiple plans, that automatically scales on demand when an [event](https://docs.microsoft.com/en-us/azure/azure-functions/event-driven-scaling) is triggered and is highly scalable.

Customers wanting to process a high rate of documents should consider using an [Azure Logic App](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview), to configure the components. Logic App will generally be cheaper and avoid any consumption limits in their tenant.

>**NOTE:** Azure Functions has a limit of a maximum of 200 instances. If you need to scale beyond this limit, consider multiple regions or app plans.

### Security

Customers should apply normal security to the components being used and for the SharePoint document library the metadata will be stored in.

[Form Recognizer](https://docs.microsoft.com/en-us/legal/cognitive-services/form-recognizer/fr-data-privacy-security) is designed with compliance, privacy, and security in mind.  It will authenticate access using an API key, encrypt data during transit and storage, and returns results using the API key.

AI Builder relies on environment security and Microsoft Dataverse security roles and privileges, to grant access to AI features in Microsoft Power Apps. For more information, see [Security overview](https://docs.microsoft.com/en-us/power-platform/admin/wp-security).

Some privileges are set by default in Dataverse. This allows built-in security roles to use AI Builder without further actions from system administrators.

## Deploy this scenario

Steps to deploy the solution can be found in this [blog article](https://powerusers.microsoft.com/t5/Power-Automate-Community-Blog/Extract-Text-From-Objects/ba-p/1249705) and also the [GitHub repo](https://github.com/Spucelik/ExtractTextFromObjects).

## Pricing

Customer should take into considerations the impact of executing this solution based on the components used.

- Power Automate – review the volume of documents being processed against licenses purchased and assigned. You must also have the HTTP premium connector to call the Forms Recognizer and Azure function.
- AI Builder credits should be purchased based on the expected model utilization.
- Cognitive Services consumption for the Forms Recognizer module should be estimated and planned accordingly. The [Azure calculator](https://azure.microsoft.com/en-us/pricing/calculator) can assist with estimating usage.

## Next steps

Customers determining if this solution is to be considered should:

- Understand the types of documents that would be well suited for this solution.  Typical documents include schematic diagrams, manufacturing control processes, and diagrams containing many shapes that need to be isolated.
- Become familiar with the capabilities offered in AI Builder and Cognitive Services.
- Have a defined information architecture to support receiving the metadata and using it to solve the identified use case.
- Review the [in-depth blog](https://powerusers.microsoft.com/t5/Power-Automate-Community-Blog/Extract-Text-From-Objects/ba-p/1249705) article explaining how the solution works and if it’s suitable for the use cases identified.
- Download and review the solution components for configuration in their tenant.
