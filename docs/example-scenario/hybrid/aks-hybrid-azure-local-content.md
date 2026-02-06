This article provides recommendations for building an app deployment pipeline for containerized apps on Azure Kubernetes Service (AKS) enabled by Azure Arc. The apps can run on Azure Local. The guidance is specifically for deployments that use Azure Arc and GitOps.

> [!IMPORTANT]
> The information in this article applies to [AKS on Azure Local, version 23H2 (latest version)](/azure/aks/aksarc/aks-whats-new-23h2).

## Architecture

:::image type="complex" border="false" source="media/aks-on-hci-architecture-v2.svg" alt-text="Diagram that shows an architecture for AKS clusters that run on Azure Local." lightbox="media/aks-on-hci-architecture-v2.svg":::
   The image shows a workflow. An arrow points from the operator to Azure Local. An arrow points from Azure Local to AKS enabled by Azure Arc, from AKS enabled by Azure Arc to GitOps configurations, and then from GitOps configurations to the Flux operator and Helm operator section. Two arrows point from the section that reads Flux picks up changes to the Flux operator and Helm operator section. Two arrows point from the Flux picks up changes section to the Git repo. A curved bracket that represents Azure Pipelines includes most of the image. Two more arrows point from the Flux operator and Helm operator section. One arrow is labeled Application rolling update and the other arrow is labeled Application deployment. An arrow that represents container images being built and published to the container registry points from the application changes section to the Container Registry icon. An arrow points from the developer icon to the Application changes section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-on-hci-architecture.vsdx) of this architecture.*

### Workflow

The architecture illustrates an implementation that deploys containerized applications on AKS clusters that run on Azure Local. It uses GitOps to manage the infrastructure as code (IaC).

The following workflow corresponds to the previous diagram:

1. An operator sets up an on-premises infrastructure on Azure Local hardware that's capable of hosting an AKS cluster.

1. From the Azure portal, an administrator of an Azure Local instance deploys an AKS cluster on Azure Local.

1. To enable GitOps, the administrator also deploys the Flux extension and its configuration to the AKS cluster. GitOps configurations facilitate IaC because they represent the desired state of the AKS cluster and use the information that the local administration provides. The *local administration* refers to the management tools, interfaces, and practices that the AKS cluster that's deployed on Azure Local provides.

1. The administrator pushes GitOps configurations to a Git repository. You can also use a Helm or Kustomize repository. The Flux components in the AKS cluster monitor the repository for changes. They also detect and apply updates as needed.

1. The Flux extension in the AKS cluster receives a notification from the GitOps flow when changes are made to the configurations in the repositories. It automatically triggers deployment of the desired configuration by using Helm charts or Kustomize.

1. Application changes in the form of new or updated configuration or code are pushed to the designated repositories, including corresponding container image updates. These container image updates are pushed to private or public container registries.

1. The Flux operator in the AKS cluster detects changes in the repositories and initiates their deployment to the cluster.

1. Changes are implemented in a rolling fashion on the cluster to ensure minimal downtime and preserve the desired state of the cluster.

### Components

- [Azure Local](/azure/well-architected/service-guides/azure-local) is a hyperconverged infrastructure solution that you can use to run virtualized and cloud-native workloads on-premises. It uses a combination of software-defined compute, storage, and networking technologies. It builds on top of Windows Server and integrates with Azure services to provide a hybrid cloud experience. In this architecture, Azure Local is the infrastructure that hosts your infrastructure on-premises workloads.

- [AKS on Azure Local](/azure/aks/aksarc/aks-overview) is the managed Kubernetes platform from Microsoft. It enables developers and administrators to use AKS to deploy and manage containerized apps on Azure Local. In this architecture, an operator creates a Kubernetes cluster on an Azure Local instance and provides application developers with the required level of access to this cluster.

