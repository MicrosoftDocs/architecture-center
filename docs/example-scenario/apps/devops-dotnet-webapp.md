---
title: CI/CD pipeline with VSTS
description: An example of building and releasing a .NET App to Azure Web Apps
author: christianreddington
ms.date: 07/11/18
---
# CI/CD pipeline with VSTS

DevOps is the integration of development, quality assurance, and IT operations. DevOps requires both unified culture and a strong set of processes for delivering software.

This example scenario demonstrates how development teams can use Visual Studio Team Services to deploy a .NET two-tier web application to Azure App Service. The Web Application depends on downstream Azure Platform as a Service (PaaS) services. This document also points out some considerations that you should make when designing such a scenario using Azure Platform as a Service (PaaS).

Adopting a modern approach to application development using Continuous Integration (CI) and Continuous Deployment (CD), helps you to accelerate the delivery of value to your users through a robust build, test, deployment, and monitoring service. By using a platform such as Visual Studio Team Services in addition to Azure services such as App Service, organizations can ensure they remain focused on the development of their scenario, rather than the management of the infrastructure to enable it.

## Related use cases

Consider DevOps for the following use cases:

* Speeding up application development and development life cycles
* Building quality and consistency into an automated build and release process

## Architecture

![Architecture overview of the Azure components involved in a DevOps scenario using Visual Studio Team Services and Azure App Service][architecture]

This scenario covers a DevOps pipeline for a .NET web application using Visual Studio Team Services (VSTS). The data flows through the scenario as follows:

1. Change application source code.
2. Commit application code and Web Apps web.config file.
3. Continuous integration triggers application build and unit tests.
4. Continuous deployment trigger orchestrates deployment of application artifacts *with environment-specific parameterized configuration values*.
5. Deployment to Azure App Service.
6. Azure Application Insights collects and analyzes health, performance, and usage data.
7. Review health, performance, and usage information.

### Components

* [Resource Groups][resource-groups] are a logical container for Azure resources and also provide an access control boundary for the management plane - think of a Resource Group as representing a "unit of deployment".
* [Visual Studio Team Services (VSTS)][vsts] is a service that enables you to manage your development life cycle end-to-end; from planning and project management, to code management, through to build and release.
* [Azure Web Apps][web-apps] is a Platform as a Service (PaaS) service for hosting web applications, REST APIs, and mobile backends. While this article focuses on .NET, there are several additional development platform options supported.
* [Application Insights][application-insights] is a first-party, extensible Application Performance Management (APM) service for web developers on multiple platforms.

### Alternative DevOps tooling options

Whilst this article focuses on Visual Studio Team Services, [Team Foundation Server][team-foundation-server] could be used as on premises substitute. Alternatively, you may also find a collection of technologies being used together for an Open Source development pipeline leveraging [Jenkins][jenkins-on-azure].

From an Infrastructure as Code perspective, [Azure Resource Manager Templates][arm-templates] are included as part of the Azure DevOps project, but you could consider [Terraform][terraform] or [Chef][chef] if you have investments here. If you prefer an Infrastructure as a Service (IaaS) based deployment and require configuration management, then you could consider either [Azure Desired State Configuration][desired-state-configuration], [Ansible][ansible] or [Chef][chef].

### Alternatives to Web App Hosting

Alternatives to hosting in Azure Web Apps:

* [VM][compare-vm-hosting] - For workloads that require a high degree of control, or depend on OS components / services that are not possible with Web Apps (for example, the Windows GAC, or COM)
* [Container Hosting][azure-containers] - Where there are OS dependencies and hosting portability, or hosting density, are also requirements.
* [Service Fabric][service-fabric] - A good option if the workload architecture is focused around distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
* [Serverless Azure functions][azure-functions] - A good option if the workload architecture is centered around fine grained distributed components, requiring minimal dependencies, where individual components are only required to run on demand (not continuously) and orchestration of components is not required.

### DevOps

