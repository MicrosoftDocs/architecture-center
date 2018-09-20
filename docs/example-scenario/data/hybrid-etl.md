---
title: Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2
description: Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2
author: alexbuckgit
ms.date: 9/20/2018
---
# Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2

This example scenario is relevant to organizations that need a cloud-based extract-transform-load (ETL) process and want to incorporate existing SQL Server Integration Services (SSIS) packages into their new cloud data workflow. Organizations often have already invested greatly in developing ETL packages using SSIS for specific tasks. Rewriting these packages can be a daunting task.  In addition, many on-premises SSIS packages may have dependencies on local resources, preventing migration to the cloud. 

Azure Data Factory v2 lets customers take advantage of their existing ETL packages while ending further investment in on-premises ETL development. This example discusses some potential use cases where existing SSIS packages can be leveraged as part of a new cloud data workflow using Azure Data Factory v2.

## Potential use cases

During data warehouse development, data professionals often encounter a variety of data source issues. One common issue is dirty data that prevents loading of data into the data warehouse. This may include data entry errors, multiple sources of reference data, missing values, duplication of records, typos, case differences, and similar problems. Resolving these issues requires a variety of tools and techniques to prepare the data prior to loading into a data warehouse.

Problematic data must be addressed immediately. Otherwise, this data will cause problems when the data is used later in downstream systems, reporting, and data science applications. Inconsistent data can skew your reports and cause bias that leads to unfavorable results. These problems exist in relational databases, delimited files, APIs, NoSQL databases, and data lakes. Dirty data exists across industries, so similar approaches can be used to solve these common problems.

Traditionally, SSIS has been the tool of choice for many SQL Server data professionals. As organizations embrace cloud technologies, many data professionals wonder how to migrate their on-premise SSIS packages into the cloud to leverage their existing work and minimize breaking changes in their current data processing jobs. To meet this need, the Integration Runtime (IR) in Azure Data Factory v2 now supports native execution of SSIS packages in Azure. 

## Architecture

*Architecture Diagram goes here*

> What does the solution look like at a high level?  
> Why did we build the solution this way?  
> What will the customer need to bring to this?  (Software, skills, etc?)  
> Is there a data flow that should be described?

### Components

> Why is each component there?  
> What does it do and why was it necessary?

* List of components with links to documentation.

* [Resource Groups][resource-groups] is a logical container for Azure resources.

### Alternatives

> What alternative technologies were considered and why didn't we use them?

## Considerations

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?

### Availability, Scalability, and Security

> How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?  
> What scale does this work at?  
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this?

## Deploy this scenario

> (Optional if it doesn't make sense)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?  
> Are there ways I could save cost?  
> If it scales linearly, than we should break it down by cost/unit.  If it does not, why?  
> What are the components that make up the cost?  
> How does scale effect the cost  
> 
> Link to the pricing calculator with all of the components outlined.  If it makes sense, include a small/medium/large configurations.  Describe what needs to be changed as you move to larger sizes

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: describe what a small implementation is.
* [Medium][medium-pricing]: describe what a medium implementation is.
* [Large][large-pricing]: describe what a large implementation is.

## Next Steps

> Where should I go next if I want to start building this?  
> Are there any reference architectures that help me build this?

## Related Resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?  

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
