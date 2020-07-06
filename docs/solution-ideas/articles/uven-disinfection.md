---
title: UVEN disinfection building management solution
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Update building management systems to provide COVID-19 protections with intelligent IoT Edge devices and cloud-powered apps.
ms.date: 07/06/2020
ms.custom: iot, fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category:
  - iot
---

# Smart lighting and UV antiviral system

BrainLit's BioCentric Lighting™ (BCL) system is a dynamic, feedback-driven, self-learning lighting system that creates high-quality natural lighting cycles for indoor environments. The science behind BCL lies in understanding human responsiveness to light. Human eyes don't only sense vision. Glllll cells connect to other brain areas like the thalamus and mediate the organism's response to light cycles. Research increasingly confirms the importance of high-quality light and natural light cycles for human health, well-being, and productivity. BCL systems can vary lighting intensity and spectral composition throughout the day to mimic natural daylight. Advanced sensors and controllers ensure that the LED room luminaires generate the optimal recipe of BCL light. The lighting system continually integrates new developments in light research via machine learning, ensuring the best scientifically-based lighting system for all needs.

The BCL system can also deliver radiant energy in the non-visible spectrum, such as ultraviolet (UV). All UV radiation has some antimicrobial capabilities. The lowest wavelength, 200-300 nm UVC radiation is absorbed by biological organisms' DNA, RNA, and proteins, causing inactivation of the DNA and preventing replication of viruses. Now, BrainLit's UVEN concept combines BCL with UVC disinfection technology to help create environments that are both safe and healthy.

Ongoing developments in plug-in UVC devices, robots, drones, and wands don't address overall effectiveness, performance, and safety in spaces. They also can't operate efficiently without disrupting business and personnel, resulting in loss of productivity and lower space utilization. UVEN disinfection operates in unoccupied spaces and during non-business hours. Enabling autonomous deactivation of microbes in real time without business disruption is key to sustaining a healthy economy.

UVEN offers:
- A smart and safe integrated system solution for disinfection with optimal usage of floor area.
- Long-term solutions that can adapt disinfection dose and recipes to changing circumstances.
- When coupled with BCL healthy lighting, increased overall health and strengthened immune systems.

UVEN Technology – The Luminaires
Combined BioCentric Lighting (BCL) and UVC radiation.
UVEN ASK – BCLTM Ceiling Panel
Dynamic LED ceiling panel with large range of circadian impact, exceptional colour rendering, while dimming smoothly down to 0.1%. 
Adaptable luminaire suitable for healthcare, conference rooms or classrooms.
UVEN ASK – BCLTM UVC-Concept
UVEN ASK integrates BCL with disinfection in one and the same luminaire.
With people present they are exposed to BCL only; whenever the space is unoccupied, virus and bacteria are heavily reduced with UV-light, creating a safe and healthy environment.
UVEN – BCLTM Dual Driver Technology
Dual functionality of the luminaire is made possible with separate drivers optimized to operate in their respective regimes. This maintains full BCL features as well as full UV functionality simultaneously.
UVEN – BCLTM Radar Tracking
Radar sensors provide "double fail safe" to ensure users are exposed with beneficial light components only. Combined with the sophisticated and patented light control system, the solution is complete.

Cell Concept – For flexibility, safety & security
One UVEN Light Control System (LCS) can manage up to 20 luminaires, defined as a UVEN Cell.
- The LCS is controlling both the emission of BCL light and UVC radiation.
- The LCS is connected to radar sensors that secure the external perimeters of the cell, as well as individual luminaire radar sensors.
- Only power and access to internet are required.

Several cells can be connected to a cluster
- Only one of the LCSs needs to be connected to the internet for light recipe updates and real time calibration
- The system can operate on a stand-alone basis or be controlled by a BCL Management System
- Multiple Building Cells can form and interact as one UVEN BCL Network System
- The UVEN BCL Net can be monitored and controlled by a central Network Light Control System
- The UVEN BCL Net is completely decentralized and offers unlimited scalability, control and flexibility
Motion sensors, alarms
Admin panel, dashboard

The UV light is divided into different categories depending on wavelength, and the UVC rays used by BrainLit, are the ones with the shortest wavelength. The fact that UVC light can kill viruses and bacteria is not news, nor the harmfulness to humans. BrainLit´s system should therefore only be activated where and when it is safe, using sensors to recognize empty areas. Niclas Olsson mentions  among other places that can utilize the light system – to disinfect and reduce the risk of Corona virus spreading.

## Potential use cases

- Hotel reception areas, train stations, and hospitals
- BMS users from individual offices, restaurants, and retail spaces to large institutions and globally distributed organizations.

## Architecture

![iBEMS Shield architecture](../media/ibems-shield.png)

1. Thermographic cameras and CCTV provide temperature and visual data to IoT Edge devices and servers.
2. Stream analytics on the edge apply cognitive and machine learning models to quickly identify, quantify, track, and alert personnel.
3. Azure IoT Hub communicates with and controls the edge devices, and streams preprocessed data to the Azure cloud.
4. In the cloud, data streams to Azure Data Lake Storage for long term persisted storage. Azure Databricks reads and analyzes the stored data.
5. The Power Apps dashboard app applies business logic, machine learning (ML) model training, and automated workflows.
6. Azure deploys the customized dashboard app via firewall, message bus, and load balancers to iBEMS on-premises Control Centers, browsers, and mobile devices.

## Components

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) intelligent devices can recognize and respond to sensor input by using onboard processing. These devices respond quickly or even offline, and limit costs by preprocessing and sending only necessary data to the cloud.
- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing that can run the same queries on the edge and in the cloud. ASA on IoT Edge can filter or aggregate data to send to the cloud for further processing or storage.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) IoT service creates comprehensive models of physical environments in a spatial intelligence graph. Rather than simply tracking individual devices, Digital Twins can virtually replicate the physical world by modeling the relationships between people, places, and devices.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects virtually any IoT device with Azure cloud services. IoT Hub enables highly secure and reliable bi-directional communication, management, and provisioning for IoT Edge devices.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is a data lake storage solution for big data analytics. Data Lake Storage combines [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) capabilities with a high-performance file system.
- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a fast, easy, and collaborative Apache Spark-based analytics service that can read and analyze data lake data.
- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) is a family of AI services and cognitive APIs that help build intelligent apps. For example, [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/), [Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service/), and [Face](https://azure.microsoft.com/services/cognitive-services/face/) can help identify and track personnel on-premises.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) lets you build, train, deploy, track, and manage ML models at cloud scale. Machine learning continually retrains and updates models to improve accuracy and performance.
- [Power Apps](https://azure.microsoft.com/products/powerapps/) is a suite of apps, services, connectors, and data platform that build custom apps for business needs. Power Apps provides responsive design that can run seamlessly in browsers, mobile devices, or large video displays. Power Apps portal apps create external-facing websites that allow secure access for various identities.

## Next steps

- For more information, please contact [iotcovid@microsoft.com](mailto:iotcovid@microsoft.com).
- For information about iBEMS, see [Intelligent Building Experience Management System (iBEMS)](https://www.ltts.com/solutions/i-bems).