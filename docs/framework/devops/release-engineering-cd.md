---
title: Release Engineering Continuous deployment
description: Release Engineering Continuous deployment
author: neilpeterson
ms.date: 09/28/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Release Engineering: Continuous deployment

## Continuous delivery pipeline

## Environments

## Release strategy

### Blue-green deployment

Blue-green deployment involves deploying an update into a production environment that's separate from the live application. After you validate the deployment, switch the traffic routing to the updated version. One way to do this is to use the staging slots available in Azure App Service to stage a deployment before moving it to production.

### Canary releases

Canary releases are similar to blue-green deployments. Instead of switching all traffic to the updated application, you route only a small portion of the traffic to the new deployment. If there's a problem, revert to the old deployment. If not, gradually route more traffic to the new version. If you're using Azure App Service, you can use the Testing in production feature to manage a canary release.

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Rollback and Rollforward ](./release-engineering-rollback.md)