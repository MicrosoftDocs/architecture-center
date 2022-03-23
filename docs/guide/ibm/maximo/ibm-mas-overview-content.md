## Introduction to IBM Maximo Application Suite

The Maximo Application Suite (MAS) is an Enterprise Asset Management platform focused on operational resiliency and reliability that leverages condition-based asset maintenance. The suite has several core components:

- Manage - Reduce downtime and costs through asset management to improve operational performance.
- Monitor - Advanced AI-powered remote asset monitoring at scale.
- Health - Manage the health of assets using IoT data from sensors, asset data and maintenance history.
- Visual Inspection - Inspection of assets using mobile devices that focuses on identification of emerging issues.
- Predict - Machine learning and data analytics focused on predicting future failures.
- Mobile - Capability to integrate the various asset and facility management solutions.

The following components have been tested on Azure:

- MAS Core
- Manage
- Monitor

This guide provides general information for running MAS on Azure and assumes you will have support from an IBM Partner for installation. MAS 8.x runs on OpenShift and it is beneficial to familiarize yourself with the suggested patterns for [Preparing to install on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html). For this guide, we will be focusing on the IPI pattern.

> [!NOTE]
> Air gapped patterns have not been tested but would require using the [User Provided Infrastructure (UPI)](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md) as a starting point.

## Architecture

:::image type="complex" source="./../images/ibm-azure-guide-architecture-diagram.png" alt-text="Architecture diagram showing how to deploy IBM Maximo Application Suite on Azure." border="false":::
   The diagram contains a large rectangle with the label Azure Virtual Network. Inside it, another large rectangle.
:::image-end:::

The IPI install pattern along with a `install-config.yaml` file will produce the above architecture minus the following:

- Domain Name with DNS Zone
- BYO Virtual Network (Optional)
- Premium Storage (NFS) with a Private Endpoint
- Standard Storage (SMB) with a Private Endpoint
- JumpBox (used for access / installation)
- SQL Server (Optional)
- Virtual Network Gateway and other services outside of the Virtual Network

> [!NOTE]
> Example of a install-config-yaml file can be found in the official [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo) under the path `/src/ocp/install-config.yaml`

## Prerequisites

1. Access to an Azure Subscription with User Access Administrator privileges
1. Application Registration (SPN) that has Contributor and User Access Administrator privileges
1. Domain or delegated Sub Domain to a Azure DNS Zone
1. RedHat OpenShift Service Agreement (Pull Secret and other keys)
1. IBM MAS Entitlement Key
1. IBM MAS License File
1. Determine if you will provide an existing VNet or let the IPI create one
1. Determine what your HA/DR requirements are

For a step-by-step guide for installing OpenShift or MAS on Azure, pleas see our official [QuickStart Guide](https://github.com/Azure/maximo) on GitHub.

## Design recommendations

At this time, MAS 8.7 supports OpenShift versions 4.8. It is recommended to use these version to avoid falling out of the official support for either IBM MAS or RedHat OpenShift. Before, building out your own deployment, we strongly recommend trying out our [QuickStart Guide](https://github.com/Azure/maximo) so that you have a clear understanding of how the deployment and configuration occurs. This will most likely speed up the process of building design requirements for your implementation.

We work closely with IBM and other Partners to ensure the guidance found in this document will give you the best experience on Azure. Please do not hesitate to reach out to your Account Team for support beyond this documentation.

## Sizing recommendations

Recommended sizing should be done by your IBM Team based on your existing installation or planned size. Once this is complete, you can calculate the number of control and worker nodes you will need for your cluster. Generally, we recommend using the following:

### Dsv4 Series

- Control nodes, you will want at minimum 1 Node per Availability Zone within the selected region. In our diagram above, we suggest 3 - D8s_v4 nodes.
- Worker nodes, you will want a minimum of 2 Nodes per Availability Zone within the selected region. In our diagram above, we suggest 6 - D8s_v4 nodes.

> [!NOTE]
> Sizing for the worker nodes will vary based on which MAS services are deployed and the expected load on your environment.

If you will be provisioning a JumpBox to do your installation, you should be able to get by with a `Standard_B2ms` running RHEL 8.4.

## Network and placement considerations

If OpenShift is being deployed to support a MAS installation then considerations will most likely want to look at considerations for OpenShift as well since MAS runs inside of OpenShift making Azure specific considerations less applicable. If there is already an existing support strategy in place for OpenShift then you can skip over the specific OpenShift considerations and focus on MAS.

### OpenShift

Considerations:

- **Region Selection** - Inside the OpenShift platform, it attempts to load balance workloads across all available nodes. When configuring the IPI for deployment, it will attempt to provision nodes across zones, when possible. In the event of a zone outage, OpenShift can still function by having other nodes (control and worker) running in another zone (Assuming those nodes have enough room to schedule the pods). List of [Availability Zones](/azure/availability-zones/az-overview#azure-regions-with-availability-zones).
- **Backup & Recover** - Although ARO is not currently supported by MAS, you can review our [guidance](/azure/openshift/howto-create-a-backup) for our Managed OpenShift (ARO) offering.
- **Failover** - Consider deploying OpenShift into 2 region and leveraging [RedHat's Advanced Cluster Management platform](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can either place Azure Front Door or Azure Traffic Manager in front of them to redirect traffic to the appropriate cluster in the event of an outage. In this situation, you would need to migrate your applications state and persistent volumes as well.

### MAS

Considerations:

- **External Dependencies** - If MAS takes dependencies on any external services (databases; kafka brokers...etc) this should be a performance consideration in case the OpenShift cluster is deployed within another region. Consider reviewing that services HA/DR options as well.
- **Backup and Restore** - For state based services running inside of the OpenShift cluster, it is necessary to frequently perform backups and move them into another region.
- **State** - For services that retain state, when possible, leverage external Azure PaaS offerings to improve upon the supportability in the event of an outage.

## Data sources

## Deployment

## Security

### Identity management

### Protect your infrastructure

## Contributors

<!-- > (Expected, but this section is optional if the principal authors would prefer to not include it)

> Start with the explanation text (same for every article), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Pricipal authors" list and the "Additional contributors" list (if there are additional contributors). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). 
> Implement this format: -->

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._
<!-- 
**Principal authors:** > Only the primary authors. List them alphabetically, by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s). -->

 * [David Baumgarten](https://www.linkedin.com/in/baumgarten-david/) | Senior Cloud Solution Architect
 * [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis/) | Principal Cloud Solution Architect
 
<!-- * > Continue for each primary author (even if there are 10 of them). -->

<!-- 
**Additional contributors:** > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. List them alphabetically, by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 * [Contributor 1 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"]
 * [Contributor 2 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"] -->

## Next steps

For help getting started, see the following resources:

- Bulleted list of third-party and other Docs and Microsoft links.
- Links shouldn't include en-us locale unless they don't work without it.
- Docs links should be site-relative, for example (/azure/feature/article-name).
- Don't include trailing slash in any links.

## Related resources

- OpenShift
- Related Azure Architecture Center articles.
- Links should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).