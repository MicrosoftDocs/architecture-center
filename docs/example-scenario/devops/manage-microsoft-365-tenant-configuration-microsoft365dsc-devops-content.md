This article describes a solution for managing changes that service administrators make to Microsoft 365 tenants. The solution uses a repository-based process to review and approve configuration changes before deployment. This process creates an audit trail for changes submitted through the repository and helps apply approved configurations consistently across multiple Microsoft 365 tenants.

## Architecture

:::image type="complex" border="false" source="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.svg" alt-text="Diagram that shows the architecture for automating changes to Microsoft 365 tenant configurations by using Microsoft365DSC and Azure Pipelines." lightbox="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.svg":::
   The workflow flows from left to right and is organized into nine numbered steps. The left side of the diagram focuses on authoring and source control activities, the center section shows automated build and deployment processes, and the right side shows deployment to Microsoft 365 staging and production environments. Step 1 begins with an administrator labeled Admin 1. Admin 1 adds, modifies, or deletes settings in a configuration file. An arrow points from Admin 1 to a document icon labeled Config file. In Step 2, the configuration changes are committed and synchronized to a personal fork of a repository. The fork is represented by a Git repository icon labeled Fork admin 1. An arrow connects the configuration file to the forked repository. Step 3 shows the administrator creating a pull request from the forked repository to a central repository. A horizontal arrow points from Fork admin 1 to a Git repository labeled Main repository. The arrow is labeled Create pull request. Step 4 introduces an automated validation stage. A downward arrow from the pull request process points to Azure Pipelines. The arrow is labeled Check pull request. Step 5 shows a group of administrators reviewing the proposed changes. An arrow points from the administrator group toward the main repository and is labeled Review code & merge PR. After the pull request is merged, the workflow continues from the main repository to a multi-stage pipeline represented by an Azure Pipelines icon. Step 6 shows the multi-stage pipeline retrieving credentials from Azure Key Vault. A vertical arrow points upward from the pipeline to the Key Vault icon. The connection is labeled Get credentials for compiling Managed Object Format (MOF) files. Step 7 shows the multi-stage pipeline passing compiled configuration data to Microsoft365DSC, represented by a Microsoft 365 icon. The connection is labeled Deploy changes from MOF files via PowerShell task. From Microsoft365DSC, two deployment paths branch outward. The upper path deploys changes to a Microsoft 365 staging environment. The arrow connecting Microsoft365DSC to staging is labeled Deploy. Step 8 shows a group of administrators validating the changes in the staging environment. An arrow points from the administrators to the Microsoft 365 staging tenant and is labeled Validate changes. After validation is complete, Step 9 shows administrators approving deployment to production. The administrator group is positioned next to the production environment. The accompanying text reads Approve change for deployment. A deployment arrow extends from Microsoft365DSC toward the Microsoft 365 production environment. The arrow is labeled Deploy. A second arrow connects the administrator approval step to the production environment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/m365-dev-ops.vsdx) of this architecture.*

### Workflow

1. Admin 1 adds, updates, or deletes an entry in a fork of a Microsoft 365 configuration file. For example, Admin 1 changes the permission policy for a Microsoft Teams app.
1. Admin 1 commits and syncs the changes to the forked repository.
1. Admin 1 creates a pull request (PR) to merge the changes into the main repository.
1. In Azure Pipelines, a build pipeline runs on the PR.
1. Other admins review the code and merge the PR.
1. The merged PR triggers a pipeline to compile Managed Object Format (MOF) files. The pipeline calls Azure Key Vault to retrieve the credentials that are used in the MOF files.
1. An Azure PowerShell task in a multistage pipeline uses the compiled MOF files to deploy configuration changes via Microsoft365DSC.
1. Admins validate the changes in a staged Microsoft 365 tenant.
1. Admins get notifications about the approval process in Azure DevOps for the production Microsoft 365 tenant. Admins approve or reject the changes.

### Components

