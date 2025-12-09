---
title: Azure Icons
description: Download official Azure icons, Azure logo files, and Azure architecture icons to create clear, professional cloud diagrams.
ms.author: pnp
author: claytonsiemens77
ms.reviewer: chkittel
ms.date: 11/07/2025
ms.subservice: architecture-guide
ms.topic: concept-article
---

# Download Azure icons to use in architecture diagrams and documentation

This page provides an official collection of Azure architecture icons including Azure product icons to help you build a custom architecture diagram for your next solution. Helping our customers design solutions is core to the Azure Architecture Center's mission. Architecture diagrams like those included in Azure guidance can help communicate design decisions and the relationships between components of a given workload.

To learn more about communicating design intent, see [Architecture design diagrams](/azure/well-architected/architect-role/design-diagrams) in the Azure Well-Architected Framework.

## General guidelines

### Do's

- Use the icon to illustrate how products can work together.
- In diagrams, we recommend including the product name somewhere close to the icon.
- Use the icons as they would appear within Azure.

### Don'ts

- Don't crop, flip, or rotate icons.
- Don't distort or change icon shape in any way.
- Don't use Microsoft product icons to represent your product or service.

## Example architecture diagrams

:::image type="complex" source="./images/baseline-app-service-architecture.svg" lightbox="./images/baseline-app-service-architecture.svg" alt-text="Diagram that shows a baseline App Service architecture with zonal redundancy and high availability.":::
    The diagram shows a virtual network with three subnets. One subnet contains Azure Application Gateway with Azure Web Application Firewall. The second subnet contains private endpoints for Azure PaaS services, while the third subnet contains a virtual interface for Azure App Service network integration. The diagram shows App Gateway communicating to Azure App Service via a private endpoint. App Service shows a zonal configuration. The diagram also shows App Service using virtual network integration and private endpoints to communicate to Azure SQL Database, Azure Key Vault, and Azure Storage.
:::image-end:::

[Browse all Azure architectures](../browse/index.yml) to view other examples.

## Icon updates

|Month|Change description|
|--------------|--------------|
|November 2025|Added 13 new icons, including Azure Kubernetes Service (AKS) Network Policy, Azure Local, Azure Linux, and Azure PubSub.|
|August 2025|Added 10 new icons, including Azure Service Groups, Microsoft Planetary Computer Pro, and Prometheus along with a few icons used in Azure portal hub experiences.|
|March 2025|Added six new icons, including SQL Database Fleet manager and Microsoft Engage Center (Services Hub) along with a few non-service icons.|
|November 2024|Added 10 new icons such as Azure AI Foundry, Azure landing zone, Azure VPN client, and Azure Managed Redis.|
|July 2024|Rebranded more Microsoft Entra ID icons. Added new icons such as AI Content Safety, AKS Automatic, Application Gateway for Containers, and Azure Monitor Pipeline.|

## Icon terms

Microsoft permits the use of these icons in architectural diagrams, training materials, or documentation. You can copy, distribute, and display the icons only for the permitted use unless granted explicit permission by Microsoft. Microsoft reserves all other rights.

<div id="consent-checkbox">
I agree to the above terms.
</div>

> [!div class="button"]
> [Download SVG icons](https://arch-center.azureedge.net/icons/Azure_Public_Service_Icons_V23.zip)

## Use in Microsoft Visio

The icons aren't provided in Visio stencil format. The icons are provided as general purpose SVG files. You can drag and drop these icons into many diagraming and drawing tools, including Visio. There are no plans to provide these icons as Visio stencils.

## More icon sets from Microsoft

- [Microsoft 365 architecture icons and templates](/microsoft-365/solutions/architecture-icons-templates)
- [Microsoft Dynamics 365 icons](/dynamics365/get-started/icons)
- [Microsoft Entra ID architecture icons](/entra/architecture/architecture-icons)
- [Microsoft Fabric icons](/fabric/fundamentals/icons)
- [Microsoft Power Platform icons](/power-platform/guidance/icons)
