---
title: Organizational Maturity - Adopt
description: Describes the baseline level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Foundational

Adopting Azure is the first stage of organizational maturity for an enterprise. By the end of the this stage, people in your organization will be able to deploy simple workloads to Azure.

The following list of documents is progressive. If you have already read or are familiar with the subject matter in a document, move on to the next in the list. 

1. Understanding Azure internals:
    - **Explainer:** [how does Azure work?](azure-explainer.md)
2. Understanding enterprise digital identity in Azure:
    - **Explainer:** [what is an Azure Active Directory Tenant?](tenant-explainer.md)
    - **How to:** [add new users to Azure Active Directory](/azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **Guidance:** [Azure AD tenant design guidance](tenant.md)
3. Understanding subscriptions in Azure:
    - **Explainer:** [what is a subscription?](subscription-explainer.md)
    - **How to:** [create an Azure subscription](subscription-howto.md)
    - **Guidance:** [Azure subscription design guidance](subscription.md)
4. Understanding resource management in Azure: 
    - **Explainer:** [what is Azure Resource Manager?](resource-manager-explainer.md)
    - **Explainer:** [what is an Azure resource group?](resource-group-explainer.md)
    - **Explainer:** [understanding resource access in Azure](/azure/active-directory/active-directory-understanding-resource-access?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **How to:** [create an Azure resource group with the portal](/azure/azure-resource-manager/resource-group-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - **Guidance:** [resource group design guidance](resource-group.md)
    - **Guidance:** [resource naming conventions](/azure/architecture/best-practices/naming-conventions?toc=/azure/architecture/cloud-adoption-guide/toc.json)
5. Basic Azure architecture:
    - PaaS: Introduction to Platform as a Service:
        - **How to:** [deploy a basic web application to Azure](/azure/app-service)
        - **Guidance:** best practices for deploying a [basic web application](/azure/architecture/reference-architectures/app-service-web-app/basic-web-app?toc=/azure/architecture/cloud-adoption-guide/toc.json) to Azure
    - IaaS: Introduction to Virtual Networking
        - **Explainer:** [Azure virtual network](/azure/virtual-network/virtual-networks-overview?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **How to:** [deploy a Virtual Network to Azure using the portal](/azure/virtual-network/virtual-networks-create-vnet-arm-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
    - IasS: Deploy a single virtual machine(VM) workload (Windows and Linux):
        - **How to:** [deploy a Windows VM to Azure with the portal](/azure/virtual-machines/windows/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **Guidance:** [best practices for running a Windows VM on Azure](/azure/architecture/reference-architectures/virtual-machines-windows/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **How to:** [deploy a Linux VM to Azure with the portal](/azure/virtual-machines/linux/quick-create-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json)
        - **Guidance:** [best practices for running a Linux VM on Azure](/azure/architecture/reference-architectures/virtual-machines-linux/single-vm?toc=/azure/architecture/cloud-adoption-guide/toc.json)
