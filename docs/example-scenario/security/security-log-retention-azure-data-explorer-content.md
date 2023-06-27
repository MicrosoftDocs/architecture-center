This solution stores security logs in Azure Data Explorer on a long-term basis. This solution minimizes costs and provides easy access when you need to query the data.

*[Grafana](https://grafana.com/) and [Jupyter Notebooks](https://jupyter.org/) are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/security-log-retention-azure-data-explorer.svg" alt-text="Architecture diagram showing the flow of security log data. Key components include Sentinel for short-term data and Azure Data Explorer for long-term storage." border="false" lightbox="./media/security-log-retention-azure-data-explorer.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/security-log-retention-azure-data-explorer.vsdx) of this architecture.*

### Dataflow

1. For SIEM and SOAR, an enterprise uses Sentinel and Defender for Endpoint.
1. Defender for Endpoint uses native functionality to export data to Azure Event Hubs and Azure Data Lake. Sentinel ingests Defender for Endpoint data to monitor devices.
1. Sentinel uses Log Analytics as a data platform for exporting data to Event Hubs and Azure Data Lake.
1. Azure Data Explorer uses connectors for [Event Hubs][Ingest data from Event Hubs into Azure Data Explorer], [Azure Blob Storage][What is Azure Blob storage?], and [Azure Data Lake Storage][Introduction to Azure Data Lake Storage Gen2] to ingest data with low-latency and high throughput. This process uses [Azure Event Grid][Ingest blobs into Azure Data Explorer by subscribing to Event Grid notifications], which triggers the Azure Data Explorer ingestion pipeline.
1. If needed, Azure Data Explorer continuously exports security logs to Azure Storage. These logs are in compressed, partitioned Parquet format and are ready to be queried.
1. To follow regulatory requirements, Azure Data Explorer exports pre-aggregated data to Data Lake Storage for archiving.
1. Log Analytics and Sentinel support cross-service queries with Azure Data Explorer. SOC analysts use this capability to run full-range investigations on security data.
1. Azure Data Explorer provides native capabilities for processing, aggregating, and analyzing data.
1. Various tools provide near real-time analytics dashboards that quickly deliver insights:

   - [Azure Data Explorer dashboards][Visualize data with Azure Data Explorer dashboards(Preview)]
   - [Power BI][Introduction to dataflows and self-service data prep]
   - [Grafana][Visualize data from Azure Data Explorer in Grafana]

### Components

- [Defender for Endpoint][When your team is two steps ahead, security is innovation] protects organizations from threats across devices, identities, apps, email, data, and cloud workloads.

- [Sentinel](/azure/sentinel/overview) is a cloud-native SIEM and SOAR solution. It uses advanced AI and security analytics to detect, hunt, prevent, and respond to threats across enterprises.

- [Monitor][Azure Monitor] is a software as a service (SaaS) solution that collects and analyzes data on environments and Azure resources. This data includes app telemetry, such as performance metrics and activity logs. Monitor also offers alerting functionality.

- [Log Analytics][Overview of Log Analytics in Azure Monitor] is a Monitor service that you can use to query and inspect Monitor log data. Log Analytics also provides features for charting and statistically analyzing query results.

- [Event Hubs][Event Hubs] is a fully managed, real-time data ingestion service that's straightforward and scalable.

- [Data Lake Storage][Introduction to Azure Data Lake Storage Gen2] is a scalable storage repository that holds a large amount of data in the data's native, raw format. This data lake is built on top of [Blob Storage][Introduction to the core Azure Storage services] and provides functionality for storing and processing data.

- [Azure Data Explorer][Azure Data Explorer] is a fast, fully managed, and highly scalable data analytics platform. You can use this cloud service for real-time analysis on large volumes of data. Azure Data Explorer is optimized for interactive, ad-hoc queries. It can handle diverse data streams from applications, websites, IoT devices, and other sources.

- [Azure Data Explorer dashboards][Visualize data with Azure Data Explorer dashboards(Preview)] natively import data from Azure Data Explorer Web UI queries. These optimized dashboards provide a way to display and explore query results.

### Alternatives

- Instead of using Azure Data Explorer for long-term storage of security logs, you can use Storage. This approach simplifies the architecture and can help control the cost. A disadvantage is the need to rehydrate the logs for security audits and interactive investigative queries. With Azure Data Explorer, you can move data from the cold partition to the hot partition by changing a policy. This functionality speeds up data exploration.

- Another option with this solution is to send all data, regardless of its security value, to Sentinel and Azure Data Explorer at the same time. Some duplication results, but the cost savings can be significant. Because Azure Data Explorer provides long-term storage, you can reduce your Sentinel retention costs with this approach.

- Log Analytics doesn't currently support exporting custom log tables. In this scenario, you can use Azure Logic Apps to export data from Log Analytics workspaces. For more information, see [Archive data from Log Analytics workspace to Azure Storage using Logic Apps][Archive data from Log Analytics workspace to Azure storage using Logic App].

## Scenario details

Security logs are useful for identifying threats and tracing unauthorized attempts to access data. Security attacks can begin well before they're discovered. As a result, having access to long-term security logs is important. Querying long-term logs is critical for identifying the impact of threats and investigating the spread of illicit access attempts.

This article outlines a solution for long-term retention of security logs. At the core of the architecture is Azure Data Explorer. This service provides storage for security data at minimal cost but keeps that data in a format that you can query. Other main components include:

- Microsoft Defender for Endpoint and Microsoft Sentinel, for these capabilities:

  - Comprehensive endpoint security
  - Security information and event management (SIEM)
  - Security orchestration automated response (SOAR)

- Log Analytics, for short-term storage of Sentinel security logs.

### Potential use cases

This solution applies to various scenarios. Specifically, security operations center (SOC) analysts can use this solution for:

- Full-scale investigations.
- Forensic analysis.
- Threat hunting.
- Security audits.

A customer testifies to the usefulness of the solution: "We deployed an Azure Data Explorer cluster almost a year and a half ago. In the last Solorigate data breach, we used an Azure Data Explorer cluster for forensic analysis. A Microsoft Dart team also used an Azure Data Explorer cluster to complete the investigation. Long-term security data retention is critical for full-scale data investigations."

### Monitoring stack

The following diagram shows the Azure monitoring stack:

:::image type="content" source="./media/security-log-retention-azure-data-explorer-current-monitor-stack-diagram.png" alt-text="Architecture diagram showing a monitoring solution. Sentinel and Log Analytics provide monitoring and alerting. Azure Data Explorer serves as a platform." border="false":::

- Sentinel uses a Log Analytics workspace to store security logs and provide SIEM and SOAR solutions.
- Monitor tracks the status of IT assets and sends alerts when needed.
- Azure Data Explorer provides an underlying data platform that stores security logs for Log Analytics workspaces, Monitor, and Sentinel.

### Main features

The solution's main features offer many benefits, as the following sections explain.

#### Long-term queryable data store

Azure Data Explorer indexes data during the storage process, making the data available for queries. When you need to focus on running audits and investigations, there's no need to process the data. Querying the data is straightforward.

#### Full-scale forensic analysis

Azure Data Explorer, Log Analytics, and Sentinel support cross-service queries. As a result, in a single query, you can reference data that's stored in any of these services. SOC analysts can use the Kusto query language (KQL) to run full-range investigations. You can also use Azure Data Explorer queries in Sentinel for hunting purposes. For more information, see [What's New: Sentinel Hunting supports ADX cross-resource queries](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/what-s-new-azure-sentinel-hunting-supports-adx-cross-resource/ba-p/2530678).

