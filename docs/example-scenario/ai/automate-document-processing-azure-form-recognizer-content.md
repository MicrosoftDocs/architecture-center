
Automating document processing and data extraction has become an integral part of organizations across all industry verticals. Artificial Intelligence (AI) is one of the proven solutions in this process, although achieving 100 percent accuracy is a distant reality. But using AI for digitization instead of a purely manual process has reduced manual effort by around 80 to 90 percent.

Optical character recognition (OCR) is one of the initial technologies that was used to extract content from images and .pdf documents, which make up the majority of documents that organizations use. Mechanisms like key word search and regex matching extracted relevant data from full text and then created structured output. But this approach has drawbacks. Extensive maintenance is needed to tweak the post extraction process to meet changing document formats.

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

:::image type="content" source="./media/data-protection-kubernetes-astra-azure-netapp-files-architecture.png" alt-text="Architecture diagram that shows how to deploy A K S with Astra Control Service for data protection and mobility." border="false" lightbox="./media/data-protection-kubernetes-astra-azure-netapp-files-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

Add intro statement.

#### Data ingestion and extraction

1. Documents are ingested through a browser at the front end of a web application. The documents contain images or are in .pdf format. Azure App Service hosts a back-end application. The solution routes the documents to that application through Azure Application Gateway. This load balancer runs with the optional addition Azure Web Application Firewall, which helps to protect the application from common attacks and vulnerabilities.

1. The backend application posts a request to one of these Azure Form Recognizer models:

   - Layout
   - Invoice
   - Receipt
   - ID document
   - Business card
   - General document, which is in preview

   The response from Form Recognizer contains raw OCR data and structured extractions that are based on the Form Recognizer model.

1. The data enters Azure Cosmos DB for downstream application consumption. The App Service back-end application can also return the results to the front-end browser. Alternatively, the raw json data can first be processed by using the confidence score [or assigned a confidence score] to evaluate the extraction quality. If the quality is below a specified threshold, the solution flags the data. Then extraction then undergoes manual verification before entering the database or returning to the front end.


### Components



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

