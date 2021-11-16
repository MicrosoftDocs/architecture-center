[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

*Infrastructure as a service (IaaS)* is a form of cloud computing that provides virtualized computing resources. *Development testing (DevTest)* is a software development approach that integrates testing early in the development phase. In this solution, configuring DevTest operations for an IaaS application reduces the cost and overhead of development and test environments, while facilitating faster development through automated virtual machine (VM) and VM image integration and deployment.

*DevOps* is a set of practices that combine software development and IT operations to shorten the development cycle and provide high-quality continuous deployments (CD). Using [Azure DevOps](https://azure.microsoft.com/services/devops/) with DevTest environments lends power and focus to the IaaS development process.

## Architecture

![Diagram showing the configuration of DevTest and DevOps for an IaaS application.](../media/dev-test-iaas.png)

1. Instead of manually configuring development environments, developers can use [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) images, pre-configured with the libraries, tools, and runtimes they need for their projects. Adding a developer to an [Azure DevTest Subscription](https://azure.microsoft.com/pricing/dev-test) makes the appropriate Azure Virtual Desktop image available to them from the DevTest environment.

2. Source code is available in [GitHub](https://azure.microsoft.com/products/github/) repos, which integrate seamlessly with Azure DevOps. The [Visual Studio](https://visualstudio.microsoft.com/) development environment combines GitHub source code editing with features like work item and pull request tracking.

3. [Azure Pipelines](/azure/devops/pipelines/get-started/pipelines-get-started) triggers automated continuous integration (CI) builds from GitHub repos and automatically delivers them to the DevTest environments, reaching quality assurance (QA) testing quickly with low developer overhead. Azure Pipelines uses [Azure Key Vault](/azure/devops/pipelines/release/azure-key-vault) to securely consume secrets like credentials and connection strings required for release and deployment configurations.

4. [Azure Boards](https://azure.microsoft.com/services/devops/boards/) connects back to the GitHub repos, letting developers track both code and tasks in one location. Automated testing also generates bugs for any build or release failures, feeding the results back into the development cycle.

5. Azure Boards work items come from automated testing, manual QA testing, and added features. Developers create feature branches and associate them with work items to track development, creating more iterations of the development loop.

6. Azure Pipelines deploys builds to the low-cost [Azure DevTest Labs](https://azure.microsoft.com/pricing/dev-test/) subscription environments, where developers and testers can rapidly provision VMs. [Azure Policy](/azure/governance/policy/concepts/recommended-policies) regulates and limits DevTest VM numbers and costs, and audits VM usage to provide insight and tracking.

   Developers can deploy VMs as quickly as needed within the lab, while staying within resource and cost parameters set by managers and administrators. The flexibility of low-cost labs provides developers with all the environments they need for rapid iterative progress.

   Testers can operate within their own DevTest Labs environment, pulling ready-for-test images into the test team's labs separately from the development team. The ability of developers and testers to work in parallel DevTest Labs contributes to rapid iteration of ready-to-release image versions.

7. As the developed VM images reach a release state, Azure Pipelines triggers releases, which generalize the targeted images for destinations like [virtual machine scale sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/), and promotes them out of DevTest and into a Production environment.

   [User Acceptance Testing (UAT)](https://wikipedia.org/wiki/Acceptance_testing#User_acceptance_testing) validates a staged VM or virtual machine scale set before deployment to Production.

   Approvals are usually required for releases to higher-cost, client-facing Production destinations. Production remains isolated and protected from inadvertent or unapproved deployments.

This scenario uses a separate DevTest and Production [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory/) per subscription to create a distinct separation of concerns. To meet compliance requirements, the Production subscription's Azure AD might need to include a smaller cross section of users than the DevTest Azure AD.

[Azure Monitor](/azure/devtest-labs/security-baseline) works across subscriptions to monitor VMs in both the Production and DevTest environments.

### Components

- [Azure DevTest Labs](https://azure.microsoft.com/services/devtest-lab/) provides labs that have all the necessary tools and software to create environments. Developers can efficiently self-manage resources without waiting for approvals. With DevTest Labs, teams can control costs and regulate resources per lab, granting developers permission and flexibility to operate their sandboxes within cost constraints.

- [Azure VM Image Builder](/azure/virtual-machines/windows/image-builder-overview) service provides baseline VM images that developers can customize. The service facilitates the creation and patching of images and can be called as an Azure Pipelines task.

- [Shared Image Gallery](/azure/virtual-machines/windows/shared-image-galleries) acts as a VM image repository for IaaS solutions. VM Image Builder can build directly into a Shared Image Gallery, facilitating an Azure Pipelines CI/CD process of versioning the VM-based application.

- [GitHub](https://docs.github.com/github/creating-cloning-and-archiving-repositories/about-repositories) is a code hosting platform for version control and collaboration. A GitHub repository contains all project files and their revision history. Developers can work together to contribute, discuss, and manage code in the repository.

- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/) deploys the VM application images. Pipelines can also deploy the VM resources themselves, through [Azure Resource Manager (ARM) templates](/azure/azure-resource-manager/templates/overview). This [infrastructure-as-code](/devops/deliver/what-is-infrastructure-as-code) can be source controlled and configured for CI/CD, ensuring that the infrastructure remains up to date.

- [Azure Key Vault](/azure/key-vault/general/basic-concepts) securely stores and tightly controls access to secrets like API keys, passwords, and certificates. For more information about Key Vault in DevOps scenarios, see [DevSecOps in Azure](devsecops-in-azure.yml).

- [Azure Boards](https://azure.microsoft.com/services/devops/boards/) is a service for managing work for software projects. Azure Boards brings a rich set of capabilities, including native support for Scrum and Kanban methodologies, customizable dashboards, and integrated reporting.

- [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) enterprise identity platform provides single sign-on and multifactor authentication to govern user access to resources. In this scenario, a separate Azure AD per subscription creates a distinct separation of concerns between Azure users.

- [Azure Policy](https://azure.microsoft.com/services/azure-policy/) governs resources to meet organizational standards and compliance. In a DevTest role, Azure Policy can regulate and limit the number and costs of VMs in the subscription. Auditing can provide insights and track the usage of the DevTest VMs.

- [Azure Monitor](/azure/devtest-labs/security-baseline) can work across subscriptions to monitor VMs in both Production and DevTest environments. Azure Monitor can collect log data from VM operating systems as well as crash dump files, and aggregate them for viewing in [Microsoft Defender for Cloud](/azure/security-center/security-center-enable-data-collection).

### Alternatives

In situations where VM Image Builder and a Shared Image Gallery don't work, you can set up an [image factory](/azure/devtest-labs/image-factory-create) to build VM images from the CI/CD pipeline and distribute them automatically to any Azure DevTest Labs registered to those images. For more information, see [Run an image factory from Azure DevOps](/azure/devtest-labs/image-factory-set-up-devops-lab).

## Next steps

- [DevSecOps in Azure](./devsecops-in-azure.yml)
- [DevTest and DevOps for PaaS solutions](dev-test-paas.yml)
- [DevTest and DevOps for microservices](dev-test-microservice.yml)
- [Set up Azure DevOps](/azure/devops/get-started/)
- [Create a lab in Azure DevTest Labs](/azure/lab-services/tutorial-create-custom-lab)
- [Create your first Windows virtual machine in the Azure portal](/azure/virtual-machines/windows/quick-create-portal)
