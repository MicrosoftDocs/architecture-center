---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Explanation of the concept security management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/3/2019
---

# Fusion: Metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to security management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Security Management discipline.

## Metrics 

Security management generally focuses on identifying potential vulnerabilities in your cloud deployments. The following are a few common pieces of data that are useful in this discipline of cloud governance:

- **Data classification**. Number of cloud-stored data and services that are unclassified according to on your organization's privacy, compliance, or business impact standards.
- **Attack surface**. How many total data sources, services, and applications will be cloud-hosted. What percentage of these data sources are classified as sensitive? What percentage of these applications and services are mission critical?
- **Network attacks**. How many coordinated attempts to disrupt your cloud-hosted services, such as through Distributed Denial of Service (DDoS) attacks, does your infrastructure experience? What is the size and severity of the attacks?
- **Malware protection**. Percentage of deployed virtual machines(VMs) that have all required anti-malware, firewall, or other security software installed.
- **Patch latency**. How long has it been since VMs have had OS and software patches applied.

Metrics to think about from Security Center:

* Covered Standards - Number of security standards defined by the Security team
* Overall Compliance - Ratio of compliance adherence to security standards
* Covered Resources - Deployed assets that are covered by the standards
* Recommendations by Severity - Number of recommendations to resolve health standards for deployed assets by severity
* Attacks by Severity - Number of attacks on deployed assets by severity of attack alert
* Number of Protected Data Stores - Number of storage end points or databases that should be encrypted
* Number of Un-encrypted Data Stores - Number of Protected Data Stores not encrypted


## Risk tolerance indicators

Cloud platforms provide a baseline set of features that enable small deployment teams to configure basic security settings without extensive additional planning. As a result, small Dev/Test or experimental first workloads that do not include sensitive data represent a relatively low level of risk, and will likely not need much in the way of formal security management policy. However, as soon as important data or mission-critical functionality is moved to the cloud, security risks increase, while tolerance for those risks diminishes rapidly. As more of your data and functionality is deployed to the cloud, the more likely you need an increased investment in the Security Management discipline.

In the early stages of cloud adoption, work with your business to determine a baseline for security risk tolerance. Once you have a baseline, you will need to determine the criteria that would trigger an increased investment in security management. This may be different with every company or deployment.

 Work with your business to identify [business risks](business-risks.md), then establish benchmarks that you can use to define triggers representing a potential increase in those risks. Use triggers to identify when you need to take action to address risk. The following are a few examples of how security metrics and identified vulnerabilities, such as those discussed above, can justify an increased investment in the security management discipline.

- **Sensitive data**. A company hosting data on the cloud that can be classified as confidential, private, or otherwise subject to regulatory concerns. They need a security management discipline to ensure that this data is not subject to loss, exposure, or theft.
- **Cloud estate size**. A company hosting more than X number of applications, services, or data sources. Large cloud deployments require the security management discipline to ensure that their overall attack surface is properly protected against unauthorized access or other external threats.
- **Mission critical workloads**. A company deploying mission critical workloads to the cloud should invest in the security management discipline to prevent potential disruption of service or sensitive data exposure.
- **External attacks**. A company that experiences serious attacks against their network infrastructure X times per month could benefit from the security management discipline.  
- **Security software compliance**. A company that has required security software installed on less than X% of deployed virtual machines. A security management discipline can be used to ensure software is installed consistently on all software.
- **Patching**. A company where deployed virtual machines or services where OS or software patches have not been applied in the last X number of days. A security management discipline can be used to ensure patching is kept up-to-date within a required schedule.
- **Security focused**. Some companies will have strong security and data confidentiality requirements even for test and experimental workloads. These companies will need to invest in the security management discipline before any deployments can begin.


## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating security policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Monitor and Enforce Policy Statements](./processes.md)
