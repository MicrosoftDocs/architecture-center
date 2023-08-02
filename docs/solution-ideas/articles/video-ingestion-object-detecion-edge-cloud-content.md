This scenario describes how to organize regular monitoring of the perimeter of a secured location. It includes a robot that patrols the premises with a live streaming camera, a system that runs locally on Azure Stack Edge to ingest and process the video stream, and Azure AI services that perform object detection.

## Architecture

image

*Download a [Visio file](https://arch-center.azureedge.net/\[filename\].vsdx) of this architecture.*

### Workflow

This workflow describes how the system processes the incoming data:

1.  A camera that's installed on the robot streams video in real time by using Real Time Streaming Protocol ([RTSP](/openspecs/windows_protocols/ms-dmct/fee912b4-f90e-458c-b44d-a03821c23fc3)).

2.  A container in the Kubernetes cluster on Azure Stack Edge reads the incoming stream and splits video into separate images. An open-source software tool called [ffmpeg](https://ffmpeg.org/about.html) ingests and processes the video stream.

3.  Images are stored in the local Stack Edge storage account.

4.  Each time a new key frame is saved in the storage account, an AI Vision container picks it up. For information about the separation of logic into multiple containers, see [Scenario details](#scenario-details).

5.  When it loads a key frame from the storage container, the AI Vision container sends it to Azure AI services in the cloud. This architecture uses Azure AI Vision, which enables object detection via image analysis.

6.  The results of image analysis (detected objects and a confidence rating) are sent to the anomaly detection container.

7.  The anomaly detection container stores the results of image analysis and anomaly detection in the local Stack Edge Azure SQL database for future reference. Using a local instance of the database improves access time, which helps to minimize delays in data access.

8.  Data processing is run to detect any security anomalies in the incoming real-time video stream. If anomalies are detected, an alert is raised for the security personnel via a front-end UI.

### Components

-   [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) is used to host running Azure services on-premises, close to the location where anomaly detection occurs, which reduces latency.

-   [Azure Kubernetes Service on Azure Stack Edge](/azure/databox-online/azure-stack-edge-deploy-aks-on-azure-stack-edge) is used to run a Kubernetes cluster of containers with the system's logic on Azure Stack Edge in a simple and managed way.

-   [Azure Arc](https://azure.microsoft.com/products/azure-arc/) controls the Kubernetes cluster that runs on the edge device.

-   [Azure AI Vision](https://azure.microsoft.com/products/ai-services/ai-vision) is used to detect objects in key frames of a video stream.

-   [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/) is used to store images of key frames that are extracted from a video stream.

-   [Azure SQL Edge]( https://azure.microsoft.com/products/azure-sql/edge/) is used to store data on the edge, close to the service that consumes and processes it.

-   [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) is used to store Docker container images.

-   [Azure Key Vault](https://azure.microsoft.com/en-gb/products/key-vault/) provides enhanced-security storage for any secrets or cryptographic keys that are used by the system.

-   [Azure Monitor](https://azure.microsoft.com/products/monitor/) provides observability for the system.

## Scenario details

This architecture demonstrates a system that processes a real-time video stream, compares the extracted real-time data with a set of reference data, and makes decisions based on the results. For example, it could be used to provide scheduled inspections of a fenced perimeter around a secured location.

The architecture uses Stack Edge to ensure that the most resource-intensive processes are performed on-premises, close to the source of the video. This design significantly improves the response time of the system, which is important when the system is part of a wider security setup, where immediate response to an anomaly is critical.

Because the components of the system are deployed as independent containers in a Kubernetes cluster, you can scale only the required subsystems according to the demand. For example, when the security video feed is sourced from multiple  cameras, the container responsible for video ingestion and processing can be scaled to handle the demand while the rest of the cluster stays at the original level.

Offloading the object detection functionality to Azure AI services significantly reduces the expertise that you need to deploy this architecture. Unless your requirements for object detection are highly specialised, the out-of-the-box approach you get from the Image Analysis service is sufficient and doesn't require knowledge of machine learning.

### Potential use cases

- Monitoring the security of a perimeter
-   Detecting an unsafe working environment in a factory

-   Detecting anomalies in an automated assembly line

-   Detecting a lack of de-icing fluid on aircraft

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

One of the biggest advantages to using Stack Edge is that you get fully managed components on your on-premises hardware. All fully managed Azure components are automatically resilient at a regional level.

In addition, running the system in a Kubernetes cluster enables you to offload the responsibility for keeping the subsystems healthy to the Kubernetes orchestration system.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

 Azure Active Directory managed identities provide security for all components of this architecture. Using managed identities eliminates the need to store secrets in code or configuration files. It simplifies access control, credential management, and role assignment.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.com/e/b5c7bb040b2f448389aec624b77bd85a). The most expensive components in the scenario are Stack Edge and Azure Kubernetes Service. Although expensive, they provide capacity for scaling the system to address increased demand in the future.

It is also worth noting the costs of using Azure Cognitive Services for object detection. The example provided above is based on the system that produces 1 image per second and operates for 8 hours a day. 1 FPS is plenty for this scenario and 8 hours a day was a rough estimate of the workload required. However, if your system needs to run for longer periods of time, the cost of utilizing Azure Cognitive Services is going to be higher:

-   [Medium workload. 12 hours a day](https://azure.com/e/ab250e01d61b44f794fb9237d144e59a)
-   [High workload. 24 hours a day]( https://azure.com/e/06e155e46e6546b79fa07824f2c124f7)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

By deploying our code in a Kubernetes cluster, we take advantage of the powerful orchestration system. Separating different subsystems in containers allows us to scale only the most demanding parts of the application. At the very basic level with one incoming video feed this scenario can start with just one node in a cluster, which greatly simplifies initial setup. As demand for data processing grows, it is easy to scale the cluster by adding more nodes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

-   [Nick Sologoub](https://www.linkedin.com/in/ncksol/) | Principal Software Engineering Lead

Other contributors:

-   [Frédéric Le Coquil](https://www.linkedin.com/in/frederic-le-coquil-449a4b) | Principal Software Engineer

## Next steps

Product documentation:

-   [Object detection](/azure/cognitive-services/computer-vision/concept-object-detection?tabs=3-2)

-   [Responsible use of AI](/legal/cognitive-services/computer-vision/imageanalysis-transparency-note?context=%2Fazure%2Fcognitive-services%2Fcomputer-vision%2Fcontext%2Fcontext)

-   [What is Azure Stack Edge Pro 2](/azure/databox-online/azure-stack-edge-pro-2-overview)

-   [Azure Kubernetes Service](/azure/aks/intro-kubernetes)

-   [Azure Arc Overview](/azure/azure-arc/overview)

Guided learning path:

-   [Bring Azure innovation to your hybrid environments with Azure Arc](/training/paths/manage-hybrid-infrastructure-with-azure-arc/)

-   [Introduction to Azure Kubernetes Service](/training/modules/intro-to-azure-kubernetes-service/)

-   [Introduction to Azure Stack](/training/modules/intro-to-azure-stack/)

-   [Analyze images with the Computer Vision service](/training/modules/analyze-images-computer-vision/)

## Related resources

-   [Image classification on Azure](/azure/architecture/example-scenario/ai/intelligent-apps-image-processing)
