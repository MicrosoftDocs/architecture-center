---
title: Compute
description: Get cost estimates for compute hosting models such as IaaS, PaaS, or FaaS. Predict cost estimates using the Pricing Calculator in Azure.
author: v-aangie
ms.date: 08/26/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-functions
ms.custom:
  - article
---

# Compute cost estimates

*Compute* refers to the hosting model for the computing resources that your application runs on. Whether you're hosting model is Infrastructure as a Service (IaaS), Platform as a Service (PaaS), or Function as a service (FaaS), each resource requires your evaluation to understand the tradeoffs that can be made that impact your cost. To learn more about hosting models, read [Understand the hosting models](../../guide/technology-choices/compute-decision-tree.md#understand-the-hosting-models).

- **Infrastructure-as-a-Service** (IaaS) lets you provision individual virtual machines (VMs) along with the associated networking and storage components. Then you deploy whatever software and applications you want onto those VMs. This model is the closest to a traditional on-premises environment, except that Microsoft manages the infrastructure. You still manage the individual VMs.

- **Platform-as-a-Service** (PaaS) provides a managed hosting environment, where you can deploy your application without needing to manage VMs or networking resources. Azure App Service is a PaaS service.

- **Functions-as-a-Service** (FaaS) goes even further in removing the need to worry about the hosting environment. In a FaaS model, you simply deploy your code and the service automatically runs it. Azure Functions are a FaaS service.

**What are the cost implications to consider for choosing a hosting model?**
***

If your application can be broken down into short pieces of code, a FaaS hosting model might be the best choice. You're charged only for the time it takes to execute your code. For example, [Azure Functions](/azure/azure-functions/functions-overview) is a FaaS service that processes events with serverless code. Azure Functions allows you to run short pieces of code (called functions) without worrying about application infrastructure. Use one of the three Azure Functions pricing plans to fit your need. To learn more about the pricing plans, see [How much does Functions cost?](/azure/azure-functions/functions-overview#pricing)

If you want to deploy a larger or more complex application, PaaS may be the better choice. With PaaS, your application is always running, as opposed to FaaS, where your code is executed only when needed. Since more resources are used with PaaS, the price increases.

If you are migrating your infrastructure from on-premises to Azure, IaaS will greatly reduce and optimize infrastructure costs and salaries for IT staff who are no longer needed to manage the infrastructure. Since IaaS uses more resources than PaaS and FaaS, your cost could be highest.

**What are the main cost drivers for Azure services?**
***

