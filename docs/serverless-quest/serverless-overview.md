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
# Serverless Functions overview

*Serverless* architecture evolves cloud platforms toward pure cloud-native code by abstracting code from the infrastructure that it needs to run. [Azure Functions](https://docs.microsoft.com/azure/azure-functions) is a serverless compute option that supports *functions*, small pieces of code that do single things.

Serverless architecture with Azure Functions is *event-driven*. An external event like an HTTP web request, message, schedule, or change in data *triggers* the function code. The Functions app doesn't code the trigger, only the response to the trigger. With a lower barrier to entry, developers can focus on business logic, rather than writing code to handle infrastructure concerns like messaging.

Azure Functions is a managed service in Azure and Azure Stack. The open source Functions runtime works in many environments, including Kubernetes, Azure IoT Edge, on-premises, and other clouds.

Benefits of using serverless architectures with Functions include:

- The cloud infrastructure provides the updated servers that applications need to keep running at scale. Serverless doesn't mean "no server," but "less server" to manage.
- Compute resources allocate dynamically as needed, and instantly autoscale to meet elastic demands.
- Micro-billing saves costs by charging only for the compute resources and duration the code uses to execute.
- Function *bindings* streamline integration by providing declarative access to a wide variety of Azure and third-party services.

Serverless and Functions require new ways of thinking and new approaches to building applications. They aren't the right solutions for every problem. For help with choosing a compute technology, see [Choose an Azure compute service for your application](../guide/technology-choices/compute-decision-tree.md).

For example serverless Functions scenarios, see [Reference architectures](reference-architectures.md).

## Next steps

Actions to drive successful deployment of serverless Functions, from planning to production, optimization, and security, include:

- [Validate, commit, and plan](validate-commit-serverless-adoption.md)
  
  *Architects* and *technical decision makers (TDM)* perform [application assessment](application-assessment.md), conduct or attend [technical workshops and trainings](technical-training.md), run [proof of concept (PoC) or pilot](poc-pilot.md) projects, and conduct [architectural designs sessions](ads.md) as necessary.
  
- [Develop and deploy apps](application-development.md)
  
  *Developers* examine serverless app development patterns and practices, configure DevOps pipelines, and implement site reliability engineering (SRE) best practices.
  
- [Manage operations](functions-app-operations.md)
  
  *IT professionals* identify hosting configurations, future-proof scalability by automating infrastructure provisioning, and maintain high availability by planning for business continuity and disaster recovery.
  
- [Secure apps](functions-app-security.md)
  
  *Security professionals* handle Azure Functions security essentials, secure the hosting setup, and provide application security guidance.

## Related resources
- To learn more about serverless technology, see the [Azure serverless documentation](https://azure.microsoft.com/solutions/serverless/).
- To learn more about Azure Functions, see the [Azure Functions documentation](https://docs.microsoft.com/azure/azure-functions/).

