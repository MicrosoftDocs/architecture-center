---
title: Secure deployment in Azure
description: DevOps considerations to ensure security and feature enhancements can be quickly deployed.
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-devops
categories:
  - security
subject:
  - security
---

# Secure deployment in Azure

Have teams, processes, and tools that can quickly deploy security fixes? A _DevOps_ or multidisciplinary approach is recommended. Multiple teams work together with efficient practices and tools. Essential DevOps practices include change management of the workload through continuous integration, continuous delivery (CI/CD).

Continuous integration (CI) is an automated process where code changes trigger the building and testing of the application. Continuous Delivery (CD) is an automated process to build, test, configure, and deploy the application from a build to production environment.

Those processes allow you to rapidly address the security concerns without waiting for a longer planning and testing cycle.

Building a DevOps process which includes a security discipline helps incorporate security concepts and enhancements earlier in the application development process. An organization's ability to rapidly address security and operational concerns increases through the combination of the Secure Development Lifecycle (SDL) and Operations Lifecycle related to application creation, maintenance, and updates.

Many traditional IT operating models aren't compatible with the cloud, and organizations must undergo operational and organizational transformation to deliver against enterprise migration targets. We recommend using a DevOps approach for both application and central teams.

:::image type="content" source="./images/devops-model.png" alt-text="Conceptual art comparing traditional and DevOps models.":::

## Checklist

**Have you adopted a secure DevOps approach to ensure security and feature enhancements can be quickly deployed?**
***
> [!div class="checklist"]
> - Establish a cross-functional DevOps platform team to build, manage, and maintain your workload.
> - Involve the security team in the planning and design of the DevOps process to integrate preventive and detective controls for security risks.
> - Clearly define CI/CD roles and permissions and minimize the number of people who have access to secure information or resources.
> - Configure quality gate approvals in DevOps release process.
> - Integrate scanning tools within CI/CD pipeline.
> - No infrastructure changes, provisioning or configuring, should be done manually outside of IaC.

## In this section
Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Do you clearly define CI/CD roles and permissions for this workload?**](deploy-governance.md)|Define CI/CD permissions such that only users responsible for production releases can start the process and that only developers can access the source code.|
|[**Are any resources provisioned or operationally configured with user tools such as the Azure portal or via Azure CLI?**](deploy-infrastructure.md)|Always use Infrastructure as code (IaC) to make even the smallest of changes. This approach makes it easy to track code because the provisioned infrastructure is reproducible and reversible.|
|[**Can you roll back or forward code quickly through automated pipelines?**](deploy-code.md)|Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle.|

## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to the [Azure Security Benchmark controls](/azure/security/benchmarks/overview?branch=master).

## Reference architecture
Here are some reference architectures related to building CI/CD pipelines:
- [CI/CD for microservices architectures](../../microservices/ci-cd.md)
- [CI/CD for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.md)

## Next step
We recommend monitoring activities that maintain the security posture. These activities can highlight, if the current security practices are effective or are there new requirements.

> [!div class="nextstepaction"]
> [Security monitoring](./monitor.md)

## Related link
> Go back to the main article: [Security](overview.md)

## Learn more
- [Secure DevOps Kit for Azure](https://azsk.azurewebsites.net/)
- [Agile Principles in Practice](/devops/plan/how-microsoft-plans-devops)
- [Platform automation and DevOps](/azure/cloud-adoption-framework/ready/enterprise-scale/platform-automation-and-devops)
