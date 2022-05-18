This example architecture shows an end-to-end approach to internet-of-things (IoT) computer vision in manufacturing. Fully automated smart factories use artificial intelligence (AI) and machine learning (ML) to analyze data, run systems, and improve processes over time.

In this example, cameras send images to an Azure Video Analyzer edge device that runs an ML model. The model calculates inferences, and sends actionable output to the cloud for further processing. Human interventions are part of the intelligence the ML model captures. The ML process is a continuous cycle of training, testing, tuning, and validating the ML algorithms.

## Potential use cases

Manufacturing processes use IoT computer vision in safety and quality assurance applications. IoT computer vision systems can:

- Help ensure compliance with manufacturing guidelines like proper labelling.
- Identify manufacturing defects like surface unevenness.
- Enhance security by monitoring building or area entrances.
- Uphold worker safety by detecting personal protective equipment (PPE) usage and other safety practices.

## Architecture

[![Diagram showing the end-to-end approach to computer vision from the edge to the cloud and back.](_images/end-to-end-smart-factory-01.png)](_images/end-to-end-smart-factory-01.png#lightbox)

### Dataflow

1. The Video Analyzer edge module captures the live video stream, breaks it down into frames, and performs inference on the image data to determine if an incident has occurred.
1. Video Analyzer uploads the raw video files and sends them to Azure Storage, which acts as a raw media store.
1. The edge module sends the inferencing results and metadata to Azure IoT Hub, which acts as a central message hub for communications in both directions.
1. Azure Logic Apps monitors IoT Hub for messages about incident events. Logic Apps routes inferencing results and metadata to Microsoft Dataverse for storage.
1. When an incident occurs, Logic Apps sends SMS and e-mail notifications to the site engineer. The site engineer uses a mobile app based on Power Apps to acknowledge and resolve the incident.
1. Power Apps pulls inferencing results and metadata from Dataverse and raw video files from Blob Storage to display relevant information about the incident. Power Apps updates Dataverse with the incident resolution that the site engineer provided. This step acts as human-in-the-loop validation for model retraining purposes.
1. Azure Data Factory is the data orchestrator that fetches raw video files from the raw media store, and gets the corresponding inferencing results and metadata from Dataverse.
1. Data Factory stores the raw video files, plus the metadata, in Azure Data Lake, which serves as a video archive for auditing purposes.
1. Data Factory breaks raw video files into frames, converts the inferencing results into labels, and uploads the data into Blob Storage, which acts as the ML data store.
1. Changes to the model code automatically trigger the Azure Pipelines model orchestrator pipeline, which operators can also trigger manually. Code changes also start the ML model training and validation process in Azure Machine Learning.
1. Azure Machine Learning starts training the model by validating the data from the ML data store and copying the required datasets to Azure Premium Blob Storage, a performance tier that provides a data cache for faster model training.
1. Azure Machine Learning uses the dataset in the Premium data cache to train the model, validate the trained model's performance, score it against the newly trained model, and register the model into the Azure Machine Learning registry.
1. The Azure Pipelines model orchestrator reviews the performance of the newly trained ML model and determines if it's better than previous models. If the new model performs better, the pipeline downloads the model from Azure Machine Learning and builds a new version of the ML inferencing module to publish in Azure Container Registry.
1. When a new ML inferencing module is ready, Azure Pipelines deploys the module container from Container Registry to the IoT Edge module in IoT Hub.
1. IoT Hub updates the Video Analyzer edge device with the new ML inferencing module.

### Components

- [Azure Video Analyzer](https://azure.microsoft.com/products/video-analyzer) is an AI service for quickly building an AI-powered video analytics solution to extract actionable insights from videos, whether stored or streaming.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) is a managed service that enables reliable and secure bidirectional communications between millions of IoT devices and a cloud-based back end. It provides per-device authentication, message routing, integration with other Azure services, and management features to control and configure the devices.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) is a serverless cloud service for creating and running automated workflows that integrate apps, data, services, and systems. Developers can use a visual designer to schedule and orchestrate common task workflows.  Logic Apps has [connectors](/connectors) for many popular cloud services, on-premises products, and other software as a service applications. In this solution, Logic Apps runs the automated notification workflow that sends SMS and email alerts to site engineers.
- [Power Apps](https://powerapps.microsoft.com) is a data platform and a suite of apps, services, and connectors. It serves as a rapid application development environment. The underlying data platform is Microsoft Dataverse.
- [Dataverse](/power-apps/maker/data-platform/data-platform-intro) is a cloud-based storage platform for Power Apps. Dataverse supports human-in-the-loop notifications and stores metadata associated with the MLOps data pipeline.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is scalable and secure object storage for unstructured data. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. In this solution it provides a local data store for the ML data store and a Premium data cache for training the ML model. The premium tier of Blob Storage is for workloads that require fast response times and high transaction rates, like the human-in-the-loop video labeling in this example.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a massively scalable and secure storage service for high-performance analytics workloads. The data typically comes from multiple heterogeneous sources and can be structured, semi-structured, or unstructured. Azure Data Lake Storage Gen2 combines Azure Data Lake Storage Gen1 capabilities with Blob Storage, and provides file system semantics, file-level security, and scale. It also offers the tiered storage, high availability, and disaster recovery capabilities of Blob Storage. In this solution, Data Lake Storage provides the archival video store for the raw video files and metadata.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a hybrid, fully managed, serverless solution for data integration and transformation workflows. It provides a code-free UI and an easy-to-use monitoring panel. It uses pipelines for data movement, and mapping data flows to perform various transformation tasks such as extract, transform, and load (ETL), and extract, load, and transform (ELT). In this example, Data Factory orchestrates the data in an ETL pipeline to the inferencing data, which it stores for retraining purposes.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an enterprise-grade machine learning service for building and deploying models quickly. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs.
- [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines), part of [Azure DevOps](https://azure.microsoft.com/services/devops) team-based developer services, creates continuous integration (CI) and continuous deployment (CD) pipelines. In this example, the Azure Pipelines model orchestrator validates ML code, triggers serverless task pipelines, compares ML models, and builds the inferencing container.
- [Container Registry](https://azure.microsoft.com/services/container-registry) creates and manages the Docker registry to build, store, and manage Docker container images, including containerized ML models.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects telemetry from Azure resources, so teams can proactively identify problems and maximize performance and reliability.

### Alternatives

Instead of using the data pipeline to break down the video stream into image frames, you can deploy an Azure Blob Storage module onto the IoT Edge device. The inferencing module then uploads the inferenced image frames to the storage module on the edge device. The storage module determines when to upload the frames directly to the ML data store. The advantage of this approach is that it removes a step from the data pipeline. The tradeoff is that the edge device is tightly coupled to Azure Blob Storage.

For model orchestration, you can use either Azure Pipelines or Azure Data Factory.

- The Azure Pipelines advantage is its close ties with the ML model code. You can trigger the training pipeline easily with code changes through CI/CD.
- The benefit of Data Factory is that each pipeline can provision the required compute resources. Data Factory doesn't hold on to the Azure Pipelines agents to run ML training, which could congest the normal CI/CD flow.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

ML-based applications typically require one set of resources for training and another for serving. Training resources generally don't need high availability, as live production requests don't directly use these resources. Resources required for serving requests need to have high availability.

### Operations

This solution is divided into three operational areas:

- In *IoT operations*, an ML model on the edge device uses real-time images from [connected cameras](../../guide/iot-edge-vision/camera.md) to inference video frames. The edge device also sends cached video streams to cloud storage to use for auditing and model retraining. After ML retraining, Azure IoT Hub updates the edge device with the new ML inferencing module.

- [MLOps](/azure/machine-learning/concept-model-management-and-deployment) uses DevOps practices to orchestrate model training, testing, and deployment operations. MLOps life cycle management automates the process of using ML models for complex decision-making, or *productionizing* the models. The key to MLOps is tight coordination among the teams that build, train, evaluate, and deploy the ML models.

- *Human-in-the-loop* operations notify people to intervene at certain steps in the automation. In human-in-the-loop transactions, workers check and evaluate the results of the machine learning predictions. Human interventions become part of the intelligence the ML model captures, and help validate the model.

  The following human roles are part of this solution:

  - *Site engineers* receive the incident notifications that Logic Apps sends, and manually validate the results or predictions of the ML model. For example, the site engineer might examine a valve that the model predicted had failed.

  - *Data labelers* label data sets for retraining, to complete the loop of the end-to-end solution. The data labeling process is especially important for image data, as a first step in training a reliable model through algorithms. In this example, Azure Data Factory organizes the video frames into positive and false positive groupings, which makes the data labeler's work easier.

  - *Data scientists* use the labeled data sets to train the algorithms to make correct real-life predictions. Data scientists use MLOps with GitHub Actions or Azure Pipelines in a CI process to automatically train and validate a model. Training can be triggered manually, or automatically by checking in new training scripts or data. Data scientists work in an [Azure Machine Learning workspace](/azure/machine-learning/concept-workspace) that can automatically register, deploy, and manage models.

  - *IoT engineers* use Azure Pipelines to publish [IoT Edge modules](/azure/iot-edge/about-iot-edge#iot-edge-modules) in containers to Container Registry. Engineers can deploy and scale the infrastructure on demand by using a CD pipeline.

  - *Safety auditors* review archived video streams to detect anomalies, assess compliance, and confirm results when questions arise about a model's predictions.

  In this solution, IoT Hub ingests telemetry from the cameras and sends the metrics to Azure Monitor, so site engineers can investigate and troubleshoot. Azure Machine Learning sends observability metrics and model telemetry to Azure Monitor, helping the IoT engineers and data scientists to optimize operations.

### Performance

IoT devices have limited memory and processing power, so it's important to limit the size of the model container sent to the device. Be sure to use an IoT device that can do model inference and produce results in an acceptable amount of time.

To optimize performance for training models, this example architecture uses [Azure Premium Blob Storage](https://azure.microsoft.com/services/storage/blobs/). This performance tier is designed for workloads that require very fast response times and high transaction rates, like the human-in-the-loop video labeling scenario.

Performance considerations also apply to the data ingestion pipeline. Data Factory maximizes data movement by providing a highly performant, cost-effective solution.

### Scalability

Most of the components used in this solution are managed services that automatically scale.

Scalability for the IoT application depends on [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling). Factors to consider include the maximum daily quota of messages into IoT Hub, the quota of connected devices in an IoT Hub instance, and the ingestion and processing throughput.

In ML, scalability refers to scale-out clusters used to train models against large datasets. Scalability also enables the ML model to meet the demands of the applications that consume it. To meet these needs, the ML cluster must provide scale-out on CPUs and on graphics processing unit (GPU)-enabled nodes.

For general guidance on designing scalable solutions, see the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency) in the Azure Architecture Center.

### Security

Access management in Dataverse and other Azure services helps ensure that only authorized users can access the environment, data, and reports. This solution uses Azure Key Vault to manage passwords and secrets. Storage is encrypted using [customer-managed keys](/azure/storage/common/customer-managed-keys-overview).

For general guidance on designing secure IoT solutions, see the [Azure Security Documentation](/azure/security) and the [Azure IoT reference architecture](../iot.yml#security).

## Pricing

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. For other considerations, see [Cost optimization](/azure/architecture/framework/cost/index).

Azure Machine Learning also deploys Container Registry, Azure Storage, and Azure Key Vault services, which incur extra costs. For more information, see [How Azure Machine Learning works: Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture).

Azure Machine Learning pricing includes charges for the virtual machines (VMs) used to train the model in the cloud. For information about availability of Azure Machine Learning and VMs per Azure region, see [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=machine-learning-service,virtual-machines&regions=all).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal Author:

- [Wilson Lee](https://www.linkedin.com/in/simplywilson) | Principal Software Engineer

## Next steps

- [What is Azure Video Analyzer? (preview)](/azure/azure-video-analyzer/video-analyzer-docs/overview)
- [IoT concepts and Azure IoT Hub](/azure/iot-hub/about-iot-hub)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Power Apps?](/powerapps/powerapps-overview)
- [Microsoft Power Apps documentation](/power-apps)
- [What is Microsoft Dataverse?](/power-apps/maker/data-platform/data-platform-intro)
- [Microsoft Dataverse documentation](/power-apps/maker/data-platform)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [Azure Machine Learning documentation](/azure/machine-learning)
- [What is Azure DevOps?](/azure/devops/user-guide/what-is-azure-devops)
- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Container Registry documentation](/azure/container-registry)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure IoT for safer workplaces](https://azure.microsoft.com/solutions/safer-workplaces-iot/)
- [Dow Chemical uses vision AI at the edge to boost employee safety and security with Azure](https://customers.microsoft.com/story/1349423518578860629-dow-chemicals-azure-video-analyzer)
- [Edge Object Detection GitHub sample](https://github.com/Azure-Samples/MLOpsManufacturing/tree/main/samples/edge-object-detection)

## Related resources

- [How Azure Machine Learning works: Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture)
- [Vision AI solutions with Azure IoT Edge](../../guide/iot-edge-vision/index.md)
- [Azure IoT reference architecture](../iot.yml)
- [Azure Machine Learning decision guide for optimal tool selection](../../example-scenario/mlops/aml-decision-tree.yml)
- [DevOps Checklist](../../checklist/dev-ops.md)
- [MLOps maturity model](../../example-scenario/mlops/mlops-technical-paper.yml)
