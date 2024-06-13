---
title: Machine learning operations (MLOps) v2
description: Learn about a single deployable set of repeatable, and maintainable patterns for creating machine learning CI/CD and retraining pipelines.
author: sdonohoo
ms.author: robbag
ms.date: 08/04/2022
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-machine-learning
  - azure-pipelines
  - azure-arc
  - azure-synapse-analytics
  - azure-event-hubs
categories:
  - ai-machine-learning
---

# Machine learning operations (MLOps) v2

This article describes three Azure architectures for machine learning operations. They all have end-to-end continuous integration (CI), continuous delivery (CD), and retraining pipelines. The architectures are for these AI applications:

- Classical machine learning
- Computer vision (CV)
- Natural language processing (NLP)

The architectures are the product of the MLOps v2 project. They incorporate the best practices that the solution architects discovered in the process of creating multiple machine learning solutions. The result is deployable, repeatable, and maintainable patterns as described here.

All of the architectures use the Azure Machine Learning service.

For an implementation with sample deployment templates for MLOps v2, see [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2) on GitHub.

## Potential use cases

- Classical machine learning: Time-Series forecasting, regression, and classification on tabular structured data are the most common use cases in this category. Examples are:
  - Binary and multi-label classification
  - Linear, polynomial, ridge, lasso, quantile, and Bayesian regression
  - ARIMA, autoregressive (AR), SARIMA, VAR, SES, LSTM
- CV: The MLOps framework presented here focuses mostly on the CV use cases of segmentation and image classification.
- NLP: This MLOps framework can implement any of those use cases, and others not listed:
  - Named entity recognition
  - Text classification
  - Text generation
  - Sentiment analysis
  - Translation
  - Question answering
  - Summarization
  - Sentence detection
  - Language detection
  - Part-of-speech tagging

Simulations, deep reinforcement learning, and other forms of AI aren't covered by this article.

## Architecture

The MLOps v2 architectural pattern is made up of four main modular elements that represent these phases of the MLOps lifecycle:

- Data estate
- Administration and setup
- Model development (inner loop)
- Model deployment (outer loop)

These elements, the relationships between them, and the personas typically associated with them are common for all MLOps v2 scenario architectures. There can be variations in the details of each, depending on the scenario.

The base architecture for MLOps v2 for Machine Learning is the classical machine learning scenario on tabular data. The CV and NLP architectures build on and modify this base architecture.

### Current architectures

The architectures currently covered by MLOps v2 and discussed in this article are:

- [Classical machine learning architecture](#classical-machine-learning-architecture)
- [Machine Learning CV architecture](#machine-learning-cv-architecture)
- [Machine Learning NLP architecture](#machine-learning-nlp-architecture)

### Classical machine learning architecture

:::image type="content" source="_images/classical-ml-architecture.png" lightbox="_images/classical-ml-architecture.png" alt-text="Diagram for the classical machine learning architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-classical-ml.vsdx) of this architecture.*

#### Workflow for the classical machine learning architecture

1. Data estate

   This element illustrates the data estate of the organization, and potential data sources and targets for a data science project. Data engineers are the primary owners of this element of the MLOps v2 lifecycle. The Azure data platforms in this diagram are neither exhaustive nor prescriptive. The data sources and targets that represent recommended best practices based on the customer use case are indicated by a green check mark.

1. Administration and setup

   This element is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to creation and management of resources and roles associated with the project. These can include the following tasks, and perhaps others:
   1. Creation of project source code repositories
   1. Creation of Machine Learning workspaces by using Bicep or Terraform
   1. Creation or modification of datasets and compute resources that are used for model development and deployment
   1. Definition of project team users, their roles, and access controls to other resources
   1. Creation of CI/CD pipelines
   1. Creation of monitors for collection and notification of model and infrastructure metrics

   The primary persona associated with this phase is the infrastructure team, but there can also be data engineers, machine learning engineers, and data scientists.

1. Model development (inner loop)

   The inner loop element consists of your iterative data science workflow that acts within a dedicated, secure Machine Learning workspace. A typical workflow is illustrated in the diagram. It proceeds from data ingestion, exploratory data analysis, experimentation, model development and evaluation, to registration of a candidate model for production. This modular element as implemented in the MLOps v2 accelerator is agnostic and adaptable to the process your data science team uses to develop models.

   Personas associated with this phase include data scientists and machine learning engineers.

1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, the model can be registered in the Machine Learning workspace registry. CI pipelines that are triggered, either automatically by model registration or by gated human-in-the-loop approval, promote the model and any other model dependencies to the model deployment phase.

   Personas associated with this stage are typically machine learning engineers.

1. Model deployment (outer loop)

   The model deployment or outer loop phase consists of pre-production staging and testing, production deployment, and monitoring of model, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining, as criteria that are appropriate to your organization and use case are satisfied.

   Personas associated with this phase are primarily machine learning engineers.

1. Staging and test

   The staging and test phase can vary with customer practices but typically includes operations such as retraining and testing of the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated, secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, it can be promoted to production by using a human-in-the-loop gated approval. Model deployment options include a managed batch endpoint for batch scenarios or, for online, near-real-time scenarios, either a managed online endpoint or Kubernetes deployment by using Azure Arc. Production typically takes place in one or more dedicated, secure Machine Learning workspaces.

1. Monitoring

   Monitoring in staging, test, and production makes it possible for you to collect metrics for, and act on, changes in performance of the model, data, and infrastructure. Model and data monitoring can include checking for model and data drift, model performance on new data, and responsible AI issues. Infrastructure monitoring can watch for slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   Based on criteria for model and data matters of concern such as metric thresholds or schedules, automated triggers and notifications can implement appropriate actions to take. This can be regularly scheduled automated retraining of the model on newer production data and a loopback to staging and test for pre-production evaluation. Or, it can be due to triggers on model or data issues that require a loopback to the model development phase where data scientists can investigate and potentially develop a new model.

1. Infrastructure monitoring: events and actions

   Based on criteria for infrastructure matters of concern such as endpoint response lag or insufficient compute for the deployment, automated triggers and notifications can implement appropriate actions to take. They trigger a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure the compute and network resources.

### Machine Learning CV architecture

:::image type="content" source="_images/computer-vision-architecture.png" lightbox="_images/computer-vision-architecture.png" alt-text="Diagram for the computer vision architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-computer-vision.vsdx) of this architecture.*

#### Workflow for the CV architecture

The Machine Learning CV architecture is based on the classical machine learning architecture, but it has modifications that are particular to supervised CV scenarios.

1. Data estate

   This element illustrates the data estate of the organization and potential data sources and targets for a data science project. Data engineers are the primary owners of this element of the MLOps v2 lifecycle. The Azure data platforms in this diagram are neither exhaustive nor prescriptive. Images for CV scenarios can come from many different data sources. For efficiency when developing and deploying CV models with Machine Learning, recommended Azure data sources for images are Azure Blob Storage and Azure Data Lake Storage.

1. Administration and setup

   This element is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to creation and management of resources and roles associated with the project. For CV scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning, but with an additional step: create image labeling and annotation projects by using the labeling feature of Machine Learning or another tool.

1. Model development (inner loop)

   The inner loop element consists of your iterative data science workflow performed within a dedicated, secure Machine Learning workspace. The primary difference between this workflow and the classical machine learning scenario is that image labeling and annotation is a key element of this development loop.

1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, the model can be registered in the Machine Learning workspace registry. CI pipelines that are triggered either automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.

1. Model deployment (outer loop)

   The model deployment or outer loop phase consists of pre-production staging and testing, production deployment, and monitoring of model, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining as criteria appropriate to your organization and use case are satisfied.

1. Staging and test

   The staging and test phase can vary with customer practices but typically includes operations such as test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. For CV scenarios, retraining of the model candidate on production data can be omitted due to resource and time constraints. Instead, the data science team can use production data for model development, and the candidate model that's registered from the development loop is the model that's evaluated for production. This phase takes place in one or more dedicated, secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, it can be promoted to production via human-in-the-loop gated approvals. Model deployment options include a managed batch endpoint for batch scenarios or, for online, near-real-time scenarios, either a managed online endpoint or Kubernetes deployment by using Azure Arc. Production typically takes place in one or more dedicated, secure Machine Learning workspaces.

1. Monitoring

   Monitoring in staging, test, and production makes it possible for you to collect metrics for, and act on, changes in the performance of the model, data, and infrastructure. Model and data monitoring can include checking for model performance on new images. Infrastructure monitoring can watch for slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   The data and model monitoring and event and action phases of MLOps for NLP are the key differences from classical machine learning. Automated retraining is typically not done in CV scenarios when model performance degradation on new images is detected. In this case, new images for which the model performs poorly must be reviewed and annotated by a human-in-the-loop process, and often the next action goes back to the model development loop for updating the model with the new images.

1. Infrastructure monitoring: events and actions

   Based on criteria for infrastructure matters of concern such as endpoint response lag or insufficient compute for the deployment, automated triggers and notifications can implement appropriate actions to take. This triggers a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure environment, compute, and network resources.

### Machine Learning NLP architecture

:::image type="content" source="_images/natural-language-processing-architecture.png" lightbox="_images/natural-language-processing-architecture.png" alt-text="Diagram for the N L P architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-natural-language-processing.vsdx) of this architecture.*

#### Workflow for the NLP architecture

The Machine Learning NLP architecture is based on the classical machine learning architecture, but it has some modifications that are particular to NLP scenarios.

1. Data estate

   This element illustrates the organization data estate and potential data sources and targets for a data science project. Data engineers are the primary owners of this element of the MLOps v2 lifecycle. The Azure data platforms in this diagram are neither exhaustive nor prescriptive. Data sources and targets that represent recommended best practices based on the customer use case are indicated by a green check mark.
1. Administration and setup

   This element is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to creation and management of resources and roles associated with the project. For NLP scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning, but with an additional step: create image labeling and annotation projects by using the labeling feature of Machine Learning or another tool.
1. Model development (inner loop)

   The inner loop element consists of your iterative data science workflow performed within a dedicated, secure Machine Learning workspace. The typical NLP model development loop can be significantly different from the classical machine learning scenario in that annotators for sentences and tokenization, normalization, and embeddings for text data are the typical development steps for this scenario.
1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, the model can be registered in the Machine Learning workspace registry. CI pipelines that are triggered either automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.
1. Model deployment (outer loop)

   The model deployment or outer loop phase consists of pre-production staging and testing, production deployment, and monitoring of the model, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining, as criteria for your organization and use case are satisfied.
1. Staging and test

   The staging and test phase can vary with customer practices, but typically includes operations such as retraining and testing of the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated, secure Machine Learning workspaces.
1. Production deployment

   After a model passes the staging and test phase, it can be promoted to production by a human-in-the-loop gated approval. Model deployment options include a managed batch endpoint for batch scenarios or, for online, near-real-time scenarios, either a managed online endpoint or Kubernetes deployment by using Azure Arc. Production typically takes place in one or more dedicated, secure Machine Learning workspaces.
1. Monitoring

   Monitoring in staging, test, and production makes it possible for you to collect and act on changes in performance of the model, data, and infrastructure. Model and data monitoring can include checking for model and data drift, model performance on new text data, and responsible AI issues. Infrastructure monitoring can watch for issues such as slow endpoint response, inadequate compute capacity, and network problems.
1. Data and model monitoring: events and actions

   As with the CV architecture, the data and model monitoring and event and action phases of MLOps for NLP are the key differences from classical machine learning. Automated retraining isn't typically done in NLP scenarios when model performance degradation on new text is detected. In this case, new text data for which the model performs poorly must be reviewed and annotated by a human-in-the-loop process. Often the next action is to go back to the model development loop to update the model with the new text data.
1. Infrastructure monitoring: events and actions

   Based on criteria for infrastructure matters of concern such as endpoint response lag or insufficient compute for the deployment, automated triggers and notifications can implement appropriate actions to take. They trigger a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure the compute and network resources.

### Components

- [Machine Learning](https://azure.microsoft.com/services/machine-learning): A cloud service for training, scoring, deploying, and managing machine learning models at scale.
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines): This build and test system is based on Azure DevOps and is used for the build and release pipelines. Azure Pipelines splits these pipelines into logical steps called tasks.
- [GitHub](https://github.com): A code hosting platform for version control, collaboration, and CI/CD workflows.
- [Azure Arc](https://azure.microsoft.com/services/azure-arc): A platform for managing Azure and on-premises resources by using Azure Resource Manager. The resources can include virtual machines, Kubernetes clusters, and databases.
- [Kubernetes](https://kubernetes.io): An open-source system for automating deployment, scaling, and management of containerized applications.
- [Azure Data Lake](https://azure.microsoft.com/services/storage/data-lake-storage): A Hadoop-compatible file system. It has an integrated hierarchical namespace and the massive scale and economy of Blob Storage.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics): A limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs). A service that ingests data streams generated by client applications. It then ingests and stores streaming data, preserving the sequence of events received. Consumers can connect to the hub endpoints to retrieve messages for processing. Here we are taking advantage of the integration with Data Lake Storage.

## Additional considerations

### Persona-based RBAC

Managing access to machine learning data and resources is crucial. Role-Based Access Control (RBAC) provides a robust framework for controlling who can perform specific actions and access particular areas within solution. Design your identity segmentation strategy to align with the lifecycle of machine learning models in Azure Machine Learning and the personas involved in the process. Each persona has a specific role and set of responsibilities that should be reflected in their RBAC roles and group membership.

#### Example personas

Consider the following common personas in a ML workload which will inform the identity-based RBAC group design to support appropriate segmentation:

#### 1 - Data Scientist/ML Engineer
**Description**: The people doing the various ML and data science activities across the SLDC lifecycle for a project. This role's responsibilies include break and fix activities for the ML models, packages, and data, which sit outside of platform support expertise.  
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: Involves data exploration and preprocessing to model training, evaluation, and deployment, to solve complex business problems and generate insight.

##### 2 - Data Analyst
**Description**: The people doing the data analyst tasks required as an input to data science activities. 
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: This role involves working with data, performing analysis, and supporting model development and deployment activities.

##### R3 - Model Tester
**Description**: The compute process used in Staging & QA testing.
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: This role provides functional segregation from the CI/CD processes.

##### 4 - Business Stakeholders
**Description**: Business stakeholders attached to the project.
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: This role is [read-only](/azure/role-based-access-control/built-in-roles/general#reader) for the AML workspace components in development.

##### 5 - Project Lead (Data Science Lead)
**Description**: The Data Science lead in a project administration role for the AML workspace. 
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: This role would also have break/fix responsibility for the ML models and packages used.

##### 6 - Project Owner (Bus Owner)
**Description**: The Business stakeholders responsible for the AML workspace based upon data ownership. 
<br/>**Type**: Person.
<br/>**Project Specific**: Yes. 
<br/>**Notes**: This role is read-only for the AML workspace configuration and components in development. Production coverage will be provided by the data governance application.

##### 7 - Platform Technical Support
**Description**: The Technical support staff responsible for break/fix activities across the platform. This role would cover infrastructure, service, etc. But not the ML models, packages or data. These elements remain under the Data Scientist/ML Engineer role's responsibility. 
<br/>**Type**: Person.
<br/>**Project Specific**: No. 
<br/>**Notes**: While the role group is permanent, membership is only transient, based upon a Privileged Identity Management ([PIM](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure)) process for time boxed, evaluated access.

##### 8 - Model End User
**Description**: The End consumers of the ML Model. This role could be a downstream process or an individual. 
<br/>**Type**: Person and Process.
<br/>**Project Specific**: Yes. 

##### 9 - CI/CD processes
**Description**: The compute processes that releases/rolls back change across the platform environments.
<br/>**Type**: Process.
<br/>**Project Specific**: No. 

##### 10 - AML Workspace
**Description**: The [managed identities](/azure/machine-learning/how-to-setup-authentication?view=azureml-api-2&tabs=sdk) used by an AML workspace to interact with other parts of Azure.
<br/>**Type**: Person.
<br/>**Project Specific**: No. 
<br/>**Notes**: This persona represents the various services that make up an AML implementation, which interact with other parts of the platform, such as, the development workspace connecting with the development data store, etc.

##### 11 - Monitoring Processes
**Description**: The compute processes which monitor & alert based upon platform activities. 
<br/>**Type**: Process.
<br/>**Project Specific**: No. 

##### 12 - Data Governance Processes
**Description**: The compute process that scans the ML project and datastores for data governance.
<br/>**Type**: Process.
<br/>**Project Specific**: No. 

#### Identity RBAC

Using the previously described personas, here are examples of how RBAC can be applied to production (Staging / Test / Production environments based on the [current architectures](#current-architectures) section) and pre-production (Development based on the [current architectures](#current-architectures) section) environments using the following built-in Azure RBAC roles:  

**Key:**

**[Standard Roles](/azure/role-based-access-control/built-in-roles#general)**
-  R = [Reader](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/general#reader).
-  C = [Contributor](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/general#contributor).
-  O = [Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/general#owner).

**[Component Specific Roles](/azure/role-based-access-control/built-in-roles/ai-machine-learning)**
- ADS = [Azure Machine Learning Data Scientist](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-data-scientist)
- ACO = [Azure Machine Learning Compute Operator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-compute-operator)
- ACRPush = [Azure Container Registry Push](https://learn.microsoft.com/azure/container-registry/container-registry-roles?tabs=azure-cli#push-image)
- DOPA = [DevOps Project Administrators](https://learn.microsoft.com/azure/devops/organizations/security/look-up-project-administrators?view=azure-devops&tabs=preview-page)
- DOPCA = [DevOps Project Collection Administrators](https://learn.microsoft.com/azure/devops/organizations/security/look-up-project-collection-administrators?view=azure-devops).
- LAR = [Log Analytics Reader](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/analytics#log-analytics-reader).
- LAC = [Log Analytics Contributor](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/analytics#log-analytics-contributor).
- MR = [Monitoring Reader](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/monitor#monitoring-reader).
- MC = [Monitoring Contributor](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/monitor#monitoring-contributor).
- KVA = [Key Vault Administrator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/security#key-vault-administrator).
- KVR = [Key Vault Reader](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/security#key-vault-reader).

**Production Environment**

| Persona                          | AML Workspace | Key Vault | Azure Container Registry | Storage Account | Azure DevOps | Azure Artifacts | Log Analytics Workspace | Azure Monitor |
| -------------------------------- | ------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data Scientist                   |               |           | R                        |                 |              |                 | LAR                     | MR            |
| Data Analyst                     |               |           |                          |                 |              |                 |                         |               |
| Model Tester                     |               |           |                          |                 |              |                 |                         |               |
| Business Stakeholders            |               |           |                          |                 |              |                 |                         | MR            |
| Project Lead (Data Science Lead) | R             | R, KVR    | R                        |                 |              |                 | LAR                     | MR            |
| Project Owner (Bus Owner)        |               |           |                          |                 |              |                 |                         | MR            |
| Platform Technical Support       | O             | O, KVA    |                          |                 | DOPCA        | O               | O                       | O             |
| Model End User                   |               |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O             | O, KVA    | ACRPush                  |                 | DOPCA        | O               | O                       | O             |
| AML Workspace                    |               | R         | C                        | C               |              |                 |                         |               |
| Monitoring Processes             | R             |           |                          |                 |              |                 | LAR                     | MR            |
| Data Governance Processes        | R             |           | R                        | R               | R            | R               |                         |               |  |

All personas have an acess period for the life of the project except for the Platform Technical Support and CI/CD processes which have temporary, or just-in-time access.

**Pre-Production Environment**

| Persona                          | AML Workspace | Key Vault | Azure Container Registry | Storage Account | Azure DevOps | Azure Artifacts | Log Analytics Workspace | Azure Monitor |
| -------------------------------- | ------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data Scientist                   | ADS           | R, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Data Analyst                     | R             |           |                          | C               |              |                 | LAR                     | MC            |
| Model Tester                     | R             | R, KVR    | R                        | R               | R            | R               | LAR                     | MR            |
| Business Stakeholders            | R             |           | R                        | R               | R            | R               |                         |               |
| Project Lead (Data Science Lead) | C             | C, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Project Owner (Bus Owner)        | R             |           |                          | R               |              |                 |                         | MR            |
| Platform Technical Support       | O             | O, KVA    | O                        | O               | DOPCA        | O               | O                       | O             |
| Model End User                   |               |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O             | O, KVA    | ACRPush                  | O               | DOPCA        | O               | O                       | O             |
| AML Workspace                    |               | R, KVR    | C                        | C               |              |                 |                         |               |
| Monitoring Processes             | R             | R         | R                        | R               | R            | R               | LAC                     |               |
| Data Governance Processes        | R             |           | R                        | R               |              |                 |                         |               |  |

All personas have an acess period for the life of the project except for the Platform Technical Support which have temporary, or just-in-time access.

A persona-based RBAC approach can also leverage [Microsoft Entra groups](https://learn.microsoft.com/entra/fundamentals/how-to-manage-groups) to streamline access control. [Microsoft Entra groups](https://learn.microsoft.com/entra/fundamentals/how-to-manage-groups) are used to manage users that all need the same access and permissions to resources, such as potentially restricted apps and services. By creating groups for each persona you can assign the above RBAC roles that grant specific permissions based on their job function. This ensures efficient and secure access management within your MLOps environment.

RBAC plays a vital role in securing and streamlining MLOps workflows. By restricting access based on assigned roles, it mitigates security risks by preventing unauthorized users from accessing sensitive data (training data, models) and critical infrastructure (production pipelines). This not only safeguards against unauthorized activity but also ensures compliance with data privacy regulation while simplifying auditing by providing a clear record of access and permissions thereby making it easier to identify security gaps and track user activity.

### Package management

Throughout the MLOps lifecycle there are often dependencies on a wide range of packages, libraries, and binaries. These dependencies can be community developed, iterate with fast-paced development cycles, and require "Subject Matter Expert" (SME) knowledge to understand and use. This gives rise to the problem of needing to access many different assets (i.e. packages, libraries, and binaries) securely and free from vulnerabilities.

In the machine learning lifecycle this can introduce many challenges, such as:
- Data scientists often require large numbers of highly specialized packages, libraries or binaries as “building blocks” for ML solutions.
- Many of these packages are community developed, iterate with fast-paced development cycles, and required "Subject Matter Expert" (SME) knowledge to understand and use.
- Traditional approaches to software management for this requirement, often result in expensive, toil-filled processes, which act as a bottleneck on the delivery of value.

A suggested approach for managing these dependencies is to use a secure, self-serve, package management process. This process should be designed to allow data scientists to self-serve from a curated list of packages, while ensuring that the packages are secure and compliant with organizational standards.

This involved safelisting three industry standard ML package repositories, allowing self-serve from individual AML workspaces. Then, use an automated testing process during the deployment to scan the resulting solution containers. Failures would elegantly exit the deployment process and remove the container. The below diagram and process flow illustrates this process:

:::image type="content" source="_images/secure-aml-package.png" lightbox="_images/secure-aml-package.png" alt-text="Diagram showing the secure AML Package approach." border="false":::

**Process Flow**

1. Data scientists working within a specific AML workspace with [network configuration](/azure/machine-learning/how-to-access-azureml-behind-firewall?view=azureml-api-2&tabs=ipaddress%2Cpublic#recommended-configuration-for-training-and-deploying-models) applied, can self-serve ML packages on-demand from the ML package repositories. An exception process is required for everything else, using the [Private Storage](/azure/machine-learning/how-to-use-private-python-packages?view=azureml-api-1&viewFallbackFrom=azureml-api-2#use-a-repository-of-packages-from-private-storage) pattern, seeded/maintained via a centralized function.
2. AML delivers ML solutions as docker containers. As these solutions are developed, they are uploaded to the Azure Container Registry (ACR). [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) can be used to generate vulnerability assessments for your container image.
3. Solution deployment occurs via a CI/CD process. [Defender for DevOps](/azure/defender-for-cloud/defender-for-devops-introduction) is used across the stack to provide security posture management and threat protection.
4. Only if the solution container passes each of the security processes will it be deployed. Failure will result in the deployment elegantly exiting with error notifications, full  audit trails and the solution container being discarded

The above process flow provides a secure, self-serve, package management process for data scientists, while ensuring that the packages are secure and compliant with organizational standards.

### Monitoring

Model monitoring is a key consideration in the end-to-end lifecycle of machine learning systems. Unlike traditional software, where behavior is governed by fixed rules, machine learning models learn from data hence their performance can degrade over time. Therefore, when monitoring the performance of a models in production it is essential to monitor data-related aspects in addition to traditional software-based metrics. Monitoring activities are relevent for personas such as Data Scientists, Business Stakeholders, Project Leads, Project Owners, Platform Technical Support, CI/CD processes, and Monitoring Processes.

The suggested MVP monitoring for the [current architectures](#current-architectures) in MLOps V2 is:

#### Model Performance

##### Data Drift
&nbsp;&nbsp; **Description**: [Data drift](/azure/machine-learning/how-to-monitor-datasets?view=azureml-api-1&tabs=python) tracks changes in the distribution of a model's input data by comparing it to the model's training data or recent past production data.
<br/>&nbsp;&nbsp; **Environment**: Production.<br/>
&nbsp;&nbsp; **Implementation**: AML – [Model Monitoring](/azure/machine-learning/concept-model-monitoring?view=azureml-api-2#enabling-model-monitoring).
<br/>&nbsp;&nbsp; **Notes**: Data drift refactoring requires recent production datasets and outputs, to be available for comparison. <br/>

##### Usage
&nbsp;&nbsp; **Description**: Several model serving endpoint metrics to indicate quality and performance. 
<br/>&nbsp;&nbsp; **Environment**: All.<br/>
&nbsp;&nbsp; **Implementation**: Azure Monitor [AML metrics](/azure/azure-monitor/essentials/monitor-azure-resource?view=azureml-api-2).

##### Prediction Drift
&nbsp;&nbsp; **Description**: Prediction drift tracks changes in the distribution of a model's prediction outputs by comparing it to validation or test labeled data or recent past production data.
<br/>&nbsp;&nbsp; **Environment**: Production.<br/>
&nbsp;&nbsp; **Implementation**: Azure Monitor [AML metrics](/azure/azure-monitor/essentials/monitor-azure-resource?view=azureml-api-2).
<br/>&nbsp;&nbsp; **Notes**: Prediction drift refactoring requires recent production datasets and outputs, to be available for comparison.  <br/>

#### Usage

##### Client Requests
&nbsp;&nbsp; **Description**: Count of the Client Requests to the model endpoint.
<br/>&nbsp;&nbsp; **Environment**: Production.<br/>
&nbsp;&nbsp; **Implementation**;
<br/>&nbsp;&nbsp; - Machine Learning Services - [OnlineEndpoints](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics). <br/>
&nbsp;&nbsp; - Count of [RequestsPerMinute](/azure/machine-learning/monitor-azure-machine-learning-reference?view=azureml-api-2#supported-metrics-for-microsoftmachinelearningservicesworkspacesonlineendpoints).
<br/>&nbsp;&nbsp; **Notes**: Acceptable thresholds could be aligned to t-shirt sizing or anomalies (acknowledging the need to establish a baseline).<br/>
&nbsp;&nbsp; - When a model is no longer being used, it should be retired from production. 

##### Throttling Delays
&nbsp;&nbsp; **Description**: [Throttling Delays](/azure/azure-resource-manager/management/request-limits-and-throttling) in request and response in data transfer. 
<br/>&nbsp;&nbsp; **Environment**: Production.<br/>
&nbsp;&nbsp; **Implementation**; 
<br/>&nbsp;&nbsp; - [AMLOnlineEndpointTrafficLog](/azure/machine-learning/monitor-resource-reference?view=azureml-api-2#amlonlineendpointtrafficlog-table-preview\).<br/>
&nbsp;&nbsp; - Sum of RequestThrottlingDelayMs. 
<br/>&nbsp;&nbsp; - ResponseThrottlingDelayMs.<br/>
&nbsp;&nbsp; **Notes**: Acceptable thresholds should be aligned to the workload's Service Level Object (or Service Level Agreement) and the solution's non-functional requirements (NFRs).

##### Errors Generated
&nbsp;&nbsp; **Description**: Response Code - Errors generated.
<br/>&nbsp;&nbsp; **Environment**: Production.<br/>
&nbsp;&nbsp; **Implementation**; 
<br/>&nbsp;&nbsp; - [AMLOnlineEndpointTrafficLog](/azure/machine-learning/monitor-resource-reference?view=azureml-api-2#amlonlineendpointtrafficlog-table-preview\).<br/>
&nbsp;&nbsp; - Count of XRequestId by ModelStatusCode. 
<br/>&nbsp;&nbsp; - Count of XRequestId by ModelStatusCode & ModelStatusReason.<br/>
&nbsp;&nbsp; **Notes**: All HTTP responses codes in the 400 & 500 range would be classified as an error.


#### Budget Boundaries

##### Deployment
&nbsp;&nbsp; **Description**: When monthly Operating expenses (OPEX), based on usage or cost, reaches or exceeds a predefined amount.
<br/>&nbsp;&nbsp; **Environment**: All.<br/>
&nbsp;&nbsp; **Implementation**: Azure – [Budget Alerts](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending#budget-alerts).
<br/>&nbsp;&nbsp; **Notes**;<br/>
&nbsp;&nbsp; - Budget thresholds should be set based upon the initial NFR’s and cost estimates.
<br/>&nbsp;&nbsp; - Multiple threshold tiers should be used, ensuring stakeholders get appropriate warning before the budget is exceeded.<br/>
&nbsp;&nbsp; - Consistent budget alerts could also be a trigger for refactoring to support greater demand.

#### Workspace

##### Staleness
&nbsp;&nbsp; **Description**: When an AML workspace no longer appears to have active use.
<br/>&nbsp;&nbsp; **Environment**: Development.<br/>
&nbsp;&nbsp; **Implementation**;
<br/>&nbsp;&nbsp; - [Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource?view=azureml-api-2) AML metrics; <br/>
&nbsp;&nbsp; - Machine Learning Services - [Workspaces](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-metrics) - count of Active Cores over a period. 
<br/>&nbsp;&nbsp; **Notes**;
&nbsp;&nbsp; - Active Cores should equal zero with aggregation of count.
<br/>&nbsp;&nbsp; - Date thresholds should be aligned to the project schedule. <br/>

#### Security Controls inc. RBAC

##### Workload
&nbsp;&nbsp; **Description**: Ensuring the appropriate security controls and baseline are implemented and not deviated from. 
<br/>&nbsp;&nbsp; **Environment**: All.<br/>
&nbsp;&nbsp; **Implementation**;
<br/>&nbsp;&nbsp; - Azure – [Policies](/azure/machine-learning/how-to-integrate-azure-policy?view=azureml-api-2#policies-for-azure-machine-learning). <br/>
&nbsp;&nbsp; - Including the “[Audit usage of custom RBAC roles](https://portal.azure.com/#view/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa451c1ef-c6ca-483d-87ed-f49761e3ffb5)”.
<br/>&nbsp;&nbsp; **Notes**;. <br/>
&nbsp;&nbsp; - The full listing of available [in-built policies](/azure/governance/policy/samples/built-in-policies?view=azureml-api-2#machine-learning) is available for AML.
<br/>&nbsp;&nbsp; - Other components/services used in this design should also have their specific in-built policies reviewed and implemented where appropriate. <br/>

#### Deployment

##### Standards/Governance
&nbsp;&nbsp; **Description**: Ensuring the appropriate standards and guardrails are adhered too. 
<br/>&nbsp;&nbsp; **Environment**: Azure & CI/CD.<br/>
&nbsp;&nbsp; **Implementation**;
<br/>&nbsp;&nbsp; - Azure – [DevOps Pipelines](/azure/governance/policy/tutorials/policy-devops-pipelines).<br/>
&nbsp;&nbsp; - [PSRule](https://azure.github.io/enterprise-azure-policy-as-code/) for Azure.
<br/>&nbsp;&nbsp; - [Enterprise policy as code](https://azure.github.io/enterprise-azure-policy-as-code/) (EPAC) (azure.github.io).<br/>
&nbsp;&nbsp; **Notes**;
<br/>&nbsp;&nbsp; - [PSRule]( https://github.com/microsoft/PSRule) provides a testing framework for Azure Infrastructure as Code (IaC).<br/>
&nbsp;&nbsp; - [EPAC](https://azure.github.io/enterprise-azure-policy-as-code/) can be used in CI/CD based system deploy Policies, Policy Sets, Assignments, Policy Exemptions and Role Assignments.
<br/>&nbsp;&nbsp; - Microsoft guidance is available in the [Azure guidance for AML regulatory compliance](/azure/machine-learning/security-controls-policy?view=azureml-api-2).<br/>

##### Security Scanning
&nbsp;&nbsp; **Description**: Automated security scanning is executed as part of the automated integration and deployment processes. 
<br/>&nbsp;&nbsp; **Environment**: CI/CD.<br/>
&nbsp;&nbsp; **Implementation**: Azure – [Defender For DevOps](/azure/defender-for-cloud/defender-for-devops-introduction).
<br/>&nbsp;&nbsp; **Notes**: This processes can be extended with [Azure marketplace](https://marketplace.visualstudio.com/search?term=security&target=AzureDevOps&category=All%20categories&sortBy=Relevance) for 3rd party security testing modules. <br/>

##### Ongoing service
&nbsp;&nbsp; **Description**: A development model appearing provide a regular service that should be productionised.
<br/>&nbsp;&nbsp; **Environment**: Development. <br/>
&nbsp;&nbsp; **Implementation**;
<br/>&nbsp;&nbsp; - [Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource?view=azureml-api-2) AML metrics. <br/>
&nbsp;&nbsp; - [AMLOnlineEndpointTrafficLog](/azure/machine-learning/monitor-resource-reference?view=azureml-api-2#amlonlineendpointtrafficlog-table-preview) - count of XMSClientRequestId over a month. 
<br/>&nbsp;&nbsp; **Notes**: Date thresholds should be aligned to the project schedule. <br/>

#### Model

##### Endpoint Security
&nbsp;&nbsp; **Description**: Targeted security monitoring of any AML endpoint.
<br/>&nbsp;&nbsp; **Environment**: All.<br/>
&nbsp;&nbsp; **Implementation**: Azure – [Defender For APIs](/azure/defender-for-cloud/defender-for-apis-introduction).


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Scott Donohoo](https://www.linkedin.com/in/scottdonohoo) | Senior Cloud Solution Architect
- [Moritz Steller](https://www.linkedin.com/in/moritz-steller-426430116/) | Senior Cloud Solution Architect

Other contributors:

- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect
- [Darren Turchiarelli](https://www.linkedin.com/in/darren-turchiarelli/) | Cloud Solution Architect
- [Leo Kozhushnik](https://www.linkedin.com/in/leo-kozhushnik-ab16707/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Arc overview](/azure/azure-arc/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Data in Azure Machine Learning](/azure/machine-learning/concept-data)
- [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2)
- [End-to-end machine learning operations (MLOps) with Azure Machine Learning](/training/paths/build-first-machine-operations-workflow)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure DevOps documentation](/azure/devops)
- [GitHub Docs](https://docs.github.com)
- [Azure Synapse Analytics documentation](/azure/synapse-analytics)
- [Azure Event Hubs documentation](/azure/event-hubs)

## Related resources

- [Choose a Microsoft Azure AI services technology](../../data-guide/technology-choices/cognitive-services.md)
- [Natural language processing technology](../../data-guide/technology-choices/natural-language-processing.yml)
- [Compare the machine learning products and technologies from Microsoft](../../ai-ml/guide/data-science-and-machine-learning.md)
- [How Azure Machine Learning works: resources and assets (v2)](/azure/machine-learning/concept-azure-machine-learning-v2)
- [What are Azure Machine Learning pipelines?](/azure/machine-learning/concept-ml-pipelines)
- [Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](mlops-technical-paper.yml)
- [What is the Team Data Science Process?](/azure/architecture/data-science-process/overview)
