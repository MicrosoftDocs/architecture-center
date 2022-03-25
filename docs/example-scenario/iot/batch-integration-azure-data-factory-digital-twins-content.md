Azure Digital Twins can help you build virtual representations of your systems and your enterprise that are regularly updated with data from the people, places, and things in your enterprise. Figuring out how to get relevant data into Azure Digital Twins can seem like a challenge. If that data is from systems that require traditional extract, transform, and load (ETL) techniques, this article can help.

In this example scenario, you integrate Azure Digital Twins into line-of-business (LOB) systems by synchronizing or updating your Azure Digital Twins graph with data. With your model and the data pipelines established, you can have a 360-degree view of your environment and system. You determine the frequency of synchronization based on your source systems and the requirements of your solution.

## Potential use cases

These other use cases have similar design patterns:

- You have a graph in Azure Digital Twins of moving assets in a warehouse (for example, forklifts). You might want to receive data about the order that's currently being processed for each asset. To do so, you could integrate data from the warehouse management system or the sales LOB application every 10 minutes. The same graph in Azure Digital Twins can be synchronized with asset management solutions every day to receive inventory of assets that are available that day for use in the warehouse.

- You have a fleet of vehicles that belong to a hierarchy that contains data that doesn't change often.  You could use this solution to keep that data updated as needed.

## Architecture

:::image type="content" alt-text="Diagram that shows the architecture of this example, including business systems, Azure Data Factory, Azure Batch, Azure Digital Twins, Azure Storage, data pipelines, and activities." source="media/batch-integration-azure-data-factory-digital-twins-diagram.png" lightbox="media/batch-integration-azure-data-factory-digital-twins-diagram.png":::

_Download a [Visio file](https://arch-center.azureedge.net/batch-integration-azure-data-factory-digital-twins-diagram.vsdx) of this architecture._

### Dataflow

1. Azure Data Factory uses either a [Copy activity](/azure/data-factory/copy-activity-overview) or a [mapping data flow](/azure/data-factory/concepts-data-flow-overview) to connect to the business system and copy the data to a temporary location.

2. A mapping data flow handles any transformations and outputs a file for each twin that must be processed.

3. A [Get Metadata activity](/azure/data-factory/control-flow-get-metadata-activity) retrieves the list of files, loops through them, and calls a [Custom activity](/azure/data-factory/transform-data-using-custom-activity).

4. Azure Batch creates a task for each file that runs the custom code to interface with Azure Digital Twins.

### Components

- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) is the foundation for the metaverse that represents the digital representation of the physical assets.

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) handles the connectivity and orchestration between the source system and Azure Digital Twins.

