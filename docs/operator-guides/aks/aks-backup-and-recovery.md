---
title: AKS Backup and Recovery
titleSuffix: Azure Architecture Center
description: Learn to how to backup and recovery your AKS clusters and their workloads.
author: AdamSharif-MSFT
ms.author: jotavar
ms.date: 11/03/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: compute
categories: compute
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Backup and Recovery for AKS

## Why backing up your AKS cluster is important

Backup and Recovery is an essential part of any organization's operational and disaster recovery strategy. A Backup and Recovery plan usually relies on a diverse set of technologies and practices that are based on taking periodic copies of data and applications to a separate, secondary device or service, and then using those copies to recover the data and applications, and the business operations on which they depend, in the event of system failure, data loss or disaster.

As cloud-native deployments and Kubernetes continue to grow in adoption, it becomes increasingly essential for organizations to include Kubernetes clusters and workloads in a comprehensive Backup and Recovery strategy.

Implementing Backup and Recovery in AKS allows you to:

- Create a secondary copy of the configuration and data from your AKS cluster, to use if irreversible system failure, data loss or disaster occurs.
- Copy Kubernetes resources and application data from one AKS cluster to another.
- Replicate your AKS cluster to create other environments.
- Take workload snapshots before maintenance operations such as AKS version upgrades.
- Adhere to data protection requirements to maintain regulatory or organizational compliance.
- Quickly rollback to a previous deployment if an issue with a recent deployment or change is detected.

It's worth noting that while backups help you to restore your workload if an issue occurs, they don't provide [high availability (HA)](/azure/well-architected/resiliency/reliability-patterns#high-availability).

When it comes to intra-region high availability and cross-region disaster recovery in AKS, there are several other options to consider, including the following:

- [Availability Zones](/azure/aks/availability-zones): AKS supports the use of Availability Zones, which are physically separate datacenters within an Azure region. By deploying AKS clusters across multiple Availability Zones, you can ensure higher resiliency and fault tolerance within a region. This allows your applications to remain operational even if one zone experiences an outage.
- [Redundancy options for Persistent Volumes](/azure/aks/concepts-storage#storage-classes): AKS provides various redundancy options for Persistent Volumes. The [Azure Disk CSI driver for Kubernetes](https://github.com/kubernetes-sigs/azuredisk-csi-driver) supports [built-in storage classes](/azure/aks/concepts-storage#storage-classes) and custom storage classes that use the locally redundant storage (LRS) or zone redundant storage (ZRS) for better intra-region resiliency. For more information, see [Driver Parameters](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/driver-parameters.md).
- [Fleet Manager](https://azure.microsoft.com/products/kubernetes-fleet-manager): Azure Kubernetes Fleet Manager enables multi-cluster and at-scale intra-region and cross-region scenarios for AKS clusters.
- [Geo-redundancy options for Azure Container Registry (ACR)](/azure/container-registry/container-registry-geo-replication): Azure Container Registry (ACR) offers geo-replication capabilities. With geo-redundancy, your container images are replicated across different Azure regions. This ensures that your images are available even if a particular region experiences an outage, providing higher availability for your container registry.

You can also use methodologies such as Infrastructure as Code (IaC), DevOps pipelines, GitOps and Flux to allow you to quickly redeploy your workloads if disaster occurs.  
To find out more about these methodologies, please review the links below:

- [Build and deploy to Azure Kubernetes Service with Azure Pipelines](/azure/aks/devops-pipeline)
- [Tutorial: Deploy applications using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Understand the structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax)
- [What is Bicep?](/azure/azure-resource-manager/bicep/overview)
- [Overview of Terraform on Azure - What is Terraform?](/azure/developer/terraform/overview)

## What to Backup

When considering Backup and Recovery for AKS and Kubernetes clusters in general, it's crucial to identify exactly which components should be included in a backup to ensure a successful restore. Primarily, these critical components consist of:

- **Cluster State:** This refers to the current and desired configuration or state of all Kubernetes objects within the cluster. It encompasses various objects such as deployments, pods, services, and more.
 The cluster state is stored in a highly available etcd key-value pair database, which is often only accessible from the API Server as is the case of managed clusters like AKS. The cluster state is defined in a declarative manner and is the result of all Kubernetes configuration files (for example, YAML manifests) applied to the cluster.

- **Application Data:** This refers to the data created, managed, or accessed by the containerized workloads running within the cluster. To ensure data persistence across pod or container restarts, Kubernetes recommends storing application data in Persistent Volumes. These volumes can be created statically or dynamically and can be backed by various types of persistent storage, offering flexibility and scalability for data storage and management requirements.

While a complete backup of the cluster would require both the Cluster State and Application Data to be included as a single unit, determining the optimal scope of each backup depends on various factors. For example, the presence of alternative sources, like Continuous Integration and Continuous Delivery (CI/CD) pipelines, may allow for easier recovery of the cluster state. Additionally, the size of the application data plays a role in storage costs and the time required for Backup and Recovery operations.

The ideal Backup and Recovery strategy highly depends on the specific application and environment. Therefore, the scope of the backup should be assessed on a case-by-case basis, considering factors such as the importance of the cluster state and the volume of application data.

It's worth noting that targeting other components such as individual cluster nodes (VMs) or local filesystems and volumes, which are typically included in traditional Backup and Recovery plans for server-based systems, isn't relevant in Kubernetes. This is because relevant state and data aren't persisted on individual nodes or local filesystems in the same manner as traditional systems.

## Introduction to Backup and Recovery options for AKS

There are notable differences between traditional monolithic applications and workloads running in a Kubernetes cluster, which present several challenges with regards to Backup and Recovery. Kubernetes workloads are intentionally designed to be highly dynamic and distributed, with data persisted across external persistent volumes supported by multiple underlying resources and services.

To effectively support Kubernetes environments, Backup and Recovery solutions must possess Kubernetes and application awareness. They should offer a degree of automation, reliability and integration, which is often not found in legacy or more conventional Backup and Recovery tools.

Various Kubernetes-native Backup and Recovery solutions are available, with options ranging from open to closed source and offering different licensing models.

Following are some examples of Backup and Recovery solutions that may be used with AKS. One notable example is Microsoft's fully managed first-party solution called [Azure Kubernetes Service (AKS) Backup](/azure/backup/azure-kubernetes-service-backup-overview), which provides an Azure-integrated service designed for Backup & Recovery of AKS clusters and their workloads. This list is by no means exhaustive and aims only to showcase a few available options.

### AKS Backup

[AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview) is Azure's offering for backing up and restoring your AKS clusters. It's a simple, Azure-native process, which allows you to back up and restore the containerized applications and data running in your AKS clusters.

AKS Backup allows for on-demand or scheduled backups of full or fine-grained cluster state and application data stored in Azure Disk based Persistent Volumes. It integrates with the [Azure Backup Center](/azure/backup/backup-center-overview) to provide a single pane of glass in the Azure Portal that can help you govern, monitor, operate, and analyze backups at scale.

NOTE - AKS Backup is currently in public preview. Preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. AKS previews are partially covered by customer support on a best-effort basis. As such, these features aren't meant for production use. For more information, see the following support articles:

- [AKS support policies](/azure/aks/support-policies)
- [Azure support FAQ](/azure/aks/faq)

Check [About AKS Backup using Azure Backup](/azure/backup/azure-kubernetes-service-backup-overview) for a detailed description of how AKS Backup works and its capabilities.

### Kasten

[Kasten](https://www.kasten.io/) is a commercial product, which provides operations teams with an easy-to-use and secure system for Backup and Recovery of Kubernetes applications. It's available in both a free version, with limited functionality and no support, and a paid version that includes more features and customer support.

Deployed as a Kubernetes operator within the cluster, Kasten provides a comprehensive backup solution. It offers a management dashboard for centralized control and visibility. With Kasten, users can benefit from incremental and application-aware backups, enabling efficient data protection. Additionally, Kasten offers disaster recovery capabilities, including automated failover and failback, as well as features for data migration and ensuring security.

For further details on Kasten's feature set, you can refer to their [documentation](https://docs.kasten.io/latest/index.html). To learn how to effectively use Kasten with AKS clusters, see [Installing K10 on Azure](https://docs.kasten.io/latest/install/azure/azure.html).

### Velero

Velero is a widely used open-source Backup and Recovery tool for Kubernetes. It offers a free and unrestricted version available to all users, with support and maintenance provided by a community of project contributors.

Velero runs as a deployment in the cluster and provides a comprehensive set of features for application backup, recovery, and data migration. While dashboards aren't available out-of-the-box, they can be added through external integrations.

 For more information on its feature set and to learn how to integrate it with AKS clusters, you can refer to Velero [documentation](https://velero.io/docs).

## Installing and Configuring AKS Backup

To install and configure [AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview), follow these steps:

1. Check [Prerequisites for AKS Backup using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup-concept) for a detailed description of the prerequisites for using AKS Backup with your AKS cluster.
2. Review [AKS Backup Support Matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for a detailed description of AKS Backup's region availability, supported scenarios and limitations.
3. Refer to [Manage AKS backups using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-manage-backups) for guidance on how to register the required resource providers on your subscriptions and manage these registrations.
4. Review [Back up AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup) for detailed instructions on how to setup Backup and Recovery for your AKS cluster using AKS Backup, including creation and configuration of all the necessary Azure resources such as Backup Vault, Backup Policies, and Backup Instances.
5. Check [Restore AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-restore) for detailed instructions on how to perform full or item-level restores of your AKS cluster from an existing Backup Instance.

## Backup Frequency and Retention in AKS – Defining a Backup Policy

Determining the backup frequency and retention period is a fundamental aspect of Backup and Recovery solutions. These parameters define how often backups are performed and how long they're retained before deletion. The selection of backup frequency and retention period for an AKS cluster and its workloads should align with the predefined goals of Recovery Point Objective (RPO) and Recovery Time Objective (RTO).

In a Kubernetes scenario, the RPO represents the maximum acceptable amount of cluster state or data loss that can be tolerated, while the RTO specifies the maximum allowable time between cluster state or data loss and the resumption of cluster operations.

The chosen backup frequency and retention period are a trade-off between desirable RPO/RTO targets, storage costs, and backup management overhead. This means there's no one-size-fits-all configuration for all AKS clusters and workloads, and the optimum configuration for each cluster/workload should instead be defined on a case-by-case basis to meet the requirements of the business, following careful planning and consideration. Relevant factors to consider when defining an AKS cluster's backup frequency and retention period include:

- **Criticality**: The level of criticality associated with the cluster and its workload application data in terms of business continuity.
- **Access patterns and change rate**: The amount of cluster state and data that is added, modified, deleted in a given period of time.
- **Data Volume**: The volume of data affecting storage costs and the time required to complete Backup and Recovery operations.
- **Compliance**: The requirements for data retention and data sovereignty based on internal compliance rules and industry regulations.

In the AKS Backup service, backup frequency and retention period are stored as a Backup Policy resource, which applies to both the cluster state and the application data from Persistent Volumes.

Backup Policies in AKS Backup support daily and hourly backups, with retention periods of up to 360 days, while multiple policies can be defined and applied to the same cluster.

Check [Create a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy) for more information on how to configure Backup Policies in AKS Backup.

## Other backup considerations

To ensure that your Backup and Recovery solution meets your organization's requirements and policies, you'll also need to consider the following:

- **Recovery Point Objective (RPO) and Recovery Time Objective (RTO)**: Determine if you have specific RPO and RTO targets that need to be met for your backups and recovery operations.
- **Persistent Volumes (PVs)**: Verify if you're using Persistent Volumes and ensure that your PV types are supported by the AKS Backup solution. Refer to the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for compatibility details.
- **Backup Scope**: Define what needs to be backed up, such as specific namespaces, types of resources, or specific data within the cluster. For more information, see [Configure a backup job](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups).
- **Backup Frequency and Retention**: Determine the frequency at which you need to perform backups and the duration for which you need to retain them. This can be configured using backup policies. For more information, see [Defining a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy).
- **Cluster Selection**: Decide if you need to backup all clusters or only specific production clusters based on your requirements.
- **Test Restore Procedure**: Perform periodic test restores to validate the reliability and usability of your backup strategy. This step is crucial for ensuring the effectiveness of the Backup and Recovery solution. For more information, see [Restoring an AKS cluster](/azure/backup/azure-kubernetes-service-cluster-restore).
- **Supported Scenarios**: Verify if your specific scenario is supported by the AKS Backup solution. Refer to the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for compatibility information.
- **Budget Allocations**: Consider if you have specific budget allocations for backup and restore operations. Review the [pricing](/azure/backup/azure-kubernetes-service-backup-overview#pricing) information provided by the AKS Backup solution to align with your budgetary requirements.

By taking these other considerations into account, you can ensure that your Backup and Recovery solution for AKS meets your organization's needs and preferences efficiently and effectively.

## AKS Backup Location and Storage

AKS Backup uses a Backup Vault and a Storage Account to store the different types of data captured from a cluster during a backup.

For disk-based Persistent Volumes, AKS Backup uses incremental snapshots of the underlying Azure Disk, which are stored within your Azure subscription.

A [Backup Vault](/azure/backup/backup-vault-overview) is a secure storage entity within Azure, which is used to store backup data for workloads supported by Azure Backup, such as AKS clusters. The Backup Vault itself contains both the backup policies, and the backups and recovery points created by backup jobs.

The storage for a Backup Vault is managed automatically by Azure, and there are several redundancy options to choose from for the data stored within it, which can be configured at the point of Backup Vault creation.

A [Storage Account](/azure/storage/common/storage-account-overview) is a storage area for your data objects within Azure, which is highly configurable. It provides multiple intra-region and cross-region redundancy options to ensure data durability.
 AKS Backup uses a Blob container within a designated Storage Account to take backups of some components of the AKS cluster.

[Incremental snapshots](/azure/virtual-machines/disks-incremental-snapshots?tabs=azure-cli) are point-in-time backups for managed disks that, when taken, consist only of the changes since the last snapshot. The first incremental snapshot is a full copy of the disk. The subsequent incremental snapshots occupy only delta changes to disks since the last snapshot.

## Using AKS Backup to migrate workloads between AKS clusters

Aside from using AKS Backup as a mechanism for Backup and Restore for specific clusters, AKS Backup also supports migration scenarios by allowing you to take a backup from one cluster and restore it to another, such as from a development to a staging cluster or replicating contents across multiple clusters.

To ensure that your scenario is supported, consult the following documentation:

- [AKS Backup overview](/azure/backup/azure-kubernetes-service-backup-overview)
- [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix)

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Adam Sharif](https://www.linkedin.com/in/adamsharif) | Technical Advisor
- [Joao Tavares](https://www.linkedin.com/in/joao-tavares-3976a63) | Senior Escalation Engineer

Other contributors:

- [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Sonia Cuff](https://www.linkedin.com/in/soniacuff) | Principal Cloud Advocate Lead

## Next steps

### Learn more about AKS Backup

- [AKS Backup overview](/azure/backup/azure-kubernetes-service-backup-overview)
- [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix)
- [AKS Backup prerequisites](/azure/backup/azure-kubernetes-service-cluster-backup-concept)
- [Configuring AKS Backup](/azure/backup/azure-kubernetes-service-cluster-backup)
- [Creating a Backup vault](/azure/backup/create-manage-backup-vault#create-a-backup-vault)
- [Creating a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy)
- [Configuring backups](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups)
- [Restoring an AKS cluster](/azure/backup/azure-kubernetes-service-cluster-restore)
- [Business continuity and disaster recovery best practices for AKS](/azure/aks/operator-best-practices-multi-region)
- [Reliability patterns - Cloud Design Patterns](/azure/well-architected/resiliency/reliability-patterns#high-availability)

### Third-party AKS backup and recovery options

- [Kasten](https://docs.kasten.io/latest/index.html)
- [Velero](https://velero.io/docs)

## Related resources

- [Azure Kubernetes Services (AKS) day-2 operations guide - Introduction](/azure/architecture/operator-guides/aks/day-2-operations-guide)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [AKS baseline for multiregion clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster)
