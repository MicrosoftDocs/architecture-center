---
title: Asynchronous Request-Reply Pattern
description: Learn how to decouple back-end processing from front-end hosts by using asynchronous operations and HTTP polling for long-running tasks.
ms.author: pnp
author: claytonsiemens77
ms.date: 02/27/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Asynchronous Request-Reply pattern

Decouple back-end processing from a front-end host when back-end processing needs to run asynchronously but the front end needs a clear response.

## Context and problem

In modern application development, client applications often rely on remote APIs to provide business logic and compose functionality. Many applications run code in a web browser, and other environments also host client code. The APIs might relate directly to the application or operate as shared services from an external service. Most API calls use HTTP or HTTPS and follow REST semantics.

In most cases, APIs for a client application respond in about 100 milliseconds (ms) or less. Many factors can affect the response latency:

- The application's hosting stack
- Security components
- The relative geographic location of the caller and the back end
- Network infrastructure
- Current load
- The size of the request payload
- Processing queue length
- The time for the back end to process the request

These factors can add latency to the response. You can mitigate some factors by scaling out the back end. Other factors, like network infrastructure, are outside the application developer's control. Most APIs respond quickly enough for the response to return over the same connection. Application code can make a synchronous API call in a nonblocking way to give the appearance of asynchronous processing. We recommend this approach for input and output (I/O)‑bound operations.

In some scenarios, the back end does work that's long-running and takes a few seconds. In other scenarios, the back end does long-running background work for minutes or for extended periods. In these cases, you can't wait for the work to finish before you send a response. This situation can create a problem for synchronous request-reply patterns.

Some architectures solve this problem by using a message broker to separate the request and response stages. Many systems achieve this separation through the [Queue-Based Load Leveling pattern](./queue-based-load-leveling.yml). This separation lets the client process and the back-end API scale independently. It also introduces extra complexity when the client requires success notification because that step must also become asynchronous.

Many of the same considerations that apply to client applications also apply to server-to-server REST API calls in distributed systems, like in a microservices architecture.

## Solution

One solution to this problem is to use HTTP polling. Polling works well for client-side code when callback endpoints are unavailable or when long-running connections add too much complexity. Even when callbacks are possible, the extra libraries and services that they require can increase complexity.

The following steps describe the solution:

- The client application makes a synchronous call to the API to trigger a long-running operation on the back end.

- The API responds synchronously as quickly as possible. It returns an HTTP 202 (Accepted) status code to acknowledge that it received the request for processing.

    > [!NOTE]
    > The API validates the request and the action to be performed before it starts the long-running process. If the request isn't valid, reply immediately with an error code like HTTP 400 (Bad Request).

- The response includes a location reference that points to an endpoint that the client can poll to check the result of the long-running operation.

- The API offloads processing to another component, like a message queue.

- For a successful call to the status endpoint, the endpoint returns HTTP 200 (OK). While the work is in progress, the endpoint returns a resource that indicates that state. When the work completes, the endpoint returns a resource that indicates completion or redirects to another resource URL. For example, if the asynchronous operation creates a new resource, the status endpoint redirects to the URL for that resource.

The following diagram shows a typical flow.

:::image type="complex" border="false" source="./_images/async-request.png" alt-text="Diagram that shows the request and response flow for asynchronous HTTP requests." lightbox="./_images/async-request.png":::
   A sequence diagram that shows a client, an API endpoint, a status endpoint, and a resource URI. The client sends a POST request to the API endpoint, which returns HTTP 202. The client then sends repeated GET requests to the status endpoint. The first response returns HTTP 200, and a later response returns HTTP 302 (Found). The client follows the redirect with a GET request to the resource URI, which returns HTTP 200. The diagram shows an asynchronous request pattern with polling and a final redirect to the completed resource.
:::image-end:::

1. The client sends a request and receives an HTTP 202 response.

1. The client sends an HTTP GET request to the status endpoint. The work is pending, so this call returns HTTP 200.

1. The work completes and the status endpoint returns HTTP 302 (Found) to redirect to the resource.

1. The client fetches the resource at the specified URL.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Multiple ways exist to implement this pattern over HTTP, and upstream services don't always use the same semantics. For example, most services return HTTP 404 (Not Found) from a GET method when a remote process isn't complete, rather than HTTP 202. According to standard REST semantics, HTTP 404 is the correct response because the result of the call doesn't exist yet.

