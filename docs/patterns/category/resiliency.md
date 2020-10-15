---
title: Resiliency patterns
titleSuffix: Cloud Design Patterns
description: Use these resiliency patterns to help your application detect failures and recover, which is important to maintain resiliency for cloud hosted applications.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Resiliency patterns

Resiliency is the ability of a system to gracefully handle and recover from failures, both inadvertent and malicious.

The nature of cloud hosting, where applications are often multi-tenant, use shared platform services, compete for resources and bandwidth, communicate over the Internet, and run on commodity hardware means there is an increased likelihood that both transient and more permanent faults will arise. The connected nature of the internet and the rise in sophistication and volume of attacks increase the likelihood of a security disruption.

Detecting failures and recovering quickly and efficiently, is necessary to maintain resiliency.

|                            Pattern                             |                                                                                                      Summary                                                                                                       |
|----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                   [Bulkhead](../bulkhead.md)                   |                                                     Isolate elements of an application into pools so that if one fails, the others will continue to function.                                                      |
|            [Circuit Breaker](../circuit-breaker.md)            |                                                  Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource.                                                   |
|   [Compensating Transaction](../compensating-transaction.md)   |                                                      Undo the work performed by a series of steps, which together define an eventually consistent operation.                                                       |
| [Health Endpoint Monitoring](../health-endpoint-monitoring.md) |                                            Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.                                            |
|            [Leader Election](../leader-election.md)            | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. |
|  [Queue-Based Load Leveling](../queue-based-load-leveling.md)  |                                            Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.                                             |
|                      [Retry](../retry.md)                      |             Enable an application to handle anticipated, temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that's previously failed.             |
| [Scheduler Agent Supervisor](../scheduler-agent-supervisor.md) |                                                            Coordinate a set of actions across a distributed set of services and other remote resources.                                                            |

## Security Resliency

Achieving security resilience requires a combination of preventive measures to block attacks, responsive measures detect and quickly remediate active attacks, and governance to ensure consistent application of best practices.

- **Security strategy** should include lessons learned described in [security strategy guidance](https://aka.ms/securitystrategy) 
- **Azure security configurations** should align to the best practices and controls in the [Azure Security Benchmark (ASB)](https://aka.ms/benchmarkdocs). Security configurations for Azure services should align to the [Security baselines for Azure](/azure/security/benchmarks/security-baselines-overview) in the ASB
- **Azure architectures** should integrate native security capabilities to protect and monitor workloads including [Azure Defender](/azure/security-center/azure-defender), [Azure DDoS protection](/azure/virtual-network/ddos-protection-overview), [Azure Firewall](/azure/firewall/), and [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/)

For a more detailed dsicussion, see the [Cybersecurity Resilience](/security/ciso-workshop/ciso-workshop-module-1#part-2-cybersecurity-resilience-1350) module in the CISO workshop
