---
title: DevOps checklist
titleSuffix: Azure Architecture Center
description: Use this checklist to assess your DevOps culture and process. DevOps integrates development, QA, and IT operations into a unified set of processes.
author: martinekuan
ms.author: katienovotny
ms.date: 03/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-devops
  - azure-monitor
categories:
  - devops
ms.custom:
  - checklist
  - fcp
checklist:
  - devops
  - management-and-governance
---

# DevOps checklist

DevOps is the integration of development, quality assurance, and IT operations into a unified culture and set of processes for delivering software. Use this checklist as a starting point to assess your DevOps culture and process.

## Culture

**Ensure business alignment across organizations and teams.** Conflicts over resources, purpose, goals, and priorities within an organization can be a risk to successful operations. Ensure that business, development, and operations teams are aligned.

**Ensure that your team understands your software life cycle.** Your team needs to understand the overall life cycle of your applications, and where each application is within that life cycle. Having this information helps all team members know what they should do now, and what they should plan and prepare for in the future.

**Reduce cycle time.** Aim to minimize the time that it takes to move from ideas to usable developed software. Limit the size and scope of individual releases to keep the test burden low. Automate build, test, configuration, and deployment processes whenever possible. Clear any obstacles to communication among developers, and between developers and operations teams.

**Review and improve processes.** Your processes and procedures, both automated and manual, are never final. Set up regular reviews of current workflows, procedures, and documentation, with a goal of continual improvement.

**Do proactive planning.** Proactively plan for failure. Have processes in place to quickly identify problems when they occur, escalate problems to the correct team members to fix, and confirm their resolution.

**Learn from failures.** Failures are inevitable, but it's important to learn from failures to avoid repeating them. If an operational failure occurs, triage the problem, document the cause and solution, and share any lessons that you learn. Whenever possible, update your build processes to automatically detect such failures in the future.

**Optimize for speed, and collect data.** Every planned improvement is a hypothesis. Work in the smallest increments that are possible. Treat new ideas as experiments. Instrument the experiments so that you can collect production data to assess experiment effectiveness. Be ready to fail fast if the hypothesis is wrong.

**Allow time for learning.** Failures and successes provide opportunities for learning. Before you move on to new projects, allow time to gather important lessons, and make sure that your team absorbs those lessons. Also give your team time to build skills, experiment, and learn about new tools and techniques.

**Document operations.** Document all tools, processes, and automated tasks with the same level of quality as your product code. Document the current design and architecture of any systems that you support, along with recovery processes and other maintenance procedures. Focus on the steps that you actually do, not theoretically optimal processes. Regularly review and update your documentation. For code, make sure to include meaningful comments, especially in public APIs. Use tools to generate code documentation automatically whenever possible.

**Share knowledge.** Documentation is only useful if people know that it exists and can find it. Keep your documentation organized, and make it easily discoverable. Be creative: use brown bags (informal presentations), videos, or newsletters to share knowledge.

## Development

**Provide developers with production-like environments.** If development and test environments don't match your production environment, it's hard to test and diagnose problems. Keep development and test environments as close to your production environment as possible. Make sure that test data is consistent with the data that you use in production, even if it's sample data and not real production data (for privacy or compliance reasons). Plan to generate and anonymize sample test data.

**Ensure that all authorized team members can provision infrastructure and deploy applications.** Setting up production-like resources and deploying an application shouldn't involve complicated manual tasks or detailed technical knowledge of a system. Anyone with the right permissions should be able to create or deploy production-like resources without going to your operations team.

This recommendation doesn't imply that anyone can push live updates to a production deployment. It's about reducing friction for development and QA teams to create production-like environments.

**Instrument each application for insight.** To understand the health of your applications, you need to know how they perform and whether they experience any errors or problems. Always include instrumentation as a design requirement, and build instrumentation into each application from the start. Instrumentation must include event logging for root cause analysis, but also telemetry and metrics to monitor the health and usage of each application.

**Track your technical debt.** Many projects prioritize release schedules over code quality to one degree or another. Always document when shortcuts are taken or other suboptimal implementations, and schedule time to revisit these issues.

