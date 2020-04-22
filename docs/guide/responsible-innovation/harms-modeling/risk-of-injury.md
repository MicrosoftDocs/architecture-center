---
title: Risk of injury
titleSuffix: Azure Application Architecture Guide
description: Consider how technology could hurt people or create dangerous environments.
author: dcass
ms.date: 04/22/2020
ms.topic: guide
ms.service: architecture-center
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Type of harm: Risk of injury

Consider how technology could hurt people or create dangerous environments.

## Overreliance on safety features

Dependence on technology to make decisions without adequate human oversight.

- How might people rely on this technology to keep them safe?
- How could this technology reduce appropriate human oversight?

*Example: A healthcare agent could misdiagnose illness, leading to unnecessary treatment.*

## Inadequate fail-safes

Real-world testing which insufficiently considers a diverse set of users and scenarios.

- If this technology fails or is misused, how would people be impacted? At what point could a human intervene?
- Are there alternative uses that have not been tested for? How would users be impacted by a system failure?

*Example: If an automatic door failed to detect a wheelchair during an emergency evacuation a person could be trapped if there isn't an accessible override button.*

## Exposure to unhealthy agents

Manufacturing, as well as disposal of technology can jeopardize the health and well-being of workers and nearby inhabitants.

- What negative outcomes could come from the manufacturing of your components or devices?

*Example: Inadequate safety measures could cause workers to be exposed to toxins during digital component manufacturing.*

Emotional or psychological injury

Misused technology can lead to serious emotional and psychological distress.

## Overreliance on automation

Misguided beliefs can lead users to trust the reliability of a digital agent over that of a human.

- How could this technology reduce direct interpersonal feedback?
- How might this technology interface with trusted sources of information?
- How could sole dependence on an artificial agent impact a person?

*Example: A chat bot could be relied upon for relationship advice or mental health counseling instead of a trained professional.*

## Distortion of reality or gaslighting

When intentionally misused, technology can undermine trust and distort someone's sense of reality.

- Could this be used to modify digital media or physical environments?

*Example: An IoT device could enable monitoring and controlling of an ex-girlfriend from afar.*

## Reduced self-esteem/reputation damage

Some shared content can be harmful, false, misleading, or denigrating.

- How could this technology be used to inappropriately share personal information?
- How could it be manipulated to misuse information and misrepresent people?

*Example: Synthetic media "revenge porn" can swap faces, creating the illusion of a person participating in a video, who did not.*

## Addiction / attention hijacking

Designing for prolonged interaction with a technology, without regard for well-being.

- In what ways might this technology reward or encourage continued interaction beyond delivering user value?

*Example: Variable drop rates in video game loot boxes could cause players to keep playing and neglect self-care.*

## Identity theft

May lead to loss of control over personal credentials, reputation, and/or representation.

- How might an individual be impersonated with this technology?
- How might this technology mistakenly recognize the wrong individual as an authentic user?

*Example: Synthetic voice font could mimic the sound of a person's voice and be used to access a bank account*

## Misattribution

Crediting a person with an action or content that they are not responsible for.

- In what ways might this technology attribute an action to an individual or group?
- How could someone be affected if an action was incorrectly attributed to them?

*Example: Facial recognition can misidentify an individual during a police investigation.*

**Reference Docs**

- [Responsible AI resource center](../index.md)
- [Assessing harms](./index.md)
- [Assessing Harms booklet](downloadable)

**Next Steps**


- [Who may be impacted](./human-understanding.md)
- [Type of harm: Denial of consequential services](./denial-of-services.md)
- [Type of harm: Infringement on human rights](./human-rights.md)
- [Type of harm: Erosion of social & democratic structures](./democratic-structures.md)