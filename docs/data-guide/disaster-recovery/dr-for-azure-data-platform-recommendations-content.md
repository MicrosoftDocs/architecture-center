## Lessons learned

- Ensure that all the parties involved understand the difference between high availability (HA) and disaster recovery (DR). Confusing these concepts can result in mismatched solutions.

- To define the recovery point objectives (RPOs) and recovery time objectives (RTOs), discuss with business stakeholders their expectations regarding the following factors:

  - The amount of downtime that they can tolerate. Keep in mind that faster recovery usually incurs a higher cost.

  - The types of incidents that stakeholders need protection against and how likely they are to occur. For instance, a server failure is more likely to happen than a natural disaster that affects all datacenters in a region.

  - The effects of system unavailability on their business.

  - The operational expenses (OPEX) budget for the long-term solution.

- Consider which degraded service options your end-users can accept. These options might include:

  - Access to visualization dashboards, even if the data isn't up-to-date. In this scenario, end-users can view their data, even if ingestion pipelines fail.

  - Read access without write capabilities.

- Your target RTO and RPO metrics determine the DR strategy that you choose to implement. These strategies include active/active, active/passive, and active/redeploy on disaster. Consider your own [composite service-level objective](/azure/well-architected/reliability/metrics) to factor in the tolerable downtimes.

- Ensure that you understand all the components that might affect the availability of your systems, such as:

  - Identity management.

  - Networking topology.

  - Secret management and key management.

  - Data sources.

  - Automation and job scheduling.

  - Source repository and deployment pipelines like GitHub and Azure DevOps.

- Early detection of outages is also a way to decrease RTO and RPO values significantly. Include the following key factors:

  - Define what an outage is and how it maps to the definition of an outage according to Microsoft. The Microsoft definition is available on the [Azure service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/) page at the product or service level.

  - Implement an efficient monitoring and alerting system with accountable teams that review metrics and alerts promptly to support the goal.

- For subscription design, extra infrastructure for DR can reside in the original subscription. Platform as a service (PaaS) offerings like Azure Data Lake Storage typically include native failover features. These capabilities support secondary instances in other regions while remaining within the original subscription. To optimize costs, some organizations choose to allocate a dedicated resource group exclusively for DR-related resources.

  - [Subscription limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) might introduce constraints in this approach.

  - Other constraints might include the design complexity and management controls to ensure that the DR resource groups aren't used for business-as-usual workflows.

- Design the DR workflow based on the criticality and dependencies of a solution. For example, don't try to rebuild an Azure Analysis Services instance before your data warehouse is operational because it triggers an error. Leave development labs for later in the process and recover core enterprise solutions first.

- Identify recovery tasks that can be parallelized across solutions. This approach reduces the total RTO.

- If your solution uses Fabric pipelines, include on-premises data gateways in the scope. Use [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) for these machines.

- Automate manual operations as much as possible to prevent human error, especially when under pressure. We recommend that you:

  - Adopt resource provisioning through Bicep, Azure Resource Manager templates (ARM templates), Terraform, or PowerShell scripts.

  - Adopt versioning of source code and resource configuration.

  - Use continuous integration and continuous delivery release pipelines instead of select-ops.

- Because you have a plan for failover, you should consider procedures to fall back to the primary instances.

- Define clear indicators and metrics to validate that the failover is successful and that solutions are operational. Confirm that performance is back to normal, also known as *primary functional*.  

- Decide if your SLAs should remain unchanged after a failover or if you allow for a temporary reduction in service quality. This decision greatly depends on the business service process being supported. For example, the failover for a room-booking system is much different than a core operational system.

- Base an RTO or RPO definition on specific user scenarios instead of at the infrastructure level. This approach provides greater granularity in how to determine which processes and components you should prioritize for recovery during an outage or disaster.

- Ensure that you perform capacity checks in the target region before you proceed with a failover. In a major disaster, many customers might attempt to fail over to the same paired region simultaneously. This scenario can result in delays or contention in resource provisioning. If these risks are unacceptable, consider either an active/active or active/passive DR strategy.

- You must create and maintain a DR plan to document the recovery process and the action owners. Keep in mind that some team members might be on leave, and ensure that secondary contacts are included.

- Perform regular DR drills to validate the DR plan workflow, ensure that it meets the required RTO and RPO requirements, and train the responsible teams. Regularly test data and configuration backups to ensure that they're *fit for purpose*, which means that they're suitable and effective for their intended use. This process ensures that they can support recovery activities.

- Early collaboration with teams responsible for networking, identity, and resource provisioning facilitates agreement on the most optimal solution for how to:

  - Redirect users and traffic from your primary to your secondary site. Concepts such as Domain Name System redirection or the use of specific tooling like [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) can be evaluated.

  - Provide access and rights to the secondary site in a timely and secure manner.

- During a disaster, effective communication between the many parties involved is key to the efficient and rapid implementation of the plan. Teams might include:

  - Decision-makers.
  - Incident response teams.
  - Affected internal users and teams.
  - External teams.

