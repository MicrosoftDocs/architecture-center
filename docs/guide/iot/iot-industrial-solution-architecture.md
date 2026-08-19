---
title: "OPC UA reference solution"
description: "Learn how to build a standards-based industrial IoT reference solution that uses OPC UA to connect shop-floor telemetry to Azure analytics services."
author: erichb
ms.author: erichb
ms.topic: concept-article
ms.date: 07/22/2026
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# OPC UA reference solution

This article discusses a standards-based industrial IoT reference solution that uses OPC Unified Architecture (OPC UA) to connect shop-floor telemetry to Azure analytics services. It demonstrates how to ingest, model, and query manufacturing data so you can support scenarios like condition monitoring, OEE analysis, and anomaly detection. Use this architecture as a starting point to validate the approach with a simulation and then adapt it for production workloads.

> [!NOTE]
> This article describes a Microsoft OPC UA reference solution that demonstrates how to send telemetry from OPC UA-enabled industrial assets to Azure. The solution is provided as reference guidance to help architects and developers understand one approach for integrating OPC UA data with Azure services.
>
> This reference solution isn't a Microsoft-supported product offering and should be evaluated carefully before use in production environments. Organizations are responsible for validating that the architecture, components, and operational characteristics align with their needs.
>
> For new deployments, Microsoft recommends evaluating Azure IoT Operations, a fully supported platform for connecting, managing, and processing industrial telemetry. Azure IoT Operations supports OPC UA-enabled environments as well as a broad range of industrial and edge scenarios, and simplifies deployment and ongoing operations for most production use cases.
>
> To learn more, see the [**Azure IoT Operations Overview**](/azure/iot-operations/overview-iot-operations#architecture-overview).

## Contents

- [About this solution](#about-this-solution)
- [Prerequisites](#prerequisites)
  - [Required Azure permissions](#required-azure-permissions)
  - [Required Azure CLI commands](#required-azure-cli-commands)
- [Post-deployment](#post-deployment)
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
  - [Analytics path-specific considerations (Azure Data Explorer, Azure Databricks, Fabric)](#analytics-path-specific-considerations-azure-data-explorer-azure-databricks-fabric)
  - [Summary of recommendations for production](#summary-of-recommendations-for-production)
  - [Configure OAuth 2.0 for the I3X API via Microsoft Entra ID](#configure-oauth-20-for-the-i3x-api-via-microsoft-entra-id)

## About this solution

Manufacturers might want to use an industrial IoT solution that doesn't lock them in to proprietary platforms. In addition, they might want to deploy this solution on a global scale and connect all of their production sites to it to increase efficiencies for each individual site.

These increased efficiencies lead to faster production, better quality, and lower energy consumption, which all lead to reducing the cost for produced goods.

The solution must be as efficient as possible and enable all required use cases, like condition monitoring, overall equipment effectiveness (OEE) calculation, forecasting, and anomaly detection. By using the insights gained from these use cases, manufacturers can create digital feedback loops, which can apply optimizations and other changes to the production processes in a fully automated way.

Interoperability is essential for these requirements. The use of open standards like OPC UA significantly helps to achieve this interoperability. Improving this interoperability led to the establishment of the [OPC Foundation Cloud Initiative](https://opcfoundation.org/cloud). This OPC UA reference solution is the Microsoft implementation of the Cloud Initiative's reference architecture.

## Prerequisites

### Required Azure permissions

The deployment provisions Azure resources, onboards the simulation VM's Kubernetes cluster to Azure Arc, installs Azure IoT Operations, and creates several Azure role assignments. Ensure the user that runs the deployment script has the following permissions:

- **Owner** on the target subscription or resource group (recommended), or the combination of **Contributor** and **User Access Administrator** (or **Role Based Access Control Administrator**) so they can both create resources and create the role assignments the template defines.
- **Contributor** or **Owner** at the subscription scope for the one-time resource-provider registration described later in this article, because `az provider register` is a subscription-scope action.
- Permission to sign in to the target Microsoft Entra tenant and run `az ad sp show` to read the `custom-locations` application service principal that's used to deploy Azure Arc.

> [!NOTE]
> After the deployment finishes, a subscription Owner or User Access Administrator can create one additional optional role assignment. For more information, see [Post-deployment](#post-deployment).

### Required Azure CLI commands

This reference solution deploys Azure Arc. The deployment requires the `custom-locations` application object ID, which you pass to the deployment script. Use the following Azure CLI commands to retrieve it:

```azurecli
az login --tenant <tenant_id>
az account set --subscription <subscription_id>
az ad sp show --id bc313c14-388c-4e7d-a58e-70017303ee3b --query id -o tsv
```

Also, the deployment process prompts you to provide a password for the virtual machine (VM) that hosts the production line simulation and the edge infrastructure.

The reference solution deploys networking, a PostgreSQL database, an Azure Data Explorer cluster, and Azure IoT Operations. These resources require the following resource providers to be registered in the subscription. Registering a resource provider is a subscription-scope action, so it must be performed once by a subscription Owner or Contributor before deployment. On a subscription that hasn't previously used these namespaces, the deployment otherwise fails with `MissingSubscriptionRegistration`. Use the following CLI commands to register them:

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

## Post-deployment

The reference solution also deploys the Azure IoT Schema Registry, which requires the **IoT Operations Arc extension** service principal to be granted the **Azure Device Registry Administrator** role. This role assignment is optional for this reference solution because the schema registry is used only by Azure IoT Operations data flows for schema-based serialization (Parquet/Delta) to storage destinations like Azure Data Lake Storage or direct connections to Microsoft OneLake.

The deployment script logs a warning that contains the extension service principal's object ID. Retrieve it from the deployment (bootstrap) log on the simulation VM via SSH:

```bash
sudo grep -oP "IoT Operations arc extension' service principal '\K[0-9a-fA-F-]{36}" /var/log/bootstrap/Bootstrap.log
```

A subscription Owner or User Access Administrator must then create the role assignment after the deployment finishes, replacing `<extension_principal_id>` with the ID obtained earlier and `<subscription_id>`, `<resource_group>`, and `<resources_name>` (the resources are named after the resource group, so this value is the resource group name in lowercase) with your values. Do so by using the following CLI command:

```azurecli
az role assignment create --assignee-object-id <extension_principal_id> --assignee-principal-type ServicePrincipal --role "Azure Device Registry Administrator" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.DeviceRegistry/schemaRegistries/<resources_name>-schemaregistry
```

## Articles in this reference solution

The following articles describe how to deploy this reference solution and how to connect it to various Microsoft services:

- [Connect Azure Data Explorer to the reference solution](how-to-connect-azure-data-explorer-to-solution.md) describes the end-to-end industrial IoT reference solution that uses Azure Data Explorer to store and analyze OPC UA telemetry for use cases such as condition monitoring, OEE calculation, and anomaly detection.
- [Connect Azure Databricks to the reference solution](how-to-connect-databricks-to-solution.md) describes how to store and analyze OPC UA telemetry in Azure Databricks by using Delta Lake tables and Structured Streaming ingestion from Azure Event Hubs.
- [Connect Microsoft Fabric to the reference solution](how-to-connect-fabric-to-solution.md) explains how to ingest and process the reference solution's OPC UA data in a Fabric eventhouse for Real-Time Intelligence, mirroring the same tables, functions, and views used by Azure Data Explorer.
- [Connect Microsoft Power BI to the reference solution](how-to-connect-powerbi-to-the-solution.md) describes how to connect Power BI to the reference solution's OPC UA data.
- [Connect Azure Managed Grafana to the reference solution](how-to-connect-grafana-to-solution.md) describes how to connect Azure Managed Grafana to the reference solution's OPC UA data.
- [Connect Microsoft Dynamics 365 Field Service to the reference solution](how-to-connect-dynamics-field-service-to-the-solution.md) describes how to connect Dynamics 365 Field Service to the reference solution's OPC UA data.
- [Connect SAP to the reference solution](how-to-connect-on-premises-sap-to-the-solution.md).
- [Connect an industrial dataspace to the reference solution](how-to-enable-industrial-dataspaces.md).
- [Import OPC UA Information Models from the UA Cloud Library into Azure services](import-opc-ua-information-models-from-ua-cloud-library.md) describes how to import standardized OPC UA information models from the OPC Foundation's UA Cloud Library into Azure services.
- [Agentic AI for the reference solution](agentic-ai-for-the-solution.md) describes how to use a Plant Copilot AI agent with the reference solution, starting with a read-only MCP server that answers natural-language questions grounded in the plant's live and historical data.

## Production line simulation

The production line simulation is made up of several stations (three stations per production line, named "Assembly", "Test," and "Packaging") that use the [station OPC UA information model](https://github.com/digitaltwinconsortium/ManufacturingOntologies/blob/main/Tools/FactorySimulation/Station/Station.NodeSet2.xml) and a simple manufacturing execution system (MES). The stations and the MES are containerized for easy deployment. The following tables describe their configuration.

| Production line | Ideal cycle time (in seconds) |
| --- | --- |
| Munich | 6 |
| Seattle | 10 |

| Shift name | Start | End |
| --- | --- | --- |
| Morning | 07:00 | 14:00 |
| Afternoon | 15:00 | 22:00 |
| Night | 23:00 | 06:00 |

Shift times are in local time zones. There are one-hour breaks between shifts.

The station OPC UA server uses the following OPC UA node IDs for telemetry to the cloud:

- `i=379`. Manufactured product serial number.
- `i=385`. Number of manufactured products.
- `i=391`. Number of discarded products.
- `i=398`. Running time.
- `i=399`. Faulty time.
- `i=400`. Status (0=station ready to do work, 1=work in progress, 2=work done and good part manufactured, 3=work done and scrap manufactured, 4=station in fault state).
- `i=406`. Energy consumption.
- `i=412`. Ideal cycle time.
- `i=418`. Actual cycle time.
- `i=434`. Pressure.

The solution uses a digital feedback loop to manage the pressure in a simulated station. To implement the feedback loop, the solution triggers a command from the cloud on one of the OPC UA servers in the simulation. The trigger activates when simulated time-series pressure data reaches a certain threshold. You can see the pressure of the assembly machine on the Azure Data Explorer dashboard. The pressure is released at regular intervals in the Seattle production line. In a real-world deployment, something as critical as opening a pressure relief valve would be done on-premises. This example simply demonstrates how to achieve the digital feedback loop.

The deployment creates a single Linux VM for both the production line simulation and the edge infrastructure. This configuration reduces costs. In a production scenario, the production line simulation isn't required.

Azure IoT Operations can operate offline for 72 hours at most, and performance might degrade during that period, so a production adaptation needs to define buffering, recovery, and data-loss behavior for longer outages. For more information, see [What is Azure IoT Operations?](/azure/iot-operations/overview-iot-operations).

## OPC UA certificate trust

The simulation stations accept anonymous or untrusted OPC UA sessions only while they're in provisioning mode. That condition lasts until you place trust material in their PKI stores (either via an OPC UA GDS push or via manual copying). After that point, each station accepts a peer certificate only if it's present in the station's `pki/trusted/certs` store or is signed by an issuer in its `pki/issuer/certs` store. The Azure IoT Operations connector for OPC UA uses a self-signed application instance certificate, and each station in turn presents its own self-signed server certificate. Without extra configuration, the two sides would reject each other after they're provisioned.

The deployment script establishes the required two-way (mutual) trust automatically, after Azure IoT Operations is installed:

- **Stations trust Azure IoT Operations.** The Azure IoT Operations connector certificate is a self-signed application instance certificate that's managed by cert-manager and stored in the Kubernetes secret `aio-opc-opcuabroker-default-application-cert`.

   The script copies this certificate into each station's `pki/trusted/certs` store. The stations mount this store from the host (`/mnt/c/K3s/<Station>/<Line>/PKI`), and the certificate validator reads it on each validation, so no station restart is required.

- **Azure IoT Operations trusts the stations.** The script enables Azure IoT Operations secret sync (reusing the solution's key vault and shared managed identity) and then adds each station's own OPC UA server certificate, for the Assembly, Test, and Packaging stations of every production line.

   Azure IoT Operations stores these certificates as the `aio-opc-ua-broker-trust-list` secret, synced from Azure Key Vault.

> [!NOTE]
> This process is the automated equivalent of the mutual-trust procedure in [Configure OPC UA certificates infrastructure for the connector for OPC UA](/azure/iot-operations/discover-manage-assets/howto-configure-opc-ua-certificates-infrastructure).

## Access the Arc-enabled Kubernetes cluster from the Azure portal

When you browse the Kubernetes resources of the Arc-enabled cluster (or the Azure IoT Operations instance) in the Azure portal, you're prompted for a service account bearer token. Generate one by signing in to the deployed VM via SSH and running the following commands:

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

This section is a threat model of the reference solution. The model uses the Microsoft STRIDE methodology (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege). It covers all three analytics paths: Azure Data Explorer, Azure Databricks, and Fabric. These paths share the same edge-to-cloud ingestion pipeline and differ only in the storage and analytics back end.

> [!IMPORTANT]
> This solution is a reference solution. Several of the defaults prioritize ease of deployment over hardening (public endpoints, a single shared VM, shared credentials, self-signed certificates). Address the following recommendations before you use any part of this design in production. This review is provided for informational purposes and isn't a substitute for a formal, environment-specific security assessment.

### Scope and architecture

Data flows from edge to cloud through a common pipeline, then flows to one of three analytics back ends.

1. **Edge:** A single Linux VM runs the production line simulation (OPC UA servers for the Assembly, Test, and Packaging stations, plus MES) and the edge infrastructure (K3s, Azure Arc, Azure IoT Operations). The stations publish OPC UA telemetry. The Azure IoT Operations connector for OPC UA bridges the telemetry to the cloud. A cloud-to-edge command (the pressure-relief valve) closes a digital feedback loop.
1. **Transport/ingestion:** Telemetry is sent to Event Hubs (Kafka-compatible), the cloud ingestion point.
1. **Storage/analytics** (one of the following services):
   - **Azure Data Explorer.** Event Hubs data connections stream into the `opcua_telemetry` and `opcua_metadata` tables. An Azure Data Explorer dashboard and the i3X REST API expose the data.
   - **Azure Databricks.** Structured Streaming reads Event Hubs into Delta Lake tables in Unity Catalog.
   - **Fabric.** An eventhouse (KQL DB) ingests from Event Hubs. A real-time dashboard and a Fabric-hosted i3X API expose it.
1. **Supporting services:** Key Vault (secrets), a user-assigned managed identity shared by the cloud services, an Azure Database for PostgreSQL flexible server, a UA Cloud Library container app, the I3X4Kusto container app (authentication-protected), and the Plant Copilot MCP container app, which exposes the i3X data to AI agents as read-only tools.

### Trust boundaries

- **Between physical/operational technology (OT) and the edge host.** The OPC UA servers and the Azure IoT Operations connector on the shared VM.
- **Between the edge and the cloud.** The Arc-connected K3s cluster on the VM, communicating with Azure (Event Hubs, Azure Resource Manager, Key Vault).
- **Between cloud services.** Managed identity-authenticated calls between the container apps, Azure Data Explorer or the eventhouse, Key Vault, and PostgreSQL.
- **Between the cloud and the external consumer.** The public dashboards, the i3X REST API, and the Plant Copilot MCP endpoint reached over the internet. (The latter is consumed by external AI agent runtimes such as Microsoft 365 Copilot or Copilot Studio.)
- **Deployment plane.** The Azure Resource Manager (ARM) template, the bootstrap scripts (fetched from GitHub `main`), and the operator's Azure credentials.

### STRIDE analysis

#### Spoofing

| Threat | Assessment in this solution | Recommendation for production |
| --- | --- | --- |
| Rogue OPC UA client/server impersonation | Mitigated: Mutual (two-way) OPC UA certificate trust is established between each station and the Azure IoT Operations connector. Stations reject peers that aren't in their `pki/trusted` or `pki/issuer` stores after they're out of provisioning mode. However, all certificates are self-signed, and stations accept anonymous sessions while they're in provisioning mode. | Use a proper PKI/CA (or OPC UA GDS) instead of self-signed certificates. Minimize the provisioning-mode window. Require user authentication on the OPC UA servers. |
| Impersonation of a cloud consumer of the i3X API | Mitigated: Authentication is mandatory on the i3X API and fails closed if no method is configured. Two methods are supported: HTTP Basic authentication and OAuth 2.0 / Entra ID bearer tokens (enabled by setting `I3X_OAUTH2_AUTHORITY`). By default, the deployment uses Basic authorization with a single shared `admin` account. | Basic authorization over TLS is acceptable for demos. For production, use the OAuth 2.0 / Entra ID path with per-consumer identities rather than the shared admin credential. For more information, see [Protect an API in Azure API Management using OAuth 2.0 authorization with Microsoft Entra ID](/azure/api-management/api-management-howto-protect-backend-with-aad).|
| Impersonation of a client of the Plant Copilot MCP server | Mitigated: Authentication is mandatory on the [Plant Copilot](agentic-ai-for-the-solution.md) MCP endpoint, and it fails closed. If no method is configured, the endpoint returns HTTP 503 instead of serving the tools. HTTP Basic authentication is enabled by default. (The user name defaults to `admin`, and the deployment supplies `adminUsername` and `adminPassword`, the password via an Azure Container Apps secret.) The server can also validate OAuth 2.0 bearer tokens from an external identity provider (`AUTH_AUTHORITY`, such as Microsoft Entra ID). The server is only a resource server. It never issues tokens and doesn't offer Dynamic Client Registration, so no caller can self-register and generate its own access. The residual weakness is that Basic authorization uses the single shared admin credential. | For production, configure `AUTH_AUTHORITY` (and `AUTH_AUDIENCE`) so tokens come from a real identity provider with interactive sign-in and consent and per-user/per-client identities. Leave `AUTH_BASIC_PASSWORD` unset so the shared credential isn't accepted. |
| Spoofing of service-to-service calls | Mitigated: Cloud services authenticate to Azure Data Explorer, Key Vault, and Event Hubs by using a user-assigned managed identity and Entra tokens (no shared keys for those hops). Azure Data Explorer read uses Entra workload identity federation. | Keep managed identity. Scope each service to its own identity rather than one shared identity. For more information, see [Elevation of privilege](#elevation-of-privilege). |
| Deployment and script source spoofing | Risk: The bootstrap and setup scripts are fetched at deploy time from the public GitHub `main` branch over HTTPS. A compromised branch or man-in-the-middle (MITM) attack on an unpinned reference could run attacker code on the VM. | Pin to an immutable commit or tag, verify checksums or signatures, or host the scripts in a trusted private location. |

#### Tampering

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Telemetry tampering in transit (edge to cloud) | Mitigated: Transport to Event Hubs is TLS-encrypted. The Azure IoT Operations MQTT broker hop uses TLS and SAT authorization. | Retain TLS everywhere. Retain OPC UA message signing and encryption end-to-end, including connections from other OPC UA servers to Azure IoT Operations. |
| Command tampering (cloud to edge pressure-relief) | Mitigated: The command path uses specification-compliant MQTT-RPC over TLS with SAT authorization, but a control command to physical equipment is high-impact. In the real world, this type of command is done on-premises. | Never actuate safety-critical equipment directly from the cloud. Require local interlocks, authorization, and command signing. |
| Tampering with data at rest | Mitigated by the platform: Azure Data Explorer, eventhouses, and Delta storage are Azure-managed with encryption at rest. Delta Lake retains history. | Enable immutability and retention policies where required. Restrict write access. (See [Elevation of privilege](#elevation-of-privilege)). |
| Configuration and PKI store tampering on the shared VM | Risk: The station PKI stores are host-mounted (`/mnt/c/K3s/...`). Anyone with VM access can alter trust material or the simulation. | Restrict VM access. Separate the simulation from real edge infrastructure. (They're co-located only to save cost.) |
| Dashboard and query definition tampering | Low: Dashboards and KQL are imported from the repo. | Review imported artifacts. The embedded Python (the Azure Data Explorer and Fabric graph tile) runs in the sandboxed `evaluate python` plugin. |
| Indirect prompt injection via tool results | Risk: Plant Copilot returns plant data (asset names and values) verbatim to the LLM, so malicious or crafted content stored upstream could influence the agent's reasoning. The impact is bounded because the tool surface is strictly read-only. The agent can't be induced to actuate the plant through it. | Treat all tool output as untrusted input in the agent. Keep write and command tools out of the MCP server. Validate and curate data at ingestion. |

#### Repudiation

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Actions can't be attributed | Partial: Azure platform logs (the activity log, resource diagnostics) exist, but the i3X API Basic authentication user is a single shared `admin` account, and the VM, PostgreSQL, and UA Cloud Library share one admin credential. Actions can't be attributed to individuals. | Enable diagnostic settings and audit logs on Azure Data Explorer, the eventhouse, Key Vault, Event Hubs and PostgreSQL. Use per-user identities so actions are traceable. Forward logs to a Security Information and Event Management (SIEM) system. |
| Command loop actions aren't logged | Partial: The connector and commander log RPC execution, but there's no signed audit trail of who or what triggered a physical command. | Add tamper-evident audit logging for control actions. |
| Agent data access isn't logged | Partial: The Plant Copilot MCP server emits a structured `AUDIT i3X access: <method> <path>` log entry for every tool-driven query, so all agent data access is recorded via Container Apps to Log Analytics. However, callers authenticate with the shared Basic credential by default, so entries can't be attributed to an individual. | Configure an external identity provider (`AUTH_AUTHORITY`), leave `AUTH_BASIC_PASSWORD` unset so the subject is a real Entra identity, and forward the audit entries to a SIEM. |

#### Information disclosure

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Public network exposure | Risk: Key Vault, Azure Data Explorer and PostgreSQL are deployed with `publicNetworkAccess: Enabled`. PostgreSQL uses an `AllowAllAzureIps` firewall rule. The i3X API, the Plant Copilot MCP endpoint and the dashboards are externally reachable. (The MCP endpoint needs to be, so that hosted agent runtimes can call it.) | Use private endpoints or virtual network integration. Replace `AllowAllAzureIps` with specific rules. Put the APIs behind a gateway or WAF. Restrict dashboard access. |
| Verbose upstream errors | Mitigated: Plant Copilot returns only a generic error to the caller when an i3X request fails and logs the upstream status and body server-side, so internal details aren't disclosed to the agent. Kestrel's `Server` response header is also suppressed to avoid fingerprinting. | Keep error responses generic on public endpoints. Review logs for sensitive content before forwarding them to a SIEM. |
| Secret exposure | Partial: Secrets are stored in Key Vault (RBAC-authorized, soft-delete, purge protection) and referenced via managed identity or container-app secretRefs. But the same `adminPassword` is used for the VM, PostgreSQL, UA Cloud Library, i3X Basic authentication credential, Plant Copilot Basic authentication credential, and the Event Hubs connection string (SAS) is stored as a Key Vault secret. | Use distinct, rotated secrets per service. Prefer managed identity or Microsoft Entra authorization over connection strings and shared passwords. Avoid credential reuse across trust boundaries. |
| Credentials in deployment inputs | Partial: `adminPassword` is a `secureString`. Ensure that it isn't echoed into logs. | Pass secrets via secure parameters or Key Vault references only. Scrub deployment logs. |
| Data exposure via the analytics back ends | Depends on the configuration: Azure Data Explorer, eventhouses, and Azure Databricks all enforce Microsoft Entra RBAC, but overly broad grants (for example, the shared identity is Azure Data Explorer Admin) widen exposure. | Grant least-privilege database roles (Viewer or Ingestor) instead of Admin. Apply row and column security if telemetry is sensitive. |

#### Denial of service

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Public endpoints abused | Partial: The Plant Copilot MCP endpoint enforces per-caller rate limiting (sliding window, default 120 requests per minute per identity or IP, returning `429` with `Retry-After`). This configuration limits request amplification into i3X and Azure Data Explorer. The dashboards, the i3X API, and the public Key Vault, Azure Data Explorer, and PostgreSQL endpoints remain without explicit throttling. | Front the remaining public services with rate limiting, WAF, and DDoS protection (Azure Front Door or API Management). Use private networking to remove the attack surface entirely. |
| Single-VM single point of failure | Risk: One Linux VM hosts both the simulation and the edge infrastructure, and the i3X subscription state is in-memory, requiring a single replica. | Separate simulation from the production edge. Run redundant edge infrastructure. Externalize API state to scale out. |
| Ingestion overload | Partial: Event Hubs and Azure Data Explorer absorb bursts, but there are no explicit quotas or throttles in the sample. | Configure Event Hubs throughput units / auto-inflate, Azure Data Explorer capacity, and consumer backpressure. |
| Unbounded queries and information-model imports | Low: KQL queries and the UA Cloud Library `[Future]` import use `take` limits. The graph tile runs in the sandbox. | Keep query limits. Limit import sizes. |

#### Elevation of privilege

| Threat | Assessment | Recommendation |
| --- | --- | --- |
| Over-privileged shared managed identity | Risk: A single user-assigned managed identity is shared by the container apps and is granted broad roles (Contributor at resource group scope, Azure Data Explorer Admin). Compromise of any one workload yields all its rights. | Give each workload its own identity with least-privilege, resource-scoped roles. Avoid the resource group-wide Contributor role. |
| Deployment identity over-permissioned | Expected: Deployment needs Owner (or Contributor plus User Access Administrator) to create role assignments. | Use just-in-time or PIM elevation for the deployment principal. Remove the Owner role after deployment. |
| Kubernetes cluster-admin token | Risk: The documented portal-access flow creates a cluster-admin service account and a long-lived token. | Scope the service account to least privilege. Use short-lived tokens. Rotate or revoke the token after use. |
| Lateral movement from the shared VM | Risk: The VM holds edge credentials, PKI stores, and Arc identity. Compromise of the VM allows an attacker to access the cluster and, via managed identity, cloud resources. | Harden and isolate the VM. Restrict its managed-identity scope. Monitor for anomalous identity use. |
| OPC UA trust-list caching | Mitigated: The setup script establishes mutual OPC UA trust before the devices and assets are onboarded, so the connector and commander pods mount a fully-populated trust list at startup and the former "add trust, then restart the pods" workaround is no longer needed. The script waits for the certificates to appear in the synced trust-list secret before onboarding. | Alert on connection failures. Re-run the trust step if station certificates are regenerated. |
| Agent actuation beyond read-only intent | Mitigated by design: Plant Copilot exposes only read tools (browse the ISA-95 hierarchy, read current values and history). There's no tool that writes a set-point, acknowledges an alarm, or otherwise actuates the plant, so a compromised or manipulated agent can't change plant state through Plant Copilot. However, Plant Copilot authenticates upstream to the i3X API by using the shared admin credential, so its effective upstream rights are broader than its own tool surface. | Keep write and command capability out of the MCP server and route any actuation through a separate, human-approval-gated path. Give the MCP server a dedicated least-privilege, read-only i3X identity instead of the shared admin credential. |

### Analytics path-specific considerations (Azure Data Explorer, Azure Databricks, Fabric)

- **Common to all three:** The same edge and Event Hubs ingestion, shared managed identity, shared `adminPassword`, and public endpoints apply regardless of back end, so the spoofing, information disclosure, and elevation of privilege information described earlier is path-independent.
- **Azure Data Explorer:** Read authorization uses Entra workload identity federation (no secret). The shared identity is Azure Data Explorer Admin, which is over-privileged. Prefer a database Viewer or Ingestor role. The dashboard's graph tile runs Python in the sandboxed `evaluate python` plugin. The i3X API in front of Azure Data Explorer enforces authentication (Basic authorization by default, or Entra ID Oauth 2.0) but is publicly reachable.
- **Azure Databricks:** Tables live in Unity Catalog (governed, Entra RBAC) with Structured Streaming checkpoints in a Unity Catalog volume. Ensure workspace access, cluster policies, and secret scopes are locked down and the Event Hubs credential is least-privilege.
- **Fabric:** The eventhouse and Real-Time Dashboard use Fabric RBAC, Entra RBAC, and a separate deployment with its own independent `adminUsername` and `adminPassword` for its i3X API. Enabling `deployFabricCapacity` requires pre-existing Fabric capacity quota. Restrict Fabric workspace roles and the eventhouse's callout and plugin policies. (The `http_request` plugin used for UA Cloud Library import is powerful. Don't enable it unless you need it.)

### Summary of recommendations for production

- **Remove public exposure.** Use private endpoints or virtual network integration for Key Vault, Azure Data Explorer, PostgreSQL, and Event Hubs. Use a gateway or WAF for the API and dashboards. Don't use `AllowAllAzureIps`.
- **Enforce least privilege.** Use per-workload managed identities. Use database Viewer or Ingestor roles instead of Azure Data Explorer Admin. Don't use the resource group-wide Contributor role. Use scoped, short-lived Kubernetes tokens.
- **Eliminate credential reuse.** Use distinct, rotated secrets per service. Prefer Entra or managed-identity authorization over connection strings and shared passwords. Use OAuth 2.0 for the API. (See the next section.)
- **Use proper PKI.** Use CA-issued (or GDS-managed) OPC UA certificates. Minimize provisioning-mode and anonymous windows.
- **Implement auditability.** Enable diagnostic settings and audit logs on all services, per-user identities, and a signed audit trail for control commands. Forward logs to a SIEM.
- **Harden the edge.** Separate the simulation from real edge infrastructure. Isolate and monitor the VM. Never actuate safety-critical equipment directly from the cloud.
- **Secure the supply chain.** Pin deployment scripts and templates to immutable, verified references instead of GitHub `main`.

### Configure OAuth 2.0 for the i3X API via Microsoft Entra ID

Follow these steps to protect the API with Microsoft Entra ID and call it with a bearer token.

1. Register the API (the resource that's being protected).
   
   1. In the Azure portal, go to **Entra ID** > **Manage** > **App registrations** > **New registration** and create an app for I3X4Kusto.
   
   1. Open the new app's **Expose an API** pane, and set the **Application ID URI**, for example, `api://<api-client-id>`. This value becomes `I3X_OAUTH2_AUDIENCE`.
   1. Decide how callers will authenticate, and add the matching permission on the app:
      - **App-only (client-credentials). Used by the quick test described later in this procedure and by service callers like Plant Copilot:** Go to **App roles** > **Create app role** and select **Applications** in **Allowed member types**. (You can use, for example, display name **I3X.Read** and value **I3X.Read**.) Client-credentials tokens carry app roles in the `roles` claim, not delegated scopes.
      - **Delegated (user sign-in):** Under **Expose an API** > **Add a scope**, add a delegated scope, like **access_as_user**. Delegated tokens carry the scope in the `scp` claim.
   
   1. Note your **Directory (tenant) ID**. It constructs `I3X_OAUTH2_AUTHORITY`.

1. Configure the deployed API. The `i3x4kusto` container app reads its OAuth settings from environment variables, so you need to set them on the deployed app. Setting them in your local shell has no effect. Update the app and let Container Apps roll out a new revision:

   ```bash
   az containerapp update \
     --name <resourcesName>-i3x4kusto \
     --resource-group <resourcesName> \
     --set-env-vars \
       I3X_OAUTH2_AUTHORITY="https://login.microsoftonline.com/<tenant-id>/v2.0" \
       I3X_OAUTH2_AUDIENCE="api://<api-client-id>" \
       I3X_OAUTH2_ISSUER="https://login.microsoftonline.com/<tenant-id>/v2.0"
   ```

   `I3X_OAUTH2_ISSUER` is optional. If it's not provided, it's taken from the authority metadata. Changing environment variables creates a new revision automatically. If the app is running in single-revision mode you can force a restart:

   ```bash
   az containerapp revision restart \
     --name <resourcesName>-i3x4kusto \
     --resource-group <resourcesName> \
     --revision $(az containerapp show --name <resourcesName>-i3x4kusto --resource-group <resourcesName> --query properties.latestRevisionName -o tsv)
   ```

   When the new revision is running, bearer-token authentication is active on the API. (HTTP Basic authorization is still accepted as well, if it's configured.)

1. Acquire a token. For a quick end-to-end test, use the app-only client-credentials flow with the app role from step 1:
   1. Add a client secret to the app registration by selecting **Certificates & secrets** > **New client secret**.
   1. Grant the calling application the `I3X.Read` app role (application permission): On the **API permissions** pane of the client app registration, select **Add a permission** > **My APIs** > **\<your I3X4Kusto app>** > **Application permissions** > **I3X.Read** > **Grant admin consent**. (For a self-test, you can use a single app registration for both the client and the API. The app role must still be assigned and granted admin consent so it appears in the token's `roles` claim.)

   ```bash
   ACCESS_TOKEN=$(curl -s -X POST \
     https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token \
     -d "grant_type=client_credentials" \
     -d "client_id=<client-id>" \
     -d "client_secret=<client-secret>" \
     -d "scope=api://<api-client-id>/.default" \
     | jq -r .access_token)
   ```

   For user sign-in scenarios, use a separate client app that's granted the API's delegated scope (`access_as_user`) and acquire a delegated token instead.

1. Call the API by using the token:

   ```bash
   curl -H "Authorization: Bearer $ACCESS_TOKEN" https://<host>/v1/objects
   ```

**Troubleshooting.** If you get a 401 error, decode the token at [jwt.ms](https://jwt.ms) and verify that:
- `aud` exactly matches `I3X_OAUTH2_AUDIENCE`.
- `iss` matches the v2.0 issuer `https://login.microsoftonline.com/<tenant-id>/v2.0`. If your token is a v1 token (`iss` = `https://sts.windows.net/<tenant-id>/`), either request a v2 token or set `I3X_OAUTH2_ISSUER` to match the token's issuer.
- The permission is present. An app-only token contains the app role in the `roles` claim (for example, `I3X.Read`). A delegated token contains the scope in the `scp` claim (for example, `access_as_user`). If the `roles` claim is missing, it's usually because the application permission wasn't assigned **and** granted admin consent.
- The token isn't expired (`exp`).

#### Example: OAuth 2.0 environment variables

The `i3x4kusto` container consumes the following variables. Set them on the deployed container app as shown in step 2 of the preceding procedure, not in your local shell.

```bash
# Enable OAuth2 bearer-token authentication against an Entra ID tenant.
I3X_OAUTH2_AUTHORITY="https://login.microsoftonline.com/<tenant-id>/v2.0"
I3X_OAUTH2_AUDIENCE="api://<application-client-id>"
# Optional: pin the expected issuer (otherwise taken from the authority metadata).
I3X_OAUTH2_ISSUER="https://login.microsoftonline.com/<tenant-id>/v2.0"
```

Clients then acquire a token from the authority and call the API by using it:

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" https://<host>/v1/objects
```
