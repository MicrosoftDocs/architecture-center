Fully automated smart factories use artificial intelligence (AI) and machine learning (ML) to analyze data, run systems, and improve processes over time. Manufacturing processes use computer vision at the internet-of-things (IoT) edge in safety and quality assurance applications. 

This example architecture shows an end-to-end approach to IoT computer vision from the edge to the cloud and back. Cameras send images to an Azure Video Analyzer edge device that runs an ML model. The model calculates inferences, and sends actionable output to the cloud for further processing. Human interventions are part of the intelligence the ML model captures. The ML process is a continuous cycle of training, testing, tuning, and validating the ML algorithms.

## Potential use cases

In a manufacturing environment, computer vision systems can:

- Monitor and troubleshoot equipment and production environments.
- Help ensure compliance with manufacturing or process guidelines.
- Recognize manufacturing defects such as leaks.
- Enhance security by monitoring building or area entrances.
- Uphold worker safety by detecting personal protective equipment (PPE) usage and other safety practices.

## Architecture

[![Diagram showing the end-to-end approach to computer vision from the edge to the cloud and back.](_images/end-to-end-smart-factory-01.png)](_images/end-to-end-smart-factory-01.png#lightbox)

1. The Video Analyzer edge module captures the live video stream, breaks it down into frames, and performs inference on the image data to determine if an incident has occurred.

1. The Video Analyzer uploads the raw video files and sends them to Azure Storage, which acts as a raw media store.

1. The edge module sends the inferencing results and metadata to Azure IoT Hub, which acts as a central message hub for communications in both directions.

1. Azure Logic Apps monitors IoT Hub for messages about incident events. Logic Apps routes inferencing results and metadata to Microsoft Dataverse for storage.

1. When an incident occurs, Logic Apps sends SMS and e-mail notifications to the site engineer. The site engineer uses a mobile app based on Power Apps to acknowledge and resolve the incident.

1. Power Apps pulls inferencing results and metadata from Dataverse and raw video files from Blob Storage to display relevant information about the incident. Power Apps updates Dataverse with the incident resolution the site engineer provided. This step acts as human-in-the-loop validation for model retraining purposes.

1. Azure Data Factory is the data orchestrator that fetches raw video files from the raw media store, and gets the corresponding inferencing results and metadata from Dataverse.

1. Data Factory stores the raw video files, plus the metadata, in Azure Data Lake, which serves as a video archive for auditing purposes.

1. Data Factory breaks raw video files into frames, converts the inferencing results into labels, and uploads the data into Blob Storage, which acts as the ML data store.

1. Changes to the model code automatically trigger the Azure Pipelines model orchestrator pipeline, which operators can also trigger manually. Code changes also start the ML model training and validation process in Azure Machine Learning.

1. Azure Machine Learning starts training the model by validating the data from the ML data store and copying the required datasets to Azure Premium Blob Storage, a performance tier that provides a data cache for faster model training.

1. Azure Machine Learning uses the dataset in the Premium data cache to train the model, validate the trained model's performance, score it against the newly trained model, and register the model into the Azure Machine Learning registry.

1. The model orchestration pipeline reviews the performance of the newly trained ML model and determines if it's better than previous models. If the new model performs better, the pipeline downloads the model from Azure Machine Learning and builds a new version of the ML inferencing module to publish in Azure Container Registry.

1. When a new ML inferencing module is ready, Azure Pipelines deploys the module container from Container Registry to the IoT Edge module in IoT Hub.

1. IoT Hub updates the Video Analyzer edge device with the new ML inferencing module.

### Components

- [Video Analyzer](/azure/azure-video-analyzer/video-analyzer-docs/overview) consists of an IoT Edge module and an Azure service. Video Analyzer lets you quickly build an AI-powered video analytics solution to extract actionable insights from stored or streaming videos.

- [IoT Hub](/azure/iot-hub/about-iot-hub) is a central message hub for communications in both directions between an IoT application and its connected devices.

- [Logic Apps](/azure/logic-apps/logic-apps-overview) creates and runs the automated notification workflow that sends SMS and email alerts to site engineers.

- [Power Apps](/powerapps/powerapps-overview) is a suite of apps, services, connectors, and a data platform that provides a rapid application development environment.

- [Dataverse](/powerapps/maker/data-platform/data-platform-intro) is a cloud-based storage platform for Power Apps. Dataverse supports human-in-the-loop notifications and stores metadata associated with the MLOps data pipeline.

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) provides a local data store for the ML data store and a Premium data cache for training the ML model. [Azure Premium Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is for workloads that require fast response times and high transaction rates, like the human-in-the-loop video labeling in this example.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) provides low-cost, tiered storage on top of Azure Blob Storage. In this example, Data Lake Storage provides the archival video store for the raw video files and metadata.

