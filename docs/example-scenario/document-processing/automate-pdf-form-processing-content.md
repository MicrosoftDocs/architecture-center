## Automate PDF form processing 

This article describes an architecture that you can use to replace manual PDF form processing process or costly legacy PDF form processing systems. The applied AI services are provided by [Azure Form Recognizer](<https://azure.microsoft.com/en-us/services/form-recognizer/>) which is part of the [Azure Cognitive Services] ([Azure Cognitive Services documentation | Microsoft Learn](https://learn.microsoft.com/en-us/azure/cognitive-services/)). The workflow is provided by [Azure Logic Apps](<https://azure.microsoft.com/en-us/services/logic-apps/#overview>). The data processing capabilities are provided by [Azure Functions](<https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview>).

A reference implementation with code, deployment scripts, and guide is published in this GitHub Repository: [GitHub - microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator). The implementation creates custom models using [Form Recognizer Studio](https://formrecognizer.appliedai.azure.com/studio). Step 2 of the deployment guide provides details on how to create a custom-built machine learning model using sample PDF forms. The custom-built machine learning model is plugged into the solution through a simple configuration: The machine model name is configured through an environment variable called “CUSTOM\_BUILT\_MODEL\_ID” in the Azure Functions App. For more details, please review step 3 of the deployment guide.

## Architecture

:::image type="content" source="images/automate-pdf-form-processing.png" alt-text="{Diagram of the architecture for PDF form processing}":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/automate-pdf-form-processing.pptx) of this architecture.*

### Workflow

1. Designated outlook email account receives PDF files as Attachments, which triggers the email processing logic app to start processing. This is a designated and dedicated email account that receives PDF forms as attachments. It will be good practice to limit the senders to only trusted parties and avoid malicious actors from spamming outlook email account.
1. The email processing logic app extracts and uploads the PDF Attachments to a specified container in Azure Data Lake Storage, for example, \`files-1-input\`. This container name is configurable from the deployment scripts published in the GitHub Repository.
1. PDF forms are manually or programmatically uploaded to the \`files-1-input\` container in Azure Data Lake Storage.
1. Whenever PDF forms are uploaded to the specified azure storage \`files-1-input\` container, it will trigger the form processing logic app to start processing the PDF forms.
1. The form processing logic app sends the location of the received PDF file to Azure Functions App for processing.
1. Azure Functions App receives the location of file, and triggers multiple events:
   1. The Functions App splits the file into single pages if the file has multiple pages, with each page containing one independent form. Split files are saved to Azure Data Lake Storage, in the container \`files-2-split\`.
   1. Via REST API (HTTPS POST), the Azure Functions app sends the location of the single page PDF file to Azure Form Recognizer for processing and receives response. The functions app prepares the response into desired data structure.
   1. Azure Functions App saves the structured data as JSON file to Azure Data Lake Storage, in the container, \`file-3-recognized\`.
1. The form processing logic app receives the processed response data.
1. The form processing logic app sends the processed data to Azure Cosmos DB. Azure Cosmos DB saves the data into specified database and collections.
1. Power BI is connected to Azure Cosmos DB to receive data and provide insights/dashboards.

### Components

- [Azure Form Recognizer](<https://azure.microsoft.com/en-us/services/form-recognizer/>) is a cloud-based Azure Applied AI Service that uses machine-learning models to extract key-value pairs, text, and tables from your documents.
- [Azure Logic Apps](<https://azure.microsoft.com/en-us/services/logic-apps/#overview>) is a cloud service that helps to schedule, automate, and orchestrate tasks, business processes, and workflows when you need to integrate apps, data, systems, and services across enterprises or organizations.
- [Azure Functions](<https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview>) is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs.
- [Azure Data Lake Storage](<https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction>) is the foundation for building enterprise data lakes on Azure.
- [Azure Cosmos DB](<https://azure.microsoft.com/en-us/services/cosmos-db/>)  is a fully managed NoSQL and relational database for modern app development.
- [Power BI](<https://docs.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview>) is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.

### Alternatives

- [Azure SQL Database]( [Azure SQL Database – Managed Cloud Database Service | Microsoft Azure](https://azure.microsoft.com/en-us/products/azure-sql/database/)) can be used to store the processed forms data instead of Azure Cosmos DB.
- [Azure Data Explorer]([Azure Data Explorer](https://dataexplorer.azure.com/publicfreecluster)) can be used to visualize the processed forms data stored in Azure Data Lake Storage.

## Scenario details

Form processing is a critical business function across industries. Many companies are still relying on manual processes, which are costly, time-consuming, and error prone. Replacing these manual processes not only reduces a company’s cost and risk but also provides business agility.

A solution accelerator with fully automated deployment process and implementation code is published to this GitHub Repository: [microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator (github.com)](<https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator>). You can follow deployment guide to deploy and set up the solution in a specified Azure Subscription and use the sample PDF forms to create a Machine Learning Model, configure the Azure Functions app to use the machine learning model, and test the solution using the additional PDF forms published.

This solution accelerator receives the PDF forms, extracts the data fields, and saves the data in Azure Cosmos DB. Power BI is then used to visualize the data. The solution accelerator was designed with a modular, metadata-driven methodology. No form fields are hard coded! It can process any PDF forms.

To process another type of new PDF forms, you will need to create a new machine learning model using new sample PDF files and plug the new machine learning model ID into the solution.

### Potential use cases

The reference implementation published in the GitHub Repository [GitHub - microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator) can be utilized directly without code modification to process PDF forms such as safety forms, invoices, incident records, and many others.

The solution can be utilized to process any PDF forms as the solution utilizes the field names saved in the machine learning model as reference to process additional unseen forms. Only 5 sample forms are needed to create a custom-built machine learning model. Up to 100 custom-built models can be merged into a composite machine learning model, to process forms that have various formats.

It can be used to process below PDF forms:

- Invoices
- Payment Records
- Safety Records
- Incident Records
- Compliance Records
- Purchase Orders
- Payment Authorization Forms
- Health Screening Forms
- Survey Forms

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework).

### Reliability

This architecture utilizes scalable and resilient Azure infrastructure and technologies. For example, Azure Cosmos DB has built-in redundancy and global coverage that is configurable to meet your specific needs. The published architecture implementation does not cover any specific High Availability and Disaster Recover (HA/DR) requirements. This architecture is intended to be a starter architecture that you can quickly deploy and prototype to provide a business solution. If successful, you can then extend and enhance the architecture to meet your own specific requirements.

If you would like to extend and enhance the current architecture for production deployment, please consider the recommendations and best practices listed below:

- Design HA/DR architecture based on your specific requirements and leverage the built-in redundancy capabilities where applicable.
- Update the bicep deployment code to create higher or different computing environments that match the requirements of your processing volumes.
- Update the bicep deployment code to create additional instances of the Architecture components that are required by your HA/DR requirements.
- Design and provision the Azure Data Lake Storage by following these guidelines: [Data redundancy - Azure Storage | Microsoft Learn](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json)
- Design and provision the Logic Apps by following these guidelines: [Business continuity and disaster recovery - Azure Logic Apps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/logic-apps/business-continuity-disaster-recovery-guidance)
- Design and provision the Functions App by following these guidelines: [Reliability in Azure Functions | Microsoft Learn](https://learn.microsoft.com/en-us/azure/reliability/reliability-functions?toc=%2Fazure%2Fazure-functions%2FTOC.json&tabs=azure-portal)
- Design and provision the Azure Cosmos DB by following these guidelines: [High availability in Azure Cosmos DB | Microsoft Learn](https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability)

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview).

A reliable workload is one that's both resilient and available. *Resiliency* is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. *Availability* is a measure of whether your users can access your workload when they need to.

For the availability guarantees of the Azure services in this solution, see these resources:

- [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5)
- [SLA for Azure Cognitive Services](https://azure.microsoft.com/support/legal/sla/cognitive-services/v1_1)
- [SLA for Azure Logic Apps](https://azure.microsoft.com/support/legal/sla/logic-apps/v1_0)
- [SLA for Azure Functions](https://www.azure.cn/en-us/support/sla/functions/)
- [SLA for Power BI](https://azure.microsoft.com/support/legal/sla/power-bi-embedded/v1_1)

### Security

The implementation code of this architecture has leveraged below security constructs:

- Azure Key Vault is created with the deployment scripts (PowerShell and bicep) to store sensitivity information so that they will not be displayed on the screens or deployment logs.
- Managed identity is utilized in Azure Functions App so that the code is not dependent on individual principals. The published code does not contain sensitive information except the processing logic.
- Additional security measures to consider can be found in the Well-architected Framework Security documentation: [Overview of the security pillar - Microsoft Azure Well-Architected Framework | Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/framework/security/overview)

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/cost/overview).

Here are some guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture, and [scale out](https://learn.microsoft.com/en-us/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start.
- You can deploy this solution accelerator by following the deployment guide: [Azure-PDF-Form-Processing-Automation-Solution-Accelerator/Deployment at main · microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator (github.com)](<https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator/tree/main/Deployment>). This will deploy a starting solution that is suitable for proof of concept. The deployment scripts create a working architecture with minimal resource requirements, for example, the deployment scripts create a smallest serverless Linux host to run the Azure Functions app.
- If you consider putting this system into production to process very large volumes of PDF forms, you can modify the deployment scripts to create a Linux Host with more resources. This can be accomplished by modifying the code inside [deploy-functionsapp.bicep] ([Azure-PDF-Form-Processing-Automation-Solution-Accelerator/deploy-functionsapp.bicep at main · microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator · GitHub](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator/blob/main/Deployment/1_deployment_scripts/deploy-functionsapp.bicep))

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/overview).

This architecture uses selected Azure PaaS and SaaS PaaS offerings that have built-in scaling capabilities that can be enabled to achieve performance efficiency.
- Azure Logic Apps and Azure Functions can both be hosted in serverless infrastructure: [Azure serverless - Azure Logic Apps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-serverless-overview).For example, Azure Logic Apps and Azure Functions can both be hosted in serverless infrastructure: Azure serverless - Azure Logic Apps | Microsoft Learn.
- Cosmos DB can be configured to automatically scale its throughput:

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><a href="https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-provision-autoscale-throughput?tabs=api-async">Provision autoscale throughput in Azure Cosmos DB for NoSQL | Microsoft Learn</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:- [Gail Zhou](http://linkedin.com/in/gailzhou) | Sr. Architect

Other contributors:

- [Nalini Chandhi](http://linkedin.com/in/nalinichandhi/) | Principal Technical Specialist
- [Steve DeMarco](http://linkedin.com/in/steve-dem/) | Sr. Cloud Solution Architect
- [Travis Hilbert](http://linkedin.com/in/travis-hilbert-a3999980) | Technical Specialist Global Black Belt
- [DB Lee](https://www.linkedin.com/in/dongbum/) | Sr. Technical Specialist
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135) | Technical Specialist Global Black Belt
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Sr. Cloud Solution Architect
- [Echo Wang](https://www.linkedin.com/in/echo-wang-99205343/) | Principal Program Manager

## Next steps

You can watch this YouTube Video that provides a quick guide for deployment and testing: [Azure PDF Form Processing Automation SA - YouTube](https://www.youtube.com/watch?v=2zvoO1jc8CE).

You can deploy the solution accelerator by following the instructions in this deployment guide:

[Azure-PDF-Form-Processing-Automation-Solution-Accelerator/Deployment at main · microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator (github.com)](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator/tree/main/Deployment)

To use this solution accelerator, you will need access to an [Azure subscription](https://azure.microsoft.com/en-us/free/). An understanding of Azure Form Recognizer, Azure Form Recognizer Studio, Azure Logic Apps, Azure Functions, Azure Cosmos DB, and Power BI will be helpful.

## Related resources

- GitHub Repository Link: [microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator (github.com)](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator)
- Deployment Guide: <https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator>
- YouTube Guide: [Azure PDF Form Processing Automation SA - YouTube](<https://www.youtube.com/watch?v=2zvoO1jc8CE>)
- Azure invoice Processing Automation Solution Accelerator: [GitHub - microsoft/Azure-Invoice-Process-Automation-Solution-Accelerator](https://github.com/microsoft/Azure-Invoice-Process-Automation-Solution-Accelerator)
- Azure Business Process Automation Solution Accelerator: [Azure/business-process-automation: Business process automation solution accelerator using Azure services (github.com)](https://github.com/Azure/business-process-automation)
- Tutorial: Automate tasks to process emails by using Azure Logic Apps, Azure Functions, and Azure Storage: [Automate tasks with multiple Azure services - Azure Logic Apps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/logic-apps/tutorial-process-email-attachments-workflow)
