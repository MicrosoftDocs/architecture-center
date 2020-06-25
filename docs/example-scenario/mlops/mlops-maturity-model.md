---
title: MLOps Maturity Model
titleSuffix: Technical Description
description: Detailed explanation of the MLOps Maturity Model stages and defining characteristics of each stage.
author: danazlin
ms.author: dermar
ms.date: 06/01/2020
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
ms.category:
    - developer-tools
    - hybrid
social_image_url: /azure/architecture/example-scenario/serverless/media/mlops.png

---

# MLOps Maturity Model

## Purpose

The purpose of this maturity model is to help clarify the MLOps principles and practices that can be targeted to represent continuous improvement in the creation and operation of a production level Machine Learning (ML) application environment. It is intended to be used as a metric for establishing the progressive requirements needed to measure the maturity of the ML production environment and its associated processes. It is also useful for estimating the scope of the work required for a new ML project, establish some success criteria, and identify project deliverables.

## Maturity Model

The MLOps Maturity Model helps clarify the DevOps principles and practices necessary to identify gaps in an existing organization's attempt to implement a sustainable production level MLOps environment. It is also a way to show a customer how to incrementally grow their MLOps capability rather than overwhelming them with the requirements of a fully mature environment. Thus, it should be used as a guide to estimate the scope of the work for new engagements, establish realistic success criteria, and identify deliverables to be handed over at the conclusion of the engagement.

As with most maturity models, the MLOps maturity model assesses qualitatively people/culture, processes/structures, and objects/technology. As the maturity level increases, the probability increases that incidents or errors will lead to improvements either in the quality and/or in the use of the development and production processes.

The MLOps Maturity Model is built upon the following levels of technical capability:  

| Level | Description | Highlights | Technology |
| ----- | ----------- | ---------- | ---------- |
| 0 | No Ops | Difficult to Manage full ML model lifecycle<br>Teams are disparate & releases are painful<br>Most systems exist as "black boxes," little feedback during/post deployment | Manual builds and deployments<br>Manual testing of model and application<br>No centralized tracking of model performance<br>Training of model is manual |
| 1 | DevOps but no MLOps | Releases are less painful but rely on Data Team for every new model<br>Still very limited feedback on how well a model performs in production<br>Difficult to trace/reproduce results | Automated builds<br>Automated tests for application code |
| 2 | Automated Training | Training environment is fully managed & traceable<br>Easy to reproduce model<br>Releases are manual, but low friction | Automated Model Training<br>Centralized tracking of model training performance<br>Model Management |
| 3 | Automated Model Deployment | Releases are low friction & automatic<br>Full traceability from deployment back to original data<br>Entire environment is managed: train > test > production | Integrated A/B testing of model performance for deployment<br>Automated tests for all code<br>Centralized traing of model training performance |
| 4 | Full MLOps - Automated Operations | Full system is automated and easily monitored<br>Production systems are providing information on how to improve and, in some cases, automatically improving with new models<br>Approaching a zero-downtime system | Automated model training and testing<br>Verbose, centralized metrics from deployed model |

Within these levels, the tables that follow identify the details characteristic for that level of process maturity. While the model will continue to evolve, this version was last updated in January 2020.

## Level 0: No MLOps

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data Scientists - siloed, not in regular comms with larger team<li>Data Engineers - siloed (if exists), not in regular comms with larger team<li>Software Engineers - siloed, receive model "over the wall"</ul> | <ul><li>Data is gathered manually<li>Compute is likely not managed<li>Experiments are not predictably tracked<li>End result may be a single file manually handed off (model), with inputs/outputs</ul> | <ul><li>Manual process<li>Scoring script may be manually created well after experiments, not version controlled<li>Release may be handled by Data Scientist or Data Engineer alone</ul> | <ul><li>Heavily reliant on Data Scientist expertise to implement<li>Manual releases each time</ul> |

## Level 1: DevOps no MLOps

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data Scientists - siloed, not in regular comms with larger team<li>Data Engineers - siloed (if exists), not in regular comms with larger team<li>Software Engineers - siloed, receive model "over the wall"</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute may or may not be managed<li>Experiments are not predictably tracked<li>End result may be a single file manually handed off (model), with inputs/outputs</ul> | <ul><li>Manual process<li>Scoring script may be manually created well after experiments, likely version controlled<li>Is handed off to Software Engineers</ul> | <ul><li>Basic integration tests exist for the model<li>Heavily reliant on Data Scientist expertise to implement model<li>Releases are automated<li>Application code has unit tests</ul> |

## Level 2: Automated Training

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs<li>Data Engineers - Working with Data Scientists<li>Software Engineers - siloed, receive model "over the wall"</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute is managed<li>Experiment results are tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Manual Release<li>Scoring Script is version controlled with tests<li>Release is managed by Software engineering team</ul> | <ul><li>Basic integration tests exist for the model<li>Heavily reliant on Data Scientist expertise to implement model<li>Application code has unit tests</ul> |

## Level 3: Automated Model Deployment

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs<li>Data Engineers - Working with Data Scientists and Software Engineers to manage inputs/outputs<li>Software Engineers - Working with Data Engineers to automate model integration into application code</ul> | <ul><li>Data pipeline gathers data automatically<li>Compute is managed<li>Experiment results are tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Automatic Release<li>Scoring Script is version controlled with tests<li>Release is managed by CI/CD pipeline</ul> | <ul><li>Unit and Integration tests for each model release<li>Less reliant on Data Scientist expertise to implement model<li>Application code has unit/integration tests</ul> |

## Level 4: Full MLOps - Automated Retraining

| People | Model Creation | Model Release | Application Integration |
| ------ | -------------- | ------------- | ----------------------- |
| <ul><li>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs. Working with Software Engineers to identify markers for Data Engineers<li>Data Engineers - Working with Data Scientists and Software Engineers to manage inputs/outputs<li>Software Engineers - Working with Data Engineers to automate model integration into application code. Implementing metrics gathering post-deployment</ul> | <ul><li>Data pipeline gathers data automatically<li>Retraining triggered automatically based on production metrics<li>Compute is managed<li>Experiment results are tracked<li>Both training code and resulting models are version controlled</ul> | <ul><li>Automatic Release<li>Scoring Script is version controlled with tests<li>Release is managed by CI/CD pipeline</ul> | <ul><li>Unit and Integration tests for each model release<li>Less reliant on Data Scientist expertise to implement model<li>Application code has unit/integration tests</ul> |

## Credits

Taylor Rockey (tarockey); David Tesar (davete); Sushant Divate (sudivate)
