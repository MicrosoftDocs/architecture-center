This article presents a solution for extracting text from images so it can be indexed and retrieved in SharePoint. By using AI Builder and Azure Form Recognizer, you can configure a Power Automate workflow to use a trained model to extract text from an image. Once you've configured a workflow, you can quickly search documents for meaningful text that's embedded in shapes and objects.

## Architecture

![Architecture diagram for using AI Builder to extract text from objects by using AI.](./media/architecture-extract-object-text.svg)

*Download a [Visio file](https://arch-center.azureedge.net/architecture-extract-object-text.vsdx) of this architecture.*

### Workflow

1. An object detection model is trained in AI Builder to recognize objects that a user specifies.
1. A new document enters a SharePoint document library, OneDrive, or Teams.
1. The document's arrival triggers a Power Automate event. That event:
   1. Runs the AI Builder model. AI Builder returns a JSON file that contains the pixel coordinates of any specified objects.
   1. Sends the document to Form Recognizer for a full optical character recognition (OCR) scan. Form Recognizer returns a JSON file that contains scanned-in text and pixel coordinates of the text.
   1. Runs a function in Azure Functions. The function analyzes the pixel coordinates in the AI Builder and Form Recognizer output files. If detected objects intersect with scanned-in text, the function returns the matched data in a JSON file.
   1. Enters the metadata, or the text from detected objects, into a document library.
1. The metadata is captured in a SharePoint search index.
1. Users search for the metadata by using PnP Modern Search web parts.

### Components

- [AI Builder](/ai-builder/overview) is a Power Platform capability. Use AI Builder to train models to recognize objects in images. AI Builder also offers prebuilt models for object detection.
- [Form Recognizer](https://azure.microsoft.com/services/form-recognizer) uses machine-learning models to extract and analyze form fields, text, and tables from your documents.
- [Power Automate](https://azure.microsoft.com/services/developer-tools/power-automate) is a part of Power Platform's no-code or low-code intuitive solutions. Power Automate is an online workflow service that automates actions across apps and services.
- [Azure Functions](https://azure.microsoft.com/en-us/services/functions) is an event-driven serverless compute platform. Azure Functions runs on demand and at scale in the cloud.
- [PnP Modern Search](https://microsoft-search.github.io/pnp-modern-search) solution is a set of SharePoint Online modern web parts. By using these tools, you can create highly flexible and personalized search-based experiences.

### Alternatives

- Azure Cognitive Services can do a full OCR scan of documents, with the resulting metadata stored in SharePoint.
- SharePoint can run OCR scans on documents and add content output to the index for retrieval. Use search techniques to target key information in documents.
- If you want to process a high rate of documents, consider using Azure Logic Apps to configure the components. Azure Logic Apps prevents you from hitting consumption limits in your tenant, and is cost-effective.  For more information, see [Azure Logic Apps](/azure/logic-apps/logic-apps-overview).

## Scenario details

Schematic and industrial diagrams often have objects that contain text. Manually scanning documents for relevant text can be laborious and time consuming.

### Potential use cases

Use cases include:

- Complicated engineering schematic diagrams that contain various types of objects. By using this solution, you can quickly search for specific components on a diagram. Having access to embedded text in objects is helpful for investigations, exposing shortages, or looking for recall and failure notices.
- Industrial diagrams that show the components in a manufacturing assembly. This solution promptly identifies pumps, valves, automated switches, and other components. Identifying components helps with preventative maintenance, isolating hazardous components, and increasing the visibility of risk management in your organization.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider these points when you analyze and process documents:

- AI Builder can only capture square coordinates when using a trained model. Objects with text outside their boundaries, like triangles and circles, could potentially add unwanted and unnecessary information.
- The metadata that's output from Azure Functions can contain extra characters if there's text outside the object's boundaries.
- The AI Builder creation process can tag more than one object. The resulting JSON file from Azure Functions contains all object types and text. The application consumes the metadata and needs to parse through and process the results.

### Availability

Azure replicates data to ensure durability and high availability. Data redundancy protects you from planned and unplanned events, including transient hardware failures, network or power outages, and natural disasters. Choose to replicate your data within the same data center, across zonal data centers within the same region, or across geographically separated regions.

### Scalability

Azure Functions is highly scalable. This platform offers multiple plans that automatically scale on demand when events are triggered. For more information, see [Event-driven scaling](/azure/azure-functions/event-driven-scaling).

Azure Functions has a limit of 200 instances. If you need to scale beyond this limit, add multiple regions or app plans.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Use standard security practices for the components that you use, and for the SharePoint document library that you store the metadata in.

Form Recognizer is designed with compliance, privacy, and security in mind.  It authenticates access by using an API key, encrypts data during transit and storage, and returns results by using the API key. For more information, see [Data, privacy, and security for Form Recognizer](/legal/cognitive-services/document-intelligence/data-privacy-security).

AI Builder relies on environment security and Dataverse security roles and privileges to grant access to AI features in Power Apps. Privileges are set by default in Dataverse. System administrators can use the default built-in security roles without further actions. For more information, see [Security overview](/power-platform/admin/wp-security).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- For Power Automate, make sure the licenses that you've purchased and assigned are adequate for the volume of documents that you process. Include an HTTP premium connector to call Form Recognizer and Azure Functions.
- Purchase AI Builder credits based on the expected model usage.
- To estimate the cost of Azure products and configurations, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

## Deploy this scenario

For more information on deploying this scenario, see the [Power Automate Community Blog](https://powerusers.microsoft.com/t5/Power-Automate-Community-Blog/Extract-Text-From-Objects/ba-p/1249705) and the [Extract Text From Objects](https://github.com/Spucelik/ExtractTextFromObjects) GitHub repo.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Steve Pucelik](https://www.linkedin.com/in/stevepucelik) | Sr. Specialist

## Next steps

- Understand the types of documents that would be well suited for this solution. Typical documents include schematic diagrams, manufacturing control processes, and diagrams that contain many shapes that need to be isolated.  For more information, see [Form Recognizer models](/azure/applied-ai-services/form-recognizer/concept-custom).
- Become familiar with the capabilities that AI Builder offers. For more information, see [AI Builder in Power Automate overview](/ai-builder/use-in-flow-overview).
- Define an information architecture that can receive and process your metadata. For more information, see [Cognitive Search skill set](../../solution-ideas/articles/cognitive-search-with-skillsets.yml).
- For information on how the solution works and whether it's suitable for your use cases, see [Extract text from objects](https://powerusers.microsoft.com/t5/Power-Automate-Community-Blog/Extract-Text-From-Objects/ba-p/1249705).

## Related resources

- [Knowledge mining for content research](../../solution-ideas/articles/content-research.yml)
- [Knowledge mining in contract management](../../solution-ideas/articles/contract-management.yml)
- [Knowledge mining in digital asset management](../../solution-ideas/articles/digital-asset-management.yml)
- [Vision classifier model with Azure Custom Vision Cognitive Service](../dronerescue/vision-classifier-model-with-custom-vision.yml)
