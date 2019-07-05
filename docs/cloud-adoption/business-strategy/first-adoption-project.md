---
title: "First cloud adoption project"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn about executing you first cloud adoption project.
author: BrianBlanchard
ms.author: brblanch
ms.date: 5/19/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

<!-- markdownlint-disable MD026 -->

# First cloud adoption project

There is a learning curve and a time commitment associated with cloud adoption planning. Even for experienced teams, proper planning takes time&mdash;time to align stakeholders, time to collect and analyze data, time to validate long-term decisions, and time to align people, processes, and technology. In the most productive adoption efforts, planning evolves in parallel with adoption, improving with each release and with each workload migration to the cloud. It is important to understand the difference between a cloud adoption plan and a cloud adoption strategy. To facilitate and guide the execution of the cloud adoption plan, a well-defined strategy is an essential requirement.

The Cloud Adoption Framework outlines the processes across cloud adoption and operation of workloads hosted in the cloud. Each of the processes across _strategy_, _plan_, _ready_, _adopt_, and _operate_ will require slight expansions of technical, business, and operational skills. Some of those skills can come from directed learning. However, many of those skills are most effectively acquired through hands-on experiences.

Starting a first adoption process in parallel with the development of the plan provides multiple benefits:

- Establish a growth mindset to encourage learning and exploration.
- Provide an opportunity for the team to develop necessary skills.
- Create situations which would encourage new approaches to collaboration.
- Identify skill gaps and potential partnership needs.
- Provide tangible inputs into the plan.

## First project criteria

The first adoption project should align with the [motivations](./motivations-why-are-we-moving-to-the-cloud.md) behind cloud adoption. Whenever possible, the first project should also demonstrate progress towards a defined [business outcome](./business-outcomes/how-to-use-the-business-outcome-template.md).

## First project expectations

The team's first adoption project is very likely to result in a production deployment of some kind. However, this is not always the case. Proper expectations need to be established early. The following are a few wise expectations to set:

- This project is a source of learning.
- This project may result in production deployments, but is likely to require additional effort first.
- The output of this project is a set of clear requirements to provide a longer-term production solution.

## First project examples

To support the criteria above, the following lists examples of a first project for each motivation category:

- **Critical business events:** When a critical business event is the primary motivation, implementation of a tool like [Azure Site Recovery](../migrate/azure-migration-guide/migrate.md?tabs=Tools#azure-site-recovery) might be a good first project. During migration, this tool can be used to quickly migrate datacenter assets. However, during the first project it could be used purely as a disaster recovery tool, reducing dependencies on disaster recovery assets within the datacenter.

- **Migration motivations:** When migration is the primary motivation, it is wise to start with the migration of a noncritical workload. The [Azure Readiness Guide](../ready/azure-readiness-guide/index.md) and the [Azure Migration Guide](../migrate/azure-migration-guide/index.md) can serve as guidance for the migration of that first workload.

- **Innovation motivations:** When innovation is the primary motivation, creation of a targeted dev/test environment can serve as a great first project.

Additional examples of first adoption projects would include:

- **Disaster recovery and business continuity (DR/BC):** Beyond Azure Site Recovery, multiple DR/BC strategies can be implemented as a first project.
- **Nonproduction**: Deployment of a nonproduction instance of a workload.
- **Archive:** Cold storage can place a strain on datacenter resources. Moving that data to the cloud is a solid quick win.
- **End of support (EOS):** Migrating assets that have reached the end of support is another quick win that builds technical skills. It could also provide some cost avoidance from expensive support contracts or licensing costs.
- **Virtual Desktop Interface (VDI):** Creating virtual desktops for remote employees can provide a quick win. In some cases, this first adoption project could also reduce dependence on expensive private networks in favor of commodity public internet connectivity.
- **Dev/Test:** Remove dev/test from on-premises environments to give developers control, agility, and self-service capacity.
- **Simple apps (less than 5):** Modernize and migrate a simple app to gain developer and operations experience quickly.
- **Performance labs:** When high-scale performance requirements are needed in a lab setting, use the cloud to quickly and cost-effectively provision those labs for a short time.

## Next steps

Once the first cloud adoption project has begun, the Cloud Strategy team can turn their attention to the longer-term [cloud adoption plan](../plan/index.md).

> [!div class="nextstepaction"]
> [Build your cloud adoption plan](../plan/index.md)
