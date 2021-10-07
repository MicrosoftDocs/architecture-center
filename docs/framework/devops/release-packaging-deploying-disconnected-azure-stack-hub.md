---
title: Release packaging for deploying to disconnected Azure Stack Hub with Universal Packages
titleSuffix: Cloud Design Patterns
description: Use these management and monitoring patterns to support cloud applications, which offer special challenges because the applications run in a remote datacenter.
author: brice.miller
ms.author: EdPriceMSFT
ms.date: 10/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-stack-hub
  - azure-resource-manager
  - azure-pipelines
---


# Release packaging for deploying to disconnected Azure Stack Hub with Universal Packages

This article discusses creating a release package using Azure DevOps Pipelines,
Azure Artifacts, and [Universal
Packages](/azure/devops/pipelines/artifacts/universal-packages?view=azure-devops&tabs=yaml)
to create and configure resources on a disconnected Azure Stack Hub. Key
considerations are also discussed to help you design and plan for deploying to a
disconnected Stack Hub.

Microsoft Azure Stack Hub is an important component of this article. Azure Stack
Hub is an extension of Azure that brings the agility and innovation of cloud
computing to your on-premises environment, enabling the only hybrid/disconnected
cloud that allows you to build and deploy hybrid apps anywhere.

## Overview

Continuous integration (CI) and continuous delivery (CD) are important concepts
to consider when building and deploying any application. You can integrate Azure
Pipelines with version control systems such as Git and Team Foundation Version
Control (TFVC) to support CI and CD processes.

However, automated CD processes are only viable with a disconnected Azure Stack
Hub when it’s used as a private cloud on your corporate intranet. In most other
cases, developers will not have direct access to a disconnected Azure Stack Hub.
Regardless, CI pipelines should be leveraged to continually test your
application prior to packaging for deployment.

Azure Artifacts enables developers to consume and publish different types of
packages to Azure Artifacts feeds, and these feeds can be used in conjunction
with Azure Pipelines to deploy packages, publish build artifacts, or integrate
files between your pipeline stages to build, test, or deploy your application.

One type of artifact that is particularly useful when deploying to a
disconnected Azure Stack Hub is called Universal Packages. Universal Packages
allows you to pack any number of files of any type and share them with your
team. Each package will be uniquely identified with a name and a version number.
Packages can be published to and consumed from Azure Artifacts feeds using the
Azure CLI or Azure Pipelines.

### Release package considerations

When determining how to build your release package, there are a few concepts to
consider in addition to those required to deploy your application:

- Infrastructure as Code (IaC)

- Configuring Azure services on Azure Stack Hub

- Use of third-party services and applications

### IaC and configuring Azure services

You can build An Azure pipeline that will deploy and configure the necessary
Azure services prior to deploying an application. Azure Pipelines can run on a
disconnected Azure Stack Hub when you install Azure DevOps and make it
accessible to your Azure Stack Hub (for instance, when you want to use Azure
Stack Hub purely as a private cloud solution that's deployed to your corporate
intranet). This may not always be an option with a disconnected Azure Stack Hub.
However, IaC concepts can still be incorporated into your release package via
shell scripting utilizing Azure CLI. Typically, an Azure Stack Hub operator will
run scripts via a virtual machine (VM) that acts as a jump box on the Azure
Stack Hub environment.

Ideally, a main orchestration script should be used to handle
authorization/authentication and orchestration of the scripts needed to create
and configure each service.

### Use of third-party services and applications

