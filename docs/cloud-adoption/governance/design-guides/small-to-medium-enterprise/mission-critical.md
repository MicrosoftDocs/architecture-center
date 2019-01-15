---
title: "Fusion: Small to Medium Enterprise – Resource Management Evolution "
description: Explanation Small to Medium Enterprise – Governance - Adding Missions Critical Applications
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Small to Medium Enterprise – Resource Management Evolution

This article will evolve the narrative by adding resource management controls to the [Governance MVP](./governance-mvp.md) to support mission critical apps.

Jump to [Narrative Changes](#narrative-changes) | [Corporate Policy Changes](#corporate-policy) | [Technical Changes](#technical-changes)

## Narrative Changes

New customer experiences, new predictions tools, and migrated infrastructure continue to progress. The business is now ready to begin using those assets in a production capacity.

### Current State Changes

* IT has retired 100% of the DR datacenter, ahead of schedule. In the process a number of assets in the Prod datacenter were identified as cloud migration candidates.
* The application development teams have is ready for production traffic.
* The BI team is ready to feed predictions and insights back into operation systems in the Prod datacenter.

### Future State Changes

* Before using Azure deployments in production business processes, cloud operations must mature. In conjunction, an additional governance evolution is required to ensure assets can be operated properly.

## Corporate Policy

The changes to current and future state expose new risks that will require new policy statements.

### New Risks

**Business Interruption:** There is an inherent risk of any new platform causing interruptions to mission critical business processes. The IT operations team and the teams executing on various cloud adoptions are relatively inexperienced with cloud operations. This increases the risk of interruption and must be mitigated and governed.

This business risk can be expanded into a number of technical risks

* There is a risk of external intrusion or denial of service attacks causing a business interruption
* There is a risk of mission critical assets not being properly discovered and therefore not being properly operated
* There is a risk of undiscovered or mislabeled assets not being supported by existing operational management processes
* There is a risk that configuration of deployed assets won't meet performance expectations
* There is a risk that logging won't be properly recorded and centralized to allow for remediation of performance issues
* There is a risk that recovery policies may fail or take longer than expected
* There is a risk that inconsistent deployment processes will result in security gaps that could lead to data leaks or interruptions
* There is a risk that configuration drift or missed patches will result in unintended security gaps that could lead to data leaks or interruptions
* There is a risk that configuration won't enforce the requirements of defined SLAs
* There is a risk that configuration won't support committed recovery requirements
* There is a risk that deployed operating systems (OS) or applications won't meet OS and App hardening requirements
* There is a risk of inconsistency with so many teams working in the cloud.

### New Policy Statements

The following changes to policy will help mitigate the new risks and guide implementation. The list looks long, but the adoption of these policies may be easier than it would appear.

1. All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance Team and the application owner prior to deployment to the cloud
2. Subnets containing mission critical applications must be protected by a firewall solution capable of detecting intrusions and responding to attacks
3. Governance tooling must audit and enforce network configuration requirements defined by the security management team
4. Governance tooling must validate that all assets related to mission critical apps or protected data are included in monitoring for resource depletion and optimization
5. Governance tooling must validate that the appropriate level of logging data is being collected for all mission critical apps or protected data
6. Governance process must validate that backup, recovery, and SLA adherence are properly implemented for mission critical apps and protected data
7. Governance tooling must limit VM deployment to approved images only
8. Governance tooling must enforce that automatic updates are prevented on all deployed assets that support mission critical applications. Violations must be reviewed with operational management teams & remediated in accordance with operations policies. Assets that are not automatically updated must be included in processes owned by IT operations.
9. Governance tooling must validate tagging related to cost, criticality, SLA, application, and data classification. All values must align to predefined values managed by the governance team
10. Governance processes must include audits at the point of deployment and at regular cycles to ensure consistency across all assets
11. Trends and exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to security management tooling used in the cloud.
12. Prior to release into production, all mission critical apps and protected data must be added to the designated operational monitoring solution. Assets that can not be discovered and monitored can not be released for production use. Any changes required to make the assets discoverable must be made to the relevant deployment processes to ensure asset(s) will be discoverable in future deployments.
13. Upon discovery, asset sizing is to be validated by operational management teams to validate that the asset meets performance requirements
14. Deployment tooling must be approved by the Cloud Governance Team to ensure on-going governance of deployed assets
15. Deployment scripts must be maintained in central repository accessible by the Cloud Governance Team for periodic review and auditing
16. Governance review processes must validate that deployed assets are properly configure in alignment with SLA and recovery requirements

### New Processes

Some of the policy statements can’t/shouldn’t be controlled by automated tooling. Other policies will result in effort from IT Security and Cloud Operations teams, over time. As such, the Cloud Governance Team will need to oversee the following processes to implement the last six policy statements:

**Corporate Policy Changes:** The Cloud Governance Team will make a number of changes to the Governance MVP design to adopt the new policies. The value of the Governance MVP, is that it will allow for the automatic enforcement of the new policies.

**Adoption Acceleration:** The cloud governance team has been reviewing deployment scripts across multiple teams. They've maintained a set of scripts that serve as deployment templates. Those templates are used by the cloud adoption teams and devops teams to more quickly define deployments. Each of those scripts contain the necessary requirements to enforce a number of governance policies, with no additional effort from cloud adoption engineers. As the curators of these scripts they can more quickly implement policy changes. Additionally, they are seen as a source of adoption acceleration. This creates consistency among deployments, without strictly forcing adherence.

**Engineer Training:** The Cloud Governance Team offers bi-monthly training sessions and has created two videos for engineers. Both of these sources help engineers quickly get up to speed on the governance culture and how things are done during deployments. The team is adding training assets to demonstrate the difference between production and non-production deployments, to help engineers understand how the new policies will affect adoption. This creates consistency among deployments, without strictly forcing adherence.

**Deployment Testing:** During deployment testing for any asset supporting a mission critical workload, the Cloud Operations Team and Cloud Governance Team will be responsible for reviewing deployed assets to validate governance and operations alignment.

**Monthly Audit and Reporting:** Each month, the Cloud Governance Team runs an audit of all cloud deployments to validate continued alignment to policy. When deviations are discovered, they are documented and shared with the cloud adoption teams. When enforcement doesn't risk a business interruption or data leak, the policies are automatically enforced. At the end of the audit, the Cloud Governance Team compiles a report for the Cloud Strategy Team and each Cloud Adoption Team to communicate overall adherence to policy. The report is also stored for auditing and legal purposes.

**Quarterly Policy Review:** Each quarter, the Cloud Governance Team and Cloud Strategy Team to review audit results and suggest changes to corporate policy. Many of those suggestions are the result of continuous improvements and the observation of usage patterns. Approved policy changes are integrated into governance tooling during subsequent audit cycles.

## Technical Changes

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

### Design Evolution Overview

1) Cloud operations to define operational monitoring tooling and automated remediation tooling. Cloud Governance Team to support those discovery processes.
    a. In this use case, the Cloud Operations Team chose Azure Monitor as the primary tool for monitoring mission critical applications.
