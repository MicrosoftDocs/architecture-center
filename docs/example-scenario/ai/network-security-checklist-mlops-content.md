**Network Security Checklist for MLOps Solutions**

After being first highlighted in a paper entitled "Hidden Technical Debt
in Machine Learning Systems" in 2015, Machine Learning DevOps (MLOps)\'s
been growing fast and its market is expected to reach \$4 billion by
2025. In the meantime, how to secure MLOps solutions is becoming more
and more important.

In this article, we\'ll talk about how to leverage Azure network
security capabilities such as Azure Virtual Network(VNet), Azure Private
Link, Azure Private DNS Zone, Azure VNet Peering to protect MLOps
solutions. After listing the choices of accessing resources in VNet,
we\'ll introduce how to use Azure Pipelines to access resources in the
VNet, required configurations of using an Azure Container Registry and
Azure Machine Learning compute instances/clusters in VNet environment as
well. Additionally, the description of the cost brought by the network
security services are also provided for your reference.

**About MLOps Security**

According to the [definition in
Wikipedia](https://en.wikipedia.org/wiki/MLOps), MLOps is a set of
practices at the intersection of Machine Learning, DevOps and Data
Engineering, aiming to deploy and maintain machine learning models in
production reliably and efficiently.

![Diagram, venn diagram Description automatically
generated](media/image1.png){width="6.5in"
height="4.6722222222222225in"}

*Figure 1. What is MLOps*

The diagram below shows a simplified MLOps process model, which offers a
solution that automates the process of machine learning data
preparation, model training, model evaluation, model registration, model
deployment and monitoring.

![Diagram Description automatically generated with medium
confidence](media/image2.png){width="6.5in"
height="1.3458333333333334in"}

*Figure 2. MLOps Process*

**How to Secure Your MLOps Environment**

When implementing a MLOps solution, you may have the challenges of
securing the following resources:

- Devops pipelines

- Machine learning training data

- Machine learning pipelines

- Machine learning models

In order to address the challenges above, you need to consider the
following aspects to protect the MLOps solution:

- Authentication and Authorization

  - Use Azure service principals or managed identities instead of
    interactive authentication

  - Use RBAC to define the user\'s access scope of the resources

- **Network Security**

  - Use Azure Virtual Network (VNet) to partially or fully isolate the
    environment from the public internet to reduce the attack surface
    and data exfiltration

- Data Encryption

  - Encrypt training data in transit and at rest, by using
    Microsoft-managed or customer-managed keys

- Policy and Monitoring

  - Use Azure Policy and the Azure Security Center to enforce policies

  - Use Azure Monitor to collect and aggregate data (metrics, logs) from
    variaty of sources into a common data platform where it can be used
    for analysis, visualization and alerting.

In this article, we\'ll be focusing on how to leverage Azure Network
Security mechanism to protect the MLOps environment.

## Architecture

![Diagram Description automatically
generated](media/image3.png){width="6.5in" height="4.292361111111111in"}

*Figure 3. System Architecture*

The diagram above shows the architecture of a sample MLOps solution. As
you can see, as the core of MLOps solution, Azure Machine Learning
workspace and its associated resources are protected by the virtual
network, AML VNET.

### Dataflow

The jump host, Azure Bastion and self-hosted agents are in another
virutual network, BASTION VNET which simulates another solution that
need to access the resources within AML VNET.

With the support of VNet peering and private DNS zones, Azure Pipelines
can be executed on self-host agents and trigger the Azure Machine
Learning pipelines published in Azure Machine Learning workspace to
train/evaluate/register the machine learning models.

Finally, the model will be deployed to online endpoints or batch
endpoints supported by Azure Machine Learning compute or Azure
Kubernetes Clusters.

This is how the Azure Pipelines and Azure Machine Learning pipelines
work in this MLOps solution.

### Components

The sample MLOps solution consists of the following components:

- Data storage: Azure Blob Storage

- Model training/validation/registration: Azure Machine Learning
  workspace

- Model deployment: Azure Kubernetes Service

- Model monitor: Azure Monitor/Application Insights

- MLOps pipelines: Azure DevOps, Azure Pipelines

Besides the components listed above, we still need to leverage more
network security services to protect the MLOps solution.

### Potential Use Cases

- The original customer for this solution is in telecommunications
  industry.

- This solution fits for the scenarios that the customer wants to use a
  MLOps solution to deploy and maintain machine learning models reliably
  and efficiently and there is a need to secure the resources in the
  MLOps environment, in various industries such as manufacturing,
  telecommunications, retail, healthcare etc. For example:

  - A telco carrier wants to protect the customer's pictures, data and
    machine learning models in its 'Retail Store Video Monitoring
    System' supported by a MLOps solution based on Azure Machine
    Learning workspace, Azure blob storage, azure kubernetes service and
    Azure container registry etc

  - An engine manufacture needs a secured solution to protect the data
    and machine learning models of its factories and products in the
    MLOps solution which is the backbone for its 'Computer Vision Part
    Defect Detection'. The MLOps solution is based on Azure Machine
    Learning workspace, Azure blob storage, azure kubernetes service and
    Azure container registry etc.

```{=html}
<!-- -->
```
- It can be fully or partially reused for any similar scenario as the
  MLOps environment is deployed on Azure, being allowed to leverage
  Azure network security capabilities to protect the MLOps relevant
  resources.

**Secure Azure Machine Learning Workspace and Its Associated Resources**

As the core component of a MLOps solution, the Azure Machine Learning
workspace is the top-level resource for Azure Machine Learning that
provides a centralized place to work with all the artifacts you create
when you use Azure Machine Learning.

When you create a new workspace, it automatically creates the following
Azure resources that are used by the workspace:

- Azure Application Insights

- Azure Container Registry

- Azure Key Vault

- Azure Storage Account

The first step of securing the MLOps environment is to protect Azure
Machine Learning workspace and its associated resources. One of the
effective ways of achieving this is to use Azure Virtual Network.

**Azure Virtual Network**

Azure Virtual Network (VNet) is the fundamental building block for your
private network in Azure. VNet enables many types of Azure resources,
such as Azure Virtual Machines (VM), to securely communicate with each
other, the internet, and on-premises networks.

By putting Azure Machine Learning workspace and its associated resources
into a VNet, we can ensure that each components are able to communicate
with each other without exposing them in the public internet. In this
way, we can significantly reduce our MLOps solution\' attack surface and
data exfiltration.

The following Terraform snippet shows how to create an AML compute
cluster, attach it to an AML workspace and put it into a subnet of a
virtual network.

resource \"azurerm_machine_learning_compute_cluster\"
\"compute_cluster\" {

name = \"my_compute_cluster\"

location = \"eastasia\"

vm_priority = \"LowPriority\"

vm_size = \"Standard_NC6s_v3\"

machine_learning_workspace_id =
azurerm_machine_learning_workspace.my_workspace.id

subnet_resource_id = azurerm_subnet.compute_subnet.id

ssh_public_access_enabled = false

scale_settings {

min_node_count = 0

max_node_count = 3

scale_down_nodes_after_idle_duration = \"PT30S\"

}

identity {

type = \"SystemAssigned\"

}

}

