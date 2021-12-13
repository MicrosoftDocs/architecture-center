---
title: Overview of a hybrid workload
description: Includes guidance and recommendations that apply to each of the five pillars in a hybrid and multi-cloud workload.
author: v-aangie
ms.author: pnp
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Overview of a hybrid workload

Customer workloads are becoming increasingly complex, with many applications often running on different hardware across on-premises, multicloud, and the edge. Managing these disparate workload architectures, ensuring uncompromised security, and enabling developer agility are critical to success.

Azure uniquely helps you meet these challenges, giving you the flexibility to innovate anywhere in your hybrid environment while operating seamlessly and securely. The Well-Architected Framework includes a hybrid description for each of the five pillars: cost optimization, operational excellence, performance efficiency, reliability, and security. These descriptions create clarity on the considerations needed for your workloads to operate effectively across hybrid environments.

Adopting a hybrid model offers multiple solutions that enable you to confidently deliver hybrid workloads: run Azure data services anywhere, modernize applications anywhere, and manage your workloads anywhere.

## Extend Azure management to any infrastructure

> [!TIP]
> Applying the principles in this article series to each of your workloads will better prepare you for hybrid adoption. For larger or centrally managed organizations, hybrid and multicloud are commonly part of a broader strategic objective. If you need to scale these principle across a portfolio of workloads using hybrid and multicloud environments, you may want to start with the Cloud Adoption Framework's [hybrid and multicloud scenario and best practices](/azure/cloud-adoption-framework/scenarios/hybrid/unified-operations). Then return to this series to refine each of your workload architectures.

Use *Azure Arc enabled infrastructure* to extend Azure management to any infrastructure in a hybrid environment. Key features of Azure Arc enabled infrastructure are:

- **Unified Operations**
   - Organize resources such as virtual machines, Kubernetes clusters and Azure services deployed across your entire IT environment.
   - Manage and govern resources with a single pane of glass from Azure.
   - Integrate with Azure Lighthouse for managed service provider support.

- **Adopt cloud practices**
   - Easily adopt DevOps techniques such as infrastructure as code.
   - Empower developers with self-service and choice of tools.
   - Standardize change control with configuration management systems, such as GitOps and DSC.

## Run Azure services anywhere

Azure Arc allows you to run Azure Services anywhere. This allows you to build consistent hybrid and multicloud application archtiectures by using Azure services that can run in Azure, on-premises, at the edge, or at other cloud providers.

### Run Azure data services anywhere

Use *Azure Arc enabled data services* to run Azure data services anywhere to support your hybrid workloads. Key features of Azure Arc enabled data services are:

- Run Azure data services on any Kubernetes cluster deployed on any hardware.
- Gain cloud automation benefits, always up-to-date innovation in Azure data services, unified management of your on-premises and cloud data assets with a cloud billing model across both environments.
- Azure SQL Database and Azure PostgreSQL Hyperscale are the first set of Azure data services that are Azure Arc enabled.

### Run Azure Application services anywhere

Use *Azure Arc enabled Application services* to run Azure App Service, Functions, Logic Apps, Event Grid, and API Management anywhere to support your hybrid workloads. Key features of Azure Arc enabled application services are as follows:

- [Web Apps](/azure/app-service/overview-arc-integration?toc=/azure/cloud-adoption-framework/toc.json&bc=/azure/cloud-adoption-framework/_bread/toc.json) - Azure App Service makes building and managing web applications and APIs easy, with a fully managed platform and features like autoscaling, deployment slots, and integrated web authentication.
- [Functions](/azure/app-service/overview-arc-integration?toc=/azure/cloud-adoption-framework/toc.json&bc=/azure/cloud-adoption-framework/_bread/toc.json) - Azure Functions makes event-driven programming simple, with state-of-the-art autoscaling, and with triggers and bindings to integrate with other Azure services.
- [Logic Apps](/azure/app-service/overview-arc-integration?toc=/azure/cloud-adoption-framework/toc.json&bc=/azure/cloud-adoption-framework/_bread/toc.json) - Azure Logic Apps produces automated workflows for integrating apps, data, services, and backend systems, with a library of more than 400 connectors.
- [Event Grid](/azure/event-grid/kubernetes/?toc=/azure/cloud-adoption-framework/toc.json&bc=/azure/cloud-adoption-framework/_bread/toc.json) - Azure Event Grid simplifies event-based applications, with a single service for managing the routing of events from any source to any destination.
- [Azure API Management gateway](/azure/api-management/how-to-deploy-self-hosted-gateway-azure-arc?toc=/azure/cloud-adoption-framework/toc.json&bc=/azure/cloud-adoption-framework/_bread/toc.json) - Azure API Management provides a unified management experience and full observability across all internal and external APIs.

## Modernize applications anywhere

Use the *Azure Stack family* to modernize applications without ever leaving the datacenter. Key features of the Azure Stack family are:

- Extend Azure to your on-premises workloads with Azure Stack Hub. Build and run cloud apps on premises, in connected or disconnected scenarios, to meet regulatory or technical requirements.
- Use Azure Stack HCI to run virtualized workloads on premises and easily connect to Azure to access cloud management and security services.
- Build and run your intelligent edge solutions on Azure Stack Edge, an Azure managed appliance to run machine learning models and compute at the edge to get results quickly—and close to where data is being generated. Easily transfer the full data set to Azure for further analysis or archive.

## Manage workloads anywhere

Use *Azure Arc management* to extend Azure management to all assets in your workloads, regardless of where they are hosted. Key features of Azure Arc management are:

- **Adopt cloud practices**
   - Easily adopt DevOps techniques such as infrastructure as code.
   - Empower developers with self-service and choice of tools.
   - Standardize change control with configuration management systems, such as GitOps and DSC.

- **Scale across workloads with [Unified Operations](/azure/cloud-adoption-framework/scenarios/hybrid/unified-operations)**
   - Organize resources such as virtual machines, Kubernetes clusters and Azure services deployed across your entire IT environment.
   - Manage and govern resources with a single pane of glass from Azure.
   - Integrate with Azure Lighthouse for managed service provider support.

## Next steps

> [!div class="nextstepaction"]
> [Cost optimization](./hybrid-cost.md)
