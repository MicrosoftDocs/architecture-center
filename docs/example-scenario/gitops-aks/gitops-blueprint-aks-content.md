GitOps is a set of principles for operating and managing a software system. This article describes techniques for using GitOps principles to operate and manage an Azure Kubernetes Services (AKS) cluster.

*The [Flux](https://fluxcd.io), [Argo CD](https://argo-cd.readthedocs.io/en/stable), [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper), [Kubernetes](https://kubernetes.io), and [Git](https://git-scm.com) logos are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

Two GitOps operators that you can use with AKS are [Flux](https://fluxcd.io) and [Argo CD](https://argo-cd.readthedocs.io/en/stable). They're both [graduated Cloud Native Computing Foundation (CNCF) projects](https://www.cncf.io/projects/) and are widely used. The following scenarios show ways to use them.

### Scenario 1: GitOps with Flux and AKS

:::image type="complex" border="false" source="media/gitops-flux.svg" alt-text="Diagram of GitOps with Flux v2, GitHub, and AKS." lightbox="media/gitops-flux.svg":::
   Diagram that illustrates the GitOps workflow with Flux v2, GitHub, and AKS. On the left, a developer commits configuration changes to a GitHub repository. In the center, the Flux operator in the AKS cluster monitors the repository for changes. When Flux detects configuration drift, it pulls the latest configuration from GitHub. On the right, Flux reconciles the desired state from the repository with the actual state in the AKS cluster and applies updates as needed. The diagram shows the flow of configuration changes from the developer to GitHub, then to Flux, and finally to the AKS cluster, and emphasizes the pull-based, continuous reconciliation process.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gitops-blueprint-aks-content.vsdx) of this architecture.*

#### Data flow for scenario 1

Flux is a [cluster extension](/azure/aks/cluster-extensions) that integrates natively with AKS. A cluster extension provides a platform for installing and managing solutions on an AKS cluster. You can use the Azure portal, the Azure CLI, or infrastructure as code (IaC) scripts, such as Terraform or Bicep scripts, to enable Flux as an extension to AKS. You can also use Azure Policy to apply Flux v2 configurations at scale on AKS clusters. For more information, see [Deploy applications consistently at scale by using Flux v2 configurations and Azure Policy](/azure/azure-arc/kubernetes/use-azure-policy-flux-2).

Flux can deploy Kubernetes manifests, Helm charts, and Kustomization files to AKS. Flux is a poll-based process, so it can detect, pull, and reconcile configuration changes without exposing cluster endpoints to your build agents.

In this scenario, Kubernetes administrators can change Kubernetes configuration objects, such as secrets and ConfigMaps, and commit the changes directly to a GitHub repository.

The following data flow corresponds to the previous diagram:

1. The developer commits configuration changes to the GitHub repository.

1. Flux detects configuration drift in the Git repository and pulls the configuration changes.

1. Flux reconciles the state in the Kubernetes cluster.

#### Alternatives for scenario 1

- You can use Flux with other Git repositories such as Azure DevOps, GitLab, and Bitbucket.

- Instead of Git repositories, the [Flux Bucket API](https://fluxcd.io/flux/components/source/buckets) defines a source to produce an artifact for objects from storage solutions like Amazon S3 and Google Cloud Storage buckets. You can also use a solution that has an S3-compatible API. Two examples are MinIO and Alibaba Cloud Object Storage Service (OSS), but there are other solutions.

- You can also configure Flux against an Azure Blob Storage container as a source to produce artifacts. For more information, see [GitOps Flux v2 configurations with AKS and Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

- Flux v2 supports multitenancy by allowing separate teams to deploy workloads into a single shared Kubernetes cluster. Multiple Git repositories that each represent a different tenant can be synchronized to the cluster. To ensure workload isolation between teams, each team might have their own namespace or namespaces within the AKS cluster to which access is restricted through Kubernetes role-based access control (RBAC) policies.

- Flux can use one cluster to manage the apps in either the same cluster or other clusters. A hub AKS cluster with Flux operator manages GitOps continuous delivery of apps and infrastructure workloads to multiple spoke AKS clusters.

### Scenario 2: Use GitOps with Flux, GitHub, and AKS to implement CI/CD

:::image type="complex" border="false" source="media/gitops-ci-cd-flux.svg" alt-text="Diagram that shows how to implement CI/CD by using GitOps with Flux, GitHub, and AKS." lightbox="media/gitops-ci-cd-flux.svg":::
   Diagram that shows a CI/CD workflow with GitOps, Flux, GitHub, and AKS. On the left, a developer writes application code in an integrated development environment (IDE) and commits it to a GitHub repository. GitHub Actions builds a container image from the code and pushes it to Azure Container Registry. GitHub Actions updates a Kubernetes manifest file in the repository with the new image version. In the center, the Flux operator in the AKS cluster monitors the repository for changes. When Flux detects an updated manifest, it pulls the configuration and deploys the new application version to the AKS cluster. The diagram shows the flow of code and configuration from the developer to GitHub, through CI/CD automation, to Flux, and finally to the AKS cluster, and emphasizes the automated, pull-based deployment process.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gitops-blueprint-aks-content.vsdx) of this architecture.*

#### Data flow for scenario 2

This scenario is a pull-based DevOps pipeline for a typical web application. The pipeline uses GitHub Actions for build. For deployment, it uses Flux as the GitOps operator to pull and sync the app.

The following data flow corresponds to the previous diagram:

1. The app code is developed by using an integrated development environment (IDE) such as Visual Studio Code.

1. The app code is committed to a GitHub repository.

1. GitHub Actions builds a container image from the app code and pushes the container image to Azure Container Registry.

1. GitHub Actions updates a Kubernetes manifest deployment file with the current image version that's based on the version number of the container image in Container Registry.

1. The Flux operator detects configuration drift in the Git repository and pulls the configuration changes.

1. Flux uses manifest files to deploy the app to the AKS cluster.

### Scenario 3: GitOps with Argo CD, GitHub repository, and AKS

:::image type="complex" border="false" source="media/gitops-argo-cd.svg" alt-text="Diagram of GitOps with Argo CD, GitHub, and AKS." lightbox="media/gitops-argo-cd.svg":::
   Diagram that shows a GitOps workflow with Argo CD, GitHub, and AKS. On the left, a Kubernetes administrator edits configuration files and commits them to a GitHub repository. In the center, Argo CD in the AKS cluster monitors the repository for changes. When Argo CD detects updated configuration, it pulls the changes and reconciles the desired state with the actual state in the AKS cluster. The diagram highlights the flow of configuration from the administrator to GitHub, then to Argo CD, and finally to the AKS cluster, and emphasizes the pull-based, continuous reconciliation process and the role of Argo CD as a controller that manages application state.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gitops-blueprint-aks-content.vsdx) of this architecture.*

#### Data flow for scenario 3

You can [enable Argo CD as a cluster extension in AKS](/azure/azure-arc/kubernetes/tutorial-use-gitops-argocd). In this scenario, the Kubernetes administrator can change Kubernetes configuration objects, such as secrets and ConfigMaps, and commit the changes directly to the GitHub repository.

The following data flow corresponds to the previous diagram:

1. The Kubernetes administrator makes configuration changes in YAML files and commits the changes to the GitHub repository.

1. Argo CD pulls the changes from the Git repository.

1. Argo CD reconciles the configuration changes to the AKS cluster.

Argo CD doesn't have to automatically sync the desired target state to the AKS cluster. It's implemented as a Kubernetes controller that continuously monitors running applications. It compares the current live state of the AKS cluster against the desired target state that's specified in the Git repository. Argo CD reports and visualizes the differences, and provides tools to automatically or manually sync the live state back to the desired target state.

Argo CD provides a browser-based user interface. You can use it to add application configurations, observe the synchronization state with respect to the cluster, and initiate synchronization against the cluster. You can also use the Argo CD command line to do these tasks. Both the user interface and command line interface provide features to view the history of configuration changes and to roll back to a previous version.

By default, the Argo CD user interface and the API server aren't exposed. To access them, we recommend that you [create an ingress controller that has an internal IP address](/troubleshoot/azure/azure-kubernetes/load-bal-ingress-c/create-unmanaged-ingress-controller#create-an-ingress-controller-using-an-internal-ip-address). Or you can [use an internal load balancer](/azure/aks/internal-lb) to expose them.

#### Alternatives for scenario 3

Any repository that's compatible with Git, including Azure DevOps, can serve as the configuration source repository.

### Scenario 4: Use GitOps with Argo CD, GitHub Actions, and AKS to implement CI/CD

:::image type="complex" border="false" source="media/gitops-ci-cd-argo-cd.svg" alt-text="Diagram that shows how to implement CI/CD by using GitOps with Argo CD, GitHub, and AKS." lightbox="media/gitops-ci-cd-argo-cd.svg":::
   Diagram of a CI/CD workflow that uses GitOps with Argo CD, GitHub, and AKS. On the left, a developer writes application code and commits it to a GitHub repository. GitHub Actions builds a container image, pushes it to Container Registry, and updates a Kubernetes manifest file in the repository with the new image version. In the center, Argo CD in the AKS cluster monitors the repository for changes, pulls the updated configuration, and deploys the new application version to the AKS cluster. The diagram shows the flow of code and configuration from the developer to GitHub, through CI/CD automation, to Argo CD, and finally to the AKS cluster, with emphasis on the automated, pull-based deployment process.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gitops-blueprint-aks-content.vsdx) of this architecture.*

