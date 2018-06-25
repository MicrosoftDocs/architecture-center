---
title: DevOps CI/CD for .NET on Azure Web Apps
description: An example of building and releasing a .NET App to Azure Web Apps
author: christianreddington
ms.date: <publish or update date>
---
# Deploy a .NET application to Azure Web Apps using Visual Studio Team Services as the CI/CD Pipeline

Introductory Paragraphs

## Potential use cases

You should consider this solution for the following use cases:

* Speeding up application development and development life cycles
* Building quality and consistency into an automated build and release process

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the Azure components involved in a DevOps solution using Visual Studio Team Services and Azure Web Apps][architecture]

## Architecture

This solution covers a DevOps pipeline for a .NET web application using Visual Studio Team Services (VSTS). The data flows through the solution as follows:

1. Change application source code.
2. Commit application code and Web Apps web.config file.
3. Continuous integration triggers application build and unit tests.
4. Continuous deployment trigger orchestrates deployment of application artifacts with environment-specific parameters.
5. Deployment to Web Apps.
6. Azure Application Insights collects and analyzes health, performance, and usage data.
7. Review health, performance, and usage information.

### Components

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Visual Studio Team Services (VSTS)][vsts] is a service that enables you to manage your development life cycle; from planning and code management through to build and release.
* [Azure Web Apps][web-apps] is a Platform as a Service (PaaS) service for hosting web applications, REST APIs, and mobile back ends. While this article focuses on .NET, there are several additional options available.

### Alternatives

* List of alternative options and why you might use them.

### Availability

Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.

Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]

For additional considerations concerning availability, please see the [availability checklist][availability] in the architecture center.

### Scalability

When building a cloud application be aware of the [typical design patterns for scalability][design-patterns-scalability].

Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]

For other scalability topics please see the  [scalability checklist][scalability] available in the architecure center.

### Security

Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.

Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]

For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.

You can find a number of [resiliency recommended practices for App Service][resiliency-app-service] on the architecture center.

For a deeper discussion on [resiliency][resiliency] please see the relevant article in the architecure center.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: describe what a small implementation is.
* [Medium][medium-pricing]: describe what a medium implementation is.
* [Large][large-pricing]: describe what a large implementation is.

## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[app-service-reference-architecture]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/
[architecture]: ./media/devops-dotnet-webapp/architecture-devops-dotnet-webapp.png
[availability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/availability
[design-patterns-availability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/availability
[design-patterns-resiliency]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/security
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[resiliency-app-service]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[vsts]: https://docs.microsoft.com/en-us/vsts/?view=vsts#pivot=services
[web-apps]: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview