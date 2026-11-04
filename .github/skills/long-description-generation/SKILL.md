---
name: long-description-generation
description: 'How to write a text-equivalent long description (alt text) for a complex image, such as an Azure architecture diagram, decision tree, process flow, or detailed screenshot. USE when generating, reviewing, or improving the alternative text for a complex image so users of assistive technology can understand its information and relationships. DO NOT USE for simple decorative images, for icons on their own, or for non-image content.'
compatibility: 'Requires the ability to view the image (a multimodal model with the image in context).'
argument-hint: 'Attach an existing PNG or SVG image, or point to its file or image reference in an article, to generate a long description.'
disable-model-invocation: false
license: MIT
user-invocable: true
metadata:
  author: 'Azure Patterns & Practices'
---

# Long description generation

Write a text equivalent for a complex image, usually an Azure architecture diagram. You act as a web accessibility expert when you apply this skill.

You follow [WCAG's equivalent-purpose principle](https://www.w3.org/WAI/WCAG22/Understanding/non-text-content.html): readers must understand the image's essential information and relationships without seeing it. Describe layout and appearance when they help convey that information. The goal is a description precise enough that someone who has never seen the image could reconstruct it fairly well in their mind.

## Prerequisite: you must be able to see the image

The user must attach an image, point to an image file, or point to an image referenced in an article. For an article reference, read the article, resolve the image source relative to the article, and view the image itself.

When the article hosting the image is available, use the surrounding text to establish the image's purpose. Don't invent missing context or add facts that the image doesn't convey.

You need the image in your context to apply this skill. The image is usually one of:

- A cloud architecture diagram of a workload running in Azure.
- A screenshot that has important details in it.
- A decision tree.
- A process flow diagram.

If no image is available, stop and ask for one before continuing.

## File types

This skill supports raster and vector diagram formats, primarily PNG and SVG. If you're handed a format you can't render or interpret as an image, stop and ask for a different file.

## Requirements for the long description

Generate the equivalent alternative text for the image, and adhere to all of the following requirements:

- Target 300 to 1,200 characters, preferably around 1,000. Don't pad a complete description or omit essential information to meet a length target.
- The text must be in en-US.
- Write the long description as one or two paragraphs of text only. Don't use bullet points, ordered lists, headings, or tables, even when the image contains a list or numbered flow.
- Start with a brief overview of the image's major groups, then follow its logical flow, which might already be labeled with numbers.
- Group repeated components concisely without losing meaningful distinctions.
- Be precise and concise.
- Preserve essential labels, quantities, and units.
- Explain arrow direction, branch conditions, return paths, and group boundaries or nesting when present.
- Explain meaning conveyed by color, line style, or shading. Ignore decorative styling.
- Ignore header or footer text when they are just labeling or scoping the image.
- Use positional terms such as "above" or "to the left of" when they clarify relationships.
- Don't describe icons, such as Azure service icons. Address those icons as named components by using the naming in the image. If naming cues aren't available, don't invent a name for the component. Use a generic term for it.
- If there's a legend, use the legend's terms to explain symbols and relationships.
- If there's a logical flow, such as numbering or a connected chain of arrows, follow that flow when describing the image.
- Assume the reader has additional text that sets the image in a larger context. Don't guess what that larger context is. Focus on describing the image.
- Don't end in any kind of summary.

## Check the result

Read the description without looking at the image: does it preserve the same essential information and relationships? Revise omissions, unsupported claims, and unnecessary detail before delivering it.

## Good examples

Use these examples to guide style. Example 3 exceeds the length target; essential information takes priority over length.

### Example 1

Source image: [deployment-stamp.png](../../../docs/patterns/_images/deployment-stamp/deployment-stamp.png)

Good long description: The diagram shows five stacked rows. Each row represents one deployment stamp. Every row has a label on the upper left that names the stamp and its Azure region, a label on the upper right that lists the tenants that the stamp serves, and two components below the labels, Azure App Service on the left and a SQL database on the right. From top to bottom, the stamps are Stamp 1 in West US 2, which serves tenants A, B, and C; Stamp 2 in West US 2, which serves tenant D; Stamp 3 in East US, which serves tenants E, F, and G; Stamp 4 in West Europe, which serves tenants H, I, and J; and Stamp 5 in Australia East, which serves tenants K, L, and M. The five stamps share the same internal composition but differ in region and in the set of tenants assigned to them. The West US 2 region contains two separate stamps while each of the other regions contains one stamp.

### Example 2

Source image: [rag-architecture.svg](../../../docs/ai-ml/guide/_images/rag-architecture.svg)

Good long description: The diagram illustrates two flows. The first flow starts with a user and then flows to an intelligent application. From there, the flow leads to an orchestrator. From the orchestrator, the flow leads to Azure OpenAI in Foundry Models and to Azure AI Search, which is the last item in the second flow. The second flow starts with documents and then flows to four stages: chunk documents, enrich chunks, embed chunks, and index chunks. From there, the flow leads to the same Azure AI Search instance that connects to the first flow.

### Example 3

Source image: [baseline-microsoft-foundry-landing-zone.svg](../../../docs/ai-ml/architecture/_images/baseline-microsoft-foundry-landing-zone.svg)

Good long description: This architecture diagram contains two primary sections. The top blue section is labeled application landing zone subscription. The bottom yellow section is labeled platform landing zone subscription. The top box contains both workload-created resources and subscription-vending resources. The workload resources consist of Azure Application Gateway and Azure Web Application Firewall, App Service and its integration subnet, and private endpoints for platform as a service (PaaS) solutions such as Azure Storage, Azure Key Vault, Azure AI Search, Foundry, Azure Cosmos DB, and Azure Storage. The workload resources also have a Foundry project with Agent Service and monitoring resources. App Service has three instances in different Azure zones.

The platform subscription contains a hub virtual network, Azure Firewall, Azure Bastion, and a grayed-out Azure VPN Gateway and Azure ExpressRoute. A spoke virtual network in the application landing zone and the hub virtual network connect via virtual network peering. Controlled egress traffic goes from the application landing zone to Azure Firewall in the platform landing zone. A flow goes from App Service to the App Service integration subnet, to private endpoints, and then to the services of the private endpoints.