- An HTTP 202 response indicates where the client polls and how often. It includes the following headers.

    | Header | Description | Notes |
    | --- | --- | --- |
    | `Location` | A URL that the client polls for a response status | This URL can be a shared access signature token. The [Valet Key pattern](./valet-key.yml) works well when this location needs access control. The pattern also applies when response polling needs to move to another back end. |
    | `Retry-After` | An estimate of when processing will complete | This header prevents polling clients from sending too many requests to the back end. |

    Consider expected client behavior when you design this response. A client that you control can follow these response values exactly. Clients that others author, including clients built by using no-code or low-code tools like Azure Logic Apps, can apply their own handling for HTTP 202.

- You might need to use a processing proxy to adjust the response headers or payload, depending on the underlying services that you use.

- If the status endpoint redirects after completion, either [HTTP 302](https://datatracker.ietf.org/doc/html/rfc7231#section-6.4.3) or [HTTP 303 (See Other)](https://datatracker.ietf.org/doc/html/rfc7231#section-6.4.4) are valid return codes, depending on the semantics that you support.

- After the server processes the request, the resource that the `Location` header specifies returns an HTTP status code like 200, 201 (Created), or 204 (No Content).

- If an error occurs during processing, persist the error at the resource URL that the `Location` header specifies and return a 4xx status code from that resource that matches the failure.

- Solutions don't all implement this pattern the same way, and some services include extra or alternate headers. For example, Azure Resource Manager uses a modified variant of this pattern. For more information, see [Resource Manager asynchronous operations](/azure/azure-resource-manager/management/async-operations).

- Legacy clients might not support this pattern. In that case, you might need to place a processing proxy over the asynchronous API to hide the asynchronous processing from the original client. For example, Logic Apps supports this pattern natively, and you can use it as an integration layer between an asynchronous API and a client that makes synchronous calls. For more information, see [Perform long-running tasks with the webhook action pattern](/azure/logic-apps/logic-apps-create-api-app#perform-long-running-tasks-with-the-webhook-action-pattern).

- In some scenarios, you might want to provide a way for clients to cancel a long-running request. In that case, the back-end service must support some form of cancellation instruction.

## When to use this pattern

Use this pattern when:

- You work with client-side code, like browser applications, and those constraints make callback endpoints difficult to provide, or long-running connections add too much complexity.

- You call a service that uses only the HTTP protocol and the return service can't send callbacks because of firewall restrictions on the client side.

- You integrate with legacy architectures that don't support modern callback mechanisms like WebSockets or webhooks.

This pattern might not be suitable when:

- You can use a service built for asynchronous notifications instead, like Azure Event Grid.

- Responses must stream in real time to the client.

- The client needs to collect many results and the latency of those results is important. Consider a service bus pattern instead.

- Server-side persistent network connections like WebSockets or SignalR are available. You can use these connections to notify the caller of the result.

- The network design supports open ports to receive asynchronous callbacks or webhooks.

## Workload design

An architect should evaluate how they can use the Asynchronous Request-Reply pattern in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars).

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | You improve responsiveness and scalability by decoupling the request and reply phases for processes that don't require an immediate response. An asynchronous approach increases concurrency and lets the server schedule work as capacity becomes available. <br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:07 Code and infrastructure](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) |

As with any design decision, consider trade-offs against the goals of the other pillars that this pattern might introduce.

## Example

The following code shows excerpts from an application that uses Azure Functions to implement this pattern. This solution has three functions:

- The asynchronous API endpoint
- The status endpoint
- A back-end function that takes queued work items and runs them

:::image type="complex" border="false" source="_images/async-request-fn.png" alt-text="Diagram of the structure of the Asynchronous Request Reply pattern in Functions." lightbox="_images/async-request-fn.png":::
   In step 1, a client calls an API. In step 2, the API places a message in a queue. In step 3, the API returns a status endpoint to the client. In step 4, a worker receives the message from the queue. In step 5, the worker processes the message and writes the result to blob storage. In step 6, the client calls the status endpoint. In step 7, the status endpoint checks for the result in blob storage.
:::image-end:::

![GitHub logo.](../_images/github.png) This sample is available on [GitHub](https://github.com/mspnp/cloud-design-patterns/blob/main/async-request-reply/README.md).

### AsyncProcessingWorkAcceptor function

The `AsyncProcessingWorkAcceptor` function implements an endpoint that accepts work from a client application and enqueues it for processing:

- The function generates a request ID and adds it as metadata to the queue message.

- The HTTP response includes a `Location` header that points to a status endpoint. The request ID appears in the URL path.

```csharp
    public class AsyncProcessingWorkAcceptor(ServiceBusClient _serviceBusClient)
    {
        [Function("AsyncProcessingWorkAcceptor")]
        public async Task<IActionResult> RunAsync([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req, [FromBody] CustomerPOCO customer)
        {
            if (string.IsNullOrEmpty(customer.id) || string.IsNullOrEmpty(customer.customername))
            {
                return new BadRequestResult();
            }

            var reqid = Guid.NewGuid().ToString();

            string scheme = Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT") == "Development" ? "http" : "https";
            var rqs = $"{scheme}://{Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME")}/api/RequestStatus/{reqid}";

            var messagePayload = JsonConvert.SerializeObject(customer);
            var message = new ServiceBusMessage(messagePayload);
            message.ApplicationProperties.Add("RequestGUID", reqid);
            message.ApplicationProperties.Add("RequestSubmittedAt", DateTime.Now);
            message.ApplicationProperties.Add("RequestStatusURL", rqs);
            var sender = _serviceBusClient.CreateSender("outqueue");

            await sender.SendMessageAsync(message);
            return new AcceptedResult(rqs, $"Request Accepted for Processing{Environment.NewLine}ProxyStatus: {rqs}");
        }
    }
```

### AsyncProcessingBackgroundWorker function

The `AsyncProcessingBackgroundWorker` function reads the operation from the queue, processes it based on the message payload, and writes the result to a storage account.

```csharp
    public class AsyncProcessingBackgroundWorker(BlobContainerClient _blobContainerClient)
    {
        [Function(nameof(AsyncProcessingBackgroundWorker))]
        public async Task Run([ServiceBusTrigger("outqueue", Connection = "ServiceBusConnection")] ServiceBusReceivedMessage message)
        {
            var requestGuid = message.ApplicationProperties["RequestGUID"].ToString();
            string blobName = $"{requestGuid}.blobdata";

            await _blobContainerClient.CreateIfNotExistsAsync();

            var blobClient = _blobContainerClient.GetBlobClient(blobName);
            using (MemoryStream memoryStream = new MemoryStream())
            using (StreamWriter writer = new StreamWriter(memoryStream))
            {
                writer.Write(message.Body.ToString());
                writer.Flush();
                memoryStream.Position = 0;

                await blobClient.UploadAsync(memoryStream, overwrite: true);
            }
        }
    }
```

### AsyncOperationStatusChecker function

The `AsyncOperationStatusChecker` function implements the status endpoint. This function checks the status of the request:

- If the request completes, the function returns a [valet key](./valet-key.yml) to the response or redirects the call immediately to the valet-key URL.

- If the request is pending, the function returns an [HTTP 200 code that includes the current state](/azure/architecture/best-practices/api-design#implement-asynchronous-methods).

```csharp
    public class AsyncOperationStatusChecker(ILogger<AsyncOperationStatusChecker> _logger)
    {  
        [Function("AsyncOperationStatusChecker")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "RequestStatus/{thisGUID}")] HttpRequest req,
             [BlobInput("data/{thisGUID}.blobdata", Connection = "DataStorage")] BlockBlobClient inputBlob, string thisGUID)
        {
            OnCompleteEnum OnComplete = Enum.Parse<OnCompleteEnum>(req.Query["OnComplete"].FirstOrDefault() ?? "Redirect");
            OnPendingEnum OnPending = Enum.Parse<OnPendingEnum>(req.Query["OnPending"].FirstOrDefault() ?? "OK");

            _logger.LogInformation($"C# HTTP trigger function processed a request for status on {thisGUID} - OnComplete {OnComplete} - OnPending {OnPending}");

            // Check whether the blob exists.
            if (await inputBlob.ExistsAsync())
            {
                // If the blob exists, the function uses the OnComplete parameter to determine the next action.
                return await OnCompleted(OnComplete, inputBlob, thisGUID);
            }
            else
            {
                // If the blob doesn't exist, the function uses the OnPending parameter to determine the next action.
                string scheme = Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT") == "Development" ? "http" : "https";
                string rqs = $"{scheme}://{Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME")}/api/RequestStatus/{thisGUID}";

                switch (OnPending)
                {
                    case OnPendingEnum.OK:
                        {
                            // Return an HTTP 200 status code.
                            return new OkObjectResult(new { status = "In progress", Location = rqs });
                        }

                    case OnPendingEnum.Synchronous:
                        {
                            // Back off and retry. Time out if the back-off period reaches one minute.
                            int backoff = 250;

                            while (!await inputBlob.ExistsAsync() && backoff < 64000)
                            {
                                _logger.LogInformation($"Synchronous mode {thisGUID}.blob - retrying in {backoff} ms");
                                backoff = backoff * 2;
                                await Task.Delay(backoff);
                            }

                            if (await inputBlob.ExistsAsync())
                            {
                                _logger.LogInformation($"Synchronous Redirect mode {thisGUID}.blob - completed after {backoff} ms");
                                return await OnCompleted(OnComplete, inputBlob, thisGUID);
                            }
                            else
                            {
                                _logger.LogInformation($"Synchronous mode {thisGUID}.blob - NOT FOUND after timeout {backoff} ms");
                                return new NotFoundResult();
                            }
                        }

                    default:
                        {
                            throw new InvalidOperationException($"Unexpected value: {OnPending}");
                        }
                }
            }
        }
        private async Task<IActionResult> OnCompleted(OnCompleteEnum OnComplete, BlockBlobClient inputBlob, string thisGUID)
        {
            switch (OnComplete)
            {
                case OnCompleteEnum.Redirect:

                    {
                        // The typical way to generate a shared access signature token in code requires the storage account key.
                        // If you need to use a managed identity to control access to your storage accounts in code, which is a recommended best practice, you should do so when possible.
                        // In this scenario, you don't have a storage account key, so you need to find another way to generate the shared access signatures.
                        // To generate shared access signatures, use a user delegation shared access signature. This approach lets you sign the shared access signature by using Microsoft Entra ID credentials instead of the storage account key.

                        BlobServiceClient blobServiceClient = inputBlob.GetParentBlobContainerClient().GetParentBlobServiceClient();
                        var userDelegationKey = await blobServiceClient.GetUserDelegationKeyAsync(DateTimeOffset.UtcNow, DateTimeOffset.UtcNow.AddDays(7));
                        // Redirect the shared access signature uniform resource identifier (URI) to blob storage.
                        return new RedirectResult(inputBlob.GenerateSASURI(userDelegationKey));
                    }

                case OnCompleteEnum.Stream:
                    {
                        // Download the file and return it directly to the caller.
                        // For larger files, use a stream to minimize RAM usage.
                        return new OkObjectResult(await inputBlob.DownloadContentAsync());
                    }

                default:
                    {
                        throw new InvalidOperationException($"Unexpected value: {OnComplete}");
                    }
            }
        }
    }

    public enum OnCompleteEnum
    {

        Redirect,
        Stream
    }

    public enum OnPendingEnum
    {

        OK,
        Synchronous
    }
```

The following `CloudBlockBlobExtensions` class provides an extension method that the status checker uses to generate a user delegation shared access signature uniform resource identifier (URI) for the result blob.

```csharp
    public static class CloudBlockBlobExtensions
    {
        public static string GenerateSASURI(this BlockBlobClient inputBlob, UserDelegationKey userDelegationKey)
        {
            BlobServiceClient blobServiceClient = inputBlob.GetParentBlobContainerClient().GetParentBlobServiceClient();

            BlobSasBuilder blobSasBuilder = new BlobSasBuilder()
            {
                BlobContainerName = inputBlob.BlobContainerName,
                BlobName = inputBlob.Name,
                Resource = "b",
                StartsOn = DateTimeOffset.UtcNow,
                ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(10)
            };
            blobSasBuilder.SetPermissions(BlobSasPermissions.Read);

            var blobUriBuilder = new BlobUriBuilder(inputBlob.Uri)
            {
                Sas = blobSasBuilder.ToSasQueryParameters(userDelegationKey, blobServiceClient.AccountName)
            };

            // Generate the shared access signature on the blob, which sets the constraints directly on the signature.
            Uri sasUri = blobUriBuilder.ToUri();

            // Return the URI string for the container, including the shared access signature token.
            return sasUri.ToString();
        }
    }
```

## Next steps

- [Use the polling action pattern for long-running tasks](/azure/logic-apps/logic-apps-create-api-app#perform-long-running-tasks-with-the-polling-action-pattern)
- [Asynchronous HTTP API pattern](/azure/azure-functions/durable/durable-functions-overview#async-http)

## Related resources

- [Web API design](../best-practices/api-design.md)
- [Backends for Frontends pattern](./backends-for-frontends.md)
- [Valet Key pattern](./valet-key.yml)
