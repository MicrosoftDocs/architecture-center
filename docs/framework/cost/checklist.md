---
title: Cost checklist
titleSuffix: Azure Design Review Framework
description: Cost checklist guidance for design concerns
author: david-stanford
ms.date: 10/10/2019
ms.topic: checklist
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: checklist
---
# Cost checklist

## Organization

- Plan your hierarchy around management groups, subscriptions, and resource groups. Mapping your organization to your Azure hierarchy will help with reporting costs across business units, applications, IT infrastructure shared services, etc.

- Leverage subscription types that offer lower rates for Azure resources, such as Dev/Test subscriptions.

- Plan a tagging strategy early in the planning process. It's important to know that tags are not inherited by resources from their parent resource group. Consider tagging single resources to create custom reporting groups where needed.

- Identify resources or meters that can't be tagged. Decide on a custom solution to account for these costs.

- Identify tags that don't flow into cost reporting. Decide on a custom solution for these costs.

- Identify resources that will be used as shared services and review their billing meters. If the meter data isn't able to be split across consumers, decide on custom solutions to allocate proportional costs. Move shared services to dedicated resources for consumers where needed to align with cost reporting.

- Consider building a self-service catalog for your consumers. Use preset 'T-shirt' size offerings on IaaS and PaaS cloud services that comply with performance and budget guidance for your organization.

- Use policies to deny or audit the provisioning of higher-cost resources such as large VM SKUs or storage accounts with RA-GRS replication.

## Architecture

- Right-size the services you intend to migrate to ensure you only pay for what you need.

- Choose the best abstraction type for your service (IaaS, PaaS, SaaS)

- Choose the correct consumption model for your service (Consumption, Pre-Provisioned)

- Choose the right data store for the job (SQL, Cosmos, Storage etc)

- Don't over engineer services for requirements that are not clearly defined.

- Only deploy to multiple regions if your service levels require it for either availability or geo-distribution.

- Cache static content if it will be reused frequently via CDN or static deployment.

- Scale out, not up. You can autoscale in and out frequently without downtime.

## Provisioning

- Leverage Hybrid Use Benefit where possible on VM images Windows Server and/or SQL Server software.

- Provision resources starting on the smaller tier and scale up/out as needed. For example, start with a smaller managed disk and scale up as needed. Some resources, such as managed disks or ExpressRoute circuits charge for allocated capacity and not consumption. Resources in Azure generally allow for scaling up/out with little to no downtime. Scaling down or in may involve downtime or redeployment.

## Reporting

- Provide access as required to users in either the EA portal or Azure portal depending on scope. Utilize the built-in Cost Management Reader role to enable users to view costs for their resources in subscriptions or resource groups.

## Optimization

- Leverage reserved instances for commonly use VM families and regions. Consider purchasing reserved instances for VM families that will likely have an uptime of 24/7.

- Leverage tooling in Azure that provides recommendations on usage or cost optimization. For example, Azure Advisor or Azure cost analysis.

- Consider using custom scripts or Azure APIs to find and delete orphaned resources not flagged by native tools like Azure Advisor.

- Consider using hot/cold/archive tiering for storage account data. Storage accounts can provide automated tiering and lifecycle management.