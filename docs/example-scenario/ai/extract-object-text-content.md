This article presents a solution for extracting text from images so it can be indexed and retrieved in Microsoft 365. By using AI Builder and Azure Document Intelligence in Foundry Tools, you can configure a Power Automate workflow that uses a trained model to extract text from images. After you configure the workflow, you can quickly search documents for meaningful text that's embedded in shapes and objects. For example, you can search engineering schematics for the part number inside a specific component, or find every valve labeled in a set of plant diagrams, without opening and scanning each file by hand.

## Architecture

:::image type="complex" alt-text="Architecture diagram for using AI Builder to extract text from objects by using AI." source="media/architecture-extract-object-text.svg" lightbox="media/architecture-extract-object-text.svg" border="false":::
  The diagram shows the process of extracting data from documents, indexing the data, and retrieving it with Search. The diagram is arranged as four areas from left to right: Microsoft 365, AI processing, Business automation, and User experience. The Microsoft 365 area contains icons for SharePoint, Teams, and OneDrive. AI processing contains AI Builder, Document Intelligence, and Azure Functions. Business automation contains Power Automate above a Search index. User experience contains a web browser. Numbered callouts map to the workflow: 1 is on AI Builder; 2 is at the top of Microsoft 365; 3 is on Power Automate; 4, 5, and 6 are on AI Builder, Document Intelligence, and Azure Functions; 7 is at the bottom of Microsoft 365; 8 is on the Search index; and 9 is on the browser.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-extract-object-text.vsdx) of this architecture.*

### Workflow

The following workflow steps correspond to the numbers in the preceding diagram:

1. A maker trains an object-detection model in AI Builder to recognize specific objects.
1. A user uploads a document that contains text in objects to a SharePoint or OneDrive document library, either directly or through Microsoft Teams.
1. The upload event triggers a Power Automate flow.
1. The flow runs the AI Builder model against the uploaded document to detect objects. AI Builder returns a JSON file that contains the pixel coordinates of all detected objects.
1. Power Automate also sends the document to Azure Document Intelligence in Foundry Tools for a full optical character recognition (OCR) scan. Document Intelligence returns a JSON file that contains the extracted text and its pixel coordinates.
1. The flow calls a function in Azure Functions that compares the pixel coordinates from the AI Builder and Document Intelligence outputs. When detected objects intersect with extracted text, the function returns the matched text and object information as a JSON payload.
1. The flow writes the matched text and metadata to the original document in Microsoft 365.
1. Microsoft Search indexes the document's new metadata so it's discoverable across Microsoft 365.
1. Users can search for the metadata in SharePoint by using PnP Modern Search web parts.

### Components

This solution uses the following components from Microsoft Power Platform, Azure, and Microsoft 365.

#### Microsoft Power Platform

- [AI Builder](/ai-builder/overview) is a Microsoft Power Platform capability that lets makers add AI to apps and flows. This scenario uses AI Builder to train and run a custom object-detection model that identifies objects of interest in images.
- [Power Automate](/power-automate/getting-started) is a low-code workflow service that automates actions across apps and services. In this scenario, Power Automate orchestrates the flow starting from the document upload trigger through writing extracted metadata back to SharePoint libraries.

#### Azure

- [Document Intelligence](/azure/ai-services/document-intelligence/overview) is a cloud-based Foundry Tools service that uses machine learning to do OCR and intelligent document processing. In this scenario, it does a full-page OCR scan on each uploaded document and returns extracted text with pixel coordinates.
- [Azure Functions](/azure/azure-functions/functions-overview) is an event-driven serverless compute service. This scenario uses an [HTTP-triggered](/azure/azure-functions/functions-bindings-http-webhook-trigger) function to host geometry logic that compares the pixel coordinates returned by AI Builder and Document Intelligence, and returns the intersecting text. Power Automate calls the function over HTTP and uses the response, so an HTTP trigger is appropriate.

#### Microsoft 365

