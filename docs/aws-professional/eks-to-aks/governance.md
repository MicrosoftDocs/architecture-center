
Governance provides mechanisms and processes to maintain control over your applications and resources in the cloud. It involves planning your initiatives and setting strategic priorities. Governance is put in place to mitigate risks and ensure minimal interruption to adoption or innovation in your organization.

When we look at governance of Kubernetes clusters in the cloud we can distinguish two aspects of it:

- Governance of the environment and the infrastructure where the Kubernetes clusters are deployed.
- Governance inside your Kubernetes environment, or how applications are deployed and run on it.

In this article we will focus only on governance in your Kubernetes environment.

> [!NOTE]
> This article is part of a [series of articles](index.md) that helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand Azure Kubernetes Service (AKS).

## Enforce policies and strengthen governance in your Kubernetes environment

When we look at the options for applying governance policies the two leading CNCF projects are:
- Open Policy Agent (OPA) via Gatekeeper 
- Kyverno

### Open Policy Agent (OPA) & Gatekeeper

[Gatekeeper](https://github.com/open-policy-agent/gatekeeper) is a Kubernetes admission controller that enforces policies created with [OPA](https://www.openpolicyagent.org/). With OPA you can create a policy that runs pods from tenants on separate instances or at a higher priority than other tenants. A collection of common OPA policies can be found in the GitHub [repository](https://github.com/aws/aws-eks-best-practices/tree/master/policies/opa) for this project.

### Kyverno

[Kyverno](https://kyverno.io) is a Kubernetes native policy engine that can validate, mutate, and generate configurations with policies as Kubernetes resources. Kyverno uses Kustomize-style overlays for validation, supports JSON Patch and strategic merge patch for mutation, and can clone resources across namespaces based on flexible triggers.

You can use Kyverno to isolate namespaces, enforce pod security and other best practices, and generate default configurations such as network policies. Several examples are included in the GitHub [repository](https://github.com/aws/aws-eks-best-practices/tree/master/policies/kyverno) for this project.  

## EKS Governance

EKS customers usually rely and use one of the above mentioned solutions, or any of the other available third party solutions for kubernetes governance. Example of policies for both Gatekeeper and Kyverno can be found in this [repository.](https://github.com/aws/aws-eks-best-practices/tree/master/policies).

## AKS Governance

Governance on AKS can be implemented any of the available third party solutions. When using AKS you can rely on  **Azure Policy** service, which allows you to create, assign, and manage policy definitions to enforce rules for your resources. This feature keeps AKS in compliance with your corporate standards.

Azure Policy extends [Gatekeeper v3](https://github.com/open-policy-agent/gatekeeper), to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. Azure Policy makes it possible to manage and report on the compliance state of your Kubernetes clusters from one place.
The add-on enacts the following functions:

- Checks with Azure Policy service for policy assignments to the cluster.
- Deploys policy definitions into the cluster as constraint template and constraint custom resources.
- Reports auditing and compliance details back to Azure Policy service.

Azure Policy for Kubernetes supports the following cluster environments:

- Azure Kubernetes Service (AKS)
- Azure Arc-enabled Kubernetes

To learn more and Understand Azure Policy for Kubernetes clusters 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Software Engineer

Other contributors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer


## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Cost management for Kubernetes](cost-management.yml)


## Related resources

- [Policy for Kubernetes](https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes)
- [Secure your AKS cluster with Azure Policy](https://docs.microsoft.com/azure/aks/use-azure-policy?toc=/azure/governance/policy/toc.json&bc=/azure/governance/policy/breadcrumb/toc.json)
- [Governance disciplines for AKS](https://docs.microsoft.com/azure/cloud-adoption-framework/scenarios/aks/eslz-security-governance-and-compliance)
- [OPA Gatekeeper: Policy and Governance for Kubernetes](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)