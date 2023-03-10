Subscriptions vending standardizes the process for requesting, deploying, and governing subscriptions for application landing zones. It places the subscription creation process under the governance of the platform, so application teams can focus on deploying their workloads with greater confidence and efficiency. You should automate as much of the subscription vending process as you can. This article provides core implementation guidance.

[![Diagram showing how the subscriptions vending fits in an organization.](images/sample-subscription-vending-architecture.png)](images/sample-subscription-vending-architecture.png)
*Figure 1. An example of how subscription vending facilitates subscription creation.*

## Architecture components

Your subscription vending automation needs to accomplish three tasks. (1) It should collect subscription request data and have a process to approve or deny requests. (2) A request approval should initiate your platform automation. (3) The platform automation should use the request data and infrastructure-as-code to create the subscription. The following diagram is an example of a Gitflow-based implementation.

[![Diagram showing the components of the subscription vending approach.](images/subscription-vending-components.png)](images/subscription-vending-components.png)

A Gitflow-based subscription vending process is a natural extension of the approach platform teams take to declaratively manage the platform.

## Collect data and approve

When an application team makes a subscription request, you need to collect enough data to automate the subscription vending process.

**Use a data collection tool.** You need to create a mechanism for application teams to request subscriptions and collect data. You can use an IT Service Management (ITSM) to collect the data or build a customer portal with a low-code / no-code tool like [Microsoft PowerApps](https://powerapps.microsoft.com/). The rest of this article assumes an ITSM tool is in use.

**Collect the required data.** The goal of data collection is to receive business approval and define the values of the subscription parameter file. The data collect tool capture as much detail as necessary to perform the business justification and subscription creation. You need to capture the request authorizer, cost center, networking requirements (internet and on-premises connectivity), key workload components (application platform, data requirements), data sensitivity, environment (development, test, pre-production, production), and any other required fields.

Your data collection tool should result in a logged and trackable request for a new subscription. For example, an ITSM generates a ticket. The request should contain all necessary data to fulfill the requirements of that subscription. You should bind business logic and authorization tracking to the request.

**Interface with other internal systems.** Where needed/possible, the ITSM tool should interface with other tools or systems in your organizations to programatically enrich the request with data from other systems. Identity, finance, security, networking.

A system like IPAM is just one example of an external system that may need to be interfaced with in this process. As part of the subscription request, expected network space and network line of sight requirements are often needed to be understood. If you have an IP address management tool, this intake process can validate available & appropriate IP space and reserve it.

It's ideal if your subscription request intake, processing, and tracking system is capable of orchestrating interactions like these at the data collection and approval step. If not, those interactions can then be handled in subsequent steps that involve creating custom workflows.

Once the request is through all ITSM-automated and any manual approval gates, then the automated subscription creation process can begin. Ideally, your ITSM tool can perform a push notification with the necessary data to start this process after approval is met. You might need a middleware layer, such as Azure Functions or Logic Apps, to initiate the process.

**OUTPUT** Upon approval, trigger with data transfer. With high-level needs such as subscription owner alias.

## Initiate platform automation

**input** notification to go with data to act on it.

Once subscription request data has been captured, validated, and ready to be acted on, the next step is to initiate platform automation. The goal is to get the collected subscription request data captured in a consistent format that can be used in deployment pipelines for the actual subscription creation.

We recommend implementing this Git-based process as a file-based, PR-driven, source-controlled flow.

**Use JSON or YAML files.** You should use structured data files (JSON or YAML) to store the data necessary to create a subscription. The structure of the file should be documented and extensible to support future needs.

[example] (networking, business unit code, tech and bio)

**Use one file per subscription.** Each subscription should get its own dedicated configuration file.  The subscription is the unit of deployment in the vending process.

**Use a pull request system.** The process that creates the subscription parameter file should automate the following:

1. Create a new branch for each subscription request
1. Use the data collected to create a YAML/JSON subscription parameter file for the new subscription in the branch
1. Create a pull request from your branch into `main`
1. Update ITSM tooling with state change and reference to this pull request

You should build this process as a pipeline to complement the Gitflow-based implementation. In the architecture component diagram, the *request pipeline* defines and executes this process. Each subscription request triggers this request pipeline and passes in the necessary parameters. Alternatively, this could be done as a code-based solution hosted in Azure if the workflow becomes sufficiently complex.

The platform team owns and maintains this implementation responsible for subscription creation in the organization.

**Perform request linting**. The pull request can trigger any automated linting process that you create to do automated validation on the request.  For example, ensuring that the IP ranges requested are still available & reserved in your IPAM system or making sure the YAML/JSON data file is correctly structured to prevent a garbage-in, garbage-out scenario. Push as much business validation up to the request collection process as possible, as a validation exception this late in the process is harder to address and need to be surfaced back into the request tracking system.

**Implement any necessary review gates.** The pull request becomes the first action signal for the platform team responsible for the subscription creation process. The assumption is that if this pull request is merged, the subscription will be created. To that end, a human-intervention gate can be added at this step for final reviews and potential last-minute alterations to the data file.

**Trigger deployment pipeline.** Once the PR merger to `main` is done, this will then initiate a continuous deployment pipeline to create the actual subscription. If no human-intervention gates are required and all linting builds are complete this could be an auto-merge PR.

**Output** Final and fully-approved subscription parameters necessary to create subscriptions. For example, mapped Owner RBAC role to subscription owner alias.

## Create subscription

**Input** everything deployment modules need to deploy. All parameters satisfied.

Up until this point, everything has been focused on capturing, reviewing, approving, and documenting the intent to have a subscription created, with as much automation as practical. This final phase is where the subscription is actually created and configured. This creation process should be automated.

The process picks up when the new subscription configuration data file merged into `main`.  This is the authoritative push notification to actually deploy new resources (subscription and base configuration) in Azure, final commits to external tracking systems (e.g. IPAM), and updating status in the ITSM tooling tracking this request.

**Use infrastructure as code.** Your deployments should use a declarative approach, using IaC templates that the platform subscription team creates and maintains, to describe the necessary Azure components to be deployed.

Use the Azure Landing Zone subscription vending implementations, available as [Bicep modules](https://aka.ms/lz-vending/bicep) and [Terraform modules](https://aka.ms/lz-vending/tf) as your starting point.

Like all of the automation so far, you should also use a CI/CD pipeline to orchestrate this resource creation and configuration phase. The pipeline will trigger based off of the merge to `main`. The pipeline is responsible for the following:

- Creating or updating any Azure AD resources to represent subscription ownership
- Creating and configuring the subscription. This includes items such as:
  - Management group placement
  - Subscription owner designation
  - Subscription-level RBAC to configured security groups
  - Microsoft Defender for Cloud enrollment
- Deploying and configuring any base resources required.  Some comment examples are:
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
