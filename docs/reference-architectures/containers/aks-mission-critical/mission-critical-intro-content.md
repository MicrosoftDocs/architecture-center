This article series provides guidance for designing a mission critical workload on Azure. It prioritizes cloud-native capabilities to maximize reliability and operational effectiveness. It applies the design methodology for [Well-Architected mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

## Key design strategies

Many factors can affect the reliability of an application, such as the ability to recover from failure, regional availability, deployment efficacy, and security. Apply a set of overarching design strategies to address these factors and ensure the target reliability tier is achieved.

Mission-critical workloads typically target an SLO of 99.99% or higher, which corresponds to a permitted annual downtime of 52 minutes and 35 seconds. All encompassed design decisions are therefore intended to accomplish this target SLO.

- **Redundancy in layers**

  - Deploy to *multiple regions in an active-active model*. The application is distributed across two or more Azure regions that handle active user traffic.

  - Utilize *availability zones* for all considered services to maximize availability within a single Azure region, distributing components across physically separate data centers inside a region.

  - Choose resources that support *global distribution*.

    > Refer to [Well-Architected mission-critical workloads: Global distribution](/azure/well-architected/mission-critical/mission-critical-application-design#global-distribution).

- **Deployment stamps**

  Deploy a regional stamp as a *scale unit* where a logical set of resources can be independently provisioned to keep up with the changes in demand. Each stamp also applies multiple nested scale units, such as the Frontend APIs and Background processors which can scale in and out independently.

  > Refer to [Well-Architected mission-critical workloads: Scale-unit architecture](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture).

- **Reliable and repeatable deployments**

  - Apply the *principle of Infrastructure as code (IaC)* using technologies, such as Terraform, to provide version control and a standardized operational approach for infrastructure components.

  - Implement *zero downtime blue/green deployment pipelines*. Build and release pipelines must be fully automated to deploy stamps as a single operational unit, using blue/green deployments with continuous validation applied.

  - Apply *environment consistency* across all considered environments, with the same deployment pipeline code across production and pre-production environments. This eliminates risks associated with deployment and process variations across environments.

  - Have *continuous validation* by integrating automated testing as part of DevOps processes, including synchronized load and chaos testing, to fully validate the health of both the application code and underlying infrastructure.

  > Refer to [Well-Architected mission-critical workloads: Deployment and testing](/azure/well-architected/mission-critical/mission-critical-deployment-testing).

- **Operational insights**

  - Have *federated workspaces for observability data*. Monitoring data for global resources and regional resources are stored independently. A centralized observability store isn't recommended to avoid a single point of failure. Cross-workspace querying is used to achieve a unified data sink and single pane of glass for operations.

  - Construct a *layered health model* that maps application health to a traffic light model for contextualizing. Health scores are calculated for each individual component and then aggregated at a user flow level and combined with key non-functional requirements, such as performance, as coefficients to quantify application health.

    > Refer to [Well-Architected mission-critical workloads: Health modeling](/azure/well-architected/mission-critical/mission-critical-health-modeling).

## Design areas

We suggest you explore these design areas for recommendations and best practice guidance when defining your mission-critical architecture.

|Design area|Description|
|---|---|
|[Application platform](mission-critical-app-platform.md)|Infrastructure choices and mitigations for potential failure cases.|
|[Application design](mission-critical-app-design.md)|Design patterns that allow for scaling, and error handling.|
|[Networking and connectivity](mission-critical-networking.md)|Network considerations for routing incoming traffic to stamps.|
|[Data platform](mission-critical-data-platform.md)|Choices in data store technologies, informed by evaluating required volume, velocity, variety, and veracity characteristics.|
|[Deployment and testing](mission-critical-deploy-test.md)|Strategies for CI/CD pipelines and automation considerations, with incorporated testing scenarios, such as synchronized load testing and failure injection (chaos) testing.|
|[Health modeling](mission-critical-health-modeling.md)|Observability considerations through customer impact analysis correlated monitoring to determine overall application health.|
|[Security](mission-critical-security.md)|Mitigation of attack vectors through Microsoft Zero Trust model.|
|[Operational procedures](mission-critical-operations.md)|Processes related to deployment, key management, patching and updates.|

## Next steps

> [!div class="nextstepaction"]
> [Mission-critical: Application platform](mission-critical-app-platform.md)
