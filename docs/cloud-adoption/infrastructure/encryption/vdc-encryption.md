---
title: "Fusion: Azure Virtual Datacenter - Encryption" 
description: Discusses how encryption is used to secure data and resources in an Azure Virtual Datacenter.
author: rotycen
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Encryption and key management

The Azure Virtual Datacenter model assumes all data in transit and at rest are encrypted as a security baseline. Encryption isolates confidential information from the rest of the public cloud environment, including the underlying platform.

## Data in transit

The Azure Virtual Datacenter model uses encryption to enforce isolation of data as it moves between:

- On-premises networks and the virtual datacenter. Data passes through either an encrypted site-to-site virtual private network (VPN) connection or an isolated, private ExpressRoute.
- Applications or services running in a different virtual DataCenter (that is, from one virtual DataCenter to another).
- Applications or services running in the same Azure virtual datacenter.
- PaaS resources, including both internal and external endpoints—storage accounts, databases, and management APIs.

You should always use SSL/TLS protocols to exchange data between the VDC hub, workload components, and the on-premises environment. This ensures that all network traffic has some degree of encryption applied at all times. You should also encrypt all communication between the components that make up the VDC shared services within the hub.

## Data at rest

The default VDC security approach also assumes data at rest encryption. This includes having encryption enabled for all the following:

- Data stored on virtual machine OS and data disks.
- Data in SQL Database or other PaaS database services.
- Data stored in Azure Storage or any other PaaS storage service, including snapshots, images, dumps and logs.
- Data stored in Service Bus.

## Azure Key Vault

Azure Key Vault is the primary mechanism for managing encryption within a VDC. Keys stored in Key Vault can be used to encrypt storage assets, secure PaaS services, or individual applications. Authorized applications and services within a VDC can use but not modify keys stored in key vault, while only key owners can make those changes through Key Vault.

In-line with the design and access model of a VDC, separate key vault instances are deployed in the hub and each of the spokes. The hub key vault is managed by the central SecOps role and stores secrets, keys, and certificates for use with hub resources and other centrally managed encryptions purposes. Control of spoke key vaults is delegated to the individual DevOps teams responsible for the spoke workload. 


## Next steps

Learn  how [monitoring and reporting](../logs-and-reporting/vdc-monitoring.md) are used to maximize policy compliance of workloads and resources host in an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Monitoring, Reporting, and Compliance](../logs-and-reporting/vdc-monitoring.md)

