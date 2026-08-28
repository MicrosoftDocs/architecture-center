---
safe-outputs:
  mentions:
    allowed-collaborators: true
    allow-context: true
    max: 7
    allowed:
      - AnnaMHuff
      - ckittel
      - claytonsiemens77
      - Court72
      - denrea
      - glynnniall
      - JamesJBarnett
      - jmart1428
      - johndowns
      - karenf-Learn
      - PlagueHO
      - ShannonLeavitt
      - Stacyrch140
      - v-albemi
      - v-regandowner
      - v-thepet
---

<!--
Single source of truth for the author @mention allow list. Import it with
`imports: [shared/author-mentions.md]` in any workflow that tags article authors.

Because `safe-outputs.mentions` is merged whole-block (main overrides import, set-if-nil),
a consuming workflow must NOT declare its own `mentions:` block, or this import is ignored.

Maintenance: add or remove GitHub usernames (the `author` value from articles) below,
then run `gh aw compile` to refresh every consuming workflow's lock file. A username only
produces a notifying mention if that account can see the repository.
-->
