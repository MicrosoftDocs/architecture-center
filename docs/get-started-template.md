# Get Started Page Template for Azure Architecture Center Categories

This template provides a standardized, research-based structure for creating "Get Started" pages across all Azure Architecture Center categories. It is based on comprehensive analysis of 12 existing "Get started" pages and identifies common patterns, variations, and best practices.

## Executive Summary

### Purpose
Create consistent, high-quality "Get started" pages that help users navigate from learning to production implementation across all Azure categories.

### Key Standardizations
- **8 REQUIRED sections** all pages must have
- **11 OPTIONAL sections** to use based on category complexity
- **Consistent section naming** to reduce cognitive load
- **Three template types** for different category complexities
- **Clear decision framework** for which sections to include

---

## Comparative Analysis of Existing "Get Started" Pages

### Section Name Comparison Across 12 Categories

| Section Purpose | Analytics | Compute (HPC) | Containers (AKS) | DevOps | Hybrid | Identity | Integration | Mgmt & Gov | Migration | Security | Storage | Virtual Desktop |
|----------------|-----------|---------------|------------------|--------|--------|----------|-------------|------------|-----------|----------|---------|-----------------|
| **Introduction** | ✓ Paragraphs | ✓ + Video | ✓ + Journey diagram | ✓ Paragraphs | ✓ Paragraphs | ✓ (in content) | ✓ (in content) | ✓ + Services list | ✓ + Services list | ✓ (in content) | ✓ + Services list | ✓ + Solutions list |
| **Learning** | "Learn about Analytics" | — | "Introduction to AKS" | "Introduction to DevOps" | "Learn about hybrid" | "Learn about Identity" | "Learn about Integration" | "Introduction to management" | "Introduction to migration" | "Learn about Security" | "Introduction to storage" | "Introduction to virtual desktop" |
| **Org Readiness** | ✓ CAF + WAF | — | — | — | — | — | — | — | — | — | — | — |
| **Production** | "Path to production" | **"Implementation checklist"** | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" | "Path to production" |
| **Best Practices** | ✓ | (in checklist) | ✓ | ✓ + Guides | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ (per service) | ✓ |
| **Operations** | — | — | **"Operations guide"** (Day-2) | — | — | — | — | — | — | — | — | — |
| **Stay Current** | — | — | ✓ Roadmap | ✓ | — | — | — | ✓ | ✓ | — | ✓ | ✓ |
| **Additional** | ✓ Comprehensive | — | ✓ | ✓ | ✓ | — | — | ✓ | ✓ | — | ✓ (per service) | ✓ (per category) |
| **Cloud Compare** | ✓ AWS/GCP | — | ✓ AWS/GCP | ✓ AWS/GCP | — | — | — | ✓ AWS/GCP | ✓ AWS/GCP | — | ✓ AWS/GCP | ✓ AWS |

### Key Findings

#### 🔴 CRITICAL: Missing from Most Pages
1. **"Organizational readiness" (CAF + WAF)** - Only in Analytics
2. **"Stay current"** - Missing from 6 of 12 pages
3. **Standardized section names** - 11 different variations for "Learning" section

#### ⚠️ IMPORTANT: Major Variations
1. **"Implementation checklist" vs "Path to production"**
   - Compute uses checkbox format (unique)
   - All others use link lists
   - **Decision needed**: Support both or standardize?

2. **"Operations guide"** - Only in Containers (AKS)
   - Comprehensive Day-2 operations guidance
   - **Decision needed**: Add to other infrastructure categories?

3. **Best practices organization**
   - General list (most common)
   - Topic-organized (some)
   - Service-specific (Storage, Virtual Desktop)

---

## Standardized Template Structure

### REQUIRED Sections (All categories MUST have)

```
1. Introduction to {Category} on Azure
2. Learn about {Category} on Azure
3. Organizational readiness
4. Path to production OR Implementation checklist
5. Best practices
6. Stay current with {Category}
7. Additional resources
8. AWS or Google Cloud professionals (if comparison docs exist)
```

### OPTIONAL Sections (Use when appropriate)