**Consider pushing updates directly to production.** To reduce your overall release cycle time, consider pushing properly tested code commits directly to production. Use [feature toggles][feature-toggles] to control which features you enable. Then you can move quickly from development to release by using the toggles to enable or disable features. Toggles are also useful when you perform tests like [canary releases][canary-release], where you deploy a particular feature to a subset of your production environment.

## Testing

**Automate testing.** Manually testing software is tedious and susceptible to error. Automate common testing tasks, and integrate the tests into your build processes. Automated testing ensures consistent test coverage and reproducibility. When you run integrated UI tests, also use an automated tool. Azure offers development and test resources that can help you configure and run testing. For more information, see [Develop and test on Azure][dev-test].

**Test for failures.** When a system can't connect to a service, the system should respond gracefully. And when the service is available again, the system should recover. Make fault-injection testing a standard part of review on test and staging environments. When your test process and practices are mature, consider running these tests in production.

**Test in production.** A release process doesn't end with deployment to production. Have tests in place to ensure that deployed code works as expected. For deployments that you update infrequently, schedule production testing as a regular part of maintenance.

**Automate performance testing to identify performance problems early.** The impact of a serious performance problem can be as severe as a bug in code. Although automated functional tests can prevent application bugs, these tests might not detect performance problems. Define acceptable performance goals for metrics like latency, load times, and resource usage. Include automated performance tests in your release pipeline to make sure that your application meets those goals.

**Perform capacity testing.** An application might work fine under test conditions and then have problems in production because of scale or resource limitations. Always define the maximum expected capacity and usage limits. Test to make sure that the application can handle those limits, but also test what happens when you exceed those limits. Do capacity testing at regular intervals.

After an initial release, you should run performance and capacity tests whenever you update production code. Use historical data to fine-tune tests and to determine what types of tests you need to do.

**Perform automated security penetration testing.** Ensuring the security of your application is as important as testing any other functionality. Make automated penetration testing a standard part of your build and deployment process. Schedule regular security tests and vulnerability scanning on deployed applications, monitoring for open ports, endpoints, and attacks. Automated testing doesn't remove the need for in-depth security reviews at regular intervals.

**Perform automated business continuity testing.** Develop tests for large-scale business continuity, including backup recovery and failover. Set up automated processes to perform these tests regularly.

## Release

**Automate deployments.** Automation provides many benefits, including:

- Enabling faster and more reliable deployments.
- Ensuring consistent deployments to any supported environment, including test, staging, and production.
- Removing the risk of human error that manual deployments can introduce.
- Making it easy to schedule releases for convenient times, which minimizes any effects of potential downtime.

Automate the process of deploying each application to your test, staging, and production environments. Have systems in place to detect any problems during rollout, and have an automated way to roll forward fixes or roll back changes.

**Use continuous integration.** Continuous integration (CI) is the practice of merging all developer code into a central code base on a regular schedule, and then automatically performing standard build and test processes. CI ensures that an entire team can work on a code base at the same time without conflicts. CI also helps you find code defects as early as possible. Preferably, a CI process should run every time that you commit or check in code. It should run at least once per day.

Consider adopting a [trunk-based development model][trunk-based]. In this model, developers commit to a single branch (the trunk). There's a requirement that commits never break a build. This model facilitates CI, because you do all feature work in the trunk, and you resolve any merge conflicts when each commit happens.

**Consider using continuous delivery.** Continuous delivery (CD) is the practice of ensuring that code is always ready to deploy, by automatically building, testing, and deploying code to production-like environments. Adding CD to create a full CI/CD pipeline helps you detect code defects as soon as possible. It also ensures that you can release properly tested updates in a short time.

Continuous *deployment* is a process that automatically takes any updates that have passed through a CI/CD pipeline and deploys them into production. Continuous deployment requires robust automatic testing and advanced process planning. It might not be appropriate for all teams.

**Make small, incremental changes.** Large code changes have a greater potential to introduce bugs than smaller ones do. Whenever possible, keep changes small. Doing so limits the potential effects of each change and simplifies the task of understanding and debugging problems.

