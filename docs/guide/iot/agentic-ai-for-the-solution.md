---
title: Agentic AI for the OPC UA Reference Solution
description: Learn how to use agentic AI to augment a solution that uses OPC Unified Architecture (OPC UA) to connect shop-floor telemetry to Azure analytics services.
author: barnstee
ms.author: erichb
ms.subservice: architecture-guide
ms.topic: concept-article
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Agentic AI for the OPC UA reference solution

After the [OPC UA reference solution](iot-industrial-solution-architecture.md) is deployed, the factory's OPC UA telemetry is connected, normalized against the ISA-95 asset hierarchy, and made queryable via Azure Data Explorer (or a Microsoft Fabric eventhouse) and the [i3X](https://api.i3x.dev) API. The OPC UA solution provides exactly the kind of grounded, well-structured, real-time data that an agentic AI solution needs. This article describes how to use an AI agent with the reference solution. An automatically deployed read-only Plant Copilot answers natural-language questions about the plant. The article outlines a safe path toward using agents that can take action.

## Why agentic AI needs an information model

Large language models (LLMs) provide powerful reasoning, but they don't know your plant. They don't know that work cell 3 is an assembly station on the Seattle assembly line, what its current energy consumption is, or how its throughput changed over the last shift. If you ask a raw model these questions, it guesses, and guessing is unacceptable on a factory floor.

This solution solves that problem by giving the agent tools instead of asking it to remember facts:

- The **ISA-95 asset hierarchy** (enterprise > site > area > line > cell > asset) gives the agent a map of the plant that it can browse.
- The **OPC UA information model** (object and variable types) tells the agent what kinds of assets exist and what each one measures.
- **Live values** and **historical trends** give the agent actual numbers, with quality indicators and timestamps, when it needs them.

When the agent grounds an answer in a tool result, it can cite the exact asset, value, and time that it used, which supports trust and auditability.

## The Model Context Protocol

