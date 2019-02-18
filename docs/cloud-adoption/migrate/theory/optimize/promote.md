---
title: "Fusion: What is required to promote a migrated resource to production?"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: What is required to promote a migrated resource to production?

Promotion to production marks the completion of an application or workloads migration to the cloud. Once the asset and all of its dependencies are promoted, production traffic is re-routed. The re-routing of traffic makes the on-prem assets obsolete, allowing them to be de-commissioned.

The process of promotion varies according to the application's architecture. However, there are a number of consistent pre-requisites and a few common tasks. This article will describe each, to serve as a kind of pre-promotion checklist.

## Pre-requisite processes

Each of the following processes should be executed, documented, and validated prior to production deployment.

* [Assess](assess.md): The application has been assessed for cloud compatibility
* [Architect](architect.md): The structure of the application has been properly architected to align with the chosen cloud provider.
* [Replicate](replicate.md): The assets have been replicated to the cloud environment.
* [Stage](stage.md): The replicated assets have been restored in a staged instance of the cloud environment.
* [Business Testing](business-test.md): The application has been fully tested and validated by business users.
* [Business Change Plan](business-change-plan.md): The business has shared a plan for the changes that will be made in accordance with the production promotion. This should include a user adoption plan, changes to business processes, users that require training, and timelines for various activities
* [Ready](ready.md): Generally, a series of technical changes need to be made in advance of promotion.

## Best practices to execute prior to promotion

The following technical changes will likely need to be completed and documented, as part of the promotion process:

* Domain Alignment: Some corporate policies require separate domains for staging and production. Ensure all assets are joined to the proper domain.
* User Routing: Validate that users are accessing the application through proper network routes. Verify consistent performance expectations.
* Identity Alignment: Validate that the users being re-routed to the application have proper permissions withing the domain to host the application.
* Application Performance: Perform a final validation of application performance to minimize surprises.
* BCDR (Business Continuity / Disaster Recovery) Validation: Validate proper backup and recovery processes are functioning as expected.
* Data Classification: Validate data classification to ensure proper protections and policies have been implemented.
* CISO (Chief Information Security Officer) Verification: Validate that the information security office has reviewed the application, business risks, risk tolerance, and mitigation strategies.

## Final step: Promote

Various applications may require detailed promotion processes. However, the common final step for promotion is network realignment. When everything else is ready, update DNS records and/or IP addresses to route traffic to the migrated application.

## Next steps: Align Business Priorities

Promotion of an application, or group of applications signals the completion of a release. The next step in the iterative migration process, is to [align business priorities](business-priorities.md).

> [!div class="nextstepaction"]
> [Align business priorities](business-priorities.md)