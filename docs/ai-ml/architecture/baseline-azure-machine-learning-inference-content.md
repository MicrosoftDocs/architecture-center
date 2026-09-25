This article describes a baseline reference architecture for Azure Machine Learning online inference in a typical enterprise environment. It prioritizes private networking, environment isolation, controlled promotion of trained model and environment artifacts, and clear separation of responsibilities between platform engineering, data science, and operations.

The architecture uses three isolated environments: *Dev*, *Stage*, and *Prod*. Each environment has its own subscription. Model training occurs in Dev. Versioned model and environment assets are published to a shared Azure Machine Learning registry and promoted through Stage to Prod. Stage and Prod are inference-focused environments. Azure Kubernetes Service (AKS) is the primary inference server host. The [Azure Machine Learning extension](/azure/machine-learning/how-to-deploy-kubernetes-extension) runs on each cluster to enable Kubernetes online endpoints, and Azure Machine Learning deployment workflows manage blue/green rollout and traffic shifting.

Each environment uses a dual-network model. An Azure Machine Learning managed virtual network provides outbound isolation for Azure Machine Learning-managed compute, such as compute instances, compute clusters, and serverless Spark. A virtual network that you create and manage, the BYO virtual network, hosts everything else: AKS, Azure Container Registry, Azure API Management, Azure Application Gateway, private endpoints, CI/CD runners, jump boxes, and the egress firewall.

> [!IMPORTANT]
> This architecture focuses on online inference. Streaming inference is out of scope. You can add batch scoring as an extension when your workload requires it. This baseline is a single-region architecture. See [Reliability](#reliability) for regional failover guidance.

## Architecture

The architecture has four planes:

- **Data and feature plane.** Azure Data Lake Storage is the primary data source and the offline feature store. A feature store that you provide, with an offline layer on Data Lake Storage and a low-latency online store, serves training data generation and request-time lookups. This baseline doesn't use the Azure Machine Learning managed feature store. See [Alternatives](#alternatives).
- **Machine learning plane.** Azure Machine Learning provides the workspace, training compute, model registration, environment management, and endpoint and deployment definitions.
- **Inference plane.** AKS hosts online inference behind Kubernetes online endpoints. Blue/green traffic control is managed by Azure Machine Learning.
- **Access and operations plane.** API Management, Application Gateway with a web application firewall (WAF), Azure Firewall, private endpoints, hybrid DNS, self-hosted runners, and jump boxes provide governance and operations.

The following views show how the baseline is implemented in each environment.

# [Dev environment](#tab/dev-environment)

:::image type="complex" source="_images/dev-machine-learning-architecture.png" lightbox="_images/dev-machine-learning-architecture.png" alt-text="Diagram that shows the development environment architecture for the baseline Azure Machine Learning inference platform." border="false":::
The Dev subscription contains a BYO virtual network above an Azure Machine Learning managed virtual network. On the left, the BYO network has private endpoints for the shared registry, workspace, storage, container registry, Key Vault, and Azure Monitor. To the right of that is AKS inference, an SRE jump box, a CI/CD runner, and a customer-provided online feature store. Controlled egress exits through shared inspection. The managed network contains the workspace, private endpoints, training compute, serverless Spark, and compute instances. Numbered steps run from compute instances (1), Spark (2), and training (3), through candidate registration (4), image and environment publication (5), and AKS smoke testing (6). Source control (7) connects to the jump box. Approved models and environments (8) flow to the shared registry below, which contains storage and a container registry. A data source at left connects to workspace storage. Monitoring and managed identities are on the right.
:::image-end:::

## Dev workflow

1. Data scientists use Azure Machine Learning compute instances for exploratory analysis and experimentation. They connect over VPN or Azure ExpressRoute with hybrid DNS resolution.
1. Serverless Spark jobs prepare source data and engineer features from Data Lake Storage. They materialize curated feature sets into the offline feature layer and the Dev online store by using a single transformation implementation.
1. Azure Machine Learning compute clusters run training jobs. Azure Machine Learning tracks metrics, artifacts, and lineage.
1. Data scientists register validated model versions in the Dev workspace. These versions are promotion candidates, not approved artifacts.
1. CI pipelines package inference code, build the container image, push it to the Dev container registry, and register a versioned Azure Machine Learning environment in the Dev workspace that references the image by digest.
1. The pipeline deploys the candidate model and environment to a Kubernetes online endpoint on the Dev AKS instance and runs smoke tests against the versioned deployment definition. Dev has no API Management or Application Gateway instance. The endpoint is reachable only from the runners and jump box subnets.
1. Azure Machine Learning endpoint definitions, deployment settings, and traffic configuration are versioned in source control.
1. The promotion pipeline shares the approved model version and its Azure Machine Learning environment to the shared Azure Machine Learning registry. This step is the promotion boundary between Dev and the inference environments.

# [Stage environment](#tab/stage-environment)

:::image type="complex" source="_images/stage-machine-learning-architecture.svg" lightbox="_images/stage-machine-learning-architecture.svg" alt-text="Diagram that shows the staging environment architecture for the baseline Azure Machine Learning inference platform." border="false":::
The Stage subscription contains a BYO virtual network above an Azure Machine Learning managed virtual network. From left to right, the BYO network contains Application Gateway with WAF, API Management, private endpoints for the shared registry and Stage services, AKS inference, CI/CD runners, a jump box, a customer-provided online feature store, and Azure Firewall. The managed network below contains the workspace, private endpoints, outbound firewall, and serverless Spark. Numbered markers identify the runners (1), AKS (2), Azure Monitor (3), the jump box (4), and source control (5), which connects to the runners. The shared subscription below contains registry storage and a container registry. Registry private endpoints connect to it, and approved model and environment versions flow up into Stage. A data source at left connects to workspace storage. Monitoring and managed identities are on the right. The legend marks routes and network security groups.
:::image-end:::

## Stage workflow

1. The promotion pipeline imports the approved image by digest from the registry Container Registry instance into the Stage Container Registry instance. It then registers a Stage workspace environment that references the imported digest and carries the registry environment name and version as tags for lineage. Finally, the pipeline creates the Kubernetes online deployment in the Stage workspace by using the registry model version, the Stage workspace environment, and the versioned deployment definition.
1. Azure Machine Learning applies the candidate release to the Stage endpoint as a new deployment with 0% traffic.
1. The pipeline runs integration, performance, and reliability checks by using a Stage-only API Management test operation that overwrites `azureml-model-deployment` with the candidate deployment name. Restrict this operation to the promotion identity so the full ingress chain exercises the candidate without exposing deployment selection to normal consumers.
1. Platform engineering validates policy, identity, network, and private endpoint behavior under Stage controls.
1. Release approvers review rollout and rollback evidence before approving promotion to Prod.

# [Prod environment](#tab/prod-environment)

:::image type="complex" source="_images/prod-machine-learning-architecture.svg" lightbox="_images/prod-machine-learning-architecture.svg" alt-text="Diagram that shows the production environment architecture for the baseline Azure Machine Learning inference platform." border="false":::
The Prod subscription contains a BYO virtual network above an Azure Machine Learning managed virtual network. From left to right, the BYO network has Application Gateway with WAF, API Management, private endpoints for the registry and Prod services, AKS inference, CI/CD runners, a jump box, an online feature store, and Azure Firewall. The managed network below contains the workspace, private endpoints, outbound firewall, and serverless Spark. At the left, an on-premises network connects through ExpressRoute to Azure DNS Private Resolver, and a data source connects to workspace storage. Markers identify the runners (1), AKS (2), Azure Monitor (3), and source control (4), which connects to the runners. The shared subscription below contains registry storage and a container registry. Approved model and environment versions flow from it into Prod. Monitoring and managed identities are on the right, above the Prod subscription. The legend marks routes and network security groups.
:::image-end:::

## Prod workflow

1. The promotion pipeline imports the Stage-approved image by digest into the Prod container registry, registers a Prod workspace environment that references that digest, and creates the Kubernetes online deployment in the Prod workspace from the same registry model version and the same image digest that Stage validated.
1. Azure Machine Learning performs a blue/green rollout on the Prod endpoint. The new deployment starts at 0% traffic, and the pipeline shifts traffic in stages after health checks and workload validation.
1. Operations monitor latency, error rates, saturation, drift indicators, and platform health and trigger rollback when thresholds are exceeded.
1. Monitoring findings, incidents, and performance observations feed back into Dev planning.

---

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-baseline.vsdm) of the diagrams in this article.*

