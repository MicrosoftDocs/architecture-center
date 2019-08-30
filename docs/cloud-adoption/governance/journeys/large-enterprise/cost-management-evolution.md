---
title: "Large enterprise guide: Improve the Cost Management discipline"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: "Large enterprise guide: Improve the Cost Management discipline"
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Large enterprise guide: Improve the Cost Management discipline

This article advances the narrative by adding cost controls to the minimum viable product (MVP) governance.

## Advancing the narrative

Adoption has grown beyond the tolerance indicator defined in the governance MVP. The increases in spending now justifies an investment of time from the cloud governance team to monitor and control spending patterns.

As a clear driver of innovation, IT is no longer seen primarily as a cost center. As the IT organization delivers more value, the CIO and CFO agree that the time is right to shift the role IT plays in the company. Amongst other changes, the CFO wants to test a direct pay approach to cloud accounting for the Canadian branch of one of the business units. One of the two retired datacenters was exclusively hosted assets for that business unit’s Canadian operations. In this model, the business unit’s Canadian subsidiary will be billed directly for the operating expenses related to the hosted assets. This model allows IT to focus less on managing someone else's spending and more on creating value. However, before this transition can begin Cost Management tooling needs to be in place.

### Changes in the current state

In the previous phase of this narrative, the IT team was actively moving production workloads with protected data into Azure.

Since then, some things have changed that will affect governance:

- 5,000 assets have been removed from the two datacenters flagged for retirement. Procurement and IT security are now deprovisioning the remaining physical assets.
- The application development teams have implemented CI/CD pipelines to deploy some cloud-native applications, significantly affecting customer experiences.
- The BI team has created aggregation, curation, insight, and prediction processes driving tangible benefits for business operations. Those predictions are now empowering creative new products and services.

### Incrementally improve the future state

- Cost monitoring and reporting should be added to the cloud solution. Reporting should tie direct operating expenses to the functions that are consuming the cloud costs. Additional reporting should allow IT to monitor spending and provide technical guidance on cost management. For the Canadian branch, the department will be billed directly.

## Changes in risk

**Budget control:** There is an inherent risk that self-service capabilities will result in excessive and unexpected costs on the new platform. Governance processes for monitoring costs and mitigating ongoing cost risks must be in place to ensure continued alignment with the planned budget.

This business risk can be expanded into a few technical risks:

- There is a risk of actual costs exceeding the plan.
- Business conditions change. When they do, there will be cases when a business function needs to consume more cloud services than expected, leading to spending anomalies. There is a risk that these additional costs will be considered overages as opposed to a required adjustment to the plan. If successful, the Canadian experiment should help remediate this risk.
- There is a risk of systems being overprovisioned, resulting in excess spending.

## Changes to the policy statements

The following changes to policy will help remediate the new risks and guide implementation.

1. All cloud costs should be monitored against plan on a weekly basis by the cloud governance team. Reporting on deviations between cloud costs and plan is to be shared with IT leadership and finance monthly. All cloud costs and plan updates should be reviewed with IT leadership and finance monthly.
2. All costs must be allocated to a business function for accountability purposes.
3. Cloud assets should be continually monitored for optimization opportunities.
4. Cloud Governance tooling must limit Asset sizing options to an approved list of configurations. The tooling must ensure that all assets are discoverable and tracked by the cost monitoring solution.
5. During deployment planning, any required cloud resources associated with the hosting of production workloads should be documented. This documentation will help refine budgets and prepare additional automation tools to prevent the use of more expensive options. During this process consideration should be given to different discounting tools offered by the cloud provider, such as Reserved Instances or License cost reductions.
6. All application owners are required to attend trained on practices for optimizing workloads to better control cloud costs.


## Incremental improvement of the best practices

This section of the article will improve the governance MVP design to include new Azure policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

1. Changes in the Azure Enterprise Portal to bill the Department administrator for the Canadian deployment.
2. Implement Azure Cost Management.
    1. Establish the right level of access scope to align with the subscription pattern and resource grouping pattern. Assuming alignment with the governance MVP defined in prior articles, this would require **Enrollment Account Scope** access for the cloud governance team executing on high-level reporting. Additional teams outside of governance, like the Canadian procurement team, will require **Resource Group Scope** access.
    2. Establish a budget in Azure Cost Management.
    3. Review and act on initial recommendations. It's recommended to have a recurring process to support the reporting process.
    4. Configure and execute Azure Cost Management Reporting, both initial and recurring.
3. Update Azure Policy.
    1. Audit tagging, management group, subscription, and resource group values to identify any deviation.
    2. Establish SKU size options to limit deployments to SKUs listed in deployment planning documentation.

## Conclusion

Adding the above processes and changes to the governance MVP helps remediate many of the risks associated with cost governance. Together, they create the visibility, accountability, and optimization needed to control costs.

## Next steps

As cloud adoption grows and delivers additional business value, risks and cloud governance needs will also change. For this fictional company, the next step is using this governance investment to manage multiple clouds.

> [!div class="nextstepaction"]
> [Multicloud improvement](./multicloud-evolution.md)
