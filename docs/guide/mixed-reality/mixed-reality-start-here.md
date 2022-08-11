---
title: Microsoft mixed reality overview
titleSuffix: Azure Architecture Center
description: See an overview of Microsoft mixed-reality concepts, product offerings, and Azure services.
author: v-thepet
ms.author: v-thepet
ms.date: 08/11/2022
ms.topic: overview
ms.service: architecture-center
categories:
  - mixed-reality
products:
  - azure-object-anchors
  - azure-remote-rendering
  - azure-spatial-anchors
  - hololens
  - mrtk
  - windows-mixed-reality
ms.custom:
  - overview
---

# Mixed-reality overview

Mixed reality is a blend of physical and digital worlds that unlocks natural and intuitive 3D human, computer, and environmental interactions. This new reality is based on advancements in computer vision, graphical processing, display technologies, input systems, and cloud computing.

:::image type="content" source="media/mixed-reality-venn-diagram.png" alt-text="Venn diagram showing interactions between computers, humans, and environments.":::

Paul Milgram and Fumio Kishino introduced the term *mixed reality* in a 1994 paper, [A Taxonomy of Mixed reality Visual Displays](https://search.ieice.org/bin/summary.php?id=e77-d_12_1321). Their paper explored the concept of a *virtuality continuum* and the taxonomy of visual displays. Since then, the application of mixed reality has gone beyond displays to include:

- Environmental understanding with spatial mapping and anchors.
- Human understanding with hand-tracking, eye-tracking, and speech input.
- Spatial sound.
- Locations and positioning in both physical and virtual spaces.
- Collaboration on 3D assets in mixed reality spaces.

:::image type="content" source="media/mixed-reality-spectrum.png" alt-text="Image showing the mixed reality spectrum.":::

## Azure mixed reality services

Several Azure cloud services help developers build compelling immersive experiences on a variety of platforms. Azure mixed reality services help people create, learn, and collaborate within their own context by bringing 3D to mobile devices, headsets, and other untethered devices. Azure services always have comprehensive security and compliance built in.

- [Azure Remote Rendering](https://azure.microsoft.com/services/remote-rendering) lets you render highly complex 3D models in real time and stream them to a device. You can add Azure Remote Rendering to your Unity or native C++ projects targeting HoloLens 2 or Windows desktop PC.

- [Azure Spatial Anchors](https://azure.microsoft.com/services/spatial-anchors) is a cross-platform service that lets you build spatially aware mixed reality applications. With Azure Spatial Anchors, you can map, persist, and share holographic content across multiple devices at real-world scale.

- [Azure Object Anchors](https://azure.microsoft.com/services/object-anchors) is a mixed reality service that helps you create rich, immersive experiences by automatically aligning 3D content with physical objects. Azure Object Anchors lets you gain contextual understanding of objects without the need for markers or manual alignment.

For more information, see [Azure mixed reality cloud services](/windows/mixed-reality/develop/mixed-reality-cloud-services).

## Microsoft Learn training resources

Microsoft Learn is a free, online training platform that provides interactive learning for Microsoft products.

### Introduction to mixed reality

If you're new to mixed reality, the best place to learn about the ecosystem is with Microsoft Learn. The **Introduction to mixed reality** learning path provides foundational knowledge about the core concepts of mixed reality, virtual reality, augmented reality, holograms, and creating 3D applications.

> [!div class="nextstepaction"]
> [Introduction to mixed reality](/learn/modules/intro-to-mixed-reality)

### Build a mixed-reality experience

If you're an intermediate-to-advanced developer with some previous experience in mixed, augmented, or virtual reality, check out the **HoloLens 2 fundamentals: develop mixed reality applications**  tutorial series. You can build a mixed-reality experience where users explore a hologram modeled after NASA's Mars Curiosity Rover. This tutorial gives you a firm grasp of the [Mixed Reality Toolkit (MRTK)](/windows/mixed-reality/mrtk-unity/mrtk2), and shows how the MRTK can speed up your development process.

> [!div class="nextstepaction"]
> [HoloLens 2 fundamentals](/learn/paths/beginner-hololens-2-tutorials)

## Path to production

Choose the mixed reality engine you want to use for development. You can select from Unity, Unreal, native, or web development paths.

> [!div class="nextstepaction"]
> [Choose a mixed reality engine](/windows/mixed-reality/develop/choosing-an-engine)

Get the tools you need to build applications for Microsoft HoloLens and Windows Mixed Reality immersive headsets, and get set up.

> [!div class="nextstepaction"]
> [Install the tools](/windows/mixed-reality/develop/install-the-tools)

## Mixed reality design and prototyping

The following articles offer a process for designing and prototyping effective mixed reality apps.

1. Understand the basic objectives of mixed reality design.

   > [!div class="nextstepaction"]
   > [Mixed reality design guidance](/windows/mixed-reality/design/about-this-design-guidance)

1. Understand mixed reality core concepts.

   > [!div class="nextstepaction"]
   > [Mixed reality core concepts](/windows/mixed-reality/design/core-concepts-landingpage)

1. Understand the types of mixed reality apps.

   > [!div class="nextstepaction"]
   > [Types of mixed reality apps](/windows/mixed-reality/discover/types-of-mixed-reality-apps)

1. Understand interaction models.

   > [!div class="nextstepaction"]
   > [Mixed reality interaction design](/windows/mixed-reality/design/interaction-fundamentals)

1. Understand user experience elements.

   > [!div class="nextstepaction"]
   > [Mixed reality UX elements](/windows/mixed-reality/design/app-patterns-landingpage)

1. Start designing and prototyping.

   > [!div class="nextstepaction"]
   > [Start designing and prototyping](/windows/mixed-reality/design)

## Scenarios and solution ideas

The following implementations and ideas illustrate how you can adopt and configure mixed reality for various scenarios.

- [Mixed reality prototyping for manufacturing](/windows/mixed-reality/enthusiast-guide/prototyping-manufacturing)
- [Shared experiences in mixed reality](/windows/mixed-reality/design/shared-experiences-in-mixed-reality)
- [Free-roaming multiuser VR experiences](/windows/mixed-reality/enthusiast-guide/free-roam-vr-multiuser-experiences)
- [Immersive education](/windows/mixed-reality/enthusiast-guide/immersive-education)
- [Theme parks and family entertainment](/windows/mixed-reality/enthusiast-guide/theme-parks-family-entertainment)
- [Training and simulation](/windows/mixed-reality/enthusiast-guide/training-simulation)
- [Virtual museums and exhibits](/windows/mixed-reality/enthusiast-guide/virtual-museums)
- [Virtual reality arcades](/windows/mixed-reality/enthusiast-guide/virtual-reality-arcades)
- [Design review with mixed reality](../../solution-ideas/articles/collaborative-design-review-powered-by-mixed-reality.yml)
- [Facilities management with mixed reality](../../solution-ideas/articles/facilities-management-powered-by-mixed-reality-and-iot.yml)
- [Training powered by mixed reality](../../solution-ideas/articles/training-and-procedural-guidance-powered-by-mixed-reality.yml)

## Best practices

- [Designing content for holographic display](/windows/mixed-reality/design/designing-content-for-holographic-display) describes elements you need to consider to achieve the best holographic experience.
- [Comfort](/windows/mixed-reality/design/comfort) explains how to create and present content that mimics cues in the natural world, and doesn't require fatiguing motions.
- [Spatial sound best practices](/windows/mixed-reality/design/spatial-sound-design) discusses how to use sound in the mixed-reality world to inform and reinforce the user's mental model.
- [App quality criteria overview](/windows/mixed-reality/develop/advanced-concepts/app-quality-criteria-overview) describes the top factors that impact the quality of mixed reality apps.

## Stay current with mixed reality

Mixed reality is changing fast. Explore the expanding world of mixed reality applications with the Mixed Reality Toolkit (MRTK), Windows Mixed Reality, Unity, Unreal, and more for HoloLens and Windows Immersive Headsets.

> [!div class="nextstepaction"]
> [Mixed reality documentation](/windows/mixed-reality)