- [SharePoint](/sharepoint/introduction), [OneDrive](/onedrive), and [Teams](/microsoftteams/teams-overview) in Microsoft 365 are the upload sources that trigger the Power Automate flow, and are also the storage targets where the flow writes the extracted metadata.
- [Microsoft Search](/microsoftsearch/overview-microsoft-search) indexes the extracted-text metadata so it becomes discoverable across Microsoft 365.
- [PnP Modern Search](https://microsoft-search.github.io/pnp-modern-search/) is a set of open-source SharePoint web parts you can use to build flexible, personalized search experiences by using the Microsoft Search index.

### Alternatives

- **Use Azure Content Understanding for unstructured or multimodal inputs.** Document Intelligence is part of [Azure Content Understanding](/azure/ai-services/content-understanding/overview) in Foundry Tools, which adds LLM-powered analyzers for unstructured and multimodal content. If your inputs include unstructured content like freeform images, audio, or video in addition to structured documents, or you need to reason over the content rather than just transcribe it, consider using Content Understanding tools. For example, you might need to summarize the revision notes on an engineering drawing, classify a diagram by equipment type, or answer questions that require interpreting the content, not just reading the text. For more information, see [Choose the right Foundry Tools for document processing](/azure/ai-services/content-understanding/choosing-right-ai-tool).
- **Use Document Intelligence alone.** If you don't need to scope OCR results to specific objects in an image, you can skip AI Builder and the geometry-comparison function app, and use [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) to run OCR on the entire document. Then have Power Automate store the resulting text as metadata in Microsoft 365.
- **Use built-in SharePoint OCR.** SharePoint in Microsoft 365 can do OCR on images and PDFs and add the extracted text to the search index. This option doesn't require a custom flow, but also doesn't expose the structured object and coordinate mapping that the current solution provides.
- **Use Azure Logic Apps for high-volume processing.** If you want to process documents at a high rate or avoid Power Automate per-flow throttling, replace Power Automate with [Logic Apps](/azure/logic-apps/logic-apps-overview), which offers dedicated workflow tiers and higher action limits. For more information, see [Logic Apps limits and configuration](/azure/logic-apps/logic-apps-limits-and-config?tabs=consumption).

## Scenario details

Schematic and industrial diagrams often contain objects that include text. For example, a building plan might label individual rooms, electrical circuits, and HVAC equipment, or an engineering schematic might show a part number inside each component. Manually scanning these documents for relevant text is laborious and time consuming. This solution combines a custom object-detection model with OCR so that you can search for embedded text by the object it appears in, not just by the document it's in.
 

### Potential use cases

- **Engineering schematics.** Complex schematics contain many object types, such as components, callouts, and revision blocks. Use this solution to quickly find specific components in a schematic. Searchable embedded text is useful for conducting investigations, identifying part shortages, and finding recall and failure notices.
- **Industrial diagrams.** Diagrams that describe a manufacturing assembly often label pumps, valves, automated switches, and other components. Indexing the text inside those objects supports preventive maintenance, isolation of hazardous components, and risk-management visibility.
- **Architectural and facility drawings.** Floor plans, electrical plans, and HVAC drawings label rooms, circuits, and equipment. Indexing those labels makes it easier to locate specific assets across a large drawing set.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Plan for transient failures.** Document Intelligence returns HTTP 429 errors when concurrent-request limits are exceeded. The Power Automate flow calls Document Intelligence directly, so configure retries with exponential backoff on that action in the flow. 
- **Make the flow idempotent.** SharePoint and OneDrive triggers can replay events. Design the Power Automate flow and downstream metadata writes to be safe when a document is processed more than once. For example, upsert metadata that's keyed on the document ID.
- **Handle long-running OCR scans.** OCR of large, multipage documents can take a long time, and Document Intelligence processes the operations as asynchronous. Design the Power Automate flow that calls Document Intelligence to submit the document and poll for the result, rather than expect an immediate response. Build in timeout handling so that a slow scan doesn't cause a run to fail.
- **Understand the service level agreement (SLA) for each service.** Review the [SLAs](https://aka.ms/csla) and recovery characteristics for Document Intelligence, Functions, and Power Automate to ensure that your reliability targets are achievable.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **Use managed identity, not keys.** Configure the Azure function to authenticate to AI Builder and Document Intelligence by using [Microsoft Entra ID](/azure/ai-services/authentication#authenticate-with-microsoft-entra-id) with a system-assigned or user-assigned managed identity. This approach removes the need to store service keys.
- **Store any remaining secrets in Azure Key Vault.** If you must use keys, for example in a Power Automate connector, store the keys in [Key Vault](/azure/key-vault/general/overview) and retrieve them at runtime by using the Azure Key Vault connector. Setting up the connector requires creating a connection with a supported Microsoft Entra authentication type. For the connection options, see the [Azure Key Vault connector reference](/connectors/keyvault) and the [get secret action](https://learn.microsoft.com/en-us/connectors/keyvault/#get-secret). The get-secret output might appear in the flow run history, so make sure to secure access to the run history.
- **Respect document permissions.** When you write extracted text back as SharePoint metadata, make sure the indexed metadata inherits the source document's permissions so that search results stay correctly trimmed.
- **Plan for sensitive content.** OCR output can contain personal data, secrets, or other sensitive content. Apply [Microsoft Purview](/purview/purview) sensitivity labels and data loss prevention policies to documents and their metadata as needed.
- **Isolate the network.** For regulated workloads that require network isolation, integrate the Functions app into your [virtual network](/azure/azure-functions/functions-networking-options) and use [private endpoints](/azure/ai-services/cognitive-services-virtual-networks) for AI Builder and Document Intelligence.
- **Apply least privilege to connectors.** In Power Automate, grant connections the minimum scope they need, for example a single SharePoint site rather than the whole tenant.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Choose the right Document Intelligence tier.** Document Intelligence bills per page and offers free (F0) and standard (S0) tiers. Estimate your page volume by using the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) and select the appropriate tier before you go to production.
 - **Filter before you call.** Use a Power Automate condition to skip unsupported files so you don't consume capacity on irrelevant uploads. If you accept PDFs, render each page to a supported image format and send the same page image to both AI Builder and Document Intelligence, so both outputs use the same pixel coordinate space. Preserve the PDF page number with each image before matching the results.
- **Plan AI Builder credit consumption.** AI Builder is licensed by credits that it consumes per model run. Review [Licensing and AI Builder credits](/ai-builder/credit-management) and add capacity if you need it.
- **Choose the right Power Automate license.** Choose a [Power Automate Premium user or Power Automate Process license](/power-platform/admin/power-automate-licensing/types) based on whether you need to license individual users or the flow itself.
- **Estimate Azure costs.** Use the [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/97bc706f51b14769bc69f9084af3e2e8) for the approximate Azure service costs for this scenario. Adjust the values to match your expected document volumes. This estimate covers only the Azure services in this scenario, including Azure Document Intelligence S0 tier for OCR processing and Azure Functions Consumption plan for pixel coordinate matching logic. Power Platform AI Builder and Power Automate components and Microsoft 365 SharePoint, OneDrive, and Teams are licensed separately and aren't included in this estimate.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Use Power Platform solutions for application lifecycle management (ALM).** Package the flow, custom connectors, and AI Builder model in a Power Platform [solution](/power-platform/alm/solution-concepts-alm) so you can promote them between development, test, and production environments.
- **Use source control on the Azure function.** Store the function in GitHub or Azure DevOps and deploy it through a continuous integration and continuous delivery (CI/CD) pipeline. For more information, see [Continuous deployment for Azure Functions](/azure/azure-functions/functions-continuous-deployment).
- **Monitor every layer.** Instrument the Azure function with [Application Insights](/azure/azure-monitor/app/app-insights-overview), watch flow runs in the [Power Platform admin center](/power-platform/admin/admin-documentation), and monitor Document Intelligence usage and throttling in [Azure Monitor](/azure/azure-monitor/overview).
- **Retrain models on a schedule.** Object-detection models drift as source documents evolve. Establish a retraining cadence for the AI Builder model and track its accuracy over time.
- **Use versioning for metadata schema.** Treat the SharePoint metadata columns as a contract. Plan how to update them without breaking ingestion and existing search experiences.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Understand service limits.** Review the [Document Intelligence service quotas and limits](/azure/ai-services/document-intelligence/service-limits) and the [AI Builder limits](/ai-builder/administer) before you plan throughput. Request quota increases early if you expect high volume.
- **Process documents in parallel.** Power Automate starts separate upload-triggered flow runs concurrently by default. If you redesign the flow to process document batches, enable concurrency and cap the degree of parallelism to stay within AI Builder and Document Intelligence limits.
- **Preprocess images for accuracy.** Higher-quality input reduces reruns. Consider downsampling oversized images, normalizing orientation, and cropping irrelevant whitespace before you send images to AI Builder and Document Intelligence.
- **Mitigate cold starts.** If latency matters, use [always-ready instances](/azure/azure-functions/flex-consumption-plan#always-ready-instances) with Flex Consumption and add [prewarmed instances](/azure/azure-functions/functions-premium-plan#eliminate-cold-starts) with the Premium plan to reduce cold-start delays.
- **Consider Logic Apps for high volume.** For high-throughput scenarios, [Logic Apps](/azure/logic-apps/logic-apps-overview) Standard tier offers higher action limits and a dedicated runtime that might scale better than Power Automate.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Steve Pucelik](https://www.linkedin.com/in/stevepucelik/) | Sr. Product Manager

Other contributor:

- [Lohith G N](https://www.linkedin.com/in/lohithgn) | Sr. CSA, Cloud & AI Platform

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Document Intelligence in Foundry Tools?](/azure/ai-services/document-intelligence/overview)
- [Document Intelligence custom models](/azure/ai-services/document-intelligence/train/custom-model)
- [AI Builder in Power Automate overview](/ai-builder/use-in-flow-overview)
- [Extract text from objects (Power Platform community blog post)](https://community.powerplatform.com/blogs/post/?postid=7e80e9fc-2613-47b1-96f7-c4416624fc52)

## Related resources

- [Azure AI Search skill set](../../solution-ideas/articles/ai-search-skillsets.yml)
- [Extract and map information from unstructured content](/azure/architecture/ai-ml/idea/multi-modal-content-processing)
