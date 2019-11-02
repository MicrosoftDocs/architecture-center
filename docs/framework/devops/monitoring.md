---
title: Monitoring for DevOps 
description: Describes how to monitor your workload to ensure your DevOps infrastructure is working as intended.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Monitoring for DevOps

What you cannot see, you cannot measure. What you cannot measure, you cannot improve. This classic management axiom is true in the cloud as well. Traditional application and infrastructure monitoring is based on whether the application is running or not, or what response time it is giving. However, cloud-based monitoring offer many more opportunities that you should be leveraging in order to give your users the best experience.

## Application Monitoring

Application Insights is the Azure Service that allows not only to verify that your application is running correctly, but it makes application troubleshooting easier, and can be used for custom business telemetry that will tell you whether your application is being used as intended.

Make sure you leverage all the rich information that Application Insights can provide about your application. This list is not exhaustive, but here you can find some of the visibility that Application Insights can give you:

* Application Insights offers you a default dashboard with an educated guess of the most important metrics you will be interested in. You can then modify it and customize it to your own needs.
* By instrumenting your application correctly, Application Insights will give you performance statistics both from a client and a server perspective
* The Application Map will show you application dependencies in other services such as backend APIs or databases, allowing to determine visually where performance problems lie
* Smart Detection will warn you when anomalies in performance or utilization patterns happen
* Usage Analysis can give you telemetry on which features of your application are most frequently used, or whether all your application functionality is being used. This is especially useful after changes to the application functionality, to verify whether those changes were successful
* Release annotations are visual indicators in your Application Insights charts of new builds and other events, so that you can visually correlate changes in application performance to code releases, being able to quickly pinpoint performance problems.
* Cross-component transaction diagnostics allow you to follow failed transactions to find the point in the architecture where the fault was originated.
* Snapshot Debugger, to automatically collect a snapshot of a live application in case of an exception, to analyze it at a later stage.

In order to use Application Insights you have two options: you can use **codeless monitoring**, where onboarding your app to Application Insights does not require any code change, or **code-based monitoring**, where you instrument your code to send telemetry to Application Insights using the Software Development Kit for your programming language of choice.

You can certainly use other Application Performance Management tools to monitor your application on Azure, such as NewRelic or AppDynamics, but Application Insights will give you the most seamless and integrated experience.

## Platform Monitoring

Application Insights is actually one of the components of Azure Monitor, which gives you rich metrics and logs to verify the state of your complete Azure landscape. No matter whether your application is running on Virtual Machines, App Services or Kubernetes, Azure Monitor will help you to follow the state of your infrastructure, and to react promptly if there are any issues.

Make sure not only to monitor your compute elements supporting your application code, but your data platform as well: databases, storage accounts or data lakes should be closely monitored, since a low performance of the data tier of an application could have serious consequences.

### Container Insights

Should your application run on Azure Kubernetes Service, Azure Monitor allows you to easily monitor the state of your cluster, nodes, and pods. Easy to configure for AKS clusters, Container Insights delivers quick, visual, and actionable information: from the CPU and memory pressure of your nodes to the logs of individual Kubernetes pods.

Additionally, for operators that prefer using the open source Kubernetes monitoring tool Prometheus but still like the ease of use of Azure Monitor Container Insights, both solutions can integrate with each other.

### Network monitoring

No matter which form factor or programming language your application is based on, the network connecting your code to your users can make or break the experience that your application provides. As a consequence monitoring and troubleshooting the network can be decisive for an operations team. The component of Azure Monitor that manages the network components is called Network Watcher, a collection of network monitoring and troubleshooting tools. Some of these tools are the following:

* Traffic Analytics will give you an overview of the traffic in your Virtual Networks, as well as the percentage coming from malicious IP addresses, leveraging Microsoft Threat Intelligence databases. This tool will show you as well the systems in your virtual networks that generate most traffic, so that you can visually identify bottlenecks before they degenerate into problems.
* Network Performance Manager can generate synthetic traffic to measure the performance of network connections over multiple links, giving you a perspective on the evolution of WAN and Internet connections over time, as well as offering valuable monitoring information about Microsoft ExpressRoute circuits.
* VPN diagnostics can help troubleshooting site-to-site VPN connections connecting your applications to users on-premises.
* Connection Monitor allows to measure the network availability between sets of endpoints.

### Other information sources

Not only your application components are producing data, but there are many other signals that you need to track to effectively operate a cloud environment:

* **Activity Log**: this is a trail audit that lets you see every change that has gone through Azure APIs. It can be critical to understand sudden performance changes or problems, that might have been due to a misconfiguration of the Azure platform.
* **Azure Service Health**: sometimes outages are provoked not by configuration changes, but by glitches in the Azure platform itself. You can find information about any Azure-related problem impacting your application in the Azure Service Health logs.
* **Azure Advisor**: find here recommendations about how to optimize your Azure platform to reduce costs, improve your security posture, or increase the availability of your environment.
* **Azure Security Center**: not a focus of this pillar, but to be included for completeness: Azure Security Center can help you to understand whether your Azure resources are configured according to security best practices

## Monitoring best practices

### Event correlation

One critical advantage of Azure Monitor is that it is the monitoring tool for the whole Azure platform. As the previous sections have shown, Azure Monitor holds metrics and logs relevant to your application code, the platform where it is running, the data components, as well as the network connecting the application to its users. This enables operators to compare metrics of different application components to each other, and find out dependencies that might have been hidden otherwise.

Dashboards in Azure offer a great way of exposing the rich information contained in Azure Monitor to other users. Make sure to create shared dashboards in order to expose relevant information to the different groups involved in operating your application, including Developers and Operators. If more complex visualizations are required, Azure Monitor data can be exported to Power BI for advanced data analysis.

### Notifications

Whether it is for application, network or platform monitoring, you should not expect operators to constantly look at dashboards. Instead, alerts should be used to send proactive notifications to the relevant individuals that will react on them. Action groups in Azure Monitor can be used to notify multiple recipients, to trigger automated actions, or even to automatically open tickets in IT Service Management Tools such as ServiceNow.

Automation around alerts is critical due to the highly collaborative nature of DevOps and the inherent speed needed for effective incident management. Earlier this year, a report from DevOps.com came out stating that 80% of IT teams are alerted to critical incidents via email. Email is an effective form of communication, but it shouldn’t be the most common notification method for a critical issue. Instead, if you can define actions to be executed upon receiving certain alerts (such as scaling up or down) your system will be self-healing.

### Other monitoring tasks

Beyond Azure Monitor, you will want to keep an eye on certain events to make sure that your application is running smoothly:

* Review Azure subscription limits for your resources, and make sure you are not coming too close.
* Understand Azure support plans. Refer to Azure support FAQs. Familiarize your team with Azure support.
* Make sure that you monitor expiration dates of digital certificates, or even better, configure automatic digital certificate renewal with Azure Key Vault.

## Summary

You can use any monitoring platform to manage your Azure resources. Microsoft's first party offering is Azure Monitor, a comprehensive solution for metrics and logs from the infrastructure to the application code, including the ability to trigger alerts and automated actions as well as data visualization.