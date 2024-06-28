:::row:::
    :::column:::
        *Well-Architected Framework benefit: Reliability ([RE:03](/azure/well-architected/reliability/failure-mode-analysis), [RE:07](/azure/well-architected/reliability/handle-transient-faults)), Performance Efficiency ([PE:07](/azure/well-architected/performance-efficiency/optimize-code-infrastructure), [PE:11](/azure/well-architected/performance-efficiency/respond-live-performance-issues))*
    :::column-end:::
:::row-end:::

Use the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) to handle service disruptions that aren't transient faults. The Circuit Breaker pattern prevents an application from continuously attempting to access a nonresponsive service. It releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users.