---
title: Release Engineering Continuous integration
description: Release Engineering Continuous integration
author: neilpeterson
ms.date: 09/28/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Release Engineering: Continuous integration

As code is developed, updated, or even removed, having a friction-free and safe method to integrate these changes into the main code branch is paramount to enabling developers to provide value fast.

## Continious integration

Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early. The key details to note are that you need to run code integration multiple times a day, every day, and you need to run the automated verification of the integration. What's the motivation for this? Well, in the development process, the earlier we surface errors, the better. And one source of frequently occurring errors is the code integration step.

## Continuous integration pipelines

## Packaging

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Continuous deployment](./release-engineering-cd.md)