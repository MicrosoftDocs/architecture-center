This article shows you how to implement the Modern Web App pattern. The Modern Web App pattern defines how you should modernize web apps in the cloud. It aligns with the principles of the [Well-Architected Framework](/azure/well-architected/) and builds on the [Reliable Web App pattern](../../overview.md#reliable-web-app-pattern). The Modern Web App pattern focuses on the essential changes you need to make to handle increased demand in the most cost efficient way. These changes include three design patterns and other key updates to your web app.

| Objectives | Design patterns | Key updates |
|---|---|---|
| Handle increased demand <br>Cost-optimized scaling | Strangler Fig <br>Queue-Based Load Leveling <br>Competing Consumers <br>Health Endpoint Monitoring |Decouple components <br>Containerization <br>Asynchronous communication <br>Autoscale independent services <br> Data autonomy |

The first step is to review the [Reliable Web App pattern](../../overview.md#reliable-web-app-pattern) and apply the guidance. Next, choose the right services that meet the needs of your web app and design your architecture. Finally, update your web app code and configurations in line with the pillars of the Well-Architected Framework.
