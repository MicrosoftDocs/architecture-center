This is the last article from a series of 5 articles about how to build a defense in depth for your IT environment running on Microsoft cloud, considering Azure public cloud and Office 365.

Security Defense in depth is built with Azure Security services, Microsoft 365 Defender services and the integration among all those services through Azure Monitoring services and Microsoft Sentinel.

In article 1 (link) we explained an overall how you build a basic map that may explain how you may integrate Azure and Microsoft 365 Defender security services.

In article 2 (link) we explained some alternatives to map some examples of common threats (tactics and techniques) against an example of a hybrid IT environment with on-premises and Microsoft cloud services (Azure and Office 365).

In article 3 (link) we built and map an example of some Azure security services that create the first layer of defense to protect your Azure environment according to Azure Security Benchmark version 3 (link).

In article 4 (link) we built and map an example of a series of attacks against your IT environment and how to add another layer of protection but at this time with Microsoft 365 Defender services.

In this last article, we will show you how to integrate all Security services to deliver a great security posture to your IT environment. This article will consider Azure Monitoring services and Microsoft Sentinel, which will be the core piece to integrate the Security services explained in the previous articles.

**Introduction**

Monitoring solutions on Azure may seem confusing at first sight, as Azure offers multiple monitoring services, but they are not. Each Microsoft Azure monitoring service has its own importance in the entire Microsoft Security and Monitoring strategy.

There is a couple of important services that will be presented in the next Architecture diagram. Some of those services are focused on capturing information from specific services such as network (Network watcher) or applications (Application Insights). For some of them, like "Azure Monitor Logs" (aka Log Analytics) and "Microsoft Sentinel", we may consider them as core services as they can collect, store and analyze information from different services, regardless of they are Network, Compute or applications services.

Those are the services in the diagram:

-   Azure Monitor

-   Azure Monitor Logs (aka Log Analytics)

-   Microsoft Defender for Cloud (formerly known as Azure Security Center)

-   Microsoft Sentinel

-   Network Watcher

-   Traffic Analytics (part of Network Watcher)

-   Application Insights

-   Storage Analytics

The diagram below shows a complete architecture reference including an example of a customer environment, a set of known threats used as an example and described according to its tactics (in blue), and its techniques (in the text box) according to the Mitre Att&ck matrix. In the central part of the diagram, we have two layers of security services and one layer with specific Azure monitoring services that are integrated through Azure Monitoring core services (on the left side of the diagram), which the key component of this integration is Microsoft Sentinel.

:::image type="content" alt-text="Image alt text." source="images/microsoft-365-defender-security-integrate-azure-architecture.png" lightbox="images/microsoft-365-defender-security-integrate-azure-architecture.png":::

**Components**

The components, part of the diagram, are explained in a nutshell so that you may digest the information quickly. For detailed information about each service, you may check the link provided.

1.  **Azure Monitor** is the "umbrella" for many Azure monitoring services that include log management, metrics, application insight among others. It also provides a collection of dashboards ready to be consumed and an Alert management system. You may check more about Azure Monitor services at this link:

[Azure Monitor overview - Azure Monitor \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/overview)

2.  **Microsoft Defender for Cloud (formerly known as Azure Security Center)** delivers a series of recommendations for VMs, Storage, Applications, etc, that helps you to be compliant with different regulatory standards such as ISO or PCI and at the same time offers a security score systems that help you track how secure your environment is. It also offers an automatic Alert system based on the logs collected and analyzed by Microsoft Defender for Cloud.

See more about it at this link:

[Microsoft Defender for Cloud - an introduction \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)

3.  **Azure Monitor Logs (aka Log analytics)** is one of the most important services. It is the responsible for storing all the logs and alerts that will be used to create Alerts, Insights and Incidents. It is also the service which Microsoft Sentinel work on top of it. Basically, everything you ingest on Log Analytics will be available automatically to Microsoft Sentinel. You may check more about Log Analytics in this link:

[Overview of Log Analytics in Azure Monitor - Azure Monitor \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)

4.  **Microsoft Sentinel** works like a facade for Log Analytics. While Log Analytics stores all logs and alerts from different sources, like on-premises VMs, Azure VMs and Alerts from Microsoft 365 Defender Security services, among many others, Microsoft Sentinel offers APIs that will help you to ingest logs from different sources and correlate all of them, so that you may have insights more accurately about what is going on in your environment avoiding false positives.

Microsoft Sentinel is the core of this whole Security and monitoring system that Microsoft Cloud has.

More about Azure Sentinel: [What is Microsoft Sentinel? \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/sentinel/overview)

The four services above may be considered as core services because they work throughout Azure, Office 365 and on-premises environments, but there are still a couple of others Monitoring services that are focused on specific resources.

5.  **Network Watcher** provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. More about it:

[Azure Network Watcher \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview)

6.  **Traffic Analytics,** part of Network Watcher, works on top of NSG (Network Security Group) logs and offer lots of nice dashboards that are capable of agreeing on different metrics from outbound and inbound connection in your Azure Virtual Network. More about it:

[Azure traffic analytics \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/network-watcher/traffic-analytics)

7.  **Application Insights,** that is under **Azure Monitor,** is focused on the application and provides extensible application performance management and monitoring for live web apps, including support for a wide variety of platform such as NET, Node.js, Java, and Python. See more about Application Insights at:

[Application Insights overview - Azure Monitor \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)

8.  **Azure Storage Analytics** is a Storage service to performs logging and provides metrics data for a storage account. You can use this data to trace requests, analyze usage trends, and diagnose issues with your storage account. See more about this service in this link:

[Use Azure Storage analytics to collect logs and metrics data \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-analytics)

9.  As this architecture reference was built based on Microsoft Zero Trust pillars, under the pillar "Infrastructure and Endpoint" was not described any specific Monitoring services because actually Azure Monitor logs and Microsoft Defender for Cloud are the main services to collect, store and analyze logs from VMs and others compute services.

The key component in this architecture is Microsoft Sentinel as it is the responsible to connect all the logs and alerts provided by Azure Security Services, Microsoft 365 Defender and Azure Monitor services.

Just in a nutshell, once you have Microsoft **Sentinel** implemented and receive logs and alerts from all the sources we mentioned in this article, the next step is mapping a set of queries that will inquire those logs for insights and evidence of IOCs (Indicators of Compromise). When something is captured by Microsoft Sentinel, you will be able to investigate it or automate it through an automatic action to mitigate or solve the incident, such as blocking a user on your Azure AD or blocking an IP address through your firewall.

As Microsoft Sentinel is not covered in details in this article, you may see more about Sentinel at this link:

[Microsoft Sentinel documentation \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/sentinel/)

**Potential use cases**

This architecture reference may help you understand the whole picture of Microsoft Cloud security services an how integrate them for a best security posture.

You don't need necessarily consider all security services presented in this architecture, but through this initial customer environment as example and a threat map represented through this diagram, you may understand how to create your own map and then plan accordingly for your security strategy by selecting the right Azure security services and the Microsoft 365 Defender services that you will want to integrate with Azure so that you may have the security you will need in your environment.

**How to access Azure Security, Monitoring and Microsoft 365 Defender services**

As we covered many different Services, here it is information about how to access each of those Services:

-   **Azure Security services**

All Azure Security services mentioned in the diagrams may be accessed through Azure Portal. Simply go to <https://portal.azure.com> and search for the service you are interested in.

-   **Azure Monitor**

Azure Monitor is a service that is available in all Azure subscription, so you only need to access Azure Portal at <https://portal.azure.com> and search for the service by typing "monitor".

-   **Microsoft Defender for Cloud**

Microsoft Defender for Cloud is also already available for anyone that access Azure Portal for the first time. To access it, go to Azure Portal at <https://portal.azure.com> and search for "Microsoft Defender for Cloud".

-   **Azure Monitor Logs (aka Log Analytics)**

To access Log Analytics, you will have to create the service as it doesn't exist by default. Go to Azure Portal at <https://portal.azure.com> , search for "Log Analytics workspace" and then click on "Create". After you create it, you will be able to access the service.

-   **Microsoft Sentinel**

Microsoft Sentinel works on top of a Log Analytics workspace, so you will have to create first a Log Analytics workspace, then, search for "Sentinel" at Azure Portal, <https://portal.azure.com>, then create the service by choosing the Log Analytics workspace you want to have behind Microsoft Sentinel.

-   **Microsoft Defender for Endpoint**

Microsoft Defender for Endpoint is part of Microsoft 365 Defender. You access the service through this URL: <https://security.microsoft.com>

In the past, you were able to access the service through <https://securitycenter.windows.com>

-   **Microsoft Defender for Cloud Apps**

Microsoft Defender for Endpoint is part of Microsoft 365. You access the service through this URL: <https://portal.cloudappsecurity.com>

-   **Microsoft Defender for Office 365**

Microsoft Defender for Office 365 is part of Microsoft 365. You access the service through this URL: <https://security.microsoft.com> that is the same portal used with Endpoint manager. In the past, you were able to access the service through <https://protection.office.com>

-   **Microsoft Defender for Identity**

Microsoft Defender for Identity is part of Microsoft 365. You access the service through this URL: <https://portal.atp.azure.com> . Remember, despite the fact that it is a cloud service, this service is responsible to protect Identities on-premises.

-   **Microsoft Endpoint Manager**

Microsoft Endpoint Manager is the rebranded name for Intune, Configuration Manager and other services. You may access it through the portal <https://endpoint.microsoft.com>

**NOTE:**

In article 4 \<LINK\>, regarding Microsoft 365 Defender, you can have more details about how to access the services provided by Microsoft 365 Defender and how each Portal is related to each other.

-   **Azure Network watcher**

Azure Network watcher is part of Azure, so you just need to search for "Network watcher" at Azure portal, <https://portal.azure.com>.

-   **Traffic Analytics**

Traffic Analytics is part of Network watcher. You will find in the left menu once you start the Network watcher. It is a powerful Azure network monitor that works based on your Network Security Groups (NSG) implemented on your NICs or Subnets. To make it work, you will have to collect information from the NSGs. See it how to do it, in that document page:

[Tutorial: Log network traffic flow to and from a virtual machine - Azure portal \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-portal)

-   **Application Insight**

Application Insight is part of Azure Monitor; however, you will have to create it in order to use it, according to the Application you want to monitor. For some applications built on Azure, such as Web Apps, you can create Application Insight directly from the Web Apps provisioning. So, to access it, you just need to search for "monitor" on Azure Portal, then, once in Monitor service, in the left menu, you will find "Applications".

-   **Storage Analytics**

Azure storage offers different types of storage under the same storage account technology. You may find blobs, files, table and queues on top of storage accounts. Storage analytics offers a broad range of metrics to use with those storages' services. You will be able to access it, going to your Storage account at Azure Portal (https://portal.azure.com) , then setting "Diagnostic settings" on the left menu and choosing one log analytics workspace to send that information. Then, you may access some dashboard on "Insights" that you will see on the left menu. But you will also be able to access a series of workbooks on "workbooks" at the left menu, Metrics and Alerts for your storage account. Everything will be inside your storage account being monitored, in the left menu.

**How is the pricing for Microsoft Security services**

It was presented in this series of articles different Microsoft security services, as you read it, you may integrate all of them to get a best security posture, however their prices is set in different ways. Some of them are free of charge, some of them are charged per usage and some of them, as Microsoft 365 Defender are charged based on different types of license.

So, the best way to get any of the **Azure** Security services prices is visiting Azure pricing calculator at [Pricing Calculator \| Microsoft Azure](https://azure.microsoft.com/en-us/pricing/calculator/).

:::image type="content" alt-text="Image alt text." source="images/pricing-calculator-web-page.png":::

You will have to search for the service you are interested in and click on it to get all the variables that you provide you the price for the service.

Microsoft 365 Defender security services works with licenses. The link below shows all licensing requirements for Microsoft 365 Defender services.

[Microsoft 365 Defender prerequisites \| Microsoft Docs](https://docs.microsoft.com/en-us/microsoft-365/security/defender/prerequisites?view=o365-worldwide)

**NEXT STEPS**

This content and set of diagrams are part of a series of 5 articles. You may review the other articles in the link below:

-   Article 1 of 5 - Microsoft cloud basic security map introduction

-   Article 2 of 5 - Customer IT environment and the Threats

-   Article 3 of 5 - Building the first layer of defense with Azure Security services

-   Article 4 of 5 - Building the second layer of defense with Microsoft 365 Defender Security services
