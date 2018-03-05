---
title: "Explainer: what is a jumpbox or bastion host?"
description: Defines the terms 'jumpbox' and 'bastion host'
author: telmosampaio
---

# Explainer: what is a jumpbox?

In the foundational adoption stage, you learned about using a single infrastructure-as-a-service (IaaS) virtual machine (VM). Most IaaS workloads will be composed by more than a simple VM. They can encompass several VMs running different software, such as a web UI, distributed micro services, and database servers. 

You need to allow different suers to access these separate VMs in a secure fashion, without necessarly providing direct access to the VMs themselves. You can do that by using a **jumpbox**, **bastion host**, or **secure administrative host**. 

> [!NOTE]
> The terms **jumpbox**, **bastion host**, and **secure administrative host** are used interchangebly in the industry. We will use the term **jumpbox** in this document to facilitate reading.

A **jumpbox** is a computer used to manage devices in different security zones. In public clouds, jumpboxes become extremelly valuable as a way to manage VMs that are protected from access from the public Internet. The jumpbox VM itself might be exposed to the Internet, and have access to VMs in your workload that are not exposed to the public. That creates an isolation boundary, or **DMZ**, that you control to provide management access to secure resoruces.

In an Azure virtual network, a jumpbox should be added to a secure subnet, that only allows remote access on the ports used by services such as *ssh* for Linux VMs, or *RDP* from Windows VMs. Outgoing connectivity should be restricted to specific management tools used from teh jumpbox top manage other VMs.

## Next steps

- Deploy a [Windows jumpbox][windows-jb].
- Deploy a [Linux jumpbox][linux-jb].

<!-- links -->
[windows-jb]: ../../reference-architectures/virtual-machines-linux/jumpbox.md
[linux-jb]: ../../reference-architectures/virtual-machines-linux/linux.md
