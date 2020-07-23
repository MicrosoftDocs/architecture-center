---
title: Predictive maintenance with the intelligent IoT Edge platform
description: See an example of predictive safety maintenance using machine learning on the Azure intelligent IoT Edge platform.
author: tmmarshall
ms.date: 07/23/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Predictive maintenance with the intelligent IoT Edge

Edge computing processes and stores internet-of-things (IoT) data closer to its source, enabling faster responses and reducing network connectivity and cloud storage needs. Edge computing can include artificial intelligence (AI) and machine learning (ML) capabilities to make IoT devices intelligent. This article provide an example implementation of an IoT intelligent edge computing model.

A major railway company sought to improve their railroad maintenance and safety by proactively identifying defective track and train components, predictively scheduling maintenance and repair, and continuously improving the quality of their findings and predictions.

The company has more than 4,000 trackside detectors that continuously monitor and stream data from every locomotive and railcar on their network. These detectors measure heat and force of equipment on the tracks, listen for wheel bearing defects or wheel cracks before they're visible, and identify missing or mis-positioned parts. Machine learning can use this data to determine the urgency of equipment repairs and spot trends to inform prescriptive maintenance and overhaul schedules.

The Microsoft Commercial Software Engineering (CSE) team collaborated with the railway company to develop an *ML on Edge* solution that processes and act on continuous streaming detector data in near-real time. The system also sends images and data for Azure cloud processing.

Bringing ML applications closer to the data source facilitates tighter decision loops and faster response times to critical system events. Implementing ML, AI, third-party services, or other business logic at the edge of the network allows devices to react more quickly to local changes, and reduces the time and bandwidth needed for communicating with the cloud. Devices can operate reliably even offline or when connectivity is limited. The edge network can also determine which data to send to the cloud, and prioritize more urgent or important data first.

The pilot project for the *ML on Edge* platform is a train wheel health analysis system that identifies equipment at risk of failure. This application is deployed to Azure IoT Edge systems running on server class hardware in trackside bungalows. With the infrastructure in place, other parallel workloads can also be deployed. The wheel health analysis system provides early identification of potential equipment failure, expediting condemnation and helping prevent catastrophic failures that could lead to train derailment.

## Potential use cases

These implementations are specifically relevant when large amounts of data are captured in real-time and actions or decisions are needed with little to no latency. 

The goals of the solution architecture were as follows:

- Maintain 99.999% uptime.
- Guarantee one-hour delivery of alerts & notifications to customer's ERP/work order system.
- Process up to 24 trains per day.
- Identify wheel health defects using a machine learning (ML) model on the Edge and then uploading corresponding evidence of possible defect to Azure Blob Storage.
- Do A/B testing of ML model in the cloud; with a reach goal of extension to A/B testing on the edge devices.

### Considerations

There were several design considerations identified by the team:

- Alert/Alarm/Notification systems require message delivery to on-prem ERP systems within 24hrs (a 99% uptime requirement). There is likely concern that local ISPs may not support required QoS for edge to cloud notifications across the last mile.
- QoS requirements on bulk data uploading is an additional concern given that local ISPs governs the last mile of connectivity.
- Edge system does not interface with wheel camera and backing data stores. As such, Edge has no control or ability to alert on camera systems or edge NAS failures.
- Dust can cover the cameras.
- There is reliance on third-party vendors. An understanding of how their assets are governed and shared with the customer is critical to long-term solution maintenance. We may also need a placeholder ML module for the engagement (consider darknet), if ML assets are not available; 3 or 4-day pre-engagement lead time.
- The customer only owns the inferencing system and not model generation. The black box nature poses some risk of dependency as noted above.

## Architecture

The technical solution is an Intelligent Edge Platform with a wheel health analysis system deployed to the Edge that will identify equipment at risk of failure. The wheel health application is deployed to Azure IoT Edge systems running on server-class hardware housed in trackside bungalows. The ML model processes the images and identifies areas on the wheels that require further inspection, while the edge compute resources, leveraging customized GPUs for performance, prioritize, and alert system operators of wheel fractures and are responsible for uploading all wheel images from the edge to the cloud. Metadata is attached to and archived with images, and historical samples of high and low confidence failure images are used for ML retraining. The DevOps environment is created to build, test, deploy, and archive edge assets. More details about the solution follow below.

This is a customized solution that includes technologies from both Microsoft and third parties. This solution integrates a third-party ML model called Cogniac, and other components such as Azure Blob Storage, Cosmos DB, Event Grid, and more. The prerequisites needed are shown in the following list.

- Azure subscription
  - Implementor requires permission to add Service Principles and the ability to create Resource Groups, as well as the ability to create resources, such as IoT Hub and Container Registry
- Azure DevOps
- Docker CE or Moby
- Visual Studio or VSCode with Docker, Azure IoT, and relevant language extensions installed
- Azure IoT Edge
- Azure IoT Hub
- Azure CLI
- Hardware:
  - One to two physical devices where IoT Edge will be installed
  - Customized hardware, including GPU cards and industrial automation cards