You will be charged differently for each service depending on your region, licensing plan (e.g., [Azure Hybrid Benefit for Windows Server](/azure/virtual-machines/windows/hybrid-use-benefit-licensing)), number and type of instances you need, operating system, lifespan, and other parameters required by the service. Assess the need for each compute service by using the flowchart in [Choose a candidate service](../../guide/technology-choices/compute-decision-tree.md#understand-the-basic-features). Consider the tradeoffs that will impact your cost by creating different estimates using the Pricing Calculator. If your application consists of multiple workloads, we recommend that you evaluate each workload separately. See [Consider limits and costs](../../guide/technology-choices/compute-decision-tree.md#consider-limits-and-cost) to perform a more detailed evaluation on service limits, cost, SLAs, and regional availability.

**Are there payment options for Virtual Machines (VMs) to help meet my budget?**
***

The best choice is driven by the business requirements of your workload. If you have higher SLA requirements, it will increase overall costs. You will likely need more VMs to ensure uptime and connectivity. Other factors that will impact cost are region, operating system, and the number of instances you choose. Your cost also depends on the workload life span. See [Virtual machines](./optimize-vm.md) and [Use Spot VMs in Azure](/azure/virtual-machines/windows/spot-vms) for more details.

- **Pay as you go** lets you pay for compute capacity by the second, with no long-term commitment or upfront payments. This option allows you to increase or decrease compute capacity on demand. It is appropriate for applications with short-term, spiky, or unpredictable workloads that cannot be interrupted. You can also start or stop usage at any time, resulting in paying only for what you use.

- **Reserved Virtual Machine Instances** lets you purchase a VM for one or three years in a specified region in advance. It is appropriate for applications with steady-state usage. You may save more money compared to pay-as-you-go pricing.

- **Spot pricing** lets you purchase unused compute capacity at major discounts. If your workload can tolerate interruptions, and its execution time is flexible, then using spot pricing for VMs can significantly reduce the cost of running your workload in Azure.

- **Dev-Test pricing** offers discounted rates on Azure to support your ongoing development and testing. Dev-Test allows you to quickly create consistent development and test environments through a scalable, on-demand infrastructure. This will allow you to spin up what you need, when you need it, and explore scenarios before going into production. To learn more about Azure Dev-Test reduced rates, see [Azure Dev/Test Pricing](https://azure.microsoft.com/pricing/dev-test/).

For details on available sizes and options for the Azure VMs you can use to run your apps and workloads, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes). For details on specific Azure VM types, see [Virtual Machine series](https://azure.microsoft.com/pricing/details/virtual-machines/series/).

**Do I pay extra to run large-scale parallel and high-performance computing (HPC) batch jobs?**
***

Use [Azure Batch](/azure/batch/batch-technical-overview) to run large-scale parallel and HPC batch jobs in Azure. You can save on VM cost because multiple apps can run on one VM. Configure your workload with either the Low-priority tier (the cheapest option) or the Standard tier (provides better CPU performance). There is no cost for the Azure Batch service. Charges accrue for the underlying resources that run your batch workloads.

## Use PaaS as an alternative to buying VMs

When you use the IaaS model, you do have final control over the VMs. It may appear to be a cheaper option at first, but when you add operational and maintenance costs, the cost increases. When you use the PaaS model, these extra costs are included in the pricing. In some cases, this means that PaaS services can be a cheaper than managing VMs on your own. For help finding areas in the architecture where it may be natural to incorporate PaaS options, see [Managed services](./design-paas.md).

**How can I cut costs with hosting my web apps in PaaS?**
***

If you host you web apps in PaaS, you'll need to choose an App Service plan to run your apps. The plan will define the set of compute resources on which your app will run. If you have more than one app, they will run using the same resources. This is where you will see the most significant cost savings, as you don't incur cost for VMs.

If your apps are event-driven with a short-lived process using a microservices architecture style, we recommend using Azure Functions. Your cost is determined by execution time and memory for a single function execution. For pricing details, see [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions/).

**Is it more cost-effective to deploy development testing (dev-test) on a PaaS or IaaS hosting model?**
***

If your dev-test is built on Azure managed services such as Azure DevOps, Azure SQL Database, Azure Cache for Redis, and Application Insights, the cheapest solution might be using the PaaS hosting model. You won't incur the cost and maintenance of hardware. If your dev-test is built on Azure managed services such as Azure DevOps, Azure DevTest Labs, VMs, and Application Insights, you need to add the cost of the VMs, which can greatly increase your cost. For details on evaluating, see [Azure Dev/Test Pricing](https://azure.microsoft.com/pricing/dev-test/).

## A special case of PaaS - Containers

**How can I get the best cost savings for a containerized workload that requires full orchestration?**
***

Your business requirements may necessitate that you store container images so that you have fast, scalable retrieval, and network-close deployment of container workloads. Although there are choices as to how you will run them, we recommend that you use AKS to set up instances with a minimum of three (3) nodes. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. There is no charge for AKS Cluster Management. Any additional costs are minimal. The containers themselves have no impact on cost. You pay only for per-second billing and custom machine sizes.

**Can I save money if my containerized workload does not need full orchestration?**
***

Your business requirements may not necessitate full orchestration. If this is the case and you are using App Service containers, we recommend that you use one of the App Service plans. Choose the appropriate plan based on your environment and workload.

There is no charge to use SNI-based SSL. Standard and Premium service plans include the right to use one IP SSL at no additional charge. Free and shared service plans do not support SSL. You can purchase the right to use additional SSL connections for a fee. In all cases the SSL certificate itself must be purchased separately. To learn more about each plan, see [App services plans](https://azure.microsoft.com/pricing/details/app-service/windows/).

**Where's the savings if my workload is event driven with a short-lived process?**
***

In this example, Service Fabric may be a better choice than AKS. The biggest difference between the two is that AKS works only with Docker applications using Kubernetes. Service Fabric works with microservices and supports many different runtime strategies. Service Fabric can deploy Docker and Windows Server containers. Like AKS, Service Fabric is built for the microservice and event-driven architectures. AKS is strictly a service orchestrator and handles deployments, whereas Service Fabric also offers a development framework that allows building stateful/stateless applications.

## Predict cost estimates using the Pricing Calculator

Use the Pricing Calculator to create your total cost estimate. After you run your initial scenario, you may find that your plan is beyond the scope of your budget. You can adjust the overall cost and create various cost scenarios to make sure your needs are met before you commit to purchasing.

> [!NOTE]
> The costs in this example are based on the current price and are subject to change. The calculation is for information purposes only. It shows the Collapsed view of the cost in this estimate.

![Azure Pricing Calculator - Collapsed view](../_images/pricing-calc-collapsed.png)

> [!TIP]
> You can start building your cost estimate at any time and re-visit it later. The changes will be saved until you modify or delete your estimate.

## Next steps

- [Provisioning cloud resources to optimize cost](./provision-checklist.md)
- [Virtual Machines documentation](/azure/virtual-machines/)
- [VM payment options](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#a-series)
- [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
