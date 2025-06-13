---
author: claytonsiemens77
ms.author: pnp
ms.topic: include
---

### Virtual machines and servers

Virtual machines (VMs) and servers allow users to deploy, manage, and maintain OS and other software. Users pay for what they use, with the flexibility to change sizes.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) | AWS and Azure on-demand VMs bill per seconds used. Although AWS instance types and Azure VM sizes have similar categories, the exact RAM, CPU, and storage capabilities differ. For information about Azure VM sizes, see [Azure VM sizes](/azure/virtual-machines/sizes).|
| [VMware Cloud on AWS](https://aws.amazon.com/vmware) | [Azure VMware Solution](https://azure.microsoft.com/services/azure-vmware) | AWS and Azure solutions let you move VMware vSphere-based workloads and environments to the cloud. Azure VMware Solution is a VMware-verified Microsoft service that runs on Azure infrastructure. You can manage existing environments with VMware solution tools, while modernizing applications with cloud native services. |
| [AWS Parallel Cluster](https://aws.amazon.com/hpc/parallelcluster) | [Azure CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud) | Create, manage, operate, and optimize HPC and large compute clusters of any scale. |

[View all the virtual machines architectures](/azure/architecture/browse/?expanded=azure&products=azure-virtual-machines)

### Autoscaling

Autoscaling lets you automatically change the number of VM instances. You set defined metrics and thresholds that determine when to add or remove instances.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Auto Scaling](https://aws.amazon.com/autoscaling) | [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview), [App Service autoscale](/azure/app-service/web-sites-scale)| In Azure, virtual machine scale sets let you deploy and manage identical sets of VMs. The number of sets can autoscale. App Service autoscale lets you autoscale Azure App Service applications.|

[View all the autoscaling architectures](/azure/architecture/browse/?expanded=azure&products=azure-vm-scalesets)

### Batch processing

Batch processing runs large-scale parallel and high-performance computing applications efficiently in the cloud.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Batch](https://aws.amazon.com/batch) | [Azure Batch](https://azure.microsoft.com/services/batch) | [Azure Batch](/azure/batch/batch-technical-overview) helps you manage compute-intensive work across a scalable collection of VMs.|

[View all the batch processing architectures](/azure/architecture/browse/?expanded=azure&products=azure-batch)

### Storage

Several services provide different types of data storage for VM disks.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
|Disk volumes on [Amazon Elastic Block Store (EBS)](https://aws.amazon.com/ebs)| Data disks in [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs).|[Data disks](/azure/virtual-machines/linux/managed-disks-overview) in blob storage provide durable data storage for Azure VMs. This storage is similar to AWS EC2 instance disk volumes on EBS.|
|[Amazon EC2 instance store](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html)|[Azure temporary storage](/archive/blogs/mast/understanding-the-temporary-drive-on-windows-azure-virtual-machines)|Azure temporary storage provides VMs with similar low-latency temporary read-write storage to EC2 instance storage, also called ephemeral storage.|
|[Amazon EBS Provisioned IOPS Volume](https://aws.amazon.com/ebs/provisioned-iops)|[Azure premium storage](/azure/virtual-machines/premium-storage-performance)|Azure supports higher performance disk I/O with premium storage. This storage is similar to AWS Provisioned IOPS storage options.|
|[Amazon Elastic File System (EFS)](https://aws.amazon.com/efs)|[Azure Files](/azure/storage/files/storage-files-introduction)|Azure Files provides VMs with similar functionality to Amazon EFS.|

[View all the storage architectures](/azure/architecture/browse/?expanded=azure&azure_categories=storage)

### Containers and container orchestrators

Several AWS and Azure services provide containerized application deployment and orchestration.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Elastic Container Service (Amazon ECS)](https://aws.amazon.com/ecs), [AWS Fargate](https://aws.amazon.com/fargate) | [Azure Container Apps](https://azure.microsoft.com/products/container-apps/) | Azure Container Apps is a scalable service that lets you deploy thousands of containers without requiring access to the control plane. |
| [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry) | Container registries store Docker formatted images and create all types of container deployments in the cloud. |
| [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks) | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) | EKS and AKS let you orchestrate Docker containerized application deployments with Kubernetes. AKS simplifies monitoring and cluster management through auto upgrades and a built-in operations console. See [Container runtime configuration](/azure/aks/concepts-clusters-workloads#container-runtime-configuration) for specifics on the hosting environment.|
| [AWS App Mesh](https://aws.amazon.com/app-mesh) | [Istio add-on for AKS](/azure/aks/istio-about)| The Istio add-on for AKS provides a fully-supported integration of the open-source Istio service mesh. |

#### Example container architectures

| Architecture | Description |
|----|----|
| [Baseline architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks/baseline-aks) | Deploy a baseline infrastructure that deploys an AKS cluster with a focus on security. |
| [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices) | Deploy a microservices architecture on Azure Kubernetes Service (AKS). |
| [CI/CD pipeline for container-based workloads](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) | Build a DevOps pipeline for a Node.js web app with Jenkins, Azure Container Registry, Azure Kubernetes Service, Azure Cosmos DB, and Grafana. |

[View all the container architectures](/azure/architecture/browse/?azure_categories=containers)

### Serverless computing

Serverless computing lets you integrate systems and run backend processes without provisioning or managing servers.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Lambda](https://aws.amazon.com/lambda) | [Azure Functions](https://azure.microsoft.com/services/functions), [WebJobs](/azure/app-service/web-sites-create-web-jobs) in Azure App Service| Azure Functions is the primary equivalent of AWS Lambda in providing serverless, on-demand code. AWS Lambda functionality also overlaps with Azure WebJobs, which let you schedule or continuously run background tasks.|

#### Example serverless architectures

| Architecture | Description |
|-----|-----|
| [Cross-cloud scaling pattern](/azure/adaptive-cloud/app-solutions/pattern-cross-cloud-scale) | Learn how to improve cross-cloud scalability with a solution architecture that includes Azure Stack. A step-by-step flowchart details instructions for implementation. |

[View all the serverless architectures](/azure/architecture/browse/?expanded=azure&products=azure-functions)
