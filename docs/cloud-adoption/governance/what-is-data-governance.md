---
title: "Fusion: What is Data Governance"
description: What is Data Governance?
author: BrianBlanchard
ms.date: 12/1/2018
---

# Fusion: What is Data Governance?

This is an introductory article on the general topic of Data Governance. This article is not expected to provide enough context to allow the reader to implement a Data Governance. It is for general awareness only. More detailed information about Cloud Security is available from [Azure's Trusted Cloud](https://azure.microsoft.com/overview/trusted-cloud/). Approaches to improving your organizations security posture can be found in the [Cloud Security Service Catalog](https://www.microsoft.com/security/information-protection).

## Data Governance Scope

Data governance has traditionally been defined as the set of processes and controls that ensure that data is consistent throughout the data lifecycle and that data is highly accurate and reliable. As the world of data expands to include new sources and forms of data, this definition has expanded in many circles. Today, data governance has grown to include data security, availability, integrity, and a number of other non-traditional disciplines that could compromise the data or the subjects of the data.

The scope of the [Fusion framework](../overview.md) is limited specifically to classification, security, availability, and access aspects of data governance, as opposed to the more traditional data quality processes.

## Data Governance Policy

To ensure compliance with regulations and standards, a data governance function is essential. It is imperative that the Cloud Adoption team know what data applications are keeping in the cloud, as well as, the laws of the country or region regarding data sovereignty and cross-border data movement.

To ensure proper understanding of data, it is important to establish a data classification process to govern data being moved to the cloud. The following is a list of commonly observed classifications seen in many corporate data classification policies:

* Personally Identifiable Information (PII) includes data points about customers, employees, partners or others that could compromise the identity or security of the person.
* Highly Confidential information includes content that would harm the business if over-shared
* Confidential information  includes content that could harm the business if over-shared
* Intellectual Property (IP) includes information or content that is considered to be a competitive advantage or of special business value
* Mission Critical includes information that is necessary for mission critical operations to function
* General information includes business information that is not meant for external consumption
* Public data includes information that is intended for public consumption

Once a classification schema is established, the CISO or other security experts can aid in aligning specific classifications with the business' level of risk tolerance. To help trigger ideas when developing a data governance policy, the following are common questions asked of each data classification:

* Is there a risk associated with hosting this classification of data in the public cloud? Is that risk acceptable?
* Should this classification of data be encrypted in flight or at rest?
* Should this classification of data be geo-replicated to other regions?
* Is there a general RTO or RPO requirement associated with this class of data?

Security and privacy are built into the Azure platform, which helps protect business and personal information based on user identities, credentials, roles, and controlled access. Azure uses industry-standard protocols to encrypt data in transit, which means your data is secured as it travels between devices and Microsoft datacenters, as it moves within datacenters, and when it is at rest in Azure Storage. However, if the Cloud Adoption team is not aware of data classification policies, it is difficult to implement the right balance of protection and cost.

Azure data privacy and governance includes the following features to help protect data:

* Protecting data in transit and at rest through encryption of data, files, applications, services, communications, and drives
* Supporting and using numerous encryption mechanisms, including SSL/TLS, IPsec, and AES
* Providing configuration support for BitLocker Drive Encryption on virtual hard disks (VHDs) that contain sensitive information
* Ensuring that access to data by Azure support personnel requires your explicit permission and is granted on a “just-in-time” basis that is logged and audited, and then revoked after completing the engagement
