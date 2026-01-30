---
title: Machine learning operations
description: Learn about a single deployable set of repeatable and maintainable patterns for creating machine learning CI/CD and retraining pipelines.
author: delynchoong
ms.author: delynchoong 
ms.date: 07/03/2024
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Machine learning operations

This article describes three Azure architectures for machine learning operations that have end-to-end continuous integration and continuous delivery (CI/CD) pipelines and retraining pipelines. The architectures are for these AI applications:

- Classical machine learning
- Computer vision (CV)
- Natural language processing

These architectures are the product of the MLOps v2 project. They incorporate best practices that solution architects identified in the process of developing various machine learning solutions. The result is deployable, repeatable, and maintainable patterns. All three architectures use the Azure Machine Learning service.

For an implementation with sample deployment templates for MLOps v2, see [Azure MLOps v2 GitHub repository](https://github.com/Azure/mlops-v2).

## Potential use cases

- Classical machine learning: Time-series forecasting, regression, and classification on tabular structured data are the most common use cases in this category. Examples include:

  - Binary and multi-label classification.

  - Linear, polynomial, ridge, lasso, quantile, and Bayesian regression.

  - ARIMA, autoregressive, SARIMA, VAR, SES, LSTM.

- CV: The MLOps framework in this article focuses mostly on the CV use cases of segmentation and image classification.

- Natural language processing: You can use this MLOps framework to implement:

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

AI simulations, deep reinforcement learning, and other forms of AI aren't described in this article.

## MLOps as a key design area for AI workloads

The planning and implementation of a MLOps and GenAIOps are a core design area in AI workloads on Azure. To get a background on why these machine learning workloads need specialized operations, see [MLOps and GenAIOps for AI workloads on Azure](/azure/well-architected/ai/mlops-genaiops) in the Azure Well-Architected Framework.

## Architecture

The MLOps v2 architectural pattern has four main modular components, or phases, of the MLOps lifecycle:

- Data estate
- Administration and setup
- Model development, or the inner loop phase
- Model deployment, or the outer loop phase

The preceding components, the connections between them, and the typical personas involved are standard across all MLOps v2 scenario architectures. Variations in the details of each component depend on the scenario.

The base architecture for MLOps v2 for Machine Learning is the classical machine learning scenario for tabular data. The CV and NLP architectures build on and modify this base architecture.

MLOps v2 covers the following architectures that are described in this article:

- [Classical machine learning architecture](#classical-machine-learning-architecture)
- [Machine Learning CV architecture](#machine-learning-cv-architecture)
- [Machine Learning natural language processing architecture](#machine-learning-natural-language-processing-architecture)

### Classical machine learning architecture

:::image type="content" source="_images/classical-ml-architecture.png" lightbox="_images/classical-ml-architecture.png" alt-text="Diagram that shows the classical machine learning architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-classical-ml.vsdx) of this architecture.*

#### Workflow for the classical machine learning architecture

1. Data estate

   This component illustrates the data estate of the organization and potential data sources and targets for a data science project. Data engineers are the primary owners of this component of the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. A green check mark indicates the data sources and targets that represent recommended best practices that are based on the customer use case.

1. Administration and setup

   This component is the first step in the MLOps v2 solution deployment. It consists of all tasks related to the creation and management of resources and roles that are associated with the project. For example, the infrastructure team might:

   1. Create project source code repositories.
   1. Use Bicep or Terraform to create Machine Learning workspaces.
   1. Create or modify datasets and compute resources for model development and deployment.
   1. Define project team users, their roles, and access controls to other resources.
   1. Create CI/CD pipelines.
   1. Create monitoring components to collect and create alerts for model and infrastructure metrics.

   The primary persona associated with this phase is the infrastructure team, but an organization might also have data engineers, machine learning engineers, or data scientists.

1. Model development (inner loop phase)

   The inner loop phase consists of an iterative data science workflow that acts within a dedicated and secure Machine Learning workspace. The preceding diagram shows a typical workflow. The process starts with data ingestion, moves through exploratory data analysis, experimentation, model development and evaluation, and then registers a model for production use. This modular component is agnostic and adaptable to the process that your data science team uses to develop models.

   Personas associated with this phase include data scientists and machine learning engineers.

1. Machine Learning registries

   After the data science team develops a model that they can deploy to production, they register the model in the Machine Learning workspace registry. CI pipelines that are triggered, either automatically by model registration or by gated human-in-the-loop approval, promote the model and any other model dependencies to the model deployment phase.

   Personas associated with this stage are typically machine learning engineers.

1. Model deployment (outer loop phase)

   The model deployment, or outer loop phase, consists of preproduction staging and testing, production deployment, and monitoring of the model, data, and infrastructure. When the model meets the criteria of the organization and use case, CD pipelines promote the model and related assets through production, monitoring, and potential retraining.

   Personas associated with this phase are primarily machine learning engineers.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as retraining and testing the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, machine learning engineers can use human-in-the-loop gated approval to promote it to production. Model deployment options include a managed batch endpoint for batch scenarios or either a managed online endpoint or Kubernetes deployment that uses Azure Arc for online, near real-time scenarios. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

    Machine learning engineers monitor components in staging, testing, and production to collect metrics related to changes in performance of the model, data, and infrastructure. They can use those metrics to take action. Model and data monitoring can include checking for model and data drift, model performance on new data, and responsible AI problems. Infrastructure monitoring might identify slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   Based on model and data criteria, such as metric thresholds or schedules, automated triggers and notifications can implement appropriate actions to take. For example, a trigger might retrain a model to use new production data and then loopback the model to staging and testing for a preproduction evaluation. Or a model or data problem might trigger an action that requires a loopback to the model development phase where data scientists can investigate the problem and potentially develop a new model.

1. Infrastructure monitoring: events and actions

   Automated triggers and notifications can implement appropriate actions to take based on infrastructure criteria, such as an endpoint response lag or insufficient compute for the deployment. Automatic triggers and notifications might trigger a loopback to the setup and administration phase where the infrastructure team can investigate the problem and potentially reconfigure the compute and network resources.

### Machine Learning CV architecture

:::image type="content" source="_images/computer-vision-architecture.png" lightbox="_images/computer-vision-architecture.png" alt-text="Diagram that shows the computer vision architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-computer-vision.vsdx) of this architecture.*

#### Workflow for the CV architecture

The Machine Learning CV architecture is based on the classical machine learning architecture, but it has modifications that are specific to supervised CV scenarios.

1. Data estate

   This component demonstrates the data estate of the organization and potential data sources and targets for a data science project. Data engineers are the primary owners of this component in the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. Images for CV scenarios can come from various data sources. For efficiency when developing and deploying CV models with Machine Learning, we recommend Azure Blob Storage and Azure Data Lake Storage.

1. Administration and setup

   This component is the first step in the MLOps v2 deployment. It consists of all tasks related to the creation and management of resources and roles associated with the project. For CV scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning but includes an extra step. The infrastructure team uses the labeling feature of Machine Learning or another tool to create image labeling and annotation projects.

1. Model development (inner loop phase)

   The inner loop phase consists of an iterative data science workflow performed within a dedicated and secure Machine Learning workspace. The primary difference between this workflow and the classical machine learning scenario is that image labeling and annotation is a key component of this development loop.

1. Machine Learning registries

   After the data science team develops a model that they can deploy to production, they register the model in the Machine Learning workspace registry. CI pipelines that are triggered automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.

1. Model deployment (outer loop phase)

   The model deployment or outer loop phase consists of preproduction staging and testing, production deployment, and monitoring of the model, data, and infrastructure. When the model meets the criteria of the organization and use case, CD pipelines promote the model and related assets through production, monitoring, and potential retraining.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. For CV scenarios, machine learning engineers don't need to retrain the model candidate on production data because of resource and time constraints. The data science team can instead use production data for model development. The candidate model registered from the development loop is evaluated for production. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, machine learning engineers can use human-in-the-loop gated approval to promote it to production. Model deployment options include a managed batch endpoint for batch scenarios or either a managed online endpoint or Kubernetes deployment that uses Azure Arc for online, near real-time scenarios. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

   Machine learning engineers monitor components in staging, testing, and production to collect metrics related to changes in performance of the model, data, and infrastructure. They can use those metrics to take action. Model and data monitoring can include checking for model performance on new images. Infrastructure monitoring might identify slow endpoint response, inadequate compute capacity, or network problems.

1. Data and model monitoring: events and actions

   The data and model monitoring and event and action phases of MLOps for natural language processing are the key differences from classical machine learning. Automated retraining is typically not done in CV scenarios when model performance degradation on new images is detected. In this case, a human-in-the-loop process is necessary to review and annotate new images for the model that performs poorly. The next action often goes back to the model development loop to update the model with the new images.

1. Infrastructure monitoring: events and actions

   Automated triggers and notifications can implement appropriate actions to take based on infrastructure criteria, such as an endpoint response lag or insufficient compute for the deployment. Automatic triggers and notifications might trigger a loopback to the setup and administration phase where the infrastructure team can investigate the problem and potentially reconfigure environment, compute, and network resources.

### Machine Learning natural language processing architecture

:::image type="content" source="_images/natural-language-processing-architecture.png" lightbox="_images/natural-language-processing-architecture.png" alt-text="Diagram for the natural language processing architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-operation-natural-language-processing.vsdx) of this architecture.*

#### Workflow for the natural language processing architecture

The Machine Learning natural language processing architecture is based on the classical machine learning architecture, but it has some modifications that are specific to NLP scenarios.

1. Data estate

   This component demonstrates the organization data estate and potential data sources and targets for a data science project. Data engineers are the primary owners of this component in the MLOps v2 lifecycle. The Azure data platforms in this diagram aren't exhaustive or prescriptive. A green check mark indicates sources and targets that represent recommended best practices that are based on the customer use case.

1. Administration and setup

   This component is the first step in the MLOps v2 deployment. It consists of all tasks related to the creation and management of resources and roles associated with the project. For natural language processing scenarios, administration and setup of the MLOps v2 environment is largely the same as for classical machine learning, but with an extra step: create text labeling and annotation projects by using the labeling feature of Machine Learning or another tool.

1. Model development (inner loop phase)

   The inner loop phase consists of an iterative data science workflow performed within a dedicated and secure Machine Learning workspace. The typical NLP model development loop differs from the classical machine learning scenario in that the typical development steps for this scenario include annotators for sentences and tokenization, normalization, and embeddings for text data.

1. Machine Learning registries

   After the data science team develops a model that they can deploy to production, they register the model in the Machine Learning workspace registry. CI pipelines that are triggered automatically by model registration or by gated human-in-the-loop approval promote the model and any other model dependencies to the model deployment phase.

1. Model deployment (outer loop phase)

   The model deployment or outer loop phase consists of preproduction staging and testing, production deployment, and monitoring of the model, data, and infrastructure. When the model meets the criteria of the organization and use case, CD pipelines promote the model and related assets through production, monitoring, and potential retraining.

1. Staging and test

   The staging and test phase varies according to customer practices. This phase typically includes operations such as retraining and testing the model candidate on production data, test deployments for endpoint performance, data quality checks, unit testing, and responsible AI checks for model and data bias. This phase takes place in one or more dedicated and secure Machine Learning workspaces.

1. Production deployment

   After a model passes the staging and test phase, machine learning engineers can use human-in-the-loop gated approval to promote it to production. Model deployment options include a managed batch endpoint for batch scenarios or either a managed online endpoint or Kubernetes deployment that uses Azure Arc for online, near real-time scenarios. Production typically takes place in one or more dedicated and secure Machine Learning workspaces.

1. Monitoring

   Machine learning engineers monitor components in staging, testing, and production to collect metrics related to changes in performance of the model, data, and infrastructure. They can use those metrics to take action. Model and data monitoring can include checking for model and data drift, model performance on new text data, and responsible AI problems. Infrastructure monitoring might identify problems, such as slow endpoint response, inadequate compute capacity, and network problems.

1. Data and model monitoring: events and actions

   As with the CV architecture, the data and model monitoring and event and action phases of MLOps for natural language processing are the key differences from classical machine learning. Automated retraining isn't typically done in natural language processing scenarios when model performance degradation on new text is detected. In this case, a human-in-the-loop process is necessary to review and annotate new text data for the model that performs poorly. Often the next action is to go back to the model development loop to update the model with the new text data.

1. Infrastructure monitoring: events and actions

   Automated triggers and notifications can implement appropriate actions to take based on infrastructure criteria, such as an endpoint response lag or insufficient compute for the deployment. Automatic triggers and notifications might trigger a loopback to the setup and administration phase where the infrastructure team can investigate the problem and potentially reconfigure compute and network resources.

### Components

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a cloud service that you can use to train, score, deploy, and manage machine learning models at scale. In this architecture, it's the primary platform for model development, deployment, monitoring, and management throughout the MLOps life cycle.

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a build-and-test system that's based on Azure DevOps and is used for build and release pipelines. Azure Pipelines splits these pipelines into logical steps called *tasks*. In this architecture, it automates and manages CI/CD workflows to help ensure consistent deployment and testing of machine learning solutions.

- [GitHub](https://github.com) is a code-hosting platform. In this architecture, GitHub is the central repository for source code, version control, and collaboration. It integrates with CI/CD pipelines for automation.

- [Azure Arc](/azure/azure-arc/overview) is a platform that uses Azure Resource Manager to manage Azure resources and on-premises resources. The resources can include virtual machines, Kubernetes clusters, and databases. In this architecture, Azure Arc provides unified management and governance for hybrid and multicloud machine learning environments.

- [Kubernetes](https://kubernetes.io) is an open-source system that you can use to automate the deployment, scaling, and management of containerized applications. In this architecture, Kubernetes orchestrates containerized machine learning workloads to enable scalable, efficient, and resilient deployments.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a Hadoop-compatible file system. It has an integrated hierarchical namespace and the massive scale and economy of Blob Storage. In this architecture, it stores and manages large volumes of structured and unstructured data for machine learning workflows.

- [Microsoft Fabric](/fabric/fundamentals/) is a unified platform that can meet your organization's data and analytics needs. In this architecture, Fabric facilitates end-to-end data integration, preparation, and analytics to support the data estate component of MLOps.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a service that ingests data streams that client applications generate. In this architecture, Event Hubs ingests and stores real-time streaming data to enable data capture and analysis for machine learning pipelines. Customers can connect to the hub endpoints to retrieve messages for processing. This architecture uses Data Lake Storage integration.

## Other considerations

The preceding MLOps v2 architectural pattern has several critical components, including Azure RBAC that aligns with business stakeholders, efficient package management, and robust monitoring mechanisms. These components collectively contribute to the successful implementation and management of machine learning workflows.

### Persona-based Azure RBAC

It's crucial that you manage access to machine learning data and resources. Azure RBAC provides a robust framework to help you manage who can take specific actions and access specific areas within your solution. Design your identity segmentation strategy to align with the lifecycle of machine learning models in Machine Learning and the personas included in the process. Each persona has a specific set of responsibilities that are reflected in their Azure RBAC roles and group membership.

#### Example personas

To support appropriate segmentation in a machine learning workload, consider the following common personas that inform the [identity-based Azure RBAC](#identity-azure-rbac) group design.

##### Data scientist and machine learning engineer

Data scientists and machine learning engineers carry out various machine learning and data science activities across the software development life cycle of a project. Their duties include exploratory data analysis and data preprocessing. Data scientists and machine learning engineers are responsible for training, evaluating, and deploying models. These roles' responsibilities also include break-fix activities for machine learning models, packages, and data. These duties are out of scope for the platform's technical support team.

**Type:** Person<br>
**Project specific:** Yes

##### Data analyst

Data analysts provide the necessary input for data science activities, such as running SQL queries for business intelligence. This role's responsibilities include working with data, performing data analysis, and supporting model development and model deployment.

**Type:** Person<br>
**Project specific:** Yes

##### Model tester

Model testers conduct tests in testing and staging environments. This role provides functional segregation from the CI/CD processes.

**Type:** Person<br>
**Project specific:** Yes

##### Business stakeholders

Business stakeholders are associated with the project, such as a marketing manager.

**Type:** Person<br>
**Project specific:** Yes

##### Project lead or data science lead

The data science lead is a project administration role for the Machine Learning workspace. This role also does break-fix activities for the machine learning models and packages.

**Type:** Person<br>
**Project specific:** Yes

##### Project or product owner (Business owner)

Business stakeholders are responsible for the Machine Learning workspace according to data ownership.

**Type:** Person<br>
**Project specific:** Yes

##### Platform technical support

Platform technical support is the technical support staff responsible for break-fix activities across the platform. This role covers infrastructure or service but not the machine learning models, packages, or data. These components remain under the data scientist or machine learning engineer role and are the project lead's responsibility.

**Type:** Person<br>
**Project specific:** No

##### Model end user

Model end users are the end consumers of the machine learning model.

**Type:** Person or Process<br>
**Project specific:** Yes

##### CI/CD processes

CI/CD processes release or roll back changes across platform environments.

**Type:** Process<br>
**Project specific:** No

##### Machine Learning workspace

 Machine Learning workspaces use [managed identities](/azure/machine-learning/how-to-setup-authentication) to interact with other parts of Azure. This persona represents the various services that make up a Machine Learning implementation. These services interact with other parts of the platform, such as the development workspace that connects with the development data store.

**Type:** Process<br>
**Project specific:** No

##### Monitoring processes

Monitoring processes are compute processes that monitor and alert based on platform activities.

**Type:** Process<br>
**Project specific:** No

##### Data governance processes

Data governance processes scan the machine learning project and data stores for data governance.

**Type:** Process<br>
**Project specific:** No

### Microsoft Entra group membership

When you implement Azure RBAC, [Microsoft Entra groups](/entra/fundamentals/how-to-manage-groups) provide a flexible and scalable way to manage access permissions across different personas. You can use Microsoft Entra groups to manage users that need the same access and permissions to resources, such as potentially restricted apps and services. Instead of adding special permissions to individual users, you create a group that applies the special permissions to every member of that group.

In this architectural pattern, you can couple these groups with a [Machine Learning workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup), such as a project, team, or department. You can associate users with specific groups to define fine-grained access policies. The policies grant or restrict permissions to various Machine Learning workspaces based on job functions, project requirements, or other criteria. For example, you can have a group that grants all data scientists access to a development workspace for a specific use case.

### Identity Azure RBAC

Consider how you can use the following built-in Azure RBAC roles to apply access control to production and preproduction environments. For the [architecture](#architecture) in this article, the production environments include staging, testing, and production environments. The preproduction environments include development environments. The following built-in roles are based on the personas described earlier in this article.

#### Standard roles

- R = [Reader](/azure/role-based-access-control/built-in-roles/general#reader)
- C = [Contributor](/azure/role-based-access-control/built-in-roles/general#contributor)
- O = [Owner](/azure/role-based-access-control/built-in-roles/general#owner)

#### Component specific roles

- ADS = [Machine Learning Data Scientist](/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-data-scientist)

- ACO = [Machine Learning Compute Operator](/azure/role-based-access-control/built-in-roles/ai-machine-learning#azureml-compute-operator)

- AcrPush = [Azure Container Registry Push](/azure/container-registry/container-registry-roles#push-image)

- DOPA = [DevOps Project Administrators](/azure/devops/organizations/security/look-up-project-administrators)

- DOPCA = [DevOps Project Collection Administrators](/azure/devops/organizations/security/look-up-project-collection-administrators)

- LAR = [Log Analytics Reader](/azure/role-based-access-control/built-in-roles/analytics#log-analytics-reader)

- LAC = [Log Analytics Contributor](/azure/role-based-access-control/built-in-roles/analytics#log-analytics-contributor)

- MR = [Monitoring Reader](/azure/role-based-access-control/built-in-roles/monitor#monitoring-reader)

- MC = [Monitoring Contributor](/azure/role-based-access-control/built-in-roles/monitor#monitoring-contributor)

- KVA = [Key Vault Administrator](/azure/role-based-access-control/built-in-roles/security#key-vault-administrator)

- KVR = [Key Vault Reader](/azure/role-based-access-control/built-in-roles/security#key-vault-reader)

*These Azure RBAC role abbreviations correspond with the following tables.*

##### Production environment

| Persona                          | Machine Learning workspace | Azure Key Vault | Container Registry | Azure Storage account | Azure DevOps | Azure Artifacts | Log Analytics workspace | Azure Monitor |
| -------------------------------- | -------------------------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data scientist                   |                                  |           | R                        |                 |              |                 | LAR                     | MR            |
| Data analyst                     |                                  |           |                          |                 |              |                 |                         |               |
| Model tester                     |                                  |           |                          |                 |              |                 |                         |               |
| Business stakeholders            |                                  |           |                          |                 |              |                 |                         | MR            |
| Project lead (Data science lead) | R                                | R, KVR    | R                        |                 |              |                 | LAR                     | MR            |
| Project/product owner            |                                  |           |                          |                 |              |                 |                         | MR            |
| Platform technical support       | O                                | O, KVA    |                          |                 | DOPCA        | O               | O                       | O             |
| Model end user                   |                                  |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O                                | O, KVA    | AcrPush                  |                 | DOPCA        | O               | O                       | O             |
| Machine Learning workspace |                                  | R         | C                        | C               |              |                 |                         |               |
| Monitoring processes             | R                                |           |                          |                 |              |                 | LAR                     | MR            |
| Data governance processes        | R                                |           | R                        | R               | R            | R               |                         |               |

##### Preproduction environment

| Persona                          | Machine Learning workspace | Key Vault | Container Registry | Storage account | Azure DevOps | Azure Artifacts | Log Analytics workspace | Azure Monitor |
| -------------------------------- | -------------------------------- | --------- | ------------------------ | --------------- | ------------ | --------------- | ----------------------- | ------------- |
| Data scientist                   | ADS                              | R, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Data analyst                     | R                                |           |                          | C               |              |                 | LAR                     | MC            |
| Model tester                     | R                                | R, KVR    | R                        | R               | R            | R               | LAR                     | MR            |
| Business stakeholders            | R                                |           | R                        | R               | R            | R               |                         |               |
| Project lead (Data science lead) | C                                | C, KVA    | C                        | C               | C            | C               | LAC                     | MC            |
| Project/product owner            | R                                |           |                          | R               |              |                 |                         | MR            |
| Platform technical support       | O                                | O, KVA    | O                        | O               | DOPCA        | O               | O                       | O             |
| Model end user                   |                                  |           |                          |                 |              |                 |                         |               |
| CI/CD processes                  | O                                | O, KVA    | AcrPush                  | O               | DOPCA        | O               | O                       | O             |
| Machine Learning workspace |                                  | R, KVR    | C                        | C               |              |                 |                         |               |
| Monitoring processes             | R                                | R         | R                        | R               | R            | R               | LAC                     |               |
| Data governance processes        | R                                |           | R                        | R               |              |                 |                         |               |

> [!NOTE]
> Every persona retains access for the project's duration except platform technical support, which has temporary or just-in-time [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure) access.

Azure RBAC plays a vital role in securing and streamlining MLOps workflows. It restricts access based on assigned roles and prevents unauthorized users from accessing sensitive data, which mitigates security risks. Sensitive data includes training data or models and critical infrastructure, such as production pipelines. You can use Azure RBAC to ensure compliance with data privacy regulations. Azure RBAC also provides a clear record of access and permissions, which simplifies auditing, makes it easy to identify security gaps, and tracks user activity.

### Package management

Dependencies on various packages, libraries, and binaries are common throughout the MLOps lifecycle. These dependencies, often community-developed and rapidly evolving, necessitate subject matter expert knowledge for proper use and understanding. You must ensure that the appropriate people have secure access to diverse assets, such as packages and libraries, but you must also prevent vulnerabilities. Data scientists encounter this problem when they assemble specialized building blocks for machine learning solutions. Traditional software management approaches are costly and inefficient. Other approaches provide more value.

To manage these dependencies, you can use a secure, self-serve, package management process based on the [Quarantine pattern](../../patterns/quarantine.yml). You can design this process to allow data scientists to self-serve from a curated list of packages and ensure that the packages are secure and compliant with organizational standards.

This approach includes safe-listing three industry standard machine learning package repositories: Microsoft Artifact Registry, Python Package Index (PyPI), and Conda. Safe-listing enables self-serve from individual Machine Learning workspaces. Then use an automated testing process during the deployment to scan the resulting solution containers. Failures elegantly exit the deployment process and remove the container. The following diagram and process flow demonstrates this process:

:::image type="content" source="_images/secure-aml-package.png" lightbox="_images/secure-aml-package.png" alt-text="Diagram that shows the secure Machine Learning package approach." border="false":::

#### Process flow

1. Data scientists that work in a Machine Learning workspace that has a [network configuration](/azure/machine-learning/how-to-access-azureml-behind-firewall#recommended-configuration-for-training-and-deploying-models) can self-serve machine learning packages on-demand from the machine learning package repositories. An exception process is required for everything else by using the [private storage](/azure/machine-learning/how-to-use-private-python-packages#use-a-repository-of-packages-from-private-storage) pattern, which is seeded and maintained by using a centralized function.

1. Machine Learning delivers machine learning solutions as Docker containers. As these solutions are developed, they're uploaded to Container Registry. [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) generates vulnerability assessments for the container image.

1. Solution deployment occurs through a CI/CD process. [Microsoft Defender for DevOps](/azure/defender-for-cloud/defender-for-devops-introduction) is used across the stack to provide security posture management and threat protection.

1. The solution container is deployed only if it passes each of the security processes. If the solution container fails a security process, the deployment fails with error notifications and full audit trails. The solution container is discarded.

The previous process flow provides a secure, self-serve, package management process for data scientists and ensures that the packages are secure and compliant with organizational standards. To balance innovation and security, you can grant data scientists self-service access to common machine learning packages, libraries, and binaries in preproduction environments. Require exceptions for less common packages. This strategy ensures that data scientists can remain productive during development, which prevents a major bottleneck during delivery.

To streamline your release processes, containerize environments for use in production environments. Containerized environments reduce toil and ensure continued security through vulnerability scanning. This process flow provides a repeatable approach that you can use across use cases to the time of delivery. It reduces the overall cost to build and deploy machine learning solutions within your enterprise.

### Monitoring

In MLOps, monitoring is crucial for maintaining the health and performance of machine learning systems and ensuring that models remain effective and aligned with business goals. Monitoring supports governance, security, and cost controls during the inner loop phase. And it provides observability into the performance, model degradation, and usage when deploying solutions during the outer loop phase. Monitoring activities are relevant for personas such as Data Scientists, Business Stakeholders, Project Leads, Project Owners, Platform Technical Support, CI/CD processes, and Monitoring Processes.

Choose your monitoring and verification platform depending on your [Machine Learning workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup), such as a project, team, or department.

#### Model performance

Monitor model performance to detect model problems and performance degradation early. Track performance to ensure that models remain accurate, reliable, and aligned with business objectives.

##### Data drift

[Data drift](/azure/machine-learning/how-to-monitor-datasets) tracks changes in the distribution of a model's input data by comparing it to the model's training data or recent past production data. These changes are a result of changes in market dynamics, feature transformation changes, or upstream data changes. Such changes can degrade model performance, so it's important to monitor for drift to ensure timely remediation. To make a comparison, data drift refactoring requires recent production datasets and outputs.

**Environment:** Production<br>
**Azure facilitation:** Machine Learning – [Model monitoring](/azure/machine-learning/concept-model-monitoring#enabling-model-monitoring)

##### Prediction drift

Prediction drift tracks changes in the distribution of a model's prediction outputs by comparing it to validation, test-labeled, or recent production data. To make a comparison, data drift refactoring requires recent production datasets and outputs.

**Environment:** Production<br>
**Azure facilitation:** Machine Learning – [Model monitoring](/azure/machine-learning/concept-model-monitoring#enabling-model-monitoring)

##### Resource

Use several model serving endpoint metrics to indicate quality and performance, such as CPU or memory usage. This approach helps you learn from production to help drive future investments or changes.

**Environment:** All<br>
**Azure facilitation:** Monitor - [Online endpoints metrics](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics)

#### Usage metrics

Monitor the usage of endpoints to ensure that you meet organization-specific or workload-specific key performance indicators, track usage patterns, and diagnose and remediate problems that your users experience.

##### Client requests

Track the number of client requests to the model endpoint to understand the active usage profile of the endpoints, which can affect scaling or cost optimization efforts.

**Environment:** Production<br>
**Azure facilitation:** Monitor - [Online endpoints metrics](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics), such as RequestsPerMinute.
**Notes:**

- You can align acceptable thresholds to t-shirt sizing or anomalies that are tailored to your workload's needs.
- Retire models that are no longer in use from production.

##### Throttling delays

[Throttling delays](/azure/azure-resource-manager/management/request-limits-and-throttling) are slowdowns in the request and response of data transfers. Throttling happens at the Resource Manager level and the service level. Track metrics at both levels.

**Environment:** Production<br>
**Azure facilitation:**

- Monitor - [Resource Manager](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics), sum of RequestThrottlingDelayMs, ResponseThrottlingDelayMs.
- Machine Learning - To check information about your endpoints' requests, you can enable [online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview). You can use a Log Analytics workspace to process logs.

**Notes:** Align acceptable thresholds to your workload's service-level objectives (SLOs) or service-level agreements (SLAs) and the solution's nonfunctional requirements (NFRs).

##### Errors generated

Track response code errors to help measure service reliability and ensure early detection of service problems. For example, a sudden increase in 500 server error responses could indicate a critical problem that needs immediate attention.

**Environment:** Production<br>
**Azure facilitation:** Machine Learning - Enable [online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview) to check information about your request. For example, you can check the count of XRequestId by using ModelStatusCode or ModelStatusReason. You can use a Log Analytics workspace to process logs.<br>
**Notes:**

- All HTTP responses codes in the 400 and 500 range are classified as an error.

#### Cost optimization

Cost management and optimization in a cloud environment are crucial because they help workloads control expenses, allocate resources efficiently, and maximize value from their cloud services.

##### Workspace compute

When monthly operating expenses reach or exceed a predefined amount, generate alerts to notify relevant stakeholders, such as project leads or project owners, based on the workspace setup boundaries. You can determine your [workspace setup](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization#team-structure-and-workspace-setup) based on project, team, or department-related boundaries.

**Environment:** All<br>
**Azure facilitation:** Microsoft Cost Management - [Budget alerts](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending#budget-alerts)<br>
**Notes:**

- Set budget thresholds based on the initial NFRs and cost estimates.
- Use multiple threshold tiers. Multiple threshold tiers ensure that stakeholders get appropriate warning before the budget is exceeded. These stakeholders might include business leads, project owners, or project Leads depending on the organization or workload.
- Consistent budget alerts could also be a trigger for refactoring to support greater demand.

##### Workspace staleness

If a Machine Learning workspace shows no signs of active use based on the associated compute usage for the intended use case, a project owner might decommission the workspace if it's no longer needed for a given project.

**Environment:** Preproduction<br>
**Azure facilitation:**

- Monitor - [Machine Learning metrics](/azure/azure-monitor/essentials/monitor-azure-resource)
- Machine Learning - [Workspace metrics](/azure/azure-monitor/reference/supported-metrics/microsoft-machinelearningservices-workspaces-metrics), such as the count of active cores over a period of time

**Notes:**

- Active cores should equal zero with aggregation of count.
- Align date thresholds to the project schedule.

#### Security

Monitor to detect deviations from appropriate security controls and baselines to ensure that Machine Learning workspaces are compliant with your organization's security policies. You can use a combination of predefined and custom-defined policies.

**Environment:** All<br>
**Azure facilitation:** [Azure Policy for Machine Learning](/azure/machine-learning/how-to-integrate-azure-policy#policies-for-azure-machine-learning)

##### Endpoint security

To gain visibility into business-critical APIs, implement targeted security monitoring of all Machine Learning endpoints. You can investigate and improve your API security posture, prioritize vulnerability fixes, and quickly detect active real-time threats.

**Environment:** Production<br>
**Azure facilitation:** [Microsoft Defender for APIs](/azure/defender-for-cloud/defender-for-apis-introduction) offers broad lifecycle protection, detection, and response coverage for APIs.
**Notes:** Defender for APIs provides security for APIs that are published in Azure API Management. You can onboard Defender for APIs in the Microsoft Defender for Cloud portal or within the API Management instance in the Azure portal. You must integrate Machine Learning online endpoints with API Management.

#### Deployment monitoring

Deployment monitoring ensures that any endpoints you create adhere to your workload or organization policies and are free from vulnerabilities. This process requires that you enforce compliance policies on your Azure resources before and after deployment, provide continued security through vulnerability scanning, and ensure that the service meets SLOs while in operation.

##### Standards and governance

Monitor to detect deviations from appropriate standards and ensure that your workload adheres to guardrails.

**Environment:** All<br>
**Azure facilitation:**

- Managed policy assignment and lifecycle through [Azure Pipelines](/azure/governance/policy/tutorials/policy-devops-pipelines) to treat policy as code.
- [PSRule for Azure](https://azure.github.io/enterprise-azure-policy-as-code/) provides a testing framework for Azure infrastructure as code.
- You can use [Enterprise Azure policy as code](https://azure.github.io/enterprise-azure-policy-as-code/) in CI/CD-based system deploy policies, policy sets, assignments, policy exemptions, and role assignments.

**Notes:** For more information, see [Azure guidance for Machine Learning regulatory compliance](/azure/machine-learning/security-controls-policy).

##### Security scanning

Implement automated security scans as part of the automated integration and deployment processes.

**Environment:** All<br>
**Azure facilitation:** [Defender For DevOps](/azure/defender-for-cloud/defender-for-devops-introduction)<br>
**Notes:** You can use apps in [Azure Marketplace](https://marketplace.visualstudio.com/search?term=security&target=AzureDevOps&category=All%20categories&sortBy=Relevance) to extend this process for non-Microsoft security testing modules.

##### Ongoing service

Monitor the ongoing service of an API for performance optimization, security, and resource usage. Ensure timely error detection, efficient troubleshooting, and compliance with standards.

**Environment:** Production<br>
**Azure facilitation:**

- Monitor - [Machine Learning metrics](/azure/azure-monitor/essentials/monitor-azure-resource)
- Machine Learning - You can enable [online endpoint traffic logs](/azure/machine-learning/monitor-azure-machine-learning-reference#amlonlineendpointtrafficlog-table-preview) to check information about your service.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Setu Chokshi](https://www.linkedin.com/in/setuchokshi/) | Senior Technical Specialist

Other contributors:

- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83/) | Cloud Solution Architect
- [Darren Turchiarelli](https://www.linkedin.com/in/darren-turchiarelli/) | Cloud Solution Architect
- [Leo Kozhushnik](https://www.linkedin.com/in/leo-kozhushnik-ab16707/) | Cloud Solution Architect
- [Daniel Crawford](https://www.linkedin.com/in/daniel-crawford-b661373/) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Arc overview](/azure/azure-arc/overview)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Data in Machine Learning](/azure/machine-learning/concept-data)
- [Azure MLOps v2 GitHub repository](https://github.com/Azure/mlops-v2)
- [End-to-end machine learning operations (MLOps) with Machine Learning](/training/paths/build-first-machine-operations-workflow)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure DevOps documentation](/azure/devops)
- [GitHub Docs](https://docs.github.com)
- [Microsoft Fabric documentation](/fabric/fundamentals/)
- [Event Hubs documentation](/azure/event-hubs)
- [How Machine Learning works: resources and assets (v2)](/azure/machine-learning/concept-azure-machine-learning-v2)
- [What are Machine Learning pipelines?](/azure/machine-learning/concept-ml-pipelines)

## Related resources

- [Choose a Microsoft Azure AI services technology](../../data-guide/technology-choices/ai-services.md)
- [Natural language processing technology](../../data-guide/technology-choices/natural-language-processing.md)
- [Compare the machine learning products and technologies from Microsoft](../../ai-ml/guide/data-science-and-machine-learning.md)
- [What is the Team Data Science Process?](../../data-science-process/overview.yml)
