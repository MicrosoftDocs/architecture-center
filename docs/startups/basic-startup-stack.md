---
title: The Basic Startup Stack
description: Understand how to approach architecture when you are building a first MVP or prototype for a startup.
author: mootpointer
ms.date: 05/15/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
---

# The Basic Startup Stack

## Approach

It is tempting to take all the lessons learned in previous roles and apply it to a startup’s first stack. However, many lessons learned in larger companies may not be directly applicable to a startup. A Service-Oriented Architecture or microservices may be appropriate for a business that is scaling in the expand phase or that is operating at the extract phase, but it is rarely the right choice for a startup that has not found product market fit, and almost definitely not right for the first iteration of a product. The complexity brought by such architectures can often lead to reductions in both speed and optionality.

Our recommendation for a first startup stack is simple. Many technologists might even describe it as boring. Believe it or not, that’s a good thing. If your infrastructure is boring, then that means you’ve spent enough time on it to have it get out of your way. An _"interesting"_ stack can be problematic in two ways – it can be the cause of bugs and require constant attention (bugs aren't always due to complexity but having a complex stack makes it easier to ship bugs) or it can be so sophisticated that it is sucking valuable development energy from moving your product forward.

Below is a simple diagram of the Basic Startup Stack – a recommended set of components that provide just enough to get your product off the ground and into the hands of your customers. For 80% of startups, this stack will be all you need to test the basic hypotheses built into your product. For some (for example those doing machine learning, working with IoT, or working in highly regulated environments), other components may be required. See Extending your architecture below for examples.

## Components

### App Server

First and foremost, your code needs to run somewhere. Ideally this platform should make deployments easy, while requiring the least amount of operational input as possible. The app server should be able to scale, however some manual intervention for scaling is fine while you are still in the explore stage.

Like most of this stack, you want to be able to forget about this – knowing that it will essentially run itself. Traditionally the app server would have been a virtual machine, or even an instance of a web server running on a bare-metal server. Now we look to Platform as a Service (PaaS) options and containers as they remove the operational overhead.

### Database

Once you have your code running somewhere, you need to store your data somewhere. That’s where your database comes in. For most cases, we’d suggest a relational database like Azure SQL, PostgreSQL, or MariaDB. While there are cases where a document database like MongoDB or CosmosDB is appropriate, a relational database provides both the optionality of multiple paradigms, and the speed that comes from being a well-trodden path.

### Continuous Integration/Continuous Deployment (CI/CD)

One of the greatest impediments to speed as you’re iterating on a product can be repeatable and rapid deployments. A well-configured CI/CD pipeline mean that the process of taking code and getting it deployed on your app server is a non-event. This quick and easy deployment means that you can see the results of your labor quickly and frequent integration avoids divergent code-bases, which often lead to conflicts when they are eventually merged.

### Monitoring

If something goes wrong with your app, you want to spend as little time as possible finding out what. The days of logging into an app server to pour over logs should be over. By aggregating logs and using application tracing from day one you allow your team to focus on the problems themselves rather than getting the data to diagnose the problems.

### Static Assets

<!-- TODO -->

TODO

### Content Delivery Network (CDN)

<!-- TODO -->

TODO

## Example
