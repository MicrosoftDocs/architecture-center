---
title: "Adopting Azure: Foundational" 
description: Describes the baseline level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Foundational

Adopting Azure is the first stage of organizational maturity for an enterprise. By the end of this stage, people in your organization can deploy simple workloads to Azure.

The list below includes the tasks for completing the foundational adoption stage. The list is progressive so complete each task in order. If you have previously completed the task, move on the next task in the list. 

1. Understand Azure internals:
    - **Explainer:** [how does Azure work?](azure-explainer.md)
2. Understand enterprise digital identity in Azure:
    - **Explainer:** [what is an Azure Active Directory Tenant?](tenant-explainer.md)
    - **How to:** [get an Azure Active Directory Tenant](/azure/active-directory/develop/active-directory-howto-tenant?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **Guidance:** [Azure AD tenant design guidance](tenant.md)
    - **How to:** [add new users to Azure Active Directory](/azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json)    
3. Understand subscriptions in Azure:
    - **Explainer:** [what is an Azure subscription?](subscription-explainer.md)
    - **Guidance:** [Azure subscription design](subscription.md)
4. Understand resource management in Azure: 
    - **Explainer:** [what is Azure Resource Manager?](resource-manager-explainer.md)
    - **Explainer:** [what is an Azure resource group?](resource-group-explainer.md)
    - **Explainer:** [understanding resource access in Azure](/azure/active-directory/active-directory-understanding-resource-access?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **How to:** [create an Azure resource group using the Azure portal](/azure/azure-resource-manager/resource-group-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **Guidance:** [Azure resource group design guidance](resource-group.md)
    - **Guidance:** [naming conventions for Azure resources](/azure/architecture/best-practices/naming-conventions?toc=/azure/architecture/cloud-adoption-guide/toc.json)
5. Deploy a basic Azure architecture:
    - Learn about the different types of Azure compute options such as Infrastructure-as-a-Service (IaaS) and Platform-as-a-Service (PaaS) in the [overview of Azure compute options](/azure/architecture/guide/technology-choices/compute-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json).
    - Now that you understand the different types of Azure compute options, pick either a PaaS web application or IaaS virtual machine as your first resource in Azure:
    - PaaS: Introduction to Platform as a Service:
        - **How to:** [deploy a basic web application to Azure](/azure/app-service/app-service-web-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **Guidance:** proven practices for deploying a [basic web application](/azure/architecture/reference-architectures/app-service-web-app/basic-web-app?toc=/azure/architecture/cloud-adoption-guide/toc.json) to Azure
    - IaaS: Introduction to Virtual Networking:
        - **Explainer:** [Azure virtual network](/azure/virtual-network/virtual-networks-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **How to:** [deploy a Virtual Network to Azure using the portal](/azure/virtual-network/virtual-networks-create-vnet-arm-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - IasS: Deploy a single virtual machine(VM) workload (Windows and Linux):
        - **How to:** [deploy a Windows VM to Azure with the portal](/azure/virtual-network/virtual-networks-create-vnet-arm-pportal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **Guidance:** [proven practices for running a Windows VM on Azure](/azure/architecture/reference-architectures/virtual-machines-windows/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **How to:** [deploy a Linux VM to Azure with the portal](/azure/virtual-machines/linux/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **Guidance:** [proven practices for running a Linux VM on Azure](/azure/architecture/reference-architectures/virtual-machines-linux/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json)
