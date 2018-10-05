---
title: CI/CD pipeline with Azure DevOps
description: Build and release a .NET app to Azure Web Apps using Azure DevOps.
author: christianreddington
ms.date: 07/11/18
---

# CI/CD pipeline with Azure DevOps

DevOps is the integration of development, quality assurance, and IT operations. DevOps requires both unified culture and a strong set of processes for delivering software.

This example scenario demonstrates how development teams can use Azure DevOps to deploy a .NET two-tier web application to Azure App Service. The Web Application depends on downstream Azure platform as a service (PaaS) services. This document also points out some considerations that you should make when designing such a scenario using Azure PaaS.

Adopting a modern approach to application development using Continuous Integration and Continuous Deployment (CI/CD), helps you to accelerate the delivery of value to your users through a robust build, test, deployment, and monitoring service. By using a platform such as Azure DevOps along with Azure services such as App Service, organizations can focus on the development of their scenario rather than the management of the supporting infrastructure.

## Relevant use cases

Consider DevOps for the following use cases:

* Accelerating application development and development life cycles
* Building quality and consistency into an automated build and release process

## Architecture

![Architecture overview of the Azure components involved in a DevOps scenario using Azure DevOps and Azure App Service][architecture]

This scenario covers a CI/CD pipeline for a .NET web application using Azure DevOps. The data flows through the scenario as follows:

1. Change application source code.
2. Commit application code and Web Apps web.config file.
3. Continuous integration triggers application build and unit tests.
4. Continuous deployment trigger orchestrates deployment of application artifacts *with environment-specific parameterized configuration values*.
5. Deployment to Azure App Service.
6. Azure Application Insights collects and analyzes health, performance, and usage data.
7. Review health, performance, and usage information.

### Components

* [Azure DevOps][vsts] is a service for managing your development life cycle end-to-end &mdash; from planning and project management, to code management, and continuing to build and release.
* [Azure Web Apps][web-apps] is a PaaS service for hosting web applications, REST APIs, and mobile back ends. While this article focuses on .NET, there are several additional development platform options supported.
* [Application Insights][application-insights] is a first-party, extensible Application Performance Management (APM) service for web developers on multiple platforms.

### Alternative DevOps tooling options

While this article focuses on Azure DevOps, [Team Foundation Server][team-foundation-server] could be used as on-premises substitute. Alternatively, you could also use a set of technologies for an open source development pipeline using [Jenkins][jenkins-on-azure].

From an infrastructure-as-code perspective, [Azure Resource Manager Templates][arm-templates] are included as part of the Azure DevOps project, but you could consider [Terraform][terraform] or [Chef][chef]. If you prefer an infrastructure-as-a-service (IaaS)-based deployment and require configuration management, you could consider either [Azure Automation State Configuration][desired-state-configuration], [Ansible][ansible], or [Chef][chef].

### Alternatives to Azure Web Apps

You could consider these alternatives to hosting in Azure Web Apps:

* [Azure Virtual Machines][compare-vm-hosting] &mdash; For workloads that require a high degree of control, or depend on OS components and services that are not possible with Web Apps (for example, the Windows GAC, or COM).
* [Service Fabric][service-fabric] &mdash; a good option if the workload architecture is focused around distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
* [Azure Functions][azure-functions] - an effective serverless approach if the workload architecture is centered around fine grained distributed components, requiring minimal dependencies, where individual components are only required to run on demand (not continuously) and orchestration of components is not required.

This [decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree) may help when choosing the right path to take for a migration.

### DevOps

**[Continuous Integration (CI)][continuous-integration]** maintains a stable build, with multiple developers regularly committing small, frequent changes to the shared codebase. As part of your continuous integration pipeline, you should:
* Frequently commit smaller code changes. Avoid batching up larger or more complex changes that may be more difficult to merge successfully.
* Conduct unit testing of your application components with sufficient code coverage, including testing the unhappy paths.
* Ensure the build is run against the shared master (or trunk) branch. This branch should be stable and maintained as "deployment ready". Incomplete or work-in-progress changes should be isolated in a separate branch with frequent "forward integration" merges to avoid conflicts later.

