---
title: Deploy ML models in production
description: How to deploy models to production, which enables them to play an active role in making business decisions.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 02/18/2022
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

- [Where to deploy models with Azure Machine Learning](/azure/machine-learning/how-to-deploy-managed-online-endpoints)
- [Deployment of a model in SQL-server](/sql/advanced-analytics/tutorials/sqldev-py6-operationalize-the-model)

> [!NOTE]
> Prior to deployment, one has to ensure the latency of model scoring is low enough to use in production.

> [!NOTE]
> For deployment from Azure Machine Learning, see [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-managed-online-endpoints).

## A/B testing

When multiple models are in production, [A/B testing](https://en.wikipedia.org/wiki/A/B_testing) may be used to compare model performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is the Team Data Science Process?](/azure/architecture/data-science-process/overview)
- [Compare the machine learning products and technologies from Microsoft](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning)
- [Machine learning at scale](/azure/architecture/data-guide/big-data/machine-learning-at-scale)
