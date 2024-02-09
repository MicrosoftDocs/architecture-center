---
title: Deployment stage of the Team Data Science Process lifecycle
description: The goals, tasks, and deliverables for the deployment stage of your data science projects
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 02/09/2024
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

This article outlines the goals, tasks, and deliverables associated with the deployment of the Team Data Science Process (TDSP). This process provides a recommended lifecycle that your team can use to structure your data-science projects. The lifecycle outlines the major stages that projects typically execute, often iteratively:

1. **Business understanding**
2. **Data acquisition and understanding**
3. **Modeling**
4. **Deployment**
5. **Customer acceptance**

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

## Goal

The goal of the deployment stage is to deploy models with a data pipeline to a production or production-like environment for final customer acceptance.

## How to do it

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

The following features in Azure Machine Learning help support this deployment lifecycle element:

- [Model management](/azure/machine-learning/how-to-manage-models-mlflow): Deployment involves taking a selected model and placing it into a production or operational environment. MLflow supports operationalization by managing and versioning deployment-ready models.

- [Model serving and deployment](/azure/machine-learning/how-to-deploy-mlflow-models): MLflow's model serving functionalities facilitate the deployment process, allowing models to be easily served in various environments.

## Artifacts

In this stage, your team delivers:

* A status dashboard (Power BI is recommended) that displays the system health and key metrics

* A final modeling report with deployment details
* A final solution architecture document

## Peer-reviewed literature

Researchers publish studies about TDSP in peer-reviewed literature.  [The citations](/azure/architecture/data-science-process/lifecycle#peer-reviewed-citations) provide an opportunity to investigate other applications or similar ideas to TDSP, including the deployment lifecycle stage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

These articles describe the other stages of the TDSP lifecycle:

- [Business understanding](lifecycle-business-understanding.md)
- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Customer acceptance](lifecycle-acceptance.md)

