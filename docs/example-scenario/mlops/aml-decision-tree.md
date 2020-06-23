---
title: Azure Machine Learning Development - Decision Guide for Optimal Tool Selection
titleSuffix: Technical White Paper
description: How to choose the best services for building an end-to-end machine learning pipeline from experimentation to deployment.
author: danazlin
ms.author: Derek.Martin
ms.date: 06/01/2020
ms.topic: MLOps, MLOps Maturity Model
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
ms.category:
    - developer-tools
    - hybrid
social_image_url: /azure/architecture/example-scenario/serverless/media/mlops.png
---

# Azure Machine Learning Development: Decision Guide for Optimal Tool Selection

## Introduction

Microsoft Azure offers a myriad of services and capabilities. Building an end-to-end machine learning pipeline from experimentation to deployment often requires bringing together a set of services from across Azure. While it may be possible to have one pipeline “do it all,” so to speak, there are tradeoffs when not utilizing the services for what they are best at.

So, when is it worth it to adopt each service for your use case? The answer is that it often depends on a variety of factors that are not necessarily related to the functional requirements. The main factors are:

* The skill sets on the team

* How the Azure service plugs into the existing architecture in place

* The maintainability of the solution build using this service

* The cost of these services at scale

### Scope

The scope of this document is focused on Azure services that are used to support data or machine learning workloads. This document does not consider third-party solutions available through Azure Marketplace. While not exhaustive, this document covers the most popular options on Azure for supporting the end to end workflow:

1. Experimentation

1. Overall Orchestration/Scheduling

1. Data Transfer

1. Data Transformation

1. Model Training

1. Model Deployment

1. Monitoring

## Options Considered

As mentioned, Azure offers many services and capabilities but this document is not exhaustive. Listed below are the Azure services options that were considered under each category.

TABLE 1 - OPTIONS CONSIDERED

| Category | Options |
| -------- | ------- |
| Experimentation | [Azure Machine Learning Notebook VMs](https://azure.microsoft.com/blog/three-things-to-know-about-azure-machine-learning-notebook-vm/)<br>[Databricks Notebooks](https://docs.databricks.com/notebooks/index.html)<br>[Azure Machine Learning Experiment for Python SDK](/python/api/overview/azure/ml/)<br>[DSVM](/azure/machine-learning/data-science-virtual-machine/) |
| Overall Orchestration / Scheduling | [Logic Apps]()<br>[Azure Data Factory]()<br>[Azure Machine Learning Pipelines]()<br>[]()<br> |
| Data Transfer |  |
| Compute |  |
| Tracking / Versioning options |  |
| Model Training |  |
| Model Deployment |  |
| Monitoring |  |

## Decision Tree

### Code or No Code

The first decision is whether to use a No Code implementation approach or the traditional Code approach. Each has its own tradeoffs.

### No Code

For those who do not want to code their own solutions, a set of tools is available for building workflows without writing any code. These include:
* For Experimentation, use Azure Machine Learning Designer. 
* For Overall Orchestration/Scheduling, use Logic Apps, especially if integrating to Office 365 suite (Outlook, etc.)
* For Data Transfer and Data Transformation, use Data Factory Data Flows. If datasets are very simple and smaller scale, they can also be handled in Azure Machine Learning Designer.
* For Model Training and Model Deployment, use Azure Machine Learning Designer. It supports both real-time and batch deployments.
* For Monitoring, use Azure Monitor with Azure Dashboards, which lets you click to pin visuals and set up alerts without code. For more configuration, Power BI can also be used to create historical dashboards.
The primary issue you’ll encounter here is that you must work within the constraints of the tools. However, if your use case fits within these limitations, this could be a good solution.
These tools are evolving, and their capabilities will expand over time. So you should familiarize yourself with their latest features at the time you consider them. Figure 1 summarizes the process for the No Code option.

:::row:::
    :::column span="3":::
        :::image type="content" source="./media/dt-no-code-option.png" alt-text="no code option process diagram":::
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::



<p style="text-align:center;font-style:italic;" tag="caption">FIGURE 1 - NO CODE OPTION</p>

### Code

For those who want to code or need the flexibility that a coded solution offers, all the options described have a “code-like” interface. Or, at least a representation of processing logic that can be exported to JSON or YAML format and can be checked into a code repository. From there, deployment can be handled through Azure DevOps or scripts. Figure 2 summarizes the Code option process.

:::image type="content" source="./media/dt-code-option.png" alt-text="code option process diagram":::

<p style="text-align:center;font-style:italic;" tag="caption">FIGURE 2 - CODE OPTION</p>

## Experimentation: Notebooks vs. Python/R Scripts

Based on the skillsets or comfort level of your team’s data scientists/engineers with notebooks or plain scripts, there are choices for experimentation that support both options.

TABLE 2 - NOTEBOOKS



TABLE 3 - PYTHON/R SCRIPTS

## Overall Orchestration/Scheduling

Table 4 lists which systems are best for supported trigger options while Table 5 adds scheduling options.

TABLE 4 - TRIGGER OPTIONS



TABLE 5 - TRIGGERS/SCHEDULING



TABLE 6 - DATA TRANSFER OPTIONS



TABLE 7 - COMPUTE OPTIONS



TABLE 8 - TRACKING/VERSIONING


TABLE 9 - MODEL TRAINING OPTIONS



TABLE 10 - MODEL DEPLOYMENT OPTIONS



TABLE 11 - MONITORING



## Resources

* [Technical White Paper: MLOps Framework for Upscaling ML Lifecycle with Azure ML](./mlops-white-paper.md)
* Reference Architecture Document: MLOps Framework for Upscaling ML Lifecycle with Azure ML
* [MLOps Maturity Model](./mlops-maturity-model.md)

## Credits

Xinyi Joffre  
