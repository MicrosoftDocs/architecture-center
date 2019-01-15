---
title: "Fusion: Small to Medium Enterprise – Security Management Evolution"
description: Explanation Small to Medium Enterprise – Security Management Evolution
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Small to Medium Enterprise – Security Management Evolution

This article will evolve the narrative by adding security controls to the [Governance MVP](./governance-mvp.md), to allow for the hosting of protected data.

Jump to [Narrative Changes](#narrative-changes) | [Corporate Policy Changes](#corporate-policy) | [Technical Changes](#technical-changes)

## Narrative Changes

IT and business leadership have been happy with results from early stage experimentation by IT, App Dev, and BI teams. To realize tangible business values from these experiments, those teams must be allowed to integrate protected data into solutions. This has trigger changes to corporate policy but will also require an evolution of the cloud governance implementations before protected data can land in the cloud.

## Cloud Adoption Team Changes

Given the impact of the changing narrative & support provided so far, the Cloud Governance Team is now viewed differently. The two system admins who started the team are now viewed as experienced Cloud Architects. As this narrative develops they will move from the Cloud Custodian perception, to more of a Cloud Guardian role.

## Current State Changes

* The application development team has implemented a CI/CD pipeline to deploy a cloud native application with an improved user experience. That app doesn’t yet interact with protected data, so it is not production ready.
* The BI team actively curates logistics, inventory, and third party data in the cloud to drive new predictions which could shape business processes. However, those predictions and insights are actionable until customer and financial data can be integrated into the data platform.
* The IT team is progressing on the CIO and CFO's plans to retire the DR data center. More than 1,000 of the 2,000 assets in the DR data center have been retired or migrated.
* The loosely defined policies regarding PII and financial data have been modernized. However, the new corporate policies are contingent upon the implementation of related security and governance policies. Teams are still stalled

## Future State Changes

* Early experiments from App Dev and BI have shown potential improvements in customer experiences and data-driven decisions. Both teams would like to expand adoption of the cloud over the next 18 months by deploying those solutions to production. 
* During the 6 months left in the plan, the team will implement security and governance requirements to allow them to migrate the protected data in that data centers. 
* Quickly implement security and governance requirements to allow each team to move forward.

## Corporate Policy

The changes to current and future state expose new risks that will require new policy statements.

## New Risks

**Data Breach:** There is an inherent increase in liabilities related to data breaches when adopting any new data platform. Technicians adopting cloud technologies have increased responsibilities to implement solutions which can decrease this risk. A robust security and governance strategy must be implemented to ensure those technicians fulfill those responsibilities.

This business risk can be expanded into a few technical risks

* There is a risk of mission critical apps or protected data being deployed unintentionally
* There is a risk of protected data being exposed during storage due to poor encryption decisions
* There is a risk of unauthorized users accessing protected data
* There is a risk of external intrusion resulting in access to protected data
* There is a risk of external intrusion or denial of service attacks causing a business interruption
* There is a risk of organization or employment changes allowing for unauthorized access to protected data
* There is a risk of new exploits producing intrusion or access opportunities
* There is a risk that inconsistent deployment processes will result in security gaps that could lead to data leaks or interruptions
* There is a risk that configuration drift or missed patches will result in unintended security gaps that could lead to data leaks or interruptions
* There is a risk that inconsistent deployment processes will result in security gaps that could lead to data leaks or interruptions
* There is a risk that configuration drift or missed patches will result in unintended security gaps that could lead to data leaks or interruptions

## New Policy Statements

The following changes to policy will help mitigate the new risks and guide implementation. The list looks long, but the adoption of these policies may be easier than it would appear.

1) All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance Team and the application owner prior to deployment to the cloud
2) All protected data must be encrypted when at rest
3) Elevated permissions in those subscriptions are an exception. Any such exceptions will be recorded with the Cloud Governance Team. Such exceptions will be audited regularly
4) Network subnets containing protected data must be isolated from any other subnets. Network traffic between protected data subnets is to be audited regularly
5) No subnet containing protected data can be directly accessed over public internet or across data centers. Access to those subnets must be routed through intermediate subnet works. All access into those subnets must come through a firewall solution capable of performing packet scanning and blocking functions
6) Governance tooling must audit and enforce network configuration requirements defined by the security management team
7) Governance tooling must limit VM deployment to approved images only
8) Governance tooling must enforce that automatic updates are enabled on all deployed assets. Violations must be reviewed with operational management teams & remediated in accordance with operations policies. Assets that are not automatically updated must be included in processes owned by IT operations.
9) Creation of new subscriptions or management groups for any mission critical applications or protected data will require a review from the Cloud Governance Team to ensure proper blueprint assignment
10) A least privilege access model is to be applied to any subscription that contains mission critical apps or protected data
11) Trends and exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to security management tooling used in the cloud.
12) Deployment tooling must be approved by the Cloud Governance Team to ensure on-going governance of deployed assets
13) Deployment scripts must be maintained in central repository accessible by the Cloud Governance Team for periodic review and auditing
14) Governance processes must include audits at the point of deployment and at regular cycles to ensure consistency across all assets
15) Deployment of any applications that require customer authentication must use an approved identity provider that is compatible with the primary identity provider for internal users
16) Cloud Governance processes must include quarterly review with identity management teams to identify malicious actors or usage patterns that should be prevented by cloud asset configuration

