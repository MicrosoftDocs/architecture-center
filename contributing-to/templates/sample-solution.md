---
title: <Article Title>
description: <Article Description>
author: <github username>
ms.date: <publish or update date - mm/dd/yyyy>
---
# Article Title

> This should be an introduction of the business problem and why this scenario was built to solve it.
>> What industry is the customer in?  
>> What prompted them to solve the problem?  
>> What was the benefits of implementing the solution described blow?

## Potential use cases

> Are there any other use cases or industries where this would be a fit?  
> How similar or different are they to what's in this article?

These other uses cases have similar design patterns:

* List of example use cases

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
