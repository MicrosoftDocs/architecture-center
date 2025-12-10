This article describes an architecture that replaces manual video analysis with an automated machine learning process. The automated process often produces more accurate results.

## Architecture

:::image type="complex" border="false" source="_images/analyze-video-content.svg" alt-text="Diagram that shows an architecture for automated video analysis by using video frames and custom code." lightbox="_images/analyze-video-content.svg":::
   The image is a flow diagram divided into four labeled sections: Ingest, Transform, Enrich and serve, and Visualize. In the Ingest section, there's an icon that represents video files, with an arrow that points to a machine learning storage account icon. In the Transform section, arrows connect the storage account to a box that has icons for Jupyter Notebook, Azure Machine Learning, and an inference cluster. An arrow labeled Run points from this box to a picture files icon, and then to a Data Lake Storage icon. An arrow points from Data Lake Storage to a box that has Azure Logic Apps, and arrows point to and from Custom Vision API and Computer Vision API icons. An arrow labeled Parsing JSON points from Logic Apps to a Microsoft Fabric icon. In the Visualize section, an arrow points from Fabric to a Power BI icon.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/analyze-video-content.pptx) of this architecture.*

*The FFmpeg and Jupyter Notebook logos are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

### Workflow

The following workflow corresponds to the previous diagram:

1. A collection of MP4 video footage is uploaded to Blob Storage, which serves as the initial storage location. The files are then processed in a machine learning storage account before frame extraction. Ideally, the videos go into a raw container.

1. A preconfigured pipeline in Machine Learning detects that video files are uploaded to the container and initiates an inference cluster to start separating the video footage into frames.

1. FFmpeg, which is an open-source tool, decodes the video and extracts individual frames as image files. You can set up how many frames per second are extracted, the quality of the extraction, and the format of the image file. The format can be JPG or PNG.

1. The inference cluster sends the images to Azure Data Lake Storage.

1. A preconfigured logic app that monitors Data Lake Storage detects that new images are being uploaded. It starts a workflow.

1. The logic app calls a pretrained Azure AI Custom Vision model to identify objects, features, or qualities in the images. It might also call a computer vision model that uses optical character recognition (OCR) to identify textual information in the images.

1. Results arrive in JSON format. The logic app parses the results to create key-value pairs. You can store those pairs in Fabric Data Warehouse, which is a managed analytical database that supports atomicity, consistency, isolation, and durability (ACID) transactions. It uses the open Delta Parquet format and integrates natively with OneLake.

1. Power BI provides data visualization.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud-based solution designed to store objects for cloud-native applications and machine learning workloads. In this architecture, it stores the uploaded raw video footage that serves as the input for the automated video analysis pipeline.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is an enterprise-grade service that supports the end-to-end machine learning life cycle. In this architecture, it manages the inference cluster and orchestrates the process of breaking down videos into frames for further analysis.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable, secure, and cost-effective cloud storage solution for analytics workloads. In this architecture, it stores the extracted video frames for downstream image analysis and processing.

- [Azure AI Vision](/azure/ai-services/computer-vision/overview) is part of [Azure AI services](/azure/ai-services/what-are-ai-services). It provides tools to extract information from images. In this architecture, it analyzes the extracted frames and identifies objects and features. It can also retrieve text via OCR.

- [Custom Vision](/azure/ai-services/custom-vision-service/overview) is a cloud-based AI service that you can use to customize and embed advanced computer vision image analysis for your specific domains. In this architecture, it identifies domain-specific objects or qualities in the extracted video frames.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud-based service that automates workflows by connecting apps and data across environments. It provides a way to access and process data in real time. In this architecture, it monitors storage locations, initiates analysis workflows, processes results, and coordinates the movement and transformation of data.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an end‑to‑end unified analytics platform that streamlines integration of data workflows across data engineering, data integration, warehousing, real‑time analytics, and business intelligence (BI). In this architecture, after Logic Apps parses the JSON results, the data is stored and analyzed in [Data Warehouse](/fabric/data-warehouse) for governed analytics before visualization in Power BI.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that work together to provide visualizations of your data. In this architecture, Power BI provides dashboards and reports that visualize the results of the automated video analysis to enable insights and decision-making.

### Alternatives

If you don't need to call a pretrained object detection custom model, use the following architecture that relies on Microsoft Azure AI Video Indexer. This service removes the decomposition of video into frames and the use of custom code to parse through the ingestion process. This approach is more direct if your use case involves detecting common objects or entities in a video.

