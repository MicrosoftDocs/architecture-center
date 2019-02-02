---
title: "Large Enterprise – Resource consistency evolution"
description: Large Enterprise – Resource consistency evolution
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Large Enterprise – Resource consistency evolution

This article will evolve the narrative by adding Resource Consistency controls to the Governance MVP to support mission critical apps.

## Evolution of the narrative

The Cloud Adoption team has met all requirements to move protected data. With those applications come SLA commitments to the business and need for IT operation support. Right behind the team migrating the two datacenters, multiple app dev and BI teams are ready to begin launching new solutions into production. IT operations is new to the thought of cloud operations and needs a way to quickly integrate existing operational processes.

### Evolution of current state

- IT is actively moving production workloads with protected data into Azure. A number of low priority workloads are serving production traffic. More can be cut over, as soon as IT Operations signs off on readiness to support the workloads.
- The application development teams are ready for production traffic.
- The BI team is ready to integrate predictions and insights into the systems that run operations for the three business units.

### Evolution of the future state

- IT operations is new to the thought of cloud operations and needs a way to quickly integrate existing operational processes.

The changes to current and future state expose new risks that will require new policy statements.

## Evolution of tangible tisks

**Business Interruption**: There is an inherent risk of any new platform causing interruptions to mission critical business processes. The IT operations team and the teams executing on various cloud adoptions are relatively inexperienced with cloud operations. This increases the risk of interruption and must be mitigated and governed.

This business risk can be expanded into several technical risks:

- Misaligned operational processes might lead to outages that can’t be detected or remediated quickly.
- External intrusion or denial of service attacks might cause a business interruption
- Mission-critical assets might not be properly discovered and therefore not properly operated.
- Undiscovered or mislabeled assets might not be supported by existing operational management processes.
- Configuration of deployed assets might not meet performance expectations.
- Logging might not be properly recorded and centralized to allow for remediation of performance issues.
- Recovery policies may fail or take longer than expected.
- Inconsistent deployment processes might result in security gaps that could lead to data leaks or interruptions.
- Configuration drift or missed patches might result in unintended security gaps that could lead to data leaks or interruptions.
- Configuration might not enforce the requirements of defined SLAs or committed recovery requirements.
- Deployed operating systems or applications might not meet OS and application hardening requirements.
- There is a risk of inconsistency due to multiple teams working in the cloud.

## Evolution of the policy statements

The following changes to policy will help mitigate the new risks and guide implementation. The list looks long, but the adoption of these policies may be easier than it would appear.

1. All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance team and the application owner prior to deployment to the cloud.
2. Subnets containing mission critical applications must be protected by a firewall solution capable of detecting intrusions and responding to attacks.
3. Governance tooling must audit and enforce network configuration requirements defined by the Security Baseline team.
4. Governance tooling must validate that all assets related to mission critical apps or protected data are included in monitoring for resource depletion and optimization.
5. Governance tooling must validate that the appropriate level of logging data is being collected for all mission critical apps or protected data.
6. Governance process must validate that backup, recovery, and SLA adherence are properly implemented for mission critical apps and protected data. 
7. Governance tooling must limit VM deployment to approved images only.
8. Governance tooling must enforce that automatic updates are **prevented** on all deployed assets that support mission critical applications. Violations must be reviewed with operational management teams and remediated in accordance with operations policies. Assets that are not automatically updated must be included in processes owned by IT operations.
9. Governance tooling must validate tagging related to cost, criticality, SLA, application, and data classification. All values must align to predefined values managed by the Cloud Governance team.
10. Governance processes must include audits at the point of deployment and at regular cycles to ensure consistency across all assets.
11. Trends and exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to Security Baseline tooling used in the cloud.
12. Prior to release into production, all mission critical apps and protected data must be added to the designated operational monitoring solution. Assets that cannot be discovered by the chosen IT operations tooling, cannot be released for production use. Any changes required to make the assets discoverable must be made to the relevant deployment processes to ensure assets will be discoverable in future deployments.
13. Upon discovery, asset sizing is to be validated by operational management teams to validate that the asset meets performance requirements.
14. Deployment tooling must be approved by the Cloud Governance team to ensure on-going governance of deployed assets.
15. Deployment scripts must be maintained in central repository accessible by the Cloud Governance team for periodic review and auditing.
16. Governance review processes must validate that deployed assets are properly configure in alignment with SLA and recovery requirements.

## Evolution of the best practices

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

Following the experience of this fictional example, it is assumed that the Protected Data evolution has already happened. Building on that best practice, the following will add operational monitoring requirements, readying a subscription for mission-critical applications.

**Corporate IT Subscription**: Add the following to the Corporate IT subscription, which acts as a hub.

1. As an external dependency, the Cloud Operations team will need to define operational monitoring tooling, Business Continuity/Disaster Recovery (BCDR) tooling and automated remediation tooling. The Cloud Governance team can then support necessary discovery processes.
    1. In this use case, the Cloud Operations team chose Azure Monitor as the primary tool for monitoring mission critical applications.
    2. The team also chose Azure Site Recovery as the primary BCDR tooling.
2. Azure Site Recovery implementation
    1. Define and deploy Azure Vault for backup and recovery processes
    2. Create ARM Template for creation of a Vault in each subscription
3. Azure Monitor implementation
    1. Once a mission critical subscription is identified, a log analytics workspace can be created using PowerShell. This is a pre-deployment process.

**Individual Cloud Adoption Subscription**: The following will ensure that each subscription is discoverable by the monitoring solution and ready to be included in BCDR practices.

1. Azure Policy for mission critical nodes
    1. Audit and enforce use of standard roles only.
    2. Audit and enforce application of encryption for all storage accounts.
    3. Audit and enforce use of approved network subnet and VNet per network interface
    4. Audit and enforce the limitation of user-defined routing tables
    5. Audit and enforce the deployment of Log Analytics agents for Windows and Linux VMs
2. Azure Blueprint
    1. Create a blueprint for “Mission Critical Workloads + Protected Data”. This blueprint will apply assets in addition to the protected data blueprint. 
    2. Add the new Azure Policies to the blueprint
    3. Apply the blueprint to any subscription that is expected to host a mission critical application. 

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with resource governance. Together, they add the recovery, sizing, and monitoring controls necessary to empower cloud-aware operations.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. For the fictitious company in this journey, the next trigger is when the scale of deployment exceeds 1,000 assets to the cloud or monthly spending exceeding $10,000/month. At this point, the Cloud Governance team [adds cost management controls](./cost-control.md).

> [!div class="nextstepaction"]
> [Cost management evolution](./cost-control.md)