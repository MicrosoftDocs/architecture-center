---
title: Health modeling for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - Health modeling.
author: nielsams
categories: monitoring
ms.author: allensu
ms.date: 08/15/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - monitoring
azureCategories:
  - monitoring  
summary: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources.
products:
  - azure-monitor
---

# Health modeling for mission-critical workloads

Monitoring applications and infrastructure is an important part of any infrastructure deployment. For a mission-critical workload, monitoring is a critical part of the deployment. Monitoring application health and key metrics of Azure resources helps you understand if the environment is working as expected. 

To fully understand these metrics and evaluate the overall health of a workload requires a holistic understanding of all of the data monitored. A health model can assist with evaluation of the overall health status by displaying a clear indication of the health of the workload instead of raw metrics. The status is often presented as "traffic light" indicators such as red, green, or yellow. Representation of a health model with clear indicators makes it intuitive for an operator to understand the overall health of the workload and respond quickly to issues that arise.

Health modeling can be expanded into the following operational tasks for the mission-critical deployment:

- **Application Health Service** - Application component on the compute cluster that provides an API called by Front Door to determine the health of a stamp.

- **Monitoring** - Collection of performance and application counters that evaluate the health and performance of the application and infrastructure.

- **Alerting** - Actionable alerts of issues or outages in the infrastructure and application.

- **Failure analysis** - Breakdown and analysis of any failures including documentation of root cause.

Taken together, these tasks make up a comprehensive health model for the mission-critical infrastructure. Development of a health model can and should be an exhaustive and integral part of any mission-critical deployment.

## Application Health Service




## Next steps

Deploy the reference implementation to get a full understanding of the resources and their configuration used in this architecture.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)
