---
title: Serverless - Functions Adoption Guide
titleSuffix: Azure Example Scenarios
description: Description
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Serverless - Functions Adoption Guide

The key focus of Serverless technologies is to remove management of infrastructure while keeping the developer entry barrier low, auto scaling, and to enable easy application integrations with cloud services (building blocks). Serverless is the evolution of cloud platforms in the direction of pure cloud native code. Serverless brings developers closer to business logic while insulating them from infrastructure concerns. It's a pattern that doesn't imply "no server" but rather, "less server". Serverless code is event-driven. Code may be triggered by anything from a traditional HTTP web request to a timer or the result of uploading a file. The infrastructure behind serverless allows for instant scale to meet elastic demands and offers micro-billing to truly "pay for what you use". Serverless requires a new way of thinking and approach to building applications and isn't the right solution for every problem. To learn more about serverless, see [Azure serverless](https://azure.microsoft.com/en-us/solutions/serverless/) services documentation.

Azure Functions allows you to run small pieces of code (called "functions" written in the language of your choice) without worrying about application infrastructure. With Azure Functions, the cloud infrastructure provides all the up-to-date servers you need to keep your application running at scale. A function is "triggered" by a specific type of event. Supported triggers include responding to changes in data, responding to messages, running on a schedule, or as the result of an HTTP request. While you can always code directly against a myriad of services, integrating with other services is streamlined by using bindings. Bindings give you declarative access to a wide variety of Azure and third-party services. Available as a managed service in Azure and Azure Stack, the open source Functions runtime also works on multiple destinations, including Kubernetes, Azure IoT Edge, on-premises, and even in other clouds. To learn more, see [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/) documentation.

## About this adoption guide
This Functions adoption guide is a prescriptive framework that includes the tools, programs, and content (best practices, configuration templates, and architecture guidance) to simplify adoption of Azure Functions and serverless practices at scale.
The list of required actions is categorized by persona to drive a successful deployment of applications on Functions, from proof of concept to production, then scaling and optimization. As part of the cloud adoption lifecycle, use the following exercises:

- [Validate and commit the serverless adoption](./validate-commit-serverless-adoption.md)
- [Application development and deployment](./application-development.md)
- Azure functions app operations.
- Azure functions app security.

