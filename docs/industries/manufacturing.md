---
title: Solutions for the manufacturing industry
titleSuffix: Azure Architecture Center
description: Architectures and ideas to use Azure services for building efficient, scalable, and reliable manufacturing solutions.
author: martinekuan
ms.author: architectures
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
keywords:
  - Azure
products:
  - azure
categories:
  - ai-machine-learning
  - analytics
  - iot
  - storage
  - web
---

# Solutions for the manufacturing industry

Manufacturing sector, a hallmark of the modern industrialized world, encompasses all steps from procuring raw materials to transforming into final product. Starting from household manufacturing in the pre-industrial era, this sector has evolved through stages such as mechanized assembly lines and automation, every new development adding to faster and more efficient manufacturing processes. Cloud computing can bring forth the next revolution for manufacturing companies by transforming their IT infrastructures and processes from error-prone on-premises to highly available, secure, and efficient cloud, as well as providing cutting edge Internet of Things (IoT), AI/ML, and analytics solutions.

Microsoft Azure holds the promise of the [fourth industrial revolution](https://www.weforum.org/agenda/2016/01/the-fourth-industrial-revolution-what-it-means-and-how-to-respond/) by providing manufacturing solutions that can do the following:

- Help build more agile smart factories with industrial IoT.
- Create more resilient and profitable supply chains.
- Transform your work force productivity.
- Unlock innovation and new business models.
- Engage with customers in new ways.

<br>

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://www.youtube.com/embed/xn32a320sv4]

<!-- markdownlint-enable MD034 -->

<br>

To learn how you can modernize your manufacturing business using Azure, visit [Azure for manufacturing](https://azure.microsoft.com/industries/discrete-manufacturing/). For more resources, see [Microsoft Trusted Cloud for Manufacturing](https://www.microsoft.com/trust-center/manufacturing).

## Architecture guides for manufacturing

The following articles provide architectural guidelines for Azure solutions in the manufacturing industry.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Azure industrial IoT analytics guidance](../guide/iiot-guidance/iiot-architecture.yml) | Build an architecture for an Industrial IoT (IIoT) analytics solution on Azure using PaaS (Platform as a service) components. | IoT |
| [Upscale machine learning lifecycle with MLOps framework](../example-scenario/mlops/mlops-technical-paper.yml) | Learn how a Fortune 500 food company improved its demand forecasting and optimized the product stocks in different stores across several regions in US with the help of customized machine learning models. | AI/ML |
| [On-demand, scalable, high-power compute](/previous-versions/azure/industry-marketing/manufacturing/compute-in-manufacturing-overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | In this article, we walk through some well-known areas in engineering and manufacturing that need large computing power and explore how the Microsoft Azure platform can help. | Compute |
| [Predictive maintenance in manufacturing](/previous-versions/azure/industry-marketing/manufacturing/predictive-maintenance-overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | After introducing some background to predictive maintenance, we discuss how to implement the various pieces of a PdM solution using a combination of on-premises data, Azure machine learning, and usage of the machine learning models. | AI/ML |
| [Predictive maintenance solution](/previous-versions/azure/industry-marketing/manufacturing/predictive-maintenance-solution?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | This article presents options for building a predictive maintenance solution. It presents different perspectives and reference existing materials to get you started. | AI/ML |
| [Extract actionable insights from IoT data](/previous-versions/azure/industry-marketing/manufacturing/extracting-insights-from-iot-data?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | This guide provides a technical overview of the components needed to extract actionable insights from IoT data analytics. | IoT |

## Architectures for manufacturing

The following articles provide detailed analysis of architectures developed and recommended for the manufacturing industry.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Anomaly detector process](/azure/architecture/solution-ideas/articles/anomaly-detector-process) | The Anomaly Detector API enables you to monitor and detect abnormalities in your time series data without having to know machine learning. | Analytics |
| [Automated guided vehicles fleet control](/azure/architecture/example-scenario/iot/automated-guided-vehicles-fleet-control) | This example architecture shows an end-to-end approach for an automotive original equipment manufacturer (OEM) and includes a reference architecture and several published supporting open-source libraries that can be reused.  | IoT |
| [Build a speech-to-text transcription pipeline with Azure Cognitive Services](/azure/architecture/example-scenario/ai/speech-to-text-transcription-analytics) | Improve the efficiency of your customer care centers and transform your business by analyzing high volumes of recorded calls and building a speech-to-text transcription pipeline with Azure Cognitive Services. | AI/ML |
| [Citizen AI with the Power Platform](/azure/architecture/example-scenario/ai/citizen-ai-power-platform) | The architecture extends on the Analytics end-to-end with Azure Synapse scenario. It allows for a custom ML model to be trained in Azure Machine Learning, and implemented with a custom application built using Microsoft Power Platform. | AI/ML |
| [Connected factory hierarchy service](/azure/architecture/solution-ideas/articles/connected-factory-hierarchy-service) | A hierarchy service allows your business stakeholders to centrally define how production assets like machines are organized within factories, from both an operational and maintenance point of view.  | IoT |
| [End-to-end manufacturing using computer vision on the edge](/azure/architecture/reference-architectures/ai/end-to-end-smart-factory) | This example architecture shows an end-to-end approach to computer vision from the edge to the cloud and back. | AI/ML |
| [Optimized storage – time based - multi writes](/azure/architecture/solution-ideas/articles/optimized-storage-time-based-multi-writes) | This architecture uses multiple storage services to optimize storage performance and cost.  | Databases |
| [Predictive maintenance with the intelligent IoT Edge](/azure/architecture/example-scenario/predictive-maintenance/iot-predictive-maintenance) | The Internet-of-things (IoT) Edge brings data processing and storage close to the data source, enabling fast, consistent responses with reduced dependency on cloud connectivity and resources. | IoT |
| [Quality assurance](/azure/architecture/solution-ideas/articles/quality-assurance) | This solution shows how to predict failures using the example of manufacturing pipelines (assembly lines).  | AI/ML |

## Solution ideas for manufacturing

The following are other ideas that you can use as a starting point for your manufacturing solution.

- [Condition monitoring for industrial IoT](/azure/architecture/solution-ideas/articles/condition-monitoring)
- [COVID-19 safe environments with IoT Edge monitoring and alerting](/azure/architecture/solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection)
- [Create personalized marketing solutions in near real time](../solution-ideas/articles/personalized-marketing.yml)
- [Defect prevention with predictive maintenance](../solution-ideas/articles/defect-prevention-with-predictive-maintenance.yml)
- [Demand forecasting](../solution-ideas/articles/demand-forecasting.yml)
- [Demand forecasting for shipping and distribution](../solution-ideas/articles/demand-forecasting-for-shipping-and-distribution.yml)
- [Environment monitoring and supply chain optimization with IoT](/azure/architecture/solution-ideas/articles/environment-monitoring-and-supply-chain-optimization)
- [Facilities management powered by mixed reality and IoT](/azure/architecture/solution-ideas/articles/facilities-management-powered-by-mixed-reality-and-iot)
- [Image classification with convolutional neural networks](../solution-ideas/articles/image-classification-with-convolutional-neural-networks.yml)
- [Knowledge mining for customer support and feedback analysis](../solution-ideas/articles/customer-feedback-and-analytics.yml)
- [Low-latency network connections for industry](/azure/architecture/solution-ideas/articles/low-latency-network)
- [Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
- [Predictive insights with vehicle telematics](/azure/architecture/solution-ideas/articles/predictive-insights-with-vehicle-telematics)
- [Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)
- [Predictive marketing with machine learning](../solution-ideas/articles/predictive-marketing-campaigns-with-machine-learning-and-spark.yml)
- [Supply chain track and trace](../solution-ideas/articles/supply-chain-track-and-trace.yml)
