> [!NOTE]
> **SECTION TODOS**
> - finalize the intro

For the people running a healthcare facility, length of stay—the number of days from patient admission to discharge—matters. However, that number can vary across facilities and across disease conditions and specialties, even within the same healthcare system, making it hard to track patient flow and plan accordingly.

## Architecture

> [!NOTE]
> **SECTION TODOS**
> - diagram: finalize with Dhanshri; when final upload to blob storage and create new .png
> - dataflow: review/complete steps 1 thru x, after diagram is mostly complete
> - components: complete after dataflow section is completed
> - alternatives: TBD

This Azure solution helps hospital administrators use the power of machine learning to predict the length of stay for in-hospital admissions, to improve capacity planning and resource utilization. A chief medical information officer might use a predictive model to determine which facilities are overtaxed and which resources to bolster within those facilities, and a care line manager might use a model to determine whether there are adequate staff resources to handle the release of a patient.

:::image type="content" source="./images/predict-length-of-stay.png" alt-text="Diagram of remote patient monitoring architecture using healthcare devices and Azure services." lightbox="./images/predict-length-of-stay.png" border="false" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Dataflow

> An alternate title for this sub-section is "Workflow" (if data isn't really involved).
> In this section, include a numbered list that annotates/describes the dataflow or workflow through the solution. Explain what each step does. Start from the user or external data source, and then follow the flow through the rest of the solution (as shown in the diagram).

The following workflow (or dataflow) corresponds to the above diagram:
1. TBD
1. TBD
1. TBD
1. TBD
1. TBD
1. TBD

### Components

- [Azure Data Factory](https://azure.microsoft.com/products/data-factory/) provides fully managed, serverless data integration service. Visually integrate data sources with more than 90+ built-in, maintenance-free connectors at no added cost.

- [Azure Storage](https://azure.microsoft.com/products/category/storage/) is used for scalable, secure data lake for high-performance analytics.

- Azure Machine Learning (ML) Services: accelerate end-to-end Length of stay (LOS) prediction ML lifecycle. In addition:
  - Empower data scientists and developers with a wide range of productive experiences to build, train, and deploy machine learning models and foster team collaboration. 
  - Accelerate time to market with industry-leading MLOps—machine learning operations, or DevOps for machine learning. 
  - Innovate on a secure, trusted platform, designed for responsible machine learning.

- Azure Synapse Analytics: a limitless analytics service that brings together data integration, enterprise data warehousing and big data analytics.

- Power BI - Self service analytics at enterprise scale, allows you to:
  - Create a data-driven culture with business intelligence for all.
  - Keep your data secure with industry-leading data security capabilities including sensitivity labeling, end-to-end encryption, and real-time access monitoring.


### Alternatives

> Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. Customers find this valuable because they want to know what other services or technologies they can use as part of this architecture.

> What alternative technologies were considered and why didn't we use them?

## Scenario details

> [!NOTE]
> **SECTION TODOS**
> - Add the scenario overview and list the potential use cases, 

> This should be an explanation of the business problem and why this scenario was built to solve it.
>   What prompted them to solve the problem?
>   What services were used in building out this solution?
>   What does this example scenario show? What are the customer's goals?
> What were the benefits of implementing the solution?

### Potential use cases

> What industry is the customer in? Use the following industry keywords, when possible, to get the article into the proper search and filter results: retail, finance, manufacturing, healthcare, government, energy, telecommunications, education, automotive, nonprofit, game, media (media and entertainment), travel (includes hospitality, like restaurants), facilities (includes real estate), aircraft (includes aerospace and satellites), agriculture, and sports. 
>   Are there any other use cases or industries where this would be a fit?
>   How similar or different are they to what's in this article?

## Considerations

> [!NOTE]
> **SECTION TODOS**
> - finalize Cost Optimizations
> - pick at least 2 of the remaining 4 considerations and finalize

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   You must include the "Cost optimization" section. 
>   You must include at least two of the other H3 sub-sections/pillars: Reliability, Security, Operational excellence, and Performance efficiency.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).


> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

> [!NOTE]
> **SECTION TODOS**
> - do we have solution assets that demo this architecture? 

> (Optional, but greatly encouraged)

> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Contributors

> [!NOTE]
> **SECTION TODOS**
> - decide whether we want to do this section

> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Author 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each additional contributor (even if there are 10 of them).
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!NOTE]
> **SECTION TODOS**
> - TBD

> Link to Docs and Learn articles, along with any third-party documentation.
> Where should I go next if I want to start building this?
> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful? Are there product documents that go into more detail on specific technologies that are not already linked?
 
## Related resources

> [!NOTE]
> **SECTION TODOS**
> - do we have more relevant links?

See the links below for technologies and resources that are related to this architecture:

- [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
