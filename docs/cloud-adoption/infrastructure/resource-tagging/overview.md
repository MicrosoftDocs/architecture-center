---
title: "Fusion: Resource organization and tagging" 
description: Discussion of resource organization and tagging as a core service in Azure migrations
author: rotycenh
ms.date: 12/28/2018
---
# Fusion: Resource organization and tagging

Organizing cloud-based resources is one of the most important tasks for IT, unless you
have the simplest of deployments. Organizing your resources serves three primary purposes:

-   Resource Management: Your IT teams will need to quickly find resources associated
    with specific workloads, environments, ownership groups or other important
    information. Organizing resources is critical to assigning organizational
    roles and access permissions for resource management.

-   Operations: In addition to making resources easier for IT to manage, a
    proper organizational scheme allows you to take advantage of automation as
    part of resource creation, operational monitoring, and the creation of
    DevOps processes.

-   Accounting: Making business groups aware of cloud resource consumption
    requires IT to understand what workloads and teams are using which resources.
    To support approaches such as charge back and show back accounting, cloud
    resources need to be organized to reflect ownership and usage. 
    See [What is Cloud Accounting](../../business-strategy/cloud-accounting.md) for more information about how resource organization can support accounting and reporting practices.

## Tagging decision guide

![Plotting tagging options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-tagging.png)

Jump to: [Resource naming](#resource-naming) | [Resource tagging](#resource-tagging) | [Naming and tagging policy](#naming-and-tagging-policy) | [Resource naming and tagging in Azure](#resource-tagging-in-azure)

Your tagging approach can be simple or complex, with the emphasis ranging from supporting IT teams managing cloud workloads to integrating information relating to all aspects of the wider business as a whole. 

An IT-aligned tagging focus will reduce the complexity of monitoring assets and make management decisions based on functionality and classification much easier.

Tagging schemes that also include non-IT policies may require a larger time investment to create tagging standards reflecting business interests and maintain those standards over time. However, the result of this process is a tagging system providing an improved ability to account for costs and value of IT assets. This association of an asset's value to its operational cost is one of the first steps in changing the cost center perception of IT within your organization.

## Resource naming

A standardized naming scheme is the starting point for organizing your
cloud-hosted resources. A properly structured naming system allows you to
quickly identify resources for both management and accounting purposes.

If you have an existing IT naming scheme in other parts of your organization,
try to keep your cloud resource naming standards consistent with it.

## Resource tagging

For adding more sophisticated organization than a consistent naming scheme can
provide, cloud platforms support the ability to "tag" resources.

Tags are metadata attached to resources that consist of pairs of key/value
strings. The values you include in these pairs is up to you, but the application
of a consistent set of global tags, as part of a comprehensive naming and
tagging policy, is critical in establishing an overall governance policy.

Some examples of common tagging types include:

| Tag type              | Examples                                                           | Description                                                                                          |
|-----------------------|--------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| Functional            | app = catalogsearch1 <br/>tier = web <br/>webserver = apache<br/>env = prod <br/>env = staging <br/>env = dev                 | Categorize resources in relation to their purpose within a workload, what environment they've been deployed to, or other functionality and operational details.                                   |
| Classification        | confidentiality=private<br/>sla = 24hours                                 | Classifies a resource by how it is used and what policies apply to it                               |
| Accounting            | department = finance <br/>project = catalogsearch <br/>region = northamerica | Allows resource to be associated with specific groups within an organization for billing purposes |
| Partnership           | owner = jsmith <br/>contactalias = catsearchowners<br/>stakeholders = user1;user2;user3<br/>                       | Provides information about what people (outside of IT) are related or otherwise affected by the resource                      |
| Purpose               | businessprocess=support<br/>businessimpact=moderate<br/>revenueimpact=high   | Aligns resources to business functions to better support investment decisions  |

## Naming and tagging policy

Your naming and tagging policy will evolve over time. However, determining your core organizational priorities at the outset of a cloud migration is critical. As part of your planning process, you should carefully consider the following questions:

- How best can your naming and tagging policies integrate with existing naming and organizational policies within your organization?
- Will you be implementing a charge back or show back accounting system? How are your departments, business groups, and teams represented in this organizational structure?
- What tagging information will be required for all resources? What tagging information will be left up to individual teams to implement or not?
- Do you need tagging to represent details such regulatory compliance requirements for a resource? What about operational details such as uptime requirements or patching schedules or security requirements?

## Resource naming and tagging in Azure

Although [Resource Groups](/azure/architecture/cloud-adoption/appendix/azure-scaffold#resource-groups) provide the basic mechanism to logically group resources within your Azure subscriptions, [Naming Standards](/azure/architecture/cloud-adoption/appendix/azure-scaffold#naming-standards) and [Resource Tags](/azure/architecture/cloud-adoption/appendix/azure-scaffold#resource-tags) are the standard way to provide fine-tuned resource organization in the Azure platform for both management and accounting purposes.

For an example of best practice naming recommendations for Azure, refer to the [Patterns and Practices guidance](/azure/architecture/best-practices/naming-conventions).

You can apply tags in Azure at both the resource group and individual resource level, allowing you a degree of flexibility in the granularity of any accounting reports based on applied tags. For details on how to apply and use tagging within Azure, see [Use tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags?toc=/azure/billing/TOC.json).

The [Azure Virtual Datacenter model provides](vdc-naming.md) basic naming and tagging recommendations to support resource management and administration within a VDC deployment.

## Next steps

Learn how [Software Defined Networks](../software-defined-networks/overview.md) provide virtualized networking capabilities for cloud deployments.

> [!div class="nextstepaction"]
> [Software Defined Networks](../software-defined-networks/overview.md)
