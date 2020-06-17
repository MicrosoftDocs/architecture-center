---
title: Technical workshops and training
titleSuffix: Azure Example Scenarios
description: Use these resources to help understand and adopt serverless technologies with Azure Functions.
author: rogeriohc
ms.date: 06/17/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Technical workshops and training

The workshops, trainings, and resources in this article provide technical training for serverless adoption with Azure Functions. These resources help you and your team or customers understand and implement application modernization and cloud-native apps.

# Technical workshops

The [Microsoft Cloud Workshop (MCW)](https://microsoftcloudworkshop.com/) program provides workshops that you can host to foster cloud learning and adoption. Each workshop includes presentation decks, trainer and student guides, and hands-on lab guides. Contribute your own content and feedback to add to a robust database of training guides for deploying advanced Azure workloads on the Microsoft Cloud Platform.

Workshops related to application development workloads include:
- [Serverless architecture](https://github.com/Microsoft/MCW-Serverless-Architecture). Implement a series of Azure Functions that independently scale and break down business logic to discrete components, allowing customers to pay only for the services they use.
- [App modernization](https://github.com/Microsoft/MCW-App-Modernization). Design a modernization plan to move services from on-premises to the cloud by leveraging cloud, web, and mobile services, secured by Azure Active Directory.
- [Modern cloud apps](https://github.com/Microsoft/MCW-Modern-Cloud-Apps). Deploy, configure, and implement an end-to-end secure and Payment Card Industry (PCI) compliant solution for e-commerce, based on Azure App Services, Azure Active Directory, and Azure DevOps.
- [Cloud-native applications](https://github.com/microsoft/MCW-Cloud-native-applications). Using DevOps best practices, build a proof of concept (PoC) to transform a platform-as-a-service (PaaS) application to a container-based application with multi-tenant web app hosting.
- [Continuous delivery in Azure DevOps](https://github.com/Microsoft/MCW-Continuous-Delivery-in-Azure-DevOps). Set up and configure continuous delivery (CD) in Azure to reduce manual errors, using Azure Resource Manager templates, Azure DevOps, and Git repositories for source control.

## Instructor-led training
[Course AZ-204: Developing solutions for Microsoft Azure](https://docs.microsoft.com/learn/certifications/courses/az-204t00) teaches developers how to create end-to-end solutions in Microsoft Azure. Students learn how to implement Azure compute solutions, create Azure Functions, implement and manage web apps, develop solutions utilizing Azure storage, implement authentication and authorization, and secure their solutions by using Azure Key Vault and managed identities. Students also learn to connect to and consume Azure and third-party services, and include event- and message-based models in their solutions. The course also covers monitoring, troubleshooting, and optimizing Azure solutions.

## Serverless OpenHack
The OpenHack simulates a real-world scenario where a company wants to utilize serverless services to build and release an API to integrate into their distributor's application. This OpenHack lets attendees quickly build and deploy Azure serverless solutions with cutting-edge compute services like Azure Functions, Logic Apps, Event Grid, Service Bus, Event Hubs, and Cosmos DB. The OpenHack also covers related technologies like API Management, Azure DevOps or GitHub, Application Insights, Dynamics 365/Office 365, and Cognitive APIs.

During the OpenHack, attendees focus on building serverless functions, web APIs, and a CI/CD pipeline to support them. They then implement further serverless technologies to integrate line of business (LOB) app workflows, process user and data telemetry, and create key progress indicator (KPI)-aligned reports. By the end of the OpenHack, attendees have built out a full serverless technical solution that can create workflows between systems and handle events, files, and data ingestion.

Microsoft customer projects inspired these OpenHack challenges:
- Configure the developer environment.
- Create your first serverless function and workflow.
- Build APIs to support business needs.
- Deploy a management layer for APIs and monitoring usage.
- Build a LOB workflow process.
- Process large amounts of unstructured file data.
- Process large amounts of incoming event data.
- Implement a publisher/subscriber messaging pattern and virtual network integration.
- Conduct sentiment analysis.
- Perform data aggregation, analysis, and reporting.

To attend an OpenHack, register at [https://openhack.microsoft.com](https://openhack.microsoft.com). For enterprises with many engineers that need training, Microsoft can request and organize a dedicated Serverless OpenHack.

## Microsoft Learn
[Microsoft Learn](https://docs.microsoft.com/learn/) is a free, online training platform that provides interactive learning for Microsoft products. The goal is to improve proficiency with fun, guided, hands-on content that's specific to your role and goals. Learning paths are collections of modules that are organized around specific roles like developer, architect, or system admin, or technologies like Azure Web Apps, Azure Functions, or Azure SQL DB. The learning path provides understanding of different aspects of the technology or role.

Learning paths about serverless apps with Azure Functions include:

- [Create serverless applications](https://docs.microsoft.com/learn/paths/create-serverless-applications/). Learn how to leverage functions to execute server-side logic and build serverless architectures.
- [Architect message brokering and serverless applications in Azure](https://docs.microsoft.com/learn/paths/architect-messaging-serverless/). Learn how to create reliable messaging for your applications, and how to take advantage of serverless application services in Azure.
- [Search all Functions-related learning paths](https://docs.microsoft.com/learn/browse/?products=azure-functions).

## Hands-on labs and how-to guides
- [Build a serverless web app](https://docs.microsoft.com/labs/build2018/serverlesswebapp/) from the Build 2018 conference
- [Build a Serverless IoT Solution with Python Azure Functions and SignalR](https://dev.to/azure/building-a-serverless-iot-solution-with-python-azure-functions-and-signalr-4ljp).

## Next steps

To move forward with the exercise 'validate and commit the serverless adoption', see the following resources:

- [Execute an application assessment](./application-assessment.md)
- [Promote a technical workshop](./technical-workshops.md)
- [Conduct architectural design session(s)](./ads.md)
- [Identify and execute a PoC or Pilot project](./poc-pilot.md)
- [Deliver a technical implementation with the team or customer](./code-with.md)