- [Azure Arc](/azure/azure-arc/overview) is a hybrid cloud-management solution that you can use to manage servers, Kubernetes clusters, and applications across on-premises, multicloud, and edge environments. It provides a unified management experience by enabling you to govern resources across different environments by using Azure management services like Azure Policy, Microsoft Defender for Cloud, and Azure Monitor. In this architecture, Azure Arc enables the operator to manage the life cycle of the Kubernetes cluster by using Azure. It also enables the application developer to access the cluster, remotely connect to the cluster, and manage workloads that run on the cluster.

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a continuous integration and continuous delivery (CI/CD) service that automates updates to repositories and registries. In this architecture, an application developer uses Azure pipelines to build and push images to container registries like Docker Hub and Azure Container Registry.

- Both public and private container registries, including [Container Registry](/azure/container-registry/container-registry-intro) and Docker Hub, host container images. Container registries are used with your existing container development and deployment pipelines to build container images on demand or fully automate builds by using triggers such as source code commits and base image updates.

- Azure provides an automated application deployments capability by using GitOps that works with AKS and Azure Arc-enabled Kubernetes clusters. Use GitOps to declare the desired state of your Kubernetes clusters in files in Git repositories. Both public and private Git, Helm, and Bitbucket repositories can host [GitOps configurations](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

- [Flux](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2) is an open-source GitOps deployment tool that Azure Arc-enabled Kubernetes clusters can use to implement cluster components that track changes to your designated Git, Helm, or Kustomize repositories. If changes are detected, the cluster components update the local cluster with those changes. In this architecture, the Flux operator periodically, or when triggered, reviews the current cluster configuration to ensure that it matches the configuration defined in the repository. If Flux detects differences, it remediates them by applying the desired configuration or reapplying the desired configuration if configuration drift occurs.

## Scenario details

To run containers at scale, you need an orchestrator that automates tasks such as scheduling, deployment, networking, scaling, health checks, and container management. Kubernetes is a commonly used orchestrator for new containerized deployments. As the number of Kubernetes clusters and environments grows, managing them individually becomes difficult. Azure Arc-enabled services like Azure Arc-enabled Kubernetes, GitOps, Azure Monitor, and Azure Policy reduce the administrative burden and help solve this challenge.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The Well-Architected Framework provides guiding principles that help with assessing and optimizing the benefits of cloud-based solutions. On-premises AKS deployments are tightly integrated with Azure technologies, which makes it essential to align your GitOps design and implementation with established framework recommendations.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Use the high-availability features of Kubernetes** to ensure high reliability in GitOps-based solutions.

- **Use Flux v2** to increase application availability in deployments that span multiple locations or clusters.

- **Use automated deployments** to reduce the possibility of human errors.

- **Integrate a CI/CD pipeline** into your architecture to improve the effectiveness of automated testing.

- **Track all code changes** so that you can quickly identify and resolve problems. To track these operational changes, use the built-in capabilities of GitHub or Azure DevOps. You can use these tools to enforce policies and automate approval workflows. This approach ensures that your changes are consistently tracked, properly reviewed, and remain maintainable over time.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **Understand the security benefits of the architecture.** By using Flux v2, Kustomize, GitOps, and DevOps pipelines, operational changes are applied via automation. You can control and audit the code that implements these operational practices by taking advantage of mechanisms like branch protection, pull request reviews, and immutable history. The IaC approach removes the need to manage permissions for accessing the infrastructure and supports the principle of least privilege. Flux makes it easier to manage multitenant setups by supporting namespace-based configuration scoping.

- **Understand encryption.** To help ensure data security, the cluster configuration service stores the Flux configuration resource data in an Azure Cosmos DB database and encrypts it at rest.

#### Use Azure policies and Azure Arc

Azure Arc extends the scope of resource management beyond Azure. This expanded scope provides a range of benefits that apply to physical and virtual servers. In the context of AKS, these benefits include the following Azure Arc capabilities:

- **Governance:** Azure Arc enforces runtime governance for AKS clusters and their pods by using Azure Policy for Kubernetes and providing centralized reports on policy compliance. You can use this capability to enforce the use of HTTPS for ingress traffic directed at the Kubernetes cluster or to restrict containers to listening on only the specific ports that you designate.

- **Improved operations:** Azure Arc provides enhanced support for automated cluster configuration via GitOps.

Azure Policy facilitates centralized GitOps management via the built-in *Deploy GitOps to Kubernetes cluster* policy definition. After you assign this policy, it automatically applies your selected GitOps-based configuration to the Azure Arc-enabled Kubernetes clusters that you designate. The policy only applies if the clusters' Azure Resource Manager resources are within the scope of the assignment.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Use the automation** that GitOps provides to minimize your management and maintenance overhead. This simplified operational model requires less effort to maintain and results in reduced operational costs.

- **Use AKS on Azure Local** to take advantage of built-in support for autoscaling compute resources and the increased workload density that's inherent to containerization. Autoscaling enables you to right-size your physical infrastructure and accelerate datacenter consolidation initiatives, which can reduce costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Use GitOps repositories** to provide a single source of truth that stores all AKS application and cluster infrastructure data. These repositories can serve as the only component that applies changes to the cluster.

- **Take advantage of the GitOps integration with the DevOps approach to infrastructure** to shorten the time required to deliver new software releases. We also recommend that you use Resource Manager and Azure Arc to build a consistent operational model for cloud-based and on-premises containerized workloads. To control GitOps configurations at different levels, use Azure Policy together with the capabilities of Flux operators. You can use this approach to establish control at the enterprise level, at the level of an individual AKS cluster, or at the level of specific namespaces within a cluster.

- **Create GitOps configurations that are scoped to a cluster**, or to multiple clusters, to implement a baseline for components of the containerized infrastructure, like ingress controllers, service meshes, security products, and monitoring solutions. This approach can help ensure that your clusters satisfy the baseline infrastructure requirements.

- **Create namespace-level GitOps configurations** to control your workload resources, such as pods, services, and ingress routes, at a more granular level. This level of control helps ensure that your workloads conform to application standards. By following these guidelines, you can ensure that your deployment and management of AKS enabled by Azure Arc applications remain efficient, effective, and cost effective.

#### Use GitOps

GitOps is well suited for managing AKS clusters. Kubernetes is based on a declarative model, where the cluster state and its components are defined in code. GitOps stores this code in a Git repository and uses it to specify the desired state of the target environment.

Code changes are subject to version control, auditing, and optional reviews and approvals. These reviews and approvals can automatically trigger updates to the AKS infrastructure and containerized workloads. GitOps uses a pull model, where a specialized set of cluster components polls the repository to check its status. When it detects a change, an AKS-hosted GitOps component retrieves and applies the updated configuration.

GitOps significantly minimizes the need for direct cluster management, which results in a simplified operational model and increased security. GitOps supports the principle of least privilege. For example, GitOps removes the need to modify clusters manually via kubectl, so fewer privileges are required. GitOps also provides early feedback about proposed policy changes. Early feedback is especially valuable to developers because it helps them reduce the risk and costs that are associated with bugs.

GitOps simplifies the process of standardizing cluster configurations across your organization to meet compliance and governance requirements. You can define a baseline configuration to apply to every cluster and its components, such as network policies, role bindings, and pod security policies. To apply that configuration across all Azure Arc-enabled clusters, use Azure Policy by targeting resource groups or subscriptions. These policies apply automatically to existing resources and to resources created after the policy assignment.

GitOps links your cluster to one or more Git repositories. Each repository can describe different aspects of cluster configuration. This declarative model facilitates automation for provisioning and managing Kubernetes resources, such as namespaces and deployments, through their manifest files. You can also use Helm charts together with Flux v2 and Kustomize to automate deployment of containerized applications, or use Kustomize files that describe environment-specific changes.

#### Use Flux

Flux functions as a Kubernetes operator. It uses a set of controllers and corresponding declarative APIs. The controllers manage a set of custom resources that work together to provide the intended functionality.

GitOps is enabled in an Azure Arc-enabled Kubernetes cluster as a `Microsoft.KubernetesConfiguration/extensions/microsoft.flux` cluster extension. After you install the `microsoft.flux` cluster extension, you can create one or more `fluxConfigurations` resources that synchronize the content of configuration sources to the cluster and reconcile the cluster to a desired state.

By default, the `microsoft.flux` extension installs the Flux controllers (Source, Kustomize, Helm, and Notification) and FluxConfig custom resource definitions (CRD), `fluxconfig-agent`, and `fluxconfig-controller`. You can also choose which of these controllers you want to install and can optionally install the Flux `image-automation` and `image-reflector` controllers, which facilitate updating and retrieving Docker images.

When you create a `fluxConfigurations` resource, the values you supply for the parameters, like the target Git repository, are used to create and configure the Kubernetes objects that enable the GitOps functionality on the cluster.

When you deploy and configure Flux v2 cluster extensions, they provide the following components and functionalities:

- **`source-controller`** monitors sources of custom configurations, such as Git repositories, Helm repositories, and cloud storage services like S3 buckets, and synchronizes and authorizes against these sources.

- **`kustomize-controller`** monitors custom resources that are based on Kustomization CRDs, which contain Kubernetes manifests and raw YAML files. `kustomize-controller` applies the manifests and YAML files to the cluster.

- **`helm-controller`** monitors custom resources that are based on charts and stored in Helm repositories that `source-controller` surfaces.

- **`notification-controller`** manages inbound events that originate from a Git repository and outbound events, like those that target Microsoft Teams or Slack.

- **`FluxConfig CRD`** represents custom resources that define Flux-specific Kubernetes objects.

- **`fluxconfig-agent`** detects new and updated Flux configuration resources. `fluxconfig-agent` initiates the corresponding configuration updates on the cluster and communicates status changes to Azure.

- **`fluxconfig-controller`** monitors `fluxconfigs` custom resources.

Flux provides the following features:

| Category | Feature |
|-|-|
| **Infrastructure and workload management** | Deployment dependency management |
|| Integration with Kubernetes role-based access control |
|| Health assessments for clusters and their workloads |
|| Automated container image updates to Git, including image scanning and patching |
|| Interoperability with cluster API providers |
|**Security and governance** | Alerting to external systems via webhook senders |
|| Policy-driven validation, including support for Open Policy Agent Gatekeeper |
|| Container image scanning and patching |
|| Alerting to external systems (via webhook senders) |
|**Integration with other GitOps flows** | Integration with a range of Git providers, including GitHub, GitLab, and Bitbucket |
|| Interoperability with workflow providers, including GitHub Actions |

For more information, see [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Cluster workloads benefit from the scalability and agility that's inherent to the Kubernetes platform. Flux v2 provides more agility, which reduces the time required for end-to-end software delivery.

- **Optimize your Kubernetes cluster and infrastructure setup** for your specific workloads. We recommend that you work with the application developer to determine the required settings.

- **Use the autoscaling feature** in Kubernetes. For more information, see [Use a cluster autoscaler on an AKS enabled by Azure Arc cluster](/azure/aks/aksarc/auto-scale-aks-arc).

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

- [Deploy a Kubernetes cluster by using the Azure portal](/azure/aks/aksarc/aks-create-clusters-portal) or [by using Azure Resource Manager template](/azure/aks/aksarc/resource-manager-quickstart)
- [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2)
- [Tutorial: Deploy applications by using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Tutorial: Implement CI/CD with GitOps (Flux v2)](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd)
- [Quickstart - Jumpstart HCIBox](https://techcommunity.microsoft.com/blog/azurearcblog/announcing-jumpstart-hcibox/3647646)

## Related resources

- [Baseline architecture for AKS on Azure Local](../../example-scenario/hybrid/aks-baseline.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