2) Azure DevOps repository creation
    a. Create a repository in Azure Devops to store and version all relevant ARM templates and scripted configurations
3) Azure Site Recovery implementation
    a. Define and deploy Azure Vault for backup and recovery processes
    b. Create ARM Template for creation of a Vault in each subscription
    c. Include the ARM template in the Azure Blueprint for deployment in each mission critical subscription
4) Update Azure Policy for all subscriptions
    a. Audit & enforce criticality and data classification across all subscriptions to identify any subscriptions with mission critical assets
    b. Audit & enforce use of approved images only 
5) Azure Monitor implementation
    a. Once a mission critical subscription is identified, a workspace can be created using powershell. This is a pre-deployment process.
    b. During deployment testing, the Cloud Operations team would deploy the necessary agents and test discovery.
6) Update Azure Policy for all subscriptions that contains mission critical applications.
    a. Audit & enforce the application of an NSG to all NICS and subnets. Networking and IT Security to define the NSG
    b. Audit & enforce use of approved network subnet and vNet per network interface
    c. Audit & enforce the limitation of user-defined routing tables
    d. Audit & enforce Azure Firewall configuration. Networking and IT Security to define the firewall configuration
    e. Audit & enforce deployment of Azure Monitor agents for all VMs and applications.
    f. Audit & enforce Azure Vault configuration for each asset

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with resource governance. Together, they add the recovery, sizing, and monitoring controls necessary to empower cloud-aware operations.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. The following are a few evolutions that may be experienced in the future.

* [Security Management](./protected-data.md): Inclusion of protected data in defined cloud adoption plans
* [Cost Management](cost-control.md): Scale of deployment exceeds 100 assets to the cloud or Monthly spend exceeding $1,00/month
* [Multi-Cloud Governance](multi-cloud.md): Leveraging this governance investment to manage multiple clouds