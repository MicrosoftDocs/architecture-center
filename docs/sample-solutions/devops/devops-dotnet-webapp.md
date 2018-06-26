---
title: DevOps CI/CD for .NET on Azure Web Apps
description: An example of building and releasing a .NET App to Azure Web Apps
author: christianreddington
ms.date: <publish or update date>
---
# Deploy a .NET application to Azure App Service using Visual Studio Team Services as the CI/CD Pipeline

Introductory Paragraphs

## Potential use cases

You should consider this solution for the following use cases:

* Speeding up application development and development life cycles
* Building quality and consistency into an automated build and release process

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the Azure components involved in a DevOps solution using Visual Studio Team Services and Azure App Service][architecture]

## Architecture

This solution covers a DevOps pipeline for a .NET web application using Visual Studio Team Services (VSTS). The data flows through the solution as follows:

1. Change application source code.
2. Commit application code and Web Apps web.config file.
3. Continuous integration triggers application build and unit tests.
4. Continuous deployment trigger orchestrates deployment of application artifacts with environment-specific parameters.
5. Deployment to Azure App Service.
6. Azure Application Insights collects and analyzes health, performance, and usage data.
7. Review health, performance, and usage information.

### Components

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Visual Studio Team Services (VSTS)][vsts] is a service that enables you to manage your development life cycle; from planning and code management through to build and release.
* [Azure Web Apps][web-apps] is a Platform as a Service (PaaS) service for hosting web applications, REST APIs, and mobile back ends. While this article focuses on .NET, there are several additional options available.
* [Application Insights][application-insights] is an extensible Application Performance Management (APM) service for web developers on multiple platforms.

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
* For other scalability topics please see the [scalability checklist][scalability] available in the architecure center.

### Security

* Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.
* Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

* Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.
* You can find a number of [resiliency recommended practices for App Service][resiliency-app-service] on the architecture center.
* For a deeper discussion on [resiliency][resiliency] please see the relevant article in the architecure center.

## Deploy the solution

### Prerequisites

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][azure-free-account] before you begin.
* You must have an existing Visual Studio Team Services (VSTS) account. Find out more details about [creating a Visual Studio Team Services (VSTS) account][vsts-account-create].

### Walk through

As we will be using Visual Studio Team Services to drive the DevOps pipeline, we cannot leverage ARM Templates to create entities in VSTS. We will leverage the VSTS Demo Generator for the purposes of this sample.

#### Setup steps

1. Navigate to the [VSTS Demo Generator][vsts-demo-generator].
2. Sign in using the credentials for the appropriate account for your VSTS account.
3. Select your VSTS account from **Account Name**.
4. Enter an appropriate project name into **New Project Name**.
5. Using the ellipsis, select the **PartsUnlimited** sample from the **general** section.
6. Click on the link to your team project once it has been provisioned.

#### Continuous Integration - Builds

1. Navigate to **Build and Release**, and click on the **Builds** tab.
2. Select the **PartsUnlimitedE2E** build definition.
3. Click **Edit**.
4. Review the tasks included as part of the build definition. Notice  we are including a test task to run our unit tests as part of our CI pipeline.
5. Browse to the **Triggers** tab in your build definition, and notice that **Enable Continuous Integration** is enabled.
6. Select **Queue**, and opt for an appropriate agent queue to build a .NET Project.
7. Once the build has completed, navigate to the completed build. Review the associated code changes, work items and test results.

#### Continuous Deployment - Releases

**Additional Considerations.**

* Tokenization of secrets
* Using variables as part of deployment

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: describe what a small implementation is.
* [Medium][medium-pricing]: describe what a medium implementation is.
* [Large][large-pricing]: describe what a large implementation is.
* [VSTS][vsts-pricing]: Visual Studio Team Services (VSTS) is a service that enables you to manage your development life cycle, and is paid for on a per user, per month basis. There may be additional charges dependent upon concurrent pipelines needed, in addition to any additional test users, or user basic licenses.

## Related Resources

* [DevOps with Visual Studio Team Services][devops-with-vsts]

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[application-insights]: https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview
[app-service-reference-architecture]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/
[azure-free-account]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[architecture]: ./media/devops-dotnet-webapp/architecture-devops-dotnet-webapp.png
[availability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/availability
[design-patterns-availability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/availability
[design-patterns-resiliency]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/security
[devops-with-vsts]: https://almvm.azurewebsites.net/labs/vsts/
[application-insights]: https://azure.microsoft.com/en-gb/services/application-insights/
[cloud-based-load-testing]: https://visualstudio.microsoft.com/team-services/cloud-load-testing/
[cloud-based-load-testing-on-premises]: https://docs.microsoft.com/en-us/vsts/test/load-test/clt-with-private-machines?view=vsts
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[resiliency-app-service]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[vsts]: https://docs.microsoft.com/en-us/vsts/?view=vsts#pivot=services
[continuous-integration]: https://docs.microsoft.com/en-us/azure/devops/what-is-continuous-integration
[continuous-delivery]: https://docs.microsoft.com/en-us/azure/devops/what-is-continuous-delivery
[web-apps]: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview
[vsts-account-create]: https://docs.microsoft.com/en-gb/vsts/organizations/accounts/create-account-msa-or-work-student?view=vsts
[vsts-demo-generator]: https://vstsdemogenerator.azurewebsites.net/
[vsts-pricing]: https://azure.microsoft.com/en-us/pricing/details/visual-studio-team-services/
[azure-key-vault]: https://docs.microsoft.com/en-gb/azure/key-vault/key-vault-overview
[infra-as-code]: https://blogs.msdn.microsoft.com/mvpawardprogram/2018/02/13/infrastructure-as-code/