---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Explanation of the concept security management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/3/2019
---

# Fusion: Metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to security management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Security Management discipline.

## Metrics and security information

Security management generally focuses on identifying potential vulnerabilities in your cloud deployments. The following are a few common pieces of data that are useful in this discipline of cloud governance:

- Data classification: List of cloud-stored data that is unclassified according to on your organization's privacy, compliance, or business impact standards.
- Attack surface: inventory of all IP addresses, ports, and services on your virtual network that are externally accessible.
- Network activity: Expected vs actual traffic levels and activities.
- Virtual machine (VM) protection: Percentage of deployed virtual machines that have all required anti-malware, firewall, or other security software installed.
- Patch latency: How long has it been since VMs have had OS and software patches applied.

## Risk tolerance indicators

Cloud platforms provide a baseline set of features that enable small deployment teams to configure basic security settings without extensive additional planning. As a result, small Dev/Test or experimental first workloads that do not include sensitive data represent a relatively low level of risk, and will likely not need much in the way of formal security management policy. However, as soon as important data or mission-critical functionality is moved to the cloud, security risks increase, while tolerance for those risks diminishes rapidly. As more of your data and functionality is deployed to the cloud, the more likely you need an increased investment in the Security Management discipline.

In the early stages of cloud adoption, work with your business to determine a baseline for security risk tolerance. Once you have a baseline, you will need to determine the criteria that would trigger an increased investment in security management. This may be different with every company or deployment.

The following are a few examples of how security metrics and identified vulnerabilities, such as those discussed above, can justify an increased investment in security management. Once you have identified [business risks](business-risks.md), you will work with your business to identify benchmarks that you can use to define triggers that could potentially increase those risks.

- Sensitive data: A company hosting data on the cloud that can be classified as confidential, private, or otherwise subject to regulatory concerns. They need a security management discipline to ensure that this data is not subject to loss, exposure, or theft.
- Publicly accessible workloads: A company hosting applications or services accessible over the internet. A security management discipline is needed to ensure that their network attack surface is properly protected against unauthorized access or other external threats.
- Network activity trigger: A company that experiences increases of network traffic X% over expected load. While there are other potential causes of large-scale traffic increases, this scenario can also be the sign of external DDoS attacks intended to disrupt services, or compromised VMs within the cloud acting as part of a botnet attack. The security management discipline can be used to anticipate and mitigate these threats.
- Software compliance trigger: A company that has required security software installed on less than X% of deployed virtual machines. A security management discipline can be used to ensure software is installed consistently on all software.
- Patching trigger: A company has deployed virtual machines or services where OS or software patches have not been deployed in the last X number of days.  A security management discipline can be used to ensure patching is kept up-to-date within a required schedule.
- Security focused: Some companies will have strong security and data confidentiality requirements even for test and experimental workloads. These companies will need to invest in the security management discipline before any deployments can begin.


## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating security policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Monitor and Enforce Policy Statements](./processes.md)
