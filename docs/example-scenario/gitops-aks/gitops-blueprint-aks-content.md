GitOps  is a set of principles for operating and managing software systems. Though GitOps can be applied to any software system, GitOps is extensively used in Kubernetes cluster management and application delivery. GitOps applies development practices like version control, collaboration, compliance, and continuous integration/continuous deployment (CI/CD) to infrastructure automation.

[GitOps](https://github.com/open-gitops/documents/blob/main/PRINCIPLES.md) provides a set of principles for operating and managing software systems. Though GitOps can be applied to any software system, GitOps finds extensive use in Kubernetes cluster management and application delivery. GitOps applies development practices like version control, collaboration, compliance, and continuous integration/continuous deployment (CI/CD) to infrastructure automation. According to GitOps principles, the desired state of a GitOps managed system must be:

- **Declarative**: A system managed by GitOps must have its desired state expressed declaratively.
- **Versioned and Immutable**: Desired state is stored in a way that enforces immutability, versioning and retains a complete version history.
- **Pulled Automatically**: Software agents automatically pull the desired state declarations from the source.
- **Continuously Reconciled**:  Software agents continuously observe actual system state and attempt to apply the desired state.

Kubernetes describes everything from cluster state to application deployments declaratively with code. In GitOps, [infrastructure as code (IaC)](https://wikipedia.org/wiki/Infrastructure_as_code) uses code to declare the desired state of infrastructure components like virtual machines (VMs), networks, and firewalls. This code is version controlled and auditable.

GitOps for Kubernetes places the cluster infrastructure desired state under version control. A component within the cluster continuously syncs the declarative state. Rather than having direct access to the cluster, most operations happen through code changes that can be reviewed and audited. This approach supports the security principle of least privilege access.

One of the principles of GitOps is to continuously reconcile the system state with the desired state (described in code repository). GitOps agents will monitor the cluster state and will attempt to reconcile the cluster state with desired state. Hence operations performed outside the cluster (such as manual creation of Kubernetes objects) can be reverted by the GitOps agents (such as [Admission Controllers](https://www.openpolicyagent.org/docs/latest/kubernetes-introduction/)).

Policy management / enforcement tools can be combined with GitOps to enforce policies and provide feedback for proposed policy changes. Notifications can be configured for various teams so that the teams are updated on the GitOps operation status (such as if a deployment is succeeded, or if a reconciliation failed).

This article describes few common options for using GitOps with an Azure Kubernetes Services (AKS) cluster. This solution explores aspects of full audit capabilities, policy enforcement, and early feedback.

## Potential use cases

This solution benefits any organization that wants the advantages of deploying applications and infrastructure as code, with an audit trail of every change.

GitOps provides consistency and standardization of the cluster state, and is useful to ensure strong security guarantees. GitOps can also be used to ensure consistent state across multiple clusters (for example, apply the same configuration across primary and DR clusters, or across a farm or clusters).

The most common and widely used GitOps operators are Flux and Argo CD. Both are CNCF projects, and can be used with Azure Kubernetes Service.

## Scenario 1:  GitOps with Argo CD, GitHub repository and AKS

### Data Flow

The data flow for this scenario is as follows:

* The Kubernetes administrator makes configuration changes in YAML files and commits the changes to the GitHub repository.
* Argo CD syncs with, or pulls from, the Git repository.
* Argo CD deploys the app to the AKS cluster.

### Alternatives

The configuration source repository could be any Git compatible repository, including Azure DevOps.

## Scenario 2:  Implementing CI/CD using GitOps with Argo CD, GitHub actions and AKS

### Dataflow

This scenario covers a pull-based DevOps pipeline for a web application. This pipeline uses GitHub Actions for build. For deployment, it uses Argo CD as a GitOps operator to pull/sync the app. The data flows through the scenario as follows:

* The app code is developed.
* The app code is committed to a GitHub repository.
* GitHub Actions builds a container image from the app code and pushes the container image to Azure Container Registry.
* GitHub Actions updates a Kubernetes manifest deployment file with the current image version based on the version number of the container image in the Azure Container Registry.
* Argo CD syncs with, or pulls from, the Git repository.
* Argo CD deploys the app to the AKS cluster.

### Alternatives

The configuration source repository could be any Git compatible repository, including Azure DevOps.

## Scenario 3: GitOps with Flux and AKS

In this scenario, Flux is the GitOps operator and controller. Flux pulls cluster desired state changes from GitHub, and syncs them into AKS. Flux:

* Pulls desired changes from GitHub.
* Detects any configuration drift.
* Reconciles the state in the Kubernetes cluster.
* Manages Gatekeeper and the applications.
* Updates itself.

### Alternatives

* Flux can be used with other Git Repositories and CI/CD tools such as Azure DevOps, GitLabs, BitBucket etc. 
* Instead of Git Repositories, [Flux Bucket API]{<https://fluxcd.io/flux/components/source/buckets/>} defines a Source to produce an Artifact for objects from storage solutions like Amazon S3, Google Cloud Storage buckets, or any other solution with a S3 compatible API such as Minio, Alibaba Cloud OSS and others. 
* [Flux can also be configured against Azure Blob Storage Container as a source to produce artifacts](/azure/azure-arc/kubernetes/conceptual-gitops-flux2).

## Scenario 4: Implementing CI/CD using GitOps with Flux, GitHub and AKS

### Dataflow

This scenario covers a pull-based DevOps pipeline for a web application. This pipeline uses GitHub Actions for build. For deployment, it uses Flux as a GitOps operator to pull/sync the app. The data flows through the scenario as follows:

* The app code is developed.
* The app code is committed to a GitHub repository.
* GitHub Actions builds a container image from the app code and pushes the container image to Azure Container Registry.
* GitHub Actions updates a Kubernetes manifest deployment file with the current image version based on the version number of the container image in the Azure Container Registry.
* Flux operator syncs with, or pulls from, the Git repository.
* Flux deploys the app to the AKS cluster using manifest files. (Flux can deploy to AKS using Kubernetes manifests / helm charts / Kustomization files).

## Scenario 5: Enforcing policies using Sycier tower and GitOps operator. 

![Diagram of GitOps for AKS, with GitHub source control, Flux GitOps controller, Syncier Security Tower GitOps control kit, and Gatekeeper admission controller.](media/gitops-blueprint-aks-new.png)

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/gitops-blueprint-aks.vsdx) of this architecture.*

This solution follows a strong GitOps approach.

1. The single point of truth is the **GitHub repository** that holds the provisioned AKS cluster configurations. The repository stores all AKS application manifests and cluster infrastructure desired states. Every change to the cluster happens under version control. GitHub functionality:

   - Ensures review for changes.
   - Prevents unintended or unauthorized changes.
   - Enforces desired quality checks.

1. **Flux** is the GitOps operator and controller, and is the only component that can make changes to the cluster. Flux pulls cluster desired state changes from GitHub, and syncs them into AKS. Flux:

   - Pulls desired changes from GitHub.
   - Detects any configuration drift.
   - Reconciles the state in the Kubernetes cluster.
   - Manages Gatekeeper and the applications.
   - Updates itself.

1. **Open Policy Agent (OPA) Gatekeeper** enforces policies with a validating admission webhook. Gatekeeper validates cluster configuration changes against provisioned policies, and applies the changes only if they comply with policies.

1. **Syncier Security Tower** is a GitOps control kit that provides an overview of all AKS clusters and helps manage policies. Syncier Security Tower:

   - Assembles all cluster images in an overview that shows which versions are deployed and identifies outdated images.
   - Provides feedback on policy violations via pull request (PR) feedback before changes are applied.
   - Introduces risk acceptance whenever policies can't be applied for good reasons.
   - Provides security policies to OPA Gatekeeper.


## Considerations

The following considerations apply to this solution.
### Scalability
GitOps has many benefits, but as cluster landscapes grow, so does the number of repositories. This solution helps meet challenges like:
* Keeping an overview of all environments and clusters.
* Tracking critical images.
* Checking that certain policies are active in every cluster.

### Security
This solution provides several security-related benefits. With the GitOps approach, individual developers or administrators don't directly access the Kubernetes clusters to apply changes or updates. Instead, users push changes to a Git repository, and the GitOps operator (Flux or Argo CD) reads them and applies them to the cluster. This approach follows the security best practice of least privilege by not giving DevOps teams write permissions to the Kubernetes API. In diagnostic or troubleshooting scenarios, you can grant cluster permissions for a limited time on a case-by-case basis.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that sync to AKS clusters:

* Branch protection: Protect the branches that represent the state of the Kubernetes clusters from having changes pushed to them directly. Require every change to be proposed by a PR that is reviewed by at least one other person. Also use PRs to do automatic checks. 
* PR review: Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the GitHub code owners feature to define individuals or teams that are responsible for reviewing specific files in a repository.
* Immutable history: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.
* Further security measures: Require your GitHub users to activate two-factor authentication. Also, allow only signed commits, which can't be altered after the fact.

### Operations

GitOps can increase DevOps productivity. One of the most useful features is the ability to quickly roll back changes that are behaving unexpectedly, just by performing Git operations. The commit graph still contains all commits, so it can help with the post-mortem analysis.

GitOps teams often manage multiple environments for the same application. It's typical to have several stages of an application deployed to different Kubernetes clusters or namespaces. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

Optionally, you can use Syncier Security Tower to simplify cluster operations. Syncier Security Tower can extract the application versions deployed to multiple clusters from the repository and displays it in a user-friendly way. An overview shows which container images and versions are deployed in each environment. DevOps teams can use advanced Syncier Security Tower features to get insights into who changed what and when in an application, or browse and filter based on factors like change type or resource kind. Syncier Security Tower provides a control center to activate policies and compare compliance state over different clusters.

## Deploy this scenario

The following tutorials provide steps for deploying applications to AKS using GitOps with Flux v2, and to implement CI/CD with GitOps and Flux v2 to AKS. 

* [Tutorial: Deploy applications using GitOps with Flux v2 - Azure Arc](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli)
* [Tutorial: Implement CI/CD with GitOps (Flux v2) - Azure Arc](/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd)

## Related resources

* [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md)
* [Secure DevOps for AKS](../../solution-ideas/articles/secure-devops-for-kubernetes.yml)
