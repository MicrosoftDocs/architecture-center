# Architecture styles

An *architecture style* is a family of architectures that share certain characteristics. For example, [N-tier][n-tier] is a common architecture style. More recently, [microservice architectures][microservices] have started to gain favor. 

Architecture styles don't require the use of particular technologies, but some technologies are well-suited for certain architectures. For example, containers are a natural fit for microservices.  

## A quick tour of the styles	

This section gives a quick tour of the architecture styles that we've identified, along with some high-level considerations for their use. For each style, you can follow the link to get more detail about each style, including:

- A logical diagram.
- Recommendations for when to choose the style.
- Benefits and challenges.
- A diagram showing a recommended deployment, with the relevant Azure services.

### N-tier

<img src="./images/n-tier-sketch.svg" style="float:left; margin-top:6px;"/>

**[N-tier][n-tier]** is a traditional architecture for enterprise applications. Dependencies are managed by dividing the application into *layers* that perform logical functions, such as presentation, business logic, and data access. A layer can only call into layers that sit below it. However, this horizontal layering can be a liability. It can be hard to introduce changes in one part of the application without touching the rest of the application. That makes frequent updates a challenge, limiting how quickly new features can be added.

N-tier is a natural fit for migrating existing applications that already use a layered architecture. For that reason, N-tier is most often seen in IaaS solutions, or application that use a mix of infrastructure as a service (IaaS) <<RBC:  I decided to go ahead and define here and you can decide later if you don't think it's necessary for the audience.>> and managed services. 

### Web-queue-worker <<RBC: We need to settle on a consistent capitalization strategy for this. I looked at web-queue-worker.md and it's not capped consistently there either. I decided to follow the Azure guidelines about not capitalizing things unless it's a specific named feature. That includes headings, although I concede this looks a little weird.>>

<img src="./images/web-queue-worker-sketch.svg" style="float:left; margin-top:6px;"/> <<RBC: Web should probalby just be lowercase in the image.>>

For a purely platform as a service (PaaS) <<RBC: I defined this because the style guide says to, but I question whether the audience needs it. Also, I commented on IaaS in the big-compute.md file because there's not great way to define there with how the content is written (only appears in the heading).>> solution, consider a **[web-queue-worker](./web-queue-worker.md)** architecture. In this style, the application has a web front end that handles HTTP requests, and a back-end worker that performs CPU-intensive tasks or long-running operations. The front end communicates to the worker through an asynchronous message queue. 

Web-queue-worker is suitable for relatively simple domains with some resource-intensive tasks. Like N-tier, the architecture is easy to understand. The use of managed services simplifies deployment and operations. But with a complex domains, it can be hard to manage dependencies. The front end and the worker can easily become large, monolithic components that are hard to maintain and update. As with N-tier, this can reduce the frequency of updates and limit innovation.

### Microservices

<img src="./images/microservices-sketch.svg" style="float:left; margin-top:6px;"/>

If your application has a more complex domain, consider moving to a **[microservices][microservices]** architecture. A microservices application is composed of many small, independent services. Each service implements a single business capability. Services are loosely coupled, communicating through API contracts.

Each service can be built by a small, focused development team. Individual services can be deployed without a lot of coordination between teams, which encourages frequent updates. A microservice architecture is more complex to build and manage than either N-tier or web-queue-worker. It requires a mature development and DevOps culture. But done right, this style can lead to higher release velocity, faster innovation, and a more resilient architecture. 

### CQRS

<img src="./images/cqrs-sketch.svg" style="float:left; margin-top:6px;"/>

The **[CQRS](./cqrs.md)** (Command and Query Responsibility Segregation) style separates read and write operations into separate models. This isolates the parts of the system that update data from the parts that read the data. Moreover, reads can be executed against a materialized view that is physically separate from the write database. That lets you scale the read and write workloads independently, and optimize the materialized view for queries.

CQRS makes the most sense when it's applied to a subsystem of a larger architecture. Generally, you shouldn't impose it across the entire application, as that will just create unneeded complexity. Consider it for collaborative domains where many users access the same data.

### Event-driven architecture 

<img src="./images/event-driven-sketch.svg" style="float:left; margin-top:6px;"/>

