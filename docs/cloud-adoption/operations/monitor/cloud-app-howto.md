---
title: Cloud monitoring guide – Monitoring strategy for cloud deployment models
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
author: mgoedtel
ms.author: magoedte
ms.date: 07/31/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: operate
services: azure-monitor
---

# Cloud monitoring guide: Monitoring strategy for cloud deployment models

This article includes our recommended monitoring strategy for each of the cloud deployment models, based on the following criteria:

- You require continued commitment to Operations Manager or other enterprise monitoring platform. This is because of integration with your IT operations processes, knowledge and expertise, or because certain functionality isn't available yet in Azure Monitor.
- You have to monitor workloads both on-premises and in the public cloud, or just in the cloud.
- Your cloud migration strategy includes modernizing IT operations and moving to our cloud monitoring services and solutions.
- You might have critical systems that are air-gapped or physically isolated, hosted in a private cloud or on physical hardware, and need to be monitored.

Our strategy includes support for monitoring infrastructure (compute, storage, and server workloads), application (end-user, exceptions, and client), and network resources to deliver a complete, service-oriented monitoring perspective.

## Azure cloud monitoring

Azure Monitor is the platform service that provides a single source for monitoring Azure resources. It's designed for cloud solutions that are built on Azure, and that support a business capability that is based on VM workloads or complex architectures that use microservices and other platform resources. It monitors all layers of the stack, starting with tenant services such as Azure Active Directory Domain Services, and subscription-level events and Azure service health. It also monitors infrastructure resources like VMs, storage, and network resources, and, at the top layer, your application. Monitoring each of these dependencies, and collecting the right signals that each can emit, gives you the observability of applications and the key infrastructure you need.

The following table summarizes the recommended approach to monitoring each layer of the stack.

<!-- markdownlint-disable MD033 -->

Layer | Resource | Scope | Method
---|---|---|----
Application | Web-based application running on .NET, .NET Core, Java, JavaScript, and Node.js platform on an Azure VM, Azure App Services, Azure Service Fabric, Azure Functions, and Azure Cloud Services | Monitor a live web application to automatically detect performance anomalies, identify code exceptions and issues, and collect usability telemetry. |  Application Insights
Containers | Azure Kubernetes Service/Azure Container Instances | Monitor capacity, availability, and performance of workloads running on containers and container instances. | Azure Monitor for containers
Guest operating system | Linux and Windows VM operating system | Monitor capacity, availability, and performance. Map dependencies hosted on each VM, including the visibility of active network connections between servers, inbound and outbound connection latency, and ports across any TCP-connected architecture. | Azure Monitor for VMs
Azure resources - PaaS | Azure Database services (for example, SQL or mySQL) | Azure Database for SQL performance metrics. | Enable diagnostic logging to stream SQL data to Azure Monitor Logs.
Azure resources - IaaS | 1. Azure Storage<br/> 2. Azure Application Gateway<br/> 3. Azure Key Vault<br/> 4. Network security groups<br/> 5. Azure Traffic Manager | 1. Capacity, availability, and performance.<br/> 2. Performance and diagnostic logs (activity, access, performance, and firewall).<br/> 3. Monitor how and when your key vaults are accessed, and by whom.<br/> 4. Monitor events when rules are applied, and the rule counter for how many times a rule is applied to deny or allow.<br/>5. Monitor endpoint status availability. | 1. Storage metrics for Blob storage.<br/> 2. Enable diagnostic logging and configure streaming to Azure Monitor Logs.<br/> 3. <br/> 4. Enable diagnostic logging of network security groups, and configure streaming to Azure Monitor Logs.<br/> 5. Enable diagnostic logging of Traffic Manager endpoints, and configure streaming to Azure Monitor Logs.
Network| Communication between your virtual machine and one or more endpoints (another VM, a fully qualified domain name, a uniform resource identifier, or an IPv4 address). | Monitor reachability, latency, and network topology changes that occur between the VM and the endpoint. | Azure Network Watcher
Azure subscription | Azure service health and basic resource health | <li> Administrative actions performed on a service or resource.<br/><li> Service health with an Azure service is in a degraded or unavailable state.<br/><li> Health issues detected with an Azure resource from the Azure service perspective.<br/><li> Operations performed with Azure Autoscale indicating a failure or exception. <br/><li> Operations performed with Azure Policy indicating that an allowed or denied action occurred.<br/><li> Record of alerts generated by Azure Security Center. |Delivered in the Activity Log for monitoring and alerting by using Azure Resource Manager.
Azure tenant|Azure Active Directory || Enable diagnostic logging, and configure streaming to Azure Monitor Logs.

