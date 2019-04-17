---
title: "CAF: Introduction to regulatory compliance"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Introduction to regulatory compliance
author: BrianBlanchard
---

# Introduction to regulatory compliance

This is an introductory article about regulatory compliance, therefore it's not intended for implementing a compliance strategy. It is for general awareness only. More detailed information about [Azure compliance offerings](https://aka.ms/allcompliance) is available at the [Microsoft Trust Center]. Moreover, all downloadable documentation is available to Azure customers under a nondisclosure agreement from the [Microsoft Service Trust Portal](https://servicetrust.microsoft.com).

Regulatory compliance refers to the discipline and process of ensuring that a company follows the laws set by governing bodies in their geography or industry. For IT regulatory compliance, people and/or processes monitor corporate systems in an effort to detect and prevent violations of policies and procedures established by governing laws and regulations. This in turn applies to a very wide area of monitoring and enforcement processes. Depending on the industry and geography, these processes can become quite lengthy and complex.

For multinational organizations (particularly those in heavily regulated industries, such as healthcare and financial services), compliance can be very challenging. Standards and regulations abound and, of course, they change frequently, making it difficult for businesses to keep abreast of evolving international electronic data handling laws.

As with security controls, organizations should understand the division of responsibilities regarding regulatory compliance in the cloud. Cloud providers strive to ensure that their platforms and services are compliant. But organizations also need to confirm that their applications, and those supplied by third parties, are compliant. Similarly, applications in regulated industries that use cloud services might require certification from the cloud provider.

The following are descriptions of compliance regulations in various industries and geographies:

## HIPAA

A healthcare application that processes protected health information (PHI) is subject to both the Privacy Rule and the Security Rule encompassed within the Health Information Portability and Accountability Act (HIPAA). At a minimum, HIPAA could likely require that a healthcare business receive written assurances from the cloud provider that it will safeguard any PHI received or created.

## PCI

Payment Card Industry Data Security Standard (PCI DSS) is a proprietary information security standard for organizations that handle branded credit cards from the major card schemes, including Visa, MasterCard, American Express, Discover, and JCB. The PCI standard is mandated by the card brands and administered by the Payment Card Industry Security Standards Council. The standard was created to increase controls around cardholder data to reduce credit-card fraud. Validation of compliance is performed annually, either by an external Qualified Security Assessor (QSA) or by a firm-specific Internal Security Assessor (ISA) who creates a Report on Compliance (ROC) for organizations handling large volumes of transactions, or by a Self-Assessment Questionnaire (SAQ) for companies.

## PII

Personally identifiable information (PII) is any datapoint that could be used to identify a consumer, employee, partner, or any other living or legal entity. Many emerging laws, particularly those dealing with privacy and individual PII, require that businesses themselves comply and report on compliance and any breaches that might occur.

## GDPR

One of the most important developments in this area is the recent enactment by the European Commission of the General Data Protection Regulation (GDPR), designed to strengthen data protection for individuals within the European Union. GDPR requires that data about individuals, such as "a name, a home address, a photo, an email address, bank details, posts on social networking websites, medical information, or a computer's IP address," be maintained on servers within the EU and not transferred out of it. It also requires that companies notify individuals of any data breaches, and mandates that companies have a Data Protection Officer. Other countries have, or are developing, similar types of regulations.

## Compliant foundation in Azure

To help customers meet their own compliance obligations across regulated industries and markets worldwide, Azure maintains the largest compliance portfolio in the industry &mdash; in breadth (total number of offerings), as well as depth (number of customer-facing services in assessment scope). Azure compliance offerings are grouped into four segments: globally applicable, US Government, industry-specific, and region/country-specific.

Azure compliance offerings are based on various types of assurances, including formal certifications, attestations, validations, authorizations, and assessments produced by independent third-party auditing firms, as well as contractual amendments, self-assessments, and customer guidance documents produced by Microsoft. Each offering description in this document provides an up-to-date scope statement indicating which Azure customer-facing services are in scope for the assessment, as well as links to downloadable resources to assist customers with their own compliance obligations.

More detailed information about Azure compliance offerings is available from the [Microsoft Trust Center](/trustcenter/compliance/complianceofferings). Moreover, all downloadable documentation is available to Azure customers under a nondisclosure agreement from the [Service Trust Portal](https://servicetrust.microsoft.com) in the following sections:

* Audit reports: Includes FedRAMP, GRC assessment, ISO, PCI DSS, and SOC reports sections
* Data protection resources: Includes compliance guides, FAQ and white papers, and pen test and security assessments sections
