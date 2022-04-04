Modularizing your ARM template management enables you to reduce repetition, model best practices in infrastructure development, and have consistent standard deployments. 

An example use case for implementing this modularization is standardizing a virtual machine (VM) deployment with the metaphor of t-shirt sizes. Suppose you have deployed dozens or hundreds of VMs. Those deployments use version 1.0.0 of your templates and have a standard medium size of an older series. To transition to a new series might require a brief outage. By building version 1.5.0, you can deploy new infrastructure with the updated standard while keeping the old infrastructure in a deployable state. By having bold versions of the infrastructure available, your product and application teams have a known-good configuration to rely on while upgrading to the new version as they have time.

## The Layer Cake of Repositories (An Example for Enterprises)

When it comes to why you might want to have a strong preference for where your templates go, how they're updated, and so on, there are two primary considerations: _branching_ and _innersourcing_. 

- **Branching.** The following model is one method that enables you to branch according to a model that facilitates [Gitflow](https://jeffkreeftmeijer.com/git-flow/) or [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow).

- **Innersourcing.** The second is [innersourcing](https://resources.github.com/whitepapers/introduction-to-innersource/). You can more confidently share different templates and module source code without necessarily needing to worry about permissions for the deployment models themselves.

Bicep has the capability to use Azure Container Registry as a private registry for hosting versioned Azure Resource Manager templates (ARM templates). Using Container Registry this way allows an enterprise to have a process of continuous integration and continuous delivery (CI/CD) for infrastructure. Integration and unit tests can be run as part of the CI process, and upon a successful build, the module can be delivered to the container registry. App teams are then able to continue to use older versions until they're ready to upgrade, or they can update sooner to take advantage of features in the newer version of the template. 

In addition to this use of Container Registry, you can combine this model with something like the [Azure Bicep ResourceModules](https://github.com/Azure/ResourceModules). Your implementation could consume from the public registry, or preferably, monitor the public repositories and pull changes into your private registry for further use. Pulling changes into your own container registry allows your organization to run tests against public modules while ensuring that they aren't used in production until quality and security practices are incorporated.  

### Layers

The proposed model is one that stacks. As you move up the stack, you have more frequent deployments and more bespoke bicep code. Development teams will build from the services and infrastructure below their layers. Layers shouldn't reach _up_ the stack. This model creates _autonomy with alignment_, which means having:

- Common tools for enterprise ease (for example, everyone uses git for source control); everyone uses GitHub Actions for CI/CD, without overreaching (that is, we don't need to mandate all teams move to Bicep, they can use Terraform, ARM templates, and so on).

- The ability to share best practices. This could take the form of ARM templates, golden images, or code snippets. It could also take the form of documenting specific techniques. For example, how to rotate keys in our environment and how to test our code.

- Some services will move down the stack over time (for example, an app team may initially develop a template for deploying a Kubernetes cluster, which is eventually pulled into the product platform as a shared service. This template becomes so useful that it's pulled into the library of samples).

Layers

:::image type="content" alt-text="Diagram that shows the layers of development, ordered by development frequency. From layer 0 to 3 are global library, global infrastructure (globally shared services), product platform (shared services), and applications." source="media/enterprise-infrastructure-bicep-container-registry-layers.png":::

#### Layer 0 - Global Library

:::image type="content" alt-text="Screen shot of the folder structure of layer 0, global infrastructure library, with the 'arm' folder selected." source="media/enterprise-infrastructure-bicep-container-registry-layer-0.png":::
     
The bottom layer is the _global library_, which is a repository of useful tidbits that aren't deployed into production. From the perspective of access control, read access should be provided to anyone at the company who requests it. For changes, suggestions, and so on, your Cloud Center of Excellence (CCOE) would approve PRs and manage a backlog as if this were any other product.

This Layer 0 should _not_ contain:
- Templates deployed in production
- Secrets or environment-specific configurations

This Layer 0 _should_ contain:

- Code snippets (Python, C#, and so on)
- Azure Policy samples
- ARM templates, Bicep templates, or Terraform files that can be used as samples

An example of this would be a sample architecture for how your company would write a deployment for a three-tier application (including tags, networks, network security groups, and so on) without any environment-specific information. This is useful because not everything can be or needs to be put into a module, and trying to do so can result in over-parameterization. 

In addition, this layer could link to other known-good sources of sample code (for example, the Terraform Registry or [Azure Resource Modules](https://aka.ms/carml)). If your organization is going to start adopting code or a pattern from either of those sources, we recommend pulling into your own Layer 0 instead of pulling directly from the public sources. By relying on your Layer, you can write your own tests, tweaks, and security configurations. Not relying on public sources reduces the risk of something that your implementation requires being unexpectedly deleted.

To be considered good sample code, your templates and modules should follow good development practices, including input validation for security and organizational requirements. To maintain this level of rigor, you should add branch policies to the main branch to require pull requests (PRs) and code review for proposed changes that would result in changes flowing to the main container registry if merged. 

This layer feeds into Azure Pipelines or GitHub Actions to automatically create versioned artifacts in Azure Container Registry. You can build automation for git commit messages to implement [semantic versioning](https://semver.org) of the artifacts. For this to work correctly, you need to have a deterministic naming standard, such as \<service\>.bicep, to make the automation maintainable over time. As discussed earlier, with proper branch policies, you can also add integration tests as a prerequisite for code reviews. This can be instrumented through tools like Pester.

With such policies and protections in place, the container registry can be the source of truth for all infrastructure modules in the enterprise that are ready to use. Your organization should consider standardizing change logs, as well as indices of available code samples, to allow for discoverability of this code. Unknown code is unused code!  



#### Layer 1 - Global Infrastructure (Globally Shared Services)

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'policy' folders in layer 1, global infrastructure (globally shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-1.png":::

This layer is your repository for _your_ Azure landing zone constructs. While Microsoft supplies templates for the deployment of Azure landing zones, you'll want to modify certain components and supply a parameters file. This is analogous to the way that you pull public registry and module repositories into Layer 0, as described earlier.

Azure Container Registry is a critical part of this architecture. Even if your company has no plans to use containers, you must deploy Container Registry to be successful in versioning Bicep templates. Container Registry enables significant flexibility and reusability for your modules while providing enterprise-grade security and access control.  

Layer 1 should contain:
    
- Policy assignments and definitions that are applied at the level of management group or subscription and that match overall corporate governance requirements.
- Core Network templates (ExpressRoute, VPN (virtual private networks), Virtual WAN, shared or hub virtual networks)
- DNS
- Core monitoring (log analytics)
- Enterprise container registry
    
You should configure branch protection to restrict the ability to push changes to this repository. Restrict approval of PRs from other developers to members of the CCOE or Cloud Governance. Contributors to this layer are primarily members of groups that are historically associated with the components in this layer. For example, the networking team builds the templates for the network, the operations team configures monitoring, and so on. However, you should grant read-only access to individuals who request it. You want to enable developers from other groups to suggest changes to the core infrastructures if they believe they have better solutions, but you won't allow their changes to be merged without approval and testing.

These files should consume the modules in our container registry for standard components, but overall, there will be a Bicep file or series of Bicep files that are customized to your enterprise's implementation of Azure landing zones or a similar governance structure. 
    
#### Layer 2 - Product Platform (Shared Services)

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'platform-code' folders in layer 2, product platform (shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-2.png":::

You can consider Layer 2, product platform, as the shared services for a particular product line or business unit. These components aren't universal across the organization, but they're meant to fit a particular business need. This would be an appropriate layer for a virtual network that is a peer with the hub in Layer 1, global infrastructure. Another example is a key vault with shared secrets to a storage account or database that is shared by the different applications within this platform.

Layer 2 should contain:
    
- Policy assignments that are applied at a subscription or resource group to match product-specific requirements.
- ARM templates for key vaults, log analytics, SQL database (if various applications within the product use the database), Azure Kubernetes Service.
    
Permissions will be restricted for the ability to push changes to this repository. Like the other layers, you should use branch protection to make sure a product lead or owner can approve PRs from other developers. There are no fixed rules about read access to the product platform, but at a minimum, developers from any of the application teams should be granted read access to be able to suggest changes. Since this could contain some proprietary architecture, or similar information, you might choose to restrict access to those in the organization who use the platform. However, if that is the case, you'll want to ensure that you build a process of harvesting good practices and snippets from this repository to share with the global library, Layer 0. 
    
####  Layer 3 - Application

:::image type="content" alt-text="Screen shot of the contents of the 'app' and 'infrastructure' folders in layer 3, applications." source="media/enterprise-infrastructure-bicep-container-registry-layer-3.png":::

The application layer includes the components that are built on top of the product platform. These components deliver the features that the business requests—for example, for a streaming platform. One app could provide the search function while another, separate app provides recommendations. 

Layer 3 should contain:
    
- Application code in C#, Python, and so on
- Infrastructure for individual components (that is, only used in this application): functions, Azure Container Instance, Event Hubs.

Permissions are restricted for the ability to push changes to this repository. You should continue to use branch protection to enable a team member of this application to approve a PR made by another team member. Team members shouldn't be allowed to approve their own changes. Since this layer could contain proprietary architecture, business logic, or similar information, you might choose to restrict access to those in the organization who build this application. However, if that is the case, you should also build a process of harvesting good practices and snippets from this layer to share with the global library, Layer 0.


### Commonalities Across Layers

While this article describes some specific details for each layer, there are also some qualities for all layers that you should be sure to consider. 

Your infrastructure should operate as if it's an application. This means that you should have a continuous integration (CI) process in which new features are tested fully, with unit tests, smoke tests, and integration tests. You should only merge code into the main release branch that has passed these tests. 

You should also ensure that you have branch policies in place to prevent individuals from circumventing the process, even for expediency. If your CI process is seen as an impediment, it means that you have incurred technical debt that must be dealt with. It doesn't mean that you need to remove the policies and protections. 

Finally, though you might not have an index of all repositories and the code within, your organization should develop a process for individuals to request access to repositories. Certain rules could be fully automated—for example, because a user on the product team, she can be granted read access without review to any application under that product. Such rules can often be implemented with group-based membership and group-based role assignments in your environments. Configuring this kind of access should help to facilitate inner sourcing and organizational knowledge.

## Next steps

- [Design area: Platform automation and DevOps](/azure/cloud-adoption-framework/ready/landing-zone/design-area/platform-automation-devops)
- [Mature team structures](/azure/cloud-adoption-framework/organize/organization-structures)
- [What is Infrastructure as Code?](/devops/deliver/what-is-infrastructure-as-code)
- [Azure/ResourceModules](https://github.com/Azure/ResourceModules): This repository includes a CI platform for and collection of mature and curated Bicep modules. The platform supports both Azure Resource Manager and Bicep, and you can use its features with GitHub actions and Azure Pipelines.
- [Create private registry for Bicep module](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry?tabs=azure-powershell)
