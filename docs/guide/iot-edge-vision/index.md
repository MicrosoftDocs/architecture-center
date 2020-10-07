---
title: Azure IoT Edge Vision
titleSuffix: Azure Architecture Center
description: 
author: MSKeith
ms.date: 09/30/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Vision with Azure IoT Edge

Visual inspection of products, resources and environments has been a core practice for most Enterprises, and was, until recently, a very manual process. An individual, or group of individuals, was responsible for performing a manual inspection of the asset or environment, which, depending on the circumstances, could become inefficient, inaccurate or both, due to human error and limitations.

In an effort to improve the efficacy of visual inspection, Enterprises began turning to deep learning artificial neural networks known as convolutional neural networks, or CNNs, to emulate human vision for analysis of images and video. Today this is commonly called computer vision, or simply Vision AI. Artificial Intelligence for image analytics spans a wide variety of industries, including manufacturing, retail, healthcare and the public sector, and an equally wide area of use cases.

- **Vision for quality assurance** - In manufacturing environments, quality inspection of parts and processes with a high degree of accuracy and velocity is one of the use cases for Vision AI. An enterprise pursuing this path automates the inspection of a product for defects to answer questions such as:

    - Is the manufacturing process producing consistent results?
    - Is the product assembled properly?
    - Can I get notification of a defect sooner to reduce waste?
    - How can I leverage drift in my computer vision model to prescribe predictive maintenance?

- **Vision for safety** - In any environment, safety is a fundamental concern for every Enterprise on the planet, and the reduction of risk is a driving force for adopting Vision AI. Automated monitoring of video feeds to scan for potential safety issues affords critical time to respond to incidents, and opportunities to reduce exposure to risk. Enterprises looking at Vision AI for this use case are commonly trying to answer questions such as:

    - How compliant is my workforce with using personal protective equipment?
    - How often are people entering unauthorized work zones?
    - Are products being stored in a safe manner?
    - Are there non-reported close calls in a facility, i.e. pedestrian/equipment “near misses?”

## Why vision on the Edge

Over the past decade, computer vision has become a rapidly evolving area of focus for Enterprises, as cloud-native technologies, such as containerization, have enabled portability and migration of this the technology toward the network edge. For instance, custom vision inference models trained in the Cloud can be easily containerized for use in an Azure IoT Edge runtime-enabled device.

The rationale behind migrating workloads from the cloud to the edge for Vision AI generally falls into two categories – performance and cost.

On the performance side of the equation, exfiltrating large quantities of data can cause an unintended performance strain on existing network infrastructure. Additionally, the latency of sending images and/or video streams to the Cloud to retrieve results may not meet the needs of the use case. For instance, a person straying into an unauthorized area may require immediate intervention, and that scenario can ill afford latency when every second counts. Positioning the inferencing model near the point of ingest allows for near-real time scoring of the image, and alerting can be performed either locally or through the cloud, depending on network topology.

In terms of cost, sending all of the data to the Cloud for analysis could significantly impact the ROI of a Vision AI initiative. With Azure IoT Edge, a Vision AI module could be designed to only capture the relevant images that have a reasonable confidence level based on the scoring, which significantly limits 
the amount of data being sent.

## Next steps

The purpose of this guidance is to give some concrete guidance on some of the key decisions when designing an end-to-end vision on the edge solution. Please proceed to the following guides to the components involved:

- [Camera selection and placement](./iot-edge-camera.md)
- [Hardware acceleration](./iot-edge-hardware.md)
- [Machine learning and data science](./iot-edge-machine-learning.md)
- [Image storage and management](./iot-edge-image-storage.md)
- [Persistence of alerts](./iot-edge-alerts.md)
- [User Interface](./iot-edge-user-interface.md)