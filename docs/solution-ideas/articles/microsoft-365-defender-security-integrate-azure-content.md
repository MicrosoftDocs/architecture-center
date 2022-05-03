This is the last article from a series of 5 articles about how to build defense in depth for your IT environment running on Microsoft cloud, considering Azure public cloud and Office 365.

Security defense in depth is built with Azure Security services, Microsoft 365 Defender services, and the integration of those services through Azure Monitoring services and Microsoft Sentinel.

[Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml), the first article, provides an overall view of how you can integrate Azure and Microsoft 365 Defender security services.

[Customer IT environment and the threats](./map-threats-it-environment.yml), the second article, describes some alternatives to map examples of common threats (tactics and techniques) against an example of a hybrid IT environment with on-premises and Microsoft cloud services (Azure and Office 365).

[Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml), the third article, maps an example of some Azure security services that create the first layer of defense to protect your Azure environment according to Azure Security Benchmark version 3 (link).

[Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml), the fourth article, describes an example of a series of attacks against your IT environment and how to add another layer of protection but at this time with Microsoft 365 Defender services.

In this last article, we show you how to integrate all security services to deliver a great security posture to your IT environment. This article considers Azure Monitoring services and Microsoft Sentinel, which will be the core piece to integrate the security services that are explained in the previous articles.

## Introduction

Monitoring solutions on Azure may seem confusing at first sight, because Azure offers multiple monitoring services. However, each Microsoft Azure monitoring service has its own importance in the Microsoft Security and Monitoring strategy.

There are a couple of important services that are presented in the next Architecture diagram. Some of those services are focused on capturing information from specific services, such as network (Network watcher) or applications (Application Insights). For some of them, like "Azure Monitor Logs" (also known as Log Analytics) and "Microsoft Sentinel", consider them as core services because they can collect, store, and analyze information from different services, regardless of whether they are network, compute, or applications services.

Those are the services in the diagram:

- Azure Monitor
- Azure Monitor Logs (aka Log Analytics)
- Microsoft Defender for Cloud (formerly known as Azure Security Center)
- Microsoft Sentinel
- Network Watcher
- Traffic Analytics (part of Network Watcher)
- Application Insights
- Storage Analytics

The following diagram shows a complete architecture reference, including an example of a customer environment, a set of known threats used as an example and described according to its tactics (in blue), and its techniques (in the text box) according to the MITRE ATT&CK matrix. The central part of the diagram has two layers of security services. There is also one layer with specific Azure monitoring services that are integrated through Azure Monitoring core services (on the left side of the diagram). The key component of this integration is Microsoft Sentinel.

:::image type="content" alt-text="Image alt text." source="../media/microsoft-365-defender-security-integrate-azure-architecture.png" lightbox="../media/microsoft-365-defender-security-integrate-azure-architecture.png":::

©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

## Components

The components, part of the diagram, are explained in a nutshell so that you may digest the information quickly. For detailed information about each service, you may check the link provided.

1.  **Azure Monitor** is the "umbrella" for many Azure monitoring services that include log management, metrics, application insight among others. It also provides a collection of dashboards that are ready to be consumed and an alert management system. For more information about Azure Monitor, see [Azure Monitor overview](/azure/azure-monitor/overview).

2.  **Microsoft Defender for Cloud** (formerly known as Azure Security Center) delivers a series of recommendations for VMs, storage, applications, etc., that helps you to be compliant with different regulatory standards, such as ISO or PCI. At the same time, it offers a security score systems that can help you track how secure your environment is. It also offers an automatic alert system based on the logs that are collected and analyzed by Defender for Cloud. For more information about Defender for Cloud, see [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction).

3.  **Azure Monitor Logs**, also known as Log Analytics, is one of the most important services. It is the responsible for storing all the logs and alerts that will be used to create Alerts, Insights and Incidents. It is also the service which Microsoft Sentinel work on top of it. Basically, everything you ingest on Log Analytics will be available automatically to Microsoft Sentinel. For more information about Log Analytics, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).

4.  **Microsoft Sentinel** works like a façade for Log Analytics. While Log Analytics stores all logs and alerts from various sources, Microsoft Sentinel offers APIs that help with ingestion of logs from various sources. Those sources include on-premises VMs, Azure VMs, alerts from Microsoft 365 Defender Security, and others. Microsoft Sentinel correlates the logs to provide insights about what is going on in your environment, avoiding false positives. Microsoft Sentinel is the core of this whole Security and monitoring system that Microsoft Cloud has. For more information about Microsoft Sentinel, see [What is Microsoft Sentinel?](/azure/sentinel/overview).

The services in the preceding list may be considered core services because they work throughout Azure, Office 365, and on-premises environments. At the same time, there are also other monitoring services that are focused on specific resources:

5.  **Network Watcher** provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. For more information about Network Watcher, see [What is Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)?

6.  **Traffic Analytics** is part of Network Watcher and works on top of logs from network security groups (NSGs). Traffic Analytics offers many dashboards that are capable of agreeing on different metrics from outbound and inbound connection in Azure Virtual Network. For more information about Traffic Analytics, see [Traffic Analytics](/azure/network-watcher/traffic-analytics).

7.  **Application Insights**, which is a feature of Azure Monitor, is focused on applications and provides extensible performance management and monitoring for live web apps, including support for a wide variety of platform such as .NET, Node.js, Java, and Python. For more information about Application Insights, see [Application Insights overview](/azure/azure-monitor/app/app-insights-overview).

8.  **Azure Storage Analytics** is a storage service that performs logging and provides metrics for a storage account. You can use this data to trace requests, analyze usage trends, and diagnose issues with your storage account. For more information about using Storage Analytics to collect logs and metrics, see [Use Azure Storage analytics to collect logs and metrics data](/azure/storage/common/storage-analytics).

9.  Because this architecture reference was based on Microsoft Zero Trust pillars, under the pillar "Infrastructure and Endpoint" was not described any specific Monitoring services because actually Azure Monitor logs and Microsoft Defender for Cloud are the main services to collect, store and analyze logs from VMs and others compute services.

The key component in this architecture is Microsoft Sentinel, because it connects all the logs and alerts that are provided by Azure Security Services, Microsoft 365 Defender, and Azure Monitor services. After you have Microsoft Sentinel implemented and receiving logs and alerts from all the sources that his article mentions, the next step is to map a set of queries that query those logs for insights and evidence of indicators of compromise (IOCs). When something is captured by Microsoft Sentinel, you will be able to investigate it or automate it through an automatic action to mitigate or solve the incident, such as blocking a user on your Azure AD or blocking an IP address through your firewall.

For more information about Microsoft Sentinel, see [Microsoft Sentinel documentation](/azure/sentinel)

## Potential use cases

This architecture reference may help you understand the whole picture of Microsoft Cloud security services and to how integrate them for a best security posture.

You don't necessarily need to consider all of the security services presented in this architecture. However, this example and the threat map represented in the architecture diagram can help you to understand how to create your own map and then plan accordingly for your security strategy. Select the right Azure security services and the Microsoft 365 Defender services that you want to integrate with Azure so that your environment has the security that it needs.

## How to access Azure Security, Monitoring and Microsoft 365 Defender services

Because this article presents many different services, the following list presents information about how to access each of those services:

- **Azure Security services**. You can access all of the Azure security services mentioned in the diagrams in this series of articles through the [Azure portal](https://portal.azure.com). In the portal, search for the service that you are interested in.

- **Azure Monitor**. Azure Monitor is available in all Azure subscriptions. You can access it from a search for *monitor* in the [Azure portal](https://portal.azure.com).

- **Microsoft Defender for Cloud**. Microsoft Defender for Cloud is also available to anyone who accesses the [Azure portal](https://portal.azure.com) for the first time. In the portal search for *Microsoft Defender for Cloud*.

- **Azure Monitor Logs (aka Log Analytics)**. To access Log Analytics, you will must create the service, because it doesn't exist by default. In the [Azure portal](https://portal.azure.com), search for *Log Analytics workspace*, and then click **Create**. You are able to access the service after after you create it.

- **Microsoft Sentinel**. Microsoft Sentinel works on top of a Log Analytics. So, you must first create a Log Analytics workspace. Next, search for *sentinel* in the [Azure portal](https://portal.azure.com). Then create the service by choosing the workspace that you want to have behind Microsoft Sentinel.

- **Microsoft Defender for Endpoint**. Microsoft Defender for Endpoint is part of Microsoft 365 Defender. Access the service through [https://security.microsoft.com](https://security.microsoft.com). (This is a change from the previous URL, *securitycenter.windows.com*.)

- **Microsoft Defender for Cloud Apps**. Microsoft Defender for Cloud Apps is part of Microsoft 365. Access the service through [https://portal.cloudappsecurity.com](https://portal.cloudappsecurity.com).

- **Microsoft Defender for Office 365**. Microsoft Defender for Office 365 is part of Microsoft 365. Access the service through [https://security.microsoft.com](https://security.microsoft.com), the same portal used for Defender for Endpoint. (This is a change from the previous URL, *protection.office.com*.)

- **Microsoft Defender for Identity**. Microsoft Defender for Identity is part of Microsoft 365. You access the service through [https://portal.atp.azure.com](https://portal.atp.azure.com). Despite the fact that it is a cloud service, Defender for Identity is responsible for also protecting identity on on-premises systems.

- **Microsoft Endpoint Manager**. Microsoft Endpoint Manager is the new name for Intune, Configuration Manager, and other services. Access it through [https://endpoint.microsoft.com](https://endpoint.microsoft.com).

  > [!NOTE]
  >
  > To learn more about accessing the services that are provided by Microsoft 365 Defender and how each portal is related, see [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml), the fourth article in this series of articles.

- **Azure Network Watcher**. To access Azure Network Watcher, search for *watcher* in the [Azure portal](https://portal.azure.com).

- **Traffic Analytics**. Traffic Analytics is part of Network Watcher. You can access it from the menu on the left side in Network Watcher. It is a powerful network monitor that works based on your NSGs that are implemented on your individual network interfaces and subnets. Network Watcher requires collection of information from the NSGs. For instructions in collecting that information, see [Tutorial: Log network traffic to and from a virtual machine using the Azure portal](/azure/network-watcher/network-watcher-nsg-flow-logging-portal).

- **Application Insight**. Application Insight is part of Azure Monitor. However, you must first create it for the application that you want to monitor. For some applications built on Azure, such as Web Apps, you can create Application Insight directly from the provisioning of Web Apps. To access it, search for *monitor* in the [Azure portal](https://portal.azure.com). In the **Monitor** page, select **Applications** in the menu on the left side.

- **Storage Analytics**. Azure Storage offers various types of storage under the same storage account technology. You may find blobs, files, table and queues on top of storage accounts. Storage analytics offers a broad range of metrics to use with those storage services. Access Storage Analytics from your Storage account in the [Azure portal](https://portal.azure.com), then select **Diagnostic settings** in the menu on the left side. Choose one log analytics workspace to send that information. Then, you may access some dashboard from **Insights** in the menu on the left side. You can also access a series of workbooks from **workbooks** in the menu on the left side, Metrics and Alerts for your storage account. Everything in your storage account that being monitored is represented in menu.

## How is the pricing for Microsoft Security services

The pricing for the services that are presented in this series of articles is calculated in various ways. Some services are free of charge, some of have a charge for each use, and some of them have a charge that is based on licensing. So, the best way to estimate the pricing for any of the Azure Security services is to use the [Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/).

:::image type="content" alt-text="Image alt text." source="../media/pricing-calculator-web-page.png" lightbox="../media/pricing-calculator-web-page.png":::

In the calculator, search for the service that you are interested in, and select it to get all the variables that determine the price for the service.

Microsoft 365 Defender security services works with licenses. For information about the licensing requirements, see [Microsoft 365 Defender prerequisites](/microsoft-365/security/defender/prerequisites?view=o365-worldwide).


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- Part 2: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 3: [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
