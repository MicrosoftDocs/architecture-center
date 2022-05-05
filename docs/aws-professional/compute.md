---
title: Comparing AWS and Azure compute services
description: Compare the compute services in Azure and AWS. Explore the differences in virtual servers, containers and container orchestrators, and serverless architectures.
author: kobile70
ms.author: kobilevi
ms.date: 08/09/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
azureCategories:
  - compute
  - networking
products:
  - azure-app-service
  - azure-functions
  - azure-logic-apps
  - azure-storage
  - azure-virtual-machines

---

# Compute services on Azure and AWS

## Amazon EC2 Instances and Azure virtual machines

Although AWS instance types and Azure virtual machine sizes are categorized similarly, the RAM, CPU, and storage capabilities differ.

- [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types)

- [Sizes for virtual machines in Azure (Windows)](/azure/virtual-machines/windows/sizes)

- [Sizes for virtual machines in Azure (Linux)](/azure/virtual-machines/linux/sizes)

Similar to AWS' per second billing, Azure on-demand VMs are billed per second.

## Amazon EBS and Azure Storage for VM disks

Durable data storage for Azure VMs is provided by [data disks](/azure/virtual-machines/linux/managed-disks-overview) residing in blob storage. This is similar to how EC2 instances store disk volumes on Elastic Block Store (EBS). [Azure temporary storage](/archive/blogs/mast/understanding-the-temporary-drive-on-windows-azure-virtual-machines) also provides VMs with the same low-latency temporary read-write storage as EC2 Instance Storage (also called ephemeral storage). [Azure Files](/azure/storage/files/storage-files-introduction) provides the VMs with the same functionality as [Amazon EFS](https://aws.amazon.com/efs).

Higher performance disk I/O is supported using [Azure premium storage](/azure/virtual-machines/windows/premium-storage). This is similar to the Provisioned IOPS storage options provided by AWS.

## AWS Lambda, Azure Functions, Azure Web-Jobs, and Azure Logic Apps

[Azure Functions](https://azure.microsoft.com/services/functions) is the primary equivalent of AWS Lambda in providing serverless, on-demand code. However, AWS Lambda functionality also overlaps with other Azure services:

- [WebJobs](/azure/app-service/web-sites-create-web-jobs) allow you to create scheduled or continuously running background tasks.

## Autoscaling, Azure VM scaling, and Azure App Service Autoscale

Autoscaling in Azure is handled by two services:

- [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) allow you to deploy and manage an identical set of VMs. The number of instances can autoscale based on performance needs.

- [App Service Autoscale](/azure/app-service/web-sites-scale) provides the capability to autoscale Azure App Service solutions.

## Container Service

The [Azure Kubernetes Service](/azure/aks/intro-kubernetes) supports Docker containers managed through Kubernetes. See [Container runtime configuration](/azure/aks/cluster-configuration#container-runtime-configuration) for specifics on the hosting environment.

## Distributed Systems Platform

[Service Fabric](/azure/service-fabric/service-fabric-overview) is a platform for developing and hosting scalable [microservices-based](/azure/service-fabric/service-fabric-overview-microservices) solutions.

## Batch Processing

[Azure Batch](/azure/batch/batch-technical-overview) allows you to manage compute-intensive work across a scalable collection of virtual machines.

## Service Comparison

[!INCLUDE [Compute Services](../../includes/aws/compute.md)]

## See also

- [Create a Linux VM on Azure using the portal](/azure/virtual-machines/linux/quick-create-portal)

- [Azure Reference Architecture: Running a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml)

- [Get started with Node.js web apps in Azure App Service](/azure/app-service/app-service-web-get-started-nodejs)

- [Azure Reference Architecture: Basic web application](../reference-architectures/app-service-web-app/basic-web-app.yml)

- [Create your first Azure Function](/azure/azure-functions/functions-create-first-azure-function)
