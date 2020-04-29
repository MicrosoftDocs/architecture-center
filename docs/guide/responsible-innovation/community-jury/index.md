---
title: Community Jury
titleSuffix: Azure Application Architecture Guide
description: This technique allows project teams to understand the perceptions and concerns of stakeholders.
author: dcass
ms.date: 04/22/2020
ms.topic: guide
ms.service: architecture-center
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Community Jury

Community jury, an adaptation of the [citizen jury](https://jefferson-center.org/about-us/how-we-work/), is a technique where diverse stakeholders impacted by a technology are provided an opportunity to learn about a project, deliberate together, and give feedback on use cases and product design. This technique allows project teams to understand the perceptions and concerns of impacted stakeholders.

A Community jury is different from a focus group or market research in that it co-creates solutions with a product team and delivers a consensus and recommendation at its conclusion.

## Benefits

### Expert Testimony

Members of a community jury hear details about the technology under consideration directly from experts on the product team who help highlight the capabilities in particular applications.

### Proximity

A community jury allows decision-makers to hear directly from the community, and to learn about their values, concerns and ideas regarding a particular issue or problem. It also provides a valuable opportunity to better understand the reasons for their conclusions. 

### Consensus

By bringing impacted individuals together and providing an opportunity for them to learn and discuss key aspects of the technology, a Community Jury can identify areas of agreement and build common ground solutions to challenging problems.

## Community jury contributors

### Product Team

This group comprises owners who will bring the product to market, representative project managers, engineers, designers, data scientists, and others involved in the making of a product. Additionally, subject matter experts are included that can answer in-depth questions about the product.

#### Preparation

Effective deliberation and co-creation requires ready answers to technical questions. As product owners, it is important to ensure technical details are collected prior to the start of the jury session.

Relevant artifacts could include:

- Documentation of existing protections, planned or in place
- Data Flows (e.g. what data types collected, who will have access, for how long, with what protections, etc.)
- Mockups or prototypes of proposed solutions

#### During the Session

Along with providing an accessible presentation of technical details, product team witnesses should describe certain applications of the technology.

Relevant artifacts could include:

- Customer benefits
- Harms assessment and socio-technical impact
- Storyboards
- Competitive analyses
- Academic or popular media reports

### Moderator

Bring on a neutral user researcher to ensure everyone is heard, avoiding domination of the communications by any one member. The moderator will facilitate brainstorms and deliberations, as well as educating jury members in uncovering bias, and ways to ask difficult questions. If a neutral user researcher is not available, choose a moderator who is skilled at leading group discussions. Following the session, the moderator is responsible for the following steps: ensure that the agreed-upon compensation is provided to the jury members; send notes to the jury members thanking them for their time and communicating next steps, and produce a summary report uncovering key insights, concerns and recommendations that emerged from the session.

#### Preparation

- Structure the sessions so that there is ample time for learning, deliberation, and co-creation. This could mean having multiple sessions that go in-depth on different topics or having longer sessions.
- Pilot the jury with a smaller sample of community members to work out the procedural and content issues prior to the actual sessions. 

#### During the Session

- Ensure that all perspectives are heard (minimizing group-thinking as well as one or two individuals dominating the discussion), including those of the project team and those of the jury members.
- Reinforce the value of the juror participation by communicating the plan for integrating jury feedback into the product planning process. Also ensure that the project team is prepared to hear criticisms from the jury.

### Jury members

These are direct and indirect stakeholders impacted by the technology, representative of the diverse community in which the technology will be deployed.

#### Sample size

A jury should be large enough to represent the diversity and collective will of the community, but not so large that the voices of quieter jurors are drowned out. It is ideal to get feedback from at least 16-20 individuals total who meet the criteria below. You can split the community jury over multiple sessions so that no more than 8-10 individuals are part of one session

#### Recruitment criteria

Stratify a randomly selected participant pool so that the jury includes the demographic diversity of the community. Based on the project objectives, relevant recruitment criteria may include balancing across gender identity, age, privacy index (see Appendix for how this is defined). Recruitment should follow good user research recruitment procedures and reach a wider community.

## Session structure

Sessions typically last 2-3 hours. Add more or longer deep dive sessions, as needed, if aspects of the project require more learning, deliberation, and co-creation.

1. **Overview, introduction, and Q&A** - The moderator provides a session overview, then introduces the project team and explains the product's purpose, along with potential use cases, benefits, and harms. Questions are then accepted from community members. This session should be between 30 to 60 minutes long.

1. **Discussion of key themes** - Jury members ask in-depth questions about aspects of the project, fielded by the moderator. This session should also be between 30 to 60 minutes in length.

1. This step can be any one of the followin options:
  
    - **Deliberation and co-creation** - This option is preferable. Jury members deliberate and co-create solutions with the project team. This is typically 30 to 60 minutes long.
    - **Individual anonymous survey** - Alternatively, conduct an anonymous survey of jury members. Anonymity may allow issues to be raised that would not otherwise be expressed. Use this 30 minute long session if there are time constraints.

1. **Following the Session** - Ideally, the different value tensions among jury participants are resolved during the deliberation session. However, if those tensions are not resolved, the product team can continue to iterate after the session to develop additional resolution ideas, then reach back to the jury members to gauge if their concerns are adequately addressed.

## Tips to run a successful jury

- Ensure alignment of goals and outcomes with the project team before planning begins (including deliverables, recruitment strategy, and timeline). Consider including additional subject-matter experts who may be relevant to the project to address open questions/concerns.
- The consent to audio and video recording of the jury should follow your company's standard procedures for non-disclosure and consent that is obtained from participants during user research studies.
- Provide fair compensation to participants for their time. A recruiter can help determine fair compensation practices and related issues such as accounting for travel. For example, fair compensation is typically $150 for a one- to two-hour session, however highly specialized occupations in medicine, science and technology may need a higher compensation rate.
- Ensure that all perspectives are heard (minimizing group-thinking as well as one or two individuals dominating the discussion), including those of the project team and those of the jury members.
- Structure the sessions so that there is ample time for learning, deliberation, and co-creation. This could mean having multiple sessions going in-depth on different topics or having longer sessions.
- Pilot the jury with a smaller sample of community members to work out the procedural and content issues prior to the actual sessions.
- If the topic being discussed is related to personal data privacy, aim to balance the composition of the community jury to include individuals with different privacy indices (see Appendix).
- Consider including session breaks and providing snacks/refreshments for sessions that are two hours or longer.
- Reinforce the value of the juror participation by communicating the plan for integrating jury feedback into the product planning process. Also ensure that the project team is prepared to hear criticisms from the jury.
- After the jury, in addition to publishing the research report, send out a thank you note to those who volunteered to participate in the jury along with an executive summary of the key insights. (see Appendix).

## Additional information

### Privacy Index

The [Privacy Index](http://reports-archive.adm.cs.cmu.edu/anon/anon/home/ftp/usr0/ftp/isri2005/CMU-ISRI-05-138.pdf) is an approximate measure for an individual's concern about personal data privacy and is gauged using the three questions below:

1. Consumers have lost all control over how personal information is collected and used by companies.
2. Most businesses handle the personal information they collect about consumers in a proper and confidential way.
3. Existing laws and organizational practices provide a reasonable level of protection for consumer privacy today.

Participants are asked to provide Reponses to the questions above using the following scale (1 - Strongly Agree, 2 - Somewhat Agree, 3 - Somewhat Disagree, 4- Strongly Disagree) and classified into the categories below.

High/Fundamentalist             =\> IF A = 1 or 2 AND B & C = 3 or 4

Low/unconcerned                   =\> IF A = 3 or 4 AND B & C = 1 or 2

Medium/pragmatist                =\> All other responses

## Next steps

Explore the following references for detailed information on this method:

- Jefferson center: creator of the Citizen's Jury method [https://jefferson-center.org/about-us/how-we-work/](https://jefferson-center.org/about-us/how-we-work/)
- Citizen's jury handbook [http://www.rachel.org/files/document/Citizens\_Jury\_Handbook.pdf](http://www.rachel.org/files/document/Citizens_Jury_Handbook.pdf)
- Case study: Connected Health Cities (UK)
  - [Project page](https://www.connectedhealthcities.org/chc-hub/public-engagement/citizens-juries-chc/citizens-jury-2018/)
  - [Final report](https://www.connectedhealthcities.org/wp-content/uploads/2018/08/Reasonable-expectations-jury-report-v1.0-FINAL-09.08.18.pdf)
  - [Jury specification](https://www.connectedhealthcities.org/wp-content/uploads/2018/06/A1-Reasonable-expectations-citizens-jury-specification-v1.pdf)
  - [Juror's report](https://www.connectedhealthcities.org/wp-content/uploads/2018/06/C1-NDG-CJ-jurors-report-final.pdf)
- Case study: [Community Jury at Microsoft](https://hits.microsoft.com/Study/6014413)

