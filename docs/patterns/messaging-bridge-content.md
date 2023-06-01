The [Messaging Bridge](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingBridge.html) design pattern is a way to integrate message-processing systems build on top of different messaging infrastructures.

## Context and problem

Message-processing systems consist of several components that work together to handle messages. Each consumes messages from a set of queues and/or topics while producing messages to a set of queues and/or topics. 

Components are bound to the messaging infrastructure via the [Message Endpoint](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageEndpoint.html). The implementation of the Message Endpoint pattern is specific to the underlying infrastrcuture, making it hard and costly to change the infrastructure. 

Even when using an abstraction layer for the messaging infrastructure, such as [NServiceBus](https://particular.net/nservicebus), [MassTransit](https://masstransit.io/) or [Rebus](https://rebus.fm/what-is-rebus/), it is not trivial to switch an endpoint from technology to another. Such a change is connected with significant risk as it has to be done as a one big re-deployment of the entire system.

Many organizations end up in a situation in which their portfolio of IT systems uses multiple messaging infrastructures, e.g. by way of merges and aquisitions. Others try to extend their current on-premises systems with cloud-hosted components for ease of maintenance, cost-effectiveness or other reasons. Yet others find themselves in a position where they need to integrate their newer systems with legacy ones that cannot be modified. Finally, there are organizations whose geographically distributed nature forces them to use multiple messageing infrastructures.

The commonly employed solution to these challenges has been integration through HTTP-based web services but it has a number of drawbacks
- it requires the applications being integrated to be modified (by adding HTTP client on one side and a HTTP request handler on the other)
- it requires hosting of HTTP servers, adding the complexity related to making these services secure and highly-available
- it is prone to network connectivity problems, requiring custom-build retry mechanisms

## Solution

A solution that does have the problems listed above is the Messaging Bridge pattern. The messaging bridge is a componenent that consists of just two instances of the [Message Endpoint](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageEndpoint.html), one for each bridged technology. It allows messages to flow from one side to the other, handling the translation transparently.

### Benefits

- The systems integrated via the Messaging Bridge do not have to be modified.
- The message-driven integration is generally more reliable, compared to the HTTP alternative due to the at-least-once message delivery mechanism.

### Drawbacks

- Advanced features of each of the bridged messaging infrastructures might not be available or relevant on the bridged route.
- The bridged route needs to take into account the limitations of both technologies (e.g. maximum message size may be not a problem on MSMQ but can be an issue when the bridged route leads via Azure Storage Queues).

## Issues and considerations

Consider the following points when implementing the Messaging Bridge pattern:

- If one of the integrated systems relies on the distributed transactions (e.g. via Microsoft Distributed Transaction Coordinator, DTC) for correctness, a deduplication mechanism needs to be put in place in the bridge.

- If one of the systems being integrated does not currently use any messaging infrastructure and cannot be modified, the Messageing Bridge might be built between the infrastructure used by the other system and a SQL Server-emulated queue. The legacy system can be made to send its messages simply by inserting to a dedicated queue-table and the bridge can take these messages and forward them to the actual messaging infrastructure.

## When to use this pattern

Use the Messaging Bridge when you need to:

- Integrate existing systems with minimal need of modification
- Integrate legacy applications that cannot be changed to use any messaging technology
- Extend existing on-premises applications with cloud-hosted components
- Connect geo-distributed systems when Internet connection is not stable


## Related resources

The following patterns might also be useful when implementing this pattern:

- [Competing Consumers](../../patterns/ccompeting-consumers.yml) should be used to ensure the implementation of the Messaging Bridge can cope with the load.
- [Retry](../../patterns/retry.yml) lets the Messaging Bridge handle transient failures.
- [Circuit breaker](../../patterns/circuit-breaker.yml) can be used to conserve resources when either side of the beidge is experiencing downtime.
- [Message Bridge implementation from Microsoft](https://github.com/Microsoft/Microsoft-Message-Bridge) is a good reference but is no longer actively maintained.
- [QPid bridge](https://openmama.finos.org/openmama_qpid_bridge.html) can be used to bridge AMQP-enabled messaging technologies.
- [Transport Bridge](https://docs.particular.net/nservicebus/bridge/) is an example of a queue-to-queue bridge that supports a wide range of messaging infrastructures, including MSMQ, Azure ServiceBus and Azure Storage Queues.
- [Router](https://github.com/SzymonPobiega/NServiceBus.Router) is an open source project that implements the Messaging Bridge pattern, allows bridging more than two technologies in a single instance and has advanced message routing capabilities.
