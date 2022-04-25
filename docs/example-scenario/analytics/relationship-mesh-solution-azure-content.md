
Building strong relationships with customers is key to improving customer retention, loyalty, and increasing revenue. Companies rely heavily on platforms like CRM systems and Office 365 to help them maintain customer relationships. This solution brings data on the customer and seller relationship from various systems into a user-friendly dashboard. The dashboard provides actionable data about customer relationships at both the seller account portfolio and individual account level. You can use these insights to manage and improve interactions at different stages in a customer engagement life cycle.

## Potential use cases

You can use this solution to ingest data from Office 365 and other systems to obtain actionable information on the relationship between sellers and their accounts. Then you can create plans to strengthen these relationships. This data provides insights on:

- The strength of multiple sellers’ relationships within an account.
- The strength of a seller’s relationship with individual external contacts within an account.
- The frequency and method of communication between seller and external contact for high-priority accounts.

## Architecture

:::image type="content" source="./media/relationship-mesh-saa-architecture.png" alt-text="Diagram that shows a relationship mesh architecture in Azure.":::

*Download a [Visio file](https://arch-center.azureedge.net/relationship-mesh-saa-architecture.vsdx) of this architecture.*

### Dataflow

1. Microsoft Graph Data Connect (MGDC) and Azure Synapse pipelines bring in data, like emails and calendar events, to Azure Data Lake Storage Gen2 (ADLS).
2. The raw Office 365 data is processed using Azure Synapse pipelines and saved to ADLS.
3. Business logic for relationship scores calculation is applied on processed data and saved to Azure Synapse Lake database.
4. The CRM data is ingested using Azure Synapse pipelines into ADLS.
5. The raw CRM data is processed and saved to Azure Synapse Lake database.
6. The prepared Office 365 data is joined with CRM data, aggregated, and saved to Azure Synapse SQL pool.
7. Power BI ingests the SQL data to visualize the relationship insights for sellers.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. You'll use it for data ingestion, storage, and processing.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a scalable and secure data lake for your high-performance analytics workloads.
- [Microsoft Graph Data Connect](https://azure.microsoft.com/services/graph-data-connect) enables you to copy select Microsoft 365 datasets into Azure data stores in a secure and scalable way.
- [Microsoft Power BI](https://powerbi.microsoft.com) can help you turn your data into coherent, visually immersive, and interactive insights. You'll use it to visualize customer profiles and metrics.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework. This framework is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

The solution's resiliency depends on the failure modes of the individual services in the architecture. Follow the checklists below to learn more:

- [Azure Storage](https://docs.microsoft.com/azure/architecture/checklist/resiliency-per-service#storage)
- [Azure Synapse Analytics](https://docs.microsoft.com/azure/architecture/checklist/resiliency-per-service#azure-synapse-analytics)

Azure Blob Storage provides redundancy options that help ensure high availability. You can use either locally redundant storage (LRS) or availability zones. For more information, see [availability parameters](https://docs.microsoft.com/azure/storage/common/storage-redundancy#durability-and-availability-parameters).

For more information about the reliability pillar, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

### Security

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure solutions in the architecture. You can manage permissions via Azure AD authentication or role-based access control. Follow these security guidelines when you implement this solution:

- [Security in Azure](https://docs.microsoft.com/azure/security/fundamentals/overview)
- [Access control for Azure Synapse](https://docs.microsoft.com/azure/synapse-analytics/security/how-to-set-up-access-control)
- [MGDC granular data consent](https://docs.microsoft.com/graph/data-connect-concept-overview#granular-data-consent)
- [Data security and governance for MGDC](https://docs.microsoft.com/graph/data-connect-concept-overview#data-security-and-governance)

For more information about the security pillar, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

### Cost optimization

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of the service in this architecture.

[Microsoft Graph Data Connect](https://azure.microsoft.com/pricing/details/graph-data-connect) consumption charges are billed monthly on a pay-as-you-go basis. The price is based on the number of Microsoft Graph objects accessed.

[Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) has various pricing options to help you optimize costs. You can perform big data processing tasks like data engineering, data preparation, and machine learning. These tasks are done directly in Azure Synapse by using memory-optimized or hardware-accelerated Apache Spark pools. Billing for usage of Spark pools is rounded up to the nearest minute.

There are various [Power BI](https://powerbi.microsoft.com/pricing) product options to meet different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality in your applications.

Azure services like Azure Storage accounts and Key Vaults that are deployed with Azure Synapse incur other costs.

For more information about the cost optimization pillar, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

### Performance efficiency

Performance efficiency, or scalability, is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner.

MGDC helps ingest data from Microsoft 365 tenants into Azure at scale. For more information, see [MGDC access-to-data-at-scale](https://docs.microsoft.com/graph/data-connect-concept-overview#access-to-data-at-scale).

This solution uses Azure Synapse Spark clusters, which can be scaled up and down automatically based on the activity needs of your workload. For more information, see [Azure Synapse Spark cluster autoscaling](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-pool-configurations#autoscale).

For more information about the performance efficiency pillar, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

## Deploy this scenario

Follow the steps in the [Getting Started guide](https://github.com/microsoft/Relationship-Mesh-Solution-Accelerator-with-MGDC-and-Azure-Synapse-Analytics#getting-started) in GitHub to deploy this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Nalini Chandhi](https://www.linkedin.com/in/nalinichandhi) | TECHNICAL SPECIALIST GBB
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135) | TECHNICAL SPECIALIST GBB

## Next steps

Review the information in this [GitHub repository](https://github.com/microsoft/Relationship-Mesh-Solution-Accelerator-with-MGDC-and-Azure-Synapse-Analytics) to determine whether you can benefit from this solution.

See the [deployment guide](https://github.com/microsoft/Relationship-Mesh-Solution-Accelerator-with-MGDC-and-Azure-Synapse-Analytics/blob/main/Deployment/Deployment.md) in the GitHub repository for step-by-step instructions for deploying the solution.

For more information, see these articles:

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- [Microsoft Graph Data Connect](https://docs.microsoft.com/graph)
- [Microsoft Power BI](https://docs.microsoft.com/power-bi)

## Related resources

- [Azure Data Architecture Guide](../../data-guide/index.md)
- [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
- [High throughput stream ingestion to Azure Synapse](../data/stream-ingestion-synapse.yml)
