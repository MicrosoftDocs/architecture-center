This article presents an [AKS Hybrid and Edge](/azure/aks-hybrid-edge/aks-overview) deployment pipeline for containerized apps on Azure Kubernetes Service (AKS) enabled by Azure Arc. This *AKS everywhere* solution extends the AKS engine, APIs, and operational model to infrastructure you own or operate. The guidance covers [AKS on Azure Local](/azure/aks/aksarc/aks-overview) and [AKS on bare metal](/azure/aks/aksarc/aks-bare-metal-overview) deployments that use Azure Arc and GitOps. For the latest AKS Hybrid and Edge release information, see [What's new in AKS Hybrid and Edge on Azure Local](/azure/aks/aksarc/aks-whats-new-local). 

> [!NOTE]
> AKS on bare metal is currently in preview. For legal terms that apply to Azure preview features, see the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

> [!NOTE]
> This article's guidance doesn't cover [AKS on Windows Server](/azure/aks/aksarc/overview), which uses a different management model.

## Architecture

:::image type="complex" border="false" source="media/aks-on-hci-architecture-v2.svg" alt-text="Diagram that shows an architecture for AKS clusters that run on on-premises infrastructure." lightbox="media/aks-on-hci-architecture-v2.svg":::
   From upper left to right, step 1 shows an Operator and Azure Local or AKS on bare metal pointing to step 2, AKS Hybrid and Edge, which points to step 3, GitOps configurations, and then to a box that has Flux and Helm controllers. To the right, from an area labeled step 7 and "Flux picks up changes", two arrows point back to the controllers and two arrows point to step 4, a Git repo. At lower right, step 6 shows a Developer and "Application changes", with one arrow pointing up to "Git merge" and then the Git repo, and one arrow labeled "Container image" pointing left to Container Registry, and from there to AKS Hybrid and Edge with an arrow labeled "Container that has a desired state". From the Flux and Helm controller box, one arrow labeled step 5 and "Application deployment" points to "Application v1 (desired state)" and another arrow labeled step 8 and "Application rolling update" points to "Application v2 (new desired state)". An Azure Pipelines bracket encompasses steps 4 and 6.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-on-hci-architecture.vsdx) of this architecture.*

### Workflow

The preceding diagram illustrates an architecture that deploys containerized applications to AKS clusters running on Azure Local or AKS on bare metal Hybrid and Edge infrastructure. This implementation uses GitOps to manage the infrastructure as code (IaC).

1. An operator sets up an on-premises Azure Local or AKS on bare metal infrastructure capable of hosting an AKS cluster.

1. From the Azure portal, an administrator deploys an AKS cluster on that infrastructure.

1. To enable GitOps, the administrator also deploys the Flux extension and its configuration to the AKS cluster.

   GitOps configurations facilitate IaC by representing the desired state of the AKS cluster and using the information that the *local administration* provides. Local administration refers to the management tools, interfaces, and practices that the AKS cluster provides, regardless of the underlying infrastructure.

1. The administrator pushes GitOps configurations to a Git repository, or can also use a Helm or Kustomize repository. The Flux components in the AKS cluster monitor the repository for changes, and detect and apply updates as needed.

1. When repository configurations change, the Flux extension in the AKS cluster receives a notification from the GitOps flow. The Flux controller automatically triggers the desired configuration deployment by using Helm charts or Kustomize.

1. A developer makes application changes and pushes the new or updated configuration or code to the designated repositories. The pipeline builds and pushes the corresponding container image updates to a private or public container registry.

1. The `source-controller` in the AKS cluster detects repository changes, and the `kustomize-controller` or `helm-controller` initiates their deployment to the cluster.

1. The deployment process implements changes in a rolling fashion to ensure minimal downtime and preserve the desired state of the cluster.

### Components

- [AKS Hybrid and Edge](/azure/aks/aksarc/aks-overview) extends the AKS engine, APIs, and operational model to infrastructure you own or operate. In this architecture, an operator creates a Kubernetes cluster on Azure Local or AKS on bare metal and provides application developers with the required level of access to the cluster.

  - [Azure Local](/azure/well-architected/service-guides/azure-local) is a hyperconverged infrastructure solution that you can use to run virtualized and cloud-native workloads on-premises. Azure Local uses a combination of software-defined compute, storage, and networking technologies. It builds on top of Windows Server and integrates with Azure services to provide a hybrid cloud experience. In this architecture, Azure Local is one of the supported infrastructure options that hosts your on-premises workloads.

  - [AKS on bare metal](/azure/aks/aksarc/aks-bare-metal-overview) (preview) is an alternative infrastructure option that runs directly on physical hardware, without the Azure Local hyperconverged and virtualization layers. In its current preview state, AKS on bare metal is restricted to single-node clusters.

