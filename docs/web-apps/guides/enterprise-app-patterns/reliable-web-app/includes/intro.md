This article shows you how to implement the Reliable Web App pattern. The Reliable Web App pattern defines how you should modify web apps (replatform) when migrating to the cloud. It aligns with the principles of the [Well-Architected Framework](/azure/well-architected/) (WAF), and the pattern focuses on the high-vaue updates to ensure your web app is successful in the cloud.

[![Diagram showing the baseline architecture of the Reliable Web App pattern.](../../../_images/rwa-architecture.svg)](../../../_images/rwa-architecture.svg)
*Figure 1. Baseline architecture of the Reliable Web App pattern.*

The Reliable Web App pattern is for architects and developers migrating web apps to the cloud. The pattern  platform-as-a-service (PaaS) enhanced security and reduced data latency with minimal code changes. The Reliable Web App pattern has you update your web app code with three design patterns that improve reliability and performance efficiency.

| Benefits | Architecture updates | Code updates<br>(design patterns) | Configuration updates |
|----------|--------------|--------------|---------------|
| Cloud-optimized web app <br> High-value updates <br>Minimal code changes | PaaS solutions<br>Secure ingress<br>Network topology<br>Infrastructure reliability<br>Private endpoints | Retry pattern<br>Circuit-breaker pattern<br>Cache-aside pattern | <br>User authentication and authorization<br>Managed identities <br>Rightsized environments <br>Infrastructure as code <br> Monitoring|