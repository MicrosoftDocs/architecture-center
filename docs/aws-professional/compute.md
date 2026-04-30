---
title: Compare AWS and Azure compute services
description: Compare the compute services in Azure and AWS. Explore the differences in virtual machines, containers, and serverless technologies.
author: splitfinity81
ms.author: yubaijna
ms.date: 04/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection:
 - migration
 - aws-to-azure
---

# Compute services on Azure and AWS

This article compares the core compute services that Microsoft Azure and Amazon Web Services (AWS) offer.

- For links to articles that compare other AWS and Azure services, see [Azure for AWS professionals](index.md).
- For a complete listing and charts showing service mapping between AWS and Azure, see [AWS to Azure services comparison](services.md).
- [Browse Azure compute architectures](/azure/architecture/browse/?azure_categories=compute).

## Compare AWS and Azure compute services

The following tables describe and compare the core compute services on Amazon Web Services (AWS) and Azure.

### Virtual machines and servers

Virtual machines (VMs) and servers allow users to deploy, manage, and maintain OS and other software. Users pay for what they use, with the flexibility to change sizes.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Lightsail](https://aws.amazon.com/lightsail/) | [Azure Virtual Machines](/azure/virtual-machines/sizes-b-series-burstable) (B-series) / [Azure App Service](/azure/app-service/overview) | Amazon Lightsail provides simplified, predictably-priced VMs with pre-configured application stacks. Azure doesn't have a dedicated equivalent, but similar outcomes can be achieved with Azure App Service (for web apps) or Azure Virtual Machines using B-series burstable sizes and Marketplace images. |
| [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) | AWS and Azure on-demand VMs bill per seconds used. Although AWS instance types and Azure VM sizes have similar categories, the exact RAM, CPU, and storage capabilities differ. For more information about Azure VM sizes, see [Azure VM sizes](/azure/virtual-machines/sizes).|
| [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster) | [Azure CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud) | Create, manage, operate, and optimize high-performance computing (HPC) and large compute clusters of any scale. |

[View all the virtual machines architectures](/azure/architecture/browse/?expanded=azure&products=azure-virtual-machines)

### Autoscaling

Autoscaling lets you automatically change the number of compute instances or resources based on defined metrics and thresholds.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Auto Scaling](https://aws.amazon.com/autoscaling) | [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview), [App Service autoscale](/azure/app-service/web-sites-scale)| In Azure, virtual machine scale sets let you deploy and manage identical sets of VMs. The number of sets can autoscale. App Service autoscale lets you autoscale Azure App Service applications.|

[View all the autoscaling architectures](/azure/architecture/browse/?expanded=azure&products=azure-vm-scalesets)

### Resource optimization recommendations

Resource optimization services analyze usage telemetry and configuration to recommend right-sizing, idle-resource detection, and cost-saving actions.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/) | [Azure Advisor](/azure/advisor/advisor-overview) (Cost category) | Both services analyze usage metrics to recommend right-sizing for compute resources. AWS Compute Optimizer focuses on EC2, Auto Scaling groups, EBS volumes, Lambda functions, ECS services on Fargate, and RDS. Azure Advisor provides cost, performance, reliability, security, and operational recommendations across VMs, VM scale sets, and most Azure services. |
| [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) | [Azure Advisor](/azure/advisor/advisor-overview) | Trusted Advisor provides checks across cost optimization, security, performance, fault tolerance, and service limits. Azure Advisor covers the same pillars in a single integrated experience. |

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
| [Amazon Elastic Block Store (EBS)](https://aws.amazon.com/ebs) | [Azure Managed Disks](/azure/virtual-machines/managed-disks-overview) | Azure Managed Disks provide persistent block-level storage for Azure VMs, similar to EBS for EC2. Available tiers include Standard HDD, Standard SSD, Premium SSD, Premium SSD v2, and Ultra Disk, comparable to EBS volume types (gp2, gp3, io1, io2, st1, sc1). |
| [Amazon EC2 instance store](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html) | [Azure VM local/temporary disks](/azure/virtual-machines/enable-nvme-temp-faqs) | Azure VMs whose size includes a local disk (typically SKUs with a 'd' in their name, such as the Ddsv5 or Ddsv6 series) provide local NVMe or SSD storage for low-latency temporary data, similar to EC2 instance store. Local storage is non-persistent and is lost when the VM is deallocated or relocated. |
| [Amazon EBS Provisioned IOPS](https://aws.amazon.com/ebs/provisioned-iops) (io1/io2, io2 Block Express, gp3) | [Premium SSD, Premium SSD v2, and Ultra Disk](/azure/virtual-machines/disks-types) | Azure offers several high-performance managed disk tiers. Premium SSD v2 allows IOPS and throughput to be configured independently from capacity, comparable to EBS gp3. Ultra Disk provides sub-millisecond latency and high IOPS and throughput for the most demanding workloads, comparable to EBS io2 Block Express. For current limits, see [Scalability and performance targets for VM disks in Azure](/azure/virtual-machines/disks-scalability-targets). |
|[Amazon Elastic File System (EFS)](https://aws.amazon.com/efs)|[Azure Files](/azure/storage/files/storage-files-introduction)|Azure Files provides VMs with similar functionality to Amazon EFS.|

[View all the storage architectures](/azure/architecture/browse/?expanded=azure&azure_categories=storage)

### Containers and container orchestrators

Several AWS and Azure services provide containerized application deployment and orchestration.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Elastic Container Service (Amazon ECS)](https://aws.amazon.com/ecs) | [Azure Container Apps](https://azure.microsoft.com/products/container-apps/) | Amazon ECS is a container orchestration service for deploying and managing containerized applications. Azure Container Apps is a managed container platform with built-in scaling, service discovery, and traffic management. |
| [AWS Fargate](https://aws.amazon.com/fargate) | [Azure Container Instances](/azure/container-instances/container-instances-overview), [Azure Container Apps](https://azure.microsoft.com/products/container-apps/) | Fargate is a serverless compute engine that provides compute capacity for Amazon ECS tasks and Amazon EKS pods. [Azure Container Instances](/azure/container-instances/container-instances-overview) provides on-demand serverless container compute and integrates with AKS through [virtual nodes](/azure/aks/virtual-nodes). Azure Container Apps also provides serverless infrastructure management with higher-level orchestration features. |
| [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry) | Container registries store Docker formatted images and create all types of container deployments in the cloud. |
| [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks) | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) | EKS and AKS let you orchestrate Docker containerized application deployments with Kubernetes. AKS simplifies monitoring and cluster management through auto upgrades and a built-in operations console. See [Container runtime configuration](/azure/aks/concepts-clusters-workloads#container-runtime-configuration) for specifics on the hosting environment.|
| [AWS App Mesh](https://aws.amazon.com/app-mesh) (scheduled for end of support on September 30, 2026) / [Amazon ECS Service Connect](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html) / [Amazon VPC Lattice](https://aws.amazon.com/vpc/lattice/) | [Istio add-on for AKS](/azure/aks/istio-about) | A service mesh provides traffic management, observability, and security for microservices communication. The Istio add-on for AKS provides a fully supported integration of the open-source Istio service mesh. AWS App Mesh is no longer accepting new customers and is scheduled for retirement on September 30, 2026; AWS recommends ECS Service Connect, VPC Lattice, or direct Application Load Balancer (ALB) routing as replacements. |

#### Example container architectures

| Architecture | Description |
|----|----|
| [Baseline architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks/baseline-aks) | Deploy a baseline infrastructure that deploys an AKS cluster with a focus on security. |
| [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices) | Deploy a microservices architecture on Azure Kubernetes Service (AKS). |
| [CI/CD pipeline for container-based workloads](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) | Build a DevOps pipeline for a Node.js web app with Jenkins, Azure Container Registry, Azure Kubernetes Service, Azure Cosmos DB, and Grafana. |

[View all the container architectures](/azure/architecture/browse/?azure_categories=containers)

### Platform as a Service (PaaS) for web apps and APIs

PaaS services let you deploy web apps, APIs, and mobile back ends without managing the underlying infrastructure.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) | [Azure App Service](/azure/app-service/overview) | Both services provide fully managed hosting for web apps and APIs written in common runtimes (.NET, Java, Node.js, Python, PHP, Ruby). They handle capacity provisioning, load balancing, autoscaling, and health monitoring. |
| [AWS App Runner](https://aws.amazon.com/apprunner/) | [Azure App Service (Linux container)](/azure/app-service/configure-custom-container) / [Azure Container Apps](/azure/container-apps/) | AWS App Runner automatically deploys containerized web apps and APIs from a source repository or container image. Azure provides equivalent capability through App Service for Linux containers or Azure Container Apps for a container-first serverless experience. |
| [AWS Amplify Hosting](https://aws.amazon.com/amplify/hosting/) | [Azure Static Web Apps](/azure/static-web-apps/overview) | Managed hosting for modern front-end web apps with built-in CI/CD from Git, global distribution, and serverless API integration. |

### Hybrid and edge compute

Services that extend cloud infrastructure and management to on-premises, edge, and customer-owned locations.

| AWS service | Azure service | Description |
| --- | --- | --- |
| [AWS Outposts](https://aws.amazon.com/outposts/) (rack and servers) | [Azure Local](/azure/azure-local/) (formerly Azure Stack HCI) | Both deliver cloud-managed, on-premises infrastructure for low-latency workloads and data-residency requirements. Azure Local provides a validated HCI platform managed through the Azure portal. |
| [AWS Systems Manager](https://aws.amazon.com/systems-manager/) for non-AWS resources | [Azure Arc](/azure/azure-arc/) | Azure Arc extends Azure management and services (policy, monitoring, RBAC, GitOps) to servers, Kubernetes clusters, and data services running anywhere — on-premises, multicloud, or edge. |
| [AWS Wavelength](https://aws.amazon.com/wavelength/) | [Azure Private MEC](/azure/private-multi-access-edge-compute-mec/) / [Azure public MEC (Azure Edge Zones)](/azure/extended-zones/overview) | Edge compute for 5G and ultra-low-latency mobile workloads, delivered in partnership with telecom carriers. |
| [AWS Local Zones](https://aws.amazon.com/about-aws/global-infrastructure/localzones/) | [Azure Edge Zones](/azure/extended-zones/overview) | Extensions of cloud regions that place compute and storage closer to end users in metropolitan areas for latency-sensitive workloads. |

### Serverless computing

Serverless computing lets you integrate systems and run backend processes without provisioning or managing servers.

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Lambda](https://aws.amazon.com/lambda) | [Azure Functions](/azure/azure-functions/functions-overview) | Both provide serverless, event-driven code execution with pay-per-execution pricing and automatic scaling. |
| [AWS Step Functions](https://aws.amazon.com/step-functions/) | [Azure Durable Functions](/azure/azure-functions/durable/durable-functions-overview) / [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) | Durable Functions extend Azure Functions with stateful workflows written in code. Logic Apps provides a low-code visual designer for workflow orchestration across SaaS and on-premises services. |
| [AWS EventBridge](https://aws.amazon.com/eventbridge/) | [Azure Event Grid](/azure/event-grid/overview) | Managed event routing for event-driven architectures. |

#### Example serverless architectures

| Architecture | Description |
|-----|-----|
| [Cross-cloud scaling pattern](/azure-stack/user/pattern-cross-cloud-scale) | Learn how to improve cross-cloud scalability with a solution architecture that includes Azure Stack. A step-by-step flowchart details instructions for implementation. |

[View all the serverless architectures](/azure/architecture/browse/?expanded=azure&products=azure-functions)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Kobi Levi](https://www.linkedin.com/in/kobi-levi) | Cloud Solution Architect

Other contributors:

- [Juan Carlos Osorio](https://www.linkedin.com/in/juan-carlos-osorio-6252bba7/) | Cloud Solution Architect

## Next steps

- [Quickstart: Create a Linux virtual machine in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- [Create a Node.js web app in Azure](/azure/app-service/app-service-web-get-started-nodejs)
- [Getting started with Azure Functions](/azure/azure-functions/functions-create-first-azure-function)
- [Azure Kubernetes Service (AKS) architecture design](/azure/architecture/reference-architectures/containers/aks-start-here)

## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [Microservices architecture on Azure Kubernetes Service](../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Run a Linux virtual machine on Azure](../reference-architectures/n-tier/linux-vm.yml)
- [Basic web application](../web-apps/app-service/architectures/basic-web-app.yml)
- [Baseline App Service web application with zone redundancy](../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Discover AWS instances](/azure/migrate/tutorial-discover-aws)
- [Assess AWS instances](/azure/migrate/tutorial-assess-aws)
- [Migrate AWS VMs](/azure/migrate/tutorial-migrate-aws-virtual-machines)
- [Migrate AWS to managed disks](/azure/virtual-machines/windows/on-prem-to-azure)
- [Migrate an AWS Windows virtual machine](/azure/virtual-machines/windows/aws-to-azure)
