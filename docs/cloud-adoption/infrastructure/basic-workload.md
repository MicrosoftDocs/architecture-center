---
title: "Enterprise cloud adoption: deploy a basic workload" 
description: Describes how to deploy a basic workload to Azure
author: petertaylor9999
ms.date: 09/10/2018
---

# Enterprise Cloud Adoption: Deploy a basic workload

The term **workload** is typically understood to define an arbitrary unit of functionality such as an application or service. We think about a workload in terms of the code artifacts that are deployed to a server, but also in terms of any other services that are necessary. This is a useful definition for an on-premises application or service but in the cloud we need to expand on it.

In the cloud, a workload not only encompasses all the artifacts but also includes the cloud resources as well. We include cloud resources as part of our definition because of a concept known as infrastructure-as-code. As you learned in the [how does Azure work?](../getting-started/what-is-azure.md), resources in Azure are deployed by an orchestrator service. The orchestrator service exposes this functionality through a web API, and this web API can be called using several tools such as Powershell, the Azure command line interface (CLI), and the Azure portal. This means that we can specify our resources in a machine-readable file that can be stored along with the code artifacts associated with our application.

This enables us to define a workload in terms of code artifacts and the necessary cloud resources, and this further enables us to isolate our workloads. Workloads may be isolated by the way resources are organized, by network topology, or by other attributes. The goal of workload isolation is to associate a workload's specific resources to a team so the team can independently manage all aspects of those resources. This enables multiple teams to share resource management services in Azure while preventing the unintentional deletion or modification of each other's resources.

This isolation also enables another concept known as DevOps. DevOps includes the software development practices that include both software development and IT operations above, but adds the use of automation as much as possible. One of the principles of DevOps is known as continuous integration and continuous delivery (CI/CD). Continuous integration refers to the automated build processes that are run each time a developer commits a code change, and continuous delivery refers to the automated processes that deploy this code to various environments such as a development environment for testing or a production environment for final deployment.

## Basic workload

A **basic workload** is typically defined as a single web application, or a virtual network (VNet) with virtual machine (VM). 

> [!NOTE]
> This guide does not cover application development. For more information about developing applications on Azure, see the [Azure Application Architecture Guide](/azure/architecture/guide/).

Regardless of whether the workload is a web application or a VM, each of these deployments requires a **resource group**. A user with permission to create a resource group must do that before following the steps below.

## Basic web application (PaaS)

For a basic web application, select one of the 5-minute quickstarts from the [web apps documentation](/azure/app-service?toc=/azure/architecture/cloud-adoption-guide/toc.json) and follow the steps. 

> [!NOTE]
> Some of the quickstarts will deploy a resource group by default. In this case, it's not necessary to create a resource group explicitly. Otherwise, deploy the web application to the resource group created above.

Once your simple workload has been deployed, you can learn more about the proven practices for deploying a [basic web application](/azure/architecture/reference-architectures/app-service-web-app/basic-web-app?toc=/azure/architecture/cloud-adoption-guide/toc.json) to Azure.

## Single Windows or Linux VM (IaaS)

For a simple workload that runs on a virtual machine, the first step is to deploy a virtual network. All IaaS resources in Azure such as virtual machines, load balancers, and gateways require a virtual network. Learn about [Azure virtual networks](/azure/virtual-network/virtual-networks-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json), and then follow the steps to [deploy a Virtual Network to Azure using the portal](/azure/virtual-network/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json). When you specify the settings for the virtual network in the Azure portal, specify the name of the resource group created above.

The next step is to decide whether to deploy a single Windows or Linux VM. For a Windows VM, follow the steps to [deploy a Windows VM to Azure with the portal](/azure/virtual-machines/windows/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json). Again, when you specify the settings for the virtual machine in the Azure portal, specify the name of the resource group created above.

Once you've followed the steps and deployed the VM, you can learn about [proven practices for running a Windows VM on Azure](/azure/architecture/reference-architectures/virtual-machines-windows/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json). For a Linux VM, follow the steps to [deploy a Linux VM to Azure with the portal](/azure/virtual-machines/linux/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json). You can also learn more about [proven practices for running a Linux VM on Azure](/azure/architecture/reference-architectures/virtual-machines-linux/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json).
