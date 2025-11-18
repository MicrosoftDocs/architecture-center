---
title: API Design
description: Learn about API design for microservices, including REST and RPC trade-offs, versioning strategies, and mapping REST to domain-driven design.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-web
---

# API design

A microservices architecture requires good API design because all data exchange between services occurs either through messages or API calls. Efficient APIs help prevent [chatty input/output (I/O)](../../antipatterns/chatty-io/index.md). Independent teams design services, so you must define API semantics and versioning schemes clearly to avoid breaking other services when you update a service.

:::image type="complex" border="false" source="../images/api-design.png" alt-text="API design for microservices." lightbox="../images/api-design.png":::
The diagram shows a flow between a client and three back-end services through a central scheduler service. An arrow labeled HTTP POST points from the client to the scheduler service, with a response code 202 (Accepted) next to the arrow. From the scheduler service, three arrows point to separate services on the right. The top arrow points to user accounts service, labeled HTTP GET, with a response code 200 (OK). The middle arrow points to package service, labeled HTTP PUT, with a response code 201 (Created). The bottom arrow points to delivery service, also labeled HTTP PUT, with a response code 201 (Created).
:::image-end:::

You must distinguish between the two types of APIs:

- Public APIs that client applications call
- Back-end APIs for interservice communication

These two types have different requirements. A public API must be compatible with client applications, like browser applications or native mobile applications. Most public APIs use REST over HTTP. But back-end APIs must account for network performance. Depending on the granularity of your services, interservice communication can result in too much network traffic. Services can quickly become I/O bound, so considerations like serialization speed and payload size become more important. Some popular alternatives to REST over HTTP include gRPC Remote Procedure Call (gRPC), Apache Avro, and Apache Thrift. These protocols support binary serialization and improve efficiency compared to HTTP.

## Considerations

Consider the following factors when you decide how to implement an API:

- **REST versus Remote Procedure Call (RPC):** Consider the trade-offs between a REST-style interface versus an RPC-style interface.

  - REST models resources, which provides an intuitive way to express the domain model. It defines a uniform interface based on HTTP verbs, which encourages evolvability. It includes well-defined semantics for idempotency, side effects, and response codes. REST also enforces stateless communication, which improves scalability.

  - RPC focuses on operations or commands. RPC interfaces resemble local method calls, so they can lead to overly chatty APIs. But RPC doesn't require chatty communication. To avoid that outcome, you must carefully design the interface.

  For a RESTful interface, most teams choose REST over HTTP via JSON. For an RPC-style interface, popular frameworks include gRPC, Avro, and Thrift.

- **Efficiency:** Consider efficiency in terms of speed, memory, and payload size. Typically a gRPC-based interface is faster than REST over HTTP.

- **Interface definition language (IDL):** Use an IDL to define the methods, parameters, and return values of an API. An IDL can generate client code, serialization code, and API documentation. API testing tools consume IDLs. Frameworks like gRPC, Avro, and Thrift define their own IDL specifications. REST over HTTP doesn't have a standard IDL format, but a common choice is OpenAPI (formerly Swagger). You can also create an HTTP REST API without using a formal definition language, but you lose the benefits of code generation and testing.

- **Serialization:** Choose how to serialize objects over the wire. Options include text-based formats like JSON and binary formats like protocol buffer. Binary formats are faster than text-based formats. But JSON provides broader interoperability because most languages and frameworks support JSON serialization. Some serialization formats require a fixed schema or a compiled schema definition file. In those cases, you must incorporate this step into your build process. For more information, see [Message encoding best practices](/azure/architecture/best-practices/message-encode).

- **Framework and language support:** Nearly every framework and language supports HTTP. Avro, gRPC, and Thrift provide libraries for C++, C#, Java, and Python. Thrift and gRPC also support Go.

- **Compatibility and interoperability:** If you choose a protocol like gRPC, you might need a protocol translation layer between the public API and the back end. A [gateway](./gateway.yml) can perform that function. If you use a service mesh, check protocol compatibility with the service mesh. For example, Linkerd has built-in support for HTTP, Thrift, and gRPC.

Use REST over HTTP unless you need the performance benefits of a binary protocol. REST over HTTP doesn't require special libraries and creates minimal coupling because callers don't need a client stub to communicate with the service. The REST ecosystem includes tools to support schema definitions, testing, and monitoring of RESTful HTTP endpoints. HTTP also works with browser clients, so you don't need a protocol translation layer between the client and the back end.

