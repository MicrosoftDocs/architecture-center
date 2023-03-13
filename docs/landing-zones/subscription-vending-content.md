This article provides implementation guidance for automating the subscription vending process.

Subscriptions vending standardizes the process for requesting, deploying, and governing subscriptions for application landing zones. It places the subscription creation process under the governance of the platform, so application teams can focus on deploying their workloads with greater confidence and efficiency. You should automate as much of the subscription vending process as you can.

## Architecture

You should architect your subscription vending automation to accomplish three primary tasks. Subscription vending automation should:

1. Collect subscription request data
1. Initiate platform automation
1. Create the subscription using infrastructure-as-code.

Numerous approaches exist for implementing subscription vending automation. The guidance presented here utilizes a GitFlow implementation with two pipelines. The GitFlow design aligns with the declarative approach that platform teams use to manage the platform.

[![Diagram showing the components of the subscription vending approach.](images/subscription-vending-components.png)](images/subscription-vending-components.png)
*Figure 1. Example implementation of subscription vending automation. For a visualization of the flow, see [subscription vending process flow](https://github.com/MicrosoftDocs/architecture-center-pr/blob/main/docs/landing-zones/images/subscription-vending-process-flow.md)*

The example implementation (*see Figure 1*), the data collection tool gathers subscription request data. When the request receives approval, it triggers the request pipeline. The request pipeline creates a JSON or YAML subscription parameter file with the data from the data collection tool. The request pipeline creates a new branch, commits the subscription parameter file and opens pull request in source control. When the new branch mergers to the main branch in source control, it triggers the deployment pipeline to create the subscription with the infrastructure-as-code modules. The deployment should create the subscription in the right management group with the necessary governance (*see Figure 2*).

[![Diagram showing how the subscriptions vending fits in an organization.](images/sample-subscription-vending-architecture.png)](images/sample-subscription-vending-architecture.png)
*Figure 2. Subscription vending automation in an example Azure environment.*

Based on the needs of the workload, the deployment could create an empty virtual network and configure peering to a regional hub. The platform team should hand off the subscription to the application team, and the application team should apply a budget to the subscription and create the workload resources.

## How to collect data

The goal of data collection is to receive business approval and define the values of the JSON/YAML subscription parameter file. You should use a data collection tool to collect the required data. The data collection tool should interface with other systems in the subscription vending workflow to initiate the platform automation.

**Use a data collection tool.** You can use an IT Service Management (ITSM) to collect the data or build a customer portal with a low-code or no-code tool like [Microsoft PowerApps](https://powerapps.microsoft.com/). This data collection tool should provide business logic approve or deny the subscription request.

**Collect the required data.** You need to collect enough data to define the values of the JSON/YAML subscription parameter so you can automate the deployment. The specific values to collect depend on your needs. Potential items to capture are the request authorizer, cost center, networking requirements (internet connectivity, on-premises connectivity), key workload components (application platform, data requirements), data sensitivity, environments (development, test, pre-production, production), and any other required fields.

**Validate data.** You want to validate as much data as possible during the request collection process as possible. It's harder to address issues in the platform automation phases.

**Create trackable request.** Your data collection tool should result in a logged and trackable request for a new subscription. For example, an ITSM generates a ticket. The request should contain all necessary data to fulfill the requirements of that subscription. You should bind the business logic and authorization tracking to the request.

**Interface with other internal systems.** Where needed, the data collection tool should interface with other tools or systems in your organizations. The goal of the interface is to enrich the request with data from other systems. These could be identity, finance, security, and networking systems. For example, you could interface with an IP address management (IPAM) tool to reserve the right IP address space.

**Create trigger.** When the subscription request receives approval, the data transfer should trigger the platform automation. It's ideal to create a push notification from your data collection with the necessary data. You might need a middleware layer, such as Azure Functions or Logic Apps, to initiate the process.

## How to initiate platform automation

The notification and data from the data collection tools should trigger the platform automation. The goal of platform automation is to create a JSON/YAML subscription parameter file, merge the file to the main branch, and deploy it with the infrastructure-as-code modules to create the subscription. The platform team owns and maintains this implementation responsible for subscription creation in the organization.

**Use JSON or YAML files.** You should use structured data files (JSON or YAML) to store the data necessary to create a subscription. The structure of the file should be documented and extensible to support future needs.

[example] (networking, business unit code, tech and bio)

**Use one file per subscription request.** Each subscription request should get its own dedicated configuration file.  The subscription is the unit of deployment in the vending process.

**Use a pull request system.** The GitFlow process that creates the subscription parameter file should automate the following steps:

1. Create a new branch for each subscription request
1. Use the data collected to create a single YAML/JSON subscription parameter file for the new subscription in the branch.
1. Create a pull request from your branch into `main`
1. Update the data collection tool with a state change and reference to this pull request

The *request pipeline* in the example implementation executes these steps (*see figure 1*). You could also use a code-based solution hosted in Azure if the workflow becomes complex.

**Validate the subscription parameter file**. The pull request should trigger a linting process to validate the request data. The goal to ensure the deployment is successful. It should validate the YAML/JSON subscription parameter file. It could also verify that the IP address range is still available. You might also want to add a manual review gate with human intervention. They could perform the final review and make any alterations to the subscription parameter file. The output should be a JSON/YAML subscription parameter file with all the data to create a subscription. For example, mapped Owner RBAC role to subscription owner alias.

**Trigger the deployment pipeline.** When the pull request merges into `main` the main branch, it should trigger the deployment pipeline.

## How to create subscription

The *deployment pipeline* in the example implementation uses the merge

This final phase is where the subscription vending automation creates and configures the workload subscription. This creation process should be automated.

Up until this point, everything has been focused on capturing, reviewing, approving, and documenting the intent to have a subscription created, with as much automation as practical.

The process picks up when the JSON/YAML subscription parameter file merges into the `main` branch. This is the authoritative push notification to actually deploy new resources (subscription and base configuration) in Azure, final commits to external tracking systems (e.g. IPAM), and updating status in the ITSM tooling tracking this request.

**Use infrastructure as code.** Your deployments should use infrastructure as code templates to create the subscription. The platform team should create and maintain these templates to ensure proper governance.

![GitHub icon](../_images/github.png) There are Azure Landing Zone subscription vending modules in [Bicep](https://aka.ms/lz-vending/bicep) and [Terraform](https://aka.ms/lz-vending/tf). You should use these as your starting point. Modify these templates to fit your implementation needs.

**Use a deployment pipeline.** The deployment pipeline orchestrates the creation and configuration of the workload subscription. The pipeline is responsible for the following:

- Create or update Azure AD resources to represent subscription ownership
- Create and configure management group placement
  - Subscription owner designation
  - Subscription-level RBAC to configured security groups
  - Microsoft Defender for Cloud enrollment
- Deploy and configure resources.  Some comment examples are:
  - Virtual networks and their peering to platform resources, such as a regional hub
  - Subscription-level Azure Policy
  - Highly privileged workload identities for workload team deployments
- Updating external systems, such as IPAM to commit on IP reservations
- Updating the ITSM request with final subscription name, GUID, and anything else necessary to communicate back to the requester that the task is complete.

Be aware that you do need a commercial agreement to create an Azure Subscription programmatically. If you do not have a commercial agreement, you'll need to introduce a manual process above to create the actual Azure Subscription, but you can automate all other aspects of subscription configuration without a commercial agreement.

**Pipeline identity.** In order to perform all of these operations, the CI/CD pipeline needs to be properly permissioned across all systems it interfaces with - Azure RBAC, Azure AD, and external systems alike. For Azure recommend using either managed identity or OpenID Connect (OIDC) to authenticate to Azure.

**OUtput** subscription under governance ready for workload.

## Post-deployment

TODO intro :

### Application team handoff

With the subscription in place, the application team is now able to deploy and operate their workload with the governance set in place through the automated subscription vending processes described above. Deploying, managing, and operating the workload then becomes the next focus of the application team that requested this subscription. Those pipelines and processes are not related to the subscription vending process outlined above; this process is solely responsible for automating the instantiation "ready-to-use" subscription.

### Cost management

TODO

### Change over time

As governance requirements of a workload change, you might need to move subscriptions to a different management group that best meets new workload needs. Consider building similar automation for some of these routine operations. Platform teams benefit from not only automating subscription creation effort, but also core and common brownfield subscription management operations.  Consider the following:

- Management group association changes
- Platform updates that [keep policies and policy initiatives up to date](/azure/cloud-adoption-framework/govern/resource-consistency/keep-azure-landing-zone-up-to-date#keep-policies-and-policy-initatives-up-to-date)
- Applying new [resource tagging](/azure/cloud-adoption-framework/govern/resource-consistency/tagging#enforce) requirements

## Variations

ITSM tool. Where things can shift. Goal is for the team to define a process flow. The flow above used this flow. You need to build a process flow and build subscription vending automation that executes that flow. [LINK to Jacks flow diagram here]

## Next steps

- [Bicep modules](https://aka.ms/lz-vending/bicep)
- [Terraform modules](https://aka.ms/lz-vending/tf)
