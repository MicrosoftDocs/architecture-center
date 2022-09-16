## Architecture

Somewhere mention that the solution proposes two options to trigger the Synapse pipeline.


### Dataflow

1. Changes occur in the operational and transactional data that's stored in MongoDB Atlas. The Mongo Atlas change stream APIs notify subscribed applications about the changes in real time.

1. A custom Azure App Service web app subscribes to the MongoDB change stream. There are two versions of the web app, *event grid* and *storage*, one for each version of the solution. Both app versions listen for changes that are caused by an insert, update, or delete operation in Atlas. When the apps detect a change, they write the changed document as a blob to Azure Data Lake Storage, which is integrated with Synapse. The first version of the app also creates a new event in Event Grid when it detects a change in Atlas.

1. Both versions of the solution trigger the Synapse pipeline:
   1. In the first version, a custom event-based trigger is configured in Azure Synapse Analytics. That trigger subscribes to the Event Grid topic that the web app publishes to. The new event on that topic activates the Synapse Analytics trigger, which causes the Synapse Analytics data pipeline to run.
   1. In the second version, a storage-based trigger is configured in Azure Synapse Analytics. When a new blob is detected on an integrated Data Lake Storage folder, that trigger is activated, which causes the Synapse Analytics data pipeline to run.

1. In a copy activity, the Synapse Data Pipeline copies the full changed document from the Data Lake Storage blob to the dedicated SQL pool. This operation is configured to do an *upsert* on a selected column. If the column exists in the dedicated SQL pool, the upsert updates the column. If the column doesn't exist, the upsert inserts the column.





### Components

Mention here that both app versions are programmed in ASP.NET, and are available on GitHub and provide the GitHub links.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The solution is based on Azure products. For detailed information about security requirements and controls, see the security section of each product's documentation.

Maybe add links to each product's security docs or Azure security baseline:

- [Azure security baseline for Azure Synapse dedicated SQL pool (formerly SQL DW)](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/synapse-analytics-security-baseline?toc=%2Fazure%2Fsynapse-analytics%2Ftoc.json)

- https://docs.microsoft.com/en-us/azure/data-factory/data-movement-security-considerations

But it's hard to find a single doc about security for each product:
Azure Synapse Analytics
Azure Data Factory
App Service Web App
Event Grid
Azure Data Lake Storage
Power BI


### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To estimate the cost of Azure products and configurations, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).
- Azure helps you avoid unnecessary costs by identifying the correct number of resources for your needs, analysing spending over time, and scaling to meet business needs without overspending. For example, you can pause the dedicated SQL pools when you don't expect any load. You can resume them later.
- You can replace Azure App Service with Azure Functions. By orchestrating the functions within Azure Synapse Pipeline, you can reduce costs.
- To reduce the Spark cluster cost, choose the right data flow compute type. The options are general and memory optimized. Also choose appropriate core count and time-to-live (TTL) values.
- To find out more about the managing costs of key solution components, see these resources:
  - [Plan and manage costs for Azure Synapse Analytics](/azure/synapse-analytics/plan-manage-costs)
  - [Plan to manage costs for Azure Data Factory](/azure/data-factory/plan-manage-costs)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

When there's a high volume of changes, running thousands of pipelines in Synapse for every change in the collection can result in a backlog of queued pipelines. To improve performance in this scenario, consider the following approaches:

- Use the storage-based App Service code, which writes the delta change JSON documents to Data Lake Storage. Don't link the storage-based trigger with the pipeline. Instead, use a scheduled trigger at a short interval, such as every two or five minutes. When the scheduled trigger runs, it takes all the files in the specified Data Lake Storage directory and updates the dedicated SQL pool for each of them.
- Modify the Event grid App service code. Program it to add a micro-batch of around 100 delta changes to the blob storage before it adds the new topic with the metadata that includes the filename to the event. With this modification, you trigger only one pipeline for one blob with the 100 delta changes. Based on your scenario, you can adjust the micro-batch size. Use small micro-batches at a high frequency to provide updates that are close to real time. Or use larger micro-batches at a lower frequency for delayed updates and reduced overhead.

For more information on improving the performance and scalability of Synapse pipeline copy activity, see [Copy activity performance and scalability guide](/azure/data-factory/copy-activity-performance).

## Deploy this scenario

For information about implementing this solution, see [Real-Time Sync Solution for MongoDB Atlas Integration with Synapse](https://github.com/Azure/RealTimeSync_Synapse-MongoDB).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Diana Annie Jenosh](https://www.linkedin.com/in/diana-jenosh-0b014814) | Senior Solutions Architect
- [Babu Srinivasan](https://www.linkedin.com/in/babusrinivasan) | Senior Solutions Architect
- [Utsay Talwar](https://www.linkedin.com/in/utsav-talwar) | Associate Solutions Architect

Other contributors:

- [Krishnakumar Rukmangathan](https://www.linkedin.com/in/krishnakumar-rukmangathan) | Senior Program Manager
- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat) | Principal Program Manager
- [Wee Hyong T.](https://www.linkedin.com/in/weehyongtok) | Principal Director
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

 
## Related resources

