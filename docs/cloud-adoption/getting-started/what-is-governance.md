---
title: "CAF: What is cloud resource governance?"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.date: 02/11/2019
description: Explanation cloud resource governance on Azure
author: petertaylor9999
---

<!-- markdownlint-disable MD026 -->

# What is cloud resource governance?

In [How does Azure work?](what-is-azure.md), you learned that Azure is a collection of servers and networking hardware running virtualized hardware and software on behalf of users. Azure enables your organization's application development and IT departments to be agile by making it easy to create, read, update, and delete resources as needed.

However, while unrestricted access to resources can make developers very agile, it can also lead to unexpected costs. For example, a development team might be approved to deploy a set of resources for testing but forget to delete them when testing is complete. These resources will continue to accrue costs even though they are no longer approved or necessary.

The solution is resource access governance. **Governance** is the ongoing process of managing, monitoring, and auditing the use of Azure resources to meet the requirements of your organization.

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://www.microsoft.com/en-us/videoplayer/embed/RE2ii94]

<!-- markdownlint-enable MD034 -->

These requirements are unique to each organization, so a one-size-fits-all approach to governance isn't helpful. Instead, it's up to each organization to design their governance model using Azure's two primary governance tools: **role-based access control (RBAC)** and **resource policy**.

RBAC defines roles, and roles define the capabilities of each user assigned that role. For example, the **owner** role allows all capabilites (create, read, update, and delete) for a resource, while the  **reader** role allows only the read capability. Roles can be defined with a broad scope that applies to many resource types, or a narrow scope that applies to a few.

Resource policies define rules for resource creation. For example, a resource policy can limit the SKU of a virtual machine to a particular pre-approved size. Another resource policy could enforce the application of a tag for an assigned cost center when the request is made to create the resource.

When configuring these tools, it is important to balance governance and organizational agility. The more restrictive your governance policy, the less agile your developers and IT workers will be. A restrictive governance policy may require more manual steps like requiring a developer to fill out a form or send an email to a member of the governance team to manually create a resource. The governance team has finite capacity and may become a bottleneck, resulting in development teams waiting unproductively for their resources to be created or unneeded resources accruing costs before they are deleted.

## Next steps

Now that you understand the concept of cloud resource governance, learn more about how resource access is managed in Azure.

> [!div class="nextstepaction"]
> [Learn about resource access in Azure](azure-resource-access.md)
