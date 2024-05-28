This article provides guidance on implementing the Reliable Web App pattern. This pattern outlines how to modify (replatform) web apps for cloud migration. It offers prescriptive architecture, code, and configuration guidance aligned with the principles of the [Well-Architected Framework](/azure/well-architected/) (WAF).

*Why the Reliable Web App pattern?* The Reliable Web App pattern helps optimize monolithic web apps for the cloud. It focuses on high-value updates and minimal code changes to enhance reliability, security, performance, and operational excellence.

*How to implement the Reliable Web App pattern* This article includes architecture, code, and configuration guidance to implement the Reliable Web App pattern. Use the following links to navigate to the specific guidance you need:

- [***Architecture guidance***](#architecture-guidance): Learn how to select the right cloud services and design an architecture that meets your business requirements.
- [***Code guidance***](#code-guidance): Implement three design patterns to improve the reliability and performance efficiency of your web app in the cloud.
- [***Configuration guidance***](#configuration-guidance): Configure authentication and authorization, managed identities, rightsized environments, infrastructure as code, and monitoring.

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) There's [***reference implementation***](reference-implementation) of the Reliable Web App pattern. It represents the end-state of the Reliable Web App implementation. It features all the code, architecture, and configuration updates discussed in this article. Deploy and use the reference implementation to guide your implementation of the Reliable Web App pattern.

:::row:::
    :::column:::
        **Benefits**\
        • Cloud-optimized web app\
        • High-value updates\
        • Minimal code changes
    :::column-end:::
    :::column:::
        **Architecture updates**\
        • PaaS solutions\
        • Secure ingress\
        • Network topology\
        • Infrastructure reliability\
        • Private endpoints
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Code updates**\
        • Retry pattern\
        • Circuit-breaker pattern\
        • Cache-aside pattern
    :::column-end:::
    :::column:::
        **Configuration updates**\
        • User authentication and authorization\
        • Managed identities\
        • Rightsized environments\
        • Infrastructure as code\
        • Monitoring
    :::column-end:::
:::row-end:::
---