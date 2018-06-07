---
title: "Adopting Azure: Foundational" 
description: Describes the baseline level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Foundational

For an organization that is new to the cloud, it can be difficult to decide on the right place to start their adoption journey. The goal of the foundational adoption stage is to provide a starting point. Once individuals within the organization have worked through this stage they will have all the knowlege and skills necessary to deploy a simple workload to Azure.

The audience for this stage of the guide is the following personas within your organization:

- *Finance:* owner of the financial commitment to Azure, responsible for developing policies and procedures for tracking resource consumption costs including billing and chargeback.
- *Central IT:* responsible for governing your organizatin's cloud resources including resource management and access, and workload health and monitoring.
- *Workload owners:* all development roles that are involved in deploying workloads to Azure, including developers, testers, and build engineers.

## Section 1: Understanding Azure and the concept of cloud goverance

This introductory section is intended for the *finance* and *central IT* personas. The focus of this section is acquiring a basic understanding of [how Azure works](azure-explainer.md) in preparation for learning about the [concept of cloud governance](governance-explainer.md). It may also be useful for the *workload owners* in your organization to review this content to help them understand how resource access is managed.

## Section 2: Understanding governance design

This audience for this section is the *central IT* persona. *Central IT* is responsible for [designing your organization's goverance architecture](governance-how-to.md). 

## Section 3: Deploy a basic workload architecture to Azure

The audience for this section is the *workload owner* persona. *Workload owners* define the compute and networking requirements for their workloads, select the correct resources to meet those requirements, and deploy them to Azure. 

For the foundational adoption stage, the workload owner can select either a platform-as-a-service (PaaS) basic web application or an infrastructure-as-a-service (IaaS) virtual network (VNet) and virtual machine VM. For more information about these different types of compute options in Azure, review the [overview of Azure compute options](/azure/architecture/guide/technology-choices/compute-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json).

Regardless of which compute option is selected, each deployment requires a **resource group**. Depending on the policies set by *central IT*, a *workload owner* may or may not have permission to create a resource group. If they do not, *central IT* will be responsible for creating the resource group and providing the name of it to the *workload owner*. Otherwise, the *workload owner* can create the resource group directly.

### PaaS basic web application

For a PaaS basic web application, select one of the 5-minute quickstarts from the [web apps documentation](/azure/app-service?toc=/azure/architecture/cloud-adoption-guide/toc.json) and follow the steps. Once your simple workload has been deployed, you can learn more about the proven practices for deploying a [basic web application](/azure/architecture/reference-architectures/app-service-web-app/basic-web-app?toc=/azure/architecture/cloud-adoption-guide/toc.json) to Azure.

### IaaS single Windows or Linux VM

For an IaaS simple workload, the first step is to deploy a virtual network. All IaaS resources in Azure such as virtual machines, load balancers, and gateways require a virtual network. Learn about [Azure virtual networks](/azure/virtual-network/virtual-networks-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json), and then follow the steps to [deploy a Virtual Network to Azure using the portal](/azure/virtual-network/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json).

The next step is to decide whether to deploy a single Windows or Linux VM. For a Windows VM, follow the steps to [deploy a Windows VM to Azure with the portal](/azure/virtual-machines/windows/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json). Once you've followed the steps and deployed the VM, you can learn about [proven practices for running a Windows VM on Azure](/azure/architecture/reference-architectures/virtual-machines-windows/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json). For a Linux VM, follow the steps to [deploy a Linux VM to Azure with the portal](/azure/virtual-machines/linux/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json). You can also learn more about [proven practices for running a Linux VM on Azure](/azure/architecture/reference-architectures/virtual-machines-linux/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json).

## Next steps

The next stage in cloud readiness is the **intermediate stage**. In the intermediate stage, you will learn about extending your on-premises network boundary to Azure, running multiple workloads, and the governance models for multiple teams. 