- [Azure Arc](/azure/azure-arc/overview) is a hybrid cloud-management solution that you can use to manage servers, Kubernetes clusters, and applications across on-premises, multicloud, and edge environments. Azure Arc provides a unified management experience that lets you govern resources across different environments by using Azure management services like Azure Policy, Microsoft Defender for Cloud, and Azure Monitor.

  In this architecture, Azure Arc enables the operator to use Azure to manage the Kubernetes cluster lifecycle. Azure Arc also allows the application developer to access and remotely connect to the cluster and manage workloads that run on it.

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a continuous integration and continuous delivery (CI/CD) service that automates changes to repositories and registries. In this architecture, the application developer uses Azure Pipelines to build and push images to container registries.

- Public and private container registries like [Azure Container Registry](/azure/container-registry/container-registry-intro) and Docker Hub host container images. You use container development and deployment pipelines to build container images on demand, or to fully automate builds by using triggers such as source code commits and base image updates.

- [GitOps configurations](/azure/azure-arc/kubernetes/conceptual-gitops-flux2) declare the desired state of your Kubernetes clusters. You can use public and private Git, Helm, and Bitbucket repositories to host GitOps configuration files. Azure provides an automated GitOps application deployment capability that works with AKS and Azure Arc-enabled Kubernetes clusters.

- [Flux](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2) is an open-source GitOps deployment tool that Azure Arc-enabled Kubernetes clusters can use to track changes to designated Git, Helm, or Kustomize repositories. If the cluster components detect repository changes, they update the local cluster with those changes. In this architecture, the Flux `source-controller`, `kustomize-controller`, and `helm-controller` review the current cluster configuration periodically or when triggered. If Flux detects differences from the configuration defined in the repository, it remediates them by applying the desired configuration or reapplies it if configuration drift occurs.

## Scenario details

To run containers at scale, you need an orchestrator that automates tasks such as scheduling, deployment, networking, scaling, health checks, and container management. Kubernetes is a commonly used orchestrator for new containerized deployments. As the number of Kubernetes clusters and environments grows, managing them individually becomes difficult. Azure Arc-enabled services like Azure Arc-enabled Kubernetes, GitOps, Azure Monitor, and Azure Policy reduce the administrative burden and help solve this challenge.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The Well-Architected Framework provides guiding principles that help with assessing and optimizing the benefits of cloud-based solutions. On-premises AKS deployments are tightly integrated with Azure technologies, so it's essential to align your GitOps design and implementation with established framework recommendations.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

 - **Configure Kubernetes' high-availability features.** High availability isn't automatic and it requires explicit configuration, such as running multiple replicas across nodes or availability zones. On Azure Local, you can spread replicas across the cluster's physical nodes or rack-aware zones to protect against a host failure. AKS on bare metal preview supports only single-node clusters, so extra replicas within that cluster don't protect against a host outage. Design application-level redundancy outside the cluster, or accept the single-host availability risk until multinode bare-metal clusters are supported.

- **Use Flux v2** to increase application availability in deployments that span multiple locations or clusters.

- **Use automated deployments** to reduce the possibility of human errors.

- **Integrate a CI/CD pipeline** into your architecture to improve the effectiveness of automated testing.

- **Track all code changes** so you can quickly identify and resolve problems. To track operational changes, enforce policies, and automate approval workflows, use built-in GitHub or Azure DevOps capabilities. This approach ensures that your changes are consistently tracked, properly reviewed, and maintainable over time.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **Understand the security benefits of the architecture.** Flux v2, Kustomize, GitOps, and DevOps pipelines apply operational changes through automation. You can control and audit the code that implements these practices by using mechanisms like branch protection, pull request reviews, and immutable history. The IaC approach removes the need to manage permissions for accessing the infrastructure and supports the principle of least privilege. Flux makes it easier to manage multitenant setups by supporting namespace-based configuration scoping.

- **Understand encryption.** To help ensure data security, the cluster configuration service stores the Flux configuration resource data in an Azure Cosmos DB database and encrypts it at rest.

#### Use Azure Policy and Azure Arc

