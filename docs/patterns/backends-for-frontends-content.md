Decouple backend services from the frontend implementations to tailor experiences for different client interfaces. This pattern is based on [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/) described by Sam Newman.

## Context and problem

Consider an application that was initially designed with a desktop web UI and a corresponding backend service. As business requirements changed over time, a mobile inteface was added. Both interfaces interact with the same backend service but the capabilities of a mobile device differ significantly from a desktop browser, in terms of screen size, performance, and display limitations.

![Context-and-problem diagram of the Backends for Frontends pattern](./_images/backend-for-frontend.png)

The backend service often faces competing demands from different frontends, leading to frequent changes and potential bottlenecks in the development process. Conflicting updates and the need to maintain compatibility result in excessive work on a single deployable resource. Having a separate team manage the backend service can create a disconnect between frontend and backend teams, causing delays in gaining consensus and balancing requirements. For example, changes requested by one frontend team must be validated with other frontend teams before integration.


## Solution

Introduce a new layer that handles only the UI-specific requirements. This layer, called the backend-for-frontend (BFF) service, sits between the frontend UI and the backend service. If the application supports multiple interfaces, create a BFF service for each interface. For example, if you have a web interface and a mobile app, you would create separate BFF services for each. 

> This pattern tailors the frontend to a specific interface, without affecting other frontend experiences. It also fine-tunes the performance to best match the needs of the frontend environment. Not only is each BFF service smaller and less complex, but it is also faster than a generic backend.
>
> Frontend teams have autonomy over their own BFF service, allowing flexibility in language selection, release cadence, workload prioritization, and feature integration without relying on a centralized backend development team. 

While many BFFs relied on REST APIs, GraphQL implementations are becoming a common alternative, which removes the need for the BFF layer because the querying mechanism doesn't require a separate endpoint.

![Diagram of the Backends for Frontends pattern](./_images/backend-for-frontend-example.png)

For more information, see [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/).

## Issues and considerations

- Consider what the optimal number of services is for you, as this will have associated costs. Maintaining and deploying more services means increased operational overhead. Each individual service has its own life cycle, maintenance requirements, and security needs.

- 

- If different interfaces (such as mobile clients) will make the same requests, consider whether it is necessary to implement a backend for each interface, or if a single backend will suffice.
- Code duplication across services is highly likely when implementing this pattern.
- Frontend-focused backend services should only contain client-specific logic and behavior. General business logic and other global features should be managed elsewhere in your application.
- Think about how this pattern might be reflected in the responsibilities of a development team.
- Consider how long it will take to implement this pattern. Will the effort of building the new backends incur technical debt, while you continue to support the existing generic backend?

## When to use this pattern

Use this pattern when:

- A shared or general purpose backend service must be maintained with significant development overhead.
- You want to optimize the backend for the requirements of specific client interfaces.
- Customizations are made to a general-purpose backend to accommodate multiple interfaces.
- A programming language is better suited for the backend of a specific user interface, but not all user interfaces.

This pattern may not be suitable:

- When interfaces make the same or similar requests to the backend.
- When only one interface is used to interact with the backend.

## Workload design

An architect should evaluate how the Backends for Frontends pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Having separate services that are exclusive to a specific frontend interface contains malfunctions so the availability of one client might not affect the availability of another client's access. Also, when you treat various clients differently, you can prioritize reliability efforts based on expected client access patterns.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | Because of service separation introduced in this pattern, the security and authorization in the service layer that supports one client can be tailored to the functionality required by that client, potentially reducing the surface area of an API and lateral movement among different backends that might expose different capabilities.<br/><br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation)<br/> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | The backend separation enables you to optimize in ways that might not be possible with a shared service layer. When you handle individual clients differently, you can optimize performance for a specific client's constraints and functionality.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Next steps

- [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/)

## Related resources

- [Gateway Aggregation pattern](./gateway-aggregation.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Gateway Routing pattern](./gateway-routing.yml)
