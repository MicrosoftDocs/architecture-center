---
title: Remediate security risks in Microsoft Defender for Cloud
description: Remediate the common risks identified by Microsoft Defender for Cloud.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
categories:
  - security
subject:
  - security
  - monitoring
---

# Remediate security risks in Microsoft Defender for Cloud

Security controls must remain effective against attackers who continuously improve their ways to attack the digital assets of an enterprise. Use the principle of drive continuous improvement to make sure systems are regularly evaluated and improved.

Start by remediating common security risks. These risks are usually from well-established attack vectors. This will forces attackers to acquire use advanced and more expensive attack methods.

## Key points

- Processes for handling incidents and post-incident activities, such as lessons learned and evidence retention.
- Remediate the common risks identified by Microsoft Defender for Cloud.
- Track remediation progress with secure score and comparing against historical results.
- Address alerts and take action with remediation steps.

## Track Secure Score

**Do you review and remediate common risks in the workload boundary?**
***

Monitor the security posture of VMs, networks, storage, data services, and various other contributing factors. [Secure Score](/azure/security-center/secure-score-security-controls) in Microsoft Defender for Cloud shows a composite score that represents the security posture at the subscription level.

:::image type="content" source="./images/secure-score-tile.png" alt-text="Azure Secure Score tile" border ="true":::

**Do you have a process for formally reviewing Secure Score on Microsoft Defender for Cloud?**
***

As you review the results and apply recommendations, track the progress and prioritize ongoing investments. Higher score indicates a better security posture.

- Set up a regular cadence (typically monthly) to review the secure score and plan initiatives with specific improvement goals.
- Assign stakeholders for monitoring and improving the score. Gamify the activity if possible to increase engagement and focus from the responsible teams.

As a technical workload owner, work with your organization's dedicated team that monitors Secure Score. In the DevOps model, workload teams may be responsible for their own resources. Typically, these teams are responsible.

- Security posture management team
- Vulnerability management or governance, risk, and compliance team
- Architecture team
- Resource-specific technical teams responsible for improving secure score, as shown in this table.

|Category|Resources|Responsible team|
|---|---|---|
|Compute and applications|App Services|Application Development/Security Team(s) |
||Containers|Application Development and/or Infrastructure/IT Operations|
||Virtual machines, scale sets, compute|IT/Infrastructure Operations|
|Data and Storage|SQL/Redis/Data Lake Analytics/Data Lake Store|Database Team|
||Storage Accounts|Storage/Infrastructure Team|
|Identity and access management|Subscriptions|Identity Team(s)|
||Key Vault|Information/Data Security Team|
|Networking Resources||Networking Team and Network Security Team|
|IoT Security|IoT Resources | IoT Operations Team|

:::image type="icon" source="../../_images/github.png" border="false"::: The [Azure Secure Score sample](https://github.com/mspnp/samples/tree/master/Security/AzureSecureScoreSample) shows how to get your Azure Secure Score for a subscription by calling the Microsoft Defender for Cloud REST API. The API methods provide the flexibility to query the data and build your own reporting mechanism of your secure scores over time.

## Review and remediate recommendations

Microsoft Defender for Cloud monitors the security status of machines, networks, storage and data services, and applications to discover potential security issues. Enable this capability at no additional cost to detect vulnerable virtual machines connected to internet, missing security updates, missing endpoint protection or encryption, deviations from baseline security configurations, missing Web Application Firewall (WAF), and more.

View the recommendations to see the potential security issues and apply the [Microsoft Defender for Cloud recommendations](/azure/security-center/security-center-recommendations) to execute technical remediations.

:::image type="content" source="./images/secure-score.png" alt-text="Azure Secure Score" border ="true":::

The recommendations are grouped by controls. Each recommendation has detailed information such as severity, affected resources, and quick fixes where applicable. Start with high severity items.

Defender for Cloud has the capability of exporting results at configured intervals. Compare the results with previous sets to verify that issues have been remediated.

For more information, see [Continuous export](/azure/security-center/continuous-export).

## Policy remediation

A common approach for maintaining the security posture is through Azure Policy.

Along with organizational policies, a workload owner can use scoped policies for governance purposes, such as check misconfiguration, prohibit certain resource types, and others. The resources are evaluated against rules to identify unhealthy resources that are risky. Post evaluation, certain actions are required as remediation. The actions can be enforced through Azure Policy effects.

For example, a workload runs in an Azure Kubernetes Service (AKS) cluster. The business goals require the workload to run in a highly restrictive environment. As a workload owner, you want the resource group to contain AKS clusters that are private. You can enforce that requirement with the **Deny** effect. It will prevent a cluster from being created if that rule isn't satisfied.

That sort of isolation can be maintained through policies at a higher level such as the subscription level or even management groups.

Another use case is that it can be automatically remediated by deploying related resources. For example, the organization wants all storage resources in a subscription to send logs to a common Log Analytics workspace. If a storage account doesn't pass the policy, a deployment is automatically started as remediation. That remediation can be enforced through **DeployIfNotExist**. There are some considerations.

- There's a significant wait before the resource is updated and the deployment starts. In the preceding example, there won't be logs captured during that wait time. Avoid using this effect for resources that cannot tolerate a delay.
- The resource deployed because of **DeployIfNotExist** are created by a separate identity than that of the identity that did the original deployment. That identity must have high enough privileges to make the required changes.

## Manage alerts

Microsoft Defender for Cloud shows a list of alerts that's based on logs collected from resources within a scope. Alerts include context information such as severity, status, activity time. Most alerts have MITRE ATT&CK® tactics that can help you understand the kill chain intent. Select the alert and investigate the problem with detailed information.

Finally take action. That action can be to fix the resources that are out of compliance with actionable remediation steps. You can also suppress alerts that are false positives.

Make sure that you are integrating critical security alerts into Security Information and Event Management (SIEM), Security Orchestration Automated Response (SOAR) without introducing a high volume of low value data. Microsoft Defender for Cloud can stream alerts to Microsoft Sentinel. You can also use a third-party solution by using Microsoft Graph Security API.

## Next

> [!div class="nextstepaction"]
> [Azure security operations](monitor-security-operations.md)

## Related links

> Go back to the main article: [Monitor](monitor.md)
