---
title: Customer acceptance stage of the Team Data Science Process lifecycle
description: Learn about the goals, tasks, and deliverables associated with the customer acceptance stage of the Team Data Science Process.
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
# Customer acceptance stage of the Team Data Science Process lifecycle

This article outlines the goals, tasks, and deliverables associated with the customer acceptance stage of the Team Data Science Process (TDSP). This process provides a recommended lifecycle that your team can use to structure your data science projects. The lifecycle outlines the major stages that your team performs, often iteratively:

- **Business understanding**
- **Data acquisition and understanding**
- **Modeling**
- **Deployment**
- **Customer acceptance**

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

For Azure, we recommend that you use Azure Machine Learning to apply the TDSP. For more information, see [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning).

## Goal

The goal of the customer acceptance stage is to finalize project deliverables. Your team should confirm that the pipeline, the model, and their deployment in a production environment satisfy the customer's objectives.

## How to complete the tasks

The customer acceptance stage has two main tasks:

- **System validation**: Confirm that the deployed model and pipeline meet the customer's needs.

- **Project hand-off**: Hand the project off to the person or team that's going to run the system in production. For example, it might be an IT team, customer data science team, or the customer's agent.

The customer should validate that the system:

- Meets their business needs.
- Answers the questions with acceptable accuracy.
- Is deployable for use.
- Has finalized documentation.

## Integrate with MLflow

MLflow isn't directly related to the customer acceptance stage, but the tracking and registry features of MLflow help maintain a record of models, experiments, and deployments. This tracking is crucial for final reporting, auditing, and obtaining customer acceptance.

## Artifacts

The main artifact that your team creates in this final stage is the *exit report* of the project for the customer. This technical report contains details about the project that the customer can use to learn how to operate the system.

## Peer-reviewed literature

Researchers publish studies about the TDSP in peer-reviewed literature.  [The citations](/azure/architecture/data-science-process/lifecycle#peer-reviewed-citations) provide an opportunity to investigate other applications or similar ideas to the TDSP, including the customer acceptance lifecycle stage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

These articles describe the other stages of the TDSP lifecycle:

- [Business understanding](lifecycle-business-understanding.md)
- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Deployment](lifecycle-deployment.md)