```
- Architecture diagram (recommended for all)
- Service list in introduction (for multi-service categories)
- Learning paths by role (for complex categories)
- Implementation checklist (for infrastructure categories)
- Operations guide (for Day-2 operations)
- Service-specific subsections (for Storage, Mgmt & Governance)
- Hybrid scenarios (if commonly hybrid)
- Industry-specific solutions (if notable implementations)
- Contributors section
- Next steps section
- Related resources section
```

---

## Template Types by Category Complexity

### Type A: Simple (Identity, Hybrid, Integration, Security)
**Structure**: Introduction → Learn → Org Readiness → Path to Production → Best Practices → Stay Current → Additional Resources → Cloud Compare

**When to use**: Cross-cutting concerns, development practices

### Type B: Comprehensive (Analytics, DevOps, Migration)
**Structure**: Type A + Specialized topics subsections + Industry solutions

**When to use**: Platform services with broad applicability

### Type C: Complex Infrastructure (Compute, Containers, Networking)
**Structure**: Introduction + Video → Implementation Checklist → Infrastructure Details → Management → Operations Guide → Best Practices → Stay Current → Additional Resources

**When to use**: Infrastructure-heavy categories with significant Day-2 operations

### Type D: Multi-Service (Storage, Virtual Desktop, Mgmt & Governance)
**Structure**: Introduction + Services → Learn → Path to Production → Service-specific subsections → Stay Current → Additional Resources

**When to use**: Categories with 3+ distinct services

---

## Decision Matrix

### Which Template Type to Use?

| Category Type | Template | Use Checklist | Use Ops Guide | Example |
|--------------|----------|---------------|---------------|---------|
| **Complex infrastructure** | Type C | ✓ Yes | ✓ Yes | Compute, Containers, Networking |
| **Platform services** | Type B | ✗ No | Maybe | Analytics, Databases, AI/ML |
| **Development practices** | Type A | ✗ No | ✗ No | DevOps, Security |
| **Cross-cutting** | Type A | ✗ No | ✗ No | Hybrid, Identity, Integration |
| **Multiple services** | Type D | Maybe | Maybe | Storage, Mgmt & Gov, Virtual Desktop |

### Which Sections to Include?

| Section | When to Include |
|---------|----------------|
| **Architecture diagram** | All categories (recommended) |
| **Services list** | 3+ distinct services in category |
| **Video** | Complex topics needing visual explanation |
| **Learning by role** | 3+ distinct user personas |
| **Implementation checklist** | Complex infrastructure setup |
| **Operations guide** | Significant ongoing operations |
| **Service subsections** | 3+ distinct services |
| **Hybrid scenarios** | Common hybrid deployments |
| **Industry solutions** | 5+ industry-specific implementations |

---

## File Structure and Naming

### File Naming Convention
- **YAML file**: `solution-ideas/articles/{category-name}-start-here.yml`
- **Content file**: `solution-ideas/articles/{category-name}-start-here-content.md`
- **Images**: `docs/_images/{category-name}-get-started-diagram.svg`
- **Thumbnail**: `docs/browse/thumbs/{category-name}-get-started-diagram-thumb.png`

### YAML File Template

```yaml
### YamlMime:Architecture
metadata:
  title: {Category} Architecture Design
  description: Get an overview of Azure {category} technologies, guidance offerings, solution ideas, and reference architectures.
  author: {github-username}
  ms.author: {microsoft-alias}
  ms.date: {mm/dd/yyyy}
  ms.topic: conceptual
  ms.service: azure-architecture-center
  ms.subservice: architecture-guide
  ms.custom: fcp
azureCategories:
  - {primary-category}
  - {secondary-category}
products:
  - {primary-azure-product}
  - {secondary-azure-product}
  - {tertiary-azure-product}
name: {Category} architecture design
summary: Get an overview of Azure {category} technologies, guidance offerings, solution ideas, and reference architectures.
thumbnailUrl: /azure/architecture/browse/thumbs/{category-name}-get-started-diagram-thumb.png
content: |
  [!INCLUDE[]({category-name}-start-here-content.md)]
```

