---
title: "CAF: Resource Consistency metrics, indicators, and risk tolerance"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Resource Consistency metrics, indicators, and risk tolerance
author: BrianBlanchard
---

# Resource Consistency metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to Resource Consistency. Defining metrics and indicators helps you create a business case for making an investment in maturing the Resource Consistency discipline.

## Metrics

The Resource Consistency discipline focuses on addressing risks related to the operational management of your cloud deployments. As part of your risk analysis you'll want to gather data related to your IT operations to determine how much risk you face, and how important investment in Resource Consistency governance is to your planned cloud deployments.

Every organization has different operational scenarios, but the following items represent useful examples of the metrics you should gather when evaluating risk tolerance within the Resource Consistency discipline:

- **Cloud assets**. Total number of cloud-deployed resources.
- **Untagged resources**. Number of resources without required accounting, business impact, or organizational tags.
- **Underused assets**. Number of resources where memory, CPU, or network capabilities are all consistently under-used.
- **Resource depletion**. Number of resources where memory, CPU, or network capabilities are exhausted by load.
- **Resource age**. Time since resource was last deployed or modified.
- **Service availability**. Percentage of actual uptime cloud-hosted workloads compared to the expected uptime.
- **VMs in critical condition**. Number of deployed VMs where one or more critical issues are detected which need to be addressed in order to restore normal functionality.
- **Alerts by Severity**. Total number of alerts on a deployed asset, broken down by severity.
- **Unhealthy subnet links**. Number of resources with network connectivity issues.
- **Unhealthy Service Endpoints**. Number of issues with external network endpoints.
- **Cloud Provider Service Health incidents**. Number of disruptions or performance incidents caused by the cloud provider.
- **Backup Health**. Number of backups actively being synchronized.
- **Recovery Health**. Number of recovery operations successfully performed.

## Risk tolerance indicators

Cloud platforms offer a baseline set of features that allow deployment teams to effectively manage small deployments without extensive additional planning or processes. As a result, small Dev/Test or experimental first workloads that include a relatively small amount of cloud-based assets represent low level of risk, and will likely not need much in the way of a formal Resource Consistency policy.

However, as the size of your cloud estate grows the complexity of managing your assets becomes significantly more difficult. With more assets on the cloud, the ability identify ownership of resources and control resource useful becomes critical to minimizing risks. As more mission-critical workloads are deployed to the cloud, service uptime becomes more critical, and tolerance for service disruption potential cost overruns diminishes rapidly.

In the early stages of cloud adoption, work with your IT operations team and business stakeholders to identify [business risks](business-risks.md) related to Resource Consistency, then determine an acceptable baseline for risk tolerance. This section of the Cloud Adoption Framework provides examples, but the detailed risks and baselines for your company or deployments may be different.

Once you have a baseline, establish minimum benchmarks representing an unacceptable increase in your identified risks. These benchmarks act as triggers for when you need to take action to mitigate these risks. The following are a few examples of how operational metrics, such as those discussed above, can justify an increased investment in the Resource Consistency discipline.

- **Tagging and naming trigger**. A company with more than X resources lacking required tagging information or not obeying naming standards should consider investing in the Resource Consistency discipline to help refine these standards and ensure consistent application of them to cloud-deployed assets.
- **Overprovisioned resources trigger**. If a company has more than X% of assets regularly using very small amounts of their available memory, CPU, or network capabilities, investment in the Resource Consistency discipline is suggested to help optimize resources usage for these items.
- **Underprovisioned resources trigger**. If a company has more than X% of assets regularly exhausting most of their available memory, CPU, or network capabilities, investment in the Resource Consistency discipline is suggested to help ensure these assets have the resources necessary to prevent service interruptions.
- **Resource age trigger**. A company with more than X resources that have not been updated in over X months could benefit from investment in the Resource Consistency discipline aimed at ensuring active resources are patched and healthy, while retiring obsolete or otherwise unused assets.
- **Service availability trigger**. A company that has experienced under X% uptime for mission-critical services should invest in the Resource Consistency discipline to improve their service reliability.
- **VM health trigger**. A company that has more than X% of VMs experiencing a critical health issue should invest in the Resource Consistency discipline to identify issues and improve VM stability.
- **Network health trigger**. A company that has more than X% of network subnets or endpoints experiencing connectivity issues should invest in the Resource Consistency discipline to identify and resolve network issues.
- **Backup coverage trigger**. A company with X% of mission-critical assets without up-to-date backups in place would benefit from an increased investment in the Resource Consistency discipline to ensure a consistent backup strategy.
- **Backup health trigger**. A company experiencing more than X% failure of restore operations should invest in the Resource Consistency discipline to identify problems with backup and ensure important resources are protected.

The exact metrics and triggers you use to gauge risk tolerance and the level of investment in the Resource Consistency discipline will be specific to your organization, but the examples above should serve as a useful base for discussion within your Cloud Governance team.

## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a process for governing and communicating Resource Consistency policy adherence.

> [!div class="nextstepaction"]
> [Establish policy compliance processes](compliance-processes.md)
