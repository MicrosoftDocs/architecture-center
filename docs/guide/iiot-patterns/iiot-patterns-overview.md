For manufacturers, the promise of digital transformation lies in breaking down silos and gaining a holistic view across the entire operation, from asset data to insights across all manufacturing processes. An IIoT solution relies on real-time and historical data from industrial devices and control systems located in manufacturing facilities. These include PLCs (Programmable Logic Controller), industrial equipment, SCADA (Supervisory Control and Data Acquisition) systems, MES (Manufacturing Execution System), and Process Historians.

A modern IIoT solution goes beyond moving existing industrial processes and tools to the cloud. It involves transforming your operations and processes, embracing cloud native services, and leveraging the power of machine learning and the intelligent edge to optimize industrial processes.

There are five key stages for a typical IIoT solution:

![IIoT Maturity](images/iiot-maturity.png)

Each stage of an IIoT Solution consists of multiple design patterns. Computerisation is the prerequisite step and it referes to enabling sensors and actuators to monitor production processes. We typically start our IIoT journey with Connectivity as the first step.

## Connectivity 
- Patterns
    - [OPC UA Server and Edge Gateway](./iiot-connectivity-patterns.md#opc-ua-server-and-edge-gateway)
    - [Protocol Translation and Edge Gateway](./iiot-connectivity-patterns.md#protocol-translation-and-edge-gateway)
    - [Built-in cloud connector](./iiot-connectivity-patterns.md#built-in-cloud-connector)
    - [Cloud SDK and Custom Application](./iiot-connectivity-patterns.md#cloud-sdk-and-custom-application)
    - [Hierarchy of IoT Edge Gateways](./iiot-connectivity-patterns.md#hierarchy-of-iot-edge-gateways)
    - [Resilient Edge Gateway](./iiot-connectivity-patterns.md#resilient-edge-gateway)
    - [Scale to multiple factories and business units](./iiot-connectivity-patterns.md#scale-to-multiple-factories-and-business-units)
    - [Cloud Gateway Options](./iiot-connectivity-patterns.md#cloud-gateway-options)
- Solution Samples
    - [Connectivity with Industrial Assets using OPC UA and Edge for Linux on Windows (EFLOW)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/1_Connectivity)

## Visibility

- Patterns
    - [Time Series Analysis](./iiot-visibility-patterns.md#time-series-analysis)
    - [Anomaly Detection and Root Cause Analysis](./iiot-visibility-patterns.md#anomaly-detection-and-root-cause-analysis)
- Solution Samples
    - [Operational Visibility with Anomaly Detection and Root Cause Analysis](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/2_OperationalVisibility)
## Transparency 

- Patterns
    - Business KPI Calculation Engine
    - Asset Hierarchy and Digital Twin Management

- Solution Samples
    - [Overall Equipment Effectiveness(OEE) and KPI Calculation Engine](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/3_OEECalculationEngine)
    - [Factory and Supply Chain Digital Twin](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/4_FactorySupplyChainTwin)

## Predictions 

- Patterns
    - Predict process and equipment failures using machine learning
    - Augment manual quality inspection using deep learing based image recognition

- Solution Samples
    - [Exploratory Data Analysis for failure predictions using machine learning](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/5_ExplorationDataAnalysis)
    - [Operationalizing machine learning based prediction models](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/6_MachineLearningForIIoT)
    - [Operationalizing deep learning based image recognition models on the factory floor](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/7_ImageRecognitionForIIoT)

## Adaptability 

- Patterns
    - Control system optimization using Deep Reinforcement Learning

- Solution Samples
    - [Control system optimization using Deep Reinforcement Learning (DRL)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/8_DeepReinforcementLearningForIIoT)