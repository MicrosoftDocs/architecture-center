---
title: Security considerations to make for monitoring
description: Describes monitoring strategies that you can use in your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Security considerations to make for monitoring

## DNS Monitoring

Utilize DNS Analytics for gathering security, performance and operations-related insights of DNS servers.

## Workload hardening

Use Security Compliance Manager to import the current configuration by using either group policies based on Active Directory or configuration of a “golden master” reference machine by using the LocalGPO tool. You can then import the local group policy into Security Compliance Manager.

## Manage antimalware

Install and manage antimalware.

## Monitor resources

Utilize Azure Monitor to get the granular, up-to-date monitoring data all in one place. Use monitoring services.

## Manage and protect infrastructure

Utilize Azure Monitor to get the granular, up-to-date monitoring data all in one place. Review monitor, manage, and protect cloud infrastructure guidance.

## How do you collect and process data about resources (security event log, Windows firewall log, antimalware assessment)?

Use Operations Management Suite (OMS) Security and Audit Solution to collect and processes data about resources.

## Trace requests

Use Azure Security Center for security management and advanced threat protection across hybrid cloud workloads. Review trace requests, analyze usage trends, and diagnose issues guidance.

## Understand who has access to what data

Data security is essential for every business. Businesses rely on data storage and transactions to perform certain operations. Usage of data has increased business profitability and efficiency. At the same time, it also has potential security risks that could devastate a company.

## Audit access log

## Actively monitor logs for suspicious activity

Being on top of logs means a quicker response time to security events and better security program effectiveness. Not only will log analysis and daily monitoring demonstrate your willingness to comply with PCI DSS and HIPAA requirements, it will also help you defend against insider and outsider threats.

Risk of compromised user credentials and suspicious activities occurring using these credentials.

## correlating calls across systems (end-to-end tracing).

You must think about security for all resources that take part in the workload. Azure Security Center provides integrated security monitoring and policy management across your Azure subscriptions. The events collected from the agents and from Azure are correlated in the security analytics engine to provide you tailored recommendations (hardening tasks), that you should follow to make sure your workloads are secure, and threat detection alerts. You should investigate such alerts as soon as possible to make sure malicious attacks aren't taking place on your workloads.

## Admin credential usage

Risk of compromised admin accounts negating the value of all the other measures taken to ensure the confidentiality and integrity of data.

Action:
Limit and constrain administrative access.

## Threat response

Inability to have a single pane of visibility to prevent, detect, and respond to threats.

Action:
Employ Azure Security Center for increased visibility into, and control over, the security of Azure resources, integrated security monitoring, and policy management across Azure subscriptions.