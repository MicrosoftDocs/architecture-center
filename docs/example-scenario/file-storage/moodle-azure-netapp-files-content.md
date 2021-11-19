Moodle is one of the most popular and widely adopted free, open-source learning management systems. With more than 30 percent of the global market share, Moodle has more than 180,000 customers worldwide. Moodle customers span many industries including education, business, IT, and finance.

Since the emergence of COVID-19, Moodle has seen a surge in growth. The company is now the market leader in learning management systems. This growth has forced Moodle to explore options for quickly expanding its business and enabling customers to quickly and efficiently deploy Moodle instances in the cloud. Moodle architecture relies on the Network File System (NFS) 3.0 protocol (NFSv3) for content storage.

Azure NetApp Files is a first-party Azure file storage service. You can use this service to migrate and run the most demanding enterprise-scale file workloads in the cloud:

- Native Server Message Block (SMB) version 3, NFSv3, and NFSv4.1 file shares
- Database workloads
- Data warehouse workloads
- High-performance computing applications

(Edit this paragraph and maybe move it before introducing Azure NetApp Files.) Moodle requires high throughput, low latency access to storage. For scaling to larger numbers of concurrent users there is strong desire to auto-scale the performance of the setup to keep up with the high expectations of users.

This article presents a solution that meets Moodle's needs. Core components include ... How are the needs met? ANF provides a high-bandwidth, low-latency solution.

## Potential use cases

This solution applies to organizations that complete these tasks:

- Supplying ...

## Architecture

:::image type="content" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Architecture diagram showing how the solution manages Azure Marketplace images. Illustrated steps include customization, tracking, testing, and publishing." border="false":::

*Download a [Visio file][Visio version of golden image publishing process architecture diagram] of this architecture.*

The process of ... contains these steps:

1. 

:::image type="content" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Architecture diagram showing how the solution manages compliance by assigning policy definitions, evaluating machines, and displaying data in a dashboard." border="false":::

*Download a [Visio file][Visio version of VM compliance architecture diagram] of this architecture.*

The process of ... contains these steps:

1. Azure Policy assigns policy definitions to VMs and evaluates the VMs for compliance.
1. Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.

### Components


### Alternatives


## Considerations

Keep the following points in mind when you implement this solution.

### Scalability considerations


### Resiliency considerations



## Pricing



## Next steps


## Related resources

