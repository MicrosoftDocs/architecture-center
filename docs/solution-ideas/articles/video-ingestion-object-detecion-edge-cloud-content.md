**Video ingestion and object detection on the edge and in the cloud**

This scenario describes how secured location personnel can organise regular monitoring of the perimeter of the location. It includes a robot patrolling the premises with a live streaming camera, a system running locally on Azure Stack Edge to ingest and process video stream and Azure Cloud Cognitive Services that are performing object detection.

**Architecture**

![](./media/image1.png){width="6.405092957130359in" height="3.6028641732283466in"}

*Download a \[Visio file\](https://arch-center.azureedge.net/\[filename\].vsdx) of this architecture.*

**Workflow**

Here is how the system processes the incoming data:

1.  A camera is installed on the robot, which streams video in real time using Real Time Streaming Protocol (\[RTSP\](https://en.wikipedia.org/wiki/Real_Time_Streaming_Protocol)).

2.  A container running within the Kubernetes cluster on Azure Stack Edge is reading the incoming stream and splits video into separate images. An open-source software tool called \[ffmpeg\](<https://ffmpeg.org/about.html>) is used to ingest and process the video stream.

3.  Produced images are stored in the local Stack Edge Storage Account.

4.  Each time a new key frame is saved into the Storage Account, Computer Vision container picks it up. See Scenario Details for details on the separation of logic into multiple containers.

5.  Upon loading key frame from the Storage Container, Computer Vision container sends it to Azure Cognitive Services in the cloud. We are using the Computer Vision service which allows for object detection via image analysis.

6.  The result of image analysis (detected objects and confidence) is sent to the Anomaly Detection container.

7.  Anomaly Detection container stores results of image analysis and anomaly detection in the local Stack Edge Azure SQL Database for future referencing. Utilising local instance of the database improves access time which helps to minimize delays in data access.

8.  In the last step the service performs data processing to detect any security anomalies in the incoming real time video stream. If anomaly is detected, an alert is raised for the security personnel via front-end UI.

**Components**

-   \[Azure Stack Edge\]( <https://azure.microsoft.com/en-gb/products/azure-stack/edge/>) is used to host Azure running services on-premises close to the location where anomaly detection is happening, thereby reducing latency.

-   \[Azure Kubernetes Service on Azure Stack Edge\]( <https://learn.microsoft.com/en-us/azure/databox-online/azure-stack-edge-deploy-aks-on-azure-stack-edge>) is used to run a Kubernetes cluster of containers with the service's logic on ASE (Azure Stack Edge) in a simple and managed way.

-   \[Azure Arc\]( <https://azure.microsoft.com/en-gb/products/azure-arc/>) is used to control the Kubernetes cluster that is running on the edge device

-   \[Computer Vision\](https://azure.microsoft.com/en-gb/products/cognitive-services/computer-vision/) part of Cognitive Services suite and is used to extract object from key frames of a video stream.

-   \[Azure Blob Storage\](<https://azure.microsoft.com/en-gb/products/storage/blobs/>) is used to store images of each key frame extracted from a video stream.

-   \[Azure SQL Edge\]( https://azure.microsoft.com/en-gb/products/azure-sql/edge/) is used to store data on the edge, close to the service that consumes and processes it.

-   \[Azure Container Registry\](<https://azure.microsoft.com/en-gb/products/container-registry/>) is a registry to store Docker container images.

-   \[Azure Key Vault\](https://azure.microsoft.com/en-gb/products/key-vault/) secure storage for any secrets or cryptographic keys in use by the service.

-   \[Azure Monitor\](<https://azure.microsoft.com/en-gb/products/monitor/>) is used for all the observability needs of the service.

**Scenario details**

This example demonstrates a system that is capable of processing incoming real-time video stream, comparing the extracted real-time data with a set of reference data, and making decisions based on the results. The scenario has been implemented by a company that needed to provide regular inspections of a fenced perimeter around a secured location.

By utilising Azure Stack Edge, we can ensure that the heaviest processes are performed on-premises, close to the source of the video. This greatly improves response time of the system. Which is very important when the system is part of a wider security setup, where immediate response to an anomaly is paramount.

Deploying the parts of the system as independent containers within a Kubernetes cluster allows us to scale only the required subsystems according to the demand. For example, if the security video feed is comprised of multiple sources (i.e., multiple cameras), the container responsible for video ingestion and processing can be scaled to handle the demand, while the rest of the cluster stays on the same level.

Offloading the object detection functionality to Azure Cognitive Services greatly lowers the expertise required to deploy this scenario. Unless your requirements for object detection are highly specialised, the out-of-the-box approach you get from Image Analysis service is sufficient and doesn't require knowledge in Machine Learning.

**Potential use cases**

While this scenario has been used for security perimeter monitoring, the following use cases have similar design patterns:

-   Detecting an unsafe working environment at a factory

-   Detecting anomalies at an automated assembly line

-   Detecting a lack of de-icing fluid on aircraft

**Considerations**

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see \[Microsoft Azure Well-Architected Framework\]( https://learn.microsoft.com/en-us/azure/architecture/framework/).

**Reliability**

Reliability ensures your application can meet the commitments you make to your customers. For more information, see \[Overview of the reliability pillar\]( https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview).

One of the greatest advantages of using Azure Stack Edge is that you get fully managed components, but on your on-premises hardware. And all the fully managed Azure components are resilient automatically at a regional level.

In addition, running the system within a Kubernetes cluster allows us to offload the responsibility of keeping all the subsystem in healthy state to the Kubernetes orchestration system.

**Security**

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see \[Overview of the security pillar\] ( https://learn.microsoft.com/en-us/azure/architecture/framework/security/overview).

All of the components of this scenario are secured via Azure Active Directory managed identities. Using managed identities eliminates the need to store secrets in code or configuration files. It simplifies access control, credentials management and roles assignment.

**Cost optimization**

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see \[Overview of the cost optimization pillar\]( https://learn.microsoft.com/en-us/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the \[Azure pricing calculator\]( https://azure.com/e/b5c7bb040b2f448389aec624b77bd85a). The most expensive components in this scenario are the Azure Stack Edge and Azure Kubernetes Service. Although expensive, they provide capacity for scaling the system to address increased demand in the future.

It is also worth noting the costs of using Azure Cognitive Services for object detection. The example provided above is based on the system that produces 1 image per second and operates for 8 hours a day. 1 FPS is plenty for this scenario and 8 hours a day was a rough estimate of the workload required. However, if your system needs to run for longer periods of time, the cost of utilizing Azure Cognitive Services is going to be higher:

-   \[Medium workload. 12 hours a day\]( <https://azure.com/e/ab250e01d61b44f794fb9237d144e59a>)

-   \[High workload. 24 hours a day\]( https://azure.com/e/06e155e46e6546b79fa07824f2c124f7)

**Performance efficiency**

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see \[Performance efficiency pillar overview\]( https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/overview).

By deploying our code in a Kubernetes cluster, we take advantage of the powerful orchestration system. Separating different subsystems in containers allows us to scale only the most demanding parts of the application. At the very basic level with one incoming video feed this scenario can start with just one node in a cluster, which greatly simplifies initial setup. As demand for data processing grows, it is easy to scale the cluster by adding more nodes.

**Contributors**

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

-   \[Nick Sologoub\]( https://www.linkedin.com/in/ncksol/) \| (Principal Software Engineering Lead)

Other contributors:

-   \[Frédéric Le Coquil\]( https://www.linkedin.com/in/frederic-le-coquil-449a4b) \| (Principal Software Engineer)

**Next steps**

Product documentation:

-   \[Object detection\](<https://learn.microsoft.com/en-gb/azure/cognitive-services/computer-vision/concept-object-detection?tabs=3-2>)

-   \[Responsible use of AI\]( <https://learn.microsoft.com/en-gb/legal/cognitive-services/computer-vision/imageanalysis-transparency-note?context=%2Fazure%2Fcognitive-services%2Fcomputer-vision%2Fcontext%2Fcontext>)

-   \[What is Azure Stack Edge Pro 2\]( <https://learn.microsoft.com/en-us/azure/databox-online/azure-stack-edge-pro-2-overview>)

-   \[Azure Kubernetes Service\](<https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes>)

-   \[Azure Arc Overview\](<https://learn.microsoft.com/en-us/azure/azure-arc/overview>)

Guided learning path:

-   \[Bring Azure innovation to your hybrid environments with Azure Arc\](<https://learn.microsoft.com/en-us/training/paths/manage-hybrid-infrastructure-with-azure-arc/>)

-   \[Introduction to Azure Kubernetes Service\](<https://learn.microsoft.com/en-us/training/modules/intro-to-azure-kubernetes-service/>)

-   \[Introduction to Azure Stack\](<https://learn.microsoft.com/en-us/training/modules/intro-to-azure-stack/>)

-   \[Analyze images with the Computer Vision service\](https://learn.microsoft.com/en-us/training/modules/analyze-images-computer-vision/)

**Related resources**

-   \[Image classification on Azure\](https://learn.microsoft.com/en-gb/azure/architecture/example-scenario/ai/intelligent-apps-image-processing)
