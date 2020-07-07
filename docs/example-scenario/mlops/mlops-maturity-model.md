---
title: Machine Learning Operations maturity model
titleSuffix: Technical Description
description: Detailed explanation of the MLOps maturity model stages and defining characteristics of each stage.
author: danazlin
ms.author: dermar
ms.date: 07/07/2020
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
ms.category:
    - developer-tools
    - hybrid
---

# Machine Learning Operations maturity model

The purpose of this maturity model is to help clarify the Machine Learning Operations (MLOps) principles and practices. The maturity model shows the continuous improvement in the creation and operation of a production level machine learning application environment. YOu can use it as a metric for establishing the progressive requirements needed to measure the maturity of a machine learning production environment and its associated processes. It's also useful for:

* Estimating the scope of the work required for a new machine learning project.

* Establishing some success criteria.

* Identifying project deliverables.

## Maturity model

The MLOps maturity model helps clarify the Development Operations (DevOps) principles and practices necessary to run a successful MLOps environment. It's intended to identify gaps in an existing organization's attempt to implement such an environment. It's also a way to show you how to grow your MLOps capability in increments rather than overwhelm you with the requirements of a fully mature environment. Use it as a guide to:

* Estimate the scope of the work for new engagements.

* Establish realistic success criteria.

* Identify deliverables you'll hand over at the conclusion of the engagement.

As with most maturity models, the MLOps maturity model qualitatively assesses people/culture, processes/structures, and objects/technology. As the maturity level increases, the probability increases that incidents or errors will lead to improvements in the quality of the development and production processes.

The MLOps maturity model encompasses five levels of technical capability:

| Level | Description | Highlights | Technology |
| ----- | ----------- | ---------- | ---------- |
| 0 | [No MLOps](#level-0-no-mlops) | <ul><li>Difficult to manage full machine learning model lifecycle<li>The teams are disparate and releases are painful<li>Most systems exist as "black boxes," little feedback during/post deployment</ul> | <ul><li>Manual builds and deployments<li>Manual testing of model and application<li>No centralized tracking of model performance<li>Training of model is manual</ul> |
| 1 | [DevOps but no MLOps](#level-1-devops-no-mlops) | <ul><li>Releases are less painful than No MLOps, but rely on Data Team for every new model<li>Still limited feedback on how well a model performs in production<li>Difficult to trace/reproduce results</ul> | <ul><li>Automated builds<li>Automated tests for application code<li> |
| 2 | [Automated Training](#level-2-automated-training) | <ul><li>Training environment is fully managed and traceable<br>Easy to reproduce model<li>Releases are manual, but low friction</ul> | <ul><li>Automated Model Training<li>Centralized tracking of model training performance<li>Model Management</ul> |
| 3 | [Automated Model Deployment](#level-3-automated-model-deployment) | <ul><li>Releases are low friction and automatic<br>Full traceability from deployment back to original data<li>Entire environment managed: train > test > production </ul>| <ul><li>Integrated A/B testing of model performance for deployment<br>Automated tests for all code<li>Centralized training of model training performance</ul> |
| 4 | [Full MLOps Automated Operations](#level-4-full-mlops-automated-retraining) | <ul><li>Full system automated and easily monitored<li>Production systems are providing information on how to improve and, in some cases, automatically improving with new models<li>Approaching a zero-downtime system </ul>| <ul><li>Automated model training and testing<li>Verbose, centralized metrics from deployed model</ul> |

Within these levels, the tables that follow identify the details characteristic for that level of process maturity. While the model will continue to evolve, this version was last updated in January 2020.

## Level 0: No MLOps

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data scientists: siloed, not in regular communications with the larger team<li>Data engineers (_if exists_): siloed, not in regular communications with the larger team<li>Software engineers: siloed, receive model remotely from the siloed team members</ul> | <ul><li>Data gathered manually<li>Compute is likely not managed<li>Experiments aren't predictably tracked<li>End result may be a single model file manually handed off with inputs/outputs</ul> | <ul><li>Manual process<li>Scoring script may be manually created well after experiments, not version controlled<li>Release handled by data scientist or data engineer alone</ul> | <ul><li>Heavily reliant on data scientist expertise to implement<li>Manual releases each time</ul> |

## Level 1: DevOps no MLOps

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data scientists: siloed, not in regular communications with the larger team<li>Data engineers (if exists): siloed, not in regular communication with the larger team<li>Software engineers: siloed, receive model remotely from the siloed team members</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute is or isn't managed<li>Experiments aren't predictably tracked<li>End result may be a single model file manually handed off with inputs/outputs</ul> | <ul><li>Manual process<li>Scoring script may be manually created well after experiments, likely version controlled<li>Is handed off to Software engineers</ul> | <ul><li>Basic integration tests exist for the model<li>Heavily reliant on data scientist expertise to implement model<li>Releases automated<li>Application code has unit tests</ul> |

## Level 2: Automated Training

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data scientists: Working directly with data engineers to convert experimentation code into repeatable scripts/jobs<li>Data engineers: Working with Data scientists<li>Software engineers: siloed, receive model remotely from the siloed team members</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute managed<li>Experiment results tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Manual release<li>Scoring script is version controlled with tests<li>Release managed by Software engineering team</ul> | <ul><li>Basic integration tests exist for the model<li>Heavily reliant on data scientist expertise to implement model<li>Application code has unit tests</ul> |

## Level 3: Automated Model Deployment

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data scientists: Working directly with data engineers to convert experimentation code into repeatable scripts/jobs<li>Data engineers: Working with data scientists and Software engineers to manage inputs/outputs<li>Software engineers: Working with data engineers to automate model integration into application code</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute managed<li>Experiment results tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Automatic release<li>Scoring script is version controlled with tests<li>Release managed by CI/CD pipeline</ul> | <ul><li>Unit and Integration tests for each model release<li>Less reliant on data scientist expertise to implement model<li>Application code has unit/integration tests</ul> |

## Level 4: Full MLOps Automated Retraining

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data scientists: Working directly with data engineers to convert experimentation code into repeatable scripts/jobs. Working with Software engineers to identify markers for data engineers<li>Data engineers: Working with data scientists and Software engineers to manage inputs/outputs<li>Software engineers: Working with data engineers to automate model integration into application code. Implementing post-deployment metrics gathering</ul> | <ul><li>Data pipeline gathers data automatically<li>Retraining triggered automatically based on production metrics<li>Compute managed<li>Experiment results tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Automatic Release<li>Scoring Script is version controlled with tests<li>Release managed by continuous integration and continuous delivery (CI/CD) pipeline</ul> | <ul><li>Unit and Integration tests for each model release<li>Less reliant on data scientist expertise to implement model<li>Application code has unit/integration tests</ul> |