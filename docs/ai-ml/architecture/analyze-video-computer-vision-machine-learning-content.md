This article describes an architecture that you can use to replace the manual analysis of video footage with an automated, and frequently more accurate, machine learning process.

## Architecture

:::image type="content" source="_images/analyze-video-content.png" alt-text="Diagram that shows an architecture for automated video analysis by using video frames and custom code." lightbox="_images/analyze-video-content.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/analyze-video-content.pptx) of this architecture.*
*The FFmpeg and Jupyter Notebook logos are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

### Workflow

1. A collection of video footage, in MP4 format, is uploaded to Azure Blob Storage. Ideally, the videos go into a "raw" container.
2. A preconfigured pipeline in Azure Machine Learning recognizes that video files are uploaded to the container and initiates an inference cluster to start separating the video footage into frames.
3. FFmpeg, an open-source tool, breaks down the video and extracts frames. You can configure how many frames per second are extracted, the quality of the extraction, and the format of the image file. The format can be JPG or PNG.
4. The inference cluster sends the images to Azure Data Lake Storage.
5. A preconfigured logic app that monitors Data Lake Storage detects that new images are being uploaded. It starts a workflow.
6. The logic app calls a pretrained custom vision model to identify objects, features, or qualities in the images. Alternatively or additionally, it calls a computer vision (optical character recognition (OCR)) model to identify textual information in the images.
7. Results are received in JSON format. The logic app parses the results and creates key-value pairs. You can store the results in Azure dedicated SQL pools that are provisioned by Azure Synapse Analytics.
8. Power BI provides data visualization.

### Components

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) provides object storage for cloud-native workloads and machine learning data stores. In this architecture, it stores the uploaded raw video footage that serves as the input for the automated video analysis pipeline.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is an enterprise-grade service that supports the end-to-end machine learning life cycle. In this architecture, it manages the inference cluster and orchestrates the process of breaking down videos into frames for further analysis.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable, secure, and cost-effective cloud storage solution for analytics workloads. In this architecture, it stores the extracted video frames for downstream image analysis and processing.

- [Computer Vision](/azure/ai-services/computer-vision/overview) is part of [Azure AI services](/azure/ai-services/what-are-ai-services). It provides tools to extract information from images. In this architecture, it analyzes the extracted frames and identifies objects and features. It can also retrieve text via OCR.

- [Custom Vision](/azure/ai-services/custom-vision-service/overview) enables you to customize and embed state-of-the-art computer vision image analysis for your specific domains. In this architecture, it identifies domain-specific objects or qualities in the extracted video frames.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) automates workflows by connecting apps and data across environments. It provides a way to access and process data in real time. In this architecture, it monitors storage locations, triggers analysis workflows, processes results, and coordinates the movement and transformation of data.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that work together to provide visualizations of your data. In this architecture, Power BI provides dashboards and reports that visualize the results of the automated video analysis to enable insights and decision-making.

### Alternatives

If there is no need to call a pre-trained Object Detection Custom Model, we can use the following architecture which relies on Azure AI Vision Video Retrieval. Using this service will omit the decomposition of video into frames and the use of custom code to parse through the ingestion process. This approach serves a more straightforward path if your use case relies on detecting common objects or entities in a video.

:::image type="content" source="_images/analyze-video-content-video-retrieval-api.png" alt-text="Diagram that shows an architecture for automated video analysis by using the Video Retrieval API." lightbox="_images/analyze-video-content-video-retrieval-api.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/analyze-video-content-2.pptx) of this architecture.*

#### Alternative Workflow

1. A collection of video footage, in MP4 format, is uploaded to Azure Blob Storage.
2. A preconfigured logic app monitors Blob Storage detects that new videos are being uploaded and starts a workflow.
3. The logic app calls the Azure AI Vision Video Retrieval API to create an index.
4. The logic app calls the Azure AI Vision Video Retrieval API to add video documents to the index.
5. A preconfigured logic app monitors the ingestion to check when the indexing is complete.
6. The logic app calls the Video Retrieval API to search with natural language, identify objects, features, or qualities in the images.
7. Results are received in JSON format. The logic app parses the results and creates key-value pairs. You can store the results in SQL Database in Fabric.
8. Power BI provides data visualization.