- [Azure Storage](https://azure.microsoft.com/services/storage) stores the code for the Custom activity and the data files that need to be processed.

- [Azure Batch](https://azure.microsoft.com/services/batch) runs the Custom activity code.

- [Azure Active Directory](https://azure.microsoft.com/services/active-directory) provides [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for securely connecting from the Custom activity to Azure Digital Twins.

### Alternatives

An alternative to this approach is to use [Azure Functions](https://azure.microsoft.com/services/functions) instead of Azure Batch. We chose not to use Azure Functions for this architecture because Functions has a timeout for execution. A timeout could be a problem if the update to Azure Digital Twins requires complex logic, or if the API gets throttled. In such a case, the function could time out before execution is complete. Azure Batch doesn't have this restriction. Also, when using Batch, you can configure the number of virtual machines that are active to process the files. This flexibility helps you to find a balance between the scale and the speed of updates.

## Considerations

- Custom activities are essentially console applications.  We took some of the best practices that are outlined in [Creating an Azure Data Factory v2 Custom Activity](https://mrpaulandrew.com/2018/11/12/creating-an-azure-data-factory-v2-custom-activity), a post by Paul Andrew on his blog, as a foundation to be able to run and debug locally.

- Consider archiving the files, after they've been processed, for historical purposes.

- Consider implementing a change-data-capture pattern so that you only update the twins that are necessary.

### Availability

For information about monitoring Data Factory pipelines, see the following resources:
- [Monitor and Alert Data Factory by using Azure Monitor](/azure/data-factory/monitor-using-azure-monitor)
- [Data Factory metrics and alerts](/azure/data-factory/monitor-metrics-alerts)
- [Monitoring data flows](/azure/data-factory/concepts-data-flow-monitoring)
- [Using Azure Monitor Effectively](https://azurelib.com/how-to-monitor-azure-data-factory-effectively)

For information about monitoring Azure Batch, see the following resources:
- [Monitor Batch solutions](/azure/batch/monitoring-overview)
- [Monitor and debug an Azure Batch .NET application with Application Insights](/azure/batch/monitor-application-insights)

### Operations

For information related to operations, see the following resources:
- [Deliver service level agreement for data pipelines](/azure/data-factory/tutorial-operationalize-pipelines)
- [Understanding pipeline failure](/azure/data-factory/tutorial-pipeline-failure-error-handling)
- [Send an email with an Azure Data Factory or Azure Synapse pipeline](/azure/data-factory/how-to-send-email)
- [Send notifications to a Microsoft Teams channel from an Azure Data Factory or Synapse Analytics pipeline](/azure/data-factory/how-to-send-notifications-to-teams?tabs=data-factory)


### Performance

Performance could be a problem if you need to integrate Azure Digital Twins with large datasets. Consider how to scale Azure Batch appropriately to find the balance you need. For help with scaling, see the following resources:
- [Auto-scaling of Azure Batch](/azure/data-factory/transform-data-using-custom-activity#auto-scaling-of-azure-batch)
- [Azure Batch and performance efficiency](/azure/architecture/framework/services/compute/azure-batch/performance-efficiency)
- [Create Generic SCD Pattern in ADF Mapping Data Flows](https://techcommunity.microsoft.com/t5/azure-data-factory-blog/create-generic-scd-pattern-in-adf-mapping-data-flows/ba-p/918519)
- [Data integration at scale with Azure Data Factory or Azure Synapse Pipeline](/learn/paths/data-integration-scale-azure-data-factory)

Depending on the complexity and size of data in the source system, consider the scale of your mapping data flow. For help with addressing performance, see [Mapping data flows performance and tuning guide](/azure/data-factory/concepts-data-flow-performance).

### Security

This scenario relies on managed identities for security of the data.  Data Factory requires the storage account key to generate shared access signatures.  To help protect that key, store it in [Azure Key Vault](https://azure.microsoft.com/services/key-vault), and grant the data factory access to it through managed identity.

### DevOps

- The Custom activity code is contained in a .zip file that's placed in Azure Storage.  A DevOps pipeline can manage the deployment of that code.
- Data Factory supports an end-to-end DevOps lifecycle.

## Deploy this scenario

You can find a reference implementation on GitHub: [Azure Digital Twins Batch Update Prototype](https://github.com/Azure-Samples/azuredigitaltwins-batchupdate).

## Pricing

Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to get accurate pricing on Azure Digital Twins, Data Factory, and Azure Batch.

## Contributors

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._

**Principal author:** 

- [Howard Ginsburg](https://www.linkedin.com/in/howardginsburg) | Senior Cloud Solution Architect

**Additional contributors:**

- [Mike Downs](https://www.linkedin.com/in/mike-downs-4373a66) | Senior Cloud Solution Architect 
- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Onder Yildirim](https://www.linkedin.com/in/%C3%B6nder-yildirim-0044601) | Senior Cloud Solution Architect 

## Next steps

- [Explore Azure Digital Twins implementation](/learn/modules/explore-azure-digital-twins-implementation)
- [Examine the components of an Azure Digital Twins solution](/learn/modules/examine-components-azure-digital-twins-solution)
- [Examine the Azure Digital Twins solution development tools and processes](/learn/modules/examine-azure-digital-twins-solution-development-tools-processes)
- [Integrate data with Azure Data Factory or Azure Synapse Pipeline](/learn/modules/data-integration-azure-data-factory)
- [Introduction to Azure Data Factory](/learn/modules/intro-to-azure-data-factory)
- [Azure Data Factory documentation](/azure/data-factory)
- [Azure Digital Twins documentation](/azure/digital-twins)

## Related resources

- [Azure Digital Twins builder](/azure/architecture/solution-ideas/articles/azure-digital-twins-builder)
- [Choose a data pipeline orchestration technology in Azure](/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement)
- [Extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl)
