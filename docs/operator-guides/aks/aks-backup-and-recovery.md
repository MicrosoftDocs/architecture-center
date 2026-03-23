---
title: AKS Backup and Recovery
description: Learn how to back up and recover AKS clusters and their workloads to protect data, maintain availability, and support disaster recovery.
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

Backup and recovery are an essential part of any organization's operational and disaster recovery (DR) strategy. A backup and recovery plan usually relies on a diverse set of technologies and practices that are based on taking periodic copies of data and applications to a separate, secondary device or service. If a system failure, data loss, or disaster occurs, you can use these copies to recover data and applications and their business operations.

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes backup and recovery practices for AKS.

## Benefits of backing up your AKS cluster

As organizations increasingly adopt cloud-native deployments and Kubernetes, they must include Kubernetes clusters and workloads in their backup and recovery strategies. Implement backup and recovery in AKS to:

- Create a secondary copy of the configuration and data from your AKS cluster. You can use this copy if irreversible system failure, data loss, or disaster occurs.

- Copy Kubernetes resources and application data from one AKS cluster to another.
- Replicate your AKS cluster to create other environments.
- Take workload snapshots before maintenance operations, such as AKS version upgrades.
- Adhere to data protection requirements to maintain regulatory or organizational compliance.
- Roll back to a previous deployment quickly if you detect a problem with a recent deployment or change.

Backups help you restore your workload if a problem occurs, but they don't provide [high availability (HA)](/azure/well-architected/reliability/highly-available-multi-region-design). If you need intra-region HA and cross-region DR functionality while using AKS, consider one of the following options:

- [Availability zones](/azure/aks/availability-zones): AKS supports the use of availability zones, which are physically separate datacenters within an Azure region. You can ensure higher resiliency and fault tolerance within a region by deploying AKS clusters across multiple availability zones. This deployment keeps your applications operational even if one zone experiences an outage.

- [Redundancy options for persistent volumes (PVs)](/azure/aks/concepts-storage#storage-classes): AKS provides various redundancy options for PVs. The [Azure Disk Container Storage Interface driver for Kubernetes](https://github.com/kubernetes-sigs/azuredisk-csi-driver) supports built-in storage classes and custom storage classes that use locally redundant storage (LRS) or zone-redundant storage (ZRS) for better intra-region resiliency. For more information, see [Driver parameters](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/driver-parameters.md).

- [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/): Azure Kubernetes Fleet Manager supports multicluster and at-scale scenarios for AKS clusters within a region or across regions.

- [Geo-redundancy options for Azure Container Registry](/azure/container-registry/container-registry-geo-replication): Container Registry offers geo-replication capabilities. You can replicate your container images across different Azure regions by using geo-redundancy. Your images remain available even if a particular region experiences an outage, which provides higher availability for your container registry.

For more information about multiregion DR patterns, see the following articles:

- [Active-active HA for AKS](/azure/architecture/guide/aks/aks-high-availability)
- [Blue-green deployment of AKS clusters](/azure/architecture/guide/aks/blue-green-deployment-for-aks)

You can also use methodologies such as infrastructure as code (IaC), Azure Pipelines, GitOps, and Flux to quickly redeploy your workloads if disaster occurs. For more information about these methodologies, see the following articles:

- [Build and deploy to AKS by using Azure Pipelines](/azure/aks/devops-pipeline)
- [Tutorial: Deploy applications by using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Understand the structure and syntax of Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates/syntax)
- [What is Bicep?](/azure/azure-resource-manager/bicep/overview)
- [Overview of Terraform on Azure](/azure/developer/terraform/overview)

## What to back up

When you plan backup and recovery for AKS and Kubernetes clusters, identify which components to include in a backup to ensure a successful restore. These components include:

- **Cluster state:** The current and desired configuration or state of all Kubernetes objects within a cluster, including deployments, pods, and services. The cluster state is stored in a highly available etcd key-value pair database that often only the API server can access. You define cluster state declaratively through Kubernetes configuration files applied to the cluster, such as YAML manifests.

- **Application data:** The data that containerized workloads that run within the cluster create, manage, or access. Kubernetes recommends that you store application data in PVs to ensure data persistence across pod or container restarts. You can create PVs statically or dynamically and back them up by using various types of persistent storage. PVs offer flexibility and scalability for data storage and management requirements.

A complete backup of the cluster requires the cluster state and the application data to be included as a single unit, but determining the optimal scope of each backup depends on various factors. For example, the presence of alternative sources, like continuous integration and continuous delivery (CI/CD) pipelines, might make it easier to recover the cluster state. Additionally, the size of the application data plays a role in storage costs and the time required for backup and recovery operations.

The ideal backup and recovery strategy depends on the specific application and environment. Therefore, you should assess the scope of the backup on a case-by-case basis. Consider factors such as the importance of the cluster state and the volume of application data.

You don't need to target other components, such as individual cluster nodes (virtual machines) and local filesystems and volumes, in Kubernetes. These components are typically included in traditional backup and recovery plans for server-based systems, but in Kubernetes, relevant state and data aren't persisted on individual nodes or local filesystems.

## Backup and recovery options for AKS

There are notable differences between traditional monolithic applications and workloads that run in a Kubernetes cluster, which present several challenges to backup and recovery. Kubernetes workloads are highly dynamic and distributed, with data persisted across external PVs that multiple underlying resources and services support.

To effectively support Kubernetes environments, backup and recovery solutions must possess Kubernetes and application awareness. Backup and recovery solutions should offer a degree of automation, reliability, and integration, which is often not found in legacy or more conventional backup and recovery tools.

You can choose from various Kubernetes-native backup and recovery solutions that range from open-source to closed-source, with different licensing models.

The following section provides examples of backup and recovery solutions that you can use with AKS.

### AKS Backup

[AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview) provides an Azure-native process for backing up and restoring containerized applications and data in AKS clusters.

AKS Backup integrates with the [Resiliency dashboard](/azure/backup/backup-center-overview) in the Azure portal to help you govern, monitor, operate, and analyze backups at scale. Back up and restore the containerized applications and data that run in your AKS clusters by using the Azure-native process in AKS Backup.

AKS Backup supports on-demand or scheduled backups of full or fine-grained cluster state data and application data stored in Azure disk-based PVs. AKS Backup supports two storage tiers:

- **Operational tier:** Stores backups as local snapshots and Kubernetes resource backups in a storage account in your subscription.

- **Vault tier:** Copies backup data to an Azure Backup-managed storage vault for long-term retention and geo-redundant protection. The Vault tier supports only PVs backed by Azure disks up to 1 TB in size. This tier also provides **Cross Region Restore (CRR)**, which can recover AKS workloads in an Azure-paired secondary region.

For stateful workloads such as databases, use [custom hooks](/azure/backup/azure-kubernetes-service-backup-overview#backup-hooks) in AKS Backup. Ensure application-consistent backups by using backup hooks. You can use backup hooks to run custom scripts in containers. Use pre-hooks before a snapshot and post-hooks after a snapshot. For example, you can freeze a database write operation before a snapshot and unfreeze it afterward.

### Veeam Kasten

[Veeam Kasten](https://www.veeam.com/products/cloud/kubernetes-data-protection.html) (formerly Kasten K10) provides operations teams with a secure system for backup and recovery of Kubernetes applications. Veeam Kasten is available in a free version with limited functionality and no support, and a paid version that includes more features and customer support.

Veeam Kasten provides a comprehensive backup solution when you deploy it as a Kubernetes operator within a cluster. Veeam Kasten offers a management dashboard for centralized control and visibility. You can benefit from incremental and application-aware backups to provide data protection. Veeam Kasten also offers DR capabilities, including automated failover and failback and features for data migration and security.

For more information about Veeam Kasten's feature set, see the [Veeam Kasten documentation](https://docs.kasten.io/latest/index.html). For more information about how to effectively use Veeam Kasten with AKS clusters, see [Install Veeam Kasten on Azure](https://docs.kasten.io/latest/install/azure/azure.html).

### Velero

Velero is a widely used open-source backup and recovery tool for Kubernetes. Velero offers a free and unrestricted version available to all users, with support and maintenance provided by a community of project contributors.

Velero runs as a deployment in the cluster and provides a set of features for application backup, recovery, and data migration. Dashboards aren't available by default, but you can add them through external integrations.

For more information about Velero's feature set and how to integrate it with AKS clusters, see the [Velero documentation](https://velero.io/docs).

## Install and configure AKS Backup

To install and configure [AKS Backup](/azure/backup/azure-kubernetes-service-backup-overview), follow these steps:

1. Check [prerequisites for using AKS Backup with your AKS cluster](/azure/backup/azure-kubernetes-service-cluster-backup-concept).

1. Review [AKS Backup region availability, supported scenarios, and limitations](/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix).

1. Find out how to register the required resource providers on your subscriptions, how to manage these registrations and [manage AKS backups using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-manage-backups).

1. Learn how to [backup and recover your AKS cluster using AKS Backup](/azure/backup/azure-kubernetes-service-cluster-backup). These instructions include information about how to create and configure all the necessary Azure resources, such as Backup vault, Backup policies, and Backup instances.

1. Find out how to perform full or item-level [restores of your AKS cluster using Azure Backup](/azure/backup/azure-kubernetes-service-cluster-restore).

## Backup frequency and retention in AKS: Define a backup policy

Backup and recovery solutions require defined backup frequencies and retention periods. These parameters define how often backups are performed and how long they're retained before deletion. Select the backup frequency and retention period for an AKS cluster and its workload that aligns with your predefined recovery point objective (RPO) and recovery time objective (RTO).

In a Kubernetes scenario, the RPO represents the maximum acceptable amount of cluster state or data loss that can be tolerated. The RTO specifies the maximum allowable time between cluster state or data loss and the resumption of cluster operations.

The backup frequency and retention period must balance desirable RPO and RTO targets, storage costs, and backup management overhead. There's no universal configuration for AKS clusters and workloads. Carefully define the optimum configuration for each cluster or workload to meet your business requirements. Consider the following factors when you define the backup frequency and retention period for an AKS cluster:

- **Criticality:** The level of criticality associated with the cluster and its workload application data in terms of business continuity.

- **Access patterns and change rate:** The amount of cluster state and data that's added, modified, deleted in a specified period of time.

- **Data volume:** The volume of data, which affects storage costs and the time required to complete backup and recovery operations.

- **Compliance:** The requirements for data retention and data sovereignty based on internal compliance rules and industry regulations.

In AKS Backup, backup frequency and retention period are stored as a *backup policy* resource, which applies to both the cluster state and the application data from PVs.

Backup policies in AKS Backup support backup frequencies at 4, 6, 8, 12, and 24-hour intervals, with retention periods of up to 360 days for the Operational tier and up to 30 days for the Vault tier. You can define and apply multiple policies to the same cluster.

For more information about how to configure backup policies in AKS Backup, see [Create a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy).

## Other backup considerations

To ensure that your backup and recovery solution meets your organization's requirements and policies, consider the following points:

- **RPO and RTO:** Determine whether you must meet specific RPO and RTO targets for your backups and recovery operations.

- **PVs:** Verify whether you use PVs and ensure that the AKS Backup solution supports your PV types.

- **Backup scope:** Define what you need to back up, such as specific namespaces, types of resources, or specific data within the cluster. For more information, see [Configure a backup job](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups).

- **Backup frequency and retention:** Determine the frequency at which you need to perform backups and the duration for which you need to retain them. You can configure this setting by using backup policies.

- **Cluster selection:** Decide whether you need to back up all clusters or only specific production clusters based on your requirements.

- **Test restore procedure:** Perform periodic test restores to validate the reliability and usability of your backup strategy. This step is crucial for ensuring the effectiveness of the backup and recovery solution.

- **Supported scenarios:** Verify that the AKS Backup solution supports your specific scenario.

- **Budget allocations:** Consider whether you have specific budget allocations for backup and restore operations. Review the [pricing information in the AKS Backup solution](/azure/backup/azure-kubernetes-service-backup-overview#understand-pricing) to align with your budgetary requirements.

## AKS Backup location and storage

AKS Backup uses a backup vault, a storage account, and the optional Vault tier to store the different types of data captured from a cluster during a backup.

### Operational tier storage

For disk-based PVs, AKS Backup uses [incremental snapshots](/azure/virtual-machines/disks-incremental-snapshots) of the underlying Azure disk. Incremental snapshots are point-in-time backups for managed disks that consist of only the changes since the last snapshot. The first incremental snapshot is a full copy of the disk. These snapshots are stored within your Azure subscription in the same region as the source disk.

Cluster state (Kubernetes resources) is backed up to a blob container within a designated [storage account](/azure/storage/common/storage-account-overview). The storage account provides multiple intra-region and cross-region redundancy options to ensure data durability.

### Vault tier storage

If the backup policy uses the Vault tier, AKS Backup copies backup data to an Azure Backup managed vault. The Vault tier provides an off-site, isolated storage layer that's managed by Azure Backup, separate from your subscription. This layer provides protection against ransomware and operational mistakes. The Vault tier is available only for PVs backed by Azure disks up to 1 TB in size. To use the Vault tier, you must set up a staging resource group and storage account as intermediate locations during data transfer.

When the backup vault is configured with geo-redundant storage (GRS) and CRR is turned on, backup data in the Vault tier is replicated to the Azure-paired secondary region. This configuration supports the recovery of workloads in the secondary region with an RPO of up to 36 hours.

### Backup vault

A [backup vault](/azure/backup/backup-vault-overview) is a secure storage entity within Azure. Backup vaults store backup data for workloads that Azure Backup supports, such as AKS clusters. The backup vault stores the backup policies, backups, and recovery points that backup jobs create.

Azure manages the storage for a backup vault. You can choose from several redundancy options for the data stored within it, including LRS, GRS, and ZRS. You can configure these options when you create the backup vault.

## Use AKS Backup to migrate workloads between AKS clusters

You can use AKS Backup as a mechanism for backup and recovery for specific clusters. You can take a backup from one cluster and restore it to another cluster by using AKS Backup. AKS Backup supports migration scenarios including:

- Restoration of a development cluster to a staging cluster.
- Replication of contents across multiple clusters.
- Restoration of a backup to a cluster in a different subscription within the same tenant.

To redirect resources into different namespaces when you restore to a different cluster, use AKS Backup for conflict resolution. AKS Backup offers conflict resolution options such as skip (skip resources that already exist in the target), patch (update mutable fields on existing resources), and namespace mapping.

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
- [Configure AKS Backup](/azure/backup/azure-kubernetes-service-cluster-backup)
- [Create a backup vault](/azure/backup/create-manage-backup-vault#create-a-backup-vault)
- [Create a backup policy](/azure/backup/azure-kubernetes-service-cluster-backup#create-a-backup-policy)
- [Configure backups](/azure/backup/azure-kubernetes-service-cluster-backup#configure-backups)
- [Restore an AKS cluster](/azure/backup/azure-kubernetes-service-cluster-restore)
- [Business continuity and DR best practices for AKS](/azure/aks/operator-best-practices-multi-region)
- [Reliability patterns - Cloud design patterns](/azure/well-architected/reliability/design-patterns)

### Non-Microsoft AKS backup and recovery options

- [Veeam Kasten](https://docs.kasten.io/latest/index.html)
- [Velero](https://velero.io/docs)

## Related resources

- [AKS day-2 operations guide - Introduction](../../operator-guides/aks/day-2-operations-guide.md)
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [AKS baseline for multiregion clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
