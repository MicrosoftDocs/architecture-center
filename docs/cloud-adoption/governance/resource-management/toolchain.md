---
title: "Fusion: What tools can help better manage resources in Azure?"
description: Explanation of the tools that can facilitate improved resource management in Azure
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: What tools can help better manage resource management in Azure?


In the [Intro to Cloud Governance](../overview.md), Resource Management is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the five disciplines of Cloud Governance, Resource management includes monitoring of application, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance SLA violations, and proactively avoid performance SLA violations through automated remediation.

Unlike the cloud-agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.


|    | [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/)  | [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)  | [Azure Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview) | [Azure Automation](https://docs.microsoft.com/en-us/azure/automation/automation-intro) | [Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis) |
|---------|---------|---------|---------|---------|---------|
| Deploy resources                             | Yes | Yes | Yes | Yes | No  |
| Manage resources                             | Yes | Yes | Yes | Yes | No  |
| Deploy resources using ARM templates         | No  | Yes | No  | Yes | No  |
| Orchestrated environment deployment          | No  | No  | Yes | No  | No  |
| Define resource groups                       | Yes | Yes | Yes | No  | No  |
| Manage workload and account owners           | Yes | Yes | Yes | No  | No  |
| Manage conditional access to resources       | Yes | Yes | Yes | No  | No  |
| Configure RBAC users                         | Yes | No  | No  | No  | Yes |
| Assign roles and permissions to to resources | Yes | Yes | Yes | No  | Yes |
| Define dependencies between resources        | No  | Yes | Yes | No  | No  |
| Apply access control                         | Yes | Yes | Yes | No  | Yes |
| Assess availability and scalability          | No  | No  | No  | Yes | No  |
| Apply tags to resources                      | Yes | Yes | Yes | No  | No  |
| Assign Azure Policy rules                    | Yes | Yes | Yes | No  | No  |
| Plan resources for disaster recovery         | Yes | Yes | Yes | No  | No  |
| Apply automated remediation                  | No  | No  | No  | Yes | No  |
| Manage billing                               | Yes | No  | No  | No  | No  |

Along with these resource management tools and features, you will need to [monitor your deployed resources](../monitoring-enforcement/overview.md) for performance and health issues. [Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) is the default monitoring and reporting solution in Azure. Azure Monitor provides a number of individual features that you can use to monitor your cloud resources, and the following list shows which feature allows you to address common monitoring requirements.

|                                                    | [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/) | [Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview) | [Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview) | [Azure Monitor Rest API](https://docs.microsoft.com/en-us/rest/api/monitor/) |
|----------------------------------------------------|--------------|----------------------|---------------|------------------------|
| Log virtual machine telemetry data                 | No           | No                   | Yes           | No                     |
| Log virtual networking telemetry data              | No           | No                   | Yes           | No                     |
| Log PaaS services telemetry data                   | No           | No                   | Yes           | No                     |
| Log application telemetry data                     | No           | Yes                  | No            | No                     |
| Configure reports and alerts                       | Yes          | No                   | No            | Yes                    |
| Schedule regular reports or custom analysis        | No           | No                   | No            | No                     |
| Visualize and analyze log and performance data     | Yes          | No                   | No            | No                     |
| Integrate with on-premises or third-party monitoring solution     | No           | No                   | No            | Yes                    |

When planning your deployment, you will need to consider where logging data is stored and how you integrate cloud-based [reporting and monitoring services](../../infrastructure/logs-and-reporting/overview.md) with your existing processes and tools. 

> [!Note]
> Organizations also use third-party DevOps tools to monitor workloads and resources. For more information, see [DevOps Tool Integrations](https://azure.microsoft.com/en-us/products/devops-tool-integrations/).


# Next steps
Learn how to create, assign, and manage [policy definitions](https://docs.microsoft.com/en-us/azure/governance/policy/) in Azure. 

