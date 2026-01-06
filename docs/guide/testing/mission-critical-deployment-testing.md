---
title: Continuous validation with Azure Load Testing and Azure Chaos Studio
description: Guide on performing automated continuous validation in production-like environments with Azure Load Testing and Chaos Studio.
author: heoelri
ms.author: msimecek
ms.date: 01/30/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: mission-critical
---

# Continuous validation with Azure Load Testing and Azure Chaos Studio

As cloud-native applications and services become more complex, deploying changes and new releases for them can be challenging. Outages are frequently caused by faulty deployments or releases. But **errors can also occur after deployment**, when an application starts receiving real traffic, especially in complex workloads that run in highly distributed multitenant cloud environments and that are maintained by multiple development teams. These environments require more resiliency measures, like retry logic and autoscaling, which are usually hard to test during the development process.

That's why **continuous validation in an environment that's similar to the production environment is important**, so that you can find and fix any problems or bugs as early in the development cycle as possible. Workload teams should test early in the development process (shift left) and make it convenient for developers to do testing in an environment that's close to the production environment.

Mission-critical workloads have high availability requirements, with targets of 3, 4, or 5 nines (99.9%, 99.99%, or 99.999%, respectively). It's crucial to implement **rigorous automated testing** to reach those goals.

Continuous validation depends on each workload and on architectural characteristics. This article provides a guide for preparing and integrating Azure Load Testing and Azure Chaos Studio into a regular development cycle.

## 1 – Define tests based on expected thresholds

Continuous testing is a complex process that requires proper preparation. What is tested and the expected outcomes must be clear.

In [PE:06 - Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test) and [RE:08 - Recommendations for designing a reliability testing strategy](/azure/well-architected/reliability/testing-strategy), the Azure Well-Architected Framework recommends that you start by **identifying key scenarios, dependencies, expected usage, availability, performance, and scalability targets**.

You should then define a set of **measurable threshold values** to quantify the expected performance of the key scenarios.

> [!TIP]
> Examples of threshold values include the expected number of user sign-ins, requests per second for a given API, and operations per second for a background process.

You should use threshold values to develop a **[health model for your application](/azure/architecture/framework/mission-critical/mission-critical-health-modeling)**, both for testing and for operating the application in production.

![Visualization of key system flows using green and red connected circles.](./images/deployment-testing-key-system-flows.png)

Next, use the values to define a **load test** that generates realistic traffic for testing application baseline performance, and for validating expected scale operations. Sustained artificial user traffic is needed in pre-production environments, because without usage it's difficult to reveal runtime issues.

Load testing ensures that changes made to the application or infrastructure don't cause issues and the system still meets the expected performance and test criteria. A failed test run that doesn't meet the test criteria indicates that you need to adjust the baseline, or that an unexpected error occurred.

![Load test run results screen showing failed load test run.](./images/deployment-testing-failed-load-test-run.png)

Even though automated tests represent day-to-day usage, **you should run manual load tests regularly** to verify how the system responds to unexpected peaks.

The second part of continuous validation is the **injection of failures** (chaos engineering). This step verifies the resiliency of a system by testing how it responds to faults. Also, that all the resiliency measures, such as retry logic, autoscaling, and others, are working as expected.

## 2 - Implement validation with Load Testing and Chaos Studio

Microsoft Azure provides these managed services to implement load testing and chaos engineering:

- **[Azure Load Testing](/azure/load-testing/)** produces synthetic user load on applications and services.
- **[Azure Chaos Studio](/azure/chaos-studio/)** provides the ability to perform chaos experimentation, by systematically injecting failures into application components and infrastructure.

You can deploy and configure both Chaos Studio and Load Testing via the Azure portal, but, in the context of continuous validation, it's more important that you have APIs to deploy, configure, and run tests in a **programmatic and automated way**. Using these two tools together enables you to observe how the system reacts to problems and its ability to self-heal in response to infrastructure or application failures.

The following video shows a [combined implementation of Chaos and Load Testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#demo-continuous-validation-with-azure-load-test-and-azure-chaos-studio) integrated in Azure DevOps:

> [!VIDEO 393a9ab4-6816-4bbf-9c25-94a34a5413e0]

If you're developing a mission-critical workload, take advantage of the detailed guidance provided as part of the [Azure Well-Architected Framework](/azure/architecture/framework/mission-critical).

One option is to execute the load test directly from within the end-to-end (e2e) pipeline that is used to spin up individual (branch specific) development environments:

![Run pipeline screen with the load testing checkbox ticked.](./images/deployment-testing-pipeline-start.png)

The pipeline automatically runs a load test, with or without chaos experiments (depending on the selection) in parallel:

![Azure DevOps pipeline run with chaos and load testing.](./images/deployment-testing-pipeline-run.png)

> [!NOTE]
> Running chaos experiments during a load test can result in higher latency, higher response times and temporarily increased error rates. Expect higher response times and latency until a scale-out operation completes or a failover has completed, when compared to a run without chaos experiments.

![Chart showing increased response time during chaos experiment.](./images/deployment-testing-response-time.png)

Depending on whether chaos testing is enabled and the choice of experiments, baseline definitions might vary, because the tolerance for errors can be different in "normal" state and "chaos" state.

## 3 – Adjust thresholds and establish a baseline

Finally, **adjust the load test thresholds** for regular runs to verify that the application (still) provides the expected performance and doesn't produce any errors. Have a separate baseline for chaos testing that tolerates expected spikes in error rates and temporary reduced performance. This activity is continuous and needs to be repeated regularly. For example, after introducing new features, changing service SKUs, and others.

The Azure Load Testing service provides a built-in capability called **test criteria** that allows specifying certain criteria that a test needs to pass. This capability can be used to implement different baselines.

![Test criteria screen with response time and error criteria marked as Failed.](./images/deployment-testing-test-criteria.png)

The capability is available through the Azure portal, and via the load testing API, and the wrapper scripts developed as part of Azure Mission-critical provide an option to handover a JSON-based baseline definition.

We highly recommend **integrating these tests directly into your CI/CD pipelines** and running them during the early stages of feature development.

In summary, failure is inevitable in any complex distributed system and the solution must therefore be architected (and tested) to handle failures. The [Well-Architected Framework mission-critical workload guidance](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing) and reference implementations can help you design and operate highly reliable applications to derive maximum value from the Microsoft cloud.

## Next step

Review the deployment and testing design area for mission-critical workloads.

> [!div class="nextstepaction"]
> [Design area: Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing)

## Related resources

- [Azure Load Testing documentation](/azure/load-testing/)
- [Azure Chaos Studio documentation](/azure/chaos-studio/)
