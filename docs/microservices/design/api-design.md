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

:::image-end:::

You must distinguish between the two types of API:

- Public APIs that client applications call
- Back-end APIs used for interservice communication

These two types have different requirements. A public API must work with client applications, like browser applications or native mobile applications. Most public APIs use REST over HTTP. But back-end APIs require you to consider network performance. Depending on the granularity of your services, interservice communication can result in too much network traffic. Services can quickly become I/O bound, so considerations like serialization speed and payload size become more important. Some popular alternatives to REST over HTTP include gRPC Remote Procedure Call (gRPC), Apache Avro, and Apache Thrift. These protocols support binary serialization and improve efficiency compared to HTTP.

## Considerations

Consider the following factors when you decide how to implement an API:

- **REST versus Remote Procedure Call (RPC):** Consider the trade-offs between a REST-style interface versus an RPC-style interface.

  - REST models resources, which provides a natural way to express the domain model. It defines a uniform interface based on HTTP verbs, which encourages evolvability. It includes well-defined semantics for idempotency, side effects, and response codes. REST also enforces stateless communication, which improves scalability.

  - RPC focuses on operations or commands. RPC interfaces look like local method calls, so they can lead to overly chatty APIs. But RPC doesn't require chatty communication. To avoid that outcome, you must carefully design the interface.

  For a RESTful interface, most teams choose REST over HTTP via JSON. For an RPC-style interface, popular frameworks include gRPC, Apache Avro, and Apache Thrift.

- **Efficiency:** Consider efficiency in terms of speed, memory, and payload size. Typically a gRPC-based interface is faster than REST over HTTP.

- **Interface definition language (IDL):** Use An IDL to define the methods, parameters, and return values of an API. An IDL can generate client code, serialization code, and API documentation. API testing tools consume IDLs. Frameworks such as gRPC, Avro, and Thrift define their own IDL specifications. REST over HTTP doesn't have a standard IDL format, but a common choice is OpenAPI (formerly Swagger). You can also create an HTTP REST API without using a formal definition language, but you lose the benefits of code generation and testing.

- **Serialization:** Choose how to serialize objects serialized over the wire. Options include text-based formats like JSON and binary formats like protocol buffer. Binary formats are faster than text-based formats. But JSON provides broader interoperability because most languages and frameworks support JSON serialization. Some serialization formats require a fixed schema or a compiled schema definition file. In that case, you must incorporate this step into your build process. For more information, see [Message encoding best practices](/azure/architecture/best-practices/message-encode).

- **Framework and language support:** Nearly every framework and language supports HTTP. Avro, gRPC, and Thrift provide libraries for C++, C#, Java, and Python. Thrift and gRPC also support Go.

- **Compatibility and interoperability:** If you choose a protocol like gRPC, you might need a protocol translation layer between the public API and the back end. A [gateway](./gateway.yml) can perform that function. If you use a service mesh, check protocol compatibility with the service mesh. For example, Linkerd has built-in support for HTTP, Thrift, and gRPC.

Use REST over HTTP unless you need the performance benefits of a binary protocol. REST over HTTP doesn't require special libraries and creates minimal coupling, because callers don't need a client stub to communicate with the service. The REST ecosystem includes tools to support schema definitions, testing, and monitoring of RESTful HTTP endpoints. HTTP also works with browser clients, so you don't need a protocol translation layer between the client and the back end.

If you choose REST over HTTP, do performance and load testing early in the development process to validate whether it performs adequately for your scenario.

## RESTful API design

The following resources can help you design RESTful APIs:

