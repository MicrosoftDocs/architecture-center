This article describes a collaboration between Microsoft and a major railroad company to create an internet-of-things (IoT) train maintenance and safety solution. 

## Architecture
[ ![Solution architecture diagram showing the IoT Edge modules in the trackside bungalows. The Edge modules use machine learning to identify failure risks. The alert handler module uploads image data to Azure Blob Storage. Azure Edge Hub uploads associated metadata and messages through Azure IoT Hub to Azure Cosmos DB storage.](./media/iot-predictive-maintenance.png) ](./media/iot-predictive-maintenance.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/iot-predictive-maintenance.vsdx) of this architecture.*

### Dataflow

1. A Network Attached Storage (NAS) image file server in a trackside bungalow serves processed and categorized train wheel images. Three pictures of each wheel create a stitched image.
1. The IoT Edge polling module alerts the IoT Edge device that new images are available for processing.
1. The IoT Edge ML module runs a third-party ML model that processes the images and identifies wheel areas that need more inspection.
1. The IoT Edge Alert Handler uploads all images into Azure Blob Storage, starting with images that have potential defects, and returns the image blob URIs.
1. The IoT Edge Hub module associates the image URIs with image metadata, like Equipment or Car Number, Axle, Timestamp, and Detector Location. The module uploads the metadata and alerts to Azure IoT Hub.
1. IoT Hub sends the metadata via Event Hubs and Azure Functions to an Azure Cosmos DB database.
1. The Azure Cosmos DB database associates the image metadata with the URIs of the images stored in Azure Blob Storage. The system can use the data from Azure Cosmos DB for defect recognition, trend analysis, predictive maintenance, and ML model retraining.

### Components

This example deploys [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) devices in trackside bungalows, using server-class hardware with customized industrial automation cards and graphics processing units (GPUs) for performance.

IoT Edge is made up of three components:

- IoT Edge *modules* are containers that can run Azure, third-party, or custom components.

  IoT Edge ML modules can support [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), third-party ML models, or custom code. The current solution uses a third-party open-source ML model called [Cogniac](https://cogniac.co/) to score train wheel data and recognize potential defects. The ML software uses historical samples of high- and low-confidence failure images to retrain its ML model.

- The IoT Edge *runtime*, consisting of the *IoT Agent* and *IoT Edge Hub*, runs on the IoT Edge devices to manage and coordinate the deployed modules.

- A cloud-based interface enables remote monitoring and management.

The system also uses the following Azure cloud components:

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) enables secure bi-directional cloud communication, management, and monitoring of IoT Edge modules.

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is object storage for the cloud. Blob storage is optimized for storing massive amounts of unstructured data like the image data in this example.

- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a fully managed, NoSQL database service with low response times and high availability and scalability.

### Alternatives

- The IoT Edge architecture uses multiple modules, but could be condensed into a single module, depending on solution performance requirements or development team structure.

- The railway company only owns the inferencing system, and relies on a third-party vendor for ML model generation. The black-box nature of the ML module poses some risk of dependency. Long-term solution maintenance requires understanding how the third party governs and shares assets. The system might be able to use placeholder ML modules for future engagements when ML assets aren't available.

## Scenario details

[Azure IoT Edge](/azure/iot-edge/about-iot-edge) enables data processing and storage closer to the data source. Processing workloads at the edge enables fast, consistent responses with less dependency on cloud connectivity and resources.

Bringing machine learning (ML) and business logic closer to the data sources means devices can react faster to local changes and critical events. Devices can operate reliably offline or when connectivity is limited.

Edge computing can incorporate artificial intelligence (AI) and ML models to create *intelligent edge* devices and networks. The edge network can determine which data to send to the cloud for further processing, and prioritize urgent and important data.

The railroad company wanted to use Azure IoT Edge to improve safety and efficiency by providing:

- Proactive identification of defective components.
- Predictive scheduling of maintenance and repair.
- Continuous improvement of analysis and predictions.

The pilot project for the IoT Edge solution is a train wheel health analysis system. In this system, over 4,000 trackside detectors continuously monitor and stream wheel data from the company's trains. The detectors:

- Measure heat and force of equipment on the tracks.
- Listen for invisible wheel bearing defects or wheel cracks.
- Identify missing or misplaced parts.

Azure IoT Edge modules process and act on the continuous streaming data in near real-time. The IoT Edge modules run on server class hardware in trackside bungalows, allowing for future parallel deployment of other workloads. The IoT Edge-based solution:

- Identifies at-risk equipment.
- Determines repair urgency.
- Generates alerts.
- Sends data to the Azure cloud for storage.

The wheel health analysis system provides early identification of potential equipment failures that could lead to train derailment. The company can use stored data to spot trends and inform prescriptive maintenance schedules.

### Potential use cases

This solution is ideal for the transportation, telecommunications, and manufacturing industries. It focuses on the following scenarios:

- A telecommunications network that has to maintain 99% or better uptime.
- Production quality control, equipment repair, and predictive maintenance in a factory.
- A transportation safety system that must process real-time streaming data with little or no latency.
- Transit systems that need to provide timely schedule notifications and alerts.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Several considerations apply to this example.

### Operations

The deployed solution requires an Azure subscription with permission to add service principals and the ability to create Azure resources. For more information, see [Container registries and service principals](/azure/container-registry/container-registry-auth-service-principal).

An [Azure Pipelines](/azure/iot-edge/how-to-continuous-integration-continuous-deployment) workflow builds, tests, deploys, and archives the IoT Edge solution through built-in Azure IoT Edge tasks. The railway company hosts the *continuous integration/continuous deployment (CI/CD)* system on-premises. The following diagram shows the DevOps architecture for deployment:

:::image type="content" source="./media/devops-architecture.png" alt-text="DevOps architecture diagram." border="false":::

1. In the first CI pipeline, a code push into the Git repository triggers the build of the IoT Edge module and registers the module image in [Azure Container Registry](https://azure.microsoft.com/services/container-registry).

1. CI pipeline completion triggers the CD pipeline, which generates the deployment manifest and deploys the module to the IoT Edge devices.

The deployment has three environments: Dev, QA, and Production. Module promotion from Dev to QA and from QA to Production supports both automatic and manual gated checks.

Building and deploying the solution also uses:
- Azure CLI
- Docker CE or Moby to build and deploy the container modules
- For development, Visual Studio or Visual Studio Code with the Docker, Azure IoT, and relevant language extensions.

### Performance

- The system requires 99% uptime and on-premises message delivery within 24 hours. The Quality of Service (QoS) for the last mile of connectivity between bungalow and Azure determines the QoS of data from the edge. Local internet service providers (ISPs) govern the last mile of connectivity, and might not support the required QoS for notifications or bulk data uploading.

- This system doesn't interface with the wheel cameras and backing data stores, so has no control or ability to raise alerts on camera system or image server failures.

- This solution doesn't replace existing manual inspection requirements determined by company and federal regulatory authorities.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Security and monitoring are considerations for IoT Edge systems. For this example:

- The company's existing third-party enterprise solution covered system monitoring.
- The physical security of trackside bungalows and network security were already in place.
- Connections from the IoT Edge to the cloud are secure by default.

## Next steps

- [The future of computing: intelligent cloud and intelligent edge](https://azure.microsoft.com/overview/future-of-cloud)
- [Azure IoT Edge documentation](/azure/iot-edge)
- [Build IoT Edge modules](/azure/iot-edge/how-to-vs-code-develop-module)
- [End-to-end solution using Azure Machine Learning and IoT Edge](/azure/iot-edge/tutorial-machine-learning-edge-01-intro)
- [Continuous integration and continuous deployment to Azure IoT Edge](/azure/iot-edge/how-to-continuous-integration-continuous-deployment)
- [Deploy Azure IoT Edge modules from the Azure portal](/azure/iot-edge/how-to-deploy-modules-portal)

**GitHub projects:**

- [CloudEvents](https://github.com/cloudevents/spec)
- [NVIDIA Container Toolkit](https://github.com/nvidia/nvidia-docker/wiki)
- [Azure IoT Edge and RabbitMQ](https://github.com/idavis/iot-edge-rabbitmq)
- [Cookiecutter Template for Azure IoT Edge Python Module](https://github.com/Azure/cookiecutter-azure-iot-edge-module)
- [Streaming at Scale](https://github.com/Azure-Samples/streaming-at-scale)
- [ServiceBusExplorer](https://github.com/paolosalvatori/ServiceBusExplorer)
- [DASH for Azure Storage](https://github.com/MicrosoftDX/Dash)

**Solution learning resources:**

- [Docker Compatibility Matrix](https://docs.docker.com/compose/compose-file/compose-versioning/#compatibility-matrix)
- [Jenkins Azure IoT Edge plugin](https://github.com/Microsoft/azure-iot-edge-jenkins-plugin)
- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- [React to Blob storage events](/azure/storage/blobs/storage-blob-event-overview)
- [Azure Blob storage bindings for Azure Functions](/azure/azure-functions/functions-bindings-storage-blob)
- [Serverless Streaming At Scale with Azure Cosmos DB](https://medium.com/streaming-at-scale-in-azure/serverless-streaming-at-scale-with-cosmos-db-e0e26cacd27d)
- [When to avoid CQRS](http://udidahan.com/2011/04/22/when-to-avoid-cqrs/)

## Related resources

- [Introduction to predictive maintenance in manufacturing](../../industries/manufacturing/predictive-maintenance-overview.yml)
- [Predictive maintenance for industrial IoT](../../solution-ideas/articles/predictive-maintenance.yml)
- [Predictive maintenance solution](../../industries/manufacturing/predictive-maintenance-solution.yml)
- [Predictive aircraft engine monitoring](../../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
- [Defect prevention with predictive maintenance using analytics and machine learning](../../solution-ideas/articles/defect-prevention-with-predictive-maintenance.yml)
- [Anomaly detector process](../../solution-ideas/articles/anomaly-detector-process.yml)
- [Quality assurance](../../solution-ideas/articles/quality-assurance.yml)
- [Connected factory signal pipeline](../iot/connected-factory-signal-pipeline.yml)
- [Claim Check pattern](../../patterns/claim-check.yml)
- [Command and Query Responsibility Segregation (CQRS) pattern](../../patterns/cqrs.yml)
