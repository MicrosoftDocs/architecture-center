---
ms.author: dastanfo
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.uid: 1fadc07b-c206-4e16-bf2c-67aa3c5bec6a
ms.assessment_question: Utilize background jobs
---
## Background jobs

Back in the 1990's and early 2000's, Enterprise Application Integration became a major topic for hooking systems together, creating and scheduling jobs and tasks. These platforms offered a series of connectors for working with common formats and protocols like EDI/X12/EDIFACT, SFTP, HL7, SWIFT, and SOAP; and managing long running processes that may span minutes/hours/days through workflow orchestration. Along with workflow, these integration tools solved app-to-app and business-to-business integration needs. Not surprisingly,these needs still exist in the cloud, but a scalable cloud native way of enabling these capabilities is paramount, and that's what the Logic Apps service enables in Azure. Logic Apps is a serverless consumption  (pay-per-use) service that enables a vast set of out-of-the-box ready-to-use connectors and a long-running workflow engine to quickly enable cloud-native integration needs. Logic Apps is flexible enough for a plethora of sceneries like running tasks/jobs, advanced scheduling, and triggering. It includes many of the format and protocol capabilities that existed in Microsoft's enterprise EAI product called BizTalk Server, and has advanced hosting options to allow it run within enterprise restricted cloud environments. Logic Apps compliments and can be combined with all other Azure services, or it can be used independently.

Like all serverless services, Logic Apps doesn't require VM instances to be purchased, enabled, and scaled up and down. Instead, Logic Apps inheritably scale automatically on serverless PaaS provided instances, and a consumer only pays based on usage. Read more about Logic Apps here: </azure/logic-apps/logic-apps-overview>
