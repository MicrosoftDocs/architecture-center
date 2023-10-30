This article describes a baseline architecture for running Financial Service Industry (FSI) workloads on Azure using Azure Batch.

## Architecture![Architecture Diagram](images/architecture.png)_Download a [Visio file](https://arch-center.azureedge.net/architecture.vsdx) that contains this architecture diagram

### Workflow

**TODO:**
> An alternate title for this sub-section is "Workflow" (if data isn't really involved), so feel free to change.
> Add callouts to the diagram above, by placing numbers next to each major step/flow
> Include an ordered list (see example below), that annotates/describes the dataflow or workflow through the solution. Explain what each step does. Start from the user or external data source, and then follow the flow through the rest of the solution (as shown in the diagram).

The following workflow (or dataflow) corresponds to the above diagram:

1. Admin 1 adds, updates, or deletes an entry in Admin 1's fork of the Microsoft 365 config file.
1. Admin 1 commits and syncs the changes to Admin 1's forked repository.
1. Admin 1 creates a pull request (PR) to merge the changes to the main repository.
1. The build pipeline runs on the PR.
1. Etc.

### Components

##### Hub Resources

Let's start by looking at the resources deployed on the hub network. These are shared resources that enable / filter / monitor
communication between the spoke network and the outside world. 

The resources deployed on the hub network are as follows:

* [Azure Firewall](https://azure.microsoft.com/services/azure-firewall): provides network-level protection for the network. The firewall is configured
  to allow only specific traffic in and out of the network. This helps protect the network from malicious attacks and monitor traffic in and out of the network.
  The rules are expected to be updated based on the business specific rules and regulations.

* [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway): provides ability to connect to the hub network from the public internet. This provides
  one of two ways for the users on the public internet to connect to the hub network. The other way is to use Azure Bastion service. The VPN gateway is
  assigned a public IP address so that VPN clients can connect to it from the public internet.

* [Azure Bastion](https://azure.microsoft.com/services/azure-bastion): provides ability to connect to the jumpboxes from the public internet. This provides
  one of two ways for the users on the public internet to connect to the jumpboxes. The other way is to use VPN gateway. Azure Bastion is deployed on the
  hub network and is assigned a public IP address so that users can connect to it from the public internet.

* [Linux Jumpbox](https://azure.microsoft.com/services/virtual-machines): a Linux VM with preinstalled tools to access the resources deployed, submit jobs, and
  monitor their progress. The jumpbox is deployed on the hub network and can be accessed from the on-premises network using the VPN gateway or Azure Bastion.

* [Windows Jumpbox](https://azure.microsoft.com/services/virtual-machines): a Windows VM with preinstalled tools to access the resources deployed, submit jobs, and
  monitor their progress. The jumpbox is deployed on the hub network and can be accessed from the on-premises network using the VPN gateway or Azure Bastion.

* [Log Analytics Workspace](https://azure.microsoft.com/services/log-analytics): provides ability to collect logs. Whenever possible, resources deployed are configured
  to save logs to the workspace. The logs are used to monitor the resources and troubleshoot issues. When combined with
  [Azure Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview?tabs=net), it provides
  performance monitoring and troubleshooting capabilities for the resources deployed.

* [Azure DNS Private Resolver](https://learn.microsoft.com/azure/dns/dns-private-resolver-overview): provides an inbound endpoint to resolve IPs of private endpoints if queried outside of the provisioned virtual network, e.g. from on-prem resources. Will be deployed if the Azure VPN Gateway is deployed.

##### Spoke Resources

Let's now look at the resources deployed on the spoke network. These are the resources intended for executing the computation workloads and all supporting resources.

The resources deployed on the spoke network are as follows:

* [Azure Batch](https://azure.microsoft.com/services/batch): the core service that our architecture relies on for
  cloud-native job scheduling and execution. Azure Batch manages the compute resources required, schedules the tasks on
  the compute resources, and monitors the tasks for completion. The Batch service is deployed with two pools: a pool
  named linux with linux compute nodes and a pool named windows with windows compute nodes. The pools are configured to:

  * Use User Subscription pool allocation mode. This ensures that all resources used internally by the Batch service are
    allocated under the same subscription as the Batch account and hence use the subscription specific quotas and policies.
  * Use the corresponding subnets on the spoke network, thus they get assigned address space from the subnet's address range.
    It also means that all network security group (NSG) rules and traffic forwarding rules setup on those subnets are applied to the compute nodes as well.
  * Not assign public IP addresses to the compute nodes. This ensures that the compute nodes are not accessible from the
    public internet directly.
  * Make it easier for workloads executing on compute notes to access shared storage resources, by mounting the supported
    storage resources on the compute nodes during initialization.
  * Use a user-assigned managed identity to authenticate the compute nodes with storage account, container registry,
    and any other resources as they join the Batch pool. This ensures that the compute nodes are authenticated using
    certificates instead of passwords or keys.

* [Azure Key Vault](https://azure.microsoft.com/services/key-vault): stores deployment secrets such as Batch account certificates. These certificates are used
  to authenticate compute node resources as they join the Batch pool. The Key Vault is deployed on the spoke network and is configured to allow access
  only from the Batch service. This ensures that the certificates are not accessible from the public internet.

* [Azure Storage](https://azure.microsoft.com/services/storage): stores input and output data. The deployment creates two storage accounts
  one for blob storage and one for file storage. The blob storage account is mounted on Linux pool using NFS. The file storage account is mounted
  on both Linux and Windows pool using SMB.

* [Azure Container Registry](https://azure.microsoft.com/services/container-registry): stores container images used by the Batch compute nodes. Using
  a private deployment of the container registry helps control access to container images and also provides a more secure way to store container images.
  The container registry is deployed on the spoke network and is configured to allow access only from the Batch service. This ensures that the container
  images are not accessible from the public internet.

* [Azure Managed Identity](https://learn.microsoft.com/azure/batch/managed-identity-pools): used to authenticate the compute nodes
  added to pools automatically with container registry, storage accounts, and other resources.

## Scenario details

A common computing pattern in FSI is to run a large number of compute-intensive simulations on an input dataset
that characterizes a financial instrument or a portfolio of financial instruments. The simulations are typically run in
parallel and the results are aggregated to produce a summary of the portfolio's risk profile. 

This architecture is not focused on a particular workload, rather it focuses on applications that want to use Azure Batch
to run compute-intensive simulations. Any production deployment architecture will need to be customized to meet the specific
requirements of the workload and business environment. This architecture is intended to be used as to be a starting point
for such customizations for pre-production and production deployments.

### Network Topology

This architecture uses a hub-and-spoke network topology. The hub and spoke resources are deployed in separate virtual networks
that are connected through virtual network peering. The hub network contains shared resources such as firewalls, vpn gateways,
and jumpboxes. The spoke network contains the Batch service, Batch compute nodes and other service endpoints needed
by the workload e.g. storage accounts, container registry, etc. The spoke network is isolated from the public internet and
can only be accessed from the hub network. 

The highlights of the network topology are as follows:

* Resources on spoke are isolated from the public internet and can only be accessed from the hub network. This minimizes direct
  exposure of the resources to the public internet.
* All outgoing traffic, including that from the pool compute nodes is routed through a Firewall. This ensures that all
  outgoing traffic is filtered, logged and tracked.
* The Firewall is configured to allow only whitelisted traffic. This ensures that only the whitelisted traffic is allowed
  to go out of the virtual network.
* Access to resources on the spoke network is enabled through optionally deployed VPN gateway or Azure Bastion.
  Both provide secure ways to connect to the hub network from the public internet.
* Windows and Linux jumpboxes are provided with preinstalled tools to access the resources deployed, submit jobs, and monitor
  their progress. These jumpboxes are deployed on the hub network and can be accessed from the on-premises network using the
  VPN gateway or Azure Bastion.
* All Azure services use private endpoints to ensure that they are accessed over private network instead of accessing
  them through public endpoints. This also helps us to ensure that the services are not accessible from the public internet.
* NSG rules are setup to allow only the required traffic in and out of the virtual network. This helps protect the
  network from malicious attacks and monitor traffic in and out of the network. These rules even restrict the traffic
  between the resources in the virtual network.

##### Hub Virtual Network

The hub virtual network contains resources that allow or monitor traffic in and out of the spoke network. The virtual network
defines following subnets in the deployment template:

1. `GatewaySubnet`: subnet for the VPN gateway, if deployed.
1. `AzureBastionSubnet`: subnet for the Azure Bastion service, if deployed.
1. `AzureFirewallSubnet`: subnet for the Azure Firewall service.
1. `sn-jumpbox`: subnet for the jumpboxes.
1. `sn-dnspr`: subnet delegated to Azure DNS resolver.

##### Spoke Virtual Network

The spoke virtual network contains the Batch service, Batch compute nodes and other service endpoints needed by the workload.
The virtual network defines following subnets:

1. `pool-linux`: subnet for the linux pool.
1. `pool-windows`: subnet for the windows pool.
1. `private-endpoints`: subnet used for private endpoints for Azure services deployed on the spoke network.

The spoke is peered with the hub network. This allows the resources on the spoke network to access the resources on the hub
network. Route tables are setup to ensure that the traffic between the spoke is routed through the Firewall.
  
### Accessing the resources

To submit computation jobs to the Batch service, one needs to connect with the Batch service endpoint to submit jobs and monitor their progress. Since the Batch service is setup to use private endpoints, it can only be accessed from within the network.
The architecture provides two options for the user to connect to the network to be able to submit jobs to the Batch service:

1. **Use VPN Gateway**. The user can connect to the hub network using a VPN Gateway. Once connected to the VPN, the user can submit
   jobs to the Batch service from the local machine directly. This also makes it easier to monitor jobs using Batch Explorer
   installed on the local machine. This will require that the Azure CLI, Batch Explorer and other tools are installed on
   the local machine. Alternatively, once connected to the VPN, the user can use the Linux and/or Windows Jumpboxes to submit
   jobs to the Batch service. This will require that the user has a SSH client and/or RDP client installed on the local machine.

1. **Use Azure Bastion**. Instead of using VPN, the user can use Azure Bastion to log on to the Linux and/or Windows Jumpboxes.
   The user logs on to the Azure portal and then uses Azure Bastion to log on to the jumpbox VM directly from the
   web browser. Once logged on to the jumpbox, the user can submit jobs to the Batch service using the Azure CLI, Batch Explorer
   and other tools installed on the jumpbox.

### Alternatives

* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service). AKS can be used instead
  of Azure Batch service for a similar configuration for containerized applications.

* [Azure CycleCloud](/azure/cyclecloud). Azure CycleCloud can be used to manage
 HPC clusters on Azure. Such HPC clusters can be setup to run workloads similar to the ones targeted by this article.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

**TODO:** Complete any additional lead-in text for this main section, plus the "Cost optimization" section and at least 2 of the remaining 4 subsections, and remove all template comments/questions.

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

The infrastructure-as-code (IaC) source-code for this reference architecture is available in the 
[Azure Batch accelerator repository](https://github.com/Azure/bacc). The included tutorials demonstrate how to deploy this reference
architecture and how to use it to run a sample FSI workload, named `azfinsim`. You can also use the following button
to deploy the resources under your subscription using Azure Portal.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fbacc%2Fmain%2Ftemplates%2Fsecured-batch_deploy.json)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Utkarsh Ayachit](https://www.linkedin.com/in/utkarsh-ayachit/) | Principal Program Manager
* [Darko Mocelj](https://www.linkedin.com/in/darko-mocelj/) | EMEA HPC & AI Sr. Technology Specialist

## Next steps

* [What is Azure Batch?](/azure/batch/batch-technical-overview)
* [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
* [Azure Storage accounts](/azure/storage/common/storage-account-overview)
* [Data processing with Batch and Data Factory](/azure/data-factory/transform-data-using-custom-activity)

Learn modules

* [Design an Azure compute solution](/training/modules/design-compute-solution)

## Related resources

* [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
