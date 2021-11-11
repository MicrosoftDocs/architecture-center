---
title: Best practices for reliability in apps
description: Review best practices for reliability monitoring in Azure applications within the Azure Well-Architected Framework.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitoring best practices for reliability in Azure applications

This article lists Azure best practices to enhance monitoring Azure applications for reliability. These best practices are derived from our experience with Azure reliability and the experiences of customers like yourself.

Implement these best practices for monitoring and alerts in your application so you can detect failures and alert an operator to fix them.

## Implement health probes and check functions

Run them regularly from outside the application to identify degradation of application health and performance.

## Check long-running workflows

Catching issues early can minimize the need to roll back the entire workflow or to execute multiple compensating transactions.

## Maintain application logs

- Log applications in production and at service boundaries.
- Use semantic and asynchronous logging.
- Separate application logs from audit logs.

## Measure remote call statistics

Measure remote call statistics, and share the data with the application team to give your operations team an instantaneous view into application health, summarize remote call metrics, such as latency, throughput, and errors in the 99 and 95 percentiles. Perform statistical analysis on the metrics to uncover errors that occur within each percentile.

## Track transient exceptions and retries

A trend of increasing exceptions over time indicates that the service is having an issue and may fail. Track transient exceptions and retries over an appropriate time frame to prevent failure.

## Set up an early warning system

Identify the key performance indicators (KPIs) of an application's health, such as transient exceptions and remote call latency, and set appropriate threshold values for each of them. Send an alert to operations when the threshold value is reached.

## Operate within Azure subscription limits

Azure subscriptions have limits on certain resource types, such as the number of resource groups, cores, and storage accounts. Watch your use of resource types.

## Monitor third-party services

Log your invocations and correlate them with your application's health and diagnostic logging using a unique identifier.

## Train multiple operators

Train multiple operators to monitor the application and to perform manual recovery steps. Make sure there is always at least one trained operator active.
