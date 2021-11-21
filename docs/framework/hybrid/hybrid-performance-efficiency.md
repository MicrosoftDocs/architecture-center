---
title: Performance efficiency in a hybrid workload
description: Includes guidance and recommendations that apply to the Performance Efficiency pillar in a hybrid and multi-cloud workload.
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Performance efficiency in a hybrid workload

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. In a hybrid environment, it is important to consider how you manage your on-premises or multicloud workloads to ensure they can meet the demands for scale. You have options to scale up into the cloud when your on-premises resources reach capacity. Scale up, down, and scale out your databases without application downtime.

Using a tool like Azure Arc, you can build cloud native apps anywhere, at scale. Architect and design hybrid applications where components are distributed across public cloud services, private clouds, data centers and edge locations without sacrificing central visibility and control. Deploy and configure applications and Kubernetes clusters consistently and at scale from source control and templates. You can also bring PaaS services on premises. This allows you to use cloud innovation flexibly, where you need it by deploying Azure services anywhere. Implement cloud practices and automation to deploy faster, consistently, and at scale with always up-to-date Azure Arc enabled services. You can scale elastically based on capacity, with the ability to deploy in seconds.

## Azure Arc design

The first steps with Azure Arc are to connect the machines to Azure. To use Azure Arc to connect the machine to Azure, you need to install the Azure Connected Machine agent on each machine that you plan to connect using Azure Arc. You can connect any other physical or virtual machine running Windows or Linux to Azure Arc.

There are four ways to connect machines:

1. Manual installation
1. Script-based installation
1. Connect machines at scale using service principal
1. Installation using Windows PowerShell DSC

After connecting the machines, you can then manage the VM extensions all from Azure, which provides consistent extension management between Azure and non-Azure VMs. In Azure you can use Azure Automation State Configuration to centrally store configurations and maintain the desired state of Arc enabled servers through the DSC VM extension. You can also collect log data for analysis with Azure Monitor Logs enabled through the Log Analytics agent VM extension. With Azure Monitor, you can analyze the performance of your Windows and Linux VMs and monitor their processes and dependencies on other resources and external processes.

## Azure Arc enabled Kubernetes

With Azure Arc enabled Kubernetes, you need to register the cluster first. You can register any CNCF Kubernetes cluster that is running. You'll need a kubeconfig file to access the cluster and cluster-admin role on the cluster for deploying Arc-enabled Kubernetes agents. You'll use Azure Command-Line Interface (Azure CLI) to perform cluster registration tasks.

## Azure Arc enabled SQL Managed Instance

When planning for deployment of Azure Arc enabled SQL Managed Instance, you should identify the correct amount of compute, memory, and storage that will be required to run the Azure Arc data controller and the intended SQL managed instance server groups.

You have the flexibility to extend the capacity of the underlying Kubernetes or AKS cluster over time by adding additional compute nodes or storage. Kubernetes or AKS offers an abstraction layer over the underlying virtualization stack and hardware. Storage classes implement such abstraction for storage.

> [!NOTE]
> When provisioning a pod, you need to decide which storage class to use for its volumes. Your decision is important from a performance standpoint because an incorrect choice could result in suboptimal performance.

When planning for deployment of Azure Arc enabled SQL Managed Instance, you should consider a range of factors affecting storage configuration [kubernetes-storage-class-factors](/azure/azure-arc/data/storage-configuration#factors-to-consider-when-choosing-your-storage-configuration) for both [data controller](/azure/azure-arc/data/storage-configuration#data-controller-storage-configuration) and [database instances](/azure/azure-arc/data/storage-configuration#database-instance-storage-configuration).

## Azure Stack HCI

With the scope of Azure Arc extended to Azure Stack HCI VMs, you'll be able to [automate their configuration by using Azure VM extensions](/azure/azure-arc/servers/manage-vm-extensions) and evaluate their [compliance with industry regulations and corporate standards by using Azure Policy](/azure/azure-arc/servers/security-controls-policy).

In remote office/branch office scenarios, you must consider storage resiliency versus usage efficiency, versus performance. Planning for Azure Stack HCI volumes involves identifying the optimal balance between resiliency, usage efficiency, and performance. The challenge results from the fact that maximizing one of these characteristics typically has a negative impact on at least one of the other two.

To learn more, see [Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office](../../hybrid/azure-stack-robo.yml#performance-efficiency).

## Monitoring in a hybrid environment

Monitoring in a hybrid environment can be a challenge. However, with tools like Azure Arc as you bring Azure services on-premises, you can easily enroll in additional Azure services such as monitoring, security, and update by simply turning them on.

- Across products: Integrate with Microsoft Sentinel, Microsoft Defender for Cloud
- Bring Microsoft Defender for Cloud to your on-prem data and servers with Arc
- Set security policies, resource boundaries, and RBAC for workloads across the hybrid infra
- Proper admin roles for read, modify, re-onboard, and delete a machine

## Monitoring containers

[Monitoring your containers is critical](../../hybrid/arc-hybrid-kubernetes.yml). Azure Monitor for containers provides a rich monitoring experience for the AKS and AKS engine clusters.

Configure Azure Monitor for containers to monitor Azure Arc enabled Kubernetes clusters hosted outside of Azure. This helps achieve comprehensive monitoring of your Kubernetes clusters across Azure, on-premises, and third-party cloud environments.

Azure Monitor for containers can provide you with performance visibility by collecting memory and processor metrics from controllers, nodes, and containers available in Kubernetes through the Metrics application programming interface (API). Container logs are also collected. After you enable monitoring from Kubernetes clusters, metrics and logs are automatically collected for you through a containerized version of the Log Analytics agent. Metrics are written to the metrics store and log data is written to the logs store associated with your Log Analytics workspace. For more information about Azure Monitor for containers, refer to Azure Monitor for containers overview.

Enable Azure Monitor for containers for one or more existing deployments of Kubernetes by using either a PowerShell or a Bash script. To enable monitoring for Arc enabled Kubernetes clusters, refer to [Enable monitoring of Azure Arc enabled Kubernetes cluster](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters).

Automatically enroll in additional Azure Arc enabled resources and services. Simply turn them on when needed:

- Strengthen your security posture and protect against threats by turning on Microsoft Defender for Cloud.
- Get actionable alerts from Azure Monitor.
- Detect, investigate, and mitigate security incidents with the power of a cloud-native SIEM, by turning on Microsoft Sentinel.

## Deploy and manage containerized applications

Deploy and manage containerized applications with GitHub and Azure Policy. Ensure that applications and clusters are consistently deployed and configured at scale from source control.  Write with your familiar tool set to the same application service APIs that can run consistently on-premises, across multicloud, and in edge environments. Easily instrument Azure monitoring, telemetry, and security services into your hybrid apps wherever they run.

## Next steps

> [!div class="nextstepaction"]
> [Reliability](./hybrid-reliability.md)
