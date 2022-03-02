The rapid and accurate verification of COVID-19 vaccination and test statuses has become a global priority for returning to the workplace. Manual data entry slows and introduces errors to any COVID-19 compliance effort, and many organizations lack the internal expertise to deploy automated solutions with real-time insights.

This architecture helps automate processes and digitize vaccination and test forms quickly. The AI-powered Azure Form Recognizer helps turn forms into usable data that is translated into real-time, actionable insights, visualized in Power BI to help validate compliance and inform evolving health and safety strategies. 

## Potential use cases

This solution was originally built for a United States Government customer, but it can be applied across many other industries who is trying to create processes to safely return to the workplace.  

The solution allows you to show how Microsoft can enable organizations to modernize their workplace, facilities and improve employee and customer safety. It helps reduce the development and deployment effort with automated deployment scripts for all Azure Resources and includes Power BI dashboards to present insights to stakeholders.

## Architecture

diagram 

*Download a [Visio file]() of this architecture.*

The architecture shows different components of the forms automation pipeline as follows: 
1.	Azure Logic App ingests raw forms sent as attachments in emails.
2.	Alternatively, an Azure Function receives raw forms uploaded to a Web application or a Power App.
3.	The raw forms are loaded to Azure Data Lake Storage and processed by Azure Form Recognizer custom model to extract key-value pairs from the forms. Azure Custom Vision model is used to validate any logos in the forms to validate the authenticity of the forms.
4.	The extracted structured data from unstructured documents is then stored in Azure Cosmos DB and Azure Synapse Analytics. 
5.	Microsoft Power BI ingests this extracted data to visualize the insights from forms.

### Components

- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) help automate the workflow to receive and process the forms as email attachments.
- [Azure Functions](https://azure.microsoft.com/services/functions) help orchestrate the workflow to receive and process the forms uploaded to a web application or a power app.
- [Azure Form Recognizer](/services/form-recognizer) is a cloud-based Azure Applied AI Service that uses machine-learning models to extract key-value pairs, text, and tables from your documents
- [Azure Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service) helps you build, deploy, and improve an object detection model. It’s used here to find and validate the logos in the forms.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a massively scalable and secure data lake for your high-performance analytics workloads.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service for modern app development. It’s used to store the extracted data from documents in JSON format.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It's used here for data storage and processing.
- [Power BI](https://powerbi.microsoft.com) can help you turn your data into coherent, visually immersive, and interactive insights. It's used here to visualize insights from processed forms data.

## Considerations

### Availability

The availability of this solution depends on the availability of its major components below:
- Forms Recognizer is an Applied AI service. Please see [SLA of Azure Applied Services](https://azure.microsoft.com/support/legal/sla/azure-applied-ai-services/v1_0) for details and note that there is no SLA provided for the Free tier.
- Cosmos DB is designed to provide multiple features and configuration options to achieve high availability. Please see [High availability in Azure Cosmos DB](/azure/cosmos-db/high-availability#slas-for-availability) for more details.
- Azure functions running on both Consumption and Premium plans guarantee high availability. Please refer to [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2) for more details.
- Blob Storage offers redundancy options that help ensure high availability. You can either use locally redundant storage (LRS) or Availability Zones. Please refer to [Availability Parameters](/azure/storage/common/storage-redundancy#durability-and-availability-parameters) for more details.

### Security

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure solutions in the architecture. You can manage permissions via Azure AD authentication or role-based access control.

Follow [these](/azure/security/fundamentals/overview) security guidelines when you implement this Azure solution.

### Scalability

This solution uses Azure Logic Apps and Azure Functions for workflow orchestration. 
- Azure Functions support automated and flexible scaling. Azure Functions on the consumption plan can scale down to zero instances. When a new event triggers a function app, a new instance must be created with your code running on it. The latency that's associated with this process is referred to as a cold start. The Azure Functions Premium plan offers the option to configure [pre-warmed instances](/azure/azure-functions/functions-premium-plan#pre-warmed-instances) that are ready for any new requests. You can configure the number of pre-warmed instances up to the minimum number of instances in your scale-out configuration.
- Azure Logic App service provides a way to securely access and process data in real time. Its serverless solutions take care of hosting, scaling, managing the workflows as needed.

### Resiliency

The solution's resiliency depends on the failure modes of individual services in the architecture. 

Form Recognizer can be made resilient by designing it to fail over to another region and/or splitting the workload into two or more regions. Please see [this document](/azure/applied-ai-services/form-recognizer/disaster-recovery) for Form Recognizer disaster recovery guidance.

Please read the checklists below for different services:
- [Cosmos DB](/azure/architecture/checklist/resiliency-per-service#cosmos-db)
- [Azure Storage](/azure/architecture/checklist/resiliency-per-service#storage)
- [Azure Synapse Analytics](/azure/architecture/checklist/resiliency-per-service#azure-synapse-analytics) 

## Deploy this scenario

Follow the steps in the [Getting Started Guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/#getting-started) (includes a step-by-step Deployment Guide) within the [GitHub Repository](/azure/security/fundamentals/overview) to deploy this solution.  < link seems wrong 

## Pricing

Use the [Azure pricing calculator]() to estimate costs of services in the architecture

Azure Functions]() has various plans to choose from to help you optimize costs. You can start with a consumption plan which is billed based on per-second resource consumption and executions. Premium plan is required for Azure Virtual Network connectivity, private site access, service endpoints, and pre-warmed instances.

Azure Logic Apps]() has various plans to choose from depending on the scale of the solution. You can start with Consumption plan for this solution which allows you to ‘pay-as-you-go’. 

Azure Form Recognizer]() has ‘Pay as You Go’ and ‘Commitment Tiers’ options for pricing. Please note that commitment tiers pricing is limited access. Apply [here] to request approval.

Azure Custom Vision]() supports ‘Free’ and ‘Standard’ instances. You can choose ‘Standard’ instance for this solution.

Azure Cosmos DB]() The cost of Cosmos DB database operations is normalized and expressed as request units (RU). Azure Cosmos DB offers two [database operations models](). You can deploy this solution with a serverless model and can adjust as the number of operations increases.

[Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) dedicated SQL pool price varies based on service level. You can deploy this solution with ‘DW100c’ level and scale up as the data size increases over time.

There are various [Power BI]() product options to meet different requirements. [Power BI Embedded]() provides an Azure-based option for embedding Power BI functionality in your applications.

Azure services like Azure Storage accounts, Key Vault, Application Insights, and so on, that are deployed as part of this solution incur other costs.

## Next steps 

1.	Review the information presented within the [GitHub repository] to determine whether your customer would benefit from this Solution Accelerator.
2.	Review the [deployment guide] within the GitHub repository for a step-by-step guide on how to deploy the solution with a customer.

## Related resources