**Azure Private Link and Azure Private Endpoint**

Azure Private Link enables you to access Azure PaaS Services (for
example, Azure Machine Learning Workspace, Azure Storage etc.) and Azure
hosted customer-owned/partner services over a private endpoint in your
virtual network. A private endpoint is a network interface which only
tied to the specific chosen Azure resources thereby protecting data
exfiltration.

In Figure 3, there are four private endpoints tied to the correspoinding
Azure PaaS services (Azure Machine Learning workspace, Azure Blob
Storage, Azure Container Registry and Azure Key Vault) that are managed
by a subnet in AML VNET. Therefore, these Azure PaaS services are only
accessbile to the resources within the same virtual network, i.e. AML
VNET.

The following Terraform script sippet shows how to use priate endpoint
to link to an Azure Machine Learning workspace thus it can be protected
by the virtual network. About the usage of the priate DNS zones, you may
refer to the next section for the details.

resource \"azurerm_machine_learning_workspace\" \"aml_ws\" {

name = \"my_aml_workspace\"

friendly_name = \"my_aml_workspace\"

location = \"eastasia\"

resource_group_name = \"my_resource_group\"

application_insights_id = azurerm_application_insights.my_ai.id

key_vault_id = azurerm_key_vault.my_kv.id

storage_account_id = azurerm_storage_account.my_sa.id

container_registry_id = azurerm_container_registry.my_acr_aml.id

identity {

type = \"SystemAssigned\"

}

}

\# Private DNS Zones

resource \"azurerm_private_dns_zone\" \"ws_zone_api\" {

name = \"privatelink.api.azureml.ms\"

resource_group_name = var.RESOURCE_GROUP

}

resource \"azurerm_private_dns_zone\" \"ws_zone_notebooks\" {

name = \"privatelink.notebooks.azure.net\"

resource_group_name = var.RESOURCE_GROUP

}

\# Linking of DNS zones to Virtual Network

resource \"azurerm_private_dns_zone_virtual_network_link\"
\"ws_zone_api_link\" {

