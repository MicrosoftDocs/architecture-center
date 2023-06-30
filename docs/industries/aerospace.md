---
title: Solutions for the aerospace industry
description: See architectures and ideas that use Azure services to build efficient, scalable, and reliable solutions in the aerospace industry.
author: martinekuan
ms.author: robbag
ms.date: 06/27/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-machine-learning
  - azure-speech
  - azure-cognitive-services
  - azure-anomaly-detector
  - azure-synapse-analytics
categories:
  - ai-machine-learning
  - analytics
  - containers
---

# Solutions for the aerospace industry

Intelligent cloud analytics, AI and machine learning, speech capabilities, and improved security are just some of the benefits that aerospace enterprises gain by using Azure.

Airbus is a leader in designing, manufacturing, and servicing commercial and military aircraft, helicopters, satellites, and launch vehicles. Watch this [video to learn how they use AI to improve pilot training and satellite operations](https://www.youtube.com/watch?v=QRprKorsDFQ).

Airbus also uses Azure to fine-tune processes for designing, building, and operating complex products. Watch [How Airbus is transforming aerospace with Microsoft Azure Stack](https://www.youtube.com/watch?v=S5kuKEfKkkg) to learn more.

In the following video, you can learn about the Microsoft partnership with SpaceX that brings worldwide satellite connectivity to cloud services:

<br>

> [!VIDEO https://www.youtube.com/embed/OWYYo2VGkHQ]

## Architectures for aerospace

The following articles provide detailed analysis of architectures created and recommended for the aerospace industry.


|Architecture  |Summary  |Technology focus  |
|---------|---------|---------|
|[Advanced Azure Kubernetes Service (AKS) microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable AKS microservices architecture. An example scenario describes a company that uses a drone-based delivery service. | Containers|
|[Deploy microservices with Azure Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml) |Deploy existing microservice applications by using Azure Container Apps. View a drone-based delivery service example. |Containers|
|[Design a microservices architecture](../microservices/design/index.yml) |Design and build a microservices architecture on Azure by using a reference implementation that illustrates best practices. View a drone-based delivery service example. |Microservices|
|[End-to-end geospatial storage, analysis, and visualization](/azure/orbital/geospatial-reference-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) |This article provides a high-level approach to use cloud-native capabilities, along with some open-source software options and commercial options. |Databases|
|[Ingest FAA SWIM content to analyze flight data](../example-scenario/analytics/ingest-faa-swim-analyze-flight-data.yml)|Integrate Chef Infra, Chef InSpec, Test Kitchen, Terraform, Terraform Cloud, and GitHub Actions to automate and create data analytics environments.| Analytics|
|[Organize spaceborne geospatial data with SpatioTemporal Asset Catalog (STAC)](/azure/orbital/organize-stac-data?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) |This reference architecture shows an end-to-end implementation of SpatioTemporal Asset Catalog (STAC) to structure geospatial data. |Databases|
|[Process Synthetic Aperture Radar (SAR) data in Azure](/azure/orbital/sar-reference-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) |View a reference architecture that enables processing SAR/Remote Sensing data on Azure by using Apache Spark on Azure Synapse. |Analytics|
|[Serverless web application](../web-apps/serverless/architectures/web-app.yml) |Review a reference architecture that shows a serverless web application that serves static content from Azure Blob Storage.  An example scenario describes a company that uses a drone-based delivery service.|Serverless|
|[Spaceborne data analysis with Azure Synapse Analytics](./aerospace/geospatial-processing-analytics.yml) |View a reference architecture that enables geospatial workloads on Azure by using Azure Synapse.|Analytics|

## Solution ideas for aerospace

Following are some other ideas that you can use as a starting point for your aerospace solution.

- [Data cache](../solution-ideas/articles/data-cache-with-redis-cache.yml)
- [Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
- [Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)
- [Vision classifier model with Azure Custom Vision Cognitive Service](../example-scenario/dronerescue/vision-classifier-model-with-custom-vision.yml)
