Machine Learning DevOps (MLOps), first highlighted in [Hidden Technical Debt in Machine Learning Systems](https://papers.nips.cc/paper/2015/file/86df7dcfd896fcaf2674f757a2463eba-Paper.pdf) in 2015, is growing fast. The market for MLOps is expected to reach $4 billion by 2025. In the meantime, working to secure MLOps solutions is becoming more important.

This article describes how to help protect MLOps solutions by using Azure network security capabilities such as Azure Virtual Network, network peering, Azure Private Link, and Azure DNS. It also introduces how to use:

- Azure Pipelines to access resources in the virtual network
- The required configurations of Azure Container Registry and Azure Machine Learning compute instances and clusters in a virtual network.

Finally, this article describes the costs of using the network security services.

## Architecture

:::image type="content" alt-text="Diagram of the stages in the MLOps process, from preparing data to monitoring the model." source="./media/network-security-mlops-architecture.svg" lightbox="./media/network-security-mlops-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/network-security-mlops-architecture.vsdx) of this architecture.*

### Dataflow

The architecture diagram shows a sample MLOps solution.

- The virtual network named **AML VNET** helps protect the Azure Machine Learning workspace and its associated resources.

- The jump host, Azure Bastion, and self-hosted agents belong to another virtual network named **BASTION VNET**. This arrangement simulates having another solution that requires access to the resources within AML VNET.

- With the support of virtual network peering and private DNS zones, Azure Pipelines can execute on self-host agents and trigger the Azure Machine Learning pipelines that are published in the Azure Machine Learning workspace to train, evaluate, and register the machine learning models.

- Finally, the model is deployed to online endpoints or batch endpoints that are supported by Azure Machine Learning compute or Azure Kubernetes Service clusters.

### Components

The sample MLOps solution consists of these components:

- Data storage: [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) for data storage.
- Model training, validation, and registration: [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) workspace
- Model deployment: [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints) and [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service)
- Model monitor: [Azure Monitor](https://azure.microsoft.com/services/monitor) for Application Insights
- MLOps pipelines: [Azure DevOps](https://azure.microsoft.com/services/devops/) and [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines)

This example scenario also uses the following services to help protect the MLOps solution:

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy/)
- [Virtual Network](https://azure.microsoft.com/services/virtual-network/)

## Scenario details

MLOps is a set of practices at the intersection of Machine Learning, DevOps, and data engineering that aims to deploy and maintain machine learning models in production reliably and efficiently.

The following diagram shows a simplified MLOps process model. This model offers a solution that automates data preparation, model training, model evaluation, model registration, model deployment, and monitoring.

:::image type="content" alt-text="Diagram of the stages in the MLOps process, from preparing data to monitoring the model." source="./media/network-security-mlops-process-pipeline-flow.png" lightbox="./media/network-security-mlops-process-pipeline-flow.png":::

When you implement an MLOps solution, you might want to help secure these resources:

- DevOps pipelines
- Machine learning training data
- Machine learning pipelines
- Machine learning models

To help secure resources, consider these methods:

- Authentication and authorization

  - Use [service principals](/azure/active-directory/fundamentals/service-accounts-principal) or [managed identities](/azure/media-services/latest/concept-managed-identities) instead of interactive authentication.
  - Use [role-based access control](/azure/role-based-access-control/overview) to define the scope of a user's access to resources.

- Network security

  - Use [Virtual Network](/azure/virtual-network/virtual-networks-overview) to partially or fully isolate the environment from the public internet to reduce the attack surface and the potential for data exfiltration.
    - In the Azure Machine Learning workspace, if you're still using Azure Machine Learning CLI v1 and Azure Machine Learning Python SDK v1 (such as v1 API), add a private endpoint to the workspace to provide network isolation for everything except CRUD operations on the workspace or compute resources.
    - To take advantage of the new features of an Azure Machine Learning workspace, use Azure Machine Learning CLI v2 and Azure Machine Learning Python SDK v2 (such as v2 API), in which enabling a private endpoint on your workspace doesn't provide the same level of network isolation. However, the virtual network will still help protect the training data and machine learning models. We recommend you evaluate v2 API before adopting it in your enterprise solutions. See [What is the new API platform on Azure Resource Manager](/azure/machine-learning/how-to-configure-network-isolation-with-v2?tabs=python#what-is-the-new-api-platform-on-azure-resource-manager-arm) for more information.

- Data encryption

  - Encrypt training data in transit and at rest by using [platform-managed](/azure/security/fundamentals/key-management) or [customer-managed](/azure/storage/common/customer-managed-keys-overview) access keys.

- Policy and monitoring

  - Use [Azure Policy](https://azure.microsoft.com/products/azure-policy/) and Microsoft Defender for Cloud to enforce policies.
  - Use [Azure Monitor](https://azure.microsoft.com/services/monitor) to collect and aggregate data (such as metrics and logs) from various sources into a common data platform for analysis, visualization, and alerting.

The Azure Machine Learning workspace is the top-level resource for Azure Machine Learning and the core component of an MLOps solution. The workspace provides a centralized place to work with all the artifacts that you create when you use Azure Machine Learning.

When you create a new workspace, it automatically creates the following Azure resources that are used by the workspace:

- Azure Application Insights
- Azure Container Registry
- Azure Key Vault
- Azure Storage Account

### Potential use cases

This solution fits scenarios in which a customer uses an MLOps solution to deploy and maintain machine learning models in a more secure environment. Customers can come from various industries, such as manufacturing, telecommunications, retail, healthcare, and so on. For example:

  - A telecommunications carrier helps protect a customer's pictures, data, and machine learning models in its video monitoring system for retail stores. 

  - An engine manufacturer needs a more secure solution to help protect the data and machine learning models of its factories and products for its system that uses computer vision to detect defects in parts. 

The MLOps solutions for these scenarios and others might use Azure Machine Learning workspaces, Azure Blob Storage, Azure Kubernetes Service, Container Registry, and other Azure services.

You can use all or part of this example for any similar scenario that has an MLOps environment that's deployed on Azure and uses Azure security capabilities to help protect the relevant resources. The original customer for this solution is in the telecommunications industry.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that improve the quality of a workload when applied. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides more assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Consider how to help secure your MLOps solution beginning with the architecture design. Development environments might not need significant security, but it's important in the staging and production environments. 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Configuring Virtual Network is free of charge, but there are charges for the other services that your scenario might require, such as private links, DNS zones, and virtual network peering. The following table describes the charges for those services and others that might be required.

| Azure Service | Pricing |
|---------------|---------|
| Virtual Network | Free of charge. |
| Private Link    | Pay only for private endpoint resource hours and the data that is processed through your private endpoint. |
| Azure DNS, private zone | Billing is based on the number of DNS zones that are hosted in Azure and the number of DNS queries that are received. |
| Virtual Network peering | Inbound and outbound traffic is charged at both ends of the peered networks. |
| VPN gateway     | Charges are based on the amount of time that the gateway is provisioned and available. |
| ExpressRoute    | Charges are for ExpressRoute and ExpressRoute Gateways. |
| Azure Bastion   | Billing involves a combination of hourly pricing that is based on SKU, scale units, and data transfer rates. |


### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

To streamline continuous integration and continuous delivery (CI/CD), the best practice is to use tools and services for infrastructure as code (IaC), such as Terraform or Azure Resource Manager templates, Azure DevOps, and Azure Pipelines.

## Deploy this scenario

The following sections describe how to deploy, access, and help secure resources in this example scenario.

#### Virtual Network

The first step in helping to secure the MLOps environment is to help protect the Azure Machine Learning workspace and its associated resources. An effective method of protection is to use Virtual Network. Virtual Network is the fundamental building block for your private network in Azure. Virtual Network lets many types of Azure resources more securely communicate with each other, the internet, and on-premises networks.

Putting the Azure Machine Learning workspace and its associated resources into a virtual network helps ensure that components can communicate with each other without exposing them to the public internet. Doing so reduces their attack surface and helps to prevent data exfiltration.

The following Terraform snippet shows how to create a compute cluster for Azure Machine Learning, attach it to a workspace, and put it into a subnet of a virtual network.

```terraform
resource "azurerm_machine_learning_compute_cluster" "compute_cluster" {
  name                          = "my_compute_cluster"
  location                      = "eastasia"
  vm_priority                   = "LowPriority"
  vm_size                       = "Standard_NC6s_v3"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.my_workspace.id
  subnet_resource_id            = azurerm_subnet.compute_subnet.id
  ssh_public_access_enabled     = false
  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 3
    scale_down_nodes_after_idle_duration = "PT30S"
  }
  identity {
    type = "SystemAssigned"
  }
}
```

#### Private Link and Azure Private Endpoint

Private Link enables access over a private endpoint in your virtual network to Azure platform as a service (PaaS) options, such as an Azure Machine Learning workspace and Azure Storage, and to Azure-hosted customer-owned and partner-owned services. A private endpoint is a network interface that connects only to specific resources, thereby helping to protect against data exfiltration.

In this example scenario, there are four private endpoints that are tied to Azure PaaS options and are managed by a subnet in AML VNET, as shown in the [architecture diagram](#architecture). Therefore, these services are only accessible to the resources within the same virtual network, AML VNET. Those services are:

- Azure Machine Learning workspace
- Azure Blob Storage
- Azure Container Registry
- Azure Key Vault

The following Terraform snippet shows how to use a private endpoint to link to an Azure Machine Learning workspace, which is more protected by the virtual network as a result. The snippet also shows use of a private DNS zone, which is described in [Private DNS zones](#private-dns-zones).

```terraform
resource "azurerm_machine_learning_workspace" "aml_ws" {
  name                    = "my_aml_workspace"
  friendly_name           = "my_aml_workspace"
  location                = "eastasia"
  resource_group_name     = "my_resource_group"
  application_insights_id = azurerm_application_insights.my_ai.id
  key_vault_id            = azurerm_key_vault.my_kv.id
  storage_account_id      = azurerm_storage_account.my_sa.id
  container_registry_id   = azurerm_container_registry.my_acr_aml.id

  identity {
    type = "SystemAssigned"
  }
}

# Configure private DNS zones

resource "azurerm_private_dns_zone" "ws_zone_api" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.RESOURCE_GROUP
}

resource "azurerm_private_dns_zone" "ws_zone_notebooks" {
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = var.RESOURCE_GROUP
}

# Link DNS zones to the virtual network

resource "azurerm_private_dns_zone_virtual_network_link" "ws_zone_api_link" {
  name                  = "ws_zone_link_api"
  resource_group_name   = "my_resource_group"
  private_dns_zone_name = azurerm_private_dns_zone.ws_zone_api.name
  virtual_network_id    = azurerm_virtual_network.aml_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "ws_zone_notebooks_link" {
  name                  = "ws_zone_link_notebooks"
  resource_group_name   = "my_resource_group"
  private_dns_zone_name = azurerm_private_dns_zone.ws_zone_notebooks.name
  virtual_network_id    = azurerm_virtual_network.aml_vnet.id
}

# Configure private endpoints

resource "azurerm_private_endpoint" "ws_pe" {
  name                = "my_aml_ws_pe"
  location            = "eastasia"
  resource_group_name = "my_resource_group"
  subnet_id           = azurerm_subnet.my_subnet.id

  private_service_connection {
    name                           = "my_aml_ws_psc"
    private_connection_resource_id = azurerm_machine_learning_workspace.aml_ws.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-ws"
    private_dns_zone_ids = [azurerm_private_dns_zone.ws_zone_api.id, azurerm_private_dns_zone.ws_zone_notebooks.id]
  }

  # Add the private link after configuring the workspace
  depends_on = [azurerm_machine_learning_compute_instance.compute_instance, azurerm_machine_learning_compute_cluster.compute_cluster]
}
```

The preceding code for `azurerm_machine_learning_workspace` will use v2 API platform by default. If you still want to use the v1 API or have a company policy that prohibits sending communication over public networks, you can enable the _v1_legacy_mode_ parameter, as shown in the following code snippet. When enabled, this parameter disables the v2 API for your workspace.

```terraform
resource "azurerm_machine_learning_workspace" "aml_ws" {
  ...
  public_network_access_enabled = false
  v1_legacy_mode_enabled  = true
}
```

#### Private DNS zones

Azure DNS provides a reliable, more secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution. By using private DNS zones, you can use custom domain names rather than the names provided by Azure. DNS resolution against a private DNS zone works only from virtual networks that are linked to it.

This sample solution uses private endpoints for the Azure Machine Learning workspace and for its associated resources such as Azure Storage, Azure Key Vault, or Container Registry. Therefore, you must configure your DNS settings to resolve the IP addresses of the private endpoints from the fully qualified domain name (FQDN) of the connection string.

You can link a private DNS zone to a virtual network to resolve specific domains.

The Terraform snippet in [Private Link and Azure Private Endpoint](#private-link-and-azure-private-endpoint) creates two private DNS zones by using the zone names that are recommended in [Azure services DNS zone configuration](/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration):

- privatelink.api.azureml.ms
- privatelink.notebooks.azure.net

#### Virtual Network peering

Virtual network peering enables the access of the jump-host virtual machine (VM) or self-hosted agent VMs in BASTION VNET to the resources in AML VNET. For connectivity purposes, the two virtual networks work as one. The traffic between VMs and Azure Machine Learning resources in peered virtual networks uses the Azure backbone infrastructure. Traffic between the virtual networks is routed through Azure's private network.

The following Terraform snippet sets up virtual network peering between AML VNET and BASTION VNET.

```terraform
# Virtual network peering for AML VNET and BASTION VNET
resource "azurerm_virtual_network_peering" "vp_amlvnet_basvnet" {
  name                      = "vp_amlvnet_basvnet"
  resource_group_name       = "my_resource_group"
  virtual_network_name      = azurerm_virtual_network.amlvnet.name
  remote_virtual_network_id = azurerm_virtual_network.basvnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vp_basvnet_amlvnet" {
  name                      = "vp_basvnet_amlvnet"
  resource_group_name       = "my_resource_group"
  virtual_network_name      = azurerm_virtual_network.basvnet.name
  remote_virtual_network_id = azurerm_virtual_network.amlvnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
```

### Access the resources in the virtual network

To access the Azure Machine Learning workspace in a virtual network, like AML VNET in this scenario, use one of the following methods:

- Azure VPN gateway
- Azure ExpressRoute
- Azure Bastion and the jump host VM

For more information, see [Connect to the workspace](/azure/machine-learning/tutorial-create-secure-workspace#connect-to-the-workspace).

### Run Azure Pipelines that access the resources in the virtual network

Azure Pipelines automatically builds and tests code projects to make them available to others. Azure Pipelines combines CI/CD to test and build your code and ship it to any target.

#### Azure-hosted agents vs. self-hosted agents

The MLOps solution in this example scenario consists of two pipelines, which can trigger Azure Machine Learning pipelines and access associated resources. Since the Azure Machine Learning workspace and its associated resource are in a virtual network, this scenario must provide a way for an Azure Pipelines agent to access them. An agent is computing infrastructure with installed agent software that runs jobs of the Azure Pipelines one at a time. There are multiple ways to implement access:

- Use self-hosted agents in the same virtual network or the peering virtual network, as shown in the [architecture diagram](#architecture).

- Use Azure-hosted agents and add their IP address ranges to an allowlist in the firewall settings of the targeted Azure services.

- Use Azure-hosted agents (as VPN clients) and VPN Gateway.

Each of these choices has pros and cons. The following table compares Azure-hosted agents with self-hosted agents.

|                 | Azure-hosted Agent | Self-hosted Agent |
|-----------------|--------------------|-------------------|
| **Cost** | Start free for one parallel job with 1,800 minutes per month and a charge for each Azure-hosted CI/CD parallel job. | Start free for one parallel job with unlimited minutes per month and a charge for each extra self-hosted CI/CD parallel job with unlimited minutes. This option offers less-expensive parallel jobs. |
| **Maintenance** | Taken care of for you by Microsoft. | Maintained by you with more control over installing the software you like. |
| **Build Time** | More time consuming because it completely refreshes every time you start a build, and you always build from scratch. | Saves time because it keeps all your files and caches. |

> [!NOTE]
> For current pricing, see [Pricing for Azure DevOps](https://azure.microsoft.com/pricing/details/devops/azure-devops-services).

Based on the comparisons in the table and the considerations of security and complexity, this example scenario uses a self-hosted agent for Azure Pipelines to trigger Azure Machine Learning pipelines in the virtual network.

To configure a self-hosted agent, you have the following options:

- Install the agent on Azure Virtual Machines.

- Install the agents on an Azure Virtual Machine Scale Set, which can be auto-scaled to meet demand.

- Install the agent on a Docker container. This option isn't feasible, because this scenario might require running the Docker container within the agent for machine learning model training.

The following sample code provisions two self-hosted agents by creating Azure VMs and extensions:

```terraform
resource "azurerm_linux_virtual_machine" "agent" {
  ...
}

resource "azurerm_virtual_machine_extension" "update-vm" {
  count                = 2
  name                 = "update-vm${format("%02d", count.index)}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = element(azurerm_linux_virtual_machine.agent.*.id, count.index)

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("../scripts/terraform/agent_init.sh", {
          AGENT_USERNAME      = "${var.AGENT_USERNAME}",
          ADO_PAT             = "${var.ADO_PAT}",
          ADO_ORG_SERVICE_URL = "${var.ADO_ORG_SERVICE_URL}",
          AGENT_POOL          = "${var.AGENT_POOL}"
        }))}"
    }
SETTINGS
}
```

As shown in the preceding code block, the Terraform script calls *agent_init.sh*, shown in the following code block, to install agent software and required libraries on the agent VM per the customer's requirements.

```bash
#!/bin/sh
# Install other required libraries 
...

# Creates directory and downloads Azure DevOps agent installation files
sudo mkdir /myagent 
cd /myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/2.194.0/vsts-agent-linux-x64-2.194.0.tar.gz
sudo tar zxvf ./vsts-agent-linux-x64-2.194.0.tar.gz
sudo chmod -R 777 /myagent

# Unattended installation
sudo runuser -l ${AGENT_USERNAME} -c '/myagent/config.sh --unattended  --url ${ADO_ORG_SERVICE_URL} --auth pat --token ${ADO_PAT} --pool ${AGENT_POOL}'

cd /myagent
#Configure as a service
sudo ./svc.sh install ${AGENT_USERNAME}
#Start service
sudo ./svc.sh start
```

#### Use Container Registry in the virtual network

There are some prerequisites for securing an Azure Machine Learning workspace in a virtual network. For more information, see [Prerequisites](/azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe%2Ccli#prerequisites). Container Registry is a required service when you use an Azure Machine Learning workspace to train and deploy the models.

In this example scenario, to ensure the self-hosted agent can access the container registry in the virtual network, we use virtual network peering and add a virtual network link to link the private DNS zone, privatelink.azurecr.io, to BASTION VNET. The following Terraform snippet shows the implementation.

```terraform
# Azure Machine Learning Container Registry is for private access 
# by the Azure Machine Learning workspace
resource "azurerm_container_registry" "acr" {
  name                     = "my_acr"
  resource_group_name      = "my_resource_group"
  location                 = "eastasia"
  sku                      = "Premium"
  admin_enabled            = true
  public_network_access_enabled = false
}

resource "azurerm_private_dns_zone" "acr_zone" {
  name                     = "privatelink.azurecr.io"
  resource_group_name      = "my_resource_group"
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_zone_link" {
  name                  = "link_acr"
  resource_group_name   = "my_resource_group"
  private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name
  virtual_network_id    = azurerm_virtual_network.amlvnet.id
}

resource "azurerm_private_endpoint" "acr_ep" {
  name                = "acr_pe"
  resource_group_name = "my_resource_group"
  location            = "eastasia"
  subnet_id           = azurerm_subnet.aml_subnet.id

  private_service_connection {
    name                           = "acr_psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-app-acr"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_zone.id]
  }
}
```

This example scenario also ensures that the container registry has a contributor role for the system-assigned managed identity of the Azure Machine Learning workspace.

#### Use a compute cluster or instance in the virtual network

An Azure Machine Learning compute cluster or instance in a virtual network requires a network security group (NSG) with some specific rules for its subnet. For a list of those rules, see [Limitations](/azure/machine-learning/how-to-secure-training-vnet?tabs=azure-studio%2Cipaddress#limitations).

Also note that for the compute cluster or instance, it's now possible to remove the public IP address, which helps provide better protection for compute resources in the MLOps solution. For more information, see [No public IP for compute instances](/azure/machine-learning/how-to-secure-training-vnet?tabs=ipaddress&branch=main#no-public-ip).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Gary Wang](https://www.linkedin.com/in/gang-gary-wang) | Principal Software Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Terraform on Azure documentation](/azure/developer/terraform)
- [Azure Machine Learning Enterprise Terraform Example](https://github.com/csiebler/azure-machine-learning-terraform)
- [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2)
- [Azure Virtual Network pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-network/)
- [Pricing for Azure DevOps](https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services) 

## Related resources

- [Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](/azure/architecture/example-scenario/mlops/mlops-technical-paper)
- [Secure an Azure Machine Learning workspace with virtual networks](/azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe)
- [Azure Pipelines agents](/azure/devops/pipelines/agents/agents?tabs=browser&view=azure-devops)