**Control exposure to changes.** Make sure that you're in control of when updates become visible to your end users. Consider using feature toggles to control when you turn on features for end users.

**Implement release management strategies to reduce deployment risk.** Deploying an application update to production always entails some risk. To minimize this risk, use strategies like [canary releases][canary-release] or [blue/green deployments][blue-green] to deploy updates to a subset of users. Confirm that each update works as expected, and then roll out each update to the rest of the system.

**Document all changes.** Minor updates and configuration changes can be a source of confusion and versioning conflict. Always keep a clear record of any changes, no matter how small. Log everything that changes, including patches that you applied, policy changes, and configuration changes. The record of the changes should be visible to your entire team. But don't include sensitive data in these logs. For example, log that a credential was updated, and who made the change, but don't record the updated credentials.

**Consider making infrastructure immutable.** Immutable infrastructure is based on the principle that you shouldn't modify infrastructure after you deploy it to production. Otherwise, you can get into a state where ad hoc changes have been applied, making it hard to know exactly what changed. Immutable infrastructure works by replacing entire servers as part of any new deployment. With this approach, you can test and deploy your code and your hosting environment as a block. After deployment, you don't modify infrastructure components until the next build and deploy cycle.

## Monitoring

**Make systems observable.** Your operations team should always have clear visibility into the health and status of a system or service. Set up external health endpoints to monitor status, and code applications to instrument operations metrics. Use a common and consistent schema that helps you correlate events across systems. The standard method of tracking the health and status of Azure resources is to use [Azure Diagnostics][azure-diagnostics] and [Application Insights][app-insights]. [Azure Monitor][azure-monitor] also provides centralized monitoring and management for cloud or hybrid solutions.

**Aggregate and correlate logs and metrics**. A properly instrumented telemetry system provides a large amount of raw performance data and event logs. Make sure that your system processes and correlates telemetry and log data quickly, so that operations staff always has an up-to-date picture of system health. Organize and display data so that you have a cohesive view of problems and can see when events are related to one another.

Consult your corporate retention policy for requirements on how to process data and how long to store data.

**Implement automated alerts and notifications.** Set up monitoring tools like [Monitor][azure-monitor-service-page] to detect patterns or conditions that indicate potential or current problems. Send alerts to team members who can address problems. Tune the alerts to avoid false positives.

**Monitor assets and resources for expirations.** Some resources and assets, like certificates, expire. Be sure to track which assets expire, when they expire, and what services or features depend on them. Use automated processes to monitor these assets. Notify your operations team before an asset expires, and escalate the situation if expiration threatens to disrupt applications.

## Management

**Automate operations tasks.** Manually handling repetitive operations processes is error-prone. Automate these tasks whenever possible to ensure consistent execution and quality. Use source control to version code that implements the automation. As with any other code, test your automation tools.

**Take an infrastructure-as-code approach to provisioning.** Minimize the amount of manual configuration that you need to provision resources. Instead, use scripts and [Azure Resource Manager][resource-manager] templates. Keep the scripts and templates in source control, like any other code that you maintain.

**Consider using containers.** Containers provide a standard package-based interface for deploying applications. When you use containers, you deploy an application by using self-contained packages that include any software, dependencies, and files that you need to run the application. This practice greatly simplifies the deployment process.

Containers also create an abstraction layer between an application and the underlying operating system, which provides consistency across environments. This abstraction can also isolate a container from other processes or applications that run on a host.

**Implement resiliency and self-healing.** Resiliency is the ability of an application to recover from failures. Strategies for resiliency include retrying transient failures, and failing over to a secondary instance or even to another region. For more information, see [Design reliable Azure applications](/azure/architecture/framework/resiliency/app-design). Instrument your applications to report problems immediately so that you can manage outages or other system failures.

**Have an operations manual.** An operations manual, or *runbook*, documents the procedures and management information that you need for operations staff to maintain a system. Also document any operations scenarios and mitigation plans that might come into play during a failure or other disruption to your service. Create this documentation during your development process, and keep it up to date afterwards. Treat these resources as living documents that you need to review, test, and improve regularly.

