This solution brings data on the customer and seller relationship from various systems into a user-friendly dashboard. The dashboard provides actionable data about customer relationships at the level of both the seller account portfolio and individual account. You can use these insights to manage and improve interactions at different stages in a customer-engagement life cycle.

*Apache®, [Apache Spark](https://spark.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/relationship-mesh-saa-architecture.svg" alt-text="Diagram that shows a relationship mesh architecture in Azure." lightbox="./media/relationship-mesh-saa-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/relationship-mesh-saa-architecture.vsdx) of this architecture.*

### Dataflow

1. Microsoft Graph Data Connect and Azure Synapse Analytics pipelines bring in Microsoft 365 data, like emails and calendar events, to Azure Data Lake Storage.
2. The raw Microsoft 365 data is processed by using Azure Synapse pipelines and saved to Data Lake Storage.
3. Business logic for calculating relationship scores is applied on processed data and saved to a lake database in Azure Synapse.
4. The CRM data is ingested by using Azure Synapse pipelines into Data Lake Storage.
5. The raw CRM data is processed and saved to an Azure Synapse lake database.
6. The prepared Microsoft 365 data is joined with CRM data, aggregated, and saved to Azure Synapse SQL pool.
7. Power BI ingests the SQL data to visualize the relationship insights for sellers.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. You'll use it for data ingestion, storage, and processing.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a scalable and secure data lake for your high-performance analytics workloads.
- [Microsoft Graph Data Connect](https://azure.microsoft.com/services/graph-data-connect) enables you to copy selected Microsoft 365 datasets into Azure data stores in a secure and scalable way.
- [Microsoft Power BI](https://azure.microsoft.com/en-us/services/developer-tools/power-bi) can help you turn your data into coherent, visually immersive, and interactive insights. You'll use it to visualize customer profiles and metrics.

## Scenario details

Building strong relationships with customers is key to improving customer retention, attracting loyalty, and increasing revenue. Companies rely heavily on platforms like customer relationship management (CRM) systems and Microsoft 365 to help them maintain customer relationships. This solution brings data on the customer and seller relationship from various systems into a user-friendly dashboard. 

### Potential use cases

You can use this solution to ingest data from Microsoft 365 and other systems to obtain actionable information on the relationship between sellers and their accounts. Then you can create plans to strengthen these relationships. Correlating this data provides insights on:

- The strength of multiple sellers’ relationships within an account.
- The strength of a seller’s relationship with individual external contacts within an account.
- The frequency and method of communication between seller and external contact for high-priority accounts.

## Considerations

These considerations use the pillars of the Azure Well-Architected Framework. This framework is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

The solution's resiliency depends on the failure modes of the individual services in the architecture. To learn more, follow the resiliency checklists in the following articles:

- [Azure Storage](/azure/architecture/checklist/resiliency-per-service#storage)
- [Azure Synapse Analytics](/azure/architecture/checklist/resiliency-per-service#azure-synapse-analytics)

Azure Blob Storage provides redundancy options that help ensure high availability. You can use either locally redundant storage (LRS) or availability zones. For more information, see [Durability and availability parameters](/azure/storage/common/storage-redundancy#durability-and-availability-parameters).

For more information about the reliability pillar, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

### Security

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure solutions in the architecture. You can manage permissions via Azure AD authentication or role-based access control. Follow the security guidelines in the following articles when you implement this solution:

- [Introduction to Azure security](/azure/security/fundamentals/overview)
- [How to set up access control for your Azure Synapse workspace](/azure/synapse-analytics/security/how-to-set-up-access-control)
- [Microsoft Graph Data Connect granular data consent](/graph/data-connect-concept-overview#granular-data-consent)
- [Microsoft Graph Data Connect data security and governance](/graph/data-connect-concept-overview#data-security-and-governance)

For more information about the security pillar, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

### Cost optimization

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of the service in this architecture.

[Microsoft Graph Data Connect](https://azure.microsoft.com/pricing/details/graph-data-connect) consumption charges are billed monthly on a pay-as-you-go basis. The price is based on the number of Microsoft Graph objects accessed.

[Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) has various pricing options to help you optimize costs. You can perform big data processing tasks like data engineering, data preparation, and machine learning. These tasks are done directly in Azure Synapse by using memory-optimized or hardware-accelerated Apache Spark pools. Billing for usage of Spark pools is rounded up to the nearest minute.

There are various [Power BI](https://powerbi.microsoft.com/pricing) product options to meet different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality in your applications.

Azure services like Azure Storage accounts and Key Vaults that are deployed with Azure Synapse incur other costs.

For more information about the cost optimization pillar, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

### Performance efficiency

Performance efficiency, or scalability, is the ability of your workload to scale in an efficient manner to meet the demands that are placed on it by users.

Microsoft Graph Data Connect helps ingest data from Microsoft 365 tenants into Azure at scale. For more information, see [Access to data at scale](/graph/data-connect-concept-overview#access-to-data-at-scale).

This solution uses Apache Spark pool configurations in Azure Synapse, which can be scaled up and down automatically based on the activity needs of your workload. For more information, see [Autoscale](/azure/synapse-analytics/spark/apache-spark-pool-configurations#autoscale).

For more information about the performance efficiency pillar, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

## Deploy this scenario

Follow the steps in the [Getting Started guide](https://github.com/microsoft/Relationship-Mesh-Solution-Accelerator-with-MGDC-and-Azure-Synapse-Analytics#getting-started) in GitHub to deploy this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Nalini Chandhi](https://www.linkedin.com/in/nalinichandhi) | Senior Technical Specialist
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135) | Technical Specialist (GBB)

## Next steps

Review the information in this [relationship mesh solution GitHub repository](https://github.com/microsoft/Relationship-Mesh-Solution-Accelerator-with-MGDC-and-Azure-Synapse-Analytics) to determine whether you can benefit from this solution.

For more information, see these articles:

- [Azure Data Architecture Guide](../../data-guide/index.md)
- [Azure Synapse Analytics](/azure/synapse-analytics)
- [Microsoft Graph Data Connect](/graph)
- [Microsoft Power BI](/power-bi)

## Related resources

- [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
- [Big data analytics with enterprise-grade security using Azure Synapse](../../solution-ideas/articles/big-data-analytics-enterprise-grade-security.yml)
- [High throughput stream ingestion to Azure Synapse](../data/stream-ingestion-synapse.yml)