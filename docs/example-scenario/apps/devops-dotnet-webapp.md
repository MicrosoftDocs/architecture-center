---
title: Design a CI/CD pipeline using Azure DevOps
titleSuffix: Azure Example Scenarios
description: Build and release a .NET app to Azure Web Apps using Azure DevOps.
author: christianreddington
ms.date: 12/06/2018
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
  - fasttrack
  - seodec18
  - devops
  - app-development
social_image_url: /azure/architecture/example-scenario/apps/media/architecture-devops-dotnet-webapp.svg
---

# Design a CI/CD pipeline using Azure DevOps

This scenario provides architecture and design guidance for building a continuous integration (CI) and continuous deployment (CD) pipeline. In this example, the CI/CD pipeline deploys a two-tier .NET web application to the Azure App Service.

Migrating to modern CI/CD processes provides many benefits for application builds, deployments, testing, and monitoring. By using Azure DevOps along with other services such as App Service, organizations can focus on the development of their apps rather than the management of the supporting infrastructure.

## Relevant use cases

Consider Azure DevOps and CI/CD processes for:

- Accelerating application development and development lifecycles.
- Building quality and consistency into an automated build and release process
- Increasing application stability and uptime.

## Architecture

![Architecture diagram of the Azure components involved in a DevOps scenario using Azure DevOps and Azure App Service][architecture]

The data flows through the scenario as follows:

1. A developer changes application source code.
2. Application code including the web.config file is committed to the source code repository in Azure Repos.
3. Continuous integration triggers application build and unit tests using Azure Test Plans.
4. Continuous deployment within Azure Pipelines triggers an automated deployment of application artifacts *with environment-specific configuration values*.
5. The artifacts are deployed to Azure App Service.
6. Azure Application Insights collects and analyzes health, performance, and usage data.
7. Developers monitor and manage health, performance, and usage information.
8. Backlog information is used to prioritize new features and bug fixes using Azure Boards.

### Components

- [Azure DevOps][vsts] is a service for managing your development lifecycle end-to-end&mdash;from planning and project management, to code management, and continuing to build and release.

- [Azure Web Apps][web-apps] is a PaaS service for hosting web applications, REST APIs, and mobile back ends. While this article focuses on .NET, there are several additional development platform options supported.

- [Application Insights][application-insights] is a first-party, extensible Application Performance Management (APM) service for web developers on multiple platforms.

### Alternatives

While this article focuses on Azure DevOps, [Azure DevOps Server][azure-devops-server] (previously known as Team Foundation Server) could be used as an on-premises substitute. Alternatively, you could also use a set of technologies for an open-source development pipeline using [Jenkins][jenkins-on-azure].

From an infrastructure-as-code perspective, [Resource Manager templates][arm-templates] were used as part of the Azure DevOps project, but you could consider other management technologies such as [Terraform][terraform] or [Chef][chef]. If you prefer an infrastructure-as-a-service (IaaS)-based deployment and require configuration management, you could consider either [Azure Automation State Configuration][desired-state-configuration], [Ansible][ansible], or [Chef][chef].

You could consider these alternatives to hosting in Azure Web Apps:

- [Azure Virtual Machines][compare-vm-hosting] handles workloads that require a high degree of control, or depend on OS components and services that are not possible with Web Apps (for example, the Windows GAC, or COM).

- [Service Fabric][service-fabric] is a good option if the workload architecture is focused around distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.

- [Azure Functions][azure-functions] provides an effective serverless approach if the workload architecture is centered around fine grained distributed components, requiring minimal dependencies, where individual components are only required to run on demand (not continuously) and orchestration of components is not required.

This [decision tree for Azure compute services](/azure/architecture/guide/technology-choices/compute-decision-tree) may help when choosing the right path to take for a migration.

## Management and Security Considerations

- Consider leveraging one of the [tokenization tasks][vsts-tokenization] available in the VSTS marketplace.

- [Azure Key Vault][download-keyvault-secrets] tasks can download secrets from an Azure Key Vault into your release. You can then use those secrets as variables in your release definition, which avoids storing them in source control.

- Use [release variables][vsts-release-variables] in your release definitions to drive configuration changes of your environments. Release variables can be scoped to an entire release or a given environment. When using variables for secret information, ensure that you select the padlock icon.

- [Deployment gates][vsts-deployment-gates] should be used in your release pipeline. This lets you leverage monitoring data in association with external systems (for example, incident management or additional bespoke systems) to determine whether a release should be promoted.

- Where manual intervention in a release pipeline is required, use the [approvals][vsts-approvals] functionality.

- Consider using [Application Insights][application-insights] and additional monitoring tools as early as possible in your release pipeline. Many organizations only begin monitoring in their production environment. By monitoring your other environments, you can identify bugs earlier in the development process and avoid issues in your production environment.

## Deploy the scenario

### Prerequisites

- You must have an existing Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

- You must sign up for an Azure DevOps organization. For more information, see [Quickstart: Create your organization][vsts-account-create].

### Walk-through

[Azure DevOps Projects](/azure/devops-project/azure-devops-project-github) will deploy an App Service Plan, App Service, and an App Insights resource for you, as well as configure an Azure Pipelines pipeline for you.

Once you've configure a pipeline with Azure DevOps Projects and the build is completed, review the associated code changes, work items, and test results. You will notice that no test results are displayed, because the code does not contain any tests to run.

The pipeline creates a release definition and a continuous deployment trigger, deploying our application into the Dev environment. As part of a continuous deployment process, you may see releases that span multiple environments. A release can span both infrastructure (using techniques such as infrastructure-as-code), and can also deploy the application packages required along with any post-configuration tasks.

## Pricing

Azure DevOps costs depend on the number of users in your organization that require access, along with other factors like the number of concurrent build/releases required and number of test users. For more information, see [Azure DevOps pricing][vsts-pricing-page].

This [pricing calculator][vsts-pricing-calculator] provides an estimate for running Azure DevOps with 20 users.

Azure DevOps is billed on a per-user per-month basis. There may be additional charges depending on concurrent pipelines needed, in addition to any additional test users or user basic licenses.

## Related resources

Review the following resources to learn more about CI/CD and Azure DevOps:

- [What is DevOps?][devops-whatis]
- [DevOps at Microsoft - How we work with Azure DevOps][devops-microsoft]
- [Step-by-step Tutorials: DevOps with Azure DevOps][devops-with-vsts]
- [DevOps Checklist][devops-checklist]
- [Create a CI/CD pipeline for .NET with Azure DevOps Projects][devops-project-create]

<!-- links -->

[ansible]: /azure/ansible/
[application-insights]: /azure/application-insights/app-insights-overview
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.md
[arm-templates]: /azure/azure-resource-manager/template-deployment-overview
[architecture]: ./media/architecture-devops-dotnet-webapp.svg
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
[vsts]: /azure/devops/
[continuous-integration]: /azure/devops/what-is-continuous-integration
[continuous-delivery]: /azure/devops/what-is-continuous-delivery
[web-apps]: /azure/app-service/app-service-web-overview
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
[azure-devops-server]: https://visualstudio.microsoft.com/tfs/
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[service-fabric]: /azure/service-fabric/
[azure-functions]: /azure/azure-functions/
[azure-containers]: https://azure.microsoft.com/overview/containers/
[compare-vm-hosting]: /azure/app-service/choose-web-site-cloud-service-vm
[app-insights-cd-monitoring]: /azure/application-insights/app-insights-vsts-continuous-monitoring
[azure-region-pair-bcdr]: /azure/best-practices-availability-paired-regions
[devops-project-create]: /azure/devops-project/azure-devops-project-aspnet-core
[terraform]: /azure/terraform/
