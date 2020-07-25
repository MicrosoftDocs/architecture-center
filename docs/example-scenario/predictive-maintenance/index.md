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

Internet-of-things (IoT) Edge computing allows data processing and storage close to the source, enabling fast, consistent responses with lower dependency on cloud connectivity and storage. Edge computing can incorporate artificial intelligence (AI) and machine learning (ML) models to create *intelligent edge* devices and networks, which can also integrate with the cloud for further processing. This article describes a collaboration between the Microsoft Commercial Software Engineering (CSE) team and a major railway company to create an [intelligent cloud and intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/) solution for train maintenance and safety.

The railway company wants to improve railroad safety and efficiency by proactively identifying defective track and train components, predictively scheduling maintenance and repair, and continuously improving the quality of these findings and predictions. The company has more than 4,000 trackside detectors that continuously monitor and stream data from every locomotive and railcar on their network. These detectors measure heat and force of equipment on the tracks, listen for invisible wheel bearing defects or wheel cracks, and use cameras to identify missing or mis-positioned parts.

The *ML on Edge* solution processes and acts on this continuous streaming detector data in near-real time to identify equipment at risk of failure, determine repair urgency, and notify operations personnel. The pilot project is a train wheel health analysis system, which is deployed to Azure IoT Edge modules running on server class hardware in trackside bungalows. This infrastructure allows for future parallel deployment of other workloads. The system also sends images and data to the Azure cloud for further processing, to spot trends and inform prescriptive maintenance and overhaul schedules. The wheel health analysis system provides early identification of potential equipment failure, expediting condemnation and helping prevent catastrophic failures that could lead to train derailment.

Bringing ML applications closer to the data source facilitates tighter decision loops and faster response times to critical system events. Implementing ML, AI, third-party services, or other business logic at the edge of the network allows devices to react more quickly to local changes, and reduces the time and bandwidth needed for communicating with the cloud. Devices can operate reliably even offline or when connectivity is limited. The edge network can also determine which data to send to the cloud, and prioritize urgent or important data first.

## Related use cases

IoT Edge implementations are especially relevant when large amounts of data captured in real time need action or decisions with little or no latency. The example system had to maintain 99.999% uptime, process data from up to 24 trains per day, and guarantee one-hour delivery of alerts and notifications to the railway's emergency response plan or work order system.

## Architecture

:::image type="content" source="./media/solution-architecture.png" alt-text="Solution architecture diagram that shows the IoT Edge modules in the trackside bungalows delivering image data to Azure Blob Storage and metadata and communications through Azure IoT Hub." border="false":::

1. The IoT Edge modules run on server-class hardware in trackside bungalows, using customized industrial automation cards and GPUs for performance.
1. Trackside detector cameras take three pictures of each wheel to create a stitched image, and send the streaming data to an image file server in each bungalow.
1. The polling module alerts the device that new images are available for processing.
1. A third-party open-source ML model called Cogniac scores the images and generates alerts for wheel failures or areas that need further inspection.
1. The alert handler uploads all images into Azure Blob Storage.
1. IoT Edge Hub uploads alert notifications via Azure IoT Hub, and uploads metadata for all archived images to Azure Cosmos DB via Azure IoT Hub, Event Hub [Grid?], and an Azure Function.
1. Azure CosmosDB holds the image metadata and points to the location of images in Azure Blob Storage. ML uses historical samples of high- and low-confidence failure images to retrain its model.

## Components

The deployed solution requires an Azure subscription with permission to add service principals and the ability to create Azure resources.

### IoT Edge

### Machine learning

### Azure Container Registry

### Azure Blob Storage

### IoT Hub

### Event Hub (Grid?)

### Azure Functions

### Cosmos DB

### Azure DevOps

An Azure Pipelines workflow builds, tests, deploys, and archives the IoT Edge solution. The following diagram shows the DevOps architecture.

:::image type="content" source="./media/devops-architecture.png" alt-text="DevOps architecture diagram." border="false":::

This design uses built-in Azure IoT Edge tasks in Azure Pipelines. In the first, continuous integration (CI) pipeline, a code push into the Git repository triggers the build of the IoT Edge module and registers the module image in Azure Container Registry. When the CI pipeline completes, it triggers the continuous deployment (CD) pipeline, which generates the deployment manifest that deploys the module to IoT Edge devices. This deployment has three environments: Dev, QA, and Production. Module promotion from Dev to QA and from QA to Production supports both automatic and manual gated checks. The railway company hosts the build and CI/CD system on-premises.

Building and deploying the solution also uses:
- Azure CLI.
- Docker CE or Moby to build and deploy the container modules.
- For development, Visual Studio or Visual Studio Code with the Docker, Azure IoT, and relevant language extensions.

## Considerations

There were several design considerations identified by the team:

- The alert, alarm, and notification systems require 99% uptime and message delivery to on-premises systems within 24 hours. The Quality of Service (QoS) for the last mile of connectivity between bungalow and Azure determines the QoS of alerts, alarms, and notifications from the edge. Local internet services providers (ISPs) govern the last mile of connectivity, and may not support the required QoS for edge-to-cloud notifications or bulk data uploading.
- This IoT Edge system doesn't interface with the wheel cameras and backing data stores, and has no control or ability to alert on camera system or image server failures.
- The railway company only owns the inferencing system, and relies on a third-party vendor for ML model generation. The black-box nature of the ML module poses some risk of dependency. An understanding of how the third party governs and shares assets with the company is critical to long-term solution maintenance. If ML assets aren't available, the system may be able to use placeholder ML modules for future engagements.
- For this engagement, the company's existing third-party enterprise solution covered system monitoring. The physical security of trackside bungalows and network security were already in place, and connections from the IoT edge to the cloud are secure by default.
- This solution doesn't replace existing manual inspection requirements determined by company and federal regulatory authorities.
- The Edge architecture is currently split into multiple modules, but can be condensed into a single module, depending on solution performance requirements or development team structure.
- This solution builds on previous CSE customer engagements in the manufacturing, oil, and gas and natural resource management industries:
  - [CloudEvents](https://github.com/cloudevents/spec)
  - [Claim Check Patterns](https://docs.microsoft.com/azure/architecture/patterns/claim-check)
  - [Command and Query Responsibility Segregation (CQRS) Pattern](http://udidahan.com/2011/04/22/when-to-avoid-cqrs/)

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