---

## Content File Template

### Template Structure

```markdown
<!-- 
Don't add metadata to this Markdown file.
The YAML file contains the metadata. 
-->

<!-- Add a brief introductory paragraph with no heading. -->

[2-3 sentence opening paragraph describing the category and its business value]

[Second paragraph explaining trends and why organizations adopt Azure for this category]

Whether your organization is just starting to evaluate cloud-based {category} tools or is looking to expand your current implementation, Azure provides many options. The workflow starts with learning about common approaches and aligning processes and roles around a cloud mindset.

[OPTIONAL - For multi-service categories:]
These are some of the key {category} services available on Azure:

- [Azure Service 1](/azure/{service}). Brief description.
- [Azure Service 2](/azure/{service}). Brief description.
- [Azure Service 3](/azure/{service}). Brief description.

## Architecture

<!-- This section is optional but recommended. Use the following format: -->

:::image type="complex" border="false" source="../images/{category-name}-get-started-diagram.svg" alt-text="Diagram that shows the {category} solution journey on Azure." lightbox="../images/{category-name}-get-started-diagram.svg":::
   Diagram showing the solution journey for {category} on Azure. The journey starts with learning and organizational readiness, then moves to choosing appropriate Azure services, followed by implementation best practices and production deployment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/{category-name}-get-started-diagram.vsdx) of this architecture.*

## Learn about {Category} on Azure

If you're new to {category} on Azure, the best place to learn more is with [Microsoft Learn](/training/?WT.mc_id=learnaka), a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on your job role, such as developer or data analyst.

Here are some [resources|learning paths and modules] to get you started:

- [Browse Azure {category} topics](/training/browse/?products=azure&terms={search-terms})
- [Learning path: {Path name}](/training/paths/{path-id})
- [Module: {Module name}](/training/modules/{module-id})
- [Module: {Module name}](/training/modules/{module-id})

[OPTIONAL - For complex categories with multiple roles:]

### Learning paths by role

- **{Role 1}**: [{Learning path name}](/training/paths/{path-id})
- **{Role 2}**: [{Learning path name}](/training/paths/{path-id})
- **{Role 3}**: [{Learning path name}](/training/paths/{path-id})

## Organizational readiness

If your organization is new to the cloud, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) can help you get started. This collection of documentation and best practices offers proven guidance from Microsoft designed to accelerate your cloud adoption journey.

[OPTIONAL - Add 1-3 category-specific CAF links:]

Specific guidance for {category} includes:

- [{CAF topic 1}](/azure/cloud-adoption-framework/{path})
- [{CAF topic 2}](/azure/cloud-adoption-framework/{path})
- [{CAF topic 3}](/azure/cloud-adoption-framework/{path})

To help assure the quality of your {category} solution on Azure, we recommend following the [Azure Well-Architected Framework](/azure/well-architected/). It provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

[OPTIONAL - Add category-specific WAF links:]

For {category}-specific guidance:

- [Azure Well-Architected Framework for {workload type}](/azure/well-architected/{path})
- [{Pillar} for {category} workloads](/azure/well-architected/{path})

---

## OPTION A: Implementation checklist
<!-- Use for complex infrastructure categories: Compute, Containers, Networking -->

As you're looking to implement your own {category} solution on Azure, ensure you've reviewed the following topics:

> [!div class="checklist"]
>
> - Choose the appropriate [architecture](#topic-1) based on your requirements
> - Know which [compute/service](#topic-2) options are right for your workload
> - Identify the right [storage/networking](#topic-3) solution that meets your needs
> - Decide how you're going to [manage](#topic-4) all your resources
> - Optimize your [application](#topic-5) for the cloud
> - [Secure](#topic-6) your infrastructure

### Topic 1: {Topic name}

[Detailed explanation with bullet points or subsections]

#### Subtopic

[Content with links to relevant documentation]

- [Link 1](/azure/{path})
- [Link 2](/azure/{path})

### Topic 2: {Topic name}

[Continue for each checklist item...]

---

## OPTION B: Path to production
<!-- Use for most categories: Platform services, development practices, cross-cutting -->

[1-2 sentences describing key decisions and first steps]

Key decision points include:

- **Decision area 1**: Options and trade-offs to consider
- **Decision area 2**: Factors that influence your choice
- **Decision area 3**: Implementation approaches available

To get started, consider the following example implementations:

- [{Example 1 name}](../../{path}/{article}.yml) - [Brief description of what makes this example useful]

- [{Example 2 name}](../../{path}/{article}.yml) - [Brief description of scenario]

- [{Example 3 name}](../../{path}/{article}.yml) - [Brief description of approach]

- [{Example 4 name}](../../{path}/{article}.yml) - [Brief description of use case]

- [{Example 5 name}](../../{path}/{article}.yml) - [Brief description of pattern]

---

## Best practices

[Opening sentence about importance of best practices for this category]

[APPROACH 1: General best practices list - Most common]

The [Microsoft Azure Well-Architected Framework](/azure/well-architected/) provides reference guidance and best practices. The framework comprises five pillars: Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency.

At the highest level, [information security](/azure/architecture/framework/security/overview) practices help ensure that your {category-specific resources} are protected. Trustworthy {category} solutions implement:

- [Governance policies](/azure/architecture/framework/security/design-governance) - [Brief category-specific guidance]

- [Identity and access management](/azure/architecture/framework/security/design-identity) - [Brief category-specific guidance]

- [Network security controls](/azure/architecture/framework/security/design-network) - [Brief category-specific guidance]

- [Data protection](/azure/architecture/framework/security/design-storage) - [Brief category-specific guidance]

At the platform level, the following best practices contribute to {category benefits} on Azure:

- **{Best practice 1}** - [Explanation with actionable guidance]

- **{Best practice 2}** - [Explanation with actionable guidance]

- **{Best practice 3}** - [Explanation with actionable guidance]

- **{Best practice 4}** - [Explanation with actionable guidance]

- **{Best practice 5}** - [Explanation with actionable guidance]

[APPROACH 2: Organized by topic/pillar - For DevOps, Management & Governance]

### {Topic 1 - e.g., Security}

- [{Best practice document 1}](/azure/{path})
- [{Best practice document 2}](/azure/{path})
- [{Best practice document 3}](/azure/{path})

### {Topic 2 - e.g., Cost Optimization}

- [{Best practice document 1}](/azure/{path})
- [{Best practice document 2}](/azure/{path})

### {Topic 3 - e.g., Operations}

- [{Best practice document 1}](/azure/{path})
- [{Best practice document 2}](/azure/{path})

[APPROACH 3: Service-specific - For Storage, Virtual Desktop, Mgmt & Governance]

Depending on the {category} technology you use, see the following best practices resources:

### {Service 1 name}

See the following guides for information about {Service 1}:

- [{Guide 1}](/azure/{path})
- [{Guide 2}](/azure/{path})
- [{Guide 3}](/azure/{path})

### {Service 2 name}

See the following guides for information about {Service 2}:

- [{Guide 1}](/azure/{path})
- [{Guide 2}](/azure/{path})

---

## OPTIONAL: Operations guide
<!-- Use for complex infrastructure with Day-2 operations: Containers, Compute, Networking -->

Getting your workload deployed on Azure is a great milestone, and this is when [day-2 operations](https://dzone.com/articles/defining-day-2-operations) become critical. **The {category} day-2 operations guide** helps ensure you're ready to meet operational demands.

> [!div class="nextstepaction"]
> [{Category} day-2 operations guide](../../operator-guides/{path}.md)

Key operational areas:

- [Monitoring and observability](../../operator-guides/{path}.md)
- [Backup and recovery procedures](../../operator-guides/{path}.md)
- [Patch and upgrade strategies](../../operator-guides/{path}.md)
- [Troubleshooting guide](../../operator-guides/{path}.md)
- [Performance optimization](../../operator-guides/{path}.md)

---

## Stay current with {Category}

[Platform/Service] is evolving rapidly. Stay informed about the latest updates and planned features:

Get the latest updates on [Azure {category} [products and features|services|technologies]](https://azure.microsoft.com/updates/?category={category-slug}).

[OPTIONAL - For categories with public roadmap:]

The platform roadmap helps you understand planned features and deprecations:

> [!div class="nextstepaction"]
> [{Category} product roadmap](https://aka.ms/{product}/roadmap)

[OPTIONAL - For specific products with detailed release notes:]

Stay current with {Product} by monitoring these resources:

- [{Product} Feature Timeline](/azure/{service}/release-notes/features-timeline)
- [{Product} documentation - What's new?](/azure/{service}/release-notes/docswhatsnew)
- [{Product} Release Notes](/azure/{service}/release-notes)

---

## Additional resources

{Category} is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### OPTIONAL: Hybrid [and multi-cloud]
<!-- Include if category commonly used in hybrid deployments -->

The vast majority of organizations need a hybrid approach to {category} because [explain why - e.g., "their data is hosted both on-premises and in the cloud"]. Organizations often [extend on-premises {category} solutions to the cloud](../../databases/guide/hybrid-on-premises-and-cloud.md). To connect environments, organizations must [choose a hybrid network architecture](../../reference-architectures/hybrid-networking/index.yml).

Key hybrid {category} scenarios:

- **{Scenario 1}**: [{Link text}](/azure/{path}) - [Brief description]
- **{Scenario 2}**: [{Link text}](/azure/{path}) - [Brief description]
- **{Scenario 3}**: [{Link text}](/azure/{path}) - [Brief description]

### OPTIONAL: {Specialized topic 1}
<!-- E.g., "Real-time processing", "Advanced analytics", "Industry solutions" -->

[Brief introduction paragraph explaining this specialized area]

- [{Solution 1}](../../{path}/{article}.yml) - [Brief description]
- [{Solution 2}](../../{path}/{article}.yml) - [Brief description]
- [{Solution 3}](../../{path}/{article}.yml) - [Brief description]

### OPTIONAL: {Specialized topic 2}
<!-- E.g., "Data governance", "Security compliance", "Multi-region" -->

[Brief introduction paragraph]

- [{Solution 1}](../../{path}/{article}.yml) - [Brief description]
- [{Solution 2}](../../{path}/{article}.yml) - [Brief description]

### Example solutions

Here are [a few|some additional] sample implementations of {category} on Azure to consider:

- [{Solution 1 name}](../../{path}/{article}.yml) - [Brief description of scenario and value]

- [{Solution 2 name}](../../{path}/{article}.yml) - [Brief description of approach]

- [{Solution 3 name}](../../{path}/{article}.yml) - [Brief description of use case]

- [{Solution 4 name}](../../{path}/{article}.yml) - [Brief description of pattern]

- [Browse more {category} examples in the Azure Architecture Center](../../browse/index.yml?azure_categories={category-filter})

### OPTIONAL: Industry-specific solutions
<!-- Include if 5+ notable industry implementations exist -->

{Category} implementations vary by industry. Explore these industry-specific architectures:

- **{Industry 1}**: [{Solution name}](../../{path}/{article}.yml) - [Brief description]
- **{Industry 2}**: [{Solution name}](../../{path}/{article}.yml) - [Brief description]
- **{Industry 3}**: [{Solution name}](../../{path}/{article}.yml) - [Brief description]

---

## AWS or Google Cloud professionals
<!-- Include if comparison documentation exists -->

These articles can help you ramp up quickly by comparing Azure {category} options to other cloud services:

- [{Comparison topic}](../../aws-professional/{article}.md) in [Database technologies on Azure and AWS](../../aws-professional/databases.md)

- [{Comparison topic}](../../gcp-professional/services.md#{anchor}) in [Google Cloud to Azure services comparison](../../gcp-professional/services.md)

[OPTIONAL - Service-specific comparisons:]

### Service comparison

- [Service comparison: {Service type}](../../aws-professional/{article}.md)
- [Service comparison: {Service type}](../../gcp-professional/services.md)

[OPTIONAL - Migration guidance:]

### Migration guidance

If you're migrating from another cloud platform:

- [Migrate {source} to {Azure service}](/azure/{service}/migration-guides/{source})
- [Migrate {source} to {Azure service}](/azure/{service}/migration-guides/{source})

---

## Contributors

<!-- This section is expected but optional if the contributors prefer to omit it. -->

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

<!-- List the primary authors alphabetically by last name. Use the *FirstName LastName* format. -->

- [Author 1 Name](https://www.linkedin.com/in/ProfileURL/) | Cloud Solution Architect
- [Author 2 Name](https://www.linkedin.com/in/ProfileURL/) | Principal Cloud Architect

Other contributors:

<!-- This section is optional. List contributors and technical reviewers. -->

- [Contributor 1 Name](https://www.linkedin.com/in/ProfileURL/) | Senior Content Developer
- [Contributor 2 Name](https://www.linkedin.com/in/ProfileURL/) | Technical Reviewer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

---

## Next steps

<!-- Add a bulleted list of links to third-party or Microsoft topics.
Link formats: 
  - Make Learn links site relative (for example, /azure/<feature>/<article-name>).
  - Start third-party links with `https://` and omit `en-us` unless the links don't work without it.
  - Omit a trailing slash, unless that is how the final URL renders after redirects.
