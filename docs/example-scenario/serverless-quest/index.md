---
title: Serverless Functions adoption guide
titleSuffix: Azure Example Scenarios
description: Description
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Serverless Functions adoption guide

Serverless architecture is the evolution of cloud platforms toward pure cloud-native code. Serverless computing abstracts code from the infrastructure that the code needs to run. Azure Functions is a serverless compute option that supports *functions,* small pieces of code that do single things.

A serverless architecture with Azure Functions is event-driven. A certain external event triggers the function code. Trigger events include HTTP web requests, messages, schedules and timers, or changes in data. A function app doesn't code the trigger, only the response to the trigger. With a lower barrier to entry, developers can focus on business logic, rather than writing code to handle infrastructure concerns like messaging.

Operational benefits to using a serverless architecture with Functions include:

- The cloud infrastructure provides the updated servers that applications need to keep running at scale. Serverless doesn't mean "no server," but "less server" to manage.
- Compute resources allocate dynamically as needed, and instantly autoscale to meet elastic demands.
- Micro-billing saves costs by charging only for the compute resources and duration the code uses to execute.
- Function *bindings* provide declarative access to a wide variety of Azure and third-party services, streamlining integration.
- Azure Functions is a managed service in Azure and Azure Stack. The open source Functions runtime works in many environments, including Kubernetes, Azure IoT Edge, on-premises, and other clouds.

Serverless and Functions require new ways of thinking and new approaches to building applications. They aren't the right solutions for every problem. For example serverless Functions scenarios, see [Reference architectures](reference-architectures.md).

## Next steps
This Serverless Functions adoption guide is a prescriptive framework to help organizations adopt serverless technology and Azure Functions at scale. The guide includes tools, programs, guidance, and related resources to simplify adoption. Actions to drive successful adoption, from planning to production, optimization, and security, include:

- [Validate, commit, and plan adoption](./validate-commit-serverless-adoption.md)
  *Architects* perform application assessment, conduct or attend technical workshops and trainings, identify proof of concept (PoC) or pilot projects, and conduct architectural designs sessions if necessary. 
- [Develop and deploy apps](./application-development.md)
  *Developers* examine serverless app development patterns and practices, configure DevOps pipelines, and implement site reliability engineering (SRE) best practices.
- [Manage operations](./functions-app-operations.md)
  *IT professionals* identify hosting configurations, future-proof scalability by automating infrastructure provisioning, and maintain high availability by planning for business continuity and disaster recovery.
- [Handle app security](./functions-app-security.md)
  *Security professionals* handle Azure Functions security essentials, secure setup for hosting, and provide application security guidance.

## Related resources
- To learn more about serverless technology, see the [Azure serverless documentation](https://azure.microsoft.com/solutions/serverless/).
- To learn more about Azure Functions, see the [Azure Functions documentation](https://docs.microsoft.com/azure/azure-functions/).
- For help with choosing a compute technology, see [Choose an Azure compute service for your application](../guide/technology-choices/compute-decision-tree.md).


