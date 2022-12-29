---
title: Community jury
titleSuffix: Azure Application Architecture Guide
description: Learn about the Community jury stakeholder collaboration technique that allows project teams to understand the perceptions and concerns of stakeholders.
author: dcass
categories: azure
ms.date: 05/18/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
  - azure-devops
ms.category:
  - fcp
ms.custom:
  - guide
  - seo-aac-fy21q3
keywords:
  - community jury
  - stakeholder collaboration
  - citizen jury
  - effective collaboration
  - jury solutions
  - collaborative solutions
---

# Community jury

*Community jury*, an adaptation of the [citizen jury](https://jefferson-center.org/about-us/how-we-work/), is a technique where diverse stakeholders impacted by a technology are provided an opportunity to learn about a project, deliberate together, and give feedback on use cases and product design. This technique allows project teams to understand the perceptions and concerns of impacted stakeholders for effective collaboration.

A community jury is different from a focus group or market research; it allows the impacted stakeholders to hear directly from the subject matter experts in the product team, and cocreate collaborative solutions to challenging problems with them.

## Benefits

This section discusses some important benefits of community jury.

### Expert testimony

Members of a community jury hear details about the technology under consideration, directly from experts on the product team. These experts help highlight the capabilities in particular applications.

### Proximity

A community jury allows decision-makers to hear directly from the community, and to learn about their values, concerns, and ideas regarding a particular issue or problem. It also provides a valuable opportunity to better understand the reasons for their conclusions.

### Consensus

By bringing impacted individuals together and providing collaborative solutions and an opportunity for them to learn and discuss key aspects of the technology, a community jury can identify areas of agreement and build common ground solutions to challenging problems.

## Community jury contributors

### Product team

This group comprises owners who will bring the product to market, representative project managers, engineers, designers, data scientists, and others involved in the making of a product. Additionally, subject matter experts are included who can answer in-depth questions about the product.

#### Preparation

Effective deliberation and cocreation require ready-to-use answers to technical questions. As product owners, it is important to ensure technical details are collected prior to the start of the jury session.

Relevant artifacts could include:

- Documentation of existing protections, planned or in place.
- Data Flows, for example, what data types collected, who will have access, for how long, with what protections, and so on.
- Mockups or prototypes of proposed stakeholder collaborative solutions.

#### During the session

Along with providing an accessible presentation of technical details, product team witnesses should describe certain applications of the technology.

Relevant artifacts could include:

- Customer benefits
- Harms assessment and socio-technical impact
- Storyboards
- Competitive solutions and analyses
- Academic or popular media reports

### Moderator

Bring on a neutral user researcher to ensure everyone is heard, avoiding domination of the communications by any one member. The moderator will facilitate brainstorms and deliberations, as well as educate jury members in uncovering bias, and ways to ask difficult questions. If a user researcher is not available, choose a moderator who is skilled at facilitating group discussions. Following the session, the moderator is responsible for the following:

  - ensure that the agreed-upon compensation is provided to the jury members;
  - produce a report that describes key insights, concerns, and recommendations, and
  - share key insights and next steps with the jury, and thank them for their participation.

#### Preparation

- Structure the sessions so that there is ample time for learning, deliberation, and cocreation. This could mean having multiple sessions that go in-depth on different topics or having longer sessions.
- Pilot the jury with a smaller sample of community members to work out the procedural and content issues prior to the actual sessions.

#### During the session

- Ensure that all perspectives are heard, including those of the project team and those of the jury members. This minimizes group-thinking as well as one or two individuals dominating the discussion.
- Reinforce the value of the juror participation by communicating the plan for integrating jury feedback into the product planning process. Ensure that the project team is prepared to hear criticisms from the jury.

### Jury members

These are direct and indirect stakeholders impacted by the technology, representative of the diverse community in which the technology will be deployed.

#### Sample size

A jury should be large enough to represent the diversity and collective will of the community, but not so large that the voices of quieter jurors are drowned out. It is ideal to get feedback from at least 16-20 individuals total who meet the criteria below. You can split the community jury over multiple sessions so that no more than 8-10 individuals are part of one session.

#### Recruitment criteria

Stratify a randomly selected participant pool so that the jury includes the demographic diversity of the community. Based on the project objectives, relevant recruitment criteria may include balancing across gender identity, age, [privacy index](#privacy-index). Recruitment should follow good user research recruitment procedures and reach a wider community.

## Session structure

Sessions typically last 2-3 hours. Add more or longer deep dive sessions, as needed, if aspects of the project require more learning, deliberation, and cocreation.

1. **Overview, introduction, and Q&A:** The moderator provides a session overview, then introduces the project team and explains the product's purpose, along with potential use cases, benefits, and harms. Questions are then accepted from community members. This session should be between 30 to 60 minutes long.

1. **Discussion of key themes:** Jury members ask in-depth questions about aspects of the project, fielded by the moderator. This session should also be between 30 to 60 minutes in length.

1. This step can be any one of the following options:

    - **Deliberation and cocreation:** This option is preferable. Jury members deliberate and co-create effective collaboration solutions with the project team. This is typically 30 to 60 minutes long.
    - **Individual anonymous survey:** Alternatively, conduct an anonymous survey of jury members. Anonymity may allow issues to be raised that would not otherwise be expressed. Use this 30-minute session if there are time constraints.

1. **Following the session:** The moderator produces a study report that describes key insights, concerns, and potential solutions to the concerns.

If the values of different stakeholders were in conflict with each other during the session and the value tensions were left unresolved, the product team would need to brainstorm solutions, and conduct a follow-up session with the jury to determine if the solutions adequately resolve their concerns.

## Tips to run a successful, effective, and collaborative jury

- Ensure alignment of goals and outcomes with the project team before planning begins, including deliverables, recruitment strategy, and timeline. Consider including additional subject-matter experts relevant to the project, to address open questions/concerns.
- The consent to audio and video recording of the jury should follow your company's standard procedures for non-disclosure and consent that is obtained from participants during user research studies.
- Provide fair compensation to participants for the time they devote to participation. Whenever possible, participants should also be reimbursed for costs incurred as a result of study participation, for example, parking and transportation costs. Experienced user research recruiters can help determine fair gratuities for various participant profiles.
- Ensure that all perspectives are heard, minimizing group-thinking as well as one or two individuals dominating the discussion. This should include those of the project team and the jury members.
- Structure the sessions so that there is ample time for learning, deliberation, and cocreation. This could mean having multiple sessions going in-depth on different topics or having longer sessions.
- Pilot the jury with a smaller sample of community members to work out the procedural and content issues prior to the actual sessions.
- If the topic being discussed is related to personal data privacy, aim to balance the composition of the community jury to include individuals with different [privacy indices](#privacy-index).
- Consider including session breaks and providing snacks/refreshments for sessions that are two hours or longer.
- Reinforce the value of the juror participation by communicating the plan for integrating jury feedback into the product planning process. Also ensure that the project team is prepared to hear criticisms from the jury.
- After the jury, in addition to publishing the research report, send out a thank you note to the volunteer participants of the jury,  along with an executive summary of the key insights.

## Additional information

### Privacy index

The [Privacy Index](http://reports-archive.adm.cs.cmu.edu/anon/anon/home/ftp/usr0/ftp/isri2005/CMU-ISRI-05-138.pdf) is an approximate measure for an individual's concern about personal data privacy, and is gauged using the following:

1. Consumers have lost all control over how personal information is collected and used by companies.
2. Most businesses handle the personal information they collect about consumers in a proper and confidential way.
3. Existing laws and organizational practices provide a reasonable level of protection for consumer privacy today.

Participants are asked to provide responses to the above concerns using the scale of: 1 - Strongly Agree, 2 - Somewhat Agree, 3 - Somewhat Disagree, 4- Strongly Disagree, and classified into the categories below.

High/Fundamentalist             =\> IF A = 1 or 2 AND B & C = 3 or 4

Low/unconcerned                 =\> IF A = 3 or 4 AND B & C = 1 or 2

Medium/pragmatist               =\> All other responses

## Next steps

Explore the following references for detailed information on this method:

- Jefferson center: creator of the Citizen's Jury method [https://jefferson-center.org/about-us/how-we-work/](https://jefferson-center.org/about-us/how-we-work/)
- Case study: [Connected Health Cities (UK)](https://connectedhealthcities.github.io/hub/ppi/connected-health-cities-citizens-juries-report.html)
- Case study: [Community Jury at Microsoft](https://hits.microsoft.com/Study/6014413)
