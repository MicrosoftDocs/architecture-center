---
title: "Fusion: Getting a migrated application ready for production promotion"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Getting a migrated application ready for production promotion

Once an application is promoted, production user traffic will be routed to the migrated assets. Readiness activities provide an opportunity to prepare the application for that traffic. The following are a few business and technology considerations to help guide readiness activities.

## Validate the Business Change Plan

Transformation happens when business users (or customers) leverage a technical solution to execute processes that drive the business. Readiness is a good opportunity to validate the [Business Change Plan](business-change-plan.md) and ensure proper training for the business and technical teams involved. In particular, ensure the following technology related aspects of the change plan are properly communicated:

* End User training is completed (or at least planned)
* Any outage windows have been communicated and approved
* Production data has been synchronized and validated by end users
* Validate promotion and adoption timing. Ensure timelines and changes have been communicated to end users

## Final Technical Readiness Tests

Ready is the last step prior to production release. That means, it is also the last chance to test the application. The following are a few tests that are suggested during this phase.

* Network isolation testing: Test & monitor network traffic to ensure proper isolation & no unexpected network vulnerabilities. Also validate that any network routing that will be severed during cut-over is not experiencing unexpected traffic.
* Dependency testing: Ensure all application dependencies have been migrated and are accessible from the migrated assets.
* BC/DR (Business Continuity / Disaster Recovery) testing: Validate that any backup and recovery SLAs are established. If possible perform a full recovery of the assets from the BC/DR solution.
* End user route testing: Validate traffic patterns and routing for end user traffic. Ensure network performance aligns with expectations.
* Final performance check: Ensure performance testing has been completed and approved by end users. Execute any automated performance testing.

## Final Business Validation

Once the Business Change Plan and Technical Readiness have been validated, the following final steps can completed the business validation.

* Cost validation (Plan vs Actual): Testing is likely to produce changes in sizing and architecture. Ensure actual deployment pricing still aligns with the original plan.
* Communicate and execute cut over plan: Prior to cut over, communicate the cut over and execute accordingly.

## Next steps: Promote the application

Once all readiness activities have been completed, its time to [promote the application](promote.md).

> [!div class="nextstepaction"]
> [Promote the application](promote.md)