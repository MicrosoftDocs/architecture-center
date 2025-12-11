---
title: Design for Operations
description: Learn about functions of the operations team for cloud-based applications, including deployment, monitoring, incident response, and security auditing.
author: claytonsiemens77
ms.author: pnp
ms.date: 08/30/2018
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Design for operations

## Design an application to equip the operations team

The shift to the cloud has fundamentally changed the role of the operations team. They're no longer responsible for managing the hardware and infrastructure that hosts the application. However, operations remain crucial for running a successful cloud application. Key functions include:

- Deployment.
- Monitoring.
- Escalation.
- Incident response.
- Security auditing.

Robust logging and tracing are especially important in cloud applications. Include the operations team in design and planning to ensure that they receive the data and insights they need for success.  <!-- to do: Link to DevOps checklist -->

## Recommendations

**Make all things observable.** After a solution is deployed and operational, logs and traces are your primary insight into the system. *Tracing* records a path through the system. Use tracing to pinpoint bottlenecks, performance problems, and failure points. *Logging* captures individual events such as application state changes, errors, and exceptions. Enable logging in production, or you can lose crucial insights when you need them most.

**Instrument for monitoring.** Monitoring provides insight into an application's performance, including availability, efficiency, and system health. For example, it shows whether you're meeting your service-level agreement. Monitoring occurs during the system's normal operation and should be as close to real-time as possible. This approach helps ensure that the operations staff can react to problems quickly. Ideally, effective monitoring helps prevent problems before they escalate into critical failures. For more information, see [Monitoring and diagnostics][monitoring].

**Instrument for root cause analysis.** Root cause analysis is the process of finding the underlying cause of failures. It takes place after a failure occurs.

**Use distributed tracing.** Use a distributed tracing system designed for concurrency, asynchrony, and cloud scale. Traces should include a correlation ID that flows across service boundaries. A single operation might include calls to multiple application services. If an operation fails, the correlation ID helps to pinpoint the cause of the failure.

**Standardize logs and metrics.** The operations team needs to aggregate logs from across the various services in your solution. If every service uses its own logging format, it becomes difficult or impossible to retrieve useful information. Define a common schema that includes fields such as correlation ID, event name, and IP address of the sender. Individual services can derive custom schemas that inherit the base schema and can contain extra fields.

**Automate management tasks**, including provisioning, deployment, and monitoring. Automating a task makes it repeatable and less prone to human error.

**Treat configuration as code.** Store configuration files in a version control system so that you can track and version your changes and roll back changes if needed.

<!-- links -->

[monitoring]: ../../best-practices/monitoring.yml
