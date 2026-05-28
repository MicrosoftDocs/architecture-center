---
title: Compare AWS and Azure Compute Services
description: Compare the compute services in Azure and Amazon Web Services (AWS). Explore the differences in virtual machines (VMs), containers, and serverless technologies.
author: juanosorioms
ms.author: jcosorio
ms.date: 05/28/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection:
 - migration
 - aws-to-azure
---

# Compute services on Azure and AWS

This article compares Microsoft Azure and Amazon Web Services (AWS) core compute services.

- For links to articles that compare other AWS and Azure services, see [Azure for AWS professionals](index.md).

- For a complete listing and charts that show the service mapping between AWS and Azure, see [AWS to Azure services comparison](../gcp-professional/services.md).

- For Azure architectures, see [Browse Azure compute architectures](/azure/architecture/browse/?azure_categories=compute).

## Compare AWS and Azure compute services

The following tables describe and compare the core compute services on AWS and Azure.

### Virtual machines and servers

Virtual machines (VMs) and servers help you deploy, manage, and maintain the OS and other software. You pay only for what you use and can change sizes as needed.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [Amazon Lightsail](https://aws.amazon.com/lightsail/) | [Azure App Service](/azure/app-service/overview), [Azure Virtual Machines](/azure/virtual-machines/sizes-b-series-burstable) (B-series) | Amazon Lightsail provides simplified, predictably priced VMs with preconfigured application stacks. Azure doesn't have a dedicated equivalent, but you can achieve similar outcomes by using Azure App Service for web apps or Azure Virtual Machines configured with B-series burstable sizes and Microsoft Marketplace images. |
| [Amazon EC2 instance types](https://aws.amazon.com/ec2/instance-types/) | [Azure Virtual Machines](/azure/virtual-machines/overview) | AWS and Azure on-demand VMs bill per second used. AWS instance types and [Azure VM sizes](/azure/virtual-machines/sizes/overview) have similar categories, but the RAM, CPU, and storage capabilities differ. |
| [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) | [Azure CycleCloud](/azure/cyclecloud/overview) | Create, manage, operate, and optimize high-performance computing (HPC) and large compute clusters of any scale. |

[View all the VMs architectures](/azure/architecture/browse/?expanded=azure&products=azure-virtual-machines).

### Autoscaling

You can use autoscaling to automatically change the number of compute instances or resources based on defined metrics and thresholds.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Auto Scaling](https://aws.amazon.com/autoscaling/) | [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview), [Azure App Service autoscale](/azure/app-service/manage-scale-up) | In Azure, you can use virtual machine scale sets to deploy and manage identical sets of VMs. The number of sets can autoscale. You can use Azure App Service to autoscale Azure App Service applications. |

[View all the autoscaling architectures](/azure/architecture/browse/?expanded=azure&products=azure-vm-scalesets).

### Resource optimization recommendations

Resource optimization services analyze usage telemetry and configuration to recommend rightsizing, idle-resource detection, and cost-saving actions.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/) | [Azure Advisor](/azure/advisor/advisor-overview) (Cost category) | Both services analyze usage metrics to recommend rightsizing for compute resources. AWS Compute Optimizer focuses on Amazon EC2, Auto Scaling groups, Amazon EBS volumes, Lambda functions, Amazon ECS services on AWS Fargate, and Amazon Relational Database Service (Amazon RDS). Azure Advisor provides reliability, security, cost, operational, and performance recommendations across VMs, virtual machine scale sets, and most Azure services. |
| [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) | [Azure Advisor](/azure/advisor/advisor-overview) | AWS Trusted Advisor provides checks across cost optimization, security, performance, fault tolerance, and service limits. Azure Advisor covers the same pillars in a single integrated experience. |

### Batch processing

Batch processing runs large-scale parallel and HPC applications efficiently in the cloud.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Batch](https://aws.amazon.com/batch/) | [Azure Batch](/azure/batch/batch-technical-overview) | Azure Batch helps you manage compute-intensive work across a scalable collection of VMs. |

[View all the batch processing architectures](/azure/architecture/browse/?expanded=azure&products=azure-batch).

### Storage

Several services provide different types of data storage for VM disks.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [Amazon Elastic Block Store (Amazon EBS)](https://aws.amazon.com/ebs/) | [Amazon managed disks](/azure/virtual-machines/managed-disks-overview) | Amazon managed disks provide persistent block-level storage for Azure VMs, similar to Amazon EBS for Amazon EC2. Azure provides the Azure Standard HDD, Azure Standard SSD, Azure Premium SSD, Premium SSD v2, and Azure Ultra Disk Storage performance tiers. These tiers correspond to Amazon EBS volume types such as gp2, gp3, io1, io2, st1, and sc1. |
| [Amazon EC2 instance store](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html) | [Azure VM local/temporary disks](/azure/virtual-machines/enable-nvme-temp-faqs) | Azure VM sizes that include a local disk (typically SKUs with a *d* in their name, such as the Ddsv5 or Ddsv6 series) provide local Non-Volatile Memory Express (NVMe) or solid-state drive (SSD) storage for low-latency temporary data, similar to Amazon EC2 instance store. Local storage is non-persistent and is lost when the VM is deallocated or relocated. |
| [Amazon EBS provisioned IOPS volumes](https://aws.amazon.com/ebs/provisioned-iops/) (io1/io2, io2 Block Express, gp3) | [Premium SSD, Premium SSD v2, and Ultra Disk Storage](/azure/virtual-machines/disks-types) | Azure provides several high-performance managed disk tiers. Premium SSD v2 allows input/output operations per second (IOPS) and throughput to be configured independently from capacity, comparable to Amazon EBS gp3. Ultra Disk Storage provides submillisecond latency and high IOPS and throughput for the most demanding workloads, comparable to Amazon EBS io2 Block Express. For current limits, see [Scalability and performance targets for VM disks in Azure](/azure/virtual-machines/disks-scalability-targets). |
| [Amazon Elastic File System (Amazon EFS)](https://aws.amazon.com/efs/) | [Azure Files](/azure/storage/files/storage-files-introduction) | Azure Files provides VMs with similar functionality to Amazon EFS. |

[View all the storage architectures](/azure/architecture/browse/?expanded=azure&azure_categories=storage).

### Containers and container orchestrators

Both AWS and Azure services provide containerized application deployment and orchestration.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [Amazon Elastic Container Service (Amazon ECS)](https://aws.amazon.com/ecs/) | [Azure Container Apps](/azure/container-apps/overview) | Amazon ECS is a container orchestration service for deploying and managing containerized applications. Azure Container Apps is a managed container platform with built-in scaling, service discovery, and traffic management. |
| [AWS Fargate](https://aws.amazon.com/fargate/) | [Azure Container Instances](/azure/container-instances/container-instances-overview), [Azure Container Apps](/azure/container-apps/overview) | AWS Fargate is a serverless compute engine that provides compute capacity for Amazon ECS tasks and Amazon EKS pods. [Azure Container Instances](/azure/container-instances/container-instances-overview) provides on-demand serverless container compute and integrates with Azure Kubernetes Service (AKS) through [virtual nodes](/azure/aks/virtual-nodes). Azure Container Apps also provides serverless infrastructure management with higher-level orchestration features. |
| [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr/) | [Azure Container Registry](/azure/container-registry/container-registry-intro) | Container registries store Docker formatted images and create all types of container deployments in the cloud. Both services support vulnerability scanning, geo-replication, and private networking. |
| [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/) | [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) | You can use Amazon EKS and Azure Kubernetes Service (AKS) to orchestrate Docker containerized application deployments with Kubernetes. Azure Kubernetes Service (AKS) provides two modes: AKS Standard for full control and customization and [AKS Automatic](/azure/aks/intro-aks-automatic) for simplified, production-ready deployments with built-in best practices. For specifics about the hosting environment, see [Container runtime configuration](/azure/aks/core-aks-concepts#nodes). |
| [Amazon ECS Anywhere](https://aws.amazon.com/ecs/anywhere/), [Amazon EKS Anywhere](https://aws.amazon.com/eks/eks-anywhere/) | [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview), [AKS on Azure Arc](/azure/aks/aksarc/overview) | Both platforms support container orchestration services on-premises or in other cloud environments with centralized management from the respective cloud control planes. |

#### Example container architectures

| Architecture | Description |
| --- | --- |
| [Baseline architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks/baseline-aks) | Deploy a baseline infrastructure that deploys an Azure Kubernetes Service (AKS) cluster with a focus on security. |
| [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices) | Deploy a microservices architecture on Azure Kubernetes Service (AKS). |
| [Continuous integration and continuous delivery (CI/CD) pipeline for container-based workloads](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture) | Build a DevOps pipeline for a Node.js web app with Jenkins, Azure Container Registry, Azure Kubernetes Service (AKS), Azure Cosmos DB, and Grafana. |

[View all the container architectures](/azure/architecture/browse/?azure_categories=containers).

### Platform as a service for web apps and APIs

You can use platform as a service (PaaS) services to deploy web apps, APIs, and mobile back ends without managing the underlying infrastructure.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) | [Azure App Service](/azure/app-service/overview) | Both services provide fully managed hosting for web apps and APIs in common runtimes (.NET, Java, Node.js, Python, PHP, Ruby). They handle capacity provisioning, load balancing, autoscaling, and health monitoring. |
| [AWS App Runner](https://aws.amazon.com/apprunner/) | [Azure App Service (Linux container)](/azure/app-service/configure-custom-container), [Azure Container Apps](/azure/container-apps/overview) | AWS App Runner automatically deploys containerized web apps and APIs from a source repository or container image. Azure provides equivalent capability through Azure App Service for Linux containers or Azure Container Apps for a container-first serverless experience. |
| [AWS Amplify Hosting](https://aws.amazon.com/amplify/hosting/) | [Azure Static Web Apps](/azure/static-web-apps/overview) | Managed hosting for modern front-end web apps with built-in CI/CD from Git, global distribution, and serverless API integration. |

### Hybrid and edge compute

Services that extend cloud infrastructure and management to on-premises, edge, and customer-owned locations.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Outposts](https://aws.amazon.com/outposts/) (rack and servers) | [Azure Local](/azure/azure-local/overview) (formerly Azure Stack HCI) | Both services deliver cloud-managed, on-premises infrastructure for low-latency workloads and data-residency requirements. Azure Local provides a validated hyperconverged infrastructure (HCI) platform managed through the Azure portal. |
| [AWS Systems Manager](https://aws.amazon.com/systems-manager/) for non-AWS resources | [Azure Arc](/azure/azure-arc/overview) | Azure Arc extends Azure management and services (such as policy, monitoring, role-based access control (RBAC), and GitOps) to servers, Kubernetes clusters, and data services across on-premises, multicloud, and edge environments. |
| [AWS Wavelength](https://aws.amazon.com/wavelength/) | [Azure private multi‑access edge computing (MEC)](/azure/private-multi-access-edge-compute-mec/), [Azure public multi‑access edge computing (MEC) (Azure edge zones)](/azure/extended-zones/overview) | Edge compute for 5G and ultra-low-latency mobile workloads, available through partnerships with telecom carriers. |
| [AWS local zones](https://aws.amazon.com/about-aws/global-infrastructure/localzones/) | [Azure edge zones](/azure/extended-zones/overview) | Extensions of cloud regions that place compute and storage closer to users in metropolitan areas for latency-sensitive workloads. |

### Serverless computing

You can use serverless compute to integrate systems and run back-end processes without server provisioning or maintenance.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Lambda](https://aws.amazon.com/lambda/) | [Azure Functions](/azure/azure-functions/functions-overview) | Both services provide serverless, event-driven code execution with pay-per-execution pricing and automatic scaling. |
| [AWS Step Functions](https://aws.amazon.com/step-functions/) | [Azure durable functions](/azure/azure-functions/durable-functions/durable-functions-overview), [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) | Azure durable functions extend Azure Functions with stateful workflows written in code. Logic Apps provides a low-code visual designer for workflow orchestration across software as a service (SaaS) and on-premises services. |
| [AWS EventBridge](https://aws.amazon.com/eventbridge/) | [Azure Event Grid](/azure/event-grid/overview) | Managed event routing for event-driven architectures. |

#### Example serverless architectures

| Architecture | Description |
| --- | --- |
| [Cross-cloud scaling pattern](/azure-stack/user/pattern-cross-cloud-scale) | Learn how to improve cross-cloud scalability with a solution architecture that includes Azure Stack. A step-by-step flowchart details instructions for implementation. |

[View all the serverless architectures](/azure/architecture/browse/?expanded=azure&products=azure-functions).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Kobi Levi](https://www.linkedin.com/in/kobi-levi) | Cloud Solution Architect

Other contributor:

- [Juan Carlos Osorio](https://www.linkedin.com/in/juan-carlos-osorio-6252bba7/) | Cloud Solution Architect

## Next steps

- [Quickstart: Create a Linux VM in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- [Create a Node.js web app in Azure](/azure/app-service/app-service-web-get-started-nodejs)
- [Get started with Azure Functions](/azure/azure-functions/functions-get-started)
- [Quickstart: Create an Azure Kubernetes Service (AKS) Automatic cluster](/azure/aks/automatic/quick-automatic-managed-network)
- [Quickstart: Deploy your first container app with Azure Container Apps](/azure/container-apps/quickstart-portal)
- [Azure Kubernetes Service (AKS) architecture design](/azure/architecture/reference-architectures/containers/aks-start-here)

## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../reference-architectures/containers/aks/baseline-aks.yml)
- [Microservices architecture on Azure Kubernetes Service](../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Run a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml)
- [Basic web application](../web-apps/app-service/architectures/basic-web-app.yml)
- [Baseline Azure App Service web application with zone redundancy](../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Discover AWS instances](/azure/migrate/tutorial-discover-aws)
- [Assess AWS instances](/azure/migrate/tutorial-assess-aws)
- [Migrate AWS VMs](/azure/migrate/tutorial-migrate-aws-virtual-machines)
- [Migrate AWS to managed disks](/azure/virtual-machines/windows/on-prem-to-azure)

### Container and Kubernetes architectures

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../reference-architectures/containers/aks/baseline-aks.yml)
- [Microservices architecture on Azure Kubernetes Service](../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [CI/CD pipeline for container-based workloads](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture)

### VMs and web applications

- [Run a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml)
- [Basic web application](../web-apps/app-service/architectures/basic-web-app.yml)
- [Baseline Azure App Service web application with zone redundancy](../web-apps/app-service/architectures/baseline-zone-redundant.yml)

### AWS to Azure migration

- [Discover AWS instances for migration](/azure/migrate/tutorial-discover-aws)
- [Assess AWS instances for migration to Azure](/azure/migrate/tutorial-assess-aws)
- [Migrate AWS VMs to Azure](/azure/migrate/tutorial-migrate-aws-virtual-machines)
