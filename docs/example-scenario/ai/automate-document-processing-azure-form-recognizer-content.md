Automating document processing and data extraction has become an integral part of organizations across all industry verticals. Artificial intelligence (AI) is one of the proven solutions in this process, although achieving 100 percent accuracy is a distant reality. But using AI for digitization instead of a purely manual process has reduced manual effort by around 80 to 90 percent.

Optical character recognition (OCR) is one of the initial technologies that was used to extract content from images and .pdf documents, which make up the majority of documents that organizations use. Mechanisms like key word search and regex matching extract relevant data from full text and then create structured output. But this approach has drawbacks. Extensive maintenance is needed to tweak the post extraction process to meet changing document formats.

This article outlines a scalable and secure solution for building an automated document processing pipeline. The solution begins by using Azure Form Recognizer for the structured extraction of data. Natural Language Process Models or custom models then enrich the data.

## Potential use cases

The following tasks can benefit from this solution:

- Approving expense reports
- Processing invoices, receipts, or bills for insurance claims and financial audits
- Processing claims that include invoices, discharge summaries, and other documents
- Automating statement of work (SoW) approvals
- Automating ID extraction for verification purposes, as with passports or driver licenses
- Automating the process of entering business card data into visitor management systems
- Identifying purchase patterns and duplicate financial documents for fraud detection

## Architecture

:::image type="content" source="./media/automate-document-processing-azure-form-recognizer-architecture.png" alt-text="Architecture diagram that shows how to deploy A K S with Astra Control Service for data protection and mobility." border="false" lightbox="./media/automate-document-processing-azure-form-recognizer-architecture-lightbox.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

Add intro statement.

#### Data ingestion and extraction

1. Documents are ingested through a browser at the front end of a web application. The documents contain images or are in .pdf format. Azure App Service hosts a back-end application. The solution routes the documents to that application through Azure Application Gateway. This load balancer runs with the optional addition Azure Web Application Firewall, which helps to protect the application from common attacks and vulnerabilities.

1. The back-end application posts a request to a Form Recognizer REST API endpoint that uses one of these models:

   - Layout
   - Invoice
   - Receipt
   - ID document
   - Business card
   - General document, which is in preview

   The response from Form Recognizer contains raw OCR data and structured extractions.

1. The data enters Azure Cosmos DB for downstream application consumption. The App Service back-end application can also return the results to the front-end browser. Alternatively, the app can evaluate the extraction quality by using confidence values that Form Recognizer assigns to the extracted data. If the quality is below a specified threshold, the app flags the data. The extraction then undergoes manual verification before entering the database or returning to the front end.

1. Other sources provide images, .pdf files, and other documents. Sources include email attachments and File Transfer Protocol (FTP) servers. Tools like Azure Data Factory and Az Copy transfer these files to Azure Blob Storage. Azure Logic Apps offers pipelines for automatically extracting attachments from emails.

1. When a document enters Azure Blob Storage, an Azure function is triggered. The function:

   - Posts a request to the relevant Azure Form Recognizer pre-built endpoint.
   - Receives the response.
   - Evaluates the extraction quality.

1. The extracted data enters Azure Cosmos DB.

#### Data enrichment

The pipeline that's used for data enrichment depends on the use case.

1. Data enrichment can include the following natural language processing (NLP) capabilities:

   - Named entity recognition (NER)
   - The extraction of personally identifiable information (PII), key phrases, health information, and other domain-dependent entities

   To enrich the data, the web app:

   - Pulls the extracted data from Cosmos DB.
   - Posts requests to a feature of the Azure Cognitive Services for Language API:

     - [NER][What is Named Entity Recognition (NER) in Azure Cognitive Service for Language?]
     - [PII][What is Personally Identifiable Information (PII) detection in Azure Cognitive Service for Language?]
     - [Key phrase extraction][What is key phrase extraction in Azure Cognitive Service for Language?]
     - [Text analytics for health][What is Text Analytics for health in Azure Cognitive Service for Language?]
     - [Custom NER][What is Custom Named Entity Recognition (NER) (preview)?], which is in preview
     - [Sentiment analysis][Sentiment analysis]
     - [Opinion mining][Opinion mining]

   - Receives responses from the Azure Cognitive Service for Language API.

1. Custom models perform fraud detection, risk analysis, and other types of analysis on the data:

   - Azure Machine Learning (AML) services trains and deploys the custom models.
   - The extracted data is retrieved from Cosmos DB.
   - The models derive insights from the data and score it.

   These possibilities exist for inferencing:

   - Real-time processes. The models are deployed as a web service in Azure Kubernetes Service (AKS).
   - Batch inferencing in an Azure Virtual Machine.

1. The enriched data enters Azure Cosmos DB.

#### Analytics and visualizations

1. Applications use the raw OCR, structured data from Form Recognizer endpoints and the enriched data from NLP: 

   - Power BI displays the data and presents reports on it.
   - The data functions as a source for Azure Cognitive Search.
   - Other applications consume the data.



### Components

- [Azure App Service][App Service] is a platform as a service (PaaS) offering on Azure. You can use App Service to host web applications that you can scale in or scale out manually or automatically. The service supports multiple languages and frameworks like ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP, and Python.

- [Azure Application Gateway][What is Azure Application Gateway?] is a layer-7 (application layer) load balancer that manages traffic to web applications. You can run Application Gateway with [Azure Web Application Firewall][What is Azure Web Application Firewall on Azure Application Gateway?] to help protect web applications from common exploits and vulnerabilities.



### Alternatives



## Considerations

Keep these points in mind when you use this solution.

### Managing


### Monitoring


### Scalability


### Availability

Azure NetApp Files is highly available by design. For this service's availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].


### Performance


## Deploy this scenario


## Pricing

Use the [Azure Pricing calculator][Azure Pricing calculator] to estimate the cost of the following components:



## Next steps



## Related resources




[App Service]: https://azure.microsoft.com/en-us/services/app-service/
[Opinion mining]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/overview#opinion-mining
[Sentiment analysis]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/overview#sentiment-analysis
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1902078-automate-document-processing-azure-form-recognizer-architecture.vsdx
[What is Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/application-gateway/overview
[What is Azure Web Application Firewall on Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview
[What is Custom Named Entity Recognition (NER) (preview)?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/custom-named-entity-recognition/overview
[What is key phrase extraction in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/key-phrase-extraction/overview
[What is Named Entity Recognition (NER) in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/named-entity-recognition/overview
[What is Personally Identifiable Information (PII) detection in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/personally-identifiable-information/overview
[What is Text Analytics for health in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/text-analytics-for-health/overview?tabs=ner


