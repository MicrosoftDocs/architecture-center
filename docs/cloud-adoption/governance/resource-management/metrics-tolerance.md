---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Explanation of the concept resource management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/3/2019
---

# Fusion: Metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to resource management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Resource Management discipline.

## Metrics and resource management information


Metrics to think about from Azure Monitor:

* VMs in critical condition: Number of deployed assets violating operating systems requirements
* Alerts by Severity: Number of alerts on a deployed asset by severity
* Unhealthy subnetwork links: Number of issues with network connectivity
* Unhealthy Service Endpoints: Number of issues with external network endpoints
* Resource depletion: Number of instances where memory or CPU resources are exhausted by app runtimes
* Cloud Provider Service Health incidents: Number of incidents caused by the cloud provider
* Backup Health: Number of backups being actively synchronized
* Recovery Health: Number of backups being actively synchronized


## Risk tolerance indicators


## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating security policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Monitor and Enforce Policy Statements](./processes.md)
