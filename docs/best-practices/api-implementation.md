---
title: RESTful Web API Implementation Best Practices
description: Learn about best practices for implementing a web API and publishing it to make it available to client applications.
ms.author: pnp
author: claytonsiemens77
ms.date: 10/20/2026
ms.topic: best-practice
ms.subservice: best-practice
ai-usage: ai-assisted
---

# Best practices for RESTful web API implementation

This article describes best practices for implementing, deploying, and operating a RESTful web API. It focuses on request handling, performance, reliability, publishing, and monitoring. For guidance on resource modeling and API design, see [Web API design](./api-design.md).

The architectural guidance applies across implementation languages and frameworks. The C# examples illustrate ASP.NET Core controllers.

## Processing requests

Consider the following points when you implement the code to handle requests.

### Preserve HTTP method semantics, and implement idempotency

Use GET to return resource data and HEAD to return response headers without a body. Don't use either method to create, update, or delete resources.

GET, HEAD, PUT, and DELETE must be idempotent, so repeating an identical request has the same intended effect as performing it once. For example, DELETE changes resource state, but repeating it doesn't delete additional resources. The first DELETE request might return 204 (No Content), while a subsequent request returns 404 (Not Found).

POST and PATCH aren't inherently idempotent. A PATCH operation that sets a property to a value can be idempotent, but one that increments a counter isn't. Document which state-changing operations clients can safely retry. If you support retries for operations that aren't naturally idempotent, implement and document how the service prevents duplicate effects. For method semantics, see [HTTP request methods](./api-design.md#http-request-methods).

