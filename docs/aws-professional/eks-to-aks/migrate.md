---
title: Migrate from Amazon Elastic Kubernetes Service to Azure Kubernetes Service
description: Learn how to migrate stateless and stateful workloads from Amazon Elastic Kubernetes Service (EKS) to Azure Kubernetes Service (AKS).
author: ketan-chawda-msft
ms.author: kechaw
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
---

# Migrate from Amazon EKS to Azure Kubernetes Service

This article describes strategies to migrate typical stateless and stateful workloads from Amazon Elastic Kubernetes Service (EKS) to Azure Kubernetes Service (AKS).

## Considerations

The deployment process of a real-world production workload varies depending on the following factors:

- **Deployment strategies:** GitOps methods versus traditional DevOps continuous integration and continuous deployment (CI/CD) methods influence the deployment approach. GitOps prioritizes declarative infrastructure that's managed through version-controlled repositories. DevOps CI/CD focuses on automated workflows for application delivery.

- **Deployment artifacts:** Your deployment artifacts help define the deployment structure. YAML files, manifest files, Helm charts, and Kustomize configurations provide various approaches to specify and customize deployment settings. Each approach has unique strengths that benefit specific use cases.
- **Workload authentication and authorization:** Depending on the setup, authentication and authorization methods differ. You can use Amazon Web Services (AWS) Identity and Access Management (IAM) roles, workload identity mechanisms, or connection strings for access control.

- **Monitoring:** When you implement monitoring solutions, you can use various tools and methodologies to help ensure the performance and health of deployed workloads. For more information about how AKS and EKS monitoring compare, see [Kubernetes monitoring and logging](/azure/architecture/aws-professional/eks-to-aks/monitoring).

Before your migration, review and consider the following general guidance and best-practice resources:

- Review the [cluster operator and developer best practices](/azure/aks/best-practices).

- Define the [monitoring and alerting strategy](/azure/aks/monitor-aks) to help ensure that the application performs as expected.
- Define the [security](/azure/aks/concepts-security) and compliance requirements for the application and the AKS environment.
- Define the [access control policies](/azure/aks/manage-azure-rbac) and how to enforce them. Identify any compliance standards that your workload must adhere to.
- Define the [disaster recovery and business continuity plan](/azure/aks/operator-best-practices-multi-region) for the AKS environment and the application.
- Define the [backup](/azure/backup/azure-kubernetes-service-cluster-backup) and restore policies and procedures. Identify the recovery time objective (RTO) and recovery point objective (RPO).
- Identify any risks or challenges that you might encounter during the deployment.
- Test the functionality to ensure that the application works as expected before redirecting live traffic to the new AKS cluster.

## Workload migration considerations

Consider the following aspects before you migrate workloads from Amazon EKS to AKS.

### Understand your existing Amazon EKS environment

Analyze your existing EKS environment to understand the current architecture, resources, and configurations.

