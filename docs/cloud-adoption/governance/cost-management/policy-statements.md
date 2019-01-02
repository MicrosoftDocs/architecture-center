---
title: "Fusion: Cost management sample policy statements"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Cost management sample policy statements

The following policy statements provide examples of that could mitigate specific business risks through design guidance and the implementation of specific tools for cost governance montoring & enforcement.

## Future Proof

**Business Risk:** Current criteria doesn't warrant an investment in a Cost Management Discipline from the governance team. However, such an investment is anticipated in the future.

**Policy Statement:** All assets deployed to the cloud should be associated with a billing unit, application/workload, and meet naming standards. This policy will ensure that future cost management efforts will be effective. 

**Design Guidance:** For guidance on establishing a future proofed foundation, see the [design guide for Cloud Native deployments](../design-guides/future-proof.md).

## Budget Overrun

If overspending is a significant concern, implement tooling with the cloud provider to limit spending for each billing unit. This will align forecasts with a budgetary spending limit that can't be easily exceeded. One policy statement to mitigate this risk, is asserting that any assets deployed to the cloud must be aligned to a billing unit, with approved budget, and a mechanism for budgetary limits. In a Microsoft context, Azure Cost Management and/or Azure Policy could be used to enforce this policy automatically.

## Under Utilization

If waste is a concern, implement a monitoring solution to report on any underutilized assets. This will identify opportunities to reduce waste and tighten spending. The corporate policy could state that all deployed assets must be registered with a solution that can monitor usage and report on any under utilization. In a Microsoft context, Azure Advisor could be used to provide this type of feedback.

## Poor user experience

If user experience is more important than asset costs, the opposite type of policy may be important for some assets. For instance, the policy may state that any asset that hosts a customer facing web or mobile property must scale to meet performance SLAs. Requiring scale sets for any asset with port 80 open would enforce such a policy. Azure Policy and Azure Blueprints could help enforce the rule in an Azure environment.  

## Next steps

Use these sample policies as a starting point to develop policies that address specific business risks aligned with your cloud adoption plans.

To begin developing your own custom policy statements related to cost management, download the [Cost Management Template](template.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns. Then modify that design to incorporate specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)