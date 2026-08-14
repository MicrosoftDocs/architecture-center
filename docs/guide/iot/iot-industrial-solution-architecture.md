---
title: "OPC UA reference solution"
description: "Learn how to build a standards-based industrial IoT reference solution that uses OPC UA to connect shop-floor telemetry to Azure analytics services."
author: erichb
ms.author: erichb
ms.service: azure-iot
ms.topic: how-to
ms.date: 07/22/2026
---

# OPC UA reference solution

This article provides a standards-based industrial IoT reference solution that uses OPC UA to connect shop-floor telemetry to Azure analytics services. It demonstrates how to ingest, model, and query manufacturing data so you can support scenarios like condition monitoring, OEE analysis, and anomaly detection. Use this architecture as a starting point to validate the approach with a simulation and then adapt it for production workloads.

> [!NOTE]
> This article describes a Microsoft OPC UA reference solution that demonstrates how to send telemetry from OPC UA-enabled industrial assets to Azure. The solution is provided as reference guidance and sample implementation content to help architects and developers understand one possible approach.
>
> This reference solution isn't a Microsoft-supported product offering. Evaluate it carefully before use in production environments. Organizations are responsible for validating that the architecture, components, and operational requirements meet their specific business and technical needs.
>
> For most new production deployments, Microsoft recommends using Azure IoT Operations, which provides a fully supported platform for connecting, managing, and processing industrial telemetry, including data from OPC UA sources. You can use Azure IoT Operations with OPC UA-enabled environments as well as broader industrial and edge scenarios.
>
> To learn more, see the [**Azure IoT Operations Overview**](/azure/iot-operations/overview-iot-operations#architecture-overview).

## Table of contents

- [About this solution](#about-this-solution)
- [Prerequisites](#prerequisites)
  - [Required Azure permissions](#required-azure-permissions)
  - [Required Azure CLI commands](#required-azure-cli-commands)
- [Postrequisites](#postrequisites)
- [Articles in this reference solution](#articles-in-this-reference-solution)
- [Production line simulation](#production-line-simulation)
- [OPC UA certificate trust](#opc-ua-certificate-trust)
- [Access the Arc-enabled Kubernetes cluster from the Azure portal](#access-the-arc-enabled-kubernetes-cluster-from-the-azure-portal)
- [Security review (STRIDE)](#security-review-stride)
  - [Scope and architecture](#scope-and-architecture)
  - [Trust boundaries](#trust-boundaries)
  - [STRIDE analysis](#stride-analysis)
    - [Spoofing](#spoofing)
    - [Tampering](#tampering)
    - [Repudiation](#repudiation)
    - [Information disclosure](#information-disclosure)
    - [Denial of service](#denial-of-service)
    - [Elevation of privilege](#elevation-of-privilege)
  - [Analytics-path-specific considerations (ADX, Databricks, Fabric)](#analytics-path-specific-considerations-adx-databricks-fabric)
  - [Summary of recommendations for production](#summary-of-recommendations-for-production)
  - [Configure OAuth2 for the I3X API via Microsoft Entra ID](#configure-oauth2-for-the-i3x-api-via-microsoft-entra-id)

## About this solution

Manufacturers want to use an industrial IoT solution that doesn't lock them in to walled-garden ecosystems. In addition, they want to deploy this solution on a global scale and connect all of their production sites to it to increase efficiencies for each individual site.

These increased efficiencies lead to faster production, better quality and lower energy consumption, which all lead to lowering the cost for the produced goods.

The solution must be as efficient as possible and enable all required use cases such as condition monitoring, overall equipment effectiveness (OEE) calculation, forecasting, and anomaly detection. By using the insights gained from these use cases, manufacturers can then create digital feedback loops, which can apply optimizations and other changes to the production processes fully automatically.

Interoperability is the key enabler for these requirements. The use of open standards such as OPC UA significantly helps to achieve this interoperability, which led to the establishment of the [OPC Foundation Cloud Initiative](https://opcfoundation.org/cloud). This OPC UA reference solution is Microsoft's implementation of the Cloud Initiative's reference architecture.

## Prerequisites

### Required Azure permissions

The deployment provisions Azure resources, onboards the simulation VM's Kubernetes cluster to Azure Arc, installs Azure IoT Operations, and creates several Azure role assignments. Ensure the user that runs the deployment script has the following:

- **Owner** on the target subscription or resource group (recommended), **or** the combination of **Contributor** and **User Access Administrator** (or **Role Based Access Control Administrator**) so it can both create resources and create the role assignments the template defines.
- **Contributor** (or Owner) at the **subscription** scope for the one-time resource-provider registration below, since `az provider register` is a subscription-scope action.
- Permission to sign in to the target **Microsoft Entra** tenant and read the `custom-locations` application service principal (`az ad sp show`), used when onboarding Azure Arc.

> [!NOTE]
> After the deployment completes, a subscription **Owner** or **User Access Administrator** can create one additional optional role assignment. For more information, see [Postrequisites](#postrequisites).

### Required Azure CLI commands

This reference solution deploys Azure Arc, which requires the `custom-locations` application object ID that needs to be passed to the deployment script. You can retrieve it with the following Azure CLI commands:

```azurecli
az login --tenant <tenant_id>
az account set --subscription <subscription_id>
az ad sp show --id bc313c14-388c-4e7d-a58e-70017303ee3b --query id -o tsv
```

In addition, the deployment process prompts you to provide a password for the virtual machine (VM) that hosts the production line simulation and the Edge infrastructure.

The reference solution deploys networking, a PostgreSQL database, an Azure Data Explorer cluster and Azure IoT Operations, which require the following resource providers to be registered in the subscription. Registering a resource provider is a subscription-scope action, so it must be done once by a subscription Owner or Contributor before deployment. On a fresh subscription that has not previously used these namespaces the deployment otherwise fails with `MissingSubscriptionRegistration`. You can register them via the following Azure CLI commands:

```azurecli
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Kusto
az provider register --namespace Microsoft.ExtendedLocation
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.IoTOperations
az provider register --namespace Microsoft.DeviceRegistry
az provider register --namespace Microsoft.SecretSyncController
```

## Postrequisites

The reference solution also deploys the Azure IoT Schema Registry, which requires the **IoT Operations Arc extension** service principal to be granted the **Azure Device Registry Administrator** role. This role assignment is **optional for this reference solution**, as the schema registry is only used by Azure IoT Operations data flows for schema-based serialization (Parquet/Delta) to storage destinations such as Azure Data Lake Storage or direct connections to Microsoft Fabric OneLake.

The deployment script logs a warning containing the extension service principal's object ID. Retrieve it from the deployment (bootstrap) log on the simulation VM via SSH:

```bash
sudo grep -oP "IoT Operations arc extension' service principal '\K[0-9a-fA-F-]{36}" /var/log/bootstrap/Bootstrap.log
```

A subscription Owner or User Access Administrator must then create the role assignment **after** the deployment completes, replacing `<extension_principal_id>` with the ID printed above and `<subscription_id>`, `<resource_group>` and `<resources_name>` (the resources are named after the resource group, so this is the resource group name in lowercase) with your values. Do so via the following Azure CLI command:

```azurecli
az role assignment create --assignee-object-id <extension_principal_id> --assignee-principal-type ServicePrincipal --role "Azure Device Registry Administrator" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.DeviceRegistry/schemaRegistries/<resources_name>-schemaregistry
```

## Articles in this reference solution

The following articles describe how to deploy this reference solution as well as how to connect it to various Microsoft services:

- [Connect Azure Data Explorer to the reference solution](how-to-connect-azure-data-explorer-to-solution.md) describes the end-to-end industrial IoT reference solution that uses Azure Data Explorer to store and analyze OPC UA telemetry for use cases such as condition monitoring, OEE calculation, and anomaly detection.
- [Connect Azure Databricks to the reference solution](how-to-connect-databricks-to-solution.md) walks through storing and analyzing OPC UA telemetry in Azure Databricks using Delta Lake tables and Structured Streaming ingestion from Azure Event Hubs.
- [Connect Microsoft Fabric to the reference solution](how-to-connect-fabric-to-solution.md) explains how to ingest and process the reference solution's OPC UA data in a Microsoft Fabric Eventhouse for Real-Time Intelligence, mirroring the same tables, functions, and views used by Azure Data Explorer.
- [Connect Microsoft Power BI to the reference solution](how-to-connect-powerbi-to-the-solution.md) describes how to connect Microsoft Power BI to the reference solution's OPC UA data.
- [Connect Azure Managed Grafana to the reference solution](how-to-connect-grafana-to-solution.md) describes how to connect Azure Managed Grafana to the reference solution's OPC UA data.
- [Connect Microsoft Dynamics 365 Field Service to the reference solution](how-to-connect-dynamics-field-service-to-the-solution.md) describes how to connect Microsoft Dynamics 365 Field Service to the reference solution's OPC UA data.
- [Connect SAP to the reference solution](how-to-connect-on-premises-sap-to-the-solution.md) describes how to connect SAP to the reference solution.
- [Connect an industrial data space to the reference solution](how-to-enable-industrial-dataspaces.md) describes how to connect an industrial data space to the reference solution.
- [Import OPC UA Information Models from the UA Cloud Library into Azure services](import-opc-ua-information-models-from-ua-cloud-library.md) describes how to import standardized OPC UA information models from the OPC Foundation's UA Cloud Library into Azure services.
- [Agentic AI for the reference solution](agentic-ai-for-the-solution.md) describes how to use the Plant Copilot AI agent on top of the reference solution, starting with a read-only MCP server that answers natural-language questions grounded in the plant's live and historical data.

## Production line simulation

The production line simulation is made up of several stations (3 per production line, named "Assembly", "Test" and "Packaging"), using the [station OPC UA information model](https://github.com/digitaltwinconsortium/ManufacturingOntologies/blob/main/Tools/FactorySimulation/Station/Station.NodeSet2.xml), and a simple manufacturing execution system (MES). Both the stations and the MES are containerized for easy deployment. Their configuration is:

| Production Line | Ideal Cycle Time (in seconds) |
| --- | --- |
| Munich | 6 |
| Seattle | 10 |

| Shift Name | Start | End |
| --- | --- | --- |
| Morning | 07:00 | 14:00 |
| Afternoon | 15:00 | 22:00 |
| Night | 23:00 | 06:00 |

Shift times are in local time zone of Seattle and Munich. There are 1 hour breaks between shifts.

The station OPC UA server uses the following OPC UA node IDs for telemetry to the cloud:

- `i=379` - manufactured product serial number
- `i=385` - number of manufactured products
- `i=391` - number of discarded products
- `i=398` - running time
- `i=399` - faulty time
- `i=400` - status (0=station ready to do work, 1=work in progress, 2=work done and good part manufactured, 3=work done and scrap manufactured, 4=station in fault state)
- `i=406` - energy consumption
- `i=412` - ideal cycle time
- `i=418` - actual cycle time
- `i=434` - pressure

The solution uses a digital feedback loop to manage the pressure in a simulated station. To implement the feedback loop, the solution triggers a command from the cloud on one of the OPC UA servers in the simulation. The trigger activates when simulated time-series pressure data reaches a certain threshold. You can see the pressure of the assembly machine in the Azure Data Explorer dashboard. The pressure is released at regular intervals for the Seattle production line. In a real-world deployment, something as critical as opening a pressure relief valve would be done on-premises. This example simply demonstrates how to achieve the digital feedback loop.

To reduce cost, the deployment creates a single Linux VM for both the production line simulation and the edge infrastructure. In a production scenario, the production line simulation isn't required.

Azure IoT Operations can operate offline for at most 72 hours and might degrade during that period, so a production adaptation needs to define buffering, recovery, and data-loss behavior for longer outages, see [the IoT overview page](/azure/iot-operations/overview-iot-operations).

## OPC UA certificate trust

The simulation stations accept anonymous/untrusted OPC UA sessions **only while they are in provisioning mode**, that is, until trust material is placed in their PKI stores (either through an OPC UA GDS push or through manual copying). After that, each station accepts a peer certificate only if it is present in the station's `pki/trusted/certs` store or is signed by an issuer in its `pki/issuer/certs` store. Azure IoT Operations' connector for OPC UA uses a self-signed application instance certificate, and each station in turn presents its own self-signed server certificate, so without extra configuration the two sides would **reject** each other once provisioned.

The deployment script establishes the required two-way (mutual) trust automatically, after Azure IoT Operations is installed:

1. **Stations trust AIO.** AIO's connector certificate is a self-signed, cert-manager-managed application instance certificate stored in the Kubernetes secret `aio-opc-opcuabroker-default-application-cert`.

   The script copies this certificate into each station's `pki/trusted/certs` store. The stations mount this store from the host (`/mnt/c/K3s/<Station>/<Line>/PKI`), and the certificate validator re-reads it on each validation, so no station restart is required.

2. **AIO trusts the stations.** The script enables Azure IoT Operations secret sync (reusing the solution's Key Vault and shared managed identity) and then adds each station's own OPC UA server certificate — for the Assembly, Test and Packaging stations of every production line.

   AIO stores this as the `aio-opc-ua-broker-trust-list` secret, synced from Key Vault.

> [!NOTE]
> This is the automated equivalent of the mutual-trust procedure in [Configure OPC UA certificates infrastructure for the connector for OPC UA](/azure/iot-operations/discover-manage-assets/howto-configure-opc-ua-certificates-infrastructure).

## Access the Arc-enabled Kubernetes cluster from the Azure portal

When you browse the Kubernetes resources of the Arc-enabled cluster (or the Azure IoT Operations instance) in the Azure portal, you are prompted for a **service account bearer token**. Generate one by logging on to the deployed VM via SSH and then running the following commands:

```bash
# Create a service account (in the default namespace).
sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml create serviceaccount arc-portal-user -n default

# Grant it cluster-admin so it can view all resources.
sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml create clusterrolebinding arc-portal-user-binding --clusterrole cluster-admin --serviceaccount default:arc-portal-user

# Create a long-lived token secret for the service account.
sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: arc-portal-user-secret
  annotations:
    kubernetes.io/service-account.name: arc-portal-user
type: kubernetes.io/service-account-token
EOF

# Print the token, then paste it into the portal's "Service account bearer token" prompt.
sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get secret arc-portal-user-secret -o jsonpath='{$.data.token}' | base64 -d
```

## Security review (STRIDE)

This section is a threat model of the reference solution using Microsoft's **STRIDE** methodology (**S**poofing, **T**ampering, **R**epudiation, **I**nformation disclosure, **D**enial of service, **E**levation of privilege). It covers all three analytics paths — Azure Data Explorer (ADX), Azure Databricks, and Microsoft Fabric — which share the same edge-to-cloud ingestion pipeline and differ only in the storage/analytics backend.

> [!IMPORTANT]
> This is a **reference solution**. Several defaults favor ease of deployment over hardening (public endpoints, a single shared VM, shared credentials, self-signed certificates). The findings and recommendations below are what you must address before using any part of this design in production. This review is provided for educational purposes and is not a substitute for a formal, environment-specific security assessment.

### Scope and architecture

Data flows edge → cloud through a common pipeline, then fans out to one of three analytics backends:

1. **Edge**: a single Linux VM runs the production line simulation (OPC UA servers for the Assembly/Test/Packaging stations + MES) and the edge infrastructure (K3s, Azure Arc, Azure IoT Operations). OPC UA telemetry is published from the stations; Azure IoT Operations' connector for OPC UA bridges it to the cloud. A cloud-to-edge command (pressure-relief valve) closes a digital feedback loop.
2. **Transport/ingestion**: telemetry is sent to **Azure Event Hubs** (Kafka-compatible) as the cloud ingestion point.
3. **Storage/analytics** (one of):
   - **ADX** — Event Hubs data connections stream into the `opcua_telemetry`/`opcua_metadata` tables; an ADX dashboard and the I3X REST API expose the data.
   - **Databricks** — Structured Streaming reads Event Hubs into Delta Lake tables in Unity Catalog.
   - **Fabric** — an Eventhouse (KQL DB) ingests from Event Hubs; a Real-Time Dashboard and a Fabric-hosted I3X API expose it.
4. **Supporting services**: Azure Key Vault (secrets), a user-assigned **managed identity** shared by the cloud services, PostgreSQL Flexible Server + a UA Cloud Library container app, the I3X4Kusto container app (authentication-protected), and the **Plant Copilot** MCP container app, which exposes the I3X data to AI agents as read-only tools.

### Trust boundaries

- **Physical/OT ↔ edge host** — the OPC UA servers and the AIO connector on the shared VM.
- **Edge ↔ cloud** — the VM/K3s cluster (Arc-connected) to Azure (Event Hubs, ARM, Key Vault).
- **Cloud service ↔ cloud service** — managed-identity-authenticated calls between the container apps, ADX/Eventhouse, Key Vault and PostgreSQL.
- **Cloud ↔ external consumer** — the public dashboards, the I3X REST API and the Plant Copilot MCP endpoint reached over the Internet (the latter consumed by external AI agent runtimes such as Microsoft 365 Copilot / Copilot Studio).
- **Deployment plane** — the ARM template, bootstrap scripts (fetched from GitHub `main`), and the operator's Azure credentials.

### STRIDE analysis

#### Spoofing

| Threat | Assessment in this solution | Recommendation for production |
| --- | --- | --- |
| Rogue OPC UA client/server impersonation | Mitigated: mutual (two-way) OPC UA certificate trust is established between each station and the AIO connector; stations reject peers not in their `pki/trusted`/`pki/issuer` stores once out of provisioning mode. However, all certificates are **self-signed** and stations accept **anonymous** sessions while in provisioning mode. | Use a proper PKI/CA (or OPC UA GDS) instead of self-signed certs; minimize the provisioning-mode window; require user authentication on the OPC UA servers. |
| Impersonating a cloud consumer of the I3X API | Mitigated: authentication is **mandatory** on the I3X API and fails closed if no method is configured. Two methods are supported: HTTP **Basic authentication** and **OAuth 2.0 / Entra ID bearer tokens** (enabled by setting `I3X_OAUTH2_AUTHORITY`). By default the deployment uses Basic auth with a single shared `admin` account. | Basic auth over TLS is acceptable for demos; for production use the OAuth2/Entra ID path (see *Configuring OAuth2 for the I3X API via Azure Entra ID*) with per-consumer identities rather than the shared admin credential. |
| Impersonating a client of the Plant Copilot MCP server | Mitigated: authentication is **mandatory** on the [Plant Copilot](agentic-ai-for-the-solution.md) MCP endpoint and it **fails closed** — if no method is configured the endpoint returns HTTP 503 instead of serving the tools. **HTTP Basic authentication is enabled by default** (user name defaults to `admin`; the deployment supplies `adminUsername`/`adminPassword`, the password via a Container Apps secret), and the server can additionally validate **OAuth 2.0 bearer tokens from an external identity provider** (`AUTH_AUTHORITY`, e.g. Microsoft Entra ID). The server is only a Resource Server — it never issues tokens and does **not** offer Dynamic Client Registration, so no caller can self-register and mint its own access. The residual weakness is that Basic auth uses the single shared admin credential. | For production, configure `AUTH_AUTHORITY` (and `AUTH_AUDIENCE`) so tokens come from a real identity provider with interactive login/consent and per-user/per-client identities, and leave `AUTH_BASIC_PASSWORD` unset so the shared credential is not accepted. |
| Spoofing service-to-service calls | Mitigated: cloud services authenticate to ADX/Key Vault/Event Hubs with a **user-assigned managed identity** and Entra tokens (no shared keys for those hops); ADX read uses Entra Workload Identity federation. | Keep managed identity; scope each service to its own identity rather than one shared identity (see Elevation of privilege). |
| Deployment/script source spoofing | Risk: the bootstrap and setup scripts are fetched at deploy time from the public GitHub `main` branch over HTTPS; a compromised branch or MITM on an unpinned ref would run attacker code on the VM. | Pin to an immutable commit/tag, verify checksums/signatures, or host the scripts in a trusted private location. |

#### Tampering

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Telemetry tampering in transit (edge→cloud) | Mitigated: transport to Event Hubs is TLS-encrypted; the AIO MQTT broker hop uses TLS + SAT auth. | Retain TLS everywhere; retain OPC UA message signing/encryption end-to-end, i.e., from other OPC UA servers to AIO, too. |
| Command tampering (cloud→edge pressure-relief) | Mitigated: the command path uses spec-valid MQTT-RPC over TLS with SAT auth; but a control command to physical equipment is high-impact. The README already warns that in the real world such an action would be done on-premises. | Never actuate safety-critical equipment directly from the cloud; require local interlocks/authorization and command signing. |
| Tampering with data at rest | Mitigated by platform: ADX/Eventhouse/Delta storage is Azure-managed with encryption at rest; Delta Lake retains history. | Enable immutability/retention policies where required; restrict write access (see EoP). |
| Config/PKI store tampering on the shared VM | Risk: the station PKI stores are host-mounted (`/mnt/c/K3s/...`); anyone with VM access can alter trust material or the simulation. | Restrict VM access; separate the simulation from real edge infrastructure (they are co-located only to save cost). |
| Dashboard/query definition tampering | Low: dashboards and KQL are imported from the repo. | Review imported artifacts; the embedded Python (ADX/Fabric graph tile) runs in the sandboxed `evaluate python` plugin. |
| Indirect prompt injection via tool results | Risk: the Plant Copilot returns plant data (asset names, values) verbatim to the LLM, so malicious or crafted content stored upstream could influence the agent's reasoning. The impact is bounded because the tool surface is strictly read-only \u2014 the agent cannot be induced to actuate the plant through it. | Treat all tool output as untrusted input in the agent; keep write/command tools out of the MCP server; validate/curate data at ingestion. |

#### Repudiation

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Actions cannot be attributed | Partial: Azure platform logs (Activity Log, resource diagnostics) exist, but the I3X API Basic-auth user is a single shared `admin` account, and the VM/PostgreSQL/UA Cloud Library share one admin credential — actions are not attributable to individuals. | Enable diagnostic settings/audit logs on ADX, Eventhouse, Key Vault, Event Hubs and PostgreSQL; use per-user identities so actions are traceable; forward logs to a Security Information and Event Management (SIEM) system. |
| Command loop actions unlogged | Partial: the connector/commander log RPC execution, but there is no signed audit trail of who/what triggered a physical command. | Add tamper-evident audit logging for control actions. |
| Agent data access unlogged | Partial: the Plant Copilot MCP server emits a structured `AUDIT i3X access: <method> <path>` log entry for every tool-driven query, so all agent data access is recorded (via Container Apps to Log Analytics). However, callers authenticate with the shared Basic credential by default, so entries are not attributable to an individual. | Configure an external identity provider (`AUTH_AUTHORITY`) and leave `AUTH_BASIC_PASSWORD` unset so the subject is a real Entra identity, and forward the audit entries to a SIEM. |

#### Information disclosure

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Public network exposure | Risk: Key Vault, ADX and PostgreSQL are deployed with `publicNetworkAccess: Enabled`; PostgreSQL uses an **AllowAllAzureIps** firewall rule; the I3X API, the Plant Copilot MCP endpoint and the dashboards are **externally** reachable (the MCP endpoint must be, so that hosted agent runtimes can call it). | Use Private Endpoints/VNet integration; replace AllowAllAzureIps with specific rules; put the APIs behind a gateway/WAF; restrict dashboard access. |
| Verbose upstream errors | Mitigated: the Plant Copilot returns only a generic error to the caller when an i3X request fails and logs the upstream status/body server-side, so internal details are not disclosed to the agent. Kestrel's `Server` response header is also suppressed to avoid fingerprinting. | Keep error responses generic on public endpoints; review logs for sensitive content before forwarding to a SIEM. |
| Secret exposure | Partial: secrets are stored in **Key Vault** (RBAC-authorized, soft-delete + purge protection) and referenced via managed identity / container-app secretRefs; but the **same `adminPassword`** is reused for the VM, PostgreSQL, UA Cloud Library, the I3X Basic-auth credential and the Plant Copilot Basic-auth credential, and the Event Hubs connection string (SAS) is stored as a KV secret. | Use distinct, rotated secrets per service; prefer managed identity / Entra auth over connection strings and shared passwords; avoid credential reuse across trust boundaries. |
| Credentials in deployment inputs | Partial: `adminPassword` is a `secureString`; ensure it isn't echoed into logs. | Pass secrets via secure parameters/Key Vault references only; scrub deployment logs. |
| Data exposure via the analytics backends | Depends on config: ADX/Eventhouse/Databricks all enforce Entra RBAC, but overly broad grants (e.g. the shared identity is ADX **Admin**) widen exposure. | Grant least-privilege database roles (viewer/ingestor) instead of Admin; apply row/column security if telemetry is sensitive. |

#### Denial of service

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Public endpoints abused | Partial: the Plant Copilot MCP endpoint now enforces **per-caller rate limiting** (sliding window, default 120 requests/minute per identity or IP, returning `429` with `Retry-After`), which caps request amplification into i3X/ADX. The dashboards, the I3X API and the public Key Vault/ADX/PostgreSQL endpoints remain without explicit throttling. | Front the remaining public services with rate limiting/WAF/DDoS protection (Azure Front Door or API Management); use private networking to remove the attack surface entirely. |
| Single-VM single point of failure | Risk: one Linux VM hosts both the simulation and the edge infrastructure; and the I3X subscription state is in-memory, requiring a single replica. | Separate simulation from production edge; run redundant edge infrastructure; externalize API state to scale out. |
| Ingestion overload | Partial: Event Hubs/ADX absorb bursts, but there are no explicit quotas/throttles in the sample. | Configure Event Hubs throughput units/auto-inflate, ADX capacity, and consumer backpressure. |
| Unbounded queries / info-model import | Low: KQL queries and the UA Cloud Library `[Future]` import use `take` limits; the graph tile runs in the sandbox. | Keep query limits; cap import sizes. |

#### Elevation of privilege

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Over-privileged shared managed identity | Risk: a **single user-assigned managed identity** is shared by the container apps and is granted broad roles (Contributor at RG scope, ADX **Admin**). Compromise of any one workload yields all its rights. | Give each workload its own identity with least-privilege, resource-scoped roles; avoid RG-wide Contributor. |
| Deployment identity over-permissioned | Expected: deployment needs Owner (or Contributor + User Access Administrator) to create role assignments. | Use just-in-time/PIM elevation for the deployment principal; remove standing Owner after deploy. |
| Kubernetes cluster-admin token | Risk: the documented portal-access flow creates a **cluster-admin** service account and a long-lived token. | Scope the service account to least privilege; use short-lived tokens; rotate/revoke after use. |
| Lateral movement from the shared VM | Risk: the VM holds edge credentials, PKI stores and Arc identity; compromise enables pivot to the cluster and (via managed identity) to cloud resources. | Harden and isolate the VM; restrict its managed-identity scope; monitor for anomalous identity use. |
| OPC UA trust-list caching | Mitigated: the setup script now establishes mutual OPC UA trust **before** the devices/assets are onboarded, so the connector/commander pods mount a fully-populated trust list at startup and the former "add trust, then restart the pods" workaround is no longer needed. The script waits for the certificates to appear in the synced trust-list secret before onboarding. | Alert on connection failures; re-run the trust step if station certificates are regenerated. |
| Agent actuation beyond read-only intent | Mitigated by design: the Plant Copilot exposes **only read tools** (browse the ISA-95 hierarchy, read current values and history) \u2014 there is no tool that writes a set-point, acknowledges an alarm or otherwise actuates the plant, so a compromised or manipulated agent cannot change plant state through it. However, it authenticates upstream to the I3X API with the **shared admin credential**, so its effective upstream rights are broader than its own tool surface. | Keep write/command capability out of the MCP server and route any actuation through a separate, human-approval-gated path; give the MCP server a dedicated least-privilege, read-only I3X identity instead of the shared admin credential. |

### Analytics-path-specific considerations (ADX, Databricks, Fabric)

- **Common to all three**: the same edge/Event Hubs ingestion, shared managed identity, shared `adminPassword`, and public endpoints apply regardless of backend — so the Spoofing/Info-disclosure/EoP findings above are path-independent.
- **ADX**: read auth uses Entra Workload Identity federation (no secret); the shared identity is ADX **Admin** (over-privileged — prefer a database viewer/ingestor role). The dashboard's graph tile executes Python in the sandboxed `evaluate python` plugin. The I3X API in front of ADX enforces authentication (Basic auth by default, or OAuth2/Entra ID) but is publicly reachable.
- **Databricks**: tables live in **Unity Catalog** (governed, Entra RBAC) with Structured Streaming checkpoints in a UC volume; ensure workspace access, cluster policies and secret scopes are locked down and the Event Hubs credential is least-privilege.
- **Fabric**: the Eventhouse and Real-Time Dashboard use Fabric/Entra RBAC and a **separate** deployment with its own (independent) `adminUsername`/`adminPassword` for its I3X API; enabling `deployFabricCapacity` requires pre-existing Fabric capacity quota. Restrict Fabric workspace roles and the Eventhouse's callout/plugin policies (the `http_request` plugin used for UA Cloud Library import is powerful and should stay disabled unless needed).

### Summary of recommendations for production

- **Remove public exposure** — Private Endpoints/VNet for Key Vault, ADX, PostgreSQL, Event Hubs; gateway/WAF for the API and dashboards; drop AllowAllAzureIps.
- **Least privilege** — per-workload managed identities; database viewer/ingestor roles instead of ADX Admin; no RG-wide Contributor; scoped, short-lived Kubernetes tokens.
- **Eliminate credential reuse** — distinct, rotated secrets per service; prefer Entra/managed-identity auth over connection strings and shared passwords; OAuth2 for the API (see next section below).
- **Proper PKI** — CA-issued (or GDS-managed) OPC UA certificates; minimize provisioning-mode/anonymous windows.
- **Auditability** — enable diagnostic/audit logs on all services, per-user identities, and a signed audit trail for control commands; forward to a SIEM.
- **Harden the edge** — separate the simulation from real edge infrastructure; isolate and monitor the VM; never actuate safety-critical equipment directly from the cloud.
- **Secure the supply chain** — pin deployment scripts/templates to immutable, verified references instead of GitHub `main`.

### Configure OAuth2 for the I3X API via Microsoft Entra ID

Follow these steps to protect the API with Entra ID and call it with a bearer token.

**1. Register the API (the resource being protected)**
- In the Azure portal, go to **Entra ID → App registrations → New registration** and create an app for I3X4Kusto.
- Open the new app's **Expose an API** blade and set the **Application ID URI**, e.g. `api://<api-client-id>`. This value becomes `I3X_OAUTH2_AUDIENCE`.
- Decide how callers will authenticate and add the matching permission on this app:
  - **App-only (client-credentials) — used by the quick test and by service callers such as the Plant Copilot:** go to **App roles → Create app role**, with **Allowed member types = Applications** (e.g. display name `I3X.Read`, value `I3X.Read`). Client-credentials tokens carry app roles in the `roles` claim, not delegated scopes.
  - **Delegated (user sign-in):** under **Expose an API → Add a scope**, add a delegated scope such as `access_as_user`. Delegated tokens carry it in the `scp` claim.
- Note your **Directory (tenant) ID** — it forms `I3X_OAUTH2_AUTHORITY`.

**2. Configure the deployed API.** The `i3x4kusto` Container App reads its OAuth settings from environment variables, so you must set them **on the deployed app** (setting them in your local shell has no effect). Update the app and let Container Apps roll out a new revision:

```bash
az containerapp update \
  --name <resourcesName>-i3x4kusto \
  --resource-group <resourcesName> \
  --set-env-vars \
    I3X_OAUTH2_AUTHORITY="https://login.microsoftonline.com/<tenant-id>/v2.0" \
    I3X_OAUTH2_AUDIENCE="api://<api-client-id>" \
    I3X_OAUTH2_ISSUER="https://login.microsoftonline.com/<tenant-id>/v2.0"
```

`I3X_OAUTH2_ISSUER` is optional (otherwise taken from the authority metadata). Changing environment variables creates a new revision automatically; if the app is running in single-revision mode you can force a restart with:

```bash
az containerapp revision restart \
  --name <resourcesName>-i3x4kusto \
  --resource-group <resourcesName> \
  --revision $(az containerapp show --name <resourcesName>-i3x4kusto --resource-group <resourcesName> --query properties.latestRevisionName -o tsv)
```

Once the new revision is running, bearer-token authentication is active on the API (HTTP Basic auth remains accepted as well, if configured).

**3. Acquire a token.** For a quick end-to-end test, use the **app-only client-credentials flow** with the app role from step 1:
1. Add a **client secret** to the app registration (**Certificates & secrets → New client secret**).
1. Grant the calling application the **`I3X.Read` app role** (application permission): in the **API permissions** blade of the *client* app registration, select **Add a permission → My APIs →** *your I3X4Kusto app* **→ Application permissions →** `I3X.Read`, then **Grant admin consent**. (For a self-test you can reuse the same app registration as both client and API; the app role must still be granted and admin-consented so it appears in the token's `roles` claim.)

```bash
ACCESS_TOKEN=$(curl -s -X POST \
  https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token \
  -d "grant_type=client_credentials" \
  -d "client_id=<client-id>" \
  -d "client_secret=<client-secret>" \
  -d "scope=api://<api-client-id>/.default" \
  | jq -r .access_token)
```

For user sign-in scenarios, use a separate client app that has been granted the API's **delegated** scope (`access_as_user`) and acquire a delegated token instead.

**4. Call the API with the token:**

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" https://<host>/v1/objects
```

**Troubleshooting.** If you get a 401, decode the token at [jwt.ms](https://jwt.ms) and verify:
- `aud` exactly matches `I3X_OAUTH2_AUDIENCE`.
- `iss` matches the v2.0 issuer `https://login.microsoftonline.com/<tenant-id>/v2.0`. If your token is a v1 token (`iss` = `https://sts.windows.net/<tenant-id>/`), either request a v2 token or set `I3X_OAUTH2_ISSUER` to match.
- The permission is present: an app-only token carries the app role in the `roles` claim (e.g. `I3X.Read`); a delegated token carries the scope in the `scp` claim (e.g. `access_as_user`). A missing `roles` claim usually means the application permission was not granted **and** admin-consented.
- The token has not expired (`exp`).

#### Example: OAuth2 environment variables

These are the variables the `i3x4kusto` container consumes. Set them **on the deployed Container App** as shown in step 2 above (not in your local shell); the values are listed here for reference:
```bash
# Enable OAuth2 bearer-token authentication against an Entra ID tenant.
I3X_OAUTH2_AUTHORITY="https://login.microsoftonline.com/<tenant-id>/v2.0"
I3X_OAUTH2_AUDIENCE="api://<application-client-id>"
# Optional: pin the expected issuer (otherwise taken from the authority metadata).
I3X_OAUTH2_ISSUER="https://login.microsoftonline.com/<tenant-id>/v2.0"
```

Clients then acquire a token from the authority and call the API with it:
```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" https://<host>/v1/objects
```