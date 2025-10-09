# Baseline MongoDB Atlas Reference Architecture in an Azure Landing Zone

## Overview

This document describes a MongoDB Atlas reference architecture designed for deployment in an Azure landing zone environment. The architecture provides secure, private connectivity between Azure resources and MongoDB Atlas clusters while following Azure landing zone principles for resource organization and governance.

The solution demonstrates how to deploy MongoDB Atlas in an enterprise Azure environment with proper network segmentation, private connectivity, and infrastructure automation.

> [!IMPORTANT]
> **What are Azure landing zones?**
>
> Azure landing zones divide your organization's cloud footprint into two key areas:
>
> - An application landing zone is an Azure subscription where a workload runs. An application landing zone connects to your organization's shared platform resources. That connection provides the landing zone with access to the infrastructure that supports the workload, such as networking, identity access management, policies, and monitoring.
>
> - A platform landing zone is a collection of various subscriptions that multiple platform teams can manage. Each subscription has a specific function. For example, a connectivity subscription provides centralized Domain Name System (DNS) resolution, cross-premises connectivity, and network virtual appliances (NVAs) for platform teams.
>
> To help you implement this architecture, understand [Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/), their [design principles](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles), and their [design areas](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

---

## Architecture

This landing zone accelerator supports two deployment patterns based on your requirements:

### Single-Region Architecture

The single-region deployment provides a straightforward MongoDB Atlas setup within a single Azure region, ideal for applications with regional data residency requirements or simpler connectivity needs.

> **Architecture Basis:**
> This deployment follows the [Single-Region Deployment Paradigm](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/single-region/) from MongoDB Atlas. All cluster nodes are placed within a single region, leveraging cloud provider availability zones for added resilience. This is the most cost-effective option and is suitable when the risk of a regional failure is acceptable.

#### Single-Region Architecture Diagram

![Single-region Atlas on Azure reference architecture](../_images/mongodb-atlas-single-region.png)

### Multi-Region Architecture

The multi-region deployment provides enhanced availability and disaster recovery capabilities with MongoDB Atlas clusters distributed across multiple Azure regions, connected via VNet peering.

> **Architecture Basis:**
> This deployment is based on the [5-Node, 3-Region Architecture (2+2+1)](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/multi-region/#5-node--3-region-architecture--2-2-1-) recommended by MongoDB Atlas. It ensures near-instant recovery in case of a regional outage, with nodes distributed across three regions (2+2+1) for automated failover and data loss protection during maintenance or full regional incidents.

#### Multi-Region Architecture Diagram

![Multi-region Atlas on Azure reference architecture](../_images/mongodb-atlas-multi-region.png)

### Components

#### MongoDB Atlas (External Service)

**Single-Region Configuration:**

- **Atlas Project and Cluster**: MongoDB cluster deployed in a single Azure region
- **Private Link Endpoint**: One private endpoint in the target region
- **Database Configuration**: Replica set with configurable sizing (M10+)
- **Backup and Recovery**: Automated backup with configurable retention

**Multi-Region Configuration:**

- **Atlas Project and Cluster**: MongoDB cluster with nodes distributed across multiple Azure regions
- **Private Link Endpoints**: Multiple private endpoints, one per Azure region
- **Database Configuration**: Cross-region replica set for high availability
- **Backup and Recovery**: Cross-region backup and disaster recovery capabilities

#### Azure Base Infrastructure

**Single-Region Deployment:**

- **Virtual Network**: Single VNet in primary region
- **Private Subnet**: One private subnet for MongoDB Atlas connectivity
- **Private Endpoints**: Single private endpoint for MongoDB Atlas
- **NAT Gateway**: Outbound internet connectivity for the private subnet
- **Network Security Groups**: Traffic segmentation and security controls
- **Private DNS Zone**: DNS resolution for MongoDB Atlas private endpoints
- **Application Insights**: Centralized monitoring and diagnostics for metrics collected from MongoDB Atlas.
- **Storage Account & Container**: Secure storage for Function App code and logs.
- **Service Plan**: Linux Flex Consumption plan for hosting the Function App.
- **Function App (Flex Consumption)**: Hosts the metrics collection function (code must be deployed separately).
- **Private DNS Zones & Links**: Ensures secure, private connectivity for monitoring and storage endpoints.
- **Azure Monitor Private Link Scope & Scoped Service**: Enables private connectivity for Application Insights.
- **Private Endpoint**: Secure private access to Application Insights.

**Multi-Region Deployment:**

- **Primary Virtual Network**: VNet in primary region
- **Secondary Virtual Network**: VNet in secondary region
- **VNet Peering**: Cross-region connectivity between virtual networks
- **Private Subnets**: One private subnet per region for MongoDB Atlas connectivity
- **Private Endpoints**: Multiple private endpoints, one per region
- **NAT Gateways**: Outbound connectivity in each region
- **Network Security Groups**: Consistent security controls across regions
- **Private DNS Zones**: Cross-region DNS resolution for MongoDB Atlas
- **Application Insights**: Centralized monitoring and diagnostics for metrics collected from MongoDB Atlas.
- **Storage Account & Container**: Secure storage for Function App code and logs.
- **Service Plan**: Linux Flex Consumption plan for hosting the Function App.
- **Function App (Flex Consumption)**: Hosts the metrics collection function (code must be deployed separately).
- **Private DNS Zones & Links**: Ensures secure, private connectivity for monitoring and storage endpoints.
- **Azure Monitor Private Link Scope & Scoped Service**: Enables private connectivity for Application Insights.
- **Private Endpoint**: Secure private access to Application Insights.

#### Infrastructure Automation

- **Terraform Modules**: Modular infrastructure as code
- **GitHub Actions**: CI/CD pipeline integration (optional)

---

## Networking

### Network Design Overview

The MongoDB Atlas Azure Landing Zone supports both single-region and multi-region network topologies, each optimized for different availability and performance requirements.

#### Single-Region Network Topology

**Design Pattern**: All resources deployed within a single Azure region for simplicity and optimal performance.

**Key Components**:

- **Virtual Network**: Single VNet with dedicated address space
- **Private Subnet**: Hosts private endpoint for MongoDB Atlas connectivity  
- **NAT Gateway**: Provides secure outbound internet access
- **Private Endpoint**: Azure Private Link connection to MongoDB Atlas
- **Network Security Groups**: Control traffic flow with least-privilege rules

**Benefits**:

- Simplified management and configuration
- Lowest latency for regional applications
- Cost-effective for single-region deployments

**Limitations**:

- No protection against regional outages
- Suited for localized applications

#### Multi-Region Network Topology

**Design Pattern**: Resources distributed across multiple Azure regions with VNet peering for cross-region connectivity.

**Key Components**:

- **Regional VNets**: Separate VNets per region with non-overlapping CIDR ranges
- **VNet Peering**: Cross-region connectivity between virtual networks
- **Regional Private Endpoints**: Private Link connections in each region
- **Regional NAT Gateways**: Outbound connectivity per region
- **NSG Rules**: Unified security policies across regions

**Benefits**:

- High availability with regional redundancy
- Disaster recovery capabilities
- Global application support

**Limitations**:

- Higher operational complexity
- Increased costs for multi-region resources

### Implementation Guidance

**Planning Considerations**:

- **Address Space**: Use non-overlapping CIDR blocks across regions
- **Private Connectivity**: Leverage Azure Private Link for secure MongoDB Atlas access
- **Security**: Implement least-privilege NSG rules
- **Performance**: Size networks and Atlas clusters for peak load

---

## Security

### Network Security

- **Private Endpoints**: No public internet access to MongoDB Atlas
- **Network Segmentation**: Separate subnets for different functions
- **Controlled Egress**: NAT Gateway for outbound connectivity
- **NSG Rules**: Least-privilege network access

### Identity and Access

- **MongoDB Atlas RBAC**: Database-level access controls
- **Network-based Security**: Private Link for connectivity
- **Azure RBAC**: Role-based access control for Azure resources

---

## Operational Considerations

### Backup and Recovery

- **MongoDB Atlas Backup**: Automated, configurable backup policies
- **Point-in-time Recovery**: Granular recovery options
- **Cross-region Replication**: For multi-region deployments

### Cost Optimization

- **Right-sizing**: MongoDB cluster sizing based on actual usage
- **Reserved Capacity**: For predictable workloads
- **Azure Cost Management**: Monitor and optimize Azure resource costs

---

## Implementation Modules

The solution includes the following Terraform modules for base infrastructure:

**Single-Region Modules:**

- **Network Module**: VNet, private subnet, NAT Gateway, NSGs for single region
- **Atlas Single-Region Configuration**: MongoDB cluster and Private Link setup for single region
- **Observability**: Application Insights, Storage Account & Container, Service Plan, Function App, Private DNS Zones & Links, Azure Monitor Private Link Scope & Scoped Service, Private Endpoint

**Multi-Region Modules:**

- **Network Module**: VNet, private subnet, NAT Gateway, NSGs (deployed per region)
- **Atlas Multi-Region Configuration**: MongoDB cluster and Private Link setup across multiple regions
- **VNet Peering Module**: Cross-region connectivity between virtual networks
- **Observability**: Application Insights, Storage Account & Container, Service Plan, Function App, Private DNS Zones & Links, Azure Monitor Private Link Scope & Scoped Service, Private Endpoint

---

## Metrics & Observability

### Architecture Overview

The solution provisions Azure-native observability resources for monitoring, logging, and metrics collection for MongoDB Atlas and supporting infrastructure.

#### Key Components

- **Application Insights**: Receives metrics from the Function App and provides dashboards, analytics, and alerting.
- **Function App**: Runs on a schedule, queries the MongoDB Atlas API for metrics, and pushes results to Application Insights.
- **Service Plan**: Hosts the Function App.
- **Storage Account & Container**: Stores the Function App code package and logs securely.
- **Private DNS Zones**: Provide private DNS resolution for Azure monitoring and storage endpoints.
- **Private Endpoints**: Secure connectivity for Application Insights, Storage Account, and monitoring resources.
- **Subnets for Observability**: Created in the VNet of the target region. Used for Function App and Private Endpoint placement.

#### Metrics Collection Flow

1. **Function App Execution**: The Function App runs on a schedule (e.g., every 5 minutes) using a timer trigger.
2. **Atlas API Query**: The function authenticates to the MongoDB Atlas API and retrieves cluster metrics (e.g., CPU, memory, connections, disk usage).
3. **Metrics Push**: Retrieved metrics are sent to Application Insights for visualization, alerting, and long-term analysis.
4. **Secure Storage**: Function code and logs are stored in a dedicated Storage Account, accessible only via private endpoints.
5. **Monitoring & Alerting**: Application Insights provides dashboards, query capabilities, and alerting for operational health and performance.

#### Benefits

- Centralized monitoring and alerting for all Atlas clusters and supporting infrastructure
- Secure, private data flow for all observability traffic
- Automated, scheduled metrics collection and visualization
- Scalable and cost-effective monitoring architecture

---

## Related Resources

- [MongoDB Atlas Azure Landing Zone Accelerator Repository](https://github.com/mongodb-partners/Azure-MongoDB-Atlas-Landing-Zone)
- [Azure Landing Zone Design Areas](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-areas)
- [MongoDB Atlas Private Endpoints](https://www.mongodb.com/docs/atlas/security-private-endpoint/)
- [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/)

---

## Next Steps

[Deploy a reference implementation](https://github.com/mongodb-partners/Azure-MongoDB-Atlas-Landing-Zone)