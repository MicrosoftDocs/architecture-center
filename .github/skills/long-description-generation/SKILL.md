---
name: long-description-generation
description: 'How to write a text-equivalent long description (alt text) for a complex image, such as an Azure architecture diagram, decision tree, process flow, or detailed screenshot. USE when generating, reviewing, or improving the alternative text for a complex image so users utilizing assistive-technology can reconstruct it. DO NOT USE for simple decorative images, for icons on their own, or for non-image content.'
compatibility: 'Requires the ability to view the image (a multimodal model with the image in context).'
argument-hint: 'Attach or point to an existing PNG or SVG image to generate alt text for.'
disable-model-invocation: false
license: MIT
user-invocable: true
metadata:
  author: 'Azure Patterns & Practices'
---

# Long description generation

This skill is guidance on how to write a text equivalent for a complex image, usually an Azure architecture diagram. Users of assistive technology, like screen readers, read your long description and build a mental image of the art. You generate a text equivalent to the image.

You act as a web accessibility expert when you apply this skill. The goal is a description precise enough that someone who has never seen the image could reconstruct it fairly well in their mind.

## Prerequisite: you must be able to see the image

You need the image in your context to apply this skill. The image is usually one of:

- a cloud architecture diagram of a workload running in Azure
- a screenshot that has important details in it
- a decision tree
- a process flow diagram

If no image is available, stop and ask for one before continuing.

## File types

This skill supports raster and vector diagram formats, primarily PNG and SVG. If you're handed a format you can't render or interpret as an image, refuse to operate on it and ask for a different file.

## Requirements for the long description

Generate the equivalent alternative text for the image, and adhere to all of the following requirements.

- The text must be no less than 300 characters long.
- The text must be no more than 1000 characters long.
- The text must be in en-US.
- The text must not contain bullet points or ordered lists.
- The text must be one or two paragraphs long.
- Describe the image so that someone reading the text could replicate the image fairly well without having ever seen it.
- Focus on the information the image provides to its consumer.
- Use strategic summarization to group similar concepts, taking cues from any grouping present in the image.
- Be precise and concise.
- Don't describe things that aren't in the image. Describe only the image you were provided.
- Use positional terms and phrases like "above," "below," or "to the left of" to help the reader understand the layout.
- If the image contains arrows or other connectors, discuss those connections and any relationship information they convey.
- Don't describe icons, such as Azure service icons. Address those icons as named components by using the naming in the image. If naming cues aren't available, don't invent a name for the component. Use a generic term for it.
- If there's a legend, describe its contents and use its terms as part of the description.
- If there's a logical flow, such as numbering or a connected chain of arrows, follow that flow when describing the image.
- Assume the reader has additional text that sets the image in a larger context. Don't guess what that larger context is. Focus on describing the image.
- Don't end in any kind of summary.

## Good examples

Here are three good examples of long descriptions generated in the past for three different images. Use the style in these examples to guide new output.

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
