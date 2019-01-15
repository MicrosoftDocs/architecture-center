---
title: "Fusion: Policy adherence processes for security management"
description: Explanation of the concept security management in relation to cloud governance processes
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Security management policy compliance processes

This article discusses an approach to policy adherence processes that govern [security management](./overview.md). Effective governance of cloud security starts with recurring manually processes designed to detect vulnerabilities and impose policies to mitigate those security risks. However, you can automate these processes and supplement with tooling to reduce the overhead of governance and allow for faster response to deviation.

## Planning, review, and reporting processes

The best security management tools in the cloud are only as good as the processes and policies that they support. The following is a set of manual processes commonly used as part of a security management discipline.

**Deployment planning**: Prior to deployment of any asset, perform a security review to ensure all access and data security policy requirements are met.

**High-level security planning**: Every 6-12 months perform a high-level review of security management strategy. Explore future corporate priorities and updated cloud adoption strategies to identify potential risk increase and other emerging security needs. 

As part of this planning, review the current cybersecurity landscape to proactively anticipate emerging threats. Also use this time to review the latest best practices and integrate these into your policies and review processes.

**Quarterly review**: On a quarterly basis perform a review of security monitoring data and incident reports to identify any changes required in security policy. Also use this time to update documentation and guidance, and ensure IT staff are up-to-date on the latest security policy requirements.

**Monthly reports**: On a monthly basis review security related activities with IT staff and identify any compliance issues not already handled as part of the ongoing monitoring and enforcement process.

**Ongoing monitoring and enforcement reporting**: Because security non-compliance can lead to critical and time-sensitive data exposure and service disruption risks, the cloud governance team should have visibility into serious policy violations. Ensure IT staff have clear escalation paths for reporting security issues to the governance team members best suited to identifying and verifying policies issues are mitigated.  

## Violation triggers and enforcement actions

When violations are detected, you should take enforcement actions to realign with policy. You can automate most violation triggers using the tools outlined in the [Azure-Specific Toolchain](toolchain.md).

The following are examples of security triggers:

- Increase in attacks detected: If any resource experiences an 25% increase in brute force or DDoS attacks, discuss with IT security staff and workload owner to determine remedies. Track issue and update guidance if policy revision is necessary to mitigate future incidents.
- Unclassified data detected: Any data source without an appropriate privacy, security, or business impact classification will have external access denied until the classification is applied by the data owner and the appropriate level of data protection applied.
- Security health issue detected: Disable any virtual machines(VMs) that have known access or malware vulnerabilities identified until appropriate patches or security software can be installed. Update policy guidance to account for any newly detected threats.
- Network vulnerability detected: Access to any resource not explicitly allowed by the network access policies should trigger an alert to IT security staff and the relevant workload owner. Track issue and update guidance if policy revision is necessary to mitigate future incidents.

## Next steps

Using the [Cloud Management template](./template.md), document the processes and triggers that align to the current cloud adoption plan.

For guidance on executing cloud management policies in alignment with adoption plans, see the article on [maturity alignment](maturity-adoption-alignment.md).

> [!div class="nextstepaction"]
> [Align Discipline Maturity with Cloud Adoption Phases](./maturity-adoption-alignment.md)
