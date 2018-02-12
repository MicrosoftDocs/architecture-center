## Guidelines for Reference Architectures on Azure Architecture Center

# What is a Reference Architecture?

tbd

# Principles

A reference architecture (RA) shows an architecture that a customer can deploy today on Azure.

- The focus is on infrastructure (what you deploy), not application development. It can be IaaS or PaaS, or a mix of both.
- Audience: Architects and developers.
- "Golden path". A single RA shows one way to do something. The goal is to guide a customer to a solution that works. An RA does _not_ describe every possible option or variation. However, there could be several RAs that address similar scenarios. In that case, there would be additional guidance to help customers select which RA meets their needs.
- Best practices. An RA embodies a set of best practices _for that scenario_. It does not comprehensively describe every feature of every Azure service being used - that's what the product docs are for.
- In most cases, an RA should include a deployable Resource Manager template.

# Document Structure

We strive to use a consistent structure for RA documents. That said, if our current structure does not work for a particular RA, we can and should evolve the structure.

## Title  - State the scenario

> Example: "Connect an on-premises network to Azure using ExpressRoute"

After the title, there is an introductory section, consisting of:

**Intro paragraph**. A short paragraph that describes the scenario and the solution that is deployed. This should be very concise, so that the diagram (next item) appears close to the top of the page.

**Architecture diagram**. The diagram shows the Azure resources that get deployed. The level of detail will depend on the scenario.

> Example: For an IaaS deployment, the diagram _should_ include the network topology (VNet, subnets, gateways, public IP addresses), VMs or VM scale sets, plus load balancers, Traffic Manager, and App Gateway, as appropriate. It _might_ include other elements such as NICs, storage accounts, or VHDs, but only if you have specific guidance that relates to those elements. For example, if some VMs need multiple NICs, include those in the diagram. Otherwise, it can be assumed that each VM has a NIC.

## Architecture

A bullet list that describes the elements in the diagram. In most cases, there should be a 1:1 correspondence - everything in the diagram should be described here, and vice versa.

For each element, describe its purpose within the context of the overall solution.

**Weak:**"A subnet is a way to segment a VNet into multiple address spaces." **← This is just a description of subnets.**

**Better:**"Put each application tier into a separate subnet."  **← This is specific to the scenario.**

It's OK to do both - describe _what_ something is, and _why_ it's there. However, you shoud often just link to the product docs for the "what."

## Recommendations

Describe in more detail the recommendations for the elements listed in the previous section. This is the place for the gory details, gotchas, and detailed explanations of things.

Optionally, this section may have subheadings (H3) to organize the recommendations. e.g., "VM recommendations", "SQL Server recommendations", "Networking recommendations"

> Examples of recommendations:
> - For each tier, put two or more VMs in an availability set.
> - Create a separate storage account for diagnostic logs.
> - For SQL Server high availability, we recommend using Always On Availability Groups.

As much as possible, provide the justification or rationale for each recommendation.

- Put two or more VMs in an availability set. _This makes the VMs eligible for a higher SLA_.
- Create a separate storage account for diagnostic logs _to avoid hitting IOPS limits_.

We want recommendations to be definite when possible.

**Weak:** To restrict traffic between the subnets, you can create network security groups. **← Are we recommending this or not?**

**Better:** Use an NSG to isolate the data tier. The data tier should only accept network traffic from the middle tier. **← Concrete and actionable**

In practice, sometimes you'll need a qualifier like "depending on your workload..."

## Considerations (pillars or "-ilities")

These are four sections (H2) that describe non-functional characteristics of the architecture.

- Scalability
- Availability
- Manageability
- Security

These correspond to 4 of our 5 [pillars of software quality](https://docs.microsoft.com/en-us/azure/architecture/guide/pillars).

Only include the sections that are relevant for the RA. In some cases, there won't be anything to say for a particular pillar, especially if an RA builds on a previous RA, as part of a series.

These sections may include whatever discussion points are relevant for that pillar, with respect to the architecture that's being described. Including:

- What the architecture gives you.
- What the architecture does not give you. When possible, point to a possible alternative.
- Things to keep in mind in order to achieve the pillar, when using this architecture. This might include app dev or operational considerations.
- Additional options to consider, which may not be part of the "golden path".

> Examples:
> - "Scale out by adding more VMs to the load balancer pool." (Scalability)  **← A capability that this architecture gives you.**
> - "If you need higher availability, replicate the application across two regions and use Traffic Manager for failover." (Availability)  **← What this architecture does _not_ give you (availability during a regional outage), along with a pointer to something actionable.**
> - "If your VMs run an HTTP server, create an HTTP health probe. Otherwise, create a TCP health probe." (Availability)  **← A best practice that depends on the specifics of your application.**
> - "The web front end should be stateless, to avoid the need to maintain client affinity." (Scalability) **← An app dev consideration.**

## Deploy the solution

If there is a deployable Azure Resoure Manager template, include instructions for how to deploy.