- **Review EKS configuration:** Assess EKS cluster configuration, such as node types, number of nodes, Kubernetes version and support policy, and scaling configuration.

   > [!NOTE]
   > EKS allows the creation of [custom AMI images](https://github.com/aws-samples/amazon-eks-custom-amis) for EKS nodes. AKS doesn't allow the use of custom node images. If your deployment requires node customization, you can apply [kubelet customization](/azure/aks/custom-node-configuration) and [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) to customize your nodes.

- **Review application workloads:** Identify all Kubernetes workloads that run on the EKS cluster, including deployments, services, stateful sets, ingress configurations, and persistent volume claims (PVCs). Create a complete list of applications and their associated resources.

- **Check dependencies:** Identify any dependencies on AWS services that are specific to EKS.

   | AWS service | Dependency |
   | ----------- | ---------- |
   | AWS Secrets Manager | [Azure Key Vault](/azure/key-vault/general/overview) |
   | Amazon GuardDuty agent | [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) |
   | EKS Pod Identity agent | [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview) |
   | Amazon Elastic File System (EFS) or Elastic Block Store (EBS) Container Storage Interface (CSI) drivers | [AKS CSI drivers](/azure/aks/csi-storage-drivers) |

- **Back up the EKS cluster:** You can use a non-Microsoft tool like [Velero](https://velero.io/) to back up and migrate Kubernetes resources and persistent volumes (PVs).

### Prepare the Azure AKS environment

The [Amazon Virtual Private Cloud (VPC) Container Networking Interface (CNI)](https://docs.aws.amazon.com/eks/latest/userguide/eks-networking.html) is the default networking plugin that EKS supports. An AKS cluster supports the following network plugins and methods to deploy a cluster in a virtual network:

- [Kubenet networking](/azure/aks/configure-kubenet) (default in AKS)
- [Azure CNI networking](/azure/aks/configure-azure-cni)
- [Azure CNI Overlay](/azure/aks/azure-cni-overlay)
- [Azure CNI networking for dynamic allocation](/azure/aks/configure-azure-cni-dynamic-ip-allocation)
- [Azure CNI with Cilium integration](/azure/aks/azure-cni-powered-by-cilium)
- [Non-Microsoft CNIs](/azure/aks/use-byo-cni)

To prepare your AKS cluster, follow these steps:

1. Create a new AKS cluster in Azure. Configure the desired networking settings to match your requirements.

1. Review the Kubernetes manifests and YAML files that you use in EKS. Check for any potential Kubernetes API version incompatibility or specific EKS configurations that AKS doesn't support.
1. Ensure that your Docker images and container image registry location are accessible from the AKS cluster. Verify network connectivity and any required authentication and authorization settings for accessing the images.

Follow these steps to successfully create an AKS cluster and help ensure compatibility for your Kubernetes manifests and Docker images. Proper compatibility helps ensure a smooth migration process from EKS to AKS.

## Migration overview

A migration from Amazon EKS to AKS involves the following steps:

- **Container image migration:** Use tools like kubectl, Docker, or container registries to export and import images.
   1. [Export images from EKS](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-pull-ecr-image.html).
   1. [Set up an Azure container registry](/azure/container-registry/container-registry-get-started-portal), and attach it to AKS if needed.
   1. [Push images](/azure/container-registry/container-registry-get-started-portal#push-image-to-registry) to the container registry.

  You can also import container images into a container registry directly from a non-Azure public or private repository. For more information, see [Import container images](/azure/container-registry/container-registry-import-images).

- **Kubernetes manifest migration:** AKS uses the Kubernetes YAML file manifest to define Kubernetes objects. Deployments are typically created and managed by using `kubectl create` or `kubectl apply`. To create a deployment, define a manifest file in YAML format. For more information, see [AKS sample manifest](https://github.com/Azure-Samples/aks-store-demo/blob/main/aks-store-quickstart.yaml).

- **Data migration:** Carefully plan your migration of stateful applications to avoid data loss or unexpected downtime.

### Stateless workload migration considerations

When you migrate your Kubernetes manifests, you must adapt the configuration to work in the Azure environment.

1. **Update manifests:** Update your Kubernetes manifests to use the new image locations in the container registry. Replace the image references in your YAML files with the container registry path.

   1. Review your existing Kubernetes manifest files for AWS-specific configurations, such as VPC and IAM roles.

   1. Review the EKS IAM roles that are associated with nodes, service accounts, and other resources. Map the roles with equivalent Azure AKS role-based access control (Azure RBAC) roles. For more information, see [Kubernetes workload identity and access](workload-identity.md).
   1. Modify the manifest files to replace AWS-specific settings with Azure-specific settings, like annotations.

1. **Apply manifests to AKS:**

   1. [Connect to the AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-portal).

   1. Apply the modified Kubernetes manifest files by using `kubectl apply -f`.

### Stateful workload migration considerations

If your applications use [PVs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) or [PVCs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) for data storage, make sure you back up their data. Use tools like [Velero](https://velero.io/) to perform cluster backups, including for PV and PVC data. For more information, see [Backup and restore your Amazon EKS cluster resources by using Velero](https://aws.amazon.com/blogs/containers/backup-and-restore-your-amazon-eks-cluster-resources-using-velero/).

Stateful applications typically have persistent data storage requirements, which add complexity to the migration process. For a comparison of the storage capabilities of Amazon EKS and AKS, see [Storage options for a Kubernetes cluster](/azure/architecture/aws-professional/eks-to-aks/storage).

Follow these steps to back up persistent data:

1. Set up Velero in [AKS](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure) and [EKS](https://github.com/vmware-tanzu/velero-plugin-for-aws) clusters.

1. Perform a [backup of your EKS cluster](https://velero.io/docs/main/file-system-backup/).
1. Copy the Velero backup from an S3 bucket to Azure Blob Storage by using the [AzCopy command](/azure/storage/common/storage-use-azcopy-s3).
1. If AKS and EKS use different `storageClassNames` for the PVCs, create a [`configMap`](https://velero.io/docs/v1.13/restore-reference/#changing-pvpvc-storage-classes) that translates the source `storageClassNames` to an AKS-compatible class name. If you use the same storage solution on the EKS and AKS Kubernetes clusters, skip this step. 
1. Restore the backup to AKS by using the [Velero restore command](https://velero.io/docs/main/restore-reference/).
1. Apply necessary changes to the restored objects, such as references to container images in Amazon Elastic Container Registry or access to secrets.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

<!-- docutune:ignoredChange ISV -->

Principal authors:

- Dixit Arora | Senior Customer Engineer, ISV DN CoE
- [Ketan Chawda](https://www.linkedin.com/in/ketanchawda1402) | Senior Customer Engineer, ISV DN CoE

Other contributors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, ISV & DN CoE
- [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Principal Cloud Solution Architect
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a/) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Back up and restore workload clusters by using Velero in AKS hybrid](/azure/aks/hybrid/backup-workload-cluster)
- [Migrate to AKS](/azure/aks/aks-migration)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