**[Continuous Integration (CI)][continuous-integration]** should aim to demonstrate a stable build, with more than one individual developer or team continuously committing small, frequent changes to the shared codebase.
As part of your Continuous Integration pipeline you should;

* Check in small amounts of code frequently (avoid batching up larger or more complex changes as these can be harder to merge successfully)
* Unit Test the components of your application with sufficient code coverage (including the unhappy paths)
* Ensuring the build is run against the shared, master (or trunk) branch. This branch should be stable and maintained as "deployment ready". Incomplete or work-in-progress changes should be isolated in a separate branch with frequent 'forward integration' merges to avoid conflicts later.

**[Continuous Delivery (CD)][continuous-delivery]** should aim to demonstrate not only a stable build but a stable deployment. This makes realizing CD a little more difficult, environment-specific configuration is required and a mechanism for setting those values correctly.

In addition, sufficient coverage of Integration Testing is required to ensure that the various components are configured and working correctly end-to-end.

This may also require setting up and resetting environment-specific data and managing database schema versions.

Continuous Delivery may also extend to Load Testing and User Acceptance Testing Environments.

Continuous Delivery benefits from continuous Monitoring, ideally across all environments.
The consistency and reliability of deployments and integration testing across environments is made easier by scripting the creation and configuration or the hosting infrastructure (something that is considerably easier for Cloud-based workloads, see Azure infrastructure as code) - this is also known as ["infrastructure-as-code"][infra-as-code].

* Start Continuous Delivery as early as possible in the project life-cycle. The later you leave it, the more difficult it will be.
* Integration & unit tests should be given the same priority as the project features
* Use environment agnostic deployment packages and manage environment-specific configuration through the release process.
* Protect sensitive configuration within the release management tooling or by calling out to a Hardware-security-module (HSM), or [Key Vault][azure-key-vault], during the release process. Do not store sensitive configuration within source control.

**Continuous Learning** - The most effective monitoring of a CD environment is provided by Application-Performance-Monitoring tools (APM for short), for example Microsoft's [Application Insights][application-insights]. Sufficient depth of monitoring for an application workload is critical to understand bugs, performance under load. [App Insights can be integrated into VSTS to enable continuous monitoring of the CD pipeline][app-insights-cd-monitoring]. This could be used to enable automatic progression to the next stage, without human intervention, or rollback if an alert is detected.

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

You can find a number of [recommended practices for App Service][resiliency-app-service] on the architecture center.

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Deploy the scenario

### Prerequisites

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][azure-free-account] before you begin.
* You must have an existing Visual Studio Team Services (VSTS) account. Find out more details about [creating a Visual Studio Team Services (VSTS) account][vsts-account-create].

### Walk through

In this scenario, you'll use the Azure DevOps Project to create your CI/CD pipeline.

The DevOps project will deploy an App Service Plan, App Service, and an App Insights resource for you, as well as configure the Visual Studio Team Services Project for you.

Once you've deployed the DevOps project and the build is completed, review the associated code changes, work items, and test results. You will notice no test results are displayed, as the code does not contain any tests to run.

Review the Release definitions. Notice that a release pipeline has been setup, releasing our application into Dev. Observe that there is a **continuous deployment trigger** set from the **Drop** build artifact, with automatic releases into the Dev environments. As part of a Continuous Deployment process, you may see releases span across multiple environments. A release can span both infrastructure (using techniques such as Infrastructure as Code), and also deploy the application packages required as well as any post-configuration tasks.

**Additional Considerations.**

