# CI/CD for microservices on Kubernetes

This article describes a proven CI/CD process for deploying microservices to Azure Kubernetes Service (AKS).

Before reading this article, consider reading [CI/CD for microservices architectures](./ci-cd.md) to understand the goals and challenges that this pipeline attempts to meet. These goals can be summarized as follows:

- Teams can build and deploy their services independently.
- Code changes that pass the CI process are automatically deployed to a production-like environment.
- Quality gates are enforced at each stage of the pipeline.
- A new version of a service can be deployed side by side with the previous version.

Let's start by looking at the overall flow of the pipeline.

## Overview of the CI/CD process

This workflow is based on the following assumptions:

- The code repository is a monorepo, with folders organized by microservice.
- The team's branching strategy is based on [trunk-based development](https://trunkbaseddevelopment.com/).
- The workflow uses [Azure Pipelines](/azure/devops/pipelines/?view=azure-devops) to build, test, and deploy microservices to AKS.
- The container images for each microservice are stored in [Azure Container Registry](/azure/container-registry/).
- The team uses Helm charts to package each microservice.

The basic approach described here can work with other tools and services such as Jenkins and Docker Hub.

### Validation builds

Suppose that a developer is working on a microservice called the Delivery Service. This service manages deliveries in a drone delivery service. (The complete scenario is described [here](./model/domain-analysis.md).) While developing a new feature, the developer checks code into a feature branch. By convention, feature branches are named `feature/*`.

The build definition file includes a trigger that filters by the branch name and the source path:

```yaml
trigger:
  batch: true
  branches:
    include:
    - master
    - feature/*
    - topic/*

    exclude:
    - feature/experimental/*
    - topic/experimental/*

  paths:
     include:
     - /src/shipping/delivery/
```

&#11162; See the [source file](https://github.com/mspnp/microservices-reference-implementation/blob/master/src/shipping/delivery/azure-pipelines-validation.yml).

Using this approach, each team can have its own build pipeline. Only code that is checked into the `/src/shipping/delivery` folder triggers a build of the Delivery Service. Pushing commits to a branch that matches the filter tiggers a CI build. At this point in the workflow, the CI build runs some minimal code verification:

1. Build the code
1. Run unit tests

The goal is to keep build times short, so the developer can get quick feedback.

![CI/CD workflow](./images/aks-cicd-1.png)

Once the feature is ready to merge into master, the developer opens a PR. This triggers another CI build that performs some additional checks:

1. Build the code
1. Run unit tests
1. Build the runtime container image
1. Run vulnerability scans on the image

![CI/CD workflow](./images/aks-cicd-2.png)

> [!NOTE]
> In Azure DevOps Repos, you can define [policies](/azure/devops/repos/git/branch-policies) to protect branches. For example, the policy could require a successful CI build plus a sign-off from an approver in order to merge into master.

### Full CI/CD build

At some point, the team is ready to deploy a new version of the Delivery service. The release manager creates a branch from master with this naming pattern: `release/<microservice name>/<semver>`. For example, `release/delivery/v1.0.2`.

Creation of this branch triggers a full CI build that runs all of the previous steps plus:

1. Push the container image to Azure Container Registry. The image is tagged with the version number taken from the branch name.
2. Run `helm package` to package the Helm chart for the service.
3. Push the Helm package to Container Registry.

Assuming this build succeeds, it triggers a deployment (CD) process using an Azure Pipelines [release pipeline](/azure/devops/pipelines/release/what-is-release-management). This pipeline has the following steps:

1. Deploy the Helm chart to a QA environment.
1. An approver signs off before the package moves to production. See [Release deployment control using approvals](/azure/devops/pipelines/release/approvals/approvals).
1. Re-tag the Docker image for the production namespace in Azure Container Registry. For example, if the current tag is `myrepo.azurecr.io/delivery:v1.0.2`, the production tag is `myrepo.azurecr.io/prod/delivery:v1.0.2`.
1. Deploy the Helm chart to the production environment.

![CI/CD workflow](./images/aks-cicd-3.png)

Even in a monorepo, these tasks can be scoped to individual microservices, so that teams can deploy with high velocity. The process has some manual steps: Approving PRs, creating release branches, and approving deployments into the production cluster. These steps are manual by policy &mdash; they could be completely automated if the organization prefers.

## Docker recommendations

When possible, package your build process into a container. That allows you to build your code artifacts using Docker, without needing to configure the build environment on each build machine. A containerized build process makes it easy to scale out the CI pipeline by adding new build agents. Also, any developer on the team can build the code simply by running the build container.

By using multi-stage builds in Docker, you can define the build environment and the runtime image in a single Dockerfile. For example, here's a Dockerfile that builds an ASP.NET Core application:

