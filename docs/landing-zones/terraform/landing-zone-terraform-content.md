This article discusses the design considerations of the [Azure landing zones Terraform module](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest). The module is an opinionated approach to deploy and manage the core platform capabilities of the [Azure landing zone conceptual architecture](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework (CAF).

Terraform is an open-source Infrastructure as Code (IaC) tool, created by HashiCorp, that uses declarative syntax to deploy infrastructure resources. (Kevin - what key features of Terraform do you want to call out here? State management? Other?)

![GitHub logo](../../../_images/github.png) The module is available on [GitHub: Azure landing zones Terraform module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale). You can use it as a starting point and configure it as per your needs.

> [!NOTE]
> There are [implementations](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) for several deployment technologies, including portal-based, ARM templates and Terraform modules. The choice of deployment technology should not influence the resulting Azure landing zones deployment.

## Design

:::image type="content" border="true" source="images/alz-tf-module-overview.png" alt-text="Diagram showing the Azure landing zones conceptual architecture." lightbox="images/alz-tf-module-overview.png":::

The implementation focuses on the central resource hierarchy of the [Azure landing zone conceptual architecture](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture).  The design is centered around the following capabilities:

* Core Resources
* Management Resources
* Connectivity Resources
* Identity Resources

## Capabilities

This section provides a high-level overview of the core capabilities in this module.

### Core resources

The [Core Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources) capability of the module aligns to the [resource organization](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) design area of the Cloud Adoption Framework. It deploys the foundational resources of the [conceptual architecture for Azure landing zones](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture).

:::image type="content" border="true" source="images/terraform-caf-enterprise-scale-core.png" alt-text="Diagram showing the core Azure landing zones architecture deployed by the Terraform module." lightbox="images/terraform-caf-enterprise-scale-core.png":::

#### Overview of key core resources

| Resource Type(s) | Description | Useful Links |
|---|---|---|
| Management Groups | Management groups are the highest level resources in an Azure tenant. Management groups allow you to more easily manage your resources. You can apply policy at the management group level and lower level resources will inherit that policy. Specifically, you can apply the following items at the management group level that will be inherited by subscriptions under the management group:<br /><ul><li>Azure Policies</li><li>Azure Role Based Access Controls (RBAC) role assignments</li><li>Cost controls</li></ul><br /> | <ul><li>[Management groups - Cloud Adoption Framework (CAF) documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)</li></ul> |
| Policy definitions, policy assignments, and policy set definitions | DeployIfNotExists (DINE) or Modify policies help ensure the subscriptions and resources that make up landing zones are compliant. Policies are assigned to management groups through policy assignments. The policies  ease the burden of management of landing zones. Policy set definitions group sets of policies together.<br /><br />Not all customers are able to use DINE or Modify policies. If that is the case for you, [CAF guidance on custom policies](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance) provides guidance. | <ul><li>[Adopt policy-driven guardrails - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)</li><li>[Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)</li></ul> |
| Role definitions and role assignments | Role-based access control (RBAC) simplifies the management of user rights within a system. Instead of managing the rights of individuals, you determine the rights required for different roles in your system. Azure RBAC has several [built-in roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles). Custom role definitions allow you to create custom roles for your environment.<br/><br/> Identity and access management (IAM) is the key security boundary in cloud computing. Azure RBAC allows you to perform role assignments of built-in roles or custom role definitions to Service Principals, Managed Identities or security groups across management groups and subscriptions. | <ul><li>[Azure role-based access control - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/roles)</li><li>[Azure identity and access management design area - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access)</li><li>[Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)</li></ul> |

#### Archetypes

What makes a management group classified as a particular Azure landing zone management group are the combination of policy definitions, policy set definitions, policy assignments, role definitions and role assignments. In the Terraform implementation, these decisions are encapsulated as [Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions).  

Landing zone management groups reference the archetype definitions. In this way, archetype definitions are reusable. In the below corp landing zone management group, the archetype_config has a pointer to the "es_corp" archetype definition. Again, that definition contains all the policy and role configurations.

```terraform
  es_corp_landing_zones = {
    "contoso-corp" = {
      display_name               = "Corp"
      parent_management_group_id = "contoso-landing-zones"
      subscription_ids           = []
      archetype_config           = {
        archetype_id ="es_corp"
        parameters   = {}
        access_control = {}
    }
  }
```

#### Deployment - core resources

By default, the module will deploy the following hierarchy which is the core set of landing zones:

* Root
  * Platform
    * Identity
    * Management
    * Connectivity
  * Landing Zones
  * Decommissioned
  * Sandbox

The SAP, Corp and Online landing zones do not apply to everyone so they are not deployed by default. The following are ways to deploy workload management groups:

1. For demo purposes, you can set the ```deploy_demo_landing_zones``` variable to true which will deploy SAP, Corp and Online landing zones
2. For production purposes, you can turn on the management groups you want by setting the following variables to true:
    * ```deploy_corp_landing_zones```
    * ```deploy_online_landing_zones```
    * ```deploy_sap_landing_zones```
3. You can deploy your own custom landing zones by creating a [custom landing zone](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-custom_landing_zones)

### Management resources

The [Management Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources) capability of the module aligns to the [management](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) design area of the Cloud Adoption Framework. This capability provides the option to deploy management and monitoring resources to the management platform landing zone.

#### Overview of key management resources

| Resource Type(s) | Description | Useful Links |
|---|---|---|
| Azure Monitor, Azure Automation, and Microsoft Sentinel | Azure Monitor, Azure Automation and Microsoft Sentinel allow you monitor and manage your infrastructure and workloads. Azure Monitor is a solution that allows you to collect, analyze and act on telemetry from your environment.<br/><br/>Microsoft Sentinel is a cloud-native security information and event management (SIEM). It allows you to:<br/><ul><li>Collect - Collect data across your entire infrastructure</li><li>Detect - Detect threats that were previously undetected</li><li>Respond - Respond to legitimate threats with built-in orchestration</li><li>Investigate - Investigate threats with artificial intelligence</li></ul><br/><br/>Azure Automation is a cloud-based automation system. It includes:<br/><ul><li>Configuration management - Inventory and track changes for Linux and Windows virtual machines and manage desired state configuration</li><li>Update management - Assess Windows and Linux system compliance and create scheduled deployments to meet compliance</li><li>Process automation - Automate management tasks</li></ul> | <ul><li>[Workload management and monitoring - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads)</li></ul> |

#### Deployment - management resources

To deploy the management resources, the ```deploy_management_resources``` variable must be set to true and the ```subscription_id_management``` variable must be set to the id of the management subscription where the resources are to be deployed.

```bash
deploy_management_resources = true
subscription_id_management = <management subscription id>
```

### Connectivity resources

The [Connectivity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources) capability of the module provides the option to deploy the [network topology and connectivity](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) of the [conceptual architecture for Azure landing zones](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture).

#### Overview of key connectivity resources

| Resource Type(s) | Description | Useful Links |
|---|---|---|
| [Core networking resource types listed here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources#resource-types) | Network topology is a key consideration in Azure landing zone deployments. [CAF focuses on 2 core networking approaches](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology):<br/><ul><li>Topologies based on Azure Virtual WAN</li><li>Traditional topologies</li></ul> | <ul><li>[Define an Azure network topology - CAF Documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)</li></ul> |
| DDoS protection plans | Azure landing zone guidance recommends enabling DDoS Protection Standard. This service offers turnkey protection against DDoS attacks. | <ul><li>[Azure DDoS Protection Standard overview](https://docs.microsoft.com/azure/ddos-protection/ddos-protection-overview)</li></ul> |
| DNS Zones, Private DNS Zones, and Private DNS Zone Virtual Network Link | Private DNS zones can be deployed to support the use of private endpoints. A private endpoint is a NIC that is assigned a private IP address from your virtual network that you can use to securely communicate to services that supports Azure Private Link. Private DNS zones can be configured to resolve the fully qualified domain name (FQDN) of the service to the private endpoint private IP address. | <ul><li>[Azure Private Endpoint DNS configuration](https://docs.microsoft.com/azure/private-link/private-endpoint-dns)</li></ul> |

#### Deployment - connectivity resources

Deploy Connectivity Resources provides guidance on how to deploy these topologies.

### Identity resources

The [Identity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources) capability of the module aligns to the [Azure identity and access management design area](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access) of the Cloud Adoption Framework. This capability provides the option to configure policies on the Identity platform landing zone.

No resources are deployed with this capability. When the ```deploy_identity_resources``` variable is set to true, Azure Policy assignments are configured that protect resources in the identity platform landing zone subscription.

#### Deployment - identity resources

To deploy the identity capability, the ```deploy_identity_resources``` variable must be set to true and the ```subscription_id_identity``` variable must be set to the id of the identity subscription where the policies are to be configured.

```bash
deploy_identity_resources = true
subscription_id_identity = <identity subscription id>
```
