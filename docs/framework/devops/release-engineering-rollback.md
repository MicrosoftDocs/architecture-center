---
title: Release Engineering Rollback and Rollforward 
description: Release Engineering Rollback and Rollforward 
author: neilpeterson
ms.date: 09/28/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Release Engineering: Rollback

In some cases, a new software deployment can harm or degrade the functionality of a software system. When building your solutions, it is essential to anticipate deployment issues, architect solutions that provide mechanisms for fixing problematic deployments. Rolling back a deployment involves reverting the deployment to a known good state. Rollback can be accomplished in many different ways. Several Azure services support native mechanisms for rolling back to a previous state. Several of these services are detailed in this article.

## Web Apps

## Azure Kubernetes Service

## Azure Resource Manager (ARM) deployments

When deploying Azure infrastructure and solutions with Azure Resource Manager (ARM) templates a deployment record is created. When creating a new deployment, you can provide a previously known good deployment so that if the current deployment fails, the previous know good deployment is redeployed. There are several considerations and caveats when using this functionality. See the documentation linked below for these details.

![Image showing Azure Resource Manager Deployments in the Azure portal.](../_images/devops/arm-deployments.png)

For more information, see [Rollback on an error to successful deployment](https://docs.microsoft.com/azure/azure-resource-manager/templates/rollback-on-error)

## Logic apps

When making changes to an Azure logic application, a new version of the application is created. Azure maintains a history of versions and can revert or promote any previous version. To do so, in the Azure portal, select your logic app > **Versions**. Previous versions can be selected on the versions pane, and the application can be inspected both in the code view and the visual designer view. Select the version you would like to revert to, and click the **Promote** option and then **Save**.

![Image showing Azure logic application version history.](../_images/devops/revert-logic-app.png)

For more information, see [Manage logic apps in the Azure portal](https://docs.microsoft.com/azure/logic-apps/manage-logic-apps-with-azure-portal)

