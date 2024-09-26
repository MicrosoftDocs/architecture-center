The following sections provide guidance on implementing the configurations updates. Each section aligns with one or more pillars of the Well-Architected Framework.

|Configuration|Reliability (RE) |Security (SE) |Cost Optimization (CO) |Operational Excellence (OE)|Performance Efficiency (PE) | Supporting WAF principles |
|---|---|---|---|---|---| --- |
|[Configure user authentication & authorization](#configure-user-authentication-and-authorization)||✔||✔|| [SE:05](/azure/well-architected/security/identity-access) <br> [OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization) |
|[Implement managed identities](#implement-managed-identities)||✔||✔|| [SE:05](/azure/well-architected/security/identity-access) <br> [OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization) |
|[Right size environments](#right-size-environments)|||✔||| [CO:05](/azure/well-architected/cost-optimization/get-best-rates) <br> [CO:06](/azure/well-architected/cost-optimization/align-usage-to-billing-increments) |
|[Implement autoscaling](#implement-autoscaling)|✔||✔||✔| [RE:06](/azure/well-architected/reliability/scaling) <br> [CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) |
|[Automate resource deployment](#automate-resource-deployment)||||✔|| [OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design)|
|[Implement monitoring](#implement-monitoring)|||✔|✔|✔| [OE:07](/azure/well-architected/operational-excellence/observability) <br> [PE:04](/azure/well-architected/performance-efficiency/collect-performance-data)|