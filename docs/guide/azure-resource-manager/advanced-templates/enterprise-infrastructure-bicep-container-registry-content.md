Modularizing your ARM template management will enable infrastructure developers to reduce repetition, model best practices, and have consistent standard deployments. 

An example use case for this would be standardizing a Virtual Machine deployment with "t-shirt" sizes. If you have deployed dozens or hundreds of machines using version 1.0.0 of your templates with a standard medium size of an older series, and you want to transition to a new series, that could require a brief outage. By building version 1.5.0, you can deploy new infrastructure with the updated standard, while keeping the old infrastructure in a deployable state. This then allows your product and application teams to have a known good configuration for the old infrastructure and the ability to upgrade on their own time.

## The Layer Cake of Repositories (An Example for Enterprises)

When it comes to why you might want to have a strong preference for where your templates go, how they are updated, etc., there are two primary considerations. The first is branching — the following model is one method that will allow you to be able to branch according to a model that facilitates [GitFlow](https://jeffkreeftmeijer.com/git-flow/) or [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow). The second is [innersourcing](https://resources.github.com/whitepapers/introduction-to-innersource/). You can more confidently share different templates and module source code without necessarily needing to worry about permissions for the deployment models themselves.

ARM Bicep has the capability to leverage an Azure Container Registry as a private registry for hosting versioned templates. This allows an enterprise to have a CI/CD (Continuous Integration and Continuous Delivery) process for infrastructure. Integration and unit tests can be run as part of the CI process, and upon a successful build, the module can be delivered to the container registry. Individual app teams are then able to continue to leverage older versions until they are ready to upgrade or can update sooner to take advantage of new features in the newer template version. 

In addition to this, an organization can combine this model with something like the [Azure Bicep ResourceModules](https://github.com/Azure/ResourceModules). This could work either by consuming from the public registry, or, preferably, by monitoring the public repositories and pulling changes into your private registry for further use. Pulling into your own registry allows your organization to run tests against public modules while ensuring they aren't used in production until quality and security practices are incorporated.  

### Layers

The proposed model is one that stacks. As you move up the stack, you have more frequent deployments and more bespoke bicep code. Development teams will build from the services/infrastructure below their layers. Layers should not reach **up** the stack. This model creates _autonomy with alignment_. What that means is that we have:

- Common tools for enterprise ease (e.g., everyone uses git for source control; everyone uses GitHub Actions for CI/CD, without overreaching (i.e., we don't need to mandate all teams move to bicep, they can use Terraform, ARM JSON templates, etc.).

- The ability to share best practices. This could take the form of ARM templates, golden images, or code snippets. It could also take the form of documenting specific techniques (how do we rotate keys in our environment? how do we test our code?).

- Some services will move down the stack over time (e.g., an app team may initially develop a template for deploying a Kubernetes cluster, which is eventually pulled into the product platform as a shared service. This template becomes so useful that it is pulled into the library of samples).

Layers

:::image type="content" alt-text="Diagram that shows the layers of development, ordered by development frequency. From layer 0 to 3 are global library, global infrastructure (globally shared services), product platform (shared services), and applications." source="media/enterprise-infrastructure-bicep-container-registry-layers.png":::

#### Layer 0 - Global Library

:::image type="content" alt-text="Screen shot of the folder structure of layer 0, global infrastructure library, with the 'arm' folder selected." source="media/enterprise-infrastructure-bicep-container-registry-layer-0.png":::
     
The bottom layer is the _global library_, which is a repository of useful tidbits that aren't deployed into production. From an access control perspective, read access should be provided to anyone at the company who requests it. For changes, suggestions, etc. your Cloud CoE would approve pull requests and manage a backlog as if this were any other product.

This layer should not contain:
- Templates deployed in production
- Secrets / environment specific configurations

This layer should contain:

- Code Snippets (Python, C#, etc.)
- Azure Policy Samples
- ARM JSON or Bicep Templates or Terraform files that can be used as samples

An example of this would be a sample architecture for how your company would write a deployment for a three-tier application (including tags, networks, network security groups, etc.) without any environment-specific information. This is useful because not everything can be or needs to be put into a module, as this can cause over-parameterization. 


In addition, this layer could link to other known good sources of sample code (e.g., the Terraform Registry or [Azure Resource Modules](https://aka.ms/carml)). If the organization is going to start adopting code or a pattern from either of those sources, it would be recommended to pull into your own Layer 0 instead of pulling directly from the public sources. This would allow you to write your own tests, tweaks, and security configurations as well as reducing the risk of something being deleted.

To be considered good sample code, your templates and modules should follow good development practices, including input validation for security as well as organizational requirements. To maintain this level of rigor, branch policies should be added to the main branch to require pull requests and code review before merging changes that would result in changes flowing to the main ACR. 

    
This layer will feed into Azure DevOps pipelines or GitHub Actions to automatically create versioned artifacts in the Azure Container Registry. Automation can be built around git commit messages to implement [Semantic Versioning](https://semver.org) of the artifacts. In order for this to work correctly, you will need to have a deterministic naming standard (such as \<service\>.bicep) to make the automation maintainable over time. As discussed above, with proper branch policies, we can also add integration tests as a prerequisite before code reviews. This can be instrumented through tools like Pester.

With this in place, ACR can then become the source of truth for all ready to use infrastructure modules in the enterprise. Your organization should consider standardizing change logs as well as indices of available code samples to allow for discoverability of this code – unknown code is unused code!  



#### Layer 1 - Global Infrastructure (Globally Shared Services)

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'policy' folders in layer 1, global infrastructure (globally shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-1.png":::

This layer is as your repository for YOUR Azure landing zone constructs. While Microsoft supplies templates for the deployment of Azure landing zones, you will undoubtedly want to tweak certain components as well as supply a parameters file. This is analogous to the way we pulled public registry/module repositories into Layer 0 above.

The Azure Container Registry is a critical part of this architecture, even if your company has no plans to use containers, you will need to deploy ACR to be successful with versioning bicep templates. Azure Container Registry allows for an immense amount of flexibility and reusability for your modules while providing enterprise-grade security and access control.  

This will contain:
    
- Policy assignments and definitions that are applied at management group/subscription level that match overall corporate governance requirements.
- Core Network templates (ExpressRoute, VPN (virtual private networks), Virtual WAN, shared or hub virtual networks)
- DNS
- Core monitoring (log analytics)
- Enterprise Container Registry
    
Permissions will be restricted for the ability to push changes to this repository. You should use branch protection to make it so a member of the Cloud CoE or Cloud Governance can approve pull requests from other developers. Contributors to this section would primarily be the groups historically associated with the components above (e.g., the networking team would build the templates for the network, the operations team would configure monitoring, etc.). However, read-only access should be granted to individuals who request it. You'll want to enable developers from other groups to suggest changes to the core infrastructures if they believe they have a better way, but you wouldn't allow their changes to go through without approval and testing.

These files should consume the modules in our container registry for standard components, but overall there will be a bicep file or series of bicep files that are customized to the enterprise's implementation of Azure landing zones or a similar governance structure. 
    
#### Layer 2 - Product Platform (Shared Services)

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'platform-code' folders in layer 2, product platform (shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-2.png":::

The product platform layer can be seen as the shared services for a particular product line or business unit. These components are not universal across the organization, but are meant to fit a particular business need. This would be a fitting space for a virtual network that peers back to the hub in the global shared services layer. Another example would be a key vault with shared secrets to a storage account or database that is shared by the different applications within this platform.

This will contain:
    
- Policy assignments that are applied at a subscription/resource group to match product specific requirements.
- ARM Templates for Key Vaults, Log Analytics, SQL Database (if used across different applications within the product), AKS (Azure Kubernetes Service).
    
Permissions will be restricted for the ability to push changes to this repository. Like the other layers, you should use branch protection to make sure a product lead or owner can approve pull requests from other developers. There are no fixed rules about read access to the product platform, but at a minimum, developers from any of the application teams should be granted read access to be able to suggest changes at the product platform level. Since this could contain some proprietary architecture decisions or similar information, it could be justified to restrict those in the organization not using the platform. However, if that is the case, you'll want to ensure that you build a process of harvesting good practices and snippets from this repository to share into the global library. 
    
####  Layer 3 - Application

:::image type="content" alt-text="Screen shot of the contents of the 'app' and 'infrastructure' folders in layer 3, applications." source="media/enterprise-infrastructure-bicep-container-registry-layer-3.png":::

The application layer is the components built on top of the product platform that deliver features requested by the business. As an example, if we made a streaming platform, the search feature could be its own app and the recommendation feature could be a separate application. 

This layer will contain:
    
- Application code (i.e., the actual C#, Python, etc.)
- Infrastructure for individual (i.e., only used in this application) components: functions, Azure Container Instance, Event Hub.

Permissions will be restricted for the ability to push changes to this repository. You should continue to use branch protection to make it so a team member of this application can approve a pull request made by a different team member. Team members should not be allowed to approve their own changes. Since this could contain some more proprietary architecture decisions, business logic, or similar information, it is often justified to restrict those in the organization not building this application. However, if that is the case, you'll want to ensure that we build a process of harvesting good practices and snippets from this repo to share into the global library.


### Commonalities Across Layers

There are some specifics that were called out in each layer, but there are some common pieces to ensure you are considering regardless of the layer you operate at. Your infrastructure should operate as if it were an application. This means that you should have a continuous integration (CI) process where new features are tested fully, with unit tests, smoke tests, and integration tests. Code should only be allowed to merge into the main release branch when it has passed these tests. 

You should also ensure that you have branch policies in place to avoid individuals circumventing the process for expediency. If your CI process is seen as an impediment, that means that you have incurred technical debt that must be dealt with, not that you need to remove all guardrails. 

Finally, though you may not have an index of all repositories and the code within, your organization should develop a process for requesting access to repositories. Certain rules could be fully automated (e.g., userA is on the product team, she can be granted read access to any application under that product without review). This can often be implemented with group-based membership and group-based role assignments in your environments. This process should help to facilitate inner sourcing and organizational knowledge.

See Also

- [Design area: Platform automation and DevOps](/azure/cloud-adoption-framework/ready/landing-zone/design-area/platform-automation-devops)
- [Mature team structures](/azure/cloud-adoption-framework/organize/organization-structures)
- [What is Infrastructure as Code?](/devops/deliver/what-is-infrastructure-as-code)
- [Azure/ResourceModules](https://github.com/Azure/ResourceModules): This repository includes a CI platform for and collection of mature and curated Bicep modules. The platform supports both ARM and Bicep and can be leveraged using GitHub actions as well as Azure DevOps pipelines.
- [Create private registry for Bicep module](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry?tabs=azure-powershell)
