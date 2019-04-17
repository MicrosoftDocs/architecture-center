---
title: "CAF: Resource Consistency tools in Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Resource Consistency tools in Azure
author: BrianBlanchard
---

# Resource Consistency tools in Azure

[Resource Consistency](overview.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the Five Disciplines of Cloud Governance, the Resource Consistency discipline includes monitoring of application, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance SLA violations, and proactively avoid performance SLA violations through automated remediation.

The following is a list of Azure tools that can help mature the policies and processes that support this governance discipline.

|    | [Azure portal](https://azure.microsoft.com/features/azure-portal)  | [Azure Resource Manager](/azure/azure-resource-manager/resource-group-overview)  | [Azure Blueprints](/azure/governance/blueprints/overview) | [Azure Automation](/azure/automation/automation-intro) | [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis) |
|---------|---------|---------|---------|---------|---------|
| Deploy resources                             | Yes | Yes | Yes | Yes | No  |
| Manage resources                             | Yes | Yes | Yes | Yes | No  |
| Deploy resources using templates             | No  | Yes | No  | Yes | No  |
| Orchestrated environment deployment          | No  | No  | Yes | No  | No  |
| Define resource groups                       | Yes | Yes | Yes | No  | No  |
| Manage workload and account owners           | Yes | Yes | Yes | No  | No  |
| Manage conditional access to resources       | Yes | Yes | Yes | No  | No  |
| Configure RBAC users                         | Yes | No  | No  | No  | Yes |
| Assign roles and permissions to resources | Yes | Yes | Yes | No  | Yes |
| Define dependencies between resources        | No  | Yes | Yes | No  | No  |
| Apply access control                         | Yes | Yes | Yes | No  | Yes |
| Assess availability and scalability          | No  | No  | No  | Yes | No  |
| Apply tags to resources                      | Yes | Yes | Yes | No  | No  |
| Assign Azure Policy rules                    | Yes | Yes | Yes | No  | No  |
| Plan resources for disaster recovery         | Yes | Yes | Yes | No  | No  |
| Apply automated remediation                  | No  | No  | No  | Yes | No  |
| Manage billing                               | Yes | No  | No  | No  | No  |

Along with these Resource Consistency tools and features, you will need to monitor your deployed resources for performance and health issues. [Azure Monitor](/azure/azure-monitor/overview) is the default monitoring and reporting solution in Azure. Azure Monitor provides a number of individual features that you can use to monitor your cloud resources, and the following list shows which feature allows you to address common monitoring requirements.

|                                                    | [Azure portal](https://azure.microsoft.com/features/azure-portal) | [Application Insights](/azure/application-insights/app-insights-overview) | [Log Analytics](/azure/azure-monitor/log-query/log-query-overview) | [Azure Monitor Rest API](/rest/api/monitor) |
|----------------------------------------------------|--------------|----------------------|---------------|------------------------|
| Log virtual machine telemetry data                 | No           | No                   | Yes           | No                     |
| Log virtual networking telemetry data              | No           | No                   | Yes           | No                     |
| Log PaaS services telemetry data                   | No           | No                   | Yes           | No                     |
| Log application telemetry data                     | No           | Yes                  | No            | No                     |
| Configure reports and alerts                       | Yes          | No                   | No            | Yes                    |
| Schedule regular reports or custom analysis        | No           | No                   | No            | No                     |
| Visualize and analyze log and performance data     | Yes          | No                   | No            | No                     |
| Integrate with on-premises or third-party monitoring solution     | No           | No                   | No            | Yes                    |

When planning your deployment, you will need to consider where logging data is stored and how you integrate cloud-based [reporting and monitoring services](../../decision-guides/log-and-report/overview.md) with your existing processes and tools.

> [!NOTE]
> Organizations also use third-party DevOps tools to monitor workloads and resources. For more information, see [DevOps tool integrations](https://azure.microsoft.com/products/devops-tool-integrations).

# Next steps

Learn how to create, assign, and manage [policy definitions](/azure/governance/policy) in Azure.
