---
title: Customer acceptance stage of the Team Data Science Process lifecycle
description: The goals, tasks, and deliverables for the customer acceptance stage of your data-science projects
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 01/15/2024
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

This article outlines the goals, tasks, and deliverables associated with the customer acceptance stage of the Team Data Science Process (TDSP). This process provides a recommended lifecycle that your team can use to structure your data-science projects. The lifecycle outlines the major stages that projects typically execute, often iteratively:

1. **Business understanding**
2. **Data acquisition and understanding**
3. **Modeling**
4. **Deployment**
5. **Customer acceptance**

Here's a visual representation of the TDSP lifecycle:

![TDSP lifecycle](./media/lifecycle/tdsp-lifecycle2.png)

## Goal
**Finalize project deliverables**: Confirm that the pipeline, the model, and their deployment in a production environment satisfy the customer's objectives.

## How to do it
There are two main tasks addressed in this stage:

* **System validation**: Confirm that the deployed model and pipeline meet the customer's needs.
* **Project hand-off**: Hand the project off to the entity that's going to run the system in production.

The customer should validate that the system meets their business needs, answers the questions with acceptable accuracy, and is deployable for customer use. All the documentation is finalized and reviewed. The project is handed-off to the entity responsible for operations. This entity might be, for example, an IT or customer data-science team or an agent of the customer that's responsible for running the system in production.

## Integration with MLflow

While MLflow doesn't directly involve customer acceptance, the tracking and registry features help maintain a record of models, experiments, and deployments.  This careful tracking can be crucial for final reporting, auditing, and obtaining customer acceptance.

## Artifacts
The main artifact produced in this final stage is the **Exit report of the project for the customer**. This technical report contains all the details of the project that are useful for learning about how to operate the system. 

## Peer-Reviewed Literature

Researchers publish studies about TDSP in peer-reviewed literature.  [The citations](/azure/architecture/data-science-process/lifecycle#peer-reviewed-citations) provide an opportunity to investigate other applications or similar ideas to TDSP, including the customer acceptance lifecycle stage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Here are links to each step in the lifecycle of the TDSP:

1. [Business understanding](lifecycle-business-understanding.md)
2. [Data acquisition and understanding](lifecycle-data.md)
3. [Modeling](lifecycle-modeling.md)
4. [Deployment](lifecycle-deployment.md)
5. [Customer acceptance](lifecycle-acceptance.md)

For Azure, we recommend applying TDSP using Azure Machine Learning:  for an overview of Azure Machine Learning see [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning).
