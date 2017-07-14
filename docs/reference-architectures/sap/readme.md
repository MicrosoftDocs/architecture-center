---
title: Deploy SAP NetWeaver and SAP HANA on Azure Readme
description: Reference architectures, blueprints, and prescriptive implementation guidance for common workloads on Azure.
---
# Deploy SAP NetWeaver and SAP HANA on Azure Readme

In this readme, we have gathered helpful notes about the installation and infrastructure for your reference. 

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Order of installation

1.  Install the HANA database software on the **sap-hana-vm1** virtual machine (VM).

2.  Install the SCS cluster, including Windows clustering, SIOS DataKeeper Cluster Edition, and SAP Central Services (SCS) software.

3.  Install the SAP database instance component (which imports application content into the HANA database) from the **sap-scs1** VM.

4.  Install the primary application server on **sap-apps-vm1**.

5.  Install the two secondary application servers on **sap-apps-vm2** and **sap-apps-vm3**.

6.  Install SAP Web Dispatcher (WDP) on **sap-wdp-vm1** and **sap-wdp-vm2**.

7.  For testing, install SAP GUI on the **jumpbox-vm1** VM.

For details about how to install an SAP system, see [Installation of SAP Systems Based on the Application Server ABAP of SAP NetWeaver 7.3 to 7.5 on Windows: SAP HANA Database](https://help.sap.com/doc/4f96ad1f741a10148da8f2319ad2172e/CURRENT_VERSION/en-US/NW7XX_Inst_HDB_Win_ABAP.pdf).

# VM access notes

- To access the VMs in the deployed environment, first connect to the **jumpbox-vm1** VM. From here, use a remote desktop client to access a VM in the environment by its internal IP address or machine name. Use a Secure Shell (SSH) tool such as PuTTY or MobaXTerm installed on **jumpbox-vm1** to access the HANA Linux VM.

- To perform the X11-based SAP graphical installation on **sap-hana-vm1**, use an X11 server such as VcXSrv, XMing, or MobaXTerm on **jumpbox-vm1**. For SAP Software Provisioning Manager (SWPM) 1.0 SP20, a browser-based graphical installation is now supported. Run the browser portion of the installation on any of the Windows Server VMs in the environment.

- To make it easy to download and share SAP software on all the VMs, consider using a single Azure file share attached to each of the VMs. At each logon, reattach each VM to the shared drive; the credentials for the share are not persistent. This approach is a convenience, not a requirement, so it is not included in the reference architecture template. After the installation process is complete, there’s no need to maintain the share.

# SAP HANA instance installation notes

- For the HANA VM, the template automatically attaches two Premium disks. You must provision the disks using the logical volume manager based on your storage partition strategy.

- For details about the SAP operating system’s configuration requirements for HANA, refer to the appropriate installation guidelines for your operating system:

  *  [SAP HANA Guidelines for SLES Operating System Installation](https://launchpad.support.sap.com/#/notes/1944799)
  *  [SAP HANA DB Recommended OS Settings for SLES 12 for SAP Applications](https://launchpad.support.sap.com/#/notes/2205917/E)
  *  [SAP HANA Guidelines for Red Hat Enterprise Linux (RHEL) Operating System](https://launchpad.support.sap.com/#/notes/2009879)
  *  [SAP HANA DB: Recommended OS settings for RHEL 7](https://launchpad.support.sap.com/#/notes/2292690/E)

- If you choose a Linux operating system image from the Azure Gallery with the name “for SAP” -- for example, SLES 12 for SAP 12 SP2 (Premium) -- the configuration settings for the SAP applications already have been applied. We recommend verifying against the latest notes to ensure completeness of the operating system settings.

- You must add an A-record to the DNS service on **ad-vm1** for the HANA VM. The HANA VM is not configured to be a member of the contoso.com domain, but rather uses local user credentials. To make it a member of the domain, use a Linux pluggable authentication module for Active Directory.

# File share creation notes

You must use a remote desktop client to access the file share witness VM, then create a file share to act as the witness for the SCS cluster.

# SCS cluster installation notes

- For instructions on installing a clustered SCS instance using SIOS DataKeeper, see [Running SAP Applications on the Microsoft Platform](https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/).

- In this reference architecture, we assume the configuration of SAP instance **00**. If you choose a different instance number, change the load balancing rules in **sap-scs-lb**, the SCS internal load balancer.

- For the 11 SCS load balancer rules, set the [idle timeout](https://azure.microsoft.com/en-us/blog/new-configurable-idle-timeout-for-azure-load-balancer/) to **30 minutes**.

- Set the interval property of the load balancer health probe for the SCS cluster to **10 seconds**.

- The hostname in Azure VMs can differ from the Azure resource name. SAP requires hostnames to be fewer than 14 characters. To conform to this rule, the SCS nodes use abbreviated hostnames, **sap-scs1** and **sap-scs2**.

- When setting up Windows Server clustering on the SCS nodes, make sure to set the cluster probe port to the value **59999**. To do this, use PowerShell on one of the SCS VMs. Enter the following commands in an elevated PowerShell window:

```
      PS C:\Users\testuser> Get-ClusterResource "SAP NW1 IP" | Set-ClusterParameter -Name ProbePort -Value 59999
```

- Install the SAP database instance on the HANA VM *after* installing the SCS cluster. However, the installation software needs access to the **sapmnt** share from the SCS cluster. To mount the **sapmnt** share on the Linux VM, perform the following as **root** before running **sapinst**:

```
      sap-hana1:/mnt # mount.cifs "//sapscscl/sapmnt" /mnt/sapmnt -o "username=testuser,password=<your password here>,uid=1002,gid=sapsys"
```

- To test the whole environment, install the SAP GUI on **jumpbox-vm1** to represent a client machine accessing the environment.

# SAP Web Dispatcher cluster

- For the WDP load balancer rule, set the [idle timeout](https://azure.microsoft.com/en-us/blog/new-configurable-idle-timeout-for-azure-load-balancer/) to **30 minutes**.

- In the WDP load-balancer configuration, set the session persistence property to **Client IP**.
