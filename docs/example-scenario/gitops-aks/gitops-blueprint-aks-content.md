GitOps is a set of principles for operating and managing a software system. This article describes techniques for using GitOps principles to operate and manage an Azure Kubernetes Services (AKS) cluster.

The [Flux](https://fluxcd.io), [Argo CD](https://argo-cd.readthedocs.io), [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper), [Kubernetes](https://kubernetes.io), and [git](https://www.git-scm.com) logos are trademarks of their respective companies. No endorsement is implied by the use of these marks.

## Architecture

Two GitOps operators that you can use with AKS are [Flux](https://fluxcd.io) and [Argo CD](https://argo-cd.readthedocs.io). They're [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io) projects and are widely used. The following scenarios show ways to use them.

### Scenario 1: GitOps with Flux and AKS

:::image type="content" source="media/gitops-flux.png" alt-text="Diagram of GitOps with Flux v2, GitHub and AKS." border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks-content.md.vsdx) of this architecture.*

#### Dataflow for scenario 1

Flux is a native [cluster extension](/azure/aks/cluster-extensions) to AKS. Cluster extensions provide a platform for installing and managing solutions on an AKS cluster. You can use the Azure portal, the Azure CLI, or infrastructure as code (IaC) scripts, such as Terraform or Bicep scripts, to enable Flux as an extension to AKS. You can also use Azure Policy to apply Flux v2 configurations at scale on AKS clusters. For more information, see [Deploy applications consistently at scale using Flux v2 configurations and Azure Policy](/azure/azure-arc/kubernetes/use-azure-policy-flux-2).

Flux can deploy Kubernetes manifests, Helm charts, and Kustomization files to AKS. Flux is a poll-based process, so it can detect, pull, and reconcile configuration changes without exposing cluster endpoints to your build agents.

In this scenario, Kubernetes administrators can change Kubernetes configuration objects, such as secrets and ConfigMaps, and commit the changes directly to a GitHub repository.

The data flow for this scenario is:

1. The developer commits configuration changes to the GitHub repository.
1. Flux detects configuration drift in the Git repository, and pulls the configuration changes.
1. Flux reconciles the state in the Kubernetes cluster.

#### Alternatives for scenario 1

- You can use Flux with other Git repositories such as Azure DevOps, GitLab, and BitBucket.
- Instead of Git repositories, [Flux Bucket API](https://fluxcd.io/flux/components/source/buckets) defines a source to produce an artifact for objects from storage solutions like Amazon S3 and Google Cloud Storage buckets. You can also use a solution that has an S3-compatible API. Two examples are Minio and Alibaba Cloud OSS, but there are others.
- You can also configure Flux against an Azure Blob Storage container as a source to produce artifacts. For more information, see [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

### Scenario 2: Use GitOps with Flux, GitHub, and AKS to implement CI/CD

:::image type="content" source="media/gitops-ci-cd-flux.png" alt-text="Diagram of implementing CI/CD by using GitOps with Flux, GitHub and AKS." border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks-content.md.vsdx) of this architecture.*

#### Dataflow for scenario 2

This scenario is a pull-based DevOps pipeline for a typical web application. The pipeline uses GitHub Actions for build. For deployment, it uses Flux as the GitOps operator to pull and sync the app. The data flows through the scenario as follows:

1. The app code is developed by using an IDE such as Visual Studio Code.
1. The app code is committed to a GitHub repository.
1. GitHub Actions builds a container image from the app code and pushes the container image to Azure Container Registry.
1. GitHub Actions updates a Kubernetes manifest deployment file with the current image version that's based on the version number of the container image in Azure Container Registry.
1. The Flux operator detects configuration drift in the Git repository and pulls the configuration changes.
1. Flux uses manifest files to deploy the app to the AKS cluster.

### Scenario 3: GitOps with Argo CD, GitHub repository and AKS

:::image type="content" source="media/gitops-argo-cd.png" alt-text="Diagram of GitOps with Argo CD, GitHub and AKS." border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks-content.md.vsdx) of this architecture.*

#### Dataflow for scenario 3

In this scenario, the Kubernetes administrator can change Kubernetes configuration objects, such as secrets and ConfigMaps, and commit the changes directly to the GitHub repository.

The data flow for this scenario is:

1. The Kubernetes administrator makes configuration changes in YAML files and commits the changes to the GitHub repository.
1. Argo CD pulls the changes from the Git repository.
1. Argo CD reconciles the configuration changes to the AKS cluster.

Argo CD doesn't have to automatically sync the desired target state to the AKS cluster. It's implemented as a Kubernetes controller that continuously monitors running applications. It compares the current, live state of the AKS cluster against the desired target state that's specified in the Git repository. Argo CD reports and visualizes the differences, while providing facilities to automatically or manually sync the live state back to the desired target state.

Argo CD provides a browser-based user interface. You can use it to add application configurations, observe the synchronization state with respect to the cluster, and initiate synchronization against the cluster. You can also use the Argo CD command line to do these things. Both the user interface and command line interface provide features to view the history of configuration changes and to roll back to a previous version.

By default, the Argo CD user interface and the API server aren't exposed. To access them, we recommend that you [create an ingress controller that has an internal IP address](/azure/aks/ingress-basic?tabs=azure-cli#create-an-ingress-controller-using-an-internal-ip-address). Or, you can [use an internal load balancer](/azure/aks/internal-lb) to expose them.

#### Alternatives for scenario 3

Any repository that's compatible with Git, including Azure DevOps, can serve as the configuration source repository.

### Scenario 4: Use GitOps with Argo CD, GitHub Actions, and AKS to Implement CI/CD

:::image type="content" source="media/gitops-ci-cd-argo-cd.png" alt-text="Diagram of implementing CI/CD using GitOps with Argo CD, GitHub and AKS." border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks-content.md.vsdx) of this architecture.*

