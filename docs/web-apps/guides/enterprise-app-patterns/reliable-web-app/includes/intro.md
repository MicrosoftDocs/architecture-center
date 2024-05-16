This article shows you how to implement the Reliable Web App pattern. The Reliable Web App pattern defines how you should modify web apps (replatform) when migrating to the cloud. It aligns with the principles of the [Well-Architected Framework](/azure/well-architected/). The Reliable Web App pattern focuses on the high-vaue updates you need to make to your web app to be successful in the cloud. The pattern introduces enhanced security and reduced data latency with minimal code changes. The Reliable Web App pattern has you update your web app code with three design patterns that improve reliability and performance efficiency.

| **Benefits** | **Key updates** | **Design patterns** |
|--------------|-----------------|---------------------|
| High-value updates<br>Cloud-optimized web app<br>Enhanced security<br>Minimal code changes | Identity-centric security<br>Secure network perimeter<br>Role-based access control<br>Managed identities<br>Private endpoints<br>Infrastructure as code<br>Rightsized environments<br>PaaS solutions | Retry<br>Circuit-breaker<br>Cache-aside |

[![Diagram showing the conceptual architecture of the Reliable Web App pattern.](../../../_images/rwa-architecture.svg)](../../../_images/rwa-architecture.svg)
*Figure 1. A conceptual architecture of the Reliable Web App pattern.*

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) This article is backed by a [reference implementation](https://aka.ms/eap/rwa/dotnet) of the Reliable Web App pattern, which features a production grade web app on Azure. Use the reference implementation to assist your application of the Reliable Web App pattern. The reference implementation simulates the migration efforts of a fictional company, Relecloud. The reference implementation is a production-grade web app that allows customers to buy concert tickets online.