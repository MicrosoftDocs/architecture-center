---
title: "Fusion: Small to Medium Enterprise - Initial Corporate Policy behind the governance strategy"
description: Small to Medium Enterprise - Initial Corporate Policy behind the governance strategy
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Small to Medium Enterprise - Initial Corporate Policy behind the governance strategy

The following corporate policy defines the initial governance position that defines the starting point for governance in this design guide. This article will define early stage risks, initial policy statements, and early processes to enforce policy statements.

> [!NOTE]
> This article is not technical at all. The corporate policy defined in this article is still important, as it will drive a number of technical decisions. For those who need an immediate answer, jump ahead to the Governance MVP article. However, it is suggested that the Cloud Governance Team read, modify, & implement this Corporate Policy prior to implementation of the design guidance.

## Define the Cloud Governance Team

The cloud governance team currently consists of two systems admins, who have foreseen the need for governance in the future. Over the next several months, they will inherit cleaning up the cloud from a governance perspective, earning them the title of Cloud Custodians. In latter evolutions, that will likely change.

## Objective:

As mentioned in the intro to this design guide, the initial objective is to establish a foundation for governance agility. Getting the Governance MVP right will allow the Cloud Governance Team to stay ahead of cloud adoption and implement governance guard rails as the adoption plan evolves.

## Business Risks

At this experimental, proof of concept, and development stage of cloud adoption, risks are relatively low. There is also little definition around the final state of the technical solutions to be deployed to the cloud. The cloud readiness of IT employees is also relatively low. A basic foundation for cloud adoption would help the team safely learn and grow. 

**Business Risk:** There is a risk of not empowering growth and/or providing the right protections against future risk. 
An agile, yet robust governance approach is required to support the board’s vision for corporate and technical growth. Failure to implement such a strategy would slow technical growth, risking market share growth and future market share. The risk is relatively high. However, at this stage tolerance for that risk is equally high.

This business risk can be broken down tactically into a few technical risks:

* There is a risk that the application of governance to deployed assets could be difficult and costly.
* There is a risk that governance may not be properly applied across an application or workload, creating gaps in security.
* There is a risk of inconsistency with so many teams working in the cloud.
* There is a risk of costs not properly aligning to business units, teams, or other budgetary management units.
* There is a risk associated with multiple identities being used to manage various deployments, which could lead to security issues.
* In spite of current policies, there is a risk that protected data could be mistakenly deployed to the cloud.

## Tolerance Indictors

The current tolerance for risk is high and appetite for investing in cloud governance is low. As such, the tolerance indicators act as an early warning system to trigger the investment of time and energy. When/if the following indicators are observed, it would be wise to evolve the governance strategy.

* Cost management: Scale of deployment exceeds 100 assets to the cloud or Monthly spend exceeding $1,00/month
* Security Management: Inclusion of protected data in defined cloud adoption plans
* Resource Management Deployment of mission critical workloads

## Policy Statements

The following policy statements establish requirements to mitigate the defined risks. These policies define the functional requirements for the Governance MVP. Each will be represented in the implementation of the Governance MVP.

### Configuration Management: 

* All assets must be grouped and tagged, in alignment with the Grouping and Tagging strategies.
* All assets must use an approved deployment model.
* Any deployment model used must be compatible with the tools used to release subsequent governance requirements.

### Identity Management: 

* All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
* All groups in the on-prem AD infrastructure which have elevated privileges should be mapped to an approved RBAC role

### Security Management: 

* Any asset deployed to the cloud must have an approved data classification
* No assets identified with a protected level of data may be deployed to the cloud
* Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements to other data centers or internal networks
* When protected data is to be deployed additional governance requirements will be established with IT Security.

### Cost Management: 

* For tracking purposes, all assets must be assigned to an Application Owner within one of the core business functions.
* When cost concerns arise, additional governance requirements will be established with the Finance.

### Resource Management: 

* Since no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.
* When mission critical workloads are deployed, additional governance requirements will be established with IT operations.

## Processes
A budget has not been allocated to the on-going monitoring and enforcement of these governance policies. Initial education and limited involvement in deployment planning are the two primary opportunities to monitor adherence to policy statements.

**Initial Education:** The "cloud governance team" is investing time to educate the cloud adoption teams on the design guides that support these policies.
**Deployment Planning:** Prior to deployment of any asset, the "cloud governance team" will review the design guide with the cloud adoption teams to discuss alignment.

## Next steps

This Corporate Policy definition prepares the Cloud Governance Team for implementation of the [Governance MVP](./governance-mvp.md), which will serve as the foundation for adoption.

> [!div class="nextstepaction"]
> [Implement the Governance MVP](./governance-mvp.md)