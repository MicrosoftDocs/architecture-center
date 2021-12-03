

The *Internet-of-things (IoT) Edge* brings data processing and storage close to the data source, enabling fast, consistent responses with reduced dependency on cloud connectivity and resources. Edge computing can incorporate artificial intelligence (AI) and machine learning (ML) models to create *intelligent edge* devices and networks, which can integrate with the cloud for further processing and security.

This article describes a collaboration between the Microsoft Commercial Software Engineering (CSE) team and a major railway company to create an [intelligent cloud and intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/) train maintenance and safety solution. The railway company wants to improve railroad safety and efficiency by proactively identifying defective components, predictively scheduling maintenance and repair, and continuously improving their findings and predictions. The pilot project for the *ML on Edge* solution is a train wheel health analysis system.

Over 4,000 trackside detectors continuously monitor and stream wheel data from all the company's trains. The detectors measure heat and force of equipment on the tracks, listen for invisible wheel bearing defects or wheel cracks, and identify missing or misplaced parts. The ML on Edge system processes and acts on this continuous streaming detector data in near-real time to identify at-risk equipment, determine repair urgency, generate alerts, and send data to the Azure cloud for storage. The IoT Edge modules run on server class hardware in trackside bungalows, allowing for future parallel deployment of other workloads.

Bringing ML and business logic closer to the data sources lets devices react faster to local changes and critical events. Devices can operate reliably offline or when connectivity is limited. The Edge network can determine which data to send to the cloud, or prioritize urgent and important data first.

The wheel health analysis system provides early identification of potential equipment failure, helping prevent catastrophic failures that could lead to train derailment. The company can use stored data to spot trends and inform prescriptive maintenance and overhaul schedules.

## Potential use cases

IoT Edge implementations are most relevant when large amounts of data captured in real time need action or decisions with little or no latency. The example system had to maintain 99.999% uptime, process data from up to 24 trains and 35 million readings per day, and guarantee one-hour delivery of alerts and notifications.

