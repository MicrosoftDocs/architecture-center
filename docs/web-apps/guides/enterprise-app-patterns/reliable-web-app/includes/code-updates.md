Update your web app code with the Retry pattern, Circuit-Breaker pattern, and Cache-Aside design patterns. Each design pattern provides workload design benefits that align with one of more pillars of the Well-Architected Framework.

|Design pattern|Reliability|Security|Cost Optimization|Operational Excellence|Performance Efficiency|
|---|---|---|---|---|---|
| [Retry pattern](#implement-the-retry-pattern) |✔| | | | |
| [Circuit-Breaker pattern](#implement-the-cicuit-breaker-pattern) |✔| | | |✔|
| [Retry pattern](#implement-the-cache-aside-pattern) |✔| | | |✔|

The Retry pattern and Circuit-Breaker pattern applies to all requests from the web app to Azure services. The Cache-Aside pattern applies to requests to the database. To update your code with these design patterns, follow this guidance:

[![Diagram showing the role of design patterns in the Reliable Web App pattern architecture.](../../../_images/rwa-design-patterns.svg)](../../../_images/rwa-design-patterns.svg#lightbox)
*Figure 3. The role of the design patterns in the web app architecture.*