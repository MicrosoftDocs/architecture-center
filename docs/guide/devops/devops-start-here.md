---
title: DevOps architecture design
titleSuffix: Azure Architecture Center
description: Learn about DevOps and how to implements DevOps solutions on Azure by using services such as Azure DevOps, Azure Pipelines, Azure Monitor, and Azure DevTest Labs.
author: martinekuan
ms.author: martinek
ms.date: 07/25/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
categories:
  - devops
  - containers
products:
  - azure-devops
  - azure-monitor
  - azure-pipelines
  - azure-devtest-labs
ms.custom:
  - overview
  - fcp
---

# DevOps architecture design

The term *DevOps* derives from *development* and *operations*. It refers to the integration of development, quality assurance, and IT operations into a unified culture and set of processes for delivering software. For an overview of DevOps, see [What is DevOps?](https://azure.microsoft.com/overview/what-is-devops).

DevOps includes these activities and operations:

- **Continuous integration (CI)** is the practice of merging all developer code into a central codebase frequently, and then performing automated build and test processes. The objectives are to quickly discover and correct code issues, to streamline deployment, and to ensure code quality. For more information, see [What is Continuous Integration?](/devops/develop/what-is-continuous-integration).
- **Continuous delivery (CD)** is the practice of automatically building, testing, and deploying code to production-like environments. The objective is to ensure that code is always ready to deploy. Adding continuous delivery to create a full CI/CD pipeline helps you detect code defects as soon as possible. It also ensures that properly tested updates can be released in a short time. For more information, see [What is Continuous Delivery?](/devops/deliver/what-is-continuous-delivery).
- **Continuous deployment** is an additional process that automatically takes any updates that have passed through the CI/CD pipeline and deploys them into production. Continuous deployment requires robust automatic testing and advanced process planning. It might not be appropriate for all teams.
- **Continuous monitoring** refers to the process and technology required to incorporate monitoring across each phase of DevOps and IT operations lifecycles. Monitoring helps to ensure the health, performance, and reliability of your application and infrastructure as the application moves from development to production. Continuous monitoring builds on the concepts of CI and CD.

## Introduction to DevOps on Azure

If you need to know more about DevOps, or DevOps on Azure, the best place to learn is [Microsoft Learn training](/training). This free online platform provides interactive training for Microsoft products and more. There are videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on job role, such as developer or data analyst. If you're not familiar with Learn you can take [a tour of Microsoft Learn training](/teamblog/microsoft-learn-tour) or [a quick video tour of Microsoft Learn training](/shows/azure-friday/learning-azure-part-3-a-quick-tour-of-microsoft-learn).

After you're familiar with Azure, you can decide whether to follow learning paths specific to DevOps, such as:

- [Get started with Azure DevOps](/training/paths/evolve-your-devops-practices)
- [Deploy applications with Azure DevOps](/training/paths/deploy-applications-with-azure-devops)
- [Build applications with Azure DevOps](/training/paths/build-applications-with-azure-devops)

> [!div class="nextstepaction"]
> [Browse other training materials for DevOps](/search/?terms=devops&category=Learn)

## Path to production

Plan your path to production by reviewing:

- [DevOps guides](#devops-guides)
- [Azure services that are often used in implementing DevOps solutions](#azure-devops-services)
- [Example DevOps architectures](#example-devops-architectures)

### DevOps guides

| Article or section | Description |
|--------------|-------------|
| [DevOps checklist](../../checklist/dev-ops.md) | A list of things to consider and do when you implement DevOps attitudes and methods in culture, development, testing, release, monitoring, and management. |
| [Operational Excellence patterns](/azure/architecture/framework/devops/devops-patterns) | A list of design patterns for achieving Operational Excellence—one of the five pillars of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)—in a cloud environment. See [Cloud Design Patterns](../../patterns/index.md) for more patterns. |
| [Advanced Azure Resource Manager template functionality](../../guide/azure-resource-manager/advanced-templates/index.md) | Some advanced examples of template use. |
| DevTest Labs guidance | A series of articles to help you use Azure Devtest Labs to provision development and test environments. The first article in the series is [DevTest Labs in the enterprise](/azure/devtest-labs/devtest-lab-guidance-prescriptive-adoption). |
| Azure Monitor guidance | A series of articles to help you use Azure Monitor to monitor cloud environments. The first article in the series is [Azure Monitor best practices - Planning your monitoring strategy and configuration](/azure/azure-monitor/best-practices-plan?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json).
| [Continuous integration and delivery for an Azure Synapse Analytics workspace](/azure/synapse-analytics/cicd/continuous-integration-delivery?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | An outline of how to use an Azure DevOps release pipeline and GitHub Actions to automate the deployment of an Azure Synapse workspace to multiple environments. |
| [DevOps for quantum computing](../../guide/quantum/devops-for-quantum-computing.yml) | A discussion of the DevOps requirements for hybrid quantum applications. |
| [Platform automation for Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-platform-automation-and-devops?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) | An overview for deploying Azure VMware Solution, including guidance for operational automation. |

### Azure DevOps services

| Azure service| Documentation | Description |
|--------------|---------------|-------------|
| [Azure Artifacts](https://azure.microsoft.com/services/devops/artifacts) |  [Azure Artifacts overview](/azure/devops/artifacts/start-using-azure-artifacts) |  Fully integrated package management for your CI/CD pipelines.
| [Azure DevOps](https://azure.microsoft.com/services/devops) | [Azure DevOps documentation](/azure/devops) | Modern dev services for managing your development lifecycle end-to-end. It includes Azure Repos, Azure Pipelines, and Azure Artifacts. |
| [Azure DevTest Labs](https://azure.microsoft.com/services/devtest-lab) | [Azure DevTest Labs documentation](/azure/devtest-labs) | Reusable templates and artifacts for provisioning development and test environments. |
| [Azure Lab Services](https://azure.microsoft.com/services/lab-services) | [Azure Lab Services documentation](/azure/lab-services) | A tool for setting up and providing on-demand access to preconfigured virtual machines (VMs). |
| [Azure Monitor](https://azure.microsoft.com/services/monitor) | [Azure Monitor documentation](/azure/azure-monitor) | Provides full observability into your applications, infrastructure, and network. |
| [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) | [Azure Pipelines documentation](/azure/devops/pipelines) | Helps you automate build and deployment by using cloud-hosted pipelines. |
  [Azure Repos](https://azure.microsoft.com/services/devops/repos) | [Azure Repos documentation](/azure/devops/repos) | Provides unlimited, cloud-hosted private Git repos for your project and coupled with GitHub Advanced Security's powerful suite of security features. |
| [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager) | [Azure Resource Manager documentation](/azure/azure-resource-manager) | Provides consistent deployment, organization, and control for resource management. |
| [Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates/overview) | [ARM template documentation](/azure/azure-resource-manager/templates) | Templates that you can use to define the infrastructure and configuration for your project. |
| [Azure Test Plans](https://azure.microsoft.com/services/devops/test-plans) | [Azure Test Plans documentation](/azure/devops/test) | Provides planned and exploratory testing services for your apps. |


### Example DevOps architectures

The DevOps architectures are found in two sections:

| Section | First article in the section |
|---------|------------------------------|
| Architectures | [Automate multistage DevOps pipelines with Azure Pipelines](../../example-scenario/devops/automate-azure-pipelines.yml) |
| Solution ideas | [CI/CD for Azure VMs](../../solution-ideas/articles/cicd-for-azure-vms.yml) |

Here are some example architectures. For each one there's a list of the key Azure services used in the architecture.

| Architecture | Description | Azure services used |
|--------------|-------------|----------------|
| [Automate multistage DevOps pipelines with Azure Pipelines](../../example-scenario/devops/automate-azure-pipelines.yml) | Use Azure DevOps REST APIs to build CI/CD pipelines. | Azure DevOps, Logic Apps, Azure Pipelines |
| [Automated API deployments with APIOps](../../example-scenario/devops/automated-api-deployments-apiops.yml) | Apply GitOps and DevOps techniques to ensure quality APIs. | Azure Repos, API Management, Azure DevOps, Azure Pipelines, Azure Repos |
| [Design a CI/CD pipeline using Azure DevOps](../../example-scenario/apps/devops-dotnet-baseline.yml) | Build a CI/CD pipeline by using Azure DevOps and other services. | Azure Repos, Azure Test Plans, Azure Pipelines |
| [Teacher-provisioned virtual labs in Azure](../../example-scenario/devops/teacher-provisioned-virtual-labs-azure.yml) | Teachers can easily set up virtual machines for students to work on class exercises. | Lab Services |
| [Enterprise monitoring with Azure Monitor](../../example-scenario/monitoring/enterprise-monitoring.yml) | Use Azure Monitor to achieve enterprise-level monitoring and centralized monitoring management. | Azure Monitor |

## Best practices

The [Microsoft Azure Well-Architected Framework](/azure/architecture/framework) provides reference guidance and best practices that you can use to improve the quality of your architectures. The framework comprises five pillars: Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency. Here's where to find documentation of the pillars:

- [Reliability](/azure/architecture/framework/resiliency)
- [Security](/azure/architecture/framework/security)
- [Cost Optimization](/azure/architecture/framework/cost)
- [Operational Excellence](/azure/architecture/framework/devops)
- [Performance Efficiency](/azure/architecture/framework/scalability)

The following articles are about best practices that are specific to DevOps and to some DevOps services.

### DevOps

- [How Teams at Microsoft Embraced a DevOps Culture - Azure webinar series](https://info.microsoft.com/ww-ondemand-how-teams-at-microsoft-embraced-a-devops-culture.html)
- [DevOps checklist](../../checklist/dev-ops.md)
- [Azure cloud migration best practices checklist](/azure/cloud-adoption-framework/migrate/azure-best-practices)
- [Resiliency checklist for specific Azure services](../../checklist/resiliency-per-service.md)
- [Continuous monitoring with Azure Monitor](/azure/azure-monitor/continuous-monitoring)
- [Monitoring best practices for reliability in Azure applications](/azure/architecture/framework/resiliency/monitor-best-practices)
- [Overview of the Azure Security Benchmark (v1)](/security/benchmark/azure/overview-v1)
- [Azure Identity Management and access control security best practices](/azure/security/fundamentals/identity-management-best-practices)
- [Security best practices](/azure/devops/organizations/security/security-best-practices)
- [Azure security best practices and patterns](/azure/security/fundamentals/best-practices-and-patterns)
- [Azure operational security checklist](/azure/security/fundamentals/operational-checklist)
- [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline)
- [Secure development best practices on Azure](/azure/security/develop/secure-dev-overview)

### Azure Artifacts

- [Azure Artifacts: best practices](/azure/devops/artifacts/concepts/best-practices)

### Azure Resource Manager

- [ARM template best practices](/azure/azure-resource-manager/templates/best-practices)
- [Best practices for Bicep](/azure/azure-resource-manager/bicep/best-practices)

## Stay current with DevOps

Stay current with Azure DevOps by monitoring these articles:

- [Azure DevOps Feature Timeline](/azure/devops/release-notes/features-timeline)
- [Azure DevOps documentation - what's new?](/azure/devops/release-notes/docswhatsnew)

## Additional resources

### Example solutions

- [Design a CI/CD pipeline using Azure DevOps](../../example-scenario/apps/devops-dotnet-baseline.yml)
- [Manage Microsoft 365 tenant configuration by using Microsoft365DSC and Azure DevOps](../../example-scenario/devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops.yml)
- [Run containers in a hybrid environment](../../hybrid/hybrid-containers.yml)

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - DevOps and application monitoring](../../aws-professional/services.md#devops-and-application-monitoring)
- [Google Cloud to Azure services comparison - DevOps and application monitoring](../../gcp-professional/services.md#devops-and-application-monitoring)
