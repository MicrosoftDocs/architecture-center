# Copilot instructions for the Azure Architecture Center on Microsoft Learn

This repository contains the source data for the Azure Architecture Center articles published as official Microsoft documentation on Microsoft Learn. The data is stored mostly as Markdown files with some YAML files supporting the Markdown. These Markdown and YAML files get converted to HTML for presentation on Microsoft Learn. This repo contains some configuration files, mostly JSON, that support that transformation.

## Audience and how they use this data

The data in the repo helps professional cloud architects and software engineers design good cloud infrastructure for workloads and workload features. These readers learn the fundamentals of cloud architecture, such as cloud design patterns and cloud application design. They also use the decision trees to help them make Azure technology selection. Lastly, the users study example and reference architectures related to scenarios that are applicable to them. With this data, they compose design patterns, cloud fundamentals, and Azure technology to design a solution that fulfills the functional and non functional requirements of their workload.

## Repository facts

- This data gets published at <https://learn.microsoft.com/azure/architecture>.
- This is not a repository for software development.
- The Markdown files are to be treated as data and this repository effectively as a database.
- The data in this repository is grounded in Microsoft Azure technology.
- The data in this repository is grounded in the Azure Well-Architected Framework's pillars: Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency.
- The data in this repository is grounded in the Cloud Adoption Framework for Azure.
- This data must always lead to success of the person reading this.
- This data does not lead to bad or risky decisions without warning the reader about them.
- This data helps an architect avoid regret in their solution design.
- This data focuses on the "regular way" of solving business and architectural problems.
- This data avoids risky decisions without proper warnings.
- This data is novel, not replicating content already addressed elsewhere in the Azure Architecture Center or on other Microsoft Learn sites.
- This data is truthful, even while being opinionated.

## Repository structure

- This is the **private repository** (`-pr` suffix) for internal Microsoft authoring.
- A corresponding **public repository** exists at <https://github.com/MicrosoftDocs/architecture-center>.
- The `main` branch is for development; the `live` branch reflects published content.

## Your behavior

- If I tell you that you are wrong, think about whether or not you think that's true and respond with facts.
- Avoid apologizing or making conciliatory statements.
- It is not necessary to agree with the user with statements such as "You're right" or "Yes."
- Avoid hyperbole and excitement, stick to the task at hand and complete it pragmatically.
- Never use content that would violate copyrights.
- When you use facts from existing content on Microsoft Learn, especially the Well-Architected Framework and the Cloud Adoption Framework, you'll link to those sources.
- You'll never invent Azure products or services.
- You'll never invent Microsoft products or services.
- You'll ensure that any recommended components are used maximizing their compliance to the [Well-Architected service guide](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/) for that service.

## How you'll write

If you're asked to create data that goes into the Markdown files in this repo. Use the following writing style constraints.

- Use clear language.
- Prefer simple sentences over those with dependent clauses.
- Be descriptive, not emotional.
- Avoid the passive voice. Use "you" as the subject where necessary.
- Avoid generalizations, marketing terms, or weasel words. Words you should generally avoid: seamless, seamlessly, fast, quick, quickly, easy, effortless, effortlessly, simple, simply, world-class, cutting-edge, cheap. You don't know the constraints of the reader or their situation, so you shouldn't make general statements like these. Instead present the facts/metrics/limits in a way that will help an architect make an informed decision.

## Folder and file structure

### Directory organization reality

- The root folder for articles is `docs/`.
- **The directory structure maps directly to published URLs** - moving files breaks links, so the structure is effectively immutable.
- The directory structure is **organically grown and inconsistent** - it attempts multiple organizational pivots (content type, technology, audience) but doesn't apply them consistently.
- Don't create new folders or move files without understanding the URL impact and redirect requirements.
- **The directory structure does NOT determine how content is navigated** - see "Table of Contents system" below.

### Three file patterns for articles

Articles use one of three patterns:

**Pattern 1: YAML + Markdown pair** (most common for structured content)

- `article-name.yml` - Contains ALL metadata
- `article-name-content.md` - Contains ONLY content body (no frontmatter)
- The YAML file uses `[!INCLUDE[](article-name-content.md)]` to pull in content at build time
- It should be used for: solution ideas, example workloads, and reference architectures only.

**Pattern 2: Pure Markdown with frontmatter** (traditional)

- `article-name.md` - Contains frontmatter metadata + content in one file
- Metadata is between `---` delimiters at the top
- Used for: guides, best practices, some patterns

**Pattern 3: Pure YAML** (navigation and landing pages)

- `article-name.yml` - Self-contained YAML, often with inline Markdown
- Used for: `toc.yml` files, `index.yml` landing pages

**Important:** The same folder can mix all three patterns. Always check which pattern an article uses before editing.

### Metadata location

- Pattern 1: Edit metadata in `.yml` file, content in `-content.md` file
- Pattern 2: Edit metadata (frontmatter) and content in same `.md` file
- Pattern 3: Everything in `.yml` file
- **Never update metadata unless requested**

## Table of Contents (TOC) system

**CRITICAL:** The TOC system defines how users navigate content, and it's completely decoupled from the directory structure.

### TOC hierarchy

The repository has **7 TOC files**:

- `docs/toc.yml` - Main navigation for the entire site
- `docs/ai-ml/toc.yml` - AI + Machine Learning workload navigation
- `docs/databases/toc.yml` - Databases workload navigation
- `docs/networking/toc.yml` - Networking workload navigation
- `docs/web-apps/toc.yml` - Web applications workload navigation
- `docs/guide/saas-multitenant-solution-architecture/toc.yml` - SaaS/Multitenancy guidance
- `docs/_bread/toc.yml` - Breadcrumb navigation metadata

