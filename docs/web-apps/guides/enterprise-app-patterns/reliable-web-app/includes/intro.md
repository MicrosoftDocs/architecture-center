This article shows you how to implement the Reliable Web App pattern. The Reliable Web App pattern defines how you should modify web apps (replatform) when migrating to the cloud. The Reliable Web App pattern provides prescriptive architecture, code, and configuration guidance that aligns with the principles of the [Well-Architected Framework](/azure/well-architected/) (WAF).

| Benefits | Architecture updates | Code updates<br>(design patterns) | Configuration updates |
|----------|--------------|--------------|---------------|
| Cloud-optimized web app <br> High-value updates <br>Minimal code changes | PaaS solutions<br>Secure ingress<br>Network topology<br>Infrastructure reliability<br>Private endpoints | Retry pattern<br>Circuit-breaker pattern<br>Cache-aside pattern | <br>User authentication and authorization<br>Managed identities <br>Rightsized environments <br>Infrastructure as code <br> Monitoring|

*Why the Reliable Web App pattern?* The Reliable Web App pattern shows you how optimize monolithic web apps for the cloud. It focuses on the high-value updates you need to make and minimal code changes to improve reliability, security, performance, and operational excellence.

*How to implement the Reliable Web App pattern*

This article contains architecture, code, and configuration guidance to implement the Modern Web App pattern. Use the following links to navigate to the guidance you need: 

- [***Architecture guidance***](#architecture-guidance): The architecture guidance shows you how to select the right cloud services and design an architecture that meets your business requirements.

- [***Code guidance***](#code-guidance): The code guidance shows you how to implement three design patterns that improve the reliability and performance efficiency of your web app in the cloud.

- [***Configuration guidance***](#configuration-guidance): The configuration guidance shows you how to configure authentication and authorization, managed identities, rightsized environments, infrastructure as code, and monitoring.

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) There's [***reference implementation***](reference-implementation) of the Reliable Web App pattern. It represents the end-state of the Reliable Web App implementation. It features all the code, architecture, and configuration updates discussed in this article. Deploy and use the reference implementation to guide your implementation of the Reliable Web App pattern.