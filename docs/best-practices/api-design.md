---
title: Web API design best practices
titleSuffix: Azure Architecture Center
description: Learn best practices for designing web APIs that support platform independence and service evolution.
ms.author: robbag
author: RobBagby
ms.date: 03/27/2025
ms.topic: best-practice
ms.subservice: best-practice
products:
  - aspnet
ms.custom:
  - best-practice
keywords:
  - "What is a web api"
  - "REST APIs"
  - "REST web services"
  - "API design"
  - "RESTful web services"
  - "API standards"
categories: featured
---

<!-- cSpell:ignore HATEOAS -->

# RESTful web API design

A RESTful web API implementation is a web API that employs REST (Representational State Transfer) architectural principles to achieve a stateless, loosely coupled interface between client and service.  A web API that is RESTful supports the standard HTTP protocol to perform operations on resources and return representations of resources with hypermedia links and HTTP operation status codes. 

A RESTful web API should align with the following principles:

- **Platform independence**, which means that clients should be able to call the web API regardless of the internal implementation. To achieve platform independence, the web API uses HTTP as a standard protocol, offers clear documentation, and supports a familiar data exchange format such as JSON or XML.

- **Loose coupling**, which means that the client and the web service should be able to evolve independently. The client shouldn't have to know the internal implementation of the web service, and the web service shouldn't have to know the internal implementation of the client. To achieve loose coupling in a RESTful web API, use only standard protocols, and having a mechanism whereby the client and the web service can agree on the format of the data to exchange.

This guide provides best practices for designing RESTful web APIs. It also covers common design patterns and considerations for building web APIs that are easy to understand, flexible, and maintainable.



## RESTful web API design concepts

To implement a RESTful web API, you need to first understand the following concepts:

- **Uniform Resource Identifier (URI)**. REST APIs are designed around *resources*, which are any kind of object, data, or service that can be accessed by the client. Each resource should be represented by a URI that uniquely identifies that resource. For example, the URI for a particular customer order might be:
    
  ```http
  https://api.contoso.com/orders/1
  ```

- **Resource representation** is how a resource - identified by its URI - is encoded and transported over the HTTP protocol in a specific format, such as XML or JSON.  Clients that want to retrieve a specific resource, must use the resource's URI in the request to the API. The API, in response, returns a resource representation of the data indicated by the URI.  For example, a client can make a GET request to the URI identifier `https://api.contoso.com/orders/1` in order to receive the following JSON body:

  ```json
  {"orderId":1,"orderValue":99.9,"productId":1,"quantity":1}
  ```

- **Uniform interface** is used by RESTful APIS to achieve loose coupling of between client and service implementations. For REST APIs built on HTTP, the uniform interface includes using standard HTTP verbs to perform operations on resources such as `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`.

- **Stateless request model**. RESTful APIs use a stateless request model, which means that HTTP requests are independent and might occur in any order. For this reason, keeping transient state information between requests isn't feasible. The only place where information is stored is in the resources themselves, and each request should be an atomic operation.  A stateless request model supports high scalability, as there's no need to retain any affinity between clients and specific servers. However, the stateless model can also limit scalability, due to challenges with web service backend storage scalability. For more information about strategies to scale out a data store, see [Horizontal, vertical, and functional data partitioning](./data-partitioning.yml).

- **Hypermedia links**. REST APIs can be driven by hypermedia links that are contained in each resource representation. For example, the following shows a JSON representation of an order. It contains links to get or update the customer that's associated with the order.

  ```json
  {
    "orderID":3,
    "productID":2,
    "quantity":4,
    "orderValue":16.60,
    "links": [
      {"rel":"product","href":"https://api.contoso.com/customers/3", "action":"GET" },
      {"rel":"product","href":"https://api.contoso.com/customers/3", "action":"PUT" }
    ]
  }
  ```



## Define RESTful web API resource URIs

A RESTful web API is organized around resources. To organize your API design around resources, define resource URIs that map to the business entities.  When possible, resource URIs should be based on nouns (the resource) and not verbs (the operations on the resource).

For example, in an e-commerce system, the primary business entities might be *customers* and *orders*. To create an order, a client sends the order information in an HTTP POST request to the resource URI.  The HTTP response to the request indicates whether the order creation is successful.


The URI for creating the order resource could be something like:

```http
https://api.contoso.com/orders // Good

```

Avoid using verbs in URIs to represent operations. For example, the following URI isn't recommended:

```http
https://api.contoso.com/create-order // Avoid

```

Entities are often grouped together into collections (orders, customers). A collection is a separate resource from the item within the collection, and should have its own URI. For example, the following URI might represent the collection of orders:

```
https://api.contoso.com/orders

```

Once the client retrieves the collection, it can then make a GET request to the URI of each item. For example, to receive information on a specific order, the client would perform an HTTP GET on the URI `https://api.contoso.com/orders/1` to receive the following JSON body as a resource representation of the internal order data:

