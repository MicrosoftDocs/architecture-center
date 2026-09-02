As enterprises integrate AI models into mission-critical systems, a key challenge is how to run real-time inferencing on production data without compromising the stability or performance of the production database and the applications that depend on it. This article describes an architecture that meets that challenge by running AI inferencing on a Silk Cloud Data Platform virtual storage area network (SAN) deployed on Azure infrastructure as a service (IaaS).

The architecture uses the Silk virtual SAN as the storage layer between Azure virtual machines (VMs) and their data, and offloads network and storage processing onto dedicated Azure Boost-enabled VMs. Inference workloads read from a Silk Echo clone of the production database rather than from the database itself, which isolates inference from transactional workloads. Colocating the model, the data clone, and the storage layer in the same zone reduces data movement and keeps inference latency predictable under load.

Key benefits of this architecture include:

- Faster AI response because of low storage and network virtualization latency.
- High-throughput, low-latency data access to accelerated Oracle and SQL production databases via the Silk DataPod virtual SAN.
- Reduced risk of AI operations affecting production, by offloading them to a Silk Echo database clone.
- Improved total cost of ownership and infrastructure utilization for continuous AI inferencing.

## Architecture

The following diagram shows a deployment pattern that uses Azure IaaS and a Silk DataPod virtual SAN to do real-time AI inferencing.

:::image type="complex" source="./_images/silk-inferencing-workflow-example.svg" lightbox="./_images/silk-inferencing-workflow-example.svg" alt-text="Diagram that shows a basic end-to-end inferencing architecture using a Silk virtual SAN." border="false":::
  Most components are inside a VNet except an AI agent and users connecting to a public endpoint. The public endpoint and users in the VNet point to an application with arrows labeled 1. An operational database points with an arrow labeled 1 Event trigger to inferencing models in an AKS cluster. A Silk Virtual SAN is below the database. An AI agent points to the models with an arrow labeled 2. An arrow labeled 2 API calls points from Application to the models. An arrow labeled 3 Current data points from the database to the models. An arrow labeled 3 Historic data points from Azure OneLake outside the VNet to the models. Arrows labeled 4 point from the models to an AI agent and the Application. Arrows labeled 5 point from the Application to users in the VNet and to the public endpoint. An arrow labeled 6 Async updates points to Azure OneLake outside the VNet. An arrow labeled 7 Fine tuning points to Azure Machine Learning outside the VNet.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-boost-iaas-silk-infra.pptx) of this architecture.*

### Workflow

The following workflow corresponds to the numbered steps in the preceding diagram:

1. The inference process starts with a request from an internal or external user or agent, or with an automated trigger from within the operational database, such as a change data capture (CDC) event or scheduled job.

2. The application or intermediate agent securely connects to the primary inference endpoint and passes the relevant context and parameters to the AI model for processing.

3. The inference engine retrieves operational data from a Silk Echo copy of the production database. It augments the data with historical context from OneLake or the enterprise lakehouse to enrich the model's response.

4. The AI model processes the combined data and returns a structured response containing predictions, recommendations, or insights to the calling application or agent.

5. The application formats the model output into a user-friendly response, such as a dashboard update, notification, or embedded insight, and delivers the output to the end user or downstream system.

6. The system logs inference outcomes and user interactions and feeds them back into the lakehouse for historical tracking.

7. Azure Machine Learning can use inference outcomes and user interactions for reinforcement learning and to fine-tune and update the model over time, ensuring continuous improvement and alignment with evolving business needs.

   > [!IMPORTANT]
   > Store inference outcomes and user interactions only after applying privacy, retention, and access-control requirements. Use curated, versioned data, and don't fine-tune directly from unvalidated feedback.

### Components

- [Azure Machine Learning](/azure/machine-learning/?view=azureml-api-2) is a cloud service for training and deploying machine learning models and managing [machine learning operations (MLOps)](/azure/architecture/ai-ml/guide/machine-learning-operations-v2). In this architecture, Azure Machine Learning supplies and trains the inferencing models, which it then deploys to the Azure Kubernetes Service (AKS) cluster. This deployment provides the model endpoints that the application and AI agents call during inference workflows.

- [Microsoft OneLake](/fabric/onelake/onelake-overview) stores the historical, analytical, and feedback data that complements operational data during inference. In this architecture, it provides the lakehouse context used to enrich model responses. It also stores inference outcomes and user interaction data that you can use for monitoring, analysis, and future model improvement.

