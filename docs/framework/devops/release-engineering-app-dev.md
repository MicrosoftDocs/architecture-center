---
title: Release Engineering Application Development
description: Release Engineering Application Development
author: neilpeterson
ms.date: 09/28/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Release Engineering: Application Development

One of the primary goals of adopting modern release management strategies is to build solutions that allow your teams to turn ideas into production delivered software with as little friction as possible. Throughout this section of the Well Architected Framework, methods, and tools for quickly and reliably delivering software are examined. You will learn about things like continuous deployment software, integration strategies, and deployment environments. Samples are provided to help you quickly get hands on with this technology.

However, release engineering does not start with fancy deployment software, multiple deployment environments, or Kubernetes clusters. Before examining how we can quickly and reliably release software, we need to look at how software is developed. Not only has the introduction of cloud computing had a significant impact on how software, if delivered and run, but it's also had a huge 'downstream' impact on how software is developed. For example, the introduction of container technology has changed how we can host, scale, and deprecate software. That said, containers have also impacted things like dependency management, host environment, and tooling as we develop software.

This article details many considerations and practices that you may want to consider when building strategies for developing for the cloud. Topics include:

- Development environments, or where you write your code.
- Test-driven development, which is a strategy for developing code against a series of code tests.
- Source control and branching strategies, how you manage, collaborate on and eventually deploy your code.
- Cloud cadence, which is just the result or benefit of adopting these development principles.

## Development environments

When developing software for the cloud, or any environment for that matter, care needs to be taken to ensure that the development environment is set up for success. When setting up a development environment, you may consider questions like the following:

- How do I ensure that all dependencies are in place?
- How can I best configure my development environment to emulate a production environment?
- How can I collaborate with my peers during the development process?

The following sections briefly detail technology that aids during the local or what is often refered to as 'inner-loop' development process.

### Docker Desktop

Docker Desktop is an application that provides a Docker environment on your development system. Docker Desktop includes not only the Docker runtime but application development tools and local Kubernetes environment. Using Docker Desktop, you can develop in any language, create and test container images, and when ready, push application ready container images to a container registry for production use.

**Learn more**

- [Docker Desktop](https://docs.microsoft.com/windows/wsl/)

### Windows Subsystem for Linux

Many applications and solutions are built on Linux. Windows Subsystem for Linux provides a Linux environment on your Windows machines, including many command-line tools, utilities, and Linux applications. Multiple GNU/Linux distributions are available and can be found in the Microsoft Store.

**Learn more**

- [Documentation: Windows Subsystem for Linux Documentation](https://www.docker.com/products/docker-desktop)

### Bridge to Kubernetes

Bridge to Kubernetes allows you to run and debug code on your development system while connected to a Kubernetes cluster. This configuration can be helpful when working on microservice type architectures. Using Bridge, you can work locally on one service, which has a dependency on other services. Rather than needing to run all dependant services on your development system or deploy your in-development code to the cluster, Bridge manages the communication between your development system and running services in your Kubernetes cluster. Essentially, the code running on your development system behaves as if it is running in the Kubernetes cluster.

Some features of Bridge:

- Works with Azure Kubernetes Service (AKS) and non-AKS clusters (in preview).
- Redirects traffic between your Kubernetes cluster and code running on your development system.
- Support for isolated traffic routing, which is important in shared clusters.
- Replicates environment variables and mounted volumes from your cluster to your development system.
- Cluster diagnostic logs are made available on your development system.

**Learn more**

- [Documentation: Use Bridge to Kubernetes with Visual Studio Code](https://www.docker.com/products/docker-desktop)
- [Documentation: Use Bridge to Kubernetes with Visual Studio](https://docs.microsoft.com/visualstudio/containers/bridge-to-kubernetes?view=vs-2019)

## Test-driven development

## Source control

## Branching strategies

## Cloud cadence

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Continuous integration](./release-engineering-ci.md)