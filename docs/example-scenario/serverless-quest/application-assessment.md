---
title: Application assessment
titleSuffix: Azure Example Scenarios
description: Application assessment.
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Application assessment
The goal of application assessment questionnaire is to certify if the main aspects of the application are being evaluated and to determine how complex and risky it is to adopt rearchitect or rebuild strategies.
? To be review: Application Lifecycle, Technology, Performance, Operations and Monitoring, Presentation Tier, Service Tier, Integrations Tier, Data Tier, Application Infrastructure.
## Business Drivers
| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| How long has this application been around? More than 3 years? Older applications may require extensive changes to get to the cloud. | Yes = 1 | - | - | - |
| Is this application business critical? | - | Yes = 1 | - | - |
| Are there technology blockers for migration? | Yes = 1 | - | - | - |
| Are there are business blockers for migration? | Yes = 1 | - | - | - |
| Is this application having compliance requirements? | - | Yes = 1 | - | - |
| Is the application subject to country-specific data requirements?| - | Yes = 1 | - | - |
| Is the application publicly accessible?| Yes = 1 | Yes = 1 | - | - |
| Are there applications serving similar needs in your portfolio? This may be an opportunity to Rearchitect or Rebuild the solution.| - | - | Yes = 1 | Yes = 1 |
| Do you expect this app to add breakthrough capabilities like intelligence, IoT, Bots? | - | - | - | Yes = 1 |
| Do you have pressing timeline (DC shutdown, EoL licensing, DC contract expiration, M&A)? The fastest way to get the application to Azure may be to Rehost, followed by Refactoring to take advantage of Cloud capabilities.| - | - | - | - |
| If you were to decide on a migration/modernization strategy, which one would you pick?| - | - | Yes = 1 | Yes = 1 |
| Is “functionality” the least efficient aspects of this application (functionality, cost, infra, processes)? | - | - | - | Yes = 1 |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total=  |total=  |total=  |total=  |

## Application Architecture
Describe the high-level architecture. Web Application, Web Services, Data storage, Caching, etc.

| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| Do application components translate directly to Azure? If true, no code changes are needed to move the application to Azure. So, you can implement Refactor strategy.  | No = 1 | No = 1 | - | - |
| Level of complexity for changes needed to get to Azure. If changes are needed, how extensive are they to get the application running in Azure? If no changes you can implement Refactor strategy.| Minor = 1 <br/> Major = 2 | Minor = 1 <br/> Major = 2 | Minor Changes = 1 | Major Changes = 1 | 
| What's the next architectural milestone you want to achieve for this app? Good with monolithic for this app, you can implement Refactor strategy.| - | - | Multi-tier <br/> Micro-services = 1 | Micro-services = 1 |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total= |total= |total= |total= |

## Technology
| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| Is this a Web-based application? The application is hosted on a web server.| No =1 | - | - | - |
| Is the application hosted in IIS (Windows)?| No =1 | - | - | - |
| Is the application hosted in Linux?| No =1 | - | - | - |
| Is the application hosted in a web farm? The application requires multiple servers to host the web components.| Yes =1 | Yes =1 | - | - |
| Does the application require third-party software installed on the servers? Third-party software must be installed on the server.| Yes =1 | - | Yes =1 | - |
| Is the application hosted in a single data center? The application's operations are performed in a single location.| Yes =1 | - | - | - |
| Does the application access the server's registry?| Yes =1 | - | Yes =1 | - |
| Does the application send emails? The application needs access to an SMTP server.| Yes =1 | - | Yes =1 | - |
| Is this a .NET application?| No =1 | - | - | - |
| Does the application use SQL Server as its data store?| Yes =1 | - | Yes =1 | - |
| Does the application stores data on local disk? The application requires access to a local disk to store information to operate properly.| Yes =1 | - | Yes =1 | - |
| Does the application use Windows Services to process asynchronous operations? The application requires external services to process data or to process operations.| Yes =1 | - | Yes =1 | - |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total= |total= |total= |total= |

