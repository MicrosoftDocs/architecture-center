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

- Plan for the hierarchy around management groups, subscriptions and resource groups. This will aid in the reporting costs across business units, applications, IT infrastructure shared services, etc.

- Leverage subscription types that offer lower rates for Azure resources, such as Dev/Test subscriptions.

- Plan for tagging strategy early in the process as tagging does not apply retroactively to resources or resource groups. Consider tagging single resources to allow for filtering based on tags on single resources. Tags are no inherited to resource when assigned at the parent resource group scope.

- Identify resources or meters that cannot be tagged. Decide on a custom solution to account for these costs.

- Identify tags that do not flow into Azure's cost analysis tooling. Decide on a custom solution to view reporting for these costs.

- Identify resources that will be used as shared services and review if meters exist that can provide for data around consumption from those utilizing the shared service. If meters are not available, decide on custom solution to allocate a percentage of the shared resource cost to consumers. Alternatively, explore the option of making the resource a dedicated resource for the consumer.

- Consider building a self-service catalog for your consumers with pre-canned T-shirt size offerings on IaaS and PaaS cloud services that comply with performance and budget best practices for your organization.

- Alternatively, identify built-in policies that can aid in denying or auditing the provisioning of higher cost resources such as large VM SKUs or storage accounts with RA-GRS replication enabled.

## Architecture

- Right Size the services you intend to migrate to ensure you only pay for what you need.

- Choose the correct abstraction type for your service (IaaS, PaaS, SaaS)

- Choose the correct consumption model for your service (Consumption, Pre-Provisioned)

- Choose the correct data store for the job (SQL, Cosmos, Storage etc)

- Don't over engineer the service to meet requirements that have not been clearly defined.

- Only go multi-region, if your service levels require it, for either availability or geo-distribution.

- Cache static content if it will be re-used frequently via CDN or static deployment.

- Scale out, not up, you can auto-scale in AND out frequently without downtime!

## Provisioning

- Leverage Hybrid Use Benefit where possible on VM images Windows Server and/or SQL Server software.

- Provision resources starting on the smaller tier and scale up/out as needed. For example, start with a smaller size managed disk at 32GB and scale up as needed. Certain resources, such as managed disks or ExpressRoute circuits charge for allocation vs. consumption as these are not pay-per-GB or pay-per-use billed. Resources in Azure generally allow for scaling up/out with little to no downtime vs. scaling down/in often requires longer periods of downtime or re-provisioning.

## Reporting

- Provide the needed access for users from the EA portal and Azure portal to view costs reports. This will aid consumers in tracking their consumption.

## Optimization

- Leverage reserved instances for commonly use VM families and regions. Consider purchasing reserved instances for VM families that will likely have an uptime of 24/7.

- Leverage tooling in Azure that provides recommendations on usage or cost optimization. For example, Azure Advisor or Azure cost analysis.

- Consider building additional custom solutions based on Azure APIs to further identify orphaned resources, empty resource or stale resources which are not identified by the Azure native tooling such as Azure Advisor.

- Consider leveraging tiering between hot/cold/archive for storage account data. Storage accounts provided automated tiering via its lifecycle management service. 