-->

[OPTIONAL - Use sparingly - only when there's a clear immediate action]

Ready to get started? Here are some recommended next steps:

- Complete a [Microsoft Learn module](/training/modules/{module-id}) to build foundational knowledge
- Deploy your first [{resource}](/azure/{service}/{article-name})
- Explore [{resource type}](/azure/{service}/{article-name})
- Join the [{Community name}](https://techcommunity.microsoft.com/{path}) to connect with experts

---

## Related resources

<!-- Add a bulleted list of links to related architecture information in the AAC TOC. -->

- [{Related architecture 1}](../../{path}/{article}.yml)
- [{Related architecture 2}](../../{path}/{article}.yml)
- [{Product 1} documentation](/azure/{service})
- [{Product 2} documentation](/azure/{service})
- [Browse more {category} architectures](../../browse/index.yml?azure_categories={category-filter})
```

---

## Implementation Checklist

### Planning Phase
- [ ] Review existing "Get started" page (if any) for the category
- [ ] Determine category complexity (Simple, Comprehensive, Complex Infrastructure, Multi-Service)
- [ ] Choose template type (A, B, C, or D)
- [ ] Identify which REQUIRED sections to include
- [ ] Identify which OPTIONAL sections make sense for this category
- [ ] Gather Microsoft Learn training paths (minimum 3-4)
- [ ] Identify 5-7 example implementations
- [ ] Check for AWS/GCP comparison documentation
- [ ] Identify if Operations guide is needed (Day-2 operations)

### Content Creation
- [ ] Create YAML file with proper metadata
- [ ] Create content markdown file following chosen template
- [ ] Write introduction with clear business value proposition
- [ ] Add Microsoft Learn links (verified working)
- [ ] Write Organizational readiness section (CAF + WAF guidance)
- [ ] Write Implementation checklist OR Path to production section
- [ ] Write Best practices section (5-7 practices minimum)
- [ ] Add Operations guide section (if applicable)
- [ ] Write Stay current section with update links
- [ ] Write Additional resources section with subsections
- [ ] Add AWS/GCP comparison (if documentation exists)
- [ ] Add Contributors section (optional)
- [ ] Add Next steps section (optional)
- [ ] Add Related resources section

### Visual Assets
- [ ] Create architecture diagram (SVG format recommended)
- [ ] Create thumbnail image (PNG format)
- [ ] Create Visio source file (VSDX format)
- [ ] Upload Visio to arch-center.azureedge.net
- [ ] Update all diagram references in content
- [ ] Test diagram rendering in preview

### Integration
- [ ] Update TOC with "Get started" entry
- [ ] Verify all internal links work (use relative paths)
- [ ] Verify all external links work (especially Microsoft Learn)
- [ ] Verify all product documentation links work
- [ ] Test all image links

### Quality Assurance
- [ ] Review for tone and consistency with other "Get started" pages
- [ ] Verify section names match standardized template
- [ ] Check that all REQUIRED sections are present
- [ ] Verify minimum link counts (15-20 total across all sections)
- [ ] Spell check and grammar review
- [ ] Validate markdown formatting
- [ ] Check code block formatting
- [ ] Test in preview environment
- [ ] Peer review

---

## Category Status and Implementation Plan

Based on the TOC analysis:

### Existing Pages Needing Updates

| Category | Current File | Required Updates | Priority |
|----------|--------------|------------------|----------|
| **Analytics** | analytics-start-here.yml | Add "Stay current" | Medium |
| **Compute** | high-performance-computing.md | Standardize names, add "Organizational readiness" + "Stay current" | High |
| **Containers** | aks-start-here.md | Standardize names, add "Organizational readiness" + "Stay current" | High |
| **DevOps** | devops-start-here.md | Add "Organizational readiness" | Medium |
| **Hybrid** | hybrid-start-here.md | Add "Organizational readiness" + "Stay current" | Medium |
| **Identity** | identity-start-here.yml | Add "Organizational readiness" + "Stay current" | Medium |
| **Integration** | integration-start-here.yml | Add "Organizational readiness" + "Stay current" | Medium |
| **Mgmt & Governance** | management-governance-start-here.md | Add "Organizational readiness" | Low |
| **Migration** | migration-start-here.md | Add "Organizational readiness" | Low |
| **Security** | security-start-here.yml | Add "Organizational readiness" + "Stay current" | Medium |
| **Storage** | storage-start-here.md | Add "Organizational readiness" | Low |
| **Virtual Desktop** | start-here.md | Add "Organizational readiness" | Low |

### New Pages Needed

| Category | Current State | Template Type | Priority |
|----------|--------------|---------------|----------|
| **AI + Machine Learning** | Links to index | Type B (Comprehensive) | High |
| **Databases** | Links to index | Type D (Multi-Service) | High |
| **IoT** | No page | Type B (Comprehensive) | Medium |
| **Networking** | Links to index | Type C (Complex Infrastructure) | High |
| **Web Apps** | Links to index | Type B (Comprehensive) | Medium |

---

## Content Guidelines

### Tone and Style
- **Professional** but **accessible** - avoid jargon without explanation
- **Solution-focused** - emphasize outcomes and business value
- **Aspirational** but **realistic** - acknowledge challenges while showing paths forward
- **Concise** - respect reader's time while providing comprehensive guidance

### Length Targets
- **Simple template (A)**: 800-1,200 words
- **Comprehensive template (B)**: 1,500-2,500 words
- **Complex infrastructure (C)**: 2,000-3,000 words
- **Multi-service template (D)**: 1,500-2,500 words

### Link Requirements
- **Minimum**: 15-20 total links across all sections
- **Microsoft Learn**: 3-4 training paths/modules
- **Example implementations**: 5-7 architecture links
- **Best practices**: 5-7 guidance documents
- **Product documentation**: 3-5 key docs

### Visual Standards
- **Diagram**: SVG preferred, PNG acceptable
- **Diagram size**: Maximum 1200px width
- **Thumbnail**: 200x150px PNG
- **Alt text**: Descriptive, 50-150 characters
- **Visio**: Upload to arch-center.azureedge.net

---

## What NOT to Do

### Content
- ❌ Don't mix section names across pages
- ❌ Don't skip "Organizational readiness" - it's now REQUIRED
- ❌ Don't skip "Stay current" - it's now REQUIRED
- ❌ Don't create walls of text without formatting
- ❌ Don't forget AWS/GCP comparison if docs exist
- ❌ Don't use generic link text like "Click here"
- ❌ Don't make claims without linking to evidence
- ❌ Don't create overly complex navigation hierarchies

### Formatting
- ❌ Don't use different heading levels inconsistently
- ❌ Don't forget to use relative paths for internal links
- ❌ Don't use absolute URLs for Microsoft Learn links
- ❌ Don't leave trailing slashes in URLs
- ❌ Don't use "en-us" in URLs unless required

### Structure
- ❌ Don't reorder REQUIRED sections
- ❌ Don't combine REQUIRED sections
- ❌ Don't split REQUIRED sections into multiple sections
- ❌ Don't nest sections more than 3 levels deep

---

## What TO Do

### Content
- ✅ Use consistent section naming across all pages
- ✅ Include all 8 REQUIRED sections
- ✅ Add descriptive text explaining what each link provides
- ✅ Use role-based guidance where applicable
- ✅ Provide clear decision criteria
- ✅ Link to authoritative sources (Microsoft Learn, CAF, WAF)
- ✅ Include visual elements (diagrams, videos where appropriate)
- ✅ Use concrete examples over abstractions

### Formatting
- ✅ Use proper markdown hierarchy (H2, H3, H4)
- ✅ Use bullet points for scanability
- ✅ Use tables for comparisons
- ✅ Use callout boxes for important notes
- ✅ Use consistent formatting across similar elements
- ✅ Use code blocks for commands/code snippets

### Structure
- ✅ Follow template structure consistently
- ✅ Group related content logically
- ✅ Provide clear section transitions
- ✅ Use subsections to organize complex topics
- ✅ Place most important content first

---

## Maintenance and Updates

### Review Schedule
- **Quarterly**: Verify all links still work
- **Quarterly**: Check for new Microsoft Learn content
- **Bi-annually**: Review for technical accuracy
- **Annually**: Full content refresh

### When to Update
- New example implementations published
- Significant product updates or new features
- CAF or WAF guidance changes
- AWS/GCP comparison docs updated
- Broken links discovered
- User feedback indicates confusion

### Update Process
1. Review current content against latest template
2. Identify missing or outdated sections
3. Update links and content
4. Update `ms.date` in YAML metadata
5. Verify all links work
6. Submit for peer review

---

## Success Metrics

### Quantitative
- All REQUIRED sections present (100% target)
- Minimum link count met (15-20 links)
- Page length within target range
- Zero broken links
- All images rendering correctly

### Qualitative
- Consistent section naming with other pages
- Clear value proposition in introduction
- Actionable best practices
- Comprehensive resource coverage
- Helpful for users at all experience levels

---

## FAQ

### Q: Should I use "Implementation checklist" or "Path to production"?
**A**: Use "Implementation checklist" for complex infrastructure categories (Compute, Containers, Networking) where users need to review multiple technical decisions before implementation. Use "Path to production" for other categories where users primarily need example implementations to learn from.

### Q: When should I include an "Operations guide" section?
**A**: Include when the category requires significant ongoing management, monitoring, troubleshooting, or maintenance (Day-2 operations). Currently used for Containers (AKS). Consider for Compute, Networking, and possibly Databases.

### Q: How do I organize best practices - general list, by topic, or by service?
**A**: 
- **General list**: Most categories (default choice)
- **By topic**: Development practices (DevOps, Security)
- **By service**: Multi-service categories (Storage, Virtual Desktop, Mgmt & Governance)

### Q: Should I include a Contributors section?
**A**: Optional but recommended for transparency and attribution. Always include if multiple people significantly contributed to the content.

### Q: How many example implementations should I include?
**A**: Minimum 5, maximum 7 in the "Path to production" section. Additional examples can go in "Additional resources".

### Q: What if AWS/GCP comparison docs don't exist for my category?
**A**: Omit the "AWS or Google Cloud professionals" section entirely. Don't create placeholder text.

### Q: How detailed should the architecture diagram be?
**A**: Show the high-level journey/decision flow, not detailed technical architecture. Focus on helping users understand the path from learning to production.

---

## Contact and Support

For questions about this template:
- Review existing "Get started" pages for examples
- Check the Architecture Center contribution guide
- Consult with the content team
- Reference the template summary document

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 01/16/2026 | Complete rebuild based on 12-page analysis; added standardized sections |
| 1.0 | (prior) | Initial template based on Analytics page only |