**[Continuous Delivery (CD)][continuous-delivery]** demonstrates not just a stable build but a stable deployment. This makes realizing CD a little more difficult, requiring environment-specific configuration and a mechanism for setting those values correctly. Other CD considerations include the following:
* Sufficient integration testing coverage is required to validate that the various components are configured and working correctly end-to-end.
* CD may also require setting up and resetting environment-specific data and managing database schema versions.
* Continuous delivery should also extend to load testing and user acceptance testing environments.
* Continuous delivery benefits from continuous monitoring, ideally across all environments.
* The consistency and reliability of deployments and integration testing across environments is made easier by scripting the creation and configuration of the hosting infrastructure. This is considerably easier for cloud-based workloads. For more information, see [Infrastructure as Code][infra-as-code].
* Begin continuous delivery as early as possible in the project lifecycle. The later you begin, the more difficult it will be to incorporate.
* Integration and unit tests should be given the same priority as application features.
* Use environment-agnostic deployment packages and manage environment-specific configuration via the release process.
* Protect sensitive configuration using the release management tooling, or by calling out to a Hardware-security-module (HSM) or [Azure Key Vault][azure-key-vault] during the release process. Do not store sensitive configuration within source control.

**Continuous Learning**. The most effective monitoring of a CD environment is provided by application performance monitoring (APM) tools such as [Application Insights][application-insights]. Sufficient depth of monitoring for an application workload is critical to understand bugs or performance under load. Application Insights can be integrated into VSTS to enable [continuous monitoring of the CD pipeline][app-insights-cd-monitoring]. This could be used to enable automatic progression to the next stage, without human intervention, or rollback if an alert is detected.

## Considerations

### Availability

Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.

Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]

For other availability topics, see the [availability checklist][availability] in the Azure Architecture Center.

### Scalability

When building a cloud application be aware of the [typical design patterns for scalability][design-patterns-scalability].

Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]

For other scalability topics, see the [scalability checklist][scalability] in the Azure Architecture Center.

### Security

Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.

Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.

You can find a number of [recommended practices for App Service][resiliency-app-service] in the Azure Architecture Center.

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Deploy the scenario

### Prerequisites

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][azure-free-account] before you begin.
* You must sign up for an Azure DevOps organization. For more information, see [Quickstart: Create your organization][vsts-account-create].

### Walk-through

In this scenario, you'll use the Azure DevOps project to create your CI/CD pipeline.

The Azure DevOps project will deploy an App Service Plan, App Service, and an App Insights resource for you, as well as configure the Azure DevOps project for you.

Once you've deployed the Azure DevOps project and the build is completed, review the associated code changes, work items, and test results. You will notice that no test results are displayed, because the code does not contain any tests to run.

Review the release definitions. Notice that a release pipeline has been set up, releasing our application into the Dev environment. Observe that there is a **continuous deployment trigger** set from the **Drop** build artifact, with automatic releases into the Dev environment. As part of a continuous deployment process, you may see releases that span multiple environments. A release can span both infrastructure (using techniques such as infrastructure-as-code), and can also deploy the application packages required along with any post-configuration tasks.

## Additional considerations

* Consider leveraging one of the [tokenization tasks][vsts-tokenization] available in the VSTS marketplace.
* Consider using the [Deploy: Azure Key Vault][download-keyvault-secrets] VSTS task to download secrets from an Azure Key Vault into your release. You can then use those secrets as variables in your release definition, so you can avoid storing them in source control.
* Consider using [release variables][vsts-release-variables] in your release definitions to drive configuration changes of your environments. Release variables can be scoped to an entire release or a given environment. When using variables for secret information, ensure that you select the padlock icon.
* Consider using [deployment gates][vsts-deployment-gates] in your release pipeline. This lets you leverage monitoring data in association with external systems (for example, incident management or additional bespoke systems) to determine whether a release should be promoted.
* Where manual intervention in a release pipeline is required, consider using the [approvals][vsts-approvals] functionality.
* Consider using [Application Insights][application-insights] and additional monitoring tools as early as possible in your release pipeline. Many organizations only begin monitoring in their production environment; by monitoring your other environments, you can identify bugs earlier in the development process and avoid issues in your production environment.

## Pricing