> [!NOTE]
> For implementation guidance, see [Idempotent Consumer pattern](../patterns/idempotent-consumer.md#idempotent-processing-beyond-messaging). In practice, first identify whether an operation is naturally idempotent. If it isn't, apply artificial idempotency by tracking processed message IDs and handling duplicates proactively or reactively.

### Validate request data, and control field access

Define request and response models that expose only the fields in the API contract. Map these models to the stored data instead of binding request bodies directly to database entities or returning every stored property. Prevent callers from changing protected properties by submitting additional fields, and omit properties they aren't authorized to read. Data transfer objects (DTOs) are one way to enforce this boundary. For more information, see [Prevent over-posting in ASP.NET Core](/aspnet/core/tutorials/first-web-api#prevent-over-posting).

Validate required fields, types, ranges, and business rules before saving changes. If you support field selection, validate requested fields against an allowlist and the caller's permissions before projecting the response. Apply documented limits to filtering and sorting as well. For the corresponding contract choices, see [Implement pagination and filtering](./api-design.md#implement-data-pagination-and-filtering).

### Limit side effects of POST actions that create resources

When a POST request creates a resource, limit its effects to that resource and directly related resources. For example, creating an order might also update inventory and generate billing information. It shouldn't modify unrelated information.

### Avoid implementing chatty POST, PUT, and DELETE operations

Avoid designing your API based on *chatty* operations. Every request comes with protocol, network, and compute overhead. For example, running 100 smaller requests instead of one larger batch request incurs added overhead in the client, on the network, and at the resource server. For workloads that need bulk operations, consider bounded batch requests instead of many individual requests.

- A GET request to a collection can retrieve multiple resources at the same time.
- A POST request can contain the details for multiple new resources and add them all to the same collection.
- A PUT request can replace the entire set of resources in a collection.
- A DELETE request can remove an entire collection.

Define maximum batch sizes, payload sizes, execution times, and concurrency. Specify whether a batch is atomic or can partially succeed, and return an outcome for each operation. Authorize and validate every operation in the batch.

If you use OData, you can use ASP.NET Core OData to implement batch requests. For more information, see [ASP.NET Core OData overview](/odata/webapi-8/overview).

### Follow the HTTP specification when sending a response

Return the appropriate HTTP status code, headers, and body format so that clients can interpret and handle the response.

For example, a POST operation that creates a resource synchronously should return 201 (Created) and identify the resource in the `Location` response header. An operation that accepts work for later processing can return 202 (Accepted), but that response doesn't indicate that the work succeeded. Don't include a response body with 204 (No Content) or 304 (Not Modified). For more information, see [HTTP request methods](./api-design.md#http-request-methods).

### Support content negotiation

A response body can contain data in different formats, such as JSON or XML. Clients can use the `Accept` request header to specify supported media types. For example, a client that requests an image might specify `image/jpeg, image/gif, image/png`. Return a supported representation and identify its media type in the `Content-Type` response header.

If the client doesn't specify an `Accept` header, use a documented default format. ASP.NET Core controllers use JSON formatters by default. Define what happens when the API can't produce a requested representation. For example, configure the API to return 406 (Not Acceptable) rather than silently returning an unsupported format. For more information, see [Format response data in ASP.NET Core Web API](/aspnet/core/web-api/advanced/formatting).

For requests with a body, check the request's `Content-Type` and accept only the formats that the operation supports. Return 415 (Unsupported Media Type) for an unsupported format. This check is separate from response negotiation via `Accept`. In ASP.NET Core, configure input formatters and use `[Consumes]` when you need to restrict an operation's request formats. For more informaion, see [Create web APIs with ASP.NET Core](/aspnet/core/web-api/).

### Implement the selected API versioning strategy

Apply the [versioning strategy you chose during design](./api-design.md#implement-versioning) consistently in the application and gateway. Route requests to the handler and response schema for the selected version. Define the behavior for omitted, malformed, and unsupported version identifiers rather than silently changing which contract an existing caller receives.

Preserve the request and response contracts of supported versions. When you introduce a breaking change, provide a new version and keep supported earlier versions available. Handle requests from older callers that omit newly added optional fields. For more information, see [API versioning and compatibility](../microservices/design/api-design.md#api-versioning).

Keep generated resource links and cached representations consistent with the selected version. For header-based versioning, ensure that caches distinguish requests for different versions instead of relying only on the URI.

### Resolve and authorize tenant context

For a [multitenant API](./api-design.md#multitenant-web-apis), determine the tenant for each request and verify that the authenticated caller can access that tenant. Treat tenant identifiers in paths, hostnames, and headers as routing inputs only. For more information, see [Map requests to tenants in a multitenant solution](../guide/multitenant/considerations/map-requests.yml).

Use the authorized tenant context consistently when querying or updating data and when handing work to background processors. If application or gateway caches store tenant-specific data, include the tenant identifier in the cache key. For gateway-specific guidance, see [API Management features that support multitenancy](../guide/multitenant/service/api-management.md#api-management-features-that-support-multitenancy).

### Provide links to support HATEOAS-style navigation and discovery of resources

Hypertext as the Engine of Application State (HATEOAS) uses links to help clients discover and navigate resources. For example, a response that contains customer details can include links to that customer's orders. Describe the operations that each linked resource supports, such as GET, POST, PUT, and DELETE, and provide the corresponding URIs. For more information, see [API design](./api-design.md#implement-hateoas).

The following example uses an application-defined link representation. Document its conventions rather than assuming that clients can interpret custom link fields. A GET request for a customer returns links to that customer's orders:

```http
GET https://api.contoso.com/customers/2 HTTP/1.1
Accept: application/json
```

```http
HTTP/1.1 200 OK
...
Content-Type: application/json; charset=utf-8
...
Content-Length: ...
{"customerId": 2,"customerName": "Bert","links": [
    {"rel": "self",
     "href": "https://api.contoso.com/customers/2",
     "action": "GET",
     "types": ["text/xml","application/json"]},
    {"rel": "self",
     "href": "https://api.contoso.com/customers/2",
     "action": "PUT",
     "types": ["application/x-www-form-urlencoded"]},
    {"rel": "self",
     "href": "https://api.contoso.com/customers/2",
     "action": "DELETE",
     "types": []},
    {"rel": "orders",
     "href": "https://api.contoso.com/customers/2/orders",
     "action": "GET",
     "types": ["text/xml","application/json"]},
    {"rel": "orders",
     "href": "https://api.contoso.com/customers/2/orders",
     "action": "POST",
     "types": ["application/x-www-form-urlencoded"]}
]}
```

The following `Customer` record represents the customer data. Its `Links` property contains the HATEOAS links.

```csharp
public sealed record Customer(
    int CustomerId,
    string CustomerName,
    IReadOnlyList<Link> Links);

public sealed record Link(
    string Rel,
    string Href,
    string Action,
    IReadOnlyList<string> Types);
```

The GET operation retrieves the customer data from storage, constructs a `Customer` record with its links, and returns a JSON response. Each link includes the following fields:

- The relationship (`Rel`) between the returned resource and the linked resource. In this example, `self` refers to the customer, and `orders` refers to the customer's order collection.
- The hyperlink (`Href`) for the object being described by the link, in the form of a URI.
- The type of HTTP request (`Action`) that can be sent to the URI.
- The format of any data (`Types`) that should be provided in the HTTP request or that can be returned in the response, depending on the type of the request.

The HATEOAS links shown in the example HTTP response indicate that a client application can perform the following operations:

- An HTTP GET request to `https://api.contoso.com/customers/2` to retrieve the customer details as XML or JSON.
- An HTTP PUT request to `https://api.contoso.com/customers/2` to modify the customer details. The request body uses this format: `application/x-www-form-urlencoded`.
- An HTTP DELETE request to `https://api.contoso.com/customers/2` to delete the customer record. This operation requires no request body and returns no response body.
- An HTTP GET request to `https://api.contoso.com/customers/2/orders` to retrieve the customer's orders as XML or JSON.
- An HTTP POST request to `https://api.contoso.com/customers/2/orders` to create an order for the customer. The request body uses this format: `application/x-www-form-urlencoded`.

## Handling exceptions

If an operation throws an exception that isn't handled, consider the following guidance.

### Capture exceptions and return a meaningful response to clients

Handle exceptions consistently, and return a meaningful error response that's safe to share with clients. Don't return exception objects, stack traces, or internal implementation details in production responses. Return an HTTP status code that reflects the failure instead of returning status code 500 for every situation. For example, if a user request causes a database update that violates a constraint (such as attempting to delete a customer that has outstanding orders), return 409 (Conflict) and a safe explanation. Return 400 (Bad Request) for malformed input or request validation failures, not for unexpected server failures. For HTTP status definitions, see [Status Codes](https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes). For implementation guidance, see [Handle errors in ASP.NET Core](/aspnet/core/fundamentals/error-handling).

The following controller maps expected domain outcomes to HTTP responses. Its repository operation checks authorization and outstanding orders as part of the deletion operation. Unexpected failures propagate to centralized exception handling rather than being silently caught in each action.

```csharp
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Authorize]
[Route("customers")]
public sealed class CustomersController(ICustomerRepository repository) : ControllerBase
{
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeleteCustomer(int id, CancellationToken cancellationToken)
    {
        var outcome = await repository.DeleteAuthorizedAsync(id, User, cancellationToken);

        return outcome switch
        {
            DeleteOutcome.Deleted => NoContent(),
            DeleteOutcome.NotFound => NotFound(),
            DeleteOutcome.HasOutstandingOrders => Conflict(new ProblemDetails
            {
                Status = StatusCodes.Status409Conflict,
                Title = "The customer has outstanding orders."
            }),
            _ => throw new InvalidOperationException("Unknown deletion outcome.")
        };
    }
}

public enum DeleteOutcome
{
    Deleted,
    NotFound,
    HasOutstandingOrders
}
```

> [!IMPORTANT]
> Don't include information that could be useful to an attacker attempting to gain unauthorized access to your API.

The hosting layer can reject requests before they reach the API. For example, authentication failures can result in 401 (Unauthorized) responses. After authentication, verify that the caller is authorized to access the requested resource. Return 403 (Forbidden) when authorization fails.

### Handle exceptions consistently and log information about errors

To handle exceptions consistently, consider implementing a global error-handling strategy across the entire web API. Log diagnostic information on the server, but exclude secrets, access tokens, and sensitive personal data. Redact sensitive values before writing log entries, and limit log access to authorized users. For more information, see [Architecture strategies for monitoring and threat detection](/azure/well-architected/security/monitor-threats).

In ASP.NET Core, use exception-handling middleware and Problem Details responses for a consistent error contract. Configure production responses to omit diagnostic details, and include a correlation identifier that support teams can use to locate the corresponding logs. For more information, see [Handle errors in ASP.NET Core](/aspnet/core/fundamentals/error-handling).

### Distinguish between client-side errors and server-side errors

Use HTTP 4*xx* status codes for client errors and HTTP 5*xx* status codes for server errors. Preserve this distinction in error responses.

## Optimizing client-side data access

Frequent requests and large responses can make the network a bottleneck. Reduce unnecessary transfers when you implement resource retrieval and updates.

### Support client-side caching

Use the `Cache-Control` response header to specify whether clients and intermediate servers can store a response and how long it remains fresh.

The following example shows an HTTP GET request and the corresponding response that includes a Cache-Control header:

```http
GET https://api.contoso.com/orders/2 HTTP/1.1
```

```http
HTTP/1.1 200 OK
...
Cache-Control: max-age=600, private
Content-Type: application/json
Content-Length: 59

{"orderId":2,"productId":4,"quantity":2,"orderValue":10.00}
```

In this example, the response remains fresh for 600 seconds. The `private` directive permits storage in a private cache, such as a browser cache, but prohibits storage in a shared cache. Use `public` only for responses that are safe to share across callers. Use `no-store` for sensitive responses that must not be stored.

In an ASP.NET Core controller, set cache headers before returning the response:

```csharp
Response.GetTypedHeaders().CacheControl = new Microsoft.Net.Http.Headers.CacheControlHeaderValue
{
    Private = true,
    MaxAge = TimeSpan.FromMinutes(10)
};
```

> [!NOTE]
> The `no-cache` directive permits storage but requires revalidation before reuse. Use `no-store` to prohibit storage.

The API controls the cache policy and validators in its responses. Clients and intermediate servers use that information to manage their caches. Set these headers consistently so that callers can reuse responses without unnecessary data transfers.

To determine `max-age`, consider how much staleness the workload can tolerate. A resource can change while a cached response is still fresh. When freshness expires, a cache can revalidate the response instead of discarding it and downloading the entire representation again. Don't use a long freshness lifetime for data that requires immediate visibility of changes.

### Provide ETags to optimize query processing

An *entity tag (ETag)* is an opaque validator for a selected resource representation. Clients can retain it with a cached response and send it in `If-None-Match` to check whether the representation changed. A matching GET or HEAD request returns 304 (Not Modified) without a response body.

Generate a validator that remains consistent across application instances and changes when the representation changes.

The following controller hashes the exact JSON bytes it returns and reuses the application's configured JSON options. `FileContentResult` applies ASP.NET Core conditional-response handling without custom result wrappers. The repository returns only an order that the caller is authorized to read. Configure authentication and authorization in the host application.

```csharp
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.Net.Http.Headers;

[ApiController]
[Authorize]
[Route("orders")]
public sealed class OrdersController(IOrderRepository repository,IOptions<JsonOptions> jsonOptions) : ControllerBase
{
    [HttpGet("{id:int}")]
    [HttpHead("{id:int}")]
    public async Task<IActionResult> GetOrder(int id, CancellationToken cancellationToken)
    {
        var order = await repository.FindAuthorizedAsync(id, User, cancellationToken);
        if (order is null)
        {
            return NotFound();
        }

        var payload = JsonSerializer.SerializeToUtf8Bytes(order, jsonOptions.Value.JsonSerializerOptions);
        var etag = new EntityTagHeaderValue($"\"{Convert.ToHexString(SHA256.HashData(payload))}\"");

        Response.GetTypedHeaders().CacheControl = new CacheControlHeaderValue
        {
            Private = true,
            MaxAge = TimeSpan.FromMinutes(10)
        };

        return new FileContentResult(payload, "application/json")
        {
            EntityTag = etag
        };
    }
}
```

This example buffers the representation and reads the order even for a conditional request. Use it only for bounded, nonsensitive responses. For large resources, consider using a stored version token that changes whenever the selected representation changes, so that you can validate a request without generating the full payload. If content negotiation, compression, or gateway transformations change the representation, ensure that validators and cache variation remain correct for that representation.

A response includes the ETag and cache policy. The following examples show the first 16 hexadecimal characters (64 bits) of the displayed JSON body's SHA-256 hash, followed by `...` for brevity. Actual headers contain the full hash without the ellipsis.

```http
HTTP/1.1 200 OK
...
Cache-Control: max-age=600, private
Content-Type: application/json
ETag: "3097D1FD51082205..."
Content-Length: 59

{"orderId":2,"productId":4,"quantity":2,"orderValue":10.00}
```

> [!TIP]
> Use `Cache-Control: no-store` for responses that contain sensitive data. For other user-specific responses that can be cached, use `private` to prevent storage in shared caches. For implementation considerations, see [Response caching middleware in ASP.NET Core](/aspnet/core/performance/caching/middleware).

Support conditional GET requests so that callers can revalidate cached responses without downloading an unchanged representation. Implement the following request and response behavior:

1. Accept conditional GET requests that supply an ETag in the `If-None-Match` header, such as:

    ```http
    GET https://api.contoso.com/orders/2 HTTP/1.1
    If-None-Match: "3097D1FD51082205..."
    ```

1. Compare the current ETag for the requested resource (order 2 in this example) with the `If-None-Match` condition.

   - If the condition matches, return 304 (Not Modified) without a response body.

   - If the condition doesn't match, return 200 (OK) with the current representation.

   - If the requested resource no longer exists, return 404 (Not Found).

> [!NOTE]
> An ETag doesn't make a response safe to cache. Apply cache directives consistently, including on conditional and error responses, and use `no-store` for sensitive data.

Use framework support for conditional requests where possible. If you implement comparisons yourself, handle all supplied entity tags, wildcard conditions, and weak versus strong comparison rules rather than comparing only the first tag. Include the appropriate ETag and cache headers on 304 (Not Modified) responses, and perform authorization before returning resource metadata.

> [!TIP]
> A stored validator can let you check whether a representation changed without retrieving the full resource. This approach can reduce data transfer and processing when the resource is large or expensive to retrieve.

### Use ETags to support optimistic concurrency

To prevent lost updates, evaluate `If-Match` preconditions on state-changing requests against the resource's current ETag. This lets the API reject a change based on a representation that another operation has already modified. Implement the following behavior:

1. Accept update requests that identify the expected version in the `If-Match` header. The following PUT request updates order 2. It uses the ETag from the earlier GET response, abbreviated in the same way. The tag identifies the existing representation, not the new request body:

    ```http
    PUT https://api.contoso.com/orders/2 HTTP/1.1
    If-Match: "3097D1FD51082205..."
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 37

    productId=3&quantity=5&orderValue=250
    ```

1. Compare the current ETag for the requested resource (order 2 in this example) with the `If-Match` condition.

   - If the precondition matches, perform the update atomically and return the documented success response, such as 204 (No Content). A `Location` header isn't required merely because an existing resource was updated. Only return an ETag on a successful PUT response when it satisfies HTTP's validator requirements for the stored representation.

   - If the condition doesn't match, return 412 (Precondition Failed). This example returns no response body.

   - If the resource to update no longer exists, return 404 (Not Found).

1. Document the success and conflict responses so that callers can determine whether an update succeeded or whether they need to retrieve the current representation before submitting another change.

For operations that must prevent lost updates, require an `If-Match` precondition and return 428 (Precondition Required) when it's missing. Use strong comparison for `If-Match`.

Checking a version in application memory and then saving unconditionally creates a race condition. Enforce the version comparison and the write atomically in the data store. For example, use a database concurrency token so that the update succeeds only if the stored version still matches the version used to evaluate the request.

In Entity Framework (EF) Core, configure a concurrency token and handle `DbUpdateConcurrencyException` rather than overwriting a concurrent change. In the API's data-access code, don't automatically replace the expected version and retry a conflicting database update unless the operation's semantics permit it. For more information, see [Handling concurrency conflicts](/ef/core/saving/concurrency).

## Handling large requests and responses

Large request and response bodies consume API memory, bandwidth, and connection capacity. Implement streaming and resource limits so that large transfers don't exhaust the service. Consider the following points when handling significant amounts of data:

### Optimize requests and responses that involve large objects

For large objects, such as images or other binary data, support streaming uploads and downloads.

Use asynchronous streaming APIs and let the server select transfer framing for the negotiated HTTP version. Don't manually add `Transfer-Encoding: chunked` to each piece of a response. Streaming isn't limited to HTTP/1.1 chunked encoding. Avoid buffering an entire unbounded request or response in application memory.

Set request-body limits, upload limits, timeouts, and cancellation policies at the application and hosting layers. Reject an oversized request with 413 (Content Too Large) before starting the response.

HTTP compression can reduce transfer size, at the cost of additional processing on the server and client. For example, a client can send `Accept-Encoding: gzip`. If the server returns gzip-compressed content, identify the encoding by using `Content-Encoding: gzip`.

Configure compression through the hosting platform or middleware and measure its CPU and bandwidth tradeoffs at both the client and server sides.

- Avoid recompressing formats that are already compressed.
- Before enabling compression for dynamically generated HTTPS responses, assess compression risks, such as [BREACH](https://wikipedia.org/wiki/BREACH), and apply appropriate mitigations. Even if you disable HTTPS compression in your middleware, your hosting server might be configured to apply compression.
- Ensure that cache variation and ETags remain correct when content encoding changes.

For compression implementation guidance and security considerations, see [Response compression in ASP.NET Core](/aspnet/core/performance/response-compression).

<a id="implement-partial-responses-for-clients-that-dont-support-asynchronous-operations"></a>

### Support partial downloads of large resources

If the API supports partial downloads of large resources, advertise that capability with `Accept-Ranges`. Handle HEAD requests by returning the resource's metadata, including its total `Content-Length`, without a response body. For GET requests that specify a supported byte range, return 206 (Partial Content), a `Content-Length` for the returned portion, and a `Content-Range` that identifies that portion of the resource. This response contract lets callers retrieve portions of a resource without requiring the API to return the entire object.

HTTP HEAD requests and partial responses are described in more detail in [API design](./api-design.md#support-partial-responses).

### Handle 100-Continue for large uploads

For a large HTTP/1.1 upload, a client can send request headers with `Expect: 100-continue` and wait before transmitting the body. The server can send an interim 100 (Continue) response or reject the request without receiving the full body. This exchange is part of one request, not a preliminary empty request followed by a second complete request.

Configure and test how the hosting stack and gateway handle requests with and without `Expect: 100-continue`. Verify the API's behavior when it accepts or rejects an upload, and measure the effects on server resource use and request latency.

### Support pagination for requests that might return large numbers of objects

Retrieving an entire large collection can increase server processing, network traffic, and latency.

Validate pagination inputs on the server and enforce a maximum page size. The following controller illustrates request validation. It defaults to 10 results and rejects limits outside 1 through 100 or offsets outside 0 through 10,000. These bounds are illustrative. Choose limits based on the workload and load tests. When you use `[ApiController]`, validation failures produce a 400 response. For more information, see [Create web APIs with ASP.NET Core](/aspnet/core/web-api/).

```csharp
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Authorize]
[Route("orders")]
public sealed class OrderCollectionsController(IOrderRepository repository) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<Order>>> GetOrders(
        [FromQuery, Range(1, 100)] int limit = 10,
        [FromQuery, Range(0, 10000)] int offset = 0,
        CancellationToken cancellationToken = default)
    {
        var orders = await repository.ListAuthorizedAsync(limit, offset, User, cancellationToken);
        return Ok(orders);
    }
}
```

A client can request 30 orders starting at offset 50 by using `https://api.contoso.com/orders?limit=30&offset=50`.

Beyond the request validation shown in the preceding example, include a next-page link or continuation token in the response contract. For example, return the orders with a `nextLink` property set to `https://api.contoso.com/orders?limit=30&offset=80` when another page is available. Preserve filters, sort order, and API version in the link. Omit `nextLink` or set it to `null` on the last page. For an example of a next-link contract, see [Microsoft Graph paging](/graph/paging).

Apply filtering and pagination in the data store, not after loading the entire collection. Use a deterministic sort order. For large or frequently changing collections, evaluate cursor-based pagination to avoid expensive offsets and unstable page boundaries.

> [!TIP]
> Enforce documented bounds on query complexity, filter expressions, and request size. Test the limits of every gateway, proxy, and server in the request path.

## Maintaining responsiveness, scalability, and availability

Define latency, throughput, and availability objectives for the API's critical operations. Design and test for expected traffic, bursts, and dependency failures. Scale-out and stateless handling support those objectives. Consider the following implementation requirements.

### Provide asynchronous support for long-running requests

For work that outlasts a normal HTTP request, validate and authorize the request, durably record the work, and return 202 (Accepted). Don't rely on an untracked in-process task to finish after a response: application restarts, scale-in, and deployment can interrupt it. Use a durable queue and worker or a durable workflow when the work must continue running despite those events. For the full HTTP semantics and implementation guidance, see [Asynchronous Request-Reply pattern](../patterns/asynchronous-request-reply.md).

Provide a way for callers to retrieve the operation's status and result. The API can also notify callers when processing completes.

You can provide a status resource that clients poll:

1. The client submits the request. Validate its input and permissions before accepting work.
1. Persist an operation identifier and status in durable storage, such as [Azure Table Storage](/azure/storage/tables/), and enqueue work for a separate processor, for example, by using [Azure Service Bus](/azure/service-bus-messaging/). Coordinate persistence and enqueueing so that a failure between these two actions doesn't result in the loss of accepted work.
1. Return 202 with a `Location` header that identifies the status endpoint and a `Retry-After` header that controls polling frequency. Accept the request only after the work is durably recorded.
1. A worker processes the operation and updates its durable state. Make processing idempotent because a worker can receive the same work more than once. Apply bounded [retries](../patterns/retry.yml) to transient failures.
1. The client polls the status endpoint. Enforce resource-level authorization on both the status and result endpoints. An unguessable identifier isn't authorization.
1. Return a documented status representation while work is in progress. On completion, provide the result or a 303 (See Other) redirect to a result resource. Report failures through a consistent, safe error contract.
1. Define retention and cleanup for operation records and results. Document operation expiration, duplicate submissions, and any supported cancellation behavior.

For connected clients, consider using ASP.NET Core SignalR for completion notifications. Keep the durable status resource available so that clients can recover after a disconnect or missed notification. For more information, see [Overview of ASP.NET Core SignalR](/aspnet/core/signalr/introduction).

### Ensure that each request is stateless

Don't require a later request to reach the same application instance as an earlier request. Keep workflow and resource state in appropriate shared stores, not solely in process memory. Requests can depend on durable resource state without creating server-instance affinity. Stateless request handling supports scale-out.

### Understand your downstream dependencies

Set a timeout for each downstream call. Keep the total time for calls, retries, and delays within the API request's deadline, and propagate request cancellation to downstream operations.

Retry only transient failures and operations that are safe to repeat. Use bounded retries with backoff and jitter. Limit aggregate retries per dependency as well as attempts per request. For more information, see [Transient fault handling](./transient-faults.md).

Use a [circuit breaker](../patterns/circuit-breaker.md) when repeated dependency failures could exhaust API capacity.

### Track clients and implement throttling to reduce the chances of DoS attacks

Apply request-rate, concurrency, payload, and execution-time limits. Partition limits by authenticated caller or tenant where possible. Return 429 (Too Many Requests) when a caller exceeds a configured rate and 503 (Service Unavailable) for temporary service unavailability. Include `Retry-After` where appropriate. If the API retries calls to downstream dependencies, bound those retries so that they don't amplify overload.

Gateway and application limits serve different purposes. Gateway limits can protect shared capacity. Application limits can reflect operation cost and downstream capacity. Neither replaces network-layer DDoS protection or a web application firewall. For more information, see [Throttling pattern](../patterns/throttling.md).

### Manage persistent HTTP connections carefully

For inbound connections, configure server and gateway keep-alive timeouts, request timeouts, and concurrent connection limits for the workload and network path. Don't routinely force connections to close after each response. For information about ASP.NET Core server settings, see [Configure options for the Kestrel web server](/aspnet/core/fundamentals/servers/kestrel/options).

If the API itself calls downstream HTTP services, reuse those outbound connections. In a .NET API implementation, use long-lived `HttpClient` instances with an appropriate `PooledConnectionLifetime`, or use clients created by `IHttpClientFactory`. Dispose outbound response messages and streams when they're no longer needed. These settings apply to the API's downstream calls, not to incoming client connections. For details and cookie-handling caveats, see [Guidelines for using HttpClient](/dotnet/fundamentals/networking/http/httpclient-guidelines).

## Publishing and managing a web API

Deploy the API to a hosting environment that meets its operational requirements. Consider the following strategies:

- Use HTTPS. Authenticate requests to protected endpoints and enforce authorization for each resource and operation.
- Scale the hosting environment to meet response-time commitments as demand changes.
- Meter requests if the API's billing model requires it.
- Regulate traffic and enforce client quotas where required.
- Record the audit events that compliance and incident response require, but don't log credentials, tokens, or sensitive request and response bodies.
- Monitor host health and define recovery actions, such as restarting an unhealthy host.

Consider using a separate [façade](https://wikipedia.org/wiki/Facade_pattern) that handles shared management concerns and forwards validated requests to the API. A façade can provide the following capabilities:

- Acting as an integration point for multiple web APIs.
- Transforming messages and translating communications protocols for clients built by using varying technologies.
- Caching requests and responses to reduce load on the server hosting the web API.

Keep API contracts and gateway configuration under version control, validate changes in deployment pipelines, and define rollback procedures. Align hosting, identity, networking, and governance with the organization's landing zone approach. For more information, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/).

## Testing a web API

Use unit tests to validate the API's logic and integration tests to verify its HTTP behavior.

Include the following checks:

- Test all routes to verify that they invoke the correct operations. Be especially aware of HTTP status code 405 (Method Not Allowed) being returned unexpectedly. This status code can indicate a mismatch between a route and the HTTP methods (GET, POST, PUT, DELETE) that can be dispatched to that route.

    Send requests that use methods that aren't supported by each route, and verify the documented 405 (Method Not Allowed) response and `Allow` header.

- Verify that all routes are protected properly and are subject to the appropriate authentication and authorization checks.

  > [!NOTE]
  > Some aspects of security, such as user authentication, are likely to be the responsibility of the host environment rather than the web API, but you still need to include security tests as part of the deployment process.

- Test the exception handling performed by each operation and verify that an appropriate and meaningful HTTP response is passed back to the client application.

- Verify that request and response messages are well-formed. For example, for a POST request that creates a resource, verify deserialization, parsing, resource creation, and the response's `Location` header.

- Test supported and unsupported request media types separately from response content negotiation. Verify 415 (Unsupported Media Type) responses for unsupported request formats and the documented validation errors for malformed bodies.

- Exercise every supported API version, including its routing, request validation, and response schema. Test omitted, malformed, and unsupported version identifiers, and verify that cached responses don't cross version boundaries.

- Verify all links and URIs in response messages. For example, an HTTP POST message should return the URI of the newly created resource. All HATEOAS links should be valid.

- Ensure that each operation returns the correct status codes for different combinations of input. For example:

  - If a query is successful, it should return status code 200 (OK).
  - If a resource isn't found, the operation should return HTTP status code 404 (Not Found).
  - If the client sends a request that successfully deletes a resource, the status code should be 204 (No Content).
  - If the client sends a request that creates a new resource, the status code should be 201 (Created).

  Investigate unexpected 5*xx* responses from the application or hosting layer.

- Test the different request header combinations that a client application can specify and ensure that the web API returns the expected information in response messages.

- Test query strings. If an operation can take optional parameters (such as pagination requests), test the different combinations and the order of parameters.

- Verify that asynchronous operations complete successfully. For streaming responses, verify that the API doesn't buffer the entire payload and that it handles client disconnections and cancellation correctly. If the API provides status resources for long-running operations, verify that they report operation progress and results correctly.

Test the failure and boundary cases that affect correctness:

- Validate minimum, maximum, negative, malformed, and excessive pagination and batch inputs.
- Follow pagination links through the last page. Verify that links preserve query options and that the documented completion signal is returned.
- Verify that additional input fields can't change protected properties and that field selection can't expose unauthorized data.
- Test matching, nonmatching, weak, multiple, and wildcard ETags, and verify that 304 responses contain no body.
- Exercise concurrent updates and confirm that the data store rejects stale writes atomically.
- Verify that callers can't read another caller's resources, status records, or cached responses.
- For multitenant APIs, test forged or mismatched tenant identifiers. When caching is enabled, test for requests for the same resource URI from different tenants.
- Simulate timeouts, client cancellation, dependency failures, worker restarts, and duplicate delivery of background work.
- Verify downstream timeout and retry budgets, cancellation, and circuit-breaker recovery.
- Verify 429 (Too Many Requests) and 503 (Service Unavailable)responses, retry behavior, and the cost of rejecting overloaded requests.

Run load tests against production-like infrastructure and realistic operation mixes. Define pass and fail criteria for throughput, latency percentiles, error rates, and resource saturation. Use [Azure Load Testing](/azure/app-testing/load-testing/overview-what-is-azure-load-testing) and integrate regression checks into the deployment pipeline.

## Using API Management

Consider using [Azure API Management](/azure/api-management/) when you need a managed gateway with policy enforcement. It adds cost, another network hop, and a dependency in the request path. Choose a service tier and topology based on capacity, networking, availability, and regional requirements; features differ by tier. The Developer tier isn't intended for production workloads. Follow the [Well-Architected service guidance for API Management](/azure/well-architected/service-guides/azure-api-management).

You can publish and manage a web API by completing these steps:

1. Deploy the web API to a hosting platform like Azure App Service, Azure Container Apps, Azure Kubernetes Service (AKS), or Azure Virtual Machines.

1. Configure API Management to route requests from its gateway URL to the backend API. One API Management instance can route requests to multiple APIs. Multiple instances can also expose the same backend API when applications need different access boundaries.

   > [!NOTE]
   > HATEOAS links in responses should reference the API Management gateway URL, not the backend server URL.

1. Import a version-controlled OpenAPI definition and validate that the imported operations, parameters, security requirements, and response schemas match the implementation. Check supported OpenAPI versions and import limitations. For more information, see [Import an OpenAPI specification](/azure/api-management/import-api-from-oas).

1. Configure authentication and authorization for both client-to-gateway and gateway-to-backend communications. Validate OAuth 2.0 access tokens and enforce the permissions required for client requests. For backends that support Microsoft Entra ID authentication, prefer an API Management managed identity with only the permissions it needs. Certificate authentication is another option. Avoid Basic authentication when more secure options are available. For more information, see [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview).

   > [!NOTE]
   > If you require API Management subscription keys, don't use them as a substitute for authentication and resource-level authorization.

1. Configure policies for authentication, cross-origin access, message transformations, IP filtering, rate limits, and quotas as needed. Configure response caching only for data that's safe to cache. Apply policies at the appropriate scope and verify their effective behavior for each operation.

For more information, see the [API Management documentation](/azure/api-management/).

> [!IMPORTANT]
> A gateway doesn't make the backend private or replace resource-level authorization. Design backend access controls, failure handling, capacity, and observability for the workload as a whole, including the gateway. Evaluate zone and regional redundancy against the selected tier's capabilities. Include gateway charges, telemetry ingestion and retention, and data transfer in the cost model.

## Supporting client-side developers

Provide API consumers with documentation for authentication, operations, parameters, data types, and response codes.

### Document the REST operations for a web API

Publish an OpenAPI definition that describes the API's operations, parameters, request and response schemas, and security requirements. Keep it under version control with the implementation, and verify that it matches the API's actual behavior.

Supplement the API reference with guidance that consumers need to use the API correctly:

- Authentication requirements and permissions for each operation.
- Representative requests, successful responses, and error responses.
- Input validation rules, payload limits, pagination, and rate limits.
- Timeout behavior, retry safety, and any idempotency requirements.
- Status and result retrieval for long-running operations.
- Versioning and compatibility expectations.

Keep the documentation and examples up to date when the API contract changes.

### Implement a client SDK

Consider supplying an SDK for API consumers. The SDK can expose typed methods that construct requests, parse responses, and surface the API's documented errors.

Consider generating typed clients from the API's OpenAPI definition, but validate the generated behavior against the service. Document authentication, timeouts, cancellation, pagination, error responses, and which operations are safe to retry. Keep the client and API compatibility policy aligned. Generated code doesn't remove the need for integration tests.

## Monitoring a web API

Monitor the API, its dependencies, and any gateway together. Define service-level objectives and alerts based on customer impact rather than relying only on host health.

### Monitoring a web API directly

Use OpenTelemetry instrumentation to collect traces, metrics, and logs, and export the signals to Application Insights or another supported backend. For .NET, Node.js, and Python instrumentation, follow the Microsoft OpenTelemetry Distro guidance. Java uses the Azure Monitor OpenTelemetry Distro. Follow the language-specific [OpenTelemetry enablement guidance](/azure/azure-monitor/app/opentelemetry-enable).

Monitor signals that describe API behavior:

- Request volume, failure rate, and latency percentiles by operation
- Dependency latency, failures, and timeouts
- Rate-limit rejections, concurrent work, and resource saturation
- Background-operation queue age, completion time, failures, and retries
- Cache effectiveness, when caching is part of the design

The telemetry a monitoring tool collects automatically varies depending on the language, libraries, and configuration. Add instrumentation for domain operations and background work. Don't assume that browser sessions, user roles, or all request details are automatically available. Propagate trace context across the gateway, application, and workers. Configure sampling and retention to balance diagnostic needs, data sensitivity, and telemetry cost.

Use Application Insights [Standard availability tests](/azure/azure-monitor/app/availability) for recurring external checks where appropriate. Check a meaningful health or operation endpoint without exposing sensitive data, define actionable alerts, and maintain a response runbook.

### Monitoring a web API by using API Management

Use the Azure Monitor metrics, logs, analytics, and diagnostics supported by API Management to distinguish gateway failures from backend failures. Correlate gateway and application telemetry, and monitor policy failures, capacity, request latency, and throttling. Available signals depend on the tier and gateway configuration.

Follow the observability and capacity recommendations in the [Well-Architected service guidance for API Management](/azure/well-architected/service-guides/azure-api-management).

## Next steps

- [ASP.NET Core OData overview](/odata/webapi-8/overview) describes how to build REST API services that conform to the OData protocol by using ASP.NET Core.
- [ASP.NET Core best practices](/aspnet/core/fundamentals/best-practices) covers asynchronous I/O, resource use, and response handling.
- [Idempotent Consumer pattern](../patterns/idempotent-consumer.md#idempotent-processing-beyond-messaging) provides implementation guidance for tracking processed message IDs and handling duplicate delivery.
- [HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes) defines HTTP status codes.
- [Asynchronous Request-Reply pattern](../patterns/asynchronous-request-reply.md) describes durable background work and status resources.
- [Architecture best practices for Azure API Management](/azure/well-architected/service-guides/azure-api-management) covers reliability, security, cost, operations, and performance.
- [Azure Load Testing](/azure/app-testing/load-testing/overview-what-is-azure-load-testing) describes load generation and automated performance checks.
- [Enable OpenTelemetry](/azure/azure-monitor/app/opentelemetry-enable) provides language-specific instrumentation and export guidance.