#### Dataflow for scenario 4

This scenario is a pull-based DevOps pipeline for a typical web application. The pipeline uses GitHub Actions for build. For deployment, it uses Argo CD as the GitOps operator to pull and sync the app. The data flows through the scenario as follows:

1. The app code is developed by using an IDE such as Visual Studio Code.
1. The app code is committed to a GitHub repository.
1. GitHub Actions builds a container image from the app code and pushes the container image to Azure Container Registry.
1. GitHub Actions updates a Kubernetes manifest deployment file with the current image version that's based on the version number of the container image in Azure Container Registry.
1. Argo CD pulls from the Git repository.
1. Argo CD deploys the app to the AKS cluster.

#### Alternatives for scenario 4

Any repository that's compatible with Git, including Azure DevOps, can serve as the configuration source repository.

### Scenario 5: Use Syncier Tower and GitOps operator to enforce policies

:::image type="content" source="media/gitops-blueprint-aks-new.png" alt-text="Diagram of GitOps for AKS, with GitHub source control, Flux GitOps controller, Syncier Security Tower GitOps control kit, and Gatekeeper admission controller." border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks-content.md.vsdx) of this architecture.*

#### Dataflow for scenario 5

This solution follows a strong GitOps approach.

1. The single source of truth is the GitHub repository that holds the provisioned AKS cluster configurations. The repository stores all AKS application manifests and all cluster infrastructure desired states. Every change to the cluster happens under version control.

   GitHub functionality:
   - Ensures review for changes.
   - Prevents unintended or unauthorized changes.
   - Enforces desired quality checks.
1. Flux is the GitOps operator and controller, and is the only component that can make changes to the cluster. Flux pulls cluster desired state changes from GitHub, and syncs them into AKS. Flux:
   - Pulls desired changes from GitHub.
   - Detects any configuration drift.
   - Reconciles the state in the Kubernetes cluster.
   - Manages Gatekeeper and the applications.
   - Updates itself.
1. Open Policy Agent (OPA) Gatekeeper enforces policies with a validating admission webhook. Gatekeeper validates cluster configuration changes against provisioned policies, and applies the changes only if they comply with policies.
1. Syncier Security Tower is a GitOps control kit that provides an overview of all AKS clusters and helps manage policies. Syncier Security Tower:
   - Assembles all cluster images in an overview that shows which versions are deployed and identifies outdated images.
   - Provides feedback on policy violations via pull request (PR) feedback before changes are applied.
   - Introduces risk acceptance whenever policies aren't applied for good reasons.
   - Provides security policies to OPA Gatekeeper.

### Components

The architecture scenarios use one or more of the following components:

1. [AKS](https://azure.microsoft.com/products/kubernetes-service) is a highly available, secure, and fully managed Kubernetes service in Azure. In AKS, Azure manages the Kubernetes API server. Cluster owners and operators access and manage the Kubernetes nodes and node pools.
1. [GitHub](https://github.com) is a code hosting platform for version control and collaboration. GitHub provides Git distributed version control, source code management, and other features.
1. [Flux](https://fluxcd.io) is a GitOps tool that automates the deployment of applications on Kubernetes. Flux automates configuration updates when there's new code to deploy. Flux is provided as a native extension to AKS.
1. [Argo CD](https://argo-cd.readthedocs.io) is a declarative GitOps continuous-delivery tool for Kubernetes.
1. [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper) is a project that integrates the open-source OPA admission controller with Kubernetes. Kubernetes admission controllers enforce policies on objects during create, update, and delete operations, and are fundamental to Kubernetes policy enforcement.
1. [Syncier Security Tower](https://securitytower.syncier.com) is a publicly available tool from Syncier that helps overcome GitOps security and compliance challenges. To help ensure that only trusted images run in the cluster, Syncier Security Tower comes with a set of best-practice policies that are grouped according to well-known security standards.

## Scenario details

GitOps is a set of principles for operating and managing a software system.

- It uses source control as the single source of truth for the system.
- It applies development practices like version control, collaboration, compliance, and continuous integration/continuous deployment (CI/CD) to infrastructure automation.
- You can apply it to any software system.

GitOps is often used for Kubernetes cluster management and application delivery. This article describes some common options for using GitOps together with an AKS cluster.

According to [GitOps principles](https://opengitops.dev/#principles), the desired state of a GitOps-managed system must be:

1. **Declarative**: A system that GitOps manages must have its desired state expressed declaratively. The declaration is typically stored in a Git repository.
1. **Versioned and immutable**: The desired state is stored in a way that enforces immutability and versioning, and retains a complete version history.
1. **Pulled automatically**: Software agents automatically pull the desired state declarations from the source.
1. **Continuously reconciled**: Software agents continuously observe actual system state and attempt to apply the desired state.

In GitOps, [infrastructure as code (IaC)](https://wikipedia.org/wiki/Infrastructure_as_code) uses code to declare the desired state of infrastructure components such as virtual machines (VMs), networks, and firewalls. This code is version controlled and auditable.

Kubernetes describes everything from cluster state to application deployments declaratively with manifests. GitOps for Kubernetes places the cluster infrastructure desired state under version control. A component in the cluster, typically called an operator, continuously syncs the declarative state. This approach makes it possible to review and audit code changes that affect the cluster. It enhances security by supporting the principle of least privilege.

GitOps agents continuously reconcile the system state with the desired state that's stored in your code repository. Some GitOps agents can revert operations that are performed outside the cluster, such as manual creation of Kubernetes objects. [Admission controllers](https://www.openpolicyagent.org/docs/latest/kubernetes-introduction), for instance, enforce policies on objects during create, update, and delete operations. You can use them to ensure that deployments change only if the deployment code in the source repository changes.

You can combine policy management and enforcement tools with GitOps to enforce policies and provide feedback for proposed policy changes. You can configure notifications for various teams to provide them with up-to-date GitOps status. For example, you can send notifications of deployment successes and reconciliation failures.

### GitOps as the single source of truth

GitOps provides consistency and standardization of the cluster state, and can help to enhance security. You can also use GitOps to ensure consistent state across multiple clusters. For example, GitOps can apply the same configuration across primary and disaster recovery (DR) clusters, or across a farm of clusters.

If you want to enforce that only GitOps can change the cluster state, you can restrict direct access to the cluster. There are various ways to do this, including Azure role-based access control (RBAC), admissions controllers, and other tools.

### Use GitOps to bootstrap initial configuration

It's possible to have a need to deploy AKS clusters as part of the baseline configuration. An example is that you have to deploy a set of shared services or a configuration before you deploy workloads. These shared-services can configure AKS add-ons such as:

- [Azure AD workload identity](/azure/aks/workload-identity-overview).
- [Secret Store CSI Driver Provider](https://github.com/Azure/secrets-store-csi-driver-provider-azure).
- Partner tools such as:
  - [Prisma Cloud Defender](https://docs.paloaltonetworks.com/prisma/prisma-cloud).
  - [Splunk Daemonset](https://github.com/splunk/splunk-connect-for-kubernetes).
- Open-source tools such as:
  - [KEDA](https://keda.sh).
  - [External-dns](https://github.com/kubernetes-sigs/external-dns).
  - [Cert-manager](https://cert-manager.io/docs).

You can enable Flux as an extension that's applied when you create an AKS cluster. Flux can then bootstrap the baseline configuration to the cluster. The [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks) suggests using GitOps for bootstrapping. If you use the Flux extension, you can bootstrap clusters very soon after you deploy.

### Other GitOps tools and add-ons

You can extend the described scenarios to other GitOps tools. Jenkins X is another GitOps tool that provides instructions to [integrate to Azure](https://jenkins-x.io/v3/admin/platforms/azure). You can use progressive delivery tools such as [Flagger](https://fluxcd.io/flagger) for gradual shifting of production workloads that are deployed through GitOps.

### Potential use cases

This solution benefits any organization that wants the advantages of deploying applications and infrastructure as code, with an audit trail of every change.

GitOps shields the developer from the complexities of managing a container environment. Developers can continue to work with familiar tools such as Git to manage updates and new features. In this way, GitOps enhances developer productivity.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

One of the key pillars of reliability is resiliency. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. If a cluster becomes unavailable, GitOps can create a new one quickly. It uses the Git repository as the single source of truth for Kubernetes configuration and application logic. It can create and apply the cluster configuration and application deployment as a scale unit and can establish the [deployment stamp](/azure/architecture/patterns/deployment-stamp) pattern.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

With the GitOps approach, individual developers or administrators don't directly access the Kubernetes clusters to apply changes or updates. Instead, users push changes to a Git repository and the GitOps operator (Flux or Argo CD) reads the changes and applies them to the cluster. This approach follows the security best practice of least privilege by not giving DevOps teams write permissions to the Kubernetes API. In diagnostic or troubleshooting scenarios, you can grant cluster permissions for a limited time on a case-by-case basis.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that sync to AKS clusters:

- **Branch protection:** Protect the branches that represent the state of the Kubernetes clusters from having changes pushed to them directly. Use PRs to make changes, and have at least one other person review every PR. Also, use PRs to do automatic checks.
- **PR review:** Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the GitHub code owners feature to define individuals or teams that are responsible for reviewing specific files in a repository.
- **Immutable history:** Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.
- **Further security measures:** Require your GitHub users to activate two-factor authentication. Also, allow only commits that are signed, to prevent changes.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- [On the free tier](/azure/aks/free-standard-pricing-tiers), AKS offers free cluster management. Costs are limited to the compute, storage, and networking resources that AKS uses to host nodes.
- GitHub offers a free service, but to use advanced security-related features like code owners or required reviewers, you need the Team plan. For more information, see the [GitHub pricing](https://github.com/pricing) page.
- Azure DevOps offers a free tier that you can use for some scenarios.
- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

GitOps can increase DevOps productivity. One of the most useful features is the ability to quickly roll back changes that are behaving unexpectedly, just by performing Git operations. The commit graph still contains all commits, so it can help with the post-mortem analysis.

GitOps teams often manage multiple environments for the same application. It's typical to have several stages of an application that are deployed to different Kubernetes clusters or namespaces. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

You can use Syncier Security Tower to simplify cluster operations. It can extract the application versions that are deployed to multiple clusters from the repository and display the results in a user-friendly way. DevOps teams can use advanced Syncier Security Tower features to get insights into who changed what, and when, in an application. Teams can browse and filter based on factors like change type and resource kind. Syncier Security Tower provides a control center to activate policies and compare compliance state over different clusters.

## Deploy a scenario

The following list provides references for information about deploying the five scenarios:

- **Scenario 1:** For guidance on using GitOps with Flux v2 to deploy applications to AKS, see [Tutorial: Deploy applications using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli). For an example of how to use the Flux extension to bootstrap AKS cluster deployment, see the [reference implementation for the AKS baseline](https://github.com/mspnp/aks-baseline/tree/main/cluster-manifests).
- **Scenario 2:** For guidance on using GitOps with Flux v2 on AKS to deploy applications and to implement CI/CD, see: [Tutorial: Implement CI/CD with GitOps (Flux v2)](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd).
- **Scenarios 3 and 4:** For step-by-step guidance on deploying a sample workload with Argo CD and AKS, see the pull-based CI/CD scenario in [AKS Baseline Automation](https://github.com/Azure/aks-baseline-automation#deploy-sample-applications-using-gitops-pull-method).
- **Scenario 5:** For guidance on deploying scenario 5 to AKS, see [Syncier Security Tower - Getting Started](https://securitytower.syncier.com/docs/guide/get-started).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Principal Cloud Solutions Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Argo CD documentation](https://argo-cd.readthedocs.io)
- [Flux CD documentation](https://fluxcd.io)
- [GitOps with Jenkins X](https://jenkins-x.io/v3/devops/gitops)
- [What is Azure role-based access control (Azure RBAC)?](/azure/role-based-access-control/overview)

## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [AKS baseline for multiregion clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
- [Build and deploy apps on AKS using DevOps and GitOps](../../guide/aks/aks-cicd-github-actions-and-gitops.yml)
- [DevSecOps on Azure Kubernetes Service (AKS)](../../guide/devsecops/devsecops-on-aks.yml)
- [DevSecOps for infrastructure as code (IaC)](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)
- [Enterprise infrastructure as code using Bicep and Azure Container Registry](../../guide/azure-resource-manager/advanced-templates/enterprise-infrastructure-bicep-container-registry.yml)
- [DevSecOps with GitHub Security](../../solution-ideas/articles/devsecops-in-github.yml)
- [Automate infrastructure reconfiguration by using Azure](../../web-apps/guides/networking/automation-application-gateway.yml)
