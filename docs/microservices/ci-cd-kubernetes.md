---
title: Microservices CI/CD Pipeline on Kubernetes with Azure DevOps and Helm 
description: Learn about building a continuous integration and continuous delivery (CI/CD) pipeline for deploying microservices to Azure Kubernetes Service (AKS) by using Azure DevOps and Helm.
author: raykao
ms.author: rakao
ms.date: 03/27/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Build a CI/CD pipeline for microservices on Kubernetes by using Azure DevOps and Helm

Creating a reliable continuous integration and continuous delivery (CI/CD) process for a microservices architecture can be challenging. Each team needs to release services quickly and reliably, without disrupting other teams or destabilizing the application as a whole.

This article describes an example CI/CD pipeline for deploying microservices to Azure Kubernetes Service (AKS). Every team and project is different, so don't take this article as a set of hard-and-fast rules. Instead, use it as a starting point for designing your own CI/CD process.

The following list summarizes the goals of a CI/CD pipeline for Kubernetes hosted microservices:

- Teams can build and deploy their services independently.
- Code changes that pass the CI process automatically deploy to a production-like environment.
- Each stage of the pipeline enforces quality gates.
- A new version of a service can be deployed side by side with the previous version.

For more information, see [CI/CD for microservices architectures](./ci-cd.md).

## Assumptions

For this example, here are some assumptions about the development team and the code base:

- The code repository is a monorepo, with folders organized by microservice.
- The team's branching strategy is based on [trunk-based development](https://trunkbaseddevelopment.com).
- The team uses [release branches](/azure/devops/repos/git/git-branching-guidance) to manage releases. Separate releases are created for each microservice.
- The CI/CD process uses [Azure Pipelines](/azure/devops/pipelines) to build, test, and deploy the microservices to AKS.
- The container images for all microservices are stored in a single, shared [Azure Container Registry](/azure/container-registry) instance, with a separate repository for each microservice. Use [Container Registry Azure ABAC repository permissions](/azure/container-registry/container-registry-rbac-abac-repository-permissions) to scope each pipeline identity to its own repository, or use separate registries where stronger trust boundaries are required.
- The team uses Helm charts to package each microservice.
- A push deployment model is used, where Azure Pipelines and associated agents perform deployments by connecting directly to the AKS cluster.

These assumptions drive many of the specific details of the CI/CD pipeline. However, you can adapt the basic approach described here for other processes, tools, and services, such as GitHub Actions, Jenkins, or Docker Hub.

### Alternatives

When you choose a CI/CD strategy with AKS, consider the following common alternatives:

