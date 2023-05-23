This article describes how to manage virtual machine compliance without impairing DevOps practices. Use Azure VM Image Builder and Azure Compute Gallery to minimize risk from system images.

## Architecture

The solution consists of two processes:

- The golden image publishing process
- The process of tracking virtual machine (VM) compliance

:::image type="content" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Architecture diagram showing how the solution manages Azure Marketplace images. Illustrated steps include customization, tracking, testing, and publishing." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-golden-image-publishing-architecture.vsdx) of this architecture.*

### Dataflow

The golden image publishing process runs monthly and contains these steps:

1. The process captures a base image from Azure Marketplace.
1. VM Image Builder customizes the image.
1. The process of image tattooing tracks image version information like the source and publish date.
1. Automated tests validate the image.
1. If the image fails any tests, it returns to the customization step for repairs.
1. The process publishes the finalized image.
1. Compute Gallery makes the image available to DevOps teams.

:::image type="content" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Architecture diagram showing how the solution manages compliance by assigning policy definitions, evaluating machines, and displaying data in a dashboard." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-track-compliance-architecture.vsdx) of this architecture.*

The process of tracking VM compliance contains these steps:

1. Azure Policy assigns policy definitions to VMs and evaluates the VMs for compliance.
1. Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.

### Components

- [VM Image Builder][Azure VM Image Builder] is a managed service for customizing system images. This service builds and distributes the images that DevOps teams use.

- [Compute Gallery][Azure Compute Gallery] helps you structure and organize custom images. By storing images in repositories, this service provides controlled access to the images. Users can be within and outside your organization.

- [Azure Policy][Azure Policy and the policy dashboard] offers policy definitions. You can use these definitions to enforce your organization's standards and to assess compliance at scale. The Azure Policy dashboard displays results from Azure Policy evaluations. This data keeps you informed about the compliance status of your resources.

- The [Azure Automanage Machine Configuration feature of Azure Policy][Azure Automanage Machine configuration] provides a way to dynamically audit or assign configurations to machines through code. The configurations generally include environment or operating system settings.

### Alternatives

- You can use a third-party tool to manage compliance. But with this type of tool, you usually need to install an agent on the target VM. You also may have to pay a licensing fee.

- You can use [custom script extensions][Custom Script Extensions] for installing software on VMs or configuring VMs after deployment. But each VM or Virtual Machine Scale Set can only have one custom script extension. And if you use custom script extensions, you prevent DevOps teams from customizing their applications.

## Scenario details

Each enterprise has its own compliance regulations and standards. Regarding security, each company has its own risk appetite. Security standards can differ from one organization to another and from one region to another.

Following differing standards can be more challenging in dynamically scaling cloud environments than in on-premises systems. When teams use DevOps practices, there are usually fewer restrictions on who can create Azure resources like VMs. This fact complicates compliance challenges.

By using Azure Policy and role-based access control assignments, enterprises can enforce standards on Azure resources. But with VMs, these mechanisms only affect the control plane, or the route to the VM. The system images that run on a VM still pose a security threat. Some companies prevent developers from accessing VMs. This approach impairs agility, making it difficult to follow DevOps practices.

This article presents a solution for managing the compliance of VMs that run on Azure. Besides tracking compliance, the solution also minimizes the risk from system images that run on VMs. At the same time, the solution is compatible with DevOps practices. Core components include Azure VM Image Builder, Azure Compute Gallery, and Azure Policy.

### Potential use cases

This solution applies to organizations with Azure [landing zones][What is an Azure landing zone?] that complete these tasks:

- Supplying *golden images* to DevOps teams. A golden image is the published version of a marketplace image.
- Testing and validating images before making them available to DevOps teams.
- Tracking which image each DevOps team uses.
- Enforcing company standards without degrading productivity.
- Ensuring that DevOps teams use the latest image versions.
- Managing the compliance of *pet servers*, which are maintenance intensive, and *cattle servers*, which are easily replaceable.

### Approach

The following sections provide a detailed description of the solution's approach.

#### Identify pets and cattle

DevOps teams use an analogy called pets and cattle to define service models. To track a VM's compliance, first determine whether it's a pet or cattle server:

- Pets require significant attention. They're not easy to dispense. Recovering a pet server requires investing a considerable amount of time and financial resources. For example, a server that runs SAP might be a pet. Besides the software that runs on the server, other considerations can also determine the service model. If you have a low failure tolerance, production servers in real-time and near real-time systems can also be pets.
- Cattle servers are part of an identical group. You can replace them easily. For example, VMs that run in a Virtual Machine Scale Set are cattle. If there are enough VMs in the set, your system keeps running, and you don't need to know each VM's name. Testing environment servers that meet the following conditions provide another example of cattle:

  - You use an automated procedure to create the servers from scratch.
  - After you finish running the tests, you decommission the servers.

An environment might contain only pet servers, or it might contain only cattle servers. In contrast, a set of VMs in an environment could be pets. A different set of VMs in that same environment could be cattle.

To manage compliance:

- Pet compliance can be more challenging to track than cattle compliance. Usually, only DevOps teams can track and maintain the compliance of pet environments and servers. But this article's solution increases the visibility of each pet's status, making it easier for everyone in the organization to track compliance.
- For cattle environments, refresh the VMs and rebuild them from scratch regularly. Those steps should be adequate for compliance. You can align this refresh cycle with your DevOps team's regular release cadence.

#### Restrict images

Don't allow DevOps teams to use Azure Marketplace VM images. Only allow VM images that Compute Gallery publishes. This restriction is critical for ensuring VM compliance. You can use a custom policy in Azure Policy to enforce this restriction. For a sample, see [Allow image publishers][Only allow certain image publishers from the Marketplace].

As part of this solution, VM Image Builder should use an Azure Marketplace image. It's essential to use the latest image that's available in Azure Marketplace. Apply any customizations on top of that image. Azure Marketplace images are refreshed often, and each image has certain preset configurations, ensuring your images are secure by default.

#### Customize images

A golden image is the version of a marketplace image that's published to Compute Gallery. Golden images are available for consumption by DevOps teams. Before the image is published, customization takes place. Customization activities are unique to each enterprise. Common activities include:

- Operating system hardening.
- Deploying custom agents for third-party software.
- Installing enterprise certificate authority (CA) root certificates.

You can use VM Image Builder to customize images by adjusting operating system settings and by running custom scripts and commands. VM Image Builder supports Windows and Linux images. For more information on customizing images, see [Azure Policy Regulatory Compliance controls for Azure Virtual Machines][Azure Policy Regulatory Compliance controls for Azure Virtual Machines].

#### Track image tattoos

Image tattooing is the process of keeping track of all image versioning information that a VM uses. This information is invaluable during troubleshooting and can include:

- The original source of the image, such as the name and version of the publisher.
- The operating system version string, which you need if there's an in-place upgrade.
- The version of your custom image.
- Your publish date.

The amount and type of information that you track depends on your organization's compliance level.

For image tattooing on Windows VMs, set up a custom registry. Add all required information to this registry path as key-value pairs. On Linux VMs, enter image tattooing data into environment variables or a file. Put the file in the `/etc/` folder, where it doesn't conflict with developer work or applications. If you'd like to use Azure Policy to track the tattooing data or report on it, store each piece of data as a unique key-value pair. For information on determining the version of a Marketplace image, see [How to find a Marketplace image version][How to find a Marketplace image version].

#### Validate golden images with automated tests

Generally, you should refresh golden images monthly to stay current with the latest updates and changes in Azure Marketplace images. Use a recurrent testing procedure for this purpose. As part of the image creation process, use an Azure pipeline or other automated workflow for testing. Set up the pipeline to deploy a new VM for running tests before the beginning of each month. The tests should confirm pared images before publishing them for consumption. Automate tests by using a test automation solution or by running commands or batches on the VM.

Common test scenarios include:

- Validating the VM boot time.
- Confirming any customization of the image, such as operating system configuration settings or agent deployments.

A failed test should interrupt the process. Repeat the test after addressing the root cause of the problem. If the tests run without problem, automating the testing process reduces the effort that goes into maintaining an evergreen state.

#### Publish golden images

Publish final images on Compute Gallery as a managed image or as a virtual hard disk (VHD) that DevOps teams can use. Mark any earlier images as aged. If you haven't set an end-of-life date for an image version in Compute Gallery, you might prefer to discontinue the oldest image. This decision depends on your company's policies.

For information on limits that apply when you use Compute Gallery, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery - Limits].

Another good practice is to publish the latest images across different regions. With Compute Gallery, you can manage the lifecycle and replication of your images across different Azure regions.

For more information on Compute Gallery, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery].

#### Refresh golden images

When an image is used for an application, it can be hard to update the underlying operating system image with recent compliance changes. Strict business requirements can complicate the process of refreshing the underlying VM. Refreshing is also complex when the VM is critical to the business.

Because cattle servers are dispensable, you can coordinate with DevOps teams to refresh these servers in a planned maintenance window as a business-as-usual activity.

It's more challenging to refresh pet servers. Discontinuing an image can put applications at risk. In scale-out scenarios, Azure can't find the respective images, resulting in failures.

Consider these guidelines when refreshing pet servers:

- For best practices, see [Overview of the reliability pillar][Overview of the reliability pillar] in the Azure Well-Architected Framework.
- To streamline the process, see the principles that these documents discuss:

  - [Deployment Stamps pattern][Deployment Stamps pattern]
  - [Geode pattern][Geode pattern]
  - [Bulkhead pattern][Bulkhead pattern]

- Tag each pet server as a pet. Configure a policy in Azure Policy to take this tag into account during refreshes.

#### Improve visibility

Generally, you should use Azure Policy to manage any control-plane compliance activity. You can also use Azure Policy for:

- Tracking VM compliance.
- Installing Azure agents.
- Capturing diagnostic logs.
- Improving the visibility of VM compliance.

Use the Azure Automanage Machine Configuration feature of Azure Policy to audit the configuration changes that you make during image customization. When drift occurs, the Azure Policy dashboard lists the affected VM as non-compliant. Azure Policy can use image tattooing information to track when you use outdated images or operating systems.

Audit pet servers for each application. By using Azure Policies with an audit effect, you can improve the visibility of these servers. Adjust the audit process according to your company's risk appetite and internal risk management processes.

Each DevOps team can track its applications' compliance levels in the Azure Policy dashboard and take appropriate corrective actions. When you assign these policies to a management group or a subscription, give the assignment description a URL that leads to a company-wide wiki. You can also use a short URL like `aka.ms/policy-21`. In the wiki, list the steps that DevOps teams should take to make their VMs compliant.

IT risk managers and security officers can also use the Azure Policy dashboard to manage company risks according to their company's risk appetite.

By using the Azure Automanage Machine configuration feature of Azure Policy with remediation options, you can apply corrective actions automatically. But interrogating a VM frequently or making changes on a VM that you use for a business-critical application can degrade performance. Plan remediation actions carefully for production workloads. Give a DevOps team ownership of application compliance in all environments. This approach is essential for pet servers and environments, which are usually long-term Azure components.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability 

You can configure the number of replicas that Compute Gallery stores of each image. A higher number of replicas minimizes the risk of throttling when you provision multiple VMs simultaneously. For general guidance on scaling and configuring an appropriate number of replicas, see [Scaling for Azure Compute Gallery][Scaling for Azure Compute Gallery].

### Resiliency 

This solution uses managed components that are automatically resilient at a regional level. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][Designing resilient applications for Azure].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Unless you use a third-party service such as Ansible or Terraform, this approach is nearly free of charge. Storage and egress costs might apply. Other potential charges involve these components:

- Azure Policy and [Azure Automanage Machine configuration][Azure Automanage Machine configuration] are free of charge for Azure resources. If your company uses a hybrid approach, there are extra charges for Azure Arc resources.
- During the public preview period, [VM Image Builder][Azure VM Image Builder - pricing] is using a single compute instance type with 1 vCPU and 3.5 GB of RAM. Charges might apply for data storage and transfer.
- [Compute Gallery][Azure Shared Image Galleries] has no charges except:

  - The cost of storing replicas.
  - Network egress charges for replicating images.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Yunus Emre Alpozen](https://www.linkedin.com/in/yemre) | Program Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure landing zone][Azure landing zone]
- [Control and audit your resources by using Azure Policy][Control and audit your resources by using Azure Policy]
- [Azure VM Image Builder][Azure VM Image Builder]
- [Azure Compute Gallery][Azure Compute Gallery]
- [Azure Policy and the policy dashboard][Azure Policy and the policy dashboard]
- [Azure Automanage Machine Configuration][Azure Automanage Machine configuration]

## Related resources

- [DevTest and DevOps for IaaS solutions][DevTest and DevOps for IaaS solutions]
- [DevSecOps on AKS][DevSecOps on AKS]
- [A computer-aided engineering service][A computer-aided engineering service]

[Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[Azure VM Image Builder]: /azure/virtual-machines/image-builder-overview
[Azure landing zone]: /azure/cloud-adoption-framework/ready/landing-zone
[Azure Automanage Machine configuration]: /azure/governance/machine-configuration
[Azure Policy and the policy dashboard]: /azure/governance/policy/overview
[Azure Policy Regulatory Compliance controls for Azure Virtual Machines]: /azure/virtual-machines/security-controls-policy
[Azure Shared Image Galleries]: /azure/virtual-machines/shared-image-galleries#billing
[Azure VM Image Builder - pricing]: https://azure.microsoft.com/pricing/details/image-builder
[Bulkhead pattern]: ../../patterns/bulkhead.yml
[A computer-aided engineering service]: ../apps/hpc-saas.yml#considerations
[Control and audit your resources by using Azure Policy]: /training/modules/build-cloud-governance-strategy-azure/6-control-audit-resources-azure-policy
[Custom Script Extensions]: /azure/virtual-machines/extensions/custom-script-windows
[Deployment Stamps pattern]: ../../patterns/deployment-stamp.yml
[Designing resilient applications for Azure]: /azure/architecture/framework/resiliency/principles
[DevSecOps on AKS]: ../../guide/devsecops/devsecops-on-aks.yml
[DevTest and DevOps for IaaS solutions]: ../../solution-ideas/articles/dev-test-iaas.yml
[Geode pattern]: ../../patterns/geodes.yml
[How to find a Marketplace image version]: /azure/virtual-machines/windows/cli-ps-findimage#view-purchase-plan-properties
[Only allow certain image publishers from the Marketplace]: https://github.com/Azure/azure-policy/tree/master/samples/Compute/allowed-image-publishers
[Overview of the reliability pillar]: /azure/architecture/framework/resiliency/overview
[Scaling for Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries#scaling
[Store and share images in an Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[Store and share images in an Azure Compute Gallery - Limits]: /azure/virtual-machines/shared-image-galleries#limits
[What is an Azure landing zone?]: /azure/cloud-adoption-framework/ready/landing-zone
