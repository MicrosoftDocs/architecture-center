---
title: Extending the Startup Stack
description: Extend the basic stack that you've built your MVP on to accommodate the growing needs of your startup.
author: mootpointer
ms.date: 05/15/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
---

# Extending the Startup Stack

## Background Jobs

One common extension to a monolithic app is to move long-running tasks to a separate background task. A common task is sending emails or other notifications as part of serving a request. It's important that the emails are sent, but the process of sending the emails adds latency to completing the user's request. Since the delivery of emails isn't expected to be instantaneous, we can move the work to a separate task while the request is completed.

This same approach can be applied to other computationally expensive tasks, for example generating a sales report over a large number of transactions. A common pattern is to acknowledge the request for the report, complete the generation of the report asynchronously and then notify the user when the task is complete.

### Example

Contoso has deployed their revolutionary widget application using the [The Basic Startup Stack](basic-startup-stack.md). They have recently added a feature that analyses data supplied by the user and suggests optimal widget configuration. The process of analysis and generation of suggestions is data intensive and can take upwards of a minute to complete. The long response time is causing user experience issues and also consuming web front-end resources.

Since this analysis task is relatively self-contained, the team decide to move the work to an Azure function. The Python Azure functions runtime makes it easy to include shared libraries, and an API endpoint is added to the existing monolith for the function to call when the analysis is complete.

_TODO: Insert diagram here_

Using the consumption plan for Azure Functions means that Contoso only pays for the time spent processing the analyses. They add the function deployment to their existing CI/CD pipeline, treating the deployment as monolithic to reduce complexity. By keeping this extension limited in scope, they invest enough to provide a good user experience without over-investing in architecture.

- [Best Practices](/azure/architecture/best-practices/background-jobs)

## Machine Learning

## Analytics
