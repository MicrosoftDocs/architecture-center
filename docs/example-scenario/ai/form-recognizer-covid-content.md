The rapid and accurate verification of COVID-19 vaccination and test statuses has become a global priority for efforts to return to the workplace. Manual data entry slows any COVID-19 compliance effort and introduces errorw. Many organizations don't have the expertise to deploy automated solutions that provide real-time insights.

This architecture can help you automate processes and digitize vaccination and test forms quickly. The AI-powered Azure Form Recognizer helps turn forms into usable data that's translated into real-time, actionable insights and visualized in Power BI to help validate compliance and inform evolving health and safety strategies. 

## Potential use cases

This solution can be applied across many industries for organizations that want to create processes to safely return to the workplace. It's ideal for the healthcare industry.

The solution allows you to modernize your workplace and improve employee and customer safety. It helps reduce the development and deployment effort with automated deployment scripts for all Azure resources and includes Power BI dashboards to present insights to stakeholders.

## Architecture

:::image type="content" border="false" source="./media/form-recognizer-covid.png" alt-text="Diagram that shows an architecture for automating processes and digitizing vaccination and test forms." lightbox="./media/form-recognizer-covid.png":::

*Download a [Visio file]() of this architecture.*

### Dataflow 

1. An Azure logic app ingests raw forms sent as attachments in emails.
2. Alternatively, an Azure function receives raw forms uploaded to a web application or an app created in Power Apps.
3. The raw forms are loaded to Azure Data Lake Storage and processed by an Azure Form Recognizer custom model to extract key-value pairs from the forms. Azure Custom Vision is used to validate any logos in the forms to help ensure the authenticity of the forms.
4. The extracted structured data from unstructured documents is stored in Azure Cosmos DB and Azure Synapse Analytics. 
5. Power BI ingests the extracted data to visualize the insights from the forms.

### Components

- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) helps to automate the workflow for receiving and processing forms sent as email attachments.
- [Azure Functions](https://azure.microsoft.com/services/functions) helps to orchestrate the workflow for receiving and processing forms uploaded to a web application or an app created in Power Apps.
- [Form Recognizer](https://azure.microsoft.com/services/form-recognizer) is a cloud-based Azure Applied AI Services product that uses machine-learning models to extract key-value pairs, text, and tables from documents
- [Azure Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service) helps you build, deploy, and improve an object detection model. It's used here to find and validate the logos in the forms.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a massively scalable and secure data lake for high-performance analytics workloads.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service for modern app development. It's used to store the extracted data from documents in JSON format.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It's used here for data storage and processing.
- [Power BI](https://powerbi.microsoft.com) can help you turn your data into coherent, visually immersive, interactive insights. It's used here to visualize insights from processed form data.

## Considerations

### Availability

The availability of this solution depends on the availability of its major components:
- Form Recognizer is an Applied AI Services product. For details, see [SLA of Azure Applied Services](https://azure.microsoft.com/support/legal/sla/azure-applied-ai-services/v1_0). Note that there is no SLA for the Free tier.
- Azure Cosmos DB provides multiple features and configuration options for high availability. For details, see [High availability in Azure Cosmos DB](/azure/cosmos-db/high-availability#slas-for-availability).
- Azure functions running on Consumption and Premium plans guarantee high availability. For details, see [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2).
- Azure Blob Storage provides redundancy options that help ensure high availability. You can use either locally redundant storage (LRS) or availability zones. For details, see [availability parameters](/azure/storage/common/storage-redundancy#durability-and-availability-parameters).

### Security

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure services in the architecture. You can manage permissions via Azure AD authentication or role-based access control.

Follow [these security guidelines](/azure/security/fundamentals/overview) when you implement this solution.

### Scalability

This solution uses Logic Apps and Azure Functions for workflow orchestration. 
- Azure Functions supports automated and flexible scaling. Azure Functions on the Consumption plan can scale down to zero instances. When a new event triggers a function app, a new instance must be created with your code running on it. The latency that's associated with this process is referred to as a *cold start*. The Azure Functions Premium plan provides the option to configure [pre-warmed instances](/azure/azure-functions/functions-premium-plan#pre-warmed-instances) that are ready for new requests. The number of pre-warmed instances that you can configure is the same as the minimum number of instances in your scale-out configuration.
- Logic Apps provides a way to access and process data in real time, with improved security. Its serverless solutions handle hosting, scaling, and managing workflows as needed.

### Resiliency

The solution's resiliency depends on the failure modes of the individual services in the architecture. 

You can make Form Recognizer resilient by designing it to fail over to another region and/or by splitting the workload into two or more regions. For guidance on Form Recognizer disaster recovery, see [Back up and recover your Form Recognizer models](/azure/applied-ai-services/form-recognizer/disaster-recovery).

For information about resiliency for specific services, see these checklists:
- [Azure Cosmos DB](/azure/architecture/checklist/resiliency-per-service#cosmos-db)
- [Azure Storage](/azure/architecture/checklist/resiliency-per-service#storage)
- [Azure Synapse Analytics](/azure/architecture/checklist/resiliency-per-service#azure-synapse-analytics) 

## Deploy this scenario

Follow the steps in the [Getting Started guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/#getting-started) in [GitHub](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms) to deploy this solution. Getting Started includes a step-by-step deployment guide.

## Pricing

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs of the services in this architecture.

[Azure Functions](https://azure.microsoft.com/pricing/details/functions) provides various plans to help you optimize costs. You can start with a Consumption plan, which is billed based on per-second resource consumption and executions. The Premium plan is required for Azure Virtual Network connectivity, private site access, service endpoints, and pre-warmed instances.

[Logic Apps](https://azure.microsoft.com/pricing/details/logic-apps) provides various plans that are based on the scale of the solution. You can start with the Consumption plan for this solution, which offers pay-as-you-go pricing. 

[Form Recognizer](https://azure.microsoft.com/pricing/details/form-recognizer) provides pay-as-you-go and Commitment tier pricing options. Note that access is limited for Commitment tier pricing. [Apply here](https://aka.ms/commitment-tier-pricing) to request approval.

[Custom Vision](https://azure.microsoft.com/pricing/details/cognitive-services/custom-vision-service) supports Free and Standard instances. You need to use Standard for this solution.

The cost of [Azure Cosmos DB](https://azure.microsoft.com/pricing/details/cosmos-db) database operations is normalized and expressed as request units (RU). Azure Cosmos DB offers two [database operations models](https://www.youtube.com/watch?v=CgYQo6uHyt0&t=9s). You can deploy this solution with a serverless model and adjust as the number of operations increases.

The price for [Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) dedicated SQL pool depends on the service level. You can deploy this solution at the DW100c level and scale up as the amount of data increases.

There are various [Power BI](https://powerbi.microsoft.com/pricing) product options for different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality in your applications.

Azure services like Azure Storage, Azure Key Vault, Application Insights, and so on, that are deployed as part of this solution incur additional costs.

## Next steps 

- Review the information in [this GitHub repository](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms) to determine whether you can benefit from this solution.
- See the [deployment guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/blob/main/Deployment/Deployment.md) in the GitHub repository for step-by-step instructions for deploying this solution.

See these articles for more information: 
- [Azure Applied AI Services documentation](/azure/applied-ai-services)
- [What is Azure Form Recognizer?](/azure/applied-ai-services/form-recognizer/overview)
- [Microsoft Learn: Introduction to Form Recognizer](/learn/modules/intro-to-form-recognizer)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Custom Vision?](/azure/cognitive-services/custom-vision-service/overview)

## Related resources

- [Automate document processing by using Azure Form Recognizer](/azure/architecture/example-scenario/ai/automate-document-processing-azure-form-recognizer)
- [Extract text from objects using Power Automate and AI Builder](/azure/architecture/example-scenario/ai/extract-object-text)
- [Knowledge mining in contract management](/azure/architecture/solution-ideas/articles/contract-management)
- [Knowledge mining in business process management](/azure/architecture/solution-ideas/articles/business-process-management)
- [Knowledge mining for content research](/azure/architecture/solution-ideas/articles/content-research)