```
FROM microsoft/dotnet:2.2-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src/Fabrikam.Workflow.Service

COPY Fabrikam.Workflow.Service/Fabrikam.Workflow.Service.csproj .
RUN dotnet restore Fabrikam.Workflow.Service.csproj

COPY Fabrikam.Workflow.Service/. .
RUN dotnet build Fabrikam.Workflow.Service.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish Fabrikam.Workflow.Service.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Fabrikam.Workflow.Service.dll"]
```

&#11162; See the [source file](https://github.com/mspnp/microservices-reference-implementation/blob/master/src/shipping/workflow/Dockerfile).

This Dockerfile defines several build stages. Notice that the stage named `base` uses the ASP.NET Core runtime, while the stage named `build` uses the full ASP.NET Core SDK. The `build` stage is used to build the ASP.NET Core project. But the final runtime container is built from `base`, contains just the runime and is significantly smaller than the full SDK image.

Another good practice is to run unit tests in the container. For example, here is part of a Dockerfile that builds a test runner. A developer can run the test runner locallty, and the automated CI process can run the same tests.

```
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
docker run -p 8080:8080 delivery-test:1
```

Here are some other best practices to consider for containers:

- Define organization-wide conventions for container tags, versioning, and naming conventions for resources deployed to the cluster (pods, services, and so on). That can make it easier to diagnose deployment issues.

- During the development and test cycle, the CI/CD process will build many container images. Only some of those are candidates for release, and then only some of those release candidates will get pushed into production. Have a clear versioning strategy, so that you know which images are currently deployed to production, and can roll back to a previous version if necessary.

- Always deploy specific container version tags, not `latest`.

