---
ms.custom:
  - devx-track-jenkins
  - devx-track-terraform
---
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure is a world-class cloud for hosting virtual machines running Windows or Linux. Whether you use Java, Node.js, Go, or PHP to develop your applications, you'll need a continuous integration and continuous deployment (CI/CD) pipeline to push changes to these virtual machines automatically.

## Potential use cases

Organizations utilize this solution for some of the benefits that include:

- Changes in the application start with a software push to the Git code repository instead of logging into the server via SSH.
- Simplified and reliable deployments.
- Fault tolerance.
- Resolve issues faster.
- It takes the most advantage of the cloud, hence its legitimate DevOps functions.

## Architecture

[ ![Architectural diagram that shows immutable infrastructure CI/CD using Jenkins and Terraform on Azure.](../media/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.svg)](../media/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture.vsdx) of this architecture.*

### Dataflow

1. Change application source code.
1. Commit code to GitHub.
1. Continuous Integration Trigger to Jenkins.
1. Jenkins triggers a Packer image build to create a VM and stores it as a VM image using Azure Managed Disks.
1. Jenkins triggers Terraform to provision a new Virtual Machine Scale Set using the Azure Managed Disks VM image.
1. Azure Log Analytics collects and analyzes logs.
1. Monitor application and make improvements.

### Components

* [Managed Disks](https://azure.microsoft.com/services/managed-disks): Persistent, secured disk storage for Azure virtual machines.
* [Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets): Manage and scale up to thousands of Linux and Windows virtual machines.
* Log Analytics: Collect, search, and visualize machine data from on-premises and cloud.
* [Visual Studio Code](https://azure.microsoft.com/products/visual-studio): Build and deploy multi-platform apps to get the most from Azure services.

## Deploy this scenario

* [Deploy to Azure](https://azure.microsoft.com/resources/templates/jenkins-cicd-vmss)

## Next steps

* [Use Terraform to create a Virtual Machine Scale Set from a Packer customer VM image](/azure/terraform/terraform-create-vm-scaleset-network-disks-using-packer-hcl)
* [Use Terraform to plan and create a Virtual Machine Scale Set with Managed Disk](/azure/terraform/terraform-create-vm-scaleset-network-disks-hcl)
* [Use Log Analytics to collect data from Linux computers](/azure/log-analytics/log-analytics-quick-collect-linux-computer)
* [Get the Azure Extensions Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)
