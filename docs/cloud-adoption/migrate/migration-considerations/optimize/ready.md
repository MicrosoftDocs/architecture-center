---
title: "Prepare a migrated application for production promotion"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: A process within cloud migration that focuses on the tasks of migrating workloads to the cloud.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Prepare a migrated application for production promotion

After a workload is promoted, production user traffic is routed to the migrated assets. Readiness activities provide an opportunity to prepare the workload for that traffic. The following are a few business and technology considerations to help guide readiness activities.

## Validate the business change plan

Transformation happens when business users or customers take advantage of a technical solution to execute processes that drive the business. Readiness is a good opportunity to validate the [business change plan](business-change-plan.md) and to ensure proper training for the business and technical teams involved. In particular, ensure that the following technology-related aspects of the change plan are properly communicated:

- End-user training is completed (or at least planned).
- Any outage windows have been communicated and approved.
- Production data has been synchronized and validated by end users.
- Validate promotion and adoption timing; ensure timelines and changes have been communicated to end users.

## Final technical readiness tests

*Ready* is the last step prior to production release. That means it is also the last chance to test the workload. The following are a few tests that are suggested during this phase:

- **Network isolation testing.** Test and monitor network traffic to ensure proper isolation and no unexpected network vulnerabilities. Also validate that any network routing to be severed during cutover is not experiencing unexpected traffic.
- **Dependency testing.** Ensure that all workload application dependencies have been migrated and are accessible from the migrated assets.
- **Business continuity and disaster recovery (BCDR) testing.** Validate that any backup and recovery SLAs are established. If possible, perform a full recovery of the assets from the BCDR solution.
- **End-user route testing.** Validate traffic patterns and routing for end-user traffic. Ensure that network performance aligns with expectations.
- **Final performance check.** Ensure that performance testing has been completed and approved by end users. Execute any automated performance testing.

## Final business validation

After the business change plan and technical readiness have been validated, the following final steps can complete the business validation:

- **Cost validation (plan versus actual).** Testing is likely to produce changes in sizing and architecture. Ensure that actual deployment pricing still aligns with the original plan.
- **Communicate and execute cutover plan.** Prior to cutover, communicate the cutover and execute accordingly.

## Next steps

After all readiness activities have been completed, its time to [promote the workload](./promote.md).

> [!div class="nextstepaction"]
> [What is required to promote a migrated resource to production?](./promote.md)
