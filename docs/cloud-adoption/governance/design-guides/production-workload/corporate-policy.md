---
title: "Fusion: Governance Design Guide Production Workload"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Corporate Policies behind the Production Workload Governance Design Guide

This article outlines the corporate policies which drive the [Production Workload - Governance Design Guide](./design-guide.md). The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company has begun deploying production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business can now justify investing time and energy in cloud governance. That investment is defined by the corporate policies outlined in this article. These policies are dependent upon the business scenario described in the [Production Workload - Use Case](./use-case.md).

## Required understanding

This corporate policy builds on the design guide, corporate policy, and use case outlined in the Future Proof - Governance Design Guide. See the [References](#references) at the end of this document for additional background on that design guide. Implementation of the Production Workload design guide assumes that the foundation defined in the future proof design guide has been implemented. Review the checklist on that design guide before proceeding with this design guide.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader of this design guide. It is simply a starting point to be customized and refined, as needed. After reviewing the use case, see the [References](#references) at the end of this article for guidance on personalizing this guide.

## Corporate Policy supporting this use case

Based on the Production Workload Use Case, the following is a set of sample corporate policy statements synthesized from similar customer experiences.
The corporate policy consists of four sections: business risk, tolerance indicators, policy statements, and processes for monitoring and enforcing policy.

## Business Risks

Experimentation on most platforms creates relatively low risks. Moving from experimentation to production workloads increase that risk. When those workloads are mission critical or contain protected data, the risks are even higher. This evolution is true with any technology platform. The cloud is no exception in this regard.

As the company defined in the use case evolves their cloud adoption the following business risks have been clearly identified:

**Business Interruption**: There is an inherent risk of any new platform causing interruptions to mission critical business processes. The IT operations team and the teams executing on various cloud adoptions are relatively inexperienced with cloud operations. This increases the risk of interruption and must be mitigated and governed.

**Data Breach**: There is an inherent data breach risk with any new data platform. Technicians adopting cloud technologies have increased responsibilities to implement solutions that increase this risk. A robust security and governance strategy must be implemented to protect against misuse by technicians.

**Cost Increases**: There is an inherent risk that self-service capabilities will result in excessive and unexpected costs on the new platform. Governance processes for monitoring costs and mitigating on-going cost risks must be in place to ensure continued alignment with the planned budget.

### Technical Risks

These business risks can be more granularly articulated in the form of technical risks. To allow for bucketing of each risk, they are categorized across the five cloud governance disciplines (See [References](#references) section at the end of this article for more details on the five disciplines of governance.) 

While the changes in the use case from Future Proof to Production Workloads are minor, the risks quickly grow. Fortunately, the chosen cloud provider can automatically mitigate some of these risks, as part of the cloud platform. Additionally, the foundation established in the Future Proof guidance will allow for expeditious mitigation of these risks. While the list is long, the resolution is manageable with a proper strategy.

**Cost Management**:

* There is a risk of actual costs exceeding the plan
* Business conditions change. When they do, there will be cases when a business function needs to consume more cloud services than expected. There is a risk that this extra spend would be seen as overages, as opposed to a required adjustment to the plan.
* There is a risk of systems being over-provisioned resulting in excess spending

**Security Management**:

* There is a risk of mission critical apps or protected data being deployed unintentionally
* There is a risk of protected data being exposed during storage due to poor encryption decisions
* There is a risk of unauthorized users accessing protected data
* There is a risk of external intrusion resulting in access to protected data
* There is a risk of external intrusion or denial of service attacks causing a business interruption
* There is a risk of organization or employment changes allowing for unauthorized access to protected data
* There is a risk of new exploits producing intrusion or access opportunities

**Resource Management**:

* There is a risk of mission critical assets not being properly discovered
* There is a risk of undiscovered or mislabeled assets not being supported by existing operational management processes
* There is a risk that configuration of deployed assets won't meet performance expectations
* There is a risk that logging won't be properly recorded and centralized to allow for remediation of performance issues
* There is a risk that recovery policies may fail or take longer than expected

**Configuration Management**:

* There is a risk that inconsistent deployment processes will result in security gaps that could lead to data leaks or interruptions
* There is a risk that configuration drift or missed patches will result in unintended security gaps that could lead to data leaks or interruptions
* There is a risk that configuration won't enforce the requirements of defined SLAs
* There is a risk that configuration won't support committed recovery requirements
* There is a risk that deployed assets won't be properly tagged to track costs back to the consuming business function
* There is a risk that deployed operating systems (OS) or applications won't meet OS and App hardening requirements
* There is a risk of inconsistency with so many teams working in the cloud.

**Identity Management**:

* There is a risk that multiple identity stores could result in poorly executed identity policies
* There is a risk that the permissions applied to on-prem groups could be improperly applied to roles in the cloud
* There is a risk that cloud identities could be granted more access than is required
* There is a risk of applications using disparate identity stores could compromise customer identities
* There is a risk of malicious actors compromising security requirements

In a real-world scenario, there are likely to be many additional business risks or technical risks worth noting at this stage of adoption. The articles outlined in the [References](#references) section at the end of this article can aid in identifying additional risks.

## Metrics

To monitor the increase or decrease of the identified risks, the following metrics will serve as governance KPIs. For more information regarding the metrics below, see the article on Metrics and Risk Tolerance indicators for the relevant Cloud Governance Discipline. Links to each are included in the [References](#references) section at the end of this article

**Cost Management**:

* Actual Cloud Costs – Total costs for the current month, quarter, year, etc...
* Budgeted Cloud Costs – Planned spending limit for the desired scope
* Accumulated cost – Total accrued daily spending, starting from the beginning of the month
* Spending trends - Spending trend against the budget

**Security Management**:

* Covered Standards - Number of security standards defined by the Security team
* Overall Compliance - Ratio of compliance adherence to security standards
* Covered Resources - Deployed assets that are covered by the standards
* Recommendations by Severity - Number of recommendations to resolve health standards for deployed assets by severity
* Attacks by Severity - Number of attacks on deployed assets by severity of attack alert
* Number of Protected Data Stores - Number of storage end points or databases that should be encrypted
* Number of Un-encrypted Data Stores - Number of Protected Data Stores not encrypted

**Resource Management**:

* VMs in critical condition: Number of deployed assets violating operating systems requirements
* Alerts by Severity: Number of alerts on a deployed asset by severity
* Unhealthy subnetwork links: Number of issues with network connectivity
* Unhealthy Service Endpoints: Number of issues with external network endpoints
* Resource depletion: Number of instances where memory or CPU resources are exhausted by app runtimes
* Cloud Provider Service Health incidents: Number of incidents caused by the cloud provider
* Backup Health: Number of backups being actively synchronized
* Recovery Health: Number of backups being actively synchronized

**Configuration Management**:


**Identity Management**:

## Policy Statements

The following policy statements would establish requirements to mitigate the defined risks. To understand options and better align the 5 disciplines of cloud governance, click on any of the policy statement headers to learn more about the specific governance discipline.

**Configuration Management**:

    * All assets must be grouped and tagged, in alignment with the Grouping and Tagging strategies defined in the design guide.
    * All assets must use an approved deployment model defined in the design guide.

**Identity Management**:

    * All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
    * All groups in the on-prem AD infrastructure which have elevated privileges should be mapped to an approved RBAC role

**Security Management**:

    * Any asset deployed to the cloud must have an approved data classification
    * No assets identified with a protected level of data may be deployed to the cloud
    * Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements

**Cost Management**:

    * For tracking purposes, all assets must be assigned to a billing unit.

**Identity Management**:

    * Since no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.

The above policy statements are based on the synthesized use case. See the article on [developing policy statements](../../policy-compliance/define-policy.md) for additional guidance on crafting unique policy statements.

## Monitoring and Enforcement Processes

A budget has not been allocated to the on-going monitoring and enforcement of these governance policies. Initial education and limited involvement in deployment planning are the two primary opportunities to monitor adherence to policy statements.

The cloud governance team currently consists of two systems admins, who have foreseen the need for governance in the future.

**Initial Eduction:** The "cloud governance team" is investing time to educate the cloud adoption teams on the design guides that support these policies.

**Deployment Planning:** Prior to deployment of any asset, the "cloud governance team" will review the design guide with the cloud adoption teams to discuss alignment.

The suggested processes are very minimal due to the state of maturity outlined in the synthesized use case. See the article on [establishing policy adherence processes](../../policy-compliance/processes.md) for additional guidance on developing monitoring and enforcement processes.



## References

### Future Proof Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Future Proof Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Future Proof Use Case](../future-proof/use-case.md)**: The use case that drives the Future Proof design guide.
**[Future Proof Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Future Proof Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Future Proof Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](./use-case.md) and the policy statements listed above.
Once validated, it's time to review and implement the [Production Workload Governance Design Guide](./design-guide.md)

> [!div class="nextstepaction"]
> [Review and implement the Production Workload Governance Design Guide](./design-guide.md)
