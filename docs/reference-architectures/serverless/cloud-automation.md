---
title: Serverless cloud automation 
titleSuffix: Azure Reference Architectures
description: Recommended architecture for implementing cloud automation using serverless technologies.
author: dsk-2015
ms.author: dkshir
ms.date: 10/30/2019
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Serverless cloud automation on Azure

Cloud automation is a broad term, which basically means automating workflows and tasks on the cloud. This reference architecture illustrates two of the most common cloud automation scenarios using [serverless](https://azure.microsoft.com/solutions/serverless/) technologies. Serverless computing can dramatically improve productivity of an organization's DevOps team. The two scenarios covered in this article use [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) that perform customized automation tasks, triggered by events such as infrastructure state change, or some other organizational activity.

![Serverless cloud automation](./_images/cloud-automation.png)

The serverless model is best suited to automate cloud operations that follow an [event-driven approach](https://blogs.gartner.com/tony-iams/using-serverless-computing-automate-cloud-operations/). These scenarios follow key event-driven patterns such as:

- statelessness, where communication happens through callback notifications,
- concurrency, where functions subscribe to notifications from event sources,
- idempotence, where event sources have no knowledge of processing in the function, and
- events record the transitions in the states, and represent the history of actions.

![GitHub logo](../../_images/github.png) The reference implementations for this architecture are available on [GitHub](https://github.com/mspnp/serverless-automation). These cover the following automation scenarios:

1. [Cost center tagging](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/deployment.md) - This workflow tags all new resources in a group, with the cost center information. It then validates this information against Azure Active Directory, for any change in the cost center, and sends out an email notification to the resource owner. If any changes are detected, it also updates the tagged information, before sending out the email.

1. [Throttling response](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md) - This workflow monitors a Cosmos DB database for throttling, which happens when data access requests are more than what the [CosmosDB Request Units (or RUs)](https://docs.microsoft.com/en-us/azure/cosmos-db/request-units) can handle. The automation function then scales the throughput, by increasing the RUs to a preset value.

## Architecture

The architecture consists of the following blocks:

**Automation Function**. [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) provide the event-driven serverless compute capabilities. It performs automation tasks, when triggered by events such as a new resource creation in the case of the first scenario, or a database overload error in the case of the second. In both these implementations, the automation function is invoked with an HTTP request. To avoid HTTP timeouts for a longer automation task, you can optionally queue this event in a Service Bus and handle the actual automation in a second function.

**Logic App**. [Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) provide an optional workflow element in this architecture. This can be used to perform non-automation related tasks which can be more easily implemented using [Logic App's built-in connectors](https://docs.microsoft.com/en-us/azure/connectors/apis-list), such as sending an email.

**Event Grid**. [Event Grid](https://docs.microsoft.com/en-us/azure/event-grid/overview) has built-in support for events from other Azure services, as well as your own events (as custom topics). It provides an important channel between events from an Azure resource and your automation workflow. Most event-driven automation workflows will use this channel, such as the cost center automation scenario.

**Azure Monitor**. [Azure Monitor Alerts](https://docs.microsoft.com/en-us/azure/azure-monitor/overview#alerts) can monitor for critical conditions, and send alert notifications for corrective action using *action groups*. This is useful for monitoring for error conditions, such as the CosmosDB throttling alert in the second scenario.

**Actions**. Your automation function can interact with other Azure services to provide the functionality as an action. The tagging scenario verifies the tagged cost center information against the Azure Active Directory, and updates the resource for any changes. The throttling scenario updates the CosmosDB RUs to increase the throughput of the database.

## Reliability considerations

## Resiliency considerations

## Security considerations

## Deployment considerations


**Functions**. For the consumption plan, the HTTP trigger scales based on the traffic. There is a limit to the number of concurrent function instances, but each instance can process more than one request at a time. For an App Service plan, the HTTP trigger scales according to the number of VM instances, which can be a fixed value or can autoscale based on a set of autoscaling rules. For information, see [Azure Functions scale and hosting][functions-scale].

**Cosmos DB**. Throughput capacity for Cosmos DB is measured in [Request Units][ru] (RU). A 1-RU throughput corresponds to the throughput need to GET a 1KB document. In order to scale a Cosmos DB container past 10,000 RU, you must specify a [partition key][partition-key] when you create the container and include the partition key in every document that you create. For more information about partition keys, see [Partition and scale in Azure Cosmos DB][cosmosdb-scale].

**API Management**. API Management can scale out and supports rule-based autoscaling. Note that the scaling process takes at least 20 minutes. If your traffic is bursty, you should provision for the maximum burst traffic that you expect. However, autoscaling is useful for handling hourly or daily variations in traffic. For more information, see [Automatically scale an Azure API Management instance][apim-scale].

## Disaster recovery considerations

The deployment shown here resides in a single Azure region. For a more resilient approach to disaster-recovery, take advantage of the geo-distribution features in the various services:

- API Management supports multi-region deployment, which can be used to distribute a single API Management instance across any number of Azure regions. For more information, see [How to deploy an Azure API Management service instance to multiple Azure regions][api-geo].

- Use [Traffic Manager][tm] to route HTTP requests to the primary region. If the Function App running in that region becomes unavailable, Traffic Manager can fail over to a secondary region.

- Cosmos DB supports [multiple master regions][cosmosdb-geo], which enables writes to any region that you add to your Cosmos DB account. If you don't enable multi-master, you can still fail over the primary write region. The Cosmos DB client SDKs and the Azure Function bindings automatically handle the failover, so you don't need to update any application configuration settings.

## Security considerations

### Authentication

The `GetStatus` API in the reference implementation uses Azure AD to authenticate requests. Azure AD supports the OpenID Connect protocol, which is an authentication protocol built on top of the OAuth 2 protocol.

In this architecture, the client application is a single-page application (SPA) that runs in the browser. This type of client application cannot keep a client secret or an authorization code hidden, so the implicit grant flow is appropriate. (See [Which OAuth 2.0 flow should I use?][oauth-flow]). Here's the overall flow:

1. The user clicks the "Sign in" link in the web application.
1. The browser is redirected the Azure AD sign in page.
1. The user signs in.
1. Azure AD redirects back to the client application, including an access token in the URL fragment.
1. When the web application calls the API, it includes the access token in the Authentication header. The application ID is sent as the audience ('aud') claim in the access token.
1. The backend API validates the access token.

To configure authentication:

- Register an application in your Azure AD tenant. This generates an application ID, which the client includes with the login URL.

- Enable Azure AD authentication inside the Function App. For more information, see [Authentication and authorization in Azure App Service][app-service-auth].

- Add the [validate-jwt policy][apim-validate-jwt] to API Management to pre-authorize the request by validating the access token.

For more details, see the [GitHub readme][readme].

It's recommended to create separate app registrations in Azure AD for the client application and the backend API. Grant the client application permission to call the API. This approach gives you the flexibility to define multiple APIs and clients and control the permissions for each.

Within an API, use [scopes][scopes] to give applications fine-grained control over what permissions they request from a user. For example, an API might have `Read` and `Write` scopes, and a particular client app might ask the user to authorize `Read` permissions only.

### Authorization

In many applications, the backend API must check whether a user has permission to perform a given action. It's recommended to use [claims-based authorization][claims], where information about the user is conveyed by the identity provider (in this case, Azure AD) and used to make authorization decisions. For example, when you register an application in Azure AD, you can define a set of application roles. When a user signs into the application, Azure AD includes a `roles` claim for each role that the user has been granted, including roles that are inherited through group membership.

The ID token that Azure AD returns to the client contains some of the user's claims. Within the function app, these claims are available in the X-MS-CLIENT-PRINCIPAL header of the request. However, it's simpler to read this information from binding data. For other claims, use [Microsoft Graph][graph] to query Azure AD. (The user must consent to this action when signing in.)

For more information, see [Working with client identities](/azure/azure-functions/functions-bindings-http-webhook#working-with-client-identities).

### CORS

In this reference architecture, the web application and the API do not share the same origin. That means when the application calls the API, it is a cross-origin request. Browser security prevents a web page from making AJAX requests to another domain. This restriction is called the *same-origin policy* and prevents a malicious site from reading sensitive data from another site. To enable a cross-origin request, add a Cross-Origin Resource Sharing (CORS) [policy][cors-policy] to the API Management gateway:

```xml
<cors allow-credentials="true">
    <allowed-origins>
        <origin>[Website URL]</origin>
    </allowed-origins>
    <allowed-methods>
        <method>GET</method>
    </allowed-methods>
    <allowed-headers>
        <header>*</header>
    </allowed-headers>
</cors>
```

In this example, the **allow-credentials** attribute is **true**. This authorizes the browser to send credentials (including cookies) with the request. Otherwise, by default the browser does not send credentials with a cross-origin request.

> [!NOTE]
> Be very careful about setting **allow-credentials** to **true**, because it means a website can send the user's credentials to your API on the user's behalf, without the user being aware. You must trust the allowed origin.

### Enforce HTTPS

For maximum security, require HTTPS throughout the request pipeline:

- **CDN**. Azure CDN supports HTTPS on the `*.azureedge.net` subdomain by default. To enable HTTPS in the CDN for custom domain names, see [Tutorial: Configure HTTPS on an Azure CDN custom domain][cdn-https].

- **Static website hosting**. Enable the "[Secure transfer required][storage-https]" option on the Storage account. When this option is enabled, the storage account only allows requests from secure HTTPS connections.

- **API Management**. Configure the APIs to use HTTPS protocol only. You can configure this in the Azure portal or through a Resource Manager template:

    ```json
    {
        "apiVersion": "2018-01-01",
        "type": "apis",
        "name": "dronedeliveryapi",
        "dependsOn": [
            "[concat('Microsoft.ApiManagement/service/', variables('apiManagementServiceName'))]"
        ],
        "properties": {
            "displayName": "Drone Delivery API",
            "description": "Drone Delivery API",
            "path": "api",
            "protocols": [ "HTTPS" ]
        },
        ...
    }
    ```

- **Azure Functions**. Enable the "[HTTPS Only][functions-https]" setting.

### Lock down the function app

All calls to the function should go through the API gateway. You can achieve this as follows:

- Configure the function app to require a function key. The API Management gateway will include the function key when it calls the function app. This prevents clients from calling the function directly, bypassing the gateway.

- The API Management gateway has a [static IP address][apim-ip]. Restrict the Azure Function to allow only calls from that static IP address. For more information, see [Azure App Service Static IP Restrictions][app-service-ip-restrictions]. (This feature is available for Standard tier services only.)

### Protect application secrets

Don't store application secrets, such as database credentials, in your code or configuration files. Instead, use App settings, which are stored encrypted in Azure. For more information, see [Security in Azure App Service and Azure Functions][app-service-security].

Alternatively, you can store application secrets in Key Vault. This allows you to centralize the storage of secrets, control their distribution, and monitor how and when secrets are being accessed. For more information, see [Configure an Azure web application to read a secret from Key Vault][key-vault-web-app]. However, note that Functions triggers and bindings load their configuration settings from app settings. There is no built-in way to configure the triggers and bindings to use Key Vault secrets.

## DevOps considerations

### Deployment

To deploy the function app, we recommend using [package files][functions-run-from-package] ("Run from package"). Using this approach, you upload a zip file to a Blob Storage container and the Functions runtime mounts the zip file as a read-only file system. This is an atomic operation, which reduces the chance that a failed deployment will leave the application in an inconsistent state. It can also improve cold start times, especially for Node.js apps, because all of the files are swapped at once.

### API versioning

An API is a contract between a service and clients. In this architecture, the API contract is defined at the API Management layer. API Management supports two distinct but complementary [versioning concepts][apim-versioning]:

- *Versions* allow API consumers to choose an API version based on their needs, such as v1 versus v2.

- *Revisions* allow API administrators to make non-breaking changes in an API and deploy those changes, along with a change log to inform API consumers about the changes.

If you make a breaking change in an API, publish a new version in API Management. Deploy the new version side-by-side with the original version, in a separate Function App. This lets you migrate existing clients to the new API without breaking client applications. Eventually, you can deprecate the previous version. API Management supports several [versioning schemes][apim-versioning-schemes]: URL path, HTTP header, or query string. For more information about API versioning in general, see [Versioning a RESTful web API][api-versioning].

For updates that are not breaking API changes, deploy the new version to a staging slot in the same Function App. Verify the deployment succeeded and then swap the staged version with the production version. Publish a revision in API Management.

## Deploy the solution

To deploy the reference implementation for this architecture, see the [GitHub readme][readme].

## Next steps

To learn more about the reference implementation, read [Code walkthrough: Serverless application with Azure Functions](../../serverless/code.md).
