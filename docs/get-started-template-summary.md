# Get Started Template - Executive Summary

## Purpose
This document provides a standardized template for creating "Get Started" pages across all Azure Architecture Center categories, based on comprehensive analysis of 12 existing "Get Started" pages.

## Key Findings from Analysis

### Current State
- **12 categories analyzed**: Analytics, Compute, Containers (AKS), DevOps, Hybrid, Identity, Integration, Management & Governance, Migration, Security, Storage, Virtual Desktop
- **Inconsistent structure**: Section names vary significantly (e.g., "Path to production" vs "Implementation checklist")
- **Missing sections**: Most pages lack "Organizational readiness" and "Stay current"
- **Varied depth**: Ranges from simple (Identity, Hybrid) to comprehensive (DevOps, Analytics) to highly specialized (Compute HPC, AKS)

### Major Differences Identified

#### 1. **"Path to Production" vs "Implementation Checklist"**
- **Path to production** (11 pages): List format with example implementations
- **Implementation checklist** (1 page - Compute): Checkbox format with topics to review before implementing
- **Recommendation**: Support BOTH - use checklist for complex infrastructure, path to production for others

#### 2. **"Best Practices" Section Organization**
Three different approaches found:
- **General list**: 5-7 actionable practices (most common)
- **Topic-organized**: Grouped by pillar/category
- **Service-specific**: Separate subsections per service (Storage, Virtual Desktop)
- **Recommendation**: Allow all three, choose based on category complexity

#### 3. **Operations Guide** 
- **Only in**: Containers (AKS) - comprehensive Day-2 operations guide
- **Missing from**: All other categories
- **Recommendation**: ADD to categories with complex ongoing operations (Compute, Networking when created)

#### 4. **Stay Current**
- **Present in**: 6 of 12 categories
- **Missing from**: Analytics, Compute, Hybrid, Identity, Integration, Security
- **Recommendation**: REQUIRED for all categories going forward

#### 5. **Organizational Readiness (CAF + WAF)**
- **Only in**: Analytics (well-developed)
- **Partial in**: Some mention CAF or WAF separately
- **Missing from**: Most categories
- **Recommendation**: REQUIRED section for all categories going forward

## Proposed Standardized Structure

### REQUIRED Sections (All categories MUST have)
1. **Introduction to {Category} on Azure** - Overview + business value
2. **Learn about {Category} on Azure** - Microsoft Learn training links
3. **Organizational readiness** - Cloud Adoption Framework + Well-Architected Framework guidance
4. **Path to production** OR **Implementation checklist** - Getting started guidance
5. **Best practices** - Quality and operational guidance
6. **Stay current with {Category}** - Update links and roadmap
7. **Additional resources** - Extended content
8. **AWS or Google Cloud professionals** - Cloud comparison (where applicable)

### OPTIONAL Sections (Use when appropriate)
- **Service list** in introduction (for categories with multiple distinct services)
- **Architecture diagram** (recommended for all but not required)
- **Learning paths by role** (for complex categories)
- **Implementation checklist** (for infrastructure-heavy categories, used WITH or INSTEAD OF Path to production)
- **Operations guide** (for categories with significant Day-2 operations)
- **Service-specific subsections** (for multi-service categories like Storage)
- **Hybrid scenarios** (if commonly used in hybrid deployments)
- **Industry-specific solutions** (if notable implementations exist)

## Decision Framework

### Which Template Type to Use?

| Category Type | Use Implementation Checklist | Use Operations Guide | Example |
|--------------|------------------------------|---------------------|---------|
| **Complex infrastructure** | ✓ Yes (with Path to production) | ✓ Yes | Compute, Containers, Networking |
| **Platform services** | ✗ No (Path to production only) | Maybe | Analytics, Databases, AI/ML |
| **Development practices** | ✗ No (Path to production only) | ✗ No | DevOps, Security |
| **Cross-cutting concerns** | ✗ No (Path to production only) | ✗ No | Hybrid, Identity, Integration |
| **Multiple services** | Maybe | Maybe | Storage, Mgmt & Governance, Virtual Desktop |

## Section Name Standardization

