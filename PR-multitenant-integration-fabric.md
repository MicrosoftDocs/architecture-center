# Draft PR: Multitenant integration delegated access Fabric wording update

## Summary

Adds Microsoft Fabric wording to the multitenant integration guidance where delegated access examples reference tenant analytics services. No structural, metadata, or code changes.

## Changes

- Updated delegated user access example: replaced the service list to include Microsoft Fabric workspaces (analytics) alongside Azure Storage and Azure Cosmos DB.
- Added Microsoft Fabric link: `/fabric/fundamentals/microsoft-fabric-overview`.
- Kept all other service references and patterns unchanged.
- No modifications to headings, front matter, or existing patterns sections.

## Rationale

Aligns delegated access guidance with current analytics workspace usage while preserving original context and patterns (delegation, identity, and access considerations).

## Verification

- Searched file for prior analytics service name (none remain in example after update).
- Link path uses relative Learn format.
- Existing external service reference link warnings are pre-existing (expected cross-site references).

## Impact / Risk

Low. Single-line text edit; no changes to architecture logic, examples, or patterns. Existing external reference links remain intact.

## Follow-up (Optional / Not in this PR)

- Broader analytics integration examples could mention workspace governance or data isolation in Fabric if future revisions expand scope.

## Checklist

- [x] Fabric reference added
- [x] Relative link format
- [x] Neutral wording
- [x] No metadata changes
- [x] Single focused edit

## Optional Next PR Body Snippet

> Potential enhancement: Add a short note on handling per-tenant Fabric workspace RBAC when using delegated access in complex analytics scenarios.
