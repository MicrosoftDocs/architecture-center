---
title: AKS Backup and Recovery
description: Learn how to back up and recover your AKS clusters and their workloads.
author: samcogan
ms.author: samcogan
ms.date: 03/24/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Backup and recovery for AKS

Backup and recovery are an essential part of any organization's operational and disaster recovery (DR) strategy. A backup and recovery plan usually relies on a diverse set of technologies and practices that are based on taking periodic copies of data and applications to a separate, secondary device or service. If a system failure, data loss, or disaster occurs, these copies can be used to recover data and applications, and to recover dependent business operations.

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes backup and recovery practices for AKS.

## Why backing up your AKS cluster is important

It's essential for organizations to include Kubernetes clusters and workloads in their backup and recovery strategies to support growing cloud-native deployments. Implement backup and recovery in AKS to:

- Create a secondary copy of the configuration and data from your AKS cluster. You can use this copy if irreversible system failure, data loss, or disaster occurs.
- Copy Kubernetes resources and application data from one AKS cluster to another.
- Replicate your AKS cluster to create other environments.
- Take workload snapshots before maintenance operations, such as AKS version upgrades.
- Adhere to data protection requirements to maintain regulatory or organizational compliance.
- Quickly roll back to a previous deployment if you detect a problem with a recent deployment or change.

Backups help you to restore your workload if a problem occurs, but they don't provide [high availability (HA)](/azure/well-architected/reliability/highly-available-multi-region-design). If you need intra-region HA and cross-region DR functionality while using AKS, consider one of the following options:

- [Availability zones](/azure/aks/availability-zones): AKS supports the use of availability zones, which are physically separate datacenters within an Azure region. You can ensure higher resiliency and fault tolerance within a region by deploying AKS clusters across multiple availability zones. This deployment keeps your applications operational even if one zone experiences an outage.