### How TOCs work

- The **main TOC** references some workload sub-TOCs by pointing to their index pages (e.g., `href: ai-ml/index.md`)
- When users navigate to these sections, they switch to the **sub-TOC** for specialized navigation
- Sub-TOCs follow a consistent **"Explore → Design → Apply"** pattern across workloads
- TOCs can reference content from **anywhere in the repository** using relative paths (e.g., `../example-scenario/`)
- The same article can appear in multiple places in the TOC (or not appear at all)

### Navigation vs. URL disconnect

**Users experience both realities simultaneously:**

- **Navigation (TOC):** Logical, task-oriented structure (what users click through)
- **URLs (directories):** Physical file paths (what users see in the address bar)

Example: Users navigate "Containers > Guides > GitOps" but the URL shows `.../example-scenario/gitops-aks/...`

**When working with content:**

- Check **both main and sub-TOCs** to see where content appears in navigation
- Don't infer content organization from folder location - check the TOC
- Content can be in `guide/` folder but appear under a workload section in the TOC
- Metadata (`ms.topic`) determines content type, not folder or TOC placement

## Content types

The Azure Architecture Center contains various content types that address needs of the readers at different points in their decision making. You, as an agent, should always be aware of what content type you are working with, so that you can tailor your responses accordingly.

- **Architecture fundamentals**: Core concepts such as microservices, error handling, and [domain-driven design](docs/microservices/model/domain-analysis.md).
- **Decision trees**: Helps a reader narrow down available services to a one or a few options for them to further evaluate. For example, [Choose a Vector search solution](docs/guide/technology-choices/vector-search.md).
- **Cloud design patterns**: Reusable solutions to common constraints or common goals in cloud architecture. For example, the [Valet Key pattern](docs/patterns/valet-key-content.md).
- **Solution ideas**: Lightweight example of how Azure services could be combined to solve a specific business problem. Does not typically address Well-Architected Framework concerns. Designed to spark an exploration by the reader. These are not production ready. For example, the [Use AI to forecast customer orders](docs/ai-ml/idea/next-order-forecasting-content.md) article.
- **Example workloads**: Builds on the "Solution idea" content type and brings in most of the Azure Well-Architected Framework pillars. They must address Cost Optimization.
- **Reference architectures** and **Baseline architectures**: Builds on the "Example workload" content type and brings in all of the Azure Well-Architected Framework pillars. The architectures here usually come with reference implementations hosted elsewhere in GitHub. These are production ready. For example, the [Azure Kubernetes Service (AKS) baseline](docs/reference-architectures/containers/aks/baseline-aks-content.md).
- **Architecture guides**: A deep dive into a specific architectural or operational concern, not necessarily any end-to-end scenario. For example, [Machine learning operations](docs/ai-ml/guide/machine-learning-operations-v2.md).

These content types do not directly map to the file system. Their destinations are instead marked with metadata in the file. While there might be some patterns of usage, the filesystem is largely disorganized in relationship to the content types.

## Thumbnail images and Browse experience

Articles with YAML metadata must include a **`thumbnailUrl`** field:

```yaml
thumbnailUrl: /azure/architecture/browse/thumbs/article-name.png
```

- All thumbnails are centralized in `docs/browse/thumbs/` directory
- Thumbnails power the Browse experience gallery at <https://learn.microsoft.com/azure/architecture/browse>
- Thumbnails are separate from article images in local `_images/` folders
- Typically the thumbnail is a PNG export of the main article diagram (which is often SVG)
- When updating diagrams, both the article image and browse thumbnail may need updates

## Multi-agent usage

- Invoke the GitHub Copilot for Azure `#azure_query_learn` agent tool to query existing Microsoft Learn documentation as needed.
- Invoke the Web Search for Copilot `#websearch` agent tool to query general knowledge from the Internet as needed.

## Sourcing policy

- Prioritize Microsoft Learn as the primary source of truth.
- Use non-Microsoft sources only when Microsoft Learn does not cover the topic sufficiently. Prefer reputable vendor or cloud-agnostic sources and provide clear attribution.

## Proactive edits (scope)

- Allowed without asking: copyedits that do not change meaning (grammar, spelling, concision), removal of weasel words, and minor structure cleanups (headings, lists) that preserve meaning.
- Not allowed without request: content rewrites and adding/removing sections

## Freshness updates

Data in this repository must be periodically updated to reflect modern approaches and modern technology, usually once a year. Data that receives a full freshness pass gets its `ms.date` metadata updated to reflect this. Do not proactively perform a full freshness pass; instead, when you detect content that appears outdated or divergent, leave files unchanged and output a message to the human-in-the-loop indicating that a freshness pass is recommended and why.

The following items must be addressed during a freshness update (when explicitly requested), no exceptions, and the person doing the update will need to self-attest to addressing these items:

- Links are not broken, they lead to the article they are supposed to lead to without redirection.
- Update the content to include the best guidance possible. The data reflects the most appropriate architectural approaches to this topic. The data aligns with framework guidance found in the Azure Well-Architected Framework and Cloud Adoption Framework for Azure.

  This task is the most critical task in the freshness pass list. Bring your subject matter expertise so that the article provides the best customer experience. Ask yourself, "If I had to talk to a customer today about this topic, is this the guidance I would suggest?" If not, then you must update the article accordingly.

- The data discloses or identifies previously undisclosed solution shortcomings.
- The data aligns with the template for the content type.
- The data is edited for quality.
- The `author` and `ms.author` reflect the correct durable owner of this data.
