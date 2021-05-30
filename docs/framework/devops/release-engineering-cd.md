---
title: Release Engineering Continuous deployment
description: Release Engineering Continuous deployment
author: neilpeterson
ms.date: 09/28/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Deployment considerations for DevOps

As you provision and update Azure resources, application code, and configuration settings, a repeatable and predictable process will help you avoid errors and downtime. We recommend automated processes for deployment that you can run on demand and rerun if something fails. After your deployment processes are running smoothly, process documentation can keep them that way.

## Automation

To activate resources on demand, deploy solutions rapidly, minimize human error, and produce consistent and repeatable results, be sure to automate deployments and updates.

### Automate as many processes as possible

The most reliable deployment processes are automated and *idempotent* &mdash; that is, repeatable to produce the same results.

- To automate provisioning of Azure resources, you can use [Terraform](/azure/virtual-machines/windows/infrastructure-automation#terraform),
    [Ansible](/azure/virtual-machines/windows/infrastructure-automation#ansible), [Chef](/azure/virtual-machines/windows/infrastructure-automation#chef), [Puppet](/azure/virtual-machines/windows/infrastructure-automation#puppet),
    [Azure PowerShell](/powershell/azure/overview), [Azure CLI](/cli/azure), or [Azure Resource Manager templates](/azure/azure-resource-manager/template-deployment-overview).
- To configure VMs, you can use [cloud-init](/azure/virtual-machines/windows/infrastructure-automation#cloud-init) (for Linux VMs) or [Azure Automation State Configuration](/azure/automation/automation-dsc-overview) (DSC).
- To automate application deployment, you can use [Azure DevOps Services](/azure/virtual-machines/windows/infrastructure-automation#azure-devops-services), [Jenkins](/azure/virtual-machines/windows/infrastructure-automation#jenkins), or other CI/CD solutions.

As a best practice, create a repository of categorized automation scripts for quick access, documented with explanations of parameters and examples of script use. Keep this documentation in sync with your Azure deployments, and designate a primary person to manage the repository.

Automation scripts can also activate resources on demand for disaster recovery.

### Automate and test deployment and maintenance tasks

Distributed applications consist of multiple parts that must work together. Deployment should take advantage of proven mechanisms, such as scripts, that can update and validate configuration and automate the deployment process. Test all processes fully to ensure that errors don't cause additional downtime.

### Implement deployment security measures

All deployment tools must incorporate security restrictions to protect the deployed application. Define and enforce deployment policies carefully, and minimize the need for human intervention.

## Release process

One of the challenges with automating deployment is the cut-over itself, taking software from the final stage of testing to live production. You usually need to do this quickly in order to minimize downtime. The blue-green deployment approach does this by ensuring you have two production environments, as identical as possible.

## Document release process

Without detailed release process documentation, an operator might deploy a bad update or might improperly configure settings for your application. Clearly define and document your release process, and ensure that it's available to the entire operations team.

## Stage your workloads

Deployment to various stages and running tests/validations at each stage before moving on to the next ensures friction free production deployment.

With good use of staging and production environments, you can push updates to the production environment in a highly controlled way and minimize disruption from unanticipated deployment issues.

- [*Blue-green deployment*](https://martinfowler.com/bliki/BlueGreenDeployment.html) involves deploying an update into a production environment that's separate from the live application. After you validate the deployment, switch the traffic routing to the updated version. One way to do this is to use the [staging slots](/azure/app-service/web-sites-staged-publishing) available in Azure App Service to stage a deployment before moving it to production.
- [*Canary releases*](https://martinfowler.com/bliki/CanaryRelease.html) are similar to blue-green deployments. Instead of switching all traffic to the updated application, you route only a small portion of the traffic to the new deployment. If there's a problem, revert to the old deployment. If not, gradually route more traffic to the new version. If you're using Azure App Service, you can use the Testing in production feature to manage a canary release.

## Test environments

If development and test environments don't match the production environment, it is hard to test and diagnose problems. Therefore, keep development and test environments as close to the production environment as possible. Make sure that test data is consistent with the data used in production, even if it's sample data and not real production data (for privacy or compliance reasons). Plan to generate and anonymize sample test data.

## Logging and auditing

To capture as much version-specific information as possible, implement a robust logging strategy. If you use staged deployment techniques, more than one version of your application will be running in production. If a problem occurs, determine which version is causing it.

## High availability considerations

An application that depends on a single instance of a service creates a single point of failure. To improve resiliency and scalability, provision multiple instances.

- For [Azure App Service](/azure/app-service/app-service-value-prop-what-is/), select an [App Service plan](/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview/) that offers multiple instances.
- For [Azure Cloud Services](/azure/cloud-services/cloud-services-choose-me), configure each of your roles to use [multiple instances](/azure/cloud-services/cloud-services-choose-me/#scaling-and-management).
- For [Azure Virtual Machines](/azure/virtual-machines/windows/), ensure that your architecture includes more than one VM and that each VM is included in an [availability set](/azure/virtual-machines/windows/manage-availability).

### Consider deploying across multiple regions

We recommend deploying all but the least critical applications and application services across multiple regions. If your application is deployed to a single region, in the rare event that the entire region becomes unavailable, the application will also be unavailable. If you choose to deploy to a single region, consider preparing to redeploy to a secondary region as a response to an unexpected failure.

### Redeploy to a secondary region

If you run applications and databases in a single, primary region with no replication, your recovery strategy might be to redeploy to another region. This solution is affordable but most appropriate for non-critical applications that can tolerate longer recovery times. If you choose this strategy, automate the redeployment process as much as possible and include redeployment scenarios in your disaster response testing.

To automate your redeployment process, consider using [Azure Site Recovery](/azure/site-recovery/).

## Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Rollback ](./release-engineering-rollback.md)