- [Azure Pipelines](/azure/devops/pipelines) is an Azure DevOps service for continuous integration and continuous delivery (CI/CD). You can use Azure Pipelines to test and build your code and ship it to any target. You can also use Azure Pipelines to implement quality gates to help ensure that you deploy changes in a controlled and consistent manner.
- [Key Vault](/azure/key-vault/general) improves the security of storage for tokens, passwords, certificates, API keys, and other secrets. It also provides tightly controlled access to these secrets. This example workload uses Key Vault to store credentials that service principals use to deploy configuration changes to Microsoft 365 tenants. Examples of those credentials include client secrets and certificates.
- [Microsoft365DSC](https://microsoft365dsc.com) is an open-source project that provides automation for the deployment, configuration, and monitoring of Microsoft 365 tenants via PowerShell Desired State Configuration (DSC). You can use Microsoft365DSC to deploy configuration changes to Microsoft 365 tenants via Azure Pipelines.
- [Windows PowerShell DSC](/powershell/scripting/dsc/overview) is a management platform in PowerShell. You can use it to manage your development infrastructure by using a configuration as code model. This model is the underlying technology that Microsoft365DSC uses.

### Alternatives

- You can use DSC in [Azure Automation](/azure/automation/automation-dsc-overview) to store DSC configurations in a central location. Azure Automation can also provide reports on the compliance of tenant configurations with a specified desired state.

- This architecture uses Key Vault to store certificates that are used for authentication to the Microsoft 365 tenant. Key Vault provides scalability by centrally managing certificates and by providing support for workloads that use multiple certificates, such as some Exchange and SharePoint workloads. As an alternative to Key Vault, for a limited-scope pipeline, you can use pipeline variables that are marked as secret. Pipeline variables can reduce resource complexity, but in Azure Pipelines, the recommended approach is to manage secret variables in Key Vault. If you use pipeline variables, restrict variable-group access, rotate secrets, and don't write secrets to logs or command-line arguments.

- By using an Azure virtual machine (VM) for Windows and DSC, you can apply and monitor a configuration to Microsoft 365 tenants that use [Microsoft365DSC](https://microsoft365dsc.com). The Azure Windows VM can use Microsoft365DSC to detect configuration drift. You can use [Azure action groups](/azure/azure-monitor/alerts/action-groups) to send email to Microsoft 365 admins whenever drift is detected. An Azure action group can also run a webhook to trigger an [Azure runbook](/azure/automation/automation-webhooks). The runbook can generate a [report](https://microsoft365dsc.com/user-guide/get-started/comparing-configurations/) of configuration drift within Microsoft 365 tenants.

- As an alternative solution, you can use the [Tenant Configuration Management (TCM) APIs](/graph/unified-tenant-configuration-management-concept-overview), an official solution that Microsoft supports. These generally available APIs don't completely replace Microsoft365DSC, because they currently support configuration snapshots and drift detection, not deployment or remediation. Microsoft365DSC remains a community-driven, open-source project.

## Scenario details

Many companies set a goal of applying DevOps practices to Microsoft 365 tenant configuration management. Not adopting DevOps for Microsoft 365 can lead to the following common problems:

- Misconfigurations
- Challenges with tracking configuration changes
- No approval process for tenant modifications

Use the solution described in this article to automate changes to Microsoft 365 tenant configurations by using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) and [Microsoft365DSC](https://microsoft365dsc.com). Microsoft365DSC is a [PowerShell DSC](/powershell/scripting/dsc/overview) module. Use it to configure and manage Microsoft 365 tenants in a true DevOps style that uses configuration as code.

### Potential use cases

This solution helps you manage Microsoft 365 tenant configuration in a controlled and automated way by using DevOps tools and practices. Microsoft365DSC can manage hundreds of properties within Microsoft 365, such as Exchange transport rules, Teams app policies, and SharePoint sharing settings. For a complete listing and examples of configurations, see the examples in the [Microsoft365DSC repo on GitHub](https://github.com/Microsoft365DSC/Microsoft365DSC/tree/Dev/Examples/Resources).

Here are some scenarios in which you can use Microsoft365DSC:

- Use DevOps tools and practices across development, test, acceptance, and production environments.
- Manage multiple customer tenants, such as in a managed service provider scenario.
- Detect compliance and configuration drift of various Microsoft 365 workloads, for example, Exchange, Teams, and SharePoint workloads.
- Migrate configurations from one tenant to another.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

Most beginners to PowerShell DSC find that it takes some time to learn how to use this platform. A solid understanding of PowerShell and experience with creating scripts make that process easier.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Service principals are the preferred authentication method for Microsoft365DSC. Service principals avoid multifactor authentication conflicts that are inherent with username/password authentication. Service principals also authenticate as a dedicated app identity with no interactive sign-in surface, and they support least-privilege API permissions with auditable credential management in Microsoft Entra ID.

Compiled MOF files can contain credentials. Treat MOF files as sensitive artifacts: restrict access and retention, don't publish them broadly, and protect any certificate passwords or application secrets that they contain.

If you build a Microsoft365DSC solution on Azure DevOps, you can also take advantage of the security in [Azure Pipelines](/azure/devops/pipelines/security/overview) and an [approval process](/azure/devops/pipelines/release/approvals/approvals) to help safeguard deployment to your production tenant.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For Azure DevOps pricing information, see [Pricing for Azure DevOps](https://azure.microsoft.com/pricing/details/devops/azure-devops-services). If you incorporate Key Vault into your solution, see [Key Vault pricing](https://azure.microsoft.com/pricing/details/key-vault).

You can also use the [Azure pricing calculator](https://azure.com/e/b63cf60f058a474bac67700c5a6feb6e) to estimate costs for this solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Some operations teams consider [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) to be a tool for developers. But operations teams can also benefit from using Azure DevOps for the following tasks:

- Store scripts in a repository and add source control and versioning.
- Automate the deployment of scripts.
- Use boards to track tasks and projects.

Using a configuration as code model isn't a one-time task. It involves a shift in your way of working and a fundamental change for all team members. Instead of making changes manually, you implement them in scripts and deploy them automatically. All team members need to have the skills to make this change.

You can use this solution when you work with multiple environments, multiple workloads, or multiple teams. You can configure the validation process so that experts need to approve each workload. You can also extend the solution to deploy to multiple tenants for scenarios such as development, test, acceptance, and production scenarios, or for multiple organizations.

## Deploy this scenario

For detailed steps that show how to deploy this scenario, see the Microsoft 365 DSC whitepaper, [Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps](https://m365dscwhitepaper.azurewebsites.net/Managing%20Microsoft%20365%20with%20Microsoft365Dsc%20and%20Azure%20DevOps.pdf).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Derek Smay](https://www.linkedin.com/in/dereksmay) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps](https://m365dscwhitepaper.azurewebsites.net/Managing%20Microsoft%20365%20with%20Microsoft365Dsc%20and%20Azure%20DevOps.pdf)
- [Microsoft365DSC source code](https://github.com/Microsoft365DSC/Microsoft365DSC)
- [Microsoft365DSC YouTube channel](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw)
- [Microsoft365DSC site](https://microsoft365dsc.com)
- [Microsoft365DSC export generator tool](https://export.microsoft365dsc.com)

## Related resource

[Microsoft 365 solution and architecture center](/microsoft-365)