- [Silk DataPod](https://marketplace.microsoft.com/product/silk.silk_cloud_data_platform) virtual SAN is a software-defined block storage layer in the Silk Cloud Data Platform, which you can deploy from Azure Marketplace. In this architecture, the Silk virtual SAN hosts the operational database volumes and the Silk Echo clones that inference workloads read from. Its disaggregated design separates performance *c.nodes* from capacity *d.nodes*, so you can scale input/output operations per second (IOPS) and throughput independent of storage size. Caching, tiering, and compression reduce data movement between storage and compute.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying and managing containerized applications. In this architecture, AKS hosts the models that generate real-time inferences, such as fraud scores or recommendations. Although Azure Machine Learning documentation recommends managed online endpoints as its default for online inference, hosting the models on AKS in the Azure virtual network keeps inference colocated with the Silk volumes and the clones it reads from.

- [Azure Boost](/azure/azure-boost/overview) is an infrastructure system that offloads virtualization functions, networking, and storage away from hypervisor and host OS cores onto dedicated, purpose-built hardware and software. This offloading frees CPU resources for guest VMs and provides a secure foundation for workloads. In this architecture, network and storage processing run on dedicated hardware instead of host CPU cores, so more VM vCPUs are available for database and inference workloads compared with non-Boost VM sizes. This offloading directly affects how fast Silk c.nodes can serve I/O to the inference tier.

### Alternatives

- Machine Learning documentation recommends managed online endpoints rather than AKS as its default for online inference hosting. For more information, see [Managed online endpoints vs Kubernetes online endpoints](/azure/machine-learning/concept-endpoints-online#managed-online-endpoints-vs-kubernetes-online-endpoints).

- If you select VM sizes that aren't Boost-enabled, the Silk data path competes with host virtualization overhead and you should expect higher and more variable latency.

## Scenario details

By placing inferencing close to the data and offloading processing to dedicated hardware, this solution minimizes data movement and ensures consistent, scalable performance. Combining a high-performance Silk virtual SAN with Azure Boost acceleration provides low-latency, high-throughput access to production data. You can support inferencing directly to an isolated production echo.

In this scenario, Azure Boost accelerates compute and networking at the hardware layer, while the Silk DataPod ensures instant data availability to those compute resources. Silk intelligent data placement and Azure Boost hardware acceleration together reduce CPU overhead, enabling higher workload density and lower total infrastructure costs. For more information, see [Announcing the general availability of Azure Laosv4, Lasv4, and Lsv4 storage optimized VMs](https://techcommunity.microsoft.com/blog/azurecompute/announcing-the-general-availability-of-azure-laosv4-lasv4-and-lsv4-storage-optim/4422481).

The architecture shown in the preceding diagram incorporates the following components and implementation details:

- You deploy all inferencing components, such as the AKS cluster, databases, and applications, in an isolated and secure **Azure virtual network**. The virtual network provides private communication between components and ensures compliance with organizational network and data security policies.

- The **public endpoint** is a secure REST or HTTPS interface that exposes the application's inference capabilities to external users or systems. The endpoint allows clients to send queries and receive predictions or responses, often through an API gateway or managed service. Because the endpoint can't reliably distinguish between requests originating from humans or from automated agents, you should apply authentication, throttling, and abuse protections to all inbound traffic.

- **AI agents** interact with users or systems and call the model endpoints to generate model responses. These agents might use natural language processing (NLP) or domain-specific inference to generate intelligent responses, using the deployed model's predictions in real time. You can deploy AI agents within an enterprise organization or have them interact through public endpoints. Public access can make request volume less predictable, so use authentication, throttling, and abuse protections to control extra load on the application and database while still serving all potential customers.

- The **operational database** stores real-time transactional data that the AI inference relies on for updated insights. This database underpins core business operations and typically uses a high-performance Online Transaction Processing (OLTP) engine such as [Azure SQL](/azure/azure-sql/) or [Oracle Database](/azure/oracle/) on Azure VMs. In this architecture, the operational database holds the critical current data needed for the AI model's real-time predictions and decisions, such as the latest customer transactions or records. Because it's part of a production system with heavy workloads, the operational database is performance-sensitive and tightly integrated with the legacy application. This architecture uses Silk Echo to offload read pressure from the database, ensuring that inference queries don't affect production performance.

- An existing or new **application** deployed in an Azure subscription interlinks tightly with the operational database to support the organization's line of business. The application team might add AI inferencing capabilities directly into the application stack, where it can pass business context to the model and embed the returned prediction, recommendation, or response into the organization's existing workflow.

### Potential use cases

This architecture supports enterprise AI inferencing scenarios that require deterministic performance and real-time responsiveness. The solution provides consistent, predictable inferencing pipeline performance across industries such as financial services, healthcare, and retail. 

- **Finance:** In fraud detection and payment-authorization scoring, each transaction must be evaluated against the account's current state and recent history within the authorization window, typically tens of milliseconds. A false decline is lost revenue and a missed fraud is a direct loss, so the model needs up-to-the-second operational data at a latency and consistency the production database can't safely serve alongside its transactional load.

- **Retail:** Personalized recommendation engines must reflect the customer's in-flight session, items just added to the cart, a return processed minutes ago, or current stock levels, within a sub-10ms latency budget. Because the recommendation depends on current transactional state rather than a nightly export, the inference path reads from a Silk Echo copy of the operational database, keeping recommendation queries from competing with checkout traffic during peak trading.

- **Healthcare:** Patient-deterioration and sepsis-prediction models score vitals, lab results, and medication events as they write to the electronic health record (EHR) system. Early intervention depends on scoring data seconds after it lands, but the EHR database is among the most performance-sensitive systems a hospital runs. Inference reads against a Silk database deliver current clinical data to the model without affecting the system that clinicians depend on.

## Silk architecture

:::image type="complex" source="./_images/silk-architecture.svg" lightbox="./_images/silk-architecture.svg" alt-text="Diagram that shows Silk virtual SAN architecture in a Silk Cloud Data Platform deployment." border="false":::
  All components are inside a box labeled Azure VNet. At upper left are a Silk Flex icon and an Azure icon. At upper center is a box labeled Operational database that has two database icons, one labeled Silk Echo, and connects to a horizontal bar labeled Data VNet. The bar connects to a box labeled Silk DataPod virtual SAN that contains the rest of the components: The upper Scalable performance layer contains five groups labeled Virtual machine c.node # and E64s_v6, numbered 1, 2, 3, 4, and 8, with an ellipsis between #4 and #8. The lower Scalable capacity layer contains two boxes labeled Protected m.node #1 and Protected m.node #4, each containing three groups labeled Virtual machine d.node # and Laos_v4, numbered 1, 2, or 16. Ellipses separate #2 and #16 and separate the #1 and #4 Protected m.node boxes. In the center of the Silk DataPod box a cloud icon labeled iSCSI or NVMe/TCP connects to all the virtual machines in both layers.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-boost-iaas-silk-infra.pptx) of this architecture.*

### Components

- **Silk Flex** is the control plane for deploying and operating the Silk Cloud Data Platform and virtual SAN. In this architecture, Silk Flex provisions, configures, monitors, and scales the Silk environment that supports the operational database and AI inferencing workloads.

- **Silk Echo** extends Silk virtual SAN capabilities by providing real-time access to a dynamic digital twin of production data. Silk Echo creates instantaneous, fully functional clones of databases and datasets by using advanced zero-footprint snapshots. These clones allow intensive AI processes like model inferencing or training to run on fresh production-grade data without affecting the live systems that generate the data.

  Because an Echo copy is fully functional and independent of its source, it can be masked, subsetted, or cleansed before delivery, giving development, test, and AI teams a safe, accurate dataset without exposing production data or waiting for a full copy. Silk Echo can create echoes of SQL or Oracle databases of any size.

- The **Silk virtual SAN** is the software-defined storage cluster that aggregates Azure resources to deliver high-throughput, low-latency storage to your workloads. This layer runs Silk's **Intelligent Data Services**, including:

  - Inline compression and deduplication, which optimize storage utilization.
  - Read caching and tiering, which automatically promote hot data to faster storage tiers.
  - Zero-footprint snapshots, thin views, and clones, which enable instant test/dev copies that consume no added capacity when created and grow only as data diverges.
  - Predictive analytics, proactive performance monitoring, and resource optimization.

- A Silk **DataPod** is the fundamental building block of the Silk virtual SAN, providing the accelerated, persistent data storage location. A DataPod consists of a *scalable performance layer* that contains c.nodes and a *scalable capacity layer* that contains *m.nodes*. Each Silk Data Pod scales from 2–8 c.nodes and 1 to 4 m.nodes, depending on performance and capacity requirements. Each DataPod can support tens of GB/sec of throughput and millions of IOPS. A single DataPod can support one or many VMs.

  - The **scalable performance layer** consists of compute nodes, or c.nodes, that handle I/O requests from database and AI or machine learning workloads. The c.nodes transparently process requests to store or retrieve data, then compress, validate, and distribute the data across the capacity layer.

    The c.nodes are high-performance VMs that appear as virtual volumes to database nodes. In this architecture, the c.nodes accelerate and add extra resilience to the infrastructure's native capabilities, enabling them to support increased demand. In Azure, each c.node is either an E, D, or L-series 64-core VM, depending on the logical capacity the environment requires. The c.nodes run software that Silk provides and can be fully managed in Flex.

  - The **scalable capacity layer** provides elastic storage scaling through data nodes, or d.nodes, where data is persisted using erasure code to automatically provide redundancy and fault tolerance. The d.nodes are inside protected m.nodes, which are logical media groups that manage sets of d.nodes.
  
    In Azure, m.nodes can vary in size from 5 TiB to 120 TiB and contain either 9 or 16 d.nodes. You can move data between m.nodes without disruption to enable migration between different media types, VM shapes, or capacity points (scale-up or down). This design gives you the flexibility to move between infrastructure types and generations without interrupting service.

    Within each m.node, d.nodes form the scalable capacity layer. In Azure, each d.node is either a Premium v2 managed volume or a storage-optimized L-series VM. Individual d.nodes within a set can go offline in case of failure. The data remains intact and available.

- An **Internet Small Computer System Interface (iSCSI) or Non-Volatile Memory Express over Transmission Control Protocol (NVMe/TCP) interface** is the high-speed protocol layer that connects compute workloads, and in this architecture, the operational databases, to the Silk virtual SAN. The iSCSI protocol supports robust compatibility, while NVMe/TCP delivers high performance by minimizing network overhead.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- A Silk DataPod is the fundamental building block of a Silk virtual SAN and deploys within a single zone. Deploy databases and DataPods in the same availability zone to minimize latency and avoid cross-zone data transfer.

- Use database or DataPod replication to provide a second copy of critical data in another Azure zone or region in case of zone or regional failures. You can take Echo copies from the primary or secondary copy of your data to match availability requirements.

- Silk provides two architectural options with different durability, availability, and cost characteristics on Azure. Consider which option, PV2 or VM-based Silk d.nodes, or a mix of both, best fits your requirements.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Azure network security group rules have no measurable performance effect, making them an efficient way to enforce network segmentation and access control. To minimize exposure and adhere to the principle of least privilege, allow communication only on the specific ports and protocols your workload requires. For example, use your network security group rules on the Silk data subnet to allow only iSCSI/NVMe-TCP ports from the database subnet.

- Use caution when implementing packet inspection or deep security techniques, because these additions can introduce significant performance overhead and increased latency in high-throughput environments. For example, don't route your database-to-Silk storage traffic through a firewall or network virtual appliance (NVA).

- Enforce security and compliance by using Azure-native controls, such as managed identities, Azure Key Vault, and role-based access control (RBAC) to ensure enterprise-grade protection for inferencing data and models.

- To encrypt the iSCSI or NVMe/TCP traffic in transit between the database VMs and the Silk c.nodes, enable [Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-overview) on the virtual network that contains the Silk DataPod and the database VMs. Confirm that all VMs in the virtual network run on supported VM sizes, because `AllowUnencrypted` is the only encryption enforcement mode generally available in Azure. Traffic from unsupported VMs continues to flow unencrypted rather than being blocked.

  Virtual Network encryption supports connectivity with Azure Private Link or private endpoints, Application Gateway, Azure Firewall Standard, and Azure ExpressRoute gateways, but traffic to these data paths remains unencrypted. Azure DNS Private Resolver isn't supported. This architecture places the Silk DataPod and database VMs in a dedicated virtual network so that the storage path stays within the encrypted scope.

- Encryption at rest with platform-managed keys is enabled by default on managed disks. Local NVMe on L-series d.nodes is encrypted by default with a unique per-disk key managed by the platform, and is cryptographically erased when the VM is deleted. Customer-managed keys don't apply to local NVMe, so use Premium SSD v2-backed d.nodes if control of the key lifecycle is a hard requirement.

- Use Azure Policy to audit configuration drift, and enable Microsoft Defender for Servers on the database and Defender for Containers on the AKS cluster.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use Azure Advisor recommendations for reserved instances and Azure savings plans.

- Use right-size AKS node pools based on actual utilization.

- Set up autoscaling thresholds to balance performance and cost.

- Use the [Azure pricing calculator](https://azure.com/e/531dbf74c4c24e53ba3b48fc0446a617) to estimate Azure costs for this architecture, not including Silk licensing. This estimate assumes that you use AKS rather than Azure Machine Learning compute.

- Use the [Silk pricing page](https://silk.us/pricing-and-packaging/) to estimate costs for Silk licensing. The licensing model is per-DataPod, meaning you pay for the performance and capacity you provision. Various features and support are included in the license.

#### VM sizing

Azure provides a range of VM families that are suitable for this architecture. Silk makes the following VM size recommendations for inferencing workloads that use the Silk virtual SAN.

| Family | Series | Key advantages | Best for |
| --- | --- | --- | --- |
| General purpose AMD, Intel, Arm | Selected D-series sizes | Higher ratio of cores to RAM memory combined with improved memory bandwidth, Azure Boost-enabled | CPU-only AI inference services, API gateways, midtier Online Transaction Processing (OLTP) databases |
| Memory-optimized AMD, Intel, Arm | E(s) | Excellent price/performance balance for memory-heavy workloads, options for high network throughput | Large relational databases, Oracle or MS SQL analytical workloads, CPU-based inference with large in-memory caches |
| Ultra-memory (In-memory databases) | M(s) | Highest RAM-to-core ratio, enhanced storage and network throughput compared to previous generations, built for massive memory needs | SAP HANA, large Online Analytical Processing (OLAP) Oracle SQL systems, vector databases, large feature stores |
| Storage, I/O optimized | L(s) | Direct-mapped local NVMe storage with extremely low I/O latency, ideal for heavy read/write workloads | High-IOPS databases, TempDB/log volumes, data warehousing, feature extraction scratch space |
| GPU, high-end AI | NCads | NVIDIA GPUs with NVLink (no Infiniband support), AMD Genoa CPUs, extreme parallel compute and bandwidth | Large language model (LLM) training, batch inference, generative AI |
| GPU, cost-efficient | NCasT | NVIDIA T GPUs, excellent cost/performance for smaller AI models and real-time inference, but not Azure Boost-enabled | Real-time classification, recommendation systems, small-to-midscale inference |
| GPU, elastic-fractional | NVads | Fractional GPUs (1/6 to full GPU), highly flexible for right-sized GPU usage, strong graphics, AI blend | Always-on light AI inference, Virtual Desktop Infrastructure (VDI) with AI assist, pre/post-processing pipelines |

- For cost control, match the required number of cores to deliver the required network bandwidth to the Silk DataPod.
- For AI inference, use GPU-enabled NC or NV series for neural workloads or D/E series for CPU-only pipelines.
- For relational databases, use Es/Eas for general workloads and Ms for large memory demands.
- To ensure optimal performance and full utilization of Azure Boost capabilities, confirm that the selected VM size is listed in the [Azure Boost documentation](/azure/azure-boost/overview).

#### Network costs

Data transferred between virtual networks, even within the same region, can incur egress costs that build up significantly in large-scale workloads. To minimize Azure egress charges, design network topologies so that dependent resources reside within the same virtual network. By consolidating workloads and services within a single virtual network where possible, you maintain high performance while avoiding unnecessary outbound data transfer charges.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

For this architecture, use Azure Monitor and Application Insights to collect inference request latency and failures, AKS container logs and metrics, VM guest metrics, and database health. Ingest Silk telemetry where supported, and create alerts and dashboards for inference Service Level Objectives (SLOs), capacity, replication, and storage latency. Use Azure Activity Log separately for control-plane changes.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Latency optimization

Even small delays in data processing or model response can significantly affect real-time decision-making and user experience. Optimize for latency to ensure your AI inferencing delivers fast, accurate responses. Minimizing latency enables AI systems to infer faster, which means they can provide accurate insights or answers immediately. Fast responses are important for applications like conversational AI, autonomous systems, and predictive analytics.

- For the lowest latency, use Azure Boost-enabled VM SKUs, NVMe/TCP protocol instead of iSCSI, same-zone placement, and Silk Echo colocation.

- Use proximity placement groups to improve network latency and performance consistency for VM and containerized deployments. Proximity placement groups are especially important for AI inferencing workloads that need fast communication and high throughput. In this architecture, c.nodes are automatically deployed within a proximity placement group, and you can add the database instances to the same group. Actual improvement depends on VM sizes and region and zone topology, so benchmark the workload before relying on proximity placement groups to meet a latency target.

- Within a Silk virtual SAN, you can use a layer of ephemeral media as a read cache above the durable PV2 or L-series m.node. Where latency is key, the Silk read cache can [reduce transactional latency significantly](https://silk.us/resources/silk-cloud-data-platform-architecture/). Silk's conservative estimate is 50%.

#### Network design

Because the Silk data path uses iSCSI or NVMe/TCP, storage performance in this architecture determines network performance. To improve performance efficiency, explicitly address the network path between the database VMs, the Silk DataPod, and the inference tier.

- If possible, enable Accelerated Networking on every VM in the data path, including the database VMs, the AKS node pools, and the Silk c.nodes and d.nodes. For VMs without Accelerated Networking, the host's virtual switch processes traffic instead of delivering it directly, which adds latency to I/O requests from the database to the Silk DataPod. A single VM without Accelerated Networking in the path can become the bottleneck for the whole pipeline.

- The [Microsoft Azure Network Adapter (MANA)](/azure/virtual-network/accelerated-networking-mana-overview) supports Jumbo frames maximum transmission unit (MTU) of up to 9,000 bytes, compared with the 1,500-byte default. Larger frames reduce the packet count and per-packet processing for large sequential transfers.

  To apply this setting, set the same MTU on both the database VM and Silk node ends of the path, and then confirm the effective value with a path MTU discovery test. For more information, see [Configure Maximum Transmission Unit (MTU) for virtual machines in Azure](/azure/virtual-network/how-to-virtual-machine-mtu).

  Be aware of the following limitations:

  - Larger MTU is supported only for traffic that stays within the virtual network or directly peered virtual networks in the same region, such as the Silk data virtual network in this architecture. Traffic that crosses a gateway or leaves the region must remain at the default frame size.

  - A mismatched MTU causes fragmentation, and Azure doesn't process fragmented packets on the Accelerated Networking fast path. A misconfigured jumbo-frame setup can therefore perform worse than the default, so evaluate your workload's I/O before and after you change the MTU.

## Deploy this scenario

The database VMs and the Silk DataPod need direct network connectivity on the iSCSI or NVMe/TCP ports TCP 3260 and TCP 4420. Deploy them in the same virtual network and in the same availability zone to minimize latency. Silk Flex also needs management-plane connectivity to the Silk nodes it deploys and operates.

The high-level deployment steps are as follows:

1. Get a [Silk Platform license](https://marketplace.microsoft.com/product/silk.silk_cloud_data_platform_saas) through Azure Marketplace.
1. Deploy the [Silk Flex orchestration tool](https://marketplace.microsoft.com/product/silk.silk_cloud_data_platform) from Azure Marketplace into an empty Azure resource group.
1. Create the cluster configuration in Flex and install the Silk license.
1. Use Flex to deploy the Silk DataPod into the required region and availability zone.
1. Create volumes and connect the database host.
1. Onboard the operational database to the Silk virtual SAN.

After the operational database is running on Silk volumes, Silk Echo can clone it for the inference tier without changing the database or the application. For detailed deployment guidance, see the [Silk on Azure deployment overview](https://silk.us/wp-content/uploads/2026/03/Silk-on-Azure-Deployment-Overview.pdf).

### Onboard the operational database to Silk DataPod

Moving a database onto Silk storage is a data migration, not a conversion. To the database VM, a Silk DataPod appears as a set of standard block volumes. The database host connects to the DataPod over iSCSI or NVMe/TCP, and the operating system mounts Silk volumes like any other disk.

- If you're migrating to Azure, restore or replicate your database directly onto Silk volumes, using native tools like backup and restore, log shipping, Oracle Data Guard, or SQL Server Always On availability groups.

- If your database already runs in Azure, present Silk volumes to the database VM alongside the existing storage, then use database tools or host-level copy commands to move the data files, and apply a short cutover process to switch to the new volumes.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Jay Lansdaal](https://www.linkedin.com/in/jelle-jay-lansdaal-bb3250107/) | Sr. Product Manager, Azure Storage
- [Tom O'Neill](https://www.linkedin.com/in/zen10440/) | Silk Vice President, Product

## Next step

> [!div class="nextstepaction"]
> [Deploy Silk through the Azure Marketplace](https://marketplace.microsoft.com/product/silk.silk_cloud_data_platform)

## Related resources

- [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Machine learning operations](/azure/architecture/ai-ml/guide/machine-learning-operations-v2)