#### On-demand data caching

Azure Data Explorer supports [window-based hot caching][Cache policy (hot and cold cache)]. This functionality provides a way to move data from a selected period into the hot cache. Then you can run fast queries on the data, making investigations more efficient. You might need to add compute nodes to the hot cache for this purpose. After the investigation is complete, you can change the hot cache policy to move the data into the cold partition. You can also restore the cluster to its original size.

#### Continuous exporting to archive data

To follow regulatory requirements, some enterprises need to store security logs for an unlimited amount of time. Azure Data Explorer supports continuous exporting of data. You can use this capability to build an archival tier by storing security logs in Storage.

#### Proven query language

The Kusto query language is native to Azure Data Explorer. This language is also available in Log Analytics workspaces and Sentinel threat-hunting environments. This availability significantly reduces the learning curve for SOC analysts. Queries that you run on Sentinel also work on data that you store in Azure Data Explorer clusters.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Keep the following points in mind when you implement this solution.

### Scalability

Consider these scalability issues:

#### Data export method

If you need to export a large amount of data from Log Analytics, you might reach Event Hubs capacity limits. To avoid this situation:

- Export data from Log Analytics into Blob Storage.
- Use Azure Data Factory workloads to periodically export the data into Azure Data Explorer.

By using this method, you can copy data from Data Factory only when the data nears its retention limit in Sentinel or Log Analytics. As a result, you avoid duplicating the data. For more information, see [Export data from Log Analytics into Azure Data Explorer][Export data from Log Analytics into Azure Data Explorer].