:::image type="content" source="./media/solution-architecture.png" alt-text="Solution architecture diagram." border="false":::

The architecture developed for this solution is shown above. Processed and categorized train wheel images are available on an image file server (NAS) stored in a bungalow. Three pictures are taken of each wheel to create a stitched image. Wheel health defects are identified by the ML model on the Edge, and corresponding evidence is uploaded to Azure Blob Storage.

Note: The ML model used was considered a bit of a "black box" in this engagement, in that the customer only needed CSE to help make the connections. The customer assumed responsibility for the creation and functionality of this aspect of the solution.

The polling module is responsible for alerting Edge modules to the presence of new images for processing. The ML Model scores images and generates alerts at the detection of a defect. The alert handler is responsible for uploading all images, irrespective of defect, into Azure Blob Storage. Azure CosmosDB holds the image metadata and points to the location of images in Azure Blob Storage.

:::image type="content" source="./media/edge-architecture.png" alt-text="Edge architecture diagram." border="false":::

The Azure IoT Edge architecture is shown above, which illustrates how the polling module, image uploader, alert handler, ML model(s), Azure ML Services, and third-party open-source software are deployed to the edge runtime environment.

:::image type="content" source="./media/devops-architecture.png" alt-text="DevOps architecture diagram." border="false":::

The diagram above shows the DevOps architecture used for the solution. This design uses built-in Azure IoT Edge tasks in Azure Pipelines. The first pipeline is the Continuous Integration (CI) pipeline, which is triggered through a code push into the module repository. The DevOps infrastructure builds the module and registers the module image in the Azure Container Registry. Upon completion, the Continuous Deployment (CD) pipeline is triggered; this generates the deployment manifest, which then deploys the module to IoT Edge devices. For this deployment, there are three environments: Dev, QA, and Production. Module promotion from Dev to QA and from QA to Production support both Automatic and Manual gated checks.

As a result of implementing this solution, the customer is better positioned to:

- Determine the need and urgency of equipment repairs
- Predictive maintenance using machine learning can spot trends in mechanical wear early
- Reduce response times to critical system events
- Identify locomotive or railcar wheel defects by processing images and data in Microsoft Azure, thereby reducing the time to detection and ultimately making railroads safer
- Improve asset utilization, servicing, and operational efficiency

In this engagement, monitoring was covered by the customer's existing third-party enterprise solution. The physical security of trackside bungalows and network security were already in place. And connectivity for IoT solutions from the edge to the cloud are secure by default. However, this solution does not replace existing manual inspection requirements as determined by the customer and federal regulatory authorities.

- The solution uptime availability has neared 99.9%. For system availability requirements to be 99.999% puts significant demand on system components, which must then, individually, exceed 99.9999% uptime.
- The Quality of Service (QoS) for the last mile of connectivity between bungalow and Azure determines the QoS of alerts, alarms, and notifications from the edge compute environment.
- A watchdog message loop to devices is needed to monitor for potential network partitions or equipment failures (such as camera flash failure).
- The Edge architecture is currently split into multiple modules but can be condensed into single module depending on solution performance requirements or development team structure.
- The build and CI/CD system is hosted on-premises.

