---
title: Performance considerations for your deployment infrastructure
description: Describes considerations to make regarding your deployment infrastructure.
author: UmarMohamedUsman
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Performance considerations for your deployment infrastructure

Build status shows if your product is in a deployable state, so builds are the heartbeat of your continuous delivery system. It’s important to have a build process up and running from the first day of your product development. Since builds provide such a crucial information about the status of your product, you should always strive for fast builds.

It will be hard to fix build problem if it takes longer to build, and the team will suffer from a broken window disorder. Eventually, nobody cares if the build is broken since it's always broken and it takes lot of effort to fix it.

## Build times

Here are few ways you can achieve faster builds.

* **Selecting right size VMs:** Speeding up your builds starts with selecting the right size VMs. Fast machines can make the difference between hours and minutes. If your pipelines are in Azure Pipelines, then you've got a convenient option to run your jobs using a Microsoft-hosted agent. With Microsoft-hosted agents, maintenance and upgrades are taken care of for you. For more info see, [Microsoft-hosted agents](/azure/devops/pipelines/agents/hosted?view=azure-devops).

* **Build server location:** When you're building your code, a lot of bits are moved across the wire, so inputs to the builds are fetched from a source control repository and the artifact repository, such as source code, NuGet packages, etc. At the end, the output from the build process needs to be copied, not only the compiled artifacts, but also test reports, code coverage results, and debug symbols. So it is important that these copy actions are fast. If you are using your own build server, ensure that the build server is located near the sources and a target location, and it can reduce the duration of your build considerably.

* **Scaling out build servers:** A single build server may be sufficient for a small product, but as the size and the scope of the product and the number of teams working on the product increases, the single server may not be enough. Scale your infrastructure horizontally over multiple machines when you reach the limit. For more info see, how you can leverage [Azure DevOps Agent Pools](/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml).

* **Optimizing the build:**

  * Add parallel build execution so we can speed up the build process. For more info see, [Azure DevOps parallel jobs](/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops).

  * Enable parallel execution of test suites, which is often a huge time saver, especially when executing integration and UI tests. For more info see, [Run tests in parallel using Azure Pipeline](/azure/devops/pipelines/test/parallel-testing-any-test-runner?view=azure-devops).

  * Use the notion of a multiplier, where you can scale out your builds over multiple build agents. For more info see, [Organizing Azure Pipeline into Jobs](/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml).

  * Move a part of the test feedback loop to the release pipeline. This improves the build speed, and hence the speed of the build feedback loop.

  * Publish the build artifacts to the package management system solution, and hence publish to a NuGet feed at the end of a build.

## Human intervention

It's important to select different builds for different purpose.

* **CI builds:** Purpose of this build is to ensure it compiles and unit tests run. This build gets triggered at each commit or set of commits over a period of time. It serves as the heartbeat of the project, provides quality feedback to the team immediately. For more info see, [CI triggers or Batching CI builds](/azure/devops/pipelines/build/triggers?view=azure-devops&tabs=yaml).

* **Nightly build:** Purpose of this build is not only to compile but also ensure necessary integration/regression tests are run. This build can take up some more time, because we need to do some extra steps to get additional information about the product. For example, metrics about the state of the software using SonarQube. It may also contain a set of regression tests and integration tests and it may also deploy the solution to a temporary machine to verify the solution is continuing to work. For more info see, [scheduling builds using cron syntax](/azure/devops/pipelines/build/triggers?view=azure-devops&tabs=yaml#scheduled-triggers)

* **Release build:** Besides compiling, running test this build additionally compiles the API documentation, compliance reports, code signing, and other steps which are not required every time the code is built. Finally this build provide the golden copy that will be pushed to the release pipeline to finally deploy in the production environment. Generally release build is gets triggered manually instead of a CI trigger.
