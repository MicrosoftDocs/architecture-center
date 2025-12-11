Route requests to multiple services or multiple service instances using a single endpoint. The pattern is useful when you want to:

- Expose multiple services on a single endpoint and route to the appropriate service based on the request
- Expose multiple instances of the same service on a single endpoint for load balancing or availability purposes
- Expose differing versions of the same service on a single endpoint and route traffic across the different versions

## Context and problem

When a client needs to consume multiple services, multiple service instances or a combination of both, the client must be updated when services are added or removed. Consider the following scenarios.

- **Multiple disparate services** - An e-commerce application might provide services such as search, reviews, cart, checkout, and order history. Each service has a different API that the client must interact with, and the client must know about each endpoint in order to connect to the services. If an API changes, the client must be updated as well. If you refactor a service into two or more separate services, the code must change in both the service and the client.
- **Multiple instances of the same service** - The system can require running multiple instances of the same service in the same or different regions. Running multiple instances can be done for load balancing purposes or to meet availability requirements. Each time an instance is spun up or down to match demand, the client must be updated.
- **Multiple versions of the same service** - As part of the deployment strategy, new versions of a service can be deployed along side existing versions. This is known as blue green deployments. In these scenarios, the client must be updated each time there are changes to the percentage of traffic being routed to the new version and existing endpoint.

## Solution

Place a gateway in front of a set of applications, services, or deployments. Use application Layer 7 routing to route the request to the appropriate instances.

With this pattern, the client application only needs to know about a single endpoint and communicate with a single endpoint. The following illustrate how the Gateway Routing pattern addresses the three scenarios outlined in the context and problem section.

### Multiple disparate services

:::image source="./_images/gateway-multiple-services.png" alt-text="Diagram of the gateway sitting in front of a search service, a checkout service, an order history service, a cart service and a reviews service.":::

The gateway routing pattern is useful in this scenario where a client is consuming multiple services. If a service is consolidated, decomposed or replaced, the client doesn't necessarily require updating. It can continue making requests to the gateway, and only the routing changes.

A gateway also lets you abstract backend services from the clients, allowing you to keep client calls simple while enabling changes in the backend services behind the gateway. Client calls can be routed to whatever service or services need to handle the expected client behavior, allowing you to add, split, and reorganize services behind the gateway without changing the client.

### Multiple instances of the same service

:::image source="./_images/gateway-multiple-regions.png" alt-text="Diagram of the gateway sitting in front of a search service in region 1 and a search service in region 2.":::

Elasticity is key in cloud computing. Services can be spun up to meet increasing demand or spun down when demand is low to save money. The complexity of registering and unregistering service instances is encapsulated in the gateway. The client is unaware of an increase or decreases in the number of services.

Service instances can be deployed in a single or multiple regions. The [Geode pattern](./geodes.yml) details how a multi-region, active-active deployment can improve latency and increase availability of a service.

### Multiple versions of the same service

:::image source="./_images/gateway-multiple-versions.png" alt-text="Diagram of the gateway sitting in front of a search service version 1 and a search service version 1.1.":::

This pattern can be used for deployments, by allowing you to manage how updates are rolled out to users. When a new version of your service is deployed, it can be deployed in parallel with the existing version. Routing lets you control what version of the service is presented to the clients, giving you the flexibility to use various release strategies, whether incremental, parallel, or complete rollouts of updates. Any issues discovered after the new service is deployed can be quickly reverted by making a configuration change at the gateway, without affecting clients.

## Issues and considerations

- The gateway service can introduce a single point of failure. Ensure it's properly designed to meet your availability requirements. Consider resiliency and fault tolerance capabilities in the implementation.
- The gateway service can introduce a bottleneck. Ensure the gateway has adequate performance to handle load and can easily scale in line with your growth expectations.
- Perform load testing against the gateway to ensure you don't introduce cascading failures for services.
- Gateway routing is level 7. It can be based on IP, port, header, or URL.
- Gateway services can be global or regional. Azure Front Door is a global gateway, while Azure Application Gateway is regional. Use a global gateway if your solution requires multi-region deployments of services. Consider using Application Gateway if you have a regional workload that requires granular control how traffic is balanced. For example, you want to balance traffic between virtual machines.
- The gateway service is the public endpoint for services it sits in front of. Consider limiting public network access to the backend services, by making the services only accessible via the gateway or via a private virtual network.

## When to use this pattern

Use this pattern when:

- A client needs to consume multiple services that can be accessed behind a gateway.
- You want to simplify client applications by using a single endpoint.
- You need to route requests from externally addressable endpoints to internal virtual endpoints, such as exposing ports on a VM to cluster virtual IP addresses.
- A client needs to consume services running in multiple regions for latency or availability benefits.
- A client needs to consume a variable number of service instances.
- You want to implement a deployment strategy where clients access multiple versions of the service at the same time.

This pattern might not be suitable when you have a simple application that uses only one or two services.

## Workload design

An architect should evaluate how the Gateway Routing pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Gateway routing enables you to route traffic to only healthy nodes in your system.<br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy)<br/> - [RE:10 Health monitoring](/azure/well-architected/reliability/monitoring-alerting-strategy) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | Gateway routing enables you to decouple requests from backends, which in turn enables your backends to support advanced deployment models, platform transitions, and a single point of management for domain name resolution and encryption in transit.<br/><br/> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | Gateway routing enables you to distribute traffic across nodes in your system to balance load.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

Using Nginx as the router, the following example shows a configuration file for a server that routes requests for applications residing on different virtual directories to different machines at the back end.

```console
server {
    listen 80;
    server_name domain.com;

    location /app1 {
        proxy_pass http://10.0.3.10:80;
    }

    location /app2 {
        proxy_pass http://10.0.3.20:80;
    }

    location /app3 {
        proxy_pass http://10.0.3.30:80;
    }
}
```

The following Azure services can be used to implement the gateway routing pattern:

- An [Application Gateway instance](/azure/application-gateway/tutorial-multiple-sites-cli), which provides regional layer-7 routing.
- An [Azure Front Door instance](/azure/frontdoor), which provides global layer-7 routing.

## Related resources

- [Backends for Frontends pattern](./backends-for-frontends.md)
- [Gateway Aggregation pattern](./gateway-aggregation.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