## Architecture
[ ![Solution architecture diagram showing the IoT Edge modules in the trackside bungalows. The Edge modules use machine learning to identify failure risks. The alert handler module uploads image data to Azure Blob Storage. Azure Edge Hub uploads associated metadata and messages through Azure IoT Hub to Azure Cosmos DB storage.](./media/iot-predictive-maintenance.svg) ](./media/iot-predictive-maintenance.svg#lightbox)

1. An image file server (NAS) in a bungalow serves processed and categorized train wheel images. Three pictures of each wheel create a stitched image.
2. The polling module alerts the Edge device that new images are available for processing.
3. A third-party ML model processes the images and identifies wheel areas that need more inspection.
4. The alert handler uploads all images into Azure Blob Storage, starting with images that have potential defects, and returns the image blob URIs.
5. IoT Edge Hub associates the image URIs with image metadata, and uploads the metadata and alerts to Azure IoT Hub.
6. IoT Hub sends the metadata via Event Hub and Azure Functions to an Azure Cosmos DB database.
7. The Cosmos DB database holds the image metadata (Equipment/Car #, Axle, Timestamp, Detector Location, etc.) and points to the location of images in Azure Blob Storage.

### Components

The deployed solution requires an Azure subscription with permission to add service principals and the ability to create Azure resources. For more information, see [Container registries and service principals](/azure/container-registry/container-registry-auth-service-principal).

- [Azure IoT Edge](/azure/iot-edge/about-iot-edge) is made up of three components:
  - IoT Edge *modules* are containers that can run Azure, third-party, or custom components. The current example deploys the IoT Edge modules in trackside bungalows, using server-class hardware with customized industrial automation cards and graphics processing units (GPUs) for performance.
  - The IoT Edge *runtime*, consisting of the *IoT Agent* and *IoT Edge Hub*, runs on the IoT Edge devices to manage and coordinate the deployed modules.
  - The [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) interface enables secure bi-directional cloud communication, management, and monitoring of IoT Edge modules.
- IoT Edge ML modules support [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/), third-party ML models, or custom code. The current solution uses a third-party open-source ML model called [Cogniac](https://cogniac.co/) to score train wheel data and recognize potential defects. The ML software uses historical samples of high- and low-confidence failure images to retrain its ML model.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is Microsoft's object storage solution for the cloud. Blob storage is optimized for storing massive amounts of unstructured data like the image data in this example.
- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a fully-managed, NoSQL database service with low response times and high availability and scalability.
- An [Azure Pipelines](/azure/iot-edge/how-to-continuous-integration-continuous-deployment) workflow builds, tests, deploys, and archives the IoT Edge solution through built-in Azure IoT Edge tasks.

## Considerations

The team identified several design considerations:

- The system requires 99% uptime and on-premises message delivery within 24 hours. The Quality of Service (QoS) for the last mile of connectivity between bungalow and Azure determines the QoS of data from the edge. Local internet service providers (ISPs) govern the last mile of connectivity, and may not support the required QoS for notifications or bulk data uploading.
- This system doesn't interface with the wheel cameras and backing data stores, so has no control or ability to raise alerts on camera system or image server failures.
- The railway company only owns the inferencing system, and relies on a third-party vendor for ML model generation. The black-box nature of the ML module poses some risk of dependency. Long-term solution maintenance requires understanding how the third party governs and shares assets. The system may be able to use placeholder ML modules for future engagements when ML assets aren't available.
- Security and monitoring are considerations for IoT Edge systems. For this engagement, the company's existing third-party enterprise solution covered system monitoring. The physical security of trackside bungalows and network security were already in place, and connections from the IoT Edge to the cloud are secure by default.
- This solution doesn't replace existing manual inspection requirements determined by company and federal regulatory authorities.
- The Edge architecture is currently split into multiple modules, but can be condensed into a single module, depending on solution performance requirements or development team structure.
- This solution builds on the following previous CSE customer engagements in the manufacturing, oil and gas, and natural resource management industries:
  - [CloudEvents](https://github.com/cloudevents/spec)
  - [Claim Check Patterns](../../patterns/claim-check.md)
  - [Command and Query Responsibility Segregation (CQRS) Pattern](http://udidahan.com/2011/04/22/when-to-avoid-cqrs/)

## Deployment

The railway company hosts the *continuous integration/continuous deployment (CI/CD)* system on-premises. The following diagram shows the DevOps architecture for deployment:

:::image type="content" source="./media/devops-architecture.png" alt-text="DevOps architecture diagram." border="false":::

1. In the first CI pipeline, a code push into the Git repository triggers the build of the IoT Edge module and registers the module image in Azure Container Registry.
1. When the CI pipeline completes, it triggers the CD pipeline, which generates the deployment manifest and deploys the module to IoT Edge devices.

The deployment has three environments: Dev, QA, and Production. Module promotion from Dev to QA and from QA to Production supports both automatic and manual gated checks.

Building and deploying the solution also uses:
- Azure CLI
- Docker CE or Moby to build and deploy the container modules
- For development, Visual Studio or Visual Studio Code with the Docker, Azure IoT, and relevant language extensions

## Next steps
- [The future of computing: intelligent cloud and intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/)
- [Azure IoT Edge documentation](/azure/iot-edge/)
- [Build IoT Edge modules](/azure/iot-edge/how-to-vs-code-develop-module)
- [End-to-end solution using Azure Machine Learning and IoT Edge](/azure/iot-edge/tutorial-machine-learning-edge-01-intro)
- [Continuous integration and continuous deployment to Azure IoT Edge](/azure/iot-edge/how-to-continuous-integration-continuous-deployment)
- [Deploy Azure IoT Edge modules from the Azure portal](/azure/iot-edge/how-to-deploy-modules-portal)

## Related resources

**GitHub code projects**

- [NVIDIA Container Toolkit](https://github.com/nvidia/nvidia-docker/wiki)
- [Azure IoT Edge and RabbitMQ](https://github.com/idavis/iot-edge-rabbitmq)
- [Cookiecutter Template for Azure IoT Edge Python Module](https://github.com/Azure/cookiecutter-azure-iot-edge-module)
- [Streaming at Scale](https://github.com/Azure-Samples/streaming-at-scale)
- [ServiceBusExplorer](https://github.com/paolosalvatori/ServiceBusExplorer)
- [DASH for Azure Storage](https://github.com/MicrosoftDX/Dash)

**Solution learning resources**

- [Docker Compatibility Matrix](https://success.docker.com/article/compatibility-matrix)
- [Jenkins Azure IoT Edge plugin](https://github.com/Microsoft/azure-iot-edge-jenkins-plugin)
- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- [React to Blob storage events](/azure/storage/blobs/storage-blob-event-overview)
- [Azure Blob storage bindings for Azure Functions](/azure/azure-functions/functions-bindings-storage-blob)
- [Serverless Streaming At Scale with Cosmos DB](https://medium.com/streaming-at-scale-in-azure/serverless-streaming-at-scale-with-cosmos-db-e0e26cacd27d)
