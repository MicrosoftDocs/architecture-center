---
title: AKS Backup and Recovery
description: Learn how to back up and recover your AKS clusters and their workloads.
author: AdamSharif-MSFT
ms.author: jotavar
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Backup and recovery for AKS

Backup and recovery are an essential part of any organization's operational and disaster recovery strategy. A backup and recovery plan usually relies on a diverse set of technologies and practices that are based on taking periodic copies of data and applications to a separate, secondary device or service. If a system failure, data loss, or disaster occurs, these copies are used to recover the data and applications, and the business operations on which they depend.

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes backup and recovery practices for AKS.

## Why backing up your AKS cluster is important

As cloud-native deployments and Kubernetes continue to grow in adoption, it becomes increasingly essential for organizations to include Kubernetes clusters and workloads in a comprehensive backup and recovery strategy.

Implementing backup and recovery in AKS lets you:

- Create a secondary copy of the configuration and data from your AKS cluster, to use if irreversible system failure, data loss or disaster occurs.
- Copy Kubernetes resources and application data from one AKS cluster to another.
- Replicate your AKS cluster to create other environments.
- Take workload snapshots before maintenance operations such as AKS version upgrades.
- Adhere to data protection requirements to maintain regulatory or organizational compliance.
- Quickly roll back to a previous deployment if an issue with a recent deployment or change is detected.

While backups help you restore your workload if an issue occurs, they don't provide [high availability (HA)](/azure/well-architected/reliability/highly-available-multi-region-design).

When it comes to intra-region high availability and cross-region disaster recovery in AKS, you can consider several other options, such as:

- [Availability zones](/azure/aks/availability-zones): AKS supports the use of availability zones, which are physically separate datacenters within an Azure region. By deploying AKS clusters across multiple availability zones, you can ensure higher resiliency and fault tolerance within a region. Doing so allows your applications to remain operational even if one zone experiences an outage.
- [Redundancy options for persistent volumes](/azure/aks/concepts-storage#storage-classes): AKS provides various redundancy options for persistent volumes. The [Azure Disk CSI driver for Kubernetes](https://github.com/kubernetes-sigs/azuredisk-csi-driver) supports [built-in storage classes](/azure/aks/concepts-storage#storage-classes) and custom storage classes that use the locally redundant storage (LRS) or zone redundant storage (ZRS) for better intra-region resiliency. For more information, see [Driver Parameters](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/driver-parameters.md).
- [Azure Kubernetes Fleet Manager](https://azure.microsoft.com/products/kubernetes-fleet-manager): Azure Kubernetes Fleet Manager enables multi-cluster and at-scale intra-region and cross-region scenarios for AKS clusters.
- [Geo-redundancy options for Azure Container Registry (ACR)](/azure/container-registry/container-registry-geo-replication): Azure Container Registry (ACR) offers geo-replication capabilities. With geo-redundancy, your container images are replicated across different Azure regions. So even if a particular region experiences an outage, your images are available, which provides higher availability for your container registry.

You can also use methodologies such as Infrastructure as Code (IaC), Azure Pipelines, GitOps and Flux to quickly redeploy your workloads if disaster occurs.

To find out more about these methodologies, you can review these articles:

- [Build and deploy to Azure Kubernetes Service with Azure Pipelines](/azure/aks/devops-pipeline)
- [Tutorial: Deploy applications using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Understand the structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax)
- [What is Bicep?](/azure/azure-resource-manager/bicep/overview)
- [Overview of Terraform on Azure - What is Terraform?](/azure/developer/terraform/overview)

## What to back up

When considering backup and recovery for AKS and Kubernetes clusters in general, it's crucial to identify exactly which components should be included in a backup to ensure a successful restore. Primarily, these critical components consist of:

- **Cluster state:** Refers to the current and desired configuration or state of all Kubernetes objects within the cluster. It encompasses various objects such as deployments, pods, services, and more.
 The cluster state is stored in a highly available etcd key-value pair database, which is often only accessible from the API server, as is the case of managed clusters like AKS. The cluster state is defined in a declarative manner and is the result of all Kubernetes configuration files applied to the cluster, such as YAML manifests.

- **Application data:** Refers to the data created, managed, or accessed by the containerized workloads running within the cluster. To ensure data persistence across pod or container restarts, Kubernetes recommends storing application data in persistent volumes. These volumes can be created statically or dynamically and can be backed by various types of persistent storage, offering flexibility and scalability for data storage and management requirements.

While a complete backup of the cluster would require both the cluster state and application data to be included as a single unit, determining the optimal scope of each backup depends on various factors. For example, the presence of alternative sources, like Continuous Integration and Continuous Delivery (CI/CD) pipelines, might allow for easier recovery of the cluster state. Additionally, the size of the application data plays a role in storage costs and the time required for backup and recovery operations.

The ideal backup and recovery strategy highly depends on the specific application and environment. Therefore, the scope of the backup should be assessed on a case-by-case basis. It should also consider factors such as the importance of the cluster state and the volume of application data.

Targeting other components such as individual cluster nodes (VMs) or local filesystems and volumes, which are typically included in traditional backup and recovery plans for server-based systems, isn't relevant in Kubernetes. Relevant state and data aren't persisted on individual nodes or local filesystems in the same way as traditional systems.

## Introduction to backup and recovery options for AKS

There are notable differences between traditional monolithic applications and workloads running in a Kubernetes cluster, which present several challenges to backup and recovery. Kubernetes workloads are intentionally designed to be highly dynamic and distributed, with data persisted across external persistent volumes supported by multiple underlying resources and services.

To effectively support Kubernetes environments, backup and recovery solutions must possess Kubernetes and application awareness. They should offer a degree of automation, reliability and integration, which is often not found in legacy or more conventional backup and recovery tools.

Various Kubernetes-native backup and recovery solutions are available, with options ranging from open to closed source and offering different licensing models.

Following are some examples of backup and recovery solutions that you can use with AKS. One notable example is Microsoft's fully managed first-party solution called [Azure Kubernetes Service (AKS) Backup](/azure/backup/azure-kubernetes-service-backup-overview), which provides an Azure-integrated service designed for backup and recovery of AKS clusters and their workloads. This list isn't exhaustive and only provides a few available options.

### AKS Backup

[AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview) is Azure's offering for backing up and restoring your AKS clusters. It's an Azure-native process that lets you back up and restore the containerized applications and data running in your AKS clusters.

AKS Backup allows for on-demand or scheduled backups of full or fine-grained cluster state and application data stored in Azure disk-based persistent volumes. It integrates with the [Azure Backup Center](/azure/backup/backup-center-overview) to provide a single area in the Azure portal that can help you govern, monitor, operate, and analyze backups at scale.

See [About AKS Backup using Azure Backup](/azure/backup/azure-kubernetes-service-backup-overview) for a detailed description of how AKS Backup works and its capabilities.

### Kasten

[Kasten](https://www.kasten.io/) is a commercial product that provides operations teams with a secure system for backup and recovery of Kubernetes applications. It's available in both a free version with limited functionality and no support, and a paid version that includes more features and customer support.

When Kasten is deployed as a Kubernetes operator within the cluster, it provides a comprehensive backup solution. It offers a management dashboard for centralized control and visibility. With Kasten, users can benefit from incremental and application-aware backups, enabling efficient data protection. Additionally, Kasten offers disaster recovery capabilities. These capabilities include automated failover and failback, and features for data migration and ensuring security.

For more information about Kasten's feature set, see the [Kasten K10 documentation](https://docs.kasten.io/latest/index.html). For more information about how to effectively use Kasten with AKS clusters, see [Installing K10 on Azure](https://docs.kasten.io/latest/install/azure/azure.html).

### Velero

Velero is a widely used open-source backup and recovery tool for Kubernetes. It offers a free and unrestricted version available to all users, with support and maintenance provided by a community of project contributors.

Velero runs as a deployment in the cluster and provides a comprehensive set of features for application backup, recovery, and data migration. While dashboards aren't available out-of-the-box, they can be added through external integrations.

 For more information about its feature set and how to integrate it with AKS clusters, see the [Velero documentation](https://velero.io/docs).

## Installing and Configuring AKS Backup

To install and configure [AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview), follow these steps:

1. See [Prerequisites for AKS Backup using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup-concept) for a detailed description of the prerequisites for using AKS Backup with your AKS cluster.
2. Review the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for a detailed description of AKS Backup's region availability, supported scenarios, and limitations.
3. See [Manage AKS backups using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-manage-backups) for guidance on how to register the required resource providers on your subscriptions and manage these registrations.
4. Review [Back up AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup) for detailed instructions on how to set up backup and recovery for your AKS cluster using AKS Backup. Instructions include the creation and configuration of all the necessary Azure resources such as Backup vault, Backup policies, and Backup instances.
5. See [Restore AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-restore) for detailed instructions on how to perform full or item-level restores of your AKS cluster from an existing Backup instance.

## Backup frequency and retention in AKS: defining a backup policy

Determining the backup frequency and retention period is a fundamental aspect of backup and recovery solutions. These parameters define how often backups are performed and how long they're retained before deletion. The selection of backup frequency and retention period for an AKS cluster and its workloads should align with the predefined goals of Recovery Point Objective (RPO) and Recovery Time Objective (RTO).

In a Kubernetes scenario, the RPO represents the maximum acceptable amount of cluster state or data loss that can be tolerated. The RTO specifies the maximum allowable time between cluster state or data loss and the resumption of cluster operations.

The chosen backup frequency and retention period are a trade-off between desirable RPO/RTO targets, storage costs, and backup management overhead. This means there's no one-size-fits-all configuration for all AKS clusters and workloads, and the optimum configuration for each cluster or workload should instead be defined on a case-by-case basis to meet the requirements of the business, following careful planning and consideration. Relevant factors to consider when defining an AKS cluster's backup frequency and retention period include:

- **Criticality**: The level of criticality associated with the cluster and its workload application data in terms of business continuity.
- **Access patterns and change rate**: The amount of cluster state and data that is added, modified, deleted in a given period of time.
- **Data Volume**: The volume of data affecting storage costs and the time required to complete backup and recovery operations.
- **Compliance**: The requirements for data retention and data sovereignty based on internal compliance rules and industry regulations.

In the AKS Backup service, backup frequency and retention period are stored as a *backup policy* resource, which applies to both the cluster state and the application data from persistent volumes.

Backup policies in AKS Backup support daily and hourly backups, with retention periods of up to 360 days, while multiple policies can be defined and applied to the same cluster.

See [Create a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy) for more information on how to configure backup policies in AKS Backup.

## Other backup considerations

To ensure that your backup and recovery solution meets your organization's requirements and policies, consider the following points:

- **Recovery Point Objective (RPO) and Recovery Time Objective (RTO)**: Determine if you have specific RPO and RTO targets that need to be met for your backups and recovery operations.
- **Persistent volumes (PVs)**: Verify if you're using persistent volumes and ensure that the AKS Backup solution supports your PV types. Refer to the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for compatibility details.
- **Backup scope**: Define what needs to be backed up, such as specific namespaces, types of resources, or specific data within the cluster. For more information, see [Configure a backup job](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups).
- **Backup frequency and retention**: Determine the frequency at which you need to perform backups and the duration for which you need to retain them. This setting can be configured using backup policies. For more information, see [Defining a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy).
- **Cluster selection**: Decide if you need to back up all clusters or only specific production clusters based on your requirements.
- **Test restore procedure**: Perform periodic test restores to validate the reliability and usability of your backup strategy. This step is crucial for ensuring the effectiveness of the backup and recovery solution. For more information, see [Restoring an AKS cluster](/azure/backup/azure-kubernetes-service-cluster-restore).
- **Supported scenarios**: Verify that the AKS Backup solution supports your specific scenario. Refer to the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix) for compatibility information.
- **Budget allocations**: Consider if you have specific budget allocations for backup and restore operations. Review the [pricing](/azure/backup/azure-kubernetes-service-backup-overview#understand-pricing) information provided by the AKS Backup solution to align with your budgetary requirements.

By taking these other considerations into account, you can ensure that your backup and recovery solution for AKS meets your organization's needs and preferences efficiently and effectively.

## AKS Backup Location and Storage

AKS Backup uses a Backup vault and a storage account to store the different types of data captured from a cluster during a backup.

For disk-based persistent volumes, AKS Backup uses incremental snapshots of the underlying Azure Disk, which are stored within your Azure subscription.

A [Backup vault](/azure/backup/backup-vault-overview) is a secure storage entity within Azure, which is used to store backup data for workloads supported by Azure Backup, such as AKS clusters. The Backup Vault itself contains both the backup policies, and the backups and recovery points created by backup jobs.

Azure automatically manages the storage for a Backup Vault. You can choose from several redundancy options for the data stored within it, which can be configured at the point of Backup Vault creation.

A [storage account](/azure/storage/common/storage-account-overview) is a storage area for your data objects within Azure, and is highly configurable. It provides multiple intra-region and cross-region redundancy options to ensure data durability. AKS Backup uses a blob container within a designated storage account to take backups of some components of the AKS cluster.

[Incremental snapshots](/azure/virtual-machines/disks-incremental-snapshots?tabs=azure-cli) are point-in-time backups for managed disks that, when taken, consist only of the changes since the last snapshot. The first incremental snapshot is a full copy of the disk. The subsequent incremental snapshots only capture delta changes to disks since the last snapshot.

## Using AKS Backup to migrate workloads between AKS clusters

You can use AKS Backup as a mechanism for backup and recovery for specific clusters. AKS Backup also supports migration scenarios by letting you take a backup from one cluster and restore it to another, such as:

- Restoring a development cluster to a staging cluster
- Replicating contents across multiple clusters

To ensure that your scenario is supported, consult the following documentation:

- [AKS Backup overview](/azure/backup/azure-kubernetes-service-backup-overview)
- [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Adam Sharif](https://www.linkedin.com/in/adamsharif) | Technical Advisor
- [Joao Tavares](https://www.linkedin.com/in/joao-tavares-3976a63) | Senior Escalation Engineer

Other contributors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
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
- [Reliability patterns - cloud design patterns](/azure/well-architected/reliability/design-patterns)

### Third-party AKS backup and recovery options

- [Kasten](https://docs.kasten.io/latest/index.html)
- [Velero](https://velero.io/docs)

## Related resources

- [Azure Kubernetes Services (AKS) day-2 operations guide - Introduction](/azure/architecture/operator-guides/aks/day-2-operations-guide)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [AKS baseline for multiregion clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster)
