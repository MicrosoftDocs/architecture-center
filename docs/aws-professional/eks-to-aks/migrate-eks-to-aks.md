---
title: Migrate from Amazon Elastic Kubernetes Service (EKS) to Azure Kubernetes Service (AKS)
description: Learn about options for migrating from Amazon EKS to Azure Kubernetes Service (AKS).
author: ketan-chawda-msft
ms.author: kechaw
ms.date: 06/05/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-policy
  - azure-backup
categories:
  - containers
  - management-and-governance
---

# Migrate from Amazon EKS to Azure Kubernetes Service (AKS)

This article provides strategies for migrating typical stateless and stateful workloads from Amazon EKS to Azure Kubernetes Service (AKS).

## Considerations

The actual deployment process of a real-world production workload can vary depending on the following factors:

- **Deployment strategies:** The choice between GitOps and traditional DevOps Continuous Integration/Continuous Deployment (CI/CD) methods significantly influences the deployment approach. GitOps prioritizes declarative infrastructure managed through version-controlled repositories, while DevOps CI/CD focuses on automated workflows for application delivery.
- **Deployment artifacts**: The selection of deployment artifacts plays a crucial role in defining the deployment structure. YAML files, manifest files, Helm charts, and Kustomize configurations represent various approaches to specifying and customizing deployment settings, each with its strengths and use cases.
- **Workload authentication and authorization**: Depending on the setup, authentication and authorization methods can differ. You can use Amazon Web Services (AWS) Identity and Access Management (IAM) roles, workload identity mechanisms, or connection strings for access control.

- **Monitoring:** Implementation of monitoring solutions is a critical aspect that can involve various tools and methodologies to ensure the performance and health of the deployed workloads. For more information on how AKS monitoring compares to EKS, see [Kubernetes monitoring and logging](/azure/architecture/aws-professional/eks-to-aks/monitoring).

Before beginning your migration, review and consider the following general guidance and best-practice resources:

- Review the [cluster operator and developer best practices](/azure/aks/best-practices).
- Define the [monitoring and alerting strategy](/azure/aks/monitor-aks) to ensure the application is performing as expected.
- Define the [security](/azure/aks/concepts-security) and compliance requirements for the application and the AKS environment.
- Define the [access control policies](/azure/aks/manage-azure-rbac) and how they're enforced. Identify any compliance standards that must be adhered to.
- Define the [disaster recovery and business continuity plan](/azure/aks/operator-best-practices-multi-region) for the AKS environment and the application.
- Define the [backup](/azure/backup/azure-kubernetes-service-cluster-backup) and restore policies and procedures. Identify the recovery time objective (RTO) and recovery point objective (RPO).
- Identify any risks or challenges that might be encountered during the deployment.
- Test the functionality to ensure the application works as expected before redirecting live traffic to the new AKS cluster.

## Workload migration considerations

This section reviews some things you should consider before migrating your workloads from Amazon EKS to AKS.

### Understand your existing Amazon EKS environment

Analyze the existing EKS environment to understand the current architecture, resources, and configurations.

