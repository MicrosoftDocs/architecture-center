This article describes an Azure architecture that you can use to replace costly and inflexible forms processing methods with cost-effective and flexible automated PDF processing.

## Architecture

:::image type="content" source="_images/automate-pdf-forms-processing.png" alt-text="Diagram of the architecture for PDF forms processing":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/automate-pdf-forms-processing.pptx) of this architecture.*

### Workflow

1. A designated Outlook email account receives PDF files as attachments. The arrival of an email triggers a logic app to process the email. The logic app is built by using the capabilities of Azure Logic Apps.
1. The logic app uploads the PDF files to a container in Azure Data Lake Storage.
1. You can also manually or programmatically upload PDF files to the same PDF container.
1. The arrival of a PDF file in the PDF container triggers another logic app to process the PDF forms that are in the PDF file.
1. The logic app sends the location of the PDF file to a function app for processing. The function app is built by using the capabilities of Azure Functions.
1. The function app receives the location of the file and takes these actions:
   1. It splits the file into single pages if the file has multiple pages. Each page contains one independent form. Split files are saved to a second container in Data Lake Storage.
   1. It uses HTTPS POST, an Azure REST API, to send the location of the single-page PDF file to AI Document Intelligence for processing. When Azure AI Document Intelligence completes its processing, it sends a response back to the function app, which places the information into a data structure.
   1. It creates a JSON data file that contains the response data and stores the file to a third container in Data Lake Storage.
1. The forms processing logic app receives the processed response data.
1. The forms processing logic app sends the processed data to Azure Cosmos DB, which saves the data in a database and in collections.
1. Power BI obtains the data from Azure Cosmos DB and provides insights and dashboards.
1. You can implement further processing as needed on the data that's in Azure Cosmos DB.

### Components