### Alternative Components 
- [Microsoft Fabric](https://www.microsoft.com/microsoft-fabric) is an end-to-end unified analytics platform to streamline data integration.  It is designed to simplify the process of managing and analyzing data across various domains by providing a comprehensive suite of tools and services within a single platform. It is used in this architecture as data ingestion platform to pull the JSON objects and pass it on to the SQL database in Fabric.
- [SQL database in Fabric](/fabric/database/sql/overview) is a simple, autonomous, and secure SQL database service optimized for AI. It is used in this architecture to store information about the videos retrieved from the Azure Video Retrieval API.
- [Azure AI Vision](/azure/ai-services/computer-vision/overview) is a service that provides advance image and video analysis capabilities without requiring machine learning expertise. The [Video Retrieval API](/azure/ai-services/computer-vision/how-to/video-retrieval) is used in this architecture to retrieve information directly from the video.

## Scenario details

Many industries record video footage to detect the presence or absence of a particular object or entity or to classify objects or entities. Video monitoring and analyses are traditionally performed manually. These processes are often monotonous and prone to errors, particularly for tasks that are difficult for the human eye. You can automate these processes by using AI and machine learning.

A video recording can be separated into individual frames so that various technologies can analyze the images. One such technology is *computer vision*: the capability of a computer to identify objects and entities on an image.

With computer vision, monitoring video footage becomes automatized, standardized, and potentially more accurate. A computer vision model can be trained, and, depending on the use case, you can frequently get results that are at least as good as those of the person who trained the model. By using [Machine Learning Operations (MLOps)](/azure/machine-learning/concept-model-management-and-deployment) to improve the model continuously, you can expect better results over time, and react to changes in the video data over time.

### Potential use cases

This scenario is relevant for any business that analyzes videos. Here are some sample use cases:

- **Agriculture.** Monitor and analyze crops and soil conditions over time. By using drones or UAVs, farmers can record video footage for analysis.

- **Environmental sciences.** Analyze aquatic species to understand where they're located and how they evolve. By attaching underwater cameras to boats, environmental researchers can navigate the shoreline to record video footage. They can analyze the video footage to understand species migrations and how species populations change over time.

- **Traffic control.** Classify vehicles into categories (SUV, car, truck, motorcycle), and use the information to plan traffic control. Video footage can be provided by CCTV in public locations. Most CCTV cameras record date and time, which can be easily retrieved via optical character recognition (OCR).

- **Quality assurance.** Monitor and analyze quality control in a manufacturing facility. By installing cameras on the production line, you can train a computer vision model to detect anomalies.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

A reliable workload is one that's both resilient and available. *Resiliency* is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. *Availability* is a measure of whether your users can access your workload when they need to.

For the availability guarantees of the Azure services in this solution, see these resources:

- [Service-level agreement (SLA) for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5)
- [SLA for Azure Machine Learning](https://azure.microsoft.com/support/legal/sla/machine-learning-service/v1_0)
- [SLA for Azure AI services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1)
- [SLA for Logic Apps](https://azure.microsoft.com/support/legal/sla/logic-apps/v1_0)
- [SLA for Azure Synapse Analytics](https://azure.microsoft.com/support/legal/sla/synapse-analytics/v1_1)
- [SLA for Power BI](https://azure.microsoft.com/support/legal/sla/power-bi-embedded/v1_1)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following resources:

- [Identity management](/azure/architecture/framework/security/overview#identity-management)
- [Protect your infrastructure](/azure/architecture/framework/security/overview#protect-your-infrastructure)
- [Application security](/azure/architecture/framework/security/overview#application-security)
- [Data sovereignty and encryption](/azure/architecture/framework/security/overview#data-sovereignty-and-encryption)
- [Security resources](/azure/architecture/framework/security/overview#security-resources)

### Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Here are some guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture, and [scale out](/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start.
- Consider opportunity costs in your architecture, and the balance between first-mover advantage versus fast follow. Use the [pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the initial cost and operational costs.
- Establish [policies](/azure/architecture/framework/cost/principles), [budgets, and controls](/azure/architecture/framework/cost/monitor-alert) that set cost limits for your solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Deployments need to be reliable and predictable. Here are some guidelines:

- Automate deployments to reduce the chance of human error.
- Implement a fast, routine deployment process to avoid slowing down the release of new features and bug fixes.
- Quickly roll back or roll forward if an update causes problems.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Appropriate use of scaling and the implementation of PaaS offerings that have built-in scaling are the main ways to achieve performance efficiency.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Oscar Shimabukuro Kiyan](https://www.linkedin.com/in/oscarshk) | Senior Cloud Solutions Architect – Data & AI
- [Han Wang](https://www.linkedin.com/in/han-hongrun-wang-577187106/) | Cloud Solutions Architect – Data & AI

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure AI services?](/azure/ai-services/what-are-ai-services)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Power BI Embedded analytics?](/power-bi/developer/embedded/embedded-analytics-power-bi)
- See the [Business process automation solution](https://github.com/Azure/business-process-automation) on GitHub
