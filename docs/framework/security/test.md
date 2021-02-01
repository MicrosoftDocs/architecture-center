---
title: Azure security test practices
description: Test your workload frequently to detect attacks.
author: PageWriter-MSFT
ms.date: 02/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Azure security test practices

Deployment & Testing
Application Deployments
Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?

N-1 and N+1 refer to roll-back and roll-forward. Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle.

Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle

Are code scanning tools an integrated part of the continuous integration (CI) process for this workload?

Credentials should not be stored in source code or configuration files, because that increases the risk of exposure. Code analyzers (such as Roslyn analyzers for Visual Studio) can prevent from pushing credentials to source code repository and pipeline addons such as CredScan (part of Microsoft Security Code Analysis) help to catch credentials during the build process.

Integrate code scanning tools within CI/CD pipeline.

Are dependencies and framework components included in the code scanning process of this workload?

As part of the continuous integration process it is crucial that every release includes a scan of all components in use. Vulnerable dependencies should be flagged and investigated. This can be done in combination with other code scanning tasks (e.g. code churn, test results/coverage).

Include code scans into CI/CD process that also covers 3rd party dependencies and framework components.

How are credentials, certificates and other secrets managed in CI/CD pipelines for this workload?

Secrets need to be managed in a secure manner inside of the CI/CD pipeline. Secrets need to be stored either in a secure store inside the pipeline or externally in Azure Key Vault. When deploying application infrastructure (e.g. with Azure Resource Manager or Terraform), credentials and keys should be generated during the process, stored directly in Key Vault and referenced by deployed resources. Hardcoded credentials should be avoided.

Store keys and secrets outside of deployment pipeline in Azure Key Vault or in secure store for the pipeline.

Are branch policies used in source control management of this workload? How are they configured?

Branch policies provide additional level of control over the code which is commited to the product. It is a common practice to not allow pushing against the main branch and require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author. Different branches can have different purposes and access levels, for example: feature branches are created by developers and are open to push, integration branch requires PR and code-review and production branch requires additional approval from a senior developer before merging.

Implement branch policy strategy to enhance branch security.

Build Environments
Does the organization apply security controls (e.g. IP firewall restrictions, update management, etc.) to self-hosted build agents for this workload?

When the organization uses their own build agents it adds management complexity and can become an attack vector. Build machine credentials must be stored securely and file system needs to be cleaned of any temporary build artifacts regularly. Network isolation can be achieved by only allowing outgoing traffic from the build agent, because it's using pull model of communication with Azure DevOps.

Apply security controls to self-hosted build agents in the same manner as with other Azure IaaS VMs.

Testing & Validation
Does the organization use Azure Defender (Azure Security Center) or any third-party solution to scan containers in this workload for vulnerabilities?

Azure Security Center is the Azure-native solution for securing containers. Security Center can protect virtual machines that are running Docker, Azure Kubernetes Service clusters, Azure Container Registry registries. ASC is able to scan container images and identify security issues, or provide real-time threat detection for containerized environments. Container Security in Security Center

Scan container workloads for vulnerabilities.

Does the organization perform penetration testing or have a third-party entity perform penetration testing of this workload to validate the current security defenses?

Real world validation of security defenses is critical to validate a defense strategy and implementation. Penetration tests or red team programs can be used to simulate either one time, or persistent threats against an organization to validate defenses that have been put in place to protect organizational resources.

Use penetration testing and red team exercises to validate security defenses for this workload.

Does the organization have a method to carry out simulated attacks on users of this workload?

People are a critical part of your defense, especially those with elevated permissions, so ensuring they have the knowledge and skills to avoid and resist attacks will reduce your overall organizational risk. Simulating attacks for educational purposes helps to enforce understanding of the various means that an attacker may use to compromise accounts. Tools such as Office 365 Attack Simulation or similar may be used.

Simulate attack against users and critical accounts. Ensure proper follow-up to educate users about the various means that an attacker may use.