<!-- markdownlint-enable MD033 -->

## Private cloud monitoring

You can achieve holistic monitoring of Azure Stack with System Center Operations Manager. Specifically, you can monitor the workloads running in the tenant, the resource level, on the virtual machines, and the infrastructure hosting Azure Stack (physical servers and network switches). You can also achieve holistic monitoring with a combination of [infrastructure monitoring capabilities](/azure/azure-stack/azure-stack-monitor-health) included in Azure Stack. These capabilities help you view health and alerts for an Azure Stack region and the [Azure Monitor service](/azure/azure-stack/user/azure-stack-metrics-azure-data) in Azure Stack, which provides base-level infrastructure metrics and logs for most services.

If you've already invested in Operations Manager, use the Azure Stack management pack to monitor the availability and health state of Azure Stack deployments. This includes regions, resource providers, updates, update runs, scale units, unit nodes, infrastructure roles, and their instances (logical entities comprised of the hardware resources). It uses the Health and Update resource provider REST APIs to communicate with Azure Stack. To monitor physical servers and storage devices, use the OEM vendors' management pack (for example, provided by Lenovo, Hewlett Packard, or Dell). Operations Manager can natively monitor the network switches to collect basic statistics by using the SNMP protocol. Monitoring the tenant workloads is possible with the Azure management pack by following two basic steps. Configure the subscription that you want to monitor, and then add the monitors for that subscription.

## Summary

To summarize, the following table highlights monitoring scenarios and how our monitoring platforms support each scenario.

Scenario | Azure Monitor | Operations Manager
:--|:---|:---
Infrastructure monitoring | Currently delivers health monitoring experience for Azure VMs, somewhat similar to Operations Manager. | Supports monitoring most of the infrastructure from the corporate network. Tracks availability state, metrics, and alerts for Azure VMs, SQL, and storage via the Azure management pack (polling Azure Resource Manager APIs).
Monitor server workloads | Can collect IIS and SQL Server error logs, Windows events, and performance counters. Requires creating custom queries, alerts, and visualizations. | Supports monitoring most of the server workloads with available management packs. Requires either the Log Analytics Windows agent or Operations Manager agent on the VM, reporting back to the management group on the corporate network.
Web application monitoring | Application Insights includes support for the latest versions of .NET, Java, and other platforms. Comprehensive web application monitoring to detect and help diagnose issues with code, capacity, and responsiveness. | Supports monitoring older versions of .NET and Java web servers. Requires creating a custom management pack by using REST API to query data from Application Insights and stream to Operations Manager.
Azure service monitoring | [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview) provides the ability to monitor your service, and how the health of the underlying Azure infrastructure affects your service. | While there is no native monitoring of Azure service health provided today through a management pack, you can create custom workflows to query Azure service health alerts. Use the Azure REST API, and get alerts through your existing notifications.
Network performance monitoring | Azure Monitor Network Insights monitors the Azure networking stack, network performance, and NSGs. Azure Monitor for VM's Map feature includes connectivity metrics between Azure and other environment VMs. | Supports availability checks, and collects basic statistics from network devices by using the SNMP protocol from the corporate network.
Data aggregation | Azure Monitor Logs and alert management support processing data from Operations Manager and other platforms. | Relies on SQL Server Reporting Services pre-canned or custom reports, third-party visualization solutions, or a custom Power BI implementation. There are scale and performance limitations with the Operations Manager data warehouse. Integrate with Azure Monitor Logs as an alternative for data aggregation requirements. Integration is achieved by configuring the Log Analytics connector.
End-to-end diagnostics, root-cause analysis, and timely troubleshooting | Azure Monitor delivers end-to-end diagnostics and root-cause analysis for developer and IT operations, from your cloud and on-premises environments. It does this through several features and tools that provide valuable insights into your applications and other resources that they depend on.| Supports end-to-end diagnostics and troubleshooting only for on-premises infrastructure and applications. It uses other System Center components or partner solutions.
Experiences – Dashboards, reports, integrations with IT/DevOps tools | Supports integration with Azure dashboards, Power BI, Grafana, and integration with ITSM tools to forward collected data and alerts. | Supports dashboards natively, or by using partner solutions from Squared Up and Savision. Integrates with ITSM tools by using custom code, System Center Orchestrator, or partner solutions based on the Operations Manager SDK.

## Next steps

> [!div class="nextstepaction"]
> [Collecting the right data](./data-collection.md)
