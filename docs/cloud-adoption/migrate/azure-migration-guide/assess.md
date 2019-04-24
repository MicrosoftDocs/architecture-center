---
title: "CAF: Assess the digital estate"
description: Assess the digital estate
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: fasttrack-new
---

# Assess the digital estate

In an ideal migration every asset would be compatible with a cloud platform, and in a state ready for migration. The reality is not everything should be migrated to the cloud. Furthermore, not every asset is compatible with cloud platforms. Before migrating assets to the cloud, it is important to assess the workload and each asset.

The resources in this section will help you perform the assessment of your environment to determine its suitability for migration and possible methods to use.

# [Tools](#tab/Tools)

The following tools help you perform an assessment of your environment to ascertain the suitability and best approach for migration.

## Azure Migrate

The Azure Migrate service assesses on-premises workloads for migration to Azure. The service assesses the migration suitability of on-premises machines, performs performance-based sizing, and provides cost estimates for running on-premises machines in Azure. If you're contemplating lift-and-shift migrations, or are in the early assessment stages of migration, this service is for you. After the assessment, you can use services such as Azure Site Recovery and Azure Database Migration Service to migrate the machines to Azure.

![Azure migrate overview](./media/assess/azuremigrate-overview-1.png)

### Create a new migration project

To get started with Azure Migrate follow these steps:

1. Select **Azure Migrate**.
1. Create a new migration project.
1. Select **Discover and Assess**.
1. Follow the **Discover machines** wizard.
    1. Download, create, configure the collector appliance for on-premises.
1. Follow the **Create assessment** wizard.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade]" submitText="Go to Azure Migration" :::

::: form action="OpenBlade[#create/Microsoft.AzureMigrate]" submitText="Create new Migration Project" :::

::: zone-end

::: zone target="docs"

### Read more

- [Azure Migration overview](/azure/migrate/migrate-overview)
- [Azure Migrate in the Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
- [Create Migration project in the Azure Portal](https://ms.portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

## Service Map

Service Map automatically discovers application components on Windows and Linux systems and maps the communication between services. With Service Map, you can view your servers in the way that you think of them: as interconnected systems that deliver critical services. Service Map shows connections between servers, processes, inbound and outbound connection latency, and ports across any TCP-connected architecture, with no configuration required other than the installation of an agent.

### Enable Service Map

1. In the Azure portal, select **+ Create a resource**.
1. Choose **Service Map** and select **Create**.
1. In **Configure a solution** pane, configure your **Log Analytics** workspace.
1. Select **Create**.

::: zone target="chromeless"

::: form action="OpenBlade[#create/Microsoft.ServiceMapOMS]" submitText="Create a Service Map resource" :::

::: zone-end

### Navigate to Service Map

1. Locate your **Log Analytics** resource that contains the workspace where you deployed **Service Map**.
1. Select **Solutions** from the Log Analytics menu.
1. Click the **Service Map** title.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.OperationalInsights%2Fworkspaces]" submitText="Go to Log Analytics workspaces" :::

::: zone-end

::: zone target="docs"

### Create a Machine Group

Machine Groups allow you to see maps centered around a set of servers, not just one so you can see all the members of a multi-tier application or server cluster in one map.

1. In **Service Map**, select the Machines tab/list.
1. Select the machines you want to add to a group.
1. Click **Add to group**.
1. Select an existing group or create a new group to contain your servers.

### View a Machine Group dependency report

1. In **Service Map**, select the Groups tab/list.
1. Select the Group you want to focus on.
1. The dependency view will refresh to highlight the servers that belong to the group.

> [!TIP]
> There are many other options for analyzing the data within Service Map, such as filtering by process. For more details see the full product documentation.

### Read more

- [Using Service Map solution in Azure](/azure/azure-monitor/insights/service-map)

::: zone-end

# [Scenarios and Stakeholders](#tab/Scenarios)

## Scenarios

This guide focuses on the **rehost** (also called **lift-and-shift**) method of migration. Some scenarios that exist within the Rehost method are:

- **Legacy hardware:** You are migrating to remove a dependency on legacy hardware nearing end of support or end of life.
- **Capacity growth:** You need to increase the capacity for assets, which your current infrastructure can't provide.
- **Datacenter modernization:** You need to extend your datacenter or modernize your datacenter with cloud technology to ensure your business remains current and competitive.
- **Application or service modernization:** While not officially a rehost objective, an outcome of the rehost migration may be an ability to create plans for application or service review and potential modernization.

### Stakeholders

The complete list of stakeholders will vary from migration project to project. You shouldn't assume to know all of the stakeholders at the start of planning for a migration as often stakeholders are only identified during certain phases of the project. You can mitigate this through more detailed planning and, most importantly, discussions with known stakeholders. An important question to ask a known stakeholder is who else within their business organization/department will have an interest in the business outcome or be affected by this project. To make this question easier, let's define what a stakeholder is:

**Stakeholders:** Who in the organization is likely to see the greatest value in a specific business outcome? Who is most likely to support this transformation, especially when things get tough or time consuming? Who has the greatest stake in the success of this transformation? This person is a potential stakeholder.

There are some common stakeholders that apply to migration projects. These include:

- **CEO:** The project may have been an initiative from the CEO, but ultimately they have final sponsorship for the project. They will have an investment from the point-of-view to ensure that the migration aligns with the overall business objectives and vision for the company.
- **CTO:** Depending on the infrastructure being migrated the CTO may have initiated this project, but ultimately they will have a stake in the project to ensure it aligns with the long-term infrastructure strategy of the business.
- **CIO:** Very similar to the CTO, the CIO though is likely to be invested in the project when it contains infrastructure critical to the internal business functions. They will have a stake in the project to ensure it aligns with the long-term infrastructure strategy of the business.
- **CFO:** The CFO will be invested in the project as it pertains to approval for spending as well as reducing the overall capital expense and operating expense for the business. They will also have strategic investments to ensure that the project aligns with the strategic plans for the business.
- **Operations management:** Any organization that manages infrastructure and services is likely to have a team who support and manage the day-to-day life of that infrastructure and services. The management of those operational staff will have a stake in the project and how it affects the day-to-day operations as well as the training and skills readiness of their staff.
- **Application or service owner:** Someone that has a responsibility to oversee the lifecycle of the application or service. This may include implementation, maintenance, feature improvements, and retirement. They act as the voice across the various operational units for their application or service. Their stake in a migration is going to be from a perspective of aligning the project to the lifecycle plans, along with understanding the impact of each operational component change as it pertains to the application or service. All while balancing this with the end-user or customer needs through the assistance of the Customer Advocate role.
- **Customer advocate:** Someone that has an existing responsibility within the organization to act as a conduit between the operational teams and the business units or customers. Their primary role generally consists of being the voice of the end user or business units when operational staff are planning maintenance activities, as well as providing any end-user feedback regarding the service to the application/service owners or operational management. Therefore, their stake in the project is from a perspective of impact to the customer either before, during, or after the project.

> [!TIP]
> For the purpose of this statement, a customer can be considered as any end user of the service either external or internal. That is, someone that interacts directly or indirectly with the application or service that is supported by the infrastructure being migrated (or a related application or service with a dependency on that infrastructure).

# [Timelines](#tab/Timelines)

As a general statement, customers find that the migration scenario covered by this guide can be completed in one to six months.

Some of the factors to consider when evaluating the timeline of your migration are:

- **Assets to migrate:** The number of and diversity of assets.
- **Staff readiness:** Are your staff ready to manage the new environment or do they need training?
- **Funding:** Do you have the appropriate approval and budget to complete the migration?
- **Change management:** Does your business have specific requirements regarding change implementation and approval?
- **Segment Regulations:** Do you have to comply with segment or industry regulations?

# [Cost Management](#tab/ManageCost)

As you assess your environment, this presents a perfect opportunity to include a cost analysis step. Using the data collected by the assessment activities you should be able to analyse and predict costs. This cost prediction should factor both the consumption service costs in addition to any one-time costs (such as increased data ingress).

During migration, there are a number of factors that will affect decisions and execution activities:

- **Digital estate size:** Understanding the size of your digital estate will directly affect decisions and the resources required to perform the migration.
- **Accounting models:** Shifting from a structured capital expense model to a fluid operating expense model.

::: zone target="docs"

The following resources provide related information:

- [CAF: Estimate cloud costs](../migration-considerations/assess/estimate.md)

::: zone-end
