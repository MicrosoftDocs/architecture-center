For manufacturers, the promise of digital transformation lies in breaking down silos and gaining a holistic view across the entire operation, from asset data to insights across all manufacturing processes. An IIoT solution relies on real-time and historical data from industrial devices and control systems located in manufacturing facilities. These include PLCs (Programmable Logic Controller), industrial equipment, SCADA (Supervisory Control and Data Acquisition) systems, MES (Manufacturing Execution System), and Process Historians.

A modern IIoT solution goes beyond moving existing industrial processes and tools to the cloud. It involves transforming your operations and processes, embracing cloud native services, and leveraging the power of machine learning and the intelligent edge to optimize industrial processes.

[ ![Industrial IoT Matrutiy model.](images/iiot-maturity.png) ](images/iiot-maturity.png#lightbox)

There are multiple stages in each of the three key phases shown above. Each stage of an IIoT Solution consists of multiple design patterns. We typically start our IIoT journey with Connectivity as the first step. Computerization is the prerequisite step and it referes to enabling sensors and actuators to monitor production processes. We will be highligting four key stages for a typical IIoT solution:

## Connectivity 


| Pattern | Summary |
|-------------|-------------|
| [OPC UA Server and Edge Gateway](./iiot-connectivity-patterns.md#opc-ua-server-and-edge-gateway) | Connecting to manufacturing machines using OPC UA standards and an IoT edge gateway |
| [Protocol Translation and Edge Gateway](./iiot-connectivity-patterns.md#protocol-translation-and-edge-gateway) | Connecting to manufacturing machines over non-standard protocols using IoT edge gateway |
| [Cloud connector from Industrial Connectivity Software or Historian](./iiot-connectivity-patterns.md#cloud-connector-from-industrial-connectivity-software-or-historian)  | Connecting to manufacturing machines using cloud connector component availabe in Industrial connectivity softwares |
| [Connecting to Layer 2 and IoT Edge Gateways](./iiot-connectivity-patterns.md#connecting-to-layer-2-and-iot-edge-gateways)  | Connecting to manufacturing machines in layer 2 of Purdue model using multiple IoT edge gateway(s) connected in a hierarchy |
| [Resilient Edge Gateway](./iiot-connectivity-patterns.md#resilient-edge-gateway)  | Provide hardware resiliency for IoT edge gateway virtual machines |
| [Cloud Gateway Options](./iiot-connectivity-patterns.md#cloud-gateway-options)  | Select a cloud gateway for connectivity|
| [Scale to multiple factories and business units](./iiot-connectivity-patterns.md#scale-to-multiple-factories-and-business-units)  | Scaling connectivity patterns to multiple factories and business units |
| [Constrained devices and add-on sensors](./iiot-connectivity-patterns.md#constrained-devices-and-add-on-sensors)  | Connecting low power & low compute devices to manufacturing machines as additional sensors |
    
## Visibility

| Pattern | Summary |
|-------------|-------------|
| [Time Series Analysis](./iiot-visibility-patterns.md#time-series-analysis)  | Analyze IoT telemetry data using time series techniques|
| [Anomaly Detection and Root Cause Analysis](./iiot-visibility-patterns.md#anomaly-detection-and-root-cause-analysis) | Detect anomalies and identify root cause analysis for anomaly incidents |

## Transparency

| Pattern | Summary |
|-------------|-------------|
| [Business KPI Calculation Engine](./iiot-transparency-patterns.md#business-kpi-calculation-engine) | Calculate business metrics using IoT telemetry and other business system(s) data |


## Predictions

| Pattern | Summary |
|-------------|-------------|
| [Predict process and equipment failures using machine learning (Batch)](./iiot-prediction-patterns.md#predict-process-and-equipment-failures-using-machine-learning-batch) | Predict process and equipment failures using a batch process |
| [Predict process and equipment failures using machine learning (Near real-time)](./iiot-prediction-patterns.md#predict-process-and-equipment-failures-using-machine-learning-near-real-time) | Predict process and equipment failures using an api |
| [Augment manual quality inspection using deep learing based image recognition](./iiot-prediction-patterns.md#augment-manual-quality-inspection-using-deep-learing-based-image-recognition) | Automate quality inspection in manufacturing using custom vision|


## Next steps

- [Industrial IoT Connectivity Patterns](./iiot-connectivity-patterns.md)

- [Industrial IoT Visibiilty Patterns](./iiot-visibility-patterns.md)

- [Industrial IoT Transparency Patterns](./iiot-transparency-patterns.md)

- [Industrial IoT Prediction Patterns](./iiot-prediction-patterns.md)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)