If you choose REST over HTTP, do performance and load testing early in the development process to check whether it performs adequately for your scenario.

## RESTful API design

The following resources can help you design RESTful APIs:

- [API design](../../best-practices/api-design.md)
- [API implementation](../../best-practices/api-implementation.md)
- [Microsoft REST API guidelines](https://github.com/Microsoft/api-guidelines)

Consider the following factors:

- Avoid APIs that expose internal implementation details or mirror an internal database schema. The API should model the domain and serve as a contract between services. Ideally, you should only change the API when you add new functionality, not when you refactor code or change the database schema.

- Different types of client, like mobile applications and desktop web browsers, might require different payload sizes or interaction patterns. Consider using the [Backends for Frontends pattern](../../patterns/backends-for-frontends.md) to create separate back ends for each client. Each back end exposes an optimal interface for that client.

- For operations that cause side effects, consider making them idempotent and implementing them as `PUT` methods. This approach enables safe retries and improves resiliency. For more information, see [Interservice communication](./interservice-communication.yml).

- HTTP methods can have asynchronous semantics, where the method returns a response immediately but the service carries out the operation asynchronously. In that case, the method should return an [HTTP 202](https://www.rfc-editor.org/rfc/rfc9110.html#section-15.3.3) response code. This code indicates that the request was accepted for processing but not yet processed. For more information, see [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.yml).

## Generic data access APIs: OData and GraphQL considerations

REST APIs provide a structured approach to expose resources, but some scenarios require more flexible data access patterns. Query-oriented APIs like OData and GraphQL provide alternatives that let clients specify exactly what data they need. This approach can potentially reduce over-fetching and improve performance. These types of APIs prioritize read operations. Mutation operations, like create, update, and delete, can be more complex to implement, but various frameworks can manage these operations effectively.

### When to consider generic data access APIs

Use a generic data access pattern in the following situations:

- Clients have diverse data requirements that result in many specialized REST endpoints or specialized behavior.

- You need to support complex querying, filtering, and sorting operations across multiple data entities.
- Over-fetching is a significant performance concern, especially for mobile or bandwidth-constrained clients.

Avoid generic data access APIs in the following situations:

- Your microservices architecture emphasizes strict service boundaries and domain encapsulation.

- You need fine-grained control over data access patterns and security policies.
- Your APIs primarily support simple create, read, update, and delete (CRUD) operations or well-defined business workflows.
- REST already meets your network performance and payload requirements.
- Security requirements demand explicit endpoint definitions to minimize attack surfaces.
- Your team lacks experience with query language implementation and optimization.

## Map REST to DDD patterns

Patterns like entity, aggregate, and value object define constraints for objects in a domain model. Many domain-driven design (DDD) discussions describe these patterns by using object-oriented (OO) language concepts like constructors or property getters and setters. For example, *value objects* are supposed to be immutable. In an OO programming language, you enforce this constraint by assigning the values in the constructor and making the properties read-only:

```ts
export class Location {
    readonly latitude: number;
    readonly longitude: number;

    constructor(latitude: number, longitude: number) {
        if (!Number.isFinite(latitude) || latitude < -90 || latitude > 90) {
            throw new RangeError('latitude must be between -90 and 90');
        }
        if (!Number.isFinite(latitude) || longitude < -180 || longitude > 180) {
            throw new RangeError('longitude must be between -180 and 180');
        }
        this.latitude = latitude;
        this.longitude = longitude;
    }
}
```

These coding practices play an important role in building a traditional monolithic application. In a large code base, many subsystems might use the `Location` object, so the object must enforce the correct behavior.

The Repository pattern provides another example. This pattern ensures that other parts of the application don't make direct reads or writes to the data store.

:::image type="complex" border="false" source="../images/repository.png" alt-text="Diagram of a drone repository." lightbox="../images/repository.png":::
The diagram shows the data flow between a drone entity, a drone repository, and a data store. An arrow labeled GetDrone() points from the drone entity toward the drone repository, which indicates a request to retrieve drone data. Another arrow points back from the drone repository to the drone entity, which shows the return of the requested data. Two other arrows connect the drone repository to the data store. Two arrows indicate bidirectional communication between the data store and the drone repository.
:::image-end:::

In a microservices architecture, services don't share the same code base or a data store. Instead, they communicate through APIs. For example, a scheduler service might request information about a drone from a drone service. The drone service defines its internal drone model through code. But the scheduler can't access these details directly. Instead, the scheduler receives a *representation* of the drone entity—like a JSON object in an HTTP response.

This example applies well to the aircraft and aerospace industries.

:::image type="complex" border="false" source="../images/ddd-rest.png" alt-text="Diagram of the Drone service." lightbox="../images/ddd-rest.png":::
The diagram shows the interaction between a scheduler service and a drone service, which communicates with a data store. On the left, a scheduler service sends an HTTP GET request to the drone service with the endpoint /api/drone. An arrow points back to the scheduler service, labeled with a response that contains JSON followed by three periods. The drone service contains an HTTP request handler and a repository. The HTTP request handler receives the GET request. The repository connects to the data store. Two arrows indicate bidirectional communication between the repository and the data store. Inside the drone service, two arrows indicate bidirectional communication between the HTTP request handler and the repository. The arrow from the repository to the HTTP request handler is labeled drone (entity), which represents the domain object returned by the repository.
:::image-end:::

The scheduler service can't modify the drone service's internal models or write to the drone service's data store. So the code that implements the drone service has a smaller exposed surface area compared to code in a traditional monolith. If the drone service defines a `Location` class, the scope of that class is limited—no other service directly consumes the class.

For these reasons, this guidance doesn't focus much on coding practices related to tactical DDD patterns. But you can model many DDD patterns through REST APIs.

The following examples show how REST concepts align with common DDD constructs:

- Aggregates map naturally to resources in REST. For example, a delivery API might expose a delivery aggregate as a resource.

- Aggregates define consistency boundaries. Operations on aggregates shouldn't leave an aggregate in an inconsistent state. Avoid creating APIs that let a client manipulate the internal state of an aggregate. Instead, favor coarse-grained APIs that expose aggregates as resources.

- Entities have unique identities. In REST, resources have unique identifiers in the form of URLs. Create resource URLs that correspond to an entity's domain identity. The mapping from URL to domain identity may be opaque to clients.

- Child entities of an aggregate can be reached from the root entity. If you follow [hypermedia as the engine of application state (HATEOAS)](https://en.wikipedia.org/wiki/HATEOAS) principles, child entities can be reached via links in the representation of the parent entity.

- Value objects are immutable. To do updates, replace the entire value object. In REST, implement updates through `PUT` or `PATCH` requests.

- A repository lets clients query, add, or remove objects in a collection. The repository abstracts the details of the underlying data store. In REST, a collection can be a distinct resource that includes methods for querying the collection or adding new entities to the collection.

When you design APIs, think about how they express the domain model, not only the data inside the model. Also consider the business operations and the constraints on the data.

| DDD concept | REST equivalent | Example |
|-------------|-----------------|---------|
| Aggregate | Resource | `{ "1":1234, "status":"pending"... }` |
| Identity | URL | `https://delivery-service/deliveries/1` |
| Child entities | Links | `{ "href": "/deliveries/1/confirmation" }` |
| Update value objects | `PUT` or `PATCH` | `PUT https://delivery-service/deliveries/1/dropoff` |
| Repository | Collection | `https://delivery-service/deliveries?status=pending` |

## API versioning

An API serves as a contract between a service and clients or consumers of that service. API changes can break external clients or microservices that depend on the API. Minimize the number of API changes that you make. Changes in the underlying implementation often don't require changes to the API. But at some point, you likely want to add new features or new capabilities that require changing an existing API.

Make API changes backward compatible when possible. For example, avoid removing a field from a model. That change can break clients that expect the field to exist. Adding a field doesn't break compatibility because clients should ignore fields that they don't recognize in a response. But the service must handle requests from older clients that omit the new field.

Support versioning in your API contract. If you introduce a breaking API change, introduce a new API version. Continue to support the previous version, and let clients select which version to call. One way to do versioning is to expose both versions in the same service. Another option is to run two versions of the service side-by-side and route requests to one or the other version based on HTTP routing rules.

:::image type="complex" source="../images/versioning.png" alt-text="Diagram showing two options for supporting versioning." border="false":::
The diagram has two parts. The left side shows a service that supports two versions. The v1 client and the v2 client both point to one service. The right side shows a side-by-side deployment. The v1 client points to a v1 service, and the v2 client points to a v2 service.
:::image-end:::

Multiple versions add cost in terms of developer time, testing, and operational overhead. Deprecate old versions as quickly as possible. For internal APIs, the team that owns the API can work with other teams to help them migrate to the new version. Cross-team governance process is useful here. External (public) APIs can be harder to deprecate an API version, especially if external or native client applications consume the API.

When a service implementation changes, tag the change with a version. The version provides important information to help troubleshoot errors. This approach supports root cause analysis because you know which version of the service is called. Consider using [semantic versioning](https://semver.org/) for service versions. Semantic versioning uses a *MAJOR.MINOR.PATCH* format. But clients should only select an API by the major version number, or by the minor version if there are significant but nonbreaking changes between minor versions. For example, clients might choose between version 1 and version 2 of an API, but they shouldn't choose version 2.1.3. If you allow that level of granularity, you risk having to support too many versions.

For more information, see [Implement versioning for a RESTful web API](../../best-practices/api-design.md#implement-versioning).

## Idempotent operations

An operation is idempotent if you can call it multiple times without producing more side effects after the first call. Idempotency serves as a useful resiliency strategy because it lets an upstream service to safely invoke an operation multiple times. For more information, see [Distributed transactions](./interservice-communication.yml#distributed-transactions).

The HTTP specification states that `GET`, `PUT`, and `DELETE` methods must be idempotent. `POST` methods aren't guaranteed to be idempotent. If a `POST` method creates a new resource, there's generally no guarantee that this operation is idempotent. The specification defines idempotent in the following way:

> A request method is considered *idempotent* if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request. ([RFC 7231](https://tools.ietf.org/html/rfc7231#section-4))

Understand the difference between `PUT` and `POST` semantics when you create a new entity. In both cases, the client sends a representation of an entity in the request body. But the meaning of the uniform resource identifier (URI) is different.

- For a `POST` method, the URI represents a parent resource of the new entity, like a collection. For example, to create a new delivery, the URI might be `/api/deliveries`. The server creates the entity and assigns it a new URI, like `/api/deliveries/39660`. This URI is returned in the `Location` header of the response. Each time the client sends a request, the server creates a new entity that has a new URI.

- For a `PUT` method, the URI identifies the entity. If an existing entity has that URI, the server replaces the existing entity with the version in the request. If no entity uses that URI, the server creates one. For example, suppose the client sends a `PUT` request to `api/deliveries/39660`. If no delivery resource uses that URI, the server creates a new one. If the client sends the same request again, the server replaces the existing entity.

The delivery service uses the following code to implement the `PUT` method:

```csharp
[HttpPut("{id}")]
[ProducesResponseType<Delivery>(StatusCodes.Status201Created)]
[ProducesResponseType(StatusCodes.Status204NoContent)]
public async Task<IActionResult> Put([FromBody]Delivery delivery, string id)
{
    logger.LogInformation("In Put action with delivery {Id}: {@DeliveryInfo}", id, delivery.ToLogInfo());
    try
    {
        var internalDelivery = delivery.ToInternal();

        // Create the new delivery entity.
        await deliveryRepository.CreateAsync(internalDelivery);

        // Create a delivery status event.
        var deliveryStatusEvent = new DeliveryStatusEvent { DeliveryId = delivery.Id, Stage = DeliveryEventType.Created };
        await deliveryStatusEventRepository.AddAsync(deliveryStatusEvent);

        // Return HTTP 201 (Created)
        return CreatedAtRoute("GetDelivery", new { id= delivery.Id }, delivery);
    }
    catch (DuplicateResourceException)
    {
        // This method mainly creates deliveries. If the delivery already exists, update it.
        logger.LogInformation("Updating resource with delivery id: {DeliveryId}", id);

        var internalDelivery = delivery.ToInternal();
        await deliveryRepository.UpdateAsync(id, internalDelivery);

        // Return HTTP 204 (No Content)
        return NoContent();
    }
}
```

Most requests create a new entity, so the method expects the creation to succeed and calls `CreateAsync` on the repository object. Then the method handles duplicate-resource exceptions by updating the resource instead.

## Next step
	
Learn about using an API gateway at the boundary between client applications and microservices.
	
> [!div class="nextstepaction"]
> [API gateways](./gateway.yml)

## Related resources

- [RESTful web API design](../../best-practices/api-design.md)
- [API implementation](../../best-practices/api-implementation.md)
- [Design a microservices architecture](index.md)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
