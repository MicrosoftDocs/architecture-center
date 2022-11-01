Many industries record video footage to gain insights from their operations. Video monitoring and analyses are  traditionally performed by a person, using their best judgement. This is often monotonous and prone to errors, particularly for tasks difficult for the human eye.

In practicality, a video is just a collection of frames which are played continuously at a defined speed (e.g. 60 frames per second), wherein the video can be decomposed into individual frames to leverage different technologies for analyzing the images. One of such technologies is called Computer Vision, the capability a machine uses in order to be able to see and identify objects and entities on an image. 

By relying on Computer Vision, the task of monitoring video footage becomes automatized, standardized and hence more accurate. Depending on the specific use case, a Computer Vision model can be trained, and we can expect results that are at least as good as those achieved by the person who trained the model. By implementing [MLOps](/azure/machine-learning/concept-model-management-and-deployment) and improving the model continuously, we can expect better results and react to changes in the video data over time.

## Architecture

diagram 

link 

### Workflow 

1.	The first step consists of uploading a collection of video footage (in .mp4 format) to Azure Blob Storage. Ideally, the videos should go into a “raw” container.
2.	A pre-configured pipeline on Azure Machine Learning Studio will recognize that video files are uploaded to the specific container and will kick-off an inference cluster to start breaking down the video footage into frames. 
3.	FFMPEG is an open-source tool that handles video files and can perform several tasks. One specific task is breaking down a video and extracting frames. FFMPEG can be configured to decide how many frames per second are extracted, the quality of the extraction, as well as the format of the image file. 
4.	The inference cluster runs FFMPEG and breaks the video into images (in a .jpg or .png format) and sends the images to Azure Data Lake Storage gen2 (ADLS gen2). 
5.	A pre-configured Logic App monitors ADLS gen2 and detects that new images are being uploaded, hence being triggered and start to run a workflow.
6.	A pre-trained custom vision model is called to identify objects, features, or qualities in the images. Alternately or additionally, a computer vision (OCR) model is called to identify textual information in the images.Results are received in JSON format and the logic app parses them and creates key-value pairs.The results can be stored in Azure Dedicated SQL pools provisioned via Synapse.
7.	Power BI is used for visualization.

### Components

- [Azure Blob Storage]() stores all the video files that are uploaded. When creating an Azure Machine Learning service, it asks for a storage account to be used as a default datastore for the ML workspace. We can create the Azure Storage resource or use an existing one.
- [Azure Machine Learning]() is an enterprise-grade machine learning (ML) service for the end-to-end ML lifecycle.
- [Azure Data Lake Storage]() provides massively scalable, high-security, cost-effective cloud storage for high-performance analytics workloads.
- [Computer Vision API]() is part of the Cognitive Services suite and is used to retrieve information about each image.
- [Custom Vision Service]() enables you to customize and embed state-of-the-art computer vision image analysis for specific domains. 
- [Azure Logic Apps]() automates workflows by connecting apps and data across clouds. This service provides a way to securely access and process data in real time. Its serverless solutions take care of building, hosting, scaling, managing, maintaining, and monitoring apps.
- [Azure Synapse Analytics]() is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. Azure Synapse contains the same Data Integration engine and experiences as Azure Data Factory, so you can create at-scale ETL pipelines without leaving Azure Synapse.
- [Dedicated SQL pool]() (formerly SQL DW) represents a collection of analytic resources that are provisioned when using Synapse SQL. The size of a dedicated SQL pool (formerly SQL DW) is determined by Data Warehousing Units (DWU).
- [Power BI]() is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.

### Alternatives 

- [Azure Video Indexer]() is a video analytics service that uses AI to extract actionable insights from stored videos. Enhance ad insertion, digital asset management, and media libraries by analyzing audio and video content—no machine learning expertise necessary.
- [Data Factory]() is a fully managed, serverless data integration service that helps you construct ETL and ELT processes.
- [Azure Functions]() is a serverless platform as a service (PaaS) in Azure that runs small, single-task code without requiring new infrastructure to be spun up. 
- [Azure Cosmos DB]() is a fully managed NoSQL database for modern app development. Single-digit millisecond response times, automatic and instant scalability, guarantee speed at any scale. As a fully managed service, Azure Cosmos DB takes database administration off your hands with automatic management, updates and patching.

## Scenario details

This scenario is relevant for businesses that need to analyze videos.

Several industries need to analyze video footage to detect the presence or absence of a particular object or entity or to classify different objects or entities. Traditionally, companies would analyze and monitor videos in a manual fashion. This process can be automated by using Artificial Intelligence and Machine Learning. 

### Potential use cases

This solution is ideal for the following sample use cases:

- **Agriculture:** Monitor and analyze the presence of crops and soil conditions over a period of time. With the help of drones or UAVs, farmers can record video footage from time to time on a specific lot which can later be analyzed. 

- **Environmental sciences:** Monitor and analyze underwater species by understanding where they are located and how they evolve. By attaching an underwater camera to a boat, environmental researchers can navigate the shoreline to record video footage of underwater species. Afterwards, they can analyze the video footage and understand how the presence of different underwater species grow over a period of time and their migration.
 
- **Traffic control:** Monitor and analyze different vehicles by being able to classify vehicles into different categories (e.g. SUV, car, truck, motorbike), and use the information to plan traffic control. Video footage comes from CCTV in public locations. Most CCTV cameras record date and time which can be easily retrievable with the OCR capabilities.

- **Quality assurance:** Monitor and analyze quality control on your manufacturing facility. By installing a small camera on the production line, we can train a computer vision model to detect anomalies with computer vision.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

A reliable workload is one that is both resilient and available. [Resiliency] is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is whether your users can access your workload when they need to. 
For the availability guarantees of the Azure services in the solution, see the following resources:

- SLA for Storage Accounts
- SLA for Azure Machine Learning
- SLA for Azure Cognitive Services
- SLA for Logic Apps
- SLA for Azure Synapse Analytics
- SLA for Power BI

### Security

For more information, reference Overview of the security pillar.

Consider the following broad security areas:

- [Identity management
- [Protect your infrastructure
- [Application security
- [Data sovereignty and encryption
- [Security resources

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. Use the pay-as-you-go strategy for your architecture, and invest in [scaling out], rather than delivering a large investment-first version. Consider opportunity costs in your architecture, and the balance between first mover advantage versus fast follow. Use the [cost calculators]() to estimate the initial cost and operational costs. Finally, establish [policies, budgets, and controls]() that set cost limits for your solution.

### Operational excellence

Operational excellence covers the operations and processes that keep an application running in production. Deployments must be reliable and predictable. Automate deployments to reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must quickly roll back or roll forward if an update has problems.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. The main ways to achieve performance efficiency include using scaling appropriately and implementing PaaS offerings that have scaling built in.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:
- [Oscar Shimabukuro Kiyan | Senior Cloud Solutions Architect – Data & AI

Other contributors:

- Mick Alberts 
- [Brandon Cowen | Senior Cloud Solutions Architect – Data & AI
- [Arash Mosharraf | Senior Cloud Solutions Architect – Data & AI
- [Priyanshi Singh | Senior Cloud Solutions Architect – Data & AI
- [Julian Soh | Director Specialist – Data & AI

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Before deploying the above architecture, make sure to read the following product documentation:

- Introduction to Azure Storage
- What is Azure Machine Learning?
- What are Azure Cognitive Services?
- What is Azure Logic Apps?
- What is Azure Synapse Analytics?
- What is Power BI embedded Analytics?

## Related resources
- Image classification with convolutional neural networks (CNNs)
- Image classification on Azure
- Business Process Accelerator