Azure DevOps costs depend on the number of users in your organization that require access, along with other factors like the number of concurrent build/releases required and number of test users. For more information, see [Azure DevOps pricing][vsts-pricing-page].

* [Azure DevOps][vsts-pricing-calculator] is a service that enables you to manage your development life cycle. It is paid for on a per-user per-month basis. There may be additional charges dependent upon concurrent pipelines needed, in addition to any additional test users or user basic licenses.

## Related resources

* [What is DevOps?][devops-whatis]
* [DevOps at Microsoft - How we work with Azure DevOps][devops-microsoft]
* [Step-by-step Tutorials: DevOps with Azure DevOps][devops-with-vsts]
* [Devops Checklist][devops-checklist]
* [Create a CI/CD pipeline for .NET with the Azure DevOps project][devops-project-create]

<!-- links -->
[ansible]: /azure/ansible/
[application-insights]: /azure/application-insights/app-insights-overview
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.md
[azure-free-account]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[arm-templates]: /azure/azure-resource-manager/resource-group-overview#template-deployment
[architecture]: ./media/architecture-devops-dotnet-webapp.png
[availability]: /azure/architecture/checklist/availability
[chef]: /azure/chef/
[design-patterns-availability]: /azure/architecture/patterns/category/availability
[design-patterns-resiliency]: /azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: /azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: /azure/architecture/patterns/category/security
[desired-state-configuration]: /azure/automation/automation-dsc-overview
[devops-microsoft]: /azure/devops/devops-at-microsoft/
[devops-with-vsts]: https://almvm.azurewebsites.net/labs/vsts/
[devops-checklist]: /azure/architecture/checklist/dev-ops
[application-insights]: https://azure.microsoft.com/services/application-insights/
[cloud-based-load-testing]: https://visualstudio.microsoft.com/team-services/cloud-load-testing/
[cloud-based-load-testing-on-premises]: /vsts/test/load-test/clt-with-private-machines?view=vsts
[jenkins-on-azure]: /azure/jenkins/
[devops-whatis]: /azure/devops/what-is-devops
[download-keyvault-secrets]: /vsts/pipelines/tasks/deploy/azure-key-vault?view=vsts
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency-app-service]: /azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: /azure/architecture/checklist/resiliency
[scalability]: /azure/architecture/checklist/scalability
[vsts]: /vsts/?view=vsts#pivot=services
[continuous-integration]: /azure/devops/what-is-continuous-integration
[continuous-delivery]: /azure/devops/what-is-continuous-delivery
[web-apps]: /azure/app-service/app-service-web-overview
[terraform]: /azure/terraform/
[vsts-account-create]: /azure/devops/organizations/accounts/create-organization-msa-or-work-student?view=vsts
[vsts-approvals]: /vsts/pipelines/release/approvals/approvals?view=vsts
[devops-project]: https://portal.azure.com/?feature.customportal=false#create/Microsoft.AzureProject
[vsts-deployment-gates]: /vsts/pipelines/release/approvals/gates?view=vsts
[vsts-pricing-calculator]: https://azure.com/e/498aa024454445a8a352e75724f900b1
[vsts-pricing-page]: https://azure.microsoft.com/pricing/details/visual-studio-team-services/
[vsts-release-variables]: /vsts/pipelines/release/variables?view=vsts&tabs=batch
[vsts-tokenization]: https://marketplace.visualstudio.com/search?term=token&target=VSTS&category=All%20categories&sortBy=Relevance
[azure-key-vault]: /azure/key-vault/key-vault-overview
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[team-foundation-server]: https://visualstudio.microsoft.com/tfs/
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[service-fabric]: /azure/service-fabric/
[azure-functions]: /azure/azure-functions/
[azure-containers]: https://azure.microsoft.com/overview/containers/
[compare-vm-hosting]: /azure/app-service/choose-web-site-cloud-service-vm
[app-insights-cd-monitoring]: /azure/application-insights/app-insights-vsts-continuous-monitoring
[azure-region-pair-bcdr]: /azure/best-practices-availability-paired-regions
[devops-project-create]: /azure/devops-project/azure-devops-project-aspnet-core
[security]: /azure/security/