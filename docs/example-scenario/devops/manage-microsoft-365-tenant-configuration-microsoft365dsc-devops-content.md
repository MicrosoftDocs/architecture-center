The solution described here tracks changes made by service administrators and adds an approval process to deployments to Microsoft 365 tenants. It can help you prevent untracked changes to Microsoft 365 tenants. It also helps to prevent configuration drift between multiple Microsoft 365 tenants.

## Architecture

:::image type="content" border="false" source="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.svg" alt-text="Diagram that shows the architecture for automating changes to Microsoft 365 tenant configurations." lightbox="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/m365-dev-ops.vsdx) of this architecture.*

### Workflow

1. Admin 1 adds, updates, or deletes an entry in Admin 1's fork of the Microsoft 365 config file.
2. Admin 1 commits and syncs the changes to Admin 1's forked repository.
3. Admin 1 creates a pull request (PR) to merge the changes to the main repository.
4. The build pipeline runs on the PR.
5. Admins review code and merge the PR.
6. The merged PR triggers a pipeline to compile Managed Object Format (MOF) files. The pipeline calls Azure Key Vault to retrieve credentials that are used in the MOFs.
7. An Azure PowerShell task in a multistage pipeline uses the compiled MOF files to deploy configuration changes via Microsoft365DSC.
8. Admins validate changes in a staged Microsoft 365 tenant.
9. Admins get notification from the approval process in Azure DevOps for the production Microsoft 365 tenant. Admins approve or reject the changes.

### Components

- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) enables continuous integration (CI) and continuous delivery (CD) to test and build your code and ship it to any target.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) improves the security of storage for tokens, passwords, certificates, API keys, and other secrets. It also provides tightly controlled access to these secrets.
- [Microsoft365DSC](https://microsoft365dsc.com) provides automation for the deployment, configuration, and monitoring of Microsoft 365 tenants via PowerShell DSC.
- [Windows PowerShell DSC](/powershell/scripting/dsc/overview) is a management platform in PowerShell. You can use it to manage your development infrastructure by using a configuration-as-code model.

### Alternatives

As a next step, you can use DSC in [Azure Automation](/azure/automation/automation-dsc-overview) to store configurations in a central location and add reporting of compliance with the desired state.

This architecture uses Key Vault to store Azure App Service certificates or user credentials that are used for authentication to the Microsoft 365 tenant. Key Vault provides scalability. As an alternative, you can use pipeline variables to reduce the complexity of the solution.

## Scenario details

Many companies are adopting DevOps practices and want to apply these practices to their Microsoft 365 tenants. If you don't adopt DevOps for Microsoft 365, you might encounter some common problems:

- Misconfiguration
- Challenges with tracking configuration changes
- No approval process for tenant modifications

You can use the solution described in this article to automate changes to Microsoft 365 tenant configurations by using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) and [Microsoft365DSC](https://microsoft365dsc.com). Microsoft365DSC is a [PowerShell Desired State Configuration (DSC)](/powershell/scripting/dsc/overview) module. You can use it to configure and manage Microsoft 365 tenants in a true DevOps style: configuration as code.

### Potential use cases

This solution can help you manage Microsoft 365 tenant configuration in a controlled and automated way, using DevOps tools and practices, across:

- Development, test, acceptance, and production environments.
- Multiple customer tenants, as in a managed-service provider scenario.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Most people starting out with PowerShell DSC find that it takes a while to learn it. It helps if you have a solid understanding of PowerShell and experience with creating scripts.

### Operations

Some operations teams consider Azure DevOps to be a tool for developers. But these teams can benefit from using Azure DevOps. Operations teams can:

- Store their scripts in a repository and add source control and versioning.
- Automate deployments of scripts.
- Use boards to track tasks, projects, and more.

Using a configuration-as-code model isn't a one-time task. It's a shift in your way of working and a fundamental change for all team members. You no longer make changes manually. Instead, everything is implemented in scripts and deployed automatically. All team members need to have the skills to make this change.

### Scalability

You can use this solution when you're working with multiple environments, multiple workloads, and/or multiple teams. You can configure the validation process so that experts need to approve each workload. You can also extend the solution to deploy to multiple tenants, for a dev/test/acceptance/production scenario and/or for multiple organizations.

To increase scalability even further, you can use an aggregated-configuration data solution like [Datum](https://github.com/gaelcolas/datum).

### Security

Most Microsoft365DSC resources support authentication via user name and password. But we don't recommend that type of authentication because Microsoft best practices recommend multifactor authentication. Application credentials is the preferred method, where supported by the Microsoft 365 resources. For example, SharePoint Online, Azure Active Directory (Azure AD), and other resources support application credentials.

If you build a Microsoft365DSC solution on Azure DevOps, you can also take advantage of the security in [Azure Pipelines](/azure/devops/pipelines/security/overview) and an [approval process](/azure/devops/pipelines/release/approvals/approvals) to safeguard deployment to your production tenant.

### DevOps

You can run this solution in Azure DevOps Server. You could create a similar solution in GitHub by using GitHub Actions.  

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For Azure DevOps pricing information, see [Pricing for Azure DevOps](https://azure.microsoft.com/pricing/details/devops/azure-devops-services). If you incorporate Key Vault into your solution, you can find [pricing information here](https://azure.microsoft.com/pricing/details/key-vault).

You can also use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

## Contributors

*This article is being maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Derek Smay](https://www.linkedin.com/in/dereksmay) | Senior Customer Engineer

## Next steps

- [Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps](https://office365dsc.azurewebsites.net/Pages/Resources/Whitepapers/Managing%20Microsoft%20365%20with%20Microsoft365Dsc%20and%20Azure%20DevOps.pdf)
- [Microsoft365DSC source code](https://github.com/microsoft/Microsoft365DSC)
- [Microsoft365DSC YouTube channel](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw)
- [Microsoft365DSC site](https://microsoft365dsc.com)
- [Microsoft365DSC export generator tool](https://export.microsoft365dsc.com)

## Related resources

- [End-to-end governance in Azure when using CI/CD](../../example-scenario/governance/end-to-end-governance-in-azure.yml)
- [CI/CD for Windows desktop apps](/azure/architecture/solution-ideas/articles/azure-devops-ci-cd-for-desktop-apps)
- [DevOps Checklist](/azure/architecture/checklist/dev-ops)
