This article shows you how to implement the Reliable Web App pattern. The Reliable Web App pattern defines how you should modify web apps (replatform) when migrating to the cloud. It aligns with the principles of the [Well-Architected Framework](/azure/well-architected/). The Reliable Web App pattern focuses on the high-vaue updates to ensure your web app is successful in the cloud.

[![Diagram showing the conceptual architecture of the Reliable Web App pattern.](../../../_images/rwa-architecture.svg)](../../../_images/rwa-architecture.svg)
*Figure 1. A conceptual architecture of the Reliable Web App pattern.*

The Reliable Web App pattern recommends platform-as-a-service (PaaS) enhanced security and reduced data latency with minimal code changes. The Reliable Web App pattern has you update your web app code with three design patterns that improve reliability and performance efficiency.

| Benefits | Code updates<br>(design patterns) | Architecture updates | Configuration updates |
|----------|--------------|--------------|---------------|
| Cloud-optimized web app <br> High-value updates <br>Minimal code changes | Retry pattern<br>Circuit-breaker pattern<br>Cache-aside pattern | PaaS solutions<br>Secure ingress<br>Network topology<br>Infrastructure reliability<br>Private endpoints | <br>User authentication and authorization<br>Managed identities <br>>Rightsized environments <br>Infrastructure as code <br> Monitoring|

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) This article is backed by a [reference implementation](https://aka.ms/eap/rwa/dotnet) of the Reliable Web App pattern, which features a production grade web app on Azure. Use the reference implementation to assist your application of the Reliable Web App pattern. The reference implementation simulates the migration efforts of a fictional company, Relecloud. The reference implementation is a production-grade web app that allows customers to buy concert tickets online.