```json
{"orderId":1,"orderValue":99.9,"productId":1,"quantity":1}
```

### Resource URI naming conventions

When designing a RESTful web API, it's important that you use the correct naming and relationship conventions for resources:

- **Use nouns for resource names.** Use nouns to represent resources. For example, use `/orders` instead of `/create-order`. The verbal action on a URI is already implied by the HTTP GET, POST, PUT, PATCH, and DELETE methods.

- **Use plural nouns to name collection URIs.** In general, it helps to use plural nouns for URIs that reference collections. It's a good practice to organize URIs for collections and items into a hierarchy. For example, `/customers` is the path to the customer's collection, and `/customers/5` is the path to the customer with ID equal to 5. This approach helps to keep the web API intuitive. Also, many web API frameworks can route requests based on parameterized URI paths, so you could define a route for the path `/customers/{id}`.

- **Consider the relationships between different types of resources and how you might expose these associations.** For example, the `/customers/5/orders` might represent all of the orders for customer 5. You could also go in the other direction, and represent the association from an order back to a customer with a URI such as `/orders/99/customer`. However, extending this model too far can become cumbersome to implement. A better solution is to provide navigable links to associated resources in the body of the HTTP response message. This mechanism is described in more detail in the section [Use HATEOAS to enable navigation to related resources](#implement-hateoas-hypertext-as-the-engine-of-application-state).

- **Keep relationships simple and flexible**. In more complex systems, it can be tempting to provide URIs that allow the client to navigate through several levels of relationships, such as `/customers/1/orders/99/products`. However, this level of complexity can be difficult to maintain and is inflexible if the relationships between resources change in the future. Instead, try to keep URIs relatively simple. Once an application has a reference to a resource, it should be possible to use this reference to find items related to that resource. The preceding query can be replaced with the URI `/customers/1/orders` to find all the orders for customer 1, and then `/orders/99/products` to find the products in this order.

    > [!TIP]
    > Avoid requiring resource URIs more complex than *collection/item/collection*.

- **Avoid a large number of small resources**. All web requests impose a load on the web server. The more requests, the bigger the load. Therefore, try to avoid "chatty" web APIs that expose a large number of small resources. Such an API might require a client application to send multiple requests to find all of the data that it requires. Instead, you might want to denormalize the data and combine related information into bigger resources that can be retrieved with a single request. However, you still need to balance this approach against the overhead of fetching data that the client doesn't need. Retrieving large objects can increase the latency of a request and incur more bandwidth costs. For more information about these performance antipatterns, see [Chatty I/O](../antipatterns/chatty-io/index.md) and [Extraneous Fetching](../antipatterns/extraneous-fetching/index.md).

- **Avoid creating APIs that mirror the internal structure of a database.** The purpose of REST is to model business entities and the operations that an application can perform on those entities. A client shouldn't be exposed to the internal implementation. For example, if your data is stored in a relational database, the web API doesn't need to expose each table as a collection of resources. In fact, that's increasing the attack surface and might lead to data leakage. Instead, think of the web API as an abstraction of the database. If necessary, introduce a mapping layer between the database and the web API. That way, client applications are isolated from changes to the underlying database scheme. 

> [!TIP]
> It might not be possible to map every operation implemented by a web API to a specific resource. You can handle such *nonresource* scenarios through HTTP requests that invoke a function and return the results as an HTTP response message. For example, a web API that implements simple calculator operations such as add and subtract could provide URIs that expose these operations as pseudo resources and use the query string to specify the parameters required. For example, a GET request to the URI */add?operand1=99&operand2=1* would return a response message with the body containing the value 100. However, only use these forms of URIs sparingly.

## Define RESTful web API methods

RESTful web API methods mirror the request methods and media types as defined by the HTTP protocol. This section contains a description of the most common request methods, and the media types used in RESTful web APIs.

### HTTP request methods

The HTTP protocol defines many request methods that indicate the desired action to be performed on a resource. The most common methods used in RESTful web APIs are: [GET](#get-requests), [POST](#post-requests), [PUT](#put-request), [PATCH](#patch-requests), and [DELETE](#delete-requests). Each method corresponds to a specific operation. When designing a RESTful web API, you should use these methods in a way that is consistent with the protocol definition, the resource being accessed, and the action being performed.

It's important to remember that the effect of a specific request method should depend on whether the resource is a collection or an individual item. The following table includes some conventions that are commonly adopted by most RESTful implementations. 


> [!IMPORTANT]
> In the table, we're using an example e-commerce `customer` entity. It is never a requirement that a web API implement all of request methods, as it depends on the specific scenario.

| **Resource** | **POST** | **GET** | **PUT** | **DELETE** |
| --- | --- | --- | --- | --- |
| /customers |Create a new customer |Retrieve all customers |Bulk update of customers |Remove all customers |
| /customers/1 |Error |Retrieve the details for customer 1 |Update the details of customer 1 if it exists |Remove customer 1 |
| /customers/1/orders |Create a new order for customer 1 |Retrieve all orders for customer 1 |Bulk update of orders for customer 1 |Remove all orders for customer 1 |


#### GET requests

A GET request retrieves a representation of the resource at the specified URI. The body of the response message contains the details of the requested resource.

A GET request should return one of the following HTTP status codes:

| HTTP status code | Reason |
|------------------|-------------|
| 200 (OK) | The method has successfully returned the resource. |
| 204 (No Content) | The response body doesn't contain any content, such as when a search request returns no matches in the HTTP response.  |
| 404 (Not Found) | The requested resource can't be found. |



#### POST requests

A POST request should create a resource. The server assigns a URI for the new resource, and returns that URI to the client.  

>[!IMPORTANT]
>For POST requests, a client shouldn't attempt to create its own URI. The client should submit the request to the URI of the collection, and the server should assign a URI to the new resource. If a client attempts this and issues a POST request to a specific URI, the server will return HTTP status code 400 (BAD REQUEST) to indicate that the method isn't supported.

In a RESTful model, POST requests are generally used to add a new resource to the collection identified by the URI. However, a POST request can also be used to submit data for processing to an existing resource, without any new resource being created.

A POST request should return one of the following HTTP status codes:

| HTTP status code | Reason |
|------------------|-------------|
| 200 (OK) | The method has done some processing but doesn't create a new resource. The result of the operation may be included in the response body.|
| 201 (Created) | The resource was created successfully. The URI of the new resource is included in the Location header of the response. The response body contains a representation of the resource. |
| 204 (No Content) |The response body contains no content. |
| 400 (Bad Request) | The client has placed invalid data in the request. The response body can contain more information about the error or a link to a URI that provides more details. |
| 405 (Method Not Allowed) | The client has attempted to make a POST request to a URI that doesn't support such requests. |

#### PUT request

A PUT request should update an existing resource if it exists or, in some cases, create a new resource if it doesn't exist. The process of making a PUT request is as follows:

1. The client specifies the URI for the resource and includes request body that contains a complete representation of the resource.
1. The client makes the request. 
1. If a resource with this URI already exists, it is replaced. Otherwise a new resource is created, if the route supports doing so.

PUT methods are usually applied to resources that are individual items, such as a specific customer, rather than collections. A server might support updates but not creation via PUT. Whether to support creation via PUT depends on whether the client can meaningfully and reliably assign a URI to a resource before it exists. If not, then use POST to create resources and have the server assign the URI, then use PUT or PATCH to update.

> [!IMPORTANT]
> PUT requests must be idempotent. If a client submits the same PUT request multiple times, the results should always be the same (the same resource will be modified with the same values). POST and PATCH requests are not guaranteed to be idempotent.

A PUT request should return one of the following HTTP status codes:

| HTTP status code | Reason |
|------------------|-------------|
| 200 (OK) | The resource was updated successfully. |
| 201 (Created) | The resource was created successfully. The response body might contain a representation of the resource. |
| 204 (No Content) | The resource was updated successfully, but the response body doesn't contain any content. |
| 409 (Conflict) | The request couldn't be completed due to a conflict with the current state of the resource. |

> [!TIP]
> Consider implementing bulk HTTP PUT operations that can batch updates to multiple resources in a collection. The PUT request should specify the URI of the collection, and the request body should specify the details of the resources to be modified. This approach can help to reduce chattiness and improve performance.

#### PATCH requests

A PATCH request performs a *partial update* to an existing resource. The client specifies the URI for the resource. The request body specifies a set of *changes* to apply to the resource. This can be more efficient than using PUT, because the client only sends the changes, not the entire representation of the resource. Technically, PATCH can also create a new resource (by specifying a set of updates to a "null" resource), if the server supports this.

With a PATCH request, the client sends a set of updates to an existing resource, in the form of a *patch document*. The server processes the patch document to perform the update. The patch document doesn't describe the whole resource, only a set of changes to apply. The specification for the PATCH method ([RFC 5789](https://tools.ietf.org/html/rfc5789)) doesn't define a particular format for patch documents. The format must be inferred from the media type in the request.

JSON is probably the most common data format for web APIs. There are two main JSON-based patch formats, called *JSON patch* and *JSON merge patch*.

JSON merge patch is somewhat simpler. The patch document has the same structure as the original JSON resource, but includes just the subset of fields that should be changed or added. In addition, a field can be deleted by specifying `null` for the field value in the patch document. (That means merge patch isn't suitable if the original resource can have explicit null values.)

For example, suppose the original resource has the following JSON representation:

```json
{
    "name":"gizmo",
    "category":"widgets",
    "color":"blue",
    "price":10
}
```

Here's a possible JSON merge patch for this resource:

```json
{
    "price":12,
    "color":null,
    "size":"small"
}
```

This tells the server to update `price`, delete `color`, and add `size`, while `name` and `category` are not modified. For the exact details of JSON merge patch, see [RFC 7396](https://tools.ietf.org/html/rfc7396). The media type for JSON merge patch is `application/merge-patch+json`.

Merge patch isn't suitable if the original resource can contain explicit null values, due to the special meaning of `null` in the patch document. Also, the patch document doesn't specify the order that the server should apply the updates, which might not matter, depending on the data and the domain. JSON patch, defined in [RFC 6902](https://tools.ietf.org/html/rfc6902), is more flexible, as it specifies the changes as a sequence of operations to apply. Operations include add, remove, replace, copy, and test (to validate values). The media type for JSON patch is `application/json-patch+json`.


A PATCH request should return one of the following HTTP status codes:

| HTTP status code | Reason |
|------------------|-------------|
| 200 (OK) | The resource was updated successfully. |
| 400 (Bad Request) |  Malformed patch document.  |
| 409 (Conflict) | The patch document is valid, but the changes can't be applied to the resource in its current state. |
| 415 (Unsupported Media Type) | The patch document format isn't supported. |

#### DELETE requests

A DELETE request removes the resource at the specified URI.

A DELETE request should return one of the following HTTP status codes:

| HTTP status code | Reason |
|------------------|-------------|
| 204 (NO CONTENT) | The resource was deleted successfully. The process has been successfully handled and the response body contains no further information. |
| 404 (NOT FOUND) | The resource doesn't exist.  |



### Resource MIME types

As stated in [RESTful web API design concepts](#restful-web-api-design-concepts), resource representation is how a resource - identified by URI - is encoded and transported over the HTTP protocol in a specific format, such as XML or JSON.  Clients that want to retrieve a specific resource, must use the URI in the request to the API. The API, in response, returns a resource representation of the data indicated by the URI.  

In the HTTP protocol, resource representation formats are specified through the use of *media types*, also called MIME types. For nonbinary data, most web APIs support JSON (media type = `application/json`) and possibly XML (media type = `application/xml`).

The Content-Type header in a request or response specifies the resource representation format. Here's an example of a POST request that includes JSON data:

```http
POST https://api.contoso.com/orders
Content-Type: application/json; charset=utf-8
Content-Length: 57

{"Id":1,"Name":"Gizmo","Category":"Widgets","Price":1.99}
```

If the server doesn't support the media type, it should return HTTP status code 415 (Unsupported Media Type).

A client request can include an Accept header that contains a list of media types the client accepts from the server in the response message. For example:

```http
GET https://api.contoso.com/orders/2
Accept: application/json, application/xml
```

If the server can't match any of the media types listed, it should return HTTP status code 406 (Not Acceptable).

## Implement asynchronous methods

Sometimes a POST, PUT, PATCH, or DELETE method might require processing that takes a while to complete. If you wait for completion before sending a response to the client, it might cause unacceptable latency. If so, consider making the method asynchronous. An asynchronous method should return HTTP status code 202 (Accepted) to indicate the request was accepted for processing but isn't completed.

You should expose an endpoint that returns the status of an asynchronous request, so the client can monitor the status by polling the status endpoint. Include the URI of the status endpoint in the Location header of the 202 response. For example:

```http
HTTP/1.1 202 Accepted
Location: /api/status/12345
```

If the client sends a GET request to this endpoint, the response should contain the current status of the request. Optionally, it could also include an estimated time to completion or a link to cancel the operation.

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status":"In progress",
    "link": { "rel":"cancel", "method":"delete", "href":"/api/status/12345" }
}
```

If the asynchronous operation creates a new resource, the status endpoint should return status code 303 (See Other) after the operation completes. In the 303 response, include a Location header that gives the URI of the new resource:

```http
HTTP/1.1 303 See Other
Location: /api/orders/12345
```

For more information on how to implement this approach, see [Providing asynchronous support for long-running requests](/azure/architecture/best-practices/api-implementation#provide-asynchronous-support-for-long-running-requests) and the [Asynchronous Request-Reply pattern](../patterns/async-request-reply.yml).



## Implement data pagination and filtering

To optimize data retrieval and reduce payload size, implement **data pagination** and **query-based filtering** in your API design. These techniques allow clients to request only the subset of data they need, improving performance and reducing bandwidth usage.

- **Pagination** divides large datasets into smaller, manageable chunks. Use query parameters to specify the number of items to return (`limit`) and the starting point (`offset`). Make sure to also provide meaningful defaults for `limit` and `offset` (e.g., `limit=25`, `offset=0`). For example:


```http
GET /orders?limit=25&offset=50
```

- **`limit`**: Specifies the maximum number of items to return.
- **`offset`**: Specifies the starting index for the data.

>[!TIP]
>To help prevent **Denial of Service** attacks, consider imposing an upper limit on the number of items returned. For example, if your service sets `max-limit=25` and a client requests `limit=1000`, your service could either return 25 items or an HTTP BAD-REQUEST error, if the API is documented as such.

    
- **Filtering** allows clients to refine the dataset by applying conditions. The API can allow the client to pass filter in the query string of the URI:

    ```http
    GET /orders?minCost=100&status=shipped
    ```

    - **`minCost`**: Filters orders with a minimum cost of 100.
    - **`status`**: Filters orders with a specific status.


Also consider the following best practices:

- **Sorting**: Allow clients to sort data using a `sort` parameter (e.g., `sort=price`). 

    > [!IMPORTANT]
    > The sorting approach can have a negative effect on caching, because query string parameters form part of the resource identifier used by many cache implementations as the key to cached data.

- **Field selection for client-defined projections**: Enable clients to specify only the fields they need by using a `fields` parameter (e.g., `fields=id,name`). For example, you could use a query string parameter that accepts a comma-delimited list of fields, such as */orders?fields=ProductID,Quantity*.

Ensure your API validates the requested fields to ensure they are specifically allowed to be accessed by the client and wouldn't expose fields normally not available through the API.

## Support partial responses

Some resources contain large binary fields, such as files or images. To overcome problems caused by unreliable and intermittent connections and to improve response times, consider supporting the partial retrieval of large binary resources. 

To support partial responses, the web API should support the Accept-Ranges header for GET requests for large resources. This header indicates that the GET operation supports partial requests. The client application can submit GET requests that return a subset of a resource, specified as a range of bytes.

Also, consider implementing HTTP HEAD requests for these resources. A HEAD request is similar to a GET request, except that it only returns the HTTP headers that describe the resource, with an empty message body. A client application can issue a HEAD request to determine whether to fetch a resource by using partial GET requests. For example:

```http
HEAD https://api.contoso.com/products/10?fields=productImage
```

Here's an example response message:

```http
HTTP/1.1 200 OK

Accept-Ranges: bytes
Content-Type: image/jpeg
Content-Length: 4580
```

The Content-Length header gives the total size of the resource, and the Accept-Ranges header indicates that the corresponding GET operation supports partial results. The client application can use this information to retrieve the image in smaller chunks. The first request fetches the first 2,500 bytes by using the Range header:

```http
GET https://api.contoso.com/products/10?fields=productImage
Range: bytes=0-2499
```

The response message indicates that this is a partial response by returning HTTP status code 206. The Content-Length header specifies the actual number of bytes returned in the message body (not the size of the resource), and the Content-Range header indicates which part of the resource this is (bytes 0-2499 out of 4580):

```http
HTTP/1.1 206 Partial Content

Accept-Ranges: bytes
Content-Type: image/jpeg
Content-Length: 2500
Content-Range: bytes 0-2499/4580

[...]
```

A subsequent request from the client application can retrieve the remainder of the resource.

## Implement HATEOAS (Hypertext as the Engine of Application State)

One of the primary motivations behind REST is that it should be possible to navigate the entire set of resources without requiring prior knowledge of the URI scheme. Each HTTP GET request should return the information necessary to find the resources related directly to the requested object through hyperlinks included in the response, and it should also be provided with information that describes the operations available on each of these resources. This principle is known as HATEOAS, or Hypertext as the Engine of Application State. The system is effectively a finite state machine, and the response to each request contains the information necessary to move from one state to another. No other information should be necessary.

> [!NOTE]
> Currently there are no general-purpose standards that define how to model the HATEOAS principle. The examples shown in this section illustrate one possible, proprietary solution.

For example, to handle the relationship between an order and a customer, the representation of an order could include links that identify the available operations for the customer of the order. Here's a possible representation:

```json
{
  "orderID":3,
  "productID":2,
  "quantity":4,
  "orderValue":16.60,
  "links":[
    {
      "rel":"customer",
      "href":"https://api.contoso.com/customers/3",
      "action":"GET",
      "types":["text/xml","application/json"]
    },
    {
      "rel":"customer",
      "href":"https://api.contoso.com/customers/3",
      "action":"PUT",
      "types":["application/x-www-form-urlencoded"]
    },
    {
      "rel":"customer",
      "href":"https://api.contoso.com/customers/3",
      "action":"DELETE",
      "types":[]
    },
    {
      "rel":"self",
      "href":"https://api.contoso.com/orders/3",
      "action":"GET",
      "types":["text/xml","application/json"]
    },
    {
      "rel":"self",
      "href":"https://api.contoso.com/orders/3",
      "action":"PUT",
      "types":["application/x-www-form-urlencoded"]
    },
    {
      "rel":"self",
      "href":"https://api.contoso.com/orders/3",
      "action":"DELETE",
      "types":[]
    }]
}
```

In this example, the `links` array has a set of links. Each link represents an operation on a related entity. The data for each link includes the relationship ("customer"), the URI (`https://api.contoso.com/customers/3`), the HTTP method, and the supported MIME types. This is all the information that a client application needs to be able to invoke the operation.

The `links` array also includes self-referencing information about the resource itself that has been retrieved. These have the relationship *self*.

The set of links that are returned can change depending on the state of the resource. This is what is meant by hypertext being the *engine of application state*.

## Implement versioning

It is highly unlikely that a web API will remain static. As business requirements change, new collections of resources can be added. As new resources are added, the relationships between resources might change, and the structure of the data in resources might be amended. While updating a web API to handle new or differing requirements is a relatively straightforward process, you must consider the effects that such changes have on client applications consuming the web API. The issue is that, although the developer designing and implementing a web API has full control over that API, they don't have the same degree of control over client applications, which can be built by remote third-party organizations. It's important to still support existing unchanged client applications, while allowing new client applications to take advantage of new features and resources.

A web API that implements versioning can indicate the features and resources that it exposes, and a client application can submit requests that are directed to a specific version of a feature or resource. The following sections describe several different approaches, each of which has its own benefits and trade-offs.

### No versioning

This is the simplest approach, and can be acceptable for some internal APIs. Significant changes could be represented as new resources or new links. Adding content to existing resources might not present a breaking change as client applications that aren't expecting to see this content simply ignore it.

For example, a request to the URI `https://api.contoso.com/customers/3` should return the details of a single customer containing `id`, `name`, and `address` fields expected by the client application:

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","address":"1 Microsoft Way Redmond WA 98053"}
```

> [!NOTE]
> For simplicity, the example responses shown in this section don't include HATEOAS links.

If the `DateCreated` field is added to the schema of the customer resource, then the response would look like this:

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","dateCreated":"2025-03-22T12:11:38.0376089Z","address":"1 Microsoft Way Redmond WA 98053"}
```

Existing client applications might continue functioning correctly if they are capable of ignoring unrecognized fields. Meanwhile, new client applications can be designed to handle this new field. However, if more radical changes to the schema of resources occur, such as removing or renaming fields, or the relationships between resources change, then these can constitute breaking changes that prevent existing client applications from functioning correctly. In these situations, you should consider one of the following approaches:

- [URI versioning](#uri-versioning)
- [Query string versioning](#query-string-versioning)
- [Header versioning](#header-versioning)
- [Media type versioning](#media-type-versioning)

### URI versioning

Each time you modify the web API or change the schema of resources, you add a version number to the URI for each resource. The previously existing URIs should continue to operate as before, returning resources that conform to their original schema.

Extending the previous example, if the `address` field is restructured into subfields containing each constituent part of the address (such as `streetAddress`, `city`, `state`, and `zipCode`), this version of the resource could be exposed through a URI containing a version number, such as `https://api.contoso.com/v2/customers/3`:

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","dateCreated":"2025-03-22T12:11:38.0376089Z","address":{"streetAddress":"1 Microsoft Way","city":"Redmond","state":"WA","zipCode":98053}}
```

This versioning mechanism is very simple but depends on the server routing the request to the appropriate endpoint. However, it can become unwieldy as the web API matures through several iterations and the server has to support a number of different versions. Also, from a purist's point of view, in all cases, the client applications are fetching the same data (customer 3), so the URI shouldn't really be different depending on the version. This scheme also complicates implementation of HATEOAS as all links need to include the version number in their URIs.

### Query string versioning

Rather than providing multiple URIs, you can specify the version of the resource by using a parameter within the query string appended to the HTTP request, such as `https://api.contoso.com/customers/3?version=2`. The version parameter should default to a meaningful value such as 1 if it is omitted by older client applications.

This approach has the semantic advantage that the same resource is always retrieved from the same URI, but it depends on the code that handles the request to parse the query string and send back the appropriate HTTP response. This approach also suffers from the same complications for implementing HATEOAS as the URI versioning mechanism.

> [!NOTE]
> Some older web browsers and web proxies don't cache responses for requests that include a query string in the URI. This can degrade performance for web applications that use a web API and run from within such a web browser.

### Header versioning

Rather than appending the version number as a query string parameter, you could implement a custom header that indicates the version of the resource. This approach requires that the client application adds the appropriate header to any requests. However, the code handling the client request could use a default value (version 1) if the version header is omitted. 

The following examples use a custom header named *Custom-Header*. The value of this header indicates the version of web API.

Version 1:

```http
GET https://api.contoso.com/customers/3
Custom-Header: api-version=1
```

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","address":"1 Microsoft Way Redmond WA 98053"}
```

Version 2:

```http
GET https://api.contoso.com/customers/3
Custom-Header: api-version=2
```

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","dateCreated":"2025-03-22T12:11:38.0376089Z","address":{"streetAddress":"1 Microsoft Way","city":"Redmond","state":"WA","zipCode":98053}}
```

As with [URI versioning](#uri-versioning) and [query string versioning](#query-string-versioning), implementing HATEOAS requires including the appropriate custom header in any links.

### Media type versioning

When a client application sends an HTTP GET request to a web server it should use and Accept header to specify the format of the content that it can handle. Usually, the purpose of the *Accept* header is to allow the client application to specify whether the body of the response should be XML, JSON, or some other common format that the client can parse. However, it's possible to define custom media types that include information that lets the client application indicate which version of a resource it's expecting.

The following example shows a request that specifies an *Accept* header with the value *application/vnd.contoso.v1+json*. The *vnd.contoso.v1* element indicates to the web server that it should return version 1 of the resource, while the *json* element specifies that the format of the response body should be JSON:

```http
GET https://api.contoso.com/customers/3
Accept: application/vnd.contoso.v1+json
```

The code handling the request is responsible for processing the *Accept* header and honoring it as far as possible. The client application can specify multiple formats in the *Accept* header, in which case the web server can choose the most appropriate format for the response body. The web server confirms the format of the data in the response body by using the Content-Type header:

```http
HTTP/1.1 200 OK
Content-Type: application/vnd.contoso.v1+json; charset=utf-8

{"id":3,"name":"Fabrikam, Inc.","address":"1 Microsoft Way Redmond WA 98053"}
```

If the Accept header doesn't specify any known media types, the web server could generate an HTTP 406 (Not Acceptable) response message or return a message with a default media type.

This approach is arguably the purest of the versioning mechanisms and lends itself naturally to HATEOAS, which can include the MIME type of related data in resource links.

> [!NOTE]
> When you select a versioning strategy, you should also consider the implications on performance, especially caching on the web server. The URI versioning and query string versioning schemes are cache-friendly inasmuch as the same URI/query string combination refers to the same data each time.
>
> The header versioning and Media Type versioning mechanisms typically require additional logic to examine the values in the custom header or the Accept header. In a large-scale environment, many clients using different versions of a web API can result in a significant amount of duplicated data in a server-side cache. This issue can become acute if a client application communicates with a web server through a proxy that implements caching, and that only forwards a request to the web server if it doesn't currently hold a copy of the requested data in its cache.

## Multitenant web APIs

A *multitenant* web API solution is one that's shared by multiple tenants, such as distinct organizations with their own groups of users.

Multitenancy has a significant impact on web API design, as it dictates how resources are accessed and discovered across multiple tenants within a single web API. Designing an API with multitenancy in mind from the outset helps avoid the need for later refactoring to implement isolation, scalability, or per-tenant customizations.

A well-architected API should clearly define how tenants are identified in requests—whether through subdomains, paths, headers, or tokens-to provide with a consistent yet flexible experience for all users. For more information, please take a look at [Map requests to tenants in a multitenant solution](/azure/architecture/guide/multitenant/considerations/map-requests)

Multitenancy impacts endpoint structure, request handling, authentication, and authorization. The approach also influences how API gateways, load balancers, and backend services route and process requests. Below are some common strategies for achieving multitenancy in a web API.

### Use subdomain or domain-based isolation (DNS-level tenancy)

This approach routes requests using [tenant-specific domains](/azure/architecture/guide/multitenant/considerations/domain-names). Wildcard domains use subdomains for flexibility and simplicity, while custom domains, allowing tenants to use their own domains, provide greater control and can be tailored to specific needs. Both methods rely on proper DNS configuration (including `A` and `CNAME` records) to direct traffic to the appropriate infrastructure. Wildcard domains simplify configuration, while custom domains offer a more branded experience. [Preserving the hostname](/azure/architecture/best-practices/host-name-preservation) between the reverse proxy and backend services helps avoid issues like URL redirection and prevents exposing internal URLs. This ensures correct routing of tenant-specific traffic and protects internal infrastructure. DNS resolution also plays a key role in achieving data residency and ensuring regulatory compliance.

```http
GET https://adventureworks.api.contoso.com/orders/3
```

### Pass tenant-specific HTTP headers

Tenant information can be passed through custom HTTP headers (e.g. `X-Tenant-ID` or `X-Organization-ID`), host-based headers (e.g. `Host`, `X-Forwarded-Host`), or extracted from JSON Web Token (JWT) claims. The choice depends on the routing capabilities of your API gateway or reverse proxy, with header-based solutions requiring a Layer 7 (L7) gateway to inspect each request. This adds processing overhead, increasing compute costs as traffic scales.  However, header-based isolation offers key benefits, as it enables centralized authentication, which simplifies security management across multitenant APIs. By using SDKs or API clients, tenant context is dynamically managed at runtime, reducing client-side configuration complexity. Also, keeping tenant context in headers results in a cleaner, more RESTful API design, avoiding tenant-specific data in the URI. 

An important consideration with header-based routing is that it complicates caching, particularly when cache layers rely solely on URI-based keys and don't account for headers. Since most caching mechanisms optimize for URI lookups, relying on headers can lead to fragmented cache entries, reducing cache hits and increasing backend load. More critically, if a caching layer doesn't differentiate responses by headers, it can serve cached data intended for one tenant to another, creating a risk of data leakage.

```http
GET https://api.contoso.com/orders/3
X-Tenant-ID: adventureworks
```

or

```http
GET https://api.contoso.com/orders/3
Host: adventureworks
```

or

```http
GET https://api.contoso.com/orders/3
Authorization: Bearer <JWT-token including a tenant-id: adventureworks claim>
```

### Pass tenant-specific information through the URI path

This approach appends tenant identifiers within the resource hierarchy, relying on the API gateway or reverse proxy to determine the appropriate tenant based on the path segment. While effective, path-based isolation compromises the web API’s RESTful design and introduces more complex routing logic, often requiring pattern matching or regular expressions to parse and canonicalize the URI path.  In contrast, header-based isolation conveys tenant information through HTTP headers as key-value pairs. Both approaches enable efficient infrastructure sharing, lowering operational costs and enhancing performance in large-scale, multitenant web APIs.

```http
GET https://api.contoso.com/tenants/adventureworks/orders/3
```

## Enabling distributed tracing and trace context in APIs

As distributed systems and microservice architectures have become the standard, [the complexity of modern architectures has increased](/azure/architecture/best-practices/monitoring). Consequently, using headers to propagate trace context in API requests (such as `Correlation-ID`, `X-Request-ID`, or `X-Trace-ID`) has become a best practice for achieving end-to-end visibility. This approach enables seamless tracking of requests as they flow from the client to backend services, facilitating rapid identification of failures, monitoring of latency, and mapping of API dependencies across services.  APIs that support the inclusion of trace and context information enhance their observability level and debugging capabilities. By enabling distributed tracing, these APIs allow for a more granular understanding of system behavior, making it easier to track, diagnose, and resolve issues across complex, multi-service environments.

```http
GET https://api.contoso.com/orders/3
Correlation-ID: 0f8fad5b-d9cb-469f-a165-70867728950e
```

```http
HTTP/1.1 200 OK
...
Correlation-ID: 0f8fad5b-d9cb-469f-a165-70867728950e

{...}
```

## Web API maturity model

In 2008, Leonard Richardson proposed what is now known as The Richardson Maturity Model (RMM) for web APIs. The RMM defines four levels of maturity for web APIs and is based on the principles of REST as an architectural approach to designing web services. In the RMM, as the level of maturity increases, the API becomes more RESTful and more closely follows the principles of REST. 

The levels are as follows:
 
- **Level 0**: Define one URI, and all operations are POST requests to this URI. SOAP web services are typically at this level.
- **Level 1**: Create separate URIs for individual resources. This level isn't yet RESTful, but is beginning to align with RESTful design.
- **Level 2**: Use HTTP methods to define operations on resources.  In practice, many published web APIs fall somewhere around this level.
- **Level 3**: Use hypermedia ([HATEOAS](#implement-hateoas-hypertext-as-the-engine-of-application-state)). This level is truly a RESTful API, according to Fielding's definition. 


## OpenAPI Initiative

The [OpenAPI Initiative](https://www.openapis.org) was created by an industry consortium to standardize REST API descriptions across vendors.  The standardizing specification was called Swagger before it was brought under the OpenAPI Initiative and renamed to the OpenAPI Specification (OAS).

You might want to adopt OpenAPI for your RESTful web APIs. Some points to consider:

- The OpenAPI Specification comes with a set of opinionated guidelines on how a REST API should be designed. That has advantages for interoperability, but requires more care when designing your API to conform to the specification.

- OpenAPI promotes a contract-first approach, rather than an implementation-first approach. Contract-first means you design the API contract (the interface) first and then write code that implements the contract.

- Tools like Swagger (OpenAPI) can generate client libraries or documentation from API contracts. For example, see [ASP.NET Core web API documentation with Swagger / OpenAPI](/aspnet/core/tutorials/web-api-help-pages-using-swagger).

## Next steps

- [Microsoft Azure REST API Guidelines](https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md). Detailed recommendations for designing REST APIs on Azure.

- [Web API checklist](https://mathieu.fenniak.net/the-api-checklist). A useful list of items to consider when designing and implementing a web API.

- [Open API Initiative](https://www.openapis.org). Documentation and implementation details on Open API.

- [SaaS and multitenant solution architecture](/azure/architecture/guide/saas-multitenant-solution-architecture/). Architect multitenant solutions on Azure.
