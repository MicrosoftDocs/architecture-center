---
title: The Team Data Science Process lifecycle
description: The Team Data Science Process (TDSP) provides a recommended lifecycle that you can use to structure your data science projects.
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
# The Team Data Science Process lifecycle

The Team Data Science Process (TDSP) provides a lifecycle that your team can use to structure your data science projects. The lifecycle outlines the steps you can take to successfully complete a project. 

You should use this lifecycle if you have a data science project that's part of an intelligent application. Intelligent applications deploy machine learning or AI models for predictive analytics. You can also use this process for exploratory data science projects and improvised analytics projects, but you might not need to implement every step of the lifecycle.

Your team can combine the task-based TDSP with other data science lifecycles, such as the cross-industry standard process for data mining [(CRISP-DM)](https://wikipedia.org/wiki/Cross_Industry_Standard_Process_for_Data_Mining), the knowledge discovery in databases [(KDD)](https://wikipedia.org/wiki/Data_mining#Process) process, or your organization's own custom process.

## Purpose and credibility

The purpose of TDSP is to streamline and standardize your approach to data science and AI projects. Microsoft has applied this structured methodology in hundreds of projects. Researchers studied TDSP and published their findings in peer-reviewed literature. The architectural framework of the TDSP is thoroughly tested and proven effective in many areas.

## Five lifecycle stages

The TDSP lifecycle is composed of five major stages that your team performs iteratively. These stages include:

- [Business understanding](lifecycle-business-understanding.md)
- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Deployment](lifecycle-deployment.md)
- [Customer acceptance](lifecycle-acceptance.md)

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

The TDSP lifecycle is a sequence of steps that provide guidance for creating predictive models. Your team deploys the predictive models in a production environment that you plan to use to build intelligent applications. The goal of this process lifecycle is to navigate a data science project toward a clear engagement endpoint. Data science is an exercise in research and discovery. When you use a well-defined process to communicate tasks to your team, you increase the chance of successfully carrying out a data science project.

Each stage has its own article that outlines:

* **Goals**: The objectives of the stage.
* **How to do it**: An outline of the tasks you perform in the stage and guidance about how to complete them.
* **Artifacts**: The deliverables that you need to produce during the stage and resources that you can use to help you create them.

## Peer-reviewed citations

Researchers publish peer-reviewed literature about the TDSP. Review the following material to investigate TDSP features and applications.

- [Software Engineering for Machine Learning: A Case Study (pages 291-300)](https://doi.org/10.1109/ICSE-SEIP.2019.00042)

- [The Art and Practice of Data Science Pipelines: A Comprehensive Study of Data Science Pipelines in Theory, In-The-Small, and In-The-Large (pages 2091-2103)](https://doi.org/10.1145/3510003.3510057)

- [An Artificial Intelligence Life Cycle: From Conception to Production](https://doi.org/10.1016/j.patter.2022.100489)

- [A Hybrid Methodology Based on CRISP-DM and TDSP for the Execution of Preprocessing Tasks in Mexican Environmental Laws (volume 13613, pages 68-82)](https://doi.org/10.1007/978-3-031-19496-2_6)

- [How to Conduct Rigorous Supervised Machine Learning in Information Systems Research: The Supervised Machine Learning Report Card (pages 589-615)](https://doi.org/10.17705/1CAIS.04845)

- [Data Science in the Business Environment: Customer Analytics Case Studies in subject matter experts (SMEs) (pages 689–713)](https://doi.org/10.1108/JM2-11-2019-0274)

- [CRISP-DM Twenty Years Later: From Data Mining Processes to Data Science Trajectories (pages 3048–3061)](https://doi.org/10.1109/TKDE.2019.2962680)

- [Data Science: A Systematic Treatment (pages 106–116)](https://doi.org/10.1145/3582491)

- [Management of Machine Learning Lifecycle Artifacts: A Survey (pages 18–35)](https://doi.org/10.1145/3582302.3582306)

- [Construction of a Quality Model for Machine Learning Systems (pages 307–335)](https://doi.org/10.1007/s11219-021-09557-y)


- [Machine Learning-driven Innovation Management: Conceptional Framework. Event Proceedings: LUT Scientific and Expertise Publications: The ISPIM Innovation Conference – Innovating Our Common Future](https://www.innoget.com/innovation-events/1878/ispim-innovation-conference-2021-innovating-our-common-future)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- For the first stage of the lifecycle, see [Business understanding](lifecycle-business-understanding.md).
- [What is the Team Data Science Process?](overview.yml)
- [Compare machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