#### Query usage and audit preparedness

Generally, you keep data in the cold cache in your Azure Data Explorer cluster. This approach minimizes your cluster cost and is sufficient for most queries that involve data from previous months. But when you query large data ranges, you might need to scale out the cluster and load the data into the hot cache.

You can use the hot window feature of the hot cache policy for this purpose. You can also use this feature when you audit long-term data. When you use the hot window, you might need to scale your cluster up or out to make room for more data in the hot cache. After you've finished querying the large data range, change the hot cache policy to reduce your computing cost.

By turning on the optimized autoscale feature in your Azure Data Explorer cluster, you can optimize your cluster size based on the caching policy. For more information on querying cold data in Azure Data Explorer, see [Query cold data with hot windows][Query cold data with hot windows].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

If you need to store security data for a long time or for an unlimited period, export the logs to Storage. Azure Data Explorer supports continuous exporting of data. By using this functionality, you can export data to Storage in compressed, partitioned Parquet format. You can then seamlessly query that data. For more information, see [Continuous data export overview][Continuous data export overview].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The Azure Data Explorer cluster cost is primarily based on the computing power that's used to store data in the hot cache. Queries on hot cache data offer better performance over cold cache queries. This solution stores most of the data in the cold cache, minimizing the computing cost.

To explore the cost of running this solution in your environment, use the [Azure pricing calculator][Azure pricing calculator].

## Deploy this scenario

To automate deployment, use this [PowerShell script][Integrate Azure Data Explorer (ADX) for long-term log retention]. This script creates these components:

- The target table
- The raw table
- The table mapping that defines how Event Hubs records land in the raw table
- Retention and update policies
- Event Hubs namespaces
- Data export rules in the Log Analytics workspace
- The data connection between Event Hubs and the Azure Data Explorer raw data table

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Deepak Agrawal](https://www.linkedin.com/in/connectwithdeepakagrawal) | Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Integrate Azure Data Explorer for long-term log retention][Integrate Azure Data Explorer for long-term log retention]
- [Move Your Microsoft Sentinel Logs to Long-Term Storage with Ease][Move Your Microsoft Sentinel Logs to Long-Term Storage with Ease]
- [Cross-resource query Azure Data Explorer by using Azure Monitor][Cross-resource query Azure Data Explorer by using Azure Monitor]
- [HOW TO: Configure Microsoft Sentinel data export for long-term storage](https://www.linkedin.com/pulse/howto-configure-azure-sentinel-data-export-long-term-storage-lauren)
- [Using Azure Data Explorer for long-term retention of Microsoft Sentinel logs][Using Azure Data Explorer for long term retention of Microsoft Sentinel logs]
- [What's New: Microsoft Sentinel Hunting supports ADX cross-resource queries](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/what-s-new-azure-sentinel-hunting-supports-adx-cross-resource/ba-p/2530678)
- [How to stream Microsoft Defender ATP hunting logs in Azure Data Explorer][How to stream Microsoft Defender ATP hunting logs in Azure Data Explorer]
- [Blog Series: Limitless Advanced Hunting with Azure Data Explorer (ADX)][Blog Series: Limitless Advanced Hunting with Azure Data Explorer (ADX)]

## Related resources

- [Azure Data Explorer monitoring][Azure Data Explorer monitoring]
- [Azure Data Explorer interactive analytics][Azure Data Explorer interactive analytics]
- [Big data analytics with Azure Data Explorer][Big data analytics with Azure Data Explorer]

[Azure Data Explorer interactive analytics]: ../../solution-ideas/articles/interactive-azure-data-explorer.yml
[Azure Data Explorer monitoring]: ../../solution-ideas/articles/monitor-azure-data-explorer.yml
[Archive data from Log Analytics workspace to Azure storage using Logic App]: /azure/azure-monitor/logs/logs-export-logic-app
[Azure Data Explorer]: https://azure.microsoft.com/services/data-explorer
[Azure Monitor]: https://azure.microsoft.com/services/monitor
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Big data analytics with Azure Data Explorer]: ../../solution-ideas/articles/big-data-azure-data-explorer.yml
[Blog Series: Limitless Advanced Hunting with Azure Data Explorer (ADX)]: https://techcommunity.microsoft.com/t5/microsoft-365-defender/blog-series-limitless-advanced-hunting-with-azure-data-explorer/ba-p/2328705
[Cache policy (hot and cold cache)]: /azure/data-explorer/kusto/management/cachepolicy
[Continuous data export overview]: /azure/data-explorer/kusto/management/data-export/continuous-data-export
[Cross-resource query Azure Data Explorer by using Azure Monitor]: /azure/azure-monitor/logs/azure-monitor-data-explorer-proxy
[Event Hubs]: https://azure.microsoft.com/services/event-hubs
[Export data from Log Analytics into Azure Data Explorer]: /azure/sentinel/store-logs-in-azure-data-explorer?tabs=azure-storage-azure-data-factory#export-data-from-log-analytics-into-azure-data-explorer
[How to stream Microsoft Defender ATP hunting logs in Azure Data Explorer]: https://techcommunity.microsoft.com/t5/azure-data-explorer/how-to-stream-microsoft-defender-atp-hunting-logs-in-azure-data/ba-p/1427888
[Ingest blobs into Azure Data Explorer by subscribing to Event Grid notifications]: /azure/data-explorer/ingest-data-event-grid?tabs=portal-1
[Ingest data from Event Hubs into Azure Data Explorer]: /azure/data-explorer/ingest-data-event-hub
[Integrate Azure Data Explorer for long-term log retention]: /azure/sentinel/store-logs-in-azure-data-explorer?tabs=adx-event-hub
[Integrate Azure Data Explorer (ADX) for long-term log retention]: https://github.com/Azure/Azure-Sentinel/tree/master/Tools/AzureDataExplorer
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
[Introduction to the core Azure Storage services]: /azure/storage/common/storage-introduction
[Introduction to dataflows and self-service data prep]: /power-bi/transform-model/dataflows/dataflows-introduction-self-service
[Move Your Microsoft Sentinel Logs to Long-Term Storage with Ease]: https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/move-your-microsoft-sentinel-logs-to-long-term-storage-with-ease/ba-p/1407153
[Overview of Log Analytics in Azure Monitor]: /azure/azure-monitor/logs/log-analytics-overview
[Query cold data with hot windows]: /azure/data-explorer/hot-windows
[Using Azure Data Explorer for long term retention of Microsoft Sentinel logs]: https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/using-azure-data-explorer-for-long-term-retention-of-microsoft/ba-p/1883947
[Visualize data with Azure Data Explorer dashboards(Preview)]: /azure/data-explorer/azure-data-explorer-dashboards
[Visualize data from Azure Data Explorer in Grafana]: /azure/data-explorer/grafana
[What is Azure Blob storage?]: /azure/storage/blobs/storage-blobs-overview
[When your team is two steps ahead, security is innovation]: https://www.microsoft.com/security/business/threat-protection