#### Data flow for scenario 4

This scenario is a pull-based DevOps pipeline for a typical web application. The pipeline uses GitHub Actions for build. For deployment, it uses Argo CD as the GitOps operator to pull and sync the app.

The following data flow corresponds to the previous diagram:

1. The app code is developed by using an IDE such as Visual Studio Code.

1. The app code is committed to a GitHub repository.

1. GitHub Actions builds a container image from the app code and pushes the container image to Container Registry.

1. GitHub Actions updates a Kubernetes manifest deployment file with the current image version that's based on the version number of the container image in Container Registry.

1. Argo CD pulls from the Git repository.

1. Argo CD deploys the app to the AKS cluster.

#### Alternatives for scenario 4

Any repository that's compatible with Git, including Azure DevOps, can serve as the configuration source repository.

## Scenario details

GitOps is a set of principles for operating and managing a software system.

- It uses source control as the single source of truth for the system.

- It applies development practices like version control, collaboration, compliance, and continuous integration and continuous deployment (CI/CD) to infrastructure automation.

- You can apply it to any software system.

GitOps is often used for Kubernetes cluster management and application delivery.

According to [GitOps principles](https://opengitops.dev/#principles), the desired state of a GitOps-managed system must meet the following criteria:

- **Declarative:** A system that GitOps manages must have its desired state expressed declaratively. The declaration is typically stored in a Git repository.

- **Versioned and immutable:** The desired state is stored in a way that enforces immutability and versioning, and retains a complete version history.

- **Pulled automatically:** Software agents automatically pull the desired state declarations from the source.

- **Continuously reconciled:** Software agents continuously observe actual system state and attempt to apply the desired state.

In GitOps, [IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) uses code to declare the desired state of infrastructure components such as virtual machines (VMs), networks, and firewalls. This code is version controlled and auditable.

Kubernetes describes everything from cluster state to application deployments declaratively by using manifests. GitOps for Kubernetes places the cluster infrastructure desired state under version control. A component in the cluster, typically called an *operator*, continuously syncs the declarative state. This approach makes it possible to review and audit code changes that affect the cluster. It enhances security by supporting the principle of least privilege (PoLP).

GitOps agents continuously reconcile the system state with the desired state that's stored in your code repository. Some GitOps agents can revert operations that are performed outside the cluster, such as manual creation of Kubernetes objects. For instance, [admission controllers](https://www.openpolicyagent.org/docs/kubernetes) enforce policies on objects during create, update, and delete operations. You can use them to ensure that deployments change only if the deployment code in the source repository changes.

You can combine policy management and enforcement tools with GitOps to enforce policies and provide feedback for proposed policy changes. You can configure notifications for individual teams to keep them informed about the current GitOps status. For example, you can send notifications of deployment successes and reconciliation failures.

### GitOps as the single source of truth

GitOps provides consistency and standardization of the cluster state, and can help enhance security. You can also use GitOps to ensure consistent state across multiple clusters. For example, GitOps can apply the same configuration across primary and disaster recovery (DR) clusters or across a farm of clusters.

To enforce GitOps as the only method for changing the cluster state, restrict direct access to the cluster. To set this configuration, use Azure role-based access control (Azure RBAC), admissions controllers, or other tools.

### Use GitOps to bootstrap initial configuration

Sometimes AKS cluster deployment is required as part of the baseline configuration. For example, you might need to deploy shared services or system-level configurations before deploying application workloads. These shared services can configure the following add-ons and tools:

- AKS add-ons such as [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview) and [Azure Key Vault Provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure)

- Partner tools such as [Prisma Cloud Defender](https://docs.prismacloud.io)

- Open-source tools such as [Kubernetes Event-driven Autoscaling (KEDA)](https://keda.sh), [ExternalDNS](https://kubernetes-sigs.github.io/external-dns/latest/), and [Cert-manager](https://cert-manager.io/docs)

You can enable Flux as an extension that's applied when you create an AKS cluster. Flux can then bootstrap the baseline configuration to the cluster. The [baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks) recommends that you use GitOps for bootstrapping. If you use the Flux extension, you can bootstrap clusters soon after you deploy.

### Other GitOps tools and add-ons

You can extend the described scenarios to other GitOps tools. Jenkins X is another GitOps tool that provides instructions to [integrate to Azure](https://jenkins-x.io/v3/admin/platforms/azure). You can use progressive delivery tools such as [Flagger](https://fluxcd.io/flagger) for gradual shifting of production workloads that are deployed through GitOps.

### Potential use cases

This solution benefits organizations that want to deploy applications and IaC and maintain an audit trail of every change.

GitOps simplifies container management for developers, which enhances productivity. Developers can continue to work with familiar tools such as Git to manage updates and new features.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

If a cluster becomes unavailable, GitOps should be used as part of creating a new cluster. It uses the Git repository as the single source of truth for Kubernetes configuration and application logic. It can create and apply the cluster configuration and application deployment as a scale unit and can establish the [Deployment Stamps](/azure/architecture/patterns/deployment-stamp) pattern.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

With the GitOps approach, individual developers or administrators don't directly access the Kubernetes clusters to apply changes or updates. Instead, users push changes to a Git repository and the GitOps operator, such as Flux or Argo CD, reads the changes and applies them to the cluster. This approach follows the security best practice of least privilege by not giving DevOps teams write permissions to the Kubernetes API. In diagnostic or troubleshooting scenarios, you can grant cluster permissions for a limited time on a case-by-case basis.

In addition to configuring repository permissions, consider implementing the following security measures in Git repositories that sync with AKS clusters:

- **Branch protection:** Protect the branches that represent the state of the Kubernetes clusters from having changes pushed to them directly. Use pull requests (PRs) to make changes, and have at least one other person review every PR. Also use PRs to do automatic checks.

- **PR review:** Require PRs to have at least one reviewer to enforce the four-eyes principle. You can also use the GitHub code owners feature to define individuals or teams that are responsible for reviewing specific files in a repository.

- **Immutable history:** Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.

- **Further security measures:** Require your GitHub users to activate two-factor authentication. Only allow commits that are signed to prevent changes.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The [AKS free tier](/azure/aks/free-standard-pricing-tiers) provides free cluster management. Costs are limited to the compute, storage, and networking resources that AKS uses to host nodes. The AKS free tier doesn't include a service-level agreement (SLA) and isn't recommended for production workloads.

- GitHub provides a free service, but to use advanced security-related features like code owners or required reviewers, you need the Team plan. For more information, see [GitHub pricing](https://github.com/pricing).

- Azure DevOps provides a free tier that you can use for some scenarios.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

GitOps can increase DevOps productivity. One of the most useful features is the ability to quickly roll back changes that behave unexpectedly by performing Git operations. The commit graph still contains all commits, so it can help with retrospective analysis.

GitOps teams often manage multiple environments for the same application. It's typical to have several stages of an application that are deployed to different Kubernetes clusters or namespaces. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

## Deploy a scenario

For more information about deploying the five scenarios, see the following resources:

- **Scenario 1:** For guidance about how to use GitOps with Flux v2 to deploy applications to AKS, see [Tutorial: Deploy applications by using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli). For an example of how to use the Flux extension to bootstrap AKS cluster deployment, see the [reference implementation for the AKS baseline](https://github.com/mspnp/aks-baseline/tree/main/cluster-manifests).

- **Scenario 2:** For guidance about how to use GitOps with Flux v2 on AKS to deploy applications and to implement CI/CD, see [Tutorial: Implement CI/CD with GitOps (Flux v2)](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd).

- **Scenarios 3 and 4:** For step-by-step guidance about how to deploy a sample workload with Argo CD and AKS, see the pull-based CI/CD scenario in [AKS baseline automation](https://github.com/Azure/aks-baseline-automation#deploy-sample-applications-using-gitops-pull-method).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Principal Cloud Solutions Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy applications by using GitOps with Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- [Deploy applications by using GitOps with Argo CD](/azure/azure-arc/kubernetes/tutorial-use-gitops-argocd)
- [Implement CI/CD with GitOps (Flux v2)](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd)
- [Argo CD documentation](https://argo-cd.readthedocs.io)
- [Flux CD documentation](https://fluxcd.io)
- [GitOps with Jenkins X](https://jenkins-x.io/v3/devops/gitops)
- [What is Azure RBAC?](/azure/role-based-access-control/overview)

## Related resources

- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [AKS baseline for multiregion clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
- [DevSecOps on AKS](../../guide/devsecops/devsecops-on-aks.yml)
- [DevSecOps for IaC](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)
