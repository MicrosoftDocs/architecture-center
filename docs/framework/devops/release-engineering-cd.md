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

## Stage your workloads

Deployment to various stages and running tests/validations at each stage before moving on to the next ensures friction free production deployment.

With good use of staging and production environments, you can push updates to the production environment in a highly controlled way and minimize disruption from unanticipated deployment issues.

- [*Blue-green deployment*](https://martinfowler.com/bliki/BlueGreenDeployment.html) involves deploying an update into a production environment that's separate from the live application. After you validate the deployment, switch the traffic routing to the updated version. One way to do this is to use the [staging slots](/azure/app-service/web-sites-staged-publishing) available in Azure App Service to stage a deployment before moving it to production.
- [*Canary releases*](https://martinfowler.com/bliki/CanaryRelease.html) are similar to blue-green deployments. Instead of switching all traffic to the updated application, you route only a small portion of the traffic to the new deployment. If there's a problem, revert to the old deployment. If not, gradually route more traffic to the new version. If you're using Azure App Service, you can use the Testing in production feature to manage a canary release.

## Logging and auditing

To capture as much version-specific information as possible, implement a robust logging strategy. If you use staged deployment techniques, more than one version of your application will be running in production. If a problem occurs, determine which version is causing it.

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Testing](./release-engineering-testing.md)