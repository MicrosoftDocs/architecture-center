---
title: Testing your Application and Azure Environment
description: Describes DevOps testing considerations to make when designing your workload.
author: jose-moreno
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Testing your Application and Azure Environment

Testing is one of the fundamental components and DevOps and agile development in general. If automation gives DevOps the required speed and agility to deploy software quickly, only through extensive testing those deployments will achieve the required reliability that customers demand.

A main tenet of a DevOps practice to achieve system reliability is the "Shift Left" principle. If developing and deploying an application is a process depicted as a series of steps going from left to right, testing should not only be performed at the very end of the process (at the right). It should be shifted as much to the beginning (to the left) as possible, errors are cheaper to repair when caught early and can be expensive or impossible to fix later in the application life cycle.

Another aspect to consider is that testing should occur on both application code as well as infrastructure code and they should be subject to the same quality controls. As described in  [Infrastructure as Code][iac], the environment where applications are running should be version-controlled and deployed through the same mechanisms as application code, and hence can be tested and validated using DevOps testing paradigms too.

You can use your favorite testing tool to run your tests, including [Azure Pipelines][pipelines] for automated testing and [Azure Testing Plans][devopstests] for manual testing.

There are multiple stages at which tests can be performed in the life cycle of code, and each of them has some particularities that is important to understand. In this guide, you can find a summary of the different tests that you should consider while developing and deploying applications.

## Automated Testing

Automating tests is the best way to make sure that they are executed. Depending on how frequently tests are performed, they are typically limited in duration and scope, as the different types of automated tests will show:

### Unit Testing

Unit tests are tests typically run by each new version of code committed into version control. Unit Tests should be extensive (should cover ideally 100% of the code) and quick (typically under 30 seconds, although this number is not a rule set in stone). Unit testing could verify things like the syntax correctness of application code, Resource Manager templates or Terraform configurations, that the code is following best practices, or that they produce the expected results when provided certain inputs.

Unit tests should be applied both to application code and infrastructure code.

### Smoke Testing

Smoke tests are more exhaustive than unit tests, but still not as much as integration tests. They normally run in less than 15 minutes. Still not verifying the interoperability of the different components with each other, smoke tests verify that each of them can be correctly built and offers the expected functionality and performance.

Smoke tests usually involve building the application code, and if infrastructure, possibly testing the deployment in a test environment.


### Integration Testing

After making sure that the different application components operate correctly individually, integration testing has as goal determine whether they can interact with each other as they should. Integration tests usually take longer than smoke testing, and as a consequence they are sometimes executed not as frequently. For example, running integration tests every night still offers a good compromise, detecting interoperability issues between application components no later than one day after they were introduced.

## Application Manual Testing

Manual testing is much more expensive than automated testing, and as a consequence it is run much less frequently. However, manual testing is fundamental for the correct functioning of the DevOps feedback loop, to correct errors before they become too expensive to repair, or cause customer dissatisfaction.

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

## Summary

In order to deploy software quickly and reliably, testing is a fundamental component of the development and deployment life cycle. Not only application code should be tested, but infrastructure automation and resiliency should equally be put to the test, to make sure that the application is going to perform as expected in every situation.

<!-- testing -->
[iac]: /azure/architecture/framework/devops/iac
[pipelines]: /azure/devops/pipelines
[devopstests]: /azure/devops/test
[telemetry]: /azure/azure-monitor/app/usage-overview
[slots]: /azure/app-service/deploy-staging-slots
