The Messaging Bridge design pattern is a way to integrate disparate systems built on top of different messaging infrastructures.

## Context and problem

Many organizations end up in a situation in which their portfolio of IT systems uses multiple messaging infrastructures, e.g. by way of mergers and acquisitions. Others try to extend their current on-premises systems with cloud-hosted components for ease of maintenance, cost-effectiveness or other reasons. Yet others find themselves in a position where they need to integrate their newer systems with legacy ones. 

One common solution to these challenges is dedicated integration through HTTP-based web services. In that approach systems being integrated are modified to include HTTP endpoints and/or clients in order to exchange the data.

But this has a number of drawbacks:
- it requires the applications being integrated to be modified (by adding an HTTP client on one side and an HTTP request handler on the other)
- it requires hosting of HTTP endpoints, adding the complexity related to making these services secure and highly-available
- it is prone to network connectivity problems, requiring custom-build retry mechanisms

## Solution

If the systems being integrated are themselves message-based (i.e. consisting of components that communicate by exchanging messages), a solution that solves the integration problem while mitigating the drawbacks listed above is the Messaging Bridge pattern.

In that case each system already connects to one messaging infrastructure. In order to integrate them, a bridge component is introduced that is able to connect to two (or more) messaging infrastructures at the same time, pulling messages from one and pushing them to the other without changing the payload.

Neither of the systems being integrated needs to know about the other, nor the bridge. The sender system is configured to send specific messages to a designated queue. The messages are picked up by the bridge and fowarded to another queue in a different messaging infrastructure where they are finally picked up by the receiver system.

### Benefits

- The systems integrated via the Messaging Bridge do not have to be modified; ideally, the endpoints would not be aware that the messages are bridged.
- The message-driven integration is generally more reliable, compared to the HTTP alternative due to the at-least-once message delivery mechanism.

### Drawbacks

- Advanced features of one or both messaging technologies might not be available on the bridged route.
- The bridged route needs to consider both technologies' limitations (e.g., maximum message size may not be a problem on MSMQ but can be an issue when the bridged route leads via Azure Storage Queues).

## Issues and considerations

Consider the following points when implementing the Messaging Bridge pattern:

- If one of the integrated systems relies on the distributed transactions (e.g. via Microsoft Distributed Transaction Coordinator, DTC) for correctness, a deduplication mechanism needs to be put in place in the bridge.

- If one of the systems being integrated does not currently use any messaging infrastructure and cannot be modified, the Messaging Bridge might be built between the infrastructure used by the other system and a SQL Server-emulated queue. The legacy system can be made to send its messages simply by inserting to a dedicated queue-table, and the bridge can take these messages and forward them to the actual messaging infrastructure.

- Using a single queue in each messaging infrastructure (designated as _bridging queue_) is a natural choice. In this topology the sending system needs to be configured to use that specific queue as destination for message types that are sent to the other system. Alternatively, using multiple pairs of queues in each messaging infrastructure allows the sender to completely unaware of the bridge. A _shadow queue_ is created for each destination queue in the destination system's messaging infrastructure and the bridge is responsible for forwarding messages between the shadow queues and their counterparts.

- In order to meet desired availability standard, the messaging bridge might need to be scaled-out using the [Competing Consumers](../../patterns/ccompeting-consumers.yml) approach.

- Regular message-processing components use a [Retry](../../patterns/retry.yml) pattern to cope with transient failures while the retry counter limit allows them to detect _poison_ messages and remove them from the queue to unblock processing. The bridge might require a different retry policy to prevent falsely indentifying messages as poison in case of the infrastructure failure, possibly involving a [Circuir Breaker](../../patterns/circuit-breaker.yml) to pause forwarding.

## When to use this pattern

Use the Messaging Bridge pattern when you need to:

- Integrate existing systems with minimal need for modification
- Integrate legacy applications that cannot be changed to use any messaging technology
- Extend existing on-premises applications with cloud-hosted components
- Connect geo-distributed systems when Internet connection is not stable
- Migrate a single distributed system from one messaging infrastructure to another without the need to stop and re-deploy the whole system

This pattern might not be suitable:

- At least one of the systems involved relies on specific feature of one messaging infrastructure not present in the other
- Integration is synchronous in nature (the initiating system requires immediate response)
- The volume of data for the integration exceeds the capacity of the messaging system or makes messaging not a cost-effective solution to the problem

## Example

_Include a working sample that shows the reader how the pattern solution is used in a real-world situation. The sample should be specific and provide code snippets when appropriate._

## Next steps

_Provide links to other topics that provide additional information about the pattern covered in the article. Topics can include links to pages that provide additional context for the pattern discussed in the article or links to pages that may be useful in a next-steps context. Use the following boilerplate sentence followed by a bulleted list._

The following information may be relevant when implementing this pattern:

- [Competing Consumers](../../patterns/ccompeting-consumers.yml) should be used to ensure the implementation of the Messaging Bridge can cope with the load.
- [Retry](../../patterns/retry.yml) lets the Messaging Bridge handle transient failures.
- [Circuit breaker](../../patterns/circuit-breaker.yml) can be used to conserve resources when either side of the bridge is experiencing downtime.

## External links

- [Message Bridge implementation from Microsoft](https://github.com/Microsoft/Microsoft-Message-Bridge) is a good reference but is no longer actively maintained.
- [QPid bridge](https://openmama.finos.org/openmama_qpid_bridge.html) can be used to bridge AMQP-enabled messaging technologies.
- [Transport Bridge](https://docs.particular.net/nservicebus/bridge/) is an example of a queue-to-queue bridge that supports a wide range of messaging infrastructures, including MSMQ, Azure ServiceBus and Azure Storage Queues.
- [Router](https://github.com/SzymonPobiega/NServiceBus.Router) is an open source project that implements the Messaging Bridge pattern, allows bridging more than two technologies in a single instance, and has advanced message routing capabilities.