- Use [namespaces](/azure/container-registry/container-registry-best-practices#repository-namespaces) in Azure Container Registry to isolate images that are approved for production from images that are still being tested. Don't move an image into the production namespace until you're ready to deploy it into production. If you combine this practice with semantic versioning of container images, it can reduce the chance of accidentally deploying a version that wasn't approved for release.

- Follow the principle of least privilege by running containers as a nonprivileged user. In Kubernetes, you can create a pod security policy that prevents containers from running as *root*. See [Prevent Pods From Running With Root Privileges](https://docs.bitnami.com/kubernetes/how-to/secure-kubernetes-cluster-psp/).

## Helm charts

Consider using Helm to manage building and deploying services. Here are some of the features of Helm that help with CI/CD:

- Often a single microservice is defined by multiple Kubernetes objects. Helm allows these objects to be packaged into a single Helm chart.
- A chart can be deployed with a single Helm command, rather than a series of kubectl commands.
- Charts are explicitly versioned. Use Helm to release a version, view releases, and roll back to a previous version. Tracking updates and revisions, using semantic versioning, along with the ability to roll back to a previous version.
- Helm charts use templates to avoid duplicating information, such as labels and selectors, across many files.
- Helm can manage dependencies between charts.
- Charts can be stored in a Helm repository, such as Azure Container Registry, and integrated into the build pipeline.

For more information about using Container Registry as a Helm repository, see [Use Azure Container Registry as a Helm repository for your application charts](/azure/container-registry/container-registry-helm-repos).

A single microservice may involve multiple Kubernetes configuration files. Updating a service can mean touching all of these files to uppate selectors, labels, and image tags. Helm treats these as a single package called a chart and allows you to easily update the YAML files by using variables. Helm uses a template language (based on Go templates) to let you write parameterized YAML configuration files.

For example, here's part of a YAML file that defines a deployment:

```yaml
apiVersion: apps/v1beta2
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
      containers:
      - name: &package-container_name fabrikam-package
        image: {{ .Values.dockerregistry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        env:
        - name: LOG_LEVEL
          value: {{ .Values.log.level }}
```

&#11162; See the [source file](https://github.com/mspnp/microservices-reference-implementation/blob/master/charts/package/templates/package-deploy.yaml).

You can see that the deployment name, labels, and container spec all use template parameters, which are provided at deployment time. For example, from the command line:

```bash
helm install $HELM_CHARTS/package/ \
     --set image.tag=0.1.0 \
     --set image.repository=package \
     --set dockerregistry=$ACR_SERVER \
     --namespace backend \
     --name package-v0.1.0
```

Although your CI/CD pipeline could simply install a chart directly to Kubernetes, we recommend creating a chart archive (.tgz file) and pushing the chart to a Helm repository such as Azure Container Registry.
For more information, see [Package Docker-based apps in Helm charts in Azure Pipelines](/azure/devops/pipelines/languages/helm?view=azure-devops).

Another good practice is to provide a change-cause annotation in the deployment template:

```yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: {{ include "delivery.fullname" . | replace "." "" }}
  labels:
     ...
  annotations:
    kubernetes.io/change-cause: {{ .Values.reason }}
```

This lets you view the change-cause field for each revision, using the `kubectl rollout history` command. In the previous example, the change-cause is provided as a Helm chart parameter.

```bash
$ kubectl rollout history deployments/delivery-v010 -n backend
deployment.extensions/delivery-v010
REVISION  CHANGE-CAUSE
1         Initial deployment
```

You can also use the `helm list` command to view the revision history:

```bash
~$ helm list
NAME            REVISION    UPDATED                     STATUS        CHART            APP VERSION     NAMESPACE
delivery-v0.1.0 1           Sun Apr  7 00:25:30 2019    DEPLOYED      delivery-v0.1.0  v0.1.0          backend
```

>[!TIP]
> Use the `--history-max` flag when initializing Helm. This setting limits the number of revisions that Tiller saves in its history. Tiller stores revision history in configmaps. If you're releasing updates frequently, the configmaps can grow very large unless you limit the history size.

## Azure DevOps Pipeline

In Azure Pipelines, pipelines are divided into *build pipelines* and *release pipelines*. The build pipeline runs the CI process and creates build artifacts. For a microservices architecture on Kubernetes, these artifacts are the container images and Helm charts that define each microservice. The release pipeline runs that CD process that deploys a microservice into a cluster.

Tasks in the build pipeline:

1. Build the test runner as a container.

    ```yaml
    - task: Docker@1
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureContainerRegistry: $(AzureContainerRegistry)
        arguments: '--pull --target testrunner'
        dockerFile: $(System.DefaultWorkingDirectory)/$(dockerFileName)
        imageName: '$(imageName)-test'
    ```

1. Run the tests, by invoking docker run against the test runner container.

    ```yaml
    - task: Docker@1
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureContainerRegistry: $(AzureContainerRegistry)
        command: 'run'
        containerName: testrunner
        volumes: '$(System.DefaultWorkingDirectory)/TestResults:/app/tests/TestResults'
        imageName: '$(imageName)-test'
        runInBackground: false
    ```

1. Publish the test results. See [Integrate build and test tasks](/azure/devops/pipelines/languages/docker?view=azure-devops&tabs=yaml#integrate-build-and-test-tasks).

    ```yaml
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'VSTest' # Options: JUnit, NUnit, VSTest, xUnit
        testResultsFiles: 'TestResults/*.trx'
        searchFolder: '$(System.DefaultWorkingDirectory)'
        publishRunAttachments: true
    ```

1. Build the runtime container.

    ```yaml
    - task: Docker@1
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureContainerRegistry: $(AzureContainerRegistry)
        dockerFile: $(System.DefaultWorkingDirectory)/$(dockerFileName)
        includeLatestTag: false
        imageName: '$(imageName)'
    ```

1. Push to the container to Azure Container Registry (or other container registry).

    ```yaml
    - task: Docker@1
      inputs:
        azureSubscriptionEndpoint: $(AzureSubscription)
        azureContainerRegistry: $(AzureContainerRegistry)
        command: 'Push an image'
        imageName: '$(imageName)'
        includeSourceTags: false
    ```

1. Package the Helm chart.

    ```yaml
    - task: HelmDeploy@0
      inputs:
        command: package
        chartPath: $(chartPath)
        chartVersion: $(Build.SourceBranchName)
        arguments: '--app-version $(Build.SourceBranchName)'
    ```

1. Push the Helm package to Azure Container Registry (or other Helm repository).

    ```yaml
    task: AzureCLI@1
      inputs:
        azureSubscription: $(AzureSubscription)
        scriptLocation: inlineScript
        inlineScript: |
        az acr helm push $(System.ArtifactsDirectory)/$(repositoryName)-$(Build.SourceBranchName).tgz --name $(AzureContainerRegistry);
    ```

&#11162; See the [source file](https://github.com/mspnp/microservices-reference-implementation/blob/master/src/shipping/delivery/azure-pipelines-ci.yml).

Tasks in the release pipeline:

- Deploy to dev/QA/staging environments.
- Wait for an approver to approve or reject the deployment.
- Retag the container image for release
- Push the release tag to the container registry.
- Upgrade the Helm chart in the production cluster.

For more information about creating a release pipeline, see [Release pipelines, draft releases, and release options](/azure/devops/pipelines/release/?view=azure-devops).

The following diagram shows the end-to-end CI/CD process described in this article:

![CD/CD pipeline](./images/aks-cicd-flow.png)

## Next steps

This article was based on a reference implementation that you can find on [GitHub](https://github.com/mspnp/microservices-reference-implementation).