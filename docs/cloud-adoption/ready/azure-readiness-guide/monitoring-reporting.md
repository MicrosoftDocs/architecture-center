---
title: Monitoring and reporting in Azure | Microsoft docs
description: Learn how to set up monitoring, reporting, and alerts for your Azure management environment
author: timleyden
ms.author: tileyden
ms.date: 04/09/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-edit"
---
# Monitoring and reporting in Azure

Azure offers many services that together provide a comprehensive solution for collecting, analyzing, and acting on telemetry from your applications and the Azure resources that support them. In addition, these services can extend to monitoring critical on-premises resources to provide a hybrid monitoring environment.

# [Azure Monitor](#tab/AzureMonitor)

Azure Monitor provides a single unified hub for all monitoring and diagnostics data in Azure. Use it to get visibility across your resources, find and fix problems, optimize performance, and understand customer behavior.

* **Monitor and visualize metrics**: Metrics are numerical values available from Azure Resources that help you understand the health of your systems. Customize charts for your dashboards and use workbooks for reporting.

* **Query and analyze logs**: Logs include activity logs and diagnostic logs from Azure. Collect additional logs from other monitoring and management solutions for your cloud or on-premises resources. Use Log Analytics as the central repository to aggregate all this data. From there, you can run queries to help troubleshoot issues or to visualize data.

* **Setup alerts and actions**: Alerts proactively notify you of critical conditions. Corrective actions can be taken based on triggers from metrics, logs, or service health issues. You can setup different notifications and actions, and send data to your IT service management tools.

::: zone target="docs"

 Start monitoring your:
* [Applications](/azure/application-insights/app-insights-overview)
* [Containers](/azure/monitoring/monitoring-container-overview)
* [Virtual machines](/azure/monitoring/monitoring-service-map)
* [Networks](/azure/networking/network-monitoring-overview)

To monitor other resources, find additional solutions in the Azure Marketplace.

To explore Azure Monitor, go to the [Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/overview).

## Learn more

To learn more, see [Azure Monitor documentation](/azure/monitoring-and-diagnostics/).

::: zone-end

::: zone target="chromeless"
## Action


::: form action="OpenBlade[#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/overview]" submitText="Explore Azure Monitor" :::

::: zone-end

# [Azure Service Health](#tab/AzureServiceHealth)
Azure Service Health provides personalized alerts and guidance when Azure service incidents affect you. It can notify you, help you understand the impact to your resources, and keep you updated as the issue is resolved. It can also help you prepare for planned maintenance and changes that could affect the availability of your resources.

Azure Service Health includes:

* **Azure status**: A global view of the health of Azure services
* **Service health**: A personalized view of the health of your Azure services
* **Resource health**: A deeper view of the health of each of your individual resources

::: zone target="chromeless"
## Action

To set up a Service Health alert,

1. Go to **Service Health**.
2. Select **Health alerts**.
3. Create a service health alert.

::: form action="OpenBlade[#blade/Microsoft_Azure_Health/AzureHealthBrowseBlade/healthalerts]" submitText="Go to Service Health" :::

::: zone-end

::: zone target="docs"

To set up a Service Health alert, go to the [Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_Health/AzureHealthBrowseBlade/healthalerts).


## Learn more

To learn more, see [Azure Service Health documentation](/azure/service-health/).

::: zone-end

# [Azure Advisor](#tab/AzureAdvisor)
Azure Advisor is a free, personalized cloud consultant that helps you follow and implement Azure best practices. It analyzes your resource configuration and usage telemetry and then recommends how you can optimize your environment. The recommendations are divided into four categories:

* **High availability**: To improve the continuity of your business-critical applications. Recommendations may include adding virtual machines to an availability set or adding geo-redundant endpoints.
* **Security**: To detect threats and vulnerabilities that might lead to security breaches. Recommendations may include applying disk encryption or enabling network security groups.
* **Performance**: To improve the speed of your applications. Recommendations may include boosting SQL query performance by creating indexes or re-configuring your traffic manager settings.
* **Cost**: To optimize and reduce your overall Azure spending. Recommendations may include resizing or shutting down under used virtual machines or switching to Azure Reservations for consistent workloads.

Recommendations in Advisor are based on the resources you deploy and the actions you take in Azure. Check Advisor regularly for the latest recommendations.

::: zone target="chromeless"
## Action
::: form action="OpenBlade[#blade/Microsoft_Azure_Expert/AdvisorBlade]" submitText="Explore Azure Advisor" :::

::: zone-end

::: zone target="docs"

To explore Azure Advisor, go to the [Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_Expert/AdvisorBlade).


## Learn more

To learn more, see [Azure Advisor documentation](/azure/advisor/).

::: zone-end



# [Azure Security Center](#tab/AzureSecurityCenter)

Azure Security Center also plays an important part in your monitoring strategy. It lets you monitor the security of your machines, networks, storage, data services, and applications. It provides advanced threat detection by using machine learning and behavioral analytics to help identify active threats targeting your Azure resources. It also provides threat protection that blocks malware or other unwanted code, and reduces the surface area exposed to brute force and other network attacks.

When Security Center identifies a threat, it triggers a security alert with steps you need to take to respond to an attack and provides a report with information about the threat that was detected.

Azure Security Center is offered in two tiers: Free and Standard. Features like security recommendations are available for free. The Standard tier provides additional protection like advanced threat detection and protection across hybrid cloud workloads.

::: zone target="chromeless"

## Action
**Try Standard tier for free for your first 60 days.**
 
After you enable and configure security policies for your subscription’s resources, you can view the security state of your resources and any issues in the Prevention section. You can also view a list of those issues on the Recommendations tile.

::: form action="OpenBlade[#blade/Microsoft_Azure_Security/SecurityMenuBlade/SecurityMenuBlade/0]" submitText="Explore Azure Security Center" :::

::: zone-end

::: zone target="docs"

To explore Azure Security Center, go to the [Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_Security/SecurityMenuBlade/SecurityMenuBlade/0).


## Learn more

To learn more, see [Azure Security Center documentation](/azure/security-center/).

::: zone-end