- [Redundancy options for persistent volumes (PVs)](/azure/aks/concepts-storage#storage-classes): AKS provides various redundancy options for PVs. The [Azure Disk Container Storage Interface driver for Kubernetes](https://github.com/kubernetes-sigs/azuredisk-csi-driver) supports built-in storage classes and custom storage classes that use locally redundant storage (LRS) or zone redundant storage (ZRS) for better intra-region resiliency. For more information, see [Driver Parameters](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/driver-parameters.md).

- [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/): Azure Kubernetes Fleet Manager enables multi-cluster and at-scale intra-region and cross-region scenarios for AKS clusters.

- [Geo-redundancy options for Azure Container Registry](/azure/container-registry/container-registry-geo-replication): Container Registry offers geo-replication capabilities. You can replicate your container images across different Azure regions by using geo-redundancy. Your images are available even if a particular region experiences an outage, which provides higher availability for your container registry.

For more information about multiregion DR patterns, see:

- [Active-active HA for AKS](/azure/architecture/guide/aks/aks-high-availability)
- [Blue-green deployment of AKS clusters](/azure/architecture/guide/aks/blue-green-deployment-for-aks)

You can also use methodologies such as Infrastructure as Code, Azure Pipelines, GitOps, and Flux to quickly redeploy your workloads if disaster occurs. For more information about these methodologies, see:

- [Build and deploy to AKS with Azure Pipelines](/azure/aks/devops-pipeline)
- [Tutorial: Deploy applications using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Understand the structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax)
- [What is Bicep?](/azure/azure-resource-manager/bicep/overview)
- [Overview of Terraform on Azure - What is Terraform?](/azure/developer/terraform/overview)

## What to back up

When considering backup and recovery for AKS and Kubernetes clusters, identify which components should be included in a backup to ensure a successful restore. These components include:

- **Cluster state:** The current and desired configuration or state of all Kubernetes objects within a cluster. The cluster state encompasses various objects such as deployments, pods, and services. The cluster state is stored in a highly available etcd key-value pair database that's often only accessible from the API server. The cluster state is defined in a declarative manner and is the result of all Kubernetes configuration files applied to the cluster, such as YAML manifests.

- **Application data:** The data created, managed, or accessed by the containerized workloads running within the cluster. Kubernetes recommends storing application data in PVs to ensure data persistence across pod or container restarts. These PVs can be created statically or dynamically, they can be backed up by various types of persistent storage, and they offer flexibility and scalability for data storage and management requirements.

A complete backup of the cluster requires the cluster state and the application data to be included as a single unit, but determining the optimal scope of each backup depends on various factors. For example, the presence of alternative sources, like Continuous Integration and Continuous Delivery pipelines, might make it easier to recover the cluster state. Additionally, the size of the application data plays a role in storage costs and the time required for backup and recovery operations.

The ideal backup and recovery strategy depends on the specific application and environment. Therefore, you should assess the scope of the backup on a case-by-case basis. Consider factors such as the importance of the cluster state and the volume of application data.

You don't need to target other components, such as individual cluster nodes (virtual machines) and local filesystems and volumes, in Kubernetes. These components are typically included in traditional backup and recovery plans for server-based systems, but in Kubernetes relevant state and data aren't persisted on individual nodes or local filesystems in the same way as traditional systems.

## Backup and recovery options for AKS

There are notable differences between traditional monolithic applications and workloads running in a Kubernetes cluster, which present several challenges to backup and recovery. Kubernetes workloads are designed to be highly dynamic and distributed, with data persisted across external PVs supported by multiple underlying resources and services.

To effectively support Kubernetes environments, backup and recovery solutions must possess Kubernetes and application awareness. Backup and recovery solutions should offer a degree of automation, reliability, and integration, which is often not found in legacy or in more conventional backup and recovery tools.

Various Kubernetes-native backup and recovery solutions are available, with options ranging from open to closed source and offering different licensing models.

The following section provides some examples of backup and recovery solutions that you can use with AKS.

### AKS Backup

Microsoft's fully managed, first-party solution, [AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview), provides an Azure-integrated service designed for backup and recovery of AKS clusters and their workloads.

AKS Backup integrates with the [Backup center in the Azure portal](/azure/backup/backup-center-overview) area in the Azure portal to help you govern, monitor, operate, and analyze backups at scale. Back up and restore the containerized applications and data running in your AKS clusters by using the Azure-native process in AKS Backup.

AKS Backup supports on-demand or scheduled backups of full or fine-grained cluster state data and application data stored in Azure disk-based PVs. AKS Backup supports two storage tiers:

- **Operational Tier:** Stores backups as local snapshots and Kubernetes resource backups in a storage account in your subscription.

- **Vault Tier:** Copies backup data to an Azure Backup-managed storage vault for long-term retention and geo-redundant protection. Vault Tier supports PVs backed by Azure Disks up to 1 TB in size and offers **Cross Region Restore (CRR)**, which can recover AKS workloads in an Azure-paired secondary region.

For stateful workloads such as databases, use [Custom Hooks](/azure/backup/azure-kubernetes-service-backup-overview#backup-hooks) in AKS Backup. Ensure application-consistent backups by using Backup hooks. You can use Backup hooks to run custom scripts in containers before and after a snapshot, using pre- and post-hooks). For example, you can freeze a database write operation before a snapshot and unfreeze it afterward.

### Veeam Kasten

[Veeam Kasten](https://www.veeam.com/products/cloud/kubernetes-data-protection.html) (formerly Kasten K10) provides operations teams with a secure system for backup and recovery of Kubernetes applications. Veeam Kasten is available in a free version with limited functionality and no support, and a paid version that includes more features and customer support.

Veeam Kasten provides a comprehensive backup solution when it's deployed as a Kubernetes operator within a cluster. Veeam Kasten offers a management dashboard for centralized control and visibility. Users can benefit from incremental and application-aware backups to enable efficient data protection. Additionally, Veeam Kasten offers DR capabilities. These capabilities include automated failover and failback, and features for data migration and ensuring security.

For more information about Veeam Kasten's feature set, see the [Veeam Kasten documentation](https://docs.kasten.io/latest/index.html). For more information about how to effectively use Veeam Kasten with AKS clusters, see [Installing Veeam Kasten on Azure](https://docs.kasten.io/latest/install/azure/azure.html).

### Velero

Velero is a widely used open-source backup and recovery tool for Kubernetes. Velero offers a free and unrestricted version available to all users, with support and maintenance provided by a community of project contributors.

Velero runs as a deployment in the cluster and provides a comprehensive set of features for application backup, recovery, and data migration. Dashboards aren't available out of the box but they can be added through external integrations.

For more information about Velero's feature set and how to integrate it with AKS clusters, see the [Velero documentation](https://velero.io/docs).

## Install and configure AKS Backup

The following links provide guidance and instructions to help you install and configure AKS Backup:

- For a detailed description of the prerequisites for using AKS Backup with your AKS cluster, see [Prerequisites for AKS Backup using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup-concept).

- For a detailed description of AKS Backup's region availability, supported scenarios, and limitations, see the [AKS Backup support matrix](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix).

- For guidance on how to register the required resource providers on your subscriptions and how to manage these registrations, see [Manage AKS backups using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-manage-backups).

- For detailed instructions on how to set up backup and recovery for your AKS cluster using AKS Backup, see [Back up AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-backup). These instructions include information about how to create and configure all the necessary Azure resources, such as Backup vault, Backup policies, and Backup instances.

- For detailed instructions on how to perform full or item-level restores of your AKS cluster from an existing Backup instance, see [Restore AKS using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-restore).

## Backup frequency and retention in AKS: Defining a backup policy

Backup and recovery solutions require defined backup frequencies and retention periods. These parameters define how often backups are performed and how long they're retained before deletion. Select the backup frequency and retention period for an AKS cluster and its workload that aligns with your predefined Recovery Point Objective (RPO) and Recovery Time Objective (RTO).

In a Kubernetes scenario, the RPO represents the maximum acceptable amount of cluster state or data loss that can be tolerated. The RTO specifies the maximum allowable time between cluster state or data loss and the resumption of cluster operations.

The backup frequency and retention period must balance desirable RPO/RTO targets, storage costs, and backup management overhead. There's no one-size-fits-all configuration for AKS clusters and workloads. The optimum configuration for each cluster or workload should be carefully defined to meet the requirements of the business. Consider the following factors when you define the backup frequency and retention period for an AKS cluster:

- **Criticality:** The level of criticality associated with the cluster and its workload application data in terms of business continuity.

- **Access patterns and change rate:** The amount of cluster state and data that's added, modified, deleted in a specified period of time.

- **Data Volume:** The volume of data, which affects storage costs and the time required to complete backup and recovery operations.

- **Compliance:** The requirements for data retention and data sovereignty based on internal compliance rules and industry regulations.

In the AKS Backup service, backup frequency and retention period are stored as a *backup policy* resource, which applies to both the cluster state and the application data from PVs.

Backup policies in AKS Backup support backup frequencies at **4, 6, 8, 12, and 24-hour intervals**, with retention periods of up to 360 days for the Operational Tier and up to 30 days for the Vault Tier. Multiple policies can be defined and applied to the same cluster.

For more information on how to configure backup policies in AKS Backup, see [Create a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy).

## Other backup considerations

To ensure that your backup and recovery solution meets your organization's requirements and policies, consider the following points:

- **RPO and RTO:** Determine if you have specific RPO and RTO targets that need to be met for your backups and recovery operations.

- **PVs:** Verify if you're using PVs and ensure that the AKS Backup solution supports your PV types.

- **Backup scope:** Define what needs to be backed up, such as specific namespaces, types of resources, or specific data within the cluster. For more information, see [Configure a backup job](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups).

- **Backup frequency and retention:** Determine the frequency at which you need to perform backups and the duration for which you need to retain them. This setting can be configured using backup policies.

- **Cluster selection:** Decide if you need to back up all clusters or only specific production clusters based on your requirements.

- **Test restore procedure:** Perform periodic test restores to validate the reliability and usability of your backup strategy. This step is crucial for ensuring the effectiveness of the backup and recovery solution.

- **Supported scenarios:** Verify that the AKS Backup solution supports your specific scenario.

- **Budget allocations:** Consider if you have specific budget allocations for backup and restore operations. Review the [pricing](/azure/backup/azure-kubernetes-service-backup-overview#understand-pricing) information provided by the AKS Backup solution to align with your budgetary requirements.

## AKS Backup location and storage

AKS Backup uses a Backup vault, a storage account, and the optional Vault Tier to store the different types of data captured from a cluster during a backup.

### Operational Tier storage

For disk-based PVs, AKS Backup uses [incremental snapshots](/azure/virtual-machines/disks-incremental-snapshots) of the underlying Azure Disk. Incremental snapshots are point-in-time backups for managed disks that consist only of the changes since the last snapshot. The first incremental snapshot is a full copy of the disk. These snapshots are stored within your Azure subscription in the same region as the source disk.

Cluster state (Kubernetes resources) is backed up to a blob container within a designated [storage account](/azure/storage/common/storage-account-overview). The storage account provides multiple intra-region and cross-region redundancy options to ensure data durability.

### Vault Tier storage

If Vault Tier is turned on in the backup policy, AKS Backup copies backup data to an Azure Backup managed vault. Vault Tier provides an **off-site, isolated storage** layer that's managed entirely by Azure Backup, separate from your subscription. This layer provides protection against ransomware and operational mistakes. Vault Tier is available only for PVs backed by Azure Disks up to 1 TB in size. To use Vault Tier, a **staging resource group and storage account** are required as intermediate locations during data transfer.

When the Backup vault is configured with **geo-redundant storage (GRS)**, and CRR is turned on, backup data in the Vault Tier is replicated to the Azure-paired secondary region. This configuration supports the recovery of workloads in the secondary region with an RPO of up to 36 hours.

### Backup vault

A [Backup vault](/azure/backup/backup-vault-overview) is a secure storage entity within Azure. Backup vaults store backup data for workloads that Azure Backup supports, such as AKS clusters. The Backup vault stores the backup policies, backups, and recovery points that backup jobs create.

Azure manages the storage for a Backup vault. You can choose from several redundancy options for the data stored within it, including LRS, GRS, and ZRS. You can configure these options when you create the Backup vault.

## Using AKS Backup to migrate workloads between AKS clusters

You can use AKS Backup as a mechanism for backup and recovery for specific clusters. You can take a backup from one cluster and restore it to another cluster by using AKS Backup. AKS Backup supports migration scenarios including:

- Restoration of a development cluster to a staging cluster.
- Replication of contents across multiple clusters.
- Restoration of a backup to a cluster in a different subscription within the same tenant.

To redirect resources into different namespaces when restoring to a different cluster, use AKS Backup for conflict resolution. AKS Backup offers conflict resolution options such as **Skip** (skip resources that already exist in the target), **Patch** (update mutable fields on existing resources), and **namespace mapping**.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Adam Sharif](https://www.linkedin.com/in/adamsharif) | Technical Advisor
- [Joao Tavares](https://www.linkedin.com/in/joao-tavares-3976a63) | Senior Escalation Engineer

Other contributors:

- [Sam Cogan](https://www.linkedin.com/in/samcogan82/) | Senior Cloud Solution Architect
- [Sonia Cuff](https://www.linkedin.com/in/soniacuff) | Principal Cloud Advocate Lead
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

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
- [Business continuity and DR best practices for AKS](/azure/aks/operator-best-practices-multi-region)
- [Reliability patterns - Cloud design patterns](/azure/well-architected/reliability/design-patterns)

### Non-Microsoft AKS backup and recovery options

- [Veeam Kasten](https://docs.kasten.io/latest/index.html)
- [Velero](https://velero.io/docs)

## Related resources

- [AKS day-2 operations guide - Introduction](/azure/architecture/operator-guides/aks/day-2-operations-guide)
- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [AKS baseline for multiregion clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster)