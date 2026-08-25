### Identity guides

**Technology choices.** The following articles help you evaluate and select the best identity technologies for your workload requirements:

- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions): Compare three services that provide access to a central identity to determine the best fit for your scenario.

- [Choose the right authentication method for your Microsoft Entra hybrid identity solution](/entra/identity/hybrid/connect/choose-ad-authn): Evaluate authentication options, including password hash synchronization, pass-through authentication, and federation.

#### Multitenant identity

- [Architectural considerations for identity in a multitenant solution](/azure/architecture/guide/multitenant/considerations/identity): Understand identity requirements for multitenant solutions, including authentication, authorization, and tenant isolation.

- [Architectural approaches for identity in multitenant solutions](/azure/architecture/guide/multitenant/approaches/identity): Explore implementation approaches for identity in multitenant solutions, including Microsoft Entra ID and External ID.

### Identity architectures

The following production-ready architectures demonstrate end-to-end identity solutions that you can deploy and customize.

#### Hybrid identity

- [Integrate on-premises Active Directory domains with Microsoft Entra ID](/entra/identity/hybrid/cloud-sync/plan-cloud-sync-topologies): Best practices for integrating on-premises Active Directory domains with Microsoft Entra ID to provide cloud-based identity authentication.

- [Create an AD DS resource forest in Azure](/entra/identity/domain-services/overview): Create a separate Active Directory domain in Azure that's trusted by domains in your on-premises Active Directory forest.

- [Deploy AD DS in an Azure virtual network](/azure/architecture/reference-architectures/identity/adds-extend-domain): Extend an on-premises Active Directory domain to Azure to provide distributed authentication services.

- [Extend on-premises AD FS to Azure](/entra/identity/hybrid/connect/migrate-from-federation-to-cloud-authentication): Extend your on-premises network to Azure and use Active Directory Federation Services (AD FS) for federated authentication and authorization.

#### Cross-cloud identity

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security): Deploy Microsoft Entra identity and access solutions for AWS to provide centralized identity management and strong single sign-on authentication.

### Identity solution ideas

The following identity solution ideas demonstrate implementation patterns and possibilities to explore:

- [Build the first layer of defense by using Azure security services](/azure/architecture/solution-ideas/articles/azure-security-build-first-layer-defense): Use Azure security services, including identity services like role-based access control (RBAC), MFA, and Conditional Access, to build a foundational security layer for your infrastructure.

- [Multilayered protection for Azure virtual machine access](/azure/architecture/solution-ideas/articles/multilayered-protection-azure-vm): Implement identity-based just-in-time access to Azure VMs by using Microsoft Entra ID, Conditional Access, and Privileged Identity Management.

