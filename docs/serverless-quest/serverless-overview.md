---
title: Serverless Functions architecture
titleSuffix: Azure Architecture Center
description: Learn about serverless architecture with Azure Functions, and how to implement serverless Functions adoption.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - compute
products:
  - azure-functions
ms.custom:
  - fcp
  - guide
---
# Serverless Functions overview

*Serverless* architecture evolves cloud platforms toward pure cloud-native code by abstracting code from the infrastructure that it needs to run. [Azure Functions](/azure/azure-functions) is a serverless compute option that supports *functions*, small pieces of code that do single things.

Benefits of using serverless architectures with Functions applications include:

- The Azure infrastructure automatically provides all the updated servers that applications need to keep running at scale.
- Compute resources allocate dynamically, and instantly autoscale to meet elastic demands. Serverless doesn't mean "no server," but "less server," because servers run only as needed.
- Micro-billing saves costs by charging only for the compute resources and duration the code uses to execute.
- Function *bindings* streamline integration by providing declarative access to a wide variety of Azure and third-party services.

Functions are *event-driven*. An external event like an HTTP web request, message, schedule, or change in data *triggers* the function code. A Functions application doesn't code the trigger, only the response to the trigger. With a lower barrier to entry, developers can focus on business logic, rather than writing code to handle infrastructure concerns like messaging.

Azure Functions is a managed service in Azure and Azure Stack. The open source Functions runtime works in many environments, including Kubernetes, Azure IoT Edge, on-premises, and other clouds.

Serverless and Functions require new ways of thinking and new approaches to building applications. They aren't the right solutions for every problem. For example serverless Functions scenarios, see [Reference architectures](reference-architectures.md).

## Implementation steps

Successful implementation of serverless technologies with Azure Functions requires the following actions:

- [Decide and plan](validate-commit-serverless-adoption.md)

  *Architects* and *technical decision makers (TDMs)* perform [application assessment](application-assessment.md), conduct or attend [technical workshops and trainings](technical-training.md), run [proof of concept (PoC) or pilot](poc-pilot.md) projects, and conduct architectural designs sessions as necessary.

- [Develop and deploy apps](application-development.md)

  *Developers* implement serverless Functions app development patterns and practices, configure DevOps pipelines, and employ site reliability engineering (SRE) best practices.

- [Manage operations](functions-app-operations.md)

  *IT professionals* identify hosting configurations, future-proof scalability by automating infrastructure provisioning, and maintain availability by planning for business continuity and disaster recovery.

- [Secure apps](functions-app-security.md)

  *Security professionals* handle Azure Functions security essentials, secure the hosting setup, and provide application security guidance.

## Related resources
- To learn more about serverless technology, see the [Azure serverless documentation](https://azure.microsoft.com/solutions/serverless/).
- To learn more about Azure Functions, see the [Azure Functions documentation](/azure/azure-functions/).
- For help with choosing a compute technology, see [Choose an Azure compute service for your application](../guide/technology-choices/compute-decision-tree-content.yml).
