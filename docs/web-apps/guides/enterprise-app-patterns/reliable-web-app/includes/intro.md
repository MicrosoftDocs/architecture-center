This article provides guidance on implementing the Reliable Web App pattern. This pattern outlines how to modify (replatform) web apps for cloud migration. It offers prescriptive architecture, code, and configuration guidance aligned with the principles of the [Well-Architected Framework](/azure/well-architected/) (WAF).

*Why the Reliable Web App pattern?* The Reliable Web App pattern helps optimize monolithic web apps for the cloud. It focuses on high-value updates and minimal code changes to enhance reliability, security, performance, and operational excellence.

*How to implement the Reliable Web App pattern* This article includes architecture, code, and configuration guidance to implement the Reliable Web App pattern. Use the following links to navigate to the specific guidance you need:

- [***Architecture guidance***](#architecture-guidance): Learn how to select the right cloud services and design an architecture that meets your business requirements.
- [***Code guidance***](#code-guidance): Implement three design patterns to improve the reliability and performance efficiency of your web app in the cloud.
- [***Configuration guidance***](#configuration-guidance): Configure authentication and authorization, managed identities, rightsized environments, infrastructure as code, and monitoring.

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) There's [***reference implementation***](reference-implementation) of the Reliable Web App pattern. It represents the end-state of the Reliable Web App implementation. It features all the code, architecture, and configuration updates discussed in this article. Deploy and use the reference implementation to guide your implementation of the Reliable Web App pattern.

| Benefits | Architecture updates | Code updates<br>(design patterns) | Configuration updates |
|----------|--------------|--------------|---------------|
| • Cloud-optimized web app <br> • High-value updates <br>• Minimal code changes | • PaaS solutions<br>• Secure ingress<br>• Network topology<br>• Infrastructure reliability<br>• Private endpoints | • Retry pattern<br>• Circuit-breaker pattern<br>• Cache-aside pattern | • User authentication and authorization<br>• Managed identities <br>• Rightsized environments <br>• Infrastructure as code <br>• Monitoring|