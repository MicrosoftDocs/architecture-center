---
title: Execute data science tasks - Team Data Science Process
description: How a data scientist can execute a data science project in a trackable, version controlled, and collaborative way.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 12/14/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Execute data science tasks: exploration, modeling, and deployment

Typical data science tasks include data exploration, modeling, and deployment. This article outlines the tasks to complete several common data science tasks such as interactive data exploration, data analysis, reporting, and model creation. Options for deploying a model into a production environment may include:

- Recommended: [Azure Machine Learning](/azure/machine-learning)
- Possible: [SQL-Server with ML services](/sql/advanced-analytics/r/r-services)

## 1. <a name='DataQualityReportUtility-1'></a> Exploration

A data scientist can perform exploration and reporting in a variety of ways: by using libraries and packages available for Python (matplotlib for example) or with R (ggplot or lattice for example). Data scientists can customize such code to fit the needs of data exploration for specific scenarios. The needs for dealing with structured data are different that for unstructured data such as text or images.

Products such as Azure Machine Learning also provide [advanced data preparation](/azure/machine-learning/how-to-create-register-datasets) for data wrangling and exploration, including feature creation. The user should decide on the tools, libraries, and packages that best suite their needs.

The deliverable at the end of this phase is a data exploration report. The report should provide a fairly comprehensive view of the data to be used for modeling and an assessment of whether the data is suitable to proceed to the modeling step.

## 2. <a name='ModelingUtility-2'></a> Modeling

There are numerous toolkits and packages for training models in a variety of languages. Data scientists should feel free to use which ever ones they are comfortable with, as long as performance considerations regarding accuracy and latency are satisfied for the relevant business use cases and production scenarios.

### Model management
After multiple models have been built, you usually need to have a system for registering and managing the models. Typically you need a combination of scripts or APIs and a backend database or versioning system. Azure Machine Learning provides [deployment of ONNX models](/azure/machine-learning/concept-onnx#deploy-onnx-models-in-azure) or [deployment of ML Flow models](/azure/machine-learning/how-to-deploy-mlflow-models).

## 3. <a name='Deployment-3'></a> Deployment

Production deployment enables a model to play an active role in a business. Predictions from a deployed model can be used for business decisions.

### Production platforms
There are various approaches and platforms to put models into production.  We recommend [deployment to Azure Machine Learning](/azure/machine-learning/how-to-deploy-managed-online-endpoints).

> [!NOTE]
> Prior to deployment, one has to ensure the latency of model scoring is low enough to use in production.
>
>


### A/B testing
When multiple models are in production, it can be useful to perform [A/B testing](https://wikipedia.org/wiki/A/B_testing) to compare performance of the models.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

[Track progress of data science projects](track-progress.md) shows how a data scientist can track the progress of a data science project.

[Model operation and CI/CD](ci-cd-flask.yml) shows how CI/CD can be performed with developed models.
