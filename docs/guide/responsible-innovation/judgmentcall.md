---
title: Judgment Call
titleSuffix: Azure Application Architecture Guide
description: Learn about Judgment Call, which is a team-based activity that puts Microsoft AI principles into action.
author: dcass
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
azureCategories: developer-tools
categories: developer-tools
products: azure
ms.custom:
  - guide
---

# Judgment Call

Judgment Call is an award-winning game and team-based activity that puts Microsoft's AI principles of fairness, privacy and security, reliability and safety, transparency, inclusion, and accountability into action. The game provides an easy-to-use method for cultivating stakeholder empathy by imagining their scenarios. Game participants write product reviews from the perspective of a particular stakeholder, describing what kind of impact and harms the technology could produce from their point of view.

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://www.youtube.com/embed/LXqlAXEMGI0]

<!-- markdownlint-enable MD034 -->

## Benefits

Technology builders need practical methods to incorporate ethics in product development, by considering the values of diverse stakeholders and how technology may uphold or not uphold those values. The goal of the game is to imagine potential outcomes of a product or platform by gaining a better understanding of stakeholders, and what they need and expect.

The game helps people discuss challenging topics in a safe space within the context of gameplay, and gives technology creator a vocabulary to facilitate ethics discussions during product development. It gives managers and designers an interactive tool to lead ethical dialogue with their teams to incorporate ethical design in their products.

The theoretical basis and initial outcomes of the Judgment Call game were presented at the 2019 ACM Design Interactive Systems conference and the game was a finalist in the Fast Company 2019 Innovation by Design Awards (Social Goods category). The game has been presented to thousands of people in the US and internationally. While the largest group facilitated in game play has been over 100, each card deck can involve 1-10 players. This game is not intended to be a substitute for performing robust user research. Rather, it's an exercise to help tech builders learn how to exercise their moral imagination.

## Preparation

Judgment Call uses role play to surface ethical concerns in product development so players will anticipate societal impact, write product reviews, and explore mitigations. Players think of what kind of harms and impacts the technology might produce by writing product reviews from the point of view of a stakeholder.

To prepare for this game, download the [printable Judgment Call game kit](https://download.microsoft.com/download/3/3/d/33da5224-fb6e-4591-827d-9c2bd9ac47c2/JudgmentCall_printable.pdf).

## During the Game

The players are expected to go through the following steps in this game:

1. **Identify the product**

    Start by identifying a product that your team is building, or a scenario you are working on. For example, if your team is developing synthetic voice technology, your scenario could be developing a voice assistant for online learning.

1. **Pass the cards**

    Once you have decided on the scenario, pass out the cards. Each player receives a stakeholder card, an ethical principle card, a rating card, and a review form. The following is a description of these cards:

      - **Stakeholder:** This represents the group of people impacted by the technology or scenario you've chosen. Stakeholders can also include the makers (those proposing and working on the technology) as well as the internal project sponsors (managers and executives who are supportive of the project).

      - **Principle:** This includes Microsoft's ethical principles of fairness, privacy and security, reliability and safety, transparency, inclusion, and accountability.

      - **Rating:** Star cards give a rating: 1-star is poor, 3-star is mediocre, 5-star is excellent.

1. **Brainstorm and identify stakeholders**

    As a group, brainstorm all the stakeholders that could be directly or indirectly affected by the technology. Then assign each player a stakeholder from the list. In some cases, the Judgment Call decks may have pre-populated stakeholder cards, but players can add additional cards relevant to their situation.

    The deck provides following categories of stakeholders:

      - **Direct:** These use the technology and/or the technology is used on them.

      - **Indirect:** These feel the effects of the technology.

      - **Special populations:** A wide range of categories that includes those who cannot use the technology or choose not to use it, and organizations that may be interested in its deployment like advocacy groups or the government.

    There are a range of harms that can be felt or perpetuated onto each group of stakeholder. Types of stakeholders can include end users of the product, administrators, internal teams, advocacy groups, manufacturers, someone who might be excluded from using the product. Stakeholders can also include the makers who propose and work on the technology, as well as the internal project sponsors, that is, the managers and executives who are supportive of the project.

1. **Moderator selection**

    The moderator describes scenarios for gameplay, guides discussion, and collects comment cards at the end. They will also give an overview of the ethical principles considered in the deck.

1. **Presentation of a product**

    The moderator introduces a product, real or imaginary, for the players to role play. They can start with questions about the product with prompts such as:

      - Who will use the product?

      - What features will it have?

      - When will it be used?

      - Where will it be used?

      - Why is it useful?

      - How will it be used?

 1. **Writing reviews**

    Players each write a review of the product or scenario based on the cards they've been dealt. Players take turns reading their reviews aloud. Listen carefully for any issues or themes that might come up. Take note of any changes you might make to your product based on insights discussed.

      - The stakeholder card tells them who they are for the round.

      - The ethical principle card is one of the six Microsoft AI principles; it tells them what area they're focusing on in their review.

      - The rating card tells them how much their stakeholder likes the technology (1, 3, or 5 stars).

    The player then writes a review of the technology, from the perspective of their stakeholder, of why they like or dislike the product from the perspective of the ethical principle they received.

## Discussion

The moderator has each player read their reviews. Everyone is invited to discuss the different perspectives and other considerations that may not have come up.

Potential moderator questions include:

- Who is the most impacted?

- What features are problematic?

- What are the potential harms?

## Harms mitigation

Finally, the group picks a thread from the discussion to begin identifying design or process changes that can mitigate a particular harm. At the end of each round, the decks are shuffled, and another round can begin with the same or a different scenario.

## Next steps

Once you have enough understanding of potential harms or negative impact your product or scenario may cause, proceed to learn [how to model these harms](./harms-modeling/index.md) so you can devise effective mitigations.