## Deployment
Number of daily users:
Number of concurrent users (average):
Expected traffic. Bandwidth in Gbps:
Requests per second:
Amount of Memory needed:

| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| Is the application code under source control? The team has access to the application code, and it is stored in a Version Control system such as Git, TFS, SVN, etc.| - | No = 1 | - | - |
| How important is it to leverage your existing code and data? If is #1 priority, you should consider implement Refactor strategy.| Important = 1 | Important = 1 | Important & Nice to have = 1| Nice to have = 1|
| Is build automation in place? The team has an automated build process in place with a system such as TFS, Jenkins, or others.| - | No = 1 | - | - |
| Is release automation in place? There is an automated process to deploy the application.| No = 1 | No = 1 | - | - |
| How often do you plan to update the app? > once every year?| - | - | Yes = 1| Yes = 1|
| Is this application governed by a Service Level Agreement (SLA)? There is a Service Level Agreement in place that dictates the amount of downtime that can be expected by the application.| - | Yes = 1 | - | - |
| Does application experiences peak usage times or days? The load on application usage changes throughout the day, week, or month.| - | Yes = 1 | Yes = 1 | Yes = 1|
| Is session state managed in-process? The web application saves its session-state in process rather than an external data store (Applicable for web applications).| Yes = 1 | - | Yes = 1 | - |
| Do you expect this application to handle large traffic?| - | - | Yes = 1 | Yes = 1 |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total= |total= |total= |total= |

## Operations
| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| Has the application a well-established instrumentation strategy? The application uses a standard instrumentation framework.| - | No = 1 | - | - |
| Are the organization's monitoring tools applied to this application? The organization's Operations team monitors the application's performance.| - | No = 1 | - | - |
| Has the application measured SLA in place? The application’s Operation team monitors the application's performance.| - | Yes = 1 | - | - |
| Does the application write to a log store? Event Log, log file, log database, App Insights.| Yes = 1 | No = 1 | - | - |
| Is the application part of the organization's Disaster Recovery plans? The organization's DR plan includes this application.| - | Yes = 1 | - | - |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total= |total= |total= |total= |

## Security
| Question | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| Does the application use Active Directory authentication? How are users authenticated into the application?| Yes = 1 | Yes = 1 | - | - |
| Has the organization already configured Azure AD and AD Connect? Azure AD is configured and is synchronized with local AD with AD Connect.| No = 1 | - | - | - |
| Does the application require access to internal resources? This would require VPN connectivity from Azure.| Yes = 1 | - | - | - |
|Has the organization already configured a VPN connection between Azure and their on-prem environment? VPN is configured.| No = 1 | No = 1 | - | - |
| Does the application use SSL certificate? SSL is required to run the application.| Yes = 1 | Yes = 1 | - | - |
| **TOTAL (sum all the answers values you have chosen and write down the result here).**|total= |total= |total= |total= |

## Results
|  | Complexity | Risk | Rearchitect | Rebuild |
|------------------------------------------------------------------|---|---|---|---|
| **TOTAL (sum all aspects values and write down the result here).**| | | | |
| Scoring Weight| 25 | 19 | | |
| The expected level of complexity to migrate this application to Azure is: **TOTAL / Scoring Weight (<0.3 = LOW, <0.7 = MEDIUM, >0.7 = HIGH)** <br/> The expected risk involved as part of the migration is: **TOTAL / Scoring Weight (<0.3 = LOW, <0.7 = MEDIUM, >0.7 = HIGH)** <br/> For the Rearchitect and Rebuild, the largest scoring result defines your strategy.| | | | |

## Next steps

To move forward with the exercise 'validate and commit the serverless adoption', see the following resources:

- [Promote a technical workshop](./technical-training.md)
- [Conduct architectural design session(s)](./ads.md)
- [Identify and execute a PoC or Pilot project](./poc-pilot.md)
- [Plan technical trainings for the project team](./technical-training.md)
- [Deliver a technical implementation with the team or customer](./code-with.md)