- [Data Factory](/azure/data-factory/introduction) is an extract-transform-load (ETL) and data integration service for orchestrating data movement and transforming data at scale. In this example, Data Factory orchestrates the data in an ETL pipeline to the inferencing data, which it stores for retraining purposes.

- [Azure Machine Learning](/azure/machine-learning) builds, trains, deploys, and manages ML models in a cloud-based environment.

- [Azure Pipelines](), part of [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) team-based developer services, creates continuous integration (CI) and continuous deployment (CD) pipelines. In this example, Azure Pipelines validates ML code, triggers Azure Machine Learning pipelines with serverless tasks, compares ML models, and builds the inferencing container.

- [Container Registry](/azure/container-registry) creates and manages the Docker registry to build, store, and manage Docker container images, including containerized ML models.

- [Azure Monitor](/azure/azure-monitor/overview) collects telemetry from Azure resources so teams can proactively identify problems and maximize performance and reliability.

### Alternatives

Instead of using the data pipeline to break down the video stream into image frames, you can deploy an Azure Blob Storage module onto the IoT Edge device. The inferencing module then uploads the inferenced image frames to the storage module on the edge device. The storage module determines when to upload the frames directly to the ML data store. The advantage of this approach is removing a step from the data pipeline. The tradeoff is that the edge device is tightly coupled to Azure Blob Storage.

For model orchestration, you can use either Azure Pipelines or Azure Data Factory.

- The advantage of using Azure Pipelines is close ties with the ML model code. You can trigger the training pipeline easily with code changes through CI/CD.

- The benefit of Data Factory is that each pipeline can provision the required compute resources. Data Factory doesn't hold on to the Azure Pipelines agents to run ML training, which could congest the normal CI/CD flow.

## Considerations

The following considerations apply to this solution:

### Availability

ML-based applications typically require one set of resources for training and another for serving. Training resources generally don't need high availability, as live production requests don't directly use these resources. Resources required for serving requests need to have high availability.

### Operations

This solution is divided into three operational areas:

- In *IoT operations*, an ML model on the edge device uses real-time images from [connected cameras](../../example-scenario/iot/introduction-to-solutions.yml) to inference video frames. The edge device also sends cached video streams to cloud storage to use for auditing and model retraining. After ML retraining, Azure IoT Hub updates the edge device with the new ML inferencing module.

- [MLOps](/azure/machine-learning/concept-model-management-and-deployment) uses DevOps practices to orchestrate the end-to-end smart factory solution. MLOps is a life cycle management approach that automates the process of using ML models for complex decision-making, or *productionizing* the models. The key to MLOps is tight coordination among the teams who build, train, evaluate, and deploy the ML models.

