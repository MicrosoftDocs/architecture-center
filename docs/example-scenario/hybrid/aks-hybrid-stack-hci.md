This article provides recommendations for building an app deployment pipeline for containerized apps running on Azure Kubernetes Service hybrid deployment options on Azure Stack HCI/Windows Server. Specifically, the guidance is for deployments using Azure Arc and GitOps.

Running containers at scale requires an orchestrator to automate scheduling, deployment, networking, scaling, health monitoring, and container management. Kubernetes is the de facto standard orchestrator for new containerized deployments. As the number of Kubernetes cluster and environments grow, managing these individually can become a challenge. Using Azure Arc-enabled services such as Arc enabled Kubernetes, GitOps, Monitor, Policy reduces the administrative burden and helps address this challenge.

## Architecture 

image
 
link

### Workflow

The architecture illustrates an implementation that deploys containerized applications on Azure Kubernetes Service (AKS) hybrid clusters running on Azure Stack HCI or Windows Server infrastructure. It uses GitOps to manage the infrastructure-as-code (IaC).

1.	An operator sets up an on-premises infrastructure using Azure Stack HCI or Windows Server hardware capable of hosting an AKS hybrid cluster.
2.	On-premises, the administrator deploys an AKS hybrid cluster on the Azure Stack HCI or Windows Server infrastructure and connects the AKS hybrid cluster to Azure using Azure Arc. To enable GitOps, the administrator also deploys the Flux extension and its configuration to the AKS hybrid cluster.
3.	GitOps configurations facilitate infrastructure as code. These GitOps configurations represent the desired state of the AKS hybrid cluster and use the information provided by the local administration experience. The local administration experience refers to the management tools, interfaces, and practices that are provided by the AKS hybrid cluster deployed on Azure Stack HCI or Windows Server infrastructure.
4.	The administrator pushes GitOps configurations to a Git repository. You can also use Helm, or Kustomize    repositories. The Flux components in the AKS hybrid cluster monitor these repositories for changes, detecting and applying updates as needed.
5.	The Flux extension in the AKS hybrid cluster receives a notification when changes to the desired configuration happen in the repo(s), from the GitOps flow and automatically triggers deployment of the desired  configuration using Helm charts and Kustomize.
6.	Application changes in the form of new or updated configuration or code    are pushed to the designated repositories, including corresponding container image updates. These container  image updates are pushed to private or public container registries.
7.	The Flux operator in the AKS hybrid cluster detects changes in the repositories and initiates their deployment to the cluster.
8.	Changes are implemented in a rolling fashion on the cluster, ensuring minimal downtime and preserving the desired state of the cluster.

### Components

