[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

You can strengthen your organization's IT security posture by using the security features available in Microsoft 365 and Azure. This fifth and final article in the series explains how to integrate these security capabilities by using Microsoft Defender XDR and Azure monitoring services.

This article builds on the previous articles in the series:

1. [Map threats to your IT environment](./map-threats-it-environment.yml) describes methods to map examples of common threats, tactics, and techniques against an example of a hybrid IT environment that uses both on-premises and Microsoft cloud services.

2. [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml) maps an example of some Azure security services that create the first layer of defense to protect your Azure environment according to Azure Security Benchmark version 3.

3. [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml) describes an example of a series of attacks against your IT environment and how to add another layer of protection by using Microsoft Defender XDR.

## Architecture

:::image type="content" alt-text="Diagram of the complete reference architecture for this five-article series that shows an IT environment, threats, and security services." source="../media/microsoft-365-defender-security-integrate-azure-architecture.png" lightbox="../media/microsoft-365-defender-security-integrate-azure-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

This diagram shows a complete architecture reference. It includes an example of an IT environment, a set of example threats that are described according to their tactics (in blue), and their techniques (in the text box) according to the MITRE ATT&CK matrix. The MITRE ATT&CK matrix is covered in [Map threats to your IT environment](./map-threats-it-environment.yml). 

The diagram highlights several important services. Some, like Azure Network Watcher and Application Insights, focus on capturing data from specific services. Others, like Log Analytics (also known as Azure Monitor Logs) and Microsoft Sentinel, serve as core services because they can collect, store, and analyze data from a wide range of services, whether related to networks, compute, or applications.

At the center of the diagram are two layers of security services and a layer dedicated to specific Azure monitoring services, all integrated through Azure Monitor (shown on the left side of the diagram). The key component of this integration is Microsoft Sentinel.

The diagram shows the following services in **Core Monitoring Services** and in the **Monitor** layer:

- Azure Monitor
- Log Analytics
- Microsoft Defender for Cloud
- Microsoft Sentinel
- Network Watcher
- Traffic Analytics (part of Network Watcher)
- Application Insights
- Storage Analytics

### Workflow

1.  **Azure Monitor** is the umbrella for many Azure monitoring services. It includes log management, metrics, and Application Insights, among others. It also provides a collection of dashboards that are ready for use and management of alerts. For more information, see [Azure Monitor overview](/azure/azure-monitor/overview).

2.  **Microsoft Defender for Cloud** delivers recommendations for virtual machines (VMs), storage, applications, and other resources, that help an IT environment to be compliant with various regulatory standards, such as ISO and PCI. At the same time, Defender for Cloud offers a score for the security posture of systems that can help you track the security of your environment. Defender for Cloud also offers automatic alerts that are based on the logs that it collects and analyzes. Defender for Cloud was formerly known as Azure Security Center. For more information, see [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction).

3.  **Log Analytics** is one of the most important services. It's responsible for storing all the logs and alerts that are used to create alerts, insights, and incidents. Microsoft Sentinel works on top of Log Analytics. Basically, all data that Log Analytics ingests is available automatically to Microsoft Sentinel. Log Analytics is also known as Azure Monitor Logs. For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).

4.  **Microsoft Sentinel** works like a façade for Log Analytics. While Log Analytics stores logs and alerts from various sources, Microsoft Sentinel offers APIs that help with ingestion of logs from various sources. Those sources include on-premises VMs, Azure VMs, alerts from Microsoft Defender XDR and other services. Microsoft Sentinel correlates the logs to provide insights about what is going on in your IT environment, avoiding false positives. Microsoft Sentinel is the core of security and monitoring for Microsoft cloud services. For more information about Microsoft Sentinel, see [What is Microsoft Sentinel?](/azure/sentinel/overview).

The preceding services in this list are core services that work throughout Azure, Office 365, and on-premises environments. The following services focus on specific resources:

5.  **Network Watcher** provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. For more information, see [What is Azure Network Watcher?](/azure/network-watcher/network-watcher-monitoring-overview).

6.  **Traffic Analytics** is part of Network Watcher and works on top of logs from network security groups (NSGs). Traffic Analytics offers many dashboards that are capable of aggregating metrics from outbound and inbound connection in Azure Virtual Network. For more information, see [Traffic Analytics](/azure/network-watcher/traffic-analytics).

7.  **Application Insights** focuses on applications and provides extensible performance management and monitoring for live web apps, including support for a wide range of platform such as .NET, Node.js, Java, and Python. Application Insights is a feature of Azure Monitor. For more information, see [Application Insights overview](/azure/azure-monitor/app/app-insights-overview).

8.  **Azure Storage Analytics** performs logging and provides metrics for a storage account. You can use its data to trace requests, analyze usage trends, and diagnose issues with your storage account. For more information, see [Use Azure Storage analytics to collect logs and metrics data](/azure/storage/common/storage-analytics).

9.  Because this architecture reference is based on [Microsoft Zero Trust](/security/zero-trust/), the services and components under **Infrastructure and Endpoint** don't have specific monitoring services. Azure Monitor logs and Defender for Cloud are the main services that collect, store, and analyze logs from VMs and others compute services.

The central component of this architecture is Microsoft Sentinel. It consolidates all the logs and alerts that are generated by Azure security services, Microsoft Defender XDR, and Azure Monitor. After Microsoft Sentinel is implemented and receiving logs and alerts from the sources outlined in this article, you need to map queries to those logs in order to gather insights and detect indicators of compromise (IOCs). When Microsoft Sentinel captures this information, you can either investigate it manually or trigger automated responses that you configure to mitigate or resolve incidents. Automated actions might include blocking a user in Microsoft Entra ID or blocking an IP address by using the firewall.

For more information about Microsoft Sentinel, see [Microsoft Sentinel documentation](/azure/sentinel).

### How to access security and monitoring services

The following list provides information about how to access each of the services that are presented in this article:

- **Azure security services**. You can access all the Azure security services that are mentioned in the diagrams in this series of articles by using [Azure portal](https://portal.azure.com). In the portal, use the search function to locate the services that you're interested in and access them.

- **Azure Monitor**. Azure Monitor is available in all Azure subscriptions. You can access it from a search for *monitor* in the [Azure portal](https://portal.azure.com).

- **Defender for Cloud**. Defender for Cloud is available to anyone who accesses the [Azure portal](https://portal.azure.com). In the portal, search for *Defender for Cloud*.

- **Log Analytics**. To access Log Analytics, you must first create the service in the portal, because it doesn't exist by default. In the [Azure portal](https://portal.azure.com), search for *Log Analytics workspace*, and then select **Create**. After creation, you're able to access the service.

- **Microsoft Sentinel**. Because Microsoft Sentinel works on top of Log Analytics, you must first create a Log Analytics workspace. Next, search for *sentinel* in the [Azure portal](https://portal.azure.com). Then create the service by choosing the workspace that you want to have behind Microsoft Sentinel.

- **Microsoft Defender for Endpoint**. Defender for Endpoint is part of Microsoft Defender XDR. Access the service through [https://security.microsoft.com](https://security.microsoft.com). This is a change from the previous URL, `securitycenter.windows.com`.

- **Microsoft Defender for Cloud Apps**. Defender for Cloud Apps is part of Microsoft 365. Access the service through [https://portal.cloudappsecurity.com](https://portal.cloudappsecurity.com).

- **Microsoft Defender for Office 365**. Defender for Office 365 is part of Microsoft 365. Access the service through [https://security.microsoft.com](https://security.microsoft.com), the same portal used for Defender for Endpoint. (This is a change from the previous URL, `protection.office.com`.)

- **Microsoft Defender for Identity**. Defender for Identity is part of Microsoft 365. You access the service through [https://portal.atp.azure.com](https://portal.atp.azure.com). Although it's a cloud service, Defender for Identity is responsible for also protecting identity on on-premises systems.

- **Microsoft Endpoint Manager**. Endpoint Manager is the new name for Intune, Configuration Manager, and other services. Access it through [https://endpoint.microsoft.com](https://endpoint.microsoft.com). To learn more about accessing the services that are provided by Microsoft Defender XDR and how each portal is related, see [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml).

- **Azure Network Watcher**. To access Azure Network Watcher, search for *watcher* in the [Azure portal](https://portal.azure.com).

- **Traffic Analytics**. Traffic Analytics is part of Network Watcher. You can access it from the menu on the left side in Network Watcher. It's a powerful network monitor that works based on your NSGs that are implemented on your individual network interfaces and subnets. Network Watcher requires collection of information from the NSGs. For instructions on how to collect that information, see [Tutorial: Log network traffic to and from a virtual machine using the Azure portal](/azure/network-watcher/network-watcher-nsg-flow-logging-portal).

- **Application Insight**. Application Insight is part of Azure Monitor. However, you must first create it for the application that you want to monitor. For some applications built on Azure, such as Web Apps, you can create Application Insight directly from the provisioning of Web Apps. To access it, search for *monitor* in the [Azure portal](https://portal.azure.com). In the **Monitor** page, select **Applications** in the menu on the left side.

- **Storage Analytics**. Azure Storage offers various types of storage under the same storage account technology. You can find blobs, files, tables, and queues on top of storage accounts. Storage analytics offers a broad range of metrics to use with those storage services. Access Storage Analytics from your Storage account in the [Azure portal](https://portal.azure.com), then select **Diagnostic settings** in the menu on the left side. Choose one log analytics workspace to send that information. Then you can access a dashboard from **Insights**. Everything in your storage account that's being monitored is represented in the menu.

### Components

The example architecture in this article uses the following Azure components:

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that helps users access external and internal resources. In this architecture, it authenticates users that access Microsoft 365, Azure, and software as a service (SaaS) applications, and supports identity-based threat detection and response.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it provides the private network infrastructure for hosting workloads and collecting network-level telemetry.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a high-performance layer-4 load balancing service for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. In this architecture, it distributes traffic across VMs and services to ensure high availability and resilience.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, VMs run workloads and applications that require full control over the operating system and environment.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying and managing containerized applications. In this architecture, AKS orchestrates container deployment and scaling, which supports microservices and continuous integration and continuous delivery (CI/CD) pipelines.

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and app virtualization service. In this architecture, it provides secure remote access to desktops and applications for distributed users.

- The [Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. You can develop in your chosen language. Applications run and scale with ease on both Windows and Linux-based environments. In this architecture, Web Apps enables scalable and language-flexible deployment of web-based services.

- [Azure Storage](/azure/storage/common/storage-introduction) is scalable and secure storage for various data objects in the cloud, including object, blob, file, disk, queue, and table storage. In this architecture, it stores application data, logs, and backups with encryption and access control.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database engine that automates upgrading, patching, backups, and monitoring. In this architecture, it provides secure, scalable, and compliant data storage for structured application data.

## Solution details

Monitoring solutions on Azure might seem confusing at first, because Azure offers multiple monitoring services. However, each Azure monitoring service is important in the security and monitoring strategy that's described in this series. The articles in this series describe the various services and how to plan effective security for your IT environment.
1. [Map threats to your IT environment](./map-threats-it-environment.yml)
2. [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
3. [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)

### Potential use cases

This reference architecture provides a comprehensive view of Microsoft Cloud security services and demonstrates how to integrate them to achieve an optimal security posture.

Although you don't need to implement every security service shown, this example and the threat map illustrated in the architecture diagram can help you create your own threat map and plan your security strategy. Choose the Azure security services and Microsoft Defender XDR services that best suit your needs.

## Cost optimization

Pricing for the Azure services that are presented in this series of articles is calculated in various ways. Some services are free of charge, some have a charge for each use, and some have a charge that is based on licensing. The best way to estimate the pricing for any of the Azure security services is to use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator). In the calculator, search for a service that you're interested in, and then select it to get all the variables that determine the price for the service.

Microsoft Defender XDR security services work with licenses. For information about the licensing requirements, see [Microsoft Defender XDR prerequisites](/microsoft-365/security/defender/prerequisites?view=o365-worldwide).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

- [Defend against threats with Microsoft 365](/training/paths/m365-security-threat-protection)
- [Detect and respond to cyber attacks with Microsoft Defender XDR](/training/paths/defender-detect-respond)
- [Get started with Microsoft Defender XDR](/microsoft-365/security/defender/get-started)
- [Manage security with Microsoft 365](/training/paths/m365-security-management)
- [Protect against malicious threats with Microsoft Defender for Office 365](/training/paths/defender-office-365-malicious-threats)
- [Protect on-premises identities with Microsoft Defender for Cloud for Identity](/training/paths/defender-identity-protect-on-premises)

## Related resources

For more information about this reference architecture, see the other articles in this series:

- Part 1: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 2: [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 3: [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)

For related architectures on Azure Architecture Center, see the following article:

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