* Consider leveraging one of the [tokenization tasks][vsts-tokenization] that are available in the VSTS marketplace.
* Consider using the [Deploy: Azure Key Vault][download-keyvault-secrets] VSTS task to download secrets from an Azure KeyVault into your release. You can then use those secrets as variables as part of your release definition, and should not be storing them in source control.
* Consider using [release variables][vsts-release-variables] in your release definitions to drive configuration changes of your environments. Release variables can be scoped to an entire release or a given environment. If using variables for secret information, ensure that you select the padlock icon.
* Consider using [deployment gates][vsts-deployment-gates] in your release pipeline. This allows you to leverage monitoring data in association with external systems (for example, incident management or additional bespoke systems) to determine whether a release should be promoted.
* Where manual intervention in a release pipeline is required, consider using the [approvals][vsts-approvals] functionality.
* Consider using [Application Insights][application-insights] and additional monitoring tooling as early as possible in your release pipeline. Most organizations only begin monitoring in their production environment, though you could identify potential bugs earlier in the process and prevent impact to your users in production.

## Pricing

Your Visual Studio Team Services costing will depend upon the number of users in your organization that require access, in addition to factors such as the number of concurrent build/releases required, and number of test users. These are detailed further on the [VSTS pricing page][vsts-pricing-page].

* [Visual Studio Team Services (VSTS)][vsts-pricing-calculator] is a service that enables you to manage your development life cycle and is paid for on a per user, per month basis. There may be additional charges dependent upon concurrent pipelines needed, in addition to any additional test users, or user basic licenses.

## Related Resources

* [What is DevOps?][devops-whatis]
* [DevOps at Microsoft - How we work with Visual Studio Team Services][devops-microsoft]
* [Step-by-step Tutorials: DevOps with Visual Studio Team Services][devops-with-vsts]
* [Create a CI/CD pipeline for .NET with the Azure DevOps project][devops-project-create]

<!-- links -->
[ansible]: /azure/ansible/
[application-insights]: /azure/application-insights/app-insights-overview
[app-service-reference-architecture]: /azure/architecture/reference-architectures/app-service-web-app/
[azure-free-account]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[arm-templates]: /azure/azure-resource-manager/resource-group-overview#template-deployment
[architecture]: ./media/devops-dotnet-webapp/architecture-devops-dotnet-webapp.png
[availability]: /azure/architecture/checklist/availability
[chef]: /azure/chef/
[design-patterns-availability]: /azure/architecture/patterns/category/availability
[design-patterns-resiliency]: /azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: /azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: /azure/architecture/patterns/category/security
[desired-state-configuration]: /azure/automation/automation-dsc-overview
[devops-microsoft]: /azure/devops/devops-at-microsoft/
[devops-with-vsts]: https://almvm.azurewebsites.net/labs/vsts/
[application-insights]: https://azure.microsoft.com/en-gb/services/application-insights/
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
[vsts-account-create]: /vsts/organizations/accounts/create-account-msa-or-work-student?view=vsts
[vsts-approvals]: /vsts/pipelines/release/approvals/approvals?view=vsts
[devops-project]: https://portal.azure.com/?feature.customportal=false#create/Microsoft.AzureProject
[vsts-deployment-gates]: /vsts/pipelines/release/approvals/gates?view=vsts
[vsts-pricing-calculator]: https://azure.com/e/498aa024454445a8a352e75724f900b1
[vsts-pricing-page]: https://azure.microsoft.com/en-us/pricing/details/visual-studio-team-services/
[vsts-release-variables]: /vsts/pipelines/release/variables?view=vsts&tabs=batch
[vsts-tokenization]: https://marketplace.visualstudio.com/search?term=token&target=VSTS&category=All%20categories&sortBy=Relevance
[azure-key-vault]: /azure/key-vault/key-vault-overview
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[team-foundation-server]: https://visualstudio.microsoft.com/tfs/
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[service-fabric]:/azure/service-fabric/
[azure-functions]:/azure/azure-functions/
[azure-containers]:https://azure.microsoft.com/en-us/overview/containers/
[compare-vm-hosting]:/azure/app-service/choose-web-site-cloud-service-vm
[app-insights-cd-monitoring]:/azure/application-insights/app-insights-vsts-continuous-monitoring
[azure-region-pair-bcdr]:/azure/best-practices-availability-paired-regions
[devops-project-create]: /vsts/pipelines/apps/cd/azure/azure-devops-project-aspnetcore?view=vsts
[security]: /azure/security/