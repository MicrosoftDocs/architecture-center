---
title: Microsoft mixed reality architecture overview
titleSuffix: Azure Architecture Center
description: See an overview of Microsoft mixed-reality concepts, training, best practices, architectures, and Azure services.
author: martinekuan
ms.author: architectures
ms.date: 08/16/2022
ms.topic: conceptual
ms.service: architecture-center
categories:
  - mixed-reality
products:
  - azure-object-anchors
  - azure-remote-rendering
  - azure-spatial-anchors
  - hololens
  - windows-mixed-reality
ms.custom:
  - overview
---

# Mixed reality architecture design

Mixed reality is a blend of physical and digital worlds that unlocks natural and intuitive 3D human, computer, and environmental interactions. This new reality is based on advancements in computer vision, graphical processing, display technologies, input systems, and cloud computing.

The following Venn diagram illustrates the interaction between computers, humans, and the environment in mixed reality:

:::image type="content" source="media/mixed-reality-venn-diagram.png" alt-text="Venn diagram showing interactions between computers, humans, and environments.":::

Paul Milgram and Fumio Kishino introduced the term *mixed reality* in a 1994 paper, [A Taxonomy of Mixed reality Visual Displays](https://search.ieice.org/bin/summary.php?id=e77-d_12_1321). The paper explored the concept of a *virtuality continuum* and the taxonomy of visual displays. Since then, the application of mixed reality has gone beyond displays to include:

- Environmental awareness with spatial mapping and anchors.
- Human responses like hand-tracking, eye-tracking, and speech input.
- Spatial sound.
- Locations and positioning in both physical and virtual spaces.
- Collaboration on 3D assets in mixed reality spaces.

Mixed reality consists of several [types of apps](/windows/mixed-reality/discover/types-of-mixed-reality-apps?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json):

- *Enhanced environment apps* (HoloLens only) place digital information or content in a user's current environment.
- *Blended environment apps* create a digital layer that overlays the user's space.
- *Immersive apps* create an environment that completely changes the user's world and can place them in a different time and space.

The following image shows the continuum of mixed-reality apps from physical to digital reality:

:::image type="content" source="media/mixed-reality-spectrum.png" alt-text="Image showing the mixed reality spectrum.":::

## Azure mixed reality services

Several Azure cloud services help developers build compelling mixed reality experiences on various platforms. Azure mixed reality services help people create, learn, and collaborate within their own context by bringing 3D to mobile devices, headsets, and other untethered devices. All Azure services build in comprehensive security and compliance capabilities.

- [Azure Remote Rendering](https://azure.microsoft.com/services/remote-rendering) lets you render highly complex 3D models in real time and stream them to a device. You can add Azure Remote Rendering to Unity or native C++ projects that target HoloLens 2 or Windows desktop PC.

- [Azure Spatial Anchors](https://azure.microsoft.com/services/spatial-anchors) is a cross-platform service that lets you build spatially aware mixed reality applications. With Spatial Anchors, you can map, persist, and share holographic content across multiple devices at real-world scale.

- [Azure Object Anchors](https://azure.microsoft.com/services/object-anchors) is a mixed reality service that helps you create rich, immersive experiences by automatically aligning 3D content with physical objects. Object Anchors lets you gain contextual understanding of objects without the need for markers or manual alignment.

> [!div class="nextstepaction"]
> [Azure mixed reality services](/windows/mixed-reality/develop/mixed-reality-cloud-services?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

## Microsoft Learn training resources

Microsoft Learn is a free online platform that provides interactive learning for Microsoft products.

### Introduction to mixed reality

If you're new to mixed reality, the best place to learn about the ecosystem is the **Introduction to mixed reality** learning path, which provides foundational knowledge about the core concepts of mixed reality, virtual reality, augmented reality, holograms, and creating 3D applications.

> [!div class="nextstepaction"]
> [Introduction to mixed reality](/training/modules/intro-to-mixed-reality)

### Build a mixed-reality experience

If you're an intermediate-to-advanced developer with previous experience with mixed, augmented, or virtual reality, check out the **HoloLens 2 fundamentals: develop mixed reality applications**  tutorial series. With this tutorial, you can build a mixed-reality experience that lets users explore a hologram modeled after NASA's Mars Curiosity Rover. The tutorial gives you a firm grasp of the [Mixed Reality Toolkit (MRTK)](/windows/mixed-reality/mrtk-unity/mrtk2), and shows how the MRTK can speed up your development process.

> [!div class="nextstepaction"]
> [HoloLens 2 fundamentals](/training/paths/beginner-hololens-2-tutorials)

## Mixed reality design and prototyping

Before you start designing and prototyping mixed reality software, read and understand the following articles:

- [Mixed reality design guidance](/windows/mixed-reality/design/about-this-design-guidance?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Mixed reality core concepts](/windows/mixed-reality/design/core-concepts-landingpage?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Types of mixed reality apps](/windows/mixed-reality/discover/types-of-mixed-reality-apps?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Interaction models](/windows/mixed-reality/design/interaction-fundamentals?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [UX elements overview](/windows/mixed-reality/design/app-patterns-landingpage?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

> [!div class="nextstepaction"]
> [Start designing and prototyping](/windows/mixed-reality/design?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json).

## Path to production

Choose the mixed reality engine you want to use for development. You can select from Unity, Unreal, native, or web development paths.

> [!div class="nextstepaction"]
> [Choose a mixed reality engine](/windows/mixed-reality/develop/choosing-an-engine?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

Get the tools you need to build applications for Microsoft HoloLens and Windows Mixed Reality immersive headsets, and get set up.

> [!div class="nextstepaction"]
> [Install the tools](/windows/mixed-reality/develop/install-the-tools?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

## Best practices

Follow these best practices to design, develop, and deliver high-quality, user-friendly mixed reality apps.

- [Design content for holographic display](/windows/mixed-reality/design/designing-content-for-holographic-display?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) describes elements to consider for the best holographic experience.
- [Comfort](/windows/mixed-reality/design/comfort?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) explains how to create and present content that mimics cues in the natural world and avoids fatiguing motions.
- [Spatial sound best practices](/windows/mixed-reality/design/spatial-sound-design?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) discusses how to use sound to inform and reinforce the user's mental model in the mixed-reality world.
- [App quality criteria overview](/windows/mixed-reality/develop/advanced-concepts/app-quality-criteria-overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) presents the top factors that affect mixed reality app quality.

## Scenarios and solution ideas

The following implementations and ideas illustrate some ways to adapt and configure mixed reality for various scenarios.

- [Shared experiences in mixed reality](/windows/mixed-reality/design/shared-experiences-in-mixed-reality?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Free-roaming multiuser VR experiences](/windows/mixed-reality/enthusiast-guide/free-roam-vr-multiuser-experiences?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Prototyping and manufacturing for enterprises](/windows/mixed-reality/enthusiast-guide/prototyping-manufacturing?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Training and simulation for enterprises](/windows/mixed-reality/enthusiast-guide/training-simulation?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Immersive education](/windows/mixed-reality/enthusiast-guide/immersive-education?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Theme parks and family entertainment centers](/windows/mixed-reality/enthusiast-guide/theme-parks-family-entertainment?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Virtual museums, exhibits, and tourism](/windows/mixed-reality/enthusiast-guide/virtual-museums?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Virtual reality arcades](/windows/mixed-reality/enthusiast-guide/virtual-reality-arcades?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

Solution ideas:

- [Design review with mixed reality](../../solution-ideas/articles/collaborative-design-review-powered-by-mixed-reality.yml)
- [Facilities management with mixed reality and IoT](../../solution-ideas/articles/facilities-management-powered-by-mixed-reality-and-iot.yml)
- [Training and procedural guidance with mixed reality](../../solution-ideas/articles/training-and-procedural-guidance-powered-by-mixed-reality.yml)

> [!div class="nextstepaction"]
> [Mixed reality samples and apps](/windows/mixed-reality/develop/features-and-samples?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

## Stay current with mixed reality

Mixed reality is changing fast. Explore the expanding world of mixed reality applications with the Mixed Reality Toolkit (MRTK), Windows Mixed Reality, Unity, Unreal, and more for HoloLens and Windows Immersive Headsets.

> [!div class="nextstepaction"]
> [Mixed reality documentation](/windows/mixed-reality)
