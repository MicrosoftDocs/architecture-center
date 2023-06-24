This article describes an architecture that you can use to replace the manual analysis of video footage with an automated and frequently more accurate machine learning process.

*The FFmpeg and Jupyter Notebook logos are trademarks of their respective companies. The use of these marks implies no endorsement.*

## Architecture

:::image type="content" source="media/analyze-video-content.png" alt-text="Diagram that shows an architecture for analyzing video content." lightbox="media/analyze-video-content.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/analyze-video-content.pptx) of this architecture.* 

### Workflow 

1.	A collection of video footage in MP4 format is uploaded to Azure Blob Storage. Ideally, the videos go into a "raw" container.
2.	A preconfigured pipeline in Azure Machine Learning recognizes that video files are uploaded to the container and initiates an inference cluster to start separating the video footage into frames.
3.	FFmpeg, an open-source tool, breaks down the video and extracts frames. You can configure how many frames per second are extracted, the extraction quality, and the image file format. The format can be JPG or PNG. 
4.	The inference cluster sends the images to Azure Data Lake Storage. 
5.	A preconfigured logic app that monitors Data Lake Storage detects that new images are being uploaded. It starts a workflow.
6.	The logic app calls a pretrained custom vision model to identify objects, features, or qualities in the images. Alternatively or additionally, it calls a computer vision (optical character recognition) model to identify textual information in the images. 
7. Results are received in JSON format. The logic app parses the results and creates key-value pairs. You can store the results in Azure dedicated SQL pools that Azure Synapse Analytics provisions.
7.	Power BI provides data visualization.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) provides object storage for cloud-native workloads and machine learning stores. In this architecture, it stores the uploaded video files. 
- [Azure Machine Learning](https://azure.microsoft.com/products/machine-learning) is an enterprise-grade machine learning service for the end-to-end machine learning lifecycle.
- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) provides massively scalable, enhanced-security, cost-effective cloud storage for high-performance analytics workloads.
- [Computer Vision](https://azure.microsoft.com/products/cognitive-services/computer-vision) is part of [Azure Cognitive Services](https://azure.microsoft.com/products/cognitive-services). It's used to retrieve information about each image.
- [Custom Vision](https://azure.microsoft.com/products/cognitive-services/custom-vision-service) enables you to customize and embed state-of-the-art computer vision image analysis for your specific domains.
- [Azure Logic Apps](https://azure.microsoft.com/products/logic-apps) automates workflows by connecting apps and data across environments. It provides a way to access and process data in real-time. 
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is a limitless analytics service that combines data integration, enterprise data warehousing, and big data analytics. 
- [Dedicated SQL pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) (formerly SQL DW) is a collection of analytics resources that are provisioned when you use Azure Synapse SQL.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to visualise your data.

### Alternatives

- [Azure Video Indexer](https://azure.microsoft.com/services/video-indexer) is a video analytics service that uses AI to extract actionable insights from stored videos. You can use it without any expertise in machine learning.
- [Azure Data Factory](https://azure.microsoft.com/products/data-factory) is a fully managed serverless data integration service that helps you construct ETL and ELT processes.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless platform as a service (PaaS) that runs single-task code without requiring new infrastructure. 
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a fully managed NoSQL database for modern app development.

## Scenario details

Many industries record video footage to detect the presence or absence of a particular object or entity or to classify objects or entities. Video monitoring and analyses are  traditionally performed manually. These processes are often monotonous and prone to errors, particularly for tasks that are difficult for the human eye. You can automate these processes by using AI and machine learning.

A video recording can be separated into individual frames so that various technologies can analyze the images. One such technology is *computer vision*: the capability of a computer to identify objects and entities on an image.

With computer vision, monitoring video footage becomes more accurate and automatized, standardized, and accurate. A computer vision model can be trained, and depending on the use case, you can frequently get results that are at least as good as those of the person who trained the model. By using [Machine Learning Operations (MLOps)](/azure/machine-learning/concept-model-management-and-deployment) to improve the model continuously, you can expect better results over time and react to changes in the video data over time.

### Potential use cases

This scenario is relevant for any business that analyzes videos. Here are some sample use cases:

- **Agriculture.** Monitor and analyze crops and soil conditions over time. By using drones or UAVs, farmers can record video footage for analysis.

- **Environmental sciences.** Analyze aquatic species to understand where they're located and how they evolve. Environmental researchers can navigate the shoreline by attaching underwater cameras to boats to record video footage. They can analyze the video footage to understand species migrations and how species populations change.
 
- **Traffic control.** Classify vehicles (SUVs, cars, trucks, motorcycles) and use the information to plan traffic control. CCTV can provide video footage in public locations. Most CCTV cameras record date and time, which can be easily retrieved via optical character recognition (OCR).

- **Quality assurance.** Monitor and analyze quality control in a manufacturing facility. Installing cameras on the production line allows you to train a computer vision model to detect anomalies.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

A reliable workload is both resilient and available. *Resiliency* is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after failure. *Availability* is a measure of whether your users can access your workload when they need to. 

For the availability guarantees of the Azure services in this solution, see these resources:

- [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5)
- [SLA for Azure Machine Learning](https://azure.microsoft.com/support/legal/sla/machine-learning-service/v1_0)
- [SLA for Azure Cognitive Services](https://azure.microsoft.com/support/legal/sla/cognitive-services/v1_1)
- [SLA for Logic Apps](https://azure.microsoft.com/support/legal/sla/logic-apps/v1_0)
- [SLA for Azure Synapse Analytics](https://azure.microsoft.com/support/legal/sla/synapse-analytics/v1_1)
- [SLA for Power BI](https://azure.microsoft.com/support/legal/sla/power-bi-embedded/v1_1)

### Security

Security assures against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Consider the following resources:

- [Identity management](/azure/architecture/framework/security/overview#identity-management)
- [Protect your infrastructure](/azure/architecture/framework/security/overview#protect-your-infrastructure)
- [Application security](/azure/architecture/framework/security/overview#application-security)
- [Data sovereignty and encryption](/azure/architecture/framework/security/overview#data-sovereignty-and-encryption)
- [Security resources](/azure/architecture/framework/security/overview#security-resources)

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Here are some guidelines for optimizing costs: 

- Use the pay-as-you-go strategy for your architecture, and [scale out](/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start. 
- Consider opportunity costs in your architecture and the balance between first-mover advantage versus fast follow. The [pricing calculator](https://azure.microsoft.com/pricing/calculator) is used to estimate the initial and operational costs. 
- Establish [policies](/azure/architecture/framework/cost/principles), [budgets, and controls](/azure/architecture/framework/cost/monitor-alert) that set cost limits for your solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Deployments need to be reliable and predictable. Here are some guidelines: 

- Automate deployments to reduce the chance of human error.
- Implement a fast, routine deployment process to avoid slowing the release of new features and bug fixes. 
- Quickly roll back or roll forward if an update causes problems.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to efficiently meet the demands placed on it by users. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Appropriate use of scaling and implementing PaaS offerings with built-in scaling are the main ways to achieve performance efficiency.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:
- [Oscar Shimabukuro Kiyan](https://www.linkedin.com/in/oscarshk) | Senior Cloud Solutions Architect – Data & AI

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b) | Senior Cloud Solutions Architect – Data & AI
- [Arash Mosharraf](https://www.linkedin.com/in/arashaga) | Senior Cloud Solutions Architect – Data & AI
- [Priyanshi Singh](https://www.linkedin.com/in/priyanshi-singh5) | Senior Cloud Solutions Architect – Data & AI
- [Julian Soh](https://www.linkedin.com/in/juliansoh) | Director Specialist – Data & AI

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Power BI embedded analytics?](/power-bi/developer/embedded/embedded-analytics-power-bi)
- [Business Process Accelerator](https://github.com/Azure/business-process-automation)

## Related resources

- [Image classification with convolutional neural networks (CNNs)](../../solution-ideas/articles/image-classification-with-convolutional-neural-networks.yml)
- [Image classification on Azure](../../solution-ideas/articles/image-classification-with-convolutional-neural-networks.yml)
- [MLOps framework to upscale machine learning lifecycle](../../example-scenario/mlops/mlops-technical-paper.yml)
