---
ms.author: dastanfo
author: david-stanford
ms.date: 10/14/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.uid: 1fadc07b-c206-4e16-bf2c-67aa3c5bec6a
ms.assessment_question: Utilize background jobs
---
## Background jobs

Review background jobs guidance. For batch processing, use Azure Logic Apps/Functions to create and schedule regularly running tasks. Return a response to the caller whilst starting background processing, then check in for updates.

Learn more: [https://docs.microsoft.com/en-us/azure/architecture/patterns/async-request-reply](https://docs.microsoft.com/en-us/azure/architecture/patterns/async-request-reply)