---
title: DevOps CI/CD for .NET on Azure Web Apps
description: An example of building and releasing a .NET App to Azure Web Apps
author: christianreddington
ms.date: <publish or update date>
---
# Deploy a .NET application to Azure App Service using Visual Studio Team Services as the CI/CD Pipeline

DevOps is the integration of development, quality assurance and IT operations. DevOps requires both unified culture and a strong set of processes for delivering software.

This sample solution demonstrates how Visual Studio Team Services can be used, by development teams, to deploy a .NET Browser based two tier Web Application to Azure App Service. The Web Application is dependent on downstream Azure Platform as a Service (PaaS) services.

This document also points out a number of the considerations that you should make whilst you architect such a solution using Azure Platform as a Service (PaaS).

Adopting a modern approach to application development using Continuous Integration (CI) and Continuous Deployment (CD), helps  you to accelerate the delivery of value to your users through a robust build, test, deployment and monitoring service.

By using a platform such as Visual Studio Team Services in addition to Azure services such as App Service, organizations can ensure they remain focused on the development of their solution, rather than the management of the infrastructure to enable it.

## Potential use cases

You should consider DevOps for the following use cases:

* Speeding up application development and development life cycles
* Building quality and consistency into an automated build and release process

## Architecture diagram

The solution diagram below is an example of the DevOps processes and components:

![Architecture overview of the Azure components involved in a DevOps solution using Visual Studio Team Services and Azure App Service][architecture]

## Architecture

This solution covers a DevOps pipeline for a .NET web application using Visual Studio Team Services (VSTS). The data flows through the solution as follows:

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
* [Azure Web Apps][web-apps] is a Platform as a Service (PaaS) service for hosting web applications, REST APIs, and mobile back ends. While this article focuses on .NET, there are several additional development platform options supported.
* [Application Insights][application-insights] is a first-party, extensible Application Performance Management (APM) service for web developers on multiple platforms.

### Alternative DevOps tooling options

Whilst this article focuses on Visual Studio Team Services, [Team Foundation Server][team-foundation-server] could be used as on premises substitute. Alternatively, you may also find a collection of technologies being used together for an Open Source development pipeline leveraging [Jenkins][jenkins-on-azure].

From an Infrastructure as Code perspective, [Azure Resource Manager (ARM) Templates][arm-templates] are included as part of the Azure DevOps project, but you could consider [Terraform][terraform] or [Chef][chef] if you have investments here. If you prefer an Infrastructure as a Service (IaaS) based deployment and require configuration management, then you could consider either [Azure Desired State Configuration][desired-state-configuration], [Ansible][ansible] or [Chef][chef].

### Alternatives to Web App Hosting

Alternatives to hosting in Azure Web Apps:

* [VM][compare-vm-hosting] - For workloads that require a high degree of control, or depend on OS components / services that are not possible with Web Apps (e.g. the Windows GAC, or COM)
* [Container Hosting][azure-containers] - Where there are OS dependencies and hosting portability, or hosting density, are also requirements.

Other options include:

* [Service Fabric][service-fabric] - A good option if the workload architecture is focused around distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
* [Serverless Azure functions][azure-functions] - A good option if the workload architecture is centered around fine grained distributed components, requiring minimal dependencies, where individual components are only required to run on demand (not continuously) and orchestration of components is not required.

### DevOps

**[Continuous Integration (CI)][continuous-integration]** should aim to demonstrate a stable build, with more than one individual developer or team continuously committing small, frequent changes to the shared codebase.
As part of your Continuous Integration pipeline you should;

* Check in small amounts of code frequently (avoid batching up larger or more complex changes as these can be harder to merge successfully)
* Unit Test the components of your application with sufficient code coverage (including the unhappy paths)
* Ensuring the build is run against the shared, master (or trunk) branch. This branch should be stable and maintained as "deployment ready". Incomplete or work-in-progress changes should be isolated in a separate branch with frequent 'forward integration' merges to avoid conflicts later.

**[Continuous Delivery (CD)][continuous-delivery]** should aim to demonstrate not only a stable build but a stable deployment. This makes realising CD a little more difficult, environment specific configuration is required and a mechanism for setting those values correctly.

In addition, sufficient coverage of Integration Testing is required to ensure that the various components are configured and working correctly end-to-end.

This may also require setting up and resetting environment specific data and managing database schema versions.

Continuous Delivery may also extend to Load Testing and User Acceptance Testing Environments.

Continuous Delivery benefits from continuous Monitoring, ideally across all environments.
The consistency and reliability of deployments and integration testing across environments is made easier by scripting the creation and configuration or the hosting infrastructure (something which is considerably easier for Cloud based workloads, see Azure infrastructure as code) - this is also known as ["infrastructure-as-code"][infra-as-code].

