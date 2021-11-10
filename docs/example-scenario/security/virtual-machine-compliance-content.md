Each enterprise has its own compliance regulations and standards. Concerning security, each company has its own risk appetite. Security standards can differ from one organization to another and from one region to another.

Complying with these differing standards can be more challenging in dynamically scaling cloud environments than in on-premises systems. When teams use DevOps practices, there are generally fewer restrictions on who can create Azure resources like virtual machines (VMs). This fact complicates compliance challenges.

By using Azure Policy and role-based access control assignments, enterprises can enforce standards on Azure resources. But with VMs, these mechanisms only affect the control plane, or the route to the VM. The images that run on a VM still pose a security threat. Some companies prevent developers from accessing VMs. This approach impairs agility, making it difficult follow DevOps practices.

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

## Considerations

Keep the following points in mind when you implement this solution.

### Scalability considerations

Consider these scalability issues:


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
[Custom Script Extensions]: https://docs.microsoft.com/azure/virtual-machines/extensions/custom-script-windows
[What is an Azure landing zone?]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/