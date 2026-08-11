---
---

## Posting a body to a safe-output tool

When you call a `safeoutputs` tool that takes a `body` (for example, `add_comment` or `update_pull_request`), the posted body must contain your full, intended text with its Markdown and line breaks intact. Treat that as the requirement; choose whatever invocation reliably achieves it.

Watch for these failure modes, which post a corrupted body while still reporting success:

- Passing the body as a raw command-line flag value. Multi-line and Markdown text are unreliable this way; the shell can truncate or mangle them. In particular, the CLI doesn't treat `--body -` as "read from stdin" — it posts a body that is the literal character `-`, which renders as an empty bullet.
- Any path that loses newlines, unescapes characters, or drops content.

A reliable technique is to pass the body as JSON on stdin so it's escaped correctly, for example `jq -n --arg body "$COMMENT_BODY" --argjson n 12345 '{item_number:$n, body:$body}' | safeoutputs add_comment .`. Use it or any equivalent approach that preserves the body faithfully.
