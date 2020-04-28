---
title: Application development and deployment
titleSuffix: Azure Example Scenarios
description: Learn about using Azure Functions for application development and architecture.
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Application development and deployment

Examine patterns and practices of serverless application development, configure DevOps pipelines, and implement site reliability engineering (SRE) best practices.

## Plan, train, and proof

As you validate and get commit to adopt serverless with Azure Functions, the checklist and resources below will help you plan your application development and deployment. You should be able to answer these questions:

- Have you prepared your development environment and setup workflow?
- How will you structure the project to support Azure Functions application development?
- Have you identified triggers, bindings, and configuration requirements of your application?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Review common serverless scenarios and technologies.** Learn more about common serverless scenarios and event-driver design patterns. Serverless is based on event-driven architecture. Every function in the project is triggered by a different event. | [Serverless apps: Architecture, patterns, and Azure implementation](https://aka.ms/serverless-ebook) <br/> [Azure Serverless Computing Cookbook, Second Edition](https://azure.microsoft.com/en-us/resources/azure-serverless-computing-cookbook) <br/> [Event-driven design patterns to enhance existing applications using Azure Functions](https://mybuild.techcommunity.microsoft.com/sessions/77062)| 
| **Define your language.** Is important understand the levels of support offered for languages that you can use with Azure Functions. Available languages: C#, F#, PowerShell, JavaScript, TypeScript, Java, Python. All functions in a project must be in the same language. | [Supported languages in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/supported-languages)|
| **Prepare your development environment.** Configure your environment with the tools you need to create functions and set up your development workflow. Find out more about the structure of the files and folders in the project. | [Code and test Azure Functions locally](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-local) <br/> [Develop Azure Functions by using Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code) <br/> [Develop Azure Functions using Visual Studio](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs) <br/> [Work with Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local) <br/> [Folder structure](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference#folder-structure)
| **Define your trigger, and input/output bindings.** A trigger defines how a function is invoked and a function must have exactly one trigger. Binding to a function is a way of declaratively connecting another resource to the function. | [Azure Functions triggers and bindings concepts](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings) <br/> [Execute an Azure Function with triggers](https://docs.microsoft.com/en-us/learn/modules/execute-azure-function-with-triggers/) <br/> [Chain Azure Functions together using input and output bindings](https://docs.microsoft.com/en-us/learn/modules/chain-azure-functions-data-using-bindings/) <br/> |
| **Create your function application.** Familiarize yourself with the end-to-end Functions development experience, including: Function code, folder structure, runtime versioning, bindings. Functions should follow the single responsibility principle: do only one thing. | [Azure Functions developers guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference) <br/> [Create serverless applications](https://docs.microsoft.com/en-us/learn/paths/create-serverless-applications/) <br/> [Strategies for testing your code in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-test-a-function) <br/> [General best practices](https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices#general-best-practices)|
| **If you need to create a stateful workflows, review Durable Functions documentation.** Durable Functions is an extension of Azure Functions that lets you write stateful functions in a serverless compute environment. The extension lets you define stateful workflows by writing orchestrator functions and stateful entities by writing entity functions using the Azure Functions programming model. Behind the scenes, the extension manages state, checkpoints, and restarts for you, allowing you to focus on your business logic.|[What are Durable Functions?](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview)|
| **Define deployment technology for your Azure Functions application.** Prepare your application file system layout for Functions app and organize for weekly or daily releases. Learn how the Functions app deployment process enables reliable, zero-downtime upgrades. | [Deployment technologies in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies)|
| **Manage application secrets.** Don't store credentials in your application code. A key vault should be used to store and retrieve keys and credentials. | [Use Key Vault references for App Service and Azure Functions](https://docs.microsoft.com/en-us/azure/app-service/app-service-key-vault-references)|

## Deploy to production and apply best practices

As you prepare the application for production, you should implement a minimum set of best practices. Use the checklist below at this stage. You should be able to answer these questions:

- Have you defined resource requirements for your application? 
- Can you monitor all aspects of your application?
- Can you diagnose and troubleshoot issues of your applications?
- Can you deploy new versions of the application without affecting production systems?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Avoid using more resource connections than you need.** Functions in a function app share resource. Among those shared resources are connections: HTTP connections, database connections, and connections to services such as Azure Storage. When many functions are running concurrently, it's possible to run out of available connections. |[Manage connections in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/manage-connections)|
| **Configure logging, application monitoring, and alerting.** Recommended to use Application Insights because it collects log, performance, and error data. It automatically detects performance anomalies and includes powerful analytics tools to help you diagnose issues and to understand how your functions are used. It's designed to help you continuously improve performance and usability.| [Monitor Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring) <br/> [Monitoring Azure Functions with Azure Monitor Logs](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitor-log-analytics) <br/> [Application Insights for Azure Functions supported features](https://docs.microsoft.com/en-us/azure/azure-monitor/app/azure-functions-supported-features)|
| **Familiarize yourself how diagnose and troubleshoot issues with your function app.** Learn how to effectively leverage diagnostics for troubleshooting in both proactive and problem-first scenarios. | [Keeping your Azure App Service and Azure Functions apps healthy and happy](https://mybuild.techcommunity.microsoft.com/sessions/77797) </br> [Troubleshoot error: "Azure Functions Runtime is unreachable"](https://docs.microsoft.com/en-us/azure/azure-functions/functions-recover-storage-account)|
| **Deploy applications using an automated pipeline and DevOps.** The full automation of all steps between code commit to production deployment allows teams to focus on building code and removes the overhead and potential human error in manual mundane steps. Deploying new code is quicker and less risky, helping teams become more agile, more productive, and more confident about their running code. | [Continuous deployment for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment) <br/> [Continuous delivery by using Azure DevOps](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-azure-devops) <br/> [Continuous delivery by using GitHub Action](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions)|

## Optimize and scale

Now that the application is in production, how can you optimize your workflow and prepare your application and team to scale? Use the optimization and scaling checklist to prepare. You should be able to answer these questions:

- Are cross-cutting application concerns abstracted from your application?
- Are you able to maintain system and application reliability, while still iterating on new features and versions?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Ensure optimal scalability of your function app.** There are several factors that impact how instances of your function app scale.| [Scalability best practices](https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices#scalability-best-practices) <br/> [Performance and scale in Durable Functions](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-perf-and-scale)|
| **Implement site reliability engineering (SRE) practices.** Site Reliability Engineering (SRE) is a proven approach to maintain crucial system and application reliability while iterating at the speed demanded by the marketplace. | [Introduction to Site Reliability Engineering (SRE)](https://docs.microsoft.com/learn/modules/intro-to-site-reliability-engineering) <br/> [DevOps at Microsoft: Game streaming SRE](https://azure.microsoft.com/resources/devops-at-microsoft-game-streaming-sre)|
