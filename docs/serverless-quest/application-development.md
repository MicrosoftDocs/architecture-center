---
title: Serverless Functions app development and deployment
titleSuffix: Azure Example Scenarios
description: Examine patterns and practices of serverless application development, configure DevOps pipelines, and implement site reliability engineering (SRE) best practices.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: management-and-governance
categories: management-and-governance
products:
  - azure-functions
ms.custom:
  - fcp
  - guide
---

# Application development and deployment

To develop and deploy serverless applications with Azure Functions, examine patterns and practices, configure DevOps pipelines, and implement site reliability engineering (SRE) best practices.

For detailed information about serverless architectures and Azure Functions, see:
- [Serverless apps: Architecture, patterns, and Azure implementation](/dotnet/architecture/serverless/)
- [Azure Serverless Computing Cookbook](https://azure.microsoft.com/resources/azure-serverless-computing-cookbook)
- [Example serverless reference architectures](reference-architectures.md)

## Planning
To plan app development and deployment:

1. Prepare development environment and set up workflow.
2. Structure projects to support Azure Functions app development.
3. Identify app triggers, bindings, and configuration requirements.

### Understand event-driven architecture
A different event triggers every function in a serverless Functions project. For more information about event-driven architectures, see:
- [Event-driven architecture style](../guide/architecture-styles/event-driven.yml).
- [Event-driven design patterns to enhance existing applications using Azure Functions](/events/build-2020/bod124)

### Prepare development environment
Set up your development workflow and environment with the tools to create Functions. For details about development tools and Functions code project structure, see:
- [Code and test Azure Functions locally](/azure/azure-functions/functions-develop-local)
- [Develop Azure Functions by using Visual Studio Code](/azure/azure-functions/functions-develop-vs-code)
- [Develop Azure Functions using Visual Studio](/azure/azure-functions/functions-develop-vs)
- [Work with Azure Functions Core Tools](/azure/azure-functions/functions-run-local)
- [Folder structure](/azure/azure-functions/functions-reference#folder-structure)

## Development

Decide on the development language to use. Azure Functions supports C#, F#, PowerShell, JavaScript, TypeScript, Java, and Python. All of a project's Functions must be in the same language. For more information, see [Supported languages in Azure Functions](/azure/azure-functions/supported-languages).

### Define triggers and bindings
A trigger invokes a Function, and every Function must have exactly one trigger. Binding to a Function declaratively connects another resource to the Function. For more information about Functions triggers and bindings, see:
- [Azure Functions triggers and bindings concepts](/azure/azure-functions/functions-triggers-bindings)
- [Execute an Azure Function with triggers](/training/modules/execute-azure-function-with-triggers/)
- [Chain Azure Functions together using input and output bindings](/training/modules/chain-azure-functions-data-using-bindings/)

### Create the Functions application
Functions follow the single responsibility principle: do only one thing. For more information about Functions development, see:
- [Azure Functions developers guide](/azure/azure-functions/functions-reference)
- [Create serverless applications](/training/paths/create-serverless-applications/)
- [Strategies for testing your code in Azure Functions](/azure/azure-functions/functions-test-a-function)
- [Functions best practices](/azure/azure-functions/functions-best-practices#general-best-practices)

### Use Durable Functions for stateful workflows
Durable Functions in Azure Functions let you define stateful workflows in a serverless environment by writing *orchestrator functions*, and stateful entities by writing *entity functions*. Durable Functions manage state, checkpoints, and restarts, allowing you to focus on business logic. For more information, see [What are Durable Functions](/azure/azure-functions/durable/durable-functions-overview).

### Understand and address cold starts

If the number of serverless host instances scales down to zero, the next request has the added latency of restarting the Function app, called a *cold start*. To minimize the performance impact of cold starts, reduce dependencies that the Functions app needs to load on startup, and use as few large, synchronous calls and operations as possible. For more information about autoscaling and cold starts, see [Serverless Functions operations](functions-app-operations.md).

### Manage application secrets
For security, don't store credentials in application code. To use Azure Key Vault with Azure Functions to store and retrieve keys and credentials, see [Use Key Vault references for App Service and Azure Functions](/azure/app-service/app-service-key-vault-references).

For more information about serverless Functions application security, see [Serverless Functions security](functions-app-security.md).

## Deployment

To prepare serverless Functions application for production, make sure you can:

- Fulfill application resource requirements.
- Monitor all aspects of the application.
- Diagnose and troubleshoot application issues.
- Deploy new application versions without affecting production systems.

### Define deployment technology
Decide on deployment technology, and organize scheduled releases. For more information about how Functions app deployment enables reliable, zero-downtime upgrades, see [Deployment technologies in Azure Functions](/azure/azure-functions/functions-deployment-technologies).

### Avoid using too many resource connections
Functions in a Functions app share resources, including connections to HTTPS, databases, and services such as Azure Storage. When many Functions are running concurrently, it's possible to run out of available connections. For more information, see [Manage connections in Azure Functions](/azure/azure-functions/manage-connections).

### Configure logging, alerting, and application monitoring
Application Insights in Azure Monitor collects log, performance, and error data. Application Insights automatically detects performance anomalies, and includes powerful analytics tools to help diagnose issues and understand function usage.

For more information about application monitoring and logging, see:
- [Monitor Azure Functions](/azure/azure-functions/functions-monitoring)
- [Monitoring Azure Functions with Azure Monitor Logs](/azure/azure-functions/functions-monitor-log-analytics)
- [Application Insights for Azure Functions supported features](/azure/azure-monitor/app/azure-functions-supported-features)

### Diagnose and troubleshoot issues
Learn how to effectively use diagnostics for troubleshooting in proactive and problem-first scenarios. For more information, see:
- [Keep your Azure App Service and Azure Functions apps healthy and happy](https://azure.microsoft.com/resources/videos/build-2019-keeping-your-azure-app-service-and-azure-functions-apps-healthy-and-happy/)
- [Troubleshoot error: "Azure Functions Runtime is unreachable"](/azure/azure-functions/functions-recover-storage-account)

### Deploy applications using an automated pipeline and DevOps
Full automation of all steps from code commit to production deployment lets teams focus on building code, and removes the overhead and potential human error of manual steps. Deploying new code is quicker and less risky, helping teams become more agile, more productive, and more confident about their code.

For more information about DevOps and continuous deployment (CD), see:
- [Continuous deployment for Azure Functions](/azure/azure-functions/functions-continuous-deployment)
- [Continuous delivery by using Azure DevOps](/azure/azure-functions/functions-how-to-azure-devops)
- [Continuous delivery by using GitHub Action](/azure/azure-functions/functions-how-to-github-actions)

## Optimization

Once the application is in production, prepare for scaling and implement site reliability engineering (SRE).

### Ensure optimal scalability
For information about factors that impact Functions app scalability, see:
- [Scalability best practices](/azure/azure-functions/functions-best-practices#scalability-best-practices)
- [Performance and scale in Durable Functions](/azure/azure-functions/durable/durable-functions-perf-and-scale)

### Implement SRE practices
Site Reliability Engineering (SRE) is a proven approach to maintaining crucial system and application reliability, while iterating at the speed the marketplace demands. For more information, see:
- [Introduction to Site Reliability Engineering (SRE)](/training/modules/intro-to-site-reliability-engineering)
- [DevOps at Microsoft: Game streaming SRE](https://azure.microsoft.com/resources/devops-at-microsoft-game-streaming-sre)

## Next steps

For hands-on serverless Functions app development and deployment walkthroughs, see:
- [Serverless Functions code walkthrough](../web-apps/serverless/architectures/code.yml)
- [CI/CD for a serverless frontend](../serverless/guide/serverless-app-cicd-best-practices.yml)

For an engineering playbook to help teams and customers successfully implement serverless Functions projects, see the [Code-With Customer/Partner Engineering Playbook](https://github.com/microsoft/code-with-engineering-playbook).
