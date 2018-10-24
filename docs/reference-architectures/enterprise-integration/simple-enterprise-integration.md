---
title: Simple enterprise integration architecture pattern - Azure Integration Services
description: This architecture reference shows how you can implement a simple enterprise integration pattern by using Azure Logic Apps and Azure API Management
services: logic-apps
author: mattfarm
ms.author: mattfarm
ms.reviewer: jonfan, estfan, LADocs
ms.topic: article
ms.date: 06/15/2018
---

# Simple enterprise integration

This reference architecture uses [Azure Integration Services][integration-services] to orchestrate calls to enterprise backend systems. The backend systems may include software as a service (SaaS) systems, Azure services, and existing web services in your enterprise.

Azure Integration Services is a collection of services for integrating applications and data. This architecture uses two of those services: [Logic Apps][logic-apps] to orchestrate workflows, and [API Management][apim] to create catalogs of APIs.

![Architecture diagram - Simple enterprise integration](./_images/simple-enterprise-integration.png)

## Architecture

The architecture has the following components:

- **Backend systems**. On the right-hand side of the diagram are the various backend systems that the enterprise has deployed or relies on. These might include SaaS systems, other Azure services, or web services that expose REST or SOAP endpoints.

- **Azure Logic Apps**. [Logic Apps][logic-apps] is a serverless platform for building enterprise workflows that integrate applications, data, and services. In this architecture, the logic apps are triggered by HTTP requests. You can also nest workflows for more complex orchestration. Logic Apps uses [connectors](/azure/connectors/apis-list) to integrate with commonly used services. Logic Apps offers hundreds of connectors, and you can create custom connectors.

