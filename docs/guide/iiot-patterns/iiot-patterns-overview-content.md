For manufacturers, the promise of digital transformation lies in breaking down silos and gaining a holistic view across their entire operation, from asset data to insights across all manufacturing processes. An Industrial IoT (IIoT) solution relies on real-time and historical data from industrial devices and control systems located in manufacturing facilities. These include programmable logic controllers (PLCs), industrial equipment, supervisory control and data acquisition (SCADA) systems, manufacturing execution systems (MES), and process historians.

A modern IIoT solution goes beyond moving existing industrial processes and tools to the cloud. It involves transforming your operations and processes, embracing cloud-native services, and by using the power of machine learning and the intelligent edge to optimize industrial processes.

:::image type="content" source="images/iiot-maturity.png" alt-text="Diagram that shows an industrial IoT maturity model." lightbox="images/iiot-maturity.png":::

There are multiple stages in each of the three key phases shown in the preceding diagram. Each stage of an IIoT solution consists of multiple design patterns. You start your IIoT journey with connectivity as the first step. Computerization is the prerequisite step and it refers to enabling sensors and actuators to monitor production processes. Four key stages for a typical IIoT solution are highlighted in this guide.

## Connectivity

| Pattern | Summary |
|-------------|-------------|
| [OPC UA server and edge gateway](./iiot-connectivity-patterns.yml#opc-ua-server-and-an-iot-edge-gateway) | Connect to manufacturing machines by using OPC UA standards and an Azure IoT Edge gateway. |
| [Protocol translation and edge gateway](./iiot-connectivity-patterns.yml#protocol-translation-and-an-iot-edge-gateway) | Connect to manufacturing machines over non-standard protocols by using an IoT Edge gateway. |
| [Cloud connector from industrial connectivity software or historian](./iiot-connectivity-patterns.yml#cloud-connector-from-industrial-connectivity-software-or-a-historian)  | Connect to manufacturing machines by using cloud connector components available in industrial connectivity software. |
| [Connect to layer 2 and IoT Edge gateways](./iiot-connectivity-patterns.yml#connect-to-layer-2-and-iot-edge-gateways)  | Connect to manufacturing machines in layer 2 of a Purdue model by using multiple IoT Edge gateways connected in a hierarchy. |
| [Resilient edge gateway](./iiot-connectivity-patterns.yml#resilient-edge-gateway)  | Provide hardware resiliency for IoT Edge gateway virtual machines. |
| [Cloud gateway options](./iiot-connectivity-patterns.yml#cloud-gateway-options)  | Select a cloud gateway for connectivity.|
| [Scale to multiple factories and business units](./iiot-connectivity-patterns.yml#scale-to-multiple-factories-and-business-units)  | Scale connectivity patterns to multiple factories and business units. |
| [Constrained devices and add-on sensors](./iiot-connectivity-patterns.yml#constrained-devices-and-add-on-sensors)  | Connect low-power and low-compute devices to manufacturing machines as extra sensors. |

## Visibility

| Pattern | Summary |
|-------------|-------------|
| [Time series analysis](./iiot-visibility-patterns.yml#time-series-analysis)  | Analyze IoT telemetry data by using time series techniques.|
| [Anomaly detection and root cause analysis](./iiot-visibility-patterns.yml#anomaly-detection-and-root-cause-analysis) | Detect anomalies and identify a root cause analysis for anomaly incidents. |

## Transparency

| Pattern | Summary |
|-------------|-------------|
| [Business KPI calculation engine](./iiot-transparency-patterns.yml#business-kpi-calculation-engine) | Calculate business metrics by using IoT telemetry and other business systems data. |

## Predictions

| Pattern | Summary |
|-------------|-------------|
| [Predict process and equipment failures by using near real-time machine learning](./iiot-prediction-patterns.yml#predict-process-and-equipment-failures-by-using-near-real-time-machine-learning) | Predict process and equipment failures by using a batch process. |
| [Predict process and equipment failures by using near real-time machine learning](./iiot-prediction-patterns.yml#predict-process-and-equipment-failures-by-using-near-real-time-machine-learning) | Predict process and equipment failures by using an API. |
| [Augment a manual quality inspection by using image recognition based on deep learning](./iiot-prediction-patterns.yml#augment-a-manual-quality-inspection-by-using-image-recognition-based-on-deep-learning) | Automate quality inspections in manufacturing by using a custom vision. |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager

Other contributor:

- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

## Next steps

- [Solutions for the manufacturing industry](../../industries/manufacturing.md)
- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
