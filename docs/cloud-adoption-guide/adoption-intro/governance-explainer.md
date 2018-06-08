---
title: "Explainer: what is cloud governance?"
description: Explains the concept of resource governance for Azure and cloud
author: petertay
---

# Explainer: what is cloud resource governance?

In the [how does Azure work](azure-explainer.md) explainer, you learned that Azure is a collection of servers and networking hardware running virtualized hardware and software on behalf of users. Azure enables your organization's development and IT departments to be agile by making it easy to create, read, update, and delete resources as needed.

However, while giving unrestricted resource access to developers can make them very agile, it can also lead to unintended cost consequences. For example, a development team might be approved to deploy a set of resources for testing but forget to delete them when testing is complete. These resources will continue to accrue costs even though their use is no longer approved or necessary. 

The solution to this problem is resource access **governance**. Governance refers to the ongoing process of managing, monitoring, and auditing the use of Azure resources to meet the goals and requirements of your organization. 

> [!VIDEO https://azure.microsoft.com/en-us/resources/videos/azure-adoption-guide-what-is-azure-governance]

These goals and requirements are unique to each organization so it's not possible to have a one-size-fits-all approach to governance. Rather, Azure implements two primary governance tools, **resource based access control (RBAC)**, and **resource policy**, and it's up to each organization to design their governance model using them.

RBAC defines roles, and roles define the capabilities for a user that is assigned the role. For example, the **owner** role enables all capabilites (create, read, update, and delete) for a resource, while the  **reader** roles enables only the read capability. Roles can be defined with a broad scope that applies to many resources types, or a narrow scope that applies to a few. 

Resource policies define rules for resource creation. For example, a resource policy can limit the SKU of a VM to a particular pre-appproved size. Or, a resource policy can enforce the addition of a tag with a cost center when the request is made to create the resource. 

When configuring these tools, an important consideration is balancing governance versus organizational agility. That is, the more restrictive your governance policy, the less agile your developers and IT workers become. This is because a restrictive goverance policy may require more manual steps, such as requiring a developer to fill out a form or send an email to a person on the governance team to manually create a resource. The goverance team has finite capabilities and may become backlogged, resulting in unproductive development teams waiting for their resources to be created and unneeded resources accruing costs while they wait to be deleted.

## Next steps

Your next step in adopting Azure is to [understand digital identity in Azure](tenant-explainer.md) and [create your first user in Azure AD][docs-add-users-to-aad].

<!-- Links -->

[docs-add-users-to-aad]: /azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json