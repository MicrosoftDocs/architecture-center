
Many companies are adopting DevOps practices and want to apply these practices to their Microsoft 365 tenants. If you don't adopt DevOps for Microsoft 365, you might encounter some common problems:

- Misconfiguration
- Challenges with tracking configuration changes
- No approval process for tenant modifications 

You can use the solution described in this article to automate changes to Microsoft 365 tenant configurations by using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) and [Microsoft365DSC](https://microsoft365dsc.com). Microsoft365DSC is a [PowerShell Desired State Configuration (DSC)](/powershell/scripting/dsc/overview/overview) module. You can use it to configure and manage Microsoft 365 tenants in a true DevOps style: configuration as code. You can use the solution to track changes made by service administrators and put an approval process around deployments to Microsoft 365 tenants. The solution helps you prevent untracked changes into Microsoft 365 tenants. It also helps to prevent configuration drift between multiple Microsoft 365 tenants.

## Potential use cases

This solution can help you manage Microsoft 365 tenant configuration in a controlled and automated way, using DevOps tools and practices, across:

- Development, test, acceptance, and production environments.
- Multiple customer tenants, as in a managed-service provider scenario.

## Architecture

:::image type="content" border="false" source="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.png" alt-text="Diagram that shows the architecture for automating changes to Microsoft 365 tenant configurations." lightbox="./media/manage-microsoft-365-tenant-configuration-microsoft365dsc-azure-devops.png":::

*Download a [Visio file](https://arch-center.azureedge.net/M365DevOps.vsdx) of this architecture.*

1. Admin 1 adds, updates, or deletes an entry in Admin 1's fork of the Microsoft 365 config file.
2. Admin 1 commits and syncs changes to Admin 1's forked repository.
3. Admin 1 creates a pull request (PR) to merge changes to the main repository.
4. The build pipeline runs on the PR.
5. Admins review code and merge the PR.
6. The merged PR triggers a pipeline to compile Managed Object Format (MOF) files. The pipeline calls Azure Key Vault to retrieve credentials that are used in the MOFs.
7. An Azure PowerShell task in a multistage pipeline uses the compiled MOF files to deploy configuration changes via Microsoft365DSC.
8. Admins validate changes in a staged Microsoft 365 tenant.
9. Admins get notification from the approval process in Azure DevOps for the production Microsoft 365 tenant. Admins approve or reject the change.

### Components

- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) enables continuous integration (CI) and continuous delivery (CD) to test and build your code and ship it to any target.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) improves the security of storage for tokens, passwords, certificates, API keys, and other secrets. It also provides tightly controlled access to these secrets. 
- [Microsoft365DSC](https://microsoft365dsc.com) provides automation for the deployment, configuration, and monitoring of Microsoft 365 tenants via PowerShell Desired State Configuration.
- [Windows PowerShell DSC](/powershell/scripting/dsc/overview/overview) is a management platform in PowerShell. You can use it to manage your development infrastructure by using a configuration-as-code model.

### Alternatives

As a next step, you can use DSC in [Azure Automation](/azure/automation/automation-dsc-overview) to store configurations in a central location and add reporting of compliance with the desired state.

This architecture uses Key Vault to store Azure App Service certificates or user credentials that are used for authentication to the Microsoft 365 tenant. Key Vault provides scalability. As an alternative, you can use pipeline variables to reduce the complexity of the solution.

## Considerations

Most people starting out with PowerShell DSC experience a steep learning curve. It helps if you have a solid understanding of PowerShell and experience with creating scripts.

### Operations

Some operations teams consider Azure DevOps to be a tool for developers. But operations teams can benefit from using Azure DevOps. Operations teams can:
- Store their scripts in a repository and add source control and versioning. 
- Automate deployments of scripts.
- Use boards to track tasks, projects, and more. 

You might want to spend some time investigating what Azure DevOps can offer operations teams.

Using a configuration-as-code model isn't a one-time task. It's a shift in your way of working. It's a fundamental change for all team members. You no longer make changes manually. Instead, everything is implemented in scripts and deployed automatically. This requires that all team members have the skills to make the change.

### Scalability

You can use this solution when you're working with multiple environments, multiple workloads, and multiple teams. The validation process can be configured in such a way approval has to be given by experts from each workload. The solution is also able to be extended to deploy to multiple tenants, both for a Dev, Test, Acceptance, Production use and/or for multiple organizations.

To increase scalability even further, an aggregated configuration data solution like [Datum](https://github.com/gaelcolas/datum/) can be considered. Datum is outside the scope of this scenario.

### Security

Most Microsoft365DSC resources support authentication via username/password, but since Microsoft best practices state that multifactor authentication (MFA) is recommended using this type of authentication is not recommended. Instead using application credentials is the way to go, where supported by the Microsoft 365 resources. For example currently Security and Compliance only supports username/password but SharePoint Online, AzureAD and others support application credentials. Building M365DSC solution upon Azure DevOps you can also take advantage security within [Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/security/overview?view=azure-devops) as well as an [approval process](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/approvals/approvals?view=azure-devops) to safeguard deployment to production tenant.

### DevOps

This solution can run in Azure DevOps server and a similar solution can be created in GitHub using GitHub actions.  

## Next steps

- The whitepaper [Microsoft365Dsc and Azure DevOps](https://microsoft365dsc.com/Pages/Resources/Whitepapers/Managing%20Microsoft%20365%20with%20Microsoft365Dsc%20and%20Azure%20DevOps.pdf) details creating a solution with Azure DevOps and Microsoft365DSC.

## Related resources

- [Microsoft365DSC source code](https://github.com/microsoft/Microsoft365DSC)
- [Microsoft365DSC YouTube channel](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw)
- [Microsoft365DSC site](https://microsoft365dsc.com/)
- [Microsoft365DSC export generator tool](https://export.microsoft365dsc.com/)

## Pricing

This solution utilizes Azure DevOps and for pricing information please visit [page](https://azure.microsoft.com/pricing/details/devops/azure-devops-services/). If you choose to incorporate Azure Key Vault into solution, you can find its pricing [here](https://azure.microsoft.com/pricing/details/key-vault/).

[calculator]: https://azure.com/e/