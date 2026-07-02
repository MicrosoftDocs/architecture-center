# Detecting deprecations live

While grounding on a fetched Microsoft Learn page, scan for signals that the feature it documents is being retired, deprecated, or superseded. Treat any of these as a hard signal that the feature should not be recommended.

## Signals

- A retirement banner or callout at the top of the page or section: "This feature is being retired," "Support for X ends on `<date>`," "X is in maintenance mode," "X is being deprecated."

- Phrases such as "we recommend migrating to," "use Y instead," "Y is the recommended replacement for X," "no longer recommended," "superseded by Y," "legacy `<feature>`."

- A "What's new" or "Retirement notices" entry under the service's documentation referencing the feature.

- The page existing as a "migration guide from X to Y" and your topic is "X."

## What to do when you detect a deprecation concern

1. Evaluate if the concern is applicable to your scenario.

2. If so, stop using the page as grounding for that recommendation.

3. Search and fetch the replacement's Learn page. The notice typically names the replacement; if not, search `<service> <feature-area> replacement` or `migrate from <X> to <Y>`.

4. Evaluate if you should use the replacement's page as the grounding source going forward.

5. Surface the deprecation to the user.

## Partial-page deprecations

If a page documents multiple features side by side and the retirement banner covers only one of them, exclude only that feature, not the page.

## Never invent deprecations

Every claim that something is deprecated must be backed by a Learn page fetched during this work. If grounding does not surface a retirement signal, treat the feature as current. Do not infer deprecation from training knowledge or blog posts.