- [API design](../../best-practices/api-design.md)
- [API implementation](../../best-practices/api-implementation.md)
- [Microsoft REST API guidelines](https://github.com/Microsoft/api-guidelines)

Consider the following factors:

- Avoid APIs that expose internal implementation details or mirror an internal database schema. The API should model the domain and serve as a contract between services. Ideally, you should only change the API when you add new functionality, not when you refactor code or change the database schema.

- Different types of client, like mobile applications and desktop web browsers, might require different payload sizes or interaction patterns. Consider using the [Backends for Frontends pattern](../../patterns/backends-for-frontends.md) to create separate back ends for each client. Each back end exposes an optimal interface for that client.

- For operations that cause side effects, consider making them idempotent and implementing them as PUT methods. This approach enables safe retries and improves resiliency. For more information, see [Interservice communication](./interservice-communication.yml).

- HTTP methods can have asynchronous semantics, where the method returns a response immediately, but the service carries out the operation asynchronously. In that case, the method should return an [HTTP 202](https://www.rfc-editor.org/rfc/rfc9110.html#section-15.3.3) response code. This code indicates that the request was accepted for processing but not yet processed. For more information, see [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.yml).

## Generic data access APIs: OData and GraphQL considerations

REST APIs provide a structured approach to exposing resources, but some scenarios require more flexible data access patterns. Query-oriented APIs like OData and GraphQL provide alternatives that allow clients to specify exactly what data they need. This approach can potentially reduce over-fetching and improve performance. These types of APIs prioritize read operations. Mutation operations, like create, update, and delete, can be more complex to implement, but various frameworks can manage these operations effectively.

### When to consider generic data access APIs

Use a generic data access pattern in the following situations:

- Clients have diverse data requirements that result in many specialized REST endpoints or specialized behavior

- You need to support complex querying, filtering, and sorting operations across multiple data entities
- Over-fetching is a significant performance concern, especially for mobile or bandwidth-constrained clients

Avoid generic data access APIs in the following situations:

- Your microservices architecture emphasizes strict service boundaries and domain encapsulation

- You need fine-grained control over data access patterns and security policies
- Your APIs primarily support simple create, read, update, and delete (CRUD) operations or well-defined business workflows
- REST already meets your network performance and payload requirements
- Security requirements demand explicit endpoint definitions to minimize attack surfaces
- Your team lacks experience with query language implementation and optimization

## Map REST to DDD patterns

Patterns like entity, aggregate, and value object define constraints for objects in a domain model. Many domain-driven design (DDD) discussionsd describe these patterns by using object-oriented (OO) language concepts like constructors or property getters and setters. For example, *value objects* are supposed to be immutable. In an OO programming language, you enforce this constraint by assigning the values in the constructor and making the properties read-only:

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

:::image-end:::

In a microservices architecture, services don't share the same code base or a data store. Instead, they communicate through APIs. For example, a scheduler service might request information about a drone from a drone service. The drone service defines its internal drone model through code. But the scheduler can't access these details directly. Instead, the scheduler receives a *representation* of the drone entity—like a JSON object in an HTTP response.

This example applies well to the aircraft and aerospace industries.

:::image type="complex" border="false" source="../images/ddd-rest.png" alt-text="Diagram of the Drone service." lightbox="../images/ddd-rest.png":::

:::image-end:::

The scheduler service can't modify the drone service's internal models or write to the drone service's data store. So the code that implements the drone service has a smaller exposed surface area compared to code in a traditional monolith. If the drone service defines a Location class, the scope of that class is limited—no other service directly consumes the class.

For these reasons, this guidance doesn't focus much on coding practices related to tactical DDD patterns. But you can model many DDD patterns through REST APIs.

The following examples show how REST concepts align with common DDD constructs:

- Aggregates map naturally to *resources* in REST. For example, the Delivery API exposes the Delivery aggregate as a resource.

- Aggregates define consistency boundaries. Operations on aggregates shouldn't leave an aggregate in an inconsistent state. Avoid creating APIs that allow a client to manipulate the internal state of an aggregate. Instead, favor coarse-grained APIs that expose aggregates as resources.

- Entities have unique identities. In REST, resources have unique identifiers in the form of URLs. Create resource URLs that correspond to an entity's domain identity. The mapping from URL to domain identity might be opaque to client.

- Child entities of an aggregate can be reached from the root entity. If you follow [HATEOAS](https://en.wikipedia.org/wiki/HATEOAS) principles, child entities can be reached via links in the representation of the parent entity.

- Value objects are immutable. To do updates, replace the entire value object. In REST, implement updates through PUT or PATCH requests.

- A repository lets clients query, add, or remove objects in a collection. The repository abstracts the details of the underlying data store. In REST, a collection can be a distinct resource, with methods for querying the collection or adding new entities to the collection.

When you design your APIs, think about how they express the domain model, not only the data inside the model. Also consider the business operations and the constraints on the data.

| DDD concept | REST equivalent | Example |
|-------------|-----------------|---------|
| Aggregate | Resource | `{ "1":1234, "status":"pending"... }` |
| Identity | URL | `https://delivery-service/deliveries/1` |
| Child entities | Links | `{ "href": "/deliveries/1/confirmation" }` |
| Update value objects | PUT or PATCH | `PUT https://delivery-service/deliveries/1/dropoff` |
| Repository | Collection | `https://delivery-service/deliveries?status=pending` |

## API versioning

An API serves as a contract between a service and clients or consumers of that service. API changes can break external clients or microservices that depend on the API. Minimize the number of API changes that you make. Changes in the underlying implementation often don't require changes to the API. But at some point, you likely want to add new features or new capabilities that require changing an existing API.

Make API changes backward compatible whenever possible. For example, avoid removing a field from a model. That change can break clients that expect the field to exist. Adding a field doesn't break compatibility because clients should ignore fields that they don't recognize in a response. But the service must handle requests from older clients that omit the new field.

Support versioning in your API contract. If you introduce a breaking API change, introduce a new API version. Continue to support the previous version, and let clients select which version to call. One way to do versioning is to expose both versions in the same service. Another option is to run two versions of the service side-by-side and route requests to one or the other version based on HTTP routing rules.

:::image type="complex" source="../images/versioning.png" alt-text="Diagram showing two options for supporting versioning.":::
   The diagram has two parts. "Service supports two versions" shows the v1 Client and the v2 Client both pointing to one Service. "Side-by-side deployment" shows the v1 Client pointing to a v1 Service, and the v2 Client pointing to a v2 Service.
:::image-end:::

Multiple versions add cost in terms of developer time, testing, and operational overhead. Deprecate old versions as quickly as possible. For internal APIs, the team that owns the API can work with other teams to help them migrate to the new version. Cross-team governance process is useful here. External (public) APIs can be harder to deprecate an API version, especially if external or native client applications consume the API.

When a service implementation changes, tag the change with a version. The version provides important information when troubleshooting errors. This approach supports root cause analysis because you know which version of the service is called. Consider using [semantic versioning](https://semver.org/) for service versions. Semantic versioning uses a *MAJOR.MINOR.PATCH* format. But clients should only select an API by the major version number, or possibly the minor version if there are significant (but nonbreaking) changes between minor versions. In other words, it's reasonable for clients to select between version 1 and version 2 of an API, but not to select version 2.1.3. If you allow that level of granularity, you risk having to support a proliferation of versions.

For more information, see [Versioning a RESTful web API](../../best-practices/api-design.md#implement-versioning).

## Idempotent operations

An operation is *idempotent* if it can be called multiple times without producing more side-effects after the first call. Idempotency can be a useful resiliency strategy, because it allows an upstream service to safely invoke an operation multiple times. For a discussion of this point, see [Distributed transactions](./interservice-communication.yml#distributed-transactions).

The HTTP specification states that GET, PUT, and DELETE methods must be idempotent. POST methods aren't guaranteed to be idempotent. If a POST method creates a new resource, there's generally no guarantee that this operation is idempotent. The specification defines idempotent this way:

> A request method is considered "idempotent" if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request. ([RFC 7231](https://tools.ietf.org/html/rfc7231#section-4))

It's important to understand the difference between PUT and POST semantics when creating a new entity. In both cases, the client sends a representation of an entity in the request body. But the meaning of the URI is different.

- For a POST method, the URI represents a parent resource of the new entity, such as a collection. For example, to create a new delivery, the URI might be `/api/deliveries`. The server creates the entity and assigns it a new URI, such as `/api/deliveries/39660`. This URI is returned in the Location header of the response. Each time the client sends a request, the server creates a new entity with a new URI.

- For a PUT method, the URI identifies the entity. If there already exists an entity with that URI, the server replaces the existing entity with the version in the request. If no entity exists with that URI, the server creates one. For example, suppose the client sends a PUT request to `api/deliveries/39660`. Assuming there's no delivery with that URI, the server creates a new one. Now if the client sends the same request again, the server replaces the existing entity.

Here's the Delivery service's implementation of the PUT method.

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
        // This method is mainly used to create deliveries. If the delivery already exists then update it.
        logger.LogInformation("Updating resource with delivery id: {DeliveryId}", id);

        var internalDelivery = delivery.ToInternal();
        await deliveryRepository.UpdateAsync(id, internalDelivery);

        // Return HTTP 204 (No Content)
        return NoContent();
    }
}
```

Most requests create a new entity, so the method optimistically calls `CreateAsync` on the repository object and then handles duplicate-resource exceptions by updating the resource instead.

## Next steps

Learn about using an API gateway at the boundary between client applications and microservices.

> [!div class="nextstepaction"]
> [API gateways](./gateway.yml)

## Related resources

- [RESTful web API design](../../best-practices/api-design.md)
- [API implementation](../../best-practices/api-implementation.md)
- [Design a microservices architecture](index.md)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
