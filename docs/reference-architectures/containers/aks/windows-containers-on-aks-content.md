# Considerations for running Windows containers on AKS

This architecture builds on the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-ak), which provides a thorough review of the recommended configurations to deploy an AKS cluster into a production environment. As such, this article focuses on those configurations specific to deploying Windows on AKS and refer back to the AKS Baseline documentation for configurations already described there.

## Components

Many components and Azure services are used in the Windows Container AKS reference architecture. Only those components with uniqueness to this Windows Container architecture are listed below. For the remaining, reference the AKS Baseline architecture.

## Network topology

## IP address planning

Unlike AKS clusters with Linux nodepools, AKS clusters with Windows nodepools require Azure CNI.  Using the Azure CNI allows a pod to be assigned an IP address from an Azure Virtual Network. The pod can then communicate on the Azure Virtual Network just like any other device. It can connect to other pods, to peered networks or on-premises networks using ExpressRoute or a VPN, or to other Azure services using Private Link.

All [guidance](/azure/architecture/reference-architectures/containers/aks/baseline-aks#plan-the-ip-addresses) relative to planning the IP addresses provided in the AKS Baseline architecture article applies here, with one additional recommendation: consider provisioning a dedicated subnet for your domain controllers.

## Node pool upgrade

The process for upgrading Windows nodes is unchanged from guidance provided in the [Azure Kubernetes Service (AKS) node image upgrade](/azure/aks/node-image-upgrade) documentation but you should consider the following schedule differences to plan your upgrade cadence.

Microsoft provides new Windows Server images, including up-to-date patches, for nodes monthly and does not perform any automatic patching or updates.  As such, you will need to manually or programmatically update your nodes according to this schedule.  Using GitHub Actions to create a cron job that runs on a schedule will allow you to programmatically schedule monthly upgrades.  The guidance provided in that documentation reflects Linux node processes, but you can update the YAML file to set your cron schedule to run monthly rather than biweekly. You will also need to change the “runs-on” parameter in the YAML file to “windows-latest” to ensure that you are upgrading to the most recent Windows Server image

[!NOTE]
> Clusters must be upgraded before performing node and node pool upgrades.  Follow the [Cluster upgrades](/azure/aks/upgrade-cluster?tabs=azure-cli) guidance to perform the upgrade

## Identity management

Customers with applications that require Active Directory authentication and authorization through [Group Managed Service Accounts](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) (GMSA) must enable the GMSA profile on their AKS cluster running Windows nodes. The [GMSA PowerShell module](/virtualization/windowscontainers/manage-containers/gmsa-aks-ps-module) demonstrates how to confirm you that have enabled the GMSA profile successfully and walks through the steps to set up the integration. During the set up, it will ask you to create an Azure Key Vault for storing the user credentials required to retrieve the service account and a Managed Identity. If you already have a Key Vault or Managed Identity you’d like to use, use the names of the existing resources for the parameter values in the PowerShell module. Prior to setting up your GMSA integration, ensure you have a domain controller that is running and is accessible by the AKS cluster.

## Node and pod scaling

Cluster autoscaler guidance is unchanged for Windows containers.  Please refer to the [Cluster autoscaler]( /azure/architecture/reference-architectures/containers/aks/baseline-aks#cluster-autoscaler) documentation for guidance.

The baseline cluster documentation describes the manual and autoscaling approaches that are available for pod scaling.  Both approaches are available for clusters running Windows containers and the [guidance](/azure/architecture/reference-architectures/containers/aks/baseline-aks#node-and-pod-scalability) provided in that article generally apply here as well.

What differs between Linux and Windows containers with respect to pod scaling operations is the size of the image in most cases.  The larger image sizes of Windows containers can dramatically increase the amount of time for scaling operations to complete and therefore some considerations on scaling philosophy should be taken. This scenario is common with legacy .NET applications due to the size of the .NET runtime. In order to mitigate the delays in pulling the image down during scaling times, you can utilize a [DaemonSet](/azure/aks/hybrid/create-daemonsets) to pull down the image from ACR or a storage account to cache on every node and therefore spin up the nodes with the image pre-loaded. From that point, the pods would need to run through the app configuration processes defined for your workload before being brought online.

Benchmarking exercises should be performed to understand the time impact of performing scaling operations and this data should be weighed against business requirements.  If your workload needs to scale faster than is possible through autoscaling, it is recommended to consider the following alternative “hot spare” solution:

You will first need to conduct baseline testing to identify how many pods you will need to run at peak load times and off-peak load times.  With this baseline established, you can plan your node count to account for the total number of nodes you will need to have available at any given time. This solution involves using manual scaling for your cluster and setting the initial number of nodes to the off-peak number of nodes required. When you approach a peak time period, you will need to preemptively scale to the peak-load time number of nodes. As time goes on, you will need to re-establish your baseline regularly to account for changing app usage or other business requirements.

## Monitoring

Monitoring your Windows containers can be done in two ways: Azure Monitor and using the Microsoft tool, LogMonitor.

Containers running Windows Server 2019 are currently supported by Azure Monitor and [Container Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview). Support for containers running Windows Server 2022 is currently in public preview. Please refer to the LogMonitor allows you to grab logs from Windows services and application events and port them to STDOUT for consumption by kubectl logs.

## Cost optimizations

The licensing costs for Windows Server increase the cost of nodes for your AKS cluster. Cost optimization recommendations include reserving capacity or using existing licenses if you already have them for other business uses. The size of Windows container images may incur additional Azure Container Registry (ACR) due to the amount of storage required for multiple images, the number of concurrent nodes pulling from the ACR and geo-replication requirements
