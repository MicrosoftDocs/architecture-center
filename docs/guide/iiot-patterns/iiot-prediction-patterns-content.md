Prediction extends operational visibility by using machine learning and AI to optimize production, optimize scheduling, and enable predictive maintenance and predictive quality. This optimization helps reduce unexpected downtime, reduce cycle time, and achieve operational excellence.

The following section includes common prediction patterns for industrial solutions.

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-prediction-patterns.pptx) for the following patterns.*

## Predict process and equipment failures by using machine learning in batch processes

Predict process and equipment failures by using batch-process machine learning.

:::image type="content" source="images/machine-language-batch.png" alt-text="Diagram that shows an architecture used to predict equipment failures by using machine learning pipelines." lightbox="images/machine-language-batch.png":::

- Dataflow:
    1. The edgeHub module sends data about the current process and equipment conditions to Azure IoT Hub or Azure IoT Central by using AMQP or MQTT. Then, IoT Hub or Azure IoT Central sends module updates to the edge and provides a control plan for edge management.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Lake Storage receives data from IoT Hub or Azure IoT Central for long term storage and model training.
    4. An Azure Synapse Analytics pipeline fetches the historical data about process and equipment failure from the on-premises systems.
    5. An Azure Synapse pipeline stores the data in Data Lake Storage for model training.
    6. Azure Machine Learning fetches the failure and condition data from Data Lake Storage, and then builds a model and publishes a batch prediction pipeline endpoint.
    7. Another Azure Synapse pipeline calls the machine learning batch prediction pipeline at a regular interval—for example every 15 minutes.
    8. The batch prediction pipeline fetches the data about process and equipment condition from Azure Data Explorer and uses the model to perform failure predictions.
    9. The batch prediction pipeline stores the prediction results in a database in Azure SQL Database.
    10. Power BI connects to SQL Database for reporting and visualization of the predictions.

- Use this pattern when you:
  - Need to build custom machine learning models on structured or tabular data.
  - Need to use raw telemetry data for feature engineering.
  - Perform predictions on an hourly or daily basis.

- Considerations:
  - [What is automated machine learning (AutoML)?](/azure/machine-learning/concept-automated-ml)
  - [Understand and build Machine Learning pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline)
  - [Azure security baseline for Azure Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context)
  - [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost)

- Deployment samples:
  - [Exploratory data analysis for failure predictions by using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
  - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)

## Predict process and equipment failures by using near real-time machine learning

Predict process and equipment failures by using an API.

:::image type="content" source="images/machine-learning-realtime.png" alt-text="Diagram that shows how to predict equipment failures in near real-time by using machine learning pipelines and deployment endpoints." lightbox="images/machine-learning-realtime.png":::

- Dataflow:
    1. The edgeHub module sends data about the current process and equipment conditions to IoT Hub or Azure IoT Central by using AMQP or MQTT. Then, IoT Hub or Azure IoT Central sends module updates to the edge and provides a control plan for edge management.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Data Lake Storage receives data from IoT Hub or Azure IoT Central for long term storage and model training.
    4. An Azure Synapse pipeline fetches the historical data about process and equipment failure from the on-premises systems.
    5. The Azure Synapse pipeline stores the data in Data Lake Storage for model training.
    6. Machine Learning fetches the historical condition data from Azure Data Explorer.
    7. Machine Learning fetches the historical failure data from Data Lake Storage.
    8. Machine Learning builds a model and deploys a real-time endpoint on a managed Kubernetes cluster.
    9. Azure Event Hubs receives each new message from IoT Hub or Azure IoT Central that contains a current process and equipment condition for failure prediction.
    10. A function app with an Event Hubs trigger fetches the condition message.
    11. The function app passes the message to a real-time prediction endpoint, which returns the prediction result.
    12. The function app stores the prediction result in a database in Azure SQL Database for reporting.
    13. The function app publishes the latest prediction via the Azure Web PubSub service.
    14. A web app that's subscribed to Web PubSub gets the message instantly and updates the UI for real-time reporting.
    15. Power BI connects with SQL Database for reporting and visualization of historic predictions.

- Use this pattern when you:
  - Need to build custom machine-learning models on structured or tabular data.
  - Need to use raw telemetry data for feature engineering.
  - Perform predictions within single-digit minutes.
  - Need custom dashboards to provide action recommendations that might impact currently running manufacturing processes.

- Considerations:
  - For predictions within seconds or milliseconds, see [Packaging the model as an edge module and deploying at the edge](/azure/iot-edge/tutorial-machine-learning-edge-06-custom-modules?view=iotedge-2020-11).
  - For information about no-code or low-code automated machine learning, see [What is automated machine learning (AutoML)?](/azure/machine-learning/concept-automated-ml)
  - For information about Machine Learning pipelines, see [Understand and build Machine Learning pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline).
  - For information about security, see [Azure security baseline for Azure Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context).
  - For information about costs, see [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost).
  - For information about real-time web application services, see [How do I choose between Azure SignalR Service and Azure Web PubSub service?](/azure/azure-web-pubsub/resource-faq#how-do-i-choose-between-azure-signalr-service-and-azure-web-pubsub-service).
  - For information about selecting a compute target, see [Choosing a compute target for deploying machine learning models](/azure/machine-learning/how-to-deploy-managed-online-endpoints).
  - The near real-time inference is only in the cloud. Consider deploying the model to IoT Edge to support offline and edge scenarios.

- Deployment samples:
  - [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
  - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)

## Augment a manual quality inspection by using image recognition based on deep learning

Automate a quality inspection in manufacturing by using a custom vision.

:::image type="content" source="images/machine-learning-image-recognition.png" alt-text="Augment manual quality inspection by using deep learning based image recognition models on the edge." lightbox="images/machine-learning-image-recognition.png":::

- Dataflow:
    1. Machine Learning builds a defect detection model by using initial labeled images stored in Data Lake Storage. The service then builds a container image and pushes the image to a container registry.
    2. The IoT Edge deployment contains multiple modules, including modules for defect detection, prediction storage, a prediction dashboard, and file upload to upload images for model retraining. These modules are packaged as a container image, stored in a container registry, and pulled by the edge via module deployments.
    3. The defect detection module flags the defect and sends the prediction message to IoT Hub or Azure IoT Central by using the edgeHub module. IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    5. Power BI connects with Azure Data Explorer for historic prediction reporting.
    6. Data Lake Storage receives data from IoT Hub or Azure IoT Central for long term storage and model training.
    7. The file upload module sends the defective detection images to Data Lake Storage for model retraining.
    8. The Machine Learning service retrains the model by using the new data collected in Data Lake Storage.

- Use this pattern when you:
  - Need to build custom machine learning models on image data.
  - Need to build a pipeline to get data from external device sources, like a camera.
  - Perform near real-time predictions within milliseconds.
  - Need custom dashboards to provide action recommendations that might impact currently running manufacturing processes.

- Considerations:
  - Use partner solutions that combine hardware and software to help accelerate time to value. Consider the cost of scaling such a solution.
  - Building custom solutions can be cost-effective for scale and help build your intellectual property. Consider the complexity of managing such a solution.
  - For details around use cases, camera selection, and edge integrations, see [Vision AI solutions with IoT Edge](../../guide/iot-edge-vision/index.md).
  - For a deep dive into how computer vision works, see [First principles of Computer Vision](https://www.youtube.com/channel/UCf0WB91t8Ky6AuYcQV0CcLw).
  - Consider the use of dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview) with GPUs to improve both image preprocessing and inference speeds.

- Deployment samples:
  - [Vision on Edge (VoE)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
  - [Machine Learning anywhere with Kubernetes](https://github.com/Azure/AML-Kubernetes)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager

Other contributor:

- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

## Next steps

- [Create machine learning models](/training/paths/create-machine-learn-models)
- [Deploy batch inference pipelines with Azure Machine Learning](/training/modules/deploy-batch-inference-pipelines-with-azure-machine-learning)
- [Introduction to machine learning](/training/modules/introduction-to-machine-learning)
- [Machine Learning overview](/azure/machine-learning/overview-what-is-azure-machine-learning)

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)
- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.yml)
- [Industrial IoT visibility patterns](./iiot-visibility-patterns.yml)
- [Industrial IoT transparency patterns](./iiot-transparency-patterns.yml)
- [Solutions for the manufacturing industry](../../industries/manufacturing.md)
- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
