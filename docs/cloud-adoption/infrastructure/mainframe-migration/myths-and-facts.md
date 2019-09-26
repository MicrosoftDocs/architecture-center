---
title: "Mainframe migration: Myths and facts"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Migrate applications from mainframe environments to Azure, a proven, highly available, and scalable infrastructure for systems that currently run on mainframes.
author: njray
ms.author: v-nanra
ms.date: 12/27/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Mainframe myths and facts

Mainframes figure prominently in the history of computing and remain viable for highly specific workloads. Most agree that mainframes are a proven platform with long-established operating procedures that make them reliable, robust environments. Software runs based on usage, measured in million instructions per second (MIPS), and extensive usage reports are available for chargebacks.

The reliability, availability, and processing power of mainframes have taken on almost mythical proportions. To evaluate the mainframe workloads that are most suitable for Azure, you first want to distinguish the myths from the reality.

## Myth: Mainframes never go down and have a minimum of five 9s of availability

Mainframe hardware and operating systems are viewed as reliable and stable. But the reality is that downtime must be scheduled for maintenance and reboots (referred to as initial program loads or IPLs). When these tasks are considered, a mainframe solution often has closer to two or three 9s of availability, which is equivalent to that of high-end, Intel-based servers.

Mainframes also remain as vulnerable to disasters as any other servers do, and require uninterruptible power supply (UPS) systems to handle these types of failures.

## Myth: Mainframes have limitless scalability

A mainframe’s scalability depends on the capacity of its system software, such as the customer information control system (CICS), and the capacity of new instances of mainframe engines and storage. Some large companies that use mainframes have customized their CICS for performance, and have otherwise outgrown the capability of the largest available mainframes.

## Myth: Intel-based servers are not as powerful as mainframes

The new core-dense, Intel-based systems have as much compute capacity as mainframes.

## Myth: The cloud can't accommodate mission-critical applications for large companies such as financial institutions

Although there may be some isolated instances where cloud solutions fall short, it is usually because the application algorithms cannot be distributed. These few examples are the exceptions, not the rule.

## Summary

By comparison, Azure offers an alternative platform that is capable of delivering equivalent mainframe functionality and features, and at a much lower cost. In addition, the total cost of ownership (TCO) of the cloud’s subscription-based, usage-driven cost model is far less expensive than mainframe computers.

## Next steps

> [!div class="nextstepaction"]
> [Make the switch from mainframes to Azure](migration-strategies.md)
