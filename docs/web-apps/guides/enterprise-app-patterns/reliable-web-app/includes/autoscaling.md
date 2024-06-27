:::row:::
    :::column:::
        *Well-Architected Framework alignment - Reliability ([RE:06](/azure/well-architected/reliability/scaling)), Cost Optimization ([CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs)), Performance Efficiency ([PE:05](/azure/well-architected/performance-efficiency/scale-partition))*
    :::column-end:::
:::row-end:::
---

Autoscaling ensures web app remain resilient, responsive, and capable of handling dynamic workloads efficiently. To implement autoscaling, follow these recommendations:

- *Automate scale-out.* Use [Azure autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Configure autoscaling rules to scale out based on key performance metrics, so your application can handle varying loads.

- *Refine scaling triggers.* Begin with CPU utilization as your initial scaling trigger if you are unfamiliar with your application’s scaling requirements. Refine your scaling triggers to include other metrics such as RAM, network throughput, and disk I/O to better match your web application's behavior and ensure optimal performance.

- *Provide a scale out buffer.* Set your scaling thresholds to trigger before reaching maximum capacity. For example, configure scaling to occur at 85% CPU utilization rather than waiting until it reaches 100%. This proactive approach helps maintain performance and avoid potential bottlenecks.