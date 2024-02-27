---
title: Business understanding stage of the Team Data Science Process lifecycle
description: The goals, tasks, and deliverables for the business understanding stage of your data science projects in the Team Data Science Process.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 02/15/2024
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# The business understanding stage of the Team Data Science Process lifecycle

This article outlines the goals, tasks, and deliverables associated with the business understanding stage of the Team Data Science Process (TDSP). This process provides a recommended lifecycle that your team can use to structure your data science projects. The lifecycle outlines the major stages that your team performs, often iteratively:

- **Business understanding**
- **Data acquisition and understanding**
- **Modeling**
- **Deployment**
- **Customer acceptance**

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

## Goals

The goals of the business understanding stage are to:

* Specify the key variables that serve as the model targets. And specify the metrics of the targets, which determine the success of the project.

* Identify the relevant data sources that the business has access to or needs to obtain.

## How to complete the tasks

The business understanding stage has two main tasks:

* **Define objectives**: Work with your customer and other stakeholders to understand and identify the business problems. Formulate questions that define the business goals that the data science techniques can target.

* **Identify data sources**: Find the relevant data that helps you answer the questions that define the objectives of the project.

### Define objectives

1. A central objective of this stage is to identify the key business variables that the analysis needs to predict. These variables are called the *model targets*, and the metrics associated with them are used to determine the success of the project. For example, a target can be a sales forecast or the probability of an order being fraudulent.

2. To define the project goals, ask and refine *sharp* questions that are relevant, specific, and unambiguous. Data science is a process that uses names and numbers to answer such questions. You typically use data science or machine learning to answer five types of questions:

   * How much or how many? (regression)
   * Which category? (classification)
   * Which group? (clustering)
   * Is this unusual? (anomaly detection)
   * Which option should be taken? (recommendation)

   Determine which of these questions to ask and how answering it can help achieve your business goals.

3. To define the project team, specify the roles and responsibilities of its members. Develop a high-level milestone plan that you iterate on as you discover more information.

4. You must define the success metrics. For example, you might want to meet a customer churn prediction with an accuracy rate of *x* percent by the end of a three-month project. With this data, you can offer customer promotions to reduce churn. The metrics must be **SMART**:

   * **S**pecific
   * **M**easurable
   * **A**chievable
   * **R**elevant
   * **T**ime-bound

### Identify data sources

Identify data sources that contain known examples of answers to your questions. Look for the following data:

* Data that's relevant to the question. Do you have measures of the target and features that are related to the target?
* Data that's an accurate measure of your model target and the features of interest.

For example, an existing system might not have the data it needs to address a problem and achieve a project goal. In this situation, you might need to find external data sources or update your systems to collect new data.

## Integrate with MLflow

For the business understanding stage, your team doesn't use MLflow tools, but it can indirectly benefit from the documentation and experiment-tracking capabilities of MLflow. These features can provide insights and historical context to help align the project with business objectives.

## Artifacts

In this stage, your team delivers:

* **A charter document**. The charter document is a living document. You update the document throughout the project as you make new discoveries and as business requirements change. The key is to iterate on this document. Add more detail as you progress through the discovery process. Inform the customer and other stakeholders of the changes and the reasons for them.

* **Data sources**. You can use [Azure Machine Learning](/azure/machine-learning/concept-data) to handle data source management. We recommend this Azure service for active and especially large projects because it integrates with MLflow.
* **Data dictionaries**. This document provides descriptions of the data that the client provides. These descriptions include information about the schema (the data types and information on the validation rules, if any) and the entity-relation diagrams, if available.  Your team should document some or all of this information.

## Peer-reviewed literature

Researchers publish studies about the TDSP in peer-reviewed literature.  [The citations](/azure/architecture/data-science-process/lifecycle#peer-reviewed-citations) provide an opportunity to investigate other applications or similar ideas to the TDSP, including the business understanding lifecycle stage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

These articles describe the other stages of the TDSP lifecycle:

- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Deployment](lifecycle-deployment.md)
- [Customer acceptance](lifecycle-acceptance.md)
