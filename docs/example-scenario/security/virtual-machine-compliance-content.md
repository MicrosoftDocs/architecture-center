Each enterprise has its own compliance regulations and standards. Concerning security, each company has its own risk appetite. Security standards can differ from one organization to another and from one region to another.

Complying with differing standards can be more challenging in dynamically scaling cloud environments than in on-premises systems. When teams use DevOps practices, there are generally fewer restrictions on who can create Azure resources like virtual machines (VMs). This fact complicates compliance challenges.

By using Azure Policy and role-based access control assignments, enterprises can enforce standards on Azure resources. But with VMs, these mechanisms only affect the control plane, or the route to the VM. The system images that run on a VM still pose a security threat. Some companies prevent developers from accessing VMs. This approach impairs agility, making it difficult follow DevOps practices.

This article presents a solution for managing the compliance of VMs that run on Azure. Besides tracking compliance, the solution also minimizes the risk from system images that run on VMs. At the same time, the solution is compatible with DevOps practices. Core components include Azure Image Builder, Azure Compute Gallery, and Azure Policy.

## Potential use cases

This solution applies to organizations with Azure [landing zones][What is an Azure landing zone?] that face these tasks:

- Supply *golden images* to DevOps teams. A golden image is the published version of a marketplace image.
- Test and validate images before making them available to DevOps teams.
- Track which image each DevOps team is using.
- Enforce company standards without degrading productivity.
- Ensure that DevOps teams use the latest image versions.
- Manage the compliance of *pet* servers, which are maintenance intensive, and *cattle* servers, which are easily replaceable.

## Architecture

The solution consists of two processes:

- The golden image publishing process
- The process of tracking virtual machine compliance

:::image type="content" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Architecture diagram showing the flow of security log data. Key components include Sentinel for short-term data and Azure Data Explorer for long-term storage." border="false":::

The golden image publishing process contains these steps:

1. The process captures a base image from Azure Marketplace.
1. Azure Image Builder customizes the image.
1. The image tattooing process tracks image version information like the source and publish date.
1. Automated tests validate the image.
1. If the image fails any tests, it returns to the customization step for repairs.
1. The process publishes the finalized image.
1. Azure Compute Gallery makes the image available to DevOps teams.

:::image type="content" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Architecture diagram showing the flow of security log data. Key components include Sentinel for short-term data and Azure Data Explorer for long-term storage." border="false":::

The process of tracking virtual machine compliance contains these steps:

1. Azure Policy assigns policy definitions to VMs and evaluates the VMs for compliance.
1. Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.

### Components

- [Azure Image Builder][Azure Image Builder] is a managed service that you can use to customize the system images that DevOps teams use.

- [Azure Compute Gallery][Azure Compute Gallery] helps you structure and organize custom images. By storing images in repositories, this service provides a way for people within and outside your organization to use the images.

- [Azure Policy][Azure Policy and Policy Dashboard] offers policy definitions that you can use to enforce organizational standards and assess compliance at scale. The Azure Policy dashboard displays results from Azure Policy evaluations. This data keeps you informed about the compliance status of your resources.

- The [guest configuration feature of Azure Policy][Azure Policy guest configuration feature] provides a way to dynamically audit or assign configurations to machines through code. The configurations generally include environment or operating system settings.

### Alternatives

- You can use a third-party tool to manage compliance. But with this type of tool, you usually need to install an agent on the target VM. You also may have to pay a licensing fee for the third-party tool.

- You can use [Custom Script Extensions][Custom Script Extensions] for installing software on VMs or configuring VMs after deployment. But each VM or virtual machine scale set can only have one custom script extension. And if you use custom script extensions, you may prevent DevOps teams from performing customizations that their applications need.

## Approach

Add intro sentence to avoid stacked headings.

### Identify pets and cattle

DevOps teams use an analogy called pets and cattle to define service models. To track a VM's compliance, first determine whether it's a pet or cattle server.

- Pets require significant attention. They're not easy to dispense. You need to invest a considerable amount of time and financial resources to recover them. For example, a server that runs SAP might be a pet. Besides the software that runs on the server, other considerations can also determine the service model. If you have a low failure tolerance, production servers that run on real-time and near realtime systems can also be pets.
- Cattle servers are part of an identical group. You can replace them easily. For example, VMs that run in a virtual machine scale set are cattle. If there are enough VMs in the virtual machine scale set, your system keeps running, and you don't need to know each VM's name. Another example of cattle might be your testing environment. You use an automated procedure to create the servers in that environment from scratch. After you finish running the tests, you decommission the servers.