name = \"ws_zone_link_api\"

resource_group_name = \"my_resource_group\"

private_dns_zone_name = azurerm_private_dns_zone.ws_zone_api.name

virtual_network_id = azurerm_virtual_network.aml_vnet.id

}

resource \"azurerm_private_dns_zone_virtual_network_link\"
\"ws_zone_notebooks_link\" {

name = \"ws_zone_link_notebooks\"

resource_group_name = \"my_resource_group\"

private_dns_zone_name = azurerm_private_dns_zone.ws_zone_notebooks.name

virtual_network_id = azurerm_virtual_network.aml_vnet.id

}

\# Private Endpoint configuration

resource \"azurerm_private_endpoint\" \"ws_pe\" {

name = \"my_aml_ws_pe\"

location = \"eastasia\"

resource_group_name = \"my_resource_group\"

subnet_id = azurerm_subnet.my_subnet.id

private_service_connection {

name = \"my_aml_ws_psc\"

private_connection_resource_id =
azurerm_machine_learning_workspace.aml_ws.id

subresource_names = \[\"amlworkspace\"\]

is_manual_connection = false

}

private_dns_zone_group {

name = \"private-dns-zone-group-ws\"

private_dns_zone_ids = \[azurerm_private_dns_zone.ws_zone_api.id,
azurerm_private_dns_zone.ws_zone_notebooks.id\]

}

\# Add Private Link after we configured the workspace

depends_on =
\[azurerm_machine_learning_compute_instance.compute_instance,
azurerm_machine_learning_compute_cluster.compute_cluster\]

}

**Private Azure DNS Zone**

In the sample solution, the private endpoints are used for not only
Azure Machine Learning workspace, but also its associated resources such
as Azure Storage, Azure Key Vault, or Azure Container Registry. For this
reason, you must correctly configure your DNS settings to resolve the
private endpoint IP address to the fully qualified domain name (FQDN) of
the connection string.

You can use Azure private DNS zones to override the DNS resolution for a
private endpoint. A private DNS zone can be linked to your virtual
network to resolve specific domains.

Azure Private DNS provides a reliable, secure DNS service to manage and
resolve domain names in a virtual network without the need to add a
custom DNS solution. By using private DNS zones, you can use your own
custom domain names rather than the Azure-provided names available
today. Please note that the DNS resolution against a private DNS zone
works only from virtual networks that are linked to it.

As you can see in the Terraform script snippet above, we created two
private DNS zones by using the [recommended zone names for Azure
services](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration):

- privatelink.api.azureml.ms

- privatelink.notebooks.azure.net

**Azure Virtual Network Peering**

In Figure 3, in order to enable the jump host VM or self-hosted agent
VMs ( in BASTION VNET)\'s access to the resources in AML VNET, we use
virtual network peering to seamlessly connect these two virtual
networks. Thus the two virtual networks appear as one for connectivity
purposes. The traffic between VMs and Azure Machine Learning resources
in peered virtual networks uses the Microsoft backbone infrastructure.
Like traffic between them in the same network, traffic is routed through
Microsoft\'s private network only.

The following Terraform script sets up the VNet peering between AML VNET
and BASTION VNET.

\# Virtual network peering for amlvnet and basvnet

resource \"azurerm_virtual_network_peering\" \"vp_amlvnet_basvnet\" {

name = \"vp_amlvnet_basvnet\"

resource_group_name = \"my_resource_group\"

virtual_network_name = azurerm_virtual_network.amlvnet.name

remote_virtual_network_id = azurerm_virtual_network.basvnet.id

allow_virtual_network_access = true

allow_forwarded_traffic = true

}

resource \"azurerm_virtual_network_peering\" \"vp_basvnet_amlvnet\" {

name = \"vp_basvnet_amlvnet\"

resource_group_name = \"my_resource_group\"

virtual_network_name = azurerm_virtual_network.basvnet.name

remote_virtual_network_id = azurerm_virtual_network.amlvnet.id

allow_virtual_network_access = true

allow_forwarded_traffic = true

}

**Access the Resources in the VNet**

As Azure Machine Learning workspace\'s been put into AML VNET, how could
data scientists or data engineers access it? You can do it in the
following ways:

- Azure VPN gateway

- ExpressRoute

- Azure Bastion and the jump host virtual machine