* Start Continuous Delivery as early as possible in the project life-cycle. The later you leave it, the more difficult it will be.
* Integration & unit tests should be given the same priority as the project features
* Use environment agnostic deployment packages and manage environment specific configuration through the release process.
* Protect sensitive configuration within the release management tooling or by calling out to a Hardware-security-module (HSM), or [Key Vault][azure-key-vault], during the release process. Do not store sensitive configuration within source control.

**Continuous Learning** - The most effective monitoring of a CD environment is provided by Application-Performance-Monitoring tools (APM for short), for example Microsoft's [Application Insights][application-insights].

### Availability

* Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.
* Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For additional considerations concerning availability, please see the [availability checklist][availability] in the architecture center.

### Scalability

* When building a cloud application be aware of the [typical design patterns for scalability][design-patterns-scalability].
* Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For other scalability topics please see the [scalability checklist][scalability] available in the architecture center.

### Security

* Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.
* Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].

### Resiliency

* Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.
* You can find a number of [resiliency recommended practices for App Service][resiliency-app-service] on the architecture center.
* For a deeper discussion on [resiliency][resiliency] please see the relevant article in the architecture center.

## Deploy the solution

### Prerequisites

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][azure-free-account] before you begin.
* You must have an existing Visual Studio Team Services (VSTS) account. Find out more details about [creating a Visual Studio Team Services (VSTS) account][vsts-account-create].

### Walk through

As we will be using Visual Studio Team Services to drive the DevOps pipeline, we cannot leverage ARM Templates to create entities in VSTS. We will leverage the Azure DevOps Project service for the purposes of this sample.

You can follow the Azure Docs to [Create a CI/CD pipeline for .NET with the Azure DevOps project][devops-project-create], if you are not comfortable with this approach.

The DevOps project will deploy an App Service Plan, App Service and app App Insights resource for you, as well as configure the Visual Studio Team Services Project for you.

Once you have completed the DevOps project and the build has complete, review the associated code changes, work items and test results. You will notice no test results are displayed, as the code does not contain any tests to run.

Review the Release definitions. Notice that a release pipeline has been setup, releasing our application into Dev. Observe that there is a **continuous deployment trigger** set from the **Drop** build artifact, with automatic releases into the Dev environments. As part of a Continuous Deployment process, you may see releases span across multiple environments. A release can span both infrastructure (using techniques such as Infrastructure as Code), and also deploy the application packages required as well as any post-configuration tasks.

**Additional Considerations.**

* Consider leveraging one of the [tokenization tasks][vsts-tokenization] that are available in the VSTS marketplace.
* Consider using the [Deploy: Azure Key Vault][download-keyvault-secrets] VSTS task to download secrets from an Azure KeyVault into your release. You can then use those secrets as variables as part of your release definition, and should not be storing them in source control.
* Consider using [release variables][vsts-release-variables] in your release definitions to drive configuration changes of your environments. Release variables can be scoped to an entire release or a given environment. If using variables for secret information, ensure that you select the padlock icon.
* Consider using [deployment gates][vsts-deployment-gates] in your release pipeline. This allows you to leverage monitoring data in association with external systems (e.g. incident management or additional bespoke systems) to determine whether a release should be promoted.
* Where manual intervention in a release pipeline is required, consider using the [approvals][vsts-approvals] functionality.
* Consider using [Application Insights][application-insights] and additional monitoring tooling as early as possible in your release pipeline. Most organizations only begin monitoring in their production environment, though you could identify potential bugs earlier in the process and prevent impact to your users in production.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get in your App Service solution.

* [Small][small-pricing]: The Small Web Application Architecture consists of a simple two tier application built out over Azure PaaS services. High Availability (HA) and the ability to scale out and back under burst load are accommodated through a "auto scale" rule. Application Performance Monitoring (APM) is enabled through Application Insights. Sufficient depth of monitoring for an application workload is critical to understand bugs, performance under load. [App Insights can be integrated into VSTS to enable continuous monitoring of the CD pipeline][app-insights-cd-monitoring]. This could be used to enable automatic progression to the next stage, without human intervention, or rollback if an alert is detected.
* [Medium][medium-pricing]: The Medium Web Application Architecture extends the Small architecture with a more complex and less tightly coupled, three tier application architecture built out over Azure PaaS services. This architecture leverages both traditional Relational data store (SQL DB PaaS) and highly scalable NoSQL store (CosmosDB). Note: Pricing CosmosDB will depend on the workload. Proof of Concepts & testing are recommended to optimize the correct number of RUs required for production to meet the project workload requirements.
* [Large][large-pricing]: The Large Web Application Architecture extends the Medium architecture by introducing a passive (or warm) standby secondary deployment in the [paired azure region][azure-region-pair-bcdr] to the primary deployment. The Disaster Recovery (DR) capability should be measured against the workloads Recovery Time Objective (RTO) and Recovery Point Objective (RPO). The data tier, SQL Azure DB and CosmosDB allow for continuous data replication and Traffic Manager is used to facilitate a manual or automatic fail over of consumer traffic to the front end Web Application Tier.

