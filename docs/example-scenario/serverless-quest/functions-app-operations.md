---
title: Azure functions app operations
titleSuffix: Azure Example Scenarios
description: Learn about using Azure Functions for application operations.
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Azure functions app operations

Identify for hosting configurations. Future-proof scalability by automating infrastructure provisioning. Maintain high availability by planning for business continuity and disaster recovery.

## Plan, train, and proof

As you get started, the checklist and resources below will help you plan the hosting design, and operations. You should be able answer these questions:
- Have you identified the best hosting option for your requirements? 
- Do you have workloads with varying requirements? 

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Choose a hosting option for your app.** The Azure Functions runtime provides flexibility in hosting where and how you want: <br/> - Azure Functions hosting plans. An Azure Functions project runs within a Function app. Each project deploys to its own Function app. The Function app is the unit of scale and cost. There are three hosting plans available for Azure Functions: Consumption plan, Premium plan, and Dedicated (App Service) plan. The hosting plan you choose dictates the behaviors like how your function app is scaled, the resources available to each function app instance, and support for advanced features such as Azure Virtual Network connectivity. <br/> - Azure Kubernetes Service. Kubernetes-based Functions provides the Functions runtime in a Docker container with event-driven scaling through KEDA. </br> Use the hosting plan comparison table to guide you in the best choice for your requirements.| [Azure Functions scale and hosting](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) <br/> [Consumption plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale#consumption-plan) <br/> [Premium plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-premium-plan) <br/> [Dedicated (App Service) plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale#app-service-plan) <br/> [Azure Functions on Kubernetes with KEDA](https://docs.microsoft.com/en-us/azure/azure-functions/functions-kubernetes-keda) <br/> [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) <br/> [Hosting plan comparison table](./functions-hosting-comparison-table.md)|
| **Familiarize yourself with scale behaviors.** Scaling can vary on several factors, and scale differently based on the trigger and language selected.| [Understanding scaling behaviors](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale)|
| **Understand what cold start is and how you can architect your solutions around it.** Cold start is a large discussion point for serverless architectures and is a point of ambiguity for many users of Azure Functions.| [Understanding serverless cold start](https://azure.microsoft.com/pt-br/blog/understanding-serverless-cold-start/)|
| **Identify storage considerations.** Every function app requires a storage account to operate. When creating a function app, you must create or link to a general-purpose Azure Storage account that supports Blob, Queue, and Table storage. This is because Functions relies on Azure Storage for operations such as managing triggers and logging function executions.| [Storage considerations for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/storage-considerations)|
| **Identify network design considerations.** Networking options give you some ability to access resources without using internet-routable addresses or to restrict internet access to a function app. The hosting models have different levels of network isolation available. Choosing the correct one helps you meet your network isolation requirements.| [Azure Functions networking options](https://docs.microsoft.com/en-us/azure/azure-functions/functions-networking-options)|
| **Decide on availability requirements.** Azure Functions run in a specific region. To get higher availability, you can deploy the same functions to multiple regions. When in multiple regions you can have your functions running in the active/active pattern or active/passive pattern.| [Azure Functions geo-disaster recovery](https://docs.microsoft.com/en-us/azure/azure-functions/functions-geo-disaster-recovery) <br/> [Disaster recovery and geo-distribution in Azure Durable Functions](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-disaster-recovery-geo-distribution)|

## Go to production and apply best practices

As you prepare the application for production, you should implement a minimum set of best practices. Use the checklist below at this stage. You should be able to answer these questions:

- Are you able to confidently redeploy the hosting plan ?
- Have you applied scale out rules?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Automate hosting plan provisioning.** With infrastructure as code, you can automate infrastructure provisioning to provide more resiliency during disasters and gain agility to quickly redeploy the infrastructure as needed.| [Automate resource deployment for your function app in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code) <br/> [Terraform - Manages a Function App](https://www.terraform.io/docs/providers/azurerm/r/function_app.html)|
| **Configure Scale Out options.** Autoscale allows you to have the right amount of resources running to handle the load on your application. It allows you to add resources to handle increases in load and also save money by removing resources that are sitting idle.| [Premium Plan settings](https://docs.microsoft.com/en-us/azure/azure-functions/functions-premium-plan#plan-and-sku-settings) <br/> [App Service Plan settings](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/autoscale-get-started)|

## Optimize and scale

Now that the application is in production, how can you optimize your workflow and prepare your application and team to scale? Use the optimization and scaling checklist to prepare. You should be able to answer these questions:

- Do you have a plan for business continuity and disaster recovery?
- Can your hosting plan scale to meet application demands?
- Are you able to monitor your hosting and application health and receive alerts?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Implement best practices to ensure optimal scalability of a function app.** There are a number of factors that impact how instances of your function app scale.| [Scalability best practices](https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices#scalability-best-practices)|
| **Implement availability requirements.** Azure Functions run in a specific region. To get higher availability, you can deploy the same functions to multiple regions. When in multiple regions you can have your functions running in the active/active pattern or active/passive pattern.| [Azure Functions geo-disaster recovery](https://docs.microsoft.com/en-us/azure/azure-functions/functions-geo-disaster-recovery)|
| **Monitoring logging, application monitoring, and alerting.** Application Insights automatically collects log, performance, error data, detects performance anomalies and includes powerful analytics tools to help you diagnose issues and to understand how your functions are used. It's designed to help you continuously improve performance and usability.| [Monitor Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring) <br/> [Monitoring Azure Functions with Azure Monitor Logs](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitor-log-analytics) <br/> [Application Insights for Azure Functions supported features](https://docs.microsoft.com/en-us/azure/azure-monitor/app/azure-functions-supported-features)|

