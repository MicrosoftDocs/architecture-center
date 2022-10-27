---
title: Conduct a proof of concept or pilot
titleSuffix: Azure Architecture Center
description: Conduct a Proof of Concept or pilot and manage change during serverless adoption with Azure Functions.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: developer-tools
products:
  - azure-functions
ms.custom:
  - fcp
  - guide
---
# Proof of concept or pilot

When driving a technical and security decision for your company or customer, a *Proof of Concept (PoC)* or *pilot* is an opportunity to deliver evidence that the proposed solution solves the business problems. The PoC or pilot increases the likelihood of a successful adoption.

A PoC:
- Demonstrates that a business model or idea is feasible and will work to solve the business problem
- Usually involves one to three features or capabilities
- Can be in one or multiple technologies
- Is geared toward a particular scenario, and proves what the customer needs to know to make the technical or security decision
- Is used only as a demonstration and won't go into production
- Is IT-driven and enablement-driven

A pilot:
- Is a test run or trial of a proposed action or product
- Lasts longer than a PoC, often weeks or months
- Has a higher return on investment (ROI) than a PoC
- Builds in a pre-production or trial environment, with the intent that it will then go into production
- Is adoption-driven and consumption-driven

## PoC and pilot best practices

Be aware of compliance issues when working in a customer's environment, and make sure your actions are always legal and compliant.
- Touching or altering the customer's environment usually requires a contract, and may involve a partner or Microsoft services. Without a contract, your company may be liable for issues or damages.
- Governance may require Legal department approval. Your company may not be able to give away intellectual property (IP) for free. You may need a legal contract or contracts to specify whether your company or the customer pays for the IP.
- Get disclosure guidance when dealing with non-disclosure agreements (NDAs), product roadmaps, NDA features, or anything not released to the general public.
- In a pilot, don't use a trial Microsoft Developers Network (MSDN) environment, or any environment that you own.
- Use properly licensed software, and ask the opportunity owner to make sure to handle software licensing correctly.

The customer, partner, or your company may pay for the PoC or pilot. Depending on the size of the contract, the ROI, and the cost of sale, one group may cover it all, or a combination of all three parties may cover the cost. Ensure that your company or customer has some investment in the PoC or pilot. If they don't, this can be a red flag signaling that your company or customer doesn't yet see value in the solution.

## PoC and pilot process
The Technical Decision Maker (TDM) is responsible for driving an adoption decision. The TDM is responsible for ensuring that the right partners and resources are involved in a PoC or pilot. As a TDM, make sure you're aware of the partners in your product and service area or region. Be aware of their key service offerings around your product service area.

### Planning
Consider the following health questions:
- Do you have a good technical plan, including key decision makers and Microsoft potential?
- Can you deliver the needed assurance without a PoC?
- Should you switch to a pilot?
- What are the detailed scope and decision criteria your team or customer agreed to?
- If you meet the criteria, will your company or customer buy or deploy the solution?

Do the following tasks:
- Analyze risk.
- Evaluate the setting.
- Do the preparation.
- Consider workloads and human resources.
- Present PoC or pilot health status.
- Fulfill technical prerequisites.
- Define the go/no go decision.
- Create a final project plan specification.

### Execution
For the execution phase:
- Determine who kicks off the presentation.
- Schedule the meeting in the morning, if possible.
- Prepare the demos and slides.
- Conduct a dry run to refine the presentation.
- Get feedback.
- Involve your company or customer team.
- Complete the win/lose statement.

### Debriefing
During the debriefing phase, consider:
- Whether criteria were met or not met
- Stakeholder investment
- Initiating deployment
- Finding a partner and training
- Lessons learned
- Corrections or extensions of PoC or pilot guidance
- Archiving of valuable deliverables

## Change management
Change management uses tested methods and techniques to avoid errors and minimize impact when administering change.

Ideally, a pilot includes a cross-section of users, to address any potential issues or problems that arise. Users may be comfortable and familiar with their old technology, and have difficulty moving into new technical solutions. Change management keeps this in mind, and helps the user understand the reasons behind the change and the impact the change will make.

This understanding is part of a pilot, and addresses everyone who has a stake in the project.  A pilot is better than a PoC, because the customer is more involved, so they're more likely to implement the change.

The pilot includes a detailed follow-up through surveys or focus groups. The feedback can prove and improve the change.

## Next steps

- [Execute an application assessment](application-assessment.md)
- [Promote a technical workshop or training](technical-training.md)
- [Code a technical implementation with the team or customer](code-with.md)

## Related resources
[Prosci® change management training](https://www.prosci.com/solutions/training-programs/virtual-change-management-certification-program)
