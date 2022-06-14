Prediction extends operational visibility by using machine learning and AI to optimize production, scheduling, and enable predictive maintenance and predictive quality. This optimization helps reduce unexpected downtime, reduce cycle time, and achieve operational excellence.

The following section includes common prediction patterns for industrial solutions.

## Predict process and equipment failures by using batch process machine learning

Predict process and equipment failures by using a batch process.

:::image type="content" source="images/ml-batch.png" alt-text="Diagram that shows an architecture used to predict equipment failures using machine learning pipelines." lightbox="images/ml-batch.png":::

- Dataflow
    1. edgeHub sends the current process and equipment condition data to Azure IoT Hub or Azure IoT Central by using AMQP or MQTT. Then, IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Data from IoT Hub or Azure IoT Central is also routed to Azure Data Lake Storage for long term storage and model training.
    4. An Azure Synapse Analytics pipeline fetches the historical process and equipment failure data from on-premises systems.
    5. An Azure Synapse pipeline stores the data in Data Lake Storage for model training.
    6. The Azure Machine Learning service fetches the failure data, the condition data from Data Lake Storage, and then builds a model and publishes a batch prediction pipeline endpoint.
    7. Another Azure Synapse pipeline calls the machine learning batch prediction pipeline on a regular interval, for example every 15 minutes.
    8. The batch prediction pipeline fetches the process and equipment condition data—for example, the last 15 minutes of data—from Azure Data Explorer and uses the model to perform failure predictions.
    9. The batch prediction pipeline stores the prediction results in a database in Azure SQL Database.
    10. Power BI is connected with SQL Database for reporting and visualization of the predictions.

- Use this pattern when you:
  - Need to build custom machine learning models on structured, or tabular, data.
  - Need to use raw telemetry data for feature engineering.
  - Perform predictions on an hourly or daily basis.

- Considerations
  - [No code or low code automated machine learning](/azure/machine-learning/concept-automated-ml)
  - [Understanding and building Machine Learning pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline)
  - [Security baseline for Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context)
  - [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost)

- Deployment Sample
  - [Exploratory data analysis for failure predictions by using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
  - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)

## Predict process and equipment failures by using near real-time machine learning

Predict process and equipment failures by using an API.

:::image type="content" source="images/ml-realtime.png" alt-text="Predict equipment failures in near real-time using machine learning pipelines and deployment endpoints." lightbox="images/ml-realtime.png":::

- Dataflow
    1. edgeHub sends the current process and equipment condition data to IoT Hub or Azure IoT Central by using AMQP or MQTT. Then, IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Data from IoT Hub or Azure IoT Central is also routed to Data Lake Storage for long term storage and model training.
    4. An Azure Synapse pipeline fetches the historical process and equipment failure data from on-premises systems.
    5. The Azure Synapse pipeline stores the data in Data Lake Storage for model training.
    6. The Machine Learning service fetches the historical condition data from Azure Data Explorer.
    7. Machine Learning fetches the historical failure data from Azure Data Lake.
    8. Machine Learning builds a model and deploys a real-time endpoint on a managed kubernetes cluster.
    9. Each new message from IoT Hub or Azure IoT Central that contains a current process and equipment condition is routed to Azure Event Hubs for failure prediction.
    10. A function app with an Event Hubs trigger fetches the condition message.
    11. The function app passes the message to a real-time prediction endpoint, which returns the prediction result.
    12. The function app stores the prediction result in a database in Azure SQL Database for reporting.
    13. The function app publishes the latest prediction via the Azure Web PubSub service.
    14. A web app subscribed to Web PubSub gets the message instantly and updates the UI for real-time reporting.
    15. Power BI connects with SQL Database for reporting and visualization of historic predictions.

- Use this pattern when you:
  - Need to build custom machine learning models on structured, or tabular, data.
  - Need to use raw telemetry data for feature engineering.
  - Perform predictions within single digit minutes.
  - Need custom dashboards to provide action recommendations that might impact currently running manufacturing processes.

- Considerations
  - For prediction within seconds or milliseconds, consider [packaging the model as an edge module and deploying at the edge](/azure/iot-edge/tutorial-machine-learning-edge-06-custom-modules?view=iotedge-2020-11).
  - [No code or low code automated machine learning](/azure/machine-learning/concept-automated-ml)
  - [Understanding and building Machine Learning pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline)
  - [Security baseline for Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context)
  - [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost)
  - [Web PubSub vs. Azure SignalR Service](/azure/azure-web-pubsub/resource-faq#how-do-i-choose-between-azure-signalr-service-and-azure-web-pubsub-service)
  - [Choosing a compute target for deploying machine learning models](/azure/machine-learning/how-to-deploy-and-where?tabs=azcli#choose-a-compute-target)
  - The near real-time inference is only in the cloud. Consider deploying the model to IoT Edge to support offline and edge scenarios.

- Deployment Sample
  - [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
  - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)

## Augment a manual quality inspection by using deep learning based image recognition

Automate a quality inspection in manufacturing by using custom vision.

:::image type="content" source="images/ml-imagerecognition.png" alt-text="Augment manual quality inspection using deep learning based image recognition models on the edge." lightbox="images/ml-imagerecognition.png":::

- Dataflow
    1. The Machine Learning service builds a defect detection model by using initial labeled images stored in Data Lake Storage. The service then builds a container image and pushes the image to a container registry.
    2. The IoT Edge module deployment contains multiple modules, including a defect detection module, prediction store, prediction dashboard, and a file upload module to upload images for model retraining. These modules are packaged as a container image, stored in a container registry, and then pulled by the edge via module deployments.
    3. The defect detection module flags the defect and sends the prediction message to IoT Hub or Azure IoT Central by using edgeHub. IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    5. Power BI connects with data explorer for historic prediction reporting.
    6. Data from IoT Hub or Azure IoT Central is also routed to Data Lake Storage for long term storage and model training.
    7. The file upload module sends the defective detection images to Data Lake Storage for model retraining.
    8. The Machine Learning service retrains the model by using the new data collected in Data Lake Storage.

- Use this pattern when you:
  - Need to build custom machine learning models on image data.
  - Need to build a pipeline to get data from external device sources like a camera.
  - Perform near real-time predictions within milliseconds.
  - Need custom dashboards to provide action recommendations that might impact current running manufacturing processes.

- Considerations
  - Use partner solutions that combine hardware and software to help accelerate time to value. Consider the cost of scaling such a solution.
  - Building custom solutions can be cost effective for scale and help build your intellectual property. Consider the complexity of managing such a solution.
  - See [Vision AI solutions with IoT Edge](/azure/architecture/guide/iot-edge-vision/) for details around use cases, camera selection, and edge integrations.
  - See [First principles of Computer Vision](https://www.youtube.com/channel/UCf0WB91t8Ky6AuYcQV0CcLw) to deep dive into how computer vision works.
  - Consider using dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview) with GPUs to improve both image preprocessing and inference speeds.

- Deployment Samples
  - [Vision on Edge (VoE)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
  - [Machine Learning anywhere with Kubernetes](https://github.com/Azure/AML-Kubernetes)

## Next steps

- [Machine Learning overview](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Introduction to machine learning](/learn/modules/introduction-to-machine-learning)
- [Create machine learning models](/learn/paths/create-machine-learn-models)
- [Deploy batch inference pipelines with Azure Machine Learning](/learn/modules/deploy-batch-inference-pipelines-with-azure-machine-learning/)

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.md)

- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.md)

- [Industrial IoT visibility patterns](./iiot-visibility-patterns.md)

- [Industrial IoT transparency patterns](./iiot-transparency-patterns.md)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