Azure Arc extends resource management scope beyond Azure. This expanded scope provides a range of benefits that apply to physical and virtual servers, including the following capabilities in an AKS context:

- **Governance:** Azure Arc enforces runtime governance for AKS clusters and their pods by using Azure Policy for Kubernetes and providing centralized policy compliance reports. You can use this capability to enforce using HTTPS for Kubernetes cluster ingress traffic or to restrict containers to listening only on designated ports.

- **Improved operations:** Azure Arc provides enhanced support for automated cluster configuration via GitOps.

Azure Policy facilitates centralized GitOps management via the built-in *Deploy GitOps to Kubernetes cluster* policy definition. After you assign this policy, your selected GitOps-based configuration automatically takes effect on the Azure Arc-enabled Kubernetes clusters you designate. The policy applies only if the clusters' Azure Resource Manager resources are within the scope of the assignment.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Use GitOps automation to minimize your management and maintenance overhead.** This simplified operational model requires less effort to maintain and results in reduced operational costs.

- **Use built-in cluster autoscaling on Azure Local** to adjust worker-node virtual machine (VM) counts within your available Azure Local cluster capacity and take advantage of the increased workload density inherent to containerization. This node-level autoscaling doesn't scale the underlying physical hosts. Use the sizing guidance in [Performance Efficiency](#performance-efficiency) to plan host and cluster capacity.

  Enabling the autoscaler limits an Azure Local instance to 12 AKS clusters rather than the usual 32 clusters. For the current limit, see [scale requirements for AKS on Azure Local](/azure/aks/aksarc/scale-requirements#scale-requirements-when-using-autoscaler-with-aks-on-azure-local). AKS on bare metal currently supports single-node clusters, so plan capacity for that single host instead of relying on autoscaling.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Use GitOps repositories** to provide a single source of truth that stores all AKS application and cluster infrastructure data. These repositories can serve as the only component that applies changes to the cluster.

- **Use GitOps integration with a DevOps infrastructure approach** to shorten the time to deliver new software releases. Use Resource Manager and Azure Arc to build a consistent operational model for cloud-based and on-premises containerized workloads. To control GitOps configurations at different levels, use Azure Policy along with Flux controller capabilities. You can use this approach to establish control at the enterprise or individual AKS cluster level, or to control specific namespaces within a cluster.

  - **Scope GitOps configurations to a cluster or multiple clusters** to implement a baseline for containerized infrastructure components like ingress controllers, service meshes, security products, and monitoring solutions. This approach helps ensure that your clusters satisfy the baseline infrastructure requirements.

  - **Create namespace-level GitOps configurations** for more granular control of workload resources like pods, services, and ingress routes. This level of control helps ensure that your workloads conform to application standards, and that deploying and managing your AKS enabled by Azure Arc applications remains efficient, effective, and cost effective.

#### Use GitOps

GitOps is well suited to managing AKS clusters because Kubernetes is based on a declarative model, where code defines the cluster state and its components. GitOps stores this code in a Git repository and uses it to specify the desired state of the target environment.

Code changes are subject to version control, auditing, and optionally to reviews and approvals. These reviews and approvals can automatically trigger updates to the AKS infrastructure and containerized workloads. GitOps uses a pull model, where a specialized set of cluster components polls the repository to check its status. When it detects a change, an AKS-hosted GitOps component retrieves and applies the updated configuration.

GitOps significantly reduces the need for direct cluster management, resulting in a simplified operational model and increased security. GitOps supports the principle of least privilege. For example, GitOps removes the need to modify clusters manually via kubectl, so fewer privileges are required. GitOps also provides early feedback about proposed policy changes. Early feedback is especially valuable because it helps developers reduce the risk and costs associated with bugs.

GitOps simplifies the process of standardizing cluster configurations across your organization to meet compliance and governance requirements. You can define a baseline configuration, such as network policies, role bindings, and Pod Security Admission or Azure Policy for Kubernetes settings, to apply to every cluster and its components. To apply that configuration across all Azure Arc-enabled clusters, use Azure Policy to target resource groups or subscriptions. The policies apply automatically to existing resources and to resources created after the policy assignment.

GitOps links your cluster to one or more Git repositories, each of which can describe different aspects of cluster configuration. This declarative model facilitates automation for provisioning and managing Kubernetes resources, like namespaces and deployments, through their manifest files. You can also use Helm charts with Flux v2 and Kustomize to automate deployment of containerized applications, or use Kustomize files that describe environment-specific changes.

#### Use Flux

Flux functions as a Kubernetes operator that uses a set of controllers and corresponding declarative APIs. The controllers manage a set of custom resources that work together to provide the intended functionality.

You enable GitOps in an Azure Arc-enabled Kubernetes cluster as a `Microsoft.KubernetesConfiguration/extensions/microsoft.flux` cluster extension. After you install the cluster extension, you can create one or more `fluxConfigurations` resources that synchronize the content of configuration sources to the cluster and reconcile the cluster to a desired state.

By default, the `microsoft.flux` extension installs the Source, Kustomize, Helm, and Notification Flux controllers, the FluxConfig custom resource definitions (CRD), `fluxconfig-agent`, and `fluxconfig-controller`. You can choose which of these controllers to install, and can optionally install the Flux `image-automation` and `image-reflector` controllers, which facilitate updating and retrieving Docker images.

A `fluxConfigurations` resource uses the values you supply for the parameters, like the target Git repository, to create and configure the Kubernetes objects that enable the GitOps functionality on the cluster.

The Flux v2 cluster extensions provide the following components and functionalities:

| Component | Functionality |
|-|-|
|`source-controller` | Monitors sources of custom configurations, such as Git repositories, Helm repositories, and cloud storage services like S3 buckets, and synchronizes and authorizes against these sources |
|`kustomize-controller` | Monitors custom resources that are based on Kustomization CRDs, which contain Kubernetes manifests and raw YAML files, and applies the manifests and YAML files to the cluster |
|`helm-controller` | Monitors custom resources that are based on charts and stored in Helm repositories that `source-controller` surfaces |
|`notification-controller` | Manages inbound events that originate from a Git repository, and outbound events like those that target Microsoft Teams or Slack |
|`FluxConfig CRD` | Represents custom resources that define Flux-specific Kubernetes objects |
|`fluxconfig-agent` | Detects new and updated Flux configuration resources, initiates the corresponding configuration updates on the cluster, and communicates status changes to Azure |
|`fluxconfig-controller` | Monitors `fluxconfigs` custom resources |

Flux provides the following features:

| Category | Feature |
|-|-|
| Infrastructure and workload management | - Deployment dependency management <br> - Integration with Kubernetes role-based access control <br> - Health assessments for clusters and their workloads <br> - Automated container image updates to Git, including image scanning and patching <br> - Interoperability with cluster API providers |
| Security and governance | - Alerting to external systems via webhook senders <br> - Policy-driven validation, including support for Open Policy Agent Gatekeeper <br> - Container image scanning and patching |
| Integration with other GitOps flows | - Integration with a range of Git providers, including GitHub, GitLab, and Bitbucket <br> - Interoperability with workflow providers, including GitHub Actions |

For more information, see [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Cluster workloads benefit from the scalability and agility inherent to the Kubernetes platform. Flux v2 provides more agility, which reduces the time required for end-to-end software delivery. To improve performance efficiency for this architecture:

- **Optimize Kubernetes cluster and infrastructure setup** for your specific workloads. Work with the application developer to determine the required settings.

- **Use the Kubernetes cluster autoscaler feature** to adjust worker-node VM counts within your Azure Local host's available capacity. For more information, see [Use a cluster autoscaler on an AKS enabled by Azure Arc cluster](/azure/aks/aksarc/auto-scale-aks-arc). AKS on bare metal currently supports only single-node clusters, so size that host for peak demand instead of relying on the cluster autoscaler.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paramesh Babu](https://www.linkedin.com/in/parameshbabu/) | Principal Program Manager
- [Sarah Cooley](https://www.linkedin.com/in/cooleys/) | Principal Program Manager
- [Mike Kostersitz](https://www.linkedin.com/in/mikekostersitz/) | Principal Program Manager Lead

Other contributors:

- [Nate Waters](https://www.linkedin.com/in/nate-waters/) | Product Marketing Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy a Kubernetes cluster by using the Azure portal](/azure/aks-hybrid-edge/local/aks-create-clusters-portal)
- [Deploy a Kubernetes cluster using an Azure Resource Manager template](/azure/aks-hybrid-edge/local/resource-manager-quickstart)
- [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2)
- [Tutorial: Deploy applications by using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Tutorial: Implement CI/CD with GitOps (Flux v2)](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd)

## Related resources

- [AKS on Azure Local baseline architecture](aks-baseline.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