1. Builds on previous CSE customer engagements in the manufacturing, oil, and gas and natural resource management industries.
1. [CloudEvents](https://github.com/cloudevents/spec)
1. [Claim Check Patterns](https://docs.microsoft.com/azure/architecture/patterns/claim-check)
1. [Command and Query Responsibility Segregation (CQRS) Pattern](http://udidahan.com/2011/04/22/when-to-avoid-cqrs/)

## Related resources

### Solution Learning Resources

- Intro to Event Sourcing: [https://martinfowler.com/eaaDev/EventSourcing.html](https://martinfowler.com/eaaDev/EventSourcing.html)
- Migrate from Dev AppInsights to Dynatrace: [https://www.dynatrace.com/technologies/azure-monitoring/azure-application-insights/](https://www.dynatrace.com/technologies/azure-monitoring/azure-application-insights/)

### Data Science & Insights Resources

- Azure IoT Edge Python Module: [https://docs.microsoft.com/azure/iot-edge/tutorial-python-module](https://docs.microsoft.com/azure/iot-edge/tutorial-python-module)
- Azure IoT Edge Python Template: [https://github.com/Azure/cookiecutter-azure-iot-edge-module](https://github.com/Azure/cookiecutter-azure-iot-edge-module)
- Python Package Publishing: [https://python-packaging.readthedocs.io/en/latest/minimal.html](https://python-packaging.readthedocs.io/en/latest/minimal.html)
- Nvidia Distributions: [https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)#centos-distributions](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)#centos-distributions)
- Nvidia Docker with Red Hat Enterprise Linux (RHEL): [https://developer.ibm.com/linuxonpower/2018/09/19/using-nvidia-docker-2-0-rhel-7/](https://developer.ibm.com/linuxonpower/2018/09/19/using-nvidia-docker-2-0-rhel-7/)
- Nvidia Container Runtimes: [https://github.com/NVIDIA/nvidia-container-runtime#daemon-configuration-file](https://github.com/NVIDIA/nvidia-container-runtime#daemon-configuration-file)
- Nvidia Cuda: [https://hub.docker.com/r/nvidia/cuda/](https://hub.docker.com/r/nvidia/cuda/)
- Containers & Multi-GPU scenarios: [https://github.com/nvidia/nvidia-docker/wiki/Frequently-Asked-Questions#i-have-multiple-gpu-devices-how-can-i-isolate-them-between-my-containers](https://github.com/nvidia/nvidia-docker/wiki/Frequently-Asked-Questions#i-have-multiple-gpu-devices-how-can-i-isolate-them-between-my-containers)
- Nvidia DGX: [https://www.nvidia.com/data-center/dgx-systems/](https://www.nvidia.com/data-center/dgx-systems/)

### Edge Compute & Security Resources

- Building IoT Edge Modules: [https://docs.microsoft.com/azure/iot-edge/how-to-vs-code-develop-module](https://docs.microsoft.com/azure/iot-edge/how-to-vs-code-develop-module)
- Azure IoT Device Explorer: [https://github.com/Azure/azure-iot-sdk-csharp/tree/master/tools/DeviceExplorer](https://github.com/Azure/azure-iot-sdk-csharp/tree/master/tools/DeviceExplorer)
- Azure Service Bus Explorer: [https://github.com/paolosalvatori/ServiceBusExplorer](https://github.com/paolosalvatori/ServiceBusExplorer)
- Azure IoT Hub Protocol Ports: [https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-protocols#port-numbers](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-protocols#port-numbers)
- Nvidia Docker Distributions: [https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)#centos-distributions](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)#centos-distributions)
- Docker Compatibility Matrix: [https://success.docker.com/article/compatibility-matrix](https://success.docker.com/article/compatibility-matrix)
- Priority Queues for Azure IoT Edge Alerts, Alarms, and Notifications: [https://github.com/idavis/iot-edge-rabbitmq](https://github.com/idavis/iot-edge-rabbitmq)

### Data Processing & Management Resources

- CosmosDB Streaming: [https://medium.com/streaming-at-scale-in-azure/serverless-streaming-at-scale-with-cosmos-db-e0e26cacd27d](https://medium.com/streaming-at-scale-in-azure/serverless-streaming-at-scale-with-cosmos-db-e0e26cacd27d)
- Streaming at Scale: [https://github.com/Azure-Samples/streaming-at-scale](https://github.com/Azure-Samples/streaming-at-scale)
- Java SDK for CosmosDB: [https://docs.microsoft.com/azure/cosmos-db/sql-api-sdk-java](https://docs.microsoft.com/azure/cosmos-db/sql-api-sdk-java)
- Functions Binding for Storage: [https://docs.microsoft.com/azure/azure-functions/functions-bindings-storage-blob](https://docs.microsoft.com/azure/azure-functions/functions-bindings-storage-blob)
- Blob Events: [https://docs.microsoft.com/azure/storage/blobs/storage-blob-event-overview](https://docs.microsoft.com/azure/storage/blobs/storage-blob-event-overview)
- Blob vs Event Trigger Performance: [https://github.com/MicrosoftDocs/azure-docs/issues/5208](https://github.com/MicrosoftDocs/azure-docs/issues/5208)
- Virtual Azure Storage Overlay: [https://github.com/MicrosoftDX/Dash](https://github.com/MicrosoftDX/Dash)
- General Availability Announcement for Java Functions: [https://azure.microsoft.com/blog/announcing-the-general-availability-of-java-support-in-azure-functions/](https://azure.microsoft.com/blog/announcing-the-general-availability-of-java-support-in-azure-functions/)

### Operations Resources

- Container Registries and Service Principals: [https://docs.microsoft.com/azure/container-registry/container-registry-auth-service-principal](https://docs.microsoft.com/azure/container-registry/container-registry-auth-service-principal)
- Jenkins Plugin for IoT Edge: [https://wiki.jenkins.io/display/JENKINS/Azure+IoT+Edge+Plugin](https://wiki.jenkins.io/display/JENKINS/Azure+IoT+Edge+Plugin)
- Jenkins Pipelines: [https://jenkins.io/doc/pipeline/tour/hello-world/](https://jenkins.io/doc/pipeline/tour/hello-world/)
- Azure IoT Edge CI/CD: [https://docs.microsoft.com/azure/iot-edge/how-to-ci-cd](https://docs.microsoft.com/azure/iot-edge/how-to-ci-cd)