- Instead of using Helm as a package management and deployment tool, you can use [Kustomize](https://kustomize.io), a Kubernetes-native configuration management tool that introduces a template-free way to customize and parameterize application configuration.

- Instead of using Azure DevOps for Git repositories and pipelines, you can use [GitHub repositories](https://docs.github.com/repositories) for private and public Git repositories, and [GitHub Actions](https://github.com/features/actions) for CI/CD pipelines.

  GitHub Actions provides integration with AKS with [starter workflows](/azure/aks/kubernetes-action) and supports OpenID Connect (OIDC) for secure, secretless authentication to Azure.

- Instead of using a push deployment model, consider managing Kubernetes configuration at large scale by using a [GitOps (pull deployment model)](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks). An in-cluster Kubernetes operator like [Flux](https://fluxcd.io) or [Argo CD](https://argoproj.github.io/cd/) synchronizes cluster state based on the configuration that's stored in a Git repository. GitOps eliminates the need for pipelines to have direct cluster access, reduces the attack surface, and provides self-healing and drift detection capabilities.

  > [!TIP]
  > When evaluating push-based versus pull-based (GitOps) deployment models, consider your workload requirements. Push-based deployments offer deterministic updates and direct pipeline control, which suits safe deployment practices. Pull-based (GitOps) deployments offer consistency, auditability, and self-healing, which makes them ideal for environments where clusters need to reconcile against a desired state without direct pipeline-to-cluster access.

## Validation builds

Suppose that a developer is working on a microservice called *Delivery Service*. When developing a new feature, the developer checks code into a feature branch. By convention, feature branches are named `feature/*`.

:::image type="complex" source="./images/aks-cicd-1.png" border="false" alt-text="Diagram of a feature branch workflow.":::
    The diagram shows two horizontal Git branch lines and a build pipeline below them. At the top is the main branch, represented as a horizontal line. The feature/8150 branch diverges from main. This branch has three dots positioned on it, collectively labeled commits. From each of the three commits, an arrow points downward toward a box at the bottom of the diagram. The box is labeled Build pipeline and contains the pipeline name ci-delivery-validation. All three dashed arrows converge on this single build pipeline box, indicating that each commit to the feature/8150 branch triggers a run of the ci-delivery-validation pipeline.
:::image-end:::

The build definition file includes a trigger that filters by the branch name and the source path:

```yaml
trigger:
  batch: true
  branches:
    include:
    # for new release to production: release flow strategy
    - release/delivery/v*
    - refs/release/delivery/v*
    - main
    - feature/delivery/*
    - topic/delivery/*
  paths:
    include:
    - /src/shipping/delivery/
```

When you use this approach, each team can have its own build pipeline. Only code that's checked into the `/src/shipping/delivery` folder triggers a build of Delivery Service. Pushing commits to a branch that matches the filter triggers a CI build. At this point in the workflow, the CI build runs some minimal code verification:

1. Build the code.
1. Run unit tests.

The goal is to keep build times short so that the developer can get quick feedback. When the feature is ready to merge into main, the developer opens a PR. This operation triggers another CI build that performs some additional checks:

1. Build the code.
1. Run unit tests.
1. Run static application security testing (SAST) on the source code.
1. Build the runtime container image.
1. Run vulnerability scans on the image.

:::image type="complex" source="./images/aks-cicd-2.png" border="false" alt-text="Diagram showing ci-delivery-full in the Build pipeline.":::
    The diagram shows two horizontal Git branch lines and a build pipeline below them. At the top is the main branch, represented as a horizontal line. Below it, the feature/8150 branch runs parallel to it and has three dots on it that represent commits. At the right end of the feature/8150 branch, a dashed arrow connects to a point on the main branch. That point is marked with a another dot that's labeled PR, indicating that a pull request has been opened against main. From the PR point on the main branch, a dashed arrow points downward to a box labeled Build pipeline, which contains the pipeline name ci-delivery-full. This line illustrates that opening a pull request from the feature branch to main triggers the ci-delivery-full pipeline, which runs the extended set of CI checks.
:::image-end:::

> [!NOTE]
> In Azure Repos, one of the services in Azure DevOps, you can define [policies](/azure/devops/repos/git/branch-policies) to protect branches. For example, the policy could require a successful CI build and a sign-off from an approver before a merge into main.

## Full CI/CD build

When the team is ready to deploy a new version of Delivery Service, the release manager creates a branch from the main branch, using this naming pattern: `release/<microservice name>/<semver>`. For example, `release/delivery/v1.0.2`.

:::image type="complex" source="./images/aks-cicd-3.png" border="false" alt-text="Diagram showing a release branch triggering a build pipeline followed by a release pipeline.":::
    The diagram shows three horizontal Git branch lines and two pipelines below them. In the middle is the main branch, represented as a horizontal line. Below main is the feature/8150 branch, which has three dots on it that represent commits. The feature/8150 branch connects to the main branch at a point labeled merge, indicating the feature branch is merged into main. Above and to the right of the main branch, a new branch labeled release/delivery/v1.0.2 extends to the right. This release branch originates from main at a point to the right of the merge. From the release/delivery/v1.0.2 branch, a dashed line points downward to a box labeled ci-delivery-full, which is above the label Build pipeline. To the right of ci-delivery-full, a horizontal arrow points to a second box labeled cd-delivery, which is above the label Release pipeline.
:::image-end:::

Creating this branch triggers a full CI build that runs all of the previous steps and these steps:

1. Push the container image to Container Registry. The image is tagged with the version number in the branch name.
1. Run `helm package` to package the Helm chart for the service. The chart is also tagged with a version number.
1. Push the Helm package to Container Registry.

If this build succeeds, it triggers a deployment (CD) process by using an Azure Pipelines [release pipeline](/azure/devops/pipelines/release). This pipeline contains the following steps:

1. Deploy the Helm chart to a QA environment.
1. An approver signs off before the package moves to production. See [Release deployment control using approvals](/azure/devops/pipelines/release/approvals/approvals).
1. Retag the Docker image for the production namespace in Container Registry. For example, if the current tag is `myrepo.azurecr.io/delivery:v1.0.2`, the production tag is `myrepo.azurecr.io/prod/delivery:v1.0.2`.
1. Deploy the Helm chart to the production environment.

Even in a monorepo, scope these tasks to individual microservices so that teams can deploy independently. The process includes some manual steps: approving PRs, creating release branches, and approving deployments into the production cluster. Workload teams can automate these steps if they want to.

## Isolation of environments

You deploy services to multiple environments, including environments for development, smoke testing, integration testing, load testing, and production. These environments need some level of isolation. In Kubernetes, you can choose between physical isolation and logical isolation. Physical isolation deploys to separate clusters. Logical isolation uses namespaces and policies.

Our recommendation is to create a dedicated production cluster together with a separate cluster for your dev/test environments. Use logical isolation to separate environments within the dev/test cluster. Services deployed to the dev/test cluster should never have access to data stores that hold business data.

To enforce isolation within a cluster, take the following steps:

- **Namespaces**: Use Kubernetes namespaces to logically separate environments (for example, `dev`, `staging`, `qa`).
- **Network policies**: Apply [Kubernetes network policies](/azure/aks/use-network-policies) to deny pod-to-pod communication across namespaces.
- **Resource quotas**: Apply [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/) per namespace to prevent noisy-neighbor problems in shared clusters.
- **Microsoft Entra ID integration**: Combine [Microsoft Entra ID authentication](/azure/aks/entra-id-control-plane-authentication) with [Kubernetes RBAC and Microsoft Entra ID](/azure/aks/kubernetes-rbac-entra-id) to control which Microsoft Entra users and groups can access each namespace.

## Authentication and authorization

Use secretless authentication wherever possible, both for the pipelines that deploy your microservices and for the workloads those pipelines deploy:

- **Workload identity federation for pipelines**: For Azure Pipelines, use a [workload identity federation service connection](/azure/devops/pipelines/library/connect-to-azure#create-an-azure-resource-manager-service-connection-using-workload-identity-federation) to authenticate to Azure without storing long-lived service principal secrets. For GitHub Actions, configure [OIDC](https://docs.github.com/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-azure) to achieve the same secretless authentication.
- **Microsoft Entra Workload ID for deployed workloads**: Configure the microservices that your pipeline deploys to use [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview) instead of injecting credentials through manifests, Helm values, or Kubernetes secrets. Workload ID federates Kubernetes service accounts with Microsoft Entra ID so that pods can authenticate to Azure services (such as Azure Key Vault, Container Registry, or Azure SQL) without the pipeline managing any secrets.

## Secrets management

Never embed secrets (connection strings, API keys, database passwords) directly in source code, Dockerfiles, Helm values files, or pipeline definitions. Instead:

- Store secrets in [Key Vault](/azure/key-vault/general/overview).
- Use the [Key Vault Provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver) to mount secrets directly into pods as volumes or environment variables. This approach keeps secrets out of Kubernetes `Secret` objects, which are base64-encoded, not encrypted by default.
- For pipeline secrets, use [Key Vault integration with Azure Pipelines](/azure/devops/pipelines/release/azure-key-vault) or [GitHub Actions secrets](https://docs.github.com/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets).
- Enable [Key Vault soft delete and purge protection](/azure/key-vault/general/soft-delete-overview) to guard against accidental or malicious secret deletion.

> [!IMPORTANT]
> Avoid storing long-lived credentials (client secrets, certificates, or passwords) in pipeline variables, environment variables, or Kubernetes secrets. Instead, use managed identities and federated credentials to reduce your credential rotation burden and attack surface.

## Build process

When possible, package your build process into a Docker container. This configuration allows you to build code artifacts by using Docker without configuring a build environment on each build machine. A containerized build process simplifies scaling out the CI pipeline by adding new build agents. Also, any developer on the team can build the code by running the build container.

By using multistage builds in Docker, you can define the build environment and the runtime image in a single Dockerfile. For example, the following Dockerfile builds a .NET 10 application:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src/Fabrikam.Workflow.Service

COPY Fabrikam.Workflow.Service/Fabrikam.Workflow.Service.csproj .
RUN dotnet restore Fabrikam.Workflow.Service.csproj

COPY Fabrikam.Workflow.Service/. .
RUN dotnet build Fabrikam.Workflow.Service.csproj -c Release -o /app/build --no-restore

FROM build AS testrunner
WORKDIR /src/tests

COPY Fabrikam.Workflow.Service.Tests/*.csproj .
RUN dotnet restore Fabrikam.Workflow.Service.Tests.csproj

COPY Fabrikam.Workflow.Service.Tests/. .
ENTRYPOINT ["dotnet", "test", "--logger:trx"]

FROM build AS publish
RUN dotnet publish Fabrikam.Workflow.Service.csproj -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Fabrikam.Workflow.Service.dll"]
```

This Dockerfile defines several build stages. Notice that the stage named `base` uses the .NET 10 ASP.NET runtime image, while the stage named `build` uses the full .NET 10 SDK. The `build` stage builds the .NET project. But the final runtime container is built from `base`, which contains just the runtime and is significantly smaller than the full SDK image.

> [!IMPORTANT]
> Starting with .NET 8, official Linux-based .NET container images include a non-root user called `app`. The `USER app` instruction in the Dockerfile runs the container as this non-privileged user, following the principle of least privilege. ASP.NET Core container images also changed their default listening port from 80 to 8080.

### Building a test runner

Another good practice is to run unit tests in the container. For example, the following code shows part of a Dockerfile that builds a test runner:

```dockerfile
FROM build AS testrunner
WORKDIR /src/tests

COPY Fabrikam.Workflow.Service.Tests/*.csproj .
RUN dotnet restore Fabrikam.Workflow.Service.Tests.csproj

COPY Fabrikam.Workflow.Service.Tests/. .
ENTRYPOINT ["dotnet", "test", "--logger:trx"]
```

A developer can use this Dockerfile to run the tests locally:

```bash
docker build . -t delivery-test:1 --target=testrunner
docker run delivery-test:1
```

The CI pipeline should also run the tests as part of the build verification step.

This file uses the Docker `ENTRYPOINT` command, not the Docker `RUN` command, to run the tests.

- If you use the `RUN` command, the tests run every time you build the image. If you use `ENTRYPOINT`, the tests are opt-in. They run only when you explicitly target the `testrunner` stage.
- A failing test doesn't cause the Docker `build` command to fail. This behavior allows you to distinguish container build failures from test failures.
- Test results can be saved to a mounted volume.

### Container best practices

Here are some other best practices to consider for containers:

- Define organization-wide conventions for container tags, versioning, and naming conventions for resources deployed to the cluster (for example, pods and services). Using these conventions can make it easier to diagnose deployment issues.
- During the development and test cycle, the CI/CD process builds many container images. Only some of those images are candidates for release, and only some of those release candidates get promoted to production. Have a clear versioning strategy so that you know which images are currently deployed to production and can easily roll back to a previous version if necessary.
- Always deploy specific container version tags, not `latest`.
- Use [namespaces](/azure/container-registry/container-registry-best-practices#repository-namespaces) in Container Registry to isolate images that are approved for production from images that are still being tested. Don't move an image into the production namespace until you're ready to deploy it into production. Combining this practice with semantic versioning of container images can reduce the chances of accidentally deploying a version that isn't approved for release.
- Follow the principle of least privilege by running containers as a nonprivileged user. In Kubernetes, use [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) with [Pod Security admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/) (which replaced the deprecated Pod Security Policies in Kubernetes 1.25) to enforce restrictions like preventing containers from running as root. Use the `restricted` profile for production workloads.
- Use minimal or distroless base images (for example, Alpine-based images, [Azure Linux base or distroless images](/azure/azure-linux/container-images-overview), or [chiseled .NET images](https://devblogs.microsoft.com/dotnet/announcing-dotnet-chiseled-containers/)) to reduce the attack surface of your container images.
- For Premium registries, configure a [Container Registry retention policy](/azure/container-registry/container-registry-retention-policy) to delete untagged manifests. To purge tags by age or name, schedule a Container Registry task that runs [acr purge](/azure/container-registry/container-registry-auto-purge). Preserve images that active deployments and rollback plans reference.

## Helm charts

Consider using Helm to manage building and deploying services. The following Helm features support a CI/CD pipeline:

- A single microservice is often defined by multiple Kubernetes objects. Helm enables these objects to be packaged into a single Helm chart.
- You can deploy a chart by using a single Helm command rather than a series of kubectl commands.
- Charts are explicitly versioned. Use Helm to release a version, view releases, and roll back to a previous version. Helm uses semantic versioning to track updates and revisions.
- Helm charts use templates to avoid duplicating information, such as labels and selectors, across many files.
- Helm can manage dependencies between charts.
- You can store charts in a Helm repository, such as Container Registry, and integrate them into the build pipeline.

For more information, see [Use Container Registry as a Helm repository for your application charts](/azure/container-registry/container-registry-helm-repos).

A single microservice might require multiple Kubernetes configuration files. To update a service, you might need to edit all of these files to update selectors, labels, and image tags. Helm treats these files as a single package called a *chart* and makes it easy to update the YAML files by using variables. Helm uses a template language (based on Go templates) that enables you to write parameterized YAML configuration files.

For example, here's part of a YAML file that defines a deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "package.fullname" . | replace "." "" }}
  labels:
    app.kubernetes.io/name: {{ include "package.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
  annotations:
    kubernetes.io/change-cause: {{ .Values.reason }}

...

spec:
  template:
    spec:
      containers:
      - name: &package-container_name fabrikam-package
        image: {{ .Values.dockerregistry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        env:
        - name: LOG_LEVEL
          value: {{ .Values.log.level }}
```

You can see that the deployment name, labels, and container spec all use template parameters, which you provide at deployment time. For example, from the command line:

```bash
helm install <release-name> oci://<registry>/<repository>/<package-chart-name> --version <desiredVersion> \
     --set image.tag=0.1.0 \
     --set image.repository=package \
     --set dockerregistry=$ACR_SERVER \
     --namespace backend
```

Although a CI/CD pipeline can install a chart directly to Kubernetes, create a chart archive (.tgz file) and push the chart to a Helm repository such as Container Registry. For more information, see [Package and deploy Helm charts (HelmDeploy task)](/azure/devops/pipelines/tasks/reference/helm-deploy-v1).

### Revisions

Helm charts always have a version number that must use [semantic versioning](https://semver.org/). A chart can also have an `appVersion`. This field is optional and doesn't need to be related to the chart version. Some teams might want to version applications separately from updates to the charts. A simpler approach is to use one version number, so there's a 1:1 relation between chart version and application version. That way, you can store one chart per release and easily deploy the desired release:

```bash
helm install <package-chart-name> --version <desiredVersion>
```

Another good practice is to provide a change-cause annotation in the deployment template:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "delivery.fullname" . | replace "." "" }}
  labels:
     ...
  annotations:
    kubernetes.io/change-cause: {{ .Values.reason }}
```

This annotation enables you to view the change-cause field for each revision by using the `kubectl rollout history` command. In the preceding example, the change-cause is provided as a Helm chart parameter.

```bash
kubectl rollout history deployments/delivery-v010 -n backend
```

```output
deployment.apps/delivery-v010
REVISION  CHANGE-CAUSE
1         Initial deployment
```

You can also use the `helm list` command to view the revision history:

```bash
helm list -n backend
```

```output
NAME              NAMESPACE   REVISION    UPDATED                                 STATUS      CHART               APP VERSION
delivery-v0.1.0   backend     1           2024-04-07 00:25:30.000000 +0000 UTC    deployed    delivery-v0.1.0     v0.1.0
```

## Azure Pipelines

Azure Pipelines, a service in Azure DevOps, has two pipeline types: *build pipelines* and *release pipelines*. The build pipeline runs the CI process and creates build artifacts. For a microservices architecture on Kubernetes, these artifacts are the container images and Helm charts that define each microservice. The release pipeline runs the CD process that deploys a microservice into a cluster.

Based on the CI flow described earlier in this article, a build pipeline might consist of the following tasks:

1. Build the test runner container by using the `Docker` task.
1. Run the tests by invoking `docker run` against the test runner container by using the `Docker` task.
1. Publish the test results by using the `PublishTestResults` task. For more information, see [Build an image](/azure/devops/pipelines/ecosystems/containers/build-image).
1. Run SAST on the source code.
1. Build the runtime container by using local `docker build` and the `Docker` task or by using Container Registry builds and the `AzureCLI` task. Generate a software bill of materials (SBOM) for the image, for example by using the [Microsoft SBOM tool](https://github.com/microsoft/sbom-tool), and publish it as a pipeline artifact associated with the image digest or [attach it to the image in Container Registry](/azure/security/container-secure-supply-chain/articles/attach-sbom).
1. Run container image vulnerability scanning (for example, by using [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) or a non-Microsoft tool like Trivy) to detect known vulnerabilities before the image is published.
1. Push the container image to Container Registry (or another container registry) by using the `Docker` or `AzureCLI` task.
1. Sign the pushed image by immutable digest to ensure its integrity and authenticity. For Azure Pipelines, follow the [Notation signing guidance](/azure/security/container-secure-supply-chain/articles/notation-ado-task-sign).
1. Package the Helm chart by using the `HelmDeploy` task.
1. Push the Helm package to Container Registry (or another Helm repository) by using the `HelmDeploy` task.

The output from the CI pipeline is a production-ready container image and an updated Helm chart for the microservice. At this point, the release pipeline can take over. There's a unique release pipeline for each microservice. The release pipeline is configured to have a trigger source set to the CI pipeline that published the artifact. This pipeline enables you to deploy each microservice independently. The release pipeline performs the following steps:

1. Deploy the Helm chart to dev/QA/staging environments. You can use the `helm upgrade` command with the `--install` flag to support the first install and subsequent upgrades.
1. Wait for an approver to approve or reject the deployment.
1. Retag the container image for release.
1. Push the release tag to the container registry.
1. Deploy the Helm chart in the production cluster. Use [Ratify with Azure Policy](/azure/security/container-secure-supply-chain/articles/validating-image-signatures-using-ratify-aks) to validate image signatures during admission, and separately configure an allowed-images policy to restrict images to trusted registries.

> [!NOTE]
> To enable AKS to pull images from Container Registry without separate image pull secrets, use [AKS-to-Container-Registry integration](/azure/aks/cluster-container-registry-integration) for a registry that uses registry-wide RBAC. For an ABAC-enabled registry, this integration isn't supported. Instead, assign the `Container Registry Repository Reader` role to the cluster's kubelet-managed identity.

For more information about creating a release pipeline, see [Release pipelines, draft releases, and release options](/azure/devops/pipelines/release).

The following diagram shows the end-to-end CI/CD process described in this article:

:::image type="complex" source="./images/aks-cicd-flow.png" border="false" lightbox="./images/aks-cicd-flow.png" alt-text="Diagram of the end-to-end CI/CD pipeline.":::
    The diagram shows the complete CI/CD pipeline from a developer commit through production deployment. On the left, it starts with a developer pushing a commit to a Git repo. The Git repo triggers the first CI pipeline. The CI pipeline contains six sequential steps: Build code, Run unit tests, Build image, Push image, Helm package, and Push chart. Each of the first three steps has a corresponding output box to its right: Build code produces code artifacts, Run unit tests produces test results, and Build image produces a container image. The Push image step pushes the image to Container Registry. The Helm package step produces a chart archive file. The Push chart step pushes the chart to a Helm repository. A second CI pipeline is below the first one. It contains five sequential steps: Deploy to QA, Integration tests, Retag image, Push image, and Deploy to production. From the Deploy to QA step, a line labeled Helm upgrade leads to a Kubernetes cluster labeled test/QA cluster. On the left, below the developer, a line leads from a QA approver icon to the Deploy to production step. This line is labeled approve. From the Deploy to production step, a line labeled Helm upgrade leads to a second Kubernetes cluster icon labeled production cluster.
:::image-end:::

### GitHub Actions alternative

If your team uses GitHub for source control, [GitHub Actions](https://github.com/features/actions) provides an equivalent CI/CD platform. In addition to the [starter workflows and OIDC authentication](#alternatives) noted earlier, consider these GitHub-specific capabilities when you target AKS:

- **Environments and protection rules.** If your GitHub plan and repository visibility support them, use [GitHub environments](https://docs.github.com/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments) with required reviewers, wait timers, and deployment branches to implement approval gates.
- **Container scanning.** Use GitHub Actions marketplace actions for [Trivy](https://github.com/aquasecurity/trivy-action), [Microsoft Defender for DevOps](https://github.com/microsoft/security-devops-action), or similar tools for container image scanning directly in your workflow.

## Observability and monitoring

Implement observability across the entire CI/CD pipeline and runtime environment:

- **Pipeline monitoring.** Track build durations, test pass rates, deployment frequency, and failure rates. Azure DevOps provides built-in analytics. GitHub Actions can use non-Microsoft dashboards.
- **Runtime monitoring.** Use [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) and [Azure Managed Grafana](/azure/managed-grafana/overview) to monitor AKS cluster health and workload metrics.
- **Application telemetry.** Instrument your microservices with [Azure Monitor Application Insights](/azure/azure-monitor/app/app-insights-overview) for distributed tracing, request logging, and dependency tracking.
- **Alerting.** Configure alerts for deployment failures, pod restarts, high error rates, and resource saturation to enable rapid incident response.

## Well-Architected Framework alignment

When you design your CI/CD pipeline for microservices on Kubernetes, consider the pillars of the [Azure Well-Architected Framework](/azure/well-architected/):

| Pillar | Considerations |
|---|---|
| **Reliability** | Automated rollback strategies, health probes on deployments, blue-green or canary release strategies, pod disruption budgets. |
| **Security** | Secretless authentication (Workload ID, OIDC), image signing, supply chain security, least-privilege RBAC, network policies. |
| **Cost Optimization** | Right-sizing build agents, using ephemeral self-hosted runners, implementing Container Registry image retention policies, and using spot node pools only for interruption-tolerant non-production workloads. |
| **Operational Excellence** | GitOps for declarative deployments, Infrastructure as Code, Pipeline as Code (YAML), observability, and runbook automation. |
| **Performance Efficiency** | Parallel pipeline stages, build caching (Docker layer caching, dependency caching), horizontal pod autoscaling. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ray Kao](https://www.linkedin.com/in/raymondkao/) | Principal Solutions Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Adopt a Git branching strategy](/azure/devops/repos/git/git-branching-guidance)
- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Release pipelines, draft releases, and release options](/azure/devops/pipelines/release)
- [Deployment control using approvals](/azure/devops/pipelines/release/approvals/approvals)
- [Introduction to Azure Container Registry](/azure/container-registry/container-registry-intro)
- [Microsoft Entra Workload ID with AKS](/azure/aks/workload-identity-overview)
- [Azure Key Vault Provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver)
- [DevSecOps on AKS](/azure/architecture/guide/devsecops/devsecops-on-aks)

## Related resources

- [CI/CD for microservices](/azure/architecture/microservices/ci-cd)
- [Microservices architecture on AKS](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
- [GitOps for Azure Kubernetes Service](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks)
- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [CI/CD baseline architecture with Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture)
