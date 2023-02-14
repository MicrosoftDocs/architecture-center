
Gridwich requires multiple resources within and outside Azure to talk to one another securely. This requirement poses continuous integration and continuous delivery (CI/CD) challenges with Azure Active Directory (Azure AD) permissions, gates, resource creation, order of operation, and long-running functions deployment. The following guiding principles address these challenges:

- A single build artifact affects all environments in the same pipeline.
- Non-gated environments are disposable.
- Terraform declaratively creates idempotent environments.
- Terraform doesn't release software.
- Infrastructure creation and software release are distinct stages in the pipeline.
- The CI/CD pipeline doesn't assign Azure AD permissions.
- The pipeline considers everything as code.
- The pipeline uses reusable components focused on composability.

For more information about how the Azure Pipelines CI/CD pipelines convert and inject pipeline variables into Terraform modules, and then to Azure Key Vault and Azure Functions app settings, see [Pipelines to Terraform variable flow](variable-group-terraform-flow.yml).

The following considerations relate to the preceding principles.

## Single artifact, multiple environments

The Gridwich pipeline scales to multiple environments, but there is only one artifact, which the pipeline promotes from one environment to the next.

## Software release vs. infrastructure creation

In Gridwich, software release and infrastructure deployment are two separate responsibilities. A single pipeline handles both responsibilities at various stages, using the following general pattern:

**Software builds > Infrastructure deployment > Software release > Software configuration > Custom script deployment**

The guiding principle that infrastructure and software release are two distinct responsibilities makes deploying Event Grid subscriptions more difficult. When Azure creates an Event Grid webhook subscription, it sends a validation event to check whether the registering endpoint accepts Event Grid events. To pass this validation check, the Azure Function must be released and running before Terraform can build the Event Grid subscription resources.

To address this issue, there are two Terraform jobs in the CI/CD pipeline:

![Diagram showing the Terraform sandwich jobs.](media/terraform-sandwich.png)

- Terraform 1 creates all the resources except for the Azure Event Grid subscriptions.
- Terraform 2 creates the Event Grid subscriptions after the software is up and running.

Because Terraform currently lacks the ability to exclude a specific module, the Terraform 1 job must explicitly target all the modules except the Event Grid subscriptions. This requirement is potentially error prone, and a current [GitHub issue on Terraform](https://github.com/hashicorp/terraform/issues/2253) tracks this problem.

## Post-deployment scripts

The CI/CD pipeline doesn't do operations that need elevated privileges, but uses [admin script templates](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/bashscriptgenerator/templates) to generate a set of admin scripts as pipeline artifacts. An admin with elevated privileges must run these admin scripts whenever a new Gridwich environment is created. For more information, see [Run Azure admin scripts](run-admin-scripts.yml).

Terraform and software releases can't complete certain Gridwich operations, including:

- Copying certificates to Azure Key Vault
- Enabling storage analytics in Azure Storage
- Scaling Azure Media Services

The Azure CLI script [azcli-last-steps-template.yml](https://github.com/mspnp/gridwich/blob/main/infrastructure/azure-pipelines/templates/steps/azcli-last-steps-template.yml) provides these last steps.

## Everything as code and code reuse

One advantage of the "everything as code" practice is component reuse.

- For Terraform, Gridwich relies heavily on [Terraform modules](https://www.terraform.io/docs/modules/composition.html) to enhance composability and reusability.
- For Azure Pipelines YAML, Gridwich uses [Pipeline templates](/azure/devops/pipelines/process/templates).

## Next steps

- [Run the admin scripts](run-admin-scripts.yml)
- [Pipeline variables to Terraform flow](variable-group-terraform-flow.yml)
