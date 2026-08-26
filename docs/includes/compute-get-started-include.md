### Compute guides

**Technology choices:** The following articles help you evaluate and select the best compute technologies for your workload requirements:

- [Choose a compute service](../guide/technology-choices/compute-decision-tree.md): Use a decision tree to help you choose the right compute option.
- [Shared access signatures (SAS) on Azure architecture](../guide/sas/sas-overview.yml): Get guidance about running SAS analytics on Azure.
- [Build workloads by using Azure Spot Virtual Machines](../guide/spot/spot-eviction.yml): Learn how to design workloads that take advantage of spare Azure capacity at reduced cost.
- [HPC on Azure](../guide/compute/high-performance-computing.md): Learn about HPC capabilities and architectures on Azure.

### Compute architectures

The following production-ready architectures demonstrate comprehensive compute solutions that you can deploy and customize:

- [Azure Virtual Machines baseline architecture](../virtual-machines/baseline.yml): See a foundational reference architecture for workloads deployed on Virtual Machines.
- [Virtual Machines baseline architecture in an Azure landing zone](../virtual-machines/baseline-landing-zone.yml): Deploy VM workloads in an Azure landing zone context.
- [Siemens Teamcenter baseline architecture](../example-scenario/manufacturing/teamcenter-baseline.yml): Deploy a Siemens Teamcenter product life cycle management (PLM) solution on Azure.
- [Teamcenter with Azure NetApp Files](../example-scenario/manufacturing/teamcenter-plm-netapp-files.yml): Use Azure NetApp Files as a storage solution for Siemens Teamcenter PLM.
- [Multiregion load balancing](../high-availability/traffic-manager-application-gateway.yml): Learn how to load balance traffic across multiple Azure regions.
- [Multitier web application built for high availability and disaster recovery (HA/DR)](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml): Deploy a multitier application that has HA/DR.
- [Deploy IBM Maximo Application Suite (MAS)](../example-scenario/apps/deploy-ibm-maximo-application-suite.yml): Run IBM MAS enterprise asset management on Azure.
- [Manage virtual machine compliance](../example-scenario/security/virtual-machine-compliance.yml): Manage VM compliance without disrupting DevOps practices by using Azure VM Image Builder and Azure Compute Gallery.
#### Quantum computing solutions

- [Quantum computing integration with classical apps](../example-scenario/quantum/quantum-computing-integration-with-classical-apps.yml): Learn how to integrate quantum work with classical applications by using direct quantum integration or workflow-orchestrated quantum integration patterns.

- [Run a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml): Learn about best practices for running a Linux VM on Azure.
- [Run a Windows VM on Azure](../reference-architectures/n-tier/windows-vm.yml): Learn about best practices for running a Windows VM on Azure.

#### Mainframe

- [AIX UNIX to Azure Linux migration](../example-scenario/unix-migration/migrate-aix-azure-linux.yml): Migrate IBM AIX workloads to Azure Linux.
- [Batch transaction processing](../example-scenario/mainframe/process-batch-transactions.yml): Use Azure Kubernetes Service (AKS) and Azure Service Bus to implement high-volume batch transaction processing.
- [Extend mainframes to digital channels by using standards-based REST APIs](../example-scenario/mainframe/extend-mainframes-rest-apis.yml): Extend mainframe applications to Azure without disruptions or modifications to existing applications.
- [General mainframe refactor to Azure](../example-scenario/mainframe/general-mainframe-refactor.yml): Modernize mainframe applications by using Azure services.
- [IBM z/OS migration with Avanade AMT](../example-scenario/mainframe/avanade-amt-zos-migration.yml): Use the Avanade Automated Migration Technology (AMT) framework to migrate IBM z/OS mainframe workloads to Azure.
- [Migrate AIX workloads with Skytap](../example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap.yml): Migrate AIX logical partitions (LPARs) to Skytap on Azure.
- [Migrate IBM i series to Azure with Skytap](../example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap.yml): Use native IBM i backup and recovery services with Azure components.
- [Refactor Adabas & Natural systems](../example-scenario/mainframe/refactor-adabas-aks.yml): Modernize mainframe computer systems that run Adabas & Natural and move them to the cloud.
- [Refactor mainframe with Raincode](../reference-architectures/app-modernization/raincode-reference-architecture.yml): See how the Raincode COBOL compiler modernizes mainframe legacy applications.
- [Rehost Adabas & Natural applications](../example-scenario/mainframe/rehost-adabas-software-ag.yml): Migrate a Software AG Adabas and Natural mainframe system to Azure by using a rehost approach with minimal changes to your existing workload.
- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml): Use virtualization technologies from Microsoft partner Unisys with an existing Unisys ClearPath Forward (CPF) Dorado enterprise server.
- [Unisys ClearPath MCP virtualization on Azure](../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml): Apply Unisys virtualization technologies to migrate a legacy Unisys ClearPath Forward Libra mainframe to Azure.

### SAP

SAP workloads have specific architecture requirements. See the following resources for SAP on Azure.

#### SAP guides

- [SAP landscape architecture](../guide/sap/sap-whole-landscape.md): Review guidance about SAP landscapes on Azure.
- [Inbound and outbound internet connections for SAP on Azure](../guide/sap/sap-internet-inbound-outbound.md): See a network architecture for SAP internet connectivity.

#### SAP architectures

- [SAP BW/4HANA in Linux on Azure](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml): Deploy an SAP BW/4HANA data warehouse on Azure Linux VMs.
- [SAP deployment by using an Oracle database](../example-scenario/apps/sap-production.yml): Run SAP production workloads by using an Oracle database on Azure.
- [SAP HANA scale-up systems on Linux](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml): Scale up SAP HANA deployments on Azure Linux VMs.
- [SAP NetWeaver in Windows on Azure](../guide/sap/sap-netweaver.md): Deploy SAP NetWeaver on Windows VMs.
- [SAP S/4HANA in Linux on Azure](../guide/sap/sap-s4hana.md): Run SAP S/4HANA on Azure Linux VMs.

### Compute solution ideas

- [IBM z/OS online transaction processing](../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml): Migrate a z/OS online transaction processing (OLTP) workload to an Azure application that is cost effective, responsive, scalable, and adaptable.

#### SAP solution idea

You can [automate SAP workloads by using SUSE tools on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml).