- **Review EKS configuration**: Assess EKS cluster configuration, such as node types, number of nodes, Kubernetes version and support policy, and scaling configuration.

   > [!NOTE]
   > EKS allows the creation of [custom AMI images](https://github.com/aws-samples/amazon-eks-custom-amis) for EKS nodes. AKS doesn't allow the use of custom node images. If your deployment requires node customization, you can apply [kubelet customization](/azure/aks/custom-node-configuration?tabs=linux-node-pools) and/or [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) to customize your nodes.

- **Review application workloads**: Identify all the Kubernetes workloads running on the EKS cluster including deployments, services, stateful sets, ingress configurations, and persistent volume claims. Ensure you have a complete list of applications and their associated resources.

- **Check dependencies**: Identify any dependencies on AWS services specific to EKS.

   | AWS service | Dependency |
   | ----------- | ---------- |
   | AWS Secret Manager | [Azure Key Vault](/azure/key-vault/general/overview) |
   | AWS Guard Duty Agent | [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) |
   | EKS Pod Identity Agent | [Microsoft Entra ID Workload Identity](/azure/aks/workload-identity-overview?tabs=dotnet) |
   | Amazon Elastic File System (EFS) or Elastic Block Store (EBS) Container Storage Interface (CSI) drivers | [AKS CSI Drivers](/azure/aks/csi-storage-drivers) |

- **Backup EKS cluster**: You can use a non-Microsoft tool like [Velero](https://velero.io/) to back up and migrate Kubernetes resources and persistent volumes.

### Prepare the Azure AKS environment

The [Amazon virtual private cloud (VPC) Container Networking Interface (CNI)](https://docs.aws.amazon.com/eks/latest/userguide/eks-networking.html) is the default networking plugin supported by EKS. An AKS cluster supports multiple network plugins and methods to deploy a cluster in a virtual network, including:

- [Kubenet networking](/azure/aks/configure-kubenet) (default in AKS)
- [Azure CNI Networking](/azure/aks/configure-azure-cni?tabs=configure-networking-portal)
- [Azure CNI Overlay](/azure/aks/azure-cni-overlay?tabs=kubectl)
- [Azure CNI networking for dynamic allocation](/azure/aks/configure-azure-cni-dynamic-ip-allocation)
- [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium)
- [Non-Microsoft CNIs](/azure/aks/use-byo-cni)

To prepare your AKS cluster, follow these steps:

1. Create a new AKS cluster in Azure, configuring the desired networking settings to match your requirements.
1. Review your Kubernetes manifests and YAML files used in EKS. Check for any potential Kubernetes API version incompatibility or specific EKS configurations that AKS doesn't support.
1. Ensure that your Docker images and container image registry location are accessible from the AKS cluster. Verify network connectivity and any required authentication and authorization settings for accessing the images.

By following these steps, you can successfully create an AKS cluster and ensure compatibility for your Kubernetes manifests and Docker images, ensuring a smooth migration process from EKS to AKS.

## Migration overview

Migrating from Amazon EKS to AKS involves several steps, such as:

- **Container image migration**: Migrating container images is a crucial step when moving from EKS to AKS. You can use tools like kubectl, Docker, or container registries to export and import images.
   1. [Export Images from EKS](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-pull-ecr-image.html).
   1. [Set up an Azure Container Registry](/azure/container-registry/container-registry-get-started-portal) and attach it to AKS if you haven't already.
   1. [Push images](/azure/container-registry/container-registry-get-started-portal) to Container Registry.

  Container images can also be imported into Container Registry directly from a non-Azure public or private repository. For more information, see [Import container images](/azure/container-registry/container-registry-import-images).

- **Kubernetes manifest migration**: AKS uses the Kubernetes YAML file manifest to define Kubernetes objects. Deployments are typically created and managed with kubectl create or kubectl apply. Create a deployment by defining a manifest file in the YAML format. For more information, see this [sample AKS manifest](https://github.com/Azure-Samples/aks-store-demo/blob/main/aks-store-quickstart.yaml). You can learn more about how YAML files work on Kubernetes by reviewing [Deployments and YAML manifests](/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests).

- **Data migration**: Carefully plan your migration of stateful applications to avoid data loss or unexpected downtime. For more information, see the section [Stateful workload migration considerations](#stateful-workload-migration-considerations).

### Stateless workload migration considerations

Migrating your Kubernetes manifests involves adapting the configuration to work in the Azure environment, including these steps:

1. **Update manifests**: Update your Kubernetes manifests to use the new image locations in Container Registry. Replace the image references in your YAML files with the Container Registry path.

   1. Review your existing Kubernetes manifest files for AWS-specific configurations, such as VPC and IAM roles.
   1. Review the EKS IAM roles associated with nodes, service accounts, and other resources. Map it with equivalent Azure AKS role-based access control (RBAC) roles. For more information, see [Kubernetes workload identity and access](/azure/architecture/aws-professional/eks-to-aks/workload-identity).
   1. Modify the manifest files to replace AWS-specific settings with Azure-specific settings, like annotations.

1. **Apply manifests to AKS**:

   1. [Connect to AKS Cluster](/azure/aks/learn/quick-kubernetes-deploy-portal).
   1. Apply the modified Kubernetes manifest files using `kubectl apply -f`.

### Stateful workload migration considerations

If your applications use [Persistent Volumes (PVs)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) or [Persistent Volume Claims (PVCs)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) for data storage, make sure you back up this data. You can use tools like [Velero](https://velero.io/) to perform cluster backups, including for PVs and PVCs data. For more information, see [Backup and restore your Amazon EKS cluster resources using Velero](https://aws.amazon.com/blogs/containers/backup-and-restore-your-amazon-eks-cluster-resources-using-velero/).

Stateful applications typically have persistent data storage requirements, which add complexity to the migration process. For a comparison of the storage capabilities of Amazon EKS and AKS, see [Storage options for a Kubernetes cluster](/azure/architecture/aws-professional/eks-to-aks/storage).

Follow these steps to back up persistent data:

1. Set up Velero in [AKS](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure) and [EKS](https://github.com/vmware-tanzu/velero-plugin-for-aws) cluster.
1. Perform a [backup of your EKS cluster](https://velero.io/docs/main/file-system-backup/).
1. Copy the Velero backup from S3 bucket to Azure blob storage, by using the [az copy command](/azure/storage/common/storage-use-azcopy-s3).
1. Since AKS and EKS might use different `storageClassNames` for the persistent volume claims, create a [`configMap`](https://velero.io/docs/v1.13/restore-reference/#changing-pvpvc-storage-classes) that translates the source `storageClassNames` to an AKS-compatible class name. You can ignore this step if you're using the same storage solution on the EKS and the AKS Kubernetes clusters.
1. Restore the backup to AKS (using [Velero restore command](https://velero.io/docs/main/restore-reference/)).
1. Apply necessary changes to the restored objects, such as references to container images in Amazon Elastic Container Registry (ECR), or access to secrets.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

<!-- docutune:ignoredChange ISV -->

Principal authors:

- Dixit Arora | Senior Customer Engineer, ISV DN CoE
- [Ketan Chawda](https://www.linkedin.com/in/ketanchawda1402) | Senior Customer Engineer, ISV DN CoE

Other contributors:

- [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, ISV & DN CoE
- [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Principal Cloud Solution Architect
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a/) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Migration Guide - Azure Samples](https://github.com/Azure-Samples/eks-aks-migration-guide)
- [AKS for Amazon EKS professionals](/azure/architecture/aws-professional/eks-to-aks/)
- [Kubernetes identity and access management](/azure/architecture/aws-professional/eks-to-aks/workload-identity)
- [Kubernetes monitoring and logging](/azure/architecture/aws-professional/eks-to-aks/monitoring)
- [Secure network access to Kubernetes](/azure/architecture/aws-professional/eks-to-aks/private-clusters)
- [Storage options for a Kubernetes cluster](/azure/architecture/aws-professional/eks-to-aks/storage)
- [Cost management for Kubernetes](/azure/architecture/aws-professional/eks-to-aks/cost-management)
- [Kubernetes node and node pool management](/azure/architecture/aws-professional/eks-to-aks/node-pools)
- [Cluster governance](/azure/architecture/aws-professional/eks-to-aks/governance)

## Related resources

- [Back up, restore workload clusters using Velero in AKS hybrid](/azure/aks/hybrid/backup-workload-cluster)
- [Migrate to Azure Kubernetes Service (AKS)](/azure/aks/aks-migration)
