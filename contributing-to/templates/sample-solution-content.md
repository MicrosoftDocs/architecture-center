> The H1 title is a noun phrase that describes the scenario. Don't enter it here, but as the **name** value in the corresponding YAML file.

Introductory section - no heading

> This should be an introduction of the business problem and why this scenario was built to solve it.
>> What industry is the customer in?
>> What prompted them to solve the problem?
>> What services were used in building out this solution?
>> What does this example scenario show? What are the customer's goals?

> What were the benefits of implementing the solution described below?

## Potential use cases

> Are there any other use cases or industries where this would be a fit?
> How similar or different are they to what's in this article?

These other uses cases have similar design patterns:

- List of example use cases

## Architecture

_Architecture diagram goes here_

> What does the solution look like at a high level?
> Why did we build the solution this way?
> What will the customer need to bring to this?  (Software, skills, etc?)
> Is there a data flow that should be described?
> Include a list of the workflow or data flow under the diagram. If you have numbers in the diagram, use a numbered list for to describe each step in the flow of the architecture.

### Components

A bulleted list of components in the architecture (including all relevant Azure services) with links to the product documentation.

> Why is each component there?
> What does it do and why was it necessary?
> Link to the name of the service to the service's product service page.

- Examples: 
  - [Azure App Service](https://azure.microsoft.com/services/app-service)
  - [Azure Bot Service](https://azure.microsoft.com/services/bot-service)
  - [Azure Cognitive Services Language Understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service)
  - [Azure Cognitive Services Speech Services](https://azure.microsoft.com/services/cognitive-services/speech-services)
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
  - [Azure Monitor](https://azure.microsoft.com/services/monitor): Application Insights is a feature of Azure Monitor.
  - [Resource Groups][resource-groups] is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.

### Alternatives

Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives.

> What alternative technologies were considered and why didn't we use them?

## Considerations

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?
> Note that you should have at least two of the sub-sections.

### Availability

> How do I need to think about managing, maintaining, and monitoring this long term?

### Performance

> Are there any key performance considerations (past the typical)?

### Scalability

> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?

### Security

> Are there any security considerations (past the typical) that I should know about this?

### Resiliency

> Are there any key resiliency considerations (past the typical)?

### DevOps

> Are there any key DevOps considerations (past the typical)?

## Deploy this scenario

> (Optional, but greatly encouraged)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?
>
> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

## Next steps

> Where should I go next if I want to start building this?
> Are there any reference architectures that help me build this?
> Be sure to link to the Architecture Center, to related architecture guides and architectures.

## Related resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?
> Are there product documents that go into more detail on specific technologies not already linked?

<!-- links -->

[calculator]: https://azure.com/e/
