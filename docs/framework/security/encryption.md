---
title: Encrypting your workload
description: Describes considerations to make when encrypting your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Encrypting your workload

## Key management strategy

Protecting your keys is essential to protecting your data in the cloud.

## Encryption policy

## Data at rest

Encryption at rest provides data protection for stored data (at rest). Attacks against data at-rest include attempts to obtain physical access to the hardware on which the data is stored, and then compromise the contained data. In such an attack, a server’s hard drive may have been mishandled during maintenance allowing an attacker to remove the hard drive. Later the attacker would put the hard drive into a computer under their control to attempt to access the data.

## Data in transit

If data moving over a network is not encrypted, there’s a chance that it can be captured and stolen by unauthorized users. When you're dealing with database services, make sure that data is encrypted between the database client and server. Also make sure that data is encrypted between database servers that communicate with each other and with middle-tier applications.

## Appropriate encryption algorithms

Organizations have to think about what type of threats they want to protect against, and that will determine the type of technology used.

## File level encryption

Risk of data leakage and lack of business insights monitor for abuse and prevent malicious access to files.

Action:
Use Azure Managed Disks for persistent and secure disk storage for Azure virtual machines. Enforce file-level data encryption.

## VM Disks

Risk of data integrity issues, such as malicious or rogue users stealing data and compromised accounts gaining unauthorized access to data.

Action:
Use Azure Disk Encryption to protect and safeguard data to meet organizational security and compliance commitments. Encrypt Azure Virtual Machines.