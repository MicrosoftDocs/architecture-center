---
title: Application assessment
titleSuffix: Azure Example Scenarios
description: Application assessment.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: management-and-governance
categories: management-and-governance
products:
  - azure-active-directory
ms.custom:
  - fcp
  - guide
---
# Application assessment

[Cloud rationalization](/azure/cloud-adoption-framework/digital-estate/5-rs-of-rationalization) is the process of evaluating applications to determine the best way to migrate or modernize them for the cloud.

Rationalization methods include:

- **Rehost**. Also known as a *lift and shift* migration, rehost moves a current application to the cloud with minimal change.
- **Refactor**. Slightly refactoring an application to fit *platform-as-a-service* (PaaS)-based options can reduce operational costs.
- **Rearchitect**. Rearchitect aging applications that aren't compatible with cloud components, or cloud-compatible applications that would realize cost and operational efficiencies by rearchitecting into a cloud-native solution.
- **Rebuild**. If the changes or costs to carry an application forward are too great, consider creating a new cloud-native code base. Rebuild is especially appropriate for applications that previously met business needs, but are now unsupported or misaligned with current business processes.

Before you decide on an appropriate strategy, analyze the current application to determine the risk and complexity of each method. Consider application lifecycle, technology, infrastructure, performance, and operations and monitoring. For multitier architectures, evaluate the presentation tier, service tier, integrations tier, and data tier.

The following checklists evaluate an application to determine the complexity and risk of rearchitecting or rebuilding.

## Complexity and risk
Each of the following factors adds to complexity, risk, or both.

### Architecture

Define the high-level architecture, such as web application, web services, data storage, or caching.

| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| Application components don't translate directly to Azure.| ✔ | ✔ |
| The application needs code changes to run in Azure.| ✔ | ✔ |
| The application needs major, complex code changes to run in Azure.| ✔ | ✔ |

### Business drivers

Older applications might require extensive changes to get to the cloud.

| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| This application has been around for more than three years. | ✔ | |
| This application is business critical. | | ✔ |
| There are technology blockers for migration. | ✔ | |
| There are business blockers for migration. | ✔ | |
| This application has compliance requirements. | | ✔ |
| The application is subject to data requirements that are specific to the country/region.| | ✔ |
| The application is publicly accessible.| ✔ | ✔ |

### Technology

| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| This is not a web-based application, and isn't hosted on a web server.| ✔ | |
| The app isn't hosted in Windows IIS| ✔ | |
| The app isn't hosted on Linux| ✔ | |
| The application is hosted in a web farm, and requires multiple servers to host the web components.| ✔ | ✔ |
| The application requires third-party software to be installed on the servers.| ✔ | ✔ |
| The application is hosted in a single datacenter, and operations are performed in a single location.| ✔ | |
| The application accesses the server's registry.| ✔ | |
| The application sends emails, and needs access to an SMTP server.| ✔ | |
| This isn't a .NET application.| ✔ | |
| The application uses SQL Server as its data store.| ✔ | |
| The application stores data on local disks, and needs access to the disks to operate properly.| ✔ | |
| The application uses Windows Services to process asynchronous operations, or needs external services to process data or operations.| ✔ | |

### Deployment
When assessing deployment requirements, consider:
- Number of daily users
- Average number of concurrent users
- Expected traffic
- Bandwidth in Gbps
- Requests per second
- Amount of memory needed

You can reduce deployment risk by storing code under source control in a version control system such as Git, Azure DevOps Server, or SVN.

| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| Using existing code and data is a #1 priority.| ✔ | ✔ |
| The application code isn't under source control.| | ✔ |
| There's no automated build process like Azure DevOps Server or Jenkins.| | ✔ |
| There's no automated release process to deploy the application.| ✔ | ✔ |
| The application has a Service Level Agreement (SLA) that dictates the amount of expected downtime.| | ✔ |
| The application experiences peak or variable usage times or loads.| | ✔ |
| The web application saves its session state in process, rather than an external data store.| ✔ | |

### Operations
| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| The application doesn't have a well-established instrumentation strategy or standard instrumentation framework.| | ✔ |
| The application doesn't use monitoring tools, and the operations team doesn't monitor the app's performance.| | ✔ |
| The application has measured SLA in place, and the operations team monitors the application's performance.| | ✔ |
| The application writes to a log store, event log, log file, log database, or Application Insights.| ✔ | |
| The application doesn't write to a log store, event log, log file, log database, or Application Insights.| | ✔ |
| The application isn't part of the organization's disaster recovery plan.| | ✔ |

