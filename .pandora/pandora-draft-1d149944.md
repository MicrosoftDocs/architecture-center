---
title: "Draft Document"
# Pandora-managed document — edit freely, chunks sync automatically
---

# Virtual desktop architecture design

Migrating end-user desktops to the cloud helps improve employee productivity and enables employees to work from anywhere on a high-security cloud-based virtual desktop infrastructure.

Azure provides these virtual desktop solutions:

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop): A desktop and application virtualization service.
- [Omnissa Horizon Cloud on Microsoft Azure](https://www.omnissa.com/products/horizon-cloud/): An Omnissa service that simplifies the delivery of virtual desktops and applications on Azure by extending Azure Virtual Desktop.
- [Citrix Virtual Apps and Desktops for Azure](https://docs.citrix.com/en-us/citrix-virtual-apps-desktops.html): A desktop and app virtualization service that you can use to provision Windows desktops and apps on Azure with Citrix and Azure Virtual Desktop.
- [Microsoft Dev Box](https://azure.microsoft.com/services/dev-box): A service that gives developers access to ready-to-code, project-specific workstations that are preconfigured and centrally managed in the cloud.

## Architecture

:::image type="complex" border="false" source="../images/virtual-desktop-get-started-diagram.svg" alt-text="[QUESTION: Provide a brief alt-text description of the virtual desktop solution journey diagram for screen readers]" lightbox="../images/virtual-desktop-get-started-diagram.svg":::
   [QUESTION: Provide a detailed long description of the diagram for accessibility. Describe the visual flow, key stages (learning, organizational readiness, service selection, implementation, production deployment), and how they connect in the solution journey.]
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-get-started-diagram.vsdx) of this architecture.*

The diagram above demonstrates a typical virtual desktop implementation journey on Azure. Refer to the [architectures](#explore-virtual-desktop-architectures-and-guides) provided in this article to find real-world solutions that you can build in Azure.

## Explore virtual desktop architectures and guides 

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use virtual desktop technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your virtual desktop proof-of-concept development.

### Virtual desktop architecture guides

[ISSUE: Need Azure Architecture Center TOC for virtual desktop category to populate architecture guides. Expected path: /azure/architecture/browse/?terms=virtual-desktop or /azure/architecture/guide/technology-choices/]

**Technology choices** - These articles help you evaluate and select the best virtual desktop technologies for your workload requirements:

- [ISSUE: Need link to virtual desktop technology choice guide if it exists at /azure/architecture/guide/technology-choices/]

**Identity** - Authentication and identity management for virtual desktop environments:

- [Authentication in Azure Virtual Desktop](/azure/virtual-desktop/authentication?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Understand authentication methods and identity requirements for Azure Virtual Desktop.
- [Deploy Microsoft Entra joined virtual machines in Azure Virtual Desktop](/azure/virtual-desktop/azure-ad-joined-session-hosts?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Configure Microsoft Entra joined session hosts for simplified identity management.
- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions): Evaluate identity solutions for your virtual desktop deployment.

**Enterprise deployment** - Guidance for enterprise-scale virtual desktop implementations:

- [Azure Virtual Desktop landing zone design guide](../../landing-zones/azure-virtual-desktop/design-guide.md): Design and deploy Azure Virtual Desktop at enterprise scale using Azure landing zones.

**FSLogix** - Profile management and user experience optimization:

- [FSLogix configuration examples](/fslogix/concepts-configuration-examples): Configure FSLogix for optimal profile management.
- [FSLogix profile containers and Azure Files](/azure/virtual-desktop/fslogix-containers-azure-files?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Implement FSLogix profile containers using Azure Files.
- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Compare storage options for FSLogix profiles.

**Networking** - Network connectivity and optimization:

- [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Understand network connections used by Azure Virtual Desktop.
- [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json): Implement RDP Shortpath for improved network performance.

### Virtual desktop architectures

[ISSUE: Need Azure Architecture Center TOC for virtual desktop category to populate architecture examples. Expected path: /azure/architecture/example-scenario/ or /azure/architecture/reference-architectures/]

These production-ready architectures demonstrate end-to-end virtual desktop solutions that you can deploy and customize:

- [Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](../../example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr.yml): Implement multi-region disaster recovery for Azure Virtual Desktop.
- [Deploy Esri ArcGIS Pro in Azure Virtual Desktop](../../example-scenario/data/esri-arcgis-azure-virtual-desktop.yml): Deploy specialized GIS applications in Azure Virtual Desktop.

[ASSUMPTION: Additional architecture examples exist in the Azure Architecture Center but cannot be listed without the TOC]

### Virtual desktop solution ideas

[ISSUE: Need Azure Architecture Center TOC for virtual desktop category to populate solution ideas. Expected path: /azure/architecture/solution-ideas/articles/]

These solution ideas demonstrate implementation patterns and possibilities to explore:

[ASSUMPTION: Solution ideas exist for virtual desktop scenarios but cannot be listed without the TOC]

## Learn about virtual desktop on Azure <!-- pandora:chunkId=learn-about-category-on-azure -->


## Learning paths by role (OPTIONAL) <!-- pandora:chunkId=learning-paths-by-role -->


## Organizational readiness <!-- pandora:chunkId=organizational-readiness -->


## Best practices <!-- pandora:chunkId=best-practices -->


## OPTIONAL: Operations guide <!-- pandora:chunkId=optional-operations-guide -->


## Stay current with virtual desktop <!-- pandora:chunkId=stay-current-with-category -->


## Additional resources <!-- pandora:chunkId=additional-resources -->


## OPTIONAL: Hybrid [and multi-cloud] <!-- pandora:chunkId=optional-hybrid-and-multi-cloud -->


## OPTIONAL: {Specialized topic 1} <!-- pandora:chunkId=optional-specialized-topic-1 -->


## OPTIONAL: {Specialized topic 2} <!-- pandora:chunkId=optional-specialized-topic-2 -->


## AWS or Google Cloud professionals (OPTIONAL)