:::image type="complex" border="false" source="_images/analyze-video-content-video-retrieval-api.svg" alt-text="Diagram that shows an architecture for automated video analysis by using Video Indexer." lightbox="_images/analyze-video-content-video-retrieval-api.svg":::
  The diagram has four sections labeled Ingest, Index, Search and detection with natural language, and Visualize. In the Ingest section, a video files icon points to Data Lake Storage, followed by an arrow to Logic Apps. In the Index section, Logic Apps connects to Video Indexer with arrows for creating an index and adding video to the index. Video Indexer connects to Logic Apps, which resides in a subsection within the Search and detection with natural language section. Inside this subsection, arrows labeled Get and Post go from Logic Apps to the Video Indexer API. An arrow points from the Logic Apps subsection to Fabric via a parsing JSON arrow. In the Visualize section, an arrow points from Fabric to Power BI.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/analyze-video-content-2.pptx) of this architecture.*

#### Alternative workflow

The following workflow corresponds to the previous diagram:

1. A collection of MP4 video footage is uploaded to Blob Storage, which is used for video upload before indexing and further processing in Data Lake Storage.

1. A preconfigured logic app monitors Blob Storage, detects that new videos are being uploaded, and starts a workflow.

1. The logic app calls the Video Indexer API to create an index.

1. The logic app calls the Video Indexer API to add video documents to the index.

1. A preconfigured logic app monitors the ingestion to check when the indexing is complete.

1. The logic app uses the Video Indexer API to run natural language searches and detect objects, features, or attributes in images.

1. Results are received in JSON format. The logic app parses the results and creates key-value pairs. You can store the results in SQL database in Fabric.

1. Power BI provides data visualization.

### Alternative components

- [SQL database in Fabric](/fabric/database/sql/overview) is a managed SQL database service designed to support AI-driven workloads securely and efficiently. In this architecture, it stores information about the videos retrieved from the Video Indexer API.

- [Video Indexer](/azure/azure-video-indexer/video-indexer-overview) is a service that enables direct analysis of video files for object, feature, and attribute detection. It supports natural language search over indexed video content. In this architecture, Video Indexer lets you retrieve structured information from videos without manual frame extraction or custom code.

## Scenario details

Many industries record video footage to detect the presence or absence of a specific object or entity or to classify objects or entities. Video monitoring and analyses are typically performed manually. These processes are often monotonous and prone to errors, especially for tasks that are difficult for the human eye. You can automate these processes by using AI and machine learning.

A video recording can be separated into individual frames so that different technologies can analyze the images. An example of this technology is *computer vision*, which is the capability of a computer to identify objects and entities in an image.

With computer vision, monitoring video footage becomes automatized, standardized, and potentially more accurate. A computer vision model can be trained. Depending on the use case, you can frequently get results that are at least as good as the results of the person who trained the model. You can achieve better results and adapt to changes in video data over time by using [machine learning operations](/azure/machine-learning/concept-model-management-and-deployment) to continuously improve the model.

### Potential use cases

This scenario is relevant for any business that analyzes videos. Consider the following sample use cases:

- **Agriculture:** Monitor and analyze crops and soil conditions over time. Farmers can record video footage for analysis by using drones or unmanned aerial vehicles (UAVs).

- **Environmental sciences:** Analyze aquatic species to learn where they're located and how they evolve. Environmental researchers can navigate the shoreline and record video footage by attaching underwater cameras to boats. They can analyze the video footage to understand species migrations and how species populations change over time.

- **Traffic control:** Classify vehicles into categories, like SUV, car, truck, and motorcycle. Use that information to plan traffic control. Closed-circuit television (CCTV) in public locations can provide video footage. Most CCTV cameras record the date and time, which can be retrieved via OCR.

- **Quality assurance:** Monitor and analyze quality control in a manufacturing facility. By installing cameras on the production line, you can train a computer vision model to detect anomalies.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

A reliable workload is resilient and available. *Resiliency* is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. *Availability* is a measure of whether your users can access your workload when they need to.

For the availability guarantees of the Azure services in this solution, see [Service-level agreements (SLAs) for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Consider the following guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture, and [scale out](/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start.

- Consider opportunity costs in your architecture and the trade-offs between being a first-mover and adopting a fast-follow strategy. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the initial cost and operational costs.

- Establish [policies](/azure/architecture/framework/cost/principles), [budgets, and controls](/azure/architecture/framework/cost/monitor-alert) that set cost limits for your solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Deployments need to be reliable and predictable. Consider the following guidelines:

- Automate deployments to reduce the chance of human error.

- Implement a fast, repeatable deployment process to ensure timely release of new features and bug fixes.

- Roll back or roll forward quickly if an update causes problems.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The appropriate use of scaling and the implementation of platform as a service (PaaS) offerings that have built-in scaling are the main ways to achieve performance efficiency.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Oscar Shimabukuro Kiyan](https://www.linkedin.com/in/oscarshk) | Senior Cloud Solutions Architect – Data & AI
- [Han Wang](https://www.linkedin.com/in/han-hongrun-wang-577187106/) | Cloud Solutions Architect – Data & AI

Other contributors:

- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Power BI embedded analytics?](/power-bi/developer/embedded/embedded-analytics-power-bi)
