---
title: "Fusion: Governance Design Guide Enterprise Guardrails"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Corporate Policies behind the Enterprise Guardrails Governance Design Guide

This article outlines the corporate policies which drive the [Enterprise Guardrails - Governance Design Guide](./design-guide.md). The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company in this use case is preparing to deploy production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business can now justify investing additional time and energy in cloud governance. That investment is defined by the corporate policies outlined in this article. These policies are dependent upon the business scenario described in the [Enterprise Guardrails - Use Case](./use-case.md).

## Required understanding

This corporate policy builds on the design guide, corporate policy, and use case outlined in the Enterprise MVP - Governance Design Guide. See the [References](#references) at the end of this document for additional background on that design guide. Implementation of the Enterprise Guardrails design guide assumes that the foundation defined in the Enterprise MVP design guide has been implemented. Review the checklist on that design guide before proceeding with this design guide.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader of this design guide. It is simply a starting point to be customized and refined, as needed. After reviewing the use case, see the [References](#references) at the end of this article for guidance on personalizing this guide.

## Corporate Policy supporting this use case

Based on the Enterprise Guardrails Use Case, the following is a set of sample corporate policy statements synthesized from similar customer experiences.

## Business Risks

Experimentation on most platforms creates relatively low risks. Moving from experimentation to Enterprise Guardrailss increase that risk. When those workloads are mission critical or contain protected data, the risks are even higher. This evolution is true with any technology platform. The cloud is no exception in this regard.

As the company defined in the use case evolves their cloud adoption, the following business risks have been clearly identified:

**Business Interruption**: There is an inherent risk of any new platform causing interruptions to mission critical business processes. The IT operations team and the teams executing on various cloud adoptions are relatively inexperienced with cloud operations. This increases the risk of interruption and must be mitigated and governed.

**Data Breach**: There is an inherent increase in liabilities related to data breaches when adopting any new data platform. Technicians adopting cloud technologies have increased responsibilities to implement solutions which can decrease this risk. A robust security and governance strategy must be implemented to ensure those technicians fulfill those responsibilities.

### Technical Risks

These business risks can be more granularly articulated in the form of technical risks. To allow for bucketing of each risk, they are categorized across the five cloud governance disciplines (See [References](#references) section at the end of this article for more details on the five disciplines of governance.)

While the changes in the use case from Enterprise MVP to Enterprise Guardrails are minor, the risks quickly grow. Fortunately, the chosen cloud provider can automatically mitigate some of these risks, as part of the cloud platform. Additionally, the foundation established in the Enterprise MVP guidance will allow for expeditious mitigation of these risks. While the list is long, the resolution is manageable with a proper strategy.

**Cost Management**:

* No new risks regarding cost have been identified in the changes to the use case

**Security Management**:

* There is a risk of mission critical apps or protected data being deployed unintentionally
* There is a risk of protected data being exposed during storage due to poor encryption decisions
* There is a risk of unauthorized users accessing protected data
* There is a risk of external intrusion resulting in access to protected data
* There is a risk of external intrusion or denial of service attacks causing a business interruption
* There is a risk of organization or employment changes allowing for unauthorized access to protected data
* There is a risk of new exploits producing intrusion or access opportunities
* The cyber security team insists there is a risk of vendor lock-in generating encryption keys on a single cloud provider's platform. *While this claim is unsubstantiated, it was accepted by the team for the time being.*

**Resource Management**:

* There is a risk of mission critical assets not being properly discovered and therefore not being properly operated
* There is a risk of undiscovered or mislabeled assets not being supported by existing operational management processes
* There is a risk that configuration of deployed assets won't meet performance expectations
* There is a risk that logging won't be properly recorded and centralized to allow for remediation of performance issues
* There is a risk that recovery policies may fail or take longer than expected

**Configuration Management**:

* There is a risk that inconsistent deployment processes will result in security gaps that could lead to data leaks or interruptions
* There is a risk that configuration drift or missed patches will result in unintended security gaps that could lead to data leaks or interruptions
* There is a risk that configuration won't enforce the requirements of defined SLAs
* There is a risk that configuration won't support committed recovery requirements
* There is a risk that deployed operating systems (OS) or applications won't meet OS and App hardening requirements
* There is a risk of inconsistency with so many teams working in the cloud.

**Identity Management**:

* There is a risk that multiple identity stores could result in poorly executed identity policies
* There is a risk that the permissions applied to on-prem groups could be improperly applied to roles in the cloud
* There is a risk that cloud identities could be granted more access than is required
* There is a risk of applications using disparate identity stores could compromise customer identities
* There is a risk of malicious actors compromising security requirements

In a real-world scenario, there are likely to be many additional business risks or technical risks worth noting at this stage of adoption. The articles outlined in the [References](#references) section at the end of this article can aid in identifying additional risks.

## Policy Statements

The following policy statements establish requirements to mitigate the defined risks. To understand options and better align the 5 disciplines of cloud governance, see the links to each discipline in the [References](#references) section at the end of this document.

> [!CAUTION]
> Addition policies are required to define and implement security, operations, devops, and identity requirements. The following policy statements define the Cloud Governance Team's responsibilities to ensure the requirements from those teams are properly enforced.

**Cost Management**:

* No additional cost management policy statements have been added

**Security Management**:

* All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance Team and the application owner prior to deployment to the cloud
* All protected data must be encrypted when at rest
* Encryption keys are to be generated on-prem
* Elevated permissions in those subscriptions are an exception. Any such exceptions will be recorded with the Cloud Governance Team. Such exceptions will be audited regularly
* Network subnets containing protected data must be isolated from any other subnets. Network traffic between protected data subnets is to be audited regularly
* No subnet containing protected data can be directly accessed over public internet or across data centers. Access to those subnets must be routed through intermediate subnet works. All access into those subnets must come through a firewall solution capable of performing packet scanning and blocking functions
* Subnets containing mission critical applications must be protected by a firewall solution capable of detecting intrusions and responding to attacks
* A least privilege access model is to be applied to any subscription that contains mission critical apps or protected data
* Identities with permissions on mission critical or protected data solutions must be synchronized with the primary identity provider to ensure changes in the organization are accurately reflected in user authorization requests
* Trends and exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to security management tooling used in the cloud.
* Governance tooling must audit and enforce network configuration requirements defined by the security management team

**Resource Management**:

* Prior to release into production, all mission critical apps and protected data must be added to the designated operational monitoring solution. Assets that can not be discovered and monitored can not be released for production use. Any changes required to make the assets discoverable must be made to the relevant deployment processes to ensure asset(s) will be discoverable in future deployments.
* Upon discovery, asset sizing is to be validated by operational management teams to validate that the asset meets performance requirements
* Governance tooling must validate that all assets related to mission critical apps or protected data are included in monitoring for resource depletion and optimization
* Governance tooling must validate that the appropriate level of logging data is being collected for all mission critical apps or protected data
* Governance process must validate that backup, recovery, and SLA adherence are properly implemented for mission critical apps and protected data

**Configuration Management**:

* Deployment tooling must be approved by the Cloud Governance Team to ensure ongoing governance of deployed assets
* Deployment scripts must be maintained in central repository accessible by the Cloud Governance Team for periodic review and auditing
* Governance tooling must limit VM deployment to approved images only
* Governance tooling must enforce that automatic updates are enabled on all deployed assets. Violations must be reviewed with operational management teams & remediated in accordance with operations policies. Assets that are not automatically updated must be included in processes owned by IT operations.
* Governance review processes must validate that deployed assets are properly configure in alignment with SLA and recovery requirements
* Governance tooling must validate tagging related to cost, criticality, SLA, application, and data classification. All values must align to predefined values managed by the governance team
* Governance processes must include audits at the point of deployment and at regular cycles to ensure consistency across all assets

**Identity Management**:

* Creation of new subscriptions or management groups for any mission critical applications or protected data will require a review from the Cloud Governance Team to ensure policy assignment and proper identity provider assignment
* Deployment of any applications that require customer authentication must use an approved identity provider that is compatible with the primary identity provider for internal users
* Cloud Governance processes must include quarterly review with identity management teams to identify malicious actors or usage patterns that should be prevented by cloud asset configuration

The above policy statements are based on the synthesized use case. See the article on [developing policy statements](../../policy-compliance/define-policy.md) for additional guidance on crafting unique policy statements.

## Monitoring and Enforcement Processes

Many of the policies required by this use case can be implemented with tools and audited programmatically. However, there are a number of processes that will require human involvement. Since governance has inherent dependencies on security, operations, devops, and identity management teams, many of these processes are designed to ensure continuous evolution of the governance strategy. The following is one example of processes that could executed by a small team of people supporting cloud governance.

The two systems administrators who were responsible for establishing the Enterprise MVP foundation have evolved with the company. They are now dedicated to governance full time. In addition, their virtual team referred to as the Cloud Governance Team now includes lead architects from security, operations, devops, and identity teams. Together, they define implementations that fulfill the policies established by the CIO. Initially, these team members were referred to as Cloud Custodians because they were constantly cleaning up deployments. Now IT looks to them as Cloud Guardians and a source of adoption acceleration.

**Corporate Policy Changes:** The Cloud Governance Team has reviewed the new policy statements. Those led to a number of changes to the governance templates (Azure Policies) implemented from the Enterprise MVP Design Guide. For details on the implementation of the policy changes, see the [Enterprise Guardrails Design Guide](./design-guide.md). The previous tooling will allow for the automatic enforcement of the new policies during the monthly audit.

**Adoption Acceleration:** The "cloud governance team" has been reviewing deployment scripts across multiple teams. They've maintained a set of scripts that serve as deployment templates. Those templates are used by the cloud adoption teams and devops teams to more quickly define deployments. Each of those scripts contain the necessary requirements to enforce a number of governance policies, with no additional effort from cloud adoption engineers. As the curators of these scripts they can more quickly implement policy changes. Additionally, they are seen as a source of adoption acceleration.

**Engineer Training:** The Cloud Governance Team offers bi-monthly training sessions and has created two videos for engineers. Both of these sources help engineers quickly get up to speed on the governance culture and how things are done during deployments. The team is adding training assets to demonstrate the difference between production and non-production deployments, to help engineers understand how the new policies will affect adoption.

**Deployment Planning:** Prior to deployment of any asset, the Cloud Governance Team is responsible for reviewing deployment scripts to validate governance alignment. When the new corporate policies go into affect, the commitment from the team is that they will review mission critical apps and protected data deployments manually. All other deployments will be reviewed for new teams. Existing teams with previously approved deployments will be audited using programmatic tooling.

**Monthly Audit and Reporting:** Each month, the Cloud Governance Team runs an audit of all cloud deployments to validate continued alignment to policy. When deviations are discovered, they are documented and shared with the cloud adoption teams. When enforcement doesn't risk a business interruption or data leak, the policies are automatically enforced. At the end of the audit, the Cloud Governance Team compiles a report for the Cloud Strategy Team and each Cloud Adoption Team to communicate overall adherence to policy. The report is also stored for auditing and legal purposes.

**Quarterly Policy Review:** Each quarter, the Cloud Governance Team and Cloud Strategy Team to review audit results and suggest changes to corporate policy. Many of those suggestions are the result of continuous improvements and the observation of usage patterns. Approved policy changes are integrated into governance tooling during subsequent audit cycles.

The suggested processes are designed to create guard rails and provide continuous governance for the synthesized use case. Depending on the time and investment in a Cloud Governance Team, the level of processes are likely to vary for each organization implementing this design guide.

## References

### This Design Guide (Enterprise Guardrailss)

The corporate policy in this article supports the [Enterprise Guardrails - Governance Design Guide](./design-guide.md). The design guide and the policies in this document are means of supporting the business needs and risks outlined in the [Enterprise Guardrails - Use Case](./use-case.md)

### Enterprise MVP Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Enterprise MVP Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Enterprise MVP - Use Case](../future-proof/use-case.md)**: The use case that drives the Enterprise MVP design guide.
**[Enterprise MVP - Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Enterprise MVP - Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Enterprise MVP Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](./use-case.md) and the policy statements listed above.
Once validated, it's time to review and implement the [Enterprise Guardrails - Governance Design Guide](./design-guide.md)

> [!div class="nextstepaction"]
> [Review and implement the Enterprise Guardrails Governance Design Guide](./design-guide.md)