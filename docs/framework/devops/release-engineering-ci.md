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

As code is developed, updated, or even removed, having a friction-free and safe method to integrate these changes into the main code branch is paramount to enabling developers to provide value fast. As a developer, making small code changes, pushing these to a code repository, and getting almost instantaneous feedback on the quality, test coverage, and introduced bugs allows me to work faster, with more confidence, and less risk. Continuous integration is a practice where source control systems and software deployment pipelines are integrated to provide automated build, test, and feedback mechanisms for software development teams. 

Continuous integration is about ensuring that software is ready for deployment but does not include the deployment itself. This document covers the basics of continuous integration and offers links and examples for more in-depth content.

## Continious integration

Continuous integration is a software development practice under which developers integrate software updates into a source control system on a regular cadence. The continuous integration process starts when an engineer creates a pull request signaling to the CI system that code changes ready to be integrated. Ideally, integration validates the code against several baselines and tests and provides quick feedback to the requesting engineer on the status of these tests. Assuming baseline checks and testing have gone well, the integration process produces and stages assets such as compiled code and container images that will eventually deploy the updated software.

As a software engineer, continuous integration can help me deliver quality software more quickly by performing the following:

- Run automated tests against the code, providing early detection of breaking changes.
- Run code analysis to ensure code standards, quality, and configuration.
- Run compliance and security checks ensuring no known vulnerabilities.
- Run acceptance or functional tested to ensure that the software operates as expected.
- Provide quick feedback on detected issues.
- Where applicable, produce deployable assets or packages that include the updated code.

To achieve continuous integration, we need software solutions to manage, integrate, and automate the process. A common practice is to use a continuous integration pipeline, detailed in the next section of this document.

## Continuous integration pipelines

## Packaging

## Tradeoffs

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Continuous deployment](./release-engineering-cd.md)