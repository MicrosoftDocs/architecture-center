---
title: Cloud monitoring guide – Monitoring strategy for cloud deployment models
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
author: MGoedtel
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
Azure resources - IaaS | 1. Azure Storage<br/> 2. Azure Application Gateway<br/> 3. Azure Key Vault<br/> 4. Network security groups<br/> 5. Azure Traffic Manager | 1. Capacity, availability, and performance.<br/> 2. Performance and diagnostic logs (activity, access, performance, and firewall).<br/> 3. Monitor how and when your key vaults are accessed, and by whom.<br/> 4. Monitor events when rules are applied, and the rule counter for how many times a rule is applied to deny or allow.<br/>5. Monitor endpoint status availability. | 1. Storage metrics for Blob storage.<br/> 2. Enable diagnostic logging and configure streaming to Azure Monitor Logs.<br/> 3. Enable diagnostic logging and configure streaming to Azure Monitor Logs, and enable the [Azure Key Vault Analytics Solution](https://docs.microsoft.com/azure/azure-monitor/insights/azure-key-vault). <br/> 4. Enable diagnostic logging of network security groups, and configure streaming to Azure Monitor Logs.<br/> 5. Enable diagnostic logging of Traffic Manager endpoints, and configure streaming to Azure Monitor Logs.
Network| Communication between your virtual machine and one or more endpoints (another VM, a fully qualified domain name, a uniform resource identifier, or an IPv4 address). | Monitor reachability, latency, and network topology changes that occur between the VM and the endpoint. | Azure Network Watcher
Azure subscription | Azure service health and basic resource health | <li> Administrative actions performed on a service or resource.<br/><li> Service health with an Azure service is in a degraded or unavailable state.<br/><li> Health issues detected with an Azure resource from the Azure service perspective.<br/><li> Operations performed with Azure Autoscale indicating a failure or exception. <br/><li> Operations performed with Azure Policy indicating that an allowed or denied action occurred.<br/><li> Record of alerts generated by Azure Security Center. |Delivered in the Activity Log for monitoring and alerting by using Azure Resource Manager.
Azure tenant|Azure Active Directory || Enable diagnostic logging, and configure streaming to Azure Monitor Logs.

<!-- markdownlint-enable MD033 -->

## Hybrid cloud monitoring

This section is currently under development to deliver a comprehensive set of recommendations intended to address your interest for this cloud model, and will be made available shortly.  

## Private cloud monitoring

You can achieve holistic monitoring of Azure Stack with System Center Operations Manager. Specifically, you can monitor the workloads running in the tenant, the resource level, on the virtual machines, and the infrastructure hosting Azure Stack (physical servers and network switches). You can also achieve holistic monitoring with a combination of [infrastructure monitoring capabilities](/azure/azure-stack/azure-stack-monitor-health) included in Azure Stack. These capabilities help you view health and alerts for an Azure Stack region and the [Azure Monitor service](/azure/azure-stack/user/azure-stack-metrics-azure-data) in Azure Stack, which provides base-level infrastructure metrics and logs for most services.

If you've already invested in Operations Manager, use the Azure Stack management pack to monitor the availability and health state of Azure Stack deployments. This includes regions, resource providers, updates, update runs, scale units, unit nodes, infrastructure roles, and their instances (logical entities comprised of the hardware resources). It uses the Health and Update resource provider REST APIs to communicate with Azure Stack. To monitor physical servers and storage devices, use the OEM vendors' management pack (for example, provided by Lenovo, Hewlett Packard, or Dell). Operations Manager can natively monitor the network switches to collect basic statistics by using the SNMP protocol. Monitoring the tenant workloads is possible with the Azure management pack by following two basic steps. Configure the subscription that you want to monitor, and then add the monitors for that subscription.

## Next steps

> [!div class="nextstepaction"]
> [Collecting the right data](./data-collection.md)