## Workflow

The preceding environment tabs describe the execution steps. This section explains how work crosses environment boundaries.

:::image type="complex" source="_images/machine-learning-basic-workflow.png" lightbox="_images/machine-learning-basic-workflow.png" alt-text="Diagram that shows the end-to-end promotion workflow across Dev, Stage, and Prod environments." border="false":::
Four boxes form two rows. At upper left, the Dev subscription trains and registers candidates, builds an image, and smoke tests on AKS. A publish arrow points right to the shared Azure Machine Learning registry, the promotion gate for approved models and environments. Consume arrows point down from the registry to both lower boxes. At lower left, the Stage subscription imports the image, uses blue/green deployment, and validates through API Management. An approve arrow points right to the Prod subscription, which deploys the versions that Stage validated, shifts traffic in stages, and monitors them. Prod incidents, drift, and performance findings return to Dev planning.
:::image-end:::

### Environment handoff criteria

- **Dev to shared Azure Machine Learning registry.** The candidate passes smoke tests on the Dev AKS instance, the model version records lineage to the training job and the image digest, and the deployment definition is versioned. Only the Dev promotion pipeline identity can write to the shared Azure Machine Learning registry in the shared platform subscription.
 - **Registry to Stage.** The handoff is automatic on publish. Stage deploys the published model version, imports the image by digest, and registers a Stage workspace environment that retains the registry environment name and version as lineage tags.
 - **Stage to Prod.** Functional and nonfunctional checks pass through the full ingress chain, rollback is exercised, and security controls are verified. Prod deploys the same registry model version, image digest, and versioned deployment definition that Stage validated.
- **Prod to Dev.** Incidents, drift findings, and performance observations are captured and prioritized for the next iteration.

## Components