For the details, please refer to [How to create a secure
workspace](https://docs.microsoft.com/en-us/azure/machine-learning/tutorial-create-secure-workspace#connect-to-the-workspace).

**Run Azure Pipelines Which Access the Resources in VNet**

Azure Pipelines automatically builds and tests code projects to make
them available to others. Azure Pipelines combines continuous
integration (CI) and continuous delivery (CD) to test and build your
code and ship it to any target.

**Microsoft-hosted Agents vs Self-hosted Agents**

As metioned in the previous section, the MLOps solution consists of a
couple of Azure Pipelines which can trigger Azure Machine Learning
pipelines and access associated resources. Since the Azure Machine
Learning workspace and its associated resource are behind a VNet, we
need to figure out a way for a Azure Pipeline Agent(the computing
infrastructure with installed agent software that runs one job of the
Azure Pipeline at a time) to access them. There are a couple of ways to
implement it:

- Use self-hosted agents in the same VNet or the peering VNet(as shown
  in Figure 3.)

- Use Microsoft-hosted agents and whitelist its IP ranges in the
  firewall settings of target Azure services

- Use Microsoft-hosted agents (as VPN clients) and Azure VPN Gateway

Each of the choices above has its pros and cons. First, let\'s compare
Microsoft-hosted agents with self-hosted agents in the following
perspectives:

|             | Microsoft-hosted Agent                                                                                           | Self-hosted Agent                                                                                                                                                                                      |
|-------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cost \*     | Start free for 1 parallel job with 1,800 minutes per month, \$40 per extra Microsoft-hosted CI/CD parallel job   | Start free for 1 parallel job with unlimited minutes per month, \$15 per extra self-hosted CI/CD parallel job with unlimited minutes (offering a cheaper solution when adding parallel jobs is needed) |
| Maintenance | Taken care of for you by Microsoft                                                                               | Maintained by yourself with more control of installing any software you like                                                                                                                           |
| Build Time  | More time consuming because it completely freshes every time you start a build and you always build from scratch | More time saving as it keeps all your files and caches                                                                                                                                                 |

\*The prices are as of Aug 19, 2022, for all regions. Please refer to
<https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services/>
.

Based on the comparison above, plus the considerartion of security and
complexity, we choose to use a self-hosted agent for the Azure Pipeline
to trigger AML pipelines in the VNet. To set up a self-hosted agent, we
have the following options:

- To install the agent on Azure Virtual Machines

- To install the agents on Azure Virtual Machine scale set that can be
  auto-scaled to meet the customer\'s demands

- To install the agent on Docker container. This is not feasible as we
  may need run Docker container within the agent for machine learning
  model training.

Here\'s the sample code for provisioning two self-hosted agents by
creating Azure virtual machines and extensions:

resource \"azurerm_linux_virtual_machine\" \"agent\" {

\...

}

resource \"azurerm_virtual_machine_extension\" \"update-vm\" {

count = 2

name = \"update-vm\${format(\"%02d\", count.index)}\"

publisher = \"Microsoft.Azure.Extensions\"

type = \"CustomScript\"

type_handler_version = \"2.1\"

virtual_machine_id = element(azurerm_linux_virtual_machine.agent.\*.id,
count.index)

settings = \<\<SETTINGS

{

\"script\":
\"\${base64encode(templatefile(\"../scripts/terraform/agent_init.sh\", {

AGENT_USERNAME = \"\${var.AGENT_USERNAME}\",

ADO_PAT = \"\${var.ADO_PAT}\",

ADO_ORG_SERVICE_URL = \"\${var.ADO_ORG_SERVICE_URL}\",

AGENT_POOL = \"\${var.AGENT_POOL}\"

}))}\"

}

SETTINGS

}

As shown in the code above, the Terraform script calls agent_init.sh to
install agent software and needed libraries on the agent VM per the
customer\'s requirements. The shell script looks like the following:

\#!/bin/sh

\# Install other needed libraries

\...

\# Creates directory & download ADO agent install files

sudo mkdir /myagent

cd /myagent

sudo wget
https://vstsagentpackage.azureedge.net/agent/2.194.0/vsts-agent-linux-x64-2.194.0.tar.gz

sudo tar zxvf ./vsts-agent-linux-x64-2.194.0.tar.gz

sudo chmod -R 777 /myagent

\# Unattended install

sudo runuser -l \${AGENT_USERNAME} -c \'/myagent/config.sh \--unattended
\--url \${ADO_ORG_SERVICE_URL} \--auth pat \--token \${ADO_PAT} \--pool
\${AGENT_POOL}\'

cd /myagent

\#Configure as a service

sudo ./svc.sh install \${AGENT_USERNAME}

\#Start svc

sudo ./svc.sh start

**Use Azure Container Registry in VNet**