### Before (Inconsistent)
- "Learn about...", "Introduction to...", "Learn more" - ALL DIFFERENT
- "Path to production", "Implementation checklist" - DIFFERENT
- "Stay current" - MISSING from most
- "Organizational readiness" - ONLY in Analytics

### After (Standardized)
- ✅ **"Learn about {Category} on Azure"** - Consistent across all
- ✅ **"Organizational readiness"** - Now REQUIRED for all
- ✅ **"Path to production"** OR **"Implementation checklist"** - Both supported, clear guidance on when to use
- ✅ **"Best practices"** - Consistent naming, flexible organization
- ✅ **"Stay current with {Category}"** - Now REQUIRED for all
- ✅ **"AWS or Google Cloud professionals"** - Consistent naming when present

## Impact Analysis

### Pages That Need Major Updates
1. **Analytics** - Add "Stay current"
2. **Compute** - Standardize section names, add "Organizational readiness" and "Stay current"
3. **Containers (AKS)** - Standardize section names, add "Organizational readiness" and "Stay current"
4. **DevOps** - Add "Organizational readiness"
5. **Hybrid** - Add "Organizational readiness" and "Stay current"
6. **Identity** - Add "Organizational readiness" and "Stay current"
7. **Integration** - Add "Organizational readiness" and "Stay current"
8. **Management & Governance** - Add "Organizational readiness" (already has some CAF/WAF)
9. **Migration** - Add "Organizational readiness"
10. **Security** - Add "Organizational readiness" and "Stay current"
11. **Storage** - Add "Organizational readiness"
12. **Virtual Desktop** - Add "Organizational readiness"

### Pages That Need to Be Created
1. **AI + Machine Learning** - Currently links to index
2. **Databases** - Currently links to index
3. **IoT** - No Get started page
4. **Networking** - Currently links to index
5. **Web Apps** - Currently links to index

## Next Steps

### Phase 1: Template Approval
- [ ] Review comparative analysis with stakeholders
- [ ] Approve standardized section names
- [ ] Decide on "Path to production" vs "Implementation checklist" approach
- [ ] Finalize REQUIRED vs OPTIONAL sections

### Phase 2: Update Existing Pages
- [ ] Prioritize pages by traffic/importance
- [ ] Add missing REQUIRED sections to all existing pages
- [ ] Standardize section names across all pages
- [ ] Update content to match quality standards

### Phase 3: Create New Pages
- [ ] Create AI + Machine Learning Get started page
- [ ] Create Databases Get started page
- [ ] Create IoT Get started page
- [ ] Create Networking Get started page
- [ ] Create Web Apps Get started page

### Phase 4: Maintenance
- [ ] Establish quarterly review process
- [ ] Create page ownership model
- [ ] Set up automated link checking
- [ ] Monitor analytics and user feedback

## Benefits of Standardization

1. **User Experience**: Consistent navigation and structure reduces cognitive load
2. **Discoverability**: Standard sections make content easier to find
3. **Completeness**: REQUIRED sections ensure no critical information is missing
4. **Scalability**: Clear template makes creating new pages faster
5. **Maintainability**: Consistent structure simplifies updates
6. **Quality**: Built-in checklist ensures minimum quality standards

## Questions for Review

### Critical Decisions Needed

1. **Implementation Checklist Approach**
   - ❓ Should we add "Implementation checklist" to ALL infrastructure-heavy categories?
   - ❓ Or keep "Implementation checklist" only for the most complex (Compute, Containers)?

2. **Best Practices Organization**
   - ❓ Allow all three approaches (general list, topic-organized, service-specific)?
   - ❓ Or standardize on one approach for consistency?

3. **Operations Guide**
   - ❓ Add "Operations guide" to Compute, Networking, and other infrastructure categories?
   - ❓ What threshold determines if a category needs an Operations guide?

4. **Rollout Strategy**
   - ❓ Update all existing pages at once or phase over time?
   - ❓ Create new pages first or update existing pages first?

### Items Marked for Your Review in Template

The template includes several sections marked with variations:
- **"Implementation checklist" vs "Path to production"** - Which to use when
- **Best practices organization** - Three different approaches shown
- **Optional sections** - Guidance on when to include

Please review [get-started-template.md](get-started-template.md) for complete details.
