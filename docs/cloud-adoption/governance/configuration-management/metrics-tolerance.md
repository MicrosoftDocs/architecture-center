---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Metrics, indicators, and risk tolerance for configuration management governance
author: alexbuckgit
ms.date: 1/17/2019
---

# Fusion: Metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to configuration management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Configuration Management discipline.

## Metrics

Configuration management focuses on deploying, updating, and maintaining cloud resources configured for proper systems operation. The following information is useful when adopting this discipline of cloud governance:

- **Recovery time objective (RTO)**. The maximum acceptable time that an application can be unavailable after an incident.
- **Recovery point objective (RPO)**. The maximum duration of data loss that is acceptable during a disaster. For example, if you store data in a single database, with no replication to other databases, and perform hourly backups, you could lose up to an hour of data.
- **Mean time to recover (MTTR)**. The average time required to restore a component after a failure.
- **Mean time between failures (MTBF)**. The duration that a component can reasonably expect to run between outages. This metric can help you calculate how often a service will become unavailable.
- **Service level agreements (SLA)**. This can include both Microsoft’s commitments for uptime and connectivity of Azure services, as well as commitments made by the business to its external and internal customers.
- **Time to deployment**. The amount of time needed to deploy updates to an existing system.
- **Assets out-of-compliance**. The number or percentage of resources that are out of compliance with defined policies.

## Risk tolerance indicators

Risks related to configuration management are largely related to the number and complexity of cloud-based systems deployed for your enterprise. As your cloud estate grows, the number of systems deployed and the frequency of updating your cloud resources will increase. Dependencies between resources magnify the importance of ensuring proper configuration of resources and designing systems for resiliency if one or more resources experiences unexpected downtime.

Consider adopting a DevOps or [DevSecOps](https://www.microsoft.com/en-us/securityengineering/devsecops) organizational culture early in your cloud adoption journey. Traditional corporate IT organizations often have siloed operations, security, and development teams that often do not collaborate well or are even adversarial or hostile towards one another. Recognizing these challenges early and integrating key stakeholders from each of the teams can help ensure agility in your cloud adoption while remaining secure and well-governed.

Work with your DevSecOps team and business stakeholders to identify [business risks](business-risks.md) related to configuration, then determine an acceptable baseline for configuration risk tolerance. This section of the Fusion guidance provides examples, but the detailed risks and baselines for your company or deployments will likely differ.

Once you have a baseline, establish minimum benchmarks representing an unacceptable increase in your identified risks. These benchmarks act as triggers for when you need to take action to mitigate these risks. The following are a few examples of how configuration-related metrics, such as those discussed above, can justify an increased investment in the Configuration Management discipline.

- **Service-level agreement (SLA) trigger**. A company that cannot meet its SLAs to its external customers or internal partners should invest in the Configuration Management discipline to reduce system downtime.
- **Recovery time triggers**. If a company exceeds the required thresholds for recovery time following a system failure, it should invest in improvement to its Configuration Management discpline and systems design to reduce or eliminate failures or the impact of individual component downtime.
- **Configuration drift triggers**. A company that is experiencing unexpected changes in the configuration of key system components, or failures in the deployment of or updates to its systems, should invest in the Configuration Management discipline to identify root causes and steps for remediation.  
- **Out of compliance triggers**. If the number of out-of-compliance resources exceeds a defined threshold (either as a total number of resources or a percentage of total resources), a company should invest in Configuration Management discipline improvements to ensure each resource's configuration remains in compliance throughout that resource's lifecycle.
 **Project schedule triggers**. If the time to deploy a company's resources and applications often exceed a define threshold, a company should invest in its Configuration Management processes to introduce or improve automated deployments for consistency and predictability. Deployment times are measured in days or even weeks are usually indicative of a suboptimal configuration management strategy.

## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating security policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Establish Policy Adherence Processes](./processes.md)
