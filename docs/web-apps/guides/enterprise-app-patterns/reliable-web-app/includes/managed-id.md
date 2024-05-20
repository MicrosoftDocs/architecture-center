:::row:::
    :::column:::
        ***WAF alignment - Security ([SE:05](/azure/well-architected/security/identity-access)), Operational Excellence ([OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization))***
    :::column-end:::
:::row-end:::
---

Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) to automate the creation and management of Azure services ([workload identities](/entra/workload-id/workload-identities-overview)). A managed identity allows Azure services to access other Azure services like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments. Hybrid and legacy systems can keep on-premises authentication solutions to simplify the migration but should transition to managed identities as soon as possible.