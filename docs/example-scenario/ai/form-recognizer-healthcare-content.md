This article describes a solution for automating the tasks of processing and digitizing healthcare forms.

## Architecture

:::image type="content" border="false" source="./media/form-recognizer-healthcare.png" alt-text="Architecture diagram that shows an automated solution for collecting, processing, and analyzing data from healthcare forms." lightbox="./media/form-recognizer-healthcare.png":::

*Download a [Visio file](https://arch-center.azureedge.net/form-recognizer-healthcare.vsdx) of this architecture.*

### Dataflow

1. An Azure logic app ingests raw forms that are sent as attachments in emails.
1. Alternatively, an Azure function app receives raw forms that are uploaded to a web application or that an app creates in Power Apps.
1. The raw forms are loaded into Azure Data Lake Storage. An Azure Form Recognizer custom model extracts key-value pairs from the forms. Azure Custom Vision validates any logos in the forms to help ensure the authenticity of the forms.
1. The structured data that's extracted from the unstructured documents is stored in Azure Cosmos DB and Azure Synapse Analytics.
1. Power BI ingests the extracted data to visualize insights from the forms.

### Components

- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) helps to automate the workflow for receiving and processing forms that are sent as email attachments.
- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. Here, it helps to orchestrate the workflow for receiving and processing uploaded forms.
- [Form Recognizer](https://azure.microsoft.com/services/form-recognizer) is a cloud-based Azure Applied AI Services product that uses machine-learning models to extract key-value pairs, text, and tables from documents.
- [Azure Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service) helps you build, deploy, and improve an object detection model. It's used here to find and validate logos in the forms.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides a massively scalable and highly secure data lake for high-performance analytics workloads.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service for modern app development. It's used to store the extracted data from documents in JSON format.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It's used here for data storage and processing.
- [Power BI](https://powerbi.microsoft.com) can help you turn your data into coherent, visually immersive, interactive insights. It's used here to visualize insights from processed form data.

## Scenario details

Manual data entry is a tedious process that can introduce errors. With healthcare data such as vaccination and test form data, manually entering data can also slow down compliance efforts. Automating data entry and verification tasks can speed up the process, improve its accuracy, and provide real-time insights from the data. But many organizations don't have the internal expertise that's needed to deploy automated solutions.

The AI-powered Azure Form Recognizer helps turn forms into usable data that's translated into real-time, actionable insights and visualized in Power BI. These insights can help you validate compliance and inform your health and safety strategies.

### Potential use cases

This solution is ideal for the healthcare industry. Organizations across many industries that need to meet healthcare compliance regulations can also use this solution.

You can use this solution to modernize your workplace and improve employee and customer safety. The AI-powered Azure Form Recognizer helps reduce development and deployment effort by introducing automated deployment scripts for all Azure resources. The solution uses Power BI dashboards to present insights to stakeholders.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The availability of this solution depends on the availability of its main components:

- Form Recognizer is an Applied AI Services product. For details, see [SLA of Azure Applied AI Services](https://azure.microsoft.com/support/legal/sla/azure-applied-ai-services/v1_0). There's no SLA for the Free tier.
- Azure Cosmos DB provides multiple features and configuration options for high availability. For details, see [High availability in Azure Cosmos DB](/azure/cosmos-db/high-availability#slas-for-availability).
- Azure function apps running on Consumption and Premium plans guarantee high availability. For details, see [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2).
- Azure Blob Storage provides redundancy options that help ensure high availability. You can use either locally redundant storage (LRS) or availability zones. For details, see [availability parameters](/azure/storage/common/storage-redundancy#durability-and-availability-parameters).

The solution's resiliency depends on the failure modes of the individual services in the architecture.

You can make Form Recognizer resilient by designing it to fail over to another region or by splitting the workload into two or more regions. For guidance on Form Recognizer disaster recovery, see [Back up and recover your Form Recognizer models](/azure/applied-ai-services/form-recognizer/disaster-recovery).

For information about resiliency for other services, see these checklists:

- [Azure Cosmos DB](../../checklist/resiliency-per-service.md#azure-cosmos-db)
- [Azure Storage](../../checklist/resiliency-per-service.md#storage)
- [Azure Synapse Analytics](../../checklist/resiliency-per-service.md#azure-synapse-analytics)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution uses Azure Active Directory (Azure AD) to authenticate users to the Azure services in the architecture. You can manage permissions via Azure AD authentication or role-based access control.

For security guidelines to follow when you implement this solution, see [Introduction to Azure security](/azure/security/fundamentals/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To estimate the costs of the services in this architecture, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

[Azure Functions](https://azure.microsoft.com/pricing/details/functions) provides various plans to help you optimize costs. You can start with the Consumption plan, which is billed based on per-second resource consumption and executions. The Premium plan is required for Azure Virtual Network connectivity, private site access, service endpoints, and pre-warmed instances.

[Logic Apps](https://azure.microsoft.com/pricing/details/logic-apps) provides various plans that are based on the scale of the solution. For this solution, you can start with the Consumption plan, which offers pay-as-you-go pricing.

[Form Recognizer](https://azure.microsoft.com/pricing/details/form-recognizer) provides pay-as-you-go and Commitment tier pricing options. Access is limited for Commitment tier pricing. To request approval, see [Purchase commitment tier pricing](/azure/cognitive-services/commitment-tier).

[Custom Vision](https://azure.microsoft.com/pricing/details/cognitive-services/custom-vision-service) supports Free and Standard instances. You need to use Standard for this solution.

The cost of [Azure Cosmos DB](https://azure.microsoft.com/pricing/details/cosmos-db) database operations is normalized and expressed as request units (RU). Azure Cosmos DB offers two [database operations models](https://www.youtube.com/watch?v=CgYQo6uHyt0&t=9s). You can deploy this solution with a serverless model and adjust as the number of operations increases.

The price for an [Azure Synapse Analytics](https://azure.microsoft.com/pricing/details/synapse-analytics) dedicated SQL pool depends on the service level. You can deploy this solution at the DW100c level and scale up as the amount of data increases.

There are various [Power BI](https://powerbi.microsoft.com/pricing) product options to meet different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality in your applications.

Azure services like Azure Storage, Azure Key Vault, and Application Insights that are deployed as part of this solution also incur costs.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This solution uses Logic Apps and Azure Functions for workflow orchestration.

- Azure Functions supports automated and flexible scaling. Azure Functions on the Consumption plan can scale down to zero instances. When a new event triggers a function app, a new instance must be created with your code running on it. This process is referred to as a *cold start*, and there's latency associated with it. The Azure Functions Premium plan provides the option to configure [pre-warmed instances](/azure/azure-functions/functions-premium-plan#pre-warmed-instances) that are ready for new requests. The number of pre-warmed instances that you can configure is the same as the minimum number of instances in your scale-out configuration.
- Logic Apps provides a way to access and process data in real time, with improved security. Its serverless solutions handle hosting, scaling, and managing workflows as needed.

## Deploy this scenario

To deploy this solution, follow the steps in the [Getting Started guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/#getting-started) in [GitHub](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms). Getting Started includes a step-by-step [deployment guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/blob/main/Deployment/Deployment.md).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Nalini Chandhi](https://www.linkedin.com/in/nalinichandhi) | Sr. Technical Specialist

## Next steps

To determine whether you can benefit from this solution, review the information in the [Azure solution accelerator for automating healthcare forms](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms) repository on GitHub.

For step-by-step instructions for deploying the solution, see the [deployment guide](https://github.com/microsoft/Azure-Solution-Accelerator-to-automate-COVID-19-Vaccination-Proof-and-Test-Verification-Forms/blob/main/Deployment/Deployment.md) in the GitHub repository.

For more information, see the following articles:

- [Azure Applied AI Services documentation](/azure/applied-ai-services)
- [What is Azure Form Recognizer?](/azure/applied-ai-services/form-recognizer/overview)
- [Introduction to Form Recognizer](/training/modules/intro-to-form-recognizer)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Custom Vision?](/azure/cognitive-services/custom-vision-service/overview)

## Related resources

- [Automate document processing by using Azure Form Recognizer](../../example-scenario/ai/automate-document-processing-azure-form-recognizer.yml)
- [Extract text from objects using Power Automate and AI Builder](../../example-scenario/ai/extract-object-text.yml)
- [Knowledge mining in contract management](../../solution-ideas/articles/contract-management.yml)
- [Knowledge mining in business process management](../../solution-ideas/articles/business-process-management.yml)
- [Knowledge mining for content research](../../solution-ideas/articles/content-research.yml)
