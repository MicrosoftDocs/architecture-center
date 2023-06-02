---
ms.custom:
  - devx-track-bicep
---
Modularizing the management of your Azure Resource Manager templates (ARM templates) enables you to reduce repetition, model best practices in infrastructure development, and have consistent standard deployments. 

An example use case for implementing this kind of modularization is deployment of virtual machines (VMs) by using the metaphor of t-shirt sizes. Suppose you have deployed dozens or hundreds of VMs. Those deployments use version 1.0.0 of your templates and have a standard *medium* size of an older series. To transition to a new series might require a brief outage of service if you simply deployed new templates. However, by building version 1.5.0 and using modularization, you can deploy new infrastructure with the updated standard while keeping the old infrastructure in a deployable state. By having old versions of the infrastructure available, your product and application teams have a known good configuration to rely on while upgrading to the new version as they have time.

## The layer cake of repositories: An example for enterprises

When it comes to why you might want to have a strong preference for where your templates go, how they're updated, and so on, there are two primary considerations: *branching* and *innersourcing*. 

- **Branching.** This example scenario facilitates git branching models that support [Gitflow](https://jeffkreeftmeijer.com/git-flow/) and [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow). For more information about Gitflow, see [Using git-flow to automate your git branching workflow](https://jeffkreeftmeijer.com/git-flow/), a blog post by Jeff Kreeftmeijer. For more information about GitHub flow, see [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow) in the GitHub documentation.

- **Innersourcing.** The second is *innersourcing*, which brings the collaborative practices of open-source software development to in-house development. In such a scenario, you can more confidently share different templates and module source code without necessarily needing to worry about permissions for the deployment models themselves. For more information about innersource development, see [An introduction to innersource](https://resources.github.com/whitepapers/introduction-to-innersource/) on GitHub, 

Bicep is a declarative language for deploying Azure resources. Bicep's reusable code can use Azure Container Registry as a private registry for hosting versioned ARM templates. By using Container Registry this way, your enterprise can have a process of continuous integration and continuous delivery (CI/CD) for infrastructure. You can run integration and unit tests as part of the CI process, and the container registry can receive modules after they're successfully built. App teams can continue to use older versions until they're ready to upgrade, or they can update to take advantage of features in the newer versions of templates. 

In addition to this use of Container Registry, you can combine this model with something like the [Azure Bicep ResourceModules](https://github.com/Azure/ResourceModules). Your implementation could consume from the public registry, or preferably, monitor the public repositories and pull changes into your private registry for further use. Pulling changes into your own container registry allows you to run tests against public modules while ensuring that they aren't used in production until quality and security practices are incorporated.  

### Layers

The model that's proposed in this example scenario is one that stacks. Layers nearer the top of the stack have more frequent deployments and deployments that are more bespoke. Bicep code provides consistent deployments. Development teams, working in the layers for their contributions, build from the services and infrastructure that are provided in the layers below. Nothing in a lower layer should rely on resources in a layer above. From layer 0 to 3 are global library, global infrastructure (globally shared services), product platform (shared services), and applications.

:::image type="content" alt-text="Diagram that shows the layers of development, ordered by development frequency." source="media/enterprise-infrastructure-bicep-container-registry-layers.png":::

This model creates *autonomy with alignment*, which means having:

- Common tools for enterprise ease. For example, everyone uses git for source control, and everyone uses GitHub Actions for CI/CD. However, we don't overreach. For example, we don't mandate that all teams use Bicep; they can use Terraform, ARM templates, and other tools.

- The ability to share best practices. They could take the form of ARM templates, golden images, or code snippets. Best practices can also be documentation of specific techniques. For example, how to rotate keys in your environment and how to test code.

- Some services move downward in the stack. For example, an app team may initially develop a template for deploying a Kubernetes cluster, which is later pulled into the product platform as a shared service. This template becomes so useful that it's pulled into the library of samples.


#### Layer 0 - Global library

The bottom layer is the *global library*, which is a repository of useful tidbits that aren't deployed into production. From the perspective of access control, read access should be provided to anyone at the company who requests it. For changes, suggestions, and so on, your Cloud Center of Excellence (CCoE) approves PRs and manage a backlog as if this were any other product.

:::image type="content" alt-text="Screen shot of the folder structure of layer 0, global infrastructure library, with the 'arm' folder selected." source="media/enterprise-infrastructure-bicep-container-registry-layer-0.png":::
     
Layer 0 should *not* contain:
- Templates that are deployed in production.
- Secrets or environment-specific configurations.

Layer 0 *should* contain:

- Code snippets (in Python, C#, and so on).
- Azure Policy samples.
- ARM templates, Bicep templates, or Terraform files that can be used as samples.

An example of this is a sample architecture for how your company would write a deployment for a three-tier application without any environment-specific information. This sample architecture could include tags, networks, network security groups, and so on. Leaving out specific information for the environment is useful, because not everything can be or needs to be put into a module. Trying to do so can result in over-parameterization. 

In addition, Layer 0 could link to other known good sources of sample code, such as the Terraform Registry or [Azure Resource Modules](https://aka.ms/carml)). If your organization adopts code or a pattern from either of those sources, we recommend pulling the code or pattern into your own Layer 0 instead of pulling directly from the public sources. By relying on your Layer 0, you can write your own tests, tweaks, and security configurations. By not relying on public sources, you reduce the risk of relying on something that could be unexpectedly deleted.

To be considered good sample code, your templates and modules should follow good development practices, including input validation for security and for organizational requirements. To maintain this level of rigor, you should add policies to the main branch to require pull requests (PRs) and code reviews for proposed changes that would result in changes flowing to the main container registry if merged. 

Layer 0 feeds into Azure Pipelines or GitHub Actions to automatically create versioned artifacts in Azure Container Registry. You can build automation for git commit messages to implement [semantic versioning](https://semver.org) of the artifacts. For this to work correctly, you need to have a deterministic naming standard, such as \<service\>.bicep, to make the automation maintainable over time. With proper branch policies, you can also add integration tests as a prerequisite for code reviews. You can instrument this by using tools like Pester.

With such policies and protections in place, the container registry can be the source of truth for all infrastructure modules in the enterprise that are ready to use. You should consider standardizing change logs, as well as indices of available code samples, to allow for discoverability of this code. Unknown code is unused code!


#### Layer 1 - Global infrastructure: Globally shared services

Layer 1 is the repository for *your* Azure landing zone constructs. While Microsoft supplies templates for the deployment of Azure landing zones, you'll want to modify certain components and supply a parameters file. This is analogous to the way that you pull public registry and module repositories into Layer 0, as described earlier.

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'policy' folders in layer 1, global infrastructure (globally shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-1.png":::

Azure Container Registry is a critical part of this architecture. Even if your company has no plans to use containers, you must deploy Container Registry to succeed in versioning Bicep templates. Container Registry enables significant flexibility and reusability for your modules while providing enterprise-grade security and access control.  

Layer 1 should contain:
    
- Policy assignments and definitions that are applied at the level of management group or subscription. These policies should match your corporate governance requirements.
- Templates for core network infrastructure, such as ExpressRoute, VPNs, virtual WAN, and virtual networks (shared or hub).
- DNS.
- Core monitoring (log analytics).
- Enterprise container registry.
    
You should configure branch protection to restrict the ability to push changes to this repository. Restrict approval of PRs from other developers to members of the CCoE or Cloud Governance. Contributors to this layer are primarily members of groups that are historically associated with the components in this layer. For example, the networking team builds the templates for the network, the operations team configures monitoring, and so on. However, you should grant read-only access to individuals who request it, because you want to enable developers from other groups to suggest changes to the core infrastructures. They may contribute improvements, though you won't allow their changes to be merged without approval and testing.

These files should consume the modules in your container registry for standard components. However, you'll also have a Bicep file, or a series of Bicep files, that are customized to your enterprise's implementation of Azure landing zones or a similar governance structure. 
    
#### Layer 2 - Product platform: Shared services

You can consider Layer 2, product platform, as the shared services for a particular product line or business unit. These components aren't universal across the organization, but they're meant to fit a particular business need. This would be an appropriate layer for a virtual network that's a peer with the hub in Layer 1, global infrastructure. A key vault is another example component for this layer. The key vault could store shared secrets to a storage account or a database that's shared by the different applications within this platform.

:::image type="content" alt-text="Screen shot of the contents of the 'infrastructure' and 'platform-code' folders in layer 2, product platform (shared services)." source="media/enterprise-infrastructure-bicep-container-registry-layer-2.png":::

Layer 2 should contain:
    
- Policy assignments that are applied at a subscription or resource group to match product-specific requirements.
- ARM templates for key vaults, log analytics, an SQL database (if various applications within the product use the database), and Azure Kubernetes Service.
    
You should implement permissions that restrict the ability to push changes to this repository. Like the other layers, you should use branch protection to make sure a product lead or owner can approve PRs from other developers. There are no fixed rules about read access to the product platform, but at a minimum, developers from any of the application teams should be granted read access to be able to suggest changes. Since Layer 2 could contain some proprietary architecture, or similar information, you might choose to restrict access to those in the organization who use the platform. However, if that's the case, you'll want to ensure that you build a process of harvesting good practices and snippets from this repository to share with the global library, Layer 0. 
    
####  Layer 3 - Application

Layer 3, the application layer, includes the components that are built on top of the product platform. These components deliver the features that the business requests. For example, for a streaming platform, one app could provide the search function while a different app provides recommendations. 

:::image type="content" alt-text="Screen shot of the contents of the 'app' and 'infrastructure' folders in layer 3, applications." source="media/enterprise-infrastructure-bicep-container-registry-layer-3.png":::

Layer 3 should contain:
    
- Application code in C#, Python, and so on.
- Infrastructure for individual components (that's, only used in this application): functions, Azure Container Instances, Event Hubs.

Permissions are restricted for the ability to push changes to this repository. You should use branch protection to enable a team member of this application to approve a PR made by another team member. Team members shouldn't be allowed to approve their own changes. Since this layer could contain proprietary architecture, business logic, or similar information, you might choose to restrict access to those in the organization who build this application. However, if that's the case, you should also build a process of harvesting good practices and snippets from this layer to share with the global library, Layer 0.


### Commonalities across layers

While this article describes some specific details for each layer, there are also some qualities for all layers that you should be sure to consider. 

Your infrastructure should operate as if it's an application. This means that you should have a continuous integration (CI) process in which new features are tested fully, with unit tests, smoke tests, and integration tests. You should merge only code that passes these tests into the main release branch. 

You should also ensure that you have branch policies in place to prevent individuals from circumventing the process, even for expediency. If your CI process is seen as an impediment, it means that you have incurred technical debt that must be dealt with. It doesn't mean that you need to remove the policies and protections. 

Finally, though you might not have an index of all repositories and the code within them, your organization should develop a process for individuals to request access to repositories. Certain rules could be fully automated. For example, you could implement a rule that grants read access, without review, to a contributor who is on the product team for any application under that product. Such rules can often be implemented with group-based membership and group-based role assignments in your environments. Configuring this kind of access should help to facilitate inner sourcing and organizational knowledge.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Tim Sullivan](https://www.linkedin.com/in/tjsullivan1/) | Senior Cloud Solution Architect

Other contributors:

 * [Gary Moore](https://www.linkedin.com/in/gwmoore/) | Programmer/Writer
 

## Next steps

- [Design area: Platform automation and DevOps](/azure/cloud-adoption-framework/ready/landing-zone/design-area/platform-automation-devops)
- [Mature team structures](/azure/cloud-adoption-framework/organize/organization-structures)
- [What is Infrastructure as Code?](/devops/deliver/what-is-infrastructure-as-code)
- [Azure/ResourceModules](https://github.com/Azure/ResourceModules): This repository includes a CI platform for and collection of mature and curated Bicep modules. The platform supports both Azure Resource Manager and Bicep, and you can use its features with GitHub actions and Azure Pipelines.
- [Create private registry for Bicep module](/azure/azure-resource-manager/bicep/private-module-registry?tabs=azure-powershell)

## Related resources

- [Azure DevTest Labs reference architecture for enterprises](../../../example-scenario/infrastructure/devtest-labs-reference-architecture.yml)
- [Build a CI/CD pipeline for chatbots with ARM templates](../../../example-scenario/apps/devops-cicd-chatbot.yml)
- [CI/CD pipeline for container-based workloads](../../../guide/aks/aks-cicd-github-actions-and-gitops.yml)
- [Design a CI/CD pipeline using Azure DevOps](../../../example-scenario/apps/devops-dotnet-baseline.yml)
- [DevSecOps for Infrastructure as Code (IaC)](../../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)
- [Microservices with AKS and Azure DevOps](../../../guide/aks/aks-cicd-azure-pipelines.yml)
