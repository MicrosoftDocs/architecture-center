---
title: Release engineering app development
description: Understand application development in release engineering. Build systems so your teams can turn ideas into production-delivered software with minimal friction.
author: david-stanford
ms.date: 09/28/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-kubernetes-service
---

# Release Engineering: Application Development

One of the primary goals of adopting modern release management strategies is to build systems that allow your teams to turn ideas into production delivered software with as little friction as possible. Throughout this section of the Well-Architected Framework, methods and tools for quickly and reliably delivering software are examined. You will learn about things like continuous deployment software, integration strategies, and deployment environments. Samples are provided to help you quickly get hands-on with this technology.

However, release engineering does not start with fancy deployment software, multiple deployment environments, or Kubernetes clusters. Before examining how we can quickly and reliably release software, we need to first look at how software is developed. Not only has the introduction of cloud computing had a significant impact on how software is delivered and run, but it's also had a huge downstream impact on how software is developed. For example, the introduction of container technology has changed how we can host, scale, and deprecate software. That said, containers have also impacted things like dependency management, host environment, and tooling as we develop software.

This article details many practices that you may want to consider when building strategies for developing for the cloud. Topics include:

- Development environments, or where you write your code.
- Source control and branching strategies, how you manage, collaborate on, and eventually deploy your code.

## Development environments

When developing software for the cloud, or any environment, care needs to be taken to ensure that the development environment is set up for success. When setting up a development environment, you may consider questions like the following:

- How do I ensure that all dependencies are in place?
- How can I best configure my development environment to emulate a production environment?
- How do I develop code where service dependencies may exist with code already in production?

The following sections briefly detail technology that aids during the local or what is often referred to as "inner-loop" development process.

### Docker Desktop

Docker Desktop is an application that provides a Docker environment on your development system. Docker Desktop includes not only the Docker runtime but application development tools and local Kubernetes environment. Using Docker Desktop, you can develop in any language, create and test container images, and when ready, push application ready container images to a container registry for production use.

**Learn more**

[Docker Desktop](https://www.docker.com/products/docker-desktop)

### Windows Subsystem for Linux

Many applications and solutions are built on Linux. Windows Subsystem for Linux provides a Linux environment on your Windows machines, including many command-line tools, utilities, and Linux applications. Multiple GNU/Linux distributions are available and can be found in the Microsoft Store.

**Learn more**

[Documentation: Windows Subsystem for Linux Documentation](/windows/wsl/)

### Bridge to Kubernetes

Bridge to Kubernetes allows you to run and debug code on your development system while connected to a Kubernetes cluster. This configuration can be helpful when working on microservice type architectures. Using Bridge, you can work locally on one service, which has a dependency on other services. Rather than needing to run all dependant services on your development system or deploy your in-development code to the cluster, Bridge manages the communication between your development system and running services in your Kubernetes cluster. Essentially, the code running on your development system behaves as if it's running in the Kubernetes cluster.

Some features of Bridge:

- Works with Azure Kubernetes Service (AKS) and non-AKS clusters (in preview).
- Redirects traffic between your Kubernetes cluster and code running on your development system.
- Support for isolated traffic routing, which is important in shared clusters.
- Replicates environment variables and mounted volumes from your cluster to your development system.
- Cluster diagnostic logs are made available on your development system.

**Learn more**

- [Documentation: Use Bridge to Kubernetes with Visual Studio Code](https://code.visualstudio.com/docs/containers/bridge-to-kubernetes)
- [Documentation: Use Bridge to Kubernetes with Visual Studio](/visualstudio/containers/bridge-to-kubernetes?preserve-view=true&view=vs-2019)

### Other tools

The tooling ecosystem for container management is rich with options. Here are a few additional tools to consider while developing container-based applications.

[Podman](https://developers.redhat.com/articles/podman-next-generation-linux-container-tools) - an open-source tool for working with containers.

## Source control

Source control management (SCM) systems provide a way to control, collaborate, and peer review software changes. As software is merged into source control, the system helps manage code conflicts. Ultimately, source control provides a running history of the software, modification, and contributors. Whether a piece of software is open-sourced or private, using source control software has become a standardized method of managing software development. As detailed in later sections of the Well-Architected Framework, source control systems can also be enlightened with integrated testing, security, and release practices. As cloud practices are adopted and because so much of the cloud infrastructure is managed through code, version control systems are also becoming an integral part of infrastructure management.

Many source control systems are powered by Git. Git is a distributed version control system with related tools that allow you and your team to track source code changes during the software development lifecycle. Using Git, you can create a copy of the software, make changes, propose the changes, and receive peer review on your proposal. During peer review, Git makes it easy to see precisely the changes being proposed. Once the proposed changes have been approved, Git helps merge the changes into the source, including conflict resolution. If, at any point, the changes need to be reverted, Git can also manage rollback.

Let's examine a few aspects of version controlling software and infrastructure configurations.

**Version Control and code changes**

Beyond providing us with a place to store code, source control systems allow us to understand what version of the software is current and identify changes between the present and past versions. Version control solutions should also provide a method for reverting to the previous version when needed.

The following image demonstrates how Git and GitHub are used to see the proposed code changes.

:::image type="content" source="../_images/devops/git-changes.png" alt-text="Image alt text" lightbox="../_images/devops/git-changes-full.png":::

**Forking and Pull Requests**

Using source control systems, you can create your own copies of the software source called forks. With your fork in place, changes can be made to the software without the risk that the changes will impact the software's current version. Once you are happy with the changes made in your fork, you can suggest that your changes be merged into the main source control through what is known as a pull request.

**Peer Review**

As updates are made to software and infrastructure configurations, version control software allows us to propose these changes before merging them into the source. During the proposal, peers can review the changes, recommend updates, and approve the changes. Source control solutions provide an excellent platform for collaboration on changes to the software.

To learn more about using Git, visit the [DevOps Resource Center](/devops/develop/git/what-is-git).

### GitHub

GitHub is a popular source control system that uses Git. In addition to core Git functionality, GitHub includes several other features such as access control, collaboration features such as code issues, project boards, wikis, and an automation platform called GitHub actions.

**Learn more**

[GitHub](https://github.com)

### Azure Repos

Azure DevOps is a collection of services for building, collaborating on, testing, and delivering software to any environment. Azure DevOps Services include Azure Repos, which is a source control system. Using Azure Repos includes unlimited free private Git repositories. Standard Git powers Azure Repos, and you can use clients and tools of your choice for working with them.

**Learn more**

[Documentation: Azure Repos](/azure/devops/repos/?preserve-view=true&view=azure-devops)

## Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Continuous integration](./release-engineering-ci.md)
