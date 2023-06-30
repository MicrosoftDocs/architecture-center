[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how to tier data and applications on-premises and on Azure. As data flows into a storage account, you can use Azure Stack to analyze the data for anomalies or compliance and to display insights in apps. 

## Architecture

:::image type="content" border="false" source="../media/tiered-data-for-analytics.svg" alt-text="Architecture diagram that shows  how to tier data and applications on-premises and on Azure." lightbox="../media/tiered-data-for-analytics.svg":::
*Download a [Visio file](https://arch-center.azureedge.net/tiered-data-for-analytics.vsdx) of this architecture.*

### Dataflow

1. Data flows into a storage account.
1. Function on Azure Stack analyzes the data for anomalies or compliance.
1. Locally relevant insights are displayed on the Azure Stack app.
1. Insights and anomalies are placed into a queue.
1. The bulk of the data is placed into an archive storage account.
1. Function sends data from queue to Azure Storage.
1. Globally relevant and compliant insights are available in the global app.

### Components

* [Storage](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure Functions](https://azure.microsoft.com/services/functions): Process events with serverless code
* [Azure Stack](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries

## Scenario details

This scenario can help you tier data and applications on-premises and on Azure. Filter unnecessary data early in the process, bring cloud applications close to the data on-premises, and analyze large-scale aggregate data from multiple locations on Azure.

### Potential use cases

Tiered applications provide the following benefits:

- The ability to update the technology stack of one tier without affecting other areas of the application.
- Development teams work on their own areas of expertise.
- Able to scale the application.
- Adds reliability and more independence of the underlying servers or services.

## Next steps

* [Storage documentation](/azure/storage)
* [Azure Functions documentation](/azure/azure-functions)
* [Azure Stack documentation](/azure/azure-stack/user/azure-stack-solution-staged-data-analytics)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)
- [Tiered data for analytics](../../example-scenario/hybrid/hybrid-tiered-data-analytics.yml)