- **Azure API Management**. [API Management][apim] is a managed service for publishing catalogs of HTTP APIs, to promote re-use and discoverability. API Management consists of two related components:

    - **API gateway**. The API gateway accepts HTTP calls and routes them to the backend. 

    - **Developer portal**. Each instance of Azure API Management provides access to a [developer portal](/azure/api-management/api-management-key-concepts#a-namedeveloper-portal-a-developer-portal). This portal gives your developers access to documentation and code samples for calling the APIs. You can also test APIs in the developer portal.

    In this architecture, composite APIs are built by [importing logic apps][apim-logic-app] as APIs. You can also import existing web services by [importing OpenAPI][apim-openapi] (Swagger) specifications or [importing SOAP APIs][apim-soap] from WSDL specifications. 

    The API gateway helps to decouple front-end clients from the back end. For example, it can rewrite URLs, or transform requests before they reach the backend. It also handles many cross-cutting concerns such as authentication, cross-origin resource sharing (CORS) support, and response caching.

- **Azure DNS**. [Azure DNS](/azure/dns/) is a hosting service for DNS domains. Azure DNS provides name resolution by using the Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records by using the same credentials, APIs, tools, and billing that you use for your other Azure services. To use a custom domain name, such as contoso.com, create DNS records that map the custom domain name to the IP address. For more information, see [Configure a custom domain name in API Management](/azure/api-management/configure-custom-domain).

- **Azure Active Directory (Azure AD)**. Use [Azure AD](/azure/active-directory/) to authenticate clients that call the API gateway. Azure AD supports the OpenID Connect (OIDC) protocol. Clients obtain an access token from Azure AD, and API Gateway [validates the token][apim-jwt] to authorize the request. In addition, Azure AD can secure access to the API Management developer portal (requires Standard or Premium tier of API Management). 

## Recommendations

Your specific requirements might differ from the generic architecture that's described by this article. Use the recommendations in this section as a starting point.

### Azure API Management tier

Use the API Management Basic, Standard, or Premium tiers. These tiers offer a production service level agreement (SLA) and support scaleout within the Azure region. The number of units varies by tier. The Premium tier also supports scaleout across multiple Azure regions. Choose your tier based on your feature set and the level of required throughput. For more information, see 
[API Management pricing](https://azure.microsoft.com/pricing/details/api-management/).

You are charged for all API Management instances when they are running. If you have scaled up and don't need that level of performance all the time, consider taking advantage of the API Management hourly billing and scale down.

### Logic Apps pricing

Logic Apps uses a [serverless](/azure/logic-apps/logic-apps-serverless-overview) model. Billing is calculated based on action and connector execution. For more information, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/). Currently, there are no tier considerations for Logic Apps.

### Logic Apps for asynchronous API calls

Logic Apps works best in scenarios that don't require low latency. For example, Logic Apps works best for asynchronous or semi long-running API calls. If low latency is required, for example, a call that blocks a user interface, implement your API or operation by using a different technology. For example, use Azure Functions or a Web API that you deploy by using Azure App Service. Use API Management to front the API to your API consumers.

### Region

To minimize network latency, choose the same region for API Management, Logic Apps, and Service Bus. In general, choose the region that's closest to your users.

The resource group also has a region. This region specifies where to store deployment metadata and where to execute the deployment template. To improve availability during deployment, put the resource group and resources in the same region.

## Scalability considerations

To increase the scalability when administering an API Management service, add [caching policies](/azure/api-management/api-management-howto-cache) where appropriate. Caching also helps reduce the load on back-end services.

To offer greater capacity, you can scale out Azure API Management Basic, Standard, and Premium tiers in an Azure region. To analyze the usage for your service, on the **Metrics** menu, select the **Capacity Metric** option and then scale up or scale down as appropriate.

Recommendations for scaling an API Management service:

- Consider traffic patterns when scaling. Customers with more volatile traffic patterns need more capacity.

- Consistent capacity that's greater than 66% might indicate a need to scale up.

- Consistent capacity that's under 20% might indicate an opportunity to scale down.

- Before you enable the load in production, always load-test your API Management service with a representative load.

You can scale out Premium tier services across multiple Azure regions. If you deploy by scaling services across multiple Azure regions, you can gain a higher SLA (99.95% versus 99.9%) and provision services near users in multiple regions.

The Logic Apps serverless model means administrators don't have to plan for service scalability. The service automatically scales to meet demand.

## Availability considerations

* For Basic, Standard, and Premium tiers, the service level agreement (SLA) for Azure API Management is currently 99.9%. For premium tier configurations with a deployment that has least one unit in two or more regions, the SLA is 99.95%.

* The SLA for Azure Logic Apps is currently 99.9%.

### Backups

Based on regularity of change, [regularly back up](/azure/api-management/api-management-howto-disaster-recovery-backup-restore) your Azure API Management configuration. Store your backup files in a location or Azure region that differs from where your service resides. You can then choose either 
option as your disaster recovery strategy:

* In a disaster recovery event, provision a new API Management instance, restore the backup to the new instance, and repoint the DNS records.

* Keep a passive copy of your service in another Azure region, which incurs additional cost. Regularly restore backups to that copy. To restore the service during a disaster recovery event, you need only repoint the DNS records.

Because you can quickly recreate logic apps, which are serverless, back them up by saving a copy of the associated Azure Resource Manager template. You can save templates in source control, and you can integrate templates with your continuous integration/continuous deployment (CI/CD) process.

If you published a logic app through Azure API Management, and that logic app moves to a different datacenter, update the app's location. You can update your API's 
**Backend** property by using a basic PowerShell script.

## Manageability considerations

Create separate resource groups for production, development, and test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights.

When you assign resources to resource groups, consider these factors:

* **Lifecycle**. In general, put resources that have the same lifecycle in the same resource group.

* **Access**. To apply access policies to the resources in a group, you can use [role-based access control (RBAC)](/azure/role-based-access-control/overview).

* **Billing**. You can view rollup costs for the resource group.

* **Pricing tier for API Management**. Use the Developer tier for your development and test environments. To minimize costs during preproduction, deploy a replica of your production environment, run your tests, and then shut down.

For more information, see [Azure Resource Manager overview](/azure/azure-resource-manager/resource-group-overviewd).

## Deployment considerations

* To deploy API Management and Logic Apps, use the [Azure Resource Manager templates](/azure/azure-resource-manager/resource-group-authoring-templates). Templates make automating deployments easier by using PowerShell or the Azure CLI.

* Put API Management and any individual logic apps in their own separate Resource Manager templates. By using separate templates, you can store the resources in source control systems. You can then deploy these templates together or individually as part of a continuous integration/continuous deployment (CI/CD) process.

### Versions

Each time you change a logic app's configuration or deploy an update through a Resource Manager template, Azure keeps a copy of that version for your convenience 
and keeps all versions that have a run history. You can use these versions for tracking historical changes or promoting a version as the logic app's current configuration. For example, you can effectively roll back a logic app.

Azure API Management has these distinct but complementary [versioning concepts](/azure/api-management/api-management-get-started-publish-versions):

* Versions that provide your API consumers the capability to choose an API version based on their needs, for example, v1, v2, beta, or production.

* Revisions that let API administrators to safely make changes in an API and then deploy those changes to users with optional commentary.

For deployment, consider API Management revisions as a way to safely make changes, keep a change history, and communicate those changes to your API's consumers. You can make a revision in a development environment and deploy that change in other environments by using Resource Manager templates.

Although you can use revisions for testing an API before you make those changes "current" and accessible to users, this method isn't recommended for load or integration testing. Instead, use separate test or preproduction environments.

### Configuration and sensitive information

Never check passwords, access keys, or connection strings into source control. If these values are required, secure and deploy these values by using the appropriate techniques. 

In Logic Apps, if a logic app requires any sensitive values that you can't create within a connection, store those values in Azure Key Vault and reference 
them from a Resource Manager template. Use deployment template parameters and parameter files for each environment. For more information, see [Secure parameters and inputs within a workflow](/azure/logic-apps/logic-apps-securing-a-logic-app#secure-parameters-and-inputs-within-a-workflow).

API Management manages secrets by using objects called *named values* or *properties*. These objects securely store values that you can access through API Management policies. For more information, see [How to use Named Values in Azure API Management policies](/azure/api-management/api-management-howto-properties).

## Diagnostics and monitoring

You can use [Azure Monitor](/azure/azure-monitor/overview) for operational monitoring in both [API Management](/azure/api-management/api-management-howto-use-azure-monitor) and [Logic Apps](/azure/logic-apps/logic-apps-monitor-your-logic-apps). Azure Monitor provides information based on the metrics configured for each service and is enabled by default.

Each service also has these options:

* For deeper analysis and dashboarding, you can send Logic Apps logs to [Azure Log Analytics](/azure/logic-apps/logic-apps-monitor-your-logic-apps-oms).

* For DevOps monitoring, you can configure Azure Application Insights for API anagement.

* API Management supports the [Power BI solution template for custom API analytics](http://aka.ms/apimpbi). You can use this solution template for creating your own analytics solution. For business users, Power BI makes reports available.

## Security considerations

Although this list doesn't completely describe all security best practices, here are some security considerations that apply specifically to the Azure services deployed in the architecture that's described by this article:

* To make sure users have appropriate access levels, use role-based access control (RBAC).

* Secure public API endpoints in API Management by using OAuth or OpenID Connect. To secure public API endpoints, configure an identity provider, and add a JSON Web Token (JWT) validation policy.

* Connect to back-end services from API Management by using mutual certificates.

* Secure HTTP trigger-based logic apps by creating an IP address whitelist that points to the API Management IP address. A whitelisted IP address prevents calling the logic app from the public internet without first going through API Management.

## Next steps

* Learn about [enterprise integration with queues and events](/azure/logic-apps/logic-apps-architectures-enterprise-integration-with-queues-event)


<!-- links -->

[apim]: /azure/api-management
[apim-jwt]: /azure/api-management/policies/authorize-request-based-on-jwt-claims
[apim-logic-app]: /azure/api-management/import-logic-app-as-api
[apim-openapi]: /azure/api-management/import-api-from-oas
[apim-soap]: /azure/api-management/import-soap-api
[integration-services]: https://azure.microsoft.com/product-categories/integration/
[logic-apps]: /azure/logic-apps/logic-apps-overview
