---
title: Deployment stage of the Team Data Science Process lifecycle
description: Learn about the goals, tasks, and deliverables associated with the deployment stage of the Team Data Science Process.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
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
# Deployment stage of the Team Data Science Process lifecycle

This article outlines the goals, tasks, and deliverables associated with the deployment of the Team Data Science Process (TDSP). This process provides a recommended lifecycle that your team can use to structure your data-science projects. The lifecycle outlines the major stages that your team performs, often iteratively:

- **Business understanding**
- **Data acquisition and understanding**
- **Modeling**
- **Deployment**
- **Customer acceptance**

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

## Goal

The goal of the deployment stage is to deploy models with a data pipeline to a production or production-like environment for final customer acceptance.

## How to complete the task

The main task for this stage is to **operationalize the model**. Deploy the model and pipeline to a production or production-like environment for application consumption.

### Operationalize a model

After you have a set of models that perform well, your team can operationalize them for other applications to consume. Depending on the business requirements, predictions are made either in real time or on a batch basis. To deploy models, you expose them with an API interface. With an interface, users can easily consume the model from various applications, such as:

* Websites
* Spreadsheets
* Dashboards
* Line-of-business applications
* Back-end applications

For examples of model operationalization with Azure Machine Learning, see [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-managed-online-endpoints). It's a best practice to build monitoring into the production model and the data pipeline that you deploy. This practice helps with subsequent system status reporting and troubleshooting.

## Integrate with MLflow

To help support this stage, you can incorporate the following Azure Machine Learning features:

- [Model management](/azure/machine-learning/how-to-manage-models-mlflow): To prepare a deployment, you place a model into a production or operational environment. MLflow manages and versions deployment-ready models, which helps to improve operationalization.

- [Model serving and deployment](/azure/machine-learning/how-to-deploy-mlflow-models): MLflow's model serving functionalities facilitate the deployment process, so you can easily serve models in various environments.

## Artifacts

In this stage, your team delivers:

* **A status dashboard** that displays the system health and key metrics. We recommend using Power BI to create a dashboard.

* **A final modeling report** with deployment details.
* **A final solution architecture document**.

## Peer-reviewed literature

Researchers publish studies about the TDSP in peer-reviewed literature. [The citations](/azure/architecture/data-science-process/lifecycle#peer-reviewed-citations) provide an opportunity to investigate other applications or similar ideas to the TDSP, including the deployment lifecycle stage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

These articles describe the other stages of the TDSP lifecycle:

- [Business understanding](lifecycle-business-understanding.md)
- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Customer acceptance](lifecycle-acceptance.md)