- Azure Stack HCI is a hyper-converged infrastructure (HCI) solution from Microsoft that enables customers to run virtualized workloads on-premises, using a combination of software-defined compute, storage, and networking technologies. It is built on top of Windows Server and integrates with Azure services, providing a hybrid cloud experience for customers.
- AKS on Azure Stack HCI enables developers and admins deploy and manage containerized apps with Azure Kubernetes Service (AKS) on Azure Stack HCI. Customers can advantage of consistency with AKS on Azure, extend to Azure with hybrid capabilities, run apps with confidence with built-in security, and use familiar tools to modernize Windows apps. 
- Azure Arc is a hybrid cloud management solution from Microsoft that allows customers to manage servers, Kubernetes clusters, and applications across on-premises, multi-cloud, and edge environments. It provides a unified management experience by allowing users to govern resources across different environments using Azure management services such as Azure Policy, Azure Security Center, and Azure Monitor.
- Git/Helm/Bucket repositories (public and private) are for hosting GitOps configurations, including Azure DevOps and GitHub repos.
- Container registry (public and private) hosts container images, including Azure Container Registry and Docker Hub.
- [Azure Pipelines is a continuous integration (CI) and continuous deployment (CD) service that automates updates to repositories and registries.    
- Flux is an open source GitOps deployment tool that Arc¬¬–enabled Kubernetes clusters can use. You can use the Azure Arc connection to implement the cluster components responsible for tracking changes to the Git, Helm, or Kustomize repositories you designate and applying them to the local    cluster. The Flux operator periodically (or based on a trigger) reviews the existing cluster configuration to ensure that it matches the one residing in the Git repository. In case differences are detected, Flux remediates them by applying or (in case of a configuration drift) reapplying the desired configuration.  

## Considerations

Considering the inherent integration of on-premises AKS deployments with Azure-based technologies, it’s suitable to review design and implementation aspects of GitOps in terms of Azure Well-Architected Framework (WAF). The framework offers guiding principles that help with assessing and optimizing the benefits of cloud-based solutions.

### Reliability

**Use high-availability features in Kubernetes.** To ensure high reliability in GitOps-based solutions, you should use the inherent high-availability features of the Kubernetes platform.

**Use Flux v2.** You should use Flux v2 to further increase application availability in deployments that span multiple locations or clusters.
Use automated deployments. Reduce the possibility of human error by making use of automated deployments.

**Use CI/CD pipeline.** You should integrate a CI/CD pipeline into your architecture to improve the effectiveness of automated testing.

**Track all code changes.** You need to ensure that you track all operational changes so that you can identify and resolve issues quickly. To do this use the built-in cap  abilities in GitHub or Azure DevOps. These tools allow implementation of policies and automations to make sure changes are tracked, follow the appropriate approval process and are maintainable.

### Cost optimization

**Use automation.** You should take advantage of the automation that GitOps promotes to minimize your management and maintenance overhead. By doing so, you can take advantage of a simplified operational model that requires less effort to maintain and results in reduced operational cost. 

**Use AKS hybrid.** AKS hybrid offers built-in support for autoscaling its computing resources and increased workload density that is inherent to containerization. This can help you to right-size your physical infrastructure and accelerate data center consolidation initiatives. These actions translate into infrastructure cost savings. 

### Operational excellence

You should leverage GitOps repositories to provide a single source of truth that stores all AKS application and cluster infrastructure data, and which can serve as the only component that applies changes to the cluster. 

Additionally, it is recommended that you take advantage of GitOps' seamless integration with the DevOps approach to infrastructure thereby shorten the time required to deliver new software releases. Furthermore, it is suggested that you make use of Azure Resource Manager and Azure Arc to build a consistent operational model for cloud-based and on-premises containerized workloads. To control GitOps configurations at different levels, you should work with Azure Policy combined with the capabilities of Flux operators. This makes it possible to do so at the enterprise-wide level, at the level of an individual AKS cluster, or even at the level of specific namespaces within that cluster. 

You should also create GitOps configurations that are scoped to a cluster (or multiple clusters) to implement a baseline for components of the containerized infrastructure, such as ingress controllers, service meshes, security products, or monitoring solutions. This will help you to ensure that your clusters satisfy the baseline infrastructure requirements. 

Finally, it is recommended that you create namespace-level GitOps configurations that can allow you to control the resources of your workloads at a more granular level (e.g., pods, services, and ingress routes), and thus ensure that your workloads conform to the application standards. By following these guidelines, you can ensure that your deployment and management of AKS hybrid applications remain efficient, cost-effective, and effective.

#### Use GitOps

GitOps is a great match for the management of AKS clusters. Kubernetes is based on the declarative model, the cluster state and its components are described in code. GitOps uses a Git repository to store that code and uses it to define the desired state of the target environment. 

Code changes are subject to version control and auditing, and optional reviews and approvals. Reviews and approvals can be used to automatically trigger updates of the AKS infrastructure and containerized workloads. GitOps uses a pull model, in which a specialized set of cluster components polls the status of the repository. When a change is detected, AKS-hosted GitOps component retrieves and applies the new configuration. 

GitOps significantly minimizes the need for direct cluster management, resulting not only in a simplified operational model, but also increased security. GitOps supports the principle of least privilege. For example, GitOps removes the need for ops users to modify their clusters manually (kubeclt), requiring less privileges. GitOps also provides early feedback about proposed policy changes. Early feedback is particularly valuable to developers, helping with reducing the risk and costs associated with bugs.

GitOps simplifies standardizing cluster configurations across your organization to meet compliance and governance requirements. You can define a baseline configuration that you want to apply to every cluster and its components, including, for example, network policies, role bindings, and pod security policies. To implement that configuration across all Azure Arc¬¬–enabled clusters, you can use Azure Policy, targeting resource groups or subscriptions. Such a policy applies automatically not only to the existing resources but also to those created after the policy assignment.

GitOps links your cluster with one or more Git repositories, where each of them can be used to describe different aspects of cluster configuration. The resulting declarative model facilitates automating provisioning and management of such Kubernetes resources as namespaces or deployments by using their respective manifest files. It’s also possible to use Helm charts, which in combination with Flux v2 and Kustomize, facilitate the automated deployment of containerized applications, or Kustomize files that describe environment-specific changes.

#### Use Flux

Flux is implemented as a Kubernetes operator, combining a set of controllers and the corresponding declarative APIs. The controllers manage a set of custom resources that work collectively to deliver the intended functionality.

GitOps is enabled in an Azure Arc¬¬–enabled Kubernetes cluster as a `Microsoft.KubernetesConfiguration/extensions/microsoft.flux` cluster extension. After the `microsoft.flux` cluster extension is installed, you can create one or more `fluxConfigurations` resources that sync the content of configuration sources to the cluster and reconcile the cluster to the desired state. 

By default, the microsoft.flux extension installs the Flux controllers (Source, Kustomize, Helm, and Notification) and the FluxConfig Custom Resource Definitions (CRD), fluxconfig-agent, and fluxconfig-controller. You can also choose which of these controllers you want to be installed and can optionally install the Flux image-automation and image-reflector controllers, which facilitate updating and retrieving Docker images.

When you create a `fluxConfigurations` resource, the values you supply for the parameters, such as the target Git repository, are used to create and configure the Kubernetes objects that enable the GitOps functionality on that cluster.

When you deploy and configure Flux (v2) cluster extensions it will provide the following components and functionality. 

- **Source-controller.** Monitors sources of custom configurations (such as Git repositories, Helm repositories, cloud storage services, such as S3 buckets and synchronizes and authorizes against these configuration sources.
- **Kustomize-controller.** Monitors custom resources based on Kustomization CRDs, which contain Kubernetes manifests and raw YAML files and applies them to the cluster.
- **Helm-controller.** Monitors custom resources based on charts stored in Helm repositories surfaced by the source-controller.
- **Notification-controller.** Specializes in managing inbound (originating from a Git repository) and outbound (such as targeting Teams or Slack) events.
- **fluxconfigs-CRD.** Represents custom resources that define Flux-specific Kubernetes objects.
- **fluxconfig-agent.** Detects new and updated flux configuration resources, for initiating the corresponding configuration updates on the cluster, and for communicating status changes to the Azure platform.
- **fluxconfig-controller.** Monitors fluxconfig custom resources.

With version 2, Flux supports additional features, including:

|Category|Feature|
|-|-|
|**Infrastructure and Workload management**|Deployment dependency management|
||	Integration with Kubernetes role-based access control (RBAC)|
||	Health assessment for cluster and its workloads|
||	Automated container image updates to Git (including image scanning and patching)|
||	Interoperability with Cluster API (CAPI) providers|
|**Security and Governance**|	Alerting to external systems (through webhook senders)|
||	Policy-driven validation (including support for Open Policy Agent Gatekeeper)|
||	Container image scanning and patching|
||	Alerting to external systems (through webhook senders)|
|**Integration options with other GitOps flows**|	Integration with a range of Git providers (including GitHub, GitLab, and Bitbucket)|
||	Interoperability with workflow providers (including GitHub Actions)|

For more information, see [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

### Performance efficiency

Cluster workloads benefit from scalability and agility inherent to the Kubernetes platform. Flux v2 offers additional agility, reducing the time required for end-to-end software delivery.

**Optimize setup.** You need to optimize your Kubernetes cluster and infrastructure setup for your specific workloads.  The optimizations required are workload specific. It is recommended you determine the required settings with the application developer.

**Consider autoscaling.** You should use the autoscaling feature in Kubernetes. For more information,  [Cluster autoscaling in AKS hybrid](/azure/aks/hybrid/concepts-cluster-autoscaling).

**Add a cache.** To optimize the application, you should use caching strategies. 

**Establish performance baseline.** Benchmark your architecture and utilize metrics and monitoring tools to identify any issues or bottlenecks that may be impacting performance. 

### Security

**Understand the security benefits of the architecture.** With Flux v2, Kustomize, GitOps/DevOps pipelines operational changes are applied in an automated fashion. The code implementing these operational practices can be tightly controlled and audited, leveraging support for such mechanisms as branch protection, pull request reviews, and immutable history. The IaC approach removes the necessity of managing permissions for accessing the infrastructure and supports the principle of least privilege. Flux support for the namespace-based configuration scoping facilitates multitenant scenarios.

**Understand encryption.**To ensure data security, the Flux configurations resource data is stored encrypted at rest in an Azure Cosmos DB database by the cluster configuration service.

**Consider private endpoints.** GitOps supports Azure Private Link for connectivity to Azure Arc–related services.

#### Use Azure policies Azure Arc

Azure Arc extends the scope of resource management model beyond Azure. The extended scope provides a range of benefits that apply to physical and virtual servers. In the context of AKS, these benefits include:

- **Governance**: Azure Arc can enforce run-time governance that affect the AKS cluster and its pods by using Azure Policy for Kubernetes and centralized reporting of the corresponding policy compliance. This allows you, for example, to enforce the use of HTTPS for ingress traffic targeting Kubernetes cluster or to ensure that containers listen only on specific ports that you designate.
-**Improved operations**: Enhanced support for automated cluster configuration by using GitOps. 

Azure Policy facilitates centralized GitOps management that leverages the built-in *Deploy GitOps to Kubernetes cluster* policy definition. Once assigned, the policy automatically applies any GitOps-based configuration you choose to Azure Arc–enabled Kubernetes clusters you designate, if their Azure Resource Manager resources are in the scope of the assignment. 

References

- Quickstart to set up Azure Kubernetes Service on Azure Stack HCI and Windows Server using Windows Admin Center - AKS-HCI | Microsoft Docs
- Quickstart to create a local Kubernetes cluster using Windows Admin Center - AKS-HCI | Microsoft Docs
- Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters - AKS-HCI | Microsoft Docs
- GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes - Azure Arc | Microsoft Docs
- Tutorial: Use GitOps with Flux v2 in Azure Arc-enabled Kubernetes or Azure Kubernetes Service (AKS) clusters - Azure Arc | Microsoft Docs
- Tutorial: Implement CI/CD with GitOps (Flux v2) - Azure Arc | Microsoft Docs
