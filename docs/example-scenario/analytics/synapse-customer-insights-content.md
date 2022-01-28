Managing customer data from multiple sources and building a unified Customer 360 view isn't a new challenge. But it is becoming increasingly difficult with the increased number of interaction channels and touchpoints with customers. By combining Azure Synapse Analytics with Dynamics 365 Customer Insights, you can build a comprehensive view of your customers to provide the best customer experience.

## Potential use cases
This solution was created for a property management organization. It can also be applied in industries like retail, financial services, manufacturing, and health care. It can be used by any organization that needs to bring data together across systems to build a Customer 360 profile to improve the customer experience.

You can use this solution to: 
- Gain better insights from your customer data. 
- Target sources of customer churn or dissatisfaction.
- Direct account and customer service activities.
- Run targeted promotions aimed at customer retention or upselling.

## Architecture
![Diagram that shows an architecture for a Customer 360 solution that uses Azure Synapse Analytics and Dynamics 365 Customer Insights.](./media/customer-360-architecture.png)

*Download a [Visio file](https://arch-center.azureedge.net/customer-360-architecture.vsdx) of this architecture.*

### Workflow

1.	Azure Synapse Analytics ingests raw source data by using Azure Synapse pipelines. 
2.	Source data is stored in Azure Synapse Analytics and Azure Data Lake Storage Gen2.
3.	Dynamics 365 Customer Insights connects to customer data from Azure Synapse. 
4.	Administrators configure unified customer profiles in Customer Insights, together with measures, segments, and enrichments. Unified customer profiles are ported from Customer Insights to Azure Synapse.
5.	Administrators use the unified customer profile in Azure Synapse to create an Azure Machine Learning pipeline for renewal prediction. 
6.	A lease renewal prediction model endpoint is created.
7.	A custom model workflow is created in Customer Insights to call the Azure ML pipeline to get the lease renewal predictions 
8.	Microsoft Power BI ingests the customer 360 data from Customer Insights to visualize the profiles and metrics.

### Components
- [Dynamics 365 Customer Insights](https://dynamics.microsoft.com/ai/customer-insights/audience-insights-capability)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) 
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning)
- [Power BI](https://powerbi.microsoft.com)

## Considerations
### Security 
This solution uses Azure Active Directory (Azure AD) to authenticate users to Azure solutions in the architecture. Permissions can be managed via Azure AD authentication or role-based access control. 

Please follow the below security guidelines while implementing this solution:
- [Best practices and guidance for developing secure Azure solutions](/azure/security/fundamentals/overview)
- [Access control for Azure Synapse](/azure/synapse-analytics/security/how-to-set-up-access-control)
- [User permissions for Customer Insights](/dynamics365/customer-insights/audience-insights/permissions)

### Scalability
This scenario uses Azure Synapse Analytics Spark clusters which can be automatically scaled up and down based on the activity needs of your workload. For additional information on the scalability of Spark clusters, see [Azure Synapse Analytics Spark cluster autoscaling](/azure/synapse-analytics/spark/apache-spark-pool-configurations#autoscale).  

Azure Machine Learning training pipelines can be scaled up and down based on data size and other configuration parameters. The compute clusters support autoscaling and auto shutdown to optimize for performance and cost. 

## Deploy this scenario
Follow the steps in the [Getting Started Guide](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator#getting-started) (includes a step-by-step Deployment Guide) within the [GitHub Repository](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator#about-this-repository) to deploy this solution.

## Pricing
[Dynamics 365 Customer Insights](https://dynamics.microsoft.com/ai/customer-insights/pricing) license pricing options are available based on the number of customer profiles needed.

[Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) has different pricing options to optimize costs as needed. Big data processing tasks such as data engineering, data preparation, and machine learning can be performed directly in Azure Synapse using memory optimized or hardware-accelerated Apache Spark pools. Usage of Spark pools is billed by rounding up to the nearest minute.

[Azure Machine Learning](https://azure.microsoft.com/pricing/details/machine-learning/#pricing) has no additional license charge. However, there will be charges for compute and other Azure services consumed, including but not limited to Azure Blob Storage, Azure Key Vault, Azure Container Registry and Azure Application Insights.

[Power BI](https://powerbi.microsoft.com/pricing) has different product options available for different requirements. [Power BI Embedded] provides an Azure-based option for embedding Power BI functionality inside your applications. 

This solution can be deployed with the following options:
- Dynamics 365 Customer Insights – 1500 profiles
- Azure Synapse Analytics – Memory Optimized Spark cluster of Medium Size (8 vCores/64GB)
- Azure Machine Learning
   - Compute Instance of type STANDARD_DS11_V2
   - Compute cluster of type STANDARD_D2_V2

Please note that there will be additional costs from other Azure services like Azure Storage accounts, Azure Key Vault, Azure Container Registry, Azure App Insights etc. that are deployed with Azure Synapse Analytics and Azure Machine Learning.

## Next steps
1.	Review the information presented within the [GitHub repository](https://aka.ms/Customer360SA) to determine whether your customer would benefit from this Solution Accelerator.
2.	Review the [deployment guide](https://github.com/microsoft/Azure-Synapse-Customer-Insights-Customer360-Solution-Accelerator/blob/main/Deployment/AzureSetup.md) within the GitHub repository for a step-by-step guide on how to deploy the solution with a customer.

## Related resources