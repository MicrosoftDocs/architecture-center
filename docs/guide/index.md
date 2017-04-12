# Azure Application Architecture Guide

The cloud is changing the way applications are designed. Instead of monoliths, applications are decomposed into smaller, decentralized services. These services communicate through APIs or by using asynchronous messaging or eventing. Applications scale horizontally, adding new instances as demand requires. These trends bring new challenges. Application state is distributed. Operations are done in parallel and asynchronously. The system as a whole must be resilient when failures occur. Deployments must be automated and predictable. Monitoring and telemetry are critical for gaining insight into the system.

This guide presents a structured approach for designing applications on Azure that are scalable, resilient, and highly available. It is intended for architects and engineers who are designing solutions for Azure. 

<table>
<thead>
    <tr><th>Traditional on-premises</th><th>Modern cloud</th></tr>
</thead>
<tbody>
<tr><td>Monolithic, centralized<br/>
Design for predictable scalability<br/>
Relational database<br/>
Strong consistency<br/>
Serial and synchronized processing<br/>
Design to avoid failures (MTBF)<br/>
Occasional big updates<br/>
Manual management<br/>
Snowflake servers</td>
<td>
Decomposed, de-centralized<br/>
Design for elastic scale<br/>
Polyglot persistence (mix of storage technologies)<br/>
Eventual consistency<br/>
Parallel and asynchronous processing<br/>
Design for failure. (MTTR)<br/>
Frequent small updates<br/>
Automated self-management<br/>
Immutable infrastructure<br/>
</td>
</tbody>
</table>


## How this guide is structured

<object data="./images/guide-steps.svg" type="image/svg+xml"></object>

It describes a series of steps on the path from design to implementation. Each step involves decisions about the architecture, starting with the most fundamental: What kind of architecture are you building? A Microservices architecture? A more traditional N-tier application? A Big Data solution?

As you move from design to implementation, the descisions become more granular and local. Should you place a message queue between two components? Can the application recover from a transient network failure? Using a structured approach helps you to keep the right focus at each stage. You move from the big picture to the particulars, and avoid making premature techical decisions early in the process.

For each step of the process, we point to related guidance on the Azure Architecture Center. This guide serves as a roadmap, while the supporting content goes deeper into each area.

Next: [Choose an architecture style](./architecture-styles/index.md)

