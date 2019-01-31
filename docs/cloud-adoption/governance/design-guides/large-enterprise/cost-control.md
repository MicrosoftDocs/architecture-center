---
title: "Fusion: Small to Medium Enterprise – Cost Management Evolution "
description: Explanation Small to Medium Enterprise – Governance - Adding Cost Controls
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Small to Medium Enterprise – Cost Management Evolution

This article will evolve the narrative by adding cost controls to the [Governance MVP](./governance-mvp.md), to better control cloud spending.

Jump to [Narrative Changes](#narrative-changes) | [Corporate Policy Changes](#corporate-policy) | [Technical Changes](#technical-changes)

## Narrative Changes

Adoption has grown beyond the tolerance indicator defined in the Governance MVP. This is a good thing, as it corresponds with migrations from the “DR” datacenter. The increases in spending now justifies an investment of time from the Cloud Governance Team.  

### Current State Changes

* IT has retired 75% of the DR data center, by moving disaster recovery and dev/test assets to Azure. The assets that remain contain protected data.
* Dozens of IT assets have been deployed to the cloud. Some secondary business assets have been deployed to the cloud
* The application development teams have implemented CI/CD pipelines to deploy a number of cloud native applications that don't interact with protected data.
* The BI team actively curates logistics, inventory, and third party data in the cloud to drive new predictions which shape business processes. However, their view is constrained until customer and financial data can be integrated into the data platform.

### Future State Changes

* Cost monitoring and reporting is to be added to the cloud solution. IT is still serving as a cost clearing house. This means that payment for cloud services continues to come from IT procurement. However, reporting should tie direct operational expenses to the functions that are consuming the cloud costs. This model is referred to as "Show Back" model to cloud accounting

## Corporate Policy

The changes to current and future state expose new risks that will require new policy statements.

### New Risks

**Cost Increases:** There is an inherent risk that self-service capabilities will result in excessive and unexpected costs on the new platform. Governance processes for monitoring costs and mitigating ongoing cost risks must be in place to ensure continued alignment with the planned budget.
This business risk can be expanded into a few technical risks

* There is a risk of actual costs exceeding the plan
* Business conditions change. When they do, there will be cases when a business function needs to consume more cloud services than expected. There is a risk that this extra spend would be seen as overages, as opposed to a required adjustment to the plan.
* There is a risk of systems being over-provisioned resulting in excess spending

### New Policy Statements

The following changes to policy will help mitigate the new risks and guide implementation.

1) All cloud costs should be monitored against plan on a weekly basis by the governance team. Reporting on deviations between cloud costs and plan is to be shared with IT leadership and finance on a monthly basis. All cloud costs and plan updates should be reviewed with IT leadership and finance on a monthly basis.
2) All costs must be allocated to a business function for accountability purposes
3) Cloud assets should be continually monitored for optimization opportunities
4) Cloud Governance tooling must limit Asset sizing options to an approved list of configurations. The tooling must ensure that all assets are discoverable and tracked by the cost monitoring solution.

## Technical Changes

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

### Design Evolution Overview

1) Implement Azure Cost Management
    a. Establish the right level of access scope to align with the subscription pattern and resource grouping pattern. 
        i. Assuming alignment with the Governance MVP defined in prior articles, this would require Enrollment Account Scope access for the Cloud Governance Team executing on high level reporting. Additional teams outside of governance, may require Resource Group Scope access.
    b. Establish a budget in Azure Cost Management
    c. Review and Act on initial recommendations (recurring process suggested to support reporting process)
    d. Configure and execute Azure Cost Management Reporting (Both initial and recurring)
2) Update Azure Policy
    a. Audit tagging, management group, subscription, and resource group values to identify any deviation
    b. Establish SKU size options

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with cost governance. Together, they create the visibility, accountability, and optimization needed to control costs.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. The following are a few evolutions that may be experienced in the future.

* [Resource Management](./mission-critical.md): Deployment of mission critical workloads
* [Security Management](./protected-data.md): Inclusion of protected data in defined cloud adoption plans
* [Multi-Cloud Governance](multi-cloud.md): Leveraging this governance investment to manage multiple clouds