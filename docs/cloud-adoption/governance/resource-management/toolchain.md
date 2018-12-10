---
title: "Fusion: What tools can help better manage resources in Azure?"
description: Explanation of the tools that can facilitate improved resource management in Azure
author: BrianBlanchard
ms.date: 12/5/2018
---

# Fusion: What tools can help better manage resource management in Azure?


In the [Intro to Cloud Governance](../overview.md), Resource Management is one of the Five Disciplines to Cloud Governance. This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the Five Disciplines of Cloud Governance, Resource management includes monitoring of application, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance SLA violations, and proactively avoid performance SLA violations through automated remediation.


Unlike the cloud agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.


|  | Azure Portal  | Azure Resource Manager  | Blueprints | Azure Automation | Azure AD |
|---------|---------|---------|---------|---------|
|Manage resources (singe team)   |Yes | Yes | Yes | Yes | No  |
|Manage resources (multiple teams) |Yes | Yes | Yes | Yes | No  |
|Define resource groups    | No | Yes  | Yes  | No  | No  |
|Manage workload and account owners    | Yes | No | Yes  | Yes | Yes  |
|Manage conditional access to resources   | Yes | Yes | Yes  | Yes |  Yes |
|Assign roles and permissions to to resources   | Yes | No | Yes  | Yes |  Yes |
|Define dependencies between resources    | No | No | Yes  | No  | No  |
|Conduct asset performance     | No | No | No  | Yes | No  |
|Apply access control to all services     | Yes | No | Yes  | Yes | Yes  |
|Assess availability and scalability    | No | No | No  | Yes | No  |
|Apply tags to resources    | No | Yes  | Yes  | No  | No  |
|Plan resources for disaster recovery    | No | No  | Yes  | Yes | No  |
|Apply automated remediation    | No | No | Yes  | Yes  | Yes  |
|Manage billing and SLAs    | Yes | No | Yes  | Yes | Yes   |

Aside from the Azure native tools mentioned above, it is extremely common for customers to leverage 3rd party tools for facilitating resource management activities.

# Next steps
Learn how to create, assign, and manage [policy definitions](https://docs.microsoft.com/en-us/azure/governance/policy/) in Azure. 

