---
title: Testing for reliability
description: Describes considerations for reliability in application testing.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Testing for reliability

Regular testing should be performed as part of each major change and if possible, on a regular basis to validate existing thresholds, targets and assumptions. Testing should also ensure the validity of the health model, capacity model, and operational procedures.

## Checklist

**Have you tested your applications with reliability in mind?**
***

> [!div class="checklist"]
> - Test regularly to validate existing thresholds, targets and assumptions.
> - Automate testing as much as possible.
> - Perform testing on both key test environments with the production environment.
> - Perform chaos testing by injecting faults.
> - Create and test a disaster recovery plan on a regular basis using key failure scenarios.
> - Design disaster recovery strategy to run most applications with reduced functionality.
> - Design a backup strategy that is tailored to business requirements and circumstances of the application.
> - Test and validate the failover and failback approach successfully at least once.
> - Configure request timeouts to manage inter-component calls.
> - Implement retry logic to handle transient application failures and transient failures with internal or external dependencies.
> - Configure and test health probes for your load balancers and traffic managers.
> - Apply chaos principles continuously.
> - Create and organize a central chaos engineering team.

## In this section

Follow these questions to assess the workload at a deeper level.

| Assessment | Description |
| ------------- | ------------- |
| [How do you test the application to ensure it is fault tolerant?](/azure/architecture/framework/resiliency/testing) | Test regularly to validate existing thresholds, targets and assumptions. Automate testing as much as possible.
| [How are you handling disaster recovery for your application?](/azure/architecture/framework/resiliency/backup-and-recovery) | A disaster recovery plan is considered complete after it has been fully tested. Include the people, processes, and applications needed to restore functionality within the service-level agreement (SLA).
| [How are you managing errors & failures?](/azure/architecture/framework/resiliency/app-design-error-handling) | Testing doesn't always catch everything. Ensure that your application can recover from errors in a critical when working in a distributed system.
| [How do you chaos-engineer your applications to ensure that they're fault tolerant?](/azure/architecture/framework/resiliency/chaos-engineering) | Deliberately inject faults that cause system components to fail. This can be done in a production or non-production environment.

## Azure services

- [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)
- [Azure Pipelines](https://docs.microsoft.com/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)
- [Azure Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview)
- [Azure Load Balancer](https://docs.microsoft.com/azure/load-balancer/load-balancer-overview)

## Reference architecture

- [Failure Mode Analysis for Azure applications](https://docs.microsoft.com/azure/architecture/resiliency/failure-mode-analysis)
- [High availability and disaster recovery scenarios for IaaS apps](https://docs.microsoft.com/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery)
- [Back up files and applications on Azure Stack Hub](https://docs.microsoft.com/azure/architecture/hybrid/azure-stack-backup)

## Next step

>[!div class="nextstepaction"]
>[Resiliency testing](/azure/architecture/framework/resiliency/testing)

## Related links

- For information on performance testing, see [Performance testing](/azure/architecture/framework/scalability/performance-test).
- For information on chaos engineering, see [Chaos engineering](/azure/architecture/framework/resiliency/chaos-engineering).
- For information on failure and disaster recovery, see [Failure and disaster recovery for Azure applications](/azure/architecture/framework/resiliency/backup-and-recovery).
- For information on testing applications, see [Testing your application and Azure environment](/azure/architecture/framework/devops/release-engineering-testing). 