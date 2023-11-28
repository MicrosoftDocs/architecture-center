---
title: Continuous validation with Azure Load Testing and Azure Chaos Studio
description: Guide on performing automated continuous validation in production-like environments with Azure Load Testing and Chaos Studio.
author: heoelri
ms.author: msimecek
ms.date: 11/28/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.custom: mission-critical
categories: azure
products:
- chaos-studio
- load-testing
---
# Continuous validation with Azure Load Testing and Azure Chaos Studio

Deploying changes and new releases for cloud-native applications and services can be challenging as they become more complex - many outages are caused by faulty deployments or releases. But **errors can also happen after the deployment** when an application starts receiving real traffic, especially in complex workloads that run in highly distributed, multi-tenant cloud environments, and that have multiple development teams working on them. These environments require more resiliency measures, such as retry logic and autoscaling, which are usually hard to test during the development process.

That's why **continuous validation in an environment that is similar to production is important**, so that you can find and fix any problems or bugs as soon as possible in the development cycle. Workload teams should test early in the development process (shift left) and make it convenient for developers to do testing that is close to production.

Mission-critical workloads have high availability requirements in levels of 3, 4, or 5 nines (99.9%, 99.99% or 99.999% respectively). It's crucial to have **rigorous automated testing** to reach that goal.

Continuous validation depends on each workload and architectural characteristics. This article provides a guide on how to prepare and integrate Azure Load Testing and Azure Chaos Studio into the regular development cycle.

## 1 – Define tests based on expected thresholds

Continuous testing is a complex process that requires proper preparation in order to be effective. It must be clear what is tested and what are the expected outcomes.

The Azure Well-Architected Framework suggests in [PE:06 - Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test) and [RE:08 - Recommendations for designing a reliability testing strategy](/azure/well-architected/reliability/testing-strategy) to start by **identifying key scenarios, dependencies, expected usage, availability, performance, and scalability targets**.

Then, define a set of **measurable threshold values** to quantify the expected performance of the key scenarios.

> [!TIP]
> Expected number of user logins, requests per second of a given API, operations per second of a background process, are examples of threshold values.

Threshold values should be used to develop a **[health model for the application](/azure/architecture/framework/mission-critical/mission-critical-health-modeling)** not only for testing but also for operating the application in production.

![Visualization of key system flows using green and red connected circles.](./images/deployment-testing-key-system-flows.png)

Next, use the numbers to define a **load test** that generates realistic traffic for testing application baseline performance, validating expected scale operations, and so on. Sustained artificial user traffic is needed in pre-production environments, because without usage it's difficult to reveal any runtime issues.

Load testing ensures that changes made to the application or infrastructure don't cause issues and the system still meets the expected performance and test criteria. A failed test run that doesn't meet the test criteria indicates that you need to adjust the baseline, or that an unexpected error occurred.

![Load test run results screen showing failed load test run.](./images/deployment-testing-failed-load-test-run.png)

Even though automated tests represent day-to-day usage, **manual load tests should be regularly executed** to verify how the system responds to unexpected peaks.

The second part of continuous validation is the **injection of failures** (chaos engineering). This step verifies the resiliency of a system by testing how it responds to faults. Also, that all the resiliency measures, such as retry logic, autoscaling, and others, are working as expected.

## 2 - Implement validation with Load Testing and Chaos Studio

Microsoft Azure provides these managed services to implement load testing and chaos engineering:

- **[Azure Load Testing](/azure/load-testing/)** produces synthetic user load on applications and services.
- **[Azure Chaos Studio](/azure/chaos-studio/)** provides the ability to perform chaos experimentation, by systematically injecting failures into application components and infrastructure.

Both Azure Chaos Studio and Load Testing can be deployed and configured through Azure portal, but in the context of continuous validation it's more important that there are APIs available to deploy, configure and execute tests in a **programmatic and automated way**. Using the tools together allows you to observe how the system reacts to issues and its ability to self-heal in response to infrastructure or application failures.

The following video shows a [combined implementation of Chaos and Load Testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#demo-continuous-validation-with-azure-load-test-and-azure-chaos-studio) integrated in Azure DevOps:

> [!VIDEO https://www.microsoft.com/en-us/videoplayer/embed/RE4Y50k]

If you are developing a mission-critical workload, take advantage of the reference architectures, detailed guidance, sample implementations, and code artifacts provided as part of the [Azure Mission-Critical project](https://github.com/Azure/Mission-Critical) and [Azure Well-Architected Framework](/azure/architecture/framework/mission-critical). 

It deploys the Azure Load Testing service through Terraform and contains a [collection of PowerShell Core wrapper scripts](https://github.com/Azure/Mission-Critical-Online/tree/main/src/testing/loadtest-azure/scripts) to interact with the service via its API. These scripts can be embedded directly into a deployment pipeline.

One option in the reference implementation is to execute the load test directly from within the end-to-end (e2e) pipeline that is used to spin up individual (branch specific) development environments:

![Run pipeline screen with the load testing checkbox ticked.](./images/deployment-testing-pipeline-start.png)

The pipeline will automatically run a load test, with or without chaos experiments (depending on the selection) in parallel:

![Azure DevOps pipeline run with chaos and load testing.](./images/deployment-testing-pipeline-run.png)

> [!NOTE]
> Running chaos experiments during a load test can result in higher latency, higher response times and temporarily increased error rates. You'll notice higher numbers until a scale-out operation completes or a failover has completed, when compared to a run without chaos experiments.

![Chart showing increased response time during chaos experiment.](./images/deployment-testing-response-time.png)

Depending on whether chaos testing is enabled and the choice of experiments, baseline definitions might vary, because the tolerance for errors can be different in "normal" state and "chaos" state.

## 3 – Adjust thresholds and establish a baseline

Finally, **adjust the load test thresholds** for regular runs to verify that the application (still) provides the expected performance and doesn't produce any errors. Have a separate baseline for chaos testing that tolerates expected spikes in error rates and temporary reduced performance. This activity is continuous and needs to be repeated regularly. For example, after introducing new features, changing service SKUs, and others.

The Azure Load Testing service provides a built-in capability called **test criteria** that allows specifying certain criteria that a test needs to pass. This capability can be used to implement different baselines.

![Test criteria screen with response time and error criteria marked as Failed.](./images/deployment-testing-test-criteria.png)

The capability is available through the Azure portal, and via the load testing API, and the wrapper scripts developed as part of Azure Mission-critical provide an option to handover a JSON-based baseline definition.

We highly recommend **integrating these tests directly into your CI/CD pipelines** and running them during the early stages of feature development. For an example, see the [sample implementation](https://github.com/Azure/Mission-Critical-Online/tree/main/src/testing/) in the Azure Mission-critical reference implementation.

In summary, failure is inevitable in any complex distributed system and the solution must therefore be architected (and tested) to handle failures. The [Azure Well-Architected Framework mission-critical workload guidance](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing) and reference implementations can you help design and operate highly reliable applications to derive maximum value from the Microsoft cloud.

## Next step

Review the deployment and testing design area for mission-critical workloads.

> [!div class="nextstepaction"]
> [Design area: Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing)

## Related resources

- [Azure Load Testing documentation](/azure/load-testing/)
- [Azure Chaos Studio documentation](/azure/chaos-studio/)