- This example uses a *human-in-the-loop* approach, which notifies people to intervene at certain steps in the automation. In human-in-the-loop transactions, workers check and evaluate the results of the machine learning predictions. Human interventions become part of the intelligence the ML model captures, and help validate the model.

  In this example, Azure Machine Learning sends observability metrics and model telemetry to Azure Monitor, enabling the IoT engineers and data scientists to optimize operations. IoT Hub ingests high volumes of telemetry from the cameras, and sends the metrics to Azure Monitor, so the site engineer can investigate and troubleshoot.

  The following human roles are part of this end-to-end smart factory solution:

  - *Data labelers* label data sets for retraining to complete the loop of the end-to-end solution. The data labeling process is especially important for image data, as a first step in creating a reliable model trained through algorithms. In this example, Azure Data Factory organizes the video frames into logical positive and false positive groupings, which makes the data labeler's work easier.

  - *Data scientists* use the labeled data sets to train the algorithms to make correct real-life predictions. As part of MLOps, data scientists use Azure DevOps with GitHub Actions or Azure Pipelines in a CI process that automatically trains and validates a model. Training can be triggered manually, or automatically by checking in new data or training scripts. Data scientists work in an [Azure Machine Learning workspace](/azure/machine-learning/concept-workspace) that can automatically register, deploy, and manage models.

  - *IoT engineers* use [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) to publish [IoT Edge modules](/azure/iot-edge/about-iot-edge) in containers to Container Registry. Engineers can deploy and scale the infrastructure on demand by using a CD pipeline.

  - *Site engineers* receive the incident notifications sent by Logic Apps, and manually validate the results or predictions of the ML model. For example, the site engineer might examine a valve that the model predicted had failed.

  - *Safety auditors* review archived video streams to detect anomalies, assess compliance, and confirm results when questions arise about a model's predictions.

### Performance

IoT devices have limited memory and processing power, so it's important to limit the size of the container sent to the device. This example uses an IoT device that can do model inference and produce results in an acceptable amount of time.

To optimize performance for training models, this example architecture uses [Azure Premium Blob Storage](https://azure.microsoft.com/services/storage/blobs/). This performance tier is designed for workloads that require very fast response times and high transaction rates like this human-in-the-loop video labeling scenario.

Performance considerations also apply to the data ingestion pipeline. Data Factory maximizes data movement by providing a highly performant, cost-effective solution.

### Scalability

Most of the components used in this example scenario are managed services that automatically scale. The [availability of the services](https://azure.microsoft.com/global-infrastructure/services/?products=machine-learning-service,virtual-machines&regions=all) used in this example varies by region.

Scalability for the IoT application depends on [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling). Factors to consider include the maximum daily quota of messages into IoT Hub, the quota of connected devices in an IoT Hub instance, and the ingestion and processing throughput.

In ML, scalability refers to scale-out clusters used to train models against large datasets. Scalability also enables the ML model to meet the demands of the applications that consume it. To meet these needs, the ML cluster must provide scale-out on CPUs and on graphics processing unit (GPU)-enabled nodes.

For general guidance on designing scalable solutions, see the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency) in the Azure Architecture Center.

### Security

Access management in Dataverse and other Azure services helps ensure that only authorized users can access the environment, data, and reports. This solution uses Azure Key Vault to manage passwords and secrets. Storage is encrypted using [customer-managed keys](/azure/storage/common/customer-managed-keys-overview).

For general guidance on designing secure IoT solutions, see the [Azure Security Documentation](/azure/security) and the [Azure IoT reference architecture](../iot.yml).

## Pricing

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. For other considerations, see [Cost Optimization](/azure/architecture/framework/cost/index).

Azure Machine Learning also deploys Container Registry, Azure Storage, and Azure Key Vault services, which incur extra costs. For more information, see [How Azure Machine Learning works: Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture). Azure Machine Learning pricing includes charges for the virtual machines that are used to train the model in the cloud.

## Next steps

- [How Azure Machine Learning works: Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture)
- [Azure IoT for safer workplaces](https://azure.microsoft.com/solutions/safer-workplaces-iot/)
- [Dow Chemical uses vision AI at the edge to boost employee safety and security with Azure](https://customers.microsoft.com/story/1349423518578860629-dow-chemicals-azure-video-analyzer)
- [Build intelligent applications infused with world-class AI](https://mybuild.microsoft.com/sessions/2ba55238-d398-46f9-9ff2-eafcd9d69df3)
- [Edge Object Detection GitHub sample](https://github.com/Azure-Samples/MLOpsManufacturing/tree/main/samples/edge-object-detection)

## Related resources

- [Azure IoT reference architecture](../iot.yml)
- [Azure Machine Learning decision guide for optimal tool selection](../../example-scenario/mlops/aml-decision-tree.yml)
- [DevOps Checklist](../../checklist/dev-ops.md)
- [MLOps maturity model](../../example-scenario/mlops/mlops-technical-paper.yml)

