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



## Continious integration

Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early. The key details to note are that you need to run code integration multiple times a day, every day, and you need to run the automated verification of the integration. What's the motivation for this? Well, in the development process, the earlier we surface errors, the better. And one source of frequently occurring errors is the code integration step.

## Continuous integration pipelines

## Testing

Automating tests is the best way to make sure that they are executed. Depending on how frequently tests are performed, they are typically limited in duration and scope, as the different types of automated tests will show:

### Unit Testing

Unit tests are tests typically run by each new version of code committed into version control. Unit Tests should be extensive (should cover ideally 100% of the code) and quick (typically under 30 seconds, although this number is not a rule set in stone). Unit testing could verify things like the syntax correctness of application code, Resource Manager templates or Terraform configurations, that the code is following best practices, or that they produce the expected results when provided certain inputs.

Unit tests should be applied both to application code and infrastructure code.

### Smoke Testing

Smoke tests are more exhaustive than unit tests, but still not as much as integration tests. They normally run in less than 15 minutes. Still not verifying the interoperability of the different components with each other, smoke tests verify that each of them can be correctly built and offers the expected functionality and performance.

Smoke tests usually involve building the application code, and if infrastructure, possibly testing the deployment in a test environment.

### Integration Testing

After making sure that the different application components operate correctly individually, integration testing has as goal determine whether they can interact with each other as they should. Integration tests usually take longer than smoke testing, and as a consequence they are sometimes executed not as frequently. For example, running integration tests every night still offers a good compromise, detecting interoperability issues between application components no later than one day after they were introduced.

### Acceptance Testing

There are many different ways of confirming that the application is doing what it should.

* **Blue/Green deployments**: when deploying a new application version, you can deploy it in parallel to the existing one. This way you can start redirecting clients to the new version, and if everything goes well you will decommission the old version. If there is any problem with the new deployment, you can always redirect the users back to the old one.
* **Canary releases**: you can expose new functionality of your application (ideally using feature flags) to a select group of users. If users are satisfied with the new functionality, you can extend it to the rest of the user community. In this case we are talking about releasing functionality, and not necessarily about deploying a new version of the application.
* **A/B testing**: A/B testing is similar to canary release-testing, but while canary releases focus on mitigate risk, A/B testing focus on evaluating the effectiveness of two similar ways of achieving different goals. For example, if you have two versions of the layout of a certain area of your application, you could send half of your users to one, the other half to the other, and use some metrics to see which layout works better for the application goals.

An important aspect to consider is how to measure the effectiveness of new features in the application. A way to do that is through [Application Insights User Behavior Analytic][telemetry], with which you can determine how people are using your application. This way you can decide whether a new feature has improved your applications without bringing effects such as decreasing usability.

Certain services in Azure offer functionality that can help with this kind of tests, such as the [slot functionality][slots] in the Azure App Service, that allows having two different versions of the same application running at the same time, and redirect part of the users to one or the other.

### Stress tests

As other sections of this framework have explained, designing your application code and infrastructure for scalability is of paramount importance. Testing that you can increase the application load and that both the code and the infrastructure will react to it is critical, so that your environment will adapt to changing load conditions.

During these stress tests, it is critical monitoring all the components of the system to identify whether there is any bottleneck. Every component of the system not able to scale out can turn into a scale limitation, such as active/passive network components or databases. It is hence important knowing their limits so that you can mitigate their impact into the application scale. This exercise might drive you to changing some of those components for more scalable counterparts.

It is equally important verifying that after the stress test is concluded, the infrastructure scales back down to its normal condition in order to keep costs under control.

### Business Continuity Drills

Certain infrastructure test scenarios can be considered under the category of acceptance testing, such as Business Continuity drills. In particular Disaster Recovery scenarios are difficult to test on-premises, but the public cloud makes this kind of tests easier. Tools such as Azure Site Recovery make it possible starting an isolated copy of the primary location in a secondary environment, so that it can be verified that the applications have come up as they should.

In case there is any problem, the Disaster Recovery procedure can be optimized, and the infrastructure in the secondary environment can be deleted.

### Exploratory Testing

Experts explore the application in its entirety trying to find faults or suboptimal implementations of functionality. These experts could be developers, UX specialists, product owners, actual users, and other profiles. Test plans are typically not used, since testing is left to the ability of the individual tester.

### Fault injection

The same concept can be applied to the infrastructure. If the application should be resilient to infrastructure failures, introducing faults in the underlying infrastructure and observing how the application behaves is fundamental for increasing the trust in your redundancy mechanisms. Shutting down ungracefully infrastructure components, degrading the performance of certain elements such as network equipment or introducing faults purposely in the environment are ways of verifying that the application is going to react as expected when these situations occur in real life.

Most companies use a controlled way of injecting faults in the system, although if confident with the application resiliency, automated frameworks could be used. A new science has been developed around fault injection, called Chaos Engineering.

## Packaging

#### Next steps

> [!div class="nextstepaction"]
> [Release Engineering: Continuous deployment](./release-engineering-cd.md)