---
title: Network monitoring
description: Use networking logging and track traffic in real time to detect threats.
author: PageWriter-MSFT
ms.date: 09/14/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Network monitoring

 Monitor all communications between [segments](design-network.md#build-a-network-segmentation-strategy) to detect potential security threats flowing over the wire. One way is by integrating logs and analyzing the data to identify anomalies. Based on those insights, you can choose to set alerts or block traffic crossing segmentation boundaries. 

## Enable network visibility

**How do you monitor and diagnose conditions of the network?** 
***

Enable logs (including raw traffic) from your network devices. 

Integrate network logs into a security information and event management (SIEM) service, such as Azure Sentinel. Other popular choices include Splunk, QRadar, or ArcSight ESM.

Use machine learning analytics platforms that support ingestion of large amounts of information and can analyze large datasets quickly. Also, these solutions can be tuned to significantly reduce the false positive alerts. 

Here are some ways to integrate network logs:

- Security group logs – [flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-portal) and diagnostic logs
- [Web application firewall logs](/azure/application-gateway/application-gateway-diagnostics)
- [Virtual network taps](/azure/virtual-network/virtual-network-tap-overview)
- [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)

## Proactive monitoring
**How do you gain access to real-time performance information at the packet level?** 
***

Take advantage of [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) to set alerts and gain access to real-time performance information at the packet level. 

Packet capture tracks traffic in and out of virtual machines. It gives you the capability to run proactive captures based on defined network anomalies including information about network intrusions. 

For an example, see [Scenario: Get alerts when VM is sending you more TCP segments than usual](/azure/network-watcher/network-watcher-alert-triggered-packet-capture#scenario).