Prior to deciding to use third-party or open-source services and applications,
you need to consider whether those services can be deployed and run on a
disconnected environment. Package managers, such as apt or NuGet, cannot be used
to install applications without internet access. You also first need to download
the package and all the dependencies to provide as part of your release package
(for example, [apt](https://manpages.debian.org/stretch/apt/apt.8.en.html) and
[dpkg](https://man7.org/linux/man-pages/man1/dpkg.1.html) can be used to install
Debian packages that are provided on the VM). A lot of commonly used
applications (for instance, Docker) provide instructions and links for manual
installation. These third-party installation files can be stored within your
version control repository so that you can incorporate them into your release
package.

For example, when using a third-party service on Kubernetes like [Kubernetes
Event-driven Autoscaling (KEDA)](https://keda.sh/), you need to download and
save any of the container images to your version control repository as well as
update the Kubernetes manifests to reference the new location for your container
images on Azure Stack Hub, in addition to installing KEDA on your Kubernetes
cluster.

If you plan to utilize [Azure CLI](/cli/azure/)
in shell scripts to create and configure services on Azure Stack Hub, be sure to
include the necessary artifacts to install Azure CLI (installation files,
installation scripts) prior to running those scripts.

### Example release package structure

An example release package directory structure is shown below.

![Screenshot of release package directory structure](../_images/release-packaging-deploying-disconnected-azure-stack-hub-01.png)

In this example, an [Azure Resource Manager (ARM)
template](/azure/azure-resource-manager/templates/overview)
is provided to create the jump box, which is used to run the main.sh script that
will deploy the application. The files directory includes the third-party
installation files (for example, Debian or MSI packages, binaries, and so on) as
well as Docker images and the Kubernetes manifests for installing KEDA on a
Kubernetes cluster. The scripts directory includes separate subdirectories to
separate the scripts based on their usage:

- *azure-services* contains scripts for creating and configuring Azure
    services on Azure Stack Hub (for instance, creating a storage account and
    necessary blob containers or storage queues).

- *deployment* contains scripts specific to the application being deployed to
    Azure Stack Hub.

- *installation* contains scripts specific to installing the third-party
    applications and references the files under files\\installation.

- *spn-scripts* contains scripts that the Azure Stack Hub operator can use to
    create a new service principal.

Additionally, relevant information regarding installation instructions and
application documentation are provided under the documentation directory.

### Publishing your release package

Once you have determined the structure for your release package, you can build
an Azure pipeline that will build your application and copy the necessary
supporting files and scripts into a Universal Package. **Keep in mind that you
will incur a cost for storing more than 2 GB worth of artifacts within Azure
DevOps**.

Once your release package is built and published, any user of your application
will be able to utilize Azure CLI to download the release package, which
contains everything needed to deploy your application. While this process isn't
fully automated, it will ensure a smoother deployment of your application to a
disconnected Azure Stack Hub.

## Next steps

Azure Architecture Center guides:

- [Configure hybrid cloud connectivity using Azure and Azure Stack
    Hub](/azure/architecture/hybrid/deployments/solution-deployment-guide-connectivity)

- [Configure hybrid cloud identity for Azure and Azure Stack Hub
    apps](/azure/architecture/hybrid/deployments/solution-deployment-guide-identity)

- [Deploy an app that scales cross-cloud using Azure and Azure Stack
    Hub](/azure/architecture/hybrid/deployments/solution-deployment-guide-cross-cloud-scaling)

Product documentation:

- [Azure Stack
    Hub](https://azure.microsoft.com/products/azure-stack/hub/#overview)

- [Azure
    Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

- [Artifacts in Azure
    Pipelines](/azure/devops/pipelines/artifacts/artifacts-overview?view=azure-devops&tabs=nuget)

Microsoft Learn learning paths:

- [Introduction to Azure
    Stack](/learn/modules/intro-to-azure-stack/)

- [Build applications with Azure
    DevOps](/learn/paths/build-applications-with-azure-devops/)

## Related resources

- [Azure Stack Hub
    Overview](/azure-stack/operator/azure-stack-overview?view=azs-2102)

- [Azure Stack Hub disconnected deployment
    considerations](/azure-stack/operator/azure-stack-disconnected-deployment?view=azs-2102)

- [Azure
    Pipelines](/azure/devops/pipelines/?view=azure-devops)

- [Artifacts in Azure
    Pipelines](/azure/devops/pipelines/artifacts/artifacts-overview?view=azure-devops&tabs=nuget)

- [Differences between global Azure, Azure Stack Hub, and Azure Stack
    HCI](/azure-stack/operator/compare-azure-azure-stack?view=azs-2102)
