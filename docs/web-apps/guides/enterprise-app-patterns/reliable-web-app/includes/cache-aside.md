:::row:::
    :::column:::
        *Well-Architected Framework benefit: Reliability ([RE:05](/azure/well-architected/reliability/redundancy)), Performance Efficiency ([PE:08](/azure/well-architected/performance-efficiency/optimize-data-performance), [PE:12](/azure/well-architected/performance-efficiency/continuous-performance-optimize))*
    :::column-end:::
:::row-end:::

Add [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) to your web app to improve in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. It shortens response times, enhances throughput, and reduces the need for more scaling. It also reduce the load on the primary datastore, improving reliability and cost optimization. To implement the Cache-Aside pattern, follow these recommendations: