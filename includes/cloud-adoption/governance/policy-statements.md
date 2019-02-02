## Policy statements

The following policy statements establish the requirements needed to mitigate the defined risks. These policies define the functional requirements for the governance MVP. Each will be represented in the implementation of the governance MVP. 

Deployment Acceleration:

- All assets must be grouped and tagged according to defined grouping and tagging strategies.
- All assets must use an approved deployment model.
- Once a governance foundation has been established for a cloud provider, any deployment tooling must be compatible with the tools defined by the governance team.

Identity Baseline:

- All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
- All groups in the on-premises Active Directory infrastructure that have elevated privileges should be mapped to an approved RBAC role.

Security Baseline:

- Any asset deployed to the cloud must have an approved data classification.
- No assets identified with a protected level of data may be deployed to the cloud, until sufficient requirements for security and governance can be approved and implemented.
- Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements to other data centers or internal networks.

Cost Management:

- For tracking purposes, all assets must be assigned to an application owner within one of the core business functions.
- When cost concerns arise, additional governance requirements will be established with the Finance team.

Resource Consistency:

- Because no mission-critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.
- When mission-critical workloads are deployed, additional governance requirements will be established with IT operations.

## Processes

No budget has been allocated for ongoing monitoring and enforcement of these governance policies. Given that, the cloud governance team has some ad hoc ways to monitor adherence to policy statements.

- **Education**: The cloud governance team is investing time to educate the cloud adoption teams on the governance journeys that support these policies.
- **Deployment** reviews: Before deploying any asset, the cloud governance team will review the governance journey with the cloud adoption teams.