The agent communicates with these tools by using the [Model Context Protocol (MCP)](https://modelcontextprotocol.io), an open standard for exposing tools and data to LLM agents. MCP is supported by Microsoft 365 Copilot, Microsoft Copilot Studio, Microsoft Foundry, Claude and a growing list of hosts, so you can reuse a single MCP server across many agent experiences.

This reference solution includes an MCP server called [Plant Copilot](https://github.com/digitaltwinconsortium/ManufacturingOntologies/tree/main/Tools/PlantCopilot). It's a thin, read-only wrapper around the i3X API that presents the factory data as a group of well-described tools. It's packaged as a Docker image and deployed as an Azure container app. It uses the MCP Streamable HTTP transport mechanism so that remote agent runtimes can reach it over HTTPS at `/mcp`.

## Architecture

:::image type="complex" source="./media/agentic-ai-architecture.svg" alt-text="Diagram that shows the Plant Copilot agentic AI solution." lightbox="./media/agentic-ai-architecture.svg" border="false":::
On the left is an icon labeled User (chat/app). An arrow labeled Natural language points from the user to a box labeled Agent runtime, which represents agent hosting platforms like Microsoft 365 Copilot and Microsoft Foundry, among others. A second arrow labeled Grounded answer points from the Agent runtime box to the user. Below the Agent runtime box, an arrow labeled MCP connects to a box labeled Plant Copilot MCP server. Below the Plant Copilot MCP server, an arrow labeled i3X connects to a box labeled I3X4Kusto. Below I3X4Kusto, an arrow labeled KQL connects to the final box, labeled Azure Data Explorer or Fabric eventhouse.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/agentic-ai-architecture.vsdx) of this architecture.*

The agent never touches the database directly. It sees only the curated, read-only tools. The i3X layer enforces authentication and the ISA-95 structure of the data.

## Plant Copilot tools

| Tool | Purpose |
|------|---------|
| `get_server_info` | Check health and capabilities. |
| `list_namespaces` | List OPC UA namespaces in the data. |
| `list_object_types` | List the information model (types). |
| `list_root_objects` | Browse the top of the ISA-95 asset hierarchy. |
| `list_relationship_types` | List relationship types that can filter related-object queries. |
| `list_objects_of_type` | Find all assets or variables of a given type. |
| `get_related_objects` | List the children or variables of an asset. |
| `get_current_values` | Read the latest value/quality/timestamp. |
| `get_value_history` | Read historical trends over a time range. |

With just these tools, an agent can respond to queries like these:

- "What is the current energy consumption of work cell 3?"
- "How did the Munich production line's throughput trend over the last shift?"
- "Which assets are test stations, and which ones have high pressure right now?"
- "List the sites and lines in the plant."

## Running Plant Copilot

Plant Copilot is deployed as part of the reference solution. You don't need to set up anything else. Its container image is built and published automatically to `ghcr.io/digitaltwinconsortium/manufacturingontologies/plantcopilot:main`. The deployment template provisions it as an Azure container app connected to the in-cluster i3X app. The deployment exposes its remote MCP endpoint as the `plantCopilotMcpUrl` output, for example, `https://<resourcesName>-plantcopilot.<region>.azurecontainerapps.io/mcp`.

To expose Plant Copilot inside Microsoft 365 Copilot, register it as an MCP tool, add it to a custom agent, and publish that agent to Microsoft 365 Copilot.

> **Permissions and governance prerequisites.** Registering a custom MCP connector and publishing an agent are governed by tenant-level policies that only administrators can configure. Before you start, make sure a Microsoft Power Platform administrator (and, where noted, a Microsoft 365 administrator and a Microsoft Entra ID administrator) completes the following prerequisites. Otherwise, the connection fails at creation or sign-in.
>
> - **Copilot Studio maker access.** You need a Microsoft Power Platform environment in which you can build agents (Environment Maker role), ideally a dedicated development or sandbox environment.
> - **DLP data policy.** The Plant Copilot custom connector must be classified into an allowed group (**Business** or **Non-Business**, matching the agent's other connectors), not **Blocked**. You can configure this setting under **Security** > **Data policies** in the Microsoft Power Platform admin center.
> - **Tenant isolation / connector endpoint filtering.** Outbound OAuth to the Plant Copilot host (`https://<resourcesName>-plantcopilot.<region>.azurecontainerapps.io`) must be allowed. These settings are tenant-scoped. Only a Global or Power Platform administrator can view or change them.
> - **Microsoft Entra ID (production authentication mode only).** Configure both `AUTH_AUTHORITY` and `AUTH_AUDIENCE`. Without `AUTH_AUDIENCE`, Plant Copilot disables audience validation and can accept tokens issued for other resources by the configured authority. Register the Plant Copilot API and the Copilot Studio client app in Microsoft Entra ID, grant the client access to the API, and ensure that no Conditional Access policy blocks sign-in. The exact blocking policy appears in **Microsoft Entra ID** > **Sign-in logs**.
> - **Microsoft 365 admin approval.** Publishing the agent to the Microsoft 365 Copilot channel might require approval in the [Microsoft 365 admin center](https://admin.microsoft.com/), under **Settings** > **Integrated apps**.
>
> If you're not an administrator, share this list (plus the connector name and host URL) with your tenant admin. Nothing in the Plant Copilot code or deployment can bypass these tenant governance controls.

### Register the MCP server as a tool

In [Microsoft Copilot Studio](https://copilotstudio.microsoft.com/), select **Tools** > **New tool** > **Custom Connector** > **New custom connector** > **Create from blank**. Provide these values:

- Connector name: **Plant Copilot**
- General > Scheme: **HTTPS**
- Security > Authentication type: **Basic Authentication**

   > [!NOTE]
   > Basic Authentication should be used only for demos. In a production environment, prefer Entra or managed-identity authorization over connection strings and shared passwords. Use OAuth 2.0 for the API.

- Security > Basic authentication: Provide two parameters called **username** and **password**.
- Definition > New Action > General > Operation ID: **InvokeServer**
- Definition > New Action > Request > Import from Sample > Verb: **POST**
- Definition > New Action > Request > Import from Sample > Url: **https://\<resourcesName>-plantcopilot.\<region>.azurecontainerapps.io/mcp**
- Test > Connections > New Connection: Enter the username and password you provided during the deployment of this solution.

Create the tool. On first connection, Copilot Studio performs the OAuth flow against Plant Copilot. Approve the request to establish the connection.

### Create the agent

1. In Copilot Studio, select **Create** > **New agent** (or **Agents** > **New agent**).
1. Give the agent a name (for example, **Plant Copilot**), provide a description of the agent, and set instructions that direct it to answer only from the tool results. For example: **"You are a plant assistant. Use the Plant Copilot tools to answer questions about assets, live values, and history. Always ground answers in tool results and cite the asset ID, value, and timestamp you used. Never invent data."**
1. Under the agent's **Tools**, select **Add tool** and choose the **Plant Copilot** MCP tool registered in the previous section.
1. Use the **Test** pane to confirm that the agent calls the tools and returns grounded answers. (For example, ask it to **"List the sites and lines in the plant"**.)

### Publish the agent to Microsoft 365 Copilot

1. Select **Publish** to publish the agent.
1. On the **Channels** tab, open **Teams and Microsoft 365 Copilot**, select **Make agent available in Microsoft 365 Copilot**, and select **Add channel**.
1. To publish organization-wide, select **Availability options** > **Show to everyone in my org** > **Submit for admin approval**. A Microsoft 365 admin reviews the request in the [Microsoft 365 admin center](https://admin.microsoft.com/) under **Agents** > **All agents** > **Requests**.

After the agent is published and approved, users can select it in Microsoft 365 Copilot (in Teams, Outlook, or the Microsoft 365 Copilot app) and ask questions about the plant directly. Copilot grounds its answers in the tool results returned by Plant Copilot.

## Alternative: A Fabric data agent for the eventhouse

If you're using the [Microsoft Fabric](how-to-connect-fabric-to-solution.md) alternative of the reference solution, you can create the same grounded plant Copilot experience entirely in Fabric, without the MCP server, Copilot Studio, or the associated connector governance. A [Fabric data agent](/fabric/data-science/concept-data-agent) answers natural-language questions against Fabric data sources by generating KQL queries directly against them. Because the reference solution already mirrors the OPC UA tables, functions, and views into the Fabric eventhouse, the plant data is available for the agent to query.

> **Which approach to use.** The Plant Copilot **MCP server** is the cross-host option. It provides one read-only tool surface that's reusable across many agent runtimes (Microsoft 365 Copilot, Claude, and others). A **Fabric data agent** is an in-Fabric alternative that queries KQL directly rather than using the curated i3X read-only tools. It requires Fabric capacity, the applicable tenant settings, and access to the data source. A Fabric data agent doesn't call the Plant Copilot MCP server. A published Fabric data agent can instead be exposed as an MCP server for other hosts, but this capability is in preview. Fabric data agents require a paid capacity of F2 or higher. Depending on the capacity's region, cross-geo AI processing and storage settings might also be required. When a data agent is consumed through a non-Fabric service, responses might be processed or stored outside the Fabric compliance boundary or geographic region according to that service's policies.

To create a Fabric data agent:

1. Open the Fabric workspace that contains the eventhouse provisioned by the reference solution.
1. Create a data agent and add the eventhouse KQL database as its data source.
1. Set instructions that keep the agent grounded. For example: **"You are a plant assistant. Answer questions about assets, live values, and history using the eventhouse. Always ground answers in query results and cite the asset ID, value, and timestamp. Never invent data."**
1. Optionally, add a few example questions and their KQL queries to direct the agent toward the ISA-95 tables, functions, and views. For more information, see [Connect Microsoft Fabric to the reference solution](how-to-connect-fabric-to-solution.md).
1. Test the agent with some questions. If you added examples, use those questions. For example, you could use "What is the current energy consumption of the assembly station in Seattle?" or "How did the Munich production line's throughput trend over the last shift?" The agent generates KQL against the eventhouse and grounds its answers in the results.

Because the reference solution normalizes telemetry against the ISA-95 asset hierarchy and OPC UA information model, the eventhouse already provides the semantic structure a data agent needs to analyze the plant.

## Beyond read-only: agents that take action

Answering questions is only the first scenario. Because the reference solution already contains normalized, model-driven data, several higher-value agentic scenarios are possible:

- **Anomaly triage.** When the anomaly detection or prediction pipeline flags an asset, an agent gathers the related context (recent history, sibling assets, asset type) and drafts an explanation and recommended next step for an operator to review.
- **Predictive-maintenance work orders.** An agent turns a prediction into a proposed work order in [Connect Microsoft Dynamics 365 Field Service to the reference solution](how-to-connect-dynamics-field-service-to-the-solution.md), which a planner approves.
- **Human-in-the-loop optimization.** An agent proposes a set-point change or schedule adjustment. The change is applied only after a human approves it and is actuated through a separate, authenticated command path (for example an OPC UA command via a dedicated, approval-gated service).
- **Self-documenting assets.** An agent uses the standardized OPC UA information models imported in [Import OPC UA Information Models from the UA Cloud Library into Azure services](import-opc-ua-information-models-from-ua-cloud-library.md) to describe unfamiliar assets in plain language.

## Safety and guardrails

Actuation on a factory floor carries physical risk, so the reference solution keeps a strict separation between reading and acting:

- **Read-only by default.** The Plant Copilot MCP server exposes browsing and querying tools only. It has no tool that changes a set-point, acknowledges an alarm, or otherwise actuates the plant.
- **Approval-gated writes.** Any action that changes the plant must go through a separate, authenticated, human-approved path. The agent might propose an action, but a person authorizes it.
- **Grounding.** Tools return data with explicit values, quality, and timestamps, and the tool descriptions instruct the agent to answer only from that data rather than inventing asset IDs, values, or times.
- **Limited access.** The i3X API is protected with authentication.
- **Auditability.** Every tool call and every proposed or approved action should be logged to your SIEM. This logging directly supports the *Repudiation* mitigations in the reference solution's [security review](iot-industrial-solution-architecture.md#security-review-stride).

Starting with a grounded, read-only Copilot lets you demonstrate value quickly and safely and then add approval-gated actions one scenario at a time as trust is established.

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
- [Connect Microsoft Fabric to the reference solution](how-to-connect-fabric-to-solution.md)