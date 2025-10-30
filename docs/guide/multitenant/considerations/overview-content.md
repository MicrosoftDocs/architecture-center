When you're considering a multitenant architecture, there are several decisions you need to make and elements you need to consider.

In a multitenant architecture, you share some or all of your resources between tenants. This process means that a multitenant architecture can give you cost and operational efficiency. However, multitenancy introduces complexities. You need to ask yourself the following questions:

- How do you define what a *tenant* is, for your specific solution? Does a tenant correspond to a customer, a user, or a group of users like a team or a family?
- How will you deploy your infrastructure to support multitenancy, and how much isolation will you have between tenants?
- What commercial pricing models will your solution offer, and how will your pricing models affect your multitenancy requirements?
- What level of service do you need to provide to your tenants, across dimensions like performance, resiliency, security, and compliance requirements like data residency?
- How do you plan to grow your business or solution? Will it scale to the number of tenants you expect?
- Do any of your tenants have unusual or special requirements? For example, does your biggest customer need higher performance or stronger guarantees than others?
- How will you monitor, manage, automate, scale, and govern your Azure environment, and how will multitenancy affect your management strategy?
- Which components of your solution handle tenant onboarding and management, and how should these components be designed?

Whatever your architecture, it's essential that you have a clear understanding of your customers' or tenants' requirements. If you have made sales commitments to customers, or if you have contractual obligations or compliance requirements to meet, then you need to know what those requirements are when you architect your solution. But equally, your customers might have implicit expectations about how things *should* work, or how you *should* behave, which could affect the way you design a multitenant solution.

As an example, imagine you're building a multitenant solution that you sell to businesses in the financial services industry. Your customers have very strict security requirements, and they need you to provide a comprehensive list of every domain name that your solution uses, so they can add it to their firewall's allowlist. This requirement affects the Azure services you use and the level of isolation that you have to provide between your tenants. They also require that their solution has a minimum level of resiliency. There might be many similar expectations, both explicit and implicit, that you need to consider across your whole solution.

In this section, we outline some of the considerations that you should give, the requirements you should elicit, and some of the tradeoffs you need to make, when you are planning a multitenant architecture.

## Intended audience

The articles in this section are particularly relevant for technical decision-makers, like chief technology officers (CTOs) and architects, as well as product managers. The audience also includes independent software vendors (ISVs) and startups who develop SaaS solutions. Additionally, anyone who works with multitenant architectures should have some familiarity with these principles and tradeoffs.

## Next steps

Consider different [tenancy models](tenancy-models.md) for your solution.