An environment might only contain pet servers, or it might only contain cattle servers. In contrast, a set of VMs in an environment might be pets. In the same environment, a different set of VMs might be cattle.

To manage compliance:

- Pet compliance is generally more challenging to track than cattle compliance. Usually only DevOps teams can track and maintain the compliance of pet environments and servers. But this article's solution increases the visibility of each pet's status, making compliance tracking easier for everyone in the organization.
- For cattle environments, refresh the VMs and rebuild them from scratch on a regular basis. Those steps should be adequate for compliance. You can align this refresh cycle with your DevOps team's regular release cadence.

### Restrict images

Don't allow DevOps teams to use Azure Marketplace VM images. Only allow VMs images that the Azure Compute Gallery publishes. This restriction is critical for ensuring VM compliance. You can use a custom policy in Azure Policy to enforce this restriction. For a sample, see [Allow image publishers][Only allow certain image publishers from the Marketplace]. 

As a part of this solution, Azure Image Builder should use an Azure Marketplace image. It's essential to use the latest image that's available in Azure Marketplace. Apply any customizations on top of that image. Azure Marketplace images are refreshed often, and each image has certain preset configurations, ensuring your images are secure by default.

### Customize images

A golden image is the version of a marketplace image that's published to Azure Compute Gallery. Golden images are available for consumption by DevOps teams. Before the image is published, customization takes place. Customization activities are unique to each enterprise. Common activities include:

- Operating system hardening
- Deploying custom agents for third-party software
- Installing enterprise certificate authority (CA) root certificates.

You can use Azure Image Builder to customize images by adjusting operating system settings and by running custom scripts and commands. Image Builder supports Windows and Linux images. For more information on customizing images, see [Azure Policy Regulatory Compliance controls for Azure Virtual Machines][Azure Policy Regulatory Compliance controls for Azure Virtual Machines].

### Track image tattoos

Image tattooing is the process of keeping track of all image version information that a VM uses. This information is invaluable during troubleshooting and can include:

- The original source of the image, such as the version and the name of the publisher.
- The operating system version string, which is needed if there's an in-place upgrade.
- The version of your custom image.
- Your publish date.

The amount and type of information that you track varies depends on your organization's compliance level.

For image tattooing on Windows VMs, set up a custom registry. Add all required information to this registry path as key-value pairs. On Linux VMs, enter image tattooing data into environment variables or a file. Put the file in the `/etc/` folder, where it doesn't conflict with developer work or applications. If you'd like to use Azure Policy to track the tattooing data or report on it, store each piece of data as a unique key-value pair. For information on determining the version of a Marketplace image, see [How to find Marketplace Image version][How to find Marketplace Image version].

### Validate golden images with automated tests

Generally, you should refresh golden images monthly to stay current with the latest updates and changes in Azure Marketplace images. Use a recurrent testing procedure for this purpose. As part of the image creation process, use an Azure pipeline or other automated workflow for testing. Set up the pipeline to deploy a new VM and run tests on it before the beginning of each month. The tests should confirm pared images before publishing them for consumption. Automate tests by using a test automation solution or by running commands or batches on the VM.

Common test scenarios include:

- Validating the VM boot time.
- Confirming any customization of the image, such as operating system configuration settings or agent deployments.

A failed test should interrupt the process. Repeat the test after addressing the root cause of the problem. If the tests run without problem for the most part, automating the testing process reduces the effort that goes into maintaining an evergreen state.

### Publish golden images

Publish final images on Azure Compute Gallery as a managed image or as a VHD that DevOps teams can use. Mark any earlier images as aged. If you haven't set an end of life date for an image version in Azure Compute Gallery, you might prefer to discontinue the oldest image. This decision depends on your company's policies.

For information on limits that apply when you use Azure Compute Galleries, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery - Limits].

Another good practice is to publish the latest images across different regions. With Azure Compute Gallery, you can manage the lifecycle and replication of your images across different Azure regions.

For more information on Azure Compute Gallery, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery].

### Refresh golden images

When an image is used for an application, it can be hard to update the underlying operating system image with recent compliance changes. Strict business requirements can complicate the process of refreshing the underlying VM. Refreshing can also be complex when the VM is critical to the business.

