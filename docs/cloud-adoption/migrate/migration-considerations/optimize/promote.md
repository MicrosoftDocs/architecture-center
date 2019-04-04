---
title: "What is required to promote a migrated resource to production?"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 4/4/2019
---

# What is required to promote a migrated resource to production?

Promotion to production marks the completion of a workload’s migration to the cloud. After the asset and all of its dependencies are promoted, production traffic is rerouted. The rerouting of traffic makes the on-premises assets obsolete, allowing them to be decommissioned.

The process of promotion varies according to the workload's architecture. However, there are a number of consistent prerequisites and a few common tasks. This article describes each and serves as a kind of pre-promotion checklist.

## Prerequisite processes
Each of the following processes should be executed, documented, and validated prior to production deployment:

- **[Assess](../assess/index.md).** The workload has been assessed for cloud compatibility.
- **[Architect](../assess/architect.md).** The structure of the workload has been properly architected to align with the chosen cloud provider.
- **[Replicate](../migrate/replicate.md).** The assets have been replicated to the cloud environment.
- **[Stage](../migrate/stage.md).** The replicated assets have been restored in a staged instance of the cloud environment.
- **[Business testing](./business-test.md).** The workload has been fully tested and validated by business users.
- **[Business change plan](./business-change-plan.md).** The business has shared a plan for the changes that will be made in accordance with the production promotion; this should include a user adoption plan, changes to business processes, users that require training, and timelines for various activities.
- **[Ready](./ready.md).** Generally, a series of technical changes need to be made in advance of promotion.

## Best practices to execute prior to promotion

The following technical changes will likely need to be completed and documented as part of the promotion process:

- **Domain alignment.** Some corporate policies require separate domains for staging and production. Ensure that all assets are joined to the proper domain.
- **User routing.** Validate that users are accessing the workload through proper network routes; verify consistent performance expectations.
- **Identity alignment.** Validate that the users being rerouted to the application have proper permissions within the domain to host the application.
- **Performance.** Perform a final validation of workload performance to minimize surprises.
- **BC/DR validation.** Validate that proper backup and recovery processes are functioning as expected.
- **Data classification.** Validate data classification to ensure that proper protections and policies have been implemented.
- **Chief information security officer (CISO) verification.** Validate that the information security officer has reviewed the workload, business risks, risk tolerance, and mitigation strategies.

## Final step: Promote

Workloads will require varying levels of detailed review and promotion processes. However, network realignment serves as the common final step for all promotion releases. When everything else is ready, update DNS records and/or IP addresses to route traffic to the migrated workload.

## Next steps

Promotion of an workload signals the completion of a release. However, in parallel to migration, retired assets need to be [decomissioned](./decomission.md) taking them out of service.

> [!div class="nextstepaction"]
> [Decomission retired assets](./decomission.md)

