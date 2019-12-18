def find_all(iterable, searchtext, returned="key"):
    
    """Returns an iterator that returns all keys or values
       of a (nested) iterable.
       
       Arguments:
           - iterable: <list> or <dictionary>
           - returned: <string> "key", "value" or "item"
           
       Returns:
           - <iterator>
    """
  
    if isinstance(iterable, dict):
        for key, value in iterable.items():
            if key == searchtext or value == searchtext:
                if returned == "key":
                    yield key
                elif returned == "value":
                    yield value
                elif returned == "item":
                    yield iterable
                else:
                    raise ValueError("'returned' keyword only accepts 'key', 'value', or item.")
            for ret in find_all(value, searchtext, returned=returned):
                yield ret
    elif isinstance(iterable, list):
        for el in iterable:
            for ret in find_all(el, searchtext, returned=returned):
                yield ret

main_toc = {'items': [{'href': 'index.md', 'name': 'Azure Architecture Center'},
           {'items': [{'href': 'guide/index.md', 'name': 'Introduction'},
                      {'items': [{'href': 'guide/architecture-styles/index.md',
                                  'name': 'Overview'},
                                 {'href': 'guide/architecture-styles/big-compute.md',
                                  'name': 'Big compute'},
                                 {'href': 'guide/architecture-styles/big-data.md',
                                  'name': 'Big data'},
                                 {'href': 'guide/architecture-styles/event-driven.md',
                                  'name': 'Event-driven architecture'},
                                 {'href': 'guide/architecture-styles/microservices.md',
                                  'name': 'Microservices'},
                                 {'href': 'guide/architecture-styles/n-tier.md',
                                  'name': 'N-tier application'},
                                 {'href': 'guide/architecture-styles/web-queue-worker.md',
                                  'name': 'Web-queue-worker'}],
                       'name': 'Architecture Styles'},
                      {'items': [{'href': 'guide/design-principles/index.md',
                                  'name': 'Overview'},
                                 {'href': 'guide/design-principles/self-healing.md',
                                  'name': 'Design for self-healing'},
                                 {'href': 'guide/design-principles/redundancy.md',
                                  'name': 'Make all things redundant'},
                                 {'href': 'guide/design-principles/minimize-coordination.md',
                                  'name': 'Minimize coordination'},
                                 {'href': 'guide/design-principles/scale-out.md',
                                  'name': 'Design to scale out'},
                                 {'href': 'guide/design-principles/partition.md',
                                  'name': 'Partition around limits'},
                                 {'href': 'guide/design-principles/design-for-operations.md',
                                  'name': 'Design for operations'},
                                 {'href': 'guide/design-principles/managed-services.md',
                                  'name': 'Use managed services'},
                                 {'href': 'guide/design-principles/use-the-best-data-store.md',
                                  'name': 'Use the best data store for the '
                                          'job'},
                                 {'href': 'guide/design-principles/design-for-evolution.md',
                                  'name': 'Design for evolution'},
                                 {'href': 'guide/design-principles/build-for-business.md',
                                  'name': 'Build for the needs of business'}],
                       'name': 'Design Principles'},
                      {'items': [{'items': [{'href': 'guide/technology-choices/compute-overview.md',
                                             'name': 'Overview'},
                                            {'href': 'guide/technology-choices/compute-decision-tree.md',
                                             'name': 'Decision tree'},
                                            {'href': 'guide/technology-choices/compute-comparison.md',
                                             'name': 'Compute comparison'}],
                                  'name': 'Choosing a compute service'},
                                 {'href': 'guide/technology-choices/load-balancing-overview.md',
                                  'name': 'Choosing a load balancing service'},
                                 {'href': 'guide/technology-choices/messaging.md',
                                  'name': 'Choosing a messaging service'}],
                       'name': 'Technology choices'},
                      {'items': [{'href': 'best-practices/api-design.md',
                                  'name': 'API design'},
                                 {'href': 'best-practices/api-implementation.md',
                                  'name': 'API implementation'},
                                 {'href': 'best-practices/auto-scaling.md',
                                  'name': 'Autoscaling'},
                                 {'href': 'best-practices/background-jobs.md',
                                  'name': 'Background jobs'},
                                 {'href': 'best-practices/caching.md',
                                  'name': 'Caching'},
                                 {'href': 'best-practices/cdn.md',
                                  'name': 'Content Delivery Network'},
                                 {'href': 'best-practices/data-partitioning.md',
                                  'name': 'Data partitioning'},
                                 {'href': 'best-practices/data-partitioning-strategies.md',
                                  'name': 'Data partitioning strategies (by '
                                          'service)'},
                                 {'href': 'best-practices/monitoring.md',
                                  'name': 'Monitoring and diagnostics'},
                                 {'href': 'best-practices/resource-naming.md',
                                  'name': 'Naming rules and restrictions for '
                                          'Azure resources'},
                                 {'href': 'best-practices/retry-service-specific.md',
                                  'name': 'Retry guidance for specific '
                                          'services'},
                                 {'href': 'best-practices/transient-faults.md',
                                  'name': 'Transient fault handling'}],
                       'name': 'Best Practices'},
                      {'items': [{'href': 'performance/index.md',
                                  'name': 'Introduction'},
                                 {'href': 'performance/distributed-transaction.md',
                                  'name': 'Scenario 1 - Distributed '
                                          'transactions'},
                                 {'href': 'performance/backend-services.md',
                                  'name': 'Scenario 2 - Multiple backend '
                                          'services'},
                                 {'href': 'performance/event-streaming.md',
                                  'name': 'Scenario 3 - Event streaming'}],
                       'name': 'Performance tuning'},
                      {'items': [{'href': 'antipatterns/index.md',
                                  'name': 'Overview'},
                                 {'href': 'antipatterns/busy-database/index.md',
                                  'name': 'Busy Database'},
                                 {'href': 'antipatterns/busy-front-end/index.md',
                                  'name': 'Busy Front End'},
                                 {'href': 'antipatterns/chatty-io/index.md',
                                  'name': 'Chatty I/O'},
                                 {'href': 'antipatterns/extraneous-fetching/index.md',
                                  'name': 'Extraneous Fetching'},
                                 {'href': 'antipatterns/improper-instantiation/index.md',
                                  'name': 'Improper Instantiation'},
                                 {'href': 'antipatterns/monolithic-persistence/index.md',
                                  'name': 'Monolithic Persistence'},
                                 {'href': 'antipatterns/no-caching/index.md',
                                  'name': 'No Caching'},
                                 {'href': 'antipatterns/synchronous-io/index.md',
                                  'name': 'Synchronous I/O'}],
                       'name': 'Performance antipatterns'},
                      {'items': [{'href': 'aws-professional/index.md',
                                  'name': 'Overview'},
                                 {'href': 'aws-professional/services.md',
                                  'name': 'Services comparison'}],
                       'name': 'Azure for AWS Professionals'}],
            'name': 'Application architecture guide'},
           {'items': [{'href': 'patterns/index.md', 'name': 'Overview'},
                      {'items': [{'href': 'patterns/category/availability.md',
                                  'name': 'Availability'},
                                 {'href': 'patterns/category/data-management.md',
                                  'name': 'Data management'},
                                 {'href': 'patterns/category/design-implementation.md',
                                  'name': 'Design and implementation'},
                                 {'href': 'patterns/category/management-monitoring.md',
                                  'name': 'Management and monitoring'},
                                 {'href': 'patterns/category/messaging.md',
                                  'name': 'Messaging'},
                                 {'href': 'patterns/category/performance-scalability.md',
                                  'name': 'Performance and scalability'},
                                 {'href': 'patterns/category/resiliency.md',
                                  'name': 'Resiliency'},
                                 {'href': 'patterns/category/security.md',
                                  'name': 'Security'}],
                       'name': 'Categories'},
                      {'href': 'patterns/ambassador.md', 'name': 'Ambassador'},
                      {'href': 'patterns/anti-corruption-layer.md',
                       'name': 'Anti-corruption Layer'},
                      {'href': 'patterns/async-request-reply.md',
                       'name': 'Asynchronous Request-Reply'},
                      {'href': 'patterns/backends-for-frontends.md',
                       'name': 'Backends for Frontends'},
                      {'href': 'patterns/bulkhead.md', 'name': 'Bulkhead'},
                      {'href': 'patterns/cache-aside.md',
                       'name': 'Cache-Aside'},
                      {'href': 'patterns/choreography.md',
                       'name': 'Choreography'},
                      {'href': 'patterns/circuit-breaker.md',
                       'name': 'Circuit Breaker'},
                      {'href': 'patterns/claim-check.md',
                       'name': 'Claim Check'},
                      {'href': 'patterns/cqrs.md',
                       'name': 'Command and Query Responsibility Segregation '
                               '(CQRS)'},
                      {'href': 'patterns/compensating-transaction.md',
                       'name': 'Compensating Transaction'},
                      {'href': 'patterns/competing-consumers.md',
                       'name': 'Competing Consumers'},
                      {'href': 'patterns/compute-resource-consolidation.md',
                       'name': 'Compute Resource Consolidation'},
                      {'href': 'patterns/event-sourcing.md',
                       'name': 'Event Sourcing'},
                      {'href': 'patterns/external-configuration-store.md',
                       'name': 'External Configuration Store'},
                      {'href': 'patterns/federated-identity.md',
                       'name': 'Federated Identity'},
                      {'href': 'patterns/gatekeeper.md', 'name': 'Gatekeeper'},
                      {'href': 'patterns/gateway-aggregation.md',
                       'name': 'Gateway Aggregation'},
                      {'href': 'patterns/gateway-offloading.md',
                       'name': 'Gateway Offloading'},
                      {'href': 'patterns/gateway-routing.md',
                       'name': 'Gateway Routing'},
                      {'href': 'patterns/health-endpoint-monitoring.md',
                       'name': 'Health Endpoint Monitoring'},
                      {'href': 'patterns/index-table.md',
                       'name': 'Index Table'},
                      {'href': 'patterns/leader-election.md',
                       'name': 'Leader Election'},
                      {'href': 'patterns/materialized-view.md',
                       'name': 'Materialized View'},
                      {'href': 'patterns/pipes-and-filters.md',
                       'name': 'Pipes and Filters'},
                      {'href': 'patterns/priority-queue.md',
                       'name': 'Priority Queue'},
                      {'href': 'patterns/publisher-subscriber.md',
                       'name': 'Publisher/Subscriber'},
                      {'href': 'patterns/queue-based-load-leveling.md',
                       'name': 'Queue-Based Load Leveling'},
                      {'href': 'patterns/retry.md', 'name': 'Retry'},
                      {'href': 'patterns/scheduler-agent-supervisor.md',
                       'name': 'Scheduler Agent Supervisor'},
                      {'href': 'patterns/sharding.md', 'name': 'Sharding'},
                      {'href': 'patterns/sidecar.md', 'name': 'Sidecar'},
                      {'href': 'patterns/static-content-hosting.md',
                       'name': 'Static Content Hosting'},
                      {'href': 'patterns/strangler.md', 'name': 'Strangler'},
                      {'href': 'patterns/throttling.md', 'name': 'Throttling'},
                      {'href': 'patterns/valet-key.md', 'name': 'Valet Key'}],
            'name': 'Design Patterns'},
           {'items': [{'href': 'framework/index.md', 'name': 'Overview'},
                      {'items': [{'href': 'framework/cost/overview.md',
                                  'name': 'Overview'},
                                 {'href': 'framework/cost/modeling.md',
                                  'name': 'Cost modeling'},
                                 {'href': 'framework/cost/monitoring.md',
                                  'name': 'Cost monitoring'},
                                 {'href': 'framework/cost/data-management.md',
                                  'name': 'Data management'},
                                 {'href': 'framework/cost/optimizing.md',
                                  'name': 'Optimizing cloud costs'},
                                 {'href': 'framework/cost/provisioning.md',
                                  'name': 'Provisioning'},
                                 {'href': 'framework/cost/tradeoffs.md',
                                  'name': 'Trade-offs'},
                                 {'href': 'framework/cost/checklist.md',
                                  'name': 'Checklist'}],
                       'name': 'Cost'},
                      {'items': [{'href': 'framework/devops/overview.md',
                                  'name': 'Overview'},
                                 {'href': 'framework/devops/app-design.md',
                                  'name': 'Application design'},
                                 {'href': 'framework/devops/gitflow-branch-workflow.md',
                                  'name': 'Branching strategies'},
                                 {'href': 'framework/devops/development.md',
                                  'name': 'Development'},
                                 {'href': 'framework/devops/deployment.md',
                                  'name': 'Deployment'},
                                 {'href': 'framework/devops/iac.md',
                                  'name': 'Infrastructure Deployments'},
                                 {'href': 'framework/devops/monitoring.md',
                                  'name': 'Monitoring'},
                                 {'href': 'framework/devops/performance.md',
                                  'name': 'Performance'},
                                 {'href': 'framework/devops/testing.md',
                                  'name': 'Testing'},
                                 {'href': 'checklist/dev-ops.md',
                                  'name': 'Checklist'}],
                       'name': 'DevOps'},
                      {'items': [{'href': 'framework/resiliency/overview.md',
                                  'name': 'Overview'},
                                 {'items': [{'href': 'framework/resiliency/app-design.md',
                                             'name': 'Design overview'},
                                            {'href': 'framework/resiliency/app-design-error-handling.md',
                                             'name': 'Error handling'},
                                            {'href': 'resiliency/failure-mode-analysis.md',
                                             'name': 'Failure mode analysis'}],
                                  'name': 'Application design'},
                                 {'href': 'framework/resiliency/backup-and-recovery.md',
                                  'name': 'Backup and recovery'},
                                 {'href': 'framework/resiliency/business-metrics.md',
                                  'name': 'Business metrics'},
                                 {'href': 'framework/resiliency/data-management.md',
                                  'name': 'Data management'},
                                 {'href': 'framework/resiliency/monitoring.md',
                                  'name': 'Monitoring and disaster recovery'},
                                 {'href': 'resiliency/recovery-loss-azure-region.md',
                                  'name': 'Recover from a region-wide service '
                                          'disruption'},
                                 {'href': 'framework/resiliency/testing.md',
                                  'name': 'Resiliency testing'},
                                 {'href': 'checklist/resiliency-per-service.md',
                                  'name': 'Checklist'}],
                       'name': 'Resiliency'},
                      {'items': [{'href': 'framework/scalability/overview.md',
                                  'name': 'Overview'},
                                 {'href': 'framework/scalability/app-design.md',
                                  'name': 'Application design'},
                                 {'href': 'framework/scalability/capacity.md',
                                  'name': 'Capacity planning'},
                                 {'href': 'framework/scalability/load-testing.md',
                                  'name': 'Load testing'},
                                 {'href': 'framework/scalability/monitoring.md',
                                  'name': 'Monitoring'},
                                 {'href': 'checklist/scalability.md',
                                  'name': 'Checklist'}],
                       'name': 'Scalability'},
                      {'items': [{'href': 'framework/security/overview.md',
                                  'name': 'Overview'},
                                 {'href': 'framework/security/role-of-security.md',
                                  'name': 'Role of security'},
                                 {'href': 'framework/security/security-principles.md',
                                  'name': 'Security design principles'},
                                 {'href': 'framework/security/architecture-type.md',
                                  'name': 'Types of attacks to resist'},
                                 {'href': 'framework/security/law-authority.md',
                                  'name': 'Regulatory compliance'},
                                 {'href': 'framework/security/resilience.md',
                                  'name': 'Reduce organizational risk'},
                                 {'href': 'framework/security/governance.md',
                                  'name': 'Governance, risk, and compliance'},
                                 {'href': 'framework/security/identity.md',
                                  'name': 'Identity and access management'},
                                 {'href': 'framework/security/network-security-containment.md',
                                  'name': 'Network security and containment'},
                                 {'href': 'framework/security/storage-data-encryption.md',
                                  'name': 'Storage, data, and encryption'},
                                 {'href': 'framework/security/applications-services.md',
                                  'name': 'Applications and services'},
                                 {'href': 'framework/security/critical-impact-accounts.md',
                                  'name': 'Administration'},
                                 {'href': 'framework/security/security-operations.md',
                                  'name': 'Security operations'}],
                       'name': 'Security'}],
            'name': 'Azure Architecture Framework'},
           {'expanded': True,
            'items': [{'items': [{'href': 'data-guide/big-data/machine-learning-at-scale.md',
                                  'name': 'Overview'},
                                 {'items': [{'items': [{'href': 'reference-architectures/ai/training-python-models.md',
                                                        'name': 'Training of '
                                                                'Python '
                                                                'scikit-learn '
                                                                'models'},
                                                       {'href': 'reference-architectures/ai/training-deep-learning.md',
                                                        'name': 'Distributed '
                                                                'training of '
                                                                'deep learning '
                                                                'models'},
                                                       {'href': 'reference-architectures/ai/batch-scoring-python.md',
                                                        'name': 'Batch scoring '
                                                                'of Python '
                                                                'models'},
                                                       {'href': 'reference-architectures/ai/batch-scoring-deep-learning.md',
                                                        'name': 'Batch scoring '
                                                                'of deep '
                                                                'learning '
                                                                'models'},
                                                       {'href': 'reference-architectures/ai/realtime-scoring-python.md',
                                                        'name': 'Real-time '
                                                                'scoring of '
                                                                'Python and '
                                                                'deep learning '
                                                                'models'},
                                                       {'href': 'reference-architectures/ai/mlops-python.md',
                                                        'name': 'MLOps for '
                                                                'Python models '
                                                                'using Azure '
                                                                'Machine '
                                                                'Learning'}],
                                             'name': 'Training and scoring '
                                                     'Python models'},
                                            {'items': [{'href': 'reference-architectures/ai/batch-scoring-R-models.md',
                                                        'name': 'Batch scoring '
                                                                'of R models'},
                                                       {'href': 'reference-architectures/ai/realtime-scoring-r.md',
                                                        'name': 'Real-time '
                                                                'scoring of R '
                                                                'models'}],
                                             'name': 'Scoring R models'},
                                            {'href': 'reference-architectures/ai/batch-scoring-databricks.md',
                                             'name': 'Batch scoring of Spark '
                                                     'models on Azure '
                                                     'Databricks'},
                                            {'href': 'reference-architectures/ai/conversational-bot.md',
                                             'name': 'Conversational bot'},
                                            {'href': 'reference-architectures/ai/real-time-recommendation.md',
                                             'name': 'Real-time recommendation '
                                                     'API'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'data-guide/technology-choices/cognitive-services.md',
                                             'name': 'Cognitive services'},
                                            {'href': 'data-guide/technology-choices/data-science-and-machine-learning.md',
                                             'name': 'Machine learning'},
                                            {'href': 'data-guide/technology-choices/natural-language-processing.md',
                                             'name': 'Natural language '
                                                     'processing'},
                                            {'href': 'data-guide/technology-choices/r-developers-guide.md',
                                             'name': "R developer's guide to "
                                                     'Azure'}],
                                  'name': 'Technology choices'},
                                 {'items': [{'href': 'example-scenario/ai/commerce-chatbot.md',
                                             'name': 'Hotel reservation '
                                                     'chatbot'},
                                            {'href': 'example-scenario/ai/intelligent-apps-image-processing.md',
                                             'name': 'Image classification'},
                                            {'href': 'example-scenario/ai/movie-recommendations.md',
                                             'name': 'Movie recommendation'},
                                            {'href': 'example-scenario/ai/newsfeed-ingestion.md',
                                             'name': 'Newsfeed ingestion'},
                                            {'href': 'example-scenario/ai/scalable-personalization.md',
                                             'name': 'Scalable '
                                                     'personalization'}],
                                  'name': 'Example workloads'}],
                       'name': 'AI and machine learning'},
                      {'items': [{'items': [{'href': 'example-scenario/apps/decentralized-trust.md',
                                             'name': 'Decentralized trust '
                                                     'between banks'}],
                                  'name': 'Example workloads'}],
                       'name': 'Blockchain'},
                      {'items': [{'items': [{'href': 'reference-architectures/data/enterprise-bi-synapse.md',
                                             'name': 'Enterprise BI with Azure '
                                                     'Synapse Analytics'},
                                            {'href': 'reference-architectures/data/enterprise-bi-adf.md',
                                             'name': 'Automated enterprise BI '
                                                     'with Azure Data Factory'},
                                            {'href': 'reference-architectures/data/stream-processing-databricks.md',
                                             'name': 'Stream processing with '
                                                     'Azure Databricks'},
                                            {'href': 'reference-architectures/data/stream-processing-stream-analytics.md',
                                             'name': 'Stream processing with '
                                                     'Azure Stream Analytics'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'data-guide/index.md',
                                             'name': 'Overview'},
                                            {'items': [{'href': 'data-guide/relational-data/etl.md',
                                                        'name': 'Extract, '
                                                                'transform, '
                                                                'and load '
                                                                '(ETL)'},
                                                       {'href': 'data-guide/relational-data/online-analytical-processing.md',
                                                        'name': 'Online '
                                                                'analytical '
                                                                'processing '
                                                                '(OLAP)'},
                                                       {'href': 'data-guide/relational-data/online-transaction-processing.md',
                                                        'name': 'Online '
                                                                'transaction '
                                                                'processing '
                                                                '(OLTP)'},
                                                       {'href': 'data-guide/relational-data/data-warehousing.md',
                                                        'name': 'Data '
                                                                'Warehousing'}],
                                             'name': 'Relational Data'},
                                            {'items': [{'href': 'data-guide/big-data/index.md',
                                                        'name': 'Big Data '
                                                                'architectures'},
                                                       {'href': 'data-guide/big-data/batch-processing.md',
                                                        'name': 'Batch '
                                                                'processing'},
                                                       {'href': 'data-guide/big-data/non-relational-data.md',
                                                        'name': 'Non-relational '
                                                                'data stores'},
                                                       {'href': 'data-guide/big-data/real-time-processing.md',
                                                        'name': 'Real time '
                                                                'processing'}],
                                             'name': 'Big Data'},
                                            {'items': [{'href': 'guide/technology-choices/data-store-overview.md',
                                                        'name': 'Overview'},
                                                       {'href': 'data-guide/technology-choices/analytical-data-stores.md',
                                                        'name': 'Analytical '
                                                                'data stores'},
                                                       {'href': 'data-guide/technology-choices/analysis-visualizations-reporting.md',
                                                        'name': 'Analytics and '
                                                                'reporting'},
                                                       {'href': 'data-guide/technology-choices/batch-processing.md',
                                                        'name': 'Batch '
                                                                'processing'},
                                                       {'href': 'data-guide/technology-choices/data-storage.md',
                                                        'name': 'Data storage'},
                                                       {'href': 'guide/technology-choices/data-store-comparison.md',
                                                        'name': 'Data store '
                                                                'comparison'},
                                                       {'href': 'data-guide/technology-choices/pipeline-orchestration-data-movement.md',
                                                        'name': 'Pipeline '
                                                                'orchestration'},
                                                       {'href': 'data-guide/technology-choices/real-time-ingestion.md',
                                                        'name': 'Real-time '
                                                                'message '
                                                                'ingestion'},
                                                       {'href': 'data-guide/technology-choices/search-options.md',
                                                        'name': 'Search data '
                                                                'stores'},
                                                       {'href': 'data-guide/technology-choices/stream-processing.md',
                                                        'name': 'Stream '
                                                                'processing'}],
                                             'name': 'Technology choices'},
                                            {'items': [{'href': 'databricks-monitoring/index.md',
                                                        'name': 'Overview'},
                                                       {'href': 'databricks-monitoring/application-logs.md',
                                                        'name': 'Send '
                                                                'Databricks '
                                                                'application '
                                                                'logs to Azure '
                                                                'Monitor'},
                                                       {'href': 'databricks-monitoring/dashboards.md',
                                                        'name': 'Use '
                                                                'dashboards to '
                                                                'visualize '
                                                                'Databricks '
                                                                'metrics'},
                                                       {'href': 'databricks-monitoring/performance-troubleshooting.md',
                                                        'name': 'Troubleshoot '
                                                                'performance '
                                                                'bottlenecks'}],
                                             'name': 'Databricks Monitoring'}],
                                  'name': 'Guides'},
                                 {'items': [{'href': 'data-guide/scenarios/advanced-analytics.md',
                                             'name': 'Advanced analytics'},
                                            {'href': 'data-guide/scenarios/data-lake.md',
                                             'name': 'Data lakes'},
                                            {'href': 'data-guide/scenarios/data-transfer.md',
                                             'name': 'Data transfer'},
                                            {'href': 'example-scenario/data/data-warehouse.md',
                                             'name': 'Data warehousing and '
                                                     'analytics'},
                                            {'href': 'data-guide/scenarios/hybrid-on-premises-and-cloud.md',
                                             'name': 'Extending on-premises '
                                                     'data solutions to the '
                                                     'cloud'},
                                            {'href': 'data-guide/scenarios/search.md',
                                             'name': 'Free-form text search'},
                                            {'href': 'example-scenario/data/hybrid-etl-with-adf.md',
                                             'name': 'Hybrid ETL with Data '
                                                     'Factory'},
                                            {'href': 'data-guide/scenarios/interactive-data-exploration.md',
                                             'name': 'Interactive data '
                                                     'exploration'},
                                            {'href': 'example-scenario/data/big-data-with-iot.md',
                                             'name': 'IoT for construction'},
                                            {'href': 'data-guide/scenarios/natural-language-processing.md',
                                             'name': 'Natural language '
                                                     'processing'},
                                            {'href': 'example-scenario/data/fraud-detection.md',
                                             'name': 'Real-time fraud '
                                                     'detection'},
                                            {'href': 'example-scenario/data/ecommerce-order-processing.md',
                                             'name': 'Scalable order '
                                                     'processing'},
                                            {'href': 'data-guide/scenarios/securing-data-solutions.md',
                                             'name': 'Securing data solutions'},
                                            {'href': 'data-guide/scenarios/time-series.md',
                                             'name': 'Time series solutions'},
                                            {'href': 'data-guide/scenarios/csv-and-json.md',
                                             'name': 'Working with CSV and '
                                                     'JSON files'}],
                                  'name': 'Example workloads'}],
                       'name': 'Data architectures'},
                      {'items': [{'href': 'checklist/dev-ops.md',
                                  'name': 'Checklist'},
                                 {'items': [{'items': [{'href': 'building-blocks/extending-templates/index.md',
                                                        'name': 'Overview'},
                                                       {'href': 'building-blocks/extending-templates/update-resource.md',
                                                        'name': 'Update a '
                                                                'resource'},
                                                       {'href': 'building-blocks/extending-templates/conditional-deploy.md',
                                                        'name': 'Conditionally '
                                                                'deploy a '
                                                                'resource'},
                                                       {'href': 'building-blocks/extending-templates/objects-as-parameters.md',
                                                        'name': 'Use an object '
                                                                'as a '
                                                                'parameter'},
                                                       {'href': 'building-blocks/extending-templates/collector.md',
                                                        'name': 'Property '
                                                                'transformer '
                                                                'and '
                                                                'collector'}],
                                             'name': 'Extending Resource '
                                                     'Manager Templates'}],
                                  'name': 'Guides'},
                                 {'items': [{'href': 'example-scenario/apps/devops-dotnet-webapp.md',
                                             'name': 'DevOps with Azure '
                                                     'DevOps'},
                                            {'href': 'example-scenario/apps/devops-with-aks.md',
                                             'name': 'DevOps with containers'},
                                            {'href': 'example-scenario/apps/jenkins.md',
                                             'name': 'Jenkins server'}],
                                  'name': 'Example workloads'}],
                       'name': 'DevOps'},
                      {'items': [{'items': [{'href': 'reference-architectures/enterprise-integration/basic-enterprise-integration.md',
                                             'name': 'Basic enterprise '
                                                     'integration'},
                                            {'href': 'reference-architectures/enterprise-integration/queues-events.md',
                                             'name': 'Enterprise integration '
                                                     'with queues and events'}],
                                  'name': 'Reference architectures'}],
                       'name': 'Enterprise integration'},
                      {'items': [{'href': 'topics/high-performance-computing.md',
                                  'name': 'Overview'},
                                 {'items': [{'href': 'example-scenario/infrastructure/hpc-cfd.md',
                                             'name': 'Computational fluid '
                                                     'dynamics (CFD)'},
                                            {'href': 'example-scenario/apps/hpc-saas.md',
                                             'name': 'Computer-aided '
                                                     'engineering'},
                                            {'href': 'example-scenario/infrastructure/video-rendering.md',
                                             'name': 'HPC video rendering'},
                                            {'href': 'example-scenario/infrastructure/image-modeling.md',
                                             'name': 'Image Modeling'},
                                            {'href': 'example-scenario/infrastructure/linux-vdi-citrix.md',
                                             'name': 'Linux virtual desktops'}],
                                  'name': 'Example workloads'}],
                       'name': 'High performance computing (HPC)'},
                      {'items': [{'items': [{'href': 'reference-architectures/identity/index.md',
                                             'name': 'Choose an Active '
                                                     'Directory integration '
                                                     'architecture'},
                                            {'href': 'reference-architectures/identity/azure-ad.md',
                                             'name': 'Integrate on-premises AD '
                                                     'with Azure AD'},
                                            {'href': 'reference-architectures/identity/adds-extend-domain.md',
                                             'name': 'Extend AD DS to Azure'},
                                            {'href': 'reference-architectures/identity/adds-forest.md',
                                             'name': 'Create an AD DS forest '
                                                     'in Azure'},
                                            {'href': 'reference-architectures/identity/adfs.md',
                                             'name': 'Extend AD FS to Azure'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'items': [{'href': 'multitenant-identity/index.md',
                                                        'name': 'Introduction'},
                                                       {'href': 'multitenant-identity/tailspin.md',
                                                        'name': 'The Tailspin '
                                                                'scenario'},
                                                       {'href': 'multitenant-identity/authenticate.md',
                                                        'name': 'Authentication'},
                                                       {'href': 'multitenant-identity/claims.md',
                                                        'name': 'Claims-based '
                                                                'identity'},
                                                       {'href': 'multitenant-identity/signup.md',
                                                        'name': 'Tenant '
                                                                'sign-up'},
                                                       {'href': 'multitenant-identity/app-roles.md',
                                                        'name': 'Application '
                                                                'roles'},
                                                       {'href': 'multitenant-identity/authorize.md',
                                                        'name': 'Authorization'},
                                                       {'href': 'multitenant-identity/web-api.md',
                                                        'name': 'Secure a web '
                                                                'API'},
                                                       {'href': 'multitenant-identity/token-cache.md',
                                                        'name': 'Cache access '
                                                                'tokens'},
                                                       {'href': 'multitenant-identity/client-assertion.md',
                                                        'name': 'Client '
                                                                'assertion'},
                                                       {'href': 'multitenant-identity/adfs.md',
                                                        'name': 'Federate with '
                                                                "a customer's "
                                                                'AD FS'}],
                                             'name': 'Identity in multitenant '
                                                     'applications'}],
                                  'name': 'Guides'}],
                       'name': 'Identity'},
                      {'items': [{'items': [{'href': 'reference-architectures/iot/index.md',
                                             'name': 'Internet of Things '
                                                     '(IoT)'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'example-scenario/data/realtime-analytics-vehicle-iot.md',
                                             'name': 'Automotive IoT data'},
                                            {'href': 'example-scenario/apps/telehealth-system.md',
                                             'name': 'Telehealth System'}],
                                  'name': 'Example workloads'}],
                       'name': 'Internet of Things (IoT)'},
                      {'items': [{'href': 'microservices/index.md',
                                  'name': 'Overview'},
                                 {'items': [{'href': 'reference-architectures/microservices/aks.md',
                                             'name': 'Azure Kubernetes Service '
                                                     '(AKS)'},
                                            {'href': 'reference-architectures/microservices/service-fabric.md',
                                             'name': 'Azure Service Fabric'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'items': [{'href': 'microservices/model/domain-analysis.md',
                                                        'name': 'Domain '
                                                                'analysis'},
                                                       {'href': 'microservices/model/tactical-ddd.md',
                                                        'name': 'Tactical DDD'},
                                                       {'href': 'microservices/model/microservice-boundaries.md',
                                                        'name': 'Identify '
                                                                'microservice '
                                                                'boundaries'}],
                                             'name': 'Domain modeling for '
                                                     'microservices'},
                                            {'items': [{'href': 'microservices/design/index.md',
                                                        'name': 'Introduction'},
                                                       {'href': 'microservices/design/compute-options.md',
                                                        'name': 'Choose a '
                                                                'compute '
                                                                'option'},
                                                       {'href': 'microservices/design/interservice-communication.md',
                                                        'name': 'Interservice '
                                                                'communication'},
                                                       {'href': 'microservices/design/api-design.md',
                                                        'name': 'API design'},
                                                       {'href': 'microservices/design/gateway.md',
                                                        'name': 'API gateways'},
                                                       {'href': 'microservices/design/data-considerations.md',
                                                        'name': 'Data '
                                                                'considerations'},
                                                       {'href': 'microservices/design/patterns.md',
                                                        'name': 'Design '
                                                                'patterns for '
                                                                'microservices'}],
                                             'name': 'Design a microservices '
                                                     'architecture'},
                                            {'items': [{'href': 'microservices/logging-monitoring.md',
                                                        'name': 'Monitor '
                                                                'microservices '
                                                                'in Azure '
                                                                'Kubernetes '
                                                                'Service '
                                                                '(AKS)'},
                                                       {'href': 'microservices/ci-cd.md',
                                                        'name': 'CI/CD for '
                                                                'microservices'},
                                                       {'href': 'microservices/ci-cd-kubernetes.md',
                                                        'name': 'CI/CD for '
                                                                'microservices '
                                                                'on '
                                                                'Kubernetes'}],
                                             'name': 'Operate microservices in '
                                                     'production'},
                                            {'items': [{'href': 'microservices/migrate-monolith.md',
                                                        'name': 'Migrate a '
                                                                'monolith '
                                                                'application '
                                                                'to '
                                                                'microservices'},
                                                       {'href': 'service-fabric/modernize-app-azure-service-fabric.md',
                                                        'name': 'Modernize '
                                                                'enterprise '
                                                                'applications '
                                                                'with Service '
                                                                'Fabric'},
                                                       {'href': 'service-fabric/migrate-from-cloud-services.md',
                                                        'name': 'Migrate from '
                                                                'Cloud '
                                                                'Services to '
                                                                'Service '
                                                                'Fabric'}],
                                             'name': 'Migrate to a '
                                                     'microservices '
                                                     'architecture'}],
                                  'name': 'Guides'},
                                 {'items': [{'href': 'example-scenario/infrastructure/service-fabric-microservices.md',
                                             'name': 'Decomposing a monolithic '
                                                     'application'}],
                                  'name': 'Example workloads'}],
                       'name': 'Microservices'},
                      {'items': [{'items': [{'href': 'reference-architectures/hybrid-networking/index.md',
                                             'name': 'Choose a hybrid network '
                                                     'architecture'},
                                            {'href': 'reference-architectures/hybrid-networking/vnet-peering.md',
                                             'name': 'Choose between virtual '
                                                     'network peering and VPN '
                                                     'gateways'},
                                            {'href': 'reference-architectures/hybrid-networking/vpn.md',
                                             'name': 'VPN'},
                                            {'href': 'reference-architectures/hybrid-networking/expressroute.md',
                                             'name': 'ExpressRoute'},
                                            {'href': 'reference-architectures/hybrid-networking/expressroute-vpn-failover.md',
                                             'name': 'ExpressRoute with VPN '
                                                     'failover'},
                                            {'href': 'reference-architectures/hybrid-networking/troubleshoot-vpn.md',
                                             'name': 'Troubleshoot a hybrid '
                                                     'VPN connection'}],
                                  'name': 'Hybrid networking'},
                                 {'href': 'reference-architectures/hybrid-networking/hub-spoke.md',
                                  'name': 'Hub-spoke topology'},
                                 {'href': 'reference-architectures/hybrid-networking/shared-services.md',
                                  'name': 'Hub-spoke topology with shared '
                                          'services'},
                                 {'items': [{'href': 'reference-architectures/dmz/secure-vnet-dmz.md',
                                             'name': 'DMZ between Azure and '
                                                     'on-premises'},
                                            {'href': 'reference-architectures/dmz/nva-ha.md',
                                             'name': 'Highly available network '
                                                     'virtual appliances'}],
                                  'name': 'Network DMZ'}],
                       'name': 'Networking'},
                      {'items': [{'href': 'serverless/index.md',
                                  'name': 'Overview'},
                                 {'items': [{'href': 'reference-architectures/serverless/event-processing.md',
                                             'name': 'Serverless event '
                                                     'processing'},
                                            {'href': 'reference-architectures/serverless/web-app.md',
                                             'name': 'Serverless web '
                                                     'application'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'serverless/code.md',
                                             'name': 'Create a serverless '
                                                     'backend with Azure '
                                                     'Functions'},
                                            {'href': 'serverless/guide/serverless-app-cicd-best-practices.md',
                                             'name': 'CI/CD for a serverless '
                                                     'frontend'},
                                            {'href': 'example-scenario/signalr/index.md',
                                             'name': 'Sharing location in real '
                                                     'time using Functions, '
                                                     'SignalR and Service '
                                                     'Bus'}],
                                  'name': 'Guides'}],
                       'name': 'Serverless applications'},
                      {'items': [{'items': [{'href': 'reference-architectures/n-tier/linux-vm.md',
                                             'name': 'Linux VM deployment'},
                                            {'href': 'reference-architectures/n-tier/windows-vm.md',
                                             'name': 'Windows VM deployment'},
                                            {'href': 'reference-architectures/n-tier/n-tier-cassandra.md',
                                             'name': 'N-tier application with '
                                                     'Cassandra (Linux)'},
                                            {'href': 'reference-architectures/n-tier/n-tier-sql-server.md',
                                             'name': 'N-tier application with '
                                                     'SQL Server (Windows)'},
                                            {'href': 'reference-architectures/n-tier/multi-region-sql-server.md',
                                             'name': 'Multi-region N-tier '
                                                     'application'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'best-practices/cassandra.md',
                                             'name': 'Apache Cassandra'},
                                            {'items': [{'href': 'reference-architectures/sap/hana-large-instances.md',
                                                        'name': 'SAP HANA on '
                                                                'Azure Large '
                                                                'Instances'},
                                                       {'href': 'reference-architectures/sap/sap-netweaver.md',
                                                        'name': 'SAP NetWeaver '
                                                                'for AnyDB'},
                                                       {'href': 'reference-architectures/sap/sap-s4hana.md',
                                                        'name': 'SAP S/4HANA'},
                                                       {'href': 'example-scenario/apps/sap-dev-test.md',
                                                        'name': 'SAP for '
                                                                'dev/test'},
                                                       {'href': 'example-scenario/apps/sap-production.md',
                                                        'name': 'SAP for '
                                                                'production'}],
                                             'name': 'SAP'},
                                            {'href': 'reference-architectures/sharepoint/index.md',
                                             'name': 'SharePoint Server 2016'},
                                            {'href': 'example-scenario/infrastructure/wordpress.md',
                                             'name': 'WordPress'}],
                                  'name': 'Example workloads'}],
                       'name': 'VM workloads'},
                      {'items': [{'items': [{'href': 'reference-architectures/app-service-web-app/basic-web-app.md',
                                             'name': 'Basic web application'},
                                            {'href': 'reference-architectures/app-service-web-app/scalable-web-app.md',
                                             'name': 'Improved scalability'},
                                            {'href': 'reference-architectures/app-service-web-app/multi-region.md',
                                             'name': 'Multi-region deployment'},
                                            {'href': 'reference-architectures/app-service-web-app/app-monitoring.md',
                                             'name': 'Web application '
                                                     'monitoring'}],
                                  'name': 'Reference architectures'},
                                 {'items': [{'href': 'example-scenario/apps/apim-api-scenario.md',
                                             'name': 'E-commerce API '
                                                     'management'},
                                            {'href': 'example-scenario/apps/ecommerce-scenario.md',
                                             'name': 'E-commerce front-end'},
                                            {'href': 'example-scenario/apps/ecommerce-search.md',
                                             'name': 'E-commerce product '
                                                     'search'},
                                            {'href': 'example-scenario/apps/publish-internal-apis-externally.md',
                                             'name': 'Publishing internal APIs '
                                                     'externally'},
                                            {'href': 'example-scenario/apps/fully-managed-secure-apps.md',
                                             'name': 'Securely managed web '
                                                     'application'},
                                            {'href': 'example-scenario/infrastructure/multi-tier-app-disaster-recovery.md',
                                             'name': 'Highly available web '
                                                     'application'}],
                                  'name': 'Example workloads'}],
                       'name': 'Web apps'}],
            'name': 'Technologies'},
           {'href': 'https://docs.microsoft.com/azure/cloud-adoption-framework',
            'name': 'Cloud Adoption Framework'}]}

for i in find_all(main_toc, 'patterns/circuit-breaker.md', 'item'):
    print(i)