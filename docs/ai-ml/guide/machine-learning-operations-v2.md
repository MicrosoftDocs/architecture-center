---
title: Machine learning operations (MLOps) v2
description: Learn about a single deployable set of repeatable and maintainable patterns for creating machine learning CI/CD and retraining pipelines.
author: sdonohoo
ms.author: robbag
ms.date: 07/01/2024
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

This article describes three Azure architectures for machine learning operations that all have end-to-end continuous integration (CI), continuous delivery (CD), and retraining pipelines. The architectures are for these AI applications:

- Classical machine learning
- Computer vision (CV)
- Natural language processing (NLP)

These architectures were created during the MLOps v2 project and incorporate best practices that solution architects identified in the process of developing various machine learning solutions. The result is deployable, repeatable, and maintainable patterns. All three architectures use the Azure Machine Learning service.

For an implementation with sample deployment templates for MLOps v2, see [Azure MLOps v2 solution accelerator](https://github.com/Azure/mlops-v2).

## Potential use cases

- Classical machine learning: Time-Series forecasting, regression, and classification on tabular structured data are the most common use cases in this category. Examples include:

  - Binary and multi-label classification
  
  - Linear, polynomial, ridge, lasso, quantile, and Bayesian regression
  
  - ARIMA, autoregressive (AR), SARIMA, VAR, SES, LSTM
  
- CV: The MLOps framework presented in this article focuses mostly on the CV use cases of segmentation and image classification.

- NLP: This MLOps framework can implement any of the following use cases, and other use cases that aren't listed:

  - Named entity recognition (NER)
  
  - Text classification
  
  - Text generation
  
  - Sentiment analysis
  
  - Translation
  
  - Question answering
  
  - Summarization
  
  - Sentence detection
  
  - Language detection
  
  - Part-of-speech tagging

AI simulations, deep reinforcement learning, and other forms of AI aren't described in this article.

## Architecture

The MLOps v2 architectural pattern is made up of four main modular components that represent the following phases of the MLOps lifecycle:

- Data estate
- Administration and setup
- Model development, or the inner loop phase
- Model deployment, or the outer loop phase

The preceding components, the connections between them, and the typical personas involved are standard across all MLOps v2 scenario architectures. Variations in the details of each component depend on the scenario.

The base architecture for MLOps v2 for Machine Learning is the classical machine learning scenario on tabular data. The CV and NLP architectures build on and modify this base architecture.

### Current architectures

The architectures currently covered by MLOps v2 and described in this article are:

- [Classical machine learning architecture](#classical-machine-learning-architecture)
- [Machine Learning CV architecture](#machine-learning-cv-architecture)
- [Machine Learning NLP architecture](#machine-learning-nlp-architecture)

### Classical machine learning architecture

:::image type="content" source="_images/classical-ml-architecture.png" lightbox="_images/classical-ml-architecture.png" alt-text="Diagram that shows the classical machine learning architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-classical-ml.vsdx) of this architecture.*

#### Workflow for the classical machine learning architecture

1. Data estate

   This component illustrates the data estate of the organization and potential data sources and targets for a data science project. Data engineers are the primary owners of this component of the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. A green check mark indicates the data sources and targets that represent recommended best practices that are based on the customer use case.

1. Administration and setup

   This component is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to the creation and management of resources and roles that are associated with the project. These tasks can include:

   1. Creation of project source code repositories
   1. Creation of Machine Learning workspaces by using Bicep or Terraform
   1. Creation or modification of datasets and compute resources that are used for model development and deployment
   1. Definition of project team users, their roles, and access controls to other resources
   1. Creation of continuous integration and continuous delivery (CI/CD) pipelines
   1. Creation of monitors for the collection and notification of model and infrastructure metrics

   The primary persona associated with this phase is the infrastructure team, but data engineers, machine learning engineers, and data scientists are also options.

1. Model development (inner loop phase)

   The inner loop phase consists of your iterative data science workflow that acts within a dedicated and secure Machine Learning workspace. The diagram shows a typical workflow. The process starts with data ingestion, moves through exploratory data analysis, experimentation, model development and evaluation, and culminates in registering a model for production use. This modular component as implemented in the MLOps v2 accelerator is agnostic and adaptable to the process that your data science team uses to develop models.

   Personas associated with this phase include data scientists and machine learning engineers.

1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, you can register the model in the Machine Learning workspace registry. CI pipelines that are triggered, either automatically by model registration or by gated human-in-the-loop approval, promote the model and any other model dependencies to the model deployment phase.

   Personas associated with this stage are typically machine learning engineers.

1. Model deployment (outer loop phase)

   The model deployment, or outer loop phase, consists of preproduction staging and testing, production deployment, and monitoring of models, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining when criteria that are appropriate to your organization and use case are met.

   Personas associated with this phase are primarily machine learning engineers.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as retraining and testing of the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, you can use a human-in-the-loop gated approval to promote it to production. Model deployment options include a managed batch endpoint for batch scenarios, or for online, near-real-time scenarios, you can use Azure Arc for a managed online endpoint or Kubernetes deployment. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

    Monitoring in staging, test, and production phases makes it possible for you to collect metrics for and to act on changes in performance of the model, data, and infrastructure. Model and data monitoring can include checking for model and data drift, model performance on new data, and responsible AI problems. Infrastructure monitoring can watch for slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   Based on the criteria for model and data matters of concern, such as metric thresholds or schedules, automated triggers and notifications can implement appropriate actions to take. These actions can be regularly scheduled automated retraining of the model on newer production data and a loopback to staging and test for preproduction evaluation. Or these actions can be due to triggers on model or data problems that require a loopback to the model development phase where data scientists can investigate and potentially develop a new model.

1. Infrastructure monitoring: events and actions

   Automated triggers and notifications can implement appropriate actions to take based on criteria for infrastructure matters of concern, such as endpoint response lag or insufficient compute for the deployment. Automatic triggers and notifications trigger a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure the compute and network resources.

### Machine Learning CV architecture

:::image type="content" source="_images/computer-vision-architecture.png" lightbox="_images/computer-vision-architecture.png" alt-text="Diagram that shows the computer vision architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-computer-vision.vsdx) of this architecture.*

#### Workflow for the CV architecture

The Machine Learning CV architecture is based on the classical machine learning architecture, but it has modifications that are specific to supervised CV scenarios.

1. Data estate

   This component demonstrates the data estate of the organization and potential data sources and targets for a data science project. Data engineers are the primary owners of this component of the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. Images for CV scenarios can come from many different data sources. For efficiency when developing and deploying CV models with Machine Learning, we recommend Azure Blob Storage and Azure Data Lake Storage for Azure data sources.

1. Administration and setup

   This component is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to the creation and management of resources and roles associated with the project. For CV scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning, but with an extra step. This step is using the labeling feature of Machine Learning or another tool to create image labeling and annotation projects.

1. Model development (inner loop phase)

   The inner loop phase consists of your iterative data science workflow performed within a dedicated and secure Machine Learning workspace. The primary difference between this workflow and the classical machine learning scenario is that image labeling and annotation is a key component of this development loop.

1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, you can register the model in the Machine Learning workspace registry. CI pipelines that are triggered automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.

1. Model deployment (outer loop phase)

   The model deployment or outer loop phase consists of preproduction staging and testing, production deployment, and monitoring of model, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining when criteria that are appropriate to your organization and use case are met.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. For CV scenarios, retraining of the model candidate on production data can be omitted due to resource and time constraints. The data science team can instead use production data for model development. The candidate model registered from the development loop is the model evaluated for production. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, it can be promoted to production through human-in-the-loop gated approvals. Model deployment options include a managed batch endpoint for batch scenarios, or for online, near-real-time scenarios, you can use Azure Arc for a managed online endpoint or Kubernetes deployment. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

   Monitoring in staging, test, and production phases makes it possible for you to collect metrics for and to act on changes in performance of the model, data, and infrastructure. Model and data monitoring can include checking for model performance on new images. Infrastructure monitoring can watch for slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   The data and model monitoring and event and action phases of MLOps for NLP are the key differences from classical machine learning. Automated retraining is typically not done in CV scenarios when model performance degradation on new images is detected. In this case, a human-in-the-loop process is necessary to review and annotate new text data for  the model that performs poorly. The next action often goes back to the model development loop to update the model with the new images.

1. Infrastructure monitoring: events and actions

   Based on criteria for infrastructure matters of concern, such as endpoint response lag or insufficient compute for the deployment, automated triggers and notifications can implement appropriate actions to take. This triggers a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure environment, compute, and network resources.

### Machine Learning NLP architecture

:::image type="content" source="_images/natural-language-processing-architecture.png" lightbox="_images/natural-language-processing-architecture.png" alt-text="Diagram for the NP architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-natural-language-processing.vsdx) of this architecture.*

#### Workflow for the NLP architecture

The Machine Learning NLP architecture is based on the classical machine learning architecture, but it has some modifications that are specific to NLP scenarios.

1. Data estate

   This component demonstrates the organization data estate and potential data sources and targets for a data science project. Data engineers are the primary owners of this component of the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. A green check mark indicates sources and targets that represent recommended best practices that are based on the customer use case.

1. Administration and setup

   This component is the first step in the MLOps v2 accelerator deployment. It consists of all tasks related to the creation and management of resources and roles associated with the project. For NLP scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning, but with an extra step: create image labeling and annotation projects by using the labeling feature of Machine Learning or another tool.

1. Model development (inner loop phase)

   The inner loop phase consists of your iterative data science workflow performed within a dedicated and secure Machine Learning workspace. The typical NLP model development loop can be different from the classical machine learning scenario in that annotators for sentences and tokenization, normalization, and embeddings for text data are the typical development steps for this scenario.

1. Machine Learning registries

   After the data science team develops a model that's a candidate for deploying to production, the model can be registered in the Machine Learning workspace registry. CI pipelines that are triggered automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.

1. Model deployment (outer loop phase)

   The model deployment or outer loop phase consists of preproduction staging and testing, production deployment, and monitoring of the model, data, and infrastructure. CD pipelines manage the promotion of the model and related assets through production, monitoring, and potential retraining, as criteria for your organization and use case are met.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as retraining and testing of the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, a human-in-the-loop gated approval can promote it to production. Model deployment options include a managed batch endpoint for batch scenarios, or for online, near-real-time scenarios, you can use Azure Arc for a managed online endpoint or Kubernetes deployment. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

   Monitoring in staging, test, and production phases makes it possible for you to collect metrics for and to act on changes in performance of the model, data, and infrastructure. Model and data monitoring can include checking for model and data drift, model performance on new text data, and responsible AI problems. Infrastructure monitoring can watch for problems such as slow endpoint response, inadequate compute capacity, and network problems.

1. Data and model monitoring: events and actions

   As with the CV architecture, the data and model monitoring and event and action phases of MLOps for NLP are the key differences from classical machine learning. Automated retraining isn't typically done in NLP scenarios when model performance degradation on new text is detected. In this case, a human-in-the-loop process is necessary to review and annotate new text data for the model that performs poorly. Often the next action is to go back to the model development loop to update the model with the new text data.

1. Infrastructure monitoring: events and actions

   Based on criteria for infrastructure matters of concern, such as endpoint response lag or insufficient compute for the deployment, automated triggers and notifications can implement appropriate actions to take. This triggers a loopback to the setup and administration phase where the infrastructure team can investigate and potentially reconfigure the compute and network resources.

### Components

- [Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud service that you can use to train, score, deploy, and manage machine learning models at scale.

- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) is a build and test system based on Azure DevOps and is used for the build and release pipelines. Azure Pipelines splits these pipelines into logical steps called *tasks*.

- [GitHub](https://github.com) is a code hosting platform for version control, collaboration, and CI/CD workflows.

- [Azure Arc](https://azure.microsoft.com/services/azure-arc) is a platform that uses Azure Resource Manager to manage Azure and on-premises resources. The resources can include virtual machines, Kubernetes clusters, and databases.

- [Kubernetes](https://kubernetes.io) is an open-source system for automating deployment, scaling, and management of containerized applications.

- [Azure Data Lake](https://azure.microsoft.com/services/storage/data-lake-storage) is a Hadoop-compatible file system. It has an integrated hierarchical namespace and the massive scale and economy of Blob Storage.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a service that ingests data streams generated by client applications. It then ingests and stores streaming data, which preserves the sequence of events received. Customers can connect to the hub endpoints to retrieve messages for processing. Integration with Data Lake Storage is used in this architecture.

## Other considerations

The preceding MLOps v2 architectural pattern is composed of several critical components, including role-based access control (RBAC) aligned to business stakeholders, efficient package management, and robust monitoring mechanisms. These components collectively contribute to the successful implementation and management of machine learning workflows.

### Persona-based RBAC

It's crucial that you manage access to machine learning data and resources. Role-based access control provides a robust framework to help you manage who can perform specific actions and access specific areas within your solution. Design your identity segmentation strategy to align with the lifecycle of machine learning models in Machine Learning and the personas included in the process. Each persona has a specific set of responsibilities that are reflected in their RBAC roles and group membership.

#### Example personas

To support appropriate segmentation, consider the following common personas in a machine learning workload that informs the [identity-based RBAC](#identity-rbac) group design.

##### Data scientist and ML engineer

Data scientists and ML engineers perform various machine learning and data science activities across the software development lifecycle (SDLC) of a project. Their duties include EDA and data preprocessing. Data scientists and ML engineers are responsible for training, evaluating, and deploying models. This role's responsibilities also include break-fix activities for machine learning models, packages, and data. These duties are out of scope for the platform’s technical support team.

**Type:** Person<br/>
**Project specific:** Yes

##### Data analyst

Data analysts provide the necessary input for data science activities, such as running SQL queries for business intelligence. This role includes working with data, performing data analysis, and supporting model development and model deployment activities.

**Type:** Person<br/>
**Project specific:** Yes

##### Model tester

Model testers conduct tests in testing and staging environments. This role provides functional segregation from the CI/CD processes.

**Type:** Person<br/>
**Project specific:** Yes

##### Business stakeholders

Business stakeholders are attached to the project, such as a marketing manager.

**Type:** Person<br/>
**Project specific:** Yes<br/>

##### Project lead or data science lead

The data science lead is a project administration role for the Machine Learning workspace. This role also has break-fix responsibility for the machine learning models and packages that are used.

**Type:** Person<br/>
**Project specific:** Yes

##### Project or product owner (Business owner)

Business stakeholders are responsible for the Machine Learning workspace according to data ownership.

**Type:** Person<br/>
**Project specific:** Yes

##### Platform technical support

Platform technical support is the technical support staff responsible for break-fix activities across the platform. This role covers infrastructure or service but not the machine learning models, packages, or data. These components remain under the Data scientist or ML engineer role, and are the Project lead's responsibility.

**Type:** Person<br/>
**Project specific:** No

##### Model end user

Model end users are the end consumers of the machine learning model.

**Type:** Person or Process<br/>
**Project specific:** Yes

##### CI/CD processes

CI/CD processes release or roll back changes across platform environments.

**Type:** Process<br/>
**Project specific:** No

##### Machine Learning workspace

 Machine Learning workspaces use [managed identities](/azure/machine-learning/how-to-setup-authentication) to interact with other parts of Azure. This persona represents the various services that make up a Machine Learning implementation. These services interact with other parts of the platform, such as the development workspace that connects with the development data store.

**Type:** Process<br/>
**Project specific:** No

##### Monitoring processes

Monitoring processes are compute processes that monitor and alert based on platform activities.

**Type:** Process<br/>
**Project specific:** No

##### Data governance processes

Data governance processes scan the machine learning project and datastores for data governance.

**Type:** Process<br/>
**Project specific:** No

#### Entra group membership

When you implement role-based access control (RBAC), [Microsoft Entra groups](/entra/fundamentals/how-to-manage-groups) provide a flexible and scalable way to manage access permissions across the different personas. You can use Microsoft Entra groups to manage users that all need the same access and permissions to resources, such as potentially restricted apps and services. Instead of adding special permissions to individual users, you create a group that applies the special permissions to every member of that group.

In this architectural pattern, you can couple these groups with the [Machine Learning workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup). This setup can be a project, team, or department. By associating users with defined groups, administrators can define fine-grained access policies. You can use fine-grained access policies to grant or restrict permissions based on job functions, project requirements, or other criteria, to different Machine Learning workspaces. For example, you can have a group that grants all data scientists access to a development workspace for a specific use-case.

#### Identity RBAC

Using the personas described previously, here are examples of how you can use the following built-in Azure RBAC roles to apply RBAC to production environments based on the [current architectures](#current-architectures) and preproduction environments based on the [current architectures](#current-architectures).

#### Standard roles

- R = [Reader](/azure/role-based-access-control/built-in-roles/general#reader)
- C = [Contributor](/azure/role-based-access-control/built-in-roles/general#contributor)
- O = [Owner](/azure/role-based-access-control/built-in-roles/general#owner)

#### Component specific roles

- ADS = [Machine Learning Data Scientist](/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-data-scientist)

- ACO = [Machine Learning Compute Operator](/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-compute-operator)

- ACRPush = [Azure Container Registry Push](/azure/container-registry/container-registry-roles#push-image)

- DOPA = [DevOps Project Administrators](/azure/devops/organizations/security/look-up-project-administrators)

- DOPCA = [DevOps Project Collection Administrators](/azure/devops/organizations/security/look-up-project-collection-administrators)

- LAR = [Log Analytics Reader](/azure/role-based-access-control/built-in-roles/analytics#log-analytics-reader)

- LAC = [Log Analytics Contributor](/azure/role-based-access-control/built-in-roles/analytics#log-analytics-contributor)

- MR = [Monitoring Reader](/azure/role-based-access-control/built-in-roles/monitor#monitoring-reader)

- MC = [Monitoring Contributor](/azure/role-based-access-control/built-in-roles/monitor#monitoring-contributor)

- KVA = [Key Vault Administrator](/azure/role-based-access-control/built-in-roles/security#key-vault-administrator)

- KVR = [Key Vault Reader](/azure/role-based-access-control/built-in-roles/security#key-vault-reader)

*The letters preceding these Azure RBAC roles are used in the following tables. Refer back to this list when reviewing the table.*

##### Production environment

| Persona                          | Machine Learning workspace | Key Vault | Container Registry | Storage Account | Azure DevOps | Azure Artifacts | Log Analytics workspace | Azure Monitor |
| -------------------------------- | -------------------------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data scientist                   |                                  |           | R                        |                 |              |                 | LAR                     | MR            |
| Data analyst                     |                                  |           |                          |                 |              |                 |                         |               |
| Model tester                     |                                  |           |                          |                 |              |                 |                         |               |
| Business stakeholders            |                                  |           |                          |                 |              |                 |                         | MR            |
| Project lead (Data science lead) | R                                | R, KVR    | R                        |                 |              |                 | LAR                     | MR            |
| Project/product owner            |                                  |           |                          |                 |              |                 |                         | MR            |
| Platform technical support       | O                                | O, KVA    |                          |                 | DOPCA        | O               | O                       | O             |
| Model end user                   |                                  |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O                                | O, KVA    | ACRPush                  |                 | DOPCA        | O               | O                       | O             |
| Machine Learning workspace |                                  | R         | C                        | C               |              |                 |                         |               |
| Monitoring processes             | R                                |           |                          |                 |              |                 | LAR                     | MR            |
| Data governance processes        | R                                |           | R                        | R               | R            | R               |                         |               |

> [!NOTE]
> All personas have an access period for the life of the project except for the Platform technical support and CI/CD processes which have temporary, [Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure), or just-in-time access.

##### Preproduction environments

| Persona                          | Machine Learning workspace | Key Vault | Container Registry | Storage Account | Azure DevOps | Azure Artifacts | Log Analytics workspace | Azure Monitor |
| -------------------------------- | -------------------------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data scientist                   | ADS                              | R, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Data analyst                     | R                                |           |                          | C               |              |                 | LAR                     | MC            |
| Model tester                     | R                                | R, KVR    | R                        | R               | R            | R               | LAR                     | MR            |
| Business stakeholders            | R                                |           | R                        | R               | R            | R               |                         |               |
| Project lead (Data science lead) | C                                | C, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Project/product owner            | R                                |           |                          | R               |              |                 |                         | MR            |
| Platform technical support       | O                                | O, KVA    | O                        | O               | DOPCA        | O               | O                       | O             |
| Model end user                   |                                  |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O                                | O, KVA    | ACRPush                  | O               | DOPCA        | O               | O                       | O             |
| Machine Learning workspace |                                  | R, KVR    | C                        | C               |              |                 |                         |               |
| Monitoring processes             | R                                | R         | R                        | R               | R            | R               | LAC                     |               |
| Data governance processes        | R                                |           | R                        | R               |              |                 |                         |               |

> [!NOTE]
> Every persona retains access for the project's duration, except Platform technical support, which has temporary or just-in-time [Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure) access.

A persona-based RBAC approach should use [Microsoft Entra groups](/entra/fundamentals/how-to-manage-groups) to streamline access control. You can use [Microsoft Entra groups](/entra/fundamentals/how-to-manage-groups) to manage users that all need the same access and permissions to resources, such as potentially restricted apps and services. By creating groups for each persona, you can assign the previous RBAC roles that grant specific permissions based on their job function. Specific permissions ensure efficient and secure access management within your MLOps environment.

RBAC plays a vital role in securing and streamlining MLOps workflows. By restricting access based on assigned roles, RBAC mitigates security risks by preventing unauthorized users from accessing sensitive data, such as training data or models, and critical infrastructure, such as production pipelines. Restricting access safeguards against unauthorized activity and ensures compliance with data privacy regulation. It also simplifies auditing by providing a clear record of access and permissions, which makes it easier to identify security gaps and track user activity.

### Package management

Dependencies on various packages, libraries, and binaries are common throughout the MLOps lifecycle. These dependencies, often community-developed and rapidly evolving, necessitate subject matter expert (SME) knowledge for proper use and understanding. The challenge lies in securely accessing diverse assets, such as packages and libraries, while avoiding vulnerabilities. Data scientists encounter this issue when assembling specialized building blocks for machine learning solutions. Traditional software management approaches can be costly and inefficient, which acts as a bottleneck on the delivery of value.

A suggested approach for managing these dependencies is to use a secure, self-serve, package management process based on the [Quarantine pattern](../../patterns/quarantine.yml). This process should be designed to allow data scientists to self-serve from a curated list of packages, while ensuring that the packages are secure and compliant with organizational standards.

This approach includes safe-listing three industry standard machine learning package repositories: Microsoft Artifact Registry, PyPI, and Conda. Safe-listing enables self-serve from individual Machine Learning workspaces. Then use an automated testing process during the deployment to scan the resulting solution containers. Failures elegantly exit the deployment process and remove the container. The following diagram and process flow demonstrates this process:

:::image type="content" source="_images/secure-aml-package.png" lightbox="_images/secure-aml-package.png" alt-text="Diagram that shows the secure Machine Learning Package approach." border="false":::

#### Process flow

1. Data scientists working within a specific Machine Learning workspace with [network configuration](/azure/machine-learning/how-to-access-azureml-behind-firewall#recommended-configuration-for-training-and-deploying-models) applied can self-serve machine learning packages on-demand from the machine learning package repositories. An exception process is required for everything else, using the [private storage](/azure/machine-learning/how-to-use-private-python-packages#use-a-repository-of-packages-from-private-storage) pattern, which is seeded and maintained by using a centralized function.

1. Machine Learning delivers machine learning solutions as docker containers. These solutions develop as they're uploaded to the Container Registry (ACR). You can use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) to generate vulnerability assessments for your container image.

1. Solution deployment occurs through a CI/CD process. [Defender for DevOps](/azure/defender-for-cloud/defender-for-devops-introduction) is used across the stack to provide security posture management and threat protection.

1. The solution container is deployed only if it passes each of the security processes. Failure results in the deployment elegantly exiting with error notifications, full audit trails, and the solution container being discarded.

The previous process flow provides a secure, self-serve, package management process for data scientists and ensures that the packages are secure and compliant with organizational standards. Organizations can balance innovation and security by granting data scientists self-service access to common machine learning packages, libraries, and binaries, while requiring exceptions for less common packages in preproduction environments. This strategy ensures that data scientists can remain productive during development, which reduces a major bottleneck during delivery. Organizations can streamline their release processes by containerizing environments for use in production environments. Streamlining release processes reduces toil and ensures continued security through vulnerability scanning. This strategy provides a repeatable approach that you can use across use cases to time of delivery and reduces the overall cost to build and deploy machine learning solutions within an enterprise.  

### Monitoring

In MLOps, monitoring is crucial for maintaining the health and performance of machine learning systems and ensuring that models remain effective and aligned with business goals. Monitoring supports governance, security, and cost controls during the [inner loop phase](#current-architectures). And it provides observability into the performance, model degradation, and usage when deploying solutions during the [outer loop phase](#current-architectures). Monitoring activities are relevant for personas such as Data Scientists, Business Stakeholders, Project Leads, Project Owners, Platform Technical Support, CI/CD processes, and Monitoring Processes.

The suggested MVP monitoring can be scoped around the [Machine Learning workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup). This setup can be a project, team, or department. For the [current architectures](#current-architectures) in MLOps V2 is:

#### Model performance

Monitoring model performance is essential for early detection of model issue and performance degradation. By tracking performance, an organization can ensure models remain accurate, reliable, and aligned with business objectives.

##### Data drift

[Data drift](/azure/machine-learning/how-to-monitor-datasets) tracks changes in the distribution of a model's input data by comparing it to the model's training data or recent past production data. These changes are a result of changes in market dynamics, feature transformation changes, or upstream data changes. Such changes can degrade model performance, so it's important to monitor for drift to ensure timely remediation. To be available for comparison, data drift refactoring requires recent production datasets and outputs.

**Environment:** Production<br/>
**Azure facilitation:** Machine Learning – [Model monitoring](/azure/machine-learning/concept-model-monitoring#enabling-model-monitoring)

##### Prediction drift

Prediction drift tracks changes in the distribution of a model's prediction outputs by comparing it to validation or test labeled data or recent past production data. To be available for comparison, redirection drift refactoring requires recent production datasets and outputs.

**Environment:** Production<br/>
**Azure facilitation:** Machine Learning – [Model monitoring](/azure/machine-learning/concept-model-monitoring#enabling-model-monitoring)

##### Resource

Use several model serving endpoint metrics to indicate quality and performance, such as CPU or memory utilization. This approach helps you learn from production to help drive future investments or changes.

**Environment:** All<br/>
**Azure facilitation:** Monitor - [Online endpoints metrics](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics)

#### Usage metrics

Monitoring the usage of endpoints is crucial to ensure that you're meeting organization or workload-specific KPIs, tracking usage patterns, and diagnosing and remediating problems that your users are experiencing.

##### Client requests

The number of client requests to the model endpoint helps a workload understand the active usage profile of the endpoints, which can feed into scaling or cost optimization efforts.

**Environment:** Production<br/>
**Azure facilitation:** Monitor - [Online endpoints metrics](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics), such as RequestsPerMinute.<br/>
**Notes:**

- Acceptable thresholds can be aligned to t-shirt sizing or anomalies tailored to the workload's need.
- Models no longer in use should be retired from production.

##### Throttling delays

[Throttling Delays](/azure/azure-resource-manager/management/request-limits-and-throttling) in request and response in data transfer. Throttling happens at the Resource Manager level and the service level, so it's important to track metrics at both levels.

**Environment:** Production<br/>
**Azure facilitation:**

- Monitor - [Resource Manager](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics), Sum of RequestThrottlingDelayMs, ResponseThrottlingDelayMs.
- Machine Learning - [Online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview) can be enabled to check information about your endpoints' requests. You can use a Log Analytics workspace to process logs.

**Notes:** Acceptable thresholds should be aligned to the workload's service-level objectives (SLOs), or service-level agreements (SLAs), and the solution's nonfunctional requirements (NFRs).

##### Errors generated

Track response code errors to assist are measuring service reliability and ensure early detection of service problems. For example, a sudden increase in 500 (server error) responses could indicate a critical issue that needs immediate attention.

**Environment:** Production<br/>
**Azure facilitation:** Machine Learning - [Online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview) can be enabled to check information about your request. For example, count of XRequestId by ModelStatusCode or count of XRequestId by ModelStatusCode and ModelStatusReason. You can use a Log Analytics workspace to process logs.<br/>
**Notes:**

- All HTTP responses codes in the 400 & 500 range would be classified as an error.

#### Cost optimization

Cost management and optimization in a cloud environment are crucial because they help workloads control expenses, allocate resources efficiently, and maximize value from their cloud services.

##### Workspace compute

When monthly operating expenses reach or exceed a predefined amount, alerts based on the workspace setup boundaries should be generated to alert relevant stakeholders, such as project leads or project owners. [Workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup) can be based on project, team, or department related boundaries.

**Environment:** All<br/>
**Azure facilitation:** Microsoft Cost Management - [Budget Alerts](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending#budget-alerts)<br/>
**Notes:**

- Budget thresholds should be set based upon the initial NFRs and cost estimates.
- Multiple threshold tiers should be used. Multiple threshold tiers ensure that stakeholders get appropriate warning before the budget is exceeded. These stakeholders might include business leads, project owners, or project Leads depending on the organization or workload.
- Consistent budget alerts could also be a trigger for refactoring to support greater demand.

##### Workspace staleness

If a Machine Learning workspace shows no signs of active use based on the associated compute usage for the intended use-case, a project owner might decide to decommission the workspace if it's no longer needed for a given project.

**Environment:** Preproduction<br/>
**Azure facilitation:**

- Monitor - [Machine Learning metrics](/azure/azure-monitor/essentials/monitor-azure-resource)
- Machine Learning - [Workspaces](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-metrics), such as count of active cores over a period

**Notes:**

- Active cores should equal zero with aggregation of count.
- Date thresholds should be aligned to the project schedule.

#### Security

Monitor to detect deviations from appropriate security controls and baselines to ensure that Machine Learning workspaces are compliant with your organization's security policies. You can use a combination of predefined and custom defined policies.

**Environment:** All<br/>
**Azure facilitation:** [Azure Policy for Machine Learning](/azure/machine-learning/how-to-integrate-azure-policy#policies-for-azure-machine-learning).

##### Endpoint security

To gain visibility into business-critical APIs, implement targeted security monitoring of all Machine Learning endpoints. You can investigate and improve your API security posture, prioritize vulnerability fixes, and quickly detect active real-time threats.

**Environment:** Production<br/>
**Azure facilitation:** [Defender For APIs](/azure/defender-for-cloud/defender-for-apis-introduction) offers broad lifecycle protection, detection, and response coverage for APIs.<br/>
**Notes:** Defender for APIs currently provides security for APIs that are published in Azure API Management. Defender for APIs can be onboarded in the Defender for Cloud portal, or within the API Management instance in the Azure portal. This process requires integrating Machine Learning online endpoints with API Management.

#### Deployment monitoring

Deployment monitoring ensures that any endpoints you create adhere to your workload or organization policies and are free from vulnerabilities. This process requires enforcing compliance policies on your Azure resources before and after deployment, continued security through vulnerability scanning, and ensuring that the service meets SLOs while in operation.

##### Standards and governance

Monitor to detect deviations from appropriate standards and that guardrails are adhered too.

**Environment:** All<br/>
**Azure facilitation:**

- Managed policy assignment and lifecycle through [Azure Pipelines](/azure/governance/policy/tutorials/policy-devops-pipelines) to treat policy as code.
- [PSRule for Azure](https://azure.github.io/enterprise-azure-policy-as-code/) provides a testing framework for Azure infrastructure as code.
- [Enterprise policy as code](https://azure.github.io/enterprise-azure-policy-as-code/) can be used in CI/CD based system deploy policies, policy sets, assignments, policy exemptions, and role assignments.

**Notes:** For more information, see [Azure guidance for Machine Learning regulatory compliance](/azure/machine-learning/security-controls-policy).

##### Security scanning

Implement automated security scans as part of the automated integration and deployment processes.

**Environment:** All<br/>
**Azure facilitation:** [Defender For DevOps](/azure/defender-for-cloud/defender-for-devops-introduction)<br/>
**Notes:** This process can be extended with [Azure Marketplace](https://marketplace.visualstudio.com/search?term=security&target=AzureDevOps&category=All%20categories&sortBy=Relevance) for non-Microsoft security testing modules.

##### Ongoing service

Monitoring the ongoing service of an API is crucial for performance optimization, security, and resource utilization. It ensures timely error detection, efficient troubleshooting, and compliance with standards.

**Environment:** Production<br/>
**Azure facilitation:**

- Monitor - [Machine Learning metrics](/azure/azure-monitor/essentials/monitor-azure-resource)
- Machine Learning - You can enable [Online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview) to check information about your service.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Scott Donohoo](https://www.linkedin.com/in/scottdonohoo) | Senior Cloud Solution Architect
- [Moritz Steller](https://www.linkedin.com/in/moritz-steller-426430116/) | Senior Cloud Solution Architect

Other contributors:

- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83/) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect
- [Darren Turchiarelli](https://www.linkedin.com/in/darren-turchiarelli/) | Cloud Solution Architect
- [Leo Kozhushnik](https://www.linkedin.com/in/leo-kozhushnik-ab16707/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Arc overview](/azure/azure-arc/overview)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Data in Machine Learning](/azure/machine-learning/concept-data)
- [Azure MLOps v2 solution accelerator](https://github.com/Azure/mlops-v2)
- [End-to-end machine learning operations (MLOps) with Machine Learning](/training/paths/build-first-machine-operations-workflow)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure DevOps documentation](/azure/devops)
- [GitHub Docs](https://docs.github.com)
- [Synapse Analytics documentation](/azure/synapse-analytics)
- [Event Hubs documentation](/azure/event-hubs)

## Related resources

- [Choose a Microsoft Azure AI services technology](../../data-guide/technology-choices/cognitive-services.md)
- [Natural language processing technology](../../data-guide/technology-choices/natural-language-processing.yml)
- [Compare the machine learning products and technologies from Microsoft](../../ai-ml/guide/data-science-and-machine-learning.md)
- [How Machine Learning works: resources and assets (v2)](/azure/machine-learning/concept-azure-machine-learning-v2)
- [What are Machine Learning pipelines?](/azure/machine-learning/concept-ml-pipelines)
- [Machine learning operations framework to upscale machine learning lifecycle with Machine Learning](mlops-technical-paper.yml)
- [What is the Team Data Science Process?](../../data-science-process/overview.yml)