Where possible resources in the secondary deployment can be provisioned scaled back, whilst not in use, until they're required on fail over.

Your Visual Studio Team Services costing will depend upon the number of users in your organization that require access, in addition to factors such as the number of concurrent build/releases required, and number of test users. These are detailed further on the [VSTS pricing page][vsts-pricing-page].

* [Visual Studio Team Services (VSTS)][vsts-pricing-calculator] is a service that enables you to manage your development life cycle and is paid for on a per user, per month basis. There may be additional charges dependent upon concurrent pipelines needed, in addition to any additional test users, or user basic licenses.

## Related Resources

* [What is DevOps?][devops-whatis]
* [DevOps at Microsoft - How we work with Visual Studio Team Services][devops-microsoft]
* [Step-by-step Tutorials: DevOps with Visual Studio Team Services][devops-with-vsts]

<!-- links -->
[small-pricing]: https://azure.com/e/9bb582ce4ab64617bf328bf13178d328
[medium-pricing]: https://azure.com/e/9b63ca1ede5b4e6085411660b1e7b8e9
[large-pricing]: https://azure.com/e/a96bf5d849174a4c95adc5bcfc4531ca
[ansible]: https://docs.microsoft.com/en-us/azure/ansible/
[application-insights]: https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview
[app-service-reference-architecture]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/
[azure-free-account]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[arm-templates]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#template-deployment
[architecture]: ./media/devops-dotnet-webapp/architecture-devops-dotnet-webapp.png
[availability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/availability
[chef]: https://docs.microsoft.com/en-us/azure/chef/
[design-patterns-availability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/availability
[design-patterns-resiliency]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/security
[desired-state-configuration]: https://docs.microsoft.com/en-us/azure/automation/automation-dsc-overview
[devops-microsoft]: https://docs.microsoft.com/en-us/azure/devops/devops-at-microsoft/
[devops-with-vsts]: https://almvm.azurewebsites.net/labs/vsts/
[application-insights]: https://azure.microsoft.com/en-gb/services/application-insights/
[cloud-based-load-testing]: https://visualstudio.microsoft.com/team-services/cloud-load-testing/
[cloud-based-load-testing-on-premises]: https://docs.microsoft.com/en-us/vsts/test/load-test/clt-with-private-machines?view=vsts
[jenkins-on-azure]: https://docs.microsoft.com/en-us/azure/jenkins/
[devops-whatis]: https://docs.microsoft.com/en-us/azure/devops/what-is-devops
[download-keyvault-secrets]: https://docs.microsoft.com/en-us/vsts/pipelines/tasks/deploy/azure-key-vault?view=vsts
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[resiliency-app-service]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[vsts]: https://docs.microsoft.com/en-us/vsts/?view=vsts#pivot=services
[continuous-integration]: https://docs.microsoft.com/en-us/azure/devops/what-is-continuous-integration
[continuous-delivery]: https://docs.microsoft.com/en-us/azure/devops/what-is-continuous-delivery
[web-apps]: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview
[terraform]: https://docs.microsoft.com/en-us/azure/terraform/
[vsts-account-create]: https://docs.microsoft.com/en-gb/vsts/organizations/accounts/create-account-msa-or-work-student?view=vsts
[vsts-approvals]: https://docs.microsoft.com/en-us/vsts/pipelines/release/approvals/approvals?view=vsts
[devops-project]: https://portal.azure.com/?feature.customportal=false#create/Microsoft.AzureProject
[vsts-deployment-gates]: https://docs.microsoft.com/en-us/vsts/pipelines/release/approvals/gates?view=vsts
[vsts-pricing-calculator]: https://azure.com/e/498aa024454445a8a352e75724f900b1
[vsts-pricing-page]: https://azure.microsoft.com/en-us/pricing/details/visual-studio-team-services/
[vsts-release-variables]: https://docs.microsoft.com/en-us/vsts/pipelines/release/variables?view=vsts&tabs=batch
[vsts-tokenization]: https://marketplace.visualstudio.com/search?term=token&target=VSTS&category=All%20categories&sortBy=Relevance
[azure-key-vault]: https://docs.microsoft.com/en-gb/azure/key-vault/key-vault-overview
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[team-foundation-server]: https://visualstudio.microsoft.com/tfs/
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/
[service-fabric]:https://docs.microsoft.com/en-us/azure/service-fabric/
[azure-functions]:https://docs.microsoft.com/en-us/azure/azure-functions/
[azure-containers]:https://azure.microsoft.com/en-us/overview/containers/
[compare-vm-hosting]:https://docs.microsoft.com/en-us/azure/app-service/choose-web-site-cloud-service-vm
[app-insights-cd-monitoring]:https://docs.microsoft.com/en-us/azure/application-insights/app-insights-vsts-continuous-monitoring
[azure-region-pair-bcdr]:https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions
[devops-project-create]: https://docs.microsoft.com/en-gb/vsts/pipelines/apps/cd/azure/azure-devops-project-aspnetcore?view=vsts