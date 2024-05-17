## Choose Azure services

Use platform-as-a-service (PaaS) solutions to achieve cost optimization and operational efficiency by reducing infrastructure management overhead while benefiting from built-in, cloud-optimized features that enhance reliability, security, and performance. To streamline the migration, choose services that support your current web app requirements, such as services that support the same runtime, database engine, data types, and redundancy requirements.

- *Application platform*: Start with Azure App Service as the default and use the [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree) to validate your choice.
- *Database*: Keep the same database engine, and use the [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree) to guide your decision.
- *Load balancer*: Web applications using PaaS solutions should use Azure Front Door (multiple regions), Application Gateway (single region), or both (SSL offloading or app-layer processing per request). Use the [load balancer decision tree](/azure/architecture/guide/technology-choices/load-balancing-overview#decision-tree-for-load-balancing-in-azure) to pick the right load balancer(s).
- *Storage*: Review the Azure [storage options](/azure/architecture/guide/technology-choices/storage-options) to pick the right storage solution based on your requirements.
- *Identity and access management*: Use [Microsoft Entra ID](/entra/identity/enterprise-apps/migration-resources) for all identity and access management needs.
- *Application performance monitoring*: Use [Application Insights](/azure/azure-monitor/app/app-insights-overview).
- *Cache*: Use [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview).
- *Secrets manager*: Use [Azure Key Vault](/azure/key-vault/general/overview).
- *Web application firewall*: Use [Azure Web Application Firewall](/azure/web-application-firewall/overview).
- *Configuration storage*: Use [Azure App Configuration](/azure/azure-app-configuration/overview).
- *Endpoint security*: Use [Azure Private Link](/azure/private-link/private-link-overview).
- *Network firewall*: Use [Azure Firewall](/azure/firewall/overview).
- *Bastion host*: Use [Azure Bastion](/azure/bastion/bastion-overview).