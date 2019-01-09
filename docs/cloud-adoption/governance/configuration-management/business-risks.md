---
title: "Fusion: Motivations and business risks that drive configuration management governance"
description: Learn about the discipline of configuration management as part of a cloud governance strategy.
author: alexbuckgit
ms.date: 1/9/2019
---

# Fusion: Motivations and business risks that drive configuration management governance

This article discusses the reasons that customers typically adopt a configuration management discipline within a cloud governance strategy. It also provides a few examples of business risks that drive policy statements.

## Is configuration management relevant?

On-premises systems are often deployed using baseline images or installation scripts. Additional configuration is usually necessary, which may involve multiple steps or human intervention. These manual processes are error-prone and often result in "configuration drift", requiring time-consuming troubleshooting and remediation tasks.

Most Azure resources can be deployed and configured manually via the Azure portal. This approach may be sufficient for your needs when only have a few resources to manage. However, as your cloud estate grows, your organization should automate the deployment of your cloud resources to take advantage of the scaling, failover, and disaster recovery capabilities that Azure provides. Adopting a DevOps or DevSecOps approach is often the best way to manage your deployments.
  
A robust configuration management plan ensures that your cloud resources are deployed, updated, and configured correctly and consistently, and remain that way. The maturity of your configuration management strategy can also be a significant factor in your [cost management strategy](../cost-management/overview.md). Automated provisioning and configuration of your cloud resources allows you scale down or deallocate resources when demand is low or time-bound, so you only pay for resources as you need them.

## Business risk

The configuration management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

- **Overreliance on manual processes**. Automated deployments ensure consistency and predictability while reducing human error.
- Disaster recovery: The lack of a disaster recovery plan can cause significant downtime for mission-critical applications in case of a cloud datacenter outage.
- **Organizational culture**. Organizational barriers between development, operations, and security teams can cause numerous challenges to efficient adoption of cloud technologies and the development of a unified cloud governance model.
- **Accurate documentation**. Executable definitions of system configurations can serve as authoritative documentation, and avoids problems caused by differences between active configurations and system documentation.
- **Troubleshooting**. Unexpected changes in configuration of system resources can make identifying root cause of issues more difficult.

## Next steps

Using the [Cloud Management Template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's [tolerance for risk](./metrics-tolerance.md) and the indicators / key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./tolerance.md)
