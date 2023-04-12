This solution combines Azure Synapse Analytics with Dynamics 365 Customer Insights, to build a comprehensive view that presents your customer data and to provide the best customer experience.

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" border="false" source="./media/customer-360.svg" alt-text="Diagram that shows an architecture for a Customer 360 solution that uses Azure Synapse Analytics and Dynamics 365 Customer Insights." lightbox="./media/customer-360.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/customer-360-architecture.vsdx) of this architecture.*

### Dataflow

1.	Azure Synapse Analytics ingests raw source data by using Azure Synapse pipelines. 
2.	Source data is stored in Azure Synapse Analytics and Azure Data Lake Storage Gen2.
3.	Dynamics 365 Customer Insights connects to customer data from Azure Synapse. 
4.	Administrators configure unified customer profiles in Customer Insights, together with measures, segments, and enrichments. Unified customer profiles are ported from Customer Insights to Azure Synapse.
5.	Administrators use the unified customer profile in Azure Synapse to create an Azure Machine Learning pipeline for retention prediction. 
6.	Administrators create a retention prediction model endpoint.
7.	Administrators create a custom model workflow in Customer Insights to call the Azure Machine Learning pipeline to get the retention predictions.
8.	Power BI ingests the Customer 360 data from Customer Insights to visualize the profiles and metrics.

### Components

- [Dynamics 365 Customer Insights](https://dynamics.microsoft.com/ai/customer-insights/audience-insights-capability) can help you provide unmatched customer experiences by using world-class AI and analytics. Here, it's used to unify, segment, and enrich customer data.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It's used here for data ingestion, storage, and processing.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a massively scalable and secure data lake for your high-performance analytics workloads.  
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an end-to-end machine learning service. It's used in this architecture to predict customer retention. 
- [Power BI](https://powerbi.microsoft.com) can help you turn your data into coherent, visually immersive, and interactive insights. It's used here to visualize customer profiles and metrics.

## Scenario details

Managing customer data from multiple sources and building a unified Customer 360 view isn't a new challenge. But it is becoming increasingly difficult with the increased number of interaction channels and touchpoints with customers. By combining Azure Synapse Analytics with Dynamics 365 Customer Insights, you can build a comprehensive view of your customers to provide the best customer experience.

### Potential use cases

This solution was created for a property management organization. It can also be applied in industries like retail, financial services, manufacturing, and health care. It can be used by any organization that needs to bring data together across systems to build a Customer 360 profile and improve the customer experience.

You can use this solution to:
- Gain better insights from your customer data. 
- Target sources of customer churn or dissatisfaction.
- Direct account and customer service activities.
- Run targeted promotions that are aimed at customer retention or upselling.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security 

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure solutions in the architecture. You can manage permissions via Azure AD authentication or role-based access control. 

Follow these security guidelines when you implement this solution:
- [Security in Azure](/azure/security/fundamentals/overview)
- [Access control for Azure Synapse](/azure/synapse-analytics/security/how-to-set-up-access-control)
- [User permissions for Customer Insights](/dynamics365/customer-insights/audience-insights/permissions)

### Scalability

This solution uses Azure Synapse Spark clusters, which can be automatically scaled up and down based on the activity needs of your workload. For more information, see [Azure Synapse Spark cluster autoscaling](/azure/synapse-analytics/spark/apache-spark-pool-configurations#autoscale).  

Azure Machine Learning training pipelines can be scaled up and down based on data size and other configuration parameters. The compute clusters support autoscaling and automatic shutdown to optimize for performance and cost. 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

[Dynamics 365 Customer Insights](https://dynamics.microsoft.com/ai/customer-insights/pricing) license pricing options are based on the number of customer profiles needed.

[Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) has various pricing options to help you optimize costs. You can perform big data processing tasks like data engineering, data preparation, and machine learning directly in Azure Synapse by using memory-optimized or hardware-accelerated Apache Spark pools. Billing for usage of Spark pools is rounded up to the nearest minute.

[Azure Machine Learning](https://azure.microsoft.com/pricing/details/machine-learning/#pricing) has no additional license charge. However, there are charges for compute and other Azure services that you consume, including but not limited to Azure Blob Storage, Azure Key Vault, Azure Container Registry, and Application Insights.

There are various [Power BI](https://powerbi.microsoft.com/pricing) product options to meet different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality in your applications. 

You can deploy this solution with the following options.
- Dynamics 365 Customer Insights: 1,500 profiles
- Azure Synapse Analytics: Memory-optimized Spark cluster of medium size (8 vCores / 64 GB)
- Azure Machine Learning
   - Compute instance of type Standard_DS11_v2
   - Compute cluster of type Standard_D2_v2

Azure services like Azure Storage accounts, Key Vault, Container Registry, Application Insights, and so on, that are deployed with Azure Synapse Analytics and Azure Machine Learning incur other costs.

## Deploy this scenario

To deploy this solution, follow the steps in the [Getting Started guide](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator#getting-started) and the step-by-step [Deployment Guide](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator/blob/main/Deployment/AzureSetup.md). You can find them in the [GitHub repository](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator#about-this-repository) for the solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Nalini Chandhi](https://www.linkedin.com/in/nalinichandhi) | Sr. Technical Specialist

## Next steps
- [Unlock customer intent with Dynamics 365 Customer Insights](/training/paths/build-customer-insights)
- [Product overview for Dynamics 365 Customer Insights](/dynamics365/customer-insights/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)

## Related resources
- [Enhanced customer dimension with Dynamics 365 Customer Insights](../../solution-ideas/articles/customer-insights-synapse.yml)
- [Modern data warehouse for small and medium businesses](../../example-scenario/data/small-medium-data-warehouse.yml) 
- [Clinical insights with Microsoft Cloud for Healthcare](../../example-scenario/mch-health/medical-data-insights.yml) 
- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
