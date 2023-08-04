---
title: IoT solution to Azure IoT migration best practices
description: Review recommendations and best practices to plan your IoT migration to Azure IoT, such as analyzing your current solution and creating a migration strategy.
author: armandoblanco
ms.author: armbla
ms.date: 11/09/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-iot
  - azure-iot-hub
  - azure-kubernetes-service
  - azure-synapse-analytics
categories:
  - iot
  - migration
---

# IoT solution to Azure IoT migration best practices

This article provides guidance for architects, developers, and IT staff who plan to migrate Internet of Things (IoT) solutions to Azure. This article reviews recommendations and best practices to plan migration to Azure IoT.

Azure helps IoT customers achieve their goals through edge-to-cloud services. For more information, see [Future-ready IoT implementations on Microsoft Azure](https://azure.microsoft.com/blog/futureready-iot-implementations-on-microsoft-azure).

## Use the Azure Well-Architected Framework for IoT

Complete the questions for IoT workloads in the [Azure Well-Architected Review assessment](/assessments) to assess your IoT solution.

Use the [Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview) to understand how to optimize your solution and implement best practices. That framework has the following pillars:

- [Reliability](/azure/architecture/framework/iot/iot-reliability)
- [Security](/azure/architecture/framework/iot/iot-security)
- [Cost optimization](/azure/architecture/framework/iot/iot-cost-optimization)
- [Operational excellence](/azure/architecture/framework/iot/iot-operational-excellence)
- [Performance efficiency](/azure/architecture/framework/iot/iot-performance)

## Evaluate your IoT solution before migration

One of the first steps in migration is to analyze your IoT solution.

- Start with the elements that require less complexity.

- Focus on elements that have the most significant effect on your solution.

- Emphasize components that allow you to avoid disruption and continue to evolve your IoT solution.

- Understand and audit your existing IoT solution

  It's essential to understand the business and technical requirements, performance, long-term growth, and important factors of your operation. This knowledge helps establish the minimum base of requirements for your platform.Use the [Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview) to understand the best practices when designing a solution.

- Obtain key information about your IoT solution

  Be clear about the requirements of your IoT solution. Requirements include device configuration, networks, security requirements, applications, and their dependencies. This information helps you analyze which components in the Azure cloud allow you to build your IoT platform in the most transparent way, addressing current requirements and future needs.

- Categorize your IoT solution in order of migration complexity

  Based on the information from your IoT solution, classify its elements:

  - Security and authentication
  - Devices
  - Device management
  - Messaging
  - Applications
  - Storage
  - Analytics

  This classification helps you prioritize the critical components of your solution to avoid disruptions to end users. It also helps identify which platform as a service (PaaS) services can help you meet requirements. For some elements, you might not need to develop a solution from scratch.

## Define your IoT migration strategy

After you identify the business requirements, analyze your solution's key components, and prioritize its features, you can select the best migration strategy for your organization.

There are some common strategies for cloud migration scenarios:

- Replatform your IoT solution

  If you want to take advantage of PaaS services, consider using services such as [Azure IoT Hub](https://azure.microsoft.com/products/iot-hub), [Azure IoT Hub device provisioning service](/azure/iot-dps), and [Azure Synapse Analytics](/azure/synapse-analytics). Using these services helps accelerate the development of your IoT platform in Azure. This approach takes advantage of the features that these services offer, so you don't have to develop from scratch.

- Refactor and rearchitect your IoT solution

  During your evaluation, you might discover that you need to combine scenarios. Some components of your IoT solution can be rehosted, such as applications or databases. Other components could be replatformed or rebuilt to take advantage of some PaaS components. In that case, *refactor and rearchitect* is the best option. You can reduce the migration time and effort and make adjustments to your backend and business rules in later stages.

  If you want a modern cloud-native solution, consider rebuilding your IoT solution. Azure offers managed services, such as [Azure Kubernetes Service](/azure/aks), [Azure Container](/azure/containers) services, and [Azure API Management](/azure/api-management) that provide a highly flexible platform. This process could be more costly in time and resources.

- Rehost your IoT solution

  To rehost your IoT solution is basically a *lift and shift* movement. This situation occurs if your IoT applications are based on virtual machines, containers, or databases that you can migrate from another cloud to Azure. This method has the advantage that it doesn't require major changes in the code.

## Plan your IoT migration process

Every IoT migration differs in various ways, such as devices, network requirements, maturity, level of solution complexity and skill level of the IT team. As a general guide, every migration includes some form of the following steps. These steps help avoid the wrong technology and methodology choices. They can help avoid surprises during the migration process.

### Plan and assess

Identify and map your IoT solution, including devices, edge devices, messaging services, applications, storage, and analytics. Create a matrix with all the elements to plan the migration.

To speed up the inventory of the digital state, the Well-Architected Framework defines an IoT architecture as a set of foundational layers. Specific technologies support the different layers, and the IoT Well-Architected Framework highlights options for designing and creating each layer. For more information, see [IoT architecture layers](/azure/architecture/framework/iot/iot-overview#iot-architecture-layers).

### Design

  After you identify your migration strategy, analyze and design your solution in Azure. During this stage, identify all the components to migrate and their dependencies. Prepare contingency plans. Learn how to construct your [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone) with two possible paths: *use enterprise-scale* or *start small and expand*.

  Find the tools you need to set up your cloud environment in the [Azure setup guide](/azure/cloud-adoption-framework/ready/azure-setup-guide).

### Pilot your migration

  Do a pilot migration to test the solution and identify and resolve any technical and business blockers in your design. At this stage, identify the stakeholders who should validate the functionality of your application and make adjustment or design decisions.

  Define a period to test your IoT solution and resolve any issues. Run the pilot in a controlled test environment that doesn't affect your current production environment. During this process, it's useful to generate documentation, adjust the plan, and establish requirements to facilitate the go-live process.

### Migrate

  After you finish your pilot, plan your migration, and identify the timeframe that generates the least impact, it's time to migrate. For more information, see [Migrate your IoT solutions to Azure](migrate-iot-solution-azure.yml).

  The migration process can cause a period of solution outage or low performance for your end users.

  - Plan stages depending on the size of your IoT solution.
  - If it's a large deployment, plan migration by a group of customers, region, or some logic that allows you to group and minimize impacts.
  - Run a post-migration validation to ensure the proper functioning of your IoT solution, like device connectivity.
  - Make sure that you receive the telemetry and store the data, and that the applications are receiving the information.
  - If you have dependencies on third parties, such as APIs or interfaces, make sure that they're operating.

  You should always have a rollback plan. If something unexpected happens, you can replan the migration.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Chafia Aouissi](https://www.linkedin.com/in/caouissi ) | Senior PM Manager
- [Armando Blanco Garcia](https://www.linkedin.com/in/armbla) | Senior Program Manager
- [Valeria Naldi](https://www.linkedin.com/in/valerianaldi) | Principal Software Engineering

Other contributors:

- [Danilo Diaz](https://www.linkedin.com/in/danidiaz) | Director Technical Specialist Manager
- [Nabeel Muhammad](https://www.linkedin.com/in/mnabeel) | Senior Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure cloud migration best practices checklist](/azure/cloud-adoption-framework/migrate/azure-best-practices)
- [Introduction to the Azure migration guide](/azure/cloud-adoption-framework/migrate/azure-migration-guide/?tabs=MigrationTools)
- [Overview of Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview)

## Related resources

- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [Industrial IoT prediction patterns](../../guide/iiot-patterns/iiot-prediction-patterns.yml)
- [Choose an analytical data store](../../data-guide/technology-choices/analytical-data-stores.md)
- [Get started with Azure IoT solutions](../../reference-architectures/iot/iot-architecture-overview.md)
