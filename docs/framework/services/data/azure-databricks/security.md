---
title: Azure Databricks and security
description: Focuses on the Azure Databricks service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Security.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-databricks
categories:
  - data
  - management-and-governance
---

# Azure Databricks and security

[Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is a data analytics platform optimized for Azure cloud services. It offers three environments for developing data intensive applications:

- [Databricks SQL](/azure/databricks/scenarios/what-is-azure-databricks-sqla)
- [Databricks Data Science and Engineering](/azure/databricks/scenarios/what-is-azure-databricks-ws)
- [Databricks Machine Learning](/azure/databricks/scenarios/what-is-azure-databricks-ml)

To learn more about how Azure Databricks improves the security of big data analytics, reference [Azure Databricks concepts](/azure/databricks/getting-started/concepts).

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Databricks.

## Design considerations

All users' notebooks and notebook results are encrypted at rest, by default. If other requirements are in place, consider using [customer-managed keys for notebooks](/azure/databricks/security/keys/customer-managed-key-managed-services-azure).

## Checklist

**Have you configured Azure Databricks with security in mind?**
***

> [!div class="checklist"]
> - Use Azure Active Directory [credential passthrough](/azure/databricks/security/credential-passthrough/adls-passthrough) to avoid the need for service principals when communicating with Azure Data Lake Storage.
> - Isolate your workspaces, compute, and data from public access. Make sure that only the right people have access and only through secure channels.
> - Ensure that the cloud workspaces for your analytics are only accessible by properly [managed users](/azure/databricks/administration-guide/users-groups/).
> - Implement Azure Private Link.
> - Restrict and monitor your virtual machines.
> - Use Dynamic IP access lists to allow admins to access workspaces only from their corporate networks.
> - Use the [VNet injection](/azure/databricks/administration-guide/cloud-configurations/azure/vnet-inject) functionality to enable more secure scenarios.
> - Use [diagnostic logs](/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs) to audit workspace access and permissions.
> - Consider using the [Secure cluster connectivity](/azure/databricks/security/secure-cluster-connectivity) feature and [hub/spoke architecture](https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html) to prevent opening ports, and assigning public IP addresses on cluster nodes.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Databricks configuration for security:

|Recommendation|Description|
|--------------|-----------|
|Ensure that the cloud workspaces for your analytics are only accessible by properly [managed users](/azure/databricks/administration-guide/users-groups/).|Azure Active Directory can handle single sign-on for remote access. For extra security, reference [Conditional Access](/azure/databricks/administration-guide/access-control/conditional-access).|
|Implement Azure Private Link.|Ensure all traffic between users of your platform, the notebooks, and the compute clusters that process queries are encrypted and transmitted over the cloud provider's network backbone, inaccessible to the outside world.|
|Restrict and monitor your virtual machines.|Clusters, which execute queries, should have SSH and network access restricted to prevent installation of arbitrary packages. Clusters should use only images that are periodically scanned for vulnerabilities.|
|Use the [VNet injection](/azure/databricks/administration-guide/cloud-configurations/azure/vnet-inject) functionality to enable more secure scenarios.|Such as: <br>- Connecting to other Azure services using service endpoints. <br>- Connecting to on-premises data sources, taking advantage of user-defined routes. <br>- Connecting to a network virtual appliance to inspect all outbound traffic and take actions according to allow and deny rules. <br>- Using custom DNS. <br>-  Deploying Azure Databricks clusters in existing virtual networks.|
|Use [diagnostic logs](/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs) to audit workspace access and permissions.|Use audit logs to see privileged activity in a workspace, cluster resizing, files, and folders shared on the cluster.|

## Source artifacts

Azure Databricks source artifacts include the Databricks blog: [Best practices to secure an enterprise-scale data platform](https://databricks.com/blog/2020/03/16/security-that-unblocks.html).

## Next step

> [!div class="nextstepaction"]
> [Azure Database for MySQL and cost optimization](../azure-db-mysql/cost-optimization.md)
