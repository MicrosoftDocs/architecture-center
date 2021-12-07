---
title: Storage Accounts and security
description: Focuses on the Storage Accounts service used in the Storage solution to provide best-practice, configuration recommendations, and design considerations related to Security.
author: v-stacywray
ms.date: 11/30/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - storage-accounts
categories:
  - storage
  - management-and-governance
---

# Storage Accounts and security

[Azure Storage Accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json) are ideal for workloads that require fast and consistent response times, or that have a high number of input output (IOP) operations per second. Storage accounts contain all your Azure Storage data objects, which include:

- Blobs
- File shares
- Queues
- Tables
- Disks

Storage accounts provide a unique namespace for your data that's accessible anywhere over `HTTP` or `HTTPS`.

For more information about the different types of storage accounts that support different features, reference [Types of storage accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json#types-of-storage-accounts).

To understand how an Azure storage account boosts security for your application workload, reference the following articles:

- [Azure security baseline for Azure Storage](/security/benchmark/azure/baselines/storage-security-baseline?toc=%2fazure%2fstorage%2fblobs%2ftoc.json?toc=/azure/storage/blobs/TOC.json)
- [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption?toc=/azure/storage/blobs/toc.json)
- [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints?toc=/azure/storage/blobs/toc.json)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure storage accounts and security.

## Design considerations

Azure storage accounts include the following design considerations:

- Storage account names must be between three and 24 characters and may contain numbers, and lowercase letters only.
- For current SLA specifications, reference [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/).
- Go to [Azure Storage redundancy](/azure/storage/common/storage-redundancy) to determine which redundancy option is best for a specific scenario.
- Storage account names must be unique within Azure. No two storage accounts can have the same name.

## Checklist

**Have you configured your Azure Storage Account with security in mind?**

> [!div class="checklist"]
> - Enable Azure Defender for all your storage accounts.
> - Turn on soft delete for blob data.
> - Use Azure AD to authorize access to blob data.
> - Consider the principle of least privilege when you assign permissions to an Azure AD security principal through Azure RBAC.
> - Use managed identities to access blob and queue data.
> - Use blob versioning or immutable blobs to store business-critical data.
> - Restrict default internet access for storage accounts.
> - Enable firewall rules.
> - Limit network access to specific networks.
> - Allow trusted Microsoft services to access the storage account.
> - Enable the **Secure transfer required** option on all your storage accounts.
> - Limit shared access signature (SAS) tokens to `HTTPS` connections only.
> - Avoid and prevent using Shared Key authorization to access storage accounts.
> - Regenerate your account keys periodically.
> - Create a revocation plan and have it in place for any SAS that you issue to clients.
> - Use near-term expiration times on an impromptu SAS, service SAS, or account SAS.

## Configuration recommendations

Consider the following recommendations to optimize security when configuring your Azure Storage Account:

|Recommendation|Description|
|--------------|-----------|
|Enable Azure Defender for all your storage accounts.|Azure Defender for Azure Storage provides an extra layer of security intelligence that detects unusual and potentially harmful attempts to access or exploit storage accounts. Security alerts are triggered in Azure Security Center when anomalies in activity occur. Alerts are also sent through email to subscription administrators, with details of suspicious activity and recommendations on how to investigate, and remediate threats. For more information, reference [Configure Azure Defender for Azure Storage](/azure/storage/common/azure-defender-storage-configure?tabs=azure-security-center).|
|Turn on soft delete for blob data.|[Soft delete for Azure Storage blobs](/azure/storage/blobs/soft-delete-blob-overview) enables you to recover blob data after it has been deleted.|
|Use Azure AD to authorize access to blob data.|Azure AD provides superior security and ease of use over Shared Key for authorizing requests to blob storage. It's recommended to use Azure AD authorization with your blob and queue applications when possible to minimize potential security vulnerabilities inherent in Shared Key. For more information, reference [Authorize access to Azure blobs and queues using Azure Active Directory](/azure/storage/blobs/authorize-access-azure-active-directory).|
|Consider the principle of least privilege when you assign permissions to an Azure AD security principal through Azure RBAC.|When assigning a role to a user, group, or application, grant that security principal only those permissions necessary for them to complete their tasks. Limiting access to resources helps prevent both unintentional and malicious misuse of your data.|
|Use managed identities to access blob and queue data.|Azure Blob and Queue storage support Azure AD authentication with managed identities for Azure resources. Managed identities for Azure resources can authorize access to blob and queue data using Azure AD credentials from applications running in Azure virtual machines (VMs), function apps, virtual machine scale sets, and other services. By using managed identities for Azure resources together with Azure AD authentication, you can avoid storing credentials with your applications that run in the cloud and issues with expiring service principals. Reference [Authorize access to blob and queue data with managed identities for Azure resources](/azure/storage/blobs/authorize-managed-identity) for more information.|
|Use blob versioning or immutable blobs to store business-critical data.|Consider using [Blob versioning](/azure/storage/blobs/versioning-overview) to maintain previous versions of an object or the use of legal holds and time-based retention policies to store blob data in a WORM (Write Once, Read Many) state. Immutable blobs can be read, but can't be modified or deleted during the retention interval. For more information, reference [Store business-critical blob data with immutable storage](/azure/storage/blobs/immutable-storage-overview).|
|Restrict default internet access for storage accounts.|By default, network access to Storage Accounts isn't restricted and is open to all traffic coming from the internet. Access to storage accounts should be granted to specific [Azure Virtual Networks](/azure/storage/common/storage-network-security?tabs=azure-portal) only whenever possible or use [private endpoints](/azure/private-link/private-endpoint-overview) to allow clients on a virtual network (VNet) to access data securely over a [Private Link](/azure/private-link/private-link-overview). Reference [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints) for more information. Exceptions can be made for Storage Accounts that need to be accessible over the internet.|
|Enable firewall rules.|Configure firewall rules to limit access to your storage account to requests that originate from specified IP addresses or ranges, or from a list of subnets in an Azure Virtual Network (VNet). For more information about configuring firewall rules, reference [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).|
|Limit network access to specific networks.|[Limiting network access](/azure/storage/common/storage-network-security?tabs=azure-portal) to networks hosting clients requiring access reduces the exposure of your resources to network attacks either by using the built-in Firewall and virtual networks functionality or by using [private endpoints](/azure/storage/common/storage-private-endpoints).|
|Allow trusted Microsoft services to access the storage account.|Turning on firewall rules for storage accounts blocks incoming requests for data by default, unless the requests originate from a service operating within an Azure Virtual Network (VNet) or from allowed public IP addresses. Blocked requests include those requests from other Azure services, from the Azure portal, from logging and metrics services, and so on. You can permit requests from other Azure services by adding an exception to allow trusted Microsoft services to access the storage account. For more information about adding an exception for trusted Microsoft services, reference [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).|
|Enable the **Secure transfer required** option on all your storage accounts.|When you enable the **Secure transfer required** option, all requests made against the storage account must take place over secure connections. Any requests made over HTTP will fail. For more information, reference [Require secure transfer in Azure Storage](/azure/storage/common/storage-require-secure-transfer).|
|Limit shared access signature (SAS) tokens to `HTTPS` connections only.|Requiring `HTTPS` when a client uses a SAS token to access blob data helps to minimize the risk of eavesdropping. For more information, reference [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview).|
|Avoid and prevent using Shared Key authorization to access storage accounts.|It's recommended to use Azure AD to authorize requests to Azure Storage and to [prevent Shared Key Authorization](/azure/storage/common/shared-key-authorization-prevent?tabs=portal). For scenarios that require Shared Key authorization, always prefer SAS tokens over distributing the Shared Key.|
|Regenerate your account keys periodically.|Rotating the account keys periodically reduces the risk of exposing your data to malicious actors.|
|Create a revocation plan and have it in place for any SAS that you issue to clients.|If a SAS is compromised, you'll want to revoke that SAS immediately. To revoke a user delegation SAS, revoke the user delegation key to quickly invalidate all signatures associated with that key. To revoke a service SAS that's associated with a stored access policy, you can delete the stored access policy, rename the policy, or change its expiry time to a time that is in the past.|
|Use near-term expiration times on an impromptu SAS, service SAS, or account SAS.|If a SAS is compromised, it's valid only for a short time. This practice is especially important if you can't reference a stored access policy. Near-term expiration times also limit the amount of data that can be written to a blob by limiting the time available to upload to it. Clients should renew the SAS well before the expiration to allow time for retries if the service providing the SAS is unavailable.|

## Next step

> [!div class="nextstepaction"]
> [Storage Accounts and cost optimization](cost-optimization.md)
