---
title: "Fusion: Small to Medium Enterprise – Cost management evolution  "
description: Explanation Small to Medium Enterprise – Cost management evolution 
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Small to Medium Enterprise – Cost management evolution

This article evolves the narrative by adding cost controls to the governance minimum viable product (MVP).

## Evolution of the narrative

Adoption has grown beyond the cost tolerance indicator defined in the governance MVP. This is a good thing, as it corresponds with migrations from the "DR" datacenter. The increase in spending now justifies an investment of time from the Cloud Governance team.

### Evolution of the current state

In the previous phase of this narrative, IT had retired 100% of the DR datacenter. The application development and BI teams were ready for production traffic.

Since then, some things have changed that will affect governance:

- The migration team has begun migrating VMs out of the production datacenter.
- The application development teams is actively pushing production applications to the cloud through CI/CD pipelines. Those applications can reactively scale with user demands.
- The business intelligence team within IT has delivered a number of predictive analytics tools in the cloud. the volumes of data aggregated in the cloud continues to grow.
- All of this growth supports committed business outcomes. However, costs have begun to mushroom. Projected budgets are growing faster than expected. The CFO needs improved approaches to managing costs.

### Evolution of the future state

Cost monitoring and reporting is to be added to the cloud solution. IT is still serving as a cost clearing house. This means that payment for cloud services continues to come from IT procurement. However, reporting should tie direct operational expenses to the functions that are consuming the cloud costs. This model is referred to as "Show Back" model to cloud accounting.

The changes to current and future state expose new risks that will require new policy statements.

## Evolution of tangible risks

**Cost Increases**: There is an inherent risk that self-service capabilities will result in excessive and unexpected costs on the new platform. Governance processes for monitoring costs and mitigating on-going cost risks must be in place to ensure continued alignment with the planned budget.

This business risk can be expanded into a few technical risks:

- Actual costs might exceed the plan.
- Business conditions change. When they do, there will be cases when a business function needs to consume more cloud services than expected. There is a risk that this extra spending will be considered overages, as opposed to a necessary adjustment to the plan.
- Systems could be over-provisioned, resulting in excess spending.

## Evolution of the policy statements

The following changes to policy will help mitigate the new risks and guide implementation.

1. All cloud costs should be monitored against plan on a weekly basis by the governance team. Reporting on deviations between cloud costs and plan is to be shared with IT leadership and finance monthly. All cloud costs and plan updates should be reviewed with IT leadership and finance monthly.
2. All costs must be allocated to a business function for accountability purposes.
3. Cloud assets should be continually monitored for optimization opportunities.
4. Cloud Governance tooling must limit Asset sizing options to an approved list of configurations. The tooling must ensure that all assets are discoverable and tracked by the cost monitoring solution.
5. During deployment planning, any required cloud resources associated with the hosting of production workloads should be documented. This documentation will help refine budgets and prepare additional automation to prevent the use of more expensive options. During this process consideration should be given to different discounting tools offered by the cloud provider, such as reserved instances or license cost reductions.
6. All application owners are required to attend trained on practices for optimizing workloads to better control cloud costs.

## Evolution of the best practices

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

1. Implement Azure Cost Management
    1. Establish the right level of access scope to align with the subscription pattern and resource consistency pattern. Assuming alignment with the Governance MVP defined in prior articles, this requires **Enrollment Account Scope** access for the Cloud Governance Team executing on high level reporting. Additional teams outside of governance may require **Resource Group Scope** access.
    2. Establish a budget in Azure Cost Management.
    3. Review and act on initial recommendations. Have a recurring process to support reporting.
    4. Configure and execute Azure Cost Management Reporting, both initial and recurring.
2. Update Azure Policy
    1. Audit the tagging, management group, subscription, and resource group values to identify any deviation.
    2. Establish SKU size options to limit deployments to SKUs listed in deployment planning documentation.

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with cost governance. Together, they create the visibility, accountability, and optimization needed to control costs.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. For the fictitious company in this journey, the next step is using this governance investment to manage multiple clouds.

> [!div class="nextstepaction"]
> [Multi-cloud evolution](./multi-cloud.md)