Since cattle servers are dispensible, you can coordinate with DevOps teams to refresh these servers in a planned maintenance window as a business-as-usual activity.

It's more challenging to refresh pet servers. Discontinuing an image can put applications at risk. In scale-out scenarios, Azure can't find the respective images, resulting in failures.

Consider these guidelines when refreshing pet servers:

- For best practices, see [Overview of the reliability pillar][Overview of the reliability pillar] in the Azure Well-Architected Framework.
- To streamline the process, see the principles that these documents discuss:

  - [Deployment Stamps pattern][Deployment Stamps pattern]
  - [Geode pattern][Geode pattern]
  - [Bulkhead pattern][Bulkhead pattern]

- Tag each pet server with a "pet" label. Configure a policy in Azure Policy to take this tag into account when refreshing. 

### Improve visibility

Generally, you should use Azure Policy to manage any control-plane compliance activity. You can also use Azure Policy for:

- Tracking VM compliance.
- Installing Azure agents.
- Capturing diagnostic logs.
- Improving the visibility of VM compliance.

Use the guest configuration feature of Azure Policy to audit the configuration changes that you make during image customization. When drift occurs, the Azure Policy dashboard lists the affected VM as non-compliant. By using image tattooing information, Azure Policy can track when you use outdated images or operating systems.

Audit pet servers for each application. By using Azure Policies with audit effect, you can improve the visibility of these servers. Adjust the audit process according to your company's risk appetite and internal risk management processes.

Each DevOps team can track its applications' compliance levels in the Azure Policy dashboard and take appropriate corrective actions. When you assign these policies to a management group or a subscription, give the assignment description a URL that leads to a company-wide wiki. You can also use a short URL like aka.ms/policy-21. In the wiki, list the steps that DevOps teams should take to make their VMs compliant.

IT risk managers and security officers can also use the Azure Policy dashboard to manage company risks according to their company's risk appetite

By using the guest configuration feature of Azure Policy with remediation options, you can apply corrective actions automatically. But interrogating a VM frequently or making changes on a VM that you use for a business-critical application could degrade performance. Plan remediation actions carefully for production workloads. Give a DevOps team ownership of application compliance in all environments. This approach is essential for pet servers and environments, which are long-term Azure components.

## Considerations

Keep the following points in mind when you implement this solution.

### Scalability considerations

You can configure the number of replicas that Azure Compute Gallery stores of each image. A higher number of replicas minimizes the risk of throttling when you provision multiple VMs simultaneously. For general guidance on scaling and configuring an appropriate number of replicas, see [Scaling for Azure Compute Gallery][Scaling for Azure Compute Gallery].





### Performance considerations


## Deploy this scenario


## Pricing


To explore the cost of running this solution in your environment, use the [Azure pricing calculator][Azure pricing calculator].

## Next steps


## Related resources









[Azure Compute Gallery]: https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries
[Azure Image Builder]: https://docs.microsoft.com/azure/virtual-machines/image-builder-overview
[Azure Policy guest configuration feature]: https://docs.microsoft.com/azure/governance/policy/concepts/guest-configuration
[Azure Policy and Policy Dashboard]: https://docs.microsoft.com/azure/governance/policy/overview
[Azure Policy Regulatory Compliance controls for Azure Virtual Machines]: https://docs.microsoft.com/azure/virtual-machines/security-controls-policy
[Bulkhead pattern]: https://docs.microsoft.com/azure/architecture/patterns/bulkhead
[Custom Script Extensions]: https://docs.microsoft.com/azure/virtual-machines/extensions/custom-script-windows
[Deployment Stamps pattern]: https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp
[Geode pattern]: https://docs.microsoft.com/azure/architecture/patterns/geodes
[How to find Marketplace Image version]: https://docs.microsoft.com/azure/virtual-machines/windows/cli-ps-findimage#view-purchase-plan-properties
[Only allow certain image publishers from the Marketplace]: https://github.com/Azure/azure-policy/tree/master/samples/Compute/allowed-image-publishers
[Overview of the reliability pillar]: https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/overview
[Scaling for Azure Compute Gallery]: https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries#scaling
[Store and share images in an Azure Compute Gallery]: https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries
[Store and share images in an Azure Compute Gallery - Limits]: https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries#limits
[What is an Azure landing zone?]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/