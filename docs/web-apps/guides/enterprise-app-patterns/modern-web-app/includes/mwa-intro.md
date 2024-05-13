This article shows you how to implement the Modern Web App pattern. The Modern Web App pattern defines how you should modernize web apps in the cloud. It aligns with the principles of the [Well-Architected Framework](/azure/well-architected/) and builds on the [Reliable Web App pattern](../../overview.md#reliable-web-app-pattern). The Modern Web App pattern focuses on the essential changes you need to make to handle increased demand in the most cost efficient way. These changes include three design patterns and other key updates to your web app.

:::row:::
    :::column:::
        **Objectives**<br>
        Handle increased demand
        Cost-optimized scaling
    :::column-end:::

    :::column:::
      **Design patterns**<br>
        Strangler Fig\
        Queue-Based Load Leveling\
        Competing Consumers\
        Health Endpoint Monitoring
    :::column-end:::

    :::column:::
      **Key updates**<br>
        Decouple components\
        Containerization\
        Asynchronous communication\
        Autoscale independent services\
        Data autonomy
    :::column-end:::
:::row-end:::

The first step is to review the [Reliable Web App pattern](../../overview.md#reliable-web-app-pattern) and apply the guidance. Next, choose the right services that meet the needs of your web app and design your architecture. Finally, update your web app code and configurations in line with the pillars of the Well-Architected Framework.
