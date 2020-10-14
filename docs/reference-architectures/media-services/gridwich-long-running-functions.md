---
title: Gridwich long-running Function Apps
titleSuffix: Azure Example Scenarios
description: Understand the challenges and solutions to deploy new Function Apps while gracefully handling the transition for long-running functions.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Long-running Function Apps

Some Gridwich functionality requires a relatively long processing time, but deploying the Function Application drops the long-running process. If these processes end abruptly, there is no status and no report back to the caller. Gridwich must deploy new Function Apps while gracefully handling the transition for long-running functions and not miss any messages.

This article discusses how Gridwich uses Azure Functions slot deployment and cancellation tokens to meet the requirements of reliable, long-running Functions.

## Async vs Sync Operations

The following diagram shows how most jobs work on Gridwich. The green box is a job that Gridwich passes to an external service and then reacts in an event-driven way to the status. The red box shows a  long-running Gridwich function.

![async_vs_sync_functions](media/long-running-functions.png)

## Constraints

- Don't invoke any additional Azure workloads, like Durable Functions, Function Apps, Logic Apps, or Azure Container Instances.
- Don't keep the state of running instances of the Gridwich app.
- Don't kill processes just because something is deploying or a new message is requesting the same activity.

## Solution

To meet the requirements and constraints, Gridwich uses Azure Functions *cancellation tokens* and *slot deployments*.

The Functions runtime adds the cancellation token when the application is shutting down. Gridwich detects the token and returns error codes for all requests and currently running processes.

Slot deployment deploys new software versions. The production slot has the running application, and the staging slot has the new version. Azure does a series of deployment steps and then swaps the slot instances. The old instance restarts as the last step of the process.

Gridwich waits 30 seconds after remapping the hostnames, so for http-triggered functions, Gridwich guarantees at least 30 seconds before the restart for the old production slot. Other triggers are controlled by app settings and don't have a mechanism to wait on app setting updates, so those functions risk being interrupted if execution starts right before the old production slot is restarted.

## Related resources

- [What happens during a slot swap for Azure Functions](/azure/azure-functions/functions-deployment-slots#swap-operations)
- [Azure Functions deployment slots](/azure/azure-functions/functions-deployment-slots)
