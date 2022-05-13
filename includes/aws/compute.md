---
author: doodlemania2
ms.author: adboegli
ms.topic: include
ms.service: architecture-center
---

### Virtual servers

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Compute Cloud (EC2) Instances](https://aws.amazon.com/ec2/) | [Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) | Virtual servers allow users to deploy, manage, and maintain OS and server software. Instance types provide combinations of CPU/RAM. Users pay for what they use with the flexibility to change sizes. |
| [Batch](https://aws.amazon.com/batch/) | [Batch](https://azure.microsoft.com/services/batch/) | Run large-scale parallel and high-performance computing applications efficiently in the cloud. |
| [Auto Scaling](https://aws.amazon.com/autoscaling/) | [Virtual Machine Scale Sets](https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) | Allows you to automatically change the number of VM instances. You set defined metric and thresholds that determine if the platform adds or removes instances. |
| [VMware Cloud on AWS](https://aws.amazon.com/vmware/) | [Azure VMware Solution](https://azure.microsoft.com/services/azure-vmware/) | Seamlessly move VMware vSphere-based workloads from your data center to Azure and integrate your VMware vSphere environment with Azure. Keep managing your existing environments with the same VMware solution tools you already know while you modernize your applications with Azure native services. Azure VMware Solution is a Microsoft service, verified by VMware, that runs on Azure infrastructure. |
| [Parallel Cluster](https://aws.amazon.com/hpc/parallelcluster/) | [CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud/) | Create, manage, operate, and optimize HPC and big compute clusters of any scale |

### Containers and container orchestrators

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Container Service (ECS)](https://aws.amazon.com/ecs/)<br/><br/>[Fargate](https://aws.amazon.com/fargate/) | [Container Instances](https://azure.microsoft.com/services/container-instances/) | Azure Container Instances is the fastest and simplest way to run a container in Azure, without having to provision any virtual machines or adopt a higher-level orchestration service. |
| [Elastic Container Registry](https://aws.amazon.com/ecr/) | [Container Registry](https://azure.microsoft.com/services/container-registry/) | Allows customers to store Docker formatted images. Used to create all types of container deployments on Azure. |
| [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) | [Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) | Deploy orchestrated containerized applications with Kubernetes. Simplify monitoring and cluster management through auto upgrades and a built-in operations console. See [AKS solution journey](/azure/architecture/reference-architectures/containers/aks-start-here). |
| [App Mesh](https://aws.amazon.com/app-mesh/) | [Service Fabric Mesh](https://docs.microsoft.com/azure/service-fabric-mesh/service-fabric-mesh-overview) | Fully managed service that enables developers to deploy microservices applications without managing virtual machines, storage, or networking.

#### Container architectures

<ul class="grid">

[!INCLUDE [Azure Kubernetes Service (AKS) Baseline Cluster](../../includes/cards/aks-baseline.md)]
[!INCLUDE [Microservices architecture on Azure Kubernetes Service (AKS)](../../includes/cards/aks.md)]
[!INCLUDE [CI/CD pipeline for container-based workloads](../../includes/cards/devops-with-aks.md)]

</ul>

[view all](/azure/architecture/browse/#containers)

### Serverless

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Lambda](https://aws.amazon.com/lambda/) | [Functions](https://azure.microsoft.com/services/functions/) | Integrate systems and run backend processes in response to events or schedules without provisioning or managing servers. |

#### Serverless architectures

<ul class="grid">

[!INCLUDE [Social App for Mobile and Web with Authentication](../../includes/cards/social-mobile-and-web-app-with-authentication.md)]
[!INCLUDE [HIPAA and HITRUST compliant health data AI](../../includes/cards/security-compliance-blueprint-hipaa-hitrust-health-data-ai.md)]
[!INCLUDE [Cross Cloud Scaling Architecture](../../includes/cards/cross-cloud-scaling.md)]

</ul>
