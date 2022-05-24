Prediction extends operational visibility by leveraging machine learning and AI to optimize production, scheduling, enable predictive maintenance and predictive quality, which helps reduce unexpected downtime, reduce cycle time and helps achieve operational excellence.

Following section includes common prediction patterns for industrial solutions. 

## Predict process and equipment failures using machine learning (Batch)

Predict process and equipment failures using a batch process.

[ ![Predict equipment failures using machine learing pipelines.](images/ml-batch.png) ](images/ml-batch.png#lightbox)

- Dataflow
    1. EdgeHub sends current process & equipment condition data to IoT Hub/ Central using AMQP or MQTT. IoT Hub / Central sends module updates to the edge and provides edge management control plan.
    1. Data from IoT Hub / Central goes to Data Explorer using Data Connection in IoT Hub or Data Export in IoT Central.
    1. Data from IoT Hub / Central is also routed to a Data Lake for long term storage and model training.
    1. Synapse pipeline fetches the historical process and equipment failure data from on-premises systems.
    1. Synape pipeline stores the data in the Data Lake for model training.
    1. Machine learning service fetches the failure data, condition data from Data Lake, builds a model and publishes a  batch prediction pipeline endpoint.
    1. Another Synapse pipeline calls the machine learning batch prediction pipeline on a regular interval e.g. every 15 minutes.
    1. The batch prediction pipeline fetches the process & equipment condition data (e.g. last 15 minutes of data) from Data Explorer and performs failure prediction using the model.
    1. The batch prediction pipelines stores the prediction results in a SQL Database.
    1. PowerBI is connected with SQL Database for reporting and visualization of the predictions.

- Use this pattern when you:
    - Need to build custom machine learning models on structured (tabular) data.
    - Need to use raw telemetry data for feature engineering.
    - Perform predictions on on hourly or daily basis.

- Considerations
    - [No Code / Low Code Automated Machine Learning](/azure/machine-learning/concept-automated-ml)
    - [Understanding and building Machine Learning Pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline)
    - [Security baseline for Azure Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context)
    - [Manage and optimize Azure Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost)
    
- Deployment Sample
    - [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
    - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)


## Predict process and equipment failures using machine learning (Near real-time)

Predict process and equipment failures using an api.

[ ![Predict equipment failures in near real-time using machine learing pipelines and deployment endpoints.](images/ml-realtime.png) ](images/ml-realtime.png#lightbox)

- Dataflow
    1. EdgeHub sends current process & equipment condition data to IoT Hub/ Central using AMQP or MQTT. IoT Hub / Central sends module updates to the edge and provides edge management control plan.
    1. Data from IoT Hub / Central goes to Data Explorer using Data Connection in IoT Hub or Data Export in IoT Central.
    1. Data from IoT Hub / Central is also routed to a Data Lake for long term storage and model training.
    1. Synapse pipeline fetches the historical process and equipment failure data from on-premises system.
    1. Synapse pipeline stores the data in the Data Lake for model training.
    1. Machine learning service fetches the historical condition data from Data Explorer.
    1. Machine learning service fetches the historical failure data from Data Lake.
    1. Machine Learning service builds a model and deploys a real-time endpoint on a managed kubernetes cluster.
    1. Each new message from IoT Hub / Central that contains current process & equipment condition is routed to an Event Hub for failure prediction.
    1. Function app with Event Hub trigger fetches the condition message
    1. Function app passes the message to real-time prediction endpoint which returns the prediction result.
    1. Function app stores the prediction result in SQL Database for reporting.
    1. Function app publishes the latest prediction via Web PubSub Service.
    1. Web App subscribted to Web PubSub service get the message instantly and updates the UI for real-time reporting.
    1. PowerBI is connected with SQL Database for reporting and visualization of historic predictions.


- Use this pattern when you:
    - Need to build custom machine learning models on structured (tabular) data.
    - Need to use raw telemetry data for feature engineering.
    - Perform predictions within single digit minutes.
    - Need custom dashboards to provide action recommendations that may impact current running manufacturing.process.

- Considerations
    - For prediction within seconds or milliseconds, consider [packaging the model as an edge module and deploying at th edge](/azure/iot-edge/tutorial-machine-learning-edge-06-custom-modules?view=iotedge-2020-11).
    - [No Code / Low Code Automated Machine Learning](/azure/machine-learning/concept-automated-ml)
    - [Understanding and building Machine Learning Pipelines](/azure/machine-learning/concept-train-machine-learning-model#machine-learning-pipeline)
    - [Security baseline for Azure Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline?context=/azure/machine-learning/context/ml-context)
    - [Manage and optimize Azure Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost)
    - [Web PubSub vs. SignalR](/azure/azure-web-pubsub/resource-faq#how-do-i-choose-between-azure-signalr-service-and-azure-web-pubsub-service)
    - [Choosing compute target for deploying machine learning models](/azure/machine-learning/how-to-deploy-and-where?tabs=azcli#choose-a-compute-target)
    - The near real-time inference in cloud only. Consider deploying the model to IoT Edge to support offline and edge scenarios.
   
    
- Deployment Sample
     - [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
    - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)
    
## Augment manual quality inspection using deep learing based image recognition

Automate quality inspection in manufacturing using custom vision.

[ ![Augment manual quality inspection using deep learing based image recognition models on the edge.](images/ml-imagerecognition.png) ](images/ml-imagerecognition.png#lightbox)

- Dataflow
    1.  Machine Learning service builds a defect detection model using initial labeled images stored in Data Lake. It then builds a container image and pushes the image to a container registry.
    1. IoT Edge module deployment contains multiple modules including defect detection module (created above), prediction store (e.g. sql edge), prediction dashboard (custom web app or grafana) and a file upload module to upload images for model re-training. These modules are packaged as a container image, stored in a container registry and pulled by the edge via module deployments.
    1. The defect detection module flags the defect and sends the prediction message to IoT Hub / Central using edgeHub. IoT Hub / Central sends module updates to the edge and provides edge management control plan.
    1. Data from IoT Hub / Central goes to Data Explorer using Data Connection in IoT Hub or Data Export in IoT Central.
    1. PowerBI is connected with Data Explorer to historic prediction reporting.
    1. Data from IoT Hub / Central is also routed to a Data Lake for long term storage and model training.
    1. File upload module sends the defect detection images to Data Lake for model re-training.
    1. Machine Learning service re-trains the model using the new data collected in Data Lake.

- Use this pattern when you:
    - Need to build custom machine learning models on image data.
    - Need to build pipeline to get data from external device sources like a camera.
    - Perform near real-time predictions within milliseconds
    - Need custom dashboards to provide action recommendations that may impact current running manufacturing process.

- Considerations
    - Using partner solutions that combine hardware + software can help accelerate time to value. Consider cost of scaling such solution.
    - Building custom solution can be cost effective for scale and help build IP. Consider complexity of managing such solution.
    - See [Vision AI solutions with Azure IoT Edge](/azure/architecture/guide/iot-edge-vision/) for details around use cases, camera selection and edge integrations.
    - See [First principles of Computer Vision](https://www.youtube.com/channel/UCf0WB91t8Ky6AuYcQV0CcLw) to deep dive into how computer vision works
    - Consider using dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/en-us/products/azure-stack/edge/#overview) with GPU's to improve both image preprocessing and inference speeds.
    
- Deployment Sample
    - [Vision on Edge (VoE)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)
    - [Azure Machine Learning anywhere with Kubernetes](https://github.com/Azure/AML-Kubernetes)


## Next steps

- Try the deployment sample for  [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)

- Try the deployment sample for [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)

- [Machine Learning Overview](/azure/machine-learning/overview-what-is-azure-machine-learning)

- [No Code / Low Code Automated Machine Learning](/azure/machine-learning/concept-automated-ml)

- [Vision on Edge (VoE)](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/factory-ai-vision)

- [Azure Machine Learning anywhere with Kubernetes](https://github.com/Azure/AML-Kubernetes)


## Related resources

- [Industrial IoT Patterns Overview](./iiot-patterns-overview.md)

- [Industrial IoT Connectivity Patterns](./iiot-connectivity-patterns.md)

- [Industrial IoT Visibiilty Patterns](./iiot-visibility-patterns.md)

- [Industrial IoT Transparency Patterns](./iiot-transparency-patterns.md)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)