**[Event-driven architectures](./event-driven.md)** use a publish-subscribe (pub-sub) model, where producers publish events, and consumers subscribe to them. The producers are independent from the consumers, and consumers are independent from each other. 

Consider an event-driven architecture for applications that ingest and process a large volume of data with very low latency, such as IoT solutions. The style is also useful when different subsystems must perform different types of processing on the same event data.


### Big data, big compute <<RBC: After much searching I decided to settle on lowercase for these. There's really no reason for them to be capped, and "big data" is specifically only lowercase in the style guide. There are only a few references to this concept in the Azure docs online and they're not consistent.>>

**[Big data](./big-data.md)** and **[big compute](./big-compute.md)** are specialized architectural styles for workloads that fit certain specific profiles. Big data divides a very large dataset into chunks, performing paralleling processing across the entire set, for analysis and reporting. Big compute, also called high-performance computing (HPC), makes parallel computations across a large number (thousands) of cores. Domains include simulations, modeling, and 3-D rendering.

## Architecture styles as constraints

An architecture style places constraints on the design, including the set of elements that can appear and the allowed relationships between those elements. Constraints guide the shape of an architecture by restricting the universe of choices. When an architecture conforms to the constraints of a particular style, certain desirable properties emerge. 

For example, the constraints in microservices include: 

- A service represents a single responsibility. 
- Every service is independent of the others. 
- Data is private to the service that owns it. Services do not share data.

By adhering to these constraints, what emerges is a system where services can be deployed independently, faults are isolated, frequent updates are possible, and it's easy to introduce new technologies into the application.

Before choosing an architecture style, make sure that you understand the underlying principles and constraints of that style. Otherwise, you can end up with a design that conforms to the style at a superficial level, but does not achieve the full potential of that style. It's also important to be pragmatic. Sometimes it's better to relax a constraint, rather than insist on architectural purity.


The following table summarizes how each style manages dependencies, and the types of domain that are best suited for each.

| Architecture style |	Dependency management | Domain type |
|--------------------|------------------------|-------------|
| N-tier | Horizontal layers. | Traditional business domain. Frequency of updates is low. |
| Web-queue-worker | Front and backend jobs, decoupled by async messaging. | Relatively simple domain with some resource intensive tasks. |
| Microservices	| Vertical (functional) decoupling. | Complicated domain. Frequent updates. |
| CQRS | Read/write segregation. Schema and scale are optimized separately. | Collaborative domain where lots of users access the same data. |
| Event-driven architecture | Producer/consumer. Independent view per subsystem. | IoT |
| Big data | Divide a huge dataset into small chunks. Parallel processing on local datasets. | Batch and real-time data analysis. Predictive analysis using ML <<RBC: Do we need to define ML?>>. |
| Big compute| Data allocation to thousands of cores. | Compute intensive domains such as simulation. |


## Consider challenges and benefits

Constraints also create challenges, so it's important to understand the trade-offs when adopting any of these styles. Do the benefits of the architecture style outweigh the challenges, *for this subdomain and bounded context*. 

Here are some of the types of challenges to consider when selecting an architecture style:

- Complexity. Is the complexity of the architecture justified for your domain? Conversely, is the style too simplistic for your domain? In that case, you risk ending up with a "ball of mud," <<RBC: So, I didn't know what this meant, and i was concerned for ESL readers so I searched and found this: https://en.wikipedia.org/wiki/Big_ball_of_mud. Should we link to it? Or would it be better to use something else. This phrase doesn't appear on MSDN, so I don't know how common it is.>> because the architecture does not help you to manage dependencies cleanly.

- Asynchronous messaging and eventual consistency. Asynchronous messaging can be used to decouple services, and increase reliability (because messages can be retried) and scalability. However, this also creates challenges such as always-once semantics, eventual consistency, <<RBC: looks like your list is missing some items.>>

- Inter-service communication. As you decompose an application into separate services, there is a risk that communication between services will cause unacceptable latency or create network congestion (for example, in a microservices architecture). 

- Manageability. How hard is it to manage the application, monitor, deploy updates, and so on?


[microservices]: ./microservices.md
[n-tier]: ./n-tier.md