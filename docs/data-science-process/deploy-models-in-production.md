---
title: Deploy ML models in production
description: How to deploy models to production, which enables them to play an active role in making business decisions.
author: marktab
manager: marktab
editor: marktab
ms.topic: article
ms.date: 12/16/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Deploy ML models to production to play an active role in making business decisions

Production deployment enables a model to play an active role in a business. Predictions from a deployed model can be used for business decisions.

## Production platforms

There are various approaches and platforms to put models into production. Here are a few options:

- [Where to deploy models with Azure Machine Learning](/azure/machine-learning/how-to-deploy-and-where)
- [Deployment of a model in SQL-server](/sql/advanced-analytics/tutorials/sqldev-py6-operationalize-the-model)

> [!NOTE]
> Prior to deployment, one has to insure the latency of model scoring is low enough to use in production.

> [!NOTE]
> For deployment from Azure Machine Learning, see [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-and-where).

## A/B testing

When multiple models are in production, [A/B testing](https://en.wikipedia.org/wiki/A/B_testing) may be used to compare model performance.

## Next steps

Walkthroughs that demonstrate all the steps in the process for **specific scenarios** are also provided. They are listed and linked with thumbnail descriptions in the [Example walkthroughs](walkthroughs.md) article. They illustrate how to combine cloud, on-premises tools, and services into a workflow or pipeline to create an intelligent application.
