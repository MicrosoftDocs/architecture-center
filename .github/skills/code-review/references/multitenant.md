# Multitenant architecture review principles

Apply these principles to affected articles under `docs/guide/multitenant/` as directed by the [Copilot review skill](../SKILL.md#multitenant-architecture-guidance). They supplement the existing editorial and engineering checks.

## Distinguish application tenants from Microsoft Entra tenants

In this collection, a tenant is a group of users, customers, or other entities that share an application or service. A Microsoft Entra tenant is an identity and directory boundary. The concepts can be related, but they aren't interchangeable. See the [collection's terminology note](https://learn.microsoft.com/azure/architecture/guide/multitenant/overview).

- Flag assumptions that a multitenant application must support multiple Microsoft Entra tenants.
- Flag passages that conflate an application's tenant boundary with a Microsoft Entra directory boundary.
- Check that identity-specific guidance addresses a relevant architectural decision. Don't request Microsoft Entra guidance solely because an article discusses multitenancy.
- Keep Microsoft Entra guidance where identity architecture is relevant. Use the full term *Microsoft Entra tenant* when the distinction matters.

## Distinguish SaaS from multitenancy

SaaS is a business model. Multitenancy is an architectural approach that also applies to non-SaaS scenarios, such as an enterprise platform shared by internal teams. See [SaaS and multitenant solution architecture](https://learn.microsoft.com/azure/architecture/guide/saas-multitenant-solution-architecture/#key-concepts).

- Flag statements that make SaaS-specific requirements universal requirements for multitenancy.
- Prefer *tenant* over *customer* in general architectural guidance. *Customer* is appropriate when the context concerns customers.
- Keep general architectural recommendations applicable across business models. SaaS-specific examples and articles about commercial concerns, such as pricing models, are appropriate when their scope is clear.
- Non-SaaS examples can help demonstrate the collection's broader applicability. Don't require every article or pull request to add one, and don't raise a finding solely because all examples in an article concern SaaS.

## Keep the focus on multitenancy

The collection supplements product documentation with the additional decisions and constraints that arise when tenants share a solution. It should not repeat a service's general overview or feature inventory. See the [collection's scope](https://learn.microsoft.com/azure/architecture/guide/multitenant/overview#scope).

For each substantive section, identify the multitenancy decision or consequence it helps the reader understand. Relevant concerns include tenant isolation, resource sharing, allocation, scaling, noisy neighbors, governance, and tenant operations.

Ask: Would this guidance be equally relevant to a conventional single-tenant deployment? Use this question as a heuristic. Brief general explanations can establish context, but substantial generic product guidance should link to product documentation and explain its multitenancy implications.

When flagging scope drift, name the passage, explain why its multitenancy relevance is missing, and suggest either connecting it to a tenant-specific decision or replacing the generic detail with a product documentation link. Don't request a general product tutorial.

## Respect the guidance layer

Use the following paths as the starting point, then confirm the article's purpose from its title, introduction, and place in the [main TOC](../../../../docs/toc.yml). The [collection overview](../../../../docs/guide/multitenant/overview.md#whats-in-this-series) explains the three layers.

| Path relative to `docs/guide/multitenant/` | Layer | Review expectations |
| --- | --- | --- |
| `considerations/` | Considerations. | Evaluate high-level decisions, requirements, questions, and trade-offs. Worked examples are appropriate. Avoid demanding implementation details or a single product recommendation when the decision depends on requirements. |
| `approaches/` | Approaches. | Evaluate patterns and trade-offs across a technology category, such as compute, networking, or storage. Product examples can illustrate the principles. Strong recommendations are appropriate when supported by established architectural constraints. |
| `service/` | Service guides. | Evaluate a specific service's tenant isolation approaches, constraints, trade-offs, and features relevant to multitenancy. |

Collection and layer overviews, the checklist, and related-resource pages have their own purposes. Don't force them into a detailed service-guide structure. For shared includes and images, use the role of the article that consumes them. Read paired YAML metadata and content together.

### Considerations

Check that the article helps architects identify requirements, decisions, and trade-offs early in design.

- Preserve a high-level architectural perspective.
- Allow questions, worked examples, and multiple possible solutions.
- Flag unjustified universal prescriptions when the appropriate choice depends on the solution's requirements.
- Don't demand product-specific configuration, deployment steps, or an end-to-end implementation.

Use the [considerations overview](../../../../docs/guide/multitenant/considerations/overview-content.md) as context.

### Approaches

Check that recommendations apply across the technology category the article addresses.

- Explain patterns, their limitations, and when to choose them.
- Allow specific products as examples without making one product define the category's guidance.
- Flag changes that turn a category-level article into a guide for one service.
- Allow stronger recommendations where architectural constraints justify them. Don't weaken a supported recommendation merely to make every option sound equally suitable.

Use the [approaches overview](../../../../docs/guide/multitenant/approaches/overview.md) and [compute approaches](../../../../docs/guide/multitenant/approaches/compute.md) as examples of scope and abstraction.

### Service guides

Check for two kinds of architectural value, where applicable to the service:

1. **Tenant isolation approaches.** Explain applicable shared-resource, dedicated-resource, partitioned, or hybrid models. Compare their service-specific implications for isolation boundaries, limits and quotas, scaling, provisioning, noisy neighbors, and operational complexity. Don't invent models or imply that a service supports an isolation boundary without evidence.
1. **Features relevant to multitenancy.** Explain why each selected capability matters for tenant-specific decisions or operations, rather than only describing what the feature does.

A comparison table followed by subsections for each isolation approach, then feature-specific subsections, is an established structure. Diagrams can clarify the models. Use the [service overview](../../../../docs/guide/multitenant/service/overview.md) and [App Configuration guide](../../../../docs/guide/multitenant/service/app-configuration.md) as structural references and examples.

Provide a comparison table for the tenant isolation approaches unless there's a good reason to omit it, such as the service having only one applicable isolation approach. Otherwise, apply the structure flexibly. Don't require exact headings, diagrams, every possible feature, or a guide for every Azure service. Raise missing coverage when it leaves a relevant tenant isolation decision or service constraint unexplained, not merely because the article differs from an example.

Ground service capabilities and constraints through the `microsoft-learn-grounding` skill. Existing collection articles establish editorial intent and structure; they don't replace product-specific grounding.

## Calibrate findings

All documents in this collection are architecture guides. The considerations, approaches, and service-guide layers describe their roles within that content type. They aren't reference architectures, example scenarios, or solution ideas. Evaluate how well they explain architectural decisions and trade-offs at the appropriate layer; don't impose requirements for those other content types.

Apply the parent skill's first-pass and repeat-run scope and severity rules. On a first pass, assess the affected article as a whole; on repeat runs, focus on changes since the previous review and their consequences.

- **Raise actionable findings** for conflated tenant concepts, unjustified SaaS-only assumptions, substantial generic product content without multitenancy relevance, a mismatch with the article's guidance layer, or missing or incorrect isolation trade-offs that affect a reader's decision.
- **Treat preferences as advisory**, including the frequency of non-SaaS examples and exact service-guide headings or section order. A tenant isolation comparison table is expected unless there's a good reason to omit it. Don't create standalone review comments for advisory preferences without a concrete clarity or architectural consequence.
- **Adapt the general checks to the article's purpose.** Don't demand production reference-architecture coverage from these guides. Keep comparisons and alternatives beside the decisions they explain when that organization serves the article's layer; don't mechanically require a separate Alternatives section.
- **Make feedback specific.** Identify the passage, explain the consequence for an architect, and suggest a scoped correction. Use an inline suggestion when the exact replacement is justified. Don't manufacture findings or repeat the same issue under both the general and domain-specific checks.

### Calibration examples

| Contribution | Review response |
| --- | --- |
| "Each application tenant must have its own Microsoft Entra tenant." | Flag the unsupported equivalence and ask the author to distinguish application tenancy from identity-directory design. |
| An identity article explains how application tenants map to one or more Microsoft Entra tenants and states the relevant requirements. | Allow the identity-specific guidance; assess its technical claims through the normal grounding checks. |
| "Every tenant must have a commercial subscription and billing account." in general architecture guidance. | Flag the universal commercial assumption. Scope it to the relevant SaaS business model or describe the general tenant requirement. |
| A pricing-model article uses customers and commercial SaaS examples. | Allow terminology and examples that match the article's stated commercial scope. |
| A service guide adds a feature inventory with no connection to tenant decisions or operations. | Ask for the multitenancy implications or a link to the general product documentation instead of the inventory. |
| A service guide explains how a feature affects per-tenant allocation or isolation, with links to configuration details. | Allow the section when the service-specific claims are grounded. |
| A considerations article uses one worked example without prescribing it for all solutions. | Allow the example. Don't demand deployment instructions or a universal recommendation. |
| An approaches article uses a product to illustrate a category-wide isolation trade-off. | Allow the example. Flag it only if the recommendation incorrectly becomes specific to that product or universal across unlike services. |
| A service guide explains multiple isolation approaches without a comparison table and gives no good reason for omitting it. | Request a comparison table so readers can compare the approaches and their trade-offs. Allow omission when there's a good reason, such as only one applicable isolation approach. |