- **[Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning)** provides workspaces, training compute, model registration, environment management, and endpoint and deployment definitions.

  - **One workspace per environment** isolates Dev, Stage, and Prod. Each workspace has its own key vault, storage account, container registry, and Application Insights instance, all reachable only through private endpoints.
  - **Compute instances (Dev only)** support interactive notebooks and experimentation. **Compute clusters (Dev only)** run shared training jobs and keep these workloads separate from personal compute instances.
  - **Serverless Spark** runs data preparation and feature engineering in Dev, feature materialization in Stage and Prod, and a custom monitoring pipeline in Prod. Materialization jobs are the single write path to both the offline and online feature layers. Serverless Spark runs inside the managed virtual network and requires that you provision the network with Spark support before the first job. See [Configure for serverless Spark jobs](/azure/machine-learning/how-to-managed-network#configure-for-serverless-spark-jobs).
  - **Workspace managed identity.** Workspaces created after November 19, 2024, receive the **Azure AI Administrator** role on the containing resource group. Workspaces created before that date received **Contributor**. For those older workspaces, replace the **Contributor** role assignment with **Azure AI Administrator**. See [Manage roles in your workspace](/azure/machine-learning/how-to-assign-roles).

- **[Azure Machine Learning registry](/azure/machine-learning/concept-machine-learning-registries-mlops)** is the promotion gate. It holds approved model versions and Azure Machine Learning environment versions and makes them available to the Stage and Prod workspaces, which consume from the registry rather than from Dev.

  - Deploy one registry in a shared platform subscription, not one per environment and not inside Prod. A registry in Prod inverts the dependency direction and makes Dev depend on a production resource.
  - Azure Machine Learning creates the registry's backing storage account and container registry in a managed resource group named `azureml-rg-<registry-name>_<GUID>`. Account for those resources in your private endpoint, policy, and cost design.
  - Only the Dev promotion pipeline identity can write to the registry. Data scientists register candidates in the Dev workspace and never write to the registry, which keeps Dev churn out of the artifact supply chain that Prod consumes.
  - Create environment assets in the Dev workspace and share them to the registry. Creating an environment asset directly in a registry isn't supported when the registry's Container Registry instance has public access disabled. Sharing components from a workspace to a registry isn't supported.
  - Expect reduced portal functionality. When the registry uses network isolation, Azure Machine Learning studio shows model assets but not registry operations. Use the CLI or SDK from the runners or the SRE jump box.

- **[Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service)** is the online inference host. Use AKS when you need Kubernetes-level control, private networking, and customer-managed runtime behavior. One cluster per environment is located in that environment's subscription. Azure Machine Learning doesn't support attaching an AKS cluster from a different subscription.

  - **[Azure Machine Learning extension](/azure/machine-learning/how-to-deploy-kubernetes-extension)** enables Kubernetes online endpoints on the cluster. Configuration values and constraints are in [Inference cluster configuration](#inference-cluster-configuration).
  - **Kubernetes compute target.** After the extension is installed, the cluster is attached to the environment's workspace as a Kubernetes compute target with a system-assigned managed identity. That compute identity is what the extension uses to pull the inference image and read model artifacts. See [Identity and access](#identity-and-access).

- **[Azure Container Registry](/azure/container-registry/container-registry-intro)** stores inference images. Each environment has a Premium Azure Container Registry instance behind a private endpoint. The Dev container registry holds images while they're built and validated. Stage and Prod container registries hold images that the promotion pipeline imports by digest. The registry's own Container Registry instance holds the image copy that backs the shared environment asset. See [Image supply chain](#image-supply-chain).

- **[Azure Data Lake Storage](/azure/well-architected/service-guides/azure-blob-storage)** is the primary data source. Use hierarchical-namespace-enabled storage accounts and register each filesystem as a Data Lake Storage datastore (`type: azure_data_lake_gen2`). Serverless Spark jobs can access data via an `azureml://` datastore URI or a direct `abfss://` URI.

- **A feature store that you provide** serves both training-time and request-time feature access. This baseline doesn't use the Azure Machine Learning managed feature store, because its built-in online materialization store targets Azure Cache for Redis (`Microsoft.Cache/Redis`), which is retiring, and no supported alternative online store exists. See [Alternatives](#alternatives).

  The feature store has two layers, and you own both:

  - **Offline layer.** Data Lake Storage containers hold point-in-time-correct feature history, written by serverless Spark materialization jobs and read by training jobs. Keep feature-set definitions and transformation code in source control and promote them with the model.
  - **Online layer.** A low-latency store, deployed per environment in the same region as the AKS cluster, is queried by the inference containers at request time. Select a store that your platform team already operates, that supports Azure Private Link or virtual network injection, and that authenticates with Microsoft Entra ID and managed identities. Azure Managed Redis, Azure Cosmos DB, and Azure Database for PostgreSQL are supported as managed virtual network private endpoint targets.

  Responsibilities that follow from providing the store:

  - **Write path.** Materialize online features from the same transformation code that produces offline features so that training and serving stay in parity.
  - **Read path.** Perform lookups from the inference container. Budget the lookup inside the end-to-end latency target, and apply a timeout and a defined fallback so that a feature store failure degrades a prediction rather than failing the request.
  - **Freshness.** Define acceptable staleness per feature set, set materialization cadence and time-to-live to match, and monitor them.
  - **Point-in-time correctness.** Training data generation must join feature history on event timestamps explicitly. Treat that join logic as a versioned, tested library.

- **[Azure API Management](/azure/well-architected/service-guides/azure-api-management)** presents the unified API surface for inference consumers in Stage and Prod, authenticates callers, and performs the token exchange that Kubernetes online endpoints require. See [Backend authentication](#backend-authentication-to-kubernetes-online-endpoints).

- **[Azure Application Gateway with WAF](/azure/well-architected/service-guides/azure-application-gateway)** is the only internet-facing component, and only in Prod. It applies OWASP-based inspection and forwards to internal-mode API Management. Stage deploys the same chain but is reachable only from enterprise networks.

- **[Azure Virtual Network](/azure/well-architected/service-guides/virtual-network)** and **[Azure Private Link](/azure/private-link/private-link-overview)** enforce private connectivity through the dual-network pattern described in [Networking](#networking).

- **[Azure Firewall](/azure/well-architected/service-guides/azure-firewall)** inspects egress from the Stage and Prod BYO virtual networks. Dev routes egress to the shared inspection point in your hub network instead of deploying its own firewall. Managed virtual network egress is governed separately by the workspace isolation mode.

- **[Azure Key Vault](/azure/key-vault/general/overview)** stores workspace secrets and connection information, the TLS certificate and key for the inference router, and the endpoint key if you can't implement the API Management token exchange. Each workspace has its own vault behind a private endpoint.

- **[Azure Monitor](/azure/azure-monitor/fundamentals/overview)**, with a central [Log Analytics workspace](/azure/well-architected/service-guides/azure-log-analytics) and per-workspace [Application Insights](/azure/well-architected/service-guides/application-insights), collects platform and workload telemetry. Link these resources to an Azure Monitor Private Link Scope (AMPLS), configure **Private Only** ingestion, and block public ingestion on each Log Analytics workspace. Resource-specific Log Analytics ingestion doesn't follow the AMPLS access mode, so both settings are required to prevent a public ingestion path.

- **Hybrid DNS** uses [Azure DNS Private Resolver](/azure/dns/dns-private-resolver-overview) in each BYO virtual network and conditional forwarding from enterprise DNS so private endpoint names, the inference router FQDN, and AMPLS zones resolve consistently from Azure and on-premises networks in all three environments.

- **[Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute)** or VPN provides private connectivity from on-premises networks. Data scientists reach Dev in this way. Operators reach Stage and Prod in this way.

- **Self-hosted CI/CD runners** run in the runners subnet of each environment with line-of-sight to that environment's private endpoints, Container Registry instance, AKS instance, and the registry. They execute infrastructure delivery and model promotion under separate workload identities.

- **SRE jump boxes** support break-glass and CLI/SDK operations that Machine Learning studio can't perform against a private registry. Production and nonproduction jump boxes are separate. Data scientists don't use jump boxes.

## Networking

The networking design separates managed compute from workload resources and controls ingress, private connectivity, name resolution, and egress for each environment.

### Virtual network and subnet layout

Deploy the dual-network pattern separately in each environment. Keep BYO virtual network address spaces non-overlapping to simplify hub integration and route governance. In your organization's hub-spoke topology, place shared inspection and DNS services in the hub and keep Azure Machine Learning workload resources in spoke virtual networks.

| Network boundary | Environments | Purpose | Typical resources |
| --- | --- | --- | --- |
| Azure Machine Learning managed virtual network | Dev, Stage, Prod | Outbound isolation for Azure Machine Learning-managed compute | Dev: compute instances, compute clusters, serverless Spark.<br> Stage and Prod: serverless Spark for feature materialization. Prod also runs a custom monitoring pipeline. |
| BYO virtual network | Dev, Stage, Prod | Hosts everything that isn't Azure Machine Learning-managed compute | AKS, Container Registry, API Management, Application Gateway, Azure Firewall, private endpoints, runners, jump boxes, DNS Private Resolver. |

Use the following subnet layout as a baseline for each BYO virtual network:

| Subnet | Environments | Purpose | Typical resources |
| --- | --- | --- | --- |
| App Gateway | Stage, Prod | Ingress and WAF boundary | Application Gateway v2 with WAF. Internet-facing in Prod only. |
| API Management | Stage, Prod | API gateway and policy layer | API Management in internal mode, fronted by Application Gateway. |
| Private Endpoints | Dev, Stage, Prod | Private Link endpoints | Environment workspace, Key Vault, storage, environment container registry, Data Lake Storage, shared Azure Machine Learning registry, registry backing storage, registry backing container registry, AMPLS, and the online store (if the online store supports Private Link). |
| Inference | Dev, Stage, Prod | Online inference runtime | AKS node pools and the internal load balancer for the Azure Machine Learning inference router. |
| Runners | Dev, Stage, Prod | CI/CD execution with private line-of-sight | Self-hosted CI/CD runners. |
| Jump box | Dev, Stage, Prod | SRE operations access | SRE jump-box VMs, accessed through Azure Bastion (private only). |
| Feature store | Dev, Stage, Prod | Online feature store that requires virtual network injection | Only when the store you provide doesn't support Private Link. |
| Firewall | Stage, Prod | Egress inspection | Azure Firewall or a non-Microsoft NVA. Dev routes egress to shared hub inspection instead. |
| Private Resolver | Dev, Stage, Prod | Hybrid name resolution | Azure DNS Private Resolver inbound and outbound endpoints (or hub-hosted). |

Design recommendations:

- Apply network security groups per subnet and explicitly allow only required flows.
- Use user-defined routes to direct BYO virtual network egress through the firewall subnet in Stage and Prod, and to the shared hub inspection point in Dev.
- Keep private endpoint subnet policies aligned with Private Link requirements.
- Separate production and nonproduction jump-box infrastructure.

### Ingress

Prod is the only environment with internet-facing ingress. You can reach Dev and Stage environments only through enterprise network paths. The production ingress chain is:

1. **Application Gateway with WAF** receives public HTTPS traffic and applies OWASP-based inspection.
1. **API Management (internal mode)** authenticates callers, enforces policy and throttling, versions the API, and exchanges the caller's identity for an Azure Machine Learning token.
1. **Azure Machine Learning inference router (`azureml-fe`)** on AKS, exposed on an internal load balancer, routes to the deployment that owns the traffic percentage.

Make TLS termination and certificate ownership explicit at each hop: Application Gateway (platform team), API Management (platform team), and the inference router certificate stored as the `sslSecret` on the cluster (workload team, sourced from Key Vault).

### Inference cluster configuration

Install the Azure Machine Learning extension with `enableInference=True`, `inferenceRouterServiceType=loadBalancer`, `internalLoadBalancerProvider=azure`, `allowInsecureConnections=False`, `sslSecret` set to the Kubernetes secret that holds the CA-issued certificate and key, and `sslCname` set to the private scoring FQDN. Create a private DNS record for that FQDN pointing at the internal load balancer IP, and include the zone in the hybrid DNS design so that API Management and the runners can resolve it.

Constraints that affect the cluster design:

- **Managed identity is required.** Azure Machine Learning doesn't support service-principal-based AKS clusters.
- **Local accounts must stay enabled.** Azure Machine Learning doesn't support AKS clusters with local accounts turned off. Treat this requirement as a reviewed security exception, and compensate with Microsoft Entra integration and Kubernetes RBAC. If policy requires local accounts to be turned off, choose Azure Machine Learning managed online endpoints instead. See [Alternatives](#alternatives).
- **API server access.** Use [AKS Trusted Access](/azure/aks/trusted-access-feature) to give the Azure Machine Learning workspace access to the Kubernetes API server through the AKS regional gateway. Configure the required Trusted Access role binding for private clusters and clusters that use authorized IP ranges. Keep public API server access disabled for private clusters.
- **Inference router high availability.** The extension deploys three `azureml-fe` replicas by default and requires at least three worker nodes. Keep `inferenceRouterHA=True` and spread the system node pool across availability zones.
- **Sizing.** Define Azure Machine Learning instance types on the cluster for each model's CPU and memory profile, and scale by using deployment `instance_count` plus the AKS cluster autoscaler. For production, use at least three worker nodes and ensure that the cluster has at least four vCPU cores and 14 GB of memory in total.

### Backend authentication to Kubernetes online endpoints

Kubernetes online endpoints don't support Microsoft Entra token (`aad_token`) authentication. They support key or Azure Machine Learning token (`aml_token`) authentication. Configure them with `aml_token`, and never expose the endpoint credential to API consumers.

Configure API Management as the only caller of the endpoint:

1. Authenticate API consumers at API Management by validating their Microsoft Entra access tokens and applying API-specific authorization policies.
1. Assign the API Management managed identity a custom role that permits only `Microsoft.MachineLearningServices/workspaces/onlineEndpoints/token/action` on the specific endpoint. Don't grant deployment, key-listing, or workspace-wide permissions.
1. In the normal consumer operation, delete any client-supplied `azureml-model-deployment` header. Then use the API Management managed identity to call the endpoint token operation and replace the client `Authorization` header with the Azure Machine Learning token before forwarding to the private scoring FQDN. Only the restricted Stage test operation should set `azureml-model-deployment`.
1. Cache the Azure Machine Learning token only until its `refreshAfterTimeUtc` value is reached, then request a replacement. Don't store Azure Machine Learning tokens in API Management named values, Key Vault, source control, deployment variables, or application configuration.
1. Send API Management gateway logs, API Management policy and role-assignment changes, Azure Machine Learning endpoint traffic logs, and Azure activity logs to the central Log Analytics workspace. Alert on failed token requests, unexpected token-action calls, endpoint key operations, and changes to API Management policies or the identity's role assignments.

Use endpoint keys only when your platform can't implement the token exchange. In that case, store the active key as a versionless Key Vault secret referenced by an API Management named value, retrieve it with the API Management managed identity, rotate by using the endpoint's secondary key to avoid downtime, and audit Key Vault secret access and key-regeneration operations.

### Egress

Route outbound network traffic through controlled inspection points instead of allowing direct internet access from workload subnets.

- Route traffic from AKS, runners, jump boxes, and API Management through Azure Firewall or an equivalent network virtual appliance that your platform team manages. In Stage and Prod, that firewall is located in the environment's firewall subnet. In Dev, user-defined routes send egress to the shared inspection point in the hub network, so Dev doesn't run its own firewall.
- Use FQDN allow lists for required dependencies, such as package feeds and approved external APIs.
- Prefer private endpoints for Azure Machine Learning, Container Registry, storage, and other Azure dependencies to keep service traffic on private networking.
- Use managed identities for service-to-service authentication to reduce secret sprawl.

For data science package acquisition in Dev, the baseline supports two patterns:

- **Quarantine pattern (baseline).** Route package acquisition through an [internal curated repository](/azure/architecture/patterns/quarantine) such as Azure Artifacts, JFrog Artifactory, or an equivalent system exposed through a private endpoint outbound rule. Configure `pip` and `conda` on compute instances to use the internal curated repository. No FQDN rules are needed, so no managed-network firewall is provisioned.
- **Agility pattern.** Add FQDN outbound rules for `pypi.org`, `*.pythonhosted.org`, and the conda hosts listed in [Access public machine learning packages](/azure/machine-learning/how-to-managed-network#scenario-access-public-machine-learning-packages), accept the Azure Firewall cost, and monitor outbound traffic. Note that FQDN rules don't propagate to serverless Spark sessions. Spark package dependencies must come from a self-contained wheel in a private-endpoint-reachable storage account.

Stage and Prod managed virtual networks run materialization jobs, and Prod also runs a custom monitoring pipeline. They need private endpoint rules to Data Lake Storage, the online store, and the workspace default resources. Prod also needs a private endpoint rule to the monitoring destination through AMPLS.

### Private endpoint approval in the managed virtual network

Grant the workspace managed identity the **Azure AI Enterprise Network Connection Approver** role, or an equivalent scoped custom role, on every resource that a private endpoint outbound rule targets. Private endpoint creation fails silently at provisioning time without it. The managed virtual network supports private endpoint outbound rules for a defined set of services, including Azure Storage, Key Vault, Container Registry, Azure Machine Learning registries, Azure Managed Redis, Azure Cosmos DB, Azure SQL, Azure Database for PostgreSQL, Azure Database for MySQL, and Application Insights through AMPLS. Confirm your online store appears in [Managed virtual network isolation](/azure/machine-learning/how-to-managed-network#private-endpoints) before you commit to it.

### Online feature store connectivity

The online store is on the request path, so it needs private connectivity from the inference plane and from serverless Spark materialization jobs in the Azure Machine Learning managed virtual network.

1. Expose the store through a private endpoint in the **Private Endpoints** subnet and disable public network access. If the store requires virtual network injection instead, place it in the **Feature Store** subnet. Some stores allow you to turn off public access only at creation time. Check whether this limitation applies to your store before you deploy.
1. Give the **Inference** subnet line-of-sight to that private endpoint. Request-time lookups originate from AKS inference pods, not from Azure Machine Learning compute.
1. Add a `private_endpoint` outbound rule on each workspace's managed virtual network so that serverless Spark materialization jobs can write to the store.
1. Add the private endpoint records to the hybrid DNS design so the store resolves consistently from the managed virtual network, the BYO virtual network, and on-premises networks.
1. Deploy the store in the same region as the AKS cluster. Cross-region lookups add round-trip latency to every scored request.
1. Authenticate with Microsoft Entra ID and managed identities when the store supports that type of authentication. Use Key Vault secrets only when the store has no identity-based option.

### Model registry connectivity

The shared registry is hosted outside the environment subscriptions, so both the publish path from Dev and the consume path in Stage and Prod cross a subscription boundary.

- In each environment, create private endpoints to the registry, its backing storage account, and its backing container registry in the same subnet that holds the Azure Machine Learning workspace private endpoint. Confirm that public network access is disabled on the registry, its storage, and its container registry. Allow trusted services to bypass the network on the shared registry's backing container registry and on each environment container registry so that the container registry image-import operation can access the restricted registries.
- Plan a documented exception on the Dev workspace storage account. Data exfiltration protection blocks asset sharing from a secure workspace to a private registry when the workspace storage account has public network access fully disabled. Set that account to **Enabled from selected virtual networks and IP addresses**, then add a resource instance rule for the `Microsoft.MachineLearningServices/registries` resource type that names your registry. Scope this deviation to the Dev workspace storage account only. Stage and Prod never share to the registry.
- Make sure hybrid DNS can resolve the registry's private FQDN, which has the form `<registry-guid>.registry.<region>.privatelink.api.azureml.ms`. There is no public resource-specific name that Azure DNS resolves recursively.

### Image supply chain

The registry serves as the system of record that approves model and environment versions. However, this baseline doesn't configure AKS clusters to pull images directly from the registry's Container Registry instance at runtime. The registry's scoped-token pull flow is documented for workspace compute, and the registry network-isolation guidance covers deployment to managed online endpoints, not Kubernetes online endpoints. To keep the runtime pull path fully inside each environment and fully documented:

1. Dev CI builds the image, pushes it to the Dev container registry, and records the digest in the Azure Machine Learning environment asset.
1. The Dev promotion pipeline shares the environment to the registry, which copies the image into the registry's Container Registry instance alongside the model version.
1. The Stage and Prod promotion pipelines import the image by digest from the registry Container Registry instance into the environment container registry, and the Kubernetes deployment references that environment Container Registry image. The registry environment version remains the lineage record.
1. The Kubernetes compute target's managed identity holds `AcrPull` on its environment's container registry only.

## Identity and access

Use the following table as a starting point for per-persona role assignments. Role names come from Azure built-in role definitions. The persona mappings reflect the separation of duties that this baseline assumes. Validate them against your own segregation-of-duties requirements.

| Persona or identity | Dev | Stage | Prod |
| --- | --- | --- | --- |
| Data scientist | AzureML Data Scientist | Reader | No standing access |
| Machine learning engineer | AzureML Data Scientist and AzureML Compute Operator | Reader | Reader |
| Platform engineering | Owner on the infrastructure scope | Owner on the infrastructure scope | Owner through a pipeline identity; JIT for humans |
| SRE and operations | Reader | Reader | AKS and Azure Monitor operational roles |
| Dev promotion pipeline identity | AzureML Registry User on the registry; AcrPush on the Dev container registry | Not applicable | Not applicable |
| Stage/Prod deployment pipeline identity | Not applicable | Custom role: registry model and environment read; endpoint and deployment read/write on the workspace; Container Registry Data Importer and Data Reader on the shared registry's backing container registry and the Stage container registry | Same as Stage, with the Prod container registry |
| Kubernetes compute target managed identity | AcrPull on the Dev container registry; Storage Blob Data Reader on the workspace storage container that holds model artifacts | AcrPull on Stage container registry; Storage Blob Data Reader, as in Dev | AcrPull on the Prod container registry; Storage Blob Data Reader, as in Dev |
| API Management managed identity | Not applicable | `onlineEndpoints/token/action` on the endpoint | `onlineEndpoints/token/action` on the endpoint |
| Workspace managed identity | Azure AI Enterprise Network Connection Approver on private endpoint targets | Same as Dev| Same as Dev|

Apply these constraints:

- **AzureML Registry User.** This role grants read, write, and delete on registry assets and exceeds what Stage and Prod need. Grant it only to the Dev promotion pipeline identity. Define a scoped custom role for consume-only paths.
- **Container Registry image import permissions.** Grant each Stage and Prod deployment pipeline identity **Container Registry Data Importer and Data Reader** on both the shared registry's backing container registry and its environment container registry. This role allows the identity to read the source image and trigger the import into the target registry. `AcrPush` doesn't grant the permissions required by the Container Registry import operation.
- **Container Registry import network exception.** Allow trusted services to bypass the network on the shared registry's backing container registry and each environment container registry. Keep public network access disabled and retain private endpoints. This exception is required because Container Registry import is performed by the service rather than from the pipeline runner's network.
- **Don't grant pipeline identities `AcrPull`.** Image pulls at runtime are performed by the Kubernetes compute target's managed identity through the extension's `amlarc-identity-controller` and `amlarc-identity-proxy` components, which request and renew Container Registry and Blob tokens on behalf of that identity. Grant `AcrPull` to the compute managed identity, scoped to the container registry that holds the deployed image.
- **Deployment pipeline permissions.** Grant each Stage and Prod pipeline identity `onlineEndpoints/read`, `onlineEndpoints/write`, `onlineEndpoints/deployments/read`, `onlineEndpoints/deployments/write`, `environments/read`, and `environments/write` on its target workspace. These permissions allow registering the promoted workspace environment and creating or updating deployments and endpoint traffic without granting registry write, endpoint key operations, or unrelated workspace permissions.
- **Scope storage roles to containers.** Assign **Storage Blob Data Contributor** to the serverless Spark materialization identity and **Storage Blob Data Reader** to training compute, scoped to the specific Data Lake Storage feature containers instead of the entire storage account.

For role definitions, see [Manage access to Azure Machine Learning workspaces](/azure/machine-learning/how-to-assign-roles) and [Azure built-in roles for AI and machine learning](/azure/role-based-access-control/built-in-roles/ai-machine-learning).

## Alternatives

The baseline reflects the recommended approach for regulated online inference, but other choices might fit your workload better.

### Inference hosting: Azure Machine Learning managed online endpoints

**Baseline:** AKS with the Azure Machine Learning extension and Kubernetes online endpoints.

**Alternative:** Azure Machine Learning managed online endpoints, which run inside the workspace managed virtual network.

Choose managed online endpoints when you want to reduce platform operations overhead, when you need native Microsoft Entra token authentication on the endpoint without the API Management token-exchange pattern that Kubernetes online endpoints require, or when policy requires AKS local accounts to be turned off. Keep AKS when you need Kubernetes-level network control, custom runtime behavior, GPU scheduling that you manage, or colocation with other Kubernetes workloads.

### Feature store: Azure Machine Learning managed feature store

**Baseline:** A feature store that you provide, with Data Lake Storage as the offline layer and a private-link-capable online store.

**Alternative:** [Azure Machine Learning managed feature store](/azure/machine-learning/concept-what-is-managed-feature-store), which adds managed feature set definitions, materialization scheduling, and point-in-time-correct training data generation.

Choose the managed feature store only if you need offline feature management and can accept its online store limitation: the built-in online materialization store supports only Azure Cache for Redis, which is retiring, and there's no supported way to substitute another store. Its network isolation also requires the `allow_internet_outbound` managed network mode, which conflicts with the approved-outbound isolation this baseline uses.

### Data platform: Microsoft OneLake-oriented patterns

**Baseline:** Data Lake Storage as the data source and offline feature layer.

**Alternative:** OneLake-oriented data platform patterns where organizational standards and maturity justify that approach.

Whichever approach you choose, keep one primary data authority for training and inference to avoid dual-source drift.

### Package governance: public package feeds

**Baseline:** Curated internal package repository reached through a private endpoint outbound rule.

**Alternative:** FQDN outbound rules to public feeds such as PyPI and conda in Dev, with monitoring.

Choose the alternative when data science agility outweighs package provenance requirements, and budget for the Azure firewall that FQDN rules provision inside the managed network.

### Runner topology

**Baseline:** Self-hosted runners per environment, with infrastructure and model promotion pipelines under separate workload identities.

**Alternative:** Separate runner pools per pipeline type per environment when segregation-of-duties policy requires that infrastructure runners can never reach model deployment scopes.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Blue/green deployment with staged traffic shifting** is the rollback mechanism. Keep the previous deployment alive at 0% traffic until the new one serves a full business cycle, because shifting traffic back is faster than redeploying. Traffic mirroring isn't available on Kubernetes online endpoints, so use Stage for shadow-style validation instead.
- **Immutable artifacts.** Prod deploys the exact registry versions that Stage validated, and images are referenced by digest, so a Prod rollout can't drift from what was tested.
- **AKS availability.** Spread node pools across availability zones, keep at least three nodes in the pool that hosts the inference router, and set pod disruption budgets for inference deployments so cluster upgrades don't drop capacity below the router's minimum.
- **Capacity reservations.** Use on-demand capacity reservation (ODCR) for the AKS node pool SKUs that Prod inference depends on so that scale-out and node replacement don't fail on regional capacity shortages. Treat this control as a reliability control, not a cost tactic.
- **Feature store recovery.** Regenerate the feature store from raw data and transformation code, for both the offline and online layers. Keep transformation code in source control and don't back up the online store as if it were a system of record.
- **Single region.** This baseline is single-region. For regional disaster recovery, deploy the ingress and inference stack in each region, replicate the registry consumers, Data Lake Storage, and the online store, and place Azure Front Door or Azure Traffic Manager in front of the regional Application Gateway instances to route traffic to a healthy region. The shared registry supports multi-region replication. Plan the secondary region at registry creation.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

 - **No public data plane except Prod ingress and the Dev registry-sharing exception.** Azure Machine Learning, Key Vault, Container Registry, registry, monitoring, and Stage and Prod storage dependencies are reachable only through private endpoints. The Dev workspace storage account also permits the named registry resource instance through selected-network public access, as described in [Model registry connectivity](#model-registry-connectivity). The only public ingress endpoint is the Prod Application Gateway instance.
- **Promotion gate enforced by identity.** Only one identity can write to the registry, and Stage and Prod identities can't reach Dev resources, so an unreviewed artifact can't enter production.
- **API Management is the only endpoint caller** and holds only the token action, so a compromised API consumer can't obtain reusable endpoint credentials.
- **Reviewed exception: AKS local accounts enabled.** Compensate with Microsoft Entra-integrated Kubernetes RBAC, no standing cluster-admin assignments, and alerting on `clusterUser` and `clusterAdmin` credential retrieval.
- **Reviewed exception: Dev workspace storage account allows the registry resource instance.** Scope it to the Dev workspace storage account only.
- **No notebooks or interactive compute in Stage or Prod.** Those workspaces have no compute instances, and human access is Reader, except for break-glass access.
- **Managed identities everywhere.** Avoid service principals for AKS, avoid Container Registry admin user, and avoid stored endpoint keys unless the token exchange is impossible.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/9de2e7268faa4a33a0e8841d86370251) includes only the components in this architecture, so customize it to match your usage.

- **Managed virtual network costs.** You pay for private endpoints created by the managed network, and FQDN outbound rules in `allow_only_approved_outbound` mode provision an Azure Firewall. Keep in mind that each FQDN rule incurs additional cost.
- **Don't provision what Stage and Prod don't run.** Their managed virtual networks exist for materialization jobs and, in Prod, custom monitoring. If you run those jobs elsewhere, skip managed network provisioning for those workspaces.
- **Size AKS to the models.** Use Azure Machine Learning instance types and the cluster autoscaler rather than fixed large pools. Keep GPU pools separate and scale to zero where the SKU allows.
- **Use compute clusters, not compute instances, for shared training** so idle personal VMs don't accumulate.
- **Environment isolation gives clean chargeback.** Tag by environment and model, and use per-subscription cost views.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Source control defines** the endpoint and deployment YAML, traffic configuration, feature transformation code, materialization job definitions, and pipeline definitions that promote them.
- **Keep pipelines isolated.** Infrastructure delivery and model promotion run under separate identities and separate approval gates.
- **Don't deploy interactively to production.** Require human approval, and use pipelines to perform deployments.
- **Registry operations are CLI/SDK only** when the registry is network-isolated. Include those commands in the pipelines and the SRE runbooks rather than relying on Azure Machine Learning studio.
- **Implement custom model monitoring in the Prod Azure Machine Learning workspace.** Azure Machine Learning model monitoring doesn't support the [`AllowOnlyApprovedOutbound` managed virtual network isolation setting](/azure/machine-learning/concept-model-monitoring#model-monitoring-limitations) that this baseline uses. Instead of using the built-in monitoring resource, run a custom scheduled Azure Machine Learning pipeline on serverless Spark, access collected inference data and drift baselines through private endpoints, and route metrics and alerts to the operations workflow that owns rollback. Changing the Stage and Prod workspaces to `allow_internet_outbound` enables built-in model monitoring and reduces custom implementation, but it permits unrestricted internet egress from Azure Machine Learning-managed compute and weakens the baseline's data-exfiltration controls. As an alternative, run the custom monitoring pipeline on customer-managed compute in the Prod BYO virtual network to gain direct control of routing and inspection at the cost of operating that compute outside Azure Machine Learning.
- **Review role assignments** on a regular cadence, paying special attention to the registry writer, the API Management token role, and workspace identities that retain the Contributor role.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Scale at two levels.** Deployment `instance_count` handles request concurrency. The AKS cluster autoscaler handles node capacity. Set both based on load-test results in Stage.
- **Keep the feature lookup in the latency budget.** Use a store designed for inference-time lookups, deployed in-region, with a timeout and fallback in the scoring code.
- **Use API Management for throttling and quota** so that one consumer can't exhaust the endpoint's capacity.
- **Separate interactive and training compute** in Dev to reduce noisy-neighbor effects on experiment turnaround.
- **Keep every hop private and in-region,** including Application Gateway, API Management, AKS, the online store, and the workspace storage that holds model artifacts.

## Next step

Learn how to implement CI/CD and retraining pipelines for machine learning workloads.

> [!div class="nextstepaction"]
> [Machine learning operations](../guide/machine-learning-operations-v2.md)

## Related resources

- [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Architecture best practices for Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning)
- [Application platform for AI workloads on Azure](/azure/well-architected/ai/application-platform)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
