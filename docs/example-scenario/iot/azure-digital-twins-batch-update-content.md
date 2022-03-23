Azure Digital Twins can help you build digital models of your systems and your enterprise that are regularly updated with data from the people, places, and things in your enterprise. Information sources can include telemetry from manufacturing equipment and vehicles, databases of sales and stock, climate and building sensors—almost any relevant data source that can help to create a current, virtual representation of your enterprise. To accomplish this, you need to get your data into Azure Digital Twins. If that data is from systems that require traditional extract, transform, and load (ETL) techniques, this article can help.

In this example scenario, you integrate Azure Digital Twins into line-of-business (LOB) systems by synchronizing or updating your Azure Digital Twins graph with data. With your model and the data pipelines established, you can have a 360-degree view of your environment and system. You determine the frequency of synchronization based on your source systems and the requirements of your solution.

## Relevant use cases

These other use cases have similar design patterns:

- You have a graph in Azure Digital Twins of moving assets in a warehouse (for example, forklifts). You might want to receive data about the order that's currently being processed for each asset by integrating with the warehouse management system or the sales LOB application every 10 minutes. The same graph in Azure Digital Twins can be synchronized with asset management solutions every day to receive inventory of assets that are available that day for use in the warehouse.

- You have a fleet of vehicles that belong to a hierarchy that contains data that doesn't change often.  You could use this solution to keep that data updated as needed.

## Architecture

:::image type="content" alt-text="Azure Digital Twins batch update architecture." source="media/azure-digital-twins-batch-update-diagram.png" lightbox="media/azure-digital-twins-batch-update-diagram.png":::

_Download a [Visio file](https://arch-center.azureedge.net/azure-digital-twins-batch-update-diagram.vsdx) of this architecture._

### Dataflow

1. Azure Data Factory uses either a [copy activity](/azure/data-factory/copy-activity-overview) or a [mapping data flow](/azure/data-factory/concepts-data-flow-overview) to connect to the business system and copy the data to a temporary location.

2. A mapping data flow handles any transformations and outputs a file for each twin that must be processed.

3. A [get metadata activity](/azure/data-factory/control-flow-get-metadata-activity) retrieves the list of files, loops through them, and calls a [custom activity](/azure/data-factory/transform-data-using-custom-activity).

4. Azure Batch creates a task for each file that executes the custom code to interface with Azure Digital Twins.

### Components

- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) is the foundation for the metaverse that represents the digital representation of the physical assets.

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) handles the connectivity and orchestration between the source system and Azure Digital Twins.

- [Azure Storage](https://azure.microsoft.com/services/storage) stores the code for the custom activity and the data files that we generate that need to be processed.

- [Azure Batch](https://azure.microsoft.com/services/batch) executes the custom activity code.

- [Azure Active Directory](https://azure.microsoft.com/services/active-directory) provides [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for securely connecting from the custom activity to Azure Digital Twins.

### Alternatives

An alternative to this approach is to use [Azure Functions](https://azure.microsoft.com/services/functions/) instead of Azure Batch. We chose not to use Azure Functions for this architecture, because Functions has a timeout for execution. A timeout could be a problem if the update to Digital Twins requires complex logic, or if the API gets throttled. In such a case, the function could time out before execution is complete. Azure Batch doesn't have this restriction. Also, when using Batch, you can configure the number of virtual machines that are active to process the files. This flexibility helps you to find a balance of scale and speed of updates.

## Considerations

- Custom Activities are essentially console applications.  We took some of the best practices that are outlined in [Creating an Azure Data Factory v2 Custom Activity](https://mrpaulandrew.com/2018/11/12/creating-an-azure-data-factory-v2-custom-activity/), a post by Paul Andrew on his blog, as a foundation to be able to run and debug locally.

- Consider archiving the files, after they've been processed, for historical purposes.

- Consider implementing a change-data-capture pattern so that you only update the twins that are necessary.

### Availability

- Monitor Azure Data Factory pipelines
  - [Using Azure Monitor](https://docs.microsoft.com/en-us/azure/data-factory/monitor-using-azure-monitor)
  - [Azure Monitor Alerts](https://docs.microsoft.com/en-us/azure/data-factory/monitor-metrics-alerts)
  - [Data Flow Monitoring](https://docs.microsoft.com/en-us/azure/data-factory/concepts-data-flow-monitoring)
  - [Using Azure Monitor Effectively](https://azurelib.com/how-to-monitor-azure-data-factory-effectively)

- Monitor Azure Batch
  - [Azure Batch Monitoring](https://docs.microsoft.com/en-us/azure/batch/monitoring-overview)
  - [Azure Batch Application Insights](https://docs.microsoft.com/en-us/azure/batch/monitor-application-insights)

### Operations

- Operational considerations 
  - [Providing SLA](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-operationalize-pipelines)
  - [Failure Handling](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-pipeline-failure-error-handling)
  - [Monitoring pipelines using email alerts](https://docs.microsoft.com/en-us/azure/data-factory/how-to-send-email)
  - [Monitoring pipelines using teams alerts](https://docs.microsoft.com/en-us/azure/data-factory/how-to-send-notifications-to-teams?tabs=data-factory)


### Performance

- Performance could be a problem if you need to integrate ADT with large datasets  Consider how to scale Azure Batch appropriately to find the balance you need.
  - [Azure Batch Autoscaling](https://docs.microsoft.com/en-us/azure/data-factory/transform-data-using-custom-activity#auto-scaling-of-azure-batch)
  - [Azure Batch Performance](https://docs.microsoft.com/en-us/azure/architecture/framework/services/compute/azure-batch/performance-efficiency)

- Depending on the complexity and size of data in the source system, consider the scale of your Mapping Data Flow.
  - [Data Flow Performance](https://docs.microsoft.com/en-us/azure/data-factory/concepts-data-flow-performance)

### Scalability

- Need to scale for large datasets
  - [Implement SCD pattern(s)](https://techcommunity.microsoft.com/t5/azure-data-factory-blog/create-generic-scd-pattern-in-adf-mapping-data-flows/ba-p/918519)
  - [Optimize Pipeline](https://docs.microsoft.com/en-us/learn/paths/data-integration-scale-azure-data-factory)

### Security

This pattern relies on Managed Identities for security, so it's safe.  Azure Data Factory requires the storage account key to generate SAS keys.  To protect that key, we store it in Azure Key Vault and grant the ADF managed identity access to it.

### Resiliency

Resiliency is considered to be part of availability, monitoring and operations sections above. 

### DevOps

- The custom activity code is a zip file that gets placed in Azure Storage.  A devops pipeline can manage the deployment of that.
- Azure Data Factory supports devops, giving you an end-to-end devops lifecycle.

## Deploy this scenario

A reference implementation can be found in [GitHub](https://github.com/Azure-Samples/azuredigitaltwins-batchupdate).

## Pricing

Leverage the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to get accurate pricing on Azure Digital Twins, Azure Data Factory, and Azure Batch.

## Contributors

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:** 

 * [Howard Ginsburg](https://www.linkedin.com/in/howardginsburg) | Senior Cloud Solutions Architect

## Next steps

> Link to Docs and Learn articles, along with any third-party documentation.
> Where should I go next if I want to start building this?
> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful? Are there product documents that go into more detail on specific technologies that are not already linked?




## Related resources

- [Pipeline Orchestration](https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement)
- [ETL](https://docs.microsoft.com/en-us/azure/architecture/data-guide/relational-data/etl)
- [Azure Digital Twins Builder](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/azure-digital-twins-builder)
