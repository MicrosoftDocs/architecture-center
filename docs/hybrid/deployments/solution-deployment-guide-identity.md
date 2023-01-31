---
title: Configure hybrid cloud identity for Azure and Azure Stack Hub apps
description: Learn how to configure hybrid cloud identity for Azure and Azure Stack Hub apps.
author: ronmiab
ms.author: robess
categories: azure
ms.service: azure-stack
ms.subservice: azure-stack-hub
ms.topic: conceptual
ms.date: 11/05/2019
ms.lastreviewed: 11/05/2019
azureCategories:
  - web
products:
  - azure
  - azure-stack-hub
# Intent: As an Azure Stack Hub operator, I want to configure hybrid cloud identity for Azure and Azure Stack Hub apps so my hybrid apps have a hybrid identity architecture.
# Keyword: hybrid cloud identity azure stack hub
---

# Configure hybrid cloud identity for Azure and Azure Stack Hub apps

Learn how to configure a hybrid cloud identity for your Azure and Azure Stack Hub apps.

You have two options for granting access to your apps in both global Azure and Azure Stack Hub.

 * When Azure Stack Hub has a continuous connection to the internet, you can use Azure Active Directory (Azure AD).
 * When Azure Stack Hub is disconnected from the internet, you can use Azure Directory Federated Services (AD FS).

You use service principals to grant access to your Azure Stack Hub apps for deployment or configuration using the Azure Resource Manager in Azure Stack Hub.

In this solution, you'll build a sample environment to:

> [!div class="checklist"]
> - Establish a hybrid identity in global Azure and Azure Stack Hub
> - Retrieve a token to access the Azure Stack Hub API.

You must have Azure Stack Hub operator permissions for the steps in this solution.

> [!Tip]
> ![Hybrid pillars diagram](media/solution-deployment-guide-cross-cloud-scaling/hybrid-pillars.png)
> Microsoft Azure Stack Hub is an extension of Azure. Azure Stack Hub brings the agility and innovation of cloud computing to your on-premises environment, enabling the only hybrid cloud that lets you build and deploy hybrid apps anywhere.
>
> The article [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations) reviews pillars of software quality (placement, scalability, availability, resiliency, manageability, and security) for designing, deploying, and operating hybrid apps. The design considerations assist in optimizing hybrid app design, minimizing challenges in production environments.

## Create a service principal for Azure AD in the portal

If you deployed Azure Stack Hub using Azure AD as the identity store, you can create service principals just like you do for Azure. [Use an app identity to access resources](/azure-stack/operator/azure-stack-create-service-principals#manage-an-azure-ad-app-identity) shows you how to perform the steps through the portal. Be sure you have the [required Azure AD permissions](/azure/azure-resource-manager/resource-group-create-service-principal-portal#required-permissions) before beginning.

## Create a service principal for AD FS using PowerShell

If you deployed Azure Stack Hub with AD FS, you can use PowerShell to create a service principal, assign a role for access, and sign in from PowerShell using that identity. [Use an app identity to access resources](/azure-stack/operator/azure-stack-create-service-principals#manage-an-ad-fs-app-identity) shows you how to perform the required steps using PowerShell.

## Using the Azure Stack Hub API

The [Azure Stack Hub API](/azure-stack/user/azure-stack-rest-api-use)  solution walks you through the process of retrieving a token to access the Azure Stack Hub API.

## Connect to Azure Stack Hub using PowerShell

The quickstart [to get up and running with PowerShell in Azure Stack Hub](/azure-stack/operator/azure-stack-powershell-install) walks you through the steps needed to install Azure PowerShell and connect to your Azure Stack Hub installation.

### Prerequisites

You need an Azure Stack Hub installation connected to Azure AD with a subscription you can access. If you don't have an Azure Stack Hub installation, you can use these instructions to set up an [Azure Stack Development Kit (ASDK)](/azure-stack/asdk/asdk-install).

#### Connect to Azure Stack Hub using code

To connect to Azure Stack Hub using code, use the Azure Resource Manager endpoints API to get the authentication and graph endpoints for your Azure Stack Hub installation. Then authenticate using REST requests. You can find a sample client application on
[GitHub](https://github.com/shriramnat/HybridARMApplication).

> [!Note]
> Unless the Azure SDK for your language of choice supports Azure API Profiles, the SDK may not work with Azure Stack Hub. To learn more about Azure API Profiles, see the [manage API version profiles](/azure-stack/user/azure-stack-version-profiles) article.

## Next steps

- To learn more about how identity is handled in Azure Stack Hub, see [Identity architecture for Azure Stack Hub](/azure-stack/operator/azure-stack-identity-architecture).
- To learn more about Azure Cloud Patterns, see [Cloud Design Patterns](../../patterns/index.md).