Azure Container Registry is a required service when you use Azure
Machine Learing workspace to train and deploy the models. While securing
the Azure Machine Learning workspace with virtual networks, please note
that there are some [prerequisites about Azure Container
Registry](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe%2Ccli#prerequisites).

In the sample solution, to ensure the self-hosted agent can access the
Azure Container Registry in the VNet, you need to use VNet peering, and
add virtual network link to link the private DNS zone
(privatelink.azurecr.io) to BASTION VNET. Refer to the Terraform script
snippet below for the implementation:

\# AML ACR is for private access by AML WS

resource \"azurerm_container_registry\" \"acr\" {

name = \"my_acr\"

resource_group_name = \"my_resource_group\"

location = \"eastasia\"

sku = \"Premium\"

admin_enabled = true

public_network_access_enabled = false

}

resource \"azurerm_private_dns_zone\" \"acr_zone\" {

name = \"privatelink.azurecr.io\"

resource_group_name = \"my_resource_group\"

}

resource \"azurerm_private_dns_zone_virtual_network_link\"
\"acr_zone_link\" {

name = \"link_acr\"

resource_group_name = \"my_resource_group\"

private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name

virtual_network_id = azurerm_virtual_network.amlvnet.id

}

resource \"azurerm_private_endpoint\" \"acr_ep\" {

name = \"acr_pe\"

resource_group_name = \"my_resource_group\"

location = \"eastasia\"

subnet_id = azurerm_subnet.aml_subnet.id

private_service_connection {

name = \"acr_psc\"

private_connection_resource_id = azurerm_container_registry.acr.id

subresource_names = \[\"registry\"\]

is_manual_connection = false

}

private_dns_zone_group {

name = \"private-dns-zone-group-app-acr\"

private_dns_zone_ids = \[azurerm_private_dns_zone.acr_zone.id\]

}

}

In the meantime, you should ensure that the Azure Container Registry has
a contributor role for the system assigned managed identity of Azure
Machine Learning workspace.

**Use Compute Cluster/Instance in VNet**

When putting a Azure Machine Learning compute cluster/instance into a
VNet, you need to create network security group (NSG) with some specific
rules for its subnet. You may refer to [limitations of Azure Machine
Learning compute
cluster/instance](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-secure-training-vnet?tabs=azure-studio%2Cipaddress#limitations)
for the detailed information.

Please also note that for the compute cluster or instance, it is now
possible to remove the public IP address (a preview feature). This
provides better protection of your compute resources in the MLOps
solution.

## Considerations

### Security

MLOps solution security should be considered in the very beginning of
the architecture design. When developing a solution, even though you can
think less about security in the development environment, still it is
highly recommended you should take security into consideration in the
staging and production environments. 

### Operational excellence

The best practice is to use infrastructure as code tools such as
Terraform or Azure ARM templates, and Azure DevOps, Azure Pipeline to
streamline the CI/CD processes.

### Cost optimization

Will leveraging Azure network security capabilities add more cost to
your solution? Let\'s take a look at them one by one:

| Azure Service                | Pricing                                                                                             |
|------------------------------|-----------------------------------------------------------------------------------------------------|
| Azure Virtual Network        | Free of charge                                                                                      |
| Azure Private Link           | Pay only for private endpoint resource hours and the data processed through your private endpoint   |
| Azure Private Azure DNS Zone | Billing is based on the number of DNS zones hosted in Azure and the number of DNS queries received  |
| Azure VNet Peering           | Inbound and outbound traffic is charged at both ends of the peered networks                         |
| Azure VPN gateway            | Charged based on the amount of time that gateway is provisioned and available                       |
| Azure ExpressRoute           | Charged for Azure ExpressRoute and ExpressRoute Gateways                                            |
| Azure Bastion                | Billing involves a combination of hourly pricing based on SKU, scale units, and data transfer rates |

Therefore, even though setting up Azure Virtual Networks is free of
charge, you still need to pay for private links, DNS zones, VNet peering
and other services if they are needed to protect your solution.

## Next steps

Refer to [Terraform on Azure
documentation](https://docs.microsoft.com/en-us/azure/developer/terraform/)
and code snippets in this article to build your network security
solution for MLOps.

## Related resources

- [Machine learning operations (MLOps) framework to upscale machine
  learning lifecycle with Azure Machine
  Learning](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/mlops/mlops-technical-paper)

- [Secure an Azure Machine Learning workspace with virtual
  networks](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe)

- [Azure Machine Learning Enterprise Terraform
  Example](https://github.com/csiebler/azure-machine-learning-terraform)

- [Azure Virtual Network
  Pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-network/)

- [Azure Pipelines
  agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser)

- [Azure DevOps
  Pricing](https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services) 
