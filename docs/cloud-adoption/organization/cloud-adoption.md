---
title: "Cloud adoption capabilities" 
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Describes the formation of cloud adoption capabilities
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: organize
---

# Cloud adoption capabilities

Cloud adoption capabilities allow for the implementation of technical solutions in the cloud. Like any IT project, the people delivering the actual work will determine success. The teams providing the necessary cloud adoption capabilities can be staffed from multiple subject matter experts or implementation partners.

## Possible sources for this capability

Cloud adoption teams are the modern-day equivalent of technical implementation teams or project teams. However, the nature of the cloud may require a more fluid team structure. Some teams focus exclusively on cloud migration while other teams focus on innovations that leverage cloud technologies. Some teams include broad technical expertise required to complete large adoption efforts, like a full datacenter migration. Other teams have more of a tight technical focus and may move between projects to accomplish specific goals. One example would be a team of data platform specialists who help convert SQL VMs to SQL PaaS instances.

Regardless of the type or number of cloud adoption teams, the cloud adoption capability is provided subject matter experts found in IT, business analysis, or implementation partners.

Depending on the desired business outcomes, the skills needed to provide full cloud adoption capabilities could include:

- Infrastructure implementers
- DevOps engineers
- Application developers
- Data scientists
- Data or application platform specialists

It's advised that cloud adoption teams consist of an average team size of six people for optimal collaboration and efficiency. These teams should be self-organizing from a technical execution perspective. Inclusion of project management with deep experience in agile, scrum, or other iterative models are also highly recommended. However, this team is most effective when managed via a flat structure.

## Key responsibilities

The primary need from any cloud adoption capability is the timely, high-quality implementation of the technical solutions outlined in the adoption plan, in alignment with governance requirements and business outcomes, taking advantage of technology, tools, and automation solutions made available to the team.

**Early planning tasks:**

- Execute the [rationalization of the digital estate](../digital-estate/overview.md)
- Review, validate, and advance the [prioritized migration backlog](../migrate/migration-considerations/assess/release-iteration-backlog.md)
- Begin execution of the [first workload](../digital-estate/rationalize.md#selecting-the-first-workload) as a learning opportunity

**Ongoing monthly tasks:**

- Oversee [change management processes](../migrate/migration-considerations/prerequisites/technical-complexity.md)
- Manage the [release and sprint backlogs](../migrate/migration-considerations/assess/release-iteration-backlog.md)
- Maintain/build the adoption landing zone in conjunction with governance requirements
- Execute the technical tasks outlined in the [sprint backlogs](../migrate/migration-considerations/assess/release-iteration-backlog.md)

## Team cadence

It's recommended that teams providing cloud adoption capability are dedicated to the effort full-time.

It's highly suggested that these teams meet daily in a self-organizing way. The goal of daily meetings is to quickly update the backlog, communicate what has been completed, what is to be done today, and what things are blocked requiring additional external support.

Release schedules and iteration durations are unique to each company. However, a range of one to four weeks per iteration seems to be the common average duration. Regardless of iteration or release cadence, it's suggested that the team meets all supporting teams at the end of each release to communicate the outcome of the release and reprioritize coming efforts. Likewise, it's valuable to meet as a team at the end of each sprint, with the [cloud center of excellence](./cloud-center-excellence.md) or [cloud governance team](./cloud-governance.md) to stay aligned on common efforts and any needs for support.

Some of the technical tasks associated with cloud adoption can become repetitive. It's advised that team members rotate every 3&ndash;6 months to avoid employee satisfaction issues and maintain relevant skills. A rotating seat on [cloud center of excellence](./cloud-center-excellence.md) or [cloud governance team](./cloud-governance.md) can provide an excellent opportunity to keep employees fresh and harness new innovations.

## Next steps

Adoption is great, but ungoverned adoption can produce unexpected results. Aligning [cloud governance capabilities](./cloud-governance.md) accelerates adoption and best practices, while reducing business and technical risks.

> [!div class="nextstepaction"]
> [Align cloud governance capabilities](./cloud-governance.md)