- Orchestration of the different resources at the right time ensures efficiency in the DR plan implementation.

## Considerations

### Antipatterns

- **Copy/paste this article series**

   This article series provides guidance for customers seeking a deeper understanding of an Azure-specific DR process. It's based on the generic Microsoft intellectual property and reference architectures instead of any single customer-specific Azure implementation.

   This content provides a strong foundational understanding. But customers must tailor their approach by considering their unique context, implementation, and requirements to develop a fit-for-purpose DR strategy and process.  

- **Treat DR as a tech-only process**

  Business stakeholders are crucial in defining the requirements for DR and completing the business validation steps required to confirm a service recovery.  

  Ensuring that business stakeholders are engaged across all DR activities provides a DR process that's fit for purpose, represents business value, and is implementable.  

- **"Set and forget" DR plans**

  Azure is constantly evolving, as is the way individual customers use various components and services. A fit-for-purpose DR process must evolve with them.  

  Customers should regularly reassess their DR plan through the software development life cycle or periodic reviews. This strategy keeps the service recovery plan valid and properly addresses any changes across components, services, or solutions.

- **Paper-based assessments**

  The end-to-end simulation of a DR event is difficult to perform across a modern data ecosystem. However, efforts should be made to get as close as possible to a complete simulation across affected components.  

  Regularly scheduled drills help an organization develop the instinctive ability to confidently implement the DR plan.

- **Relying on Microsoft to do it all**

  Microsoft Azure services define a clear [shared responsibility model for reliability](/azure/reliability/concept-shared-responsibility) based on the cloud service tier.
  
  ![Diagram that shows the shared responsibility model.](../images/shared-responsibility-model.png)  

  Even if a full [software-as-a-service stack](https://azurecharts.com/overview/?f=saas) is used, the customer retains the responsibility to ensure that the accounts, identities, and data are correct and up-to-date, along with the devices used to interact with the Azure services.  

## Event scope and strategy  

### Disaster event scope  

Different events have varying scopes of impact that require different responses. The following diagram illustrates the scope of impact and response for a disaster event.

![Diagram that shows the event scope and recovery process.](../images/dr-for-azure-data-platform-event-scope.png)  

### Disaster strategy options  

There are four high-level options for a DR strategy:  

- **Wait for Microsoft**

  As the name suggests, the solution is offline until the complete recovery of services in the affected region by Microsoft. After recovery, the customer validates the solution, and it's then updated to help ensure service recovery.

- **Redeploy on disaster**

  The solution is manually redeployed as a fresh deployment into an available region after a disaster event.

- **Warm spare (active/passive)**

  A secondary hosted solution is created in an alternate region and components are deployed to guarantee minimal capacity. However, the components don't receive production traffic.

  The secondary services in the alternative region might be *turned off*, or run at a lower performance level until a DR event occurs.  

- **Hot spare (active/active)**

  The solution is hosted in an active/active setup across multiple regions. The secondary hosted solution receives, processes, and serves data as part of the larger system.  

### DR strategy effects  

The operating cost attributed to the higher levels of service reliability often plays a major role in the [key design decision](/azure/architecture/framework/cost/tradeoffs#cost-vs-reliability) for a DR strategy, but other important factors should also be considered.

> [!NOTE]  
> [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is one of the five pillars of architectural excellence within the [Azure Well-Architected Framework](/azure/well-architected/pillars). Its goal is to reduce unnecessary expenses and improve operational efficiencies.  

The DR scenario for this worked example is a complete Azure regional outage that directly affects the primary region that hosts the Contoso Data Platform.

The following table is a comparison between the options. A strategy that has a green indicator is better for that classification than a strategy that has an orange or red indicator.

![Diagram that shows the effects of the outage on the DR strategies.](../images/dr-for-azure-data-platform-strategy.png)  

### Classification key

For this outage scenario, the relative impact on the four high-level DR strategies is based on the following factors:  

- **RTO:** The expected elapsed time from the disaster event to platform service recovery.  

- **Complexity to execute:** The complexity for the organization to carry out the recovery activities.  

- **Complexity to implement:** The complexity for the organization to implement the DR strategy.  

- **Customer impact:** The direct impact to customers of the data platform service from the DR strategy.  

- **Above-the-line OPEX cost:** The extra cost expected from implementing this strategy, like increased monthly billing for Azure for extra components and extra resources required to support.

## Next steps

- [Mission-critical workload](/azure/architecture/framework/mission-critical/mission-critical-overview)
- [Well-Architected Framework recommendations for designing a DR strategy](/azure/well-architected/reliability/disaster-recovery)

## Related resources

- [DR for Azure Data Platform - Overview](dr-for-azure-data-platform-overview.yml)
- [DR for Azure Data Platform - Architecture](dr-for-azure-data-platform-architecture.yml)
- [DR for Azure Data Platform - Scenario details](dr-for-azure-data-platform-scenario-details.yml)