Shared documentation is critical. Encourage team members to contribute and share knowledge. Your entire team should have access to documents. Make it easy for anyone on the team to help keep documents updated.

**Document on-call procedures.** Make sure to document on-call duties, schedules, and procedures, and to share them with all team members. Always keep this information up to date.

**Document escalation procedures for third-party dependencies.** If your application depends on external third-party services that you don't directly control, you need a plan to deal with outages. Create documentation for your planned mitigation processes. Include support contacts and escalation paths.

**Use configuration management.** Plan configuration changes, make them visible to operations, and record them. You might use a configuration management database or a configuration-as-code approach for these purposes. Audit configuration regularly to ensure that expected settings are actually in place.

**Get an Azure support plan and understand the support process.** Azure offers many [support plans][azure-support-plans]. Determine the right plan for your needs, and make sure that your entire team knows how to use the plan. Team members should understand the details of the plan, how the support process works, and how to open a support ticket with Azure. If you're expecting a high-scale event, Azure support can assist you with increasing your service limits. For more information, see [Azure support plans FAQs](https://azure.microsoft.com/support/legal/faq).

**Follow least-privilege principles when you grant access to resources.** Carefully manage access to resources. Deny access by default, unless you explicitly give a user access to a resource. Only grant users access to what they need for completing their tasks. Track user permissions and perform regular security audits.

**Use Azure role-based access control.** Assigning user accounts and access to resources shouldn't be a manual process. Use [Azure role-based access control (Azure RBAC)][rbac] to grant access that's based on [Azure Active Directory (Azure AD)][azure-ad] identities and groups.

**Use a bug tracking system to track problems.** Without a good way to track problems, it's easy to miss items, duplicate work, or introduce new problems. Don't rely on informal person-to-person communication to track the status of bugs. Use a bug tracking tool to record details about problems, assign resources to address them, and provide an audit trail of progress and status.

**Manage all resources in a change management system.** If you include all aspects of your DevOps process in a management and versioning system, you can easily track and audit changes. Include code, infrastructure, configuration, documentation, and scripts. Treat all these types of resources as code throughout the process of testing, building, and reviewing.

**Use checklists.** Operations checklists can help you follow processes. It's easy to miss something in a large manual, but following a checklist can force attention to details that you might otherwise overlook. Maintain the checklists, and continually look for ways to automate tasks and streamline processes.

## Next steps

- [What is DevOps?][what-is-devops]
- [Azure DevOps documentation](/azure/devops)
- [Get started with Azure DevOps](/training/paths/evolve-your-devops-practices)
- [The DevOps journey at Microsoft](https://azure.microsoft.com/solutions/devops/devops-at-microsoft)

## Related resources

- [CI/CD baseline architecture with Azure Pipelines](../example-scenario/apps/devops-dotnet-baseline.yml)
- [Automate multistage Azure pipelines with Azure Pipelines](../example-scenario/devops/automate-azure-pipelines.yml)
- [CI/CD for Azure VMs](../solution-ideas/articles/cicd-for-azure-vms.yml)
- [CI/CD for containers](../solution-ideas/articles/cicd-for-containers.yml)

<!-- links -->

[app-insights]: /azure/azure-monitor/app/app-insights-overview
[azure-ad]: https://azure.microsoft.com/services/active-directory
[azure-diagnostics]: /azure/monitoring-and-diagnostics/azure-diagnostics
[azure-monitor]: /azure/monitoring-and-diagnostics/monitoring-overview
[azure-support-plans]: https://azure.microsoft.com/support/plans
[blue-green]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[canary-release]:https://martinfowler.com/bliki/CanaryRelease.html
[dev-test]: https://azure.microsoft.com/solutions/dev-test
[feature-toggles]: https://www.martinfowler.com/articles/feature-toggles.html
[azure-monitor-service-page]: https://azure.microsoft.com/services/monitor
[rbac]: /azure/role-based-access-control/overview
[resource-manager]: /azure/azure-resource-manager
[trunk-based]: https://trunkbaseddevelopment.com
[what-is-devops]: https://azure.microsoft.com/overview/what-is-devops