- [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview), a cloud-based service that enables you to build intelligent document processing solutions. It applies advanced machine learning to extract text, key-value pairs, tables, and structures from documents automatically and accurately. In this architecture, it is the intelligent document processing service utilized to extract information from PDF documents.
- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a serverless cloud service for creating and running automated workflows that integrate apps, data, services, and systems. In this architecture, it is used to as an orchestrator to coordinate the user input, document storage, document processing, storage of the results, and analysis of the processed documents.
- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless solution that makes it possible for you to write less code, maintain less infrastructure, and save on costs. In this architecture, it is the backend services to configure input to utilize [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview), and store the output.
- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is the foundation for building enterprise data lakes on Azure. In this architecture, it is used to store the raw PDF documents, machine learning results, and processed output.
- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL and relational database for modern app development. In this architecture, it is used to store the extracted insights from each PDF document. The information is utilized by [Power BI](/power-bi/fundamentals/power-bi-overview) to produce insights.
- [Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that work together so that you can turn your unrelated sources of data into coherent, visually immersive, and interactive insights. In this architecture, it is used to analyze the document processing results.

### Alternatives

- You can use [Microsoft Fabric](/fabric/) instead of [Power BI](/power-bi/fundamentals/power-bi-overview) to ingest the processed output to a Lakehouse and then do further analysis and processing of the output data.

## Scenario details

Forms processing is often a critical business function. Many companies still rely on manual processes that are costly, time consuming, and prone to error. Replacing manual processes reduces cost and risk and makes a company more agile.

This article describes an architecture that you can use to replace manual PDF forms processing or costly legacy systems that automate PDF forms processing. Azure AI Document Intelligence processes the PDF forms, Logic Apps provides the workflow, and Functions provides data processing capabilities.

For deployment information, see [Deploy this scenario](#deploy-this-scenario) in this article.

### Potential use cases

The solution that's described in this article can process many types of forms, including:

- Invoices and payment records
- Purchase orders
- Safety, incident, and compliance records
- Health screening forms
- Customer feedback forms
- Employee records
- Academic and research papers
- Documents with handwritten notes
- Custom documents from your domain

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture is intended as a starter architecture that you can quickly deploy and prototype to provide a business solution. If your prototype is a success, you can then extend and enhance the architecture, if necessary, to meet additional requirements.

This architecture utilizes scalable and resilient Azure infrastructure and technologies. For example, Azure Cosmos DB has built-in redundancy and global coverage that you can configure to meet your needs.

For the availability guarantees of the Azure services that this solution uses, see [Service-level agreements (SLAs) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The Outlook email account that's used in this architecture is a dedicated email account that receives PDF forms as attachments. It's good practice to limit the senders to trusted parties only and to prevent malicious actors from spamming the email account.

The implementation of this architecture that's described in [Deploy this scenario](#deploy-this-scenario) takes the following measures to increase security:

- The PowerShell and Bicep deployment scripts use Azure Key Vault to store sensitive information so that it isn't displayed on terminal screens or stored in deployment logs.
- Managed identities provide an automatically managed identity in Microsoft Entra ID for applications to use when they connect to resources that support Microsoft Entra authentication. The function app uses managed identities so that the code doesn't depend on individual principals and doesn't contain sensitive identity information.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and to improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Here are some guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture, and [scale out](/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start.
- The implementation of the architecture that's described in [Deploy this scenario](#deploy-this-scenario) deploys a starting solution that's suitable for proof of concept. The deployment scripts create a working architecture with minimal resource requirements. For example, the deployment scripts create a smallest serverless Linux host to run the function app.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale in an efficient manner to meet the demands that are placed on it by users. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This architecture uses services that have built-in scaling capabilities that you can use to improve performance efficiency. Here are some examples:

- You can host both Azure Logic Apps and Azure Functions in a serverless infrastructure. For more information, see [Azure serverless overview: Create cloud-based apps and solutions with Azure Logic Apps and Azure Functions](/azure/logic-apps/logic-apps-serverless-overview).
- You can configure Azure Cosmos DB to automatically scale its throughput. For more information, see [Provision autoscale throughput on a database or container in Azure Cosmos DB - API for NoSQL](/azure/cosmos-db/nosql/how-to-provision-autoscale-throughput).

## Deploy this scenario

You can deploy a rudimentary version of this architecture and use it as a starting point for deploying your own solution. The repository includes code, deployment scripts, and a deployment guide.

The sample receives the PDF forms, extracts the data fields, and saves the data in Azure Cosmos DB. Power BI visualizes the data. The design uses a modular, metadata-driven methodology. No form fields are hard-coded. It can process any PDF forms.

You can use the repository as is, without code modification, to process and visualize any single-page PDF forms such as safety forms, invoices, incident records, and many others. To use it, you only need to collect sample PDF forms, train a new model to learn the layout of the forms, and plug the model into the solution. You also need to redesign the Power BI report for your datasets so that it provides the insights that you want.

The implementation uses [Azure AI Document Intelligence Studio](https://formrecognizer.appliedai.azure.com/studio) to create custom models. The sample uses the field names that are saved in the machine learning model as a reference to process other forms. Only five sample forms are needed to create a custom-built machine learning model. You can merge as many as 100 custom-built models to create a composite machine learning model that can process a variety of forms.

### Deployment repository

The code for this sample is in [Azure PDF Form Processing Automation Solution](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator) GitHub repository. Follow the deployment guide in the repository.

### Deployment considerations

To process a new type of PDF form, you use sample PDF files to create a new machine learning model. When the model is ready, you plug the model ID into the solution.

This container name is configurable in the deployment scripts that you get from the GitHub repository.

The architecture doesn't address any high availability (HA) or disaster recovery (DR) requirements. If you want to extend and enhance the current architecture for production deployment, consider the following recommendations and best practices:

- Design the HA/DR architecture based on your requirements and use the built-in redundancy capabilities where applicable.
- Update the Bicep deployment code to create a computing environment that can handle your processing volumes.
- Update the Bicep deployment code to create more instances of the architecture components to satisfy your HA/DR requirements.
- Follow the guidelines in [Azure Storage redundancy](/azure/storage/common/storage-redundancy) when you design and provision storage.
- Follow the guidelines in [Business continuity and disaster recovery](/azure/logic-apps/business-continuity-disaster-recovery-guidance) when you design and provision the logic apps.
- Follow the guidelines in [Reliability in Azure Functions](/azure/reliability/reliability-functions?toc=%2Fazure%2Fazure-functions%2FTOC.json&tabs=azure-portal) when you design and provision the function app.
- Follow the guidelines in [Achieve high availability with Azure Cosmos DB](/azure/cosmos-db/high-availability) when you design and provision a database that was created by using Azure Cosmos DB.
- If you consider putting this system into production to process large volumes of PDF forms, you can modify the deployment scripts to create a Linux host that has more resources. To do so, modify the code inside [deploy-functionsapp.bicep](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator/blob/main/Deployment/1_deployment_scripts/deploy-functionsapp.bicep)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Gail Zhou](https://www.linkedin.com/in/gailzhou) | Principal Software Engineer

Other contributors:
- [Said Nikjou](https://www.linkedin.com/in/snikjou/) | Sr. Cloud Solution Architect
- [Nalini Chandhi](https://www.linkedin.com/in/nalinichandhi) | Principal Software Engineering Manager
- [Steve DeMarco](https://www.linkedin.com/in/steve-dem) | Principal Technical Specialist 
- [Travis Hilbert](https://www.linkedin.com/in/travis-hilbert-a3999980) | Software Engineer II 
- [DB Lee](https://www.linkedin.com/in/dongbum) | Principal Software Engineer
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135) | Sr. Software Engineer
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk) | Sr. Cloud Solution Architect
- [Echo Wang](https://www.linkedin.com/in/echo-wang-99205343) | Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Video: Azure PDF Form Processing Automation](https://www.youtube.com/watch?v=2zvoO1jc8CE).
- [Azure PDF Form Processing Automation Solution](https://github.com/microsoft/Azure-PDF-Form-Processing-Automation-Solution-Accelerator) GitHub repository
- [Azure Invoice Process Automation Solution](https://github.com/microsoft/Azure-Invoice-Process-Automation-Solution-Accelerator) GitHub repository
- [Tutorial: Create workflows that process emails by using Azure Logic Apps, Azure Functions, and Azure Storage](/azure/logic-apps/tutorial-process-email-attachments-workflow)

## Related resources

- [Custom document processing models on Azure](../../example-scenario/document-processing/build-deploy-custom-models.yml)
- [Index file content and metadata by using Azure AI Search](../../ai-ml/architecture/search-blob-metadata.yml)
- [Automate document identification, classification, and search by using Durable Functions](../../example-scenario/ai/automate-document-classification-durable-functions.yml)
