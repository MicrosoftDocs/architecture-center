### Web applications guides

The following articles help you evaluate and select the best web app technologies for your workload requirements.

#### Networking guidance for web apps

- [Improved-security access to Azure App Service web apps from an on-premises network](/azure/architecture/web-apps/guides/networking/access-multitenant-web-app-from-on-premises): An architecture for setting up private connectivity to Azure App Service from on-premises networks by using Azure Private Link, virtual network integration, and private endpoints.

##### Global routing redundancy for highly available web applications

- [Overview](/azure/architecture/guide/networking/global-web-applications/overview): Learn how to develop highly resilient global web applications.
- [Content delivery](/azure/architecture/guide/networking/global-web-applications/mission-critical-content-delivery): Learn how to develop highly resilient global HTTP applications when your focus is on content delivery and caching.
- [Global HTTP ingress](/azure/architecture/guide/networking/global-web-applications/mission-critical-global-http-ingress): Learn how to develop highly resilient global HTTP applications when your focus is on HTTP ingress.

#### Security guidance for web apps

- [Use Azure API Management to protect access tokens in single-page applications](/azure/architecture/web-apps/guides/security/secure-single-page-application-authorization): An architecture that uses Azure API Management to implement a stateless Backends for Frontends pattern that protects OAuth2 access tokens from cross-site scripting attacks.

#### Disaster recovery for web apps

- [Multiple-region Azure App Service app approaches for disaster recovery (DR)](/azure/architecture/web-apps/guides/multi-region-app-service/multi-region-app-service): Approaches for deploying multiple-region Azure App Service architectures, including active-active, active-passive, and passive-cold configurations.

### Web app architectures

The following production-ready architectures demonstrate end-to-end web app solutions that you can deploy and customize.

#### Host web apps with App Service

- [Basic web app](/azure/architecture/web-apps/app-service/architectures/basic-web-app): An introductory architecture for learning how to run web apps on Azure App Service in a single region.

- [Baseline highly available zone-redundant web app](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant): A secure, zone-redundant, and highly available web app that uses Azure Application Gateway, Azure Web Application Firewall, and Azure App Service with Azure Private Link.

#### Host web apps with App Service Environment

- [Enterprise deployment that uses App Service Environment](/azure/architecture/web-apps/app-service-environment/architectures/app-service-environment-standard-deployment): A standard enterprise workload that uses App Service Environment v3 with enhanced security, including Azure Application Gateway and Azure Firewall.

- [High availability (HA) enterprise deployment that uses App Service Environment](/azure/architecture/web-apps/app-service-environment/architectures/app-service-environment-high-availability-deployment): A zone-redundant App Service Environment deployment that improves resiliency by distributing resources across availability zones.

- [Securely managed web apps](/azure/architecture/example-scenario/apps/fully-managed-secure-apps): A secure App Service Environment deployment with Azure Application Gateway and Azure Web Application Firewall, integrated with Azure DevOps for continuous integration and continuous deployment (CI/CD).

#### Manage APIs with Azure API Management

- [Protect APIs by using Azure Application Gateway and Azure API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis): An architecture that uses Azure Application Gateway and Azure API Management to protect API access with Azure Web Application Firewall and URL-based routing.

- [Migrate a web app by using Azure API Management](/azure/architecture/example-scenario/apps/apim-api-scenario): A migration scenario that uses Azure API Management as a facade for both legacy on-premises services and new Azure-hosted APIs.

### Web applications solution ideas

The following web app solution idea demonstrates implementation patterns and possibilities to explore:

- [Highly available SharePoint farm](/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm): A highly available deployment of SharePoint that uses load-balanced Microsoft Entra ID, SQL Server Always On availability groups, and highly available SharePoint resources.