## New Processes

Some of the policy statements can’t/shouldn’t be controlled by automated tooling. Other policies will result in effort from IT Security and on-prem Identity Management teams, over time. As such, the Cloud Governance Team will need to oversee the following processes to implement the last eight policy statements:

**Corporate Policy Changes:** The Cloud Governance Team will make a number of changes to the Governance MVP design to adopt the new policies. The value of the Governance MVP, is that it will allow for the automatic enforcement of the new policies.

**Adoption Acceleration:** The cloud governance team has been reviewing deployment scripts across multiple teams. They've maintained a set of scripts that serve as deployment templates. Those templates are used by the cloud adoption teams and devops teams to more quickly define deployments. Each of those scripts contain the necessary requirements to enforce a number of governance policies, with no additional effort from cloud adoption engineers. As the curators of these scripts they can more quickly implement policy changes. Additionally, they are seen as a source of adoption acceleration. This creates consistency among deployments, without strictly forcing adherence.

**Engineer Training:** The Cloud Governance Team offers bi-monthly training sessions and has created two videos for engineers. Both of these sources help engineers quickly get up to speed on the governance culture and how things are done during deployments. The team is adding training assets to demonstrate the difference between production and non-production deployments, to help engineers understand how the new policies will affect adoption. This creates consistency among deployments, without strictly forcing adherence.

**Deployment Planning:** Prior to deployment of any asset containing protected data, the Cloud Governance Team will be responsible for reviewing deployment scripts to validate governance alignment. Existing teams with previously approved deployments will be audited using programmatic tooling.

**Monthly Audit and Reporting:** Each month, the Cloud Governance Team runs an audit of all cloud deployments to validate continued alignment to policy. When deviations are discovered, they are documented and shared with the cloud adoption teams. When enforcement doesn't risk a business interruption or data leak, the policies are automatically enforced. At the end of the audit, the Cloud Governance Team compiles a report for the Cloud Strategy Team and each Cloud Adoption Team to communicate overall adherence to policy. The report is also stored for auditing and legal purposes.

**Quarterly Policy Review:** Each quarter, the Cloud Governance Team and Cloud Strategy Team to review audit results and suggest changes to corporate policy. Many of those suggestions are the result of continuous improvements and the observation of usage patterns. Approved policy changes are integrated into governance tooling during subsequent audit cycles.

## Technical Changes

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

### Design Evolution Overview

1) Networking and IT security to define Network requirements. Governance to support the conversation.
2) Identity and IT security to define Identity requirements and make any necessary changes to local Active Directory implementation. Governance to review changes.
3) Azure DevOps repository creation
    a. Create a repository in Azure Devops to store and version all relevant ARM templates and scripted configurations
4) Azure Security Center implementation
    a. Configure Azure Security Center for any Management Group that contains protected data classifications
    b. Set Automatic provisioning to on by default
    c. Establish OS security configurations. IT Security to define the configuration
    d. Support IT Security in the initial use of Azure Security Center. Transition use of security center to IT security, but maintain access for governance continuous improvement purposes
    e. Create an ARM Template for reference in the Azure Blueprint to ensure Azure Security Center configuration are applied to all subscriptions containing protected data.
5) Update Azure Policy for all subscriptions
    a. Audit & enforce criticality and data classification across all subscriptions to identify any subscriptions with protected data classifications
    b. Audit & enforce use of approved images only
6) Update Azure Policy for all subscriptions that contains protected data classifications.
    a. Audit & enforce use of standard roles only
    b. Audit & enforce application of encryption for all files and accounts 
    c. Audit & enforce the application of an NSG to all NICS and subnets. Networking and IT Security to define the NSG
    d. Audit & enforce use of approved network subnet and vNet per network interface
    e. Audit & enforce the limitation of user-defined routing tables
    f. Audit & enforce Azure Firewall configuration. Networking and IT Security to define the firewall configuration

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with security governance. Together, they add the network, identity, and security monitoring tools needed to protect data.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. The following are a few evolutions that may be experienced in the future.

* [Resource Management](./mission-critical.md): Deployment of mission critical workloads
* [Cost Management](cost-control.md): Scale of deployment exceeds 100 assets to the cloud or Monthly spend exceeding $1,00/month
* [Multi-Cloud Governance](multi-cloud.md): Leveraging this governance investment to manage multiple clouds