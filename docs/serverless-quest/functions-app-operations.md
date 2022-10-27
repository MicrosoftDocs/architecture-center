---
title: Serverless Functions app operations
titleSuffix: Azure Example Scenarios
description: Configure hosting, automate infrastructure provisioning, and maintain high availability for serverless Functions apps.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: developer-tools
products:
  - azure-functions
ms.custom:
  - fcp
  - guide
---
# Serverless Functions app operations

This article describes Azure operations considerations for serverless Functions applications. To support Functions apps, operations personnel need to:

- Understand and implement hosting configurations.
- Future-proof scalability by automating infrastructure provisioning.
- Maintain business continuity by meeting availability and disaster recovery requirements.

## Planning

To plan operations, understand your workloads and their requirements, then design and configure the best options for the requirements.

### Choose a hosting option
The Azure Functions Runtime provides flexibility in hosting. Use the [hosting plan comparison table](/azure/azure-functions/functions-scale#hosting-plans-comparison) to determine the best choice for your requirements.

- Azure Functions hosting plans

  Each Azure Functions project deploys and runs in its own Functions app, which is the unit of scale and cost. The three hosting plans available for Azure Functions are the Consumption plan, Premium plan, and Dedicated (App Service) plan. The hosting plan determines scaling behavior, available resources, and support for advanced features like virtual network connectivity.

- Azure Kubernetes Service (AKS)

  Kubernetes-based Functions provides the Functions Runtime in a Docker container with event-driven scaling through Kubernetes-based Event Driven Autoscaling (KEDA).

For more information about hosting plans, see:
- [Azure Functions scale and hosting](/azure/azure-functions/functions-scale)
- [Consumption plan](/azure/azure-functions/functions-scale#consumption-plan)
- [Premium plan](/azure/azure-functions/functions-premium-plan)
- [Dedicated (App Service) plan](/azure/azure-functions/functions-scale#app-service-plan)
- [Azure Functions on Kubernetes with KEDA](/azure/azure-functions/functions-kubernetes-keda)
- [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits)

### Understand scaling

The serverless Consumption and Premium hosting plans *scale* automatically, adding and removing Azure Functions host instances based on the number of incoming events. Scaling can vary on several dimensions, and behave differently based on plan, trigger, and code language.

For more information about scaling, see:
- [Understand scaling behaviors](/azure/azure-functions/functions-scale#understanding-scaling-behaviors)
- [Scalability best practices](/azure/azure-functions/functions-best-practices#scalability-best-practices)

### Understand and address cold starts

If the number of host instances scales down to zero, the next request has the added latency of restarting the Function app, called a *cold start*. [Cold start](/azure/azure-functions/functions-scale#cold-start) is a large discussion point for serverless architectures, and a point of ambiguity for Azure Functions.

The Premium hosting plan prevents cold starts by keeping some instances warm. Reducing dependencies and using asynchronous operations in the Functions app also minimizes the impact of cold starts. However, availability requirements may require running the app in a Dedicated hosting plan with *Always on* enabled. The Dedicated plan uses dedicated virtual machines (VMs), so is not serverless.

For more information about cold start, see [Understanding serverless cold start](https://azure.microsoft.com/blog/understanding-serverless-cold-start/).

### Identify storage considerations

Every Azure Functions app relies on Azure Storage for operations such as managing triggers and logging function executions. When creating a Functions app, you must create or link to a general-purpose Azure Storage account that supports Blob, Queue, and Table storage. For more information, see [Storage considerations for Azure Functions](/azure/azure-functions/storage-considerations).

### Identify network design considerations

Networking options let the Functions app restrict access, or access resources without using internet-routable addresses. The hosting plans offer different levels of network isolation. Choose the option that best meets your network isolation requirements. For more information, see [Azure Functions networking options](/azure/azure-functions/functions-networking-options).

## Production

To prepare the application for production, make sure you can easily redeploy the hosting plan, and apply scale-out rules.

### Automate hosting plan provisioning
With infrastructure as code, you can automate infrastructure provisioning. Automatic provisioning provides more resiliency during disasters, and more agility to quickly redeploy the infrastructure as needed.

For more information on automated provisioning, see:
- [Automate resource deployment for your function app in Azure Functions](/azure/azure-functions/functions-infrastructure-as-code)
- [Terraform - Manages a Function App](https://www.terraform.io/docs/providers/azurerm/r/function_app.html)

### Configure scale out options
Autoscale provides the right amount of running resources to handle application load. Autoscale adds resources to handle increases in load, and saves money by removing resources that are idle.

For more information about autoscale options, see:
- [Premium Plan settings](/azure/azure-functions/functions-premium-plan#plan-and-sku-settings)
- [App Service Plan settings](/azure/azure-monitor/platform/autoscale-get-started)

## Optimization

When the application is in production, make sure that:

- The hosting plan can scale to meet application demands.
- There's a plan for business continuity, availability, and disaster recovery.
- You can monitor hosting and application health and receive alerts.

### Implement availability requirements

Azure Functions run in a specific region. To get higher availability, you can deploy the same Functions app to multiple regions. In multiple regions, Functions can run in the *active-active* or *active-passive* availability pattern.

For more information about Azure Functions availability and disaster recovery, see:
- [Azure Functions geo-disaster recovery](/azure/azure-functions/functions-geo-disaster-recovery)
- [Disaster recovery and geo-distribution in Azure Durable Functions](/azure/azure-functions/durable/durable-functions-disaster-recovery-geo-distribution)

### Monitoring logging, application monitoring, and alerting
Application Insights and logs in Azure Monitor automatically collect log, performance, and error data and detect performance anomalies. Azure Monitor includes powerful analytics tools to help diagnose issues and understand function use. Application Insights help you continuously improve performance and usability.

For more information about monitoring and analyzing Azure Functions performance, see:
- [Monitor Azure Functions](/azure/azure-functions/functions-monitoring)
- [Monitor Azure Functions with Azure Monitor logs](/azure/azure-functions/functions-monitor-log-analytics)
- [Application Insights for Azure Functions supported features](/azure/azure-monitor/app/azure-functions-supported-features)

## Next steps

- [Serverless application development and deployment](application-development.md)
- [Azure Functions app security](functions-app-security.md)
