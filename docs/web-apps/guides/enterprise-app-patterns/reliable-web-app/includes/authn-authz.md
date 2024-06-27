:::row:::
    :::column:::
        *Well-Architected Framework alignment - Security ([SE:05](/azure/well-architected/security/identity-access)), Operational Excellence ([OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization))*
    :::column-end:::
:::row-end:::
---

When migrating web applications to Azure, configure user authentication and authorization mechanisms. Follow these recommendations:

- *Use an identity platform.* Use the [Microsoft Identity platform](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). This platform supports both single-tenant and multi-tenant applications, allowing users to sign in with their Microsoft identities or social accounts.