### Security
| Factor | Complexity | Risk |
|------------------------------------------------------------------|---|---|
| The application uses Active Directory to authenticate users.| ✔ | ✔ |
| The organization hasn't yet configured Azure Active Directory (Azure AD), or hasn't configured Azure AD Connect to synchronize on-premises AD with Azure AD.| ✔ | |
| The application requires access to on-premises resources, which will require VPN connectivity from Azure.| ✔ | |
| The organization hasn't yet configured a VPN connection between Azure and their on-premises environment.| ✔ | ✔ |
| The application requires an SSL certificate to run.| ✔ | ✔ |

### Results
Count your application's **Complexity** and **Risk** checkmarks.

- The expected level of complexity to migrate or modernize the application to Azure is: **Total Complexity/25**.
- The expected risk involved is: **Total Risk/19**.

For both complexity and risk, a score of <0.3 = low, <0.7 = medium, >0.7 = high.

## Refactor, rearchitect, or rebuild

To rationalize whether to rehost, refactor, rearchitect, or rebuild your application, consider the following points. Many of these factors also contribute to complexity and risk.

Determine whether the application components can translate directly to Azure. If so, you don't need code changes to move the application to Azure, and could use rehost or refactor strategies. If not, you need to rewrite code, so you need to rearchitect or rebuild.

If the app does need code changes, determine the complexity and extent of the needed changes. Minor changes might allow for rearchitecting, while major changes may require rebuilding.

### Rehost or refactor

- If using existing code and data is a top priority, consider a refactor strategy rather than rearchitecting or rebuilding.

- If you have pressing timelines like datacenter shutdown or contract expiration, end-of-life licensing, or mergers or acquisitions, the fastest way to get the application to Azure might be to rehost, followed by refactoring to take advantage of cloud capabilities.

### Rearchitect or rebuild

- If there are applications serving similar needs in your portfolio, this might be an opportunity to rearchitect or rebuild the entire solution.

- If you want to [implement multi-tier or microservices architecture](../microservices/migrate-monolith.yml) for a monolithic app, you must rearchitect or rebuild the app. If you don't mind retaining the monolithic structure, you might be able to rehost or refactor.

- Rearchitect or rebuild the app to take advantage of cloud capabilities if you plan to update the app more often than yearly, if the app has peak or variable usage times, or if you expect the app to handle high traffic.

To decide between rearchitecting or rebuilding, assess the following factors. The largest scoring result indicates your best strategy.

| Factor | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|
| There are other applications serving similar needs in your portfolio.| ✔ | ✔ |
| The application needs minor code changes to run in Azure.| ✔ | |
| The application needs major, complex code changes to run in Azure.| | ✔ |
| It's important to use existing code.| ✔ | |
| You want to move a monolithic application to multi-tier architecture.| ✔| |
| You want to move a monolithic application to a microservices architecture.| ✔ | ✔ |
| You expect this app to add breakthrough capabilities like AI, IoT, or bots.| | ✔ |
| Among functionality, cost, infrastructure, and processes, functionality is the least efficient aspect of this application.| | ✔ |
| The application requires third-party software installed on the servers.| ✔ | |
| The application accesses the server's registry.| ✔ | |
| The application sends emails and needs access to an SMTP server.| ✔ | |
| The application uses SQL Server as its data store.| ✔ | |
| The application stores data on local disks, and needs access to the disks to run properly.| ✔ | |
| The application uses Windows services to process asynchronous operations, or needs external services to process data or operations.| ✔ | |
| A web application saves its session state in process, rather than to an external data store.| ✔ | |
| The app has peak and variable usage times and loads.| ✔ | ✔ |
| You expect the application to handle high traffic.| ✔ | ✔ |

## Next steps

- [What is a digital estate?](/azure/cloud-adoption-framework/digital-estate)
- [Approaches to digital estate planning](/azure/cloud-adoption-framework/digital-estate/approach)
- [Rationalize the digital estate](/azure/cloud-adoption-framework/digital-estate/rationalize)

## Related resources

- [Migration architecture design](../guide/migration/migration-start-here.md)
- [Build migration plan with Azure Migrate](/azure/migrate